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
//----------------------------------------------------------------------------------
//
// CRUNSTATICTEXT: extension object
//
//----------------------------------------------------------------------------------
package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunObjectMover extends CRunExtension
{
    short enabled;
    int previousX;
    int previousY;

    public CRunObjectMover()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 1;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        ho.hoImgWidth = file.readInt();
        ho.hoImgHeight = file.readInt();
        enabled = file.readShort();
        previousX = ho.hoX;
        previousY = ho.hoY;

        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        if (ho.hoX != previousX || ho.hoY != previousY)
        {
            int deltaX = ho.hoX - previousX;
            int deltaY = ho.hoY - previousY;
            if (enabled != 0)
            {
                int n;
                int x1 = previousX;
                int y1 = previousY;
                int x2 = previousX + ho.hoImgWidth;
                int y2 = previousY + ho.hoImgHeight;
                CRun rhPtr = ho.hoAdRunHeader;
                int count = 0;
                for (n = 0; n < rhPtr.rhNObjects; n++)
                {
                    while (rhPtr.rhObjectList[count] == null)
                    {
                        count++;
                    }
                    CObject pHo = rhPtr.rhObjectList[count];
                    count++;
                    if (pHo != ho)
                    {
                        if (pHo.hoX >= x1 && pHo.hoX + pHo.hoImgWidth < x2)
                        {
                            if (pHo.hoY >= y1 && pHo.hoY + pHo.hoImgHeight < y2)
                            {
                                setPosition(pHo, pHo.hoX + deltaX, pHo.hoY + deltaY);
                            }
                        }
                    }
                }
            }
            previousX = ho.hoX;
            previousY = ho.hoY;
        }
        return 0;
    }

    void setPosition(CObject pHo, int x, int y)
    {
        if (pHo.rom != null)
        {
            pHo.rom.rmMovement.setXPosition(x);
            pHo.rom.rmMovement.setYPosition(y);
        }
        else
        {
            pHo.hoX = x;
            pHo.hoY = y;
            if (pHo.roc != null)
            {
                pHo.roc.rcChanged = true;
                pHo.roc.rcCheckCollides = true;
            }
        }
    }

    public void displayRunObject(Canvas c, Paint p)
    {
    }

    @Override
	public void pauseRunObject()
    {
    }

    @Override
	public void continueRunObject()
    {
    }

    public void saveBackground(Bitmap img)
    {
    }

    public void restoreBackground(Canvas c, Paint p)
    {
    }

    public void killBackground()
    {
    }

    @Override
	public CFontInfo getRunObjectFont()
    {
        return null;
    }

    @Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
    {
    }

    @Override
	public int getRunObjectTextColor()
    {
        return 0;
    }

    @Override
	public void setRunObjectTextColor(int rgb)
    {
    }

    @Override
	public CMask getRunObjectCollisionMask(int flags)
    {
        return null;
    }

    public Bitmap getRunObjectSurface()
    {
        return null;
    }

    @Override
	public void getZoneInfos()
    {
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case 0:
                return cndEnabled(cnd);
        }
        return false;
    }

    boolean cndEnabled(CCndExtension cnd)
    {
        return enabled != 0;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case 0:
                actSetWidth(act);
                break;
            case 1:
                actSetHeight(act);
                break;
            case 2:
                actEnable(act);
                break;
            case 3:
                actDisable(act);
                break;
        }
    }

    void actEnable(CActExtension act)
    {
        enabled = 1;
    }

    void actDisable(CActExtension act)
    {
        enabled = 0;
    }

    void actSetWidth(CActExtension act)
    {
        int width = act.getParamExpression(rh, 0);
        if (width > 0)
        {
            ho.hoImgWidth = width;
        }
    }

    void actSetHeight(CActExtension act)
    {
        int height = act.getParamExpression(rh, 0);
        if (height > 0)
        {
            ho.hoImgHeight = height;
        }
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case 0:
                return expGetWidth();
            case 1:
                return expGetHeight();
        }
        return null;
    }

    CValue expGetWidth()
    {
        return new CValue(ho.hoImgWidth);
    }

    CValue expGetHeight()
    {
        return new CValue(ho.hoImgHeight);
    }
}
