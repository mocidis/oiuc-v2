cmake_minimum_required(VERSION 2.8.4)

project(oiuc)

#include(../cmake/mingw.cmake)
include(../cmake/darwin.cmake)
include(../cmake/utils.cmake)

find_package(Qt5Core REQUIRED)
find_package(Qt5Declarative REQUIRED)
find_package(Qt5Sql REQUIRED)

set(CMAKE_AUTORCC TRUE)

set(OIUC oiuc)

set(SRCS 
    ../group-man/src/node.c
    ../group-man/src/gb-receiver.c
    ../media-endpoint/src/endpoint.c
    ../concurrent_queue/src/queue.c 
    ../ics/src/ics-command.c 
    ../ics/src/ics.c
    ../ics/src/ics-event.c
    ../object-pool/src/object-pool.c
    ../common/src/ansi-utils.c
    ../common/src/my-pjmedia-utils.c 
    ../common/src/my-pjlib-utils.c)

set(QT_CLASSES 
    OIUC Config Log Radio RadioList OIU OIUList)
    
set(CPP_SRCS
    ./src/ctocpp.cpp 
    ./src/main.cpp 
	./src/backend.cpp)

set(MOC_HEADERS)

foreach(_CLASS ${QT_CLASSES})
    list(APPEND CPP_SRCS ./src/${_CLASS}.cpp)
    list(APPEND MOC_HEADERS ${PROJECT_SOURCE_DIR}/include/${_CLASS}.h)
endforeach()

qt5_wrap_cpp(MOCCED_FILES ${MOC_HEADERS})

set(GM_SRCS
    ${PROJECT_BINARY_DIR}/gen/gm-server.c 
    ${PROJECT_BINARY_DIR}/gen/gm-client.c)
set(GMC_SRCS
    ${PROJECT_BINARY_DIR}/gen/gmc-server.c 
    ${PROJECT_BINARY_DIR}/gen/gmc-client.c)
set(ADV_SRCS
    ${PROJECT_BINARY_DIR}/gen/adv-server.c 
    ${PROJECT_BINARY_DIR}/gen/adv-client.c)
set(GB_SRCS
    ${PROJECT_BINARY_DIR}/gen/gb-server.c
    ${PROJECT_BINARY_DIR}/gen/gb-client.c)

set(USERVER_DIR ${PROJECT_SOURCE_DIR}/../userver)
set(UGENTOOL ${USERVER_DIR}/gen-tools/gen.awk)

set(GM_U    ${PROJECT_SOURCE_DIR}/../group-man/protocols/gm-proto.u)
set(GMC_U   ${PROJECT_SOURCE_DIR}/../group-man/protocols/gmc-proto.u)
set(ADV_U   ${PROJECT_SOURCE_DIR}/../group-man/protocols/adv-proto.u)
set(GB_U    ${PROJECT_SOURCE_DIR}/../group-man/protocols/gb-proto.u)

add_custom_command(
    OUTPUT ${GM_SRCS}
    COMMAND mkdir -p gen
    COMMAND awk -f ${UGENTOOL} $< ${USERVER_DIR}
    DEPENDS ${GM_U}
)
add_custom_command(
    OUTPUT ${GMC_SRCS}
    COMMAND mkdir -p gen
    COMMAND awk -f ${UGENTOOL} $< ${USERVER_DIR}
    DEPENDS ${GMC_U}
)
add_custom_command(
    OUTPUT ${ADV_SRCS}
    COMMAND mkdir -p gen
    COMMAND awk -f ${UGENTOOL} $< ${USERVER_DIR}
    DEPENDS ${ADV_U}
)
add_custom_command(
    OUTPUT ${GB_SRCS}
    COMMAND mkdir -p gen
    COMMAND awk -f ${UGENTOOL} $< ${USERVER_DIR}
    DEPENDS ${GB_U}
)

add_executable(${OIUC} ${SRCS} ${GM_SRCS} ${ADV_SRCS} ${GMC_SRCS} ${GB_SRCS} ${CPP_SRCS} ${MOCCED_FILES} oiuc.qrc)

my_find_pjproject()

my_find_json_c()

set(oiuc_VERSION_MAJOR 1)
set(oiuc_VERSION_MINOR 1)
set(oiuc_VERSION_PATCH 0)
set(oiuc_VERSION "\"${oiuc_VERSION_MAJOR}.${oiuc_VERSION_MINOR}.${oiuc_VERSION_PATCH}\"")

add_definitions("-DAPP_VERSION=${oiuc_VERSION}")

add_definitions(${PJPROJECT_CFLAGS} ${JSON_C_CFLAGS})
add_definitions("-D__ICS_INTEL__")

include_directories(
    ${PROJECT_BINARY_DIR}
    ${PROJECT_BINARY_DIR}/gen
    include
    ../common/include
    ../object-pool/include
    ../concurrent_queue/include
    ../media-endpoint/include
    ../group-man/include
    ../ics/include
    ../libut/include
    ${PJPROJECT_INCLUDE_DIRS}
    ${JSON_C_INCLUDE_DIRS}
)

my_target_link_pjproject(${OIUC})

target_link_libraries(${OIUC} ${JSON_C_LDFLAGS})

#set(CMAKE_CXX_FLAGS "${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}")

include_directories(${Qt5Core_INCLUDES} ${Qt5Declarative_INCLUDES} ${Qt5Sql_INCLUDES})
#add_definitions(${Qt5Widgets_DEFINITIONS})
target_link_libraries(${OIUC} ${Qt5Core_LIBRARIES} ${Qt5Declarative_LIBRARIES} ${Qt5Sql_LIBRARIES})
