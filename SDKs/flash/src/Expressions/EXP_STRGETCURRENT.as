//----------------------------------------------------------------------------------
//
// CHAINE COURANTE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_STRGETCURRENT extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceString("");
				return;
			}
			var pText:CText=CText(pHo);
			if (pText.rsTextBuffer!=null)
				rhPtr.getCurrentResult().forceString(pText.rsTextBuffer);
			else
				rhPtr.getCurrentResult().forceString("");
		}
	    
	}
}