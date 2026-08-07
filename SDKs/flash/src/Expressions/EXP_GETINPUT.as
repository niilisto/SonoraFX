//----------------------------------------------------------------------------------
//
// INPUT
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Application.*;

	public class EXP_GETINPUT extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var joueur:int=oi;
			var r:int=CRunApp.CTRLTYPE_KEYBOARD;
			if ( joueur<CRunApp.MAX_PLAYER )
				r = rhPtr.rhApp.getCtrlType()[joueur];
			if (r == CRunApp.CTRLTYPE_KEYBOARD)
				r = CRunApp.CTRLTYPE_MOUSE;
			rhPtr.getCurrentResult().forceInt(r);
		}    
	}
}