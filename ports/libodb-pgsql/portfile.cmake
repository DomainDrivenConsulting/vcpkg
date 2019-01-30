include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "git://git.codesynthesis.com/odb/libodb-pgsql.git"
    REF 41c0f00576a4c47281570d9815a755df362d4e55
    SHA512 0847138cfbd78c29e5829950f1f753ddfc509180f12d3aef82318c642e6afbe654ff3509cd78c5c6a2355ab3015935b5b6a3004a9a45762ff652b487bbf75999
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/options.ixx
  ${CMAKE_CURRENT_LIST_DIR}/options.hxx
  ${CMAKE_CURRENT_LIST_DIR}/options.cxx
  DESTINATION ${SOURCE_PATH}/odb/pgsql/details)

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
