cmake_minimum_required(VERSION 3.9)
project("BHL")

# include all the common-cmake functionality
find_package(common-cmake REQUIRED)

# Set the default install location.
SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR}/bin")

# Load the project version from a file 'VERSION'
SetProjectVersionFromFile(BHL ${CMAKE_CURRENT_LIST_DIR}/version/VERSION)

# Enable target groups for the Visual Studio IDE
EnableGroups()

# Add Libraries
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/src/BHL_Common")
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/src/BHL")

# Installs the project's targets
SetupExport("BHL")
InstallExport("BHL"
	NAMESPACE "BHL")