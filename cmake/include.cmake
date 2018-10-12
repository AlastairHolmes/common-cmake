#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# AddIncludeDirectoryToTarget(p_target_name p_directory):
	# Options
		# INSTALL_INTERFACE (Optional)
			# The equivalent to p_directory during installation.
			# This must be a relative path, relative to CMAKE_INSTALL_PREFIX.
			# See CMAKE documentation.
		# SCOPE (Optional, Default PUBLIC) - PUBLIC or PRIVATE
			# Sets if the directory is public
function(AddIncludeDirectoryToTarget p_target_name p_directory)

	# Parsing Arguments
	
	set(option_args "")
    set(one_value_args INSTALL_INTERFACE SCOPE)
    set(multi_value_args "")
	cmake_parse_arguments(AIDTT "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	if(DEFINED AIDTT_INSTALL_INTERFACE)
		set(AIDTT_INSTALL_INTERFACE "INTERFACE $<INSTALL_INTERFACE:${AIDTT_INSTALL_INTERFACE}>")
	else()
		set(AIDTT_INSTALL_INTERFACE "")
	endif()
	
	if(DEFINED AIDTT_SCOPE)
		if(NOT ${AIDTT_SCOPE} MATCHES "^(PUBLIC)|(PRIVATE)$")
			message(FATAL_ERROR "AddIncludeDirectoryToTarget(p_target_name p_directory): SCOPE option must be either PUBLIC, or PRIVATE.")
		endif()
	else()	
		set(AIDTT_SCOPE "PUBLIC")
	endif()

	if((${AIDTT_SCOPE} STREQUAL "PUBLIC") AND (${AIDTT_INSTALL_INTERFACE} STREQUAL ""))
		message(AUTHOR_WARNING "AddIncludeDirectoryToTarget(${p_target_name} ${p_directory}): If this target ${p_target_name} is intended to be installed, you should provide a INSTALL_INTERFACE for this include directory.")
	elseif((${AIDTT_SCOPE} STREQUAL "PRIVATE") AND (NOT ${AIDTT_INSTALL_INTERFACE} STREQUAL ""))
		message(AUTHOR_WARNING "AddIncludeDirectoryToTarget(${p_target_name} ${p_directory}): Its doesn't make sense to have a PRIVATE include directory with a INSTALL_INTERFACE.")
	endif()
	
	get_target_property(target_type ${p_target_name} TYPE)
	
	# Add Include Directories
	
	if((${target_type} STREQUAL "INTERFACE_LIBRARY") AND (${AIDTT_SCOPE} STREQUAL "PUBLIC"))
	
		target_include_directories(${p_target_name} INTERFACE $<BUILD_INTERFACE:${p_directory}>
			${INSTALL_INTERFACE})

	elseif(NOT ${target_type} STREQUAL "INTERFACE_LIBRARY")
	
		target_include_directories(${p_target_name} ${AIDTT_SCOPE} $<BUILD_INTERFACE:${p_directory}>
			${INSTALL_INTERFACE})
		
	endif()
	
endfunction()