// -----------------------------------------------------------------------------
//
// SET LOOP INDEX
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import Services.*;

	public class ACT_SETLOOPINDEX extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pLoop:CLoop= rhPtr.findFastLoop
				(rhPtr.get_EventExpressionStringLowercase(CParamExpression(evtParams[0])));
			
			if (pLoop == null)
				return;
			
			var number:int= rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			
			pLoop.index = number;
		}
	}
}