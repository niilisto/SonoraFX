// -----------------------------------------------------------------------------
//
// SET SAMPLE POSITION
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETSAMPLEPOS extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var sample:int=PARAM_SAMPLE(evtParams[0]).sndHandle;
			var position:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (position>=0)
			{
				rhPtr.rhApp.soundPlayer.setSamplePos(sample, Number(position));
			}
		}
	}
}