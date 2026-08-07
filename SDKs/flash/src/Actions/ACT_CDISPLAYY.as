// -----------------------------------------------------------------------------
//
// CENTER DISPLAY Y
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_CDISPLAYY extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var y:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.setDisplay(0, y, -1, 2);
		}
	}
}