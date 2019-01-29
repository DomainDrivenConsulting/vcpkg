# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
include(CMakePackageConfigHelpers)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libodb-2.5.0-b.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://codesynthesis.com/~boris/tmp/odb/pre-release/b.3/libodb-2.5.0-b.3.tar.gz"
    FILENAME "libodb-2.5.0-b.3.tar.gz"
    SHA512 41dcb218aa2458033fa1e851fa91fa498840d9c9408374b87b9ef9dad8a28912a83d046c940894f0f39e3dd42c47cddd29e5033805cb73d4900a246dd61b71c3
)
vcpkg_extract_source_archive(${ARCHIVE})
file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
)
vcpkg_build_cmake()
vcpkg_install_cmake()
file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_libodbConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_libodbConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/odbConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/odb)
write_basic_package_version_file(${CURRENT_PACKAGES_DIR}/share/odb/odbConfigVersion.cmake
    VERSION 2.5.0
    COMPATIBILITY SameMajorVersion
)
# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb/copyright)

set(LIBODB_HEADER_PATH ${CURRENT_PACKAGES_DIR}/include/odb/details/export.hxx)
file(READ ${LIBODB_HEADER_PATH} LIBODB_HEADER)
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 1" LIBODB_HEADER ${LIBODB_HEADER})
else()
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 0" LIBODB_HEADER ${LIBODB_HEADER})
endif()
file(WRITE ${LIBODB_HEADER_PATH} "${LIBODB_HEADER}")

vcpkg_copy_pdbs()
