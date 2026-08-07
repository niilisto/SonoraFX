//----------------------------------------------------------------------------------
//
// CRUNMVTSIMPLEELLIPSE
//
//----------------------------------------------------------------------------------

package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;

	public class CRunMvtclickteam_simple_ellipse extends CRunMvtExtension
	{
	    public static var MFLAG1_MOVEATSTART:int = 1;
	    public var m_dwCX:int;
	    public var m_dwCY:int;
	    public var m_dwRadiusX:int;
	    public var m_dwRadiusY:int;
	    public var m_dwStartAngle:int;
	    public var m_dwFlags:int;
	    public var m_dwAngVel:int;
	    public var m_dwOffset:int;
	    public var r_Stopped:Boolean;
	    public var r_CX:int;
	    public var r_CY:int;
	    public var r_radiusX:int;
	    public var r_radiusY:int;
	    public var r_AngVel:Number;
	    public var r_Offset:Number;
	    public var r_CurrentAngle:Number;
	
	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwCX = file.readInt();
	        m_dwCY = file.readInt();
	        m_dwRadiusX = file.readInt();
	        m_dwRadiusY = file.readInt();
	        m_dwStartAngle = file.readInt();
	        m_dwFlags = file.readInt();
	        m_dwAngVel = file.readInt();
	        m_dwOffset = file.readInt();
	
	        r_Stopped = ((m_dwFlags & MFLAG1_MOVEATSTART) == 0);
	
	        r_CX = m_dwCX;
	        r_CY = m_dwCY;
	        r_AngVel = m_dwAngVel / 50.0 * (Math.PI / 180.0);
	        r_Offset = m_dwOffset * (Math.PI / 180.0);
	        r_CurrentAngle = m_dwStartAngle * (Math.PI / 180.0);
	        r_radiusX = m_dwRadiusX;
	        r_radiusY = m_dwRadiusY;
	
	        ho.roc.rcSpeed = m_dwAngVel;
	    }

	    public override function move():Boolean
		{ 
	        //*** Object needs to be moved?
	        if (!r_Stopped)
	        {
	            var x:Number = r_radiusX * Math.cos(r_CurrentAngle);
	            var y:Number = r_radiusY * Math.sin(r_CurrentAngle);
	
	            //*** Carry out 2D transform if needed
	            if (Math.abs(r_Offset) > 0.0001)
	            {
	                var xprime:Number = Math.cos(r_Offset) * x - y * Math.sin(r_Offset);
	                var yprime:Number = Math.sin(r_Offset) * x + y * Math.cos(r_Offset);
	
	                x = xprime;
	                y = yprime;
	            }
	
	            var calculs:Number = r_AngVel;
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
	
	            animations(CAnim.ANIMID_WALK);
	            ho.hoX = (int) (r_CX + x);
	            ho.hoY = (int) (r_CY - y);
	            collisions();
	
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
	        r_AngVel = m_dwAngVel / 50.0 * (Math.PI / 180.0);
	        r_Offset = m_dwOffset * (Math.PI / 180.0);
	        r_CurrentAngle = m_dwStartAngle * (Math.PI / 180.0);
	        r_radiusX = m_dwRadiusX;
	        r_radiusY = m_dwRadiusY;
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
	            case 3645:	    // SET_CENTRE_X = 3645,
	                param = getParamDouble();
	                r_CX = param;
	                break;
	            case 3646:	    // SET_CENTRE_Y,
	                param = getParamDouble();
	                r_CY = param;
	                break;
	            case 3647:	    // SET_RADIUS_X,
	                param = getParamDouble();
	                r_radiusX = param;
	                break;
	            case 3648:	    // SET_RADIUS_Y,
	                param = getParamDouble();
	                r_radiusY = param;
	                break;
	            case 3649:	    // SET_ANGSPEED,
	                param = getParamDouble();
	                r_AngVel = param / 50.0 * (Math.PI / 180.0);
	                ho.roc.rcSpeed = param;
	                break;
	            case 3650:	    // SET_CURRENTANGLE,
	                param = getParamDouble();
	                r_CurrentAngle = param * (Math.PI / 180.0);
					break;
	            case 3651:	    // SET_OFFSETANGLE,
	                param = getParamDouble();
	                r_Offset = param * (Math.PI / 180.0);
					break;
	            case 3652:	    // GET_CENTRE_X,
	                return r_CX;
	            case 3653:	    // GET_CENTRE_Y,
	                return r_CY;
	            case 3654:	    // GET_RADIUS_X,
	                return r_radiusX;
	            case 3655:	    // GET_RADIUS_Y,
	                return r_radiusY;
	            case 3656:	    // GET_ANGSPEED,
	                return r_AngVel * 50.0 * (180.0 / Math.PI);
	            case 3657:	    // GET_CURRENTANGLE,
	                return r_CurrentAngle * (180 / Math.PI);
	            case 3658:	    // GET_OFFSETANGLE
	                return r_Offset * (180 / Math.PI);
	        }
	        return 0;
	    }
	}
}