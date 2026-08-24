{ pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "ssh.dayu.jp" = {
        ProxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };

      "mini" = {
        HostName = "v6.dayu.jp";
      };

      "mini.local" = {
        HostName = "192.168.160.2";
      };

      "mini.cloudflared" = {
        HostName = "ssh.dayu.jp";
        ProxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };

      "mini*" = lib.hm.dag.entryAfter [ "mini" "mini.local" "mini.cloudflared" ] {
        User = "odayu";
        Port = 22;
        StrictHostKeyChecking = "yes";
        UserKnownHostsFile = "${./keys/mini.pub}";
      };

      "mirai" = {
        User = "dayu";
        HostName = "mirai.dayu.jp";
        Port = 22;
        StrictHostKeyChecking = "yes";
        UserKnownHostsFile = "${./keys/mirai.pub}";
      };

      "*" = lib.hm.dag.entryAfter [ "mini*" "mirai" ] {
        IdentityFile = "~/.ssh/id_ed25519_sk_rk";
        IdentitiesOnly = "yes";

        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        AddKeysToAgent = "yes";
        HashKnownHosts = "yes";

        SetEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}
