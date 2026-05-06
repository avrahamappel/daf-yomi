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

        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);

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
          packages = [
            androidComposition.androidsdk
            jdk
            bacon
            cargo
            clippy
            rustc
            rustfmt
            rust-analyzer
          ];

          env = androidEnvironment;
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
            pkgs.rustPlatform.buildRustPackage {
              pname = cargoToml.name;
              version = cargoToml.version;
              src = pkgs.lib.cleanSource ./.;
              postPatch = ''
                echo "Injecting commit data into build script"
                sed -i 's#commitHash = .*$#commitHash = "${commitHash}"#' hooks/versionInfoPlugin.js
                sed -i 's#commitDate = .*$#commitDate = "${commitDate}"#' hooks/versionInfoPlugin.js
              '';

              cargoDeps = pkgs.rustPlatform.importCargoLock {
                lockFile = ./.;
              };
            };

          githubPages = self.packages.${system}.default.overrideAttrs {
            npmBuildFlags = [ "--" "--base" "/daf-yomi" ];
          };
        };
      }
    );
}
