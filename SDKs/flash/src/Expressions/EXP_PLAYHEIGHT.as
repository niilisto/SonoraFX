//----------------------------------------------------------------------------------
//
// HAUTEUR TERRAIN
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_PLAYHEIGHT extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.getCurrentResult().forceInt(rhPtr.rhFrame.leHeight);
		}    
	}
}