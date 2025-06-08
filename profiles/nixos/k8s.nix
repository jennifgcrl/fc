{...}: let
  kubeMasterIP = "100.112.143.31";
  kubeMasterHostname = "server3.dog-lime.ts.net";
  kubeMasterAPIServerPort = 6443;
in {
  services.kubernetes = {
    roles = ["node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };
    addons.dns.enable = true;
  };

  users.users.jennifer.extraGroups = ["kubernetes"];

  # master notes:
  # log out & log in to gain the group
  # to read the cluster key for kubectl to work:
  # sudo chmod g+r /var/lib/kubernetes/secrets/cluster-admin-key.pem

  # node notes:
  # scp server3:/var/lib/kubernetes/secrets/apitoken.secret (NODE):/var/lib/kubernetes/secrets/apitoken.secret
  # ensure /var/lib/kubernetes/secrets/apitoken.secret owned by root:kubernetes, chmod 600
}
