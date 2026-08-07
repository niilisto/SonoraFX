// -----------------------------------------------------------------------------
//
// SET COLOR 2
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class ACT_CSETCOLOR2 extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var color:int;
			if (evtParams[0].code==CParam.PARAM_EXPRESSIONNUM)
			{
				color=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				color=CServices.swapRGB(color);
			}
			else
				color=(PARAM_COLOUR(evtParams[0])).color;
			
			(CCounter(pHo)).cpt_SetColor2(color);        
		}
	}
}