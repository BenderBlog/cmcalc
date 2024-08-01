#!/bin/bash

#===============================================================================
# Filename:  build_mpfr.sh
# Author:    Volodymyr Boichentsov
# Copyright: (c) Copyright 2015 3D4Medical.com
# Licence:   Only for 3D4Medical.com company needs
#===============================================================================

BUILD_IOS=
BUILD_OSX=

unknownParameter()
{
    if [[ -n $2 &&  $2 != "" ]]; then
        echo Unknown argument \"$2\" for parameter $1.
    else
        echo Unknown argument $1
    fi
    die
}

parseArgs()
{
    while [ "$1" != "" ]; do
        case $1 in

        	-ios)
                BUILD_IOS=1
                ;;

            -osx)
                BUILD_OSX=1
                ;;

            --min-ios-version)
                if [ -n $2 ]; then
                    SDKVERSION=$2
                    shift
                else
                    missingParameter $1
                fi
                ;;
			--min-macosx-version)
				if [ -n $2 ]; then
					SDKVERSION=$2
					shift
				else
					missingParameter $1
				fi
				;;


            *)
                unknownParameter $1
                ;;
        esac

        shift
    done
}

parseArgs $@

if [[ -z $BUILD_IOS && -z $BUILD_OSX ]]; then
	BUILD_IOS=1
fi

CURRENT=`pwd`
# if [ -d "${CURRENT}/mpfr/mpfrlib" ]; then
# 	exit
# fi

__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

MPFR_VERSION="4.2.1"

if [[ -z $SDKVERSION ]]; then
    SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`
fi

BITCODE_FLAGS=" -disable-llvm-optzns -O3"
if [ "${SDKVERSION}" == "9.0" ]; then
	BITCODE_FLAGS=""
fi

OSX_PLATFORM=`xcrun --sdk macosx --show-sdk-platform-path`
OSX_SDK=`xcrun --sdk macosx --show-sdk-path`

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SDK=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SDK=`xcrun --sdk iphonesimulator --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`


downloadMPFR()
{
    if [ ! -d "${CURRENT}/mpfr" ]; then
        echo "Downloading MPFR"
        curl -L -o "${CURRENT}/mpfr-${MPFR_VERSION}.tar.bz2" http://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.bz2
		tar xfj "mpfr-${MPFR_VERSION}.tar.bz2"
		mv mpfr-${MPFR_VERSION} mpfr
		rm "mpfr-${MPFR_VERSION}.tar.bz2"
    fi
}


build()
{
	ARCH=$1
	SDK=$2
	PLATFORM=$3
	ARGS=$4
	TYPE=$5
	POSTFIX=$6

	make clean &> "${CURRENT}/clean.log"
	make distclean &> "${CURRENT}/clean.log"

	export PATH="${PLATFORM}/Developer/usr/bin:${DEVELOPER}/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

	if [ -d "mpfrlib-${ARCH}-${TYPE}${POSTFIX}" ] ; then
		rm -rf "mpfrlib-${ARCH}-${TYPE}${POSTFIX}"
	fi

	mkdir "mpfrlib-${ARCH}-${TYPE}${POSTFIX}"

	EXTRAS="-arch ${ARCH}"
	if [ "${TYPE}" == "ios" ]; then
		EXTRAS="${EXTRAS} -miphoneos-version-min=${SDKVERSION} -fembed-bitcode -target ${ARCH}-apple-ios${SDKVERSION}${POSTFIX}"
	fi

	if [ "${TYPE}" == "osx" ]; then
        echo "macOS deployment target ${SDKVERSION}"
		EXTRAS="${EXTRAS} -mmacosx-version-min=${SDKVERSION} "
	fi

	if [ "${ARCH}" == "i386" ]; then
		EXTRAS="${EXTRAS} -m32"
	fi

	CFLAGS=" ${BITCODE_FLAGS} -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration ${EXTRAS} -fvisibility=hidden"

	GMP_LIB_PATH="${CURRENT}/../gmp/gmplib-${ARCH}-${TYPE}${POSTFIX}"
	GMP_PATH="${CURRENT}/../gmp"

	echo "Configuring for ${ARCH} ${TYPE}${POSTFIX}..."
	./configure  --prefix="${CURRENT}/mpfrlib-${ARCH}-${TYPE}${POSTFIX}" CC="${CLANG}  ${CFLAGS}" CPP="${CLANG} -E" --with-gmp="${GMP_LIB_PATH}" \
	--host=arm64-apple-darwin --enable-thread-safe --disable-decimal-float --disable-float128 --disable-shared --with-pic ${ARGS} &> "${CURRENT}/mpfrlib-${ARCH}-${TYPE}${POSTFIX}-configure.log"

	echo "Make in progress for ${ARCH} ${TYPE}${POSTFIX}..."
	make -j`sysctl -n hw.logicalcpu_max` &> "${CURRENT}/mpfrlib-${ARCH}-${TYPE}${POSTFIX}-build.log"

	echo "Install in progress for ${ARCH} ${TYPE}${POSTFIX}..."
	make install &> "${CURRENT}/mpfrlib-${ARCH}-${TYPE}-install.log"
}

downloadMPFR

cd mpfr
CURRENT=`pwd`

if [[ -n $BUILD_IOS ]]; then
#    build "armv7" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "ios"
	# build "armv7s" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "ios"
	build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "ios"
#    build "i386" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "" "ios"
	build "arm64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "" "ios" "-simulator"

	[ -d mpfrlib/ios ] || mkdir -p mpfrlib/ios
	cp -r "${CURRENT}/mpfrlib-arm64-ios/include" mpfrlib/include

#        "${CURRENT}/mpfrlib-armv7-ios/lib/libmpfr.a" 
#        "${CURRENT}/mpfrlib-i386-ios/lib/libmpfr.a" 
fi

if [[ -n $BUILD_OSX ]]; then
#    build "i386" "${OSX_SDK}" "${OSX_PLATFORM}" "" "osx"
	build "x86_64" "${OSX_SDK}" "${OSX_PLATFORM}" "" "osx"

	[ -d mpfrlib/osx ] || mkdir -p mpfrlib/osx
	cp -r "${CURRENT}/mpfrlib-x86_64-osx/include" mpfrlib/include

	echo "Creating Fat library"

    cp "${CURRENT}/mpfrlib-x86_64-osx/lib/libmpfr.a" "${CURRENT}/mpfrlib/osx/libmpfr.a"

#    lipo \
#        "${CURRENT}/mpfrlib-i386-osx/lib/libmpfr.a" \
#        "${CURRENT}/mpfrlib-x86_64-osx/lib/libmpfr.a" \
#        -create -output "${CURRENT}/mpfrlib/osx/libmpfr.a"
fi


echo "Done with MPFR!"
