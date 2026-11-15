"""Signed Vikunja webhooks to a durable, encrypted Matrix outbox."""

import asyncio
import hashlib
import hmac
import json
import logging
import os
import re
from pathlib import Path
import sqlite3
import threading
import time
from http.server import BaseHTTPRequestHandler, HTTPServer


class MatrixFailure(RuntimeError):
    """An error containing only locally written context and a Matrix error code."""


def matrix_failure(operation, response):
    code = str(getattr(response, "status_code", ""))
    if not re.fullmatch(r"M_[A-Z0-9_]+|[0-9]{3}", code):
        code = type(response).__name__
    return MatrixFailure(f"{operation} ({code})")


def error_detail(error):
    return str(error) if isinstance(error, MatrixFailure) else type(error).__name__


async def join_room(client, room_id):
    from nio import Api, JoinResponse

    # nio 0.26's join() sends no body; Conduit requires a JSON object.
    # Keep nio's transport/authentication and response handling.
    method, path = Api.join(client.access_token, room_id)
    return await client._send(JoinResponse, method, path, "{}")


def message(payload):
    event = payload["event_name"]
    data = payload["data"]
    tasks = data.get("tasks", [data.get("task")])
    lines = ["Vikunja: " + event]
    for task in tasks:
        if isinstance(task, dict) and "id" in task:
            lines.append(f'{task.get("title", "Task")} — https://tasks.ltvnt.com/tasks/{task["id"]}')
    return "\n".join(lines)[:16000]


class Outbox:
    def __init__(self, path):
        self.path = path
        with self.connect() as db:
            db.execute("CREATE TABLE IF NOT EXISTS outbox (id TEXT PRIMARY KEY, body TEXT NOT NULL, sent INTEGER NOT NULL DEFAULT 0)")

    def connect(self):
        return sqlite3.connect(self.path, timeout=10)

    def enqueue(self, raw, body):
        with self.connect() as db:
            db.execute("INSERT OR IGNORE INTO outbox(id, body) VALUES (?, ?)",
                       (hashlib.sha256(raw).hexdigest(), body))


async def deliver(client, room_id, transaction, body):
    from nio import RoomSendResponse

    room = client.rooms.get(room_id)
    if client.olm is None or room is None or not room.encrypted:
        raise MatrixFailure("Destination must be a joined, encrypted room")
    response = await client.room_send(
        room_id, "m.room.message", {"msgtype": "m.text", "body": body},
        tx_id=transaction, ignore_unverified_devices=True,
    )
    if not isinstance(response, RoomSendResponse):
        raise matrix_failure("Matrix rejected the message", response)


async def matrix_worker(config, outbox, state):
    from nio import AsyncClient, AsyncClientConfig, JoinResponse, LoginResponse, SyncResponse

    client = AsyncClient(config["homeserver"], config["user_id"], store_path=str(state),
                         config=AsyncClientConfig(encryption_enabled=True, store_sync_tokens=True,
                                                  request_timeout=20, max_timeouts=2,
                                                  max_limit_exceeded=2))
    session_path = state / "session.json"
    try:
        if session_path.exists():
            session = json.loads(session_path.read_text())
            if session["user_id"] != config["user_id"]:
                raise MatrixFailure("Saved Matrix session belongs to another user")
            client.restore_login(session["user_id"], session["device_id"], session["access_token"])
        else:
            response = await client.login(config["password"], device_name="Vikunja notifications")
            if not isinstance(response, LoginResponse):
                raise matrix_failure("Matrix bot login failed", response)
            temporary = state / "session.json.tmp"
            temporary.write_text(json.dumps({"user_id": response.user_id,
                                             "device_id": response.device_id,
                                             "access_token": response.access_token}))
            temporary.replace(session_path)
        response = await join_room(client, config["room_id"])
        if not isinstance(response, JoinResponse):
            raise matrix_failure("Bot could not join the configured room; check the room ID and invitation", response)
        logging.info("Matrix bot joined the configured room")
        first_sync = True
        while True:
            try:
                response = await client.sync(timeout=1000, full_state=first_sync)
                if not isinstance(response, SyncResponse):
                    raise matrix_failure("Matrix sync failed", response)
                first_sync = False
                if client.should_upload_keys:
                    await client.keys_upload()
                if client.should_query_keys:
                    await client.keys_query()
                with outbox.connect() as db:
                    row = db.execute("SELECT id, body FROM outbox WHERE sent = 0 ORDER BY rowid LIMIT 1").fetchone()
                if row:
                    await deliver(client, config["room_id"], *row)
                    with outbox.connect() as db:
                        db.execute("UPDATE outbox SET sent = 1 WHERE id = ?", (row[0],))
                else:
                    await asyncio.sleep(5)
            except Exception as error:
                # Do not log request objects, tokens, or task contents.
                logging.error("Matrix delivery failed: %s; retrying in 30 seconds", error_detail(error))
                await asyncio.sleep(30)
    finally:
        await client.close()


def worker(config, outbox, state):
    while True:
        try:
            asyncio.run(matrix_worker(config, outbox, state))
        except Exception as error:
            logging.error("Matrix connection failed: %s; retrying in 30 seconds", error_detail(error))
        time.sleep(30)


def handler(config, outbox):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *_args):
            pass

        def do_POST(self):
            self.connection.settimeout(10)
            if self.path != "/vikunja-matrix":
                self.send_error(404)
                return
            try:
                length = int(self.headers.get("Content-Length", "0"))
                if not 0 < length <= 1048576:
                    self.send_error(413)
                    return
                raw = self.rfile.read(length)
                signature = hmac.new(config["webhook_secret"].encode(), raw, hashlib.sha256).hexdigest()
                if not hmac.compare_digest(signature, self.headers.get("X-Vikunja-Signature", "")):
                    self.send_error(403)
                    return
                body = message(json.loads(raw))
            except (ValueError, KeyError, TypeError, AttributeError):
                self.send_error(400)
                return
            try:
                outbox.enqueue(raw, body)
            except sqlite3.Error:
                self.send_error(503)
                return
            self.send_response(202)
            self.end_headers()
    return Handler


def main():
    logging.basicConfig(level=logging.INFO)
    credentials = Path(os.environ["CREDENTIALS_DIRECTORY"])
    config = {key: (credentials / key).read_text().rstrip("\n")
              for key in ("password", "room_id", "webhook_secret")}
    config.update(homeserver=os.environ["MATRIX_HOMESERVER"], user_id=os.environ["MATRIX_USER_ID"])
    for key in ("homeserver", "user_id", "password", "room_id", "webhook_secret"):
        if not config.get(key):
            raise ValueError(f"Missing configuration: {key}")
    state = Path(os.environ["STATE_DIRECTORY"])
    outbox = Outbox(state / "outbox.sqlite")
    threading.Thread(target=worker, args=(config, outbox, state), daemon=True).start()
    HTTPServer(("127.0.0.1", 3457), handler(config, outbox)).serve_forever()


if __name__ == "__main__":
    main()
