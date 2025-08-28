let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";

  pkgs = import nixpkgs {
    config = {
        allowUnsupportedSystem = false;
     };
    overlays = [ ];
  };

  packages =
    let
      phpWithCustomPeclExtensions = (
        pkgs.php82.buildEnv {
          extensions = (
            { enabled, all }:
            enabled
            ++ (with all; [
              xdebug
              openswoole
            ])
          );
          extraConfig = ''
            xdebug.mode=debug
          '';
        }
      );
    in
    [
      phpWithCustomPeclExtensions
      pkgs.treefmt
      pkgs.nixfmt-rfc-style
      pkgs.gnumake
      # https://discourse.nixos.org/t/php-composer-does-not-find-installed-php-extensions/31164/4
      # composer check-platform-reqs
      (pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ all.openswoole ])).packages.composer
    ];
in
pkgs.mkShell {
  inherit packages;
}

