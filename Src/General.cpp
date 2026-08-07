// General.cpp - Matching SDLJoystick structure
#include "common.h"

HINSTANCE hInstLib;

BOOL WINAPI DllMain(HINSTANCE hDLL, DWORD dwReason, LPVOID lpReserved)
{
	switch (dwReason)
	{
		case DLL_PROCESS_ATTACH:
			hInstLib = hDLL;
			break;
		case DLL_THREAD_ATTACH:
			break;
		case DLL_THREAD_DETACH:
			break;
	    case DLL_PROCESS_DETACH:
			break;
	}
	return TRUE;
}

extern "C" int WINAPI DLLExport Initialize(mv _far *mV, int quiet)
{
	return 0;
}

extern "C" int WINAPI DLLExport Free(mv _far *mV)
{
	return 0;
}

extern "C" 
{
	DWORD WINAPI DLLExport GetInfos(int info)
	{
		switch (info)
		{
			case KGI_VERSION:
				return EXT_VERSION2;
			case KGI_PLUGIN:
				return EXT_PLUGIN_VERSION1;
			case KGI_PRODUCT:
#if defined(PROEXT)
				return PRODUCT_VERSION_DEV;
#else
				return PRODUCT_VERSION_STANDARD;
#endif
			case KGI_BUILD:
				return MINBUILD;
			case KGI_UNICODE:
				#ifdef _UNICODE
					return TRUE;
				#else
					return FALSE;
				#endif
			default:
				return 0;
		}
	}
}

short WINAPI DLLExport GetRunObjectInfos(mv _far *mV, fpKpxRunInfos infoPtr)
{
	infoPtr->conditions = (LPBYTE)ConditionJumps;
	infoPtr->actions = (LPBYTE)ActionJumps;
	infoPtr->expressions = (LPBYTE)ExpressionJumps;

	infoPtr->numOfConditions = CND_LAST;
	infoPtr->numOfActions = ACT_LAST;
	infoPtr->numOfExpressions = EXP_LAST;

	infoPtr->editDataSize = MAX_EDITSIZE;
	infoPtr->editFlags = OEFLAGS;
	infoPtr->windowProcPriority = WINDOWPROC_PRIORITY;
	infoPtr->editPrefs = OEPREFS;
	infoPtr->identifier = IDENTIFIER;
	infoPtr->version = KCX_CURRENT_VERSION;
	
	return TRUE;
}

LPCTSTR* WINAPI DLLExport GetDependencies()
{
	return NULL;
}

int WINAPI DLLExport LoadObject(mv _far *mV, LPCSTR fileName, LPEDATA edPtr, int reserved)
{
	return 0;
}

void WINAPI DLLExport UnloadObject(mv _far *mV, LPEDATA edPtr, int reserved)
{
}

HGLOBAL WINAPI DLLExport UpdateEditStructure(mv __far *mV, void __far * OldEdPtr)
{
	return 0;
}

void WINAPI DLLExport UpdateFileNames(mv _far *mV, LPTSTR appName, LPEDATA edPtr, void (WINAPI * lpfnUpdate)(LPTSTR, LPTSTR))
{
}
