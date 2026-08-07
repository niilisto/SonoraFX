//----------------------------------------------------------------------------------
//
// CSERVICES : Routines utiles diverses
//
//----------------------------------------------------------------------------------

package Services
{
	import Application.CRunApp;
	
	import flash.display.BitmapData;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;
	import flash.utils.ByteArray;
	
	public class CServices
	{
	    public static var DT_LEFT:int=0x0000;
	    public static var DT_TOP:int=0x0000;
	    public static var DT_CENTER:int=0x0001;
	    public static var DT_RIGHT:int=0x0002;
	    public static var DT_BOTTOM:int=0x0008;
	    public static var DT_VCENTER:int=0x0004;
	    public static var DT_SINGLELINE:int=0x0020;
	    public static var DT_VALIGN:int=0x0800;
    	public static var CPTDISPFLAG_INTNDIGITS:int=0x000F;		
    	public static var CPTDISPFLAG_FLOATNDIGITS:int=0x00F0;		
		public static var CPTDISPFLAG_FLOATNDIGITS_SHIFT:int=4;
    	public static var CPTDISPFLAG_FLOATNDECIMALS:int=0xF000;	
    	public static var CPTDISPFLAG_FLOATNDECIMALS_SHIFT:int=12;
    	public static var CPTDISPFLAG_FLOAT_FORMAT:int=0x0200;		
    	public static var CPTDISPFLAG_FLOAT_USENDECIMALS:int=0x0400;
    	public static var CPTDISPFLAG_FLOAT_PADD:int=0x0800;		
	
		public function CServices()
		{
		}
		
		//public static function filterAccelerometer(e:AccelerometerEvent, direct:Array, filtered:Array, instant:Array, nominalG:Number):void {
			// Information extracted from http://docs.nvidia.com/tegra/data/How_To_Use_the_Android_Accelerometer.html
			// For Now, this should be implemented for Adobe AIR in a runtime specific for devices
			/*
			switch (getActualOrientation())
			{
				case StageOrientation.ROTATION_0:
					direct[0] = -(e.values[0] / nominalG);
					direct[1] =  (e.values[1] / nominalG);
					direct[2] = e.values[2] / nominalG;
					//Log.v("Accel", " Rotation 0 ");
					break;
				case StageOrientation.ROTATION_180:
					direct[0] =  (e.values[0] / nominalG);
					direct[1] = -(e.values[1] / nominalG);
					direct[2] = e.values[2] / nominalG;
					//Log.v("Accel", " Rotation 180 ");
					break;
				case StageOrientation.ROTATION_90:       
					direct[0] =  (e.values[1] / nominalG);
					direct[1] =  (e.values[0] / nominalG);
					direct[2] = e.values[2] / nominalG;
					//Log.v("Accel", " Rotation 90 ");
					break;
				case StageOrientation.ROTATION_270:
					direct[0] = -(e.values[1] / nominalG);
					direct[1] = -(e.values[0] / nominalG);
					direct[2] = e.values[2] / nominalG;
					//Log.v("Accel", " Rotation 270 ");
					break;
			}
			
			direct[0] = (e.accelerationX / nominalG);
			direct[1] = (e.accelerationY / nominalG);
			direct[2] = (e.accelerationZ / nominalG);
			
			var filteringFactor:Number = 0.1;
			
			filtered[0] = ((direct[0] * filteringFactor) + (filtered[0] * (1.0 - filteringFactor)));
			filtered[1] = ((direct[1] * filteringFactor) + (filtered[1] * (1.0 - filteringFactor)));
			filtered[2] = ((direct[2] * filteringFactor) + (filtered[2] * (1.0 - filteringFactor)));
			
			instant[0] = direct[0] - ((direct[0] * filteringFactor) + (instant[0] * (1.0 - filteringFactor)));
			instant[1] = direct[1] - ((direct[1] * filteringFactor) + (instant[1] * (1.0 - filteringFactor)));
			instant[2] = direct[2] - ((direct[2] * filteringFactor) + (instant[2] * (1.0 - filteringFactor)));
			
		}
		*/
	    public static function HIWORD(ul:int):int
	    {
			return ul>>16;
	    }
	    public static function LOWORD(ul:int):int
	    {
			return ul&0x0000FFFF;
	    }
	    public static function MAKELONG(lo:int, hi:int):int
	    {
			return (hi<<16)|(lo&0xFFFF);
	    }
	    public static function getRValueFlash(rgb:int):int
	    {
			return (rgb>>>16)&0xFF;
	    }
	    public static function getGValueFlash(rgb:int):int
	    {
			return (rgb>>>8)&0xFF;
	    }
	    public static function getBValueFlash(rgb:int):int
	    {
			return rgb&0xFF;
	    }
	    public static function RGBFlash(r:int, g:int, b:int):int
	    {
			return (r&0xFF)<<16|(g&0xFF)<<8|(b&0xFF);
	    }
	    public static function swapRGB(rgb:int):int
	    {
			var r:int=(rgb>>>16)&0xFF;
			var g:int=(rgb>>>8)&0xFF;
			var b:int=rgb&0xFF;
			return (b&0xFF)<<16|(g&0xFF)<<8|(r&0xFF);
	    }	    
		public static function clamp(val:int, a:int, b:int):int
		{
			return Math.min(Math.max(val, a), b);
		}
	    public static function tildBoolean(b:Boolean):Boolean
	    {
	        if (b)
	            return false;
	        else
	            return true;
	    }
		public static function compareStringsIgnoreCase(s1:String, s2:String):Boolean
		{
			if (s1.length==s2.length)
			{
				var ss1:String=s1.toLowerCase();
				var ss2:String=s2.toLowerCase();
				return Boolean(ss1 == ss2);
			}
			return false;
		} 
/*
		// Routine that rotates a rectangle
		public static function rotateRect(width:Number, height:Number, point:CPoint, fAngle:Number):void
		{
			var angle:Number=(fAngle*Math.PI)/180;
			
			if (fAngle<90)
			{
				point.x=0;
				point.y=Math.round(width*Math.sin(angle));
			}
			else if (fAngle<180)
			{
				point.x=Math.round(width*Math.sin(angle-Math.PI/2));
				point.y=Math.round(width*Math.sin(angle)+height*Math.sin(angle-Math.PI/2));
			}
			else if (fAngle<270)
			{
				point.x=Math.round(width*Math.sin(angle-Math.PI/2)+height*Math.sin(angle-Math.PI));
				point.y=Math.round(height*Math.sin(angle-Math.PI/2));
			}
			else 
			{
				point.x=Math.round(height*Math.sin(angle-Math.PI));
				point.y=0;
			}
		}
*/		
		public static function intToString(value:int, displayFlags:int):String
		{
			var s:String=value.toString();
			if ((displayFlags&CPTDISPFLAG_INTNDIGITS)!=0)
			{
				var nDigits:int=displayFlags&CPTDISPFLAG_INTNDIGITS;
				if (s.length>nDigits)
				{
					s=s.substring(s.length-nDigits);
				}
				else 
				{
					while(s.length<nDigits)
					{
						s="0"+s;
					}
				}					
			}
			return s;							
		}
		public static function doubleToString(value:Number, displayFlags:int):String
		{
			var s:String;
			if ( (displayFlags & CPTDISPFLAG_FLOAT_FORMAT) == 0 )
			{
				s=value.toString();	
			}
			else
			{
				var fmt:NumberFormatter = new NumberFormatter("en-US");
				var nDigits:int = ((displayFlags & CPTDISPFLAG_FLOATNDIGITS) >> CPTDISPFLAG_FLOATNDIGITS_SHIFT) + 1;
				var nDecimals:int = -1;
				
				fmt.trailingZeros = true;
				fmt.leadingZero = true;
				fmt.negativeNumberFormat = 1;
				
				if ( (displayFlags & CPTDISPFLAG_FLOAT_USENDECIMALS) != 0 )
					nDecimals = ((displayFlags & CPTDISPFLAG_FLOATNDECIMALS) >> CPTDISPFLAG_FLOATNDECIMALS_SHIFT);
				if (nDecimals>=0)
				{
					fmt.fractionalDigits = nDecimals;
				}
				
				s = fmt.formatNumber(value);
				
				if (nDigits>0)
				{
					var nIntegerDigits:int = nDigits;
					var i:int;
					var ss:String = "";
					var nLimit:int = 0;
					for (i = s.length ; i > 0; i--) {
						if((s.charCodeAt(i-1) > 47 && s.charCodeAt(i-1) < 58)) {
							if(nLimit < nDigits) {
								ss = s.charAt(i-1) + ss;
								nLimit++;
							}
						}
						else
							ss = s.charAt(i-1) + ss;							
					}
					s = ss;	
					if ((displayFlags & CPTDISPFLAG_FLOAT_PADD)!=0) {
						ss="";
						var nIdx:int=0;
						if(s.charAt(0) == "-") {
							ss = ss + "-";
							nIdx = 1;
						}
						for (i = 0 ; i < nDigits-nLimit; i++) {
							ss = ss + "0";
						}
						ss = ss + s.slice(nIdx, s.length);
						s = ss;
					}

				}
			}
			return s;
		}
		
		public static function replaceColor(app:CRunApp, oldImage:BitmapData, oldColor:int, newColor:int):BitmapData
		{			
			var r:Rectangle=new Rectangle(0, 0, oldImage.width, oldImage.height);
//			var newImage:BitmapData=new BitmapData(oldImage.width, oldImage.height, true, 0);
//			newImage.threshold(oldImage, r, new Point(0, 0), "==", oldColor, newColor|0xFF000000, 0xffffff, true);
//			return newImage;
			
			var oldPixels:ByteArray=oldImage.getPixels(r);
			oldPixels.position=0;			
			var x:int, y:int;
			var p:int;
			var newPixels:ByteArray=new ByteArray();
			for (x=0; x<oldImage.width; x++)
			{
				for (y=0; y<oldImage.height; y++)
				{
					p=oldPixels.readUnsignedInt();
					if ((p&0xFFFFFF)==oldColor)
					{
						p=(p&0xFF000000)|newColor;
					}
					newPixels.writeUnsignedInt(p);
				}
			}
			var newImage:BitmapData=new BitmapData(oldImage.width, oldImage.height, true, 0);
			newPixels.position=0;
			p=newPixels.readUnsignedInt();
			newPixels.position=0;
			newImage.setPixels(r, newPixels);
			return newImage;
		
		}
		public static function charArrayToString(c:Array):String
		{
			/*
			var ret:String=new String();
			
			var n:int=0;
			if (c.length>8)
			{
				for (; n<c.length-8; n+=8)
				{
					ret+=String.fromCharCode(c[n], c[n+1], c[n+2], c[n+3], c[n+4], c[n+5], c[n+6], c[n+7]);
				}
			}
			for (; n<c.length; n++)
			{
				ret+=String.fromCharCode(c[n]);				
			}
			*/
			var ret:String = "";
			var length:int = c.length;
			for(var i:int = 0; i < length; i++) 
			{
				ret += String.fromCharCode(c[i]);
			}
			return ret;			
		}
		public static function getData(pData:Array, bXOR:int):String
		{
			var l:int=pData.length;
			var pDest:ByteArray=new ByteArray();
			var i:int, c:int;
			for (i=0; i<l; i++)
			{			
				bXOR = (((bXOR & 1) != 0) ? 0x80 : 0) + (bXOR >> 1);
				c = (pData[i] ^ bXOR);
				pDest.writeByte(c);
			}
			var ret:String=pDest.toString();
			return ret;
		}
		
	}
}