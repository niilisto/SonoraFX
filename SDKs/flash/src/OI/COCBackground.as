//----------------------------------------------------------------------------------
//
// COCBACKGROUND : un objet décor normal
//
//----------------------------------------------------------------------------------

package OI
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class COCBackground extends COC
	{
    	public var ocImage:int;			// Image
		
		public function COCBackground()
		{
		}

	    public override function load(file:CFile, type:int):void
	    {
			file.skipBytes(4);		// ocDWSize
			ocObstacleType=file.readAShort();
			ocColMode=file.readAShort();
			ocCx=file.readAInt();
			ocCy=file.readAInt();
			ocImage=file.readAShort();
	    }
    
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
			if (enumImages!=null)
			{
			    var num:int=enumImages.enumerate(ocImage);
			    if (num!=-1)
			    {
					ocImage=num;
			    }
			}
	    }
	}
}