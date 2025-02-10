#!/bin/bash

# Copyright 2025 BenderBlog Rodriguez and contributors.
# SPDX-License-Identifier: Unlicense

# Thanks Deep Seek!

# Define variables
LIBQALCULATE_VERSION="5.5.0" # Change this to the desired version
LIBQALCULATE_FILE="libqalculate-${LIBQALCULATE_VERSION}.tar.gz"
LIBQALCULATE_URL="https://github.com/Qalculate/libqalculate/releases/download/v${LIBQALCULATE_VERSION}/${LIBQALCULATE_FILE}"
LIBQALCULATE_DIR="libqalculate-${LIBQALCULATE_VERSION}"

# Temp build directory
BUILD_DIR="$(pwd)/build"
IOS_SDK=$(xcrun --sdk iphoneos --show-sdk-path)
SIMULATOR_SDK=$(xcrun --sdk iphonesimulator --show-sdk-path)
MIN_IOS_VER=12

# CFLAGS
IOS_CFLAGS="-target arm-apple-ios$MIN_IOS_VER -arch arm64 -isysroot $IOS_SDK -miphoneos-version-min=$MIN_IOS_VER"
SIMULATOR_CFLAGS="-target x86_64-apple-ios$MIN_IOS_VER-simulator -arch x86_64 -isysroot $SIMULATOR_SDK -miphonesimulator-version-min=$MIN_IOS_VER"
SIMULATOR_ARM64_CFLAGS="-target arm-apple-ios$MIN_IOS_VER-simulator -arch arm64 -isysroot $SIMULATOR_SDK -miphonesimulator-version-min=$MIN_IOS_VER"

DEPS_DIR="$BUILD_DIR/deps"
NUM_CORES=$(sysctl -n hw.ncpu)

# Create build directory
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Function to download and extract tarballs
download_and_extract() {
    local url=$1
    local tarball=$(basename $url)
    local folder=$2

    if [ ! -e $tarball ]; then
        curl -LO $url
    fi

    if [ -d $folder ]; then
        rm -rf $folder
    fi
    
    tar -xzf $tarball
}

# Download and build dependencies
echo "Downloading and building dependencies..."

# Function to build a dependency for multiple architectures
build_dependency() {
    local name=$1
    local url=$2
    local configure_options=$3
    local build_dir=$4

    download_and_extract $url $build_dir
    cd $build_dir

    IOS_WITH=""
    SIMULATOR_WITH=""
    SIMULATOR_ARM_WITH=""

    if [ ! -z $5 ]; then
        echo "ADDON FOUND $with"
        IOS_WITH="--with-$5=$DEPS_DIR/ios"
        SIMULATOR_WITH="--with-$5=$DEPS_DIR/simulator"
        SIMULATOR_ARM_WITH="--with-$5=$DEPS_DIR/simulatorarm"
    fi

    # Build for iOS
    export CC=$(xcrun --sdk iphoneos --find clang)
    export CXX=$(xcrun --sdk iphoneos --find clang++)
    ./configure --host="arm64-apple-darwin" --prefix=$DEPS_DIR/ios --disable-shared --enable-static $configure_options $IOS_WITH CFLAGS="$IOS_CFLAGS" LDFLAGS="$IOS_CFLAGS"
    make -j$NUM_CORES
    make install
    make clean

    # Build for iOS Simulator (x86_64)
    export CC=$(xcrun --sdk iphonesimulator --find clang)
    export CXX=$(xcrun --sdk iphonesimulator --find clang++)
    ./configure --host="x86_64-apple-darwin" --prefix=$DEPS_DIR/simulator --disable-shared --enable-static $configure_options $SIMULATOR_WITH CFLAGS="$SIMULATOR_CFLAGS" LDFLAGS="$SIMULATOR_CFLAGS"
    make -j$NUM_CORES
    make install
    make clean

    # Build for iOS Simulator (arm64)
    ./configure --host="arm64-apple-darwin" --prefix=$DEPS_DIR/simulatorarm --disable-shared --enable-static $configure_options $SIMULATOR_ARM_WITH CFLAGS="$SIMULATOR_ARM64_CFLAGS" LDFLAGS="$SIMULATOR_ARM64_CFLAGS"
    make -j$NUM_CORES
    make install
    make clean

    cd ..
}

# GMP
echo "Building dependency GMP..."
build_dependency "GMP" "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz" "--disable-assembly" "gmp-6.2.1"

# MPFR
echo "Building dependency MPFR..."
build_dependency "MPFR" "https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz" "" "mpfr-4.2.1" "gmp"

# Following three libraries are provided by apple
# liblzma (XZ Utils)
#echo "Building dependency liblzma..."
#build_dependency "XZ Utils" "https://github.com/tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.gz" "" "xz-5.6.4"

# libxml2
#echo "Building dependency libxml..."
#build_dependency "libxml2" "https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.5.tar.xz" "--with-lzma=$DEPS_DIR/ios" "libxml2-2.13.5"

