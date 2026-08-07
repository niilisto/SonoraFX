// -----------------------------------------------------------------------------
//
// SET SAMPLE MAIN PAN
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETSAMPLEMAINPAN extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pan:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (pan>=-100 && pan<=100)
			{
				rhPtr.rhApp.soundPlayer.setMainPan(Number(pan)/100.0);
			}
		}
	}
}