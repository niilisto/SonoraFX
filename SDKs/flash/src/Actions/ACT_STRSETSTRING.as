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
	
	import Sprites.*;

	public class ACT_STRSETSTRING extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo!=null)
			{
				var text:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
				var pText:CText=CText(pHo);
				if (pText.rsTextBuffer==null || (pText.rsTextBuffer!=null && text!=pText.rsTextBuffer))
				{
					pText.txtSetString(text);
					pText.txtChange(-1);
					if ((pHo.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)==0)
					{
//						pHo.roc.rcChanged=true;
						pHo.modif();
					}
				}
			}        
		}
	}
}