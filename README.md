# box-kube-applier

Builds kube-applier binary from public source code into a Box base image for use on our clusters.

The upstream repo is packaged as a compressed tar file. The image build process decompresses the file, builds a Go binary from the source code, and adds the binary to a Box base image.

## Usage

Refer to [upstream documentation](https://github.com/box/kube-applier).

## Upgrading

To upgrade to a new patchset from the upstream repo, replace the existing tar file with a new tar file that contains the patched repo.

Tar files are available on the upstream [releases](https://github.com/box/kube-applier/releases) page, or can be manually created.

In the build.sh script, update the `tarname` variable to point to the new tar file.
```
tarname=<release>.tar.gz
```
