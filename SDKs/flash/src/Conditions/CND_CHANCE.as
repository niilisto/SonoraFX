// ------------------------------------------------------------------------------
// 
// X CHANCES OUT OF Y
// 
// ------------------------------------------------------------------------------

package Conditions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_CHANCE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	        return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var param1:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var param2:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (param2>=1 && param1>0 && param1<=param2)
			{
			    var rnd:int=rhPtr.random(param2);
			    if (rnd<=param1)
			    {
					return true;
			    }
			}
			return false;
	    }
	}
}