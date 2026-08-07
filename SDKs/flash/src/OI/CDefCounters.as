//----------------------------------------------------------------------------------
//
// CDEFCOUNTERS : Données d'un objet score / vies / counter
//
//----------------------------------------------------------------------------------

package OI
{
	import Banks.IEnum;
	
	import Services.CFile;
	
	public class CDefCounters
	{
    	// Display types
    	public static var CTA_HIDDEN:int=0;
    	public static var CTA_DIGITS:int=1;
    	public static var CTA_VBAR:int=2;
    	public static var CTA_HBAR:int=3;
    	public static var CTA_ANIM:int=4;
    	public static var CTA_TEXT:int=5;    
    	public static var BARFLAG_INVERSE:int=0x0100;
		    
    	public var odCx:int;					// Size: only lives & counters
    	public var odCy:int;
    	public var odPlayer:int;				// Player: only score & lives
    	public var odDisplayType:int;			// CTA_xxx
    	public var odDisplayFlags:int;			// BARFLAG_INVERSE
    	public var odFont:int;					// Font
    	public var ocBorderSize:int;			// Border
    	public var ocBorderColor:int;
    	public var ocShape:int;			// Shape
    	public var ocFillType:int;
    	public var ocLineFlags:int;			// Only for lines in non filled mode
    	public var ocColor1:int;			// Gradient
    	public var ocColor2:int;
    	public var ocGradientFlags:int;
    	public var nFrames:int;
    	public var frames:Array;

		public function CDefCounters()
		{
		}

	    public function load(file:CFile):void
	    {
	        file.skipBytes(4);          // size
	        odCx=file.readAInt();
	        odCy=file.readAInt();
	        odPlayer=file.readAShort();
	        odDisplayType=file.readAShort();
	        odDisplayFlags=file.readAShort();
	        odFont=file.readAShort();
        
	        switch (odDisplayType)
	        {
	            case 0:             // CTA_HIDDEN
	                break;
	            case 1:             // CTA_DIGITS
	            case 4:             // CTA_ANIM
	                nFrames=file.readAShort();
	                frames=new Array(nFrames);
	                var n:int;
	                for (n=0; n<nFrames; n++)
	                {
	                    frames[n]=file.readAShort();
	                }
	                break;
	            case 2:             // CTA_VBAR
	            case 3:             // CTA_HBAR
	            case 5:             // CTA_TEXT
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
	                            break;
	                    }
	                }
	                break;
	        }
    	}
	    public function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
			var num:int;
			switch(odDisplayType)
			{
		     	case 1:             // CTA_DIGITS
		        case 4:             // CTA_ANIM
					var n:int;
					for (n=0; n<nFrames; n++)
					{
				    	if (enumImages!=null)
				    	{
							num=enumImages.enumerate(frames[n]); 
							if (num!=-1)
							{
					    		frames[n]=num;
							}
				    	}
					}
					break;
		        case 5:             // CTA_TEXT
					if (enumFonts!=null)
					{
				    	num=enumFonts.enumerate(odFont);
				    	if (num!=-1)
				    	{
							odFont=num;
				    	}
					}
					break;
			}
	    }

	}
}