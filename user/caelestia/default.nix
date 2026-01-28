{
  pkgs,
  config,
  pkgsUnstable,
  ...
}: {
  #imports = [
  #  ../shell/foot
  #];
  home.packages = with pkgs; [
    networkmanagerapplet
    app2unit
    adw-gtk3
    papirus-icon-theme
    pavucontrol
  ];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
      launcher.actionPrefix = "<";
      bar = {
        workspaces = {
          shown = 8;
        };
        status = {
          showAudio = true;
          showKbLayout = true;
        };
        entries = [
          {
            id = "logo";
            enabled = true;
          }
          {
            id = "workspaces";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "tray";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "statusIcons";
            enabled = true;
          }
          {
            id = "power";
            enabled = true;
          }
        ];
      };
    };
  };
  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink /etc/nixos/user/caelestia/hypr;
  };
}
