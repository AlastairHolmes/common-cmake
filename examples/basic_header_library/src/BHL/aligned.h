/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018 Alastair Holmes. All rights reserved.
/////////////////////////////////////////////////////////////////////////

#ifndef BHL_HEADER2_H
#define BHL_HEADER2_H

#include <BHLCommon/version.h>
#include <stdint.h>

namespace bhl
{

	template <class instanceType, uint32_t instanceAlignment>
	struct aligned
	{
		aligned();

		aligned(const aligned<instanceType, instanceAlignment>& p_instance);
		aligned(aligned<instanceType, instanceAlignment>&& p_instance);

		aligned(const instanceType& p_value);
		aligned(instanceType&& p_value);

		alignas((instanceAlignment == 0) ? 1 : instanceAlignment) typename instanceType value;
	};

	template<class instanceType, uint32_t instanceAlignment>
	inline aligned<instanceType, instanceAlignment>::aligned(const instanceType& p_value)
		: value(p_value)
	{}

	template<class instanceType, uint32_t instanceAlignment>
	inline aligned<instanceType, instanceAlignment>::aligned(instanceType&& p_value)
		: value(p_value)
	{}

	template<class instanceType, uint32_t instanceAlignment>
	inline aligned<instanceType, instanceAlignment>::aligned()
		: value()
	{
	}

	template<class instanceType, uint32_t instanceAlignment>
	inline aligned<instanceType, instanceAlignment>::aligned(const aligned<instanceType, instanceAlignment>& p_instance)
		: value(p_instance.value)
	{
	}

	template<class instanceType, uint32_t instanceAlignment>
	inline aligned<instanceType, instanceAlignment>::aligned(aligned<instanceType, instanceAlignment>&& p_instance)
		: value(std::move(p_instance.value))
	{
	}

}

#endif