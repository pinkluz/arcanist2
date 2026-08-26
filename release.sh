#!/bin/bash
# Builds release binaries for every supported platform. Keep the platform
# list and build flags in sync with .github/workflows/build.yml and
# release-assets.yml, which produce the same artifacts in CI.
set -euo pipefail

platforms=(
  "linux amd64"
  "linux arm64"
  "darwin amd64"
  "darwin arm64"
  "freebsd amd64"
  "openbsd amd64"
  "netbsd amd64"
)

releases="release/$(git describe --tags)"
mkdir -p "${releases}"

for platform in "${platforms[@]}"; do
  read -r goos goarch <<< "${platform}"
  out="${releases}/arc_${goos}_${goarch}"
  echo "building ${out}"
  CGO_ENABLED=0 GOOS="${goos}" GOARCH="${goarch}" \
    go build -trimpath -ldflags "-s -w" -o "${out}" ./cmd/arc
done
