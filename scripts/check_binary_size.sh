#!/usr/bin/env bash

set -e
set -o pipefail

# Generate stripped versions for every architecture
xcrun bitcode_strip ./$1 -r -o ./MapboxMobileEvents-stripped
strip -Sx ./MapboxMobileEvents-stripped
lipo ./MapboxMobileEvents-stripped -extract armv7 -output ./MapboxMobileEvents-stripped-armv7
lipo ./MapboxMobileEvents-stripped -extract arm64 -output ./MapboxMobileEvents-stripped-arm64
#lipo ./MapboxMobileEvents-stripped -extract x86_64 -output ./MapboxMobileEvents-stripped-x86_64

du -sh *
