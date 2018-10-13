
add_executable(EXE "")
AddTargetToGroup(EXE EXE)

find_package(SLIB REQUIRED)

target_link_libraries(EXE PUBLIC SLIB::SLIB)

install(TARGETS EXE EXPORT EXE
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	RUNTIME DESTINATION bin
	INCLUDES DESTINATION include)
	
AddIncludeDirectoryToTarget(EXE "${CMAKE_CURRENT_SOURCE_DIR}/.." SCOPE PRIVATE)

# Header Files

	#AddSourcesToTarget(SLIB
	#	GROUP "Header Files"
	#	SCOPE PRIVATE
	#	FILES "")

# Source Files

	AddSourcesToTarget(EXE
		GROUP "Source Files"
		SCOPE PRIVATE
		FILES
			"${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")