// ------------------------------------------------------------------------------
// 
// JOYSTICK PUSHSED
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_JOYPUSHED extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var s:int=rhPtr.rhPlayer[evtOi];
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[0]);
			s&=p.value;
			if (s!=p.value) 
			    return negaFALSE();
			return negaTRUE();
	    }
	}
}