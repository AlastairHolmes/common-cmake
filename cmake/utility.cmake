#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# AddCMakeModulePath(p_path):
	# Add Path to Module Search Path
	# Parameters:
		# p_path: must be an absolute path.
	# Options:
	# Usage:
		# AddCMakeModulePath("${CMAKE_SOURCE_DIR}/modules")
macro(AddCMakeModulePath p_path)

	# Parameter Check
	if(NOT IS_ABSOLUTE "${p_path}")
	
		message(FATAL_ERROR "AddCMakeModulePath(${p_path}): p_path='${p_path}' is not an absolute path.")
	
	endif()
	
	# Add path to CMAKE_MODULE_PATH	
	LIST(APPEND CMAKE_MODULE_PATH ${p_path})
	
endmacro()

# SetDefaultInstallPrefix(p_default_path):
	# Sets the install prefix to ${p_default_path} by default.
	# This default can be overridden manually. I.e. In the CMake GUI.
	# Parameters:
		# p_default_path: must be an absolute path.
	# Options:
	# Usage:
		# SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR}/bin")
macro(SetDefaultInstallPrefix p_default_path)

	# Parameter Checks
	if(NOT IS_ABSOLUTE "${p_default_path}")
	
		message(FATAL_ERROR "SetDefaultInstallPrefix(${p_default_path}): p_default_path='${p_default_path}' is not an absolute path.")
	
	endif()

	# CMAKE_INSTALL_PREFIX_CC_DEFAULT is defined and set TRUE if this code has run before.
		# In the case this code hasn't run we override the existing value, if the code has been run before we do nothing.
		# This allows the default value to be initially set and then later manually changed by a user.
	if(NOT CMAKE_INSTALL_PREFIX_CC_DEFAULT)
	
		set(CMAKE_INSTALL_PREFIX "${p_default_path}" CACHE PATH "Install Path" FORCE)	
		set(CMAKE_INSTALL_PREFIX_CC_DEFAULT "TRUE" CACHE PATH "" FORCE)
		mark_as_advanced(CMAKE_INSTALL_PREFIX_CC_DEFAULT)

	endif()
	
endmacro()
