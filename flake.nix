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
              "android-sdk-build-tools"
              "android-sdk-cmdline-tools"
              "android-sdk-platform-tools"
              "android-sdk-platforms"
              "android-sdk-tools"
              "build-tools"
              "cmake"
              "cmdline-tools"
              "platform-tools"
              "platforms"
              "tools"
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

        # Must match the values in android/app/build.gradle
        # and android/variables.gradle
        buildToolsVersion = "35.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = [ "36" ];
        };
        androidEnvironment = rec {
          ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
        };
      in
      {
        devShells.default = with pkgs; pkgs.mkShell {
          packages = with elmPackages; [
            importNpmLock.linkNodeModulesHook
            androidComposition.androidsdk
            jdk
            elmWrapper
            elm2nix
            elm-language-server
            elm-format
            nodejs
          ];

          npmDeps = importNpmLock.buildNodeModules {
            npmRoot = ./.;
            inherit nodejs;
          };

          env = androidEnvironment // {
            NPM_CONFIG_PACKAGE_LOCK_ONLY = "true";
          };
        };

        packages = {
          default =
            let
              commitHash = self.shortRev or self.dirtyShortRev;
              commitDate = builtins.concatStringsSep "-" [
                (builtins.substring 0 4 self.lastModifiedDate)
                (builtins.substring 4 2 self.lastModifiedDate)
                (builtins.substring 6 2 self.lastModifiedDate)
              ];
            in
            pkgs.buildNpmPackage {
              pname = packageJson.name;
              version = packageJson.version;
              src = ./.;
              postPatch = ''
                echo "Injecting commit data into build script"
                sed -i 's#commitHash = .*$#commitHash = "${commitHash}"#' hooks/versionInfoPlugin.js
                sed -i 's#commitDate = .*$#commitDate = "${commitDate}"#' hooks/versionInfoPlugin.js
              '';
              npmDepsHash = "sha256-Ttiqd1MDFUEUBeg2r2nOuEjb1XTvjt0rme8CqwSY8dI=";
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
