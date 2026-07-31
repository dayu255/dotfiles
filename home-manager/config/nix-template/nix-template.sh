#!/bin/bash

FLAKE_NIX="flake.nix"

if [ -e ${FLAKE_NIX} ]; then
    echo "${FLAKE_NIX} is already exist"
    echo "Aborted"
    exit 1
fi

install -m 0644 "$FLAKE_NIX_TEMPLATE" ./flake.nix
echo "${FLAKE_NIX} was created"
exit 0
