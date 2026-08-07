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
import Application.CJoystick;
import Application.CJoystickAcc;
import Application.CRunApp;
import Application.CRunFrame;
import Expressions.CValue;
import Params.CPositionInfo;
import RunLoop.CCreateObjectInfo;
import Runtime.MMFRuntime;
import Services.CBinaryFile;

public class CRunJoystickControl extends CRunExtension
{
	public static final int POS_NOTDEFINED = 0x80000000;

    public static final int  ACT_STARTACCELEROMETER = 0;
    public static final int  ACT_STOPACCELEROMETER  = 1;
    public static final int  ACT_STARTSTOPTOUCH     = 2;
    public static final int  ACT_SETJOYPOSITION		= 3;
    public static final int  ACT_SETFIRE1POSITION	= 4;
    public static final int  ACT_SETFIRE2POSITION	= 5;
    public static final int  ACT_SETXJOYSTICK		= 6;
    public static final int  ACT_SETYJOYSTICK		= 7;
    public static final int  ACT_SETXFIRE1			= 8;
    public static final int  ACT_SETYFIRE1			= 9;
    public static final int  ACT_SETXFIRE2		    = 10;
    public static final int  ACT_SETYFIRE2			= 11;
    public static final int  ACT_SETJOYMASK			= 12;
    public static final int  EXP_XJOYSTICK			= 0;
    public static final int  EXP_YJOYSTICK			= 1;
    public static final int  EXP_XFIRE1				= 2;
    public static final int  EXP_YFIRE1				= 3;
    public static final int  EXP_XFIRE2				= 4;
    public static final int  EXP_YFIRE2				= 5;

	public boolean bAccelerometer, bJoystick;
	
	public int xJoystick, yJoystick, xFire1, yFire1,
				xFire2, yFire2;
	
    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }
    
    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
    	xJoystick=POS_NOTDEFINED;
    	yJoystick=POS_NOTDEFINED;
    	xFire1=POS_NOTDEFINED;
    	yFire1=POS_NOTDEFINED;
    	xFire2=POS_NOTDEFINED;
    	yFire2=POS_NOTDEFINED;
    	bAccelerometer=false;
    	bJoystick=false;
    	
        return false;
    }
    
    public @Override void pauseRunObject()
    {
    	if(bAccelerometer) {
    		CJoystickAcc j = ho.hoAdRunHeader.rhApp.joystickAcc;
    		if(j != null) {
    			j.deactivate();
    			j = null;
    		}
    	}
    }
    
    public @Override void continueRunObject()
    {
    	if(bAccelerometer)
    		ho.hoAdRunHeader.rhApp.createJoystickAcc(true);
    }
   
    
    @Override
	public void destroyRunObject(boolean bFast)
    {
    	if(bJoystick)
    		ho.hoAdRunHeader.rhApp.destroyJoystick();
    	
    	if(bAccelerometer) {
    		CJoystickAcc j = ho.hoAdRunHeader.rhApp.joystickAcc;
    		if(j != null) {
    			j.deactivate();
    			j = null;
    		}
    	}    	
    }
    
    @Override
	public void action(int num, CActExtension act)
    {
    	switch(num)
    	{
		case ACT_STARTACCELEROMETER:
			startAccelerometer(act);
			break;
		case ACT_STOPACCELEROMETER:
			stopAccelerometer(act);
			break;
		case ACT_STARTSTOPTOUCH:
			startStopTouch(act);
			break;
		case ACT_SETJOYPOSITION:
			setJoyPosition(act);
			break;
		case ACT_SETFIRE1POSITION:
			setFire1Position(act);
			break;
		case ACT_SETFIRE2POSITION:
			setFire2Position(act);
			break;
		case ACT_SETXJOYSTICK:
			setXJoystick(act);
			break;
		case ACT_SETYJOYSTICK:
			setYJoystick(act);
			break;
		case ACT_SETXFIRE1:
			setXFire1(act);
			break;
		case ACT_SETYFIRE1:
			setYFire1(act);
			break;
		case ACT_SETXFIRE2:
			setXFire2(act);
			break;
		case ACT_SETYFIRE2:
			setYFire2(act);
			break;
		case ACT_SETJOYMASK:
			setJoyMask(act);
			break;
    	};	
    }

