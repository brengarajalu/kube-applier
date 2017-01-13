#!/bin/bash

# Build a golang project from Github if only one tar is in /project which untars
# only one top level directory.
name=kube-applier
tarname=v0.4.2.tar.gz

set -e
set -x

godir=/go/src/github.com/box

mkdir -p $godir
export GOPATH=/go
export GO15VENDOREXPERIMENT=1
mkdir /scratch
tar zxf /project/$tarname -C /scratch
tardirname=$(ls /scratch)
mv /scratch/$tardirname $godir/$name
cd $godir/$name
go build -o $name .

rm -rf /project/build
mkdir -p /project/build/templates /project/build/static
mv $name /project/build
mv templates /project/build
mv static /project/build
