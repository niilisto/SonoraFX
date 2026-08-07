//----------------------------------------------------------------------------------
//
// VALEUR NUMERIQUE DE LA CHAINE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class EXP_STRGETNUMERIC extends CExpOi
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
			if (pText.rsTextBuffer!=null)
			{
				var val:CFuncVal=new CFuncVal();
				switch(val.parse(pText.rsTextBuffer))
				{
					case 0:
						rhPtr.getCurrentResult().forceInt(val.intValue);
						return;
					case 1:
						rhPtr.getCurrentResult().forceDouble(val.doubleValue);
						return;
				}
			}
			rhPtr.getCurrentResult().forceInt(0);
		}    
	}
}