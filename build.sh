subdirs="liveMedia groupsock UsageEnvironment BasicUsageEnvironment"
lipo_subdirs="groupsock liveMedia UsageEnvironment BasicUsageEnvironment"
ios_archs="mac-catalyst iphoneos iphone-simulator"
tvos_archs="tvos tvos-simulator"

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

build_ios() {
    for arch in $ios_archs
    do
        ./genMakefiles $arch
        make clean
        make install PREFIX=./build-"$arch" -j12
    done
}

build_tvos() {
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

create_ios_libs() {
    for subdir in $lipo_subdirs
    do
        mkdir -p $subdir/build/$subdir/lib
        mkdir -p $subdir/build/$subdir/include
        cp -a $subdir/include/. $subdir/build/$subdir/include/
        lipo -create $subdir/build-iphoneos/lib/lib"$subdir".a $subdir/build-iphone-simulator/lib/lib"$subdir".a -output $subdir/build/$subdir/lib/lib"$subdir".a
    done
}

create_tvos_libs() {
    for subdir in $lipo_subdirs
    do
        mkdir -p $subdir/build/$subdir/lib
        mkdir -p $subdir/build/$subdir/include
        cp -a $subdir/include/. $subdir/build/$subdir/include/
        lipo -create $subdir/build-tvos/lib/lib"$subdir".a $subdir/build-tvos-simulator/lib/lib"$subdir".a -output $subdir/build/$subdir/lib/lib"$subdir".a
    done
}

build() {
    build_ios
    build_tvos
    create_xcframework
}

clean
build