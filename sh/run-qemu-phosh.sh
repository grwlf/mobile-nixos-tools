#!/bin/sh

TOP=$(cd "$(dirname $0)/.."; pwd;)

set -e -x

sh $TOP/sh/build-mobile-nixos.sh -S -C $TOP/nix/phosh.nix -A outputs.uefi.vm "$@"
./result
