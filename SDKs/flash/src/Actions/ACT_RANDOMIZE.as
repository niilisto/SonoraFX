// -----------------------------------------------------------------------------
//
// RANDOMIZE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_RANDOMIZE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var seed:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			rhPtr.rh3Graine=seed;	
		}
	}
}