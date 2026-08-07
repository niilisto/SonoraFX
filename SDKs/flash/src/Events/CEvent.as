//----------------------------------------------------------------------------------
//
// CEVENT : une condition ou une action
//
//----------------------------------------------------------------------------------
package Events
{
	public class CEvent
	{
	    public var evtCode:int;
	    public var evtOi:int;					
	    public var evtOiList:int;				
	    public var evtFlags:int;				
	    public var evtFlags2:int;				
	    public var evtDefType:int;		
	    public var evtNParams:int;
	    public var evtParams:Array;
	
	    public static var EVFLAGS_REPEAT:int=0x01;
	    public static var EVFLAGS_DONE:int=0x02;
	    public static var EVFLAGS_DEFAULT:int=0x04;
	    public static var EVFLAGS_DONEBEFOREFADEIN:int=0x08;
	    public static var EVFLAGS_NOTDONEINSTART:int=0x10;
	    public static var EVFLAGS_ALWAYS:int=0x20;
	    public static var EVFLAGS_BAD:int=0x40;
	    public static var EVFLAGS_BADOBJECT:int=0x80;
	    public static var EVFLAGS_DEFAULTMASK:int=EVFLAGS_ALWAYS+EVFLAGS_REPEAT+EVFLAGS_DEFAULT+EVFLAGS_DONEBEFOREFADEIN+EVFLAGS_NOTDONEINSTART;
	    public static var EVFLAG2_NOT:int=0x01;
		
		public function CEvent()
		{
		}

	}
}