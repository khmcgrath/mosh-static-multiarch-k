# mosh-static

An unofficial static binary distribution of [mobile-shell/mosh](https://github.com/mobile-shell/mosh) which can be dropped into a remote server. Extends [dtinth/mosh-static](https://github.com/dtinth/mosh-static) to add support for arm64 and armv7 architectures, using QEMU when building.

Releasing is automated by GitHub Actions — [this GitHub Actions workflow](https://github.com/freitas-renato/mosh-static/blob/main/.github/workflows/autobuild.yml) clones `mosh`’s source code, compiles it inside an Alpine Docker image, and creates a GitHub release with the binaries.

## Using the binaries

```sh
# On the server (ARM64)
wget https://github.com/freitas-renato/mosh-static-multiarch/releases/latest/download/mosh-server-arm64.zip
unzip mosh-server-arm64.zip
chmod +x mosh-server-arm64/mosh-server

# On the client
mosh --server=./mosh-server <username>@<hostname>
```

