{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      forAllSystemsWithPkgs =
        f: forAllSystems (system: f (nixpkgs.legacyPackages.${system}.extend self.overlays.default));
      treefmtEval = forAllSystemsWithPkgs (pkgs: treefmt-nix.lib.evalModule pkgs ./.nix/treefmt.nix);
    in
    {
      checks = forAllSystemsWithPkgs (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      formatter = forAllSystemsWithPkgs (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      overlays.default = (
        final: prev: {
          myWebsite = final.callPackage ./.nix/pkgs/www.nix { };
          myWebisteServe = final.callPackage ./.nix/pkgs/www-serve.nix { };
        }
      );

      apps = forAllSystemsWithPkgs (pkgs: {
        default = {
          type = "app";
          program = "${lib.getExe pkgs.myWebisteServe}";
        };
      });

      packages = forAllSystemsWithPkgs (pkgs: {
        default = pkgs.myWebsite;
      });

      devShells = forAllSystemsWithPkgs (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.jekyll
          ];
        };
      });
    };
}
