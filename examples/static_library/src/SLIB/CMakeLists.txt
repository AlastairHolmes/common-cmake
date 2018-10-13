# Create a library
AddLibrary(SLIB STATIC)
AddTargetToGroup(SLIB SLIB)

find_package(BHL REQUIRED)

# Link to BHL
target_link_libraries(SLIB PUBLIC BHL::BHL)

# Link to common
target_link_libraries(SLIB PUBLIC Common)

# Add the library to the export SLIB
# and specify the relative locations (relative to the install location)
# to put each of its components (LIBRARYs () in /lib, ARCHIVEs (.so/.lib) in /lib, RUNTIMEs (.dll, .exe), ...)
# Also INCLUDES DESTINATION adds INTERFACE include directories to the targets.
# (This isn't really needed as the AddIncludeDirectoryToTarget function does this automatically and will warn you
# if you don't)
install(TARGETS SLIB EXPORT SLIB
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	RUNTIME DESTINATION bin
	INCLUDES DESTINATION include)

# Add an include directory to the library and specify the equivalent directory once installed
# (Where the headers that were in "src/SLIB" are installed to i.e. "include/SLIB"
# (This installation of header files is done below by the install(FILES...) call))
	# Note how the install DESTINATION for the install(FILES...) call is the same as the INSTALL_INTERFACE option on this call.
AddIncludeDirectoryToTarget(SLIB "${CMAKE_CURRENT_SOURCE_DIR}/.." INSTALL_INTERFACE "include")

# Header Files

	set(SLIBFiles
		"${CMAKE_CURRENT_SOURCE_DIR}/header.h")
		
	# This call ensures the files will show up in the IDE.
	# As these are header files (.h) this is not needed (But is extremely helpful).
	# For source files (.cpp) you must do this so the compiler knows to compile those sources (.cpp files).
	AddSourcesToTarget(SLIB
		GROUP "Header Files"
		SCOPE PRIVATE # PRIVATE here refers to the fact that the sources will not also be added to other targets that link to 'BHL' (Note PRIVATE is the default)
		FILES ${SLIBFiles})
		
	# Installs the header files so external projects can include them
	install(FILES ${SLIBFiles} DESTINATION "include/SLIB")
	
# Source Files

	AddSourcesToTarget(SLIB
		GROUP "Source Files"
		SCOPE PRIVATE # PRIVATE here refers to the fact that the sources will not also be added to other targets that link to 'BHL' (Note PRIVATE is the default)
		FILES
			"${CMAKE_CURRENT_SOURCE_DIR}/source.cpp")