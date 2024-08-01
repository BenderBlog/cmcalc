#!/bin/bash

#===============================================================================
#  Filename:  build_mpc.sh
#  Created by Volodymyr Boichentsov on 18/09/2015.
#  Copyright © 2015 3D4Medical. All rights reserved.
#  Property of 3D4Medical.
#===============================================================================

#-emit-obj -fembed-bitcode -disable-llvm-optzns -O3

BUILD_IOS=

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


            --min-ios-version)
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

__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

MPC_VERSION="1.3.1"

if [[ -z $SDKVERSION ]]; then
    SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`
fi

OSX_PLATFORM=`xcrun --sdk macosx --show-sdk-platform-path`
OSX_SDK=`xcrun --sdk macosx --show-sdk-path`

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SDK=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SDK=`xcrun --sdk iphonesimulator --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`

downloadMPC()
{
    if [ ! -d "${CURRENT}/mpc" ]; then
        echo "Downloading MPC"
        curl -L -o "${CURRENT}/mpc-${MPC_VERSION}.tar.gz" http://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz
		tar xfj "mpc-${MPC_VERSION}.tar.gz"
		mv mpc-${MPC_VERSION} mpc
		rm "mpc-${MPC_VERSION}.tar.gz"
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

	if [ -d "mpclib-${ARCH}-${TYPE}${POSTFIX}" ] ; then
		rm -rf "mpclib-${ARCH}-${TYPE}${POSTFIX}"
	fi
	
	mkdir "mpclib-${ARCH}-${TYPE}${POSTFIX}"

	EXTRAS="-arch ${ARCH}"
	if [ "${TYPE}" == "ios" ]; then
		EXTRAS="${EXTRAS} -miphoneos-version-min=${SDKVERSION} -fembed-bitcode -target ${ARCH}-apple-ios${SDKVERSION}${POSTFIX}"
	fi

	if [ "${TYPE}" == "osx" ]; then
        echo "macOS deployment target ${SDKVERSION}"
		EXTRAS="$EXTRAS -mmacosx-version-min=${SDKVERSION} "
	fi

	if [ "${ARCH}" == "i386" ]; then
		EXTRAS="${EXTRAS} -m32"
	fi

	CFLAGS=" -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration ${EXTRAS} -fvisibility=hidden"

    GMP_LIB_PATH="${CURRENT}/../gmp/gmplib-${ARCH}-${TYPE}${POSTFIX}/lib"
    GMP_INCLUDE_PATH="${CURRENT}/../gmp/gmplib-${ARCH}-${TYPE}${POSTFIX}/include"
	MPFR_LIB_PATH="${CURRENT}/../mpfr/mpfrlib-${ARCH}-${TYPE}${POSTFIX}/lib"
    MPFR_INCLUDE_PATH="${CURRENT}/../mpfr/mpfrlib-${ARCH}-${TYPE}${POSTFIX}/include"

	echo "Configuring for ${ARCH} ${TYPE}${POSTFIX}..."
	./configure  --prefix="${CURRENT}/mpclib-${ARCH}-${TYPE}${POSTFIX}" CC="${CLANG}  ${CFLAGS}" CPP="${CLANG} -E" \
	--host=arm64-apple-ios --disable-shared \
    --with-mpfr-include=${MPFR_INCLUDE_PATH} \
    --with-mpfr-lib=${MPFR_LIB_PATH} \
    --with-gmp-include=${GMP_INCLUDE_PATH} \
    --with-gmp-lib=${GMP_LIB_PATH} --with-pic ${ARGS} &> "${CURRENT}/mpclib-${ARCH}-${TYPE}${POSTFIX}-configure.log"

	echo "Make in progress for ${ARCH} ${TYPE}${POSTFIX}..."
	make -j`sysctl -n hw.logicalcpu_max` &> "${CURRENT}/mpclib-${ARCH}-${TYPE}${POSTFIX}-build.log"
	echo "Install in progress for ${ARCH} ${TYPE}${POSTFIX}..."
	make install &> "${CURRENT}/mpclib-${ARCH}-${TYPE}${POSTFIX}-install.log"
	
	cp -r "${CURRENT}/mpclib-${ARCH}-${TYPE}${POSTFIX}/" "${CURRENT}/../mpclib-${ARCH}-${TYPE}${POSTFIX}/"
}

downloadMPC

cd mpc
CURRENT=`pwd`

echo "MPC $CURRENT"

if [[ -n $BUILD_IOS ]]; then
	build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "ios" ""
	build "arm64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "" "ios" "-simulator"
fi


echo "Done with MPC!"