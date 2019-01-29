include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libodb-boost-2.5.0-b.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://codesynthesis.com/~boris/tmp/odb/pre-release/b.3/libodb-boost-2.5.0-b.3.tar.gz"
    FILENAME "libodb-boost-2.5.0-b.3.tar.gz"
    SHA512 093da7a07252dec89e08cdb80664a575f3efebfbab11f9e7fcac8c81565996a32b88f10009baefabbff3c689015b84eddddeece5a19bbe5765d0f56fdd8fd829
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

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_boostConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_boostConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb-boost)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb-boost/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb-boost/copyright)
vcpkg_copy_pdbs()
