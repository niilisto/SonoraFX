//----------------------------------------------------------------------------------
//
// NOMBRE DE JOUEURS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GAMNPLAYER extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhNPlayers);
		}    
	}
}