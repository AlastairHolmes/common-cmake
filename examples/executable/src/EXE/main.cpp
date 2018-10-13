#include <iostream>

#include <SLIB\header.h>

int main()
{
	std::cout << "SLIB Version: " << slib::get_major_version() << "." << slib::get_minor_version() << "." << slib::get_patch_version() << std::endl;

	return 0;
}