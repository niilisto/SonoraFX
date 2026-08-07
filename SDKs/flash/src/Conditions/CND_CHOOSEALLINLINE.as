// ------------------------------------------------------------------------------
// 
// CHOOSE ALL OBJECT IN A LINE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CHOOSEALLINLINE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);        
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var x1:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var y1:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			var x2:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[2]));
			var y2:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[3]));
		
			if (rhPtr.rhEvtProg.select_LineOfSight(x1, y1, x2, y2)!=0)
			    return true;
			return false;        
	    }
	}
}