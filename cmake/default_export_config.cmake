# @CC_ExportTargetGroup_UseDependencyFile@
# @CC_ExportTargetGroup_DependencyList@
# @CC_ExportTargetGroup_TargetGroupName@

include(CMakeFindDependencyMacro) # Include find_dependency() functionality (For Dependency File)
if(@CC_ExportTargetGroup_UseDependencyFile@)
	include("${CMAKE_CURRENT_LIST_DIR}/@CC_ExportTargetGroup_TargetGroupName@Dependencies.cmake") # Find All Target Dependencies
endif()
foreach(FOREACH_CCE_ELEMENT_DEPENDENCY @CC_ExportTargetGroup_DependencyList@)
	find_dependency(${FOREACH_CCE_ELEMENT_DEPENDENCY})
endforeach()
include("${CMAKE_CURRENT_LIST_DIR}/@CC_ExportTargetGroup_TargetGroupName@Targets.cmake") # Add All Targets