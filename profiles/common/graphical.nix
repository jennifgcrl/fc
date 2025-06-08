{pkgs, ...}: {
  fonts.packages = with pkgs; [
    departure-mono
    dm-mono
    noto-fonts
    recursive
  ];
}
