package Sprites
{
	import Banks.*;
	
	import Frame.*;
	
	import OI.*;
	
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	
	public class CSprites
	{
		public var bitmap:Bitmap;
		public var image:CImage;
		public var bShown:Boolean;
		//		public var scaleX:Number;
		//		public var scaleY:Number;
		//		public var angle:Number;
		public var nLayer:int;
		public var pLayer:CLayer;
		public var startFade:int;
		public var sprite:Sprite;
		public var ho:CObject;
		public var displayObject:DisplayObject;
		public var bHandCursor:Boolean;
		public var rcRotate:CRect=null;
		public var ptRotate:CPoint=null;
		public var oalpha:Number=1.0;
		
		public function CSprites(Ho:CObject)
		{
			ho = Ho;
			bHandCursor=false;
		}
		public function addSprite(x:int, y:int, i:int, layer:int, bShow:Boolean):void
		{
			nLayer=layer;
			pLayer=ho.hoAdRunHeader.rhFrame.layers[layer];
			
			bitmap=new Bitmap();
			displayObject=bitmap;
			image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(i);
			
			displayObject.x=x-image.xSpot+pLayer.x;
			displayObject.y=y-image.ySpot+pLayer.y;

			setEffect(ho.ros.rsEffect, ho.ros.rsEffectParam);
			
			this.bShown=bShow;
			displayObject.visible=this.bShown;
			bitmap.bitmapData=image.img;
			pLayer.planeSprites.addChild(bitmap);
			
			setHandCursor(bHandCursor);
		}
		public function setEffect(effect:int, effectParam:int):int
		{		
			var effectMasked:int=effect&CRSpr.BOP_MASK;
			
			oalpha=1.0;
			var r:int=255;
			var g:int=255;
			var b:int=255;
			if ((effect & CRSpr.BOP_RGBAFILTER) != 0)
			{
				r=((effectParam&0xFFFFFF)>>16)&0xFF;
				g=((effectParam&0xFFFFFF)>>8)&0xFF;
				b=(effectParam&0xFFFFFF)&0xFF;
				oalpha = (((effectParam >> 24) & 0xFF) / 255.0);
			}
			else if (effectMasked == CRSpr.BOP_BLEND)
			{
				oalpha = ((128 - effectParam) / 128.0);
			}
			if (displayObject==null)
				return oalpha;
			
			switch(effectMasked)
			{
				case CRSpr.BOP_ADD:
					displayObject.blendMode = "add";
					displayObject.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
				case CRSpr.BOP_SUB:
					displayObject.blendMode = "subtract";
					displayObject.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
				case CRSpr.BOP_INVERT:
					displayObject.blendMode = "normal";
					displayObject.transform.colorTransform = new ColorTransform(-r/255.0, -g/255.0, -b/255.0, 1, 255, 255, 255, 0);  
					break;
				default: 
					displayObject.blendMode = "normal";
					displayObject.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
			}
			displayObject.alpha=oalpha;
			return oalpha;
		}
		public function setHandCursor(bOn:Boolean):void
		{
			if (bOn)
			{
				if (bitmap!=null)
				{
					if (sprite==null)
					{
						var index:int=getChildIndex();
						if (index>=pLayer.planeSprites.numChildren)
						{
							index=pLayer.planeSprites.numChildren-1;
							if (index<0)
							{
								index=0;
							}
						}
						sprite=new Sprite();
						displayObject=sprite;
						sprite.x=bitmap.x;
						sprite.y=bitmap.y;
						sprite.alpha=bitmap.alpha;
						bitmap.alpha=1.0;
						sprite.visible=bitmap.visible;
						bitmap.visible=true;
						bitmap.x=0;
						bitmap.y=0;
						sprite.buttonMode=true;
						sprite.useHandCursor=true;
						pLayer.planeSprites.removeChild(bitmap);
						sprite.addChild(bitmap);
						pLayer.planeSprites.addChildAt(sprite, index);
						bHandCursor=true;
					}					
					else if (sprite!=null && bitmap!=null)
					{
						sprite.buttonMode=true;
						sprite.useHandCursor=true;
						bHandCursor=true;					
					}
				}
			}
			else
			{
				if (sprite!=null)
				{	
					sprite.buttonMode=false;
					sprite.useHandCursor=false;
					bHandCursor=false;
				}
			}			
		}
		public function modifSprite(x:int, y:int, i:int, xScale:Number, yScale:Number, rotAngle:int):void
		{
			if (bitmap!=null)
			{
				//var xx:int=x-ho.hoImgXSpot+pLayer.x;
				//var yy:int=y-ho.hoImgYSpot+pLayer.y;
				image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(i);
				bitmap.scaleX=xScale;
				bitmap.scaleY=yScale;
				bitmap.rotation=360-rotAngle;
				
				if (rotAngle==0)
				{
					displayObject.x=x-ho.hoImgXSpot+pLayer.x;
					displayObject.y=y-ho.hoImgYSpot+pLayer.y;
				}
				else
				{
					var dest:CPoint=new CPoint();
					var sx:Number=image.width*xScale;
					var sy:Number=image.height*yScale;
					
					var ifo:CImage = ho.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(ho.roc.rcImage, 0, ho.roc.rcScaleX, ho.roc.rcScaleY);
					var xo:Number = 0;  // coordonnées du point top-left par rapport au hot spot dans le repère du hot spot
					var yo:Number = 0;

					if(ifo != null) {
						xo = -ifo.xSpot;  // coordonnées du point top-left par rapport au hot spot dans le repère du hot spot
						yo = -ifo.ySpot;
					}
					var cosa:Number, sina:Number;
					if ( rotAngle == 90.0 )
					{
						cosa = 0.0;
						sina = 1.0;
					}
					else if ( rotAngle == 180.0 )
					{
						cosa = -1.0;
						sina = 0.0;
					}
					else if ( rotAngle == 270.0 )
					{
						cosa = 0.0;
						sina = -1.0;
					}
					else
					{
						var arad:Number = Number(rotAngle * Math.PI / 180.0);
						cosa = Math.cos(arad);
						sina = Math.sin(arad);
					}
					
					var dx:Number = xo * cosa + yo * sina;  // rotation du point top-left dans le repère du hot spot
					var dy:Number = yo * cosa - xo * sina;
					displayObject.x=x+dx+pLayer.x;
					displayObject.y=y+dy+pLayer.y;
					
				}
				if (image!=null)
				{
					bitmap.bitmapData=image.img;
				}
				bitmap.smoothing=(ho.ros.rsFlags&CRSpr.RSFLAG_ROTATE_ANTIA)!=0;

			}
		}
		public function delSprite():int
		{
			if (displayObject!=null)
			{
				var index:int=pLayer.planeSprites.getChildIndex(displayObject);
				pLayer.planeSprites.removeChild(displayObject);
				bitmap=null;
				displayObject=null;
				sprite=null;
				return index;
			}
			return 0;
		}
		public function showSprite():void
		{
			if (displayObject!=null)
			{
				displayObject.visible=true;
			}
			bShown=true;
		}
		public function hideSprite():void
		{
			if (displayObject!=null)
			{
				displayObject.visible=false;
			}
			bShown=false;
		}
		public function getChildIndex():int
		{
			if (displayObject!=null)
			{
				return pLayer.planeSprites.getChildIndex(displayObject);
			}
			return -1;
		}
		public function getChildMaxIndex():int
		{
			return pLayer.planeSprites.numChildren;
		}
		public function setChildIndex(index:int):void
		{
			if (index>=pLayer.planeSprites.numChildren)
			{
				index=pLayer.planeSprites.numChildren-1;
			}
			if (index<0)
			{
				index=0;
			}
			if (displayObject!=null)
			{
				pLayer.planeSprites.setChildIndex(displayObject, index);
			}
		}
		public function setTransparency(t:Number):void
		{
			if (displayObject!=null)
			{
				displayObject.alpha=t*oalpha;
			}
		}
	}
}