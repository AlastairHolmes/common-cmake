# PrintTargetType(p_target_name):
function(PrintTargetType p_target_name)
	get_target_property(target_type ${p_target_name} TYPE)
	message(STATUS "Target ${p_target_name} is of type ${target_type}.")
endfunction()

# Add_Library
	# Creates a Library Target named: ${p_target_name}
	# p_type must be STATIC, SHARED, MODULE, HEADERONLY
	# For HEADERONLY this creates a interface library and a custom target so the library will show up in
	# your IDE.
	# Options:
		# EXCLUDE_FROM_ALL (See CMake Documentation)
macro(AddLibrary p_target_name p_type)

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
	
	set(${p_target_name}_CC_CREATED TRUE)
	
	if(${p_type} STREQUAL "STATIC")
		add_library(${p_target_name} STATIC ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif(${p_type} STREQUAL "SHARED")
		add_library(${p_target_name} SHARED ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif(${p_type} STREQUAL "MODULE")
		add_library(${p_target_name} MODULE ${AddLibraryCC_EXCLUDE_FROM_ALL} "")
	elseif(${p_type} STREQUAL "HEADERONLY")
		add_library(${p_target_name} INTERFACE)	
		add_custom_target(${p_target_name}_ide ${AddLibraryCC_ALL})
	else()
		message(FATAL_ERROR "AddLibrary(p_target_name p_type): p_type must be STATIC, SHARED, MODULE, or HEADERONLY")
	endif()
	
endmacro()