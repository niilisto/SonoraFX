// -----------------------------------------------------------------------------
//
// SET SAMPLE MAIN VOL
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETSAMPLEMAINVOL extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var volume:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			if (volume>=0 && volume<=100)
			{
				rhPtr.rhApp.soundPlayer.setMainVolume(Number(volume)/100.0);
			}
		}
	}
}