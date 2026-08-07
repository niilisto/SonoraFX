//----------------------------------------------------------------------------------
//
// CRUNMVTVECTOR
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;

	public class CRunMvtclickteam_vector extends CRunMvtExtension
	{
	    public static var MOVEATSTART:int = 1;
	    public static var HANDLE_DIRECTION:int = 2;
	    public static var ToDegrees:Number = 57.295779513082320876798154814105;
	    public static var ToRadians:Number = 0.017453292519943295769236907684886;
	    
	    public var m_dwFlags:int;
	    public var m_dwVel:int;
	    public var m_dwVelAngle:int;
	    public var m_dwAcc:int;
	    public var m_dwAccAngle:int;
	    public var r_Stopped:Boolean = false;
	    public var handleDirection:Boolean = false;
	    public var posX:Number = 0;
	    public var posY:Number = 0;
	    public var velX:Number = 0;
	    public var velY:Number = 0;
	    public var accX:Number = 0;
	    public var accY:Number = 0;
	    public var angle:Number = 0;
	    public var minSpeed:Number = -1;
	    public var maxSpeed:Number = -1;

	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwFlags = file.readInt();
	        m_dwVel = file.readInt();
	        m_dwVelAngle = file.readInt();
	        m_dwAcc = file.readInt();
	        m_dwAccAngle = file.readInt();
	
	        //*** General variables
	        r_Stopped = ((m_dwFlags & MOVEATSTART) == 0);
	        handleDirection = ((m_dwFlags & HANDLE_DIRECTION) != 0);
	
	        var vel:Number = m_dwVel;
	        var velAngle:Number = m_dwVelAngle * ToRadians;
	
	        var acc:Number = m_dwAcc * 0.01;
	        var accAngle:Number = m_dwAccAngle * ToRadians;
	
	        posX = ho.hoX;
	        posY = ho.hoY;
	
	        velX = vel * Math.cos(velAngle);
	        velY = -vel * Math.sin(velAngle);
	
	        accX = acc * Math.cos(accAngle);
	        accY = -acc * Math.sin(accAngle);
	    }

	    public override function move():Boolean
	    {
	        //*** Object needs to be moved?
	        if (!r_Stopped)
	        {
	            //*** Update internal variables
	            var calculs:Number;
	            calculs = accX;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            velX += calculs;
				
	            calculs = accY;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            velY += calculs;
				
	            calculs = velX;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            posX += calculs * 0.01;
				
	            calculs = velY;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            posY += calculs * 0.01;
	
	            //*** Code the handle the min / max speed control
	            checkSpeed();
	
	            //*** Calculate the current direction
	            angle = Math.atan2(-velY, velX);
	            if (angle < 0)
	            {
	                angle += 2 * Math.PI;
	            }
	
	            if (handleDirection)
	            {
					//ho.roc.rcDir=((int)(((angle + (Math.PI/32) )*32)/(Math.PI*2) ))%32;
					ho.roc.rcDir=AngleToDir(angle);

	            }
	
	            //*** Update MMF2 with the new position
	            animations(CAnim.ANIMID_WALK);
	            ho.hoX = (int) (posX + 0.5);
	            ho.hoY = (int) (posY + 0.5);
	            collisions();
	
	            //*** Indicate the object has been moved
	            return true;
	        }
        	animations(CAnim.ANIMID_STOP);			
	        collisions();
	        return false;
	    }

	    public function reset():void
	    {
	        var vel:Number = m_dwVel;
	        var velAngle:Number = m_dwVelAngle * ToRadians;
	
	        var acc:Number = m_dwAcc / 100.0;
	        var accAngle:Number = m_dwAccAngle * ToRadians;
	
	        posX = ho.hoX;
	        posY = ho.hoY;
	
	        velX = vel * Math.cos(velAngle);
	        velY = -vel * Math.sin(velAngle);
	
	        accX = acc * Math.cos(accAngle);
	        accY = -acc * Math.sin(accAngle);
	    }

	    public function checkSpeed():Boolean
	    {
	        //*** Code the handle the min / max speed control
	        if (maxSpeed != -1)
	        {
	            if ((velX * velX + velY * velY) > maxSpeed * maxSpeed)
	            {
	                recalculateAngle();
	                //*** Recalculate velocity components
	                velX = maxSpeed * Math.cos(angle);
	                velY = -maxSpeed * Math.sin(angle);
	                return true;
	            }
	        }
	        else if (minSpeed != -1)
	        {
	            if ((velX * velX + velY * velY) < minSpeed * minSpeed)
	            {
	                recalculateAngle();
	                //*** Recalculate velocity components
	                velX = minSpeed * Math.cos(angle);
	                velY = -minSpeed * Math.sin(angle);
	                return true;
	            }
	        }
	        return false;
	    }

	    public function recalculateAngle():void
	    {
	        angle = Math.atan2(-velY, velX);
	        if (angle < 0)
	        {
	            angle += 2 * Math.PI;
	        }
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        posX -= (ho.hoX - x);
	        posY -= (ho.hoY - y);
	
	        ho.hoX = x;
	        ho.hoY = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        posX -= (ho.hoX - x);
	        ho.hoX = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        posY -= (ho.hoY - y);
	        ho.hoY = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        r_Stopped = true;
	    }

	    public override function reverse():void
	    {
	        velX *= -1;
	        velY *= -1;
	        recalculateAngle();
	    }
	
	    public override function start():void
	    {
	        r_Stopped = false;
	    }

	    public override function setSpeed(speed:int):void
	    {
	        velX = speed * Math.cos(angle);
	        velY = -speed * Math.sin(angle);
	
	        if (checkSpeed())
	        {
	            recalculateAngle();
	        }
	    }
	
	    public override function setMaxSpeed(speed:int):void
	    {
	        maxSpeed = speed;
	        if (checkSpeed())
	        {
	            recalculateAngle();
	        }
	    }

	    public override function setGravity(gravity:int):void
	    {
	        var accAngle:Number = Math.atan2(-accY, accX);
	        var acc:Number = gravity * 0.01;
	
	        accX = acc * Math.cos(accAngle);
	        accY = -acc * Math.sin(accAngle);
	    }
	
	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        var vel:Number;
	        var accAngle:Number;
	        var acc:Number;
	        var flo:Number;
	        switch (action)
	        {
	            case 3845:	    // SET_Vector_X = 3845,
	                param = getParamDouble();
	                posX = param;
	                break;
	            case 3846:	    // SET_Vector_Y,
	                param = getParamDouble();
	                posY = param;
	                break;
	            case 3847:	    // SET_Vector_XY,
	                param = getParamDouble();
	                break;
	            case 3848:	    // SET_Vector_AddDistX,
	                param = getParamDouble();
	                posX += 0.01 * param;
	                break;
	            case 3849:	    // SET_Vector_AddDistY,
	                param = getParamDouble();
	                posY -= 0.01 * param;
	                break;
	            case 3850:	    // SET_Vector_Dir,
	                param = getParamDouble();
	                angle = (param) * ToRadians;
	                vel = Math.sqrt(velX * velX + velY * velY);
	                velX = vel * Math.cos(angle);
	                velY = -vel * Math.sin(angle);
	                break;
	            case 3851:	    // SET_Vector_RotateTowardsAngle,
	                param = getParamDouble();
	                break;
	            case 3852:	    // SET_Vector_RotateTowardsPoint,
	                param = getParamDouble();
	                break;
	            case 3853:	    // SET_Vector_RotateTowardsObject,
	                param = getParamDouble();
	                break;
	            case 3854:	    // SET_Vector_Speed,
	                param = getParamDouble();
	                vel = param;
	                velX = vel * Math.cos(angle);
	                velY = -vel * Math.sin(angle);
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3855:	    // SET_Vector_SpeedX,
	                param = getParamDouble();
	                velX = param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3856:	    // SET_Vector_SpeedY,
	                param = getParamDouble();
	                velY = param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3857:	    // SET_Vector_AddSpeedX,
	                param = getParamDouble();
	                velX += 0.01 * param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3858:	    // SET_Vector_AddSpeedY,
	                param = getParamDouble();
	                velY -= 0.01 * param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3859:	    // SET_Vector_MinSpeed,
	                param = getParamDouble();
	                minSpeed = param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3860:	    // SET_Vector_MaxSpeed,
	                param = getParamDouble();
	                maxSpeed = param;
	                if (checkSpeed())
	                {
	                    recalculateAngle();
	                }
	                break;
	            case 3861:	    // SET_Vector_Gravity,
	                param = getParamDouble();
	                accAngle = Math.atan2(-accY, accX);
	                acc = param * 0.01;
	                accX = acc * Math.cos(accAngle);
	                accY = -acc * Math.sin(accAngle);
	                break;
	            case 3862:	    // SET_Vector_GravityDir,
	                param = getParamDouble();
	                accAngle = param * ToRadians;
	                acc = Math.sqrt(accX * accX + accY * accY);
	                accX = acc * Math.cos(accAngle);
	                accY = -acc * Math.sin(accAngle);
	                break;
	            case 3863:	    // SET_Vector_BounceCoeff,
	                param = getParamDouble();
	                break;
	            case 3864:	    // SET_Vector_ForceBounce,
	                param = getParamDouble();
	                angle = param * ToRadians * 2;
	                posX -= velX * 0.01;
	                posY -= velY * 0.01;
	                angle -= Math.atan2(-velY, velX);
	                vel = Math.sqrt(velX * velX + velY * velY);
	                velX = vel * Math.cos(angle);
	                velY = -vel * Math.sin(angle);
	                break;
	
	            case 3865:	    // GET_Vector_X,
	                return posX;
	            case 3866:	    // GET_Vector_Y,
	                return posY;
	            case 3867:	    // GET_Vector_Dir,
	                flo = (angle * ToDegrees);
	                if (flo < 0)
	                {
	                    flo += 360;
	                }
	                return flo;
	            case 3868:	    // GET_Vector_Speed,
	                return Math.sqrt(velX * velX + velY * velY);
	            case 3869:	    // GET_Vector_SpeedX,
	                return velX;
	            case 3870:	    // GET_Vector_SpeedY,
	                return velY;
	            case 3871:	    // GET_Vector_MinSpeed,
	                return minSpeed;
	            case 3872:	    // GET_Vector_MaxSpeed,
	                return maxSpeed;
	            case 3873:	    // GET_Vector_Gravity,
	                return (100 * Math.sqrt(accX * accX + accY * accY));
	            case 3874:	    // GET_Vector_GravityDir,
	                flo = (Math.atan2(-accY, accX) * ToDegrees);
	                if (flo < 0)
	                {
	                    flo += 360;
	                }
	                return flo;
	            case 3875:	    // GET_Vector_BounceCoef
	                return 0;
	
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return (Math.sqrt(velX * velX + velY * velY));
	    }

	    public override function getGravity():int
	    {
	        return 100 * Math.sqrt(accX * accX + accY * accY);
	    }
	}
}