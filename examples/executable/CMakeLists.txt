cmake_minimum_required(VERSION 3.9)
project("EXE")

# include all the common-cmake functionality
find_package(common-cmake REQUIRED)

# Set the default install location.
SetDefaultInstallPrefix("${CMAKE_SOURCE_DIR}/bin")

# Load the project version from a file 'VERSION'
SetProjectVersionFromFile(EXE ${CMAKE_CURRENT_LIST_DIR}/version/VERSION)

# Enable target groups for the Visual Studio IDE
EnableGroups()

# Add Executable
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/src/EXE")

# Installs the project's targets
SetupExport("EXE")
InstallExport("EXE")