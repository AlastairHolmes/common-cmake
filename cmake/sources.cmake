#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# AddSourcesToTarget(p_target_name):
	# Adds sources to target, similiar to CMake's target_sources().
	# Parameters:
		# p_target_name: must be the name of a target.
	# Options:
		# FILES (NOT Optional)
			# A list of the files to add to the target
			# Note this can be a space-seperated list. (See 'Usage' below)
		# GROUP (Optional)
			# This uses the CMake source_group() function to group the files in your IDE.
		# SCOPE (Optional)
			# PUBLIC, INTERFACE, PRIVATE (See CMake 'target_sources' Documentation)
		# INSTALL_DESTINATION (Optional)
			# This is designed to be a quick and easy way to install public headers.
			# Must be a relative directory.
			# Example setting: 'INSTALL_DESTINATION "include"'
			# You can alternatively install them manually:
				#install(
				#	FILES
				#		"${FILES}"
				#	DESTINATION
				#		"${INSTALL_DESTINATION}"
				#	...)
				# This allows you to control the COMPONENT and CONFIGURATIONS options.
			# Note the sources/files will always be installed, even if the target isn't
				# But this is hard to avoid even if you manually install
	# Usage:
		# AddSourcesToTarget(myTarget
		#	GROUP "Headers" SCOPE "PUBLIC" INSTALL_DESTINATION "include/myTarget"
		#	FILES
		#		"${CMAKE_CURRENT_LIST_DIR}/header.h"
		#		"${CMAKE_CURRENT_LIST_DIR}/header.h")	
function(AddSourcesToTarget p_target_name)
	
	# Parameter Check
	if(NOT TARGET ${p_target_name})
		message(FATAL_ERROR "AddSourcesToTarget('${p_target_name}'): A target with name '${p_target_name}' doesn't exist.")
	endif()
	
	# Parsing Arguments

	set(option_args "")
	set(one_value_args GROUP SCOPE INSTALL_DESTINATION)
	set(multi_value_args FILES)
	cmake_parse_arguments(ASTT "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	# Argument Checks
	
	if(NOT DEFINED ASTT_FILES)
		message(FATAL_ERROR "AddSourcesToTarget('${p_target_name}'): Must provide FILES option to specify what files/sources to add to the target.")
	endif()
	
	if(DEFINED ASTT_GROUP)
		source_group("${ASTT_GROUP}" FILES ${ASTT_FILES})
	endif()
	
	if(NOT DEFINED ASTT_SCOPE)
		set(ASTT_SCOPE "PRIVATE")
	elseif(NOT "${ASTT_SCOPE}" MATCHES "^(PUBLIC)|(PRIVATE)|(INTERFACE)$")
		message(FATAL_ERROR "AddSourcesToTarget('${p_target_name}'): SCOPE='${ASTT_SCOPE}' option must be PUBLIC, PRIVATE, or INTERFACE.")
	endif()
	
	if((DEFINED ASTT_INSTALL_DESTINATION) AND (IS_ABSOLUTE "${ASTT_INSTALL_DESTINATION}"))
		message(FATAL_ERROR "AddSourcesToTarget('${p_target_name}'): INSTALL_DESTINATION='${ASTT_INSTALL_DESTINATION}' is not a relative path.")
	endif()
	
	# Check relative directory
	
	get_target_property(target_type ${p_target_name} TYPE)
	
	if(("${target_type}" STREQUAL "INTERFACE_LIBRARY") AND ("${${p_target_name}_CC_CREATED}")) # HEADERONLY Library
		
		if(TARGET "${p_target_name}_ide")
		
			set_property(TARGET ${p_target_name}_ide APPEND PROPERTY SOURCES ${ASTT_FILES})
	
		endif()
	
		if(("${ASTT_SCOPE}" STREQUAL "PUBLIC") OR ("${ASTT_SCOPE}" STREQUAL "INTERFACE"))
			
			target_sources(${p_target_name} INTERFACE ${ASTT_FILES})
			
		endif()
	
	else()
	
		target_sources(${p_target_name} "${ASTT_SCOPE}" ${ASTT_FILES})
	
	endif()
	
	if(DEFINED ASTT_INSTALL_DESTINATION)
			
		install(
			FILES
				${ASTT_FILES}
			DESTINATION
				"${ASTT_INSTALL_DESTINATION}"
		)
			
	endif()
	
endfunction()
