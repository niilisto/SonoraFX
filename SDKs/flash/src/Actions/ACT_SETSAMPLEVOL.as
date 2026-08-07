// -----------------------------------------------------------------------------
//
// SET SAMPLE VOLUME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETSAMPLEVOL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var sample:int=PARAM_SAMPLE(evtParams[0]).sndHandle;
			var volume:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (volume>=0 && volume<=100)
			{
				rhPtr.rhApp.soundPlayer.setSampleVolume(sample, Number(volume)/100.0);
			}
		}
	}
}