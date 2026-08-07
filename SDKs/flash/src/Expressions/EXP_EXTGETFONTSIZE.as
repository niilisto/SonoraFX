//----------------------------------------------------------------------------------
//
// GET FONT SIZE
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.CFontInfo;

	public class EXP_EXTGETFONTSIZE extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var info:CFontInfo=CRun.getObjectFont(pHo);
			rhPtr.getCurrentResult().forceInt(info.lfHeight);
		}    
	}
}