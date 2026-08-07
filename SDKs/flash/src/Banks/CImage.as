//----------------------------------------------------------------------------------
//
// CIMAGE : une image
//
//----------------------------------------------------------------------------------
package Banks
{
	import Services.*;
	
	import Sprites.CMask;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.*;
	import flash.utils.*;
	
	public class CImage
	{
	    public var handle:int;
	    public var width:int;
	    public var height:int;
	    public var xSpot:int;
	    public var ySpot:int;
	    public var xAP:int;
	    public var yAP:int;
	    public var useCount:int;
	    public var img:BitmapData;    
	    public var maskNormal:CMask;
	    public var maskPlatform:CMask;
	    
	    public static var maxRotatedMasks:int=10;
		public var maskRotation:CArrayList;
		
		public function CImage()
		{
			maskRotation=null;
		}
	    public function loadHandle(file:CFile):void
	    {
			handle=file.readAShort();
			file.skipBytes(12);
	        var size:int=file.readAInt();
	        file.skipBytes(size);
	    }
	    public function load(file:CFile):void
	    {
			handle=file.readAShort();
	        width=file.readAShort();
	        height=file.readAShort();
			xSpot=file.readShort();
			ySpot=file.readShort();
			xAP=file.readShort();
			yAP=file.readShort();
	        
	        var size:int=file.readAInt();
	        var zip:ByteArray=file.readBuffer(size);
	        var l:int=zip.length;
	        zip.uncompress();
	        l=zip.length;	        
	        img=new BitmapData(width, height, true);
	        var rect:Rectangle=new Rectangle(0, 0, width, height);
	        img.setPixels(rect, zip);
	    }
	    
	    public function getMask(flags:int, angle:int, scaleX:Number, scaleY:Number):CMask
	    {
	        if ((flags & CMask.GCMF_PLATFORM) == 0)
	        {
        		if (maskNormal==null)
        		{
        			maskNormal=new CMask();
        			maskNormal.createMask(flags, this);
        		}
	        	if (angle==0 && scaleX==1.0 && scaleY==1.0)
	        	{
        			return maskNormal;
	        	}
	        	
	        	// Returns the rotated mask
	        	var rMask:CRotatedMask;
	        	if (maskRotation==null)
	        	{
	        		maskRotation=new CArrayList();
	        	}
	        	var n:int;
	        	var tick:int=0x7FFFFFFF;
	        	var nOldest:int=-1;
	        	for (n=0; n<maskRotation.size(); n++)
	        	{
	        		rMask=CRotatedMask(maskRotation.get(n));
	        		if (angle==rMask.angle && scaleX==rMask.scaleX && scaleY==rMask.scaleY)
	        		{
	        			return rMask.mask; 
	        		}
	        		if (rMask.tick<tick)
	        		{
	        			tick=rMask.tick;
	        			nOldest=n;
	        		}
	        	}
	        	if (maskRotation.size()<maxRotatedMasks)
	        	{
	        		nOldest=-1;
	        	}
        		rMask=new CRotatedMask();
				rMask.mask=new CMask();
				rMask.mask.createRotatedMask(maskNormal, angle, scaleX, scaleY);
	        	rMask.angle=angle;
	        	rMask.scaleX=scaleX;
	        	rMask.scaleY=scaleY;
	        	rMask.tick=getTimer();
	        	if (nOldest<0)
	        	{
	        		maskRotation.add(rMask);
	        	}
	        	else
	        	{
	        		maskRotation.set(nOldest, rMask);
	        	}
	        	return rMask.mask;
	        }
	        else
	        {
        		if (maskPlatform==null)
        		{
        			maskPlatform=new CMask();
        			maskPlatform.createMask(flags, this);
        		}
        		return maskPlatform;
	        }
		    return null;
	    }
	}
}