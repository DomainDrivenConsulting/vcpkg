include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "git://git.codesynthesis.com/odb/libodb-boost.git"
    REF e6c9f749aea3b741bd3d35a2d14c92e8c3227bb7
    SHA512 6c9f031d1c23730a8ee6a4681da35d4ef846987162c0dd9ad887391442b24d4f1630f329392f8fb14b26f441988c3de562f3e74a41e27cf3b929b3cc23b5c747
)

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
