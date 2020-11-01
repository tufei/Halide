# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindBPG
--------

Find the Better Portable Graphics (BPG) library (``libbpg``)

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` targets:

``BPG::BPG``
  The BPG library, if found.

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project:

``BPG_FOUND``
  If false, do not try to use BPG.
``BPG_INCLUDE_DIRS``
  where to find bpg.h, etc.
``BPG_LIBRARIES``
  the libraries needed to use BPG.
``BPG_DEFINITIONS``
  You should add_definitions(${BPG_DEFINITIONS}) before compiling code
  that includes bpg library files.
``BPG_VERSION``
  the version of the BPG library found

Cache variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``BPG_INCLUDE_DIRS``
  where to find bpg.h, etc.
``BPG_LIBRARY_RELEASE``
  where to find the BPG library (optimized).
``BPG_LIBRARY_DEBUG``
  where to find the BPG library (debug).

Obsolete variables
^^^^^^^^^^^^^^^^^^

``BPG_INCLUDE_DIR``
  where to find bpg.h, etc. (same as BPG_INCLUDE_DIRS)
``BPG_LIBRARY``
  where to find the BPG library.
#]=======================================================================]

find_path(BPG_INCLUDE_DIR bpg.h PATH_SUFFIXES libbpg)

set(bpg_enc_names ${BPG_ENC_NAMES} bpg_enc)
foreach(name ${bpg_enc_names})
  list(APPEND bpg_enc_names_debug "${name}d")
endforeach()

set(bpg_dec_names ${BPG_DEC_NAMES} bpg_dec)
foreach(name ${bpg_dec_names})
  list(APPEND bpg_dec_names_debug "${name}d")
endforeach()

set(jctvc_names jctvc)
foreach(name ${jctvc_names})
  list(APPEND jctvc_names_debug "${name}d")
endforeach()

set(x265_8b_names x265_8bit)
foreach(name ${x265_8b_names})
  list(APPEND x265_8b_names_debug "${name}d")
endforeach()

set(x265_10b_names x265_10bit)
foreach(name ${x265_10b_names})
  list(APPEND x265_10b_names_debug "${name}d")
endforeach()

set(x265_12b_names x265_12bit)
foreach(name ${x265_12b_names})
  list(APPEND x265_12b_names_debug "${name}d")
endforeach()

include(SelectLibraryConfigurations)
if(NOT BPG_LIBRARY)
  find_library(BPG_ENC_LIBRARY_RELEASE NAMES ${bpg_enc_names})
  find_library(BPG_ENC_LIBRARY_DEBUG NAMES ${bpg_enc_names_debug})
  select_library_configurations(BPG_ENC)
  mark_as_advanced(BPG_ENC_LIBRARY_RELEASE BPG_ENC_LIBRARY_DEBUG)

  find_library(BPG_DEC_LIBRARY_RELEASE NAMES ${bpg_dec_names})
  find_library(BPG_DEC_LIBRARY_DEBUG NAMES ${bpg_dec_names_debug})
  select_library_configurations(BPG_DEC)
  mark_as_advanced(BPG_DEC_LIBRARY_RELEASE BPG_DEC_LIBRARY_DEBUG)

  find_library(JCTVC_LIBRARY_RELEASE NAMES ${jctvc_names})
  find_library(JCTVC_LIBRARY_DEBUG NAMES ${jctvc_names_debug})
  select_library_configurations(JCTVC)
  mark_as_advanced(JCTVC_LIBRARY_RELEASE JCTVC_LIBRARY_DEBUG)

  if (NOT JCTVC_FOUND)
    find_library(X265_8BIT_LIBRARY_RELEASE NAMES ${x265_8b_names})
    find_library(X265_8BIT_LIBRARY_DEBUG NAMES ${x265_8b_names_debug})
    select_library_configurations(X265_8BIT)
    mark_as_advanced(X265_8BIT_LIBRARY_RELEASE X265_8BIT_LIBRARY_DEBUG)

    find_library(X265_10BIT_LIBRARY_RELEASE NAMES ${x265_10b_names})
    find_library(X265_10BIT_LIBRARY_DEBUG NAMES ${x265_10b_names_debug})
    select_library_configurations(X265_10BIT)
    mark_as_advanced(X265_10BIT_LIBRARY_RELEASE X265_10BIT_LIBRARY_DEBUG)

    find_library(X265_12BIT_LIBRARY_RELEASE NAMES ${x265_12b_names})
    find_library(X265_12BIT_LIBRARY_DEBUG NAMES ${x265_12b_names_debug})
    select_library_configurations(X265_12BIT)
    mark_as_advanced(X265_12BIT_LIBRARY_RELEASE X265_12BIT_LIBRARY_DEBUG)

    set(BPG_LIBRARY ${BPG_ENC_LIBRARY} ${BPG_DEC_LIBRARY} ${X265_8BIT_LIBRARY} ${X265_10BIT_LIBRARY} ${X265_12BIT_LIBRARY})
  else()
    set(BPG_LIBRARY ${BPG_ENC_LIBRARY} ${BPG_DEC_LIBRARY} ${JCTVC_LIBRARY})
  endif()
endif()

unset(bpg_enc_names)
unset(bpg_enc_names_debug)
unset(bpg_dec_names)
unset(bpg_dec_names_debug)
unset(jctvc_names)
unset(jctvc_names_debug)
unset(x265_8b_names)
unset(x265_8b_names_debug)
unset(x265_10b_names)
unset(x265_10b_names_debug)
unset(x265_12b_names)
unset(x265_12b_names_debug)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BPG
  REQUIRED_VARS BPG_LIBRARY BPG_INCLUDE_DIR
  VERSION_VAR BPG_VERSION)

if(BPG_FOUND)
  set(BPG_LIBRARIES ${BPG_LIBRARY})
  set(BPG_INCLUDE_DIRS "${BPG_INCLUDE_DIR}")
  set(BPG_DEFINITIONS _BPG_API)

  if(NOT TARGET BPG::BPG)
    add_library(BPG::BPG UNKNOWN IMPORTED)
    if(BPG_INCLUDE_DIRS)
      set_target_properties(BPG::BPG PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${BPG_INCLUDE_DIRS}")
    endif()
    if(BPG_DEFINITIONS)
      set_property(TARGET BPG::BPG APPEND PROPERTY
        COMPILE_DEFINITIONS "${BPG_DEFINITIONS}")
    endif()
    if(EXISTS "${BPG_ENC_LIBRARY}")
      set_target_properties(BPG::BPG PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${BPG_ENC_LIBRARY}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${BPG_DEC_LIBRARY}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_8BIT_LIBRARY}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_10BIT_LIBRARY}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_12BIT_LIBRARY}")
    endif()
    if(EXISTS "${BPG_ENC_LIBRARY_RELEASE}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(BPG::BPG PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
        IMPORTED_LOCATION_RELEASE "${BPG_ENC_LIBRARY_RELEASE}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${BPG_DEC_LIBRARY_RELEASE}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_8BIT_LIBRARY_RELEASE}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_10BIT_LIBRARY_RELEASE}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_12BIT_LIBRARY_RELEASE}")
    endif()
    if(EXISTS "${BPG_LIBRARY_DEBUG}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(BPG::BPG PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "C"
        IMPORTED_LOCATION_DEBUG "${BPG_LIBRARY_DEBUG}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${BPG_DEC_LIBRARY_DEBUG}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_8BIT_LIBRARY_DEBUG}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_10BIT_LIBRARY_DEBUG}")
      set_property(TARGET BPG::BPG APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${X265_12BIT_LIBRARY_DEBUG}")
    endif()

    set_property(TARGET BPG::BPG APPEND PROPERTY
      INTERFACE_LINK_LIBRARIES "m")
    set_property(TARGET BPG::BPG APPEND PROPERTY
      INTERFACE_LINK_LIBRARIES "pthread")
  endif()
endif()

mark_as_advanced(BPG_LIBRARY BPG_INCLUDE_DIR)
