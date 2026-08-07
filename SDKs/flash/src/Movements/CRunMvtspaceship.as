//----------------------------------------------------------------------------------
//
// CRUNMVTSPACESHIP : Movement spaceship!
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Objects.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunMvtspaceship extends CRunMvtExtension
	{
	    public var m_dwPower:int;
	    public var m_dwRotationSpeed:int;
	    public var m_dwInitialSpeed:int;
	    public var m_dwInitialDir:int;
	    public var m_dwDeceleration:int;
	    public var m_dwGravity:int;
	    public var m_dwGravityDir:int;
	    public var m_dwPlayer:int;
	    public var m_dwButton:int;
	    public var m_dwFlags:int;
	    
	    public var m_X:Number;
	    public var m_Y:Number;
	    public var m_xVector:Number;
	    public var m_yVector:Number;
	    public var m_xGravity:Number;
	    public var m_yGravity:Number;
	    public var m_deceleration:Number;
	    public var m_power:Number;
	    public var m_button:int;
	    public var m_rotationSpeed:int;
	    public var m_rotCounter:int;
	    public var m_gravity:int;
	    public var m_gravityAngle:int;
	    public var m_bStop:Boolean;
	    public var m_autoReactor:Boolean;
	    public var m_autoRotateRight:Boolean;
	    public var m_autoRotateLeft:Boolean;
	    public var m_initialSpeed:int;
	
		public function CRunMvtspaceship()
		{
		}

	    public override function initialize(file:CBinaryFile):void
	    {
	        // Charge les données
	        var version:int = file.readByte();
	        m_dwPower = file.readInt();
	        m_dwRotationSpeed = file.readInt();
	        m_dwInitialSpeed = file.readInt();
	        m_dwInitialDir = file.readInt();
	        m_dwDeceleration = file.readInt();
	        m_dwGravity = file.readInt();
	        m_dwGravityDir = file.readInt();
	        m_dwPlayer = file.readInt();
	        m_dwButton = file.readInt();
	        m_dwFlags = file.readInt();
	
	        // Initialisations
	        m_X = ho.hoX;
	        m_Y = ho.hoY;
	
	        // Finds the initial speed vectors
	        ho.roc.rcSpeed = m_dwInitialSpeed;
	        ho.roc.rcDir = dirAtStart(m_dwInitialDir);
	        var angle:Number = (ho.roc.rcDir * 2 * Math.PI) / 32.0;
	        m_xVector = ho.roc.rcSpeed * Math.cos(angle);
	        m_yVector = -ho.roc.rcSpeed * Math.sin(angle);
	
	        // Calculates the vectors
	        m_gravity = m_dwGravity;
	        m_gravityAngle = dirAtStart(m_dwGravityDir);
	        angle = (m_gravityAngle * 2 * Math.PI) / 32.0;
	        m_xGravity = m_gravity * Math.cos(angle);
	        m_yGravity = -m_gravity * Math.sin(angle);
	
	        // Other values
	        m_deceleration = m_dwDeceleration;
	        m_rotationSpeed = m_dwRotationSpeed;
	        m_power = m_dwPower;
	        m_button = m_dwButton;
	        m_bStop = false;
	        ho.roc.rcPlayer = m_dwPlayer;
	        m_rotCounter = 0;
	
	        m_autoReactor = false;
	        m_autoRotateRight = false;
	        m_autoRotateLeft = false;
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
	        var anim:int = CAnim.ANIMID_WALK;
	
	        if (m_bStop == false)
	        {
	            // Get the joystick
	            var j:int = rh.rhPlayer[ho.roc.rcPlayer];
	
	            // Rotation of the ship
	            if ((j & 15) != 0 || (m_autoRotateRight || m_autoRotateLeft))
	            {
	                var rotSpeed:int = m_rotationSpeed;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    rotSpeed = int(( Number(rotSpeed)) * ho.hoAdRunHeader.rh4MvtTimerCoef);
	                }
	                m_rotCounter += rotSpeed;
	                if (m_rotCounter >= 100)
	                {
	                    m_rotCounter -= 100;
	                    if ((j & 0x04) != 0 || m_autoRotateLeft)
	                    {
	                        m_autoRotateLeft = false;
	                        ho.roc.rcDir += 1;
	                        if (ho.roc.rcDir >= 32)
	                        {
	                            ho.roc.rcDir -= 32;
	                        }
	                    }
	                    if ((j & 0x08) != 0 || m_autoRotateRight)
	                    {
	                        m_autoRotateRight = false;
	                        ho.roc.rcDir -= 1;
	                        if (ho.roc.rcDir < 0)
	                        {
	                            ho.roc.rcDir += 32;
	                        }
	                    }
	                }
	            }
	
	            // Movement of the ship
	            var mask:int = 0x01;
	            switch (m_button)
	            {
	                case 0:
	                    mask = 0x01;
	                    break;
	                case 1:
	                    mask = 0x10;
	                    break;
	                case 2:
	                    mask = 0x20;
	                    break;
	            }
	
	            var calculs:Number;
	            var angle:Number;
	            if ((j & mask) != 0 || (m_autoReactor))
	            {
	                angle= (ho.roc.rcDir * 2 * Math.PI) / 32.0;
	
	                calculs = m_power;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                }
	
	                var m_xPower:Number = calculs * Math.cos(angle);
	                var m_yPower:Number = -calculs * Math.sin(angle);
	
	                m_xVector += m_xPower / 150.0;
	                m_yVector += m_yPower / 150.0;
	
	                anim = CAnim.ANIMID_JUMP;
	
	                // switch off automatic reactor (as have applied it)
	                m_autoReactor = false;
	            }
	
	            // Gravity
	            calculs = m_xGravity;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            m_xVector += calculs / 150.0;
	            calculs = m_yGravity;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            m_yVector += calculs / 150.0;
	
	            // Deceleration
	            angle= getAngle(m_xVector, m_yVector);	// Get the angle and vector
	            var vector:Number = getVector(m_xVector, m_yVector);	// Get the angle and vector
	            calculs = m_deceleration;
	            if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	            {
	                calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	            }
	            vector -= calculs / 250.0;
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
	
	            ho.roc.rcSpeed = int(vector);
	        }
	
	        // Performs the animation
	        if (ho.roc.rcSpeed > 100)
	        {
	            ho.roc.rcSpeed = 100;
	        }
	        animations(anim);
	
	        // detects the collisions
	        ho.hoX = int(m_X);
	        ho.hoY = int(m_Y);
	        collisions();
	
	        return true;
	    }

	    public function modf(value:Number):Number
	    {
	        var i:int = int(value);
	        return value - i;
	    }
	
	    public override function setPosition(x:int, y:int):void
	    {
	        ho.hoX = x;
	        ho.hoY = y;
	
	        var dummy:Number, frac:Number;
	        frac = modf(m_X);
	        m_X = x + frac;
	        frac = modf(m_Y);
	        m_Y = y + frac;
	    }

	    public override function setXPosition(x:int):void
	    {
	        ho.hoX = x;
	        var dummy:Number, frac:Number;
	        frac = modf(m_X);
	        m_X = x + frac;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        ho.hoY = y;
	        var dummy:Number, frac:Number;
	        frac = modf(m_Y);
	        m_Y = y + frac;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        m_bStop = true;
	    }
	
	    public override function bounce(bCurrent:Boolean):void
	    {
	        if (bCurrent)
	        {
	            var pt:CPoint = new CPoint();
	            approachObject(ho.hoX, ho.hoY, ho.roc.rcOldX, ho.roc.rcOldY, 0, CColMask.CM_TEST_PLATFORM, pt);
	            ho.hoX = pt.x;
	            ho.hoY = pt.y;
	            m_X = pt.x;
	            m_Y = pt.y;
	        }
	        m_xVector = -m_xVector;
	        m_yVector = -m_yVector;
	    }

	    public override function reverse():void
	    {
	        m_xVector = -m_xVector;
	        m_yVector = -m_yVector;
	    }
	
	    public override function start():void
	    {
	        m_bStop = false;
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        if (speed < 0)
	        {
	            speed = 0;
	        }
	        if (speed > 100)
	        {
	            speed = 100;
	        }
	
	        var angle:Number = (ho.roc.rcDir * 2 * Math.PI) / 32.0;
	        ho.roc.rcSpeed = speed;
	        m_xVector = speed * Math.cos(angle);
	        m_yVector = -speed * Math.sin(angle);
	    }

	    public override function setDir(dir:int):void
	    {
	        var angle:Number = getAngle(m_xVector, m_yVector);	// Get the angle and vector
	        var vector:Number = getVector(m_xVector, m_yVector);
	        angle = (dir * 2 * Math.PI) / 32.0;
	        ho.roc.rcDir = dir;
	        m_xVector = vector * Math.cos(angle);					// Restores X and Y speeds
	        m_yVector = -vector * Math.sin(angle);
	    }

	    public override function setDec(dec:int):void
	    {
	        if (dec < 0)
	        {
	            dec = 0;
	        }
	        if (dec > 100)
	        {
	            dec = 100;
	        }
	        m_deceleration = dec;
    	}

	    public override function setRotSpeed(speed:int):void
	    {
	        if (speed < 0)
	        {
	            speed = 0;
	        }
	        if (speed > 100)
	        {
	            speed = 100;
	        }
	        m_rotationSpeed = speed;
    	}

	    public override function setGravity(gravity:int):void
	    {
	        if (gravity < 0)
	        {
	            gravity = 0;
	        }
	        if (gravity > 100)
	        {
	            gravity = 100;
	        }
	
	        m_gravity = gravity;
	        var angle:Number = (m_gravityAngle * 2 * Math.PI) / 32.0;
	        m_xGravity = m_gravity * Math.cos(angle);
	        m_yGravity = -m_gravity * Math.sin(angle);
	    }

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;

	        switch (action)
	        {
	            case 0:		// SPACE_SETPOWER:
	                param = int(getParamDouble());
	                if (param < 0)
	                {
	                    param = 10;
	                }
	                if (param > 100)
	                {
	                    param = 100;
	                }
	                m_power = param;
	                break;
	            case 1:		// SPACE_SETSPEED:
	                param = int(getParamDouble());
	                setSpeed(param);
	                break;
	            case 2:		// SPACE_SETDIR:
	                param = int(getParamDouble());
	                setDir(param);
	                break;
	            case 3:		// SPACE_SETDEC:
	                param = int(getParamDouble());
	                setDec(param);
	                break;
	            case 4:		// SPACE_SETROTSPEED:
	                param = int(getParamDouble());
	                setRotSpeed(param);
	                break;
	            case 5:		// SPACE_SETGRAVITY:
	                param = int(getParamDouble());
	                setGravity(param);
	                break;
	            case 6:		// SPACE_SETGRAVITYDIR:
	                param = int(getParamDouble());
	                var angle2:Number = (param * 2 * Math.PI) / 32.0;
	                m_xGravity = m_gravity * Math.cos(angle2);
	                m_yGravity = -m_gravity * Math.sin(angle2);
	                break;
	            case 7:		// SPACE_APPLYREACTOR:
	                m_autoReactor = true;
	                break;
	            case 8:		// SPACE_APPLYROTATERIGHT:
	                m_autoRotateRight = true;
	                break;
	            case 9:		// SPACE_APPLYROTATELEFT:
	                m_autoRotateLeft = true;
	                break;
	            case 10:		// SPACE_GETGRAVITY:
	                return m_gravity;
	            case 11:		// SPACE_GETGRAVITYDIR:
	                return m_gravityAngle;
	            case 12:		// SPACE_GETDECELERATION:
	                return m_deceleration;
	            case 13:		// PACE_GETROTATIONSPEED:
	                return m_rotationSpeed;
	            case 14:		// SPACE_GETTHRUSTPOWER:
	                return m_power;
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
	    }
	
	    public override function getAcceleration():int
	    {
	        return int(m_power);
	    }
	
	    public override function getDeceleration():int
	    {
	        return int(m_deceleration);
	    }
	
	    public override function getGravity():int
	    {
	        return int(m_gravity);
	    }

	}
}