public void startStopTouch(CActExtension act)
{
	CRunApp rhApp=ho.hoAdRunHeader.rhApp;
	if (rhApp.parentApp!=null)
	{
		return;
	}
	if (rhApp.frame.joystick!=CRunFrame.JOYSTICK_EXT)
	{
		return;
	}

	int joy=act.getParamExpression(rh, 0);
	int fire1=act.getParamExpression(rh, 1);
	int fire2=act.getParamExpression(rh, 2);
	int leftHanded=act.getParamExpression(rh, 3);

	int flags=0;
	if (fire1!=0)
	{
		flags=CJoystick.JFLAG_FIRE1;
	}
	if (fire2!=0)
	{
		flags|=CJoystick.JFLAG_FIRE2;
	}
	if (joy!=0)
	{
		flags|=CJoystick.JFLAG_JOYSTICK;
	}
	if (leftHanded!=0)
	{
		flags|=CJoystick.JFLAG_LEFTHANDED;
	}
	
	if ((flags&(CJoystick.JFLAG_FIRE1|CJoystick.JFLAG_FIRE2|CJoystick.JFLAG_JOYSTICK))!=0)
	{
		rhApp.createJoystick(true, flags);
		rhApp.joystick.reset(flags);
		if (xJoystick!=POS_NOTDEFINED)
		{
			rhApp.joystick.setXPosition(CJoystick.JFLAG_JOYSTICK, xJoystick);
		}
		else
		{
			xJoystick=ScreenToFrame(0, rhApp.joystick.imagesX[CJoystick.KEY_JOYSTICK]);
		}

		if (yJoystick!=POS_NOTDEFINED)
		{
			rhApp.joystick.setYPosition(CJoystick.JFLAG_JOYSTICK, yJoystick);
		}
		else
		{
			yJoystick=ScreenToFrame(1, rhApp.joystick.imagesY[CJoystick.KEY_JOYSTICK]);
		}

		if (xFire1!=POS_NOTDEFINED)
		{
			rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE1, xFire1);
		}
		else
		{
			xFire1=ScreenToFrame(0, rhApp.joystick.imagesX[CJoystick.KEY_FIRE1]);
		}

		if (yFire1!=POS_NOTDEFINED)
		{
			rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE1, yFire1);
		}
		else
		{
			yFire1=ScreenToFrame(1, rhApp.joystick.imagesY[CJoystick.KEY_FIRE1]);
		}

		if (xFire2!=POS_NOTDEFINED)
		{
			rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE2, xFire2);
		}
		else
		{
			xFire2=ScreenToFrame(0, rhApp.joystick.imagesX[CJoystick.KEY_FIRE2]);
		}

		if (yFire2!=POS_NOTDEFINED)
		{
			rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE2, yFire2);
		}
		else
		{
			yFire2=ScreenToFrame(1, rhApp.joystick.imagesY[CJoystick.KEY_FIRE2]);
		}

		bJoystick=true;
	}
	else
	{
		rhApp.createJoystick(false, 0);
		bJoystick=false;
	}
}

void setJoyPosition(CActExtension act)
{
	CPositionInfo pos=act.getParamPosition(rh, 0);
	xJoystick=pos.x;
	yJoystick=pos.y;
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_JOYSTICK, xJoystick);
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_JOYSTICK, yJoystick);
	}
}
void setFire1Position(CActExtension act)
{
	CPositionInfo pos=act.getParamPosition(rh, 0);
	xFire1=pos.x;
	yFire1=pos.y;
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE1, xFire1);
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE1, yFire1);
	}
}
void setFire2Position(CActExtension act)
{
	CPositionInfo pos=act.getParamPosition(rh, 0);
	xFire2=pos.x;
	yFire2=pos.y;
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE2, xFire2);
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE2, yFire2);
	}
}
void setXJoystick(CActExtension act)
{
	xJoystick=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_JOYSTICK, xJoystick);
	}
}
void setYJoystick(CActExtension act)
{
	yJoystick=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_JOYSTICK, yJoystick);
	}
}
void setXFire1(CActExtension act)
{
	xFire1=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE1, xFire1);
	}
}
void setYFire1(CActExtension act)
{
	yFire1=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE1, yFire1);
	}
}
void setXFire2(CActExtension act)
{
	xFire2=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setXPosition(CJoystick.JFLAG_FIRE2, xFire2);
	}
}
void setYFire2(CActExtension act)
{
	yFire2=act.getParamExpression(rh, 0);
	if (bJoystick)
	{
		ho.hoAdRunHeader.rhApp.joystick.setYPosition(CJoystick.JFLAG_FIRE2, yFire2);
	}
}
void setJoyMask(CActExtension act)
{
    int mask=act.getParamExpression(rh, 0);
    ho.hoAdRunHeader.rhJoystickMask=mask;
}
void startAccelerometer(CActExtension act)
{
    CRunApp app = ho.hoAdRunHeader.rhApp;

    if(app.parentApp != null)
        return;

    if(app.frame.joystick != CRunFrame.JOYSTICK_EXT)
        return;

    if(bAccelerometer == false)
    {
        ho.hoAdRunHeader.rhApp.createJoystickAcc(true);
        bAccelerometer = true;
    }
}
void stopAccelerometer(CActExtension act)
{
    if(bAccelerometer == true)
    {
        ho.hoAdRunHeader.rhApp.createJoystickAcc(false);
        bAccelerometer = false;
    }
}

// Expressions
// --------------------------------------------
@Override
public CValue expression(int num)
{
	int ret=0;

	switch (num)
	{
		case EXP_XJOYSTICK:
			ret=xJoystick;
			break;
		case EXP_YJOYSTICK:
			ret=yJoystick;
			break;
		case EXP_XFIRE1:
			ret=xFire1;
			break;
		case EXP_YFIRE1:
			ret=yFire1;
			break;
		case EXP_XFIRE2:
			ret=xFire2;
			break;
		case EXP_YFIRE2:
			ret=yFire2;
			break;
	}

    return new CValue(ret);
}

private int ScreenToFrame(int axis, int p) {
	if(axis == 0) {
		p -= MMFRuntime.inst.viewportX;
		p /= MMFRuntime.inst.scaleX;
	}
	
	if(axis == 1) {
		p -= MMFRuntime.inst.viewportY;
		p /= MMFRuntime.inst.scaleY;
	}
	return p;
}

}
