# Common CMake
A set of macros and functions to make using CMake easier. These are primarily focused on correctly and simply exporting/installing targets. This set of utilities is not intended to cover all cases, but simply avoid duplicating code in common cases. These utilities do not depend on each other, meaning these functions can be mixed with 'raw' CMake and still function correctly; for example, an export can contain your own targets that you manually create, and the SetupExport and InstallExport functions will still function correctly.

## Examples

There are a set of explained examples included in this project to demonstrate usage, in the 'examples' subdirectory. The example below shows how little code is required to correctly export a static library:

```
cmake_minimum_required(VERSION 3.9)
project("SLIB")

find_package(common-cmake REQUIRED)

SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR}/bin")

SetProjectVersionFromFile(SLIB ${CMAKE_CURRENT_LIST_DIR}/version/VERSION)

EnableGroups()

AddLibrary(SLIB STATIC)
AddTargetToGroup(SLIB SLIB)

find_package(BHL CONFIG REQUIRED)

target_link_libraries(SLIB PUBLIC BHL::BHL)

install(TARGETS SLIB EXPORT SLIB
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	RUNTIME DESTINATION bin
	INCLUDES DESTINATION include)

AddIncludeDirectoryToTarget(SLIB "${CMAKE_CURRENT_SOURCE_DIR}/.." INSTALL_INTERFACE "include")

# Header Files

	set(SLIBFiles
		"${CMAKE_CURRENT_SOURCE_DIR}/header.h")
	AddSourcesToTarget(SLIB
		GROUP "Header Files"
		SCOPE PRIVATE
		FILES ${SLIBFiles})
	install(FILES ${SLIBFiles} DESTINATION "include/SLIB")
	
# Source Files

	AddSourcesToTarget(SLIB
		GROUP "Source Files"
		SCOPE PRIVATE
		FILES
			"${CMAKE_CURRENT_SOURCE_DIR}/source.cpp")
			
SetupExport("SLIB" DEPENDENCIES "BHL CONFIG REQUIRED")
InstallExport("SLIB"
	NAMESPACE "SLIB")
			
```
			
## General Guidelines

Even if you don't use any of my utilities, here are some guidelines I have found useful:

- Split your CMake code into seperate cmakelists files, particularly try to have each target in seperate cmakelists file. (See Examples)
- Try to avoid the usage of variables. While often required, if not required you are simply making the code harder to read.
- KISS (Keep It Simple Stupid).
- Wrap up duplicate code as macros or functions. If you have a project with multiple targets its likely you will have some duplicate/similar code. For example, if you are storing a list of header files in a variable to avoid having to rewrite the list of header files each time you use it, those operations could be wrapped in a function instead. See in the above example how the usage of 'SLIBFiles' could be wrapped as some kind of 'AddPublicHeadersToTarget' function.
- Most importantly, use modern CMake practices:
	- [CppCon 2017 Presentation by Mathieu Ropert](https://www.youtube.com/watch?v=eC9-iRN2b04)
	- [C++Now 2017 Presenetation by Daniel Pfeifer](https://www.youtube.com/watch?v=bsXLMQ6WgIk)
	- [Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
	- [Effective Modern CMake](https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1)
	- [Its time to do CMake right](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)
	- [Awesome CMake](https://github.com/onqtam/awesome-cmake)
- Use the CMake IDE, its much quicker. You generally don't want/need to be using the command-line. The only reason you want to be using the command-line to run CMake is if you are automating builds etc (I.e. A Python script that runs CMake).
	
## Usage

I personally include these utilties in my projects by using 'find_package' (To avoid hard-coded paths, and so I don't have duplicates of these utilities all over my system), but it is more sensible to use 'include(common.cmake)'.

## Documentation

The utilities are documented inplace inside the 'cmake' directory.

## Contents

- SetProjectVersion
- SetProjectVersionFromFile
- AddCMakeModulePath
- SetDefaultInstallPrefix
- PrintTargetType
- AddLibrary
- EnableGroups
- AddTargetToGroup
- AddIncludeDirectoryToTarget
- AddSourcesToTarget
- SetupExport
- InstallExport

## TODO:

- Use 'configure_package_config_file' internally.
- Remove DEPENDENCY_FILE option and rework as CONFIG_FILE option.
- Add Testing
- Improve argument error checking
- Expand usage of BUILD_TYPE_REGEX option to all relate functions/macros. (Useful for single-configuration generators) 
- Consider Export internal changes to support Export(PACKAGE) command.