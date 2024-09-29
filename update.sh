#!/usr/bin/env bash

set -o pipefail

# Update nix flake
nix flake update

# Update NPM dependencies
npm update

# Rebuild elm nix manifests
elm2nix convert > elm-srcs.nix
elm2nix snapshot

# Update NPM deps hash if necessary
if ! output="$(nix build --no-link |& tee /dev/tty)"; then
  new_hash="$(echo "$output" | awk '/got:/ {print $2}')"

  echo "Updating NPM dependencies hash to [$new_hash]"
  sed -i "s/npmDepsHash = \".*\"/npmDepsHash = \"$new_hash\"/" flake.nix
fi
