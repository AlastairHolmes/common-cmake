#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# PrintTargetType(p_target_name):
	# Prints the internal target's type.
	# Parameters:
		# p_target_name: must be the name of a target.
	# Options:
	# Usage:
		# PrintTargetType(Boost)
function(PrintTargetType p_target_name)

	# Parameter Check
	if(NOT TARGET ${p_target_name})
		
		message(FATAL_ERROR "PrintTargetType(${p_target_name}): p_target_name='${p_target_name}' is not the name of an existing target.")
	
	endif()

	get_target_property(target_type ${p_target_name} TYPE)
	message(STATUS "Target ${p_target_name} is of type ${target_type}.")
	
endfunction()

# AddLibrary(p_target_name p_type):
	# Creates a Library Target named: ${p_target_name}
	# For HEADERONLY this creates an interface library and a custom target so the library will show up in
	# your IDE.
	# Parameters:
		# p_target_name: the name of the created library.
		# p_type: the type of the created library. Must be STATIC, SHARED, MODULE, or HEADERONLY.
	# Options:
		# EXCLUDE_FROM_ALL (Optional) (See CMake 'add_library' Documentation)
	# Usage:
		# AddLibrary(myLibrary HEADERONLY EXCLUDE_FROM_ALL)
macro(AddLibrary p_target_name p_type)

	# Parameter Checks
	if(TARGET ${p_target_name})
		message(FATAL_ERROR "AddLibrary(${p_target_name} ${p_type}): A target with name ${p_target_name} already exists.")
	endif()

	if(NOT "${p_type}" MATCHES "^(STATIC)|(SHARED)|(MODULE)|(HEADERONLY)$")
		message(FATAL_ERROR "AddLibrary(${p_target_name} ${p_type}): p_type=${p_type} is not STATIC, SHARED, MODULE, or HEADERONLY")
	endif()
	
	# Check macro's variables aren't defined
	if(	DEFINED AddLibraryCC_EXCLUDE_FROM_ALL OR
		DEFINED AddLibraryCC_ALL)
		message(FATAL_ERROR "AddLibrary(${p_target_name} ${p_type}): Macro's internal variables overlap with external variables.")
	endif()
	
	if(DEFINED ${p_target_name}_CC_CREATED)
		message(FATAL_ERROR "AddLibrary(${p_target_name} ${p_type}): ${p_target_name}_CC_CREATED has been defined. This variable is used for common-cmake's internal target tracking. You must not define this yourself.")
	endif()
	set(${p_target_name}_CC_CREATED TRUE)
	
	# Parsing Arguments
	set(option_args EXCLUDE_FROM_ALL)
    set(one_value_args "")
    set(multi_value_args "")
	cmake_parse_arguments(AddLibraryCC "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	if(${AddLibraryCC_EXCLUDE_FROM_ALL})
		set(AddLibraryCC_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
		set(AddLibraryCC_ALL "")
	else()
		set(AddLibraryCC_EXCLUDE_FROM_ALL "")
		set(AddLibraryCC_ALL "ALL")
	endif()
	
	if("${p_type}" STREQUAL "STATIC")
		add_library(${p_target_name} STATIC ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif("${p_type}" STREQUAL "SHARED")
		add_library(${p_target_name} SHARED ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif("${p_type}" STREQUAL "MODULE")
		add_library(${p_target_name} MODULE ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif("${p_type}" STREQUAL "HEADERONLY")
		add_library(${p_target_name} INTERFACE)	
		add_custom_target(${p_target_name}_ide ${AddLibraryCC_ALL} VERBATIM)
	else()
		message(FATAL_ERROR "AddLibrary(${p_target_name} ${p_type}): p_type=${p_type} is not STATIC, SHARED, MODULE, or HEADERONLY")
	endif()
	
	# Undefine the macro's internal variables.
	unset(AddLibraryCC_EXCLUDE_FROM_ALL)
	unset(AddLibraryCC_ALL)
	
endmacro()