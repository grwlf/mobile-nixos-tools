#!/bin/sh

set -e -x

DEVIP="192.168.1.38"
TOP=$(cd "$(dirname $0)/.."; pwd;)

sh $TOP/sh/build-mobile-nixos.sh \
  -U root@$DEVIP -C $TOP/nix/example.nix -A config.system.build.toplevel "$@"
