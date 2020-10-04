cmake_minimum_required(VERSION 3.10)

project(live555 C CXX)

add_definitions(-DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -DBSD=1)

set(OUTPUT_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/prebuilt/${ANDROID_ABI}")
set(OUTPUT_LIB_DIR "${PROJECT_SOURCE_DIR}/prebuilt/${ANDROID_ABI}")

add_subdirectory(UsageEnvironment)
add_subdirectory(BasicUsageEnvironment)
add_subdirectory(groupsock)
add_subdirectory(liveMedia)