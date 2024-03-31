{
  description = "Today's daf";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        elmWrapper = pkgs.writeShellScriptBin "elm" ''
          ${pkgs.elmPackages.elm}/bin/elm "$@"

          # Update manifests if elm.json changed
          if [[ "$(git diff --name-only)" =~ elm.json ]]; then
            echo 'elm.json changed, updating manifest files'
            elm2nix convert > elm-srcs.nix
            elm2nix snapshot
          fi
        '';

        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        elmJson = builtins.fromJSON (builtins.readFile ./elm.json);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; with elmPackages; [
            elmWrapper
            elm-language-server
            elm-format
            nodejs
          ];
        };

        packages = {
          default = pkgs.buildNpmPackage {
            pname = packageJson.name;
            version = packageJson.version;
            src = ./.;
            npmDepsHash = "sha256-XB34f3MwgYQ7msAHKFClos8m9quZhZypMZLmyPvUTew=";
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

          githubPages = self.packages.${system}.default.overrideAttrs {
            npmBuildFlags = [ "--" "--base" "/daf-yomi" ];
          };
        };
      }
    );
}
