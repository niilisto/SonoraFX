// ------------------------------------------------------------------------------
// 
// MOUSE IN ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_MINZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var p:PARAM_ZONE=PARAM_ZONE(evtParams[0]);
			if (rhPtr.rh2MouseX>=p.x1 && rhPtr.rh2MouseX<p.x2 && rhPtr.rh2MouseY>=p.y1 && rhPtr.rh2MouseY<p.y2)
			    return negaTRUE();	
			return negaFALSE();
	    }
	}
}