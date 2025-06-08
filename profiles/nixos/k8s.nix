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
  # kubeconfig at /etc/kubernetes/cluster-admin.kubeconfig
  # key at /var/lib/kubernetes/secrets/cluster-admin-key.pem

  # node notes:
  # scp server3:/var/lib/kubernetes/secrets/apitoken.secret (NODE):/var/lib/kubernetes/secrets/apitoken.secret
  # ensure /var/lib/kubernetes/secrets/apitoken.secret owned by root:kubernetes, chmod 600
}
