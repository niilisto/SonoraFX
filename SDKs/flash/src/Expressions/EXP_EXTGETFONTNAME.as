//----------------------------------------------------------------------------------
//
// GET FONT NAME
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;

	public class EXP_EXTGETFONTNAME extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceString("");
				return;
			}
			var info:CFontInfo=CRun.getObjectFont(pHo);
			rhPtr.getCurrentResult().forceString(info.lfFaceName);
		}    
	}
}