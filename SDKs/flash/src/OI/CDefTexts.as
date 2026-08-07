//----------------------------------------------------------------------------------
//
// CDEFTEXTS : liste de textes
//
//----------------------------------------------------------------------------------
package OI
{
	import Banks.IEnum;
	
	import Services.CFile;
	
	public class CDefTexts extends CDefObject
	{
    	public var otCx:int;
    	public var otCy:int;
    	public var otNumberOfText:int;
    	public var otTexts:Array;

		public function CDefTexts()
		{
		}

	    public override function load(file:CFile):void
	    {
	        var debut:int=file.getFilePointer();
	        file.skipBytes(4);          // Size
	        otCx=file.readAInt();
	        otCy=file.readAInt();
	        otNumberOfText=file.readAInt();
	        
	        otTexts=new Array(otNumberOfText);
	        var offsets:Array=new Array(otNumberOfText);
	        var n:int;
	        for (n=0; n<otNumberOfText; n++)
	        {
	            offsets[n]=file.readAInt();
	        }
	        for (n=0; n<otNumberOfText; n++)
	        {
	            otTexts[n]=new CDefText();
	            file.seek(debut+offsets[n]);
	            otTexts[n].load(file);
	        }
	    }
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {	
			var n:int;
			for (n=0; n<otNumberOfText; n++)
			{
			    otTexts[n].enumElements(enumImages, enumFonts);
			}
	    }

	}
}