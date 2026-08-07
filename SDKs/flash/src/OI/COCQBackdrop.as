//----------------------------------------------------------------------------------
//
// CCOCQBackdrop : objet quick backdrop
//
//----------------------------------------------------------------------------------

package OI
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class COCQBackdrop extends COC
	{
    	public static var LINEF_INVX:int=0x0001;
    	public static var LINEF_INVY:int=0x0002;

    	public var ocBorderSize:int;			// Border
    	public var ocBorderColor:int;
    	public var ocShape:int;			// Shape
    	public var ocFillType:int;
    	public var ocLineFlags:int;			// Only for lines in non filled mode
    	public var ocColor1:int;			// Gradient
    	public var ocColor2:int;
    	public var ocGradientFlags:int;
    	public var ocImage:int;				// Image
		
		public function COCQBackdrop()
		{
		}

	    public override function load(file:CFile, type:int):void
	    {
			file.skipBytes(4);		// ocDWSize
			ocObstacleType=file.readAShort();
			ocColMode=file.readAShort();
			ocCx=file.readAInt();
			ocCy=file.readAInt();
			ocBorderSize=file.readAShort();
			ocBorderColor=file.readAColor();
			ocShape=file.readAShort();
			
			ocFillType=file.readAShort();
			if (ocShape==1)		// SHAPE_LINE
			{
			    ocLineFlags=file.readAShort();
			}
			else
			{
			    switch (ocFillType)
			    {
				case 1:			    // FILLTYPE_SOLID
				    ocColor1=file.readAColor();
				    break;
				case 2:			    // FILLTYPE_GRADIENT
				    ocColor1=file.readAColor();
				    ocColor2=file.readAColor();
				    ocGradientFlags=file.readAInt();
				    break;
				case 3:			    // FILLTYPE_IMAGE
				    ocImage=file.readAShort();
				    break;
			    }
			}
	    }
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
    	{
			if (ocFillType==3)		    // FILLTYPE_IMAGE
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
}