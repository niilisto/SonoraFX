// ------------------------------------------------------------------------------
// 
// QUESTION EQUALS
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_QEQUAL extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			// Le parametre
			var num:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
		
			// Compare
			if (rhPtr.rhEvtProg.rhCurParam0==num) 
			    return true;
			return false;
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return false;        
	    }
	}
}