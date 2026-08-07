#ifndef COMMON_H
#define COMMON_H

#if defined(_DEBUG) && defined(WIN32)
	#define	_CRTDBG_MAP_ALLOC	1
#endif

#define	IN_EXT_VERSION2

// Build number of the minimum required version of MMF / Fusion 2.5
#ifdef _UNICODE
#define	MINBUILD	249
#else
#define	MINBUILD	243
#endif

// General includes
#include	"ccxhdr.h"
#include	"Surface.h"

// Specific to this cox
#include	"Resource.h"
#include	"Main.h"
#include	"TigsExt.hpp"

// Globals and Prototypes
extern HINSTANCE hInstLib;
extern short conditionsInfos[];
extern short actionsInfos[];
extern short expressionsInfos[];

// Jump tables matching SDLJoystick
extern long (WINAPI * ConditionJumps[])(LPRDATA rdPtr, long param1, long param2);
extern short (WINAPI * ActionJumps[])(LPRDATA rdPtr, long param1, long param2);
extern long (WINAPI * ExpressionJumps[])(LPRDATA rdPtr, long param);

// Compatibility helper macro (matching SDLJoystick)
#if defined(MMFEXT)
#define	IS_COMPATIBLE(v) (v->mvGetVersion != NULL && (v->mvGetVersion() & MMFBUILD_MASK) >= MINBUILD && (v->mvGetVersion() & MMFVERSION_MASK) >= MMFVERSION_20 && ((v->mvGetVersion() & MMFVERFLAG_MASK) & MMFVERFLAG_HOME) == 0)
#elif defined(PROEXT)
#define IS_COMPATIBLE(v) (v->mvGetVersion != NULL && (v->mvGetVersion() & MMFBUILD_MASK) >= MINBUILD && (v->mvGetVersion() & MMFVERSION_MASK) >= MMFVERSION_20 && ((v->mvGetVersion() & MMFVERFLAG_MASK) & MMFVERFLAG_PRO) != 0)
#else
#define	IS_COMPATIBLE(v) (v->mvGetVersion != NULL && (v->mvGetVersion() & MMFBUILD_MASK) >= MINBUILD && (v->mvGetVersion() & MMFVERSION_MASK) >= MMFVERSION_20)
#endif

#endif // COMMON_H
