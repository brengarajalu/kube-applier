#!/bin/bash

# Build a golang project from Github if only one tar is in /git-root which untars
# only one top level directory.
name=kube-applier

# 0.2.0 is equivalent to the official 0.2.0 release here
# https://github.com/box/kube-applier/tree/v0.2.0
tarname=v0.2.1.tar.gz

set -e
set -x

TMP_DIR=$(mktemp -d)
godir=$TMP_DIR/go/src/github.com/box

mkdir -p $godir
export GOPATH=$TMP_DIR/go
export GO15VENDOREXPERIMENT=1
export SCRATCH=$TMP_DIR/scratch
mkdir -p $SCRATCH
tar zxf /git-root/$tarname -C $SCRATCH
tardirname=$(ls $SCRATCH)
mv $SCRATCH/$tardirname $godir/$name
cd $godir/$name
go build -o $name .

rm -rf /git-root/build
mkdir -p /git-root/build/templates /git-root/build/static
mv $name /git-root/build
mv templates /git-root/build
mv static /git-root/build
