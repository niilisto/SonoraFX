// -----------------------------------------------------------------------------
//
// SET FONT NAME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;

	public class ACT_EXTSETFONTNAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
	
			var name:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
	
			var info:CFontInfo=CRun.getObjectFont(pHo);
	
			info.lfFaceName=name;
	
			CRun.setObjectFont(pHo, info, null);
		}
	}
}