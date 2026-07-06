{ pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "mini" = {
        HostName = "v6.dayu.jp";
      };

      "mini.local" = {
        HostName = "192.168.160.2";
      };

      "mini.cloudflare" = {
        HostName = "ssh.dayu.jp";
        ProxyCommand = "cloudflared access ssh --hostname %h";
      };

      "mirai" = {
        HostName = "mirai.dayu.jp";
        User = "dayu";
        Port = 22;
        StrictHostKeyChecking = "yes";
        UserKnownHostsFile = "${./keys/mirai.pub}";
      };

      "mini*" = lib.hm.dag.entryAfter [ "mini" "mini.local" "mini.cloudflare" ] {
        User = "odayu";
        Port = 22;
        StrictHostKeyChecking = "yes";
        UserKnownHostsFile = "${./keys/mini.pub}";
      };

      "*" = lib.hm.dag.entryAfter [ "mini*" "mirai" ] {
        IdentityFile = "~/.ssh/id_ed25519_sk_rk";
        IdentitiesOnly = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        AddKeysToAgent = "yes";
        HashKnownHosts = "yes";
      };
    };
  };
}
