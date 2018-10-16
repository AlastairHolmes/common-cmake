#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# AddIncludeDirectoryToTarget(p_target_name p_directory):
	# Adds an include directory to the target. This function's primary function
	# is to warning the user if they do something that is likely incorrect.
	# Parameters:
		# p_target_name: must be the name of a target.
		# p_directory: must be an absolute path.
	# Options
		# INSTALL_INTERFACE (Optional) (See CMAKE documentation)
			# The equivalent to p_directory during installation.
			# This must be a relative path, relative to CMAKE_INSTALL_PREFIX.
		# SCOPE (Optional, Default PUBLIC) - PUBLIC or PRIVATE
			# Sets if the directory is public
	# Usage:
		# AddIncludeDirectoryToTarget(myLibrary "${CMAKE_CURRENT_SOURCE_DIR}" SCOPE "PUBLIC" INSTALL_INTERFACE "include/myLibrary")
function(AddIncludeDirectoryToTarget p_target_name p_directory)

	# Parameter Checks
	if(NOT TARGET "${p_target_name}")
		message(FATAL_ERROR "AddIncludeDirectoryToTarget('${p_target_name}' '${p_directory}'): A target with name ${p_target_name} doesn't exist.")
	endif()

	if(NOT IS_ABSOLUTE "${p_directory}")
		message(FATAL_ERROR "AddIncludeDirectoryToTarget('${p_target_name}' '${p_directory}'): p_directory='${p_directory}' is not an absolute path.")
	endif()
	
	# Parsing Arguments
	
	set(option_args "")
    set(one_value_args INSTALL_INTERFACE SCOPE)
    set(multi_value_args "")
	cmake_parse_arguments(AIDTT "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(DEFINED AIDTT_INSTALL_INTERFACE)
		if(IS_ABSOLUTE "${AIDTT_INSTALL_INTERFACE}")
			message(FATAL_ERROR "AddIncludeDirectoryToTarget('${p_target_name}' '${p_directory}'): INSTALL_INTERFACE='${AIDTT_INSTALL_INTERFACE}' option is not a relative path.")
		endif()
		set(AIDTT_INSTALL_INTERFACE "INTERFACE $<INSTALL_INTERFACE:${AIDTT_INSTALL_INTERFACE}>")
	else()
		set(AIDTT_INSTALL_INTERFACE "")
	endif()
	
	if(DEFINED AIDTT_SCOPE)
		if(NOT "${AIDTT_SCOPE}" MATCHES "^(PUBLIC)|(PRIVATE)$")
			message(FATAL_ERROR "AddIncludeDirectoryToTarget('${p_target_name}' '${p_directory}'): SCOPE option must be either PUBLIC, or PRIVATE.")
		endif()
	else()	
		set(AIDTT_SCOPE "PUBLIC")
	endif()

	if(("${AIDTT_SCOPE}" STREQUAL "PUBLIC") AND ("${AIDTT_INSTALL_INTERFACE}" STREQUAL ""))
		message(AUTHOR_WARNING "AddIncludeDirectoryToTarget('${p_target_name}' '${p_directory}'): If this target ${p_target_name} is intended to be installed, you should provide an INSTALL_INTERFACE for this include directory.")
	elseif(("${AIDTT_SCOPE}" STREQUAL "PRIVATE") AND (NOT "${AIDTT_INSTALL_INTERFACE}" STREQUAL ""))
		message(AUTHOR_WARNING "AddIncludeDirectoryToTarget('${p_target_name}' ${p_directory}'): Its doesn't make sense to have a PRIVATE include directory with an INSTALL_INTERFACE.")
	endif()
	
	# Add Include Directory
	
	get_target_property(target_type ${p_target_name} TYPE)
	
	if(("${target_type}" STREQUAL "INTERFACE_LIBRARY") AND ("${AIDTT_SCOPE}" STREQUAL "PUBLIC"))
	
		target_include_directories(${p_target_name} INTERFACE $<BUILD_INTERFACE:${p_directory}>
			${INSTALL_INTERFACE})

	elseif(NOT "${target_type}" STREQUAL "INTERFACE_LIBRARY")
	
		target_include_directories(${p_target_name} ${AIDTT_SCOPE} $<BUILD_INTERFACE:${p_directory}>
			${INSTALL_INTERFACE})
		
	endif()
	
endfunction()