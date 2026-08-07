// -----------------------------------------------------------------------------
//
// SET PLAYER NAME
//
// -----------------------------------------------------------------------------
package Actions
{
	import Application.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_SETPLAYERNAME extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var joueur:int = evtOi;
			if ( joueur>=CRunApp.MAX_PLAYER )
				return;
			var pString:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
			rhPtr.rhApp.playerNames[joueur]=pString;
		}
	}
}