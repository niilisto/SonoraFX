// -----------------------------------------------------------------------------
//
// SET SAMPLE PAN
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETSAMPLEPAN extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var sample:int=PARAM_SAMPLE(evtParams[0]).sndHandle;
			var pan:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (pan>=-100 && pan<=100)
			{
				rhPtr.rhApp.soundPlayer.setSamplePan(sample, Number(pan)/100.0);
			}
		}
	}
}