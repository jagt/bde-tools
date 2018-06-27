# No include guard - may be reloaded
include(bde_ufid)
bde_process_ufid()

bde_prefixed_override(ufid project_setup_install_opts)
function(ufid_project_setup_install_opts proj)
    bde_assert_no_extra_args()

    set(libPath "bin/so")
    if (${bde_ufid_is_64}) 
        string(APPEND libPath "/64")
    endif()

    bde_struct_create(
        installOpts
        BDE_INSTALL_OPTS_TYPE
            INCLUDE_DIR "include"
            ARCHIVE_DIR "${bde_install_lib_suffix}/${bde_install_ufid}"
            LIBRARY_DIR ${libPath}
            PKGCONFIG_DIR "${bde_install_lib_suffix}/pkgconfig"
            EXECUTABLE_DIR "bin/${bde_install_ufid}"  # todo: bitness?
    )

    bde_struct_set_field(${proj} INSTALL_OPTS ${installOpts})
endfunction()

bde_prefixed_override(ufid uor_setup_interface)
function(ufid_uor_setup_interface uor)
    uor_setup_interface_base(ufid_uor_setup_interface ${ARGV})
    bde_struct_get_field(interfaceTarget ${uor} INTERFACE_TARGET)
    bde_ufid_setup_flags(${interfaceTarget})
endfunction()

bde_override(package_group_initialize ufid_initialize_library)
bde_override(standalone_package_initialize ufid_initialize_library)
function(ufid_initialize_library retUor uorName)
    bde_assert_no_extra_args()

    bde_ufid_add_library(${uorName} "")
    bde_uor_initialize(uor ${uorName})

    bde_return(${uor})
endfunction()

bde_prefixed_override(ufid package_group_install)
function(ufid_package_group_install uor listFile installOpts)
    package_group_install_base(ufid_package_group_install ${ARGV})
    bde_create_ufid_symlink(${uor} ${installOpts})
endfunction()

bde_prefixed_override(ufid standalone_package_install)
function(ufid_standalone_package_install uor listFile installOpts)
    standalone_package_install_base(ufid_standalone_package_install ${ARGV})
    bde_create_ufid_symlink(${uor} ${installOpts})
endfunction()

function(bde_create_ufid_symlink uor installOpts)
    if(CMAKE_HOST_UNIX)
        bde_struct_get_field(uorTarget ${uor} TARGET)

        bde_struct_get_field(component ${installOpts} COMPONENT)
        bde_struct_get_field(archiveInstallDir ${installOpts} ARCHIVE_DIR)

        get_filename_component(symlinkDir ${archiveInstallDir} DIRECTORY)
        get_filename_component(symlinkRelativeTargetDir ${archiveInstallDir} NAME)

        # This code will create a symlink to a corresponding "ufid" build.
        # Use with care.
        set(
            libName
            "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}${CMAKE_STATIC_LIBRARY_SUFFIX}"
        )
        set(symlinkVal "${symlinkRelativeTargetDir}/${libName}")

        set(
            libLinkName
            "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}.${bde_install_ufid}${CMAKE_STATIC_LIBRARY_SUFFIX}"
        )
        set(
            symlinkFile
            "\${CMAKE_INSTALL_PREFIX}/${symlinkDir}/${libLinkName}"
        )

        install(
            CODE
                "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \
                ${symlinkVal} ${symlinkFile})"
            COMPONENT "${component}-symlinks"
            EXCLUDE_FROM_ALL
        )

        # This code creates compatibility symlinks
        # WARNING: This is custom logic that has nothing to do with our build system.
        # Some external build systems expect to find a variaty of ufids in dpkg.
        string(REGEX MATCHALL "[^-_]+" install_ufid_flags "${bde_install_ufid}")

        if (${bde_ufid_is_64})
            bde_ufid_add_flags(bde_alt_install_ufid "${install_ufid_flags}" "64")

            set(
                libLinkName
                "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}.${bde_alt_install_ufid}${CMAKE_STATIC_LIBRARY_SUFFIX}"
            )

            set(
                symlinkFile
                "\${CMAKE_INSTALL_PREFIX}/${symlinkDir}/${libLinkName}"
            )

            # IMPORTANT: symlinkFile is the same as above!
            install(
                CODE
                    "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \
                    ${symlinkVal} ${symlinkFile})"
                COMPONENT "${component}-symlinks"
                EXCLUDE_FROM_ALL
            )
        endif()

        # The case when the build system add the PIC flag silently, we create
        # the symlink containing "pic".
        if (${bde_ufid_is_pic} AND (NOT pic IN_LIST install_ufid_flags))
            bde_ufid_add_flags(bde_alt_install_ufid "${install_ufid_flags}" "pic")

            set(
                libLinkName
                "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}.${bde_alt_install_ufid}${CMAKE_STATIC_LIBRARY_SUFFIX}"
            )

            set(
                symlinkFile
                "\${CMAKE_INSTALL_PREFIX}/${symlinkDir}/${libLinkName}"
            )

            # IMPORTANT: symlinkFile is the same as above!
            install(
                CODE
                    "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \
                    ${symlinkVal} ${symlinkFile})"
                COMPONENT "${component}-symlinks"
                EXCLUDE_FROM_ALL
            )

            # And another one with "64" AND "pic"
            if (${bde_ufid_is_64})
                bde_ufid_add_flags(bde_alt_install_ufid "${install_ufid_flags}" "64;pic")

                set(
                    libLinkName
                    "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}.${bde_alt_install_ufid}${CMAKE_STATIC_LIBRARY_SUFFIX}"
                )

                set(
                    symlinkFile
                    "\${CMAKE_INSTALL_PREFIX}/${symlinkDir}/${libLinkName}"
                )

                # IMPORTANT: symlinkFile is the same as above!
                install(
                    CODE
                        "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \
                        ${symlinkVal} ${symlinkFile})"
                    COMPONENT "${component}-symlinks"
                    EXCLUDE_FROM_ALL
                )
            endif()
        endif()

        # This code creates so called "release" symlink to the library.
        set(
            libReleaseLinkName
            "${CMAKE_STATIC_LIBRARY_PREFIX}${uorTarget}${CMAKE_STATIC_LIBRARY_SUFFIX}"
        )
        set(
            symlinkReleaseFile
            "\${CMAKE_INSTALL_PREFIX}/${symlinkDir}/${libReleaseLinkName}"
        )
        install(
            CODE
                "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \
                ${symlinkVal} ${symlinkReleaseFile})"
            COMPONENT "${uorName}-release-symlink"
            EXCLUDE_FROM_ALL
        )
    endif()
endfunction()