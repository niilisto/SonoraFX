//----------------------------------------------------------------------------------
//
// CDEFTEXT : un element de texte
//
//----------------------------------------------------------------------------------
package OI
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class CDefText
	{
    	public var tsFont:int;					// Font 
    	public var tsFlags:int;				// Flags
    	public var tsColor:int;				// Color
    	public var tsText:String;

    	public const TSF_LEFT:int=0x0000;
    	public const TSF_HCENTER:int=0x0001;
    	public const TSF_RIGHT:int=0x0002;
    	public const TSF_VCENTER:int=0x0004;
    	public const TSF_HALIGN:int=0x000F;
    	public static var TSF_CORRECT:int=0x0100;
    	public static var TSF_RELIEF:int=0x0200;

		public function CDefText()
		{
		}
	    public function load(file:CFile):void
	    {
	        tsFont=file.readShort();
	        tsFlags=file.readAShort();
	        tsColor=file.readAColor();
	        tsText=file.readAString();
	    }
	    public function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
			if (enumFonts!=null)
			{
			    var num:int=enumFonts.enumerate(tsFont);
			    if (num!=-1)
			    {
					tsFont=num;
			    }
			}
	    }    

	}
}