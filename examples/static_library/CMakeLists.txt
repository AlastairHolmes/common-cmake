cmake_minimum_required(VERSION 3.9)
project("SLIB")

# include all the common-cmake functionality
find_package(common-cmake REQUIRED)

# Set the default install location.
SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR}/bin")

# Load the project version from a file 'VERSION'
SetProjectVersionFromFile(SLIB ${CMAKE_CURRENT_LIST_DIR}/version/VERSION)

# Enable target groups for the Visual Studio IDE
EnableGroups()

# Add Libraries
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/src/SLIB_Common")
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/src/SLIB")

# Installs the project's targets
SetupExport("SLIB" DEPENDENCIES "BHL REQUIRED")
InstallExport("SLIB"
	NAMESPACE "SLIB")