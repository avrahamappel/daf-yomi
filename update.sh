#!/usr/bin/env bash

set -o pipefail

# Update nix flake
nix flake update

# Update NPM dependencies
npm update

# Rebuild elm nix manifests
elm2nix convert > elm-srcs.nix
# Only write new registry.dat if dependencies changed
if [[ "$(git diff --name-only)" =~ elm-srcs.nix ]]; then
  elm2nix snapshot
fi
