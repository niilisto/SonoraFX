#pragma once

#define MMFEXT

#include "DarkEdif.hpp"

#pragma pack (push, 1)
struct EDITDATA final
{
	NO_DEFAULT_CTORS_OR_DTORS(EDITDATA);
	extHeader eHeader;
	DarkEdif::Properties Props;
};
#pragma pack (pop)

#include "Extension.hpp"
