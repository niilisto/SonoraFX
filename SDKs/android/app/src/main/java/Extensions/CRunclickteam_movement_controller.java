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

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Movements.CMoveDef;
import Movements.CMoveDefExtension;
import OI.CObjectCommon;
import Objects.CObject;
import Params.CPositionInfo;
import Params.PARAM_ZONE;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunclickteam_movement_controller extends CRunExtension
{
    //*** Circular movement
    public static int SET_CIRCLE_CENTRE_X = 3345;
    public static int SET_CIRCLE_CENTRE_Y = 3346;
    public static int SET_CIRCLE_ANGSPEED = 3347;
    public static int SET_CIRCLE_CURRENTANGLE = 3348;
    public static int SET_CIRCLE_RADIUS = 3349;
    public static int SET_CIRCLE_SPIRALVEL = 3350;
    public static int SET_CIRCLE_MINRADIUS = 3351;
    public static int SET_CIRCLE_MAXRADIUS = 3352;
    public static int SET_CIRCLE_ONCOMPLETION = 3353;
    public static int GET_CIRCLE_CENTRE_X = 3354;
    public static int GET_CIRCLE_CENTRE_Y = 3355;
    public static int GET_CIRCLE_ANGSPEED = 3356;
    public static int GET_CIRCLE_CURRENTANGLE = 3357;
    public static int GET_CIRCLE_RADIUS = 3358;
    public static int GET_CIRCLE_SPIRALVEL = 3359;
    public static int GET_CIRCLE_MINRADIUS = 3360;
    public static int GET_CIRCLE_MAXRADIUS = 3361;
    //*** Regular Polygon movement
    public static int SET_REGPOLY_CENTRE_X = 3445;
    public static int SET_REGPOLY_CENTRE_Y = 3446;
    public static int SET_REGPOLY_NUMSIDES = 3447;
    public static int SET_REGPOLY_RADIUS = 3448;
    public static int SET_REGPOLY_ROTATION_ANGLE = 3449;
    public static int SET_REGPOLY_VELOCITY = 3450;
    public static int GET_REGPOLY_CENTRE_X = 3451;
    public static int GET_REGPOLY_CENTRE_Y = 3452;
    public static int GET_REGPOLY_NUMSIDES = 3453;
    public static int GET_REGPOLY_RADIUS = 3454;
    public static int GET_REGPOLY_ROTATION_ANGLE = 3455;
    public static int GET_REGPOLY_VELOCITY = 3456;
    //*** Sinewave movement
    public static int SET_SINEWAVE_SPEED = 3545;
    public static int SET_SINEWAVE_STARTX = 3546;
    public static int SET_SINEWAVE_STARTY = 3547;
    public static int SET_SINEWAVE_FINALX = 3548;
    public static int SET_SINEWAVE_FINALY = 3549;
    public static int SET_SINEWAVE_AMPLITUDE = 3550;
    public static int SET_SINEWAVE_ANGVEL = 3551;
    public static int SET_SINEWAVE_STARTANG = 3552;
    public static int SET_SINEWAVE_CURRENTANGLE = 3553;
    public static int GET_SINEWAVE_SPEED = 3554;
    public static int GET_SINEWAVE_STARTX = 3555;
    public static int GET_SINEWAVE_STARTY = 3556;
    public static int GET_SINEWAVE_FINALX = 3557;
    public static int GET_SINEWAVE_FINALY = 3558;
    public static int GET_SINEWAVE_AMPLITUDE = 3559;
    public static int GET_SINEWAVE_ANGVEL = 3560;
    public static int GET_SINEWAVE_STARTANG = 3561;
    public static int GET_SINEWAVE_CURRENTANGLE = 3562;
    public static int RESET_SINEWAVE = 3563;
    public static int SET_SINEWAVE_ONCOMPLETION = 3564;
    //*** Simple Ellipse movement
    public static int SET_SIMPLEELLIPSE_CENTRE_X = 3645;
    public static int SET_SIMPLEELLIPSE_CENTRE_Y = 3646;
    public static int SET_SIMPLEELLIPSE_RADIUS_X = 3647;
    public static int SET_SIMPLEELLIPSE_RADIUS_Y = 3648;
    public static int SET_SIMPLEELLIPSE_ANGSPEED = 3649;
    public static int SET_SIMPLEELLIPSE_CURRENTANGLE = 3650;
    public static int SET_SIMPLEELLIPSE_OFFSETANGLE = 3651;
    public static int GET_SIMPLEELLIPSE_CENTRE_X = 3652;
    public static int GET_SIMPLEELLIPSE_CENTRE_Y = 3653;
    public static int GET_SIMPLEELLIPSE_RADIUS_X = 3654;
    public static int GET_SIMPLEELLIPSE_RADIUS_Y = 3655;
    public static int GET_SIMPLEELLIPSE_ANGSPEED = 3656;
    public static int GET_SIMPLEELLIPSE_CURRENTANGLE = 3657;
    public static int GET_SIMPLEELLIPSE_OFFSETANGLE = 3658;
    //*** Invaders movement
    public static int SET_INVADERS_SPEED = 3745;
    public static int SET_INVADERS_STEPX = 3746;
    public static int SET_INVADERS_STEPY = 3747;
    public static int SET_INVADERS_LEFTBORDER = 3748;
    public static int SET_INVADERS_RIGHTBORDER = 3749;
    public static int GET_INVADERS_SPEED = 3750;
    public static int GET_INVADERS_STEPX = 3751;
    public static int GET_INVADERS_STEPY = 3752;
    public static int GET_INVADERS_LEFTBORDER = 3753;
    public static int GET_INVADERS_RIGHTBORDER = 3754;
    //*** Vector movement
    public static int SET_Projectile_X = 3845;
    public static int SET_Projectile_Y = 3846;
    public static int SET_Projectile_XY = 3847;
    public static int SET_Projectile_AddDistX = 3848;
    public static int SET_Projectile_AddDistY = 3849;
    public static int SET_Projectile_Dir = 3850;
    public static int SET_Projectile_RotateTowardsAngle = 3851;
    public static int SET_Projectile_RotateTowardsPoint = 3852;
    public static int SET_Projectile_RotateTowardsObject = 3853;
    public static int SET_Projectile_Speed = 3854;
    public static int SET_Projectile_SpeedX = 3855;
    public static int SET_Projectile_SpeedY = 3856;
    public static int SET_Projectile_AddSpeedX = 3857;
    public static int SET_Projectile_AddSpeedY = 3858;
    public static int SET_Projectile_MinSpeed = 3859;
    public static int SET_Projectile_MaxSpeed = 3860;
    public static int SET_Projectile_Gravity = 3861;
    public static int SET_Projectile_GravityDir = 3862;
    public static int SET_Projectile_BounceCoeff = 3863;
    public static int SET_Projectile_ForceBounce = 3864;
    public static int GET_Projectile_X = 3865;
    public static int GET_Projectile_Y = 3866;
    public static int GET_Projectile_Dir = 3867;
    public static int GET_Projectile_Speed = 3868;
    public static int GET_Projectile_SpeedX = 3869;
    public static int GET_Projectile_SpeedY = 3870;
    public static int GET_Projectile_MinSpeed = 3871;
    public static int GET_Projectile_MaxSpeed = 3872;
    public static int GET_Projectile_Gravity = 3873;
    public static int GET_Projectile_GravityDir = 3874;
    public static int GET_Projectile_BounceCoef = 3875;
    //*** Presentation movement
    public static int SET_PRESENTATION_Next = 3945;
    public static int SET_PRESENTATION_Prev = 3946;
    public static int SET_PRESENTATION_ToStart = 3947;
    public static int SET_PRESENTATION_ToEnd = 3948;
    public static int GET_PRESENTATION_Index = 3949;
    public static int GET_PRESENTATION_LastIndex = 3950;
    public static int SPACE_SETPOWER = 0;
    public static int SPACE_SETSPEED = 1;
    public static int SPACE_SETDIR = 2;
    public static int SPACE_SETDEC = 3;
    public static int SPACE_SETROTSPEED = 4;
    public static int SPACE_SETGRAVITY = 5;
    public static int SPACE_SETGRAVITYDIR = 6;
    public static int SPACE_APPLYREACTOR = 7;
    public static int SPACE_APPLYROTATERIGHT = 8;
    public static int SPACE_APPLYROTATELEFT = 9;
    public static int SPACE_GETGRAVITY = 10;
    public static int SPACE_GETGRAVITYDIR = 11;
    public static int SPACE_GETDECELERATION = 12;
    public static int SPACE_GETROTATIONSPEED = 13;
    public static int SPACE_GETTHRUSTPOWER = 14;

	//*** Drag-drop movement
    public static final int SET_DragDrop_Method = 4145;
    public static final int SET_DragDrop_IsLimited=4146;
    public static final int SET_DragDrop_DropOutsideArea=4147;
    public static final int SET_DragDrop_ForceWithinLimits=4148;
    public static final int SET_DragDrop_AreaX=4149;
    public static final int SET_DragDrop_AreaY=4150;
    public static final int SET_DragDrop_AreaW=4151;
    public static final int SET_DragDrop_AreaH=4152;
    public static final int SET_DragDrop_SnapToGrid=4153;
    public static final int SET_DragDrop_GridX=4154;
    public static final int SET_DragDrop_GridY=4155;
    public static final int SET_DragDrop_GridW=4156;
    public static final int SET_DragDrop_GridH=4157;
    public static final int GET_DragDrop_AreaX=4158;
    public static final int GET_DragDrop_AreaY=4159;
    public static final int GET_DragDrop_AreaW=4160;
    public static final int GET_DragDrop_AreaH=4161;
    public static final int GET_DragDrop_GridX=4162;
    public static final int GET_DragDrop_GridY=4163;
    public static final int GET_DragDrop_GridW=4164;
    public static final int GET_DragDrop_GridH=4165;

    CObject currentObject = null;
    static final String DLL_CIRCULAR = "clickteam-circular";
    static final String DLL_INVADERS = "clickteam-invaders";
    static final String DLL_PRESENTATION = "clickteam-presentation";
    static final String DLL_REGPOLYGON = "clickteam-regpolygon";
    static final String DLL_SIMPLE_ELLIPSE = "clickteam-simple_ellipse";
    static final String DLL_SINEWAVE = "clickteam-sinewave";
    static final String DLL_DRAGDROP = "clickteam-dragdrop";
    static final String DLL_VECTOR = "clickteam-vector";
    static final String DLL_SPACESHIP = "spaceship";
    static final double ToRadians = 0.017453292519943295769236907684886;
    static final double ToDegrees = 57.295779513082320876798154814105;

    public CRunclickteam_movement_controller()
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

    public void saveBackground(Bitmap b)
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
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            //*** Circular movement
            case 0:
                Action_SET_CIRCLE_CENTRE_X(act);
                break;
            case 1:
                Action_SET_CIRCLE_CENTRE_Y(act);
                break;
            case 2:
                Action_SET_CIRCLE_ANGSPEED(act);
                break;
            case 3:
                Action_SET_CIRCLE_CURRENTANGLE(act);
                break;
            case 4:
                Action_SET_CIRCLE_RADIUS(act);
                break;
            case 5:
                Action_SET_CIRCLE_SPIRALVEL(act);
                break;
            case 6:
                Action_SET_CIRCLE_MINRADIUS(act);
                break;
            case 7:
                Action_SET_CIRCLE_MAXRADIUS(act);
                break;
            case 8:
                Action_SET_CIRCLE_ONEND1(act);
                break;
            case 9:
                Action_SET_CIRCLE_ONEND2(act);
                break;
            case 10:
                Action_SET_CIRCLE_ONEND3(act);
                break;
            case 11:
                Action_SET_CIRCLE_ONEND4(act);
                break;

            //*** Regular Polygon movement
            case 12:
                Action_SET_REGPOLY_CENTRE_X(act);
                break;
            case 13:
                Action_SET_REGPOLY_CENTRE_Y(act);
                break;
            case 14:
                Action_SET_REGPOLY_NUMSIDES(act);
                break;
            case 15:
                Action_SET_REGPOLY_RADIUS(act);
                break;
            case 16:
                Action_SET_REGPOLY_ROTATION_ANGLE(act);
                break;
            case 17:
                Action_SET_REGPOLY_VELOCITY(act);
                break;

            //*** Sinewave movement
            case 18:
                Action_SET_SINEWAVE_SPEED(act);
                break;
            case 19:
                Action_SET_SINEWAVE_STARTX(act);
                break;
            case 20:
                Action_SET_SINEWAVE_STARTY(act);
                break;
            case 21:
                Action_SET_SINEWAVE_FINALX(act);
                break;
            case 22:
                Action_SET_SINEWAVE_FINALY(act);
                break;
            case 23:
                Action_SET_SINEWAVE_AMPLITUDE(act);
                break;
            case 24:
                Action_SET_SINEWAVE_ANGVEL(act);
                break;
            case 25:
                Action_SET_SINEWAVE_STARTANG(act);
                break;
            case 26:
                Action_SET_SINEWAVE_CURRENTANGLE(act);
                break;
            case 27:
                Action_RESET_SINEWAVE(act);
                break;
            case 28:
                Action_SET_SINEWAVE_ONEND1(act);
                break;
            case 29:
                Action_SET_SINEWAVE_ONEND2(act);
                break;
            case 30:
                Action_SET_SINEWAVE_ONEND3(act);
                break;
            case 31:
                Action_SET_SINEWAVE_ONEND4(act);
                break;

            //*** Simple Ellipse movement
            case 32:
                Action_SET_SIMPLEELLIPSE_CENTRE_X(act);
                break;
            case 33:
                Action_SET_SIMPLEELLIPSE_CENTRE_Y(act);
                break;
            case 34:
                Action_SET_SIMPLEELLIPSE_RADIUS_X(act);
                break;
            case 35:
                Action_SET_SIMPLEELLIPSE_RADIUS_Y(act);
                break;
            case 36:
                Action_SET_SIMPLEELLIPSE_ANGVEL(act);
                break;
            case 37:
                Action_SET_SIMPLEELLIPSE_CURRENTANGLE(act);
                break;
            case 38:
                Action_SET_SIMPLEELLIPSE_OFFSETANGLE(act);
                break;

            //*** Invaders movement
            case 39:
                Action_SET_INVADERS_SPEED(act);
                break;
            case 40:
                Action_SET_INVADERS_STEPX(act);
                break;
            case 41:
                Action_SET_INVADERS_STEPY(act);
                break;
            case 42:
                Action_SET_INVADERS_LEFTBORDER(act);
                break;
            case 43:
                Action_SET_INVADERS_RIGHTBORDER(act);
                break;

            //*** Vector movement
            case 44:
                Action_SET_Projectile_X(act);
                break;
            case 45:
                Action_SET_Projectile_Y(act);
                break;
            case 46:
                Action_SET_Projectile_XY(act);
                break;
            case 47:
                Action_SET_Projectile_MoveTowardsAngle(act);
                break;
            case 48:
                Action_SET_Projectile_MoveTowardsPoint(act);
                break;
            case 49:
                Action_SET_Projectile_MoveTowardsObject(act);
                break;
            case 50:
                Action_SET_Projectile_Dir(act);
                break;
            case 51:
                Action_SET_Projectile_DirToPoint(act);
                break;
            case 52:
                Action_SET_Projectile_DirToObject(act);
                break;
            case 53:
                Action_SET_Projectile_RotateTowardsAngle(act);
                break;
            case 54:
                Action_SET_Projectile_RotateTowardsPoint(act);
                break;
            case 55:
                Action_SET_Projectile_RotateTowardsObject(act);
                break;
            case 56:
                Action_SET_Projectile_Speed(act);
                break;
            case 57:
                Action_SET_Projectile_SpeedX(act);
                break;
            case 58:
                Action_SET_Projectile_SpeedY(act);
                break;
            case 59:
                Action_SET_Projectile_AddDirSpeedTowardsAngle(act);
                break;
            case 60:
                Action_SET_Projectile_AddDirSpeedTowardsPoint(act);
                break;
            case 61:
                Action_SET_Projectile_AddDirSpeedTowardsObject(act);
                break;
            case 62:
                Action_SET_Projectile_MinSpeed(act);
                break;
            case 63:
                Action_SET_Projectile_MaxSpeed(act);
                break;
            case 64:
                Action_SET_Projectile_Gravity(act);
                break;
            case 65:
                Action_SET_Projectile_GravityDir(act);
                break;
            case 66:
                Action_SET_Projectile_GravityDirToPoint(act);
                break;
            case 67:
                Action_SET_Projectile_GravityDirToObject(act);
                break;
            case 68:
                Action_SET_Projectile_BounceCoeff(act);
                break;
            case 69:
                Action_SET_Projectile_ForceBounce(act);
                break;

            //*** Presentation movement
            case 70:
                Action_SET_PRESENTATION_Next(act);
                break;
            case 71:
                Action_SET_PRESENTATION_Prev(act);
                break;
            case 72:
                Action_SET_PRESENTATION_ToStart(act);
                break;
            case 73:
                Action_SET_PRESENTATION_ToEnd(act);
                break;

            //*** Set Object
            case 74:
                Action_SetObject_Object(act);
                break;
            case 75:
                Action_SetObject_FixedValue(act);
                break;

            // Spaceship
            case 76:
                Action_SetPower(act);
                break;
            case 77:
                Action_SetSpeed(act);
                break;
            case 78:
                Action_SetDir(act);
                break;
            case 79:
                Action_SetDec(act);
                break;
            case 80:
                Action_SetRotSpeed(act);
                break;
            case 81:
                Action_SetGravity(act);
                break;
            case 82:
                Action_SetGravityDir(act);
                break;
            case 83:
                Action_ApplyReactor(act);
                break;
            case 84:
                Action_ApplyRotateRight(act);
                break;
            case 85:
                Action_ApplyRotateLeft(act);
                break;

                //*** Drag-drop Object
            case 86:
                Action_DragDrop_Method1(act);
                break;
            case 87:
                Action_DragDrop_Method2(act);
                break;
            case 88:
                Action_DragDrop_Method3(act);
                break;
            case 89:
                Action_DragDrop_Method4(act);
                break;
            case 90:
                Action_DragDrop_Method5(act);
                break;
            case 91:
                Action_DragDrop_IsLimited(act);
                break;
            case 92:
                Action_DragDrop_IsLimitedOff(act);
                break;
            case 93:
                Action_DragDrop_DropOutsideArea(act);
                break;
            case 94:
                Action_DragDrop_DropOutsideAreaOff(act);
                break;
            case 95:
                Action_DragDrop_ForceWithinLimits(act);
                break;
            case 96:
                Action_DragDrop_ForceWithinLimitsOff(act);
                break;
            case 97:
                Action_DragDrop_Area(act);
                break;
            case 98:
                Action_DragDrop_AreaX(act);
                break;
            case 99:
                Action_DragDrop_AreaY(act);
                break;
            case 100:
                Action_DragDrop_AreaW(act);
                break;
            case 101:
                Action_DragDrop_AreaH(act);
                break;
            case 102:
                Action_DragDrop_SnapToGrid(act);
                break;
            case 103:
                Action_DragDrop_SnapToGridOff(act);
                break;
            case 104:
                Action_DragDrop_GridOrigin(act);
                break;
            case 105:
                Action_DragDrop_GridX(act);
                break;
            case 106:
                Action_DragDrop_GridY(act);
                break;
            case 107:
                Action_DragDrop_GridW(act);
                break;
            case 108:
                Action_DragDrop_GridH(act);
                break;
        }
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        int value = 0;
        double dValue = 0.0;
        boolean bDouble = false;

        switch (num)
        {
            //*** Circular movement
            case 0:
                value = Expression_GET_CIRCLE_CENTRE_X();
                break;
            case 1:
                value = Expression_GET_CIRCLE_CENTRE_Y();
                break;
            case 2:
                value = Expression_GET_CIRCLE_ANGSPEED();
                break;
            case 3:
                value = Expression_GET_CIRCLE_CURRENTANGLE();
                break;
            case 4:
                value = Expression_GET_CIRCLE_RADIUS();
                break;
            case 5:
                value = Expression_GET_CIRCLE_SPIRALVEL();
                break;
            case 6:
                value = Expression_GET_CIRCLE_MINRADIUS();
                break;
            case 7:
                value = Expression_GET_CIRCLE_MAXRADIUS();
                break;
            case 8:
                value = Expression_GET_CIRCLE_COUNT();
                break;

            //*** Regular Polygon movement
            case 9:
                value = Expression_GET_REGPOLY_CENTRE_X();
                break;
            case 10:
                value = Expression_GET_REGPOLY_CENTRE_Y();
                break;
            case 11:
                value = Expression_GET_REGPOLY_NUMSIDES();
                break;
            case 12:
                value = Expression_GET_REGPOLY_RADIUS();
                break;
            case 13:
                value = Expression_GET_REGPOLY_ROTATION_ANGLE();
                break;
            case 14:
                value = Expression_GET_REGPOLY_VELOCITY();
                break;
            case 15:
                value = Expression_GET_REGPOLY_COUNT();
                break;

            //*** Sinewave movement
            case 16:
                value = Expression_GET_SINEWAVE_SPEED();
                break;
            case 17:
                value = Expression_GET_SINEWAVE_STARTX();
                break;
            case 18:
                value = Expression_GET_SINEWAVE_STARTY();
                break;
            case 19:
                value = Expression_GET_SINEWAVE_FINALX();
                break;
            case 20:
                value = Expression_GET_SINEWAVE_FINALY();
                break;
            case 21:
                value = Expression_GET_SINEWAVE_AMPLITUDE();
                break;
            case 22:
                value = Expression_GET_SINEWAVE_ANGVEL();
                break;
            case 23:
                value = Expression_GET_SINEWAVE_STARTANG();
                break;
            case 24:
                value = Expression_GET_SINEWAVE_CURRENTANGLE();
                break;
            case 25:
                value = Expression_GET_SINEWAVE_COUNT();
                break;

            //*** Simple Ellipse movement
            case 26:
                value = Expression_GET_SIMPLEELLIPSE_CENTRE_X();
                break;
            case 27:
                value = Expression_GET_SIMPLEELLIPSE_CENTRE_Y();
                break;
            case 28:
                value = Expression_GET_SIMPLEELLIPSE_RADIUS_X();
                break;
            case 29:
                value = Expression_GET_SIMPLEELLIPSE_RADIUS_Y();
                break;
            case 30:
                value = Expression_GET_SIMPLEELLIPSE_ANGVEL();
                break;
            case 31:
                value = Expression_GET_SIMPLEELLIPSE_CURRENTANGLE();
                break;
            case 32:
                value = Expression_GET_SIMPLEELLIPSE_OFFSETANGLE();
                break;
            case 33:
                value = Expression_GET_SIMPLEELLIPSE_COUNT();
                break;

            //*** Invaders movement
            case 34:
                value = Expression_GET_INVADERS_SPEED();
                break;
            case 35:
                value = Expression_GET_INVADERS_STEPX();
                break;
            case 36:
                value = Expression_GET_INVADERS_STEPY();
                break;
            case 37:
                value = Expression_GET_INVADERS_LEFTBORDER();
                break;
            case 38:
                value = Expression_GET_INVADERS_RIGHTBORDER();
                break;
            case 39:
                value = Expression_GET_INVADERS_COUNT();
                break;

            //*** Vector movement
            case 40:
                dValue = Expression_GET_Projectile_X();
                bDouble = true;
                break;
            case 41:
                dValue = Expression_GET_Projectile_Y();
                bDouble = true;
                break;
            case 42:
                dValue = Expression_GET_Projectile_Dir();
                bDouble = true;
                break;
            case 43:
                dValue = Expression_GET_Projectile_Speed();
                bDouble = true;
                break;
            case 44:
                dValue = Expression_GET_Projectile_SpeedX();
                bDouble = true;
                break;
            case 45:
                dValue = Expression_GET_Projectile_SpeedY();
                bDouble = true;
                break;
            case 46:
                dValue = Expression_GET_Projectile_MinSpeed();
                bDouble = true;
                break;
            case 47:
                dValue = Expression_GET_Projectile_MaxSpeed();
                bDouble = true;
                break;
            case 48:
                dValue = Expression_GET_Projectile_Gravity();
                bDouble = true;
                break;
            case 49:
                dValue = Expression_GET_Projectile_GravityDir();
                bDouble = true;
                break;
            case 50:
                dValue = Expression_GET_Projectile_BounceCoef();
                break;
            case 51:
                dValue = Expression_GET_Projectile_Count();
                bDouble = true;
                break;

            //*** Presentation movement
            case 52:
                value = Expression_GET_PRESENTATION_Index();
                break;
            case 53:
                value = Expression_GET_PRESENTATION_LastIndex();
                break;
            case 54:
                value = Expression_GET_PRESENTATION_Count();
                break;

            //*** General Expressions
            case 55:
                dValue = Expression_DistObjects();
                bDouble = true;
                break;
            case 56:
                dValue = Expression_DistPoints();
                bDouble = true;
                break;
            case 57:
                dValue = Expression_AngleObjects();
                bDouble = true;
                break;
            case 58:
                dValue = Expression_AnglePoints();
                bDouble = true;
                break;
            case 59:
                value = Expression_Angle2Dir();
                break;
            case 60:
                dValue = Expression_Dir2Angle();
                bDouble = true;
                break;

            // Spaceship movement
            case 61:
                value = Expression_SpaceShip_Gravity();
                break;
            case 62:
                value = Expression_SpaceShip_GravityDir();
                break;
            case 63:
                value = Expression_SpaceShip_Deceleration();
                break;
            case 64:
                value = Expression_SpaceShip_RotationSpeed();
                break;
            case 65:
                value = Expression_SpaceShip_ThrustPower();
                break;
            case 66:
                value = Expression_SpaceShip_Count();
                break;

            //*** Drag-drop Object
            case 67:
                value=Expression_DragDrop_AreaX();
                break;
            case 68:
                value=Expression_DragDrop_AreaY();
                break;
            case 69:
                value=Expression_DragDrop_AreaW();
                break;
            case 70:
                value=Expression_DragDrop_AreaH();
                break;
            case 71:
                value=Expression_DragDrop_GridX();
                break;
            case 72:
                value=Expression_DragDrop_GridY();
                break;
            case 73:
                value=Expression_DragDrop_GridW();
                break;
            case 74:
                value=Expression_DragDrop_GridH();
                break;

        }

        CValue ret = new CValue();
        if (bDouble == false)
        {
            ret.forceInt(value);
        }
        else
        {
            ret.forceDouble(dValue);
        }

        return ret;
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

                            if (dllName.equalsIgnoreCase (mvPtr.moduleName))
                                return hoPtr;

                            return null;
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

    int enumerateRuntimeObjects(String dllName)
    {
        int count = 0;

        // Enumerate objects
        CObject hoPtr;
        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
        {
            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
            {
                // Test if the object has a movement and this movement is an extension
                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
                {
                    CObjectCommon ocPtr = hoPtr.hoCommon;
                    CMoveDefExtension mvPtr = (CMoveDefExtension) ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum];
                    if (dllName.equalsIgnoreCase(mvPtr.moduleName))
                    {
                        count++;
                    }
                }
            }
        }
        return count;
    }

    CObject findObject(String dllName)
    {
        // Enumerate objects
        CObject hoPtr;
        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
        {
            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
            {
                // Test if the object has a movement and this movement is an extension
                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
                {
                    CObjectCommon ocPtr = hoPtr.hoCommon;
                    CMoveDefExtension mvPtr = (CMoveDefExtension) ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum];
                    if (dllName.equalsIgnoreCase(mvPtr.moduleName))
                    {
                        return hoPtr;
                    }
                }
            }
        }
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


    //*** Circular movement
    void Action_SET_CIRCLE_CENTRE_X(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_CENTRE_X, param1);
        }
    }

    void Action_SET_CIRCLE_CENTRE_Y(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_CENTRE_Y, param1);
        }
    }

    void Action_SET_CIRCLE_ANGSPEED(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_ANGSPEED, param1);
        }
    }

    void Action_SET_CIRCLE_CURRENTANGLE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_CURRENTANGLE, param1);
        }
    }

    void Action_SET_CIRCLE_RADIUS(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_RADIUS, param1);
        }
    }

    void Action_SET_CIRCLE_SPIRALVEL(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_SPIRALVEL, param1);
        }
    }

    void Action_SET_CIRCLE_MINRADIUS(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_MINRADIUS, param1);
        }
    }

    void Action_SET_CIRCLE_MAXRADIUS(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_CIRCLE_MAXRADIUS, param1);
        }
    }

    void Action_SET_CIRCLE_ONEND1(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 0);
        }
    }

    void Action_SET_CIRCLE_ONEND2(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 1);
        }
    }

    void Action_SET_CIRCLE_ONEND3(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 2);
        }
    }

    void Action_SET_CIRCLE_ONEND4(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_CIRCULAR);
        if (object != null)
        {
            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 3);
        }
    }

    //*** Regular Polygon movement
    void Action_SET_REGPOLY_CENTRE_X(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_CENTRE_X, param1);
        }
    }

    void Action_SET_REGPOLY_CENTRE_Y(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_CENTRE_Y, param1);
        }
    }

    void Action_SET_REGPOLY_NUMSIDES(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_NUMSIDES, param1);
        }
    }

    void Action_SET_REGPOLY_RADIUS(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_RADIUS, param1);
        }
    }

    void Action_SET_REGPOLY_ROTATION_ANGLE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_ROTATION_ANGLE, param1);
        }
    }

    void Action_SET_REGPOLY_VELOCITY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_REGPOLYGON);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_REGPOLY_VELOCITY, param1);
        }
    }

    //*** Sinewave movement
    void Action_SET_SINEWAVE_SPEED(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_SPEED, param1);
        }
    }

    void Action_SET_SINEWAVE_STARTX(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_STARTX, param1);
        }
    }

    void Action_SET_SINEWAVE_STARTY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_STARTY, param1);
        }
    }

    void Action_SET_SINEWAVE_FINALX(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_FINALX, param1);
        }
    }

    void Action_SET_SINEWAVE_FINALY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_FINALY, param1);
        }
    }

    void Action_SET_SINEWAVE_AMPLITUDE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_AMPLITUDE, param1);
        }
    }

    void Action_SET_SINEWAVE_ANGVEL(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_ANGVEL, param1);
        }
    }

    void Action_SET_SINEWAVE_STARTANG(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_STARTANG, param1);
        }
    }

    void Action_SET_SINEWAVE_CURRENTANGLE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SINEWAVE_CURRENTANGLE, param1);
        }
    }

    void Action_RESET_SINEWAVE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            ho.callMovement(object, RESET_SINEWAVE, 0);
        }
    }

    void Action_SET_SINEWAVE_ONEND1(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 0);
        }
    }

    void Action_SET_SINEWAVE_ONEND2(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 1);
        }
    }

    void Action_SET_SINEWAVE_ONEND3(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 2);
        }
    }

    void Action_SET_SINEWAVE_ONEND4(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SINEWAVE);
        if (object != null)
        {
            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 3);
        }
    }

    //*** Simple Ellipse movement
    void Action_SET_SIMPLEELLIPSE_CENTRE_X(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_CENTRE_X, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_CENTRE_Y(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_CENTRE_Y, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_RADIUS_X(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_RADIUS_X, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_RADIUS_Y(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_RADIUS_Y, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_ANGVEL(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_ANGSPEED, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_CURRENTANGLE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_CURRENTANGLE, param1);
        }
    }

    void Action_SET_SIMPLEELLIPSE_OFFSETANGLE(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_SIMPLEELLIPSE_OFFSETANGLE, param1);
        }
    }

    //*** Invaders movement
    void Action_SET_INVADERS_SPEED(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_INVADERS);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_INVADERS_SPEED, param1);
        }
    }

    void Action_SET_INVADERS_STEPX(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_INVADERS);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_INVADERS_STEPX, param1);
        }
    }

    void Action_SET_INVADERS_STEPY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_INVADERS);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_INVADERS_STEPY, param1);
        }
    }

    void Action_SET_INVADERS_LEFTBORDER(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_INVADERS);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_INVADERS_LEFTBORDER, param1);
        }
    }

    void Action_SET_INVADERS_RIGHTBORDER(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_INVADERS);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_INVADERS_RIGHTBORDER, param1);
        }
    }

    //*** Projectile movement
    void Action_SET_Projectile_X(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_X, param1);
        }
    }

    void Action_SET_Projectile_Y(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_Y, param1);
        }
    }

    void Action_SET_Projectile_XY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int x = act.getParamExpression(rh, 0);
            int y = act.getParamExpression(rh, 1);
            ho.callMovement(object, SET_Projectile_X, x);
            ho.callMovement(object, SET_Projectile_Y, y);
        }
    }

    void Action_SET_Projectile_MoveTowardsAngle(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double angle = act.getParamExpression(rh, 0) * ToRadians;
            int distance = act.getParamExpression(rh, 1);

            int addDistX = (int) (distance * Math.cos(angle) + 0.5);
            int addDistY = (int) (distance * Math.sin(angle) + 0.5);

            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
        }
    }
    //-----------------------------------------------
    // Fast arctan2

    private double arctan2(double y, double x)
    {
        double coeff_1 = Math.PI / 4;
        double coeff_2 = 3 * coeff_1;
        double abs_y = Math.abs(y) + 1e-10;      // kludge to prevent 0/0 condition
        double r, angle;
        if (x >= 0)
        {
            r = (x - abs_y) / (x + abs_y);
            angle = coeff_1 - coeff_1 * r;
        }
        else
        {
            r = (x + abs_y) / (abs_y - x);
            angle = coeff_2 - coeff_1 * r;
        }
        if (y < 0)
        {
            return (-angle);     // negate if in quad III or IV
        }
        else
        {
            return (angle);
        }
    }

    void Action_SET_Projectile_MoveTowardsPoint(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);

            double fp3 = act.getParamExpDouble(rh, 0);
            double fp4 = act.getParamExpDouble(rh, 1);
            int distance = act.getParamExpression(rh, 2);

            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            int addDistX = (int) (distance * Math.cos(angle) + 0.5);
            int addDistY = (int) (distance * Math.sin(angle) + 0.5);

            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
        }
    }

    void Action_SET_Projectile_MoveTowardsObject(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            CObject p2 = act.getParamObject(rh, 0);

            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);

            double fp3 = p2.hoX;
            double fp4 = p2.hoY;
            int distance = act.getParamExpression(rh, 1);

            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            int addDistX = (int) (distance * Math.cos(angle) + 0.5);
            int addDistY = (int) (distance * Math.sin(angle) + 0.5);

            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
        }
    }

    void Action_SET_Projectile_Dir(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_Dir, param1);
        }
    }

    void Action_SET_Projectile_DirToPoint(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);

            double fp3 = act.getParamExpDouble(rh, 0);
            double fp4 = act.getParamExpDouble(rh, 1);

            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            if (angle < 0)
            {
                angle += 6.283185;
            }
            angle *= ToDegrees;

            ho.callMovement(object, SET_Projectile_Dir, (int) angle);
        }
    }

    void Action_SET_Projectile_DirToObject(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            CObject p2 = act.getParamObject(rh, 0);

            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);

            double fp3 = p2.hoX;
            double fp4 = p2.hoY;

            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            if (angle < 0)
            {
                angle += 6.283185;
            }
            angle *= ToDegrees;

            ho.callMovement(object, SET_Projectile_Dir, (int) angle);
        }
    }

    void Action_SET_Projectile_RotateTowardsAngle(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            int param2 = act.getParamExpression(rh, 1);
            double newangleTow = param1 % 360;	// angle towards
            double newangleAdd = param2 % 360;	// angle to add

            double currentAngle = ho.callMovement(object, GET_Projectile_Dir, 0);

            double difM = currentAngle - newangleTow;
            if (difM < 0)
            {
                difM += 360;
            }

            double difA = 360 - difM;

            if (difM <= difA)
            {
                if (difM < newangleAdd)
                {
                    currentAngle -= difM;
                }
                else
                {
                    currentAngle -= newangleAdd;
                }
            }
            else
            {
                if (difA < newangleAdd)
                {
                    currentAngle += difA;
                }
                else
                {
                    currentAngle += newangleAdd;
                }
            }
            ho.callMovement(object, SET_Projectile_Dir, (int) currentAngle);
        }
    }

    void Action_SET_Projectile_RotateTowardsPoint(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
            double currentAngle = ho.callMovement(object, GET_Projectile_Dir, 0);

            double fp3 = act.getParamExpDouble(rh, 0);
            double fp4 = act.getParamExpDouble(rh, 1);

            double newangleAdd = act.getParamExpDouble(rh, 2) % 360;
            double newangleTow = (arctan2(fp2 - fp4, fp3 - fp1) * ToDegrees);

            if (newangleTow < 0)
            {
                newangleTow += 360;
            }

            double difM = currentAngle - newangleTow;
            if (difM < 0)
            {
                difM += 360;
            }

            double difA = 360 - difM;

            if (difM <= difA)
            {
                if (difM < newangleAdd)
                {
                    currentAngle -= difM;
                }
                else
                {
                    currentAngle -= newangleAdd;
                }
            }
            else
            {
                if (difA < newangleAdd)
                {
                    currentAngle += difA;
                }
                else
                {
                    currentAngle += newangleAdd;
                }
            }
            ho.callMovement(object, SET_Projectile_Dir, (int) currentAngle);
        }
    }

    void Action_SET_Projectile_RotateTowardsObject(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            CObject p2 = act.getParamObject(rh, 0);

            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
            double currentAngle = ho.callMovement(object, GET_Projectile_Dir, 0);
            double fp3 = p2.hoX;
            double fp4 = p2.hoY;
            double newangleAdd = act.getParamExpDouble(rh, 1) % 360;
            double newangleTow = (arctan2(fp2 - fp4, fp3 - fp1) * ToDegrees);

            if (newangleTow < 0)
            {
                newangleTow += 360;
            }

            double difM = currentAngle - newangleTow;
            if (difM < 0)
            {
                difM += 360;
            }

            double difA = 360 - difM;

            if (difM <= difA)
            {
                if (difM < newangleAdd)
                {
                    currentAngle -= difM;
                }
                else
                {
                    currentAngle -= newangleAdd;
                }
            }
            else
            {
                if (difA < newangleAdd)
                {
                    currentAngle += difA;
                }
                else
                {
                    currentAngle += newangleAdd;
                }
            }
            ho.callMovement(object, SET_Projectile_Dir, (int) currentAngle);
        }
    }

    void Action_SET_Projectile_Speed(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_Speed, param1);
        }
    }

    void Action_SET_Projectile_SpeedX(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_SpeedX, param1);
        }
    }

    void Action_SET_Projectile_SpeedY(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_SpeedY, param1);
        }
    }

    void Action_SET_Projectile_AddDirSpeedTowardsAngle(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double angle = act.getParamExpression(rh, 0) * ToRadians;
            int speed = act.getParamExpression(rh, 1);

            int addSpeedX = (int) (speed * Math.cos(angle) + 0.5);
            int addSpeedY = (int) (speed * Math.sin(angle) + 0.5);

            ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
            ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
        }
    }

    void Action_SET_Projectile_AddDirSpeedTowardsPoint(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
            double fp3 = act.getParamExpDouble(rh, 0);
            double fp4 = act.getParamExpDouble(rh, 1);
            int speed = act.getParamExpression(rh, 2);

            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            int addSpeedX = (int) (speed * Math.cos(angle) + 0.5);
            int addSpeedY = (int) (speed * Math.sin(angle) + 0.5);

            ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
            ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
        }
    }

    void Action_SET_Projectile_AddDirSpeedTowardsObject(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            CObject p2 = act.getParamObject(rh, 0);

            if(p2 != null)
            {
                double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
                double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
                double fp3 = p2.hoX;
                double fp4 = p2.hoY;
                int speed = act.getParamExpression(rh, 1);
                double angle = (arctan2(fp2 - fp4, fp3 - fp1));

                int addSpeedX = (int) (speed * Math.cos(angle) + 0.5);
                int addSpeedY = (int) (speed * Math.sin(angle) + 0.5);

                ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
                ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
            }
        }
    }

    void Action_SET_Projectile_MinSpeed(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_MinSpeed, param1);
        }
    }

    void Action_SET_Projectile_MaxSpeed(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_MaxSpeed, param1);
        }
    }

    void Action_SET_Projectile_Gravity(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_Gravity, param1);
        }
    }

    void Action_SET_Projectile_GravityDir(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_GravityDir, param1);
        }
    }

    void Action_SET_Projectile_GravityDirToPoint(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
            double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
            double fp3 = act.getParamExpDouble(rh, 0);
            double fp4 = act.getParamExpDouble(rh, 1);
            double angle = (arctan2(fp2 - fp4, fp3 - fp1));

            if (angle < 0)
            {
                angle += 6.283185;
            }
            angle *= ToDegrees;

            ho.callMovement(object, SET_Projectile_GravityDir, (int) angle);
        }
    }

    void Action_SET_Projectile_GravityDirToObject(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
            CObject p2 = act.getParamObject(rh, 0);

            if(p2 != null)
            {
                double fp1 = ho.callMovement(object, GET_Projectile_X, 0);
                double fp2 = ho.callMovement(object, GET_Projectile_Y, 0);
                double fp3 = p2.hoX;
                double fp4 = p2.hoY;
                double angle = (arctan2(fp2 - fp4, fp3 - fp1));

                if (angle < 0)
                {
                    angle += 6.283185;
                }
                angle *= ToDegrees;

                ho.callMovement(object, SET_Projectile_GravityDir, (int) angle);
            }
        }
    }

    void Action_SET_Projectile_BounceCoeff(CActExtension act)
    {
        //callRunTimeFunction2(((LPRDATA)param1), RFUNCTION_CALLMOVEMENT, SET_Projectile_Y, param2);
    }

    void Action_SET_Projectile_ForceBounce(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_VECTOR);
        if (object != null)
        {
        	int param1=act.getParamExpression(rh, 0);
            ho.callMovement(object, SET_Projectile_ForceBounce, param1);
        }
    }

    //*** Presentation movement
    void Action_SET_PRESENTATION_Next(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_PRESENTATION);
        if (object != null)
        {
            ho.callMovement(object, SET_PRESENTATION_Next, 0);
        }
    }

    void Action_SET_PRESENTATION_Prev(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_PRESENTATION);
        if (object != null)
        {
            ho.callMovement(object, SET_PRESENTATION_Prev, 0);
        }
    }

    void Action_SET_PRESENTATION_ToStart(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_PRESENTATION);
        if (object != null)
        {
            ho.callMovement(object, SET_PRESENTATION_ToStart, 0);
        }
    }

    void Action_SET_PRESENTATION_ToEnd(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_PRESENTATION);
        if (object != null)
        {
            ho.callMovement(object, SET_PRESENTATION_ToEnd, 0);
        }
    }

    // Spaceship movement
    void Action_SetPower(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETPOWER, param1);
        }
    }

    void Action_SetSpeed(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETSPEED, param1);
        }
    }

    void Action_SetDir(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETDIR, param1);
        }
    }

    void Action_SetDec(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETDEC, param1);
        }
    }

    void Action_SetRotSpeed(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETROTSPEED, param1);
        }
    }

    void Action_SetGravity(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETGRAVITY, param1);
        }
    }

    void Action_SetGravityDir(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            int param1 = act.getParamExpression(rh, 0);
            ho.callMovement(object, SPACE_SETGRAVITYDIR, param1);
        }
    }

    void Action_ApplyReactor(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            ho.callMovement(object, SPACE_APPLYREACTOR, 0);
        }
    }

    void Action_ApplyRotateRight(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            ho.callMovement(object, SPACE_APPLYROTATERIGHT, 0);
        }
    }

    void Action_ApplyRotateLeft(CActExtension act)
    {
        CObject object = getCurrentObject(DLL_SPACESHIP);
        if (object != null)
        {
            ho.callMovement(object, SPACE_APPLYROTATELEFT, 0);
        }
    }

    //*** Drag-drop movement
    void Action_DragDrop_Method1(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_Method, 0);
    }
    void Action_DragDrop_Method2(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_Method, 1);
    }
    void Action_DragDrop_Method3(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_Method, 2);
    }
    void Action_DragDrop_Method4(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_Method, 3);
    }
    void Action_DragDrop_Method5(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_Method, 4);
    }

    void Action_DragDrop_IsLimited(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_IsLimited, 1);
    }

    void Action_DragDrop_IsLimitedOff(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_IsLimited, 0);
    }

    void Action_DragDrop_DropOutsideArea(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_DropOutsideArea, 1);
    }

    void Action_DragDrop_DropOutsideAreaOff(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_DropOutsideArea, 0);
    }

    void Action_DragDrop_ForceWithinLimits(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_ForceWithinLimits, 1);
    }

    void Action_DragDrop_ForceWithinLimitsOff(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_ForceWithinLimits, 0);
    }

    void Action_DragDrop_Area(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        PARAM_ZONE area = act.getParamZone(rh, 0);	// PARAM_AREA structure; 0=? 1=? 2=X1 3=Y1 4=X2 5=Y2

        if (object!=null)
        {
            ho.callMovement(object, SET_DragDrop_AreaX, area.x1);
            ho.callMovement(object, SET_DragDrop_AreaY, area.y1);
            ho.callMovement(object, SET_DragDrop_AreaW, area.x2 - area.x1);
            ho.callMovement(object, SET_DragDrop_AreaH, area.y2 - area.y1);
        }
    }

    void Action_DragDrop_AreaX(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_AreaX, param1);
    }

    void Action_DragDrop_AreaY(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_AreaY, param1);
    }

    void Action_DragDrop_AreaW(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_AreaW, param1);
    }

    void Action_DragDrop_AreaH(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_AreaH, param1);
    }

    void Action_DragDrop_SnapToGrid(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_SnapToGrid, 1);
    }

    void Action_DragDrop_SnapToGridOff(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_SnapToGrid, 0);
    }

    void Action_DragDrop_GridOrigin(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        CPositionInfo info=act.getParamPosition(rh, 0);
        if (object!=null)
        {
            ho.callMovement(object, SET_DragDrop_GridX, info.x);
            ho.callMovement(object, SET_DragDrop_GridY, info.y);
        }
    }

    void Action_DragDrop_GridX(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_GridX, param1);
    }

    void Action_DragDrop_GridY(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_GridY, param1);
    }

    void Action_DragDrop_GridW(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_GridW, param1);
    }

    void Action_DragDrop_GridH(CActExtension act)
    {
        CObject object=getCurrentObject(DLL_DRAGDROP);
        int param1=act.getParamExpression(rh, 0);
        if (object!=null)
            ho.callMovement(object, SET_DragDrop_GridH, param1);
    }

    // ============================================================================
    //
    // EXPRESSIONS ROUTINES
    //
    // ============================================================================

    //*** Circular movement
    int Expression_GET_CIRCLE_CENTRE_X()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_CENTRE_X, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_CENTRE_Y()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_CENTRE_Y, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_ANGSPEED()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_ANGSPEED, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_CURRENTANGLE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_CURRENTANGLE, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_RADIUS()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_RADIUS, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_SPIRALVEL()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_SPIRALVEL, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_MINRADIUS()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_MINRADIUS, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_MAXRADIUS()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_CIRCULAR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_CIRCLE_MAXRADIUS, 0);
        }
        return 0;
    }

    int Expression_GET_CIRCLE_COUNT()
    {
        return enumerateRuntimeObjects(DLL_CIRCULAR);
    }


    //*** Regular Polygon movement
    int Expression_GET_REGPOLY_CENTRE_X()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_CENTRE_X, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_CENTRE_Y()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_CENTRE_Y, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_NUMSIDES()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_NUMSIDES, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_RADIUS()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_RADIUS, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_ROTATION_ANGLE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_ROTATION_ANGLE, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_VELOCITY()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_REGPOLYGON);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_REGPOLY_VELOCITY, 0);
        }
        return 0;
    }

    int Expression_GET_REGPOLY_COUNT()
    {
        return enumerateRuntimeObjects(DLL_REGPOLYGON);
    }


    //*** Sinewave movement
    int Expression_GET_SINEWAVE_SPEED()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_SPEED, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_STARTX()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_STARTX, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_STARTY()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_STARTY, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_FINALX()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_FINALX, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_FINALY()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_FINALY, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_AMPLITUDE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_AMPLITUDE, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_ANGVEL()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_ANGVEL, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_STARTANG()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_STARTANG, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_CURRENTANGLE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SINEWAVE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SINEWAVE_CURRENTANGLE, 0);
        }
        return 0;
    }

    int Expression_GET_SINEWAVE_COUNT()
    {
        return enumerateRuntimeObjects(DLL_SINEWAVE);
    }


    //*** Simple Ellipse movement
    int Expression_GET_SIMPLEELLIPSE_CENTRE_X()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_CENTRE_X, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_CENTRE_Y()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_CENTRE_Y, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_RADIUS_X()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_RADIUS_X, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_RADIUS_Y()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_RADIUS_Y, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_ANGVEL()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_ANGSPEED, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_CURRENTANGLE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_CURRENTANGLE, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_OFFSETANGLE()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SIMPLE_ELLIPSE);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_SIMPLEELLIPSE_OFFSETANGLE, 0);
        }
        return 0;
    }

    int Expression_GET_SIMPLEELLIPSE_COUNT()
    {
        return enumerateRuntimeObjects(DLL_SIMPLE_ELLIPSE);
    }

    //*** Invaders movement
    int Expression_GET_INVADERS_SPEED()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_INVADERS);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_INVADERS_SPEED, 0);
        }
        return 0;
    }

    int Expression_GET_INVADERS_STEPX()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_INVADERS);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_INVADERS_STEPX, 0);
        }
        return 0;
    }

    int Expression_GET_INVADERS_STEPY()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_INVADERS);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_INVADERS_STEPY, 0);
        }
        return 0;
    }

    int Expression_GET_INVADERS_LEFTBORDER()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_INVADERS);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_INVADERS_LEFTBORDER, 0);
        }
        return 0;
    }

    int Expression_GET_INVADERS_RIGHTBORDER()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_INVADERS);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, GET_INVADERS_RIGHTBORDER, 0);
        }
        return 0;
    }

    int Expression_GET_INVADERS_COUNT()
    {
        return enumerateRuntimeObjects(DLL_INVADERS);
    }

    //*** Projectile movements
    double Expression_GET_Projectile_X()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_X, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_Y()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_Y, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_Dir()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_Dir, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_Speed()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_Speed, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_SpeedX()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_SpeedX, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_SpeedY()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_SpeedY, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_MinSpeed()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_MinSpeed, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_MaxSpeed()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_MaxSpeed, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_Gravity()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_Gravity, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_GravityDir()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_GravityDir, 0);
        }
        return 0;
    }

    double Expression_GET_Projectile_BounceCoef()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_VECTOR);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return ho.callMovement(object, GET_Projectile_BounceCoef, 0);
        }
        return 0;
    }

    int Expression_GET_Projectile_Count()
    {
        return enumerateRuntimeObjects(DLL_VECTOR);
    }

    //*** Presentation movement
    int Expression_GET_PRESENTATION_Index()
    {
        CObject object = findObject(DLL_PRESENTATION);
        if (object != null)
        {
            return (int) ho.callMovement(object, GET_PRESENTATION_Index, 0);
        }
        return -1;
    }

    int Expression_GET_PRESENTATION_LastIndex()
    {
        CObject object = findObject(DLL_PRESENTATION);
        if (object != null)
        {
            return (int) ho.callMovement(object, GET_PRESENTATION_LastIndex, 0);
        }
        return -1;
    }

    int Expression_GET_PRESENTATION_Count()
    {
        return enumerateRuntimeObjects(DLL_PRESENTATION);
    }

    //*** Spaceship movement
    int Expression_SpaceShip_Gravity()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SPACESHIP);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, SPACE_GETGRAVITY, 0);
        }
        return -1;
    }

    int Expression_SpaceShip_GravityDir()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SPACESHIP);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, SPACE_GETGRAVITYDIR, 0);
        }
        return -1;
    }

    int Expression_SpaceShip_Deceleration()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SPACESHIP);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, SPACE_GETDECELERATION, 0);
        }
        return -1;
    }

    int Expression_SpaceShip_RotationSpeed()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SPACESHIP);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, SPACE_GETROTATIONSPEED, 0);
        }
        return -1;
    }

    int Expression_SpaceShip_ThrustPower()
    {
        int p1 = ho.getExpParam().getInt();
        CObject object;
        if (p1 == 0)
        {
            object = getCurrentObject(DLL_SPACESHIP);
        }
        else
        {
            object = ho.getObjectFromFixed(p1);
        }

        if (object != null)
        {
            return (int) ho.callMovement(object, SPACE_GETTHRUSTPOWER, 0);
        }
        return -1;
    }

    int Expression_SpaceShip_Count()
    {
        return enumerateRuntimeObjects(DLL_SPACESHIP);
    }

    //*** General Expressions
    double Expression_DistObjects()
    {
        int p1 = ho.getExpParam().getInt();
        int p2 = ho.getExpParam().getInt();

        CObject object1, object2;
        if (p1 == 0)
        {
            object1 = getCurrentObject(null);
        }
        else
        {
            object1 = ho.getObjectFromFixed(p1);
        }

        if (p2 == 0)
        {
            object2 = getCurrentObject(null);
        }
        else
        {
            object2 = ho.getObjectFromFixed(p2);
        }

        if (object1 == null || object2 == null)
        {
            return -1;
        }

        double fp1 = object1.hoX;
        double fp2 = object1.hoY;
        double fp3 = object2.hoX;
        double fp4 = object2.hoY;
        return Math.sqrt((fp1 - fp3) * (fp1 - fp3) + (fp2 - fp4) * (fp2 - fp4));
    }

    double Expression_DistPoints()
    {
        double fp1 = ho.getExpParam().getDouble();
        double fp2 = ho.getExpParam().getDouble();
        double fp3 = ho.getExpParam().getDouble();
        double fp4 = ho.getExpParam().getDouble();

        return Math.sqrt((fp1 - fp3) * (fp1 - fp3) + (fp2 - fp4) * (fp2 - fp4));
    }

    double Expression_AngleObjects()
    {
        int p1 = ho.getExpParam().getInt();
        int p2 = ho.getExpParam().getInt();

        CObject object1, object2;
        if (p1 == 0)
        {
            object1 = getCurrentObject(null);
        }
        else
        {
            object1 = ho.getObjectFromFixed(p1);
        }

        if (p2 == 0)
        {
            object2 = getCurrentObject(null);
        }
        else
        {
            object2 = ho.getObjectFromFixed(p2);
        }

        if (object1 == null || object2 == null)
        {
            return -1;
        }

        double fp1 = object1.hoX;
        double fp2 = object1.hoY;
        double fp3 = object2.hoX;
        double fp4 = object2.hoY;

        //double fp5 = (arctan2(fp2 - fp4, fp3 - fp1));
        double fp5 = Math.atan2(fp2 - fp4, fp3 - fp1);

        if (fp5 < 0)
        {
            fp5 += 6.283185;
        }
        fp5 *= ToDegrees;
        return fp5;
    }

    double Expression_AnglePoints()
    {
        double fp1 = ho.getExpParam().getDouble();
        double fp2 = ho.getExpParam().getDouble();
        double fp3 = ho.getExpParam().getDouble();
        double fp4 = ho.getExpParam().getDouble();

        //double fp5 = (arctan2(fp2 - fp4, fp3 - fp1));
        double fp5 = Math.atan2(fp2 - fp4, fp3 - fp1);

        if (fp5 < 0)
        {
            fp5 += 6.283185;
        }
        fp5 *= ToDegrees;
        return fp5;
    }

    int Expression_Angle2Dir()
    {
        int angle = ho.getExpParam().getInt();
        int dir = (int) ((((angle + 5.625) / 11.25)) % 32);
        return dir;
    }

    double Expression_Dir2Angle()
    {
        int p1 = ho.getExpParam().getInt();
        double dir = ((p1 % 32) * 11.25);
        return dir;
    }

    //*** Drag-drop movement
    int Expression_DragDrop_AreaX()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_AreaX, 0);

        return 0;
    }

    int Expression_DragDrop_AreaY()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_AreaY, 0);

        return 0;
    }

    int Expression_DragDrop_AreaW()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_AreaW, 0);

        return 0;
    }

    int Expression_DragDrop_AreaH()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_AreaH, 0);

        return 0;
    }

    int Expression_DragDrop_GridX()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_GridX, 0);

        return 0;
    }

    int Expression_DragDrop_GridY()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_GridY, 0);

        return 0;
    }

    int Expression_DragDrop_GridW()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_GridW, 0);

        return 0;
    }

    int Expression_DragDrop_GridH()
    {
        CObject object;
        int p1 = ho.getExpParam().getInt();
        if( p1 == 0 )
            object = getCurrentObject(DLL_DRAGDROP);
        else
            object = ho.getObjectFromFixed(p1);

        if(object != null)
            return (int) ho.callMovement(object, GET_DragDrop_GridH, 0);

        return 0;
    }


}
