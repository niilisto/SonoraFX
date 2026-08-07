//----------------------------------------------------------------------------------
//
// MOVEMENT CONTROLLER: extension object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.PARAM_ZONE;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	import Params.*;

	public class CRunclickteam_movement_controller extends CRunExtension
	{
	    //*** Circular movement
	    public static var SET_CIRCLE_CENTRE_X:int=3345;
	    public static var SET_CIRCLE_CENTRE_Y:int=3346;
	    public static var SET_CIRCLE_ANGSPEED:int=3347;
	    public static var SET_CIRCLE_CURRENTANGLE:int=3348;
	    public static var SET_CIRCLE_RADIUS:int=3349;
	    public static var SET_CIRCLE_SPIRALVEL:int=3350;
	    public static var SET_CIRCLE_MINRADIUS:int=3351;
	    public static var SET_CIRCLE_MAXRADIUS:int=3352;
	    public static var SET_CIRCLE_ONCOMPLETION:int=3353;
	    public static var GET_CIRCLE_CENTRE_X:int=3354;
	    public static var GET_CIRCLE_CENTRE_Y:int=3355;
	    public static var GET_CIRCLE_ANGSPEED:int=3356;
	    public static var GET_CIRCLE_CURRENTANGLE:int=3357;
	    public static var GET_CIRCLE_RADIUS:int=3358;
	    public static var GET_CIRCLE_SPIRALVEL:int=3359;
	    public static var GET_CIRCLE_MINRADIUS:int=3360;
	    public static var GET_CIRCLE_MAXRADIUS:int=3361;
	    
	    //*** Regular Polygon movement
	    public static var SET_REGPOLY_CENTRE_X:int=3445;
	    public static var SET_REGPOLY_CENTRE_Y:int=3446;
	    public static var SET_REGPOLY_NUMSIDES:int=3447;
	    public static var SET_REGPOLY_RADIUS:int=3448;
	    public static var SET_REGPOLY_ROTATION_ANGLE:int=3449;
	    public static var SET_REGPOLY_VELOCITY:int=3450;
	    public static var GET_REGPOLY_CENTRE_X:int=3451;
	    public static var GET_REGPOLY_CENTRE_Y:int=3452;
	    public static var GET_REGPOLY_NUMSIDES:int=3453;
	    public static var GET_REGPOLY_RADIUS:int=3454;
	    public static var GET_REGPOLY_ROTATION_ANGLE:int=3455;
	    public static var GET_REGPOLY_VELOCITY:int=3456;
	    
	    //*** Sinewave movement
	    public static var SET_SINEWAVE_SPEED:int=3545;
	    public static var SET_SINEWAVE_STARTX:int=3546;
	    public static var SET_SINEWAVE_STARTY:int=3547;
	    public static var SET_SINEWAVE_FINALX:int=3548;
	    public static var SET_SINEWAVE_FINALY:int=3549;
	    public static var SET_SINEWAVE_AMPLITUDE:int=3550;
	    public static var SET_SINEWAVE_ANGVEL:int=3551;
	    public static var SET_SINEWAVE_STARTANG:int=3552;
	    public static var SET_SINEWAVE_CURRENTANGLE:int=3553;
	    public static var GET_SINEWAVE_SPEED:int=3554;
	    public static var GET_SINEWAVE_STARTX:int=3555;
	    public static var GET_SINEWAVE_STARTY:int=3556;
	    public static var GET_SINEWAVE_FINALX:int=3557;
	    public static var GET_SINEWAVE_FINALY:int=3558;
	    public static var GET_SINEWAVE_AMPLITUDE:int=3559;
	    public static var GET_SINEWAVE_ANGVEL:int=3560;
	    public static var GET_SINEWAVE_STARTANG:int=3561;
	    public static var GET_SINEWAVE_CURRENTANGLE:int=3562;
	    public static var RESET_SINEWAVE:int=3563;
	    public static var SET_SINEWAVE_ONCOMPLETION:int=3564;
	    
	    //*** Simple Ellipse movement
	    public static var SET_SIMPLEELLIPSE_CENTRE_X:int=3645;
	    public static var SET_SIMPLEELLIPSE_CENTRE_Y:int=3646;
	    public static var SET_SIMPLEELLIPSE_RADIUS_X:int=3647;
	    public static var SET_SIMPLEELLIPSE_RADIUS_Y:int=3648;
	    public static var SET_SIMPLEELLIPSE_ANGSPEED:int=3649;
	    public static var SET_SIMPLEELLIPSE_CURRENTANGLE:int=3650;
	    public static var SET_SIMPLEELLIPSE_OFFSETANGLE:int=3651;
	    public static var GET_SIMPLEELLIPSE_CENTRE_X:int=3652;
	    public static var GET_SIMPLEELLIPSE_CENTRE_Y:int=3653;
	    public static var GET_SIMPLEELLIPSE_RADIUS_X:int=3654;
	    public static var GET_SIMPLEELLIPSE_RADIUS_Y:int=3655;
	    public static var GET_SIMPLEELLIPSE_ANGSPEED:int=3656;
	    public static var GET_SIMPLEELLIPSE_CURRENTANGLE:int=3657;
	    public static var GET_SIMPLEELLIPSE_OFFSETANGLE:int=3658;
	    
	    //*** Invaders movement
	    public static var SET_INVADERS_SPEED:int=3745;
	    public static var SET_INVADERS_STEPX:int=3746;
	    public static var SET_INVADERS_STEPY:int=3747;
	    public static var SET_INVADERS_LEFTBORDER:int=3748;
	    public static var SET_INVADERS_RIGHTBORDER:int=3749;
	    public static var GET_INVADERS_SPEED:int=3750;
	    public static var GET_INVADERS_STEPX:int=3751;
	    public static var GET_INVADERS_STEPY:int=3752;
	    public static var GET_INVADERS_LEFTBORDER:int=3753;
	    public static var GET_INVADERS_RIGHTBORDER:int=3754;
	    
	    //*** Vector movement
	    public static var SET_Projectile_X:int=3845;
	    public static var SET_Projectile_Y:int=3846;
	    public static var SET_Projectile_XY:int=3847;
	    public static var SET_Projectile_AddDistX:int=3848;
	    public static var SET_Projectile_AddDistY:int=3849;
	    public static var SET_Projectile_Dir:int=3850;
	    public static var SET_Projectile_RotateTowardsAngle:int=3851;
	    public static var SET_Projectile_RotateTowardsPoint:int=3852;
	    public static var SET_Projectile_RotateTowardsObject:int=3853;
	    public static var SET_Projectile_Speed:int=3854;
	    public static var SET_Projectile_SpeedX:int=3855;
	    public static var SET_Projectile_SpeedY:int=3856;
	    public static var SET_Projectile_AddSpeedX:int=3857;
	    public static var SET_Projectile_AddSpeedY:int=3858;
	    public static var SET_Projectile_MinSpeed:int=3859;
	    public static var SET_Projectile_MaxSpeed:int=3860;
	    public static var SET_Projectile_Gravity:int=3861;
	    public static var SET_Projectile_GravityDir:int=3862;
	    public static var SET_Projectile_BounceCoeff:int=3863;
	    public static var SET_Projectile_ForceBounce:int=3864;
	    
	    public static var GET_Projectile_X:int=3865;
	    public static var GET_Projectile_Y:int=3866;
	    public static var GET_Projectile_Dir:int=3867;
	    public static var GET_Projectile_Speed:int=3868;
	    public static var GET_Projectile_SpeedX:int=3869;
	    public static var GET_Projectile_SpeedY:int=3870;
	    public static var GET_Projectile_MinSpeed:int=3871;
	    public static var GET_Projectile_MaxSpeed:int=3872;
	    public static var GET_Projectile_Gravity:int=3873;
	    public static var GET_Projectile_GravityDir:int=3874;
	    public static var GET_Projectile_BounceCoef:int=3875;
	    
	    //*** Presentation movement
	    public static var SET_PRESENTATION_Next:int=3945;
	    public static var SET_PRESENTATION_Prev:int=3946;
	    public static var SET_PRESENTATION_ToStart:int=3947;
	    public static var SET_PRESENTATION_ToEnd:int=3948;
	    public static var GET_PRESENTATION_Index:int=3949;
	    public static var GET_PRESENTATION_LastIndex:int=3950;
	    
		//*** SpaceShip movement
	    public static var SPACE_SETPOWER:int=0;
	    public static var SPACE_SETSPEED:int=1;
	    public static var SPACE_SETDIR:int=2;
	    public static var SPACE_SETDEC:int=3;
	    public static var SPACE_SETROTSPEED:int=4;
	    public static var SPACE_SETGRAVITY:int=5;
	    public static var SPACE_SETGRAVITYDIR:int=6;
	    public static var SPACE_APPLYREACTOR:int=7;
	    public static var SPACE_APPLYROTATERIGHT:int=8;
	    public static var SPACE_APPLYROTATELEFT:int=9;
	    public static var SPACE_GETGRAVITY:int=10;
	    public static var SPACE_GETGRAVITYDIR:int=11;
	    public static var SPACE_GETDECELERATION:int=12;
	    public static var SPACE_GETROTATIONSPEED:int=13;
	    public static var SPACE_GETTHRUSTPOWER:int=14;

		//*** Drag-drop movement
		public static var SET_DragDrop_Method:int = 4145;
		public static var SET_DragDrop_IsLimited:int=4146;
		public static var SET_DragDrop_DropOutsideArea:int=4147;
		public static var SET_DragDrop_ForceWithinLimits:int=4148;
		public static var SET_DragDrop_AreaX:int=4149;
		public static var SET_DragDrop_AreaY:int=4150;
		public static var SET_DragDrop_AreaW:int=4151;
		public static var SET_DragDrop_AreaH:int=4152;
		public static var SET_DragDrop_SnapToGrid:int=4153;
		public static var SET_DragDrop_GridX:int=4154;
		public static var SET_DragDrop_GridY:int=4155;
		public static var SET_DragDrop_GridW:int=4156;
		public static var SET_DragDrop_GridH:int=4157;
	
		public static var GET_DragDrop_AreaX:int=4158;
		public static var GET_DragDrop_AreaY:int=4159;
		public static var GET_DragDrop_AreaW:int=4160;
		public static var GET_DragDrop_AreaH:int=4161;
		public static var GET_DragDrop_GridX:int=4162;
		public static var GET_DragDrop_GridY:int=4163;
		public static var GET_DragDrop_GridW:int=4164;
		public static var GET_DragDrop_GridH:int=4165;
	
	    public var currentObject:CObject;
	    public static var DLL_CIRCULAR:String="clickteam-circular";
	    public static var DLL_INVADERS:String="clickteam-invaders";
	    public static var DLL_PRESENTATION:String="clickteam-presentation";
	    public static var DLL_REGPOLYGON:String="clickteam-regpolygon";
	    public static var DLL_SIMPLE_ELLIPSE:String="clickteam-simple_ellipse";
	    public static var DLL_SINEWAVE:String="clickteam-sinewave";
	    public static var DLL_VECTOR:String="clickteam-vector";
	    public static var DLL_SPACESHIP:String="spaceship";
	    public static var DLL_DRAGDROP:String = "clickteam-dragdrop";
	
	    public static var ToRadians:Number=0.017453292519943295769236907684886;
	    public static var ToDegrees:Number=57.295779513082320876798154814105;


	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
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
	    public override function expression(num:int):CValue
	    {
	        var value:int = 0;
	        var dValue:Number = 0.0;
	        var bDouble:Boolean = false;
	
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
	
	        var ret:CValue = new CValue(0);
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

	    public function getCurrentObject(dllName:String):CObject
	    {
	        // No need to search for the object if it's null
	        if (currentObject == null)
	        {
	            return null;
	        }
	
	        // Enumerate objects
	        var hoPtr:CObject;
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
	                            var ocPtr:CObjectCommon = hoPtr.hoCommon;
	                            var mvPtr:CMoveDefExtension = CMoveDefExtension(ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum]);
	                            if (CServices.compareStringsIgnoreCase(dllName, mvPtr.moduleName))
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
	    public function enumerateRuntimeObjects(dllName:String):int
	    {
	        var count:int = 0;
	
	        // Enumerate objects
	        var hoPtr:CObject;
	        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
	        {
	            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	            {
	                // Test if the object has a movement and this movement is an extension
	                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	                {
	                    var ocPtr:CObjectCommon = hoPtr.hoCommon;
	                    var mvPtr:CMoveDefExtension = CMoveDefExtension(ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum]);
	                    if (CServices.compareStringsIgnoreCase(dllName, mvPtr.moduleName))
	                    {
	                        count++;
	                    }
	                }
	            }
	        }
	        return count;
	    }

	    public function findObject(dllName:String):CObject 
	    {
	        // Enumerate objects
	        var hoPtr:CObject;
	        for (hoPtr = ho.getFirstObject(); hoPtr != null; hoPtr = ho.getNextObject())
	        {
	            if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	            {
	                // Test if the object has a movement and this movement is an extension
	                if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	                {
	                    var ocPtr:CObjectCommon = hoPtr.hoCommon;
	                    var mvPtr:CMoveDefExtension = CMoveDefExtension(ocPtr.ocMovements.moveList[hoPtr.rom.rmMvtNum]);
	                    if (CServices.compareStringsIgnoreCase(dllName, mvPtr.moduleName))
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
	    public function Action_SetObject_Object(act:CActExtension):void
	    {
	        var hoPtr:CObject = act.getParamObject(rh, 0);
	        if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	        {
	            if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	            {
	                currentObject = hoPtr;
	            }
	        }
	    }
	
	    public function Action_SetObject_FixedValue(act:CActExtension):void
	    {
	        var fixed:int = act.getParamExpression(rh, 0);
	        var hoPtr:CObject = ho.getObjectFromFixed(fixed);
	
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
	    public function Action_SET_CIRCLE_CENTRE_X(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_CENTRE_X, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_CENTRE_Y(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_CENTRE_Y, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_ANGSPEED(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_ANGSPEED, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_CURRENTANGLE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_CURRENTANGLE, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_RADIUS(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_RADIUS, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_SPIRALVEL(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_SPIRALVEL, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_MINRADIUS(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_MINRADIUS, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_MAXRADIUS(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_MAXRADIUS, param1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_ONEND1(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 0);
	        }
	    }
	
	    public function Action_SET_CIRCLE_ONEND2(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 1);
	        }
	    }
	
	    public function Action_SET_CIRCLE_ONEND3(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 2);
	        }
	    }
	
	    public function Action_SET_CIRCLE_ONEND4(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_CIRCULAR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_CIRCLE_ONCOMPLETION, 3);
	        }
	    }
	
	    //*** Regular Polygon movement
	    public function Action_SET_REGPOLY_CENTRE_X(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_CENTRE_X, param1);
	        }
	    }
	
	    public function Action_SET_REGPOLY_CENTRE_Y(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_CENTRE_Y, param1);
	        }
	    }
	
	    public function Action_SET_REGPOLY_NUMSIDES(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_NUMSIDES, param1);
	        }
	    }
	
	    public function Action_SET_REGPOLY_RADIUS(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_RADIUS, param1);
	        }
	    }
	
	    public function Action_SET_REGPOLY_ROTATION_ANGLE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_ROTATION_ANGLE, param1);
	        }
	    }
	
	    public function Action_SET_REGPOLY_VELOCITY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_REGPOLYGON);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_REGPOLY_VELOCITY, param1);
	        }
	    }
	
	    //*** Sinewave movement
	    public function Action_SET_SINEWAVE_SPEED(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_SPEED, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_STARTX(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_STARTX, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_STARTY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_STARTY, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_FINALX(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_FINALX, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_FINALY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_FINALY, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_AMPLITUDE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_AMPLITUDE, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_ANGVEL(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_ANGVEL, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_STARTANG(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_STARTANG, param1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_CURRENTANGLE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_CURRENTANGLE, param1);
	        }
	    }
	
	    public function Action_RESET_SINEWAVE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            ho.callMovement(object, RESET_SINEWAVE, 0);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_ONEND1(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 0);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_ONEND2(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 1);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_ONEND3(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 2);
	        }
	    }
	
	    public function Action_SET_SINEWAVE_ONEND4(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SINEWAVE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SINEWAVE_ONCOMPLETION, 3);
	        }
	    }
	
	    //*** Simple Ellipse movement
	    public function Action_SET_SIMPLEELLIPSE_CENTRE_X(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_CENTRE_X, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_CENTRE_Y(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_CENTRE_Y, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_RADIUS_X(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_RADIUS_X, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_RADIUS_Y(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_RADIUS_Y, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_ANGVEL(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_ANGSPEED, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_CURRENTANGLE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_CURRENTANGLE, param1);
	        }
	    }
	
	    public function Action_SET_SIMPLEELLIPSE_OFFSETANGLE(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SIMPLE_ELLIPSE);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_SIMPLEELLIPSE_OFFSETANGLE, param1);
	        }
	    }
	
	    //*** Invaders movement
	    public function Action_SET_INVADERS_SPEED(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_INVADERS);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_INVADERS_SPEED, param1);
	        }
	    }
	
	    public function Action_SET_INVADERS_STEPX(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_INVADERS);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_INVADERS_STEPX, param1);
	        }
	    }
	
	    public function Action_SET_INVADERS_STEPY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_INVADERS);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_INVADERS_STEPY, param1);
	        }
	    }
	
	    public function Action_SET_INVADERS_LEFTBORDER(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_INVADERS);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_INVADERS_LEFTBORDER, param1);
	        }
	    }
	
	    public function Action_SET_INVADERS_RIGHTBORDER(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_INVADERS);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_INVADERS_RIGHTBORDER, param1);
	        }
	    }
	
	    //*** Projectile movement
	    public function Action_SET_Projectile_X(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_X, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_Y(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_Y, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_XY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var x:int = act.getParamExpression(rh, 0);
	            var y:int = act.getParamExpression(rh, 1);
	            ho.callMovement(object, SET_Projectile_X, x);
	            ho.callMovement(object, SET_Projectile_Y, y);
	        }
	    }
	
	    public function Action_SET_Projectile_MoveTowardsAngle(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var angle:Number = act.getParamExpression(rh, 0) * ToRadians;
	            var distance:int = act.getParamExpression(rh, 1);
	
	            var addDistX:int = (distance * Math.cos(angle) + 0.5);
	            var addDistY:int = (distance * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
	            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
	        }
	    }
	
	    public function Action_SET_Projectile_MoveTowardsPoint(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	
	            var fp3:Number = act.getParamExpDouble(rh, 0);
	            var fp4:Number = act.getParamExpDouble(rh, 1);
	            var distance:int = act.getParamExpression(rh, 2);
	
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            var addDistX:int = (distance * Math.cos(angle) + 0.5);
	            var addDistY:int = (distance * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
	            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
	        }
	    }
	
	    public function Action_SET_Projectile_MoveTowardsObject(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var p2:CObject = act.getParamObject(rh, 0);
	
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	
	            var fp3:Number = p2.hoX;
	            var fp4:Number = p2.hoY;
	            var distance:int = act.getParamExpression(rh, 1);
	
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            var addDistX:int = (distance * Math.cos(angle) + 0.5);
	            var addDistY:int = (distance * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddDistX, addDistX);
	            ho.callMovement(object, SET_Projectile_AddDistY, addDistY);
	        }
	    }
	
	    public function Action_SET_Projectile_Dir(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_Dir, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_DirToPoint(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	
	            var fp3:Number = act.getParamExpDouble(rh, 0);
	            var fp4:Number = act.getParamExpDouble(rh, 1);
	
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            if (angle < 0)
	            {
	                angle += 6.283185;
	            }
	            angle *= ToDegrees;
	
	            ho.callMovement(object, SET_Projectile_Dir, angle);
	        }
	    }
	
	    public function Action_SET_Projectile_DirToObject(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var p2:CObject = act.getParamObject(rh, 0);
	
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	
	            var fp3:Number = p2.hoX;
	            var fp4:Number = p2.hoY;
	
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            if (angle < 0)
	            {
	                angle += 6.283185;
	            }
	            angle *= ToDegrees;
	
	            ho.callMovement(object, SET_Projectile_Dir, angle);
	        }
	    }
	
	    public function Action_SET_Projectile_RotateTowardsAngle(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            var param2:int = act.getParamExpression(rh, 1);
	            var newangleTow:Number = (param1 % 360);	// angle towards
	            var newangleAdd:Number = (param2 % 360);	// angle to add
	
	            var currentAngle:Number = ho.callMovement(object, GET_Projectile_Dir, 0);
	
	            var difM:Number = currentAngle - newangleTow;
	            if (difM < 0)
	            {
	                difM += 360;
	            }
	
	            var difA:Number = 360 - difM;
	
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
	            ho.callMovement(object, SET_Projectile_Dir, currentAngle);
	        }
	    }
	
	    public function Action_SET_Projectile_RotateTowardsPoint(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var currentAngle:Number = ho.callMovement(object, GET_Projectile_Dir, 0);
	
	            var fp3:Number = act.getParamExpDouble(rh, 0);
	            var fp4:Number = act.getParamExpDouble(rh, 1);
	
	            var newangleAdd:Number = act.getParamExpDouble(rh, 2) % 360;
	            var newangleTow:Number = (Math.atan2(fp2 - fp4, fp3 - fp1) * ToDegrees);
	
	            if (newangleTow < 0)
	            {
	                newangleTow += 360;
	            }
	
	            var difM:Number = currentAngle - newangleTow;
	            if (difM < 0)
	            {
	                difM += 360;
	            }
	
	            var difA:Number = 360 - difM;
	
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
	            ho.callMovement(object, SET_Projectile_Dir, currentAngle);
	        }
	    }
	
	    public function Action_SET_Projectile_RotateTowardsObject(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var p2:CObject = act.getParamObject(rh, 0);
	
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var currentAngle:Number = ho.callMovement(object, GET_Projectile_Dir, 0);
	            var fp3:Number = p2.hoX;
	            var fp4:Number = p2.hoY;
	            var newangleAdd:Number = act.getParamExpDouble(rh, 1) % 360;
	            var newangleTow:Number = (Math.atan2(fp2 - fp4, fp3 - fp1) * ToDegrees);
	
	            if (newangleTow < 0)
	            {
	                newangleTow += 360;
	            }
	
	            var difM:Number = currentAngle - newangleTow;
	            if (difM < 0)
	            {
	                difM += 360;
	            }
	
	            var difA:Number = 360 - difM;
	
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
	            ho.callMovement(object, SET_Projectile_Dir, currentAngle);
	        }
	    }
	
	    public function Action_SET_Projectile_Speed(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_Speed, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_SpeedX(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_SpeedX, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_SpeedY(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_SpeedY, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_AddDirSpeedTowardsAngle(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var angle:Number = act.getParamExpression(rh, 0) * ToRadians;
	            var speed:int = act.getParamExpression(rh, 1);
	
	            var addSpeedX:int = (speed * Math.cos(angle) + 0.5);
	            var addSpeedY:int = (speed * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
	            ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
	        }
	    }
	
	    public function Action_SET_Projectile_AddDirSpeedTowardsPoint(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var fp3:Number = act.getParamExpDouble(rh, 0);
	            var fp4:Number = act.getParamExpDouble(rh, 1);
	            var speed:int = act.getParamExpression(rh, 2);
	
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            var addSpeedX:int = (speed * Math.cos(angle) + 0.5);
	            var addSpeedY:int = (speed * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
	            ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
	        }
	    }
	
	    public function Action_SET_Projectile_AddDirSpeedTowardsObject(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var p2:CObject = act.getParamObject(rh, 0);
	
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var fp3:Number = p2.hoX;
	            var fp4:Number = p2.hoY;
	            var speed:int = act.getParamExpression(rh, 1);
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            var addSpeedX:int = (speed * Math.cos(angle) + 0.5);
	            var addSpeedY:int = (speed * Math.sin(angle) + 0.5);
	
	            ho.callMovement(object, SET_Projectile_AddSpeedX, addSpeedX);
	            ho.callMovement(object, SET_Projectile_AddSpeedY, addSpeedY);
	        }
	    }
	
	    public function Action_SET_Projectile_MinSpeed(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_MinSpeed, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_MaxSpeed(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_MaxSpeed, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_Gravity(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_Gravity, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_GravityDir(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_GravityDir, param1);
	        }
	    }
	
	    public function Action_SET_Projectile_GravityDirToPoint(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var fp3:Number = act.getParamExpDouble(rh, 0);
	            var fp4:Number = act.getParamExpDouble(rh, 1);
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            if (angle < 0)
	            {
	                angle += 6.283185;
	            }
	            angle *= ToDegrees;
	
	            ho.callMovement(object, SET_Projectile_GravityDir, angle);
	        }
	    }
	
	    public function Action_SET_Projectile_GravityDirToObject(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var p2:CObject = act.getParamObject(rh, 0);
	
	            var fp1:Number = ho.callMovement(object, GET_Projectile_X, 0);
	            var fp2:Number = ho.callMovement(object, GET_Projectile_Y, 0);
	            var fp3:Number = p2.hoX;
	            var fp4:Number = p2.hoY;
	            var angle:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	            if (angle < 0)
	            {
	                angle += 6.283185;
	            }
	            angle *= ToDegrees;
	
	            ho.callMovement(object, SET_Projectile_GravityDir, angle);
	        }
	    }
	
	    public function Action_SET_Projectile_BounceCoeff(act:CActExtension):void
	    {
	        //callRunTimeFunction2(((LPRDATA)param1), RFUNCTION_CALLMOVEMENT, SET_Projectile_Y, param2);
	    }
	
	    public function Action_SET_Projectile_ForceBounce(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_VECTOR);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SET_Projectile_ForceBounce, param1);
	        }
	    }
	
	    //*** Presentation movement
	    public function Action_SET_PRESENTATION_Next(act:CActExtension):void
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_PRESENTATION_Next, 0);
	        }
	    }
	
	    public function Action_SET_PRESENTATION_Prev(act:CActExtension):void
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_PRESENTATION_Prev, 0);
	        }
	    }
	
	    public function Action_SET_PRESENTATION_ToStart(act:CActExtension):void
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_PRESENTATION_ToStart, 0);
	        }
	    }
	
	    public function Action_SET_PRESENTATION_ToEnd(act:CActExtension):void
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_PRESENTATION_ToEnd, 0);
	        }
	    }
	
	    // Spaceship movement
	    public function Action_SetPower(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETPOWER, param1);
	        }
	    }
	
	    public function Action_SetSpeed(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETSPEED, param1);
	        }
	    }
	
	    public function Action_SetDir(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETDIR, param1);
	        }
	    }
	
	    public function Action_SetDec(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETDEC, param1);
	        }
	    }
	
	    public function Action_SetRotSpeed(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETROTSPEED, param1);
	        }
	    }
	
	    public function Action_SetGravity(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETGRAVITY, param1);
	        }
	    }
	
	    public function Action_SetGravityDir(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            var param1:int = act.getParamExpression(rh, 0);
	            ho.callMovement(object, SPACE_SETGRAVITYDIR, param1);
	        }
	    }
	
	    public function Action_ApplyReactor(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            ho.callMovement(object, SPACE_APPLYREACTOR, 0);
	        }
	    }
	
	    public function Action_ApplyRotateRight(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            ho.callMovement(object, SPACE_APPLYROTATERIGHT, 0);
	        }
	    }
	
	    public function Action_ApplyRotateLeft(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_SPACESHIP);
	        if (object != null)
	        {
	            ho.callMovement(object, SPACE_APPLYROTATELEFT, 0);
	        }
	    }

	    //*** Drag-drop movement
	    public function Action_DragDrop_Method1(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_Method, 0);
	        }
	    }
	
	    public function Action_DragDrop_Method2(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_Method, 1);
	        }
	    }
	
	    public function Action_DragDrop_Method3(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_Method, 2);
	        }
	    }
	    public function Action_DragDrop_Method4(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_Method, 3);
	        }
	    }
	    public function Action_DragDrop_Method5(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_Method, 4);
	        }
	    }
	
	    public function Action_DragDrop_IsLimited(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_IsLimited, 1);
	        }
	    }
	
	    public function Action_DragDrop_IsLimitedOff(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_IsLimited, 0);
	        }
	    }
	
	    public function Action_DragDrop_DropOutsideArea(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_DropOutsideArea, 1);
	        }
	    }
	
	    public function Action_DragDrop_DropOutsideAreaOff(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_DropOutsideArea, 0);
	        }
	    }
	
	    public function Action_DragDrop_ForceWithinLimits(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_ForceWithinLimits, 1);
	        }
	    }
	
	    public function Action_DragDrop_ForceWithinLimitsOff(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_ForceWithinLimits, 0);
	        }
	    }
	
	    public function Action_DragDrop_Area(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        var area:PARAM_ZONE = act.getParamZone(rh, 0);
	
	        if (object!=null)
	        {
	            ho.callMovement(object, SET_DragDrop_AreaX, area.x1);
	            ho.callMovement(object, SET_DragDrop_AreaY, area.y1);
	            ho.callMovement(object, SET_DragDrop_AreaW, area.x2-area.x1);
	            ho.callMovement(object, SET_DragDrop_AreaH, area.y2-area.y1);
	        }
	    }
	
	    public function Action_DragDrop_AreaX(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_AreaX, param1);
	        }
	    }
	
	    public function Action_DragDrop_AreaY(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_AreaY, param1);
	        }
	    }
	
	    public function Action_DragDrop_AreaW(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_AreaW, param1);
	        }
	    }
	
	    public function Action_DragDrop_AreaH(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_AreaH, param1);
	        }
	    }
	
	    public function Action_DragDrop_SnapToGrid(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_SnapToGrid, 1);
	        }
	    }
	
	    public function Action_DragDrop_SnapToGridOff(act:CActExtension):void
	    {
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_SnapToGrid, 0);
	        }
	    }
	
	    public function Action_DragDrop_GridOrigin(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_GridX, param1&0xFFFF);
	            ho.callMovement(object, SET_DragDrop_GridY, param1>>16);
	        }
	    }
	
	    public function Action_DragDrop_GridX(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_GridX, param1);
	        }
	    }
	
	    public function Action_DragDrop_GridY(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_GridY, param1);
	        }
	    }
	
	    public function Action_DragDrop_GridW(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_GridW, param1);
	        }
	    }
	
	    public function Action_DragDrop_GridH(act:CActExtension):void
	    {
	        var param1:int=act.getParamExpression(rh, 0);
	        var object:CObject = getCurrentObject(DLL_DRAGDROP);
	        if (object != null)
	        {
	            ho.callMovement(object, SET_DragDrop_GridH, param1);
	        }
	    }

		// ============================================================================
		//
		// EXPRESSIONS ROUTINES
		// 
		// ============================================================================

	    //*** Circular movement
	    public function  Expression_GET_CIRCLE_CENTRE_X():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_CENTRE_X, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_CENTRE_Y():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_CENTRE_Y, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_ANGSPEED():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_ANGSPEED, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_CURRENTANGLE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_CURRENTANGLE, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_RADIUS():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_RADIUS, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_SPIRALVEL():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_SPIRALVEL, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_MINRADIUS():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_MINRADIUS, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_MAXRADIUS():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_CIRCLE_MAXRADIUS, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_CIRCLE_COUNT():int
	    {
	        return enumerateRuntimeObjects(DLL_CIRCULAR);
	    }
	
	
	    //*** Regular Polygon movement
	    public function  Expression_GET_REGPOLY_CENTRE_X():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_CENTRE_X, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_CENTRE_Y():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_CENTRE_Y, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_NUMSIDES():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_NUMSIDES, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_RADIUS():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_RADIUS, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_ROTATION_ANGLE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_ROTATION_ANGLE, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_VELOCITY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_REGPOLY_VELOCITY, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_REGPOLY_COUNT():int
	    {
	        return enumerateRuntimeObjects(DLL_REGPOLYGON);
	    }
	
	
	    //*** Sinewave movement
	    public function  Expression_GET_SINEWAVE_SPEED():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_SPEED, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_SINEWAVE_STARTX():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_STARTX, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_SINEWAVE_STARTY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_STARTY, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_SINEWAVE_FINALX():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_FINALX, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_SINEWAVE_FINALY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_FINALY, 0);
	        }
	        return 0;
	    }
	
	    public function  Expression_GET_SINEWAVE_AMPLITUDE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_AMPLITUDE, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SINEWAVE_ANGVEL():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_ANGVEL, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SINEWAVE_STARTANG():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_STARTANG, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SINEWAVE_CURRENTANGLE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SINEWAVE_CURRENTANGLE, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SINEWAVE_COUNT():int
	    {
	        return enumerateRuntimeObjects(DLL_SINEWAVE);
	    }
	
	
	    //*** Simple Ellipse movement
	    public function Expression_GET_SIMPLEELLIPSE_CENTRE_X():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_CENTRE_X, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_CENTRE_Y():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_CENTRE_Y, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_RADIUS_X():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_RADIUS_X, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_RADIUS_Y():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_RADIUS_Y, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_ANGVEL():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_ANGSPEED, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_CURRENTANGLE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_CURRENTANGLE, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_OFFSETANGLE():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_SIMPLEELLIPSE_OFFSETANGLE, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_SIMPLEELLIPSE_COUNT():int
	    {
	        return enumerateRuntimeObjects(DLL_SIMPLE_ELLIPSE);
	    }
	
	    //*** Invaders movement
	    public function Expression_GET_INVADERS_SPEED():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_INVADERS_SPEED, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_INVADERS_STEPX():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_INVADERS_STEPX, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_INVADERS_STEPY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_INVADERS_STEPY, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_INVADERS_LEFTBORDER():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_INVADERS_LEFTBORDER, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_INVADERS_RIGHTBORDER():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, GET_INVADERS_RIGHTBORDER, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_GET_INVADERS_COUNT():int
	    {
	        return enumerateRuntimeObjects(DLL_INVADERS);
	    }
	
	    //*** Projectile movements
	    public function Expression_GET_Projectile_X():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_Y():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_Dir():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_Speed():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_SpeedX():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_SpeedY():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_MinSpeed():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_MaxSpeed():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_Gravity():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_GravityDir():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_BounceCoef():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	
	    public function Expression_GET_Projectile_Count():int
	    {
	        return enumerateRuntimeObjects(DLL_VECTOR);
	    }
	
	    //*** Presentation movement
	    public function Expression_GET_PRESENTATION_Index():int
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_PRESENTATION_Index, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_GET_PRESENTATION_LastIndex():int
	    {
	        var object:CObject = findObject(DLL_PRESENTATION);
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_PRESENTATION_LastIndex, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_GET_PRESENTATION_Count():int
	    {
	        return enumerateRuntimeObjects(DLL_PRESENTATION);
	    }
	
	    //*** Spaceship movement
	    public function Expression_SpaceShip_Gravity():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, SPACE_GETGRAVITY, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_SpaceShip_GravityDir():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, SPACE_GETGRAVITYDIR, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_SpaceShip_Deceleration():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, SPACE_GETDECELERATION, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_SpaceShip_RotationSpeed():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, SPACE_GETROTATIONSPEED, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_SpaceShip_ThrustPower():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
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
	            return ho.callMovement(object, SPACE_GETTHRUSTPOWER, 0);
	        }
	        return -1;
	    }
	
	    public function Expression_SpaceShip_Count():int
	    {
	        return enumerateRuntimeObjects(DLL_SPACESHIP);
	    }
	
	    //*** General Expressions
	    public function Expression_DistObjects():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var p2:int = ho.getExpParam().getInt();
	
	        var object1:CObject, object2:CObject;
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
	
	        var fp1:Number = object1.hoX;
	        var fp2:Number = object1.hoY;
	        var fp3:Number = object2.hoX;
	        var fp4:Number = object2.hoY;
	        return Math.sqrt((fp1 - fp3) * (fp1 - fp3) + (fp2 - fp4) * (fp2 - fp4));
	    }
	
	    public function Expression_DistPoints():Number
	    {
	        var fp1:Number = ho.getExpParam().getDouble();
	        var fp2:Number = ho.getExpParam().getDouble();
	        var fp3:Number = ho.getExpParam().getDouble();
	        var fp4:Number = ho.getExpParam().getDouble();
	
	        return Math.sqrt((fp1 - fp3) * (fp1 - fp3) + (fp2 - fp4) * (fp2 - fp4));
	    }
	
	    public function Expression_AngleObjects():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var p2:int = ho.getExpParam().getInt();
	
	        var object1:CObject, object2:CObject;
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
	
	        var fp1:Number = object1.hoX;
	        var fp2:Number = object1.hoY;
	        var fp3:Number = object2.hoX;
	        var fp4:Number = object2.hoY;
	
	        var fp5:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	        if (fp5 < 0)
	        {
	            fp5 += 6.283185;
	        }
	        fp5 *= ToDegrees;
	        return fp5;
	    }
	
	    public function Expression_AnglePoints():Number
	    {
	        var fp1:Number = ho.getExpParam().getDouble();
	        var fp2:Number = ho.getExpParam().getDouble();
	        var fp3:Number = ho.getExpParam().getDouble();
	        var fp4:Number = ho.getExpParam().getDouble();
	
	        var fp5:Number = (Math.atan2(fp2 - fp4, fp3 - fp1));
	
	        if (fp5 < 0)
	        {
	            fp5 += 6.283185;
	        }
	        fp5 *= ToDegrees;
	        return fp5;
	    }
	
	    public function Expression_Angle2Dir():int
	    {
	        var angle:int = ho.getExpParam().getInt();
	        var dir:int = ((((angle + 5.625) / 11.25)) % 32);
	        return dir;
	    }
	
	    public function Expression_Dir2Angle():Number
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var dir:Number = ((p1 % 32) * 11.25);
	        return dir;
	    }

	    //*** Drag-drop movement
	    public function Expression_DragDrop_AreaX():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_AreaX, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_AreaY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_AreaY, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_AreaW():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_AreaW, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_AreaH():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_AreaH, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_GridX():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_GridX, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_GridY():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_GridY, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_GridW():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_GridW, 0);
	        }
	        return 0;
	    }
	
	    public function Expression_DragDrop_GridH():int
	    {
	        var p1:int = ho.getExpParam().getInt();
	        var object:CObject;
	        if (p1 == 0)
	        {
	            object = getCurrentObject(DLL_DRAGDROP);
	        }
	        else
	        {
	            object = ho.getObjectFromFixed(p1);
	        }
	
	        if (object != null)
	        {
	            return ho.callMovement(object, GET_DragDrop_GridH, 0);
	        }
	        return 0;
	    }

	}
}