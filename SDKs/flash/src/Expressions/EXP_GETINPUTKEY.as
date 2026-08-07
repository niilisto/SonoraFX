//----------------------------------------------------------------------------------
//
// INPUT KEY
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Application.*;

	public class EXP_GETINPUTKEY extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var joueur:int=oi;
	
			rhPtr.rh4CurToken++;
			var key:int=rhPtr.get_ExpressionInt();			// Numero de la touche
			if (key<CRunApp.MAX_KEY)
			{
				var s:String=CKeyConvert.getKeyText(rhPtr.rhApp.pcCtrlKeys[joueur*CRunApp.MAX_KEY+key]);
				rhPtr.getCurrentResult().forceString(s);
			}
			rhPtr.getCurrentResult().forceString("");
		}
	}
}