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

list(APPEND BPG_NAMES bpg_dec bpg_enc libbpg_dec libbpg_enc)
list(APPEND BPG_NAMES jctvc x265_8bit x265_10bit x265_12bit)
find_library(BPG_LIBRARY NAMES ${BPG_NAMES})

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
  get_filename_component(NATIVE_BPG_LIB_PATH ${BPG_LIBRARY} PATH)
endif()

mark_as_advanced(BPG_LIBRARY BPG_INCLUDE_DIR)
