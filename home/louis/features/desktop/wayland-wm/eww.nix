{ pkgs, ... }:
let
  # CPU usage script
  cpu-usage = pkgs.writeShellScriptBin "cpu-usage" ''
    #!/bin/bash
    PREV_TOTAL=0
    PREV_IDLE=0
    cpuFile="/tmp/.cpu_usage"

    if [[ -f "''${cpuFile}" ]]; then
      fileCont=$(cat "''${cpuFile}")
      PREV_TOTAL=$(echo "''${fileCont}" | head -n 1)
      PREV_IDLE=$(echo "''${fileCont}" | tail -n 1)
    fi

    CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
    unset CPU[0]                          # Discard the "cpu" prefix.
    IDLE=''${CPU[4]}                        # Get the idle CPU time.

    # Calculate the total CPU time.
    TOTAL=0
    for VALUE in "''${CPU[@]:0:4}"; do
      let "TOTAL=$TOTAL+$VALUE"
    done

    if [[ "''${PREV_TOTAL}" != "" ]] && [[ "''${PREV_IDLE}" != "" ]]; then
      # Calculate the CPU usage since we last checked.
      let "DIFF_IDLE=$IDLE-$PREV_IDLE"
      let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
      let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
      echo "''${DIFF_USAGE}"
    else
      echo "?"
    fi

    # Remember the total and idle CPU times for the next check.
    echo "''${TOTAL}" > "''${cpuFile}"
    echo "''${IDLE}" >> "''${cpuFile}"
  '';

  # Memory usage script
  mem-usage = pkgs.writeShellScriptBin "mem-usage" ''
    #!/bin/bash
    printf "%.0f\n" $(${pkgs.procps}/bin/free -m | grep Mem | ${pkgs.gawk}/bin/awk '{print ($3/$2)*100}')
  '';

  # Brightness script
  brightness = pkgs.writeShellScriptBin "brightness" ''
    #!/bin/bash
    CARD=`ls /sys/class/backlight | head -n 1`
    if [[ "$CARD" == *"intel_"* ]]; then
      BNESS=`${pkgs.xorg.xbacklight}/bin/xbacklight -get`
      LIGHT=''${BNESS%.*}
    else
      # Fallback method for non-intel cards
      if [[ -n "$CARD" ]]; then
        BNESS=`cat /sys/class/backlight/$CARD/brightness`
        MAX_BNESS=`cat /sys/class/backlight/$CARD/max_brightness`
        PERC="$(($BNESS*100/$MAX_BNESS))"
        LIGHT=''${PERC%.*}
      else
        LIGHT=0
      fi
    fi
    echo "$LIGHT"
  '';

  # Battery script
  battery = pkgs.writeShellScriptBin "battery" ''
    #!/bin/bash
    BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
    if [[ -n "$BAT" ]]; then
      cat /sys/class/power_supply/''${BAT}/capacity
    else
      echo "0"
    fi
  '';
  # Music status script
  music-status = pkgs.writeShellScriptBin "music-status" ''
    #!/bin/bash
    STATUS="$(${pkgs.mpc-cli}/bin/mpc status)"
    if [[ $STATUS == *"[playing]"* ]]; then
      echo ""
    else
      echo ""
    fi
  '';

  # Get current song title
  music-song = pkgs.writeShellScriptBin "music-song" ''
    #!/bin/bash
    song=`${pkgs.mpc-cli}/bin/mpc -f %title% current`
    if [[ -z "$song" ]]; then
      echo "Offline"
    else
      echo "$song"
    fi
  '';

  # Get current artist
  music-artist = pkgs.writeShellScriptBin "music-artist" ''
    #!/bin/bash
    artist=`${pkgs.mpc-cli}/bin/mpc -f %artist% current`
    if [[ -z "$artist" ]]; then
      echo "Offline"
    else
      echo "$artist"
    fi
  '';

  # Get progress percentage
  music-time = pkgs.writeShellScriptBin "music-time" ''
    #!/bin/bash
    time=`${pkgs.mpc-cli}/bin/mpc status | grep "%)" | ${pkgs.gawk}/bin/awk '{print $4}' | tr -d '(%)'`
    if [[ -z "$time" ]]; then
      echo "0"
    else
      echo "$time"
    fi
  '';

  # Get current time
  music-ctime = pkgs.writeShellScriptBin "music-ctime" ''
    #!/bin/bash
    ctime=`${pkgs.mpc-cli}/bin/mpc status | grep "#" | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.gnused}/bin/sed 's|/.*||g'`
    if [[ -z "$ctime" ]]; then
      echo "0:00"
    else
      echo "$ctime"
    fi
  '';

  # Get total time
  music-ttime = pkgs.writeShellScriptBin "music-ttime" ''
    #!/bin/bash
    ttime=`${pkgs.mpc-cli}/bin/mpc -f %time% current`
    if [[ -z "$ttime" ]]; then
      echo "0:00"
    else
      echo "$ttime"
    fi
  '';

  # Get album cover
  music-cover = pkgs.writeShellScriptBin "music-cover" ''
    #!/bin/bash
    COVER="/tmp/.music_cover.jpg"
    MUSIC_DIR="''${HOME}/Music"

    current_file=$(${pkgs.mpc-cli}/bin/mpc current -f %file%)
    if [[ -z "$current_file" ]]; then
      echo "images/music.png"
      exit 0
    fi

    ${pkgs.ffmpeg}/bin/ffmpeg -i "''${MUSIC_DIR}/''${current_file}" "''${COVER}" -y &> /dev/null
    STATUS=$?

    # Check if the file has embedded album art
    if [ "$STATUS" -eq 0 ]; then
      echo "$COVER"
    else
      echo "images/music.png"
    fi
  '';

  # Music control scripts
  music-toggle = pkgs.writeShellScriptBin "music-toggle" ''
    #!/bin/bash
    ${pkgs.mpc-cli}/bin/mpc -q toggle
  '';

  music-next = pkgs.writeShellScriptBin "music-next" ''
    #!/bin/bash
    ${pkgs.mpc-cli}/bin/mpc -q next
    # Update cover after changing song
    COVER="/tmp/.music_cover.jpg"
    MUSIC_DIR="''${HOME}/Music"
    current_file=$(${pkgs.mpc-cli}/bin/mpc current -f %file%)
    if [[ -n "$current_file" ]]; then
      ${pkgs.ffmpeg}/bin/ffmpeg -i "''${MUSIC_DIR}/''${current_file}" "''${COVER}" -y &> /dev/null
    fi
  '';

  music-prev = pkgs.writeShellScriptBin "music-prev" ''
    #!/bin/bash
    ${pkgs.mpc-cli}/bin/mpc -q prev
    # Update cover after changing song
    COVER="/tmp/.music_cover.jpg"
    MUSIC_DIR="''${HOME}/Music"
    current_file=$(${pkgs.mpc-cli}/bin/mpc current -f %file%)
    if [[ -n "$current_file" ]]; then
      ${pkgs.ffmpeg}/bin/ffmpeg -i "''${MUSIC_DIR}/''${current_file}" "''${COVER}" -y &> /dev/null
    fi
  '';
