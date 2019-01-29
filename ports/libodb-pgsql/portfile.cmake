include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libodb-pgsql-2.5.0-b.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://codesynthesis.com/~boris/tmp/odb/pre-release/b.3/libodb-pgsql-2.5.0-b.3.tar.gz"
    FILENAME "libodb-pgsql-2.5.0-b.3.tar.gz"
    SHA512 f53f996805f362666e97d292245d5341088b2dd7ef503fd9642a64d7dd18379adc70b0d1be5b72fd4b4d28c56a097320e6aaa27c88839b7422fc9ee9d7c93b40
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

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_pgsqlConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_pgsqlConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql/copyright)
vcpkg_copy_pdbs()
