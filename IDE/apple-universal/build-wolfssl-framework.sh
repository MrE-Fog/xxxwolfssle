#!/bin/bash
set -euxo pipefail

WOLFSSL_DIR=$(pwd)/../../
OUTDIR=$(pwd)/artifacts
LIPODIR=${OUTDIR}/lib
SDK_OUTPUT_DIR=${OUTDIR}/xcframework


ENABLE_FIPS="no"
CFLAGS_COMMON=""
CONF_OPTS_COMMON="--disable-shared --enable-static --enable-curl --enable-harden --enable-fips=${ENABLE_FIPS}"


rm -rf $OUTDIR
mkdir -p $LIPODIR
mkdir -p $SDK_OUTPUT_DIR


buildIOSSim()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-ios-simulator-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildIOS()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk iphoneos --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-ios-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildMacOS()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk macosx --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-macos-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildWatchOS()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk watchos --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-watchos-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildWatchOSSim()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk watchsimulator --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-watchos-simulator-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildTVOS()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=arm64
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk appletvos --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-tvos-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildTVOSSim()
{
    pushd .
    cd $WOLFSSL_DIR

	ARCH=$1
    HOST="${ARCH}-apple-darwin"
    SDK_ROOT=$(xcrun --sdk appletvsimulator --show-sdk-path)

    ./configure -prefix=${OUTDIR}/wolfssl-tvos-simulator-${ARCH} ${CONF_OPTS_COMMON} --host=${HOST} \
        CFLAGS="${CFLAGS_COMMON} -arch ${ARCH} -isysroot ${SDK_ROOT}"
    make -j
    make install

    popd
}

buildCatalyst()
{
    echo "TBD"
}

############################################################################################################################################
# IOS Simulator ############################################################################################################################
############################################################################################################################################
buildIOSSim arm64
buildIOSSim x86_64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-ios-simulator-x86_64/lib/libwolfssl.a" \
    "$OUTDIR/wolfssl-ios-simulator-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-ios-simulator.a

echo "Checking libraries"
xcrun -sdk iphonesimulator lipo -info $LIPODIR/libwolfssl-ios-simulator.a

############################################################################################################################################
# IOS ######################################################################################################################################
############################################################################################################################################
buildIOS arm64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-ios-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-ios.a

echo "Checking libraries"
xcrun -sdk iphoneos lipo -info $LIPODIR/libwolfssl-ios.a


############################################################################################################################################
# MacOS ####################################################################################################################################
############################################################################################################################################
buildMacOS arm64
buildMacOS x86_64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-macos-x86_64/lib/libwolfssl.a" \
    "$OUTDIR/wolfssl-macos-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-macos.a

echo "Checking libraries"
xcrun -sdk macosx lipo -info $LIPODIR/libwolfssl-macos.a


############################################################################################################################################
# tvOS Simulator ###########################################################################################################################
############################################################################################################################################
buildTVOSSim arm64
buildTVOSSim x86_64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-tvos-simulator-x86_64/lib/libwolfssl.a" \
    "$OUTDIR/wolfssl-tvos-simulator-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-tvos-simulator.a

echo "Checking libraries"
xcrun -sdk appletvsimulator lipo -info $LIPODIR/libwolfssl-tvos-simulator.a


############################################################################################################################################
# tvOS #####################################################################################################################################
############################################################################################################################################
buildTVOS arm64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-tvos-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-tvos.a

echo "Checking libraries"
xcrun -sdk appletvos lipo -info $LIPODIR/libwolfssl-tvos.a


############################################################################################################################################
# watchOS Simulator ########################################################################################################################
############################################################################################################################################
buildWatchOSSim arm64
buildWatchOSSim x86_64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-watchos-simulator-arm64/lib/libwolfssl.a" \
    "$OUTDIR/wolfssl-watchos-simulator-x86_64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-watchos-simulator.a

echo "Checking libraries"
xcrun -sdk watchsimulator lipo -info $LIPODIR/libwolfssl-watchos-simulator.a


############################################################################################################################################
# watchOS ##################################################################################################################################
############################################################################################################################################
buildWatchOS arm64

# Create universal binaries from architecture-specific static libraries
lipo \
    "$OUTDIR/wolfssl-watchos-arm64/lib/libwolfssl.a" \
    -create -output $LIPODIR/libwolfssl-watchos.a

echo "Checking libraries"
xcrun -sdk watchos lipo -info $LIPODIR/libwolfssl-watchos.a


############################################################################################################################################
# Catalyst #################################################################################################################################
############################################################################################################################################


############################################################################################################################################
#  ********** BUILD FRAMEWORK
############################################################################################################################################

xcodebuild -create-xcframework \
        -library ${LIPODIR}/libwolfssl-ios-simulator.a \
        -headers ${OUTDIR}/wolfssl-ios-simulator-arm64/include \
        -library ${LIPODIR}/libwolfssl-ios.a \
        -headers ${OUTDIR}/wolfssl-ios-arm64/include \
        -library ${LIPODIR}/libwolfssl-macos.a \
        -headers ${OUTDIR}/wolfssl-macos-arm64/include \
        -library ${LIPODIR}/libwolfssl-tvos.a \
        -headers ${OUTDIR}/wolfssl-tvos-arm64/include \
        -library ${LIPODIR}/libwolfssl-tvos-simulator.a \
        -headers ${OUTDIR}/wolfssl-tvos-simulator-arm64/include \
        -library ${LIPODIR}/libwolfssl-watchos.a \
        -headers ${OUTDIR}/wolfssl-watchos-arm64/include \
        -library ${LIPODIR}/libwolfssl-watchos-simulator.a \
        -headers ${OUTDIR}/wolfssl-watchos-simulator-arm64/include \
		-output ${SDK_OUTPUT_DIR}/libwolfssl.xcframework
