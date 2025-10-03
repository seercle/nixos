{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder
  ];
  programs.gpu-screen-recorder.enable = true;
}
