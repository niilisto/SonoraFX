// -----------------------------------------------------------------------------
//
// SET NUMBER OF LIVES
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;

	public class ACT_SETLIVES extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));			// Expression
			var joueur:int=evtOi;								// Joueur
			rhPtr.actPla_FinishLives(joueur, value);
		}
	}
}