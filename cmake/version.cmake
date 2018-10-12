#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# SetProjectVersion(p_project_name p_version):
	# Setups version variables for ${p_project_name}:
		# ${p_project_name}_VERSION
		# ${p_project_name}_VERSION_MAJOR
		# ${p_project_name}_VERSION_MINOR
		# ${p_project_name}_VERSION_PATCH
	# Parameters:
		# p_project_name: The version variable's prefix.
		# p_version: should be formatted MAJOR.MINOR.PATCH
	# Options:
	# Usage:
		# SetProjectVersion(Jackal 1.0.0)
macro(SetProjectVersion p_project_name p_version)

	# Check version varaible's haven't been set already
	if(	DEFINED ${p_project_name}_VERSION OR
		DEFINED ${p_project_name}_VERSION_MAJOR OR
		DEFINED ${p_project_name}_VERSION_MINOR OR
		DEFINED ${p_project_name}_VERSION_PATCH)
		message(WARNING "SetProjectVersion(${p_project_name} ${p_version}): The project's version variables have already been set.")
	endif()

	# Parameter Check
	if(NOT ${p_version} MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$")
	
		message(FATAL_ERROR "SetDefaultInstallPrefix(p_project_name p_version): p_version=${p_version} is not formatted corrected. Expects '^([0-9]+)\\.([0-9]+)\\.([0-9]+)$\' ")
	
	endif()

	# setup global version variable
	set(${p_project_name}_VERSION ${p_version})

	# Major, minor and patch version strings
	string(REPLACE "." ";" VERSION_LIST ${${p_project_name}_VERSION})
	list(GET VERSION_LIST 0 ${p_project_name}_VERSION_MAJOR)
	list(GET VERSION_LIST 1 ${p_project_name}_VERSION_MINOR)
	list(GET VERSION_LIST 2 ${p_project_name}_VERSION_PATCH)

	# full version string (This is to confirm correct formatting)
	set(${p_project_name}_VERSION ${${p_project_name}_VERSION_MAJOR}.${${p_project_name}_VERSION_MINOR}.${${p_project_name}_VERSION_PATCH})
	message(STATUS "${p_project_name} Project version: ${${p_project_name}_VERSION}")
	
endmacro()

# SetProjectVersionFromFile(p_project_name p_version_file):
	# Setups version variables for ${p_project_name}:
		# ${p_project_name}_VERSION
		# ${p_project_name}_VERSION_MAJOR
		# ${p_project_name}_VERSION_MINOR
		# ${p_project_name}_VERSION_PATCH
	# Equivalent to SetProjectVersion, but reads the project version from a file.
	# Parameters:
		# p_project_name: The version variable's prefix.
		# p_version_file: must be an absolute path.
	# Options:
	# Usage:
		# SetProjectVersionFromFile(Jackal "${CMAKE_CURRENT_SOURCE_LIST}/version/VERSION")
macro(SetProjectVersionFromFile p_project_name p_version_file)

	# Check version variable's haven't been set already
	if(	DEFINED ${p_project_name}_VERSION OR
		DEFINED ${p_project_name}_VERSION_MAJOR OR
		DEFINED ${p_project_name}_VERSION_MINOR OR
		DEFINED ${p_project_name}_VERSION_PATCH)
		message(WARNING "SetProjectVersionFromFile(${p_project_name} ${p_version_file}): The project's version variables have already been set.")
	endif()

	# Check macro's variables aren't defined
	if(	DEFINED ${p_project_name}_VERSION_CC_SetProjectVersionFromFile)
		message(FATAL_ERROR "SetProjectVersionFromFile(${p_project_name} ${p_version_file}): Macro's internal variables overlap with external variables.")
	endif()
	
	if(NOT IS_ABSOLUTE "${p_version_file}")
	
		message(FATAL_ERROR "SetProjectVersionFromFile(p_project_name p_version_file): p_version_file must be an absolute path.")
	
	endif()

	# setup global version variables
	file(READ ${p_version_file} ${p_project_name}_VERSION_CC_SetProjectVersionFromFile)

	SetProjectVersion(${p_project_name} ${${p_project_name}_VERSION_CC_SetProjectVersionFromFile})

	# Undefine the macro's internal variables.
	unset(${p_project_name}_VERSION_CC_SetProjectVersionFromFile)
	
endmacro()