{
  description = "Today's daf";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; with elmPackages; [
            elm
            elm-language-server
            elm-format
            elm2nix
            nodejs
            yarn
            yarn2nix
          ];
        };

        packages.default = pkgs.mkYarnPackage {
          name = "daf-yomi";
          src = ./.;
          packageJSON = ./package.json;
          yarnLock = ./yarn.lock;
          yarnNix = ./yarn.nix;
        };
      }
    );
}
