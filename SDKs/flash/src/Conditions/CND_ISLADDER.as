// ------------------------------------------------------------------------------
// 
// IS LADDER AT X/Y
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_ISLADDER extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var x:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var y:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
		
			if ( rhPtr.y_GetLadderAt(-1, x, y) != null )
			    return negaTRUE();
			return negaFALSE();
	    }
	}
}