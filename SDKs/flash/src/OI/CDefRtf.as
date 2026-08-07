//----------------------------------------------------------------------------------
//
// CDEFRTF : definition objet RTF
//
//----------------------------------------------------------------------------------

package OI
{
	import Banks.IEnum;
	
	import Services.CFile;
	
	public class CDefRtf extends CDefObject
	{

    	public var odDWSize:int;
    	public var odVersion:int;				// 0
    	public var odOptions:int;				// Options
    	public var odBackColor:int;                             // Background color	
    	public var odCx:int;					// Size
    	public var odCy:int;
    	public var text:String;

		public function CDefRtf()
		{
		}
	    public override function load(file:CFile):void
	    {
	        odDWSize=file.readAInt();
	        odVersion=file.readAInt();
	        odOptions=file.readAInt();
	        odBackColor=file.readAColor();
	        odCx=file.readAInt();
	        odCy=file.readAInt();
	        
	        file.skipBytes(4);
	        var size:int=file.readAInt();
	        text=file.readAStringSize(size);
	    }
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
	    }	

	}
}