#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# @UseDependencyFile@
# @DependencyList@
# @ExportName@

include(CMakeFindDependencyMacro) # Include find_dependency() functionality (For Dependency File)
if(@UseDependencyFile@)
	include("${CMAKE_CURRENT_LIST_DIR}/@ExportName@Dependencies.cmake") # Find All Target Dependencies
endif()

@DependencyList@
include("${CMAKE_CURRENT_LIST_DIR}/@ExportName@Targets.cmake") # Add All Targets