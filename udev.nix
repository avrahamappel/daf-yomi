{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "alcatel-udev-rules";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/cm-b2g/B2G/1230463/tools/51-android.rules";
    hash = "sha256-AsNUWjzzHA7HkE8DzvVkSbSA9ci/M3BqzExhqYcFoJY=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src $out/etc/udev/rules.d/51-android.rules
  '';
}
