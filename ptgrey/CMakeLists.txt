cmake_minimum_required(VERSION 2.8.3)
project(ptgrey)

set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_CXX_FLAGS "-std=c++11 -march=native ")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall -fPIC ")
## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  sensor_msgs
  std_msgs
  cv_bridge
  dji_sdk
#  sys_utils
)

find_package(Boost REQUIRED COMPONENTS filesystem program_options system)
include_directories(${Boost_INCLUDE_DIRS})

find_package(OpenCV REQUIRED)

string(ASCII 27 Esc)
set(ColourReset "${Esc}[m")
set(ColourBold  "${Esc}[1m")
set(Red         "${Esc}[31m")
set(Green       "${Esc}[32m")
set(Yellow      "${Esc}[33m")
set(Blue        "${Esc}[34m")
set(Magenta     "${Esc}[35m")
set(Cyan        "${Esc}[36m")
set(White       "${Esc}[37m")
set(BoldRed     "${Esc}[1;31m")
set(BoldGreen   "${Esc}[1;32m")
set(BoldYellow  "${Esc}[1;33m")
set(BoldBlue    "${Esc}[1;34m")
set(BoldMagenta "${Esc}[1;35m")
set(BoldCyan    "${Esc}[1;36m")
set(BoldWhite   "${Esc}[1;37m")

set(LIBUSB_1_INCLUDE_DIR
    /usr/local/include/libusb-1.0
)
message(STATUS "${Green}Found libusb.h: ${LIBUSB_1_INCLUDE_DIR}${ColourReset}")

set(LIBUSB_1_LIBRARY
    /usr/local/lib/libusb-1.0.so
)
message(STATUS "${Green}Found libusb 1.0 library: ${LIBUSB_1_LIBRARY}${ColourReset}")

if (LIBUSB_1_INCLUDE_DIR AND LIBUSB_1_LIBRARY)
   set(LIBUSB_1_FOUND TRUE)
   set(LIBUSB_1_LIBRARIES ${LIBUSB_1_LIBRARY})
else (LIBUSB_1_INCLUDE_DIR AND LIBUSB_1_LIBRARY)
   set(LIBUSB_1_FOUND FALSE)
endif (LIBUSB_1_INCLUDE_DIR AND LIBUSB_1_LIBRARY)

if (LIBUSB_1_FOUND)
      message(STATUS "${Green}Found LibLIBUSB_1: ${LIBUSB_1_LIBRARIES}${ColourReset}")
else (LIBUSB_1_FOUND)
           message(STATUS "${Red}don't find LibLIBUSB_1${ColourReset}")
endif (LIBUSB_1_FOUND)

MARK_AS_ADVANCED(LIBUSB_1_INCLUDE_DIR LIBUSB_1_LIBRARIES LIBUSB_1_LIBRARY)

FIND_PATH(POINTGREY_INCLUDE_DIR FlyCapture2.h
    /usr/include/flycapture
    /usr/local/include/flycapture
)
message(STATUS "${Green}Found POINTGREYCamera: ${POINTGREY_INCLUDE_DIR}${ColourReset}")

FIND_LIBRARY(POINTGREY_LIBRARY NAMES libflycapture.so
   /usr/lib
)
message(STATUS "${Green}Found POINTGREYCamera library: ${POINTGREY_LIBRARY}${ColourReset}")

if (POINTGREY_INCLUDE_DIR AND POINTGREY_LIBRARY)
   set(POINTGREY_FOUND TRUE)
   set(POINTGREY_LIBRARIES ${POINTGREY_LIBRARY})
else (POINTGREY_INCLUDE_DIR AND POINTGREY_LIBRARY)
   set(POINTGREY_FOUND FALSE)
endif (POINTGREY_INCLUDE_DIR AND POINTGREY_LIBRARY)

if (POINTGREY_FOUND)
    message(STATUS "${Green}Found LibPOINTGREY: ${POINTGREY_LIBRARIES}")
    catkin_package(
      INCLUDE_DIRS
      LIBRARIES pointgrey
      CATKIN_DEPENDS roscpp sensor_msgs std_msgs
    #  DEPENDS system_lib
    )

    ###########
    ## Build ##
    ###########

    ## Specify additional locations of header files
    ## Your package locations should be listed before other locations
    # include_directories(include)
    include_directories(
      ${catkin_INCLUDE_DIRS}
    )


    add_executable(single_reader    src/single_reader.cc    src/ptgrey_lib/singleCamera.cpp    src/ptgrey_lib/singleCameraReader.cpp  src/preprocess/process.cc)
    target_link_libraries( single_reader    ${catkin_LIBRARIES}    ${OpenCV_LIBS}    ${POINTGREY_LIBRARIES} ${LIBUSB_1_LIBRARIES} )

    add_library(ptgrey_reader  src/milti_reader.cc   src/ptgrey_lib/singleCameraReader.cpp  src/ptgrey_lib/multiCamera.cpp    src/ptgrey_lib/multiCameraReader.cpp  src/preprocess/process.cc src/ptgrey_lib/singleCamera.cpp)
    target_link_libraries(ptgrey_reader    ${catkin_LIBRARIES}    ${OpenCV_LIBS}    ${POINTGREY_LIBRARIES}    ${LIBUSB_1_LIBRARIES}  )

    add_executable(multi_reader    src/milti_reader.cc    src/ptgrey_lib/multiCamera.cpp    src/ptgrey_lib/multiCameraReader.cpp  src/ptgrey_lib/singleCamera.cpp src/preprocess/process.cc  )
    target_link_libraries( multi_reader   ${catkin_LIBRARIES}    ${OpenCV_LIBS}    ${POINTGREY_LIBRARIES}    ${LIBUSB_1_LIBRARIES}   )

    add_executable( camera_list    src/camera_list.cc)
    target_link_libraries( camera_list    ${catkin_LIBRARIES}    ${OpenCV_LIBS}    ${POINTGREY_LIBRARIES}    ${LIBUSB_1_LIBRARIES}   )
else (POINTGREY_FOUND)
    message(STATUS "${Red}don't find LibPOINTGREY${ColourReset}")
endif (POINTGREY_FOUND)

