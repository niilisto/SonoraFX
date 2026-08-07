//----------------------------------------------------------------------------------
//
// PARAGRAPHE NUMERO
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_STRGETNPARA extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var pText:CText=CText(pHo);
			rhPtr.getCurrentResult().forceInt(pText.rsMaxi);
		}
	    
	}
}