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
// MOVEMENT CONTROLLER: extension object
//
//----------------------------------------------------------------------------------

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Movements.CMoveDef;
import Movements.CMoveDefExtension;
import OI.CObjectCommon;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;

public class CRunInAndOutController extends CRunExtension
{
    static final int ACT_SETOBJECT=0;
    static final int ACT_SETOBJECTFIXED=1;
    static final int ACT_POSITIONIN=2;
    static final int ACT_POSITIONOUT=3;
    static final int ACT_MOVEIN=4;
    static final int ACT_MOVEOUT=5;
    static final String DLL_INANDOUT = "InAndOut";
    static final int ACTION_POSITIONIN=0;
    static final int ACTION_POSITIONOUT=1;
    static final int ACTION_MOVEIN=2;
    static final int ACTION_MOVEOUT=3;

    CObject currentObject = null;

    public CRunInAndOutController()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        return REFLAG_ONESHOT;
    }

    @Override
	public void pauseRunObject()
    {
    }

    @Override
	public void continueRunObject()
    {
    }

    public boolean saveRunObject(DataOutputStream stream)
    {
        return true;
    }

    public boolean loadRunObject(DataInputStream stream)
    {
        return true;
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

    @Override
	public void getZoneInfos()
    {
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            //*** Set Object
            case ACT_SETOBJECT:
                Action_SetObject_Object(act);
                break;
            case ACT_SETOBJECTFIXED:
                Action_SetObject_FixedValue(act);
                break;
            case ACT_POSITIONIN:
                RACT_POSITIONIN(act);
                break;
            case ACT_POSITIONOUT:
                RACT_POSITIONOUT(act);
                break;
            case ACT_MOVEIN:
                RACT_MOVEIN(act);
                break;
            case ACT_MOVEOUT:
                RACT_MOVEOUT(act);
                break;
        }
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        return null;
    }

    CObject getCurrentObject(String dllName)
    {
        // No need to search for the object if it's null
        if (currentObject == null)
        {
            return null;
        }

        // Enumerate objects
        CObject hoPtr;
        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
        {
            if (hoPtr == currentObject)
            {
                // Check if the object can have movements
                if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
                {
                    // Test if the object has a movement and this movement is an extension
                    if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
                    {
                        if (dllName != null)
                        {
                            CObjectCommon ocPtr = hoPtr.hoCommon;
                            CMoveDefExtension mvPtr = (CMoveDefExtension) ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum];
                            if (dllName.compareToIgnoreCase(mvPtr.moduleName) == 0)
                            {
                                return hoPtr;
                            }
                            else
                            {
                                return null;
                            }
                        }
                        else
                        {
                            return hoPtr;
                        }
                    }
                    return null;
                }
            }
        }
        currentObject = null;
        return null;
    }

    // ============================================================================
    //
    // ACTIONS ROUTINES
    //
    // ============================================================================

    //*** Set Object
    void Action_SetObject_Object(CActExtension act)
    {
        CObject hoPtr = act.getParamObject(rh, 0);
        if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
        {
            if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
            {
                currentObject = hoPtr;
            }
        }
    }

    void Action_SetObject_FixedValue(CActExtension act)
    {
        int fixed = act.getParamExpression(rh, 0);
        CObject hoPtr = ho.getObjectFromFixed(fixed);

        if (hoPtr != null)
        {
            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
            {
                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
                {
                    currentObject = hoPtr;
                }
            }
        }
    }
    void RACT_POSITIONIN(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_INANDOUT);
        if (object!=null)
            ho.callMovement(object, ACTION_POSITIONIN, 0);
    }
    void RACT_POSITIONOUT(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_INANDOUT);
        if (object!=null)
            ho.callMovement(object, ACTION_POSITIONOUT, 0);
    }
    void RACT_MOVEIN(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_INANDOUT);
        if (object!=null)
            ho.callMovement(object, ACTION_MOVEIN, 0);
    }
    void RACT_MOVEOUT(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_INANDOUT);
        if (object!=null)
            ho.callMovement(object, ACTION_MOVEOUT, 0);
    }
}
