//----------------------------------------------------------------------------------
//
// CRUNDEMORECORD : demo enregistree
//
//----------------------------------------------------------------------------------
package RunLoop
{
	import Application.*;	
	import Services.*;	
	import flash.utils.ByteArray;
	
	public class CDemoRecord
	{
	    public static var DEMONOTHING:int=0;
	    public static var DEMORECORD:int=1;
	    public static var DEMOPLAY:int=2;
	
	    public static var DEMOEND:int=0;
	    public static var DEMOENDFRAME:int=1;
	    public static var DEMOKEYDOWN:int=2;
	    public static var DEMOKEYUP:int=3;
	    public static var DEMOJOYSTICK:int=4;
	    public static var DEMOMOUSEPOS:int=5;
	    public static var DEMOMOUSEKEY:int=6;
	    
	    public var m_rhPtr:CRun;
	    public var m_vkNew:ByteArray;
	    public var m_pBuffer:CFile;
	    public var m_joystick:Array;
	    public var m_mouse:CPoint;
	    public var m_graine:int;
	   	public var m_currentPos:int;
	   	
		public function CDemoRecord(rhPtr:CRun, file:CFile)
		{
			m_pBuffer=file;
			m_rhPtr=rhPtr;
			m_rhPtr.rh4DemoMode=DEMONOTHING;
		    m_vkNew=new ByteArray();
		    var n:int;
		    for (n=0; n<CRunApp.MAX_VK; n++)
		    {
		    	m_vkNew.writeByte(0);
		    }
			m_joystick=new Array(4);
			m_mouse=new CPoint();
		}
	    public function startPlaying():void
	    {
			var b1:int=m_pBuffer.readUnsignedByte();
			var b2:int=m_pBuffer.readUnsignedByte();
			m_rhPtr.rh3Graine=(b1<<8+b2);			
		
			var n:int;
			for (n=0; n<CRunApp.MAX_VK; n++)
			{
			    m_vkNew[n]=0;
			}
			for (n=0; n<4; n++)
			{
			    m_joystick[n]=0;
			}
			m_rhPtr.rh4DemoMode=DEMOPLAY;
	    }
	    public function playStep():void
	    {
			var key:int=0;
			var clicks:int=0;
			var n:int;
			var vk:int;
			var code:int;
			var code2:int;
			if (m_rhPtr.rhLoopCount>1)
			{
			    // Le clavier
			    while(true)
			    {
			    	code=m_pBuffer.readUnsignedByte();
					switch (m_pBuffer[m_currentPos])
					{
					    case 6:	// DEMOMOUSEKEY:
					    	code2=m_pBuffer.readUnsignedByte();
							switch (m_pBuffer[m_currentPos+1])
							{
							    case 1:	    // WM_LBUTTONDOWN
									key=0;
									clicks=1;
									break;
							    case 4:	    // WM_RBUTTONDOWN
									key=2;
									clicks=1;
									break;
							    case 7:	    // WM_MBUTTONDOWN
									key=1;
									clicks=1;
									break;
							    case 3:	    // WM_LBUTTONDBLCLICK
									key=0;
									clicks=2;
									break;
							    case 6:	    // WM_RBUTTONDBLCLICK
									key=2;
									clicks=2;
									break;
							    case 9:	    // WM_MBUTTONDBLCLICK
									key=1;
									clicks=2;
									break;
							}
							var m:CSysEventClick=new CSysEventClick(key, clicks);
							m_rhPtr.rhApp.sysEvents.add(m);
							continue;
					    case 3:	    // DEMOKEYUP
					    	vk=m_pBuffer.readUnsignedByte();
							m_vkNew[CKeyConvert.getFlashKey(vk)]=0;
							continue;
					    case 2:	    // DEMOKEYDOWN:
					    	vk=m_pBuffer.readUnsignedByte();
							m_vkNew[CKeyConvert.getFlashKey(vk)]=1;
					    case 4:	    // DEMOJOYSTICK:
							for (n=0; n<4; n++)
							{
							    m_joystick[n]=m_pBuffer.readUnsignedByte();
							}
							continue;
					    case 5:	    // DEMOMOUSEPOS:
							var b1:int=m_pBuffer.readUnsignedByte();
							var b2:int=m_pBuffer.readUnsignedByte();
							m_mouse.x=b1*256+b2;
							b1=m_pBuffer.readUnsignedByte();
							b2=m_pBuffer.readUnsignedByte();
							m_mouse.y=b1*256+b2;
							continue;
					    case 1:	    // DEMOENDFRAME:
							return;
					    case 0:	    // DEMOEND:
							m_rhPtr.rh4DemoMode=DEMONOTHING;
						return;
					}
		    	}
			}        
    	}
	    public function getJoystick(n:int):int
	    {
			return m_joystick[n];
	    }
	    public function setMousePos():void
	    {
//			m_rhPtr.rhApp.setCursorPos(m_mouse.x, m_mouse.y);
	    }
	    public function getMouseX():int
	    {
			return m_mouse.x;
	    }
	    public function getMouseY():int
	    {
			return m_mouse.y;
	    }
	    public function getKeyState(key:int):Boolean
	    {
			if (m_vkNew[key]!=0)
		    	return true;
	        return false;
	    }
	}
}