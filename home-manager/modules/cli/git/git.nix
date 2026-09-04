{
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.ff = "only";

      commit.gpgSign = true;
      user = {
        name = "dayu";
        email = "dayu@dayu.jp";
        signingkey = "BF2D5F721420828E";
      };

      # Github-Cliと連携しての認証の設定
      "credential".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };
}
