//----------------------------------------------------------------------------------
//
// CRUNMVTREGPOLYGON : Movement polyone!
//
//----------------------------------------------------------------------------------

package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;
	
	public class CRunMvtclickteam_regpolygon extends CRunMvtExtension
	{
	    public static var MFLAG1_MOVEATSTART:int=1;

	    public var m_dwCX:int;
	    public var m_dwCY:int;
	    public var m_dwNumSides:int;
	    public var m_dwRadius:int;
	    public var m_dwFlags:int;
	    public var m_dwRotAng:int;
	    public var m_dwVel:int;
	
	    public var r_Stopped:Boolean;
	    public var r_OnEnd:int;
	    public var r_CX:int;
	    public var r_CY:int;
	    public var r_Sides:int;
	    public var r_Vel:Number;
	    public var r_CurrentAngle:Number;
	    public var r_SideRemainder:Number;
	    public var r_Radius:Number;
	    public var r_CurrentX:Number;
	    public var r_CurrentY:Number;
	    public var r_SideSize:Number;
	    public var r_TurnAngle:Number;
	    
	    public override function initialize(file:CBinaryFile):void
	    {
	        // Version number
	        file.skipBytes(1);
	        m_dwCX = file.readInt();
	        m_dwCY = file.readInt();
	        m_dwNumSides = file.readInt();
	        m_dwRadius = file.readInt();
	        m_dwFlags = file.readInt();
	        m_dwRotAng = file.readInt();
	        m_dwVel = file.readInt();
	
	        //*** General variables
	        var r_StartAngle:Number = m_dwRotAng * (Math.PI / 180.0);
	
	        r_Stopped = ((m_dwFlags & MFLAG1_MOVEATSTART) == 0);
	        r_CX = m_dwCX;
	        r_CY = m_dwCY;
	        r_Sides = m_dwNumSides;
	        r_Vel = m_dwVel / 50.0;
	        r_Radius = m_dwRadius;
	
	        r_CurrentX = r_CX + r_Radius * Math.cos(r_StartAngle);
	        r_CurrentY = r_CY - r_Radius * Math.sin(r_StartAngle);
	        r_SideSize = 2 * r_Radius * Math.sin(Math.PI / r_Sides);
	        r_TurnAngle = (2.0 / r_Sides) * Math.PI;
	        r_CurrentAngle = Math.PI * (0.5 + (1.0 / r_Sides)) + r_StartAngle;
	        r_SideRemainder = r_SideSize;
	
	        ho.roc.rcSpeed = Math.abs(m_dwVel);
	
	        if (r_Vel < 0.0)
	        {
	            r_CurrentAngle = r_CurrentAngle + Math.PI * (1.0 - (2.0 / r_Sides));
	            r_TurnAngle += 2 * Math.PI * (1.0 - (2.0 / r_Sides));
	            r_Vel *= -1;
	        }
	    }

	    public function reset():void
	    {
	        //*** General variables
	        var r_StartAngle:Number = m_dwRotAng * (Math.PI / 180.0);
	
	        r_CX = m_dwCX;
	        r_CY = m_dwCY;
	        r_Sides = m_dwNumSides;
	        r_Vel = m_dwVel / 50.0;
	        r_Radius = m_dwRadius;
	
	        r_CurrentX = r_CX + r_Radius * Math.cos(r_StartAngle);
	        r_CurrentY = r_CY - r_Radius * Math.sin(r_StartAngle);
	        r_SideSize = 2 * r_Radius * Math.sin(Math.PI / r_Sides);
	        r_TurnAngle = (2.0 / r_Sides) * Math.PI;
	        r_CurrentAngle = Math.PI * (0.5 + (1.0 / r_Sides)) + r_StartAngle;
	        r_SideRemainder = r_SideSize;
	
	        if (r_Vel < 0.0)
	        {
	            r_CurrentAngle = r_CurrentAngle + Math.PI * (1.0 - (2.0 / r_Sides));
	            r_TurnAngle += 2 * Math.PI * (1.0 - (2.0 / r_Sides));
	            r_Vel *= -1;
	        }
	    }

	    public override function move():Boolean
	    {
	        //*** Object needs to be moved?
	        if (!r_Stopped)
	        {
	            var toMove:Number = r_Vel;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                toMove = toMove * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	
	            var complete:Boolean = false;
	
	            while (complete == false)
	            {
	                if (toMove >= r_SideRemainder)
	                {
	                    //*** move to the next vertex and turn the angle ready to move along next section
	                    r_CurrentX += r_SideRemainder * Math.cos(r_CurrentAngle);
	                    r_CurrentY -= r_SideRemainder * Math.sin(r_CurrentAngle);
	                    toMove -= r_SideRemainder;
	                    r_SideRemainder = r_SideSize;
	                    r_CurrentAngle += r_TurnAngle;
	                }
	                else
	                {
	                    //*** move along the side
	                    r_CurrentX += toMove * Math.cos(r_CurrentAngle);
	                    r_CurrentY -= toMove * Math.sin(r_CurrentAngle);
	                    r_SideRemainder -= toMove;
	                    complete = true;
	                }
	            }
	            //*** Move object, run animation and collision detection
	            animations(CAnim.ANIMID_WALK);
	            ho.hoX = r_CurrentX;
	            ho.hoY = r_CurrentY;
	            collisions();
	
	            //*** Indicate the object has been moved
	            return true;
	        }
	        animations(CAnim.ANIMID_STOP);
	        collisions();
	        return false;
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        r_CurrentX -= ho.hoX - x;
	        r_CurrentY -= ho.hoY - y;
	
	        r_CX -= ho.hoX - x;
	        r_CY -= ho.hoY - y;
	
	        ho.hoX = x;
	        ho.hoY = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        r_CurrentX -= ho.hoX - x;
	        r_CX -= ho.hoX - x;
	
	        ho.hoX = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        r_CurrentY -= ho.hoY - y;
	        r_CY -= ho.hoY - y;
	
	        ho.hoY = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        r_Stopped = true;
    	}

	    public override function reverse():void
	    {
	        r_CurrentAngle += Math.PI;
	        r_TurnAngle = 2 * Math.PI - r_TurnAngle;
	        r_SideRemainder = r_SideSize - r_SideRemainder;
	    }
	
	    public override function start():void
	    {
	        r_Stopped = false;
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        r_Vel = Math.abs(speed) / 50.0;
	    }

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        switch (action)
	        {
	            case 3445:	    // SET_CENTRE_X = 3445,
	                param = getParamDouble();
	                r_CurrentX += param - r_CX;
	                r_CX = param;
	                break;
	            case 3446:	    // SET_CENTRE_Y,
	                param = getParamDouble();
	                r_CurrentY += param - r_CY;
	                r_CY = param;
	                break;
	            case 3447:	    // SET_NUMSIDES,
	                param = getParamDouble();
	                m_dwNumSides = Math.max(param, 0);
	                reset();
	                break;
	            case 3448:	    // SET_RADIUS,
	                param = getParamDouble();
	                m_dwRadius = Math.max(param, 0);
	                reset();
	                break;
	            case 3449:	    // SET_ROTATION_ANGLE,
	                param = getParamDouble();
	                m_dwRotAng = Math.max(param, 0);
	                reset();
	                break;
	            case 3450:	    // SET_VELOCITY,
	                param = getParamDouble();
	                r_Vel = Math.abs(param) / 50.0;
	                break;
	            case 3451:	    // GET_CENTRE_X,
	                return r_CX;
	            case 3452:	    // GET_CENTRE_Y,
	                return r_CY;
	            case 3453:	    // GET_NUMSIDES,
	                return r_Sides;
	            case 3454:	    // GET_RADIUS,
	                return r_Radius;
	            case 3455:	    // GET_ROTATION_ANGLE,
	                return m_dwRotAng;
	            case 3456:	    // GET_VELOCITY
	                return r_Vel * 50;
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return (r_Vel * 50);
	    }
	}
}