//----------------------------------------------------------------------------------
//
// PARAM_GROUP groupe d'evenements
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_GROUP extends CParam
	{
	    public var grpFlags:int;					// Active / Unactive?
	    public var grpId:int;						// Group identifier
	    public static var GRPFLAGS_INACTIVE:int=0x0001;
	    public static var GRPFLAGS_CLOSED:int=0x0002;
	    public static var GRPFLAGS_PARENTINACTIVE:int=0x0004;
	    public static var GRPFLAGS_GROUPINACTIVE:int=0x0008;
	    public static var GRPFLAGS_GLOBAL:int=0x0010;

		public function PARAM_GROUP()		
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        grpFlags=app.file.readAShort();
	        grpId=app.file.readAShort();
	    }
	}
}