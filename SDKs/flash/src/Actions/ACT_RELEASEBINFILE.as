// -----------------------------------------------------------------------------
//
// RELEASE BIN FILE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Application.*;
	import Params.*;

	public class ACT_RELEASEBINFILE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var path:int=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));			// Expression
			rhPtr.rhApp.releaseFile(path);
		}
	}
}