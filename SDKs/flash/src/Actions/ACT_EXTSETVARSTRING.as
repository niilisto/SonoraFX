// -----------------------------------------------------------------------------
//
// SET ALTERABLE STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Values.*;

	public class ACT_EXTSETVARSTRING extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var pHo:CObject=rhPtr.rhEvtProg.get_ActionObjects(this);
			if (pHo==null) 
				return;
			
			var num:int;
			if (evtParams[0].code==62)	// PARAM_ALTSTRING_EXP
				num=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			else
				num=(PARAM_SHORT(evtParams[0])).value;
	
			if (num>=0 && num<CRVal.STRINGS_NUMBEROF_ALTERABLE)
			{
				var s:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[1]));
				pHo.rov.setString(num, s);
			}        
		}
	}
}