{ pkgs, ... }:

{

  # https://devenv.sh/packages/
  packages = [ 
        pkgs.git 
        pkgs.sqlite
        pkgs.litecli
    ];

  # https://devenv.sh/languages/
  # languages.nix.enable = true;
  languages.nim.enable = true ;
  languages.elm.enable = true ;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
