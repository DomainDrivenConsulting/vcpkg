# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libodb-sqlite-2.5.0-b.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://codesynthesis.com/~boris/tmp/odb/pre-release/b.3/libodb-sqlite-2.5.0-b.3.tar.gz"
    FILENAME "libodb-sqlite-2.5.0-b.3.tar.gz"
    SHA512 6d49ecdae54ce480bfcc88a61c097a0cc8f370bccac78a0d16ae07246f8372185cdd0b5c62fffe293d366e96b0198bfd739d3f566f1ca3b3d508ce6759c60762
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

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_sqliteConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_sqliteConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb-sqlite)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb-sqlite/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb-sqlite/copyright)
vcpkg_copy_pdbs()
