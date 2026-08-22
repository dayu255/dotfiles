{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    docker
  ];

  # Docker deamon enable
  virtualisation.docker.enable = true;
}
