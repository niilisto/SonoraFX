// ------------------------------------------------------------------------------
// 
// CLICK IN ZONE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_MCLICKINZONE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			var key:int=rhPtr.rhEvtProg.rhCurParam0;
			if ((PARAM_SHORT(evtParams[0])).value==key) 
			{
			    var p:PARAM_ZONE=PARAM_ZONE(evtParams[1]);
			    if (rhPtr.rh2MouseX>=p.x1 && rhPtr.rh2MouseX<p.x2 && rhPtr.rh2MouseY>=p.y1 && rhPtr.rh2MouseY<p.y2)
			    {
					return true;	
			    }
			}
			return false;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			if ((PARAM_SHORT(evtParams[0])).value==rhPtr.rhEvtProg.rh2CurrentClick) 
			{
			    var p:PARAM_ZONE=PARAM_ZONE(evtParams[1]);
			    if (rhPtr.rh2MouseX>=p.x1 && rhPtr.rh2MouseX<p.x2 && rhPtr.rh2MouseY>=p.y1 && rhPtr.rh2MouseY<p.y2)
			    {
					return true;	
			    }
			}
			return false;        
	    }
	}
}