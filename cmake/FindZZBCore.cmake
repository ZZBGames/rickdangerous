# Copyright (c) 2016 ZZBGames
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

find_path(ZZBCore_INCLUDE_DIR zzbgames/core/Version.hpp PATH_SUFFIXES include
    PATHS ${ZZBCore_ROOT} $ENV{ZZBCore_ROOT} /usr/ /usr/local/)

# Check the version number
set(ZZBCore_VERSION_OK TRUE)
if (ZZBCore_FIND_VERSION AND ZZBCore_INCLUDE_DIR)
    set(ZZBCore_VERSION_HPP_INPUT "${ZZBCore_INCLUDE_DIR}/zzbgames/core/Version.hpp")
    file(READ "${ZZBCore_VERSION_HPP_INPUT}" ZZBCore_VERSION_HPP_CONTENTS)

    set(ZZBCore_VERSION_REGEX ".*#define ZZB_CORE_MAJOR_VERSION ([0-9]+).*#define ZZB_CORE_MINOR_VERSION ([0-9]+).*#define ZZB_CORE_PATCH_VERSION ([0-9]+).*")
    string(REGEX REPLACE ".*#define ZZB_CORE_MAJOR_VERSION ([0-9]+).*" "\\1" ZZB_CORE_MAJOR_VERSION "${ZZBCore_VERSION_HPP_CONTENTS}")
    string(REGEX REPLACE ".*#define ZZB_CORE_MINOR_VERSION ([0-9]+).*" "\\1" ZZB_CORE_MINOR_VERSION "${ZZBCore_VERSION_HPP_CONTENTS}")
    string(REGEX REPLACE ".*#define ZZB_CORE_PATCH_VERSION ([0-9]+).*" "\\1" ZZB_CORE_PATCH_VERSION "${ZZBCore_VERSION_HPP_CONTENTS}")
    set(ZZBCore_VERSION "${ZZB_CORE_MAJOR_VERSION}.${ZZB_CORE_MINOR_VERSION}.${ZZB_CORE_PATCH_VERSION}")

    if (ZZBCore_VERSION LESS ZZBCore_FIND_VERSION)
        set(ZZBCore_VERSION_OK FALSE)
    endif ()

    unset(ZZBCore_VERSION_HPP_CONTENTS)
    unset(ZZBCore_VERSION_REGEX)
    unset(ZZB_CORE_MAJOR_VERSION)
    unset(ZZB_CORE_MINOR_VERSION)
    unset(ZZB_CORE_PATCH_VERSION)
endif ()

# Find required components
set(ZZBCore_FOUND TRUE)
foreach (component ${ZZBCore_FIND_COMPONENTS})
    string(TOUPPER ${component} COMPONENT_UPPER)
    string(TOLOWER ${component} COMPONENT_LOWER)

    find_library(ZZBCore_${COMPONENT_UPPER}_LIBRARY zzb-${COMPONENT_LOWER} PATH_SUFFIXES lib64 lib
        PATHS ${ZZBCore_ROOT} $ENV{ZZBCore_ROOT} /usr/ /usr/local/)
    if (ZZBCore_${COMPONENT_UPPER}_LIBRARY)
        set(ZZBCore_${COMPONENT_UPPER}_FOUND TRUE)
        set(ZZBCore_LIBRARIES ${ZZBCore_LIBRARIES} "${ZZBCore_${COMPONENT_UPPER}_LIBRARY}")
    else ()
        set(ZZBCore_FOUND FALSE)
        set(ZZBCore_${COMPONENT_UPPER}_FOUND FALSE)
        set(ZZBCore_${COMPONENT_UPPER}_LIBRARY "")
        set(ZZBCore_MISSING_LIBRARIES ${ZZBCore_MISSING_LIBRARIES} "zzb-${COMPONENT_LOWER}")
    endif ()

    mark_as_advanced(ZZBCore_${COMPONENT_UPPER}_LIBRARY)

    unset(COMPONENT_UPPER)
    unset(COMPONENT_LOWER)
endforeach ()

if (NOT ZZBCore_VERSION_OK)
    set(ZZBCore_ERROR "Could NOT find ZZBGames (Core): version ${ZZBCore_VERSION} is too low (requested: ${ZZBCore_FIND_VERSION})")
    set(ZZBCore_FOUND FALSE)
elseif (NOT ZZBCore_FOUND)
    set(ZZBCore_ERROR "Could NOT find ZZBGames (Core): missing libraries (${ZZBCore_MISSING_LIBRARIES})")
endif ()

if (ZZBCore_FOUND)
    message(STATUS "Found ZZBGames (Core) ${ZZBCore_VERSION} in ${ZZBCore_INCLUDE_DIR}")
else ()
    if (ZZBCore_FIND_REQUIRED)
        message(FATAL_ERROR "${ZZBCore_ERROR}")
    elseif (NOT ZZBCore_FIND_QUIETLY)
        message(${ZZBCore_ERROR})
    endif ()
endif ()
