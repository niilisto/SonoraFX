// ------------------------------------------------------------------------------
// 
// TIMER SUPERIEUR
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_TIMERSUP extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var time:int;
			if (evtParams[0].code==22)	// PARAM_EXPRESSION
			    time=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			else
			    time=(PARAM_TIME(evtParams[0])).timer;
		
			if (rhPtr.rhTimer>time) 
			    return true;
		
			return false;
	    }
	}
}