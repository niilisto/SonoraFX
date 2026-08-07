// -----------------------------------------------------------------------------
//
// ADD TO LIVES
//
// -----------------------------------------------------------------------------

package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	public class ACT_ADDLIVES extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));			// Expression
			var joueur:int=evtOi;	// Joueur
			value=rhPtr.rhApp.getLives()[joueur]+value;
			rhPtr.actPla_FinishLives(joueur, value);
		}
	}
}