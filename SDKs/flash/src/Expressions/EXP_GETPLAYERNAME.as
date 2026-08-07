//----------------------------------------------------------------------------------
//
// PLAYER NAME
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_GETPLAYERNAME extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceString(rhPtr.rhApp.playerNames[oi]);
		}    
	}
}