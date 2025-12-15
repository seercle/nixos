{
  pkgs,
  pkgsUnstable,
  ...
}: {
  imports = [
    ../../../../user/shell/fish
    ../../../../user/shell/aliases
    ../../../../user/shell/foot
    ../../../../user/shell/starship
    ../../../../user/shell/direnv
    ../../../../user/cursor/catppuccin
    ../../../../user/wm/hyprland/caelestia
    ../../../../user/app/spicetify
    ../../../../user/app/btop
  ];
  home.packages = with pkgs; [
    pkgsUnstable.zed-editor
    bitwarden-desktop
    thunderbird
    cloc
    firefox
    redis
    postgresql
    tmux
  ];
  programs = {
    vesktop.enable = true;
    tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
    };
    git = {
      userName = "seercle";
      userEmail = "notseercle@gmail.com";
    };
  };
}
