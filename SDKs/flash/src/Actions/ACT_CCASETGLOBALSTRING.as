// -----------------------------------------------------------------------------
//
// SET GLOBAL STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_CCASETGLOBALSTRING extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var number:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			var s:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[1]));
			
			(CCCA(pHo)).setGlobalString(number, s);
		}
	}
}