cmake_minimum_required(VERSION 3.10)

project(BasicUsageEnvironment C CXX)

set(LIB_HEADERS
    include/BasicHashTable.hh
    include/DelayQueue.hh
    include/HandlerSet.hh
    include/BasicUsageEnvironment.hh
    include/BasicUsageEnvironment0.hh
    include/BasicUsageEnvironment_version.hh
)

set(LIB_SOURCES
    BasicHashTable.cpp  
    BasicTaskScheduler0.cpp  
    BasicTaskScheduler.cpp
    BasicUsageEnvironment0.cpp  
    BasicUsageEnvironment.cpp
    DelayQueue.cpp
)

set(LIB_INCLUDE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/include/"
)

message("${PROJECT_NAME} headers: ${LIB_HEADERS}")
message("${PROJECT_NAME} sources: ${LIB_SOURCES}")
message("${PROJECT_NAME} include dir: ${LIB_INCLUDE_DIR}")
message("${PROJECT_NAME} current dir: ${CMAKE_CURRENT_SOURCE_DIR}")
message("${PROJECT_NAME} source current dir: ${CMAKE_SOURCE_DIR}")

add_library(${PROJECT_NAME} OBJECT
    ${LIB_SOURCES}
    ${LIB_HEADERS}
)

# public headers
target_include_directories(${PROJECT_NAME} PUBLIC
    ${LIB_INCLUDE_DIR}
)

# private headers
target_include_directories(${PROJECT_NAME} PRIVATE
    ../UsageEnvironment/include
    ../groupsock/include
)

# public headers to be exported
set_target_properties(${PROJECT_NAME} 
    PROPERTIES PUBLIC_HEADER "${LIB_HEADERS}"
)

# target_link_libraries(${PROJECT_NAME}
#     UsageEnvironment
# )

# install(TARGETS ${PROJECT_NAME}
#     LIBRARY DESTINATION "${OUTPUT_LIB_DIR}/${PROJECT_NAME}"
#     ARCHIVE DESTINATION "${OUTPUT_LIB_DIR}/${PROJECT_NAME}"
#     PUBLIC_HEADER DESTINATION "${OUTPUT_INCLUDE_DIR}/${PROJECT_NAME}/include"
# )