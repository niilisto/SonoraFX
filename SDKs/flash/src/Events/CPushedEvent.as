//----------------------------------------------------------------------------------
//
// CPUSHEDEVENT : un evenement pousse
//
//----------------------------------------------------------------------------------
package Events
{
	import Objects.*;
	
	public class CPushedEvent
	{
	    public var routine:int;
	    public var code:int;
	    public var param:int;
	    public var pHo:CObject;
	    public var oi:int;

	    public function CPushedEvent(r:int, c:int, p:int, hoPtr:CObject, o:int)
	    {
	        routine = r;
	        code = c;
	        param = p;
	        pHo = hoPtr;
	        oi = o;
	    }
	}
}