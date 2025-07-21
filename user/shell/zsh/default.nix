{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    plugins = [
    {
      name = "catppuccin-zsh-syntax-highlighting";
      file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zsh-syntax-highlighting";
        rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
        sha256 = "1yjgpd44hhyk2mpg5g1scf53dwpjbyqbi2i8zhv98qkk1as77awp";
      };
    }
    ];
  };
}

