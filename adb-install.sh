#!/usr/bin/env bash

apk="$(nix build .#androidApk --print-out-paths)"
adb install "$apk"
