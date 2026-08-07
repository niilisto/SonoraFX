//----------------------------------------------------------------------------------
//
// CRUNMOVESAFELY2CLONEOBJECTS
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Objects.*;
	
	public class CRunMoveSafely2CloneObjects
	{
	    public var obj:CObject;
	    public var OldX:int;
	    public var OldY:int;
	    public var NewX:int;
	    public var NewY:int;
	    public var Dist:int;

		public function CRunMoveSafely2CloneObjects(o:CObject, d:int)
		{
	        obj = o;
	        Dist = d;			
		}
	}
}