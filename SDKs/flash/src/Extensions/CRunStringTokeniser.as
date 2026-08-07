//----------------------------------------------------------------------------------
//
// CRunparser 
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Services.*;
	
	public class CRunStringTokeniser
	{
	    public var tokens:CArrayList;
   	 	public var numToken:int;
		
	    public function CRunStringTokeniser(text:String, delimiter:String)
	    {
	        tokens=new CArrayList();
	
	        var oldPos:int=0;
	        var pos:int=text.indexOf(delimiter);
	        while(pos>=0)
	        {
	            if (pos>oldPos)
	            {
	                tokens.add(text.substring(oldPos, pos));
	            }
	            oldPos=pos+delimiter.length;
	            pos=text.indexOf(delimiter, oldPos);
	        }
	        if (text.length>oldPos)
	        {
	        	tokens.add(text.substring(oldPos, text.length));
	        }
	        numToken=0;
	    }
	    public function countTokens():int
	    {
	        return tokens.size();
	    }
	    public function nextToken():String
	    {
	        if (numToken<tokens.size())
	        {
	        	var s:String=String(tokens.get(numToken++));
	        	if (s==null)
	        	{
	        		return "";
	        	}
	            return s;
	        }
	        return "";
	    }

	}
}