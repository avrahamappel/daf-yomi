{
  description = "Today's daf";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs
          {
            inherit system;
            config.android_sdk.accept_license = true;
            config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
              "android-sdk-cmdline-tools"
              "android-sdk-tools"
            ];
          };

        elmWrapper = pkgs.writeShellScriptBin "elm" ''
          ${pkgs.elmPackages.elm}/bin/elm "$@"

          # Update manifests if elm.json changed
          if [[ "$(git diff --name-only)" =~ elm.json ]]; then
            echo 'elm.json changed, updating manifest files'
            ${pkgs.elm2nix}/bin/elm2nix convert > elm-srcs.nix
            ${pkgs.elm2nix}/bin/elm2nix snapshot
          fi
        '';

        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        elmJson = builtins.fromJSON (builtins.readFile ./elm.json);

        buildToolsVersion = "34.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = [ "34" ];
        };
        androidEnvironment = rec {
          ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
          ANDROID_SDK_ROOT = ANDROID_HOME;
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; with elmPackages; [
            androidComposition.androidsdk
            jdk
            elmWrapper
            elm2nix
            elm-language-server
            elm-format
            nodejs
            cordova
            gradle
          ];

          env = androidEnvironment;
        };

        packages = {
          default = pkgs.buildNpmPackage {
            pname = packageJson.name;
            version = packageJson.version;
            src = ./.;
            npmDepsHash = "sha256-tek2w9qKvliGe6G4jPJfGP1oA99Ft3N/hqdPQXrrHtk=";
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
