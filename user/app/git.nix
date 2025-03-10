{lib, config,...}:
{
  options.git.userName = lib.mkOption {
    type = lib.types.str;
  };
  options.git.userEmail = lib.mkOption {
    type = lib.types.str;
  };

  config = {
    programs.git.enable = true;
    programs.git.userName = config.git.userName;
    programs.git.userEmail = config.git.userEmail;
  };
}
