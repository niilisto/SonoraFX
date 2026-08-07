//----------------------------------------------------------------------------------
//
// CRUNMVTINANDOUT
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Services.*;

	public class CRunMvtinandout extends CRunMvtExtension
	{
		private static var MOVESTATUS_PREPAREOUT:int=0;
		private static var MOVESTATUS_MOVEOUT:int=1;
		private static var MOVESTATUS_WAITOUT:int=2;
		private static var MOVESTATUS_PREPAREIN:int=3;
		private static var MOVESTATUS_MOVEIN:int=4;
		private static var MOVESTATUS_WAITIN:int=5;
		private static var MOVESTATUS_POSITIONIN:int=6;
		private static var MOVESTATUS_POSITIONOUT:int=7;
		private static var ACTION_POSITIONIN:int=0;
		private static var ACTION_POSITIONOUT:int=1;
		private static var ACTION_MOVEIN:int=2;
		private static var ACTION_MOVEOUT:int=3;
		private static var MFLAG_OUTATSTART:int=0x00000001;
		private static var MFLAG_MOVEATSTART:int=0x00000002;
		private static var MFLAG_STOPPED:int=0x00000004;
		private static var MOVETYPE_LINEAR:int=0;
		private static var MOVETYPE_SMOOTH:int=1;

		private var m_direction:int;
		private var m_speed:int;
		private var m_flags:int;
		private var m_moveStatus:int;
		private var m_angle:Number;
		private var m_maxPente:Number;
		private var m_moveTimerStart:int;
		private var m_stopTimer:int;
		private var m_type:int;
		private var m_startX:int;
		private var m_startY:int;
		private var m_destX:int;
		private var m_destY:int;

		
		public function CRunMvtinandout()
		{
		}
	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_type=file.readInt();
	        m_direction=file.readInt();
	        m_speed=file.readInt();
	        m_flags=file.readInt();
	        m_destX=file.readInt();
	        m_destY=file.readInt();
	    	m_angle=(m_direction*Math.PI)/180.0;
	        m_maxPente=0;
	
	        if ((m_flags&MFLAG_MOVEATSTART)!=0)
	        {
	            if ((m_flags&MFLAG_OUTATSTART)==0)
	            {
	                m_moveStatus=MOVESTATUS_PREPAREOUT;
	            }
	            else
	            {
	                m_moveStatus=MOVESTATUS_PREPAREIN;
	            }
	            m_flags&=~MFLAG_STOPPED;
	    	}
	        else
	        {
	            if ((m_flags&MFLAG_OUTATSTART)==0)
	            {
	            	m_moveStatus=MOVESTATUS_WAITIN;
	            }
	            else
	            {
	            	m_moveStatus=MOVESTATUS_WAITOUT;
	            }
	        }
	    }

	    public override function move():Boolean
	    {
	        // Calcule la position de sortie
	        if (m_maxPente==0)
	        {
	            var maxPente:Number;
	            var x:int=0, y:int=0, rightX:int, bottomY:int;
	            m_startX=ho.hoX;
	            m_startY=ho.hoY;
	
	            if (m_destX!=0 || m_destY!=0)
	            {
	                var vX:int=m_destX-m_startX;
	                var vY:int=m_destY-m_startY;
	                maxPente=Math.sqrt(vX*vX+vY*vY);
	                if (maxPente==0.0)
	                {
	                    m_angle=0.0;
	                }
	                else
	                {
	                    m_angle=Math.acos(vX/maxPente);
	                    if (m_destY>m_startY)
	                    {
	                        m_angle=2.0*Math.PI-m_angle;
	                    }
	                }
	            }
	            else
	            {
	                for (maxPente=0; maxPente<100000; maxPente+=5)
	                {
	                    x=int(Math.cos(m_angle)*maxPente+m_startX);
	                    y=int(-Math.sin(m_angle)*maxPente+m_startY);
	                    rightX=x+ho.hoImgWidth;
	                    bottomY=y+ho.hoImgHeight;
	                    if (x>ho.hoAdRunHeader.rhLevelSx)
	                    {
	                        break;
	                    }
	                    if (y>ho.hoAdRunHeader.rhLevelSy)
	                    {
	                        break;
	                    }
	                    if (rightX<0)
	                    {
	                        break;
	                    }
	                    if (bottomY<0)
	                    {
	                        break;
	                    }
	                }
	                m_destX=x;
	                m_destY=y;
	            }
	            if (maxPente==0)
	            {
	                maxPente=5;
	            }
	            m_maxPente=maxPente;
	        }
	
	        var bRet:Boolean=false;
	        if ((m_flags&MFLAG_OUTATSTART)!=0)
	        {
	            m_flags&=~MFLAG_OUTATSTART;
	            ho.hoX=m_destX;
	            ho.hoY=m_destY;
	            bRet=true;
	        }
	
	        // Stopped?
	        if ((m_flags&MFLAG_STOPPED)!=0)
	        {
	            animations(CAnim.ANIMID_STOP);
	            collisions();
				return ho.roc.rcChanged;
	        }
	
			var pente:Number;
			var deltaTime:int;
	        switch(m_moveStatus)
	        {
	        case MOVESTATUS_PREPAREOUT:
	            ho.hoX=m_startX;
	            ho.hoY=m_startY;
	            m_moveTimerStart=ho.hoAdRunHeader.rhTimer;
	            m_moveStatus=MOVESTATUS_MOVEOUT;
	            break;
	        case MOVESTATUS_MOVEOUT:
	            {
	                deltaTime=int(ho.hoAdRunHeader.rhTimer-m_moveTimerStart);
	                if (deltaTime>=m_speed)
	                {
	                    ho.hoX=m_destX;
	                    ho.hoY=m_destY;
	                    m_moveStatus=MOVESTATUS_WAITOUT;
	                }
	                else
	                {
	                    switch (m_type)
	                    {
	                    case MOVETYPE_LINEAR:
	                        {
	                            pente=(m_maxPente*(Number(deltaTime)/Number(m_speed)));
	                            ho.hoX=int(Math.cos(m_angle)*pente+m_startX);
	                            ho.hoY=int(-Math.sin(m_angle)*pente+m_startY);
	                        }
	                        break;
	                    case MOVETYPE_SMOOTH:
	                        {
	                            pente=m_maxPente-Math.cos(Math.PI/2*(Number(deltaTime)/Number(m_speed)))*m_maxPente;
	                            ho.hoX=int(Math.cos(m_angle)*pente+m_startX);
	                            ho.hoY=int(-Math.sin(m_angle)*pente+m_startY);
	                        }
	                        break;
	                    }
	                }
	                ho.roc.rcDir=int((m_direction*32)/360);
	                ho.roc.rcSpeed=100;
	                animations(CAnim.ANIMID_WALK);
	                bRet=true;
	            }
	            break;
	        case MOVESTATUS_WAITOUT:
	            animations(CAnim.ANIMID_STOP);
				bRet=ho.roc.rcChanged;
	            break;
	        case MOVESTATUS_POSITIONOUT:
	            ho.hoX=m_destX;
	            ho.hoY=m_destY;
	            m_moveStatus=MOVESTATUS_WAITOUT;
	            bRet=true;
	            break;
	        case MOVESTATUS_PREPAREIN:
	            ho.hoX=m_destX;
	            ho.hoY=m_destY;
	            m_moveTimerStart=ho.hoAdRunHeader.rhTimer;
	            m_moveStatus=MOVESTATUS_MOVEIN;
	            break;
	        case MOVESTATUS_MOVEIN:
	            {
	                deltaTime=int(ho.hoAdRunHeader.rhTimer-m_moveTimerStart);
	                if (deltaTime>=m_speed)
	                {
	                    ho.hoX=m_startX;
	                    ho.hoY=m_startY;
	                    m_moveStatus=MOVESTATUS_WAITIN;
	                }
	                else
	                {
	                    switch (m_type)
	                    {
	                    case MOVETYPE_LINEAR:
	                        {
	                            pente=(m_maxPente-(m_maxPente*(Number(deltaTime)/Number(m_speed))));
	                            ho.hoX=int(Math.cos(m_angle)*pente+m_startX);
	                            ho.hoY=int(-Math.sin(m_angle)*pente+m_startY);
	                        }
	                        break;
	                    case MOVETYPE_SMOOTH:
	                        {
	                            pente=m_maxPente-Math.sin(Math.PI/2*(Number(deltaTime)/Number(m_speed)))*m_maxPente;
	                            ho.hoX=int(Math.cos(m_angle)*pente+m_startX);
	                            ho.hoY=int(-Math.sin(m_angle)*pente+m_startY);
	                        }
	                        break;
	                    }
	                }
	                ho.roc.rcDir=(int(((m_direction*32)/360+16)))%32;
	                ho.roc.rcSpeed=100;
	                animations(CAnim.ANIMID_WALK);
	                bRet=true;
	            }
	            break;
	        case MOVESTATUS_WAITIN:
	            animations(CAnim.ANIMID_STOP);
				bRet=ho.roc.rcChanged;
	            break;
	        case MOVESTATUS_POSITIONIN:
	            ho.hoX=m_startX;
	            ho.hoY=m_startY;
	            m_moveStatus=MOVESTATUS_WAITIN;
	            bRet=true;
	            break;
	        }
	
	        // detects the collisions
	        collisions();
	
	        // The object has been moved
	        return bRet;
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	    }
	
	    public override function setXPosition(x:int):void
	    {
	    }
	
	    public override function setYPosition(y:int):void
	    {
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        m_flags|=MFLAG_STOPPED;
	        m_stopTimer=ho.hoAdRunHeader.rhTimer;
	    }

	    public override function reverse():void
	    {
	    }
	
	    public override function start():void
	    {
	        if ((m_flags&MFLAG_STOPPED)!=0)
	        {
	            m_flags&=~MFLAG_STOPPED;
	            m_moveTimerStart+=ho.hoAdRunHeader.rhTimer-m_stopTimer;
	        }
	        if (m_moveStatus==MOVESTATUS_WAITOUT)
	        {
	            m_moveStatus=MOVESTATUS_PREPAREIN;
	        }
	        else if (m_moveStatus==MOVESTATUS_WAITIN)
	        {
	            m_moveStatus=MOVESTATUS_PREPAREOUT;
	        }
	    }
	
	    public override function setSpeed(speed:int):void
	    {
    	}

	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
    	}

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        switch (action)
	        {
	            case ACTION_POSITIONIN:
	                m_moveStatus=MOVESTATUS_POSITIONIN;
	                m_flags&=~MFLAG_STOPPED;
	                break;
	            case ACTION_POSITIONOUT:
	                m_moveStatus=MOVESTATUS_POSITIONOUT;
	                m_flags&=~MFLAG_STOPPED;
	                break;
	            case ACTION_MOVEIN:
	                m_moveStatus=MOVESTATUS_PREPAREIN;
	                m_flags&=~MFLAG_STOPPED;
	                break;
	            case ACTION_MOVEOUT:
	                m_moveStatus=MOVESTATUS_PREPAREOUT;
	                m_flags&=~MFLAG_STOPPED;
	                break;
	            default:
	                break;
	        }
	        return 0;
	    }


	}
}