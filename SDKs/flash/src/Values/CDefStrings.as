//----------------------------------------------------------------------------------
//
// CDEFSTRINGS : definition des alterable strings
//
//----------------------------------------------------------------------------------

package Values
{
	import Services.CFile;
	
	public class CDefStrings
	{
    	public var nStrings:int;
    	public var strings:Array;

		public function CDefStrings()
		{
		}
	    public function load(file:CFile):void
	    {
	        nStrings=file.readAShort();
	        strings=new Array(nStrings);
	        var n:int;
	        for (n=0; n<nStrings; n++)
	        {
	            strings[n]=file.readAString();
	        }
	    }
	}
}