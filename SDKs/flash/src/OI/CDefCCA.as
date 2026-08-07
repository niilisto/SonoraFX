//----------------------------------------------------------------------------------
//
// CDEFCCA : definitions objet CCA
//
//----------------------------------------------------------------------------------

package OI
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class CDefCCA extends CDefObject
	{

    	public var odCx:int;						// Size (ignored)
    	public var odCy:int;
    	public var odVersion:int;					// 0
    	public var odNStartFrame:int;
    	public var odOptions:int;					// Options
    	public var odName:String;

		public function CDefCCA()
		{
		}
	    public override function load(file:CFile):void 
	    {
	        file.skipBytes(4);
	        odCx=file.readAInt();
	        odCy=file.readAInt();
	        odVersion=file.readAShort();
	        odNStartFrame=file.readAShort();
	        odOptions=file.readAInt();
	        file.skipBytes(4+4);                  // odFree+pad bytes
	        odName=file.readAString();
	    }
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
	    }	
	}
}