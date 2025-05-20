{niri, ...}: {
  nixpkgs.overlays = [niri.overlays.niri];
}