# iconv library
#echo "Building dependency iconv..."
#build_dependency "iconv" "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz" "" "libiconv-1.18"

# Download and extract libqalculate
download_and_extract $LIBQALCULATE_URL $LIBQALCULATE_DIR
cd $LIBQALCULATE_DIR

# Define Qalculate compile flags per platform
QALCULATE_IOS_CPPFLAGS="-I$DEPS_DIR/ios/include"
QALCULATE_IOS_LDFLAGS="-L$DEPS_DIR/ios/lib"

QALCULATE_SIMULATOR_CPPFLAGS="-I$DEPS_DIR/simulator/include"
QALCULATE_SIMULATOR_LDFLAGS="-L$DEPS_DIR/simulator/lib"

QALCULATE_SIMULATOR_ARM64_CPPFLAGS="-I$DEPS_DIR/simulatorarm/include"
QALCULATE_SIMULATOR_ARM64_LDFLAGS="-L$DEPS_DIR/simulatorarm/lib"

QALCULATE_PATTERN="--disable-shared --enable-static --without-icu --without-libcurl --without-gnuplot-call --without-libintl-prefix --enable-compiled-definitions --disable-textport --disable-unittests"

# Build for iOS
echo "Building for iOS..."
mkdir build
cd build
export CC=$(xcrun --sdk iphoneos --find clang)
export CXX=$(xcrun --sdk iphoneos --find clang++)
../configure --host="arm64-apple-darwin" --prefix="$DEPS_DIR/ios" $QALCULATE_PATTERN \
    CPPFLAGS="$IOS_CFLAGS $QALCULATE_IOS_CPPFLAGS" LDFLAGS="$IOS_CFLAGS $QALCULATE_IOS_LDFLAGS"
make -j$NUM_CORES
make install

# Build for iOS Simulator (x86_64)
cd ..
rm -rf build
mkdir build
cd build
echo "Building for iOS Simulator (x86_64)..."
export CC=$(xcrun --sdk iphonesimulator --find clang)
export CXX=$(xcrun --sdk iphonesimulator --find clang++)
../configure --host="x86_64-apple-darwin" --prefix="$DEPS_DIR/simulator" $QALCULATE_PATTERN \
    CPPFLAGS="$SIMULATOR_CFLAGS $QALCULATE_SIMULATOR_CPPFLAGS" LDFLAGS="$SIMULATOR_CFLAGS $QALCULATE_SIMULATOR_LDFLAGS"
make -j$NUM_CORES
make install

# Build for iOS Simulator (arm64)
cd ..
rm -rf build
mkdir build
cd build
echo "Building for iOS Simulator (arm64)..."
../configure --host="arm64-apple-darwin" --prefix="$DEPS_DIR/simulatorarm" $QALCULATE_PATTERN \
    CPPFLAGS="$SIMULATOR_ARM64_CFLAGS $QALCULATE_SIMULATOR_ARM64_CPPFLAGS" LDFLAGS="$SIMULATOR_ARM64_CFLAGS $QALCULATE_SIMULATOR_ARM64_LDFLAGS" 
make -j$NUM_CORES
make install

# Combine libraries into a single fat library
echo "Creating fat library..."
PLATFORM=("simulatorarm" "simulator" "ios")
for platform in "${PLATFORM[@]}"; do
    mkdir $BUILD_DIR/$platform
    libtool -static  "$DEPS_DIR/$platform/lib/libgmp.a" "$DEPS_DIR/$platform/lib/libmpfr.a" "$DEPS_DIR/$platform/lib/libqalculate.a" -o "$BUILD_DIR/$platform/libqalculate.a"
done
lipo -create $BUILD_DIR/simulatorarm/libqalculate.a $BUILD_DIR/simulator/libqalculate.a -output $BUILD_DIR/libqalculate.a

# Create module.modulemap
cat > $DEPS_DIR/ios/include/module.modulemap <<EOF
module LibQalculate {
    header "libqalculate/BuiltinFunctions.h"
    header "libqalculate/Calculator.h"
    header "libqalculate/DataSet.h"
    header "libqalculate/ExpressionItem.h"
    header "libqalculate/Function.h"
    header "libqalculate/MathStructure.h"
    header "libqalculate/Number.h"
    header "libqalculate/Prefix.h"
    header "libqalculate/QalculateDateTime.h"
    header "libqalculate/Unit.h"
    header "libqalculate/includes.h"
    header "libqalculate/qalculate.h"
    header "libqalculate/util.h"

    header "gmp.h"
    header "mpfr.h"

    export *
}
EOF

xcodebuild -create-xcframework \
-library $BUILD_DIR/libqalculate.a \
-headers $DEPS_DIR/ios/include/ \
-library $BUILD_DIR/$platform/libqalculate.a \
-headers $DEPS_DIR/ios/include/ \
-output $BUILD_DIR/../../LibQalculate.xcframework
