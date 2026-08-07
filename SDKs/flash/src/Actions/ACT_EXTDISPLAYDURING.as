// -----------------------------------------------------------------------------
//
// DISPLAY DURING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Sprites.*;

	public class ACT_EXTDISPLAYDURING extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			if (pHo.ros!=null)
			{
				pHo.ros.obHide();
				pHo.ros.rsFlags&=~CRSpr.RSFLAG_VISIBLE;
	
            			if (evtParams[0].code == 2)     // PARAM_TIME
            			{
							var p:PARAM_TIME=PARAM_TIME(evtParams[0]);
							pHo.ros.rsFlash=p.timer;
						}
						else
						{
							pHo.ros.rsFlash=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
						}
            	pHo.ros.rsFlashCpt=pHo.ros.rsFlash;	
			}
		}
	}
}