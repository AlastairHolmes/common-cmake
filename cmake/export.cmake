#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

include(CMakeParseArguments)
include(CMakePackageConfigHelpers)

# This file is used to generate Config.cmake files.
set(CC_EXPORT_DEFAULT_CONFIG_FILE "${CMAKE_CURRENT_LIST_DIR}/default_export_config.cmake" CACHE INTERNAL "The template config.cmake file provided by common-cmake.")

# SetupExport: Prepares a target group for installing
	# This must called before calling InstallExport, and must only be called once for a particular INSTALL_POSTFIX
	# Options:
		# INSTALL_POSTFIX (Optional, Default Value: lib/cmake/${p_export_name})
			# Controls the directory to which target group is installed.
		# VERSION (Optional)
			# If specified will install a ${p_export_name}ConfigVersion.cmake file using the COMPATIBILITY specified
				# This allows the version to be checked when importing your target.
					# E.g. find_package(Project 1.0.5 REQUIRED)
						# If Project was installed using the VERSION option 1.0.4 and COMPATIBILITY was 'ExactVersion'
						# Then this find_package call would fail as the required version is different to the installed version.
		# COMPATIBILITY (Optional, must specific if VERSION is specified)
			# Can only be AnyNewerVersion, SameMajorVersion, or ExactVersion.
			# Controls if two versions are considered compatible by a find_package call.
		# DEPENDENCY_FILE (Optional)
			# This is an absolute path to a .cmake file that finds all the dependencies required by the targets in this target group.
		# DEPENDENCIES (Optional)
			# This is a list of dependencies required by the targets in this target group.
			# Each element in the list represents a call to find_dependency() and
			# can be used to add options to the call e.g. SetupExport(TargetGroupExample DEPENDENCIES "Boost 1.36.0 REQUIRED" "LUA")
				# This means the targets in the target group 'TargetGroupExample' depend on Boost and Lua, but only definitely needs Boost.
				# See CMake find_dependency() documentation.
			
