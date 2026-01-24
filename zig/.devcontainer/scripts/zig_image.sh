
#!/bin/bash

set -e

VERSION="0.15.2"
ZIG_ARCH="x86_64-linux"
BASE_IMAGE="docker.io/debian:bookworm-slim"
IMAGE_NAME="zig-dev"

echo "stage 1: --metadata retrieval from ziglang source json page--"
METADATA=$(curl -s https://ziglang.org/download/index.json | \
  jq -r --arg ver "$VERSION" --arg arch "$ZIG_ARCH" \
  '.[$ver][$arch] | "\(.tarball) \(.shasum)"')

read URL ZIG_SHA256 <<< "$METADATA"

if [ -z "$URL" ] || [ "$URL" == "null" ]; then
  echo "combo ver arch is wrong"
  exit 1 
fi

echo "Target: Zig $VERSION_WANTED ($ZIG_ARCH)"
echo "Source: $URL"
echo "Sha256: $ZIG_SHA256"

echo "stage 2: --initialize base (OCI RootFS)--"
ctr=$(buildah from $BASE_IMAGE)
mnt=$(buildah mount $ctr)

echo "stage 3: --setup deps (layer 1: OS)--"
buildah run $ctr -- apt-get update
buildah run $ctr -- apt-get install -y --no-install-recommends \
  ca-certificates curl git xz-utils libc6-dev gcc build-essential

echo "stage 4: --zig installation (layer 2: toolchain)--"
TAR_FILENAME="zig.tar.xz"
# curl redirects automatically with -L 
curl -L -o "$mnt/tmp/$TAR_FILENAME" "$URL"
# so it's fundamental to check the shasum 
echo "$ZIG_SHA256 $mnt/tmp/$TAR_FILENAME" | sha256sum -c - 

echo "extracting zig in /usr/local/lib.."
buildah run $ctr -- tar -xf "/tmp/$TAR_FILENAME" -C /usr/local/lib
buildah run $ctr -- mv /usr/local/lib/zig-x86_64-linux-$VERSION /usr/local/lib/zig
buildah run $ctr -- ln -s /usr/local/lib/zig/zig /usr/local/bin/zig 

echo "stage 5: --cleaning filesystem--"
rm "$mnt/tmp/$TAR_FILENAME"
buildah run $ctr -- apt-get clean
buildah run $ctr -- rm /var/lib/apt/lists/* -rf

echo "stage 6: --user config--"
buildah run $ctr -- useradd -m -s /bin/bash user

echo "stage 7: --OCI config--"
buildah config --author "neosnakex34 <francescojamesfanti@gmail.com>" $ctr
buildah config --os "linux" $ctr
buildah config --arch "amd64" $ctr
buildah config --env PATH="/usr/local/bin:$PATH" $ctr
buildah config --user "user" $ctr

buildah config --label "org.opencontainers.image.source=https://ziglang.org" $ctr
buildah config --label "org.opencontainers.image.version=$VERSION" $ctr
buildah config --entrypoint '["/bin/bash"]' $ctr

echo "stage 8: --image generation (commit)--"
buildah unmount $ctr
# new single clean layer with squash
buildah commit --squash $ctr $IMAGE_NAME:$VERSION

buildah tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest

buildah rm $ctr
echo "image is ready!"
