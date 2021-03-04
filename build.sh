subdirs="liveMedia groupsock UsageEnvironment BasicUsageEnvironment"
lipo_subdirs="groupsock liveMedia UsageEnvironment BasicUsageEnvironment"
ios_archs="mac-catalyst iphoneos iphone-simulator"
tvos_archs="tvos tvos-simulator"
android_archs="armeabi-v7a arm64-v8a x86_64 x86"
android_api_level=21

clean() {
    for subdir in $subdirs
    do
        /bin/rm -rf $subdir/build
        /bin/rm -rf $subdir/build-*
        /bin/rm -rf $subdir.xcframework
        /bin/rm -rf frameworks/
    done

    find . -type f -name "*.o" -delete
}

build_ios_libs() {
    for arch in $ios_archs
    do
        ./genMakefiles $arch
        make clean
        make install PREFIX=./build-"$arch" -j12
    done
}

build_tvos_libs() {
    for arch in $tvos_archs
    do
        ./genMakefiles $arch
        make clean
        make install PREFIX=./build-"$arch" -j12   
    done
}

create_xcframework() {
    mkdir frameworks
    for subdir in $lipo_subdirs
    do
        xcodebuild -create-xcframework \
            -library "${subdir}/build-iphoneos/lib/lib${subdir}.a" -headers "${subdir}/build-iphoneos/include"\
            -library "${subdir}/build-iphone-simulator/lib/lib${subdir}.a" -headers "${subdir}/build-iphone-simulator/include"\
            -library "${subdir}/build-mac-catalyst/lib/lib${subdir}.a" -headers "${subdir}/build-mac-catalyst/include"\
            -library "${subdir}/build-tvos/lib/lib${subdir}.a" -headers "${subdir}/build-tvos/include"\
            -library "${subdir}/build-tvos-simulator/lib/lib${subdir}.a" -headers "${subdir}/build-tvos-simulator/include"\
            -output frameworks/$subdir.xcframework
    done
}

build_android() {
    rm -rf build
    rm -rf prebuilt
    for arch in $android_archs
    do
        build_dir=build/${arch}
        mkdir -p ${build_dir}
        cd ${build_dir}

        cmake ../../ \
                -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake" \
                -DANDROID_ABI=${arch} \
                -DANDROID_PLATFORM=${android_api_level} \
                -DCMAKE_BUILD_TYPE=RELEASE
        make install -j12

        cd -
    done
}

build_ios() {
    build_ios_libs
    build_tvos_libs
    create_xcframework
}


while [[ $# -gt 0 ]]
do
key="$1"

echo ${key}

case $key in
    --android)
    build_android
    shift # past argument
    shift # past value
    ;;
    --ios)
    build_ios
    shift # past argument
    shift # past value
    ;;
esac
done