in
{
  programs.eww.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      eww
      noto-fonts
      noto-fonts-emoji
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.symbols-only
    ];
    file.".config/eww/eww.yuck".text = ''

      (defvar NAME "Louis Thevenet")
      (defpoll UNAME :interval "5m" `whoami`)

      ;; Sys vars
      (defpoll HOST :interval "5s" `hostname`)
      (defpoll CPU_USAGE :interval "1s" `${cpu-usage}`)
      (defpoll MEM_USAGE :interval "1s" `${mem-usage}`)
      (defpoll BLIGHT :interval "1s" `${brightness}`)
      (defpoll BATTERY :interval "5s" `${battery}`)

      ;; Time vars
      (defpoll HOUR :interval "5s" `date +\"%I\"`)
      (defpoll MIN :interval "5s" `date +\"%M\"`)
      (defpoll MER :interval "5s" `date +\"%p\"`)
      (defpoll DAY :interval "5s" `date +\"%A\"`)

      ;; Uptime vars
      (defpoll UPHOUR :interval "5s" `uptime -p | awk '{print $2 \" \" $3}' | sed 's/,//g'`)
      (defpoll UPMIN :interval "5s" `uptime -p | awk '{print $4 \" \" $5}'`)

      ;; Music vars
      (defpoll SONG :interval "1s" `${music-song}`)
      (defpoll ARTIST :interval "1s" `${music-artist}`)
      (defpoll STATUS :interval "1s" `${music-status}`)
      (defpoll CURRENT :interval "1s" `${music-time}`)
      (defpoll COVER :interval "1s" `${music-cover}`)
      (defpoll CTIME :interval "1s" `${music-ctime}`)
      (defpoll TTIME :interval "1s" `${music-ttime}`)

      (defpoll FREE :interval "5s" `df -h / | awk '{print $4}' | tail -n 1 | sed 's/G/GB/'`)

      ;; background
      (defwidget bg [] 
      	(box :class "bg")
      )

      ;; profile
      (defwidget user [] 
      	(box :class "genwin" :orientation "v" :spacing 35 :space-evenly "false" :vexpand "false" :hexpand "false"
      		(label :class "fullname" :halign "center" :wrap "true" :limit-width 25 :text NAME)
      		(label :class "username" :halign "center" :wrap "true" :limit-width 25 :text UNAME)))

      ;; system
      (defwidget system [] 
        (box :class "genwin" :vexpand "false" :hexpand "false" 
          (box :orientation "v" :spacing 35 :halign "center" :valign "center" :space-evenly "false" :vexpand "false" :hexpand "false" 
            (box :class "cpu_bar" :orientation "h" :spacing 20 :space-evenly "false" :vexpand "false" :hexpand "false" 
              (label :class "iconcpu" :text "")        ;; microchip
              (scale :min 0 :max 100 :value CPU_USAGE :active "false"))
            (box :class "mem_bar" :orientation "h" :spacing 20 :space-evenly "false" :vexpand "false" :hexpand "false" 
              (label :class "iconmem" :text "")        ;; memory (devicons)
              (scale :min 0 :max 100 :value MEM_USAGE :active "false"))
            (box :class "bright_bar" :orientation "h" :spacing 20 :space-evenly "false" :vexpand "false" :hexpand "false" 
              (label :class "iconbright" :text "")     ;; sun
              (scale :min 0 :max 100 :value BLIGHT :active "false"))
            (box :class "bat_bar" :orientation "h" :spacing 20 :space-evenly "false" :vexpand "false" :hexpand "false" 
              (label :class "iconbat" :text "")        ;; battery full
              (scale :min 0 :max 100 :value BATTERY :active "false")))))

      ;; clock
      (defwidget clock [] 
      	(box :class "genwin" :orientation "h" :spacing 50 :space-evenly false :vexpand "false" :hexpand "false" 
      		(box :orientation "h" :spacing 0
      			(label :class "time_hour" :valign "start" :wrap "true" :limit-width 25 :text HOUR)
      			(label :class "time_min" :valign "end" :wrap "true" :limit-width 25 :text MIN))
      		(box :orientation "v" :spacing 0 
      			(label :class "time_mer" :valign "start" :halign "end" :wrap "true" :limit-width 25 :text MER)
      			(label :class "time_day" :valign "end" :halign "end" :wrap "true" :limit-width 25 :text DAY))))

      ;; uptime
      (defwidget uptime [] 
      	(box :class "genwin" 
      		(box :orientation "h" :halign "center" :spacing 40 :space-evenly "false" :vexpand "false" :hexpand "false" 
      			(label :class "icontimer" :valign "center" :text "")
      			(box :orientation "v" :valign "center" :spacing 0 :space-evenly "false" :vexpand "false" :hexpand "false" 
      				(label :class "uphour" :halign "start" :wrap "true" :limit-width 25 :text UPHOUR)
      				(label :class "upmin" :halign "start" :wrap "true" :limit-width 25 :text UPMIN)))))

      ;; Music
      (defwidget music [] 
      	(box :class "genwin" :orientation "h" :space-evenly "false" :vexpand "false" :hexpand "false" 
      		(box :class "album_art" :vexpand "false" :hexpand "false" :style "background-image: url('$${COVER}');")
      		(box :orientation "v" :spacing 20 :space-evenly "false" :vexpand "false" :hexpand "false" 
      			(label :halign "center" :class "song" :wrap "true" :limit-width 20 :text SONG)
      			(label :halign "center" :class "artist" :wrap "true" :limit-width 15 :text ARTIST)
      			(box :orientation "h" :spacing 20 :halign "center" :space-evenly "true" :vexpand "false" :hexpand "false" 
              (button :class "btn_prev" :onclick "${music-prev}" "")
              (button :class "btn_play" :onclick "${music-toggle}" STATUS)
              (button :class "btn_next" :onclick "${music-next}" ""))
              (box :class "music_bar" :halign "center" :vexpand "false" :hexpand "false" 
        			(scale :onscroll "mpc -q seek +1" :min 0 :active "true" :max 100 :value CURRENT)))))
      ;; power buttons
      (defwidget logout [] 
        (box :class "genwin" :vexpand "false" :hexpand "false" 
          (button :class "btn_logout" :onclick "openbox --exit" "")))

      (defwidget sleep [] 
        (box :class "genwin" :vexpand "false" :hexpand "false" 
          (button :class "btn_sleep" :onclick "systemctl suspend" "")))

      (defwidget reboot [] 
        (box :class "genwin" :vexpand "false" :hexpand "false" 
          (button :class "btn_reboot" :onclick "systemctl reboot" "")))

      (defwidget poweroff [] 
        (box :class "genwin" :vexpand "false" :hexpand "false" 
          (button :class "btn_poweroff" :onclick "systemctl poweroff" "")))

      ;; ** Windows *************************************************************************

      ;; background
      (defwindow background   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 0 :y 0 :width "1920px" :height "1080px")
      					(bg))

      ;; profile
      (defwindow profile   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 150 :y 150 :width 350 :height 440)
      					(user))

      ;; system
      (defwindow system   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 150 :y 605 :width 350 :height 325)
      					(system))

      ;; clock
      (defwindow clock   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 515 :y 150 :width 350 :height 155)
      					(clock))

      ;; uptime
      (defwindow uptime   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 515 :y 320 :width 350 :height 155)
      					(uptime))

      ;; music
      (defwindow music   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 515 :y 490 :width 610 :height 280)
      					(music))

      ;; logout
      (defwindow logout   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 1445 :y 150 :width 155 :height 155)
      					(logout))

      ;; sleep
      (defwindow sleep   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 1615 :y 150 :width 155 :height 155)
      					(sleep))

      ;; reboot
      (defwindow reboot   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 1445 :y 320 :width 155 :height 155)
      					(reboot))

      ;; poweroff
      (defwindow poweroff   :monitor 0 :stacking "fg" :focusable "false" :screen 1 
      	    :geometry (geometry :x 1615 :y 320 :width 155 :height 155)
      					(poweroff))
    '';
    file.".config/eww/eww.scss".text = ''
      /** Global *******************************************/
      *{
      	all: unset;
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      }

      /** Background ***************************************/
      .bg {
      	background-image: url("images/bg.png");
      	background-color: #474D59;
      	opacity: 1;
      }

      /** Generic window ***********************************/
      .genwin {
      	background-color: #2E3440;
      	border-radius: 16px;
      }

      /** Profile ******************************************/
      .face {
      	background-size: 200px;
      	min-height: 200px;
      	min-width: 200px;
      	margin: 65px 0px 0px 0px;
      	border-radius: 100%;
      }

      .fullname {
      	color: #D46389;
      	font-size : 30px;
      	font-weight : bold;
      }

      .username {
      	color: #8FBCBB;
      	font-size : 22px;
      	font-weight : bold;
      	margin : -15px 0px 0px 0px;
      }

      /** System ********************************************/
      .iconcpu, .iconmem, .iconbright, .iconbat {
      	font-size : 32px;
      	font-weight : normal;
      }
      .iconcpu {
      	color: #BF616A;
      }
      .iconmem {
      	color: #A3BE8C;
      }
      .iconbright {
      	color: #EBCB8B;
      }
      .iconbat {
      	color: #88C0D0;
      }

      .cpu_bar, .mem_bar, .bright_bar, .bat_bar, scale trough {
      	all: unset;
      	background-color: #3A404C;
      	border-radius: 16px;
      	min-height: 28px;
      	min-width: 240px;
      }

      .cpu_bar, .mem_bar, .bright_bar, .bat_bar, scale trough highlight {
      	all: unset;
      	border-radius: 16px;
      }

      .cpu_bar scale trough highlight {
      	background-color: #BF616A;
      }
      .mem_bar scale trough highlight {
      	background-color: #A3BE8C;
      }
      .bright_bar scale trough highlight {
      	background-color: #EBCB8B;
      }
      .bat_bar scale trough highlight {
      	background-color: #88C0D0;
      }

      /** Clock ********************************************/
      .time_hour, .time_min {
      	color: #81A1C1;
      	font-size : 70px;
      	font-weight : bold;
      }
      .time_hour {
      	margin : 15px 0px 0px 20px;
      }
      .time_min {
      	margin : 0px 0px 10px 0px;
      }

      .time_mer {
      	color: #A3BE8C;
      	font-size : 40px;
      	font-weight : bold;
      	margin : 20px 0px 0px 0px;
      }

      .time_day {
      	color: #EBCB8B;
      	font-size : 30px;
      	font-weight : normal;
      	margin : 0px 0px 20px -20px;
      }

      /** Uptime ********************************************/
      .icontimer {
      	color: #B48EAD;
      	font-size : 90px;
      	font-weight : normal;
      }

      .uphour {
      	color: #E5E9F0;
      	font-size : 42px;
      	font-weight : bold;
      }

      .upmin {
      	color: #E5E9F0;
      	font-size : 32px;
      	font-weight : bold;
      }

      /** Music ***************************************/
      .album_art {
      	background-size: 240px;
      	min-height: 240px;
      	min-width: 240px;
      	margin: 20px;
      	border-radius: 14px;
      }

      .song {
      	color: #8FBCBB;
      	font-size : 24px;
      	font-weight : bold;
      	margin : 40px 0px 0px 0px;
      }

      .artist {
      	color: #EBCB8B;
      	font-size : 16px;
      	font-weight : normal;
      	margin : 0px 0px 15px 0px;
      }

      .btn_prev, .btn_play, .btn_next {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      }
      .btn_prev {
      	color: #EBCB8B;
      	font-size : 32px;
      	font-weight : normal;
      }
      .btn_play {
      	color: #A3BE8C;
      	font-size : 48px;
      	font-weight : bold;
      }
      .btn_next {
      	color: #EBCB8B;
      	font-size : 32px;
      	font-weight : normal;
      }

      .music_bar scale trough highlight {
      	all: unset;
      	background-color: #B48EAD;
      	border-radius: 8px;
      }
      .music_bar scale trough {
      	all: unset;
      	background-color: #3A404C;
      	border-radius: 8px;
      	min-height: 20px;
      	min-width: 310px;
      	margin : 10px 0px 0px 0px;
      }

      /** Weather ***************************************/
      .iconweather {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      	font-size : 120px;
      	font-weight : normal;
      	margin : 15px 0px 0px 30px;
      }

      .label_temp {
      	color : #A6D1DD;
      	font-size : 80px;
      	font-weight : bold;
      	margin : -15px 30px 0px 0px;
      }

      .label_stat {
      	color : #BF616A;
      	font-size : 38px;
      	font-weight : bold;
      }

      .label_quote {
      	color : #E5E5E5;
      	font-size : 18px;
      	font-weight : normal;
      }

      /** Applications ***************************************/
      .appbox {
      	margin : 15px 0px 0px 25px;
      }

      .app_fox, .app_telegram, .app_discord, .app_terminal,
      .app_files, .app_geany, .app_code, .app_gimp, .app_vbox {
          background-repeat: no-repeat;
      	background-size: 64px;
      	min-height: 64px;
      	min-width: 64px;
      	margin: 8px 8px 0px 8px;
      }

      .app_fox {}
      .app_telegram {}
      .app_discord {}
      .app_terminal {}
      .app_files {}
      .app_geany {}
      .app_code {}
      .app_gimp {}
      .app_vbox {}

      /** Links ***************************************/
      .iconweb, .iconmail {
      	color: #FFFFFF;
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      	font-size : 70px;
      	font-weight : normal;
      }
      .iconmail {
      	color: #DF584E;
      }

      .github {
      	background-color: #24292E;
      	border-radius: 16px;
      }
      .reddit {
      	background-color: #E46231;
      	border-radius: 16px;
      }
      .twitter {
      	background-color: #61AAD6;
      	border-radius: 16px;
      }
      .youtube {
      	background-color: #DF584E;
      	border-radius: 16px;
      }
      .mail {
      	background-color: #FFFFFF;
      	border-radius: 16px;
      }

      .mailbox {
      	background-color: #E5E5E5;
      	border-radius: 10px;
      	margin: 48px 0px 48px 0px;
      }
      .label_mails {
      	color: #404040;
      	font-size : 32px;
      	font-weight : bold;
      	margin: 0px 12px 0px 12px;
      }

      /** Power buttons ***************************************/
      .btn_logout, .btn_sleep, .btn_reboot, .btn_poweroff {
      	font-size : 48px;
      	font-weight : bold;
      }

      .btn_logout {
      	color: #BF616A;
      }
      .btn_sleep {
      	color: #A3BE8C;
      }
      .btn_reboot {
      	color: #EBCB8B;
      }
      .btn_poweroff {
      	color: #88C0D0;
      }

      /** Home folders ***************************************/
      .hddbox {
      	background-color: #3A404C;
      	border-radius: 10px;
      	margin : 15px;
      }
      .hddicon {
      	color: #81A1C1;
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      	font-size : 70px;
      	font-weight : normal;
      	margin : 25px 20px 25px 40px;
      }
      .hdd_label {
      	color: #E5E9F0;
      	font-size : 48px;
      	font-weight : bold;
      	margin : 0px 0px 0px 15px;
      }
      .fs_sep {
      	color: #2E3440;
      	font-size : 36px;
      	font-weight : bold;
      }

      .iconfolder1, .iconfolder2, .iconfolder3, .iconfolder4, .iconfolder5, .iconfolder6  {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji";
      	font-size : 32px;
      	font-weight : normal;
      	margin : 0px 0px 0px 75px;
      }
      .iconfolder1 {
      	color: #BF616A;
      }
      .iconfolder2 {
      	color: #A3BE8C;
      }
      .iconfolder3 {
      	color: #EBCB8B;
      }
      .iconfolder4 {
      	color: #81A1C1;
      }
      .iconfolder5 {
      	color: #B48EAD;
      }
      .iconfolder6 {
      	color: #88C0D0;
      }

      .label_folder1, .label_folder2, .label_folder3, .label_folder4, .label_folder5, .label_folder6  {
      	font-size : 22px;
      	font-weight : normal;
      	margin : 0px 0px 0px 30px;
      }
      .label_folder1 {
      	color: #BF616A;
      }
      .label_folder2 {
      	color: #A3BE8C;
      }
      .label_folder3 {
      	color: #EBCB8B;
      }
      .label_folder4 {
      	color: #81A1C1;
      }
      .label_folder5 {
      	color: #B48EAD;
      }
      .label_folder6 {
      	color: #88C0D0;
      }

      /** EOF *************************************************/
    '';
  };
}
