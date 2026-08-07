//----------------------------------------------------------------------------------
//
// COMPARE TWO GENERAL VALUES
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_COMPARE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var value1:CValue=new CValue(0);
			value1.forceValue(rhPtr.get_EventExpressionAny(CParamExpression(evtParams[0])));
		
			var pp:CParamExpression=CParamExpression(evtParams[1]);
			var value2:CValue=rhPtr.get_EventExpressionAny(pp);
		
			return CRun.compareTo(value1, value2, pp.comparaison);
	    }    
	}
}