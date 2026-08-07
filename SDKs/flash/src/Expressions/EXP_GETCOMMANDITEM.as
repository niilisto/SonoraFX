//----------------------------------------------------------------------------------
//
// GETCOMMANDITEM
//
//----------------------------------------------------------------------------------
package Expressions
{
	import RunLoop.*;

	public class EXP_GETCOMMANDITEM extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			
			var ret:String = rhPtr.rhApp.flashVars[rhPtr.get_ExpressionString()];
			
			if(!ret)
				ret="";	
			
			rhPtr.getCurrentResult().forceString(ret);
		}
	}
}