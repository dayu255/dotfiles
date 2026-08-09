{
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "dayu";
        email = "dayu@dayu.jp";
        signingkey = "BF2D5F721420828E";
      };

      commit.gpgSign = true;
      init.defaultBranch = "main";

      # Github-Cliと連携しての認証の設定
      "credential".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };
}
