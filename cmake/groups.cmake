#########################################################################
## Copyright (c) 2018 Alastair Holmes. All rights reserved.
#########################################################################

# EnableGroups():
	# Allows the Source, Header, and File grouping functionality to work. E.g. In MSVC IDE the source and headers will be grouped as specified.
	# Call before using 'AddSourcesToTarget' or 'AddTargetToGroup'.
	# Parameters:
	# Options:
	# Usage:
		# EnableGroups()
macro(EnableGroups)
	set_property(GLOBAL PROPERTY USE_FOLDERS On)
endmacro()

# AddTargetToGroup(p_target_name p_group_name):
	# Easy grouping of targets in your IDE. Only works for the Visual Studio generator.
	# Parameters:
		# p_target_name: must be the name of an existing target.
		# p_group_name: the name which the target will be added to.
	# Options:
	# Usage:
		# AddTargetToGroup(myTarget myTargetGroup)
function(AddTargetToGroup p_target_name p_group_name)
	
	# Parameter Check
	if(NOT TARGET ${p_target_name})
		message(FATAL_ERROR "AddTargetToGroup(${p_target_name}): A target with name ${p_target_name} doesn't exist.")
	endif()
	
	get_target_property(target_type ${p_target_name} TYPE)
	
	if((${target_type} STREQUAL "INTERFACE_LIBRARY") AND ("${${target_type}_CC_CREATED}")) # HEADERONLY Library
		
		if(${${p_library_name}_CC_CREATED})
		
			set_target_properties(${p_target_name}_ide PROPERTIES FOLDER ${p_group_name})
			
		endif()
	
	else()
	
		set_target_properties(${p_target_name} PROPERTIES FOLDER ${p_group_name})
	
	endif()
		
endfunction()