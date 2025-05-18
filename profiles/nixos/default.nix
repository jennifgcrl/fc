{
  pkgs,
  ...
}: {
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";

  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    neovim
    ghostty.terminfo
  ];

  services.tailscale.enable = true;
  services.eternal-terminal.enable = true;
}
