//----------------------------------------------------------------------------------
//
// STRING BY INDEX
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;
	import Values.*;

	public class EXP_EXTVARSTRINGBYINDEX extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;
			var number:int=rhPtr.get_ExpressionInt();
			if (pHo!=null && pHo.rov!=null)
			{
				if (number>=0 && number<CRVal.STRINGS_NUMBEROF_ALTERABLE)
				{
					rhPtr.getCurrentResult().forceString(pHo.rov.getString(number));
					return;
				}
			}
			rhPtr.getCurrentResult().forceString("");
		}
	}
}