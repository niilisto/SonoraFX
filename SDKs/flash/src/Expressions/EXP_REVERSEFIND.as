//----------------------------------------------------------------------------------
//
// REVERSE FIND
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	import RunLoop.*;

	public class EXP_REVERSEFIND extends CExp
	{
	    
		public override function evaluate(rhPtr:CRun):void
		{        
			rhPtr.rh4CurToken++;
			var pMainString:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var pSubString:String=rhPtr.get_ExpressionString();
			rhPtr.rh4CurToken++;
			var firstChar:int=rhPtr.get_ExpressionInt();
	
			if (firstChar>pMainString.length)
			{
				firstChar=pMainString.length;
			}
	
			var oldPos:int;
			var pos:int=-1;
			while(true)
			{
				oldPos=pos;
				var pFound:int=pMainString.indexOf(pSubString, pos+1);
				if (pFound==-1) 
					break;
				pos=pFound;
				if (pos>firstChar)
					break;
			}
			rhPtr.getCurrentResult().forceInt(oldPos);
		}
	    
	}
}