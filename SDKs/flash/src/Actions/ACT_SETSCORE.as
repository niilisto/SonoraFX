// -----------------------------------------------------------------------------
//
// SET SCORE
//
// -----------------------------------------------------------------------------
package Actions
{
	import Actions.*;
	import RunLoop.*;
	import Params.*;
	import OI.*;

	public class ACT_SETSCORE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));	    // Expression
			var joueur:int=evtOi;								// Joueur
			var scores:Array=rhPtr.rhApp.getScores();
			scores[joueur]=value;							// Change la valeur
			
			rhPtr.update_PlayerObjects(joueur, COI.OBJ_SCORE, scores[joueur]);        
		}
	}
}