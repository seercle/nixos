{pkgs, ...}:
{
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        libva
        libva-utils
      ];
    };
    enableAllFirmware = true;
  };
}
