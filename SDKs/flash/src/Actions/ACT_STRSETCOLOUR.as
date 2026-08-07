// -----------------------------------------------------------------------------
//
// SET STRING COLOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class ACT_STRSETCOLOUR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var color:int;
				if (evtParams[0].code==24)	    // PARAM_COLOUR
					color=(PARAM_COLOUR(evtParams[0])).color;
				else
				{
					color=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
					color=CServices.swapRGB(color);
				}
				var pText:CText=CText(pHo);
				pText.rsTextColor=color;
//				pHo.roc.rcChanged=true;
				pText.bTxtChanged=true;
				pHo.modif();
			}
		}
	}
}