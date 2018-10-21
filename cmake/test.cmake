#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

function(EnableTests)
	enable_testing()
endfunction()

macro(AddTestTarget p_target_name)

	# Parameter Checks
	if(TARGET ${p_target_name})
		message(FATAL_ERROR "AddTestTarget('${p_target_name}'): A target with name '${p_target_name}' already exists.")
	endif()

	# Parsing Arguments
	set(option_args AUTO)
    set(one_value_args WORKING_DIRECTORY)
    set(multi_value_args "")
	cmake_parse_arguments(AddTestTargetCC "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(NOT DEFINED AddTestTargetCC_WORKING_DIRECTORY)
		set(AddTestTargetCC_WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
	endif()
	
	add_executable(${p_target_name} "")	
	add_test(NAME "${p_target_name}"
		COMMAND "${p_target_name}"
		WORKING_DIRECTORY "${AddTestTargetCC_WORKING_DIRECTORY}")
	
	if(${AddTestTargetCC_AUTO})
		add_custom_command(TARGET ${p_target_name}
			POST_BUILD
			COMMAND ${p_target_name}
			WORKING_DIRECTORY "${AddTestTargetCC_WORKING_DIRECTORY}"
			COMMENT "Running test target: '${target}'." VERBATIM)
	endif()
	
endmacro()