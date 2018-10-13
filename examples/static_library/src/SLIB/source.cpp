/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018 Alastair Holmes. All rights reserved.
/////////////////////////////////////////////////////////////////////////

#include <SLIB\header.h>
#include <SLIB_Common\version.h>

namespace slib
{

	uint32_t get_major_version()
	{
		return SLIB_VERSION_MAJOR;
	}

	uint32_t get_minor_version()
	{
		return SLIB_VERSION_MINOR;
	}

	uint32_t get_patch_version()
	{
		return SLIB_VERSION_PATCH;
	}

}