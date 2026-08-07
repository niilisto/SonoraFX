//----------------------------------------------------------------------------------
//
// CRUNVSCROLLBAR : Vertical scroll bar
//
//----------------------------------------------------------------------------------
package Extensions
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;


	public class CRunVScrollBar
	{
		public static var SX_BUTTON:int=19;
		public static var SY_BUTTON:int=18;
		public static var SX_LINES:int=6;
		public static var SX_ARROW:int=6;
		public static var SY_ARROW:int=4;
		
		public var parent:DisplayObjectContainer;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var yPos:int;
		public var yMax:int;
		public var syCenter:int;
		public var shape:Shape;
		public var sySlider:int;
		public var ySlider:int;
		public var hilight:int;
		public var selected:int;
		public var bActivated:Boolean;
		public var oldZone:int;
		public var yDrag:int;
		public var yDragPos:int;
		public var bDrag:Boolean;
		public var oldKey:int;
		public var bEnabled:Boolean;
		
		public function CRunVScrollBar(p:DisplayObjectContainer, xx:int, yy:int, w:int, h:int)
		{
			parent=p;
			x=xx;
			y=yy;
			width=w;
			height=h;
			yPos=0;
			yMax=10;
			syCenter=1;
			hilight=-1;
			selected=-1;
			oldZone=-1;
			oldKey=0;
			bEnabled=true;

			shape=new Shape();
			shape.x=x;
			shape.y=y;
			parent.addChild(shape);
			
			createDisplay();			
		}
		public function handle(xMouse:int, yMouse:int, keyBuffer:ByteArray):void
		{
			if (bActivated && bEnabled)
			{
				var bDisplay:Boolean=false;
				var zone:int=getZone(xMouse, yMouse);
				if (zone!=hilight)
				{
					hilight=zone;
					if (zone<0)
					{
						selected=-1;
					}	
					bDisplay=true;
				}
				
				var key:int=0;
				if (keyBuffer[260]!=0)
				{
					key=1;
				}
				if (key!=oldKey)
				{
					oldKey=key;				
					bDisplay=true;
					if (key==1)
					{
						selected=zone;
						switch(zone)
						{						
							case 0:
								if (yPos>0)
								{
									yPos--;
								}
								break;
							case 1:
								bDrag=true;
								yDrag=yMouse;
								yDragPos=yPos;
								break;
							case 2:
								if (yPos+syCenter<yMax)
								{
									yPos++;
								}
								break;
							case 3:
								yPos-=syCenter;
								if (yPos<0)
								{
									yPos=0;
								}
								break;
							case 4:
								yPos+=syCenter;
								if (yPos>yMax-syCenter)
								{
									yPos=yMax-syCenter;
								}
								break;
						}					
					}
					else
					{
						bDrag=false;
						selected=-1;
					}
				}
				if (key==1 && bDrag==true)
				{
					var y:int=yDragPos+((yMouse-yDrag)/(height-SY_BUTTON*2))*yMax;
					if (y<0)
					{
						y=0;
					}			
					if (y>yMax-syCenter)
					{		
						y=yMax-syCenter;
					}
					if (y!=yPos)
					{
						yPos=y;
						bDisplay=true;
					}
				} 
				if (bDisplay)
				{
					createDisplay();
				}
			}
		}
		public function getZone(xMouse:int, yMouse:int):int
		{
			if (xMouse>=0 && xMouse<SX_BUTTON)
			{
				if (yMouse>=0 && yMouse<height)
				{
					if (yMouse<SY_BUTTON)
					{
						return 0;	
					}	
					if (yMouse>=ySlider && yMouse<ySlider+sySlider)
					{
						return 1;
					}
					if (yMouse>=height-SY_BUTTON)
					{
						return 2;
					}
					if (yMouse<ySlider)
					{
						return 3;
					}
					return 4;
				}
			}
			return -1; 
		}
		public function createDisplay():void
		{
			shape.graphics.clear();
			
	    	var colors:Array=[0x94999B, 0xE7E7E7];
	    	var alphas:Array=[1, 1];
	    	var ratios:Array=[0, 255];
	    	var matr:Matrix=new Matrix();
    		matr.createGradientBox(width-1, height-1, 0, 0, 0);
	    	shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
			shape.graphics.drawRect(1, 1, width-2, height-2);
			shape.graphics.endFill();
			shape.graphics.lineStyle(1, 0x6A6B6E);
			shape.graphics.drawRect(0, 0, width-1, height-1);
			
			var color:int=0x6A6B6E;
			if (hilight==0)
			{
				color=0x64CFFF;
			}
			shape.graphics.lineStyle(1, color);
			shape.graphics.drawRect(0, 0, width-1, SY_BUTTON-1);
			color=0x6A6B6E;
			if (hilight==2)
			{
				color=0x64CFFF;
			}
			shape.graphics.lineStyle(1, color);
			shape.graphics.drawRect(0, height-SY_BUTTON, width-1, SY_BUTTON-1);
			
			color=0xF4F4F4;
			if (selected==0)
			{
				color=0xA6DCFF;
			}
			shape.graphics.lineStyle(1, color);
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(1, 1, width-3, SY_BUTTON-3);
			shape.graphics.endFill();			
			color=0xF4F4F4;
			if (selected==2)
			{
				color=0xA6DCFF;
			}
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(1, height-SY_BUTTON+1, width-3, SY_BUTTON-3);
			shape.graphics.endFill();			

			color=0x808080;
			if (hilight==0)
			{
				color=0x404040;
			}
			if (bActivated==false || bEnabled==false)
			{
				color=0xC0C0C0;
			}			
			shape.graphics.beginFill(color);
			shape.graphics.lineStyle(1, color);
			var x:int=width/2+1;
			var y:int=SY_BUTTON/2-SY_ARROW/2;
			shape.graphics.moveTo(x, y);
			shape.graphics.lineTo(x+SX_ARROW/2, y+SY_ARROW);
			shape.graphics.lineTo(x-SX_ARROW/2, y+SY_ARROW);
			shape.graphics.lineTo(x, y);
			shape.graphics.endFill();
			color=0x808080;
			if (hilight==2)
			{
				color=0x404040;
			}
			if (bActivated==false || bEnabled==false)
			{
				color=0xC0C0C0;
			}			
			y=height-SY_BUTTON/2+SY_ARROW/2;
			shape.graphics.beginFill(color);
			shape.graphics.lineStyle(1, color);
			shape.graphics.moveTo(x, y);
			shape.graphics.lineTo(x-SX_ARROW/2, y-SY_ARROW);
			shape.graphics.lineTo(x+SX_ARROW/2, y-SY_ARROW);
			shape.graphics.lineTo(x, y);
			shape.graphics.endFill();
			
			if (bActivated && bEnabled)
			{
				ySlider=((height-SY_BUTTON*2)*yPos)/yMax+SY_BUTTON;
				sySlider=(syCenter*(height-SY_BUTTON*2))/yMax;
				if (sySlider<10)
				{
					sySlider=10;
				}
				if (ySlider+sySlider>height-SY_BUTTON)
				{
					ySlider=height-SY_BUTTON-sySlider;
				}
				color=0x808080;
				if (hilight==1)
				{
					color=0x64CFFF;
				}
				shape.graphics.lineStyle(1, color);
				shape.graphics.drawRect(0, ySlider, width-1, sySlider-1);

				color=0xF4F4F4;
				if (selected==1)
				{
					color=0xA6DCFF;
				}
				shape.graphics.beginFill(color);
				shape.graphics.drawRect(1, ySlider+1, width-3, sySlider-3);
				shape.graphics.endFill();			

				if (syCenter>15)
				{
					var n:int;
					for (n=0; n<5; n++)
					{
						y=ySlider+sySlider/2-5+n*2;
						shape.graphics.lineStyle(1, 0x929292);
						shape.graphics.moveTo(width/2-SX_LINES/2, y);
						shape.graphics.lineTo(width/2+SX_LINES/2, y);
					}
				}							
			}								
		}
		public function setRange(ySize:int, y:int, sy:int):void
		{
			bActivated=false;
			yMax=ySize;
			yPos=y;
			syCenter=sy;
			if (yPos+syCenter>yMax)
			{
				yPos=yMax-syCenter;
				if (yPos<0)
				{
					yPos=0;
				}
			}
			if (yMax>0 && yPos+syCenter<=yMax)
			{
				bActivated=true;
			}
			createDisplay();
		}		
		public function setEnabled(b:Boolean):void
		{
			if (b!=bEnabled)
			{
				bEnabled=b;
				createDisplay();
			}
		}
	}
}