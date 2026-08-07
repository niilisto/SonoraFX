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
// CRunPlatform: Platform Movement object
// fin 03/april/09
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunPlatform extends CRunExtension
{
    static final int CID_ObstacleTest = 0;
    static final int CID_JumpThroughTest = 1;
    static final int CID_IsOnGround = 2;
    static final int CID_IsJumping = 3;
    static final int CID_IsFalling = 4;
    static final int CID_IsPaused = 5;
    static final int CID_IsMoving = 6;
    static final int AID_ColObstacle = 0;
    static final int AID_ColJumpThrough = 1;
    static final int AID_SetObject = 2;
    static final int AID_MoveRight = 3;
    static final int AID_MoveLeft = 4;
    static final int AID_Jump = 5;
    static final int AID_SetXVelocity = 6;
    static final int AID_SetYVelocity = 7;
    static final int AID_SetMaxXVelocity = 8;
    static final int AID_SetMaxYVelocity = 9;
    static final int AID_SetXAccel = 10;
    static final int AID_SetXDecel = 11;
    static final int AID_SetGravity = 12;
    static final int AID_SetJumpStrength = 13;
    static final int AID_SetJumpHoldHeight = 14;
    static final int AID_SetStepUp = 15;
    static final int AID_JumpHold = 16;
    static final int AID_Pause = 17;
    static final int AID_UnPause = 18;
    static final int AID_SetSlopeCorrection = 19;
    static final int AID_SetAddXVelocity = 20;
    static final int AID_SetAddYVelocity = 21;
    static final int EID_GetXVelocity = 0;
    static final int EID_GetYVelocity = 1;
    static final int EID_GetMaxXVelocity = 2;
    static final int EID_GetMaxYVelocity = 3;
    static final int EID_GetXAccel = 4;
    static final int EID_GetXDecel = 5;
    static final int EID_GetGravity = 6;
    static final int EID_GetJumpStrength = 7;
    static final int EID_GetJumpHoldHeight = 8;
    static final int EID_GetStepUp = 9;
    static final int EID_GetSlopeCorrection = 10;
    static final int EID_GetAddXVelocity = 11;
    static final int EID_GetAddYVelocity = 12;

    int ObjFixed;
    int ObjShortCut;
    CRunPlatformCOL Col;
    CRunPlatformMove PFMove;

    public CRunPlatform()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 7;
    }

    private String fixString(String input)
    {
        for (int i = 0; i < input.length(); i++)
        {
            if (input.charAt(i) < 10)
            {
                return input.substring(0, i);
            }
        }
        return input;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        file.setUnicode(false);
        file.skipBytes(8);
        this.PFMove = new CRunPlatformMove();
        try
        {
            this.PFMove.MaxXVelocity = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.MaxYVelocity = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.XAccel = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.XDecel = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.Gravity = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.JumpStrength = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.JumpHoldHeight = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.StepUp = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        try
        {
            this.PFMove.SlopeCorrection = Integer.parseInt(fixString(file.readString(16)));
        }
        catch (Exception e)
        {
        }
        this.Col = new CRunPlatformCOL();
        this.Col.JumpThroughColTop = file.readByte() == 1 ? true : false;
        this.Col.EnableJumpThrough = file.readByte() == 1 ? true : false;
        return true;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    private CObject GetCObject(int Fixed)
    {
        CObject[] co = rh.rhObjectList;
        for (int i = 0; i < co.length; i++)
        {
            if (co[i] != null)
            {
                if (((co[i].hoCreationId << 16) + co[i].hoNumber) == Fixed)
                {
                    return co[i];
                }
            }
        }
        return null;
    }

    private boolean IsOverObstacle()
    {
        this.Col.Obstacle = false;
        ho.generateEvent(CID_ObstacleTest, ho.getEventParam());
        return this.Col.Obstacle;
    }

    private boolean IsOverJumpThrough()
    {
        if (!this.Col.EnableJumpThrough)
        {
            return false;
        }
        this.Col.JumpThrough = false;
        ho.generateEvent(CID_JumpThroughTest, ho.getEventParam());
        return this.Col.JumpThrough;
    }

    @Override
	public int handleRunObject()
    {
        CObject Object = GetCObject(this.ObjFixed);
        // If Object is valid, do movement
        if (!this.PFMove.Paused && Object != null)
        {
            if (this.PFMove.RightKey && !this.PFMove.LeftKey)
            {
                this.PFMove.XVelocity += this.PFMove.XAccel; // add to x velocity when pressing right
            }
            if (this.PFMove.LeftKey && !this.PFMove.RightKey)
            {
                this.PFMove.XVelocity -= this.PFMove.XAccel; // sub from x velocity when pressing left
            }
            if (this.PFMove.XVelocity != 0 && ((!this.PFMove.LeftKey && !this.PFMove.RightKey) || (this.PFMove.LeftKey && this.PFMove.RightKey)))
            {
                // slow the object down when not pressing right or left
                this.PFMove.XVelocity -= this.PFMove.XVelocity / Math.abs(this.PFMove.XVelocity) * this.PFMove.XDecel;
                if (this.PFMove.XVelocity <= this.PFMove.XDecel && this.PFMove.XVelocity >= 0 - this.PFMove.XDecel)
                {
                    this.PFMove.XVelocity = 0; // set x velocity to 0 when it's close to 0
                }
            }
            /////////////////////////////////////////////////////////////////////////
            // MOVEMENT LOOPS
            // set velocitities to max and min
            this.PFMove.XVelocity = Math.min(Math.max(this.PFMove.XVelocity, 0 - this.PFMove.MaxXVelocity), this.PFMove.MaxXVelocity);
            this.PFMove.YVelocity = Math.min(Math.max(this.PFMove.YVelocity + this.PFMove.Gravity, 0 - this.PFMove.MaxYVelocity), this.PFMove.MaxYVelocity);
            int tmpXVelocity = this.PFMove.XVelocity + this.PFMove.AddXVelocity;
            int tmpYVelocity = this.PFMove.YVelocity + this.PFMove.AddYVelocity;
            this.PFMove.XMoveCount += Math.abs(tmpXVelocity);
            this.PFMove.YMoveCount += Math.abs(tmpYVelocity);

            // X MOVEMENT LOOP
            while (this.PFMove.XMoveCount > 100)
            {
                if (!IsOverObstacle())
                {
                    Object.hoX += tmpXVelocity / Math.abs(tmpXVelocity);
                }

                if (IsOverObstacle())
                {
                    for (int up = 0; up < this.PFMove.StepUp; up++) // Step up (slopes)
                    {
                        Object.hoY--;
                        if (!IsOverObstacle())
                        {
                            break;
                        }
                    }
                    if (IsOverObstacle())
                    {
                        Object.hoY += (short) this.PFMove.StepUp;
                        Object.hoX -= tmpXVelocity / Math.abs(tmpXVelocity);
                        this.PFMove.XVelocity = this.PFMove.XMoveCount = 0;
                    }
                }
                this.PFMove.XMoveCount -= 100;
                Object.roc.rcChanged = true;
            }

            // Y MOVEMENT LOOP
            while (this.PFMove.YMoveCount > 100)
            {
                if (!IsOverObstacle())
                {
                    Object.hoY += tmpYVelocity / Math.abs(tmpYVelocity);
                    this.PFMove.OnGround = false;
                }

                if (IsOverObstacle())
                {
                    Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
                    if (tmpYVelocity > 0)
                    {
                        this.PFMove.OnGround = true;
                    }
                    this.PFMove.YVelocity = this.PFMove.YMoveCount = 0;
                }

                if (IsOverJumpThrough() && tmpYVelocity > 0)
                {
                    if (this.Col.JumpThroughColTop)
                    {
                        Object.hoY--;
                        if (!IsOverJumpThrough())
                        {
                            Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
                            this.PFMove.YVelocity = this.PFMove.YMoveCount = 0;
                            this.PFMove.OnGround = true;
                        }
                        Object.hoY++;
                    }
                    else
                    {
                        Object.hoY -= tmpYVelocity / Math.abs(tmpYVelocity);
                        this.PFMove.YVelocity = this.PFMove.YMoveCount = 0;
                        this.PFMove.OnGround = true;
                    }
                }
                this.PFMove.YMoveCount -= 100;
                Object.roc.rcChanged = true;

            }
            if (this.PFMove.SlopeCorrection > 0 && tmpYVelocity >= 0)
            {
                boolean tmp = false;
                // Slope correction
                for (int sc = 0; sc < this.PFMove.SlopeCorrection; sc++)
                {
                    Object.hoY++;
                    if (IsOverObstacle())
                    {
                        Object.hoY--;
                        this.PFMove.OnGround = true;
                        tmp = true;
                        break;
                    }
                }
                if (tmp == false)
                {
                    Object.hoY -= (short) this.PFMove.SlopeCorrection;
                }
            }
        }
        // Reset values
        this.PFMove.RightKey = false;
        this.PFMove.LeftKey = false;
        return 0;
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
            case CID_ObstacleTest:
                return true;
            case CID_JumpThroughTest:
                return true;
            case CID_IsOnGround:
                return PFMove.OnGround;
            case CID_IsJumping:
                return (!PFMove.OnGround && PFMove.YVelocity <= 0);
            case CID_IsFalling:
                return (!PFMove.OnGround && PFMove.YVelocity > 0);
            case CID_IsPaused:
                return PFMove.Paused;
            case CID_IsMoving:
                return (Math.abs(PFMove.XVelocity) > 0);
        }
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case AID_ColObstacle:
                Col.Obstacle = true;
                break;
            case AID_ColJumpThrough:
                Col.JumpThrough = true;
                break;
            case AID_SetObject:
                SetObject(act.getParamObject(rh, 0));
                break;
            case AID_MoveRight:
                PFMove.RightKey = true;
                break;
            case AID_MoveLeft:
                PFMove.LeftKey = true;
                break;
            case AID_Jump:
                PFMove.YVelocity = 0 - PFMove.JumpStrength;
                break;
            case AID_SetXVelocity:
                PFMove.XVelocity = act.getParamExpression(rh, 0);
                break;
            case AID_SetYVelocity:
                PFMove.YVelocity = act.getParamExpression(rh, 0);
                break;
            case AID_SetMaxXVelocity:
                PFMove.MaxXVelocity = act.getParamExpression(rh, 0);
                break;
            case AID_SetMaxYVelocity:
                PFMove.MaxYVelocity = act.getParamExpression(rh, 0);
                break;
            case AID_SetXAccel:
                PFMove.XAccel = act.getParamExpression(rh, 0);
                break;
            case AID_SetXDecel:
                PFMove.XDecel = act.getParamExpression(rh, 0);
                break;
            case AID_SetGravity:
                PFMove.Gravity = act.getParamExpression(rh, 0);
                break;
            case AID_SetJumpStrength:
                PFMove.JumpStrength = act.getParamExpression(rh, 0);
                break;
            case AID_SetJumpHoldHeight:
                PFMove.JumpHoldHeight = act.getParamExpression(rh, 0);
                break;
            case AID_SetStepUp:
                PFMove.StepUp = act.getParamExpression(rh, 0);
                break;
            case AID_JumpHold:
                PFMove.YVelocity -= PFMove.JumpHoldHeight;
                break;
            case AID_Pause:
                PFMove.Paused = true;
                break;
            case AID_UnPause:
                PFMove.Paused = false;
                break;
            case AID_SetSlopeCorrection:
                PFMove.SlopeCorrection = act.getParamExpression(rh, 0);
                break;
            case AID_SetAddXVelocity:
                PFMove.AddXVelocity = act.getParamExpression(rh, 0);
                break;
            case AID_SetAddYVelocity:
                PFMove.AddYVelocity = act.getParamExpression(rh, 0);
                break;
        }
    }

    private void SetObject(CObject object)
    {
		if ( object != null )
			ObjFixed = (object.hoCreationId << 16) + object.hoNumber;
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EID_GetXVelocity:
                return new CValue(PFMove.XVelocity);
            case EID_GetYVelocity:
                return new CValue(PFMove.YVelocity);
            case EID_GetMaxXVelocity:
                return new CValue(PFMove.MaxXVelocity);
            case EID_GetMaxYVelocity:
                return new CValue(PFMove.MaxYVelocity);
            case EID_GetXAccel:
                return new CValue(PFMove.XAccel);
            case EID_GetXDecel:
                return new CValue(PFMove.XDecel);
            case EID_GetGravity:
                return new CValue(PFMove.Gravity);
            case EID_GetJumpStrength:
                return new CValue(PFMove.JumpStrength);
            case EID_GetJumpHoldHeight:
                return new CValue(PFMove.JumpHoldHeight);
            case EID_GetStepUp:
                return new CValue(PFMove.StepUp);
            case EID_GetSlopeCorrection:
                return new CValue(PFMove.SlopeCorrection);
            case EID_GetAddXVelocity:
                return new CValue(PFMove.AddXVelocity);
            case EID_GetAddYVelocity:
                return new CValue(PFMove.AddYVelocity);
        }
        return new CValue(0);//won't be used
    }
    
    
}
