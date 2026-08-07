// -----------------------------------------------------------------------------
//
// ADD TO GLOBAL VARIABLE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Expressions.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_ADDVARG extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var num:int;
			if (evtParams[0].code==52)	    // PARAM_VARGLOBAL_EXP 
				num=(rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1);	// &15; YVES: enleve
			else
				num=(PARAM_SHORT(evtParams[0])).value;
			   
			var value:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
			rhPtr.rhApp.getGlobalValueAt(num).add(value);
		}
	}
}