// -----------------------------------------------------------------------------
//
// CENTER X DISPLAY
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_CDISPLAYX extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var x:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.setDisplay(x, 0, -1, 1);
		}
	}
}