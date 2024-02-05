{ pkgs, stdenv }:

stdenv.mkDerivation {
  name = "kaios-simulator";
  src = pkgs.fetchzip {
    url = "https://s3.amazonaws.com/kaicloudsimulatordl/developer-portal/simulator/Kaiosrt_ubuntu.tar.bz2";
    hash = "sha256-BAe5hnAa/mBDznmt4Wy6tVJZcGw0Vx09srtv2o9p0h0=";
  };

  buildInputs = [ pkgs.autoPatchelfHook ];

  nativebuildInputs = with pkgs; [
    libstdcxx5
    libgcc
    libgtk
    libgdk
    libfreetype
    libfontconfig
    lib
  ];

  buildPhase = ''
    mkdir -p $out/bin $out/lib
    tar -xvf $src/kaiosrt-v2.5.en-US.linux-x86_64.tar.bz2 --directory $out/lib
    ln -s $out/lib/kaiosrt/kaiosrt $out/bin/kaiosrt
  '';
}
