// -----------------------------------------------------------------------------
//
// SET TEXT COLOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Objects.*;
	import Params.*;
	import Services.*;

	public class ACT_EXTSETTEXTCOLOR extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var rgb:int;
			if (evtParams[0].code==22)	    // PARAM_EXPRESSION
			{
				rgb=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				rgb=CServices.swapRGB(rgb);
			}
			else
				rgb=(PARAM_COLOUR(evtParams[0])).color;
	
			CRun.setObjectTextColor(pHo, rgb);        
		}
	}
}