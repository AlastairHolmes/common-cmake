#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# GenerateDoxygenDocumentation(p_documentation_target_name p_preconfig_doxyfile):
	# This function adds a target that generates doxygen documentation, using the Doxyfile 'p_preconfig_doxyfile'
	# This file is run through a configure_file() call with the @ONLY option set.
	# Note find_package(Doxygen) adds a function 'doxygen_add_docs' (See documentation for FindDoxygen), 'doxygen_add_docs'
	# maybe more appropiate for many cases, my function below provides a little extra flexibility (By allowing you to specify your own Doxyfile).
	# Parameters:
		# p_documentation_target_name: The name of the custom target that will be added by this function to generate the documentation.
		# p_preconfig_doxyfile: The doxygen configuration file. This file is run through a configure_file() call with the @ONLY option set, before being passed to Doxygen.
	# Options:
		# ALL (Optional)
			# Controls if the created target is added to the 'ALL' target. Is set, when the 'ALL' target is built the documentation will be generated.
		# REQUIRED (Optional)
			# If set will produce fatal error if is can't find a doxygen installation.
		# QUIET (Optional)
			# If set this function will only produce warnings (not fatal errors) in the case it can't find Doxygen. (see REQUIRED option)
	# Usage:
		# GenerateDoxygenDocumentation(Documentation "${CMAKE_CURRENT_LIST_DIR}/Doxy/Doxyfile.in" REQUIRED)
function(GenerateDoxygenDocumentation p_documentation_target_name p_preconfig_doxyfile)
	
	# Parsing Arguments

	set(option_args ALL REQUIRED QUIET)
    set(one_value_args "")
    set(multi_value_args "")
	cmake_parse_arguments(GenerateDoxygenCC "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(TARGET "${p_documentation_target_name}")
		message(FATAL_ERROR "GenerateDoxygenDocumentation('${p_documentation_target_name}' '${p_preconfig_doxyfile}'): A Target with name '${p_documentation_target_name}' already exists.")
	endif()
	
	if(NOT EXISTS "${p_preconfig_doxyfile}")
		message(FATAL_ERROR "GenerateDoxygenDocumentation('${p_documentation_target_name}' '${p_preconfig_doxyfile}'): File '${p_preconfig_doxyfile}' doesn't exist.")
	endif()

	find_package(Doxygen QUIET)

	if(DOXYGEN_FOUND)
	
		# configure doxygen
		configure_file("${p_preconfig_doxyfile}" "${CMAKE_CURRENT_BINARY_DIR}/${p_documentation_target_name}/Doxyfile" @ONLY)
		
		# add a target to generate API documentation with Doxygen
		if(${GenerateDoxygenCC_ALL})
		
			add_custom_target(${p_documentation_target_name} ALL
				"${DOXYGEN_EXECUTABLE}" "${CMAKE_CURRENT_BINARY_DIR}/${p_documentation_target_name}/Doxyfile"
				WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${p_documentation_target_name}"
				COMMENT "Generating '${p_documentation_target_name}' documentation with Doxygen" VERBATIM)
		else()
		
			add_custom_target(${p_documentation_target_name}
				"${DOXYGEN_EXECUTABLE}" "${CMAKE_CURRENT_BINARY_DIR}/${p_documentation_target_name}/Doxyfile"
				WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${p_documentation_target_name}"
				COMMENT "Generating '${p_documentation_target_name}' documentation with Doxygen" VERBATIM)
		
		endif()
	  
	elseif(NOT ${GenerateDoxygenCC_QUIET}) 
		if(${GenerateDoxygenCC_REQUIRED})
			message(FATAL_ERROR "GenerateDoxygenDocumentation('${p_documentation_target_name}' '${p_preconfig_doxyfile}'): Could not find Doxygen.")
		else()
			message(WARNING "Doxygen documentation target wasn't added as Doxygen could not be found.")
		endif()
	endif()
	
endfunction()