// -----------------------------------------------------------------------------
//
// SET STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_STRSET extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var text:int;
				if (evtParams[0].code==31)	    // PARAM_TEXTNUMBER
					text=(PARAM_SHORT(evtParams[0])).value;
				else
					text=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1;
				var pText:CText=CText(pHo);
				if (pText.txtChange(text))
				{
//					pHo.roc.rcChanged=true;
					pHo.modif();
				}
			}        
		}
	}
}