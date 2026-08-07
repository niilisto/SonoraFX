//----------------------------------------------------------------------------------
//
// FLAG
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Objects.*;

	public class EXP_EXTFLAG extends CExpOi
	{
		public override function evaluate(rhPtr:CRun):void
		{        
	 		var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
			rhPtr.rh4CurToken++;							// Saute le token
			var num:int=rhPtr.get_ExpressionInt();			// Le numero du flag
			if (pHo==null)
			{
				rhPtr.getCurrentResult().forceInt(0);
				return;
			}
			num&=31;
			if (pHo.rov!=null)
			{
				var result:int=0;
				if (((1<<num)&pHo.rov.rvValueFlags)!=0)
				{
					result=1;
				}
				rhPtr.getCurrentResult().forceInt(result);
			}
			else
			{
				rhPtr.getCurrentResult().forceInt(0);
			}
		}
	    
	}
}