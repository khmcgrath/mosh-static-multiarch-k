# mosh-static

An unofficial static binary distribution of [mobile-shell/mosh](https://github.com/mobile-shell/mosh) which can be dropped into a remote server. Extends [dtinth/mosh-static](https://github.com/dtinth/mosh-static) to add support for arm64 and armv7 architectures on Linux, using QEMU when building, and also support for macOS on arm64 and x86_64.

Releasing is automated by GitHub Actions on [this GitHub Actions workflow](https://github.com/freitas-renato/mosh-static-multiarch/blob/main/.github/workflows/autobuild.yml). For Linux, it clones `mosh`’s source code, compiles it inside an Alpine Docker image with QEMU for arm64, armv7 and amd64 targets. For macOS, it installs dependencies via Macports and compiles inside a macOS environment, linking protobuf statically. In the end, it creates a [GitHub release](https://github.com/freitas-renato/mosh-static-multiarch/releases/latest) with the binaries.

## Using the binaries

```sh
# On the server (ARM64)
wget https://github.com/freitas-renato/mosh-static-multiarch/releases/latest/download/mosh-server-linux-arm64 -O mosh-server
chmod +x mosh-server

# On the client
mosh --server=./mosh-server <username>@<hostname>
```

