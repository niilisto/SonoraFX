// ------------------------------------------------------------------------------
// 
// CND_PICKFROMID_OLD
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_PICKFROMID_OLD extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			return rhPtr.rhEvtProg.pickFromId(value);	
	    }
	}
}