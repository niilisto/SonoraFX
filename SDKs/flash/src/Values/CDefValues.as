//----------------------------------------------------------------------------------
//
// CDEFVALUES : Alterable values par defaut
//
//----------------------------------------------------------------------------------
package Values
{
	import Services.CFile;
	
	public class CDefValues
	{
    	public var nValues:int;
    	public var values:Array;

		public function CDefValues()
		{
		}
	    public function load(file:CFile):void
	    {
	        nValues=file.readAShort();
	        values=new Array(nValues);
	        var n:int;
	        for (n=0; n<nValues; n++)
	        {
	            values[n]=file.readAInt();
	        }
	    }
	}
}