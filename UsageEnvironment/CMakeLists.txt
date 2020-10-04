cmake_minimum_required(VERSION 3.10)

project(UsageEnvironment)

add_library(${PROJECT_NAME} SHARED
    HashTable.cpp  
    strDup.cpp  
    UsageEnvironment.cpp
)

file(GLOB_RECURSE INCLUDE_FILES "include/*.h*")

set(PUBLIC_INCLUDE_DIRECTORIES include/)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${PUBLIC_INCLUDE_DIRECTORIES}
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ../groupsock/include/
)

set_target_properties(${PROJECT_NAME} 
    PROPERTIES PUBLIC_HEADER "${INCLUDE_FILES}"
)

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION "${OUTPUT_LIB_DIR}/${PROJECT_NAME}"
    ARCHIVE DESTINATION "${OUTPUT_LIB_DIR}/${PROJECT_NAME}"
    PUBLIC_HEADER DESTINATION "${OUTPUT_INCLUDE_DIR}/${PROJECT_NAME}/include"
)