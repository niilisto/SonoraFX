#include "Common.hpp"

#if EditorBuild

int FusionAPI MakeIconEx(mv * mV, cSurface * pIconSf, TCHAR * lpName, ObjInfo * oiPtr, EDITDATA * edPtr)
{
#pragma DllExportHint
	pIconSf->Delete();
	pIconSf->Clone(*Edif::SDK->Icon);
	pIconSf->SetTransparentColor(RGB(255, 0, 255));
	return 0;
}

int FusionAPI CreateObject(mv * mV, LevelObject * loPtr, EDITDATA * edPtr)
{
#pragma DllExportHint
	if (!Edif::IS_COMPATIBLE(mV))
		return -1;

	Edif::Init(mV, edPtr);
	return DarkEdif::DLL::DLL_CreateObject(mV, loPtr, edPtr);
}

void FusionAPI EditorDisplay(mv *mV, ObjectInfo * oiPtr, LevelObject * loPtr, EDITDATA * edPtr, RECT * rc)
{
#pragma DllExportHint
	cSurface * Surface = WinGetSurface((int) mV->IdEditWin);
	if (!Surface)
		return;

	Edif::SDK->Icon->Blit(*Surface, rc->left, rc->top, BMODE_TRANSP, BOP_COPY, 0);
}

#endif

#ifdef _WIN32
void cSurface::GetSizeOfRotatedRect(int * pWidth, int * pHeight, int angle)
{
	if (pWidth) *pWidth = 32;
	if (pHeight) *pHeight = 32;
}
#endif
