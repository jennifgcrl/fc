{
  config,
  pkgs,
  ip,
  ...
}: let
  kubeMasterIP = "100.112.143.31";
  kubeMasterHostname = "server3.dog-lime.ts.net";
  kubeMasterAPIServerPort = 6443;
in {
  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;
  };
}
