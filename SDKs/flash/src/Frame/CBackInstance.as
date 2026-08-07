//----------------------------------------------------------------------------------
//
// CBACKINSTANCE : instance objet decor
//
//----------------------------------------------------------------------------------
package Frame
{
	import Application.*;
	
	import Banks.CImage;
	
	import OI.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	import Box2D.Dynamics.b2Body;
	
	public class CBackInstance 
	{
		public var app:CRunApp;
		public var levelObject:CLO;
		public var shapeInstance:Shape;
		public var bitmapInstance:Bitmap;
		public var type:int;
		public var obstacleType:int;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var poi:COI;
		public var colBox:Boolean;		
		public var imageUsed:CImage;
		public var displayObject:DisplayObject;
		public var alpha:Number=1.0;
		public var body:b2Body = null;
					
		public function CBackInstance(a:CRunApp, xx:int, yy:int, plo:CLO, sprImage:CImage, colType:int)
		{
			var image:CImage;
			
			app=a;
			levelObject=plo;
			x=xx;
			y=yy;
		
			if (plo!=null)
			{	
				poi=app.OIList.getOIFromHandle(plo.loOiHandle);
				type=poi.oiType;
				obstacleType=poi.oiOC.ocObstacleType;
							
				if (type==COI.OBJ_BOX)
				{
					shapeInstance=new Shape();
					displayObject=shapeInstance;
					shapeInstance.x=xx;
					shapeInstance.y=yy;
					
					var pCOCQB:COCQBackdrop=COCQBackdrop(poi.oiOC);
					var borderWidth:int=pCOCQB.ocBorderSize;
					width=pCOCQB.ocCx;
					height=pCOCQB.ocCy;
					colBox=pCOCQB.ocColMode!=0;

					//var alpha:Number=1.0;
					if ((poi.oiInkEffect&0xFFFF)==1)		// SEMITRANSP
					{
						alpha=Number(128-poi.oiInkEffectParam)/128.0
					}
										
					switch (pCOCQB.ocFillType)
					{
					    case 0:
							if (borderWidth==0)
						    	borderWidth=1;
							break;
					    case 1:			    // FILLTYPE_SOLID
					    	shapeInstance.graphics.beginFill(pCOCQB.ocColor1, alpha);
							break;
					    case 2:			    // FILLTYPE_GRADIENT
					    	var colors:Array=[pCOCQB.ocColor1, pCOCQB.ocColor2];
					    	var alphas:Array=[alpha, alpha];
					    	var ratios:Array=[0, 255];
					    	var matr:Matrix=new Matrix();
					    	if (pCOCQB.ocGradientFlags==0)
					    	{
					    		matr.createGradientBox(pCOCQB.ocCx, pCOCQB.ocCy, 0, 0, 0);
					    	}
					    	else
					    	{
					    		matr.createGradientBox(pCOCQB.ocCx, pCOCQB.ocCy, Math.PI/2, 0, 0);				    		
					    	}
					    	shapeInstance.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
							break;
					    case 3:			    // FILLTYPE_IMAGE
							image=app.imageBank.getImageFromHandle(pCOCQB.ocImage);
							shapeInstance.graphics.beginBitmapFill(image.img, null, true);
							break;
					}
					switch(pCOCQB.ocShape)
					{
						// SHAPE_LINE
						case 1:
							var xx:int=0;
							var yy:int=0;
							var cx:int=pCOCQB.ocCx;
							var cy:int=pCOCQB.ocCy;
		                    if ((pCOCQB.ocLineFlags & COCQBackdrop.LINEF_INVX) != 0)
		                    {
		                        xx += cx;
		                        cx = -cx;
		                    }
		                    if ((pCOCQB.ocLineFlags & COCQBackdrop.LINEF_INVY) != 0)
		                    {
		                        yy += cy;
		                        cy = -cy;
		                    }
							shapeInstance.graphics.lineStyle(borderWidth, pCOCQB.ocBorderColor, alpha);	
							shapeInstance.graphics.moveTo(xx, yy);
							shapeInstance.graphics.lineTo(xx+cx, yy+cy);
						    break;
						// SHAPE_RECTANGLE
						case 2:
							shapeInstance.graphics.drawRect(0, 0, pCOCQB.ocCx, pCOCQB.ocCy);
							shapeInstance.graphics.endFill();
						    break;
						// SHAPE_ELLIPSE
						case 3:
							shapeInstance.graphics.drawEllipse(0, 0, pCOCQB.ocCx, pCOCQB.ocCy);
							shapeInstance.graphics.endFill();
						    break;						
					}
					var n:int;
					if (borderWidth>0)
					{
						shapeInstance.graphics.lineStyle(1, pCOCQB.ocBorderColor, alpha);	
						switch (pCOCQB.ocShape)
						{
							// SHAPE_RECTANGLE
							case 2:
								for (n=0; n<borderWidth; n++)
								{
									shapeInstance.graphics.drawRect(0+n, 0+n, pCOCQB.ocCx-n*2-1, pCOCQB.ocCy-n*2-1);									
								}
								break;
							// SHAPE_ELLIPSE
							case 3:
								for (n=0; n<borderWidth; n++)
								{
									shapeInstance.graphics.drawEllipse(0+n, 0+n, pCOCQB.ocCx-n*2-1, pCOCQB.ocCy-n*2-1);
								}
								break;
						}							
					}
				}
				else
				{
					bitmapInstance=new Bitmap();
					displayObject=bitmapInstance;
					bitmapInstance.x=xx;
					bitmapInstance.y=yy;
	
					var pCOCBkd:COCBackground=COCBackground(poi.oiOC);
					imageUsed=app.imageBank.getImageFromHandle(pCOCBkd.ocImage);
					bitmapInstance.bitmapData=imageUsed.img;
					width=imageUsed.width;
					height=imageUsed.height;
					colBox=pCOCBkd.ocColMode!=0;
					if ((poi.oiInkEffect&0xFFFF)==1)		// SEMITRANSP
					{	
			    		var v:Number=(Number(128-poi.oiInkEffectParam))/128.0;
		    			bitmapInstance.alpha=v;
					}	
				}
				setEffect(poi.oiInkEffect, poi.oiInkEffectParam);
			}
			else
			{
				type=COI.OBJ_PASTED;
				imageUsed=sprImage;
				bitmapInstance=new Bitmap();
				displayObject=bitmapInstance;
				bitmapInstance.x=xx-imageUsed.xSpot;
				bitmapInstance.y=yy-imageUsed.ySpot;
				bitmapInstance.bitmapData=imageUsed.img;
				width=imageUsed.width;
				height=imageUsed.height;
				x-=imageUsed.xSpot;
				y-=imageUsed.ySpot;
				switch(colType)
				{
					case 0:			// Transparent
						obstacleType=COC.OBSTACLE_NONE;
						break;
					case 1:
						obstacleType=COC.OBSTACLE_SOLID;
						break;
					case 2:
						obstacleType=COC.OBSTACLE_PLATFORM;
						break;
					case 3:
						obstacleType=COC.OBSTACLE_LADDER;
						break;
				}
				colBox=false;
			}		
		}
		public function addInstance(num:int, pLayer:CLayer):void
		{
			switch(type)
			{
				case COI.OBJ_BOX:
					pLayer.planeBack.addChild(shapeInstance);
					break;
				case COI.OBJ_BKD:
					pLayer.planeBack.addChild(bitmapInstance);
					break;
				case COI.OBJ_PASTED:
					pLayer.planeBack.addChild(bitmapInstance);
					pLayer.addBackdrop(this);
					break;
			}
			switch(obstacleType)
			{
				case COC.OBSTACLE_SOLID:
					pLayer.addObstacle(this);
					pLayer.addPlatform(this);
					break;
				case COC.OBSTACLE_PLATFORM:
					pLayer.addPlatform(this);
					break;
				case COC.OBSTACLE_LADDER:
	//				pLayer.addObstacle(this);
					pLayer.addLadder(x, y, x+width, y+height);
					break; 
			}
		}
		public function delInstance(pLayer:CLayer):void
		{
			switch(type)
			{
				case COI.OBJ_BOX:
					pLayer.planeBack.removeChild(shapeInstance);
					break;
				case COI.OBJ_BKD:
				case COI.OBJ_PASTED:
					pLayer.planeBack.removeChild(bitmapInstance);
					break;
			}
			switch(obstacleType)
			{
				case COC.OBSTACLE_SOLID:
					pLayer.delObstacle(this);
					pLayer.delPlatform(this);
					break;
				case COC.OBSTACLE_PLATFORM:
					pLayer.delPlatform(this);
					break;
				case COC.OBSTACLE_LADDER:
//					pLayer.delObstacle(this);
					pLayer.ladderSub(x, y, x+width, y+height);
					break; 
			}
		}
		public function testMask(mask:CMask, xx:int, yy:int, htFoot:int):Boolean
		{
			var flags:int;
			var mask2:CMask;
			
			switch(type)
			{
				case 0:			// COI:OBJ_BOX:
					var h:int=height;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						h=CRunFrame.HEIGHT_PLATFORM;
					}
					return mask.testRect(xx, yy, htFoot, x, y, width, h, 0);
				case 1:			// COI.OBJ_BKD:
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask2=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testMask(xx, yy, htFoot, mask2, x, y, 0);					
				case 11:		// COI.OBJ_PASTED
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask2=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testMask(xx, yy, htFoot, mask2, x, y, 0);					
			}
			return false;		
		}
		public function testRect(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			var flags:int;
			var mask:CMask;
			
			switch(type)
			{
				case 0:		// COI:OBJ_BOX:
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						var yTop:int=y;
						var yBottom:int=y+Math.min(height, CRunFrame.HEIGHT_PLATFORM);
						if (yTop<y2 && yBottom>y1)
						{
							return true;
						}
						return false;
					}
					return true;
				case 1:		// COI.OBJ_BKD:
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testRect(x, y, 0, x1, y1, x2, y2, 0);
				case 11:		// COI.OBJ_PASTED:
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testRect(x, y, 0, x1, y1, x2, y2, 0);
			}
			return false;
		}
		public function testPoint(x1:int, y1:int):Boolean
		{
			var flags:int;
			var mask:CMask;
			
			switch(type)
			{
				case 0:		// COI:OBJ_BOX:
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						var yTop:int=y+height-CRunFrame.HEIGHT_PLATFORM;
						var yBottom:int=y+height;
						if (y1>=yTop && y1<yBottom)
						{
							return true;
						}
						return false;
					}
					return true;
				case 1:		// COI.OBJ_BKD:
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testPoint(x, y, x1, y1);
				case 11:		// COI.OBJ_PASTED:
					if (colBox!=0)
					{
						return true;
					}
					flags=CMask.GCMF_OBSTACLE;
					if (obstacleType==COC.OBSTACLE_PLATFORM)
					{
						flags=CMask.GCMF_PLATFORM;
					}
					mask=imageUsed.getMask(flags, 0, 1.0, 1.0);
					return mask.testPoint(x, y, x1, y1);
			}
			return false;
		}
		public function setEffect(effect:int, effectParam:int):void
		{
			var effectMasked:int=effect&CRSpr.BOP_MASK;
			
			alpha=1.0;
			var r:int=255;
			var g:int=255;
			var b:int=255;
			if ((effect & CRSpr.BOP_RGBAFILTER) != 0)
			{
				r=((effectParam&0xFFFFFF)>>16)&0xFF;
				g=((effectParam&0xFFFFFF)>>8)&0xFF;
				b=(effectParam&0xFFFFFF)&0xFF;
				alpha = (((effectParam >> 24) & 0xFF) / 255.0);
			}
			else if (effectMasked == CRSpr.BOP_BLEND)
			{
				alpha = ((128 - effectParam) / 128.0);
			}
			
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
			setTransparency(alpha);
		}
		public function setTransparency(t:Number):void
		{
			displayObject.alpha=t*alpha;
		}			
	}
}