function(SetupExport p_export_name)
	
	# Parsing Arguments
	
	set(option_args "")
    set(one_value_args INSTALL_POSTFIX VERSION COMPATIBILITY DEPENDENCY_FILE)
    set(multi_value_args DEPENDENCIES)
	cmake_parse_arguments(SetupExportCC "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	# Argument Checks
	
	if(NOT DEFINED SetupExportCC_INSTALL_POSTFIX)
		set(SetupExportCC_INSTALL_POSTFIX "lib/cmake/${p_export_name}")
	elseif(IS_ABSOLUTE "${SetupExportCC_INSTALL_POSTFIX}")
		message(FATAL_ERROR "SetupExport(p_export_name): INSTALL_POSTFIX option must be a relative path.")
	endif()
	
	if(DEFINED SetupExportCC_VERSION)
		if(NOT DEFINED SetupExportCC_COMPATIBILITY)
			message(FATAL_ERROR "SetupExport(p_export_name): If VERSION option is given, you must provide the COMPATIBILITY option.")
		elseif(NOT ${SetupExportCC_COMPATIBILITY} MATCHES "^(AnyNewerVersion)|(SameMajorVersion)|(ExactVersion)$")
			message(FATAL_ERROR "SetupExport(p_export_name): COMPATIBILITY must be AnyNewerVersion, SameMajorVersion, or ExactVersion.")
		endif()
	else()
		if(DEFINED SetupExportCC_COMPATIBILITY)
			message(AUTHOR_WARNING "SetupExport(p_export_name): If VERSION option is not provided, COMPATIBILITY option is ignored.")
		endif()
	endif()
	
	if(DEFINED SetupExportCC_DEPENDENCY_FILE)
		if((NOT IS_ABSOLUTE ${SetupExportCC_DEPENDENCY_FILE}) OR (NOT EXISTS ${SetupExportCC_DEPENDENCY_FILE}))
			message(FATAL_ERROR "SetupExport(p_export_name): DEPENDENCY_FILE must be an absolute path to an existing file.")
		endif()
		set(UseDependencyFile TRUE)
	elseif()
		set(UseDependencyFile FALSE)
	endif()
	
	if(DEFINED SetupExportCC_DEPENDENCIES)
		set(DependencyList "${SetupExportCC_DEPENDENCIES}")
	else()
		set(DependencyList "")
	endif()
	
	# Create ConfigVersion.cmake File
	
		# Only create ConfigVersion if VERSION option was set.
		
			if(DEFINED SetupExportCC_VERSION)
				
				# Create ConfigVersion.cmake File

					write_basic_package_version_file("${CMAKE_BINARY_DIR}/${SetupExportCC_INSTALL_POSTFIX}/${p_export_name}ConfigVersion.cmake"
						VERSION ${SetupExportCC_VERSION}
						COMPATIBILITY ${SetupExportCC_COMPATIBILITY})
			
			endif()
		
	# Create Dependencies.cmake File
	
		if(${CC_ExportTargetGroup_UseDependencyFile})
			configure_file("${p_dependencies_file}" "${CMAKE_BINARY_DIR}/${SetupExportCC_INSTALL_POSTFIX}/${p_export_name}Dependencies.cmake" @ONLY)
		endif()
		
	# Create Config.cmake File
	
		set(ExportName "${p_export_name}")
		configure_file("${CC_EXPORT_DEFAULT_CONFIG_FILE}" "${CMAKE_BINARY_DIR}/${SetupExportCC_INSTALL_POSTFIX}/${p_export_name}Config.cmake" @ONLY)
	
endfunction()

# InstallExport: Installs all the targets in the target group '${p_export_name}' to "${CMAKE_INSTALL_PREFIX}/${INSTALL_POSTFIX}"
	# You must call SetupExport will the same INSTALL_POSTFIX option before this function.
	# Options:
		# EXCLUDE_FROM_ALL - See CMake Install Documentation
		# NAMESPACE - See CMake Install Documentation
		# COMPONENT - See CMake Install Documentation
		# CONFIGURATIONS - See CMake Install Documentation
		# INSTALL_POSTFIX (Optional, Default Value: lib/cmake/${p_export_name})
			# Controls the directory to which target group is installed.		
function(InstallExport p_export_name)

	# Parsing Arguments

	set(option_args EXCLUDE_FROM_ALL)
    set(one_value_args INSTALL_POSTFIX NAMESPACE COMPONENT)
    set(multi_value_args CONFIGURATIONS)
	cmake_parse_arguments(InstallExportCC "${option_args}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	# Argument Checks
	
	if(InstallExportCC_EXCLUDE_FROM_ALL)
		set(InstallExportCC_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
	else()
		set(InstallExportCC_EXCLUDE_FROM_ALL "")
	endif()
	
	if(DEFINED InstallExportCC_NAMESPACE)
		set(InstallExportCC_NAMESPACE "NAMESPACE ${InstallExportCC_NAMESPACE}::")
	else()
		set(InstallExportCC_NAMESPACE "")
	endif()
	
	if(DEFINED InstallExportCC_COMPONENT)
		set(InstallExportCC_COMPONENT "COMPONENT ${InstallExportCC_COMPONENT}")
	else()
		set(InstallExportCC_COMPONENT "")
	endif()
	
	if(NOT DEFINED InstallExportCC_INSTALL_POSTFIX)
		set(InstallExportCC_INSTALL_POSTFIX "lib/cmake/${p_export_name}")
	elseif(IS_ABSOLUTE "${InstallExportCC_INSTALL_POSTFIX}")
		message(FATAL_ERROR "InstallExport(p_export_name): INSTALL_POSTFIX option must be a relative path.")
	endif()
	
	if(DEFINED InstallExportCC_CONFIGURATIONS)
		set(InstallExportCC_CONFIGURATIONS "CONFIGURATIONS ${InstallExportCC_CONFIGURATIONS}")
	else()
		set(InstallExportCC_CONFIGURATIONS "")
	endif()
	
	# Install ConfigVersion.cmake File

		install(FILES "${CMAKE_BINARY_DIR}/${InstallExportCC_INSTALL_POSTFIX}/${p_export_name}ConfigVersion.cmake"
			${InstallExportCC_CONFIGURATIONS}
			DESTINATION ${InstallExportCC_INSTALL_POSTFIX}
			${InstallExportCC_COMPONENT}
			${InstallExportCC_EXCLUDE_FROM_ALL}
			OPTIONAL
		)
	
	# Install Dependencies.cmake and Config.cmake
	
		# Check Setup Called
			if(NOT EXISTS "${CMAKE_BINARY_DIR}/${InstallExportCC_INSTALL_POSTFIX}/${p_export_name}Config.cmake") # Not Very Effective Check
				message(FATAL_ERROR "InstallExport(p_export_name): Must call SetupExport(p_export_name) with equal INSTALL_POSTFIX option before calling InstallExport(p_export_name).")
			endif()
	
		install(FILES "${CMAKE_BINARY_DIR}/${InstallExportCC_INSTALL_POSTFIX}/${p_export_name}Config.cmake"
			${InstallExportCC_CONFIGURATIONS}
			DESTINATION ${InstallExportCC_INSTALL_POSTFIX}
			${InstallExportCC_COMPONENT}
			${InstallExportCC_EXCLUDE_FROM_ALL}
		)
		
		install(FILES "${CMAKE_BINARY_DIR}/${InstallExportCC_INSTALL_POSTFIX}/${p_export_name}Dependencies.cmake"
			${InstallExportCC_CONFIGURATIONS}
			DESTINATION ${InstallExportCC_INSTALL_POSTFIX}
			${InstallExportCC_COMPONENT}
			${InstallExportCC_EXCLUDE_FROM_ALL}
			OPTIONAL
		)
	
	# Create Targets.cmake (and Install it)
	
		install(EXPORT "${p_export_name}"
			FILE "${p_export_name}Targets.cmake"
			${InstallExportCC_CONFIGURATIONS}
			${InstallExportCC_NAMESPACE}
			DESTINATION ${InstallExportCC_INSTALL_POSTFIX}
			${InstallExportCC_COMPONENT}
			${InstallExportCC_EXCLUDE_FROM_ALL}
		)
	
endfunction()