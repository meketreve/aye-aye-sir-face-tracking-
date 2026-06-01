cmake_minimum_required(VERSION 3.16)

project(aye-aye-mask VERSION 0.1.0 LANGUAGES CXX)

# -----------------------------------------------------------------------------
# Build settings
# -----------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
endif()

# -----------------------------------------------------------------------------
# Sources
#   NOTE: extended milestone-by-milestone. M1 = no-op passthrough filter only.
# -----------------------------------------------------------------------------
set(PLUGIN_SOURCES
  src/plugin-main.cpp
  src/mask-filter.cpp
  src/frame-grab.cpp
  src/tracker.cpp
  src/pose.cpp
  src/mask-renderer.cpp
  src/smoothing.cpp
  src/headpose.cpp
  src/landmarks.cpp
)

add_library(${PROJECT_NAME} MODULE ${PLUGIN_SOURCES})
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_compile_definitions(${PROJECT_NAME} PRIVATE PLUGIN_VERSION="${PROJECT_VERSION}")

# -----------------------------------------------------------------------------
# libobs  (Ubuntu: provided by `libobs-dev`)
#   Prefer the CMake package config; fall back to pkg-config.
# -----------------------------------------------------------------------------
find_package(libobs QUIET)
if(libobs_FOUND)
  message(STATUS "aye-aye-mask: linking OBS::libobs (CMake package)")
  target_link_libraries(${PROJECT_NAME} PRIVATE OBS::libobs)
elseif(DEFINED LIBOBS_INCLUDE_DIR AND DEFINED LIBOBS_LIB)
  # Manual libobs (e.g. Windows CI: cloned headers + import lib from obs.dll).
  # LIBOBS_INCLUDE_DIR may be a ;-list of include dirs.
  message(STATUS "aye-aye-mask: manual libobs lib=${LIBOBS_LIB}")
  target_include_directories(${PROJECT_NAME} PRIVATE ${LIBOBS_INCLUDE_DIR})
  target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBOBS_LIB})
else()
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(LIBOBS REQUIRED IMPORTED_TARGET libobs)
  message(STATUS "aye-aye-mask: linking libobs ${LIBOBS_VERSION} (pkg-config)")
  target_link_libraries(${PROJECT_NAME} PRIVATE PkgConfig::LIBOBS)
endif()

# -----------------------------------------------------------------------------
# OpenCV  (Ubuntu: provided by `libopencv-dev`)
#   YuNet face detection (objdetect) + solvePnP (calib3d) + image ops.
# -----------------------------------------------------------------------------
find_package(OpenCV REQUIRED COMPONENTS core imgproc objdetect calib3d)
message(STATUS "aye-aye-mask: OpenCV ${OpenCV_VERSION}")
target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS})
target_include_directories(${PROJECT_NAME} PRIVATE ${OpenCV_INCLUDE_DIRS})

# -----------------------------------------------------------------------------
# onnxruntime  (head-pose net inference). Ubuntu: `libonnxruntime-dev`.
#   Prefer CMake package; fall back to pkg-config.
# -----------------------------------------------------------------------------
find_package(onnxruntime QUIET)
if(onnxruntime_FOUND)
  message(STATUS "aye-aye-mask: onnxruntime (CMake package)")
  target_link_libraries(${PROJECT_NAME} PRIVATE onnxruntime::onnxruntime)
elseif(DEFINED ORT_ROOT)
  # Prebuilt onnxruntime (Windows): <ORT_ROOT>/include + <ORT_ROOT>/lib.
  message(STATUS "aye-aye-mask: onnxruntime prebuilt at ${ORT_ROOT}")
  find_library(ORT_LIB NAMES onnxruntime PATHS "${ORT_ROOT}/lib" REQUIRED)
  target_include_directories(${PROJECT_NAME} PRIVATE "${ORT_ROOT}/include")
  target_link_libraries(${PROJECT_NAME} PRIVATE "${ORT_LIB}")
else()
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(ORT REQUIRED IMPORTED_TARGET libonnxruntime)
  message(STATUS "aye-aye-mask: onnxruntime ${ORT_VERSION} (pkg-config)")
  target_link_libraries(${PROJECT_NAME} PRIVATE PkgConfig::ORT)
endif()

# -----------------------------------------------------------------------------
# Install layout.
#   Linux (dev): per-user OBS plugin dir, so `cmake --install build` is enough.
#   Windows: OBS plugin tree relative to the install prefix, so
#            `cmake --install build --prefix package` produces a stageable tree
#            for the NSIS installer (see installer/).
# -----------------------------------------------------------------------------
if(WIN32)
  install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION "obs-plugins/64bit"
    LIBRARY DESTINATION "obs-plugins/64bit")
  install(DIRECTORY data/
    DESTINATION "data/obs-plugins/${PROJECT_NAME}")
else()
  if(NOT DEFINED OBS_PLUGIN_DESTINATION)
    set(OBS_PLUGIN_DESTINATION "$ENV{HOME}/.config/obs-studio/plugins/${PROJECT_NAME}")
  endif()
  install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION "${OBS_PLUGIN_DESTINATION}/bin/64bit")
  install(DIRECTORY data/
    DESTINATION "${OBS_PLUGIN_DESTINATION}/data")
endif()
