#!/usr/bin/env nix
#!nix develop --command bash

npx vite build
npx cap sync
cd android || exit 1
./gradlew assemble
adb install app/build/outputs/apk/debug/app-debug.apk
