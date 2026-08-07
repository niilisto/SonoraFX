// ------------------------------------------------------------------------------
// 
// MOUSE CLICK
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_MCLICK extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var key:int=rhPtr.rhEvtProg.rhCurParam0;
			if ((PARAM_SHORT(evtParams[0])).value!=key) 
			    return false;
			return true;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if ((PARAM_SHORT(evtParams[0])).value==rhPtr.rhEvtProg.rh2CurrentClick) 
			    return true;
			return false;
	    }
	}
}