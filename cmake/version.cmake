#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# SetProjectVersion: Setups version variables for ${p_project_name}:
	# ${p_project_name}_VERSION
	# ${p_project_name}_VERSION_MAJOR
	# ${p_project_name}_VERSION_MINOR
	# ${p_project_name}_VERSION_PATCH
macro(SetProjectVersion p_project_name p_version)

	if(NOT ${p_version} MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$")
	
		message(FATAL_ERROR "SetDefaultInstallPrefix(p_project_name p_version): p_version is not formatted corrected. Expects '^([0-9]+)\\.([0-9]+)\\.([0-9]+)$\' ")
	
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

# SetProjectVersionFromFile: Equivalent to SetProjectVersion, but reads the project version from a file.
	# VersionFile must be absolute path.
macro(SetProjectVersionFromFile p_project_name p_version_file)

	if(NOT IS_ABSOLUTE "${p_version_file}")
	
		message(FATAL_ERROR "SetProjectVersionFromFile(p_project_name p_version_file): p_version_file must be an absolute path.")
	
	endif()

	# setup global version variables
	file(READ ${p_version_file} ${p_project_name}_VERSION)

	SetProjectVersion(${p_project_name} ${${p_project_name}_VERSION})

endmacro()