//----------------------------------------------------------------------------------
//
// CRUNMVTSINWAVE
//
//----------------------------------------------------------------------------------

package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;

	public class CRunMvtclickteam_sinewave extends CRunMvtExtension
	{
	    public static var MFLAG1_MOVEATSTART:int = 1;
	    public static var ONEND_STOP:int = 0;
	    public static var ONEND_RESET:int = 1;
	    public static var ONEND_BOUNCE:int = 2;
	    public static var ONEND_REVERSE:int = 3;
	    public var m_dwFlags:int;
	    public var m_dwSpeed:int;
	    public var m_dwFinalX:int;
	    public var m_dwFinalY:int;
	    public var m_dwAmp:int;
	    public var m_dwAngVel:int;
	    public var m_dwStartAngle:int;
	    public var m_dwOnEnd:int;
	    
	    //*** General variables
	    public var r_CurrentX:Number;
	    public var r_CurrentY:Number;
	    public var r_Stopped:Boolean;
	    public var r_OnEnd:int;
	
	    //*** Line motion variables
	    public var r_Speed:int;
	    public var r_StartX:int;
	    public var r_StartY:int;
	    public var r_FinalX:int;
	    public var r_FinalY:int;
	    public var r_Dx:Number;
	    public var r_Dy:Number;
	    public var r_Steps:Number;
	    public var r_Angle:Number;
	
	    //*** Sine motion variables
	    public var r_Amp:Number;
	    public var r_AngVel:Number;
	    public var r_CurrentAngle:Number;
	    public var r_Cx:Number;
	    public var r_Cy:Number;

	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwFlags = file.readInt();
	        m_dwSpeed = file.readInt();
	        m_dwFinalX = file.readInt();
	        m_dwFinalY = file.readInt();
	        m_dwAmp = file.readInt();
	        m_dwAngVel = file.readInt();
	        m_dwStartAngle = file.readInt();
	        m_dwOnEnd = file.readInt();
	
	        r_StartX = ho.hoX;
	        r_StartY = ho.hoY;
	        r_FinalX = m_dwFinalX;
	        r_FinalY = m_dwFinalY;
	        r_CurrentX = r_StartX;
	        r_CurrentY = r_StartY;
	        r_Amp = m_dwAmp;
	        r_AngVel = (m_dwAngVel * (Math.PI / 180.0)) / 50.0;
	        r_CurrentAngle = m_dwStartAngle * (Math.PI / 180.0);
	//	r_Stopped = (bool)( 1 - m_pMvt->m_dwFlags);
	        r_Stopped = ((m_dwFlags & MFLAG1_MOVEATSTART) == 0);
	        r_OnEnd = m_dwOnEnd;
	
	        //*** Linear motion components;
	        r_Speed = m_dwSpeed;
	        ho.roc.rcSpeed = r_Speed;
	
	        if (r_Speed != 0)
	        {
	            r_Angle = Math.atan2((r_FinalY - r_StartY), (r_FinalX - r_StartX));
	
	            r_Cx = Math.cos(r_Angle + Math.PI * 0.5);
	            r_Cy = Math.sin(r_Angle + Math.PI * 0.5);
	
	            r_Dx = Math.cos(r_Angle) * (r_Speed / 50.0);
	            r_Dy = Math.sin(r_Angle) * (r_Speed / 50.0);
	
	            if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalX - r_StartX) / r_Dx);
	            }
	            else if (Math.abs(r_Dy) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalY - r_StartY) / r_Dy);
	            }
	            else
	            {
	                r_Steps = 0.0;
	            }
	        }
	        else
	        {
	            r_Dx = 0;
	            r_Dy = 0;
	            r_Steps = 0.0;
	        }
	    }

	    public override function move():Boolean
	    {
	        //*** Object needs to be moved?
	        if (r_Speed != 0 && !r_Stopped)
	        {
	            if (r_Steps > 0.0)
	            {
	                var calculs:Number;
	
	                //*** Ensure angle is in the range 0 to 360 degrees
	                if (r_CurrentAngle < 0)
	                {
	                    r_CurrentAngle += 2 * Math.PI;
	                }
	                else if (r_CurrentAngle >= 2 * Math.PI)
	                {
	                    r_CurrentAngle -= 2 * Math.PI;
	                }
	
	                var angVel:Number = r_AngVel;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    angVel = angVel * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                }
	                var dx:Number = r_Dx;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    dx = dx * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                }
	                var dy:Number = r_Dy;
	                if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                {
	                    dy = dy * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                }
	
					var amp:Number;
	                if (r_Steps > 1.0)
	                {
	                    //*** This is not the final section of movement
	                    r_CurrentX += dx;
	                    r_CurrentY += dy;
	                    r_CurrentAngle -= angVel;
	                    calculs = 1.0;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    r_Steps -= calculs;
	                    if (r_Steps<0.1)
	                    {
	                    	r_Steps=0.1;
	                    }
	                }
	                else
	                {
	                    //**** Final section of movement, handle movement completion
	                    r_CurrentX += r_Steps * dx;
	                    r_CurrentY += r_Steps * dy;
	                    r_CurrentAngle -= r_Steps * angVel;
	                    calculs = 1.0;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    r_Steps -= calculs;
	                    if (r_Steps<0.1)
	                    {
	                    	r_Steps=0.1;
	                    }
	
	                    animations(CAnim.ANIMID_WALK);
	
	                    if (r_OnEnd == ONEND_STOP)
	                    {
	                        amp = r_Amp * Math.sin(r_CurrentAngle);
	
	                        //*** Move object, run animation and collision detection
	                        ho.hoX = (int) (r_CurrentX + r_Cx * amp);
	                        ho.hoY = (int) (r_CurrentY + r_Cy * amp);
	                        r_Stopped = true;
	                    }
	                    else if (r_OnEnd == ONEND_RESET)
	                    {
	                        reset();
	                    }
	                    else if (r_OnEnd == ONEND_BOUNCE)
	                    {
	                        bounce(false);
	                    }
	                    else if (r_OnEnd == ONEND_REVERSE)
	                    {
	                        reverse();
	                    }
	
	                    collisions();
	                    return true;
	                }
	
	                //*** Sine motion amplitude
	                amp = r_Amp * Math.sin(r_CurrentAngle);
	
	                //*** Move object, run animation and collision detection
	                animations(CAnim.ANIMID_WALK);
	                ho.hoX = (int) (r_CurrentX + r_Cx * amp);
	                ho.hoY = (int) (r_CurrentY + r_Cy * amp);
	                collisions();
	
	                //*** Indicate the object has been moved
	                return true;
	            }
	        }
	        animations(CAnim.ANIMID_STOP);
	        collisions();
	
	        //*** The object has not been moved
	        return false;
	    }

	    public function reset():void
	    {
	        ho.hoX = r_StartX;
	        ho.hoY = r_StartY;
	
	        r_CurrentX = r_StartX;
	        r_CurrentY = r_StartY;
	        r_CurrentAngle = (m_dwStartAngle) * (Math.PI / 180.0);
	
	        if (r_Speed != 0)
	        {
	            r_Angle = Math.atan2((r_FinalY - r_StartY), (r_FinalX - r_StartX));
	
	            r_Cx = Math.cos(r_Angle + Math.PI / 2);
	            r_Cy = Math.sin(r_Angle + Math.PI / 2);
	
	            r_Dx = Math.cos(r_Angle) * (r_Speed / 50.0);
	            r_Dy = Math.sin(r_Angle) * (r_Speed / 50.0);
	
	            if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalX - r_StartX) / r_Dx);
	            }
	            else if (Math.abs(r_Dy) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalY - r_StartY) / r_Dy);
	            }
	            else
	            {
	                r_Steps = 0.0;
	            }
	        }
	        else
	        {
	            r_Steps = 0.0;
	        }
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        r_CurrentX -= ho.hoX - x;
	        r_CurrentY -= ho.hoY - y;
	
	        ho.hoX = x;
	        ho.hoY = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        r_CurrentX -= ho.hoX - x;
	        ho.hoX = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        r_CurrentY -= ho.hoY - y;
	        ho.hoY = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        r_Stopped = true;
	    }
	
	    public override function bounce(bCurrent:Boolean):void
	    {
	        var amp:Number = r_Amp * Math.sin(r_CurrentAngle);
	        ho.hoX = (int) (r_CurrentX + r_Cx * amp);
	        ho.hoY = (int) (r_CurrentY + r_Cy * amp);
	
	        var tmpX:int = r_FinalX;
	        var tmpY:int = r_FinalY;
	
	        r_FinalX = r_StartX;
	        r_FinalY = r_StartY;
	
	        r_StartX = tmpX;
	        r_StartY = tmpY;
	
	        r_Angle += Math.PI;
	
	        if (r_Speed != 0)
	        {
	            r_Dx *= -1;
	            r_Dy *= -1;
	
	            if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalX - r_CurrentX) / r_Dx);
	            }
	            else if (Math.abs(r_Dy) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalY - r_CurrentY) / r_Dy);
	            }
	            else
	            {
	                r_Steps = 0.0;
	            }
	        }
	        else
	        {
	            r_Dx = 0;
	            r_Dy = 0;
	            r_Steps = 0.0;
	        }
	    }

	    public override function reverse():void
	    {
	        //*** Finish moving the object first *****
	        var amp:Number = r_Amp * Math.sin(r_CurrentAngle);
	        ho.hoX = (int) (r_CurrentX + r_Cx * amp);
	        ho.hoY = (int) (r_CurrentY + r_Cy * amp);
	
	        var tmpX:int = r_FinalX;
	        var tmpY:int = r_FinalY;
	
	        r_FinalX = r_StartX;
	        r_FinalY = r_StartY;
	
	        r_StartX = tmpX;
	        r_StartY = tmpY;
	
	        r_AngVel *= -1;
	        r_Angle += Math.PI;
	
	        if (r_Speed != 0)
	        {
	            r_Dx *= -1;
	            r_Dy *= -1;
	
	            if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalX - r_CurrentX) / r_Dx);
	            }
	            else if (Math.abs(r_Dy) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalY - r_CurrentY) / r_Dy);
	            }
	            else
	            {
	                r_Steps = 0.0;
	            }
	        }
	        else
	        {
	            r_Dx = 0;
	            r_Dy = 0;
	            r_Steps = 0.0;
	        }
	    }

	    public override function start():void
	    {
	        r_Stopped = false;
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        if (speed < 0)
	        {
	            speed = 0; //** Do not allow negative speed
	        }
	        //*** Linear motion components;
	        r_Speed = speed;
	        ho.roc.rcSpeed = r_Speed;
	
	        if (r_Speed != 0)
	        {
	            r_Dx = Math.cos(r_Angle) * (r_Speed / 50.0);
	            r_Dy = Math.sin(r_Angle) * (r_Speed / 50.0);
	
	            if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalX - r_CurrentX) / r_Dx);
	            }
	            else if (Math.abs(r_Dx) > 0.0001)
	            {
	                r_Steps = Math.abs((r_FinalY - r_CurrentY) / r_Dy);
	            }
	            else
	            {
	                r_Steps = 0.0;
	            }
	        }
	        else
	        {
	            r_Dx = 0;
	            r_Dy = 0;
	            r_Steps = 0.0;
	        }
	    }

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        switch (action)
	        {
	            case 3545:	    // SET_SINEWAVE_SPEED = 3545,
	                param = getParamDouble();
	                setSpeed(param);
	                break;
	            case 3546:	    // SET_SINEWAVE_STARTX,
	                param = getParamDouble();
	                r_StartX = param;
	                break;
	            case 3547:	    // SET_SINEWAVE_STARTY,
	                param = getParamDouble();
	                r_StartY = param;
	                break;
	            case 3548:	    // SET_SINEWAVE_FINALX,
	                param = getParamDouble();
	                r_FinalX = param;
	                break;
	            case 3549:	    // SET_SINEWAVE_FINALY,
	                param = getParamDouble();
	                r_FinalY = param;
	                break;
	            case 3550:	    // SET_SINEWAVE_AMPLITUDE,
	                param = getParamDouble();
	                r_Amp = Math.max(param, 0);
	                break;
	            case 3551:	    // SET_SINEWAVE_ANGVEL,
	                param = getParamDouble();
	                r_AngVel = param * (Math.PI / 180.0) / 50.0;
					break;
	            case 3552:	    // SET_SINEWAVE_STARTANG,
	                param = getParamDouble();
	                m_dwStartAngle = int(Math.max(param * (Math.PI / 180.0), 0));
	                break;
	            case 3553:	    // SET_SINEWAVE_CURRENTANGLE,
	                param = getParamDouble();
	                r_CurrentAngle = Math.max(param * (Math.PI / 180.0), 0);
	                break;
	            case 3554:	    // GET_SINEWAVE_SPEED,
	                return ho.roc.rcSpeed;
	            case 3555:	    // GET_SINEWAVE_STARTX,
	                return r_Cx;
	            case 3556:	    // GET_SINEWAVE_STARTY,
	                return r_StartY;
	            case 3557:	    // GET_SINEWAVE_FINALX,
	                return r_FinalX;
	            case 3558:	    // GET_SINEWAVE_FINALY,
	                return r_FinalY;
	            case 3559:	    // GET_SINEWAVE_AMPLITUDE,
	                return r_Amp;
	            case 3560:	    // GET_SINEWAVE_ANGVEL,
	                return r_AngVel * 50.0 * (180.0 / Math.PI);
	            case 3561:	    // GET_SINEWAVE_STARTANG,
	                return m_dwStartAngle;
	            case 3562:	    // GET_SINEWAVE_CURRENTANGLE,
	                return r_CurrentAngle * (180.0 / Math.PI);
	            case 3563:	    // RESET_SINEWAVE,
	                reset();
	                break;
	            case 3564:	    // SET_SINEWAVE_ONCOMPLETION
	                param = getParamDouble();
	                var option:int = param;
	                if (option == ONEND_STOP)
	                {
	                    r_OnEnd = ONEND_STOP;
	                }
	                else if (option == ONEND_RESET)
	                {
	                    r_OnEnd = ONEND_RESET;
	                }
	                else if (option == ONEND_BOUNCE)
	                {
	                    r_OnEnd = ONEND_BOUNCE;
	                }
	                else if (option == ONEND_REVERSE)
	                {
	                    r_OnEnd = ONEND_REVERSE;
	                }
	                break;
	        }
	        return 0;
	    }
	    
	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
	    }

	}
}