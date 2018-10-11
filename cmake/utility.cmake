# AddCMakeModulePath: Add Path to Module Search Path
macro(AddCMakeModulePath p_path)
	LIST(APPEND CMAKE_MODULE_PATH ${p_path})
endmacro()

# SetDefaultInstallPrefix: Sets the install prefix to 'DefaultPath' by default. Allows manual setting via the CMake GUI.
	# Usage: SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR/bin}")
	# DefaultPath must be absolute path.
macro(SetDefaultInstallPrefix p_default_path)

	if(NOT IS_ABSOLUTE "${p_default_path}")
	
		message(FATAL_ERROR "SetDefaultInstallPrefix(p_default_path): p_default_path must be an absolute path.")
	
	endif()

	if(NOT CMAKE_INSTALL_PREFIX_CC_DEFAULT)
	
		set(CMAKE_INSTALL_PREFIX "${p_default_path}" CACHE PATH "Install Path" FORCE)	
		set(CMAKE_INSTALL_PREFIX_CC_DEFAULT "TRUE" CACHE PATH "" FORCE)
		mark_as_advanced(CMAKE_INSTALL_PREFIX_CC_DEFAULT)

	endif()
	
endmacro()
