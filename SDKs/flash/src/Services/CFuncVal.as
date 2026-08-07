//----------------------------------------------------------------------------------
//
// CFUNCVAL petite classe pour parser une chaine
//
//----------------------------------------------------------------------------------
package Services 
{
	public class CFuncVal 
	{
		public var intValue:int;
		public var doubleValue:Number;
	
		public function parse(s:String):int   
		{
		    var ss:String;
		    if (s.length>=3)
			{
				if (s.charAt(0)=='0' && (s.charAt(1)=='x' || s.charAt(2)=='X'))
				{
					ss=s.substr(2,s.length-2);		
					intValue=parseInt(ss, 16);
					return 0;
				}
				if (s.charAt(0)=='0' && (s.charAt(1)=='b' || s.charAt(2)=='B'))
				{
					ss=s.substr(2,s.length-2);
					intValue=parseInt(ss, 2);
					return 0;
				}		
			}
			
		    var d:Number=Number(s);
		    var test:String=d.toString();
		  	if (test=="NaN")
		  	{
		  		intValue=0;
		  		return 0;
		  	}
	    	var frac:Number=Math.round(d);
	    	intValue=int(d);
	    	doubleValue=d;
	    	if (d-frac!=0 || s.indexOf(".")>=0)
			{
				doubleValue=d;
				return 1;
			}
		    return 0;
    	}		
	}
	
}