# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "git://git.codesynthesis.com/odb/libodb-sqlite.git"
    REF 1722964fc477213f36c78272505eb09f6073bff4
    SHA512 eda436648c13d85c1249bc8d7b223e76f82c5133dbbb70d68649d8a8fb1b4ab1a244e9813703a039a430ca29a271d78e92b52f9424eaf03352e70e29c0391053
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/options.ixx
  ${CMAKE_CURRENT_LIST_DIR}/options.hxx
  ${CMAKE_CURRENT_LIST_DIR}/options.cxx
  DESTINATION ${SOURCE_PATH}/odb/sqlite/details)

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
