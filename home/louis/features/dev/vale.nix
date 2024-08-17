{pkgs, ...}: {
  home.packages = with pkgs; [
    (
      vale.withStyles
      (s: [s.alex s.proselint s.google s.readability])
    )
  ];
  home.file.".vale.ini".text = ''
    StylesPath = styles
    MinAlertLevel = suggestion

    Packages = Google, Readability, alex, proselint

    [*]
    BasedOnStyles = alex, proselint
  '';
}
