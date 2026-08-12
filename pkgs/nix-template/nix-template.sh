#!/bin/bash

if [ -e "flake.nix" ]; then
    echo "flake.nix is already exist"
    echo "Aborted"
    exit 1
fi

install -m 0644 "$FLAKE_NIX_TEMPLATE" ./flake.nix
if [ -e ".envrc" ]; then
    echo ".envrc is already exist"
else
    echo "use flake" > .envrc
    echo ".envrc was created"
    direnv allow
fi

echo "flake.nix was created"
exit 0
