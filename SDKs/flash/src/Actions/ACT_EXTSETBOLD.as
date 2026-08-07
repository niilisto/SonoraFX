// -----------------------------------------------------------------------------
//
// SET BOLD
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;

	public class ACT_EXTSETBOLD extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var bFlag:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			var info:CFontInfo=CRun.getObjectFont(pHo);
			if (bFlag!=0)
				info.lfWeight=700;
			else
				info.lfWeight=400;
			
			CRun.setObjectFont(pHo, info, null);        
		}
	}
}