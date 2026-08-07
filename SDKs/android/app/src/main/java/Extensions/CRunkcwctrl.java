/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Runtime.MMFRuntime;
import Runtime.SurfaceView;
import Services.CBinaryFile;
import android.graphics.PixelFormat;

public class CRunkcwctrl extends CRunExtension
{
	private static final int CND_ISICONIC=0;
	private static final int CND_ISMAXIMIZED=1;
	private static final int CND_ISVISIBLE=2;
	private static final int CND_ISAPPACTIVE=3;
	private static final int CND_HASFOCUS=4;
	private static final int CND_ISATTACHEDTODESKTOP=5;
	private static final int CND_LAST=6;

	private static final int ACT_SETBACKCOLOR=23;

	private static final int EXP_GETXPOSITION=0;
	private static final int EXP_GETYPOSITION=1;
	private static final int EXP_GETXSIZE=2;
	private static final int EXP_GETYSIZE=3;
	private static final int EXP_GETSCREENXSIZE=4;
	private static final int EXP_GETSCREENYSIZE=5;
	private static final int EXP_GETSCREENDEPTH=6;
	private static final int EXP_GETCLIENTXSIZE=7;
	private static final int EXP_GETCLIENTYSIZE=8;
	private static final int EXP_GETTITLE=9;
	private static final int EXP_GETBACKCOLOR=10;
	private static final int EXP_GETXFRAME=11;
	private static final int EXP_GETYFRAME=12;
	private static final int EXP_GETWFRAME=13;
	private static final int EXP_GETHFRAME=14;

	private CValue expRet;
	@Override
	public int getNumberOfConditions()
	{
		return CND_LAST;
	}
	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		expRet = new CValue(0);
		return false;
	}
	@Override
	public void destroyRunObject(boolean bFast)
	{
	}

	// Conditions
	// --------------------------------------------------
	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case CND_ISICONIC:
			return false;
		case CND_ISMAXIMIZED:
			return true;
		case CND_ISVISIBLE:
			return true;
		case CND_ISAPPACTIVE:
			return true;
		case CND_HASFOCUS:
			return true;
		case CND_ISATTACHEDTODESKTOP:
			return false;
		}
		return false;
	}

	// Actions
	// -------------------------------------------------
	@Override
	public void action(int num, CActExtension act)
	{
		if (num==ACT_SETBACKCOLOR)
		{
			rh.rhApp.gaBorderColour=act.getParamColour(rh, 0);
		}
	}

	// Expressions
	// --------------------------------------------
	int getScreenWidth()
	{
		return MMFRuntime.inst.currentWidth;
	}
	int getScreenHeight()
	{
		return MMFRuntime.inst.currentHeight;
	}
	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case EXP_GETXPOSITION:
			expRet.forceInt(0);
			return expRet;
		case EXP_GETYPOSITION:
			expRet.forceInt(0);
			return expRet;
		case EXP_GETXSIZE:
			expRet.forceInt(getScreenWidth());
			return expRet;
		case EXP_GETYSIZE:
			expRet.forceInt(getScreenHeight());
			return expRet;
		case EXP_GETSCREENXSIZE:
			expRet.forceInt(getScreenWidth());
			return expRet;
		case EXP_GETSCREENYSIZE:
			expRet.forceInt(getScreenHeight());
			return expRet;
		case EXP_GETSCREENDEPTH:
			expRet.forceInt(0);
			if(SurfaceView.inst != null)
				expRet.forceInt(SurfaceView.inst.pixelFormat == PixelFormat.RGBA_8888 ? 32 : 24);
			return expRet;
		case EXP_GETCLIENTXSIZE:
			expRet.forceInt(getScreenWidth());
			return expRet;
		case EXP_GETCLIENTYSIZE:
			expRet.forceInt(getScreenHeight());
			return expRet;
		case EXP_GETTITLE:
			expRet.forceString(ho.getApplication().appName);
			return expRet;
		case EXP_GETBACKCOLOR:
			expRet.forceInt(rh.rhApp.gaBorderColour);
			return expRet;
		case EXP_GETXFRAME:
			expRet.forceInt(0);
			return expRet;
		case EXP_GETYFRAME:
			expRet.forceInt(0);
			return expRet;
		case EXP_GETWFRAME:
			expRet.forceInt(rh.rhApp.gaCxWin);
			return expRet;
		case EXP_GETHFRAME:
			expRet.forceInt(rh.rhApp.gaCyWin);
			return expRet;
		}
		return new CValue(0);//won't be used
	}



}
