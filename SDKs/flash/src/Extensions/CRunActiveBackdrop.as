//----------------------------------------------------------------------------------
//
// CRUNACTIVEBACKDROP
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import Objects.*;
	
	import Params.CPositionInfo;
	import Params.PARAM_POSITION;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	
	public class CRunActiveBackdrop extends CRunExtension
	{
		public static var FLAG_VISIBLE:int=0x00000001;

		public var bitmap:Bitmap;		
		public var nImages:int;
		public var imageList:Array;
		public var flags:int;
		public var currentImage:int;
		public var pLayer:CLayer;

		public function CRunActiveBackdrop()
		{
		}

		public override function getNumberOfConditions():int
		{
			return 1;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			ho.hoImgWidth = file.readInt();
			ho.hoImgHeight = file.readInt();
			nImages=file.readShort();
			flags=file.readInt();
			imageList=new Array(nImages);
			var n:int;
			for (n=0; n<nImages; n++)
			{
				imageList[n]=file.readShort();
			}
			if (nImages>0)
			{
				ho.loadImageList(imageList);
				currentImage=0;
			}
			else
			{
				currentImage=-1;
			}
			bitmap=new Bitmap();
			pLayer=ho.hoAdRunHeader.rhFrame.layers[0];
			bitmap.x=ho.hoX-ho.hoAdRunHeader.rhWindowX+pLayer.x;
			bitmap.y=ho.hoY-ho.hoAdRunHeader.rhWindowY+pLayer.y;
			if (currentImage>=0)
			{
				var image:CImage=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(imageList[currentImage]);
				bitmap.bitmapData=image.img;
			}
			if ((flags&FLAG_VISIBLE)==0)
			{
				bitmap.visible=false;
			}
			pLayer.planeBack.addChild(bitmap);
			getZoneInfos();
			return false;
		}		
		public override function destroyRunObject(bFast:Boolean):void
		{
			pLayer.planeBack.removeChild(bitmap);
		}

		public override function getZoneInfos():void
		{
			if (currentImage>=0)
			{
				var image:CImage=ho.getImage(imageList[currentImage]);
				ho.hoImgWidth=image.width;
				ho.hoImgHeight=image.height;
			}
			else
			{
				ho.hoImgWidth=1;
				ho.hoImgHeight=1;
			}
		}
		
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			switch (num)
			{
				case 0:
					return (flags&FLAG_VISIBLE)!=0;
			}
			return false;
		}
		
		public override function action(num:int, act:CActExtension):void
		{   
			switch (num)
			{        
				case 0:
					actSetImage(act);
					break;
				case 1:
					actSetX(act);
					break;
				case 2:
					actSetY(act);
					break;
				case 3:
					actShow(act);
					break;
				case 4:
					actHide(act);
					break;
			}
		}
		
		public function actSetImage(act:CActExtension):void
		{
			var image:int=act.getParamExpression(rh, 0);
			if (image>=0 && image<nImages)
			{
				currentImage=image;
				var cimage:CImage=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(imageList[currentImage]);
				bitmap.bitmapData=cimage.img;
				getZoneInfos();
			}			
		}
		public function actSetX(act:CActExtension):void
		{
			ho.hoX=act.getParamExpression(rh, 0);
			bitmap.x=ho.hoX-ho.hoAdRunHeader.rhWindowX+pLayer.x;
		}
		public function actSetY(act:CActExtension):void
		{
			ho.hoY=act.getParamExpression(rh, 0);
			bitmap.y=ho.hoY-ho.hoAdRunHeader.rhWindowX+pLayer.y;
		}
		public function actHide(act:CActExtension):void
		{
			flags&=~FLAG_VISIBLE;
			bitmap.visible=false;
		}
		public function actShow(act:CActExtension):void
		{
			flags|=FLAG_VISIBLE;
			bitmap.visible=true;
		}

		public override function expression(num:int):CValue
		{
			switch (num)
			{
				case 0:
					return new CValue(currentImage);
				case 1:
					return new CValue(ho.hoX);
				case 2:
					return new CValue(ho.hoY);
			}
			return new CValue(0);//won't be used
		}
	}
}