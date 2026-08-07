// -----------------------------------------------------------------------------
//
// SET GLOBAL VALUE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CCASETGLOBALVALUE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var number:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var value:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[1]));
			
			(CCCA(pHo)).setGlobalValue(number, value);
		}
	}
}