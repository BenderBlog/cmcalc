#!/bin/bash
if [$NDK_TOOLCHAIN == ""]; then
    echo "Please export NDK_TOOLCHAIN in your shell."
    exit 1
fi

declare -A platform=(["android-arm64"]="aarch64-linux-android" ["android-arm"]="armv7a-linux-androideabi" ["android-x64"]="x86_64-linux-android")
export LD="$NDK_TOOLCHAIN/bin/ld"
export RANLIB="$NDK_TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$NDK_TOOLCHAIN/bin/llvm-strip"
export AR="$NDK_TOOLCHAIN/bin/llvm-ar"

for i in "${!platform[@]}"; do
    echo $i
    echo "${platform[$i]}"
    export CC="$NDK_TOOLCHAIN/bin/${platform[$i]}21-clang"
    export AS=$CC
    export CXX="$NDK_TOOLCHAIN/bin/a${platform[$i]}-clang++"
    export CXXCPP="$NDK_TOOLCHAIN/bin/clang -E"
    flutter build apk --split-per-abi --target-platform=$i
done


