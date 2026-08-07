//----------------------------------------------------------------------------------
//
// IDENTIFIER
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;

	public class EXP_EXTIDENTIFIER extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			var id:int=(pHo.hoCreationId<<16)|((int(pHo.hoNumber))&0xFFFF);
			rhPtr.getCurrentResult().forceInt(id);
		}    
	}
}