#!/usr/bin/env bash

# Update nix flake
nix flake update

# Update NPM dependencies
npm update

# Rebuild elm nix manifests
elm2nix convert > elm-srcs.nix
elm2nix snapshot
