// -----------------------------------------------------------------------------
//
// SET STRIKED OUT
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;

	public class ACT_EXTSETSRIKEOUT extends CAct
	{    
		public override function execute(rhPtr:CRun):void
		{
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var bFlag:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
	
			var info:CFontInfo=CRun.getObjectFont(pHo);
			info.lfStrikeOut=bFlag;	
			CRun.setObjectFont(pHo, info, null);        
	   }
	}
}