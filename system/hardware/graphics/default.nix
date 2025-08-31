{pkgs, ...}:
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      libva
      libva-utils
    ];
  };
}
