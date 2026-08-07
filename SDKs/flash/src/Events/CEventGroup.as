//----------------------------------------------------------------------------------
//
// CEVENTGROUP: Groupe d'evenements
//
//----------------------------------------------------------------------------------
package Events
{
	import Application.*;
	import Actions.*;
	import Conditions.*;
	
	public class CEventGroup
	{
	    public var evgNCond:int;
	    public var evgNAct:int;
	    public var evgFlags:int;
	    public var evgInhibit:int;
	    public var evgInhibitCpt:int;
	    public var evgIdentifier:int;
	    public var evgEvents:Array;
		
	    // Internal flags of eventgroups
	    public static var EVGFLAGS_ONCE:int=0x0001;
	    public static var EVGFLAGS_NOTALWAYS:int=0x0002;
	    public static var EVGFLAGS_REPEAT:int=0x0004;
	    public static var EVGFLAGS_NOMORE:int=0x0008;
	    public static var EVGFLAGS_SHUFFLE:int=0x0010;
	    public static var EVGFLAGS_EDITORMARK:int=0x0020;
	    public static var EVGFLAGS_UNDOMARK:int=0x0040;
	    public static var EVGFLAGS_COMPLEXGROUP:int=0x0080;
	    public static var EVGFLAGS_BREAKPOINT:int=0x0100;
	    public static var EVGFLAGS_ALWAYSCLEAN:int=0x0200;
	    public static var EVGFLAGS_ORINGROUP:int=0x0400;
	    public static var EVGFLAGS_STOPINGROUP:int=0x0800;
	    public static var EVGFLAGS_ORLOGICAL:int=0x1000;
	    public static var EVGFLAGS_GROUPED:int=0x2000;
	    public static var EVGFLAGS_INACTIVE:int=0x4000;
	    public static var EVGFLAGS_NOGOOD:int=0x8000;
	    public static var EVGFLAGS_LIMITED:int=EVGFLAGS_SHUFFLE+EVGFLAGS_NOTALWAYS+EVGFLAGS_REPEAT+EVGFLAGS_NOMORE;
	    public static var EVGFLAGS_DEFAULTMASK:int=EVGFLAGS_BREAKPOINT+EVGFLAGS_GROUPED;

		public function CEventGroup()
		{
		}

	    public static function create(app:CRunApp):CEventGroup
	    {
	        var debut:int=app.file.getFilePointer();
	        
	        var size:int=app.file.readShort();          // evgSize
	        var evg:CEventGroup=new CEventGroup();
	        
	        evg.evgNCond=app.file.readUnsignedByte();
	        evg.evgNAct=app.file.readUnsignedByte();
	        evg.evgFlags=app.file.readAShort();
	        evg.evgInhibit=app.file.readAShort();
	        evg.evgInhibitCpt=app.file.readAShort();
	        evg.evgIdentifier=app.file.readAShort();
	        app.file.skipBytes(2);          // evgUndo
	        
	        evg.evgEvents=new Array(evg.evgNCond+evg.evgNAct);
	        var n:int;
	        var count:int=0;
	        for (n=0; n<evg.evgNCond; n++)
	        {
	            evg.evgEvents[count++]=CCnd.create(app);
	        }
	
	        for (n=0; n<evg.evgNAct; n++)
	        {
	            evg.evgEvents[count++]=CAct.create(app);
	        }
	        
	        // Positionne en fin de groupe
	        app.file.seek(debut-size);
	        
	        return evg;
	    }

	}
}