// -----------------------------------------------------------------------------
//
// SET GLOBAL STRING
//
// -----------------------------------------------------------------------------
package Actions
{
	import Params.*;
	
	import RunLoop.*;

	public class ACT_SETGLOBALSTRING extends CAct
	{
	    
		public override function execute(rhPtr:CRun):void
		{
			var num:int;
			if (evtParams[0].code==59)	    // PARAM_VARGLOBAL_EXP 
				num=(rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]))-1);	// &15; YVES: enleve
			else
				num=(PARAM_SHORT(evtParams[0])).value;
			   
			var string:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[1]));
			rhPtr.rhApp.setGlobalStringAt(num, string);	        
		}
	}
}