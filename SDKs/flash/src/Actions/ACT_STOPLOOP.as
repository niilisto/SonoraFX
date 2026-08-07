// -----------------------------------------------------------------------------
//
// STOP LOOP
//
// -----------------------------------------------------------------------------
package Actions {
	import Params.CParamExpression;
	import RunLoop.CRun;
	
	public class ACT_STOPLOOP extends CAct
	{
		public override function execute(rhPtr:CRun):void {
			var pLoop:CLoop= rhPtr.findFastLoop
				(rhPtr.get_EventExpressionStringLowercase(CParamExpression(evtParams[0])));
			
			if (pLoop == null)
				return;
			
			pLoop.flags|=CLoop.FLFLAG_STOP;
		}
	}
}