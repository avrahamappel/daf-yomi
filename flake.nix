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

        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        elmJson = builtins.fromJSON (builtins.readFile ./elm.json);

        # Must match the values in android/app/build.gradle
        # and android/variables.gradle
        buildToolsVersion = "34.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = [ "35" ];
        };
        androidEnvironment = rec {
          ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            androidComposition.androidsdk
            cargo
            cargo-leptos
            clippy
            jdk
            leptosfmt
            lld
            nodejs
            rustc
            rustfmt
            rust-analyzer
            wasm-bindgen-cli
          ];

          env = androidEnvironment;
        };

        packages = {
          default = pkgs.buildNpmPackage {
            pname = packageJson.name;
            version = packageJson.version;
            src = ./.;
            npmDepsHash = "sha256-48B1FGQszYk9id2IG7lbmbuJGhQo6WWzOogN+9JU84Y=";
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
