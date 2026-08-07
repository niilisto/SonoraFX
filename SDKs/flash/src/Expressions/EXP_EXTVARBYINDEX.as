//----------------------------------------------------------------------------------
//
// VAR BY INDEX
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;
	import Values.*;

	public class EXP_EXTVARBYINDEX extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;
			var number:int=rhPtr.get_ExpressionInt();
			if (pHo!=null && pHo.rov!=null)
			{
				if (number>=0 && number<CRVal.VALUES_NUMBEROF_ALTERABLE)
				{
					rhPtr.getCurrentResult().forceValue(pHo.rov.getValue(number));
					return;
				}
			}
			rhPtr.getCurrentResult().forceInt(0);
		}
	}
}