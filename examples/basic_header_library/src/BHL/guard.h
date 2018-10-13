/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018 Alastair Holmes. All rights reserved.
/////////////////////////////////////////////////////////////////////////

#ifndef BHL_HEADER1_H
#define BHL_HEADER1_H

#include <common/version.h>

namespace bhl
{

	//The use of noexcept in this guard class ensures the guard will always run validly, and if it can't it will terminate the whole program.

	template <class payloadCallable>
	class guard
	{
	public:

		guard(const payloadCallable& p_payload) noexcept; //Could terminate if lambda captures an object by-value and that object throws in its copy constructor
		guard(payloadCallable&& p_payload) noexcept; //Could terminate if lambda captures an object by-value and that object throws in its move constructor

		guard(const guard<payloadCallable>&) = delete;
		guard(guard<payloadCallable>&& p_guard) noexcept; //Could terminate if lambda captures an object by-value and that object throws in its move constructor

		guard<payloadCallable>& operator=(const guard<payloadCallable>&) = delete;
		guard<payloadCallable>& operator=(guard<payloadCallable>&&) = delete;

		~guard() noexcept; //Could terminate if lambda captures an object by-value and that object throws its destructor

		void enable() noexcept; //Truely never throws
		void disable() noexcept; //Truely never throws

	private:

		bool m_enabled;
		payloadCallable m_payload;

	};

	template<class payloadCallable>
	inline guard<payloadCallable>::guard(const payloadCallable & p_payload) noexcept
		: m_payload(p_payload), m_enabled(true)
	{
	}

	template<class payloadCallable>
	inline guard<payloadCallable>::guard(payloadCallable&& p_payload) noexcept
		: m_payload(p_payload), m_enabled(true)
	{
	}

	template<class payloadCallable>
	inline guard<payloadCallable>::guard(guard<payloadCallable>&& p_guard) noexcept
		: m_payload(p_guard.m_payload), m_enabled(p_guard.m_enabled)
	{
		p_guard.m_enabled = false;
	}

	template<class payloadCallable>
	inline guard<payloadCallable>::~guard() noexcept
	{
		if (m_enabled)
		{
			m_payload();
		}
	}

	template<class payloadCallable>
	inline void guard<payloadCallable>::enable() noexcept
	{
		m_enabled = true;
	}

	template<class payloadCallable>
	inline void guard<payloadCallable>::disable() noexcept
	{
		m_enabled = false;
	}

	template<class payloadCallable>
	guard<payloadCallable> make_guard(payloadCallable&& p_callable) noexcept
	{
		return guard<payloadCallable>(std::forward<payloadCallable>(p_callable));
	}

}

#endif