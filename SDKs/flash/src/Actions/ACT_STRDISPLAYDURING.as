// -----------------------------------------------------------------------------
//
// DISPLAY STRING DURING
//
// -----------------------------------------------------------------------------
package Actions {
	import Objects.CObject;
	import Params.CParamExpression;
	import Params.PARAM_SHORT;
	import Params.PARAM_TIME;
	import RunLoop.CRun;
	
	public class ACT_STRDISPLAYDURING extends CAct
	{
		public override function execute(rhPtr:CRun):void {
			var p:PARAM_SHORT=PARAM_SHORT(evtParams[1]);
			var num:int=rhPtr.txtDoDisplay(this, p.value);			// trouve le numero du texte
			if (num>=0)
			{
				var hoPtr:CObject=rhPtr.rhObjectList[num];
				if (evtParams[2].code == 2)     // PARAM_TIME
				{
					var p2:PARAM_TIME=PARAM_TIME(evtParams[2]);
					hoPtr.ros.rsFlash=p2.timer;
				}
				else
				{
					hoPtr.ros.rsFlash=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[2]));
				}
				hoPtr.ros.rsFlashCpt=hoPtr.ros.rsFlash;
			}
		}
	}
}