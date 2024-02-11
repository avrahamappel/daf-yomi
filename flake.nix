{
  description = "Today's daf";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        kaiosEnv = (pkgs.callPackage
          (pkgs.fetchFromGitHub {
            owner = "fmnxl";
            repo = "nix-kaiosenv";
            rev = "20bf3b84d90a0476cb453fe496a283d807bb4b87";
            sha256 = "sha256-JQqeoosYjdFsViR/kmtWgTjqNhFN4eD4oZQJ65L60B4=";
          })
          { }).package;

        palemoon = pkgs.palemoon-bin.overrideAttrs (final: {
          version = "28.6.1";
          src = pkgs.fetchzip {
            url = "http://archive.palemoon.org/palemoon/28.x/28.6.1/palemoon-28.6.1.linux-x86_64.tar.bz2";
            hash = "sha256-IQ6cbCtPhX5IdEAIpMemk4NdwVVPbbIUue2jgYZTdoo=";
          };
        });

        gdeploy = pkgs.buildNpmPackage {
          name = "gdeploy";
          src = ./gdeploy;
          makeCacheWritable = true;
          dontNpmBuild = true;
          npmDepsHash = "sha256-IiHYrFd47m4sp/HDamqjQorTY2iHDG5lQ6+r02Ay6y0=";
        };

        simulator = pkgs.callPackage ./simulator.nix { };

        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        elmJson = builtins.fromJSON (builtins.readFile ./elm.json);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; with elmPackages; [
            palemoon
            usbutils
            gdeploy
            simulator
            elm
            elm-language-server
            elm-format
            elm2nix
            kaiosEnv
            nodejs
          ];
        };

        packages = {
          default = pkgs.buildNpmPackage {
            pname = packageJson.name;
            version = packageJson.version;
            src = ./.;
            npmDepsHash = "sha256-fysZnlTvdrHtmMHcMXBoEHIwDcl1Ny/tKjDjVyiZG7s=";
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
