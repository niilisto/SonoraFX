//----------------------------------------------------------------------------------
//
// CRunparser 
//
//----------------------------------------------------------------------------------
package Extensions
{
	public class CRunparserElement
	{
	    public var text:String;
    	public var index:int;
    	public var endIndex:int;

		public function CRunparserElement(text:String, index:int)
		{
        	this.text = text;
        	this.index = index;
        	this.endIndex = index + this.text.length;
		}
	}
}