#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd sox
patch -N -p1 --reject-file=- < ../sox-update-ffmpeg-api.patch
autoreconf --install --force --verbose

./configure \
        CFLAGS="-I$LOCAL/include -I$DESTDIR/mp3lame -march=armv7-a -mcpu=cortex-a8 -mfloat-abi=softfp -mfpu=neon" \
        LDFLAGS="-L$LOCAL/lib -L$DESTDIR/mp3lame -L$DESTDIR/x264 -Wl,--fix-cortex-a8" \
        LIBS="-lavformat -lavcodec -lavutil -lz -lx264" \
        CC="$CC" \
        LD="$LD" \
        STRIP="$STRIP" \
        --host=$HOST \
        --with-sysroot="$NDK_SYSROOT" \
        --enable-static \
        --disable-shared \
        --with-ffmpeg \
        --without-libltdl


popd; popd


