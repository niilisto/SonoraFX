//----------------------------------------------------------------------------------
//
// MASQUE DE COLLISIONS
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;
	import Sprites.*;
	import Application.*;
	
	public class EXP_GETCOLLISIONMASK extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{        
			var x:int, y:int;
	
			rhPtr.rh4CurToken++;
			x=rhPtr.get_ExpressionInt();
			rhPtr.rh4CurToken++;
			y=rhPtr.get_ExpressionInt();
	
			var result:int=0;
			if ( rhPtr.y_GetLadderAt(-1, x, y) != null )
				result=2;
			else
			{
				if ( rhPtr.colMask_Test_XY(x, y, -1, CRunFrame.CM_TEST_OBSTACLE) )
					result=1;
			}
			rhPtr.getCurrentResult().forceInt(result);
		}
	    
	}
}