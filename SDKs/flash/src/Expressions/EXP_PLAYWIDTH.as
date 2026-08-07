//----------------------------------------------------------------------------------
//
// LARGEUR TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLAYWIDTH extends CExp 
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhFrame.leWidth);	
		}    
	}
}