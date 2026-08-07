//----------------------------------------------------------------------------------
//
// CHAINE NUMERO N
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;

	public class EXP_STRGETNUMBER extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceString("");
				return;
			}
			var num:int=rhPtr.get_ExpressionInt();		// Demande le numero du texte
	
			var pText:CText=CText(pHo);
			
			// Le texte courant
			if (num<0)
			{
				if (pText.rsTextBuffer!=null)
					rhPtr.getCurrentResult().forceString(pText.rsTextBuffer);
				else
					rhPtr.getCurrentResult().forceString("");
				return;
			}
	
			// Un texte stocke
			if (num>=pText.rsMaxi) 
				num=pText.rsMaxi-1;
			var txt:CDefTexts=CDefTexts(pHo.hoCommon.ocObject);
			rhPtr.getCurrentResult().forceString(txt.otTexts[num].tsText);
		}    
	}
}