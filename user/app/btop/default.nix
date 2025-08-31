{pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      btop
    ];
    file = {
      ".config/btop/btop.conf".source = ./btop.conf;
    };
  };
}
