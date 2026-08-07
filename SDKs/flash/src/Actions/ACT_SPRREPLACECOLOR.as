// -----------------------------------------------------------------------------
//
// REPLACE COLOR
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class ACT_SPRREPLACECOLOR extends CAct 
	{
		public var replace:CActReplaceColor=null;
	    
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;

			// Un cran d'animation sans effet
			pHo.roa.animIn(0);
	
			// Recupere parametres
			var oldColor:int;
			if (evtParams[0].code==24)	    // PARAM_COLOUR)
				oldColor=(PARAM_COLOUR(evtParams[0])).color;
			else
			{
				oldColor=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
				oldColor=CServices.swapRGB(oldColor);
			}

			var newColor:int;
			if (evtParams[1].code==24)	    // PARAM_COLOUR)
				newColor=(PARAM_COLOUR(evtParams[1])).color;
			else
			{
				newColor=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
				newColor=CServices.swapRGB(newColor);
			}
		   
			if (replace==null)
			{
				replace=new CActReplaceColor();
			}
	        replace.execute(rhPtr, pHo, newColor, oldColor);
		}
	}
}