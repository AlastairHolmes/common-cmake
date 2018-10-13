# Creates a library for the common functionlity of all the targets in this project
AddLibrary(Common HEADERONLY)
AddTargetToGroup(Common SLIB)

# Adds the library to the project's main export 'BHL'
install(TARGETS Common EXPORT SLIB
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	RUNTIME DESTINATION bin
	INCLUDES DESTINATION include)
	
# Adds the needed include include directories these are public by default, so
# targets linked with common will get them too.
# The INSTALL_INTERFACE option ensures external targets can correctly include the headers of 'common'
AddIncludeDirectoryToTarget(Common "${CMAKE_CURRENT_SOURCE_DIR}/.." INSTALL_INTERFACE "include")
AddIncludeDirectoryToTarget(Common "${CMAKE_CURRENT_BINARY_DIR}/.." INSTALL_INTERFACE "include")

# Header Files

	# Generate version.h Header
	configure_file(version.h.in version.h)

	set(commonFiles
		"${CMAKE_CURRENT_SOURCE_DIR}/version.h.in")

	set(generatedCommonFiles
		"${CMAKE_CURRENT_BINARY_DIR}/version.h")

	AddSourcesToTarget(Common
		GROUP "Header Files"
		SCOPE PRIVATE # PRIVATE here refers to the fact that the sources will not also be added to other targets that link to 'common' (Note PRIVATE is the default)
		FILES ${commonFiles})
		
	# Installs the header files so external projects can include them
	install(FILES ${generatedCommonFiles} DESTINATION "include/SLIB_Common")
	
# Source Files