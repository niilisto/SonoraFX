//----------------------------------------------------------------------------------
//
// CANIMDIR : Une direction d'animation
//
//----------------------------------------------------------------------------------

package Animations
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class CAnimDir
	{
	    public var adMinSpeed:int;					// Minimum speed
	    public var adMaxSpeed:int;					// Maximum speed
	    public var adRepeat:int;					// Number of loops
	    public var adRepeatFrame:int;				// Where to loop
	    public var adNumberOfFrame:int;			// Number of frames
	    public var adFrames:Array;

		public function CAnimDir()
		{
		}

	    public function load(file:CFile):void
	    {
	        adMinSpeed=file.readAByte();
	        adMaxSpeed=file.readAByte();
	        adRepeat=file.readAShort();
	        adRepeatFrame=file.readAShort();
	        adNumberOfFrame=file.readAShort();
	    
	        adFrames=new Array(adNumberOfFrame);
	        var n:int;
	        for (n=0; n<adNumberOfFrame; n++)
	        {
	            adFrames[n]=file.readAShort();
	        }
	    }

	    public function enumElements(enumImages:IEnum):void
	    {
	        var n:int;
	        for (n=0; n<adNumberOfFrame; n++)
	        {
			    if (enumImages!=null)
			    {
					var num:int=enumImages.enumerate(adFrames[n]);
					if (num!=-1)
					{
					    adFrames[n]=num;
					}
			    }
	        }
	    }
	}
}