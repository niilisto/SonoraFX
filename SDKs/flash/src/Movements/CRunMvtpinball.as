//----------------------------------------------------------------------------------
//
// CRUNMVTPINBALL : movement pinball
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Objects.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunMvtpinball extends CRunMvtExtension
	{
	    public static var EFLAG_MOVEATSTART:int=1;
	    public static var MFLAG_STOPPED:int=1;
	
	    public var m_dwInitialSpeed:int;
	    public var m_dwDeceleration:int;
	    public var m_dwGravity:int;
	    public var m_dwInitialDir:int;
	    public var m_dwFlags:int;
	
	    public var m_gravity:Number;
	    public var m_xVector:Number;
	    public var m_yVector:Number;
	    public var m_angle:Number;
	    public var m_X:Number;
	    public var m_Y:Number;
	    public var m_deceleration:Number;
	    public var m_flags:int;
	
		public function CRunMvtpinball()
		{
		}

	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwInitialSpeed = file.readInt();
	        m_dwDeceleration = file.readInt();
	        m_dwGravity = file.readInt();
	        m_dwInitialDir = file.readInt();
	        m_dwFlags = file.readInt();
	
	        // Initialisations
	        m_X = ho.hoX;
	        m_Y = ho.hoY;
	        ho.roc.rcSpeed = m_dwInitialSpeed;
	
	        // Finds the initial direction
	        ho.roc.rcDir = dirAtStart(m_dwInitialDir);
	        var angle:Number = (ho.roc.rcDir * 2 * Math.PI) / 32.0;
	
	        // Calculates the vectors
	        m_gravity = m_dwGravity;
	        m_deceleration = m_dwDeceleration;
	        m_xVector = ho.roc.rcSpeed * Math.cos(angle);
	        m_yVector = -ho.roc.rcSpeed * Math.sin(angle);
	
	        // Move at start
	        m_flags = 0;
	        if ((m_dwFlags & EFLAG_MOVEATSTART) == 0)
	        {
	            m_flags |= MFLAG_STOPPED;
	        }
	    }

	    public function getAngle(vX:Number, vY:Number):Number
	    {
	        var vector:Number = Math.sqrt(vX * vX + vY * vY);
	        if (vector == 0.0)
	        {
	            return 0.0;
	        }
	        var angle:Number = Math.acos(vX / vector);
	        if (vY > 0.0)
	        {
	            angle = 2.0 * Math.PI - angle;
	        }
	        return angle;
	    }
	
	    public function getVector(vX:Number, vY:Number):Number
	    {
	        return Math.sqrt(vX * vX + vY * vY);
	    }

	    public override function move():Boolean
	    {
	        // Stopped?
	        if ((m_flags & MFLAG_STOPPED) != 0)
	        {
	            animations(CAnim.ANIMID_STOP);
	            collisions();
	            return false;
	        }
	
	        // Increase Y speed
	        m_yVector += m_gravity / 10.0;
	
	        // Get the current vector of the ball
	        var angle:Number = getAngle(m_xVector, m_yVector);	// Get the angle and vector
	        var vector:Number = getVector(m_xVector, m_yVector);
	        var calculs:Number = m_deceleration;
	        if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	        {
	            calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	        }
	        vector -= calculs / 50.0;
	        if (vector < 0.0)
	        {
	            vector = 0.0;
	        }
	        m_xVector = vector * Math.cos(angle);					// Restores X and Y speeds
	        m_yVector = -vector * Math.sin(angle);
	
	        // Calculate the new position
	        calculs = m_xVector;
	        if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	        {
	            calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	        }
	        m_X = m_X + (calculs / 10.0);
	        calculs = m_yVector;
	        if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	        {
	            calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	        }
	        m_Y = m_Y + (calculs / 10.0);
	
	        // Performs the animation
	        ho.roc.rcSpeed = vector;
	        if (ho.roc.rcSpeed > 100)
	        {
	            ho.roc.rcSpeed = 100;
	        }
	        ho.roc.rcDir = int((angle * 32) / (2.0 * Math.PI));
	        animations(CAnim.ANIMID_WALK);
	
	        // detects the collisions
	        ho.hoX = int(m_X);
	        ho.hoY = int(m_Y);
	        collisions();
	
	        // The object has been moved
	        return true;
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        ho.hoX = int(x);
	        ho.hoY = int(y);
	        m_X = x;
	        m_Y = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        ho.hoX = int(x);
	        m_X = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        ho.hoY = int(y);
	        m_Y = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        m_flags |= MFLAG_STOPPED;
	    }
	
	    public override function bounce(bCurrent:Boolean):void
	    {
	        if (!bCurrent)
	        {
	            m_xVector = -m_xVector;
	            m_yVector = -m_yVector;
	            return;
	        }
	
	        // Takes the object against the obstacle
	        var pt:CPoint = new CPoint();
	        approachObject(ho.hoX, ho.hoY, ho.roc.rcOldX, ho.roc.rcOldY, 0, CColMask.CM_TEST_PLATFORM, pt);
	        ho.hoX = pt.x;
	        ho.hoY = pt.y;
	        m_X = pt.x;
	        m_Y = pt.y;
	
	        // Get the current vector of the ball
	        var angle:Number = getAngle(m_xVector, m_yVector);
	        var vector:Number = getVector(m_xVector, m_yVector);
	
	        // Finds the shape of the obstacle
	        var a:Number;
	        var aFound:Number = -1000;
	        for (a = 0.0; a < 2.0 * Math.PI; a += Math.PI / 32.0)
	        {
	            var xVector:Number = 16 * Math.cos(angle + a);
	            var yVector:Number = -16 * Math.sin(angle + a);
	            var x:Number = m_X + xVector;
	            var y:Number = m_Y + yVector;
	
	            if (testPosition(x, y, 0, CColMask.CM_TEST_PLATFORM, false))
	            {
	                aFound = a;
	                break;
	            }
	        }
	
	        // If nothing is found, simply go backward
	        if (aFound == -1000)
	        {
	            m_xVector = -m_xVector;
	            m_yVector = -m_yVector;
	        }
	        else
	        {
	            // The angle is found, proceed with the bounce
	            angle += aFound * 2;
	            if (angle > 2.0 * Math.PI)
	            {
	                angle -= 2.0 * Math.PI;
	            }
	
	            // Restores the speed vectors
	            m_xVector = vector * Math.cos(angle);
	            m_yVector = -vector * Math.sin(angle);
	        }
	    }
	    
	    public override function reverse():void
	    {
	        m_xVector = -m_xVector;
	        m_yVector = -m_yVector;
	    }
	
	    public override function start():void
	    {
	        m_flags &= ~MFLAG_STOPPED;
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        ho.roc.rcSpeed = speed;
	
	        // Gets the current speed vector
	        var angle:Number = getAngle(m_xVector, m_yVector);
	        var vector:Number = getVector(m_xVector, m_yVector);
	
	        // Changes the current x and y vectors
	        m_xVector = speed * Math.cos(angle);
	        m_yVector = -speed * Math.sin(angle);
	    }

	    public override function setDir(dir:int):void
	    {
	        ho.roc.rcDir = dir;
	
	        // Get the current speed vector
	        var angle:Number = getAngle(m_xVector, m_yVector);
	        var vector:Number = getVector(m_xVector, m_yVector);
	
	        // Converts the angle in 32 directions to a angle in radian
	        angle = dir * 2.0 * Math.PI / 32.0;
	
	        // Changes the speeds
	        m_xVector = vector * Math.cos(angle);
	        m_yVector = -vector * Math.sin(angle);
	    }
	
	    public override function setGravity(gravity:int):void
	    {
	        m_gravity = gravity;
	    }

	    public override function actionEntry(action:int):Number
	    {
	        switch (action)
	        {
	            default:		// SET_INVADERS_SPEED = 3745,
	                m_gravity = getParamDouble();
	                break;
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
	    }

	    public override function getDeceleration():int
	    {
	        return m_deceleration;
	    }
	
	    public override function getGravity():int
	    {
	        return m_gravity;
	    }
	}
}