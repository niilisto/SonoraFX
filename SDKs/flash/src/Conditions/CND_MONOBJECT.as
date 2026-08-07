// ------------------------------------------------------------------------------
// 
// MOUSE ON OBJECT
// 
// ------------------------------------------------------------------------------
package Conditions
{	
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_MONOBJECT extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var flag:Boolean=(evtFlags2&CEvent.EVFLAG2_NOT)!=0;
			var po:PARAM_OBJECT=PARAM_OBJECT(evtParams[0]);
			return rhPtr.getMouseOnObjectsEDX(po.oiList, flag);
	    }
	}
}