# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindBPG
# --------
#
# Find BPG
#
# Find the native BPG includes and library This module defines
#
# ::
#
#   BPG_INCLUDE_DIRS, where to find bpg.h, etc.
#   BPG_LIBRARIES, the libraries needed to use BPG.
#   BPG_DEFINITIONS, the definitions needed to use BPG.
#   BPG_FOUND, If false, do not try to use BPG.
#
# also defined, but not for general use are
#
# ::
#
#   BPG_LIBRARY, where to find the BPG library.

find_path(BPG_INCLUDE_DIR bpg.h PATH_SUFFIXES libbpg)

find_library(BPG_ENC_LIBRARY bpg_enc)
find_library(BPG_DEC_LIBRARY bpg_dec)
find_library(JCTVC jctvc)

if(NOT MSVC)
    if(NOT JCTVC)
        find_library(X265_8BIT x265_8bit)
        find_library(X265_10BIT x265_10bit)
        find_library(X265_12BIT x265_12bit)
        set(HEVC_LIBRARIES ${X265_8BIT} ${X265_10BIT} ${X265_12BIT} m pthread)
    else()
        set(HEVC_LIBRARIES ${JCTVC})
    endif()
    set(BPG_LIBRARY ${BPG_DEC_LIBRARY} ${BPG_ENC_LIBRARY} ${HEVC_LIBRARIES})
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(BPG DEFAULT_MSG BPG_LIBRARY BPG_INCLUDE_DIR)

if(BPG_FOUND)
    if(MSVC)
        string(REPLACE "lib " "lib;" BPG_LIBRARIES ${BPG_LIBRARY})
    else()
        set(BPG_LIBRARIES ${BPG_LIBRARY})
    endif()
    set(BPG_INCLUDE_DIRS ${BPG_INCLUDE_DIR})
    set(BPG_DEFINITIONS -D_BPG_API)
endif()

# Deprecated declarations.
set(NATIVE_BPG_INCLUDE_PATH ${BPG_INCLUDE_DIR})
if(BPG_LIBRARY)
    if(MSVC)
        get_filename_component(NATIVE_BPG_LIB_PATH ${BPG_LIBRARY} PATH)
    else()
        get_filename_component(NATIVE_BPG_LIB_PATH ${BPG_DEC_LIBRARY} PATH)
    endif()
endif()

mark_as_advanced(BPG_LIBRARY BPG_INCLUDE_DIR)
