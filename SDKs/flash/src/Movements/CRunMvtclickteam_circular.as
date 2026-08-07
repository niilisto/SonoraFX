//----------------------------------------------------------------------------------
//
// CRUNMVTCIRCULAR : Movement circular!
//
//----------------------------------------------------------------------------------

package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;

	public class CRunMvtclickteam_circular extends CRunMvtExtension
	{
	    public static var MFLAG1_MOVEATSTART:int=1;
	    public static var ONEND_STOP:int=0;
	    public static var ONEND_RESET:int=1;
	    public static var ONEND_REVERSE_VEL:int=2;
	    public static var ONEND_REVERSE_DIR:int=3;
	    
	    public var m_dwCX:int;
	    public var m_dwCY:int;
	    public var m_dwStartAngle:int;
	    public var m_dwRadius:int;
	    public var m_dwRmin:int;
	    public var m_dwRmax:int;
	    public var m_dwFlags:int;
	    public var m_dwOnEnd:int;
	    public var m_dwSpiVel:int;
	    public var m_dwAngVel:int;
	    
	    public var r_Stopped:Boolean;
	    public var 	r_OnEnd:int;
	    public var r_CX:int;
	    public var r_CY:int;
	    public var r_Rmin:int;
	    public var r_Rmax:int;
	    public var r_AngVel:Number;
	    public var r_SpiVel:Number;
	    public var r_CurrentRadius:Number;
	    public var r_CurrentAngle:Number;
		
		public function CRunMvtclickteam_circular()
		{
		}

	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwCX = file.readInt();
	        m_dwCY = file.readInt();
	        m_dwRadius = file.readInt();
	        m_dwStartAngle = file.readInt();
	        m_dwRmin = file.readInt();
	        m_dwRmax = file.readInt();
	        m_dwFlags = file.readInt();
	        m_dwOnEnd = file.readInt();
	        m_dwAngVel = file.readInt();
	        m_dwSpiVel = file.readInt();
	
	        //*** General variables
	        r_Stopped = ((m_dwFlags & MFLAG1_MOVEATSTART) == 0);
	        r_OnEnd = m_dwOnEnd;
	
	        r_CX = m_dwCX;
	        r_CY = m_dwCY;
	        r_Rmin = m_dwRmin;
	        r_Rmax = m_dwRmax;
	        r_AngVel = m_dwAngVel / 50.0 * (Math.PI / 180.0);
	        r_SpiVel = m_dwSpiVel / 50.0;
	        r_CurrentAngle = m_dwStartAngle * (Math.PI / 180.0);
	        r_CurrentRadius = m_dwRadius;
	        ho.roc.rcSpeed = m_dwAngVel;
	    }

	    public override function move():Boolean
	    {
	        var calculs:Number;
	
	        //*** Object needs to be moved?
	        if (!r_Stopped)
	        {
	            animations(CAnim.ANIMID_WALK);
	            ho.hoX = (int) (r_CX + r_CurrentRadius * Math.cos(r_CurrentAngle));
	            ho.hoY = (int) (r_CY - r_CurrentRadius * Math.sin(r_CurrentAngle));
	            collisions();
	
	            calculs = r_AngVel;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            r_CurrentAngle += calculs;
	
	            if (r_CurrentAngle < 0)
	            {
	                r_CurrentAngle += 2 * Math.PI;
	            }
	            else if (r_CurrentAngle > 2 * Math.PI)
	            {
	                r_CurrentAngle -= 2 * Math.PI;
	            }
	
	            if (Math.abs(r_SpiVel) > 0.00001)
	            {
	                calculs = r_SpiVel;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                }
	                r_CurrentRadius += calculs;
	
	                if (r_CurrentRadius < r_Rmin || r_CurrentRadius > r_Rmax)
	                {
	                    if (r_OnEnd == ONEND_STOP)
	                    {
	                        r_Stopped = true;
	                    }
	                    else if (r_OnEnd == ONEND_REVERSE_VEL)
	                    {
	                        r_SpiVel *= -1;
	                    }
	                    else if (r_OnEnd == ONEND_REVERSE_DIR)
	                    {
	                        r_AngVel *= -1;
	                        r_SpiVel *= -1;
	                    }
	                    else if (r_OnEnd == ONEND_RESET)
	                    {
	                        reset();
	                    }
	                }
	            }
	            //*** Indicate the object has been moved
	            return true;
	        }
	        animations(CAnim.ANIMID_STOP);
	        collisions();
	
	        //*** The object has not been moved
	        return false;
	    }

	    public function reset():void
	    {
	        r_CX = m_dwCX;
	        r_CY = m_dwCY;
	        r_Rmin = m_dwRmin;
	        r_Rmax = m_dwRmax;
	        r_AngVel = m_dwAngVel / 50.0 * (Math.PI / 180.0);
	        r_SpiVel = m_dwSpiVel / 50.0;
	        r_CurrentAngle = m_dwStartAngle * (Math.PI / 180.0);
	        r_CurrentRadius = m_dwRadius;
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        r_CX -= ho.hoX - x;
	        r_CY -= ho.hoY - y;
	
	        ho.hoX = x;
	        ho.hoY = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        r_CX -= ho.hoX - x;
	        ho.hoX = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        r_CY -= ho.hoY - y;
	        ho.hoY = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        r_Stopped = true;
	    }

	    public override function reverse():void
	    {
	        r_AngVel *= -1;
	    }
	
	    public override function start():void
	    {
	        r_Stopped = false;
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        //*** Linear motion components;
	        r_AngVel = (speed) / 50.0 * (Math.PI / 180.0);
	        ho.roc.rcSpeed = speed;
    	}

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        switch (action)
	        {
	            case 3345:		// SET_CENTRE_X = 3345,
	                param = getParamDouble();
	                r_CX = param;
	                return 0;
	            case 3346:		// SET_CENTRE_Y,
	                param = getParamDouble();
	                r_CY = param;
	                return 0;
	            case 3347:		// SET_ANGSPEED,
	                param = getParamDouble();
	                r_AngVel = param / 50.0 * (Math.PI / 180.0);
	                ho.roc.rcSpeed = param;
	                return 0;
	            case 3348:		// SET_CURRENTANGLE,
	                param = getParamDouble();
	                r_CurrentAngle = param * (Math.PI / 180.0);
	                return 0;
	            case 3349:		// SET_RADIUS,
	                param = getParamDouble();
	                r_CurrentRadius = Math.max(param, 0);
	                return 0;
	            case 3350:		// SET_SPIRALVEL,
	                param = getParamDouble();
	                r_SpiVel = param / 50.0;
	                return 0;
	            case 3351:		// SET_MINRADIUS,
	                param = getParamDouble();
	                r_Rmin = Math.max(param, 0);
	                return 0;
	            case 3352:		// SET_MAXRADIUS,
	                param = getParamDouble();
	                r_Rmax = Math.max(param, 0);
	                return 0;
	            case 3353:		// SET_ONCOMPLETION,
	                param = getParamDouble();
	                var onEnd:int = param;
	                if (onEnd >= ONEND_STOP && onEnd <= ONEND_REVERSE_DIR)
	                {
	                    r_OnEnd = onEnd;
	                }
	                return 0;
	            case 3354:		// GET_CENTRE_X,
	                return r_CX;
	            case 3355:		// GET_CENTRE_Y,
	                return r_CY;
	            case 3356:		// GET_ANGSPEED,
	                return r_AngVel * 50.0 * (180.0 / Math.PI);
	            case 3357:		// GET_CURRENTANGLE,
	                return r_CurrentAngle * (180 / Math.PI);
	            case 3358:		// GET_RADIUS,
	                return r_CurrentRadius;
	            case 3359:		// GET_SPIRALVEL,
	                return r_SpiVel * 50;
	            case 3360:		// GET_MINRADIUS,
	                return r_Rmin;
	            case 3361:		// GET_MAXRADIUS
	                return r_Rmax;
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
	    }
	}
}