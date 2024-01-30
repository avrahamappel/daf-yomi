{
  description = "Today's daf";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        elmJson = builtins.fromJSON (builtins.readFile ./elm.json);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; with elmPackages; [
            elm
            elm-language-server
            elm-format
            elm2nix
            nodejs
          ];
        };

        packages.default = pkgs.buildNpmPackage {
          pname = packageJson.name;
          version = packageJson.version;
          src = ./.;
          npmDepsHash = "sha256-0SiITCk/67iZzxPKz8SXfoIjamBCPhYA0MrSuHwgVrc=";
          nativeBuildInputs = with pkgs; [ elmPackages.elm ];
          configurePhase = pkgs.elmPackages.fetchElmDeps {
            elmPackages = import ./elm-srcs.nix;
            elmVersion = elmJson.elm-version;
            registryDat = ./registry.dat;
          };
          postInstall = ''
            cp -r dist $out/
          '';
        };
      }
    );
}
