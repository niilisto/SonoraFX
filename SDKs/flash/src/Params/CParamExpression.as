//----------------------------------------------------------------------------------
//
// CParamExpression, classe de base d'une expression
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	import Expressions.*;
	
	import Services.*;
	
	public class CParamExpression extends CParam
	{		
    	public var tokens:Array;
    	public var comparaison:int;
    
		public function CParamExpression()
		{
		}
		public function loadExpression(app:CRunApp, file:CFile):void
		{
	      	var debut:int = file.getFilePointer();
	
	        // Compte le nombre de tokens
	        var count:int = 0;
	        var size:int;
	        var code:int;
	        while (true)
	        {
	            count++;
	            code = file.readAInt();
	            if (code == 0)
	            {
	                break;
	            }
	            size = file.readAShort();
	            if (size > 6)
	            {
	                file.skipBytes(size - 6);
	            }
	        }
	
	        // Charge les tokens
	        file.seek(debut);
	        tokens = new Array(count);
	        var n:int;
	        for (n = 0; n < count; n++)
	        {
	            tokens[n] = CExp.create(file);
	        }
		}
	    public override function load(app:CRunApp):void    
	    {
	    	
	    }		
	}
}