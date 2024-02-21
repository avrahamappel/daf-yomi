{ pkgs ? import <nixpkgs> { }, stdenv ? pkgs.stdenv }:

let
  kaiosrt = stdenv.mkDerivation {
    name = "kaiosrt";
    src = pkgs.fetchzip {
      url = "https://s3.amazonaws.com/kaicloudsimulatordl/developer-portal/simulator/Kaiosrt_ubuntu.tar.bz2";
      hash = "sha256-BAe5hnAa/mBDznmt4Wy6tVJZcGw0Vx09srtv2o9p0h0=";
    };

    buildInputs = [ pkgs.autoPatchelfHook ];

    nativebuildInputs = with pkgs; [
      pkg-config
      glib
    ];

    autoPatchelfIgnoreMissingDeps = [ "*" ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      tar -xvf $src/kaiosrt-v2.5.en-US.linux-x86_64.tar.bz2 --directory $out/bin
      runHook postInstall
    '';
  };
in

pkgs.writeShellScriptBin "kaios-simulator" ''
  ${kaiosrt}/bin/kaiosrt/kaiosrt "$@"
''
