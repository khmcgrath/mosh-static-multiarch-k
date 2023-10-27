ARG TARGET_ARCH=amd64
ARG HOST_ARCH=amd64

FROM multiarch/qemu-user-static as bootstrap
ARG arch
ARG host
RUN echo "Switching from $host to $arch" && uname -a

# Based on from https://github.com/javabrett/mosh/blob/docker/dockerfiles/Dockerfile.alpine
FROM multiarch/alpine:${TARGET_ARCH}-latest-stable as build
ARG TARGET_ARCH
RUN echo "Building for ${TARGET_ARCH}" && uname -a

RUN apk update && \
  apk --no-cache add \
  autoconf \
  automake \
  build-base \
  ncurses-dev \
  ncurses-static \
  openssh-client \
  openssh-server \
  openssl-dev \
  openssl-libs-static \
  perl-doc \
  protobuf-dev \
  zlib-static \
  zlib-dev \
  libutempter-dev
