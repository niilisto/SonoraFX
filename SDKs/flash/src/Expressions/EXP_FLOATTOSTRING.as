//----------------------------------------------------------------------------------
//
// FLOAT TO STRING
//
//----------------------------------------------------------------------------------
package Expressions
{
	import Expressions.*;
	
	import RunLoop.*;

	public class EXP_FLOATTOSTRING extends CExp
	{
		public override function evaluate(rhPtr:CRun):void
		{ 
			rhPtr.rh4CurToken++;
			var value:Number=rhPtr.get_ExpressionDouble();
	        
			rhPtr.rh4CurToken++;
			var nDigits:int=rhPtr.get_ExpressionInt();
			if (nDigits<1)
			{
				nDigits=1;
			}
		
			rhPtr.rh4CurToken++;
			var nDecimals:int=rhPtr.get_ExpressionInt();
	        
			var temp:String=value.toString();
			var result:String=new String();
	        
			var point:int=temp.indexOf(".");
	        
			// Regarde si vraiment des chiffres apres la virgule
			var cpt:int;
			if (point>=0)
			{
				for (cpt=point+1; cpt<temp.length; cpt++)
				{
					if (temp.charAt(cpt)!="0")
					{
						break;
					}
				}
				if (cpt==temp.length)
				{
					point=-1;
				}
			}

			// Formattage
			var pos:int=0;
			if (point>=0)
			{
				// Le signe
				if (value<0.0)
				{
					result+="-";
					pos++;
				}

				// La partie entiere
				while(pos<point)
				{
					result+=temp.charAt(pos);
					pos++;
				}
	            
				if (nDecimals>0)
				{
					result+=".";
					pos++;
	            
					// La partie decimale
					for (cpt=0; cpt<nDecimals && cpt+pos<temp.length; cpt++)
					{
						result+=temp.charAt(pos+cpt);
					}
				}            
				else if (nDecimals<0)
				{
					result+=".";
					pos++;
					while(pos<temp.length)
					{
						result+=temp.charAt(pos);
						pos++;
					}
				}
			}
			else
			{
				while(pos<temp.length && temp.charAt(pos)!=".")
				{
					result+=temp.charAt(pos);
					pos++;
				}
				if (nDecimals>0)
				{
					result+=".";
					for (cpt=0; cpt<nDecimals; cpt++)
					{
						result+="0";
					}
				}
			}
			rhPtr.getCurrentResult().forceString(result);
		}    
	}
}