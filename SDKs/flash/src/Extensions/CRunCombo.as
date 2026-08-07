//----------------------------------------------------------------------------------
//
// CRUNCOMBO : Combo box control
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Application.CRunApp;

	public class CRunCombo
	{
		import Services.CArrayList;
		import Services.CFontInfo;
		
		import flash.display.*;
		import flash.display.DisplayObjectContainer;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.geom.Matrix;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;
		import flash.utils.ByteArray;

	
		public static var COMBOFLAG_SCROLLBAR:int=0x0001;
		public static var COMBOFLAG_SORT:int=0x0002;
		public static var COMBOFLAG_HIDDEN:int=0x0010;
		public static var COMBOFLAG_SCROLLTONEWLINE:int=0x0020;
		public static var COMBOTYPE_SIMPLE:int=0x0000;
		public static var COMBOTYPE_DROPDOWNLIST:int=0x0001;
		public static var COMBOTYPE_DROPDOWN:int=0x0002;
		public static var SX_BUTTON:int=22;
		public static var SX_ARROW:int=8;
		public static var SY_ARROW:int=6;
		public static var SX_BARBORDER:int=4;
		public static var SY_BARBORDER:int=4;
		public static var ZONE_TEXTFIELD:int=1;
		public static var ZONE_BUTTON:int=2;
		public static var ZONE_LIST:int=3;
		public var parent:DisplayObjectContainer;
		public var width:int;
		public var height:int;
		public var sprite:Sprite;
		public var textField:TextField;
		public var x:int;
		public var y:int;
		public var backColor:int;
		public var fontColor:int;
		public var flags:int;
		public var bVisible:Boolean;
		public var font:CFontInfo;
		public var textFormat:TextFormat;
		public var bHilighted:Boolean;
		public var syBar:int;
		public var syText:int;
		public var list:CRunComboList;
		public var xList:int;
		public var yList:int;
		public var type:int;
		public var currentZone:int;
		public var xMouse:int;
		public var yMouse:int;
		public var currentText:String;
		public var bSelChanged:Boolean;
		public var bClick:Boolean;
		public var bDoubleClick:Boolean;
		public var oldKey:int;
		public var bFocus:Boolean;
		public var bEnabled:Boolean;
		public var bSysColor:Boolean;
		public var bEmbedFont:Boolean;
		public var rhApp:CRunApp;
						
		public function CRunCombo(app:CRunApp, p:DisplayObjectContainer, xx:int, yy:int, w:int, h:int, ft:CFontInfo, bSys:Boolean, ftColor:int, bkColor:int, fl:int, t:int)
		{
			rhApp=app;
			parent=p;
			x=xx;
			y=yy;
			width=w;
			height=h;
			bSysColor=bSys;
			backColor=bkColor;
			fontColor=ftColor;
			font=ft;
			flags=fl;
			type=t;
			
			bVisible=true;
			if ((flags&COMBOFLAG_HIDDEN)!=0)
			{
				bVisible=false;
			}
			bEnabled=true;
			
			currentText="";
			sprite=new Sprite();
			textField=new TextField();
			sprite.addChild(textField);
			textField.addEventListener(Event.CHANGE, changeHandler);
			createDisplay();
			
			var sy:int=height-syBar;
			if (sy<30)
			{
				sy=30;
			}
			xList=0;
			yList=syBar;
			var f:int=flags;
			f|=CRunComboList.LISTFLAG_BORDER;
			if (type!=COMBOTYPE_SIMPLE)
			{
				f|=CRunComboList.LISTFLAG_HIDDEN;				
			}
			if (type==COMBOTYPE_DROPDOWNLIST)
			{
				textField.selectable=false;
			}
			list=new CRunComboList(rhApp, sprite, xList, yList, width-1, sy, font, fontColor, backColor, f);
			sprite.visible=bVisible;
			parent.addChild(sprite);
			
			currentZone=-1;
			bHilighted=false;
			oldKey=0;
			bFocus=true;
		}
		public function bringToFront():void
		{
			var last:int=parent.numChildren-1;
			if (last<0)
			{
				last=0;
			}
			parent.setChildIndex(sprite, last);
		}
		public function destroy():void
		{
			textField.removeEventListener(Event.CHANGE, changeHandler);
			parent.removeChild(sprite);			
		}
		public function setHandCursor(bOn:Boolean):void
		{
			sprite.buttonMode=bOn;
			sprite.useHandCursor=bOn;
		}
        public function changeHandler(e:Event):void 
        {
			currentText=textField.text;
        }
		public function createDisplay():void
		{
			sprite.x=x;
			sprite.y=y;
			drawBar();
			textField.x=SX_BARBORDER;
			textField.y=SY_BARBORDER;
			if (type==COMBOTYPE_DROPDOWNLIST || type==COMBOTYPE_SIMPLE)
			{
				textField.width=width-SX_BARBORDER*2;
			}
			else
			{
				textField.width=width-SX_BUTTON-SX_BARBORDER-6;
			}
			textField.height=syText+4;
			drawText();
		}
		public function createTextFormat():void
		{
			textFormat=new TextFormat();
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.color=fontColor;
			
			var embeddedName:String=font.getEmbeddedName();
			var embeddedFont:int=rhApp.getEmbeddedFont(embeddedName);
			bEmbedFont=false;
			if (embeddedFont>=0)
			{
				bEmbedFont=true;
				textFormat.font=embeddedName;
			}
			else
			{
				textFormat.font=font.lfFaceName;
				if (font.lfWeight>600)
					textFormat.bold=true;
				if (font.lfItalic!=0)
					textFormat.italic=true;
				if (font.lfUnderline!=0)
					textFormat.underline=true;						
			}
			textFormat.size=font.lfHeight;
		}
		public function drawBar():void
		{
			// Trouve la hauteur du texte
			var tf:TextField=new TextField();
			tf.text="AqYy";
			createTextFormat();				
			tf.setTextFormat(textFormat);
			syText=tf.textHeight;
			syBar=syText+SY_BARBORDER*2+4;
			
			// Dessine la barre			
			sprite.graphics.clear();
			
			var color:int;			
			color=0x8D8F92;
			if (bHilighted)
			{
				color=0x64CFFF;
			}
			sprite.graphics.lineStyle(1, color);
			var colors:Array;
			if (bSysColor)
			{
	    		colors=[0xDEE5E8, 0xA8B5BC];
		    	if (bHilighted)
		    	{
		    		colors[0]=0xE9EEEF;
		    		colors[1]=0xCBD3D7;
		    	}
			}
			else
			{
				colors=[backColor, backColor];
			}
	    	var alphas:Array=[1, 1];
	    	var ratios:Array=[0, 255];
	    	var matr:Matrix=new Matrix();
    		matr.createGradientBox(width-1, syBar, Math.PI/2, 0, 0);
	    	sprite.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
			sprite.graphics.drawRoundRect(0, 0, width-1, syBar-1, 5);
			sprite.graphics.endFill();

			if (type!=COMBOTYPE_SIMPLE)
			{
				color=0x8D8F92;
				if (bHilighted)
				{
					color=0x606060;
				}
				sprite.graphics.lineStyle(1, color);
				sprite.graphics.moveTo(width-SX_BUTTON-2, 4);
				sprite.graphics.lineTo(width-SX_BUTTON-2, syBar-4);				
				sprite.graphics.lineStyle(1, 0xD0D8DC);
				sprite.graphics.moveTo(width-SX_BUTTON-1, 4);
				sprite.graphics.lineTo(width-SX_BUTTON-1, syBar-4);
	
				color=0x808080;
				if (bHilighted)
				{
					color=0x404040;
				}			
				sprite.graphics.lineStyle(1, color);
				var x:int=width-SX_BUTTON/2;
				var y:int=syBar/2+SY_ARROW/2;
				var n:int;
				for (n=0; n<5; n++)
				{
					sprite.graphics.moveTo(x, y-n);
					sprite.graphics.lineTo(x+n-SX_ARROW/2, y+n-SY_ARROW);
					sprite.graphics.lineTo(x-n+SX_ARROW/2, y+n-SY_ARROW);
					sprite.graphics.lineTo(x, y-n);
				}
			}
		}
		public function drawText():void
		{
			textField.text=currentText;
			textField.setTextFormat(textFormat);
			textField.embedFonts=bEmbedFont;
			textField.defaultTextFormat=textFormat;
			if (type!=COMBOTYPE_DROPDOWNLIST)
			{
				textField.backgroundColor=backColor;
				textField.background=true;
			}			
		}
		public function handle(xm:int, ym:int, keyBuffer:ByteArray):void
		{
			xMouse=xm;
			yMouse=ym;

			if (bVisible==true && bEnabled==true)
			{
				// Gestion de la liste
				list.handle(xMouse-xList, yMouse-yList, keyBuffer);
				
				// Trouve la zone courante
				currentZone=getZone(xMouse, yMouse);			
				var bHi:Boolean=false;
				if (currentZone>=0)
				{
					bHi=true;
				}		
				if (bHi!=bHilighted)
				{
					bHilighted=bHi;
					drawBar();
				}
				
				// Appui sur return?
				if (bFocus==true)
				{
					var key:int=0;
					if (keyBuffer[13]!=0)		// RETURN
					{
						key=1;
					}
					if (keyBuffer[38]!=0)		// UP
					{
						key=2;
					}
					if (keyBuffer[40]!=0)		// DOWN
					{
						key=3;
					}
					if (keyBuffer[33]!=0)		// PAGEUP
					{
						key=4;
					}
					if (keyBuffer[34]!=0)		// PAGEDOWN
					{
						key=5;
					}
					if (key!=oldKey)
					{
						oldKey=key;
						switch (key)
						{
							case 1:
								currentText=String(list.strings.get(list.ySelected));
								drawText();
								bSelChanged=true;
								if (type==COMBOTYPE_DROPDOWN || type==COMBOTYPE_DROPDOWNLIST)
								{
									list.setVisible(false);
								}
								break;
							case 2:
								if (list.bVisible==false)
								{
									y=list.ySelected;
									if (y==-1)
									{	
										y=0;
									}
									else
									{
										if (y>0)
										{
											y--;
										}
									}
									list.setSelected(y);
								}
								break;
							case 3:
								if (list.bVisible==false)
								{
									y=list.ySelected;
									if (y==-1)
									{	
										y=0;
									}
									else
									{
										if (y<list.strings.size()-1)
										{
											y++;
										}
									}
									list.setSelected(y);
								}
								break;
							case 4:			// PAGEUP
								if (list.bVisible==false)
								{
									y=list.ySelected;
									if (y==-1)
									{
										y=0;
									}
									else
									{
										y-=list.nLines;
										if (y<0)
										{
											y=0;
										}									
									}
									list.setSelected(y);
								}
								break;
							case 5:			// PAGEDOWN
								if (list.bVisible==false)
								{
									y=list.ySelected;
									if (y==-1)
									{
										y=0;
									}
									else
									{
										y+=list.nLines;
										if (y>=list.strings.size())
										{
											y=list.strings.size()-1;
										}
									}
									list.setSelected(y);
								}
								break;
						}
					}
				}
				
				// Changement de texte
				if (list.bSelChanged)
				{
					list.bSelChanged=false;
					if (list.ySelected>=0)
					{
						currentText=String(list.strings.get(list.ySelected));
						drawText();
						bSelChanged=true;
					}
				}
				if (list.bClick)
				{
					list.bClick=false;
					bClick=true;
					if (type==COMBOTYPE_DROPDOWN || type==COMBOTYPE_DROPDOWNLIST)
					{
						list.setVisible(false);
					}
				}
				if (list.bDoubleClick)
				{
					list.bDoubleClick=false;
					bDoubleClick=true;
				}
			}
		}
		
		public function getZone(xm:int, ym:int):int
		{
			if (xMouse>=0 && xMouse<width)
			{
				if (yMouse>=0 && yMouse<syBar)
				{
					if (xMouse>width-SX_BUTTON)
					{
						return ZONE_BUTTON;
					}	
					return ZONE_TEXTFIELD;
				}
			}	
			if (list.bVisible)
			{
				if (xMouse>=xList && xMouse<xList+list.width)
				{
					if (yMouse>=yList && yMouse<yList+list.height)
					{
						return ZONE_LIST;
					}
				}
			}
			return -1;
		}
		public function click():void
		{
			list.click();
			
			if (bVisible==true && bEnabled==true)
			{
				switch(type)
				{
					case COMBOTYPE_SIMPLE:
						if (currentZone==ZONE_TEXTFIELD)
						{
							textField.selectable=true;
							textField.mouseEnabled=true;
			            	textField.type=TextFieldType.INPUT;
			   			}
			   			else
			   			{
							textField.selectable=false;
							textField.mouseEnabled=false;
			            	textField.type=TextFieldType.DYNAMIC;
			   			}	
			   			if (currentZone==ZONE_LIST)
			   			{
			   				list.setFocus(true);
			   			}
		            	break;
		            case COMBOTYPE_DROPDOWN:
						if (currentZone==ZONE_TEXTFIELD)
						{
							textField.selectable=true;
							textField.mouseEnabled=true;
			            	textField.type=TextFieldType.INPUT;
			   			}	
			   			else if (currentZone==ZONE_BUTTON)
			   			{
			            	if (list.bVisible)
			            	{
			            		list.setVisible(false);
			            	}
			            	else
			            	{
			            		list.setVisible(true);
			            		list.setFocus(true);
			            		bringToFront();
			            	}
			      		}
			      		else if (currentZone==ZONE_LIST)
			      		{
							textField.selectable=false;
							textField.mouseEnabled=false;
			            	textField.type=TextFieldType.DYNAMIC;
			      		}
			      		else if (currentZone<0)
			      		{
							textField.selectable=true;
							textField.mouseEnabled=true;
			            	textField.type=TextFieldType.INPUT;
		            		list.setVisible(false);
			      		}		      		
		            	break;
		            case COMBOTYPE_DROPDOWNLIST:
		            	if (currentZone==ZONE_TEXTFIELD || currentZone==ZONE_BUTTON)
		            	{
			            	if (list.bVisible)
			            	{
			            		list.setVisible(false);
			            	}
			            	else
			            	{
			            		list.setVisible(true);
			            		list.setFocus(true);
			            		bringToFront();
			            	}
			            }
			      		else if (currentZone<0)
			      		{
		            		list.setVisible(false);
			      		}		      		
		            	break;
				}
				if (currentZone==-1)
				{
					switch (type)
					{
						case COMBOTYPE_SIMPLE:
							break;
						case COMBOTYPE_DROPDOWN:
							textField.selectable=false;
							textField.mouseEnabled=false;
			            	textField.type=TextFieldType.DYNAMIC;
	 					case COMBOTYPE_DROPDOWNLIST:
							if (list.bVisible==true)
							{
								var bVis:Boolean=false;
								if (xMouse>=xList && xMouse<xList+list.width)
								{
									if (yMouse>yList && yMouse<yList+list.height)
									{
										bVis=true;
									}
								}
								if (bVis==false)
								{
									list.setVisible(false);
								}
							}
							break;
					}
				}
			}
		}
		public function addString(s:String, bDisplay:Boolean=true):void
		{
			list.addString(s, bDisplay);
		}
		public function insertString(index:int, s:String, bDisplay:Boolean=true):void
		{
			list.insertString(index, s, bDisplay);
		}
		public function setString(index:int, s:String, bDisplay:Boolean=true):void
		{
			list.setString(index, s, bDisplay);
		}
		public function delString(index:int, bDisplay:Boolean=true):void
		{
			list.delString(index, bDisplay);
		}
		public function displayStrings():void
		{
			list.displayStrings();
		}
		public function setPosition(xx:int, yy:int):void
		{
			x=xx;
			y=yy;
			sprite.x=xx;
			sprite.y=yy;
		}
		public function setFocus(b:Boolean):void
		{
			if (b!=bFocus)
			{
				bFocus=b;
				if (bFocus==false)
				{
					if (type!=COMBOTYPE_SIMPLE)
					{
						list.setVisible(false);
					}
				}
			}
		}
		public function setVisible(b:Boolean):void
		{
			if (b!=bVisible)
			{
				bVisible=b;
				sprite.visible=b;
			}
		}
		public function setEnabled(b:Boolean):void
		{
			bEnabled=b;
			list.setEnabled(b);
			if (b==false)
			{					
				textField.selectable=false;
				textField.mouseEnabled=false;
            	textField.type=TextFieldType.DYNAMIC;
				if (type!=COMBOTYPE_SIMPLE)
				{
					list.setVisible(false);
				}
			}
		}
		public function reset():void
		{
			list.reset();
			currentText="";
			drawText();
		}
		public function getSize():int
		{
			return list.strings.size();					
		}
		public function setSelected(index:int):void
		{
			list.setSelected(index);			
		}
		public function setCurrentText(t:String):void
		{
			currentText=t;
			drawText();
		}
		public function ensureLineIsVisible(line:int):void
		{
	        list.ensureIndexIsVisible(line);
		}
		public function setForeground(color:int):void
		{
			fontColor=color;
			createDisplay();
			list.setForeground(color);
		}
		public function setBackground(color:int):void
		{
			backColor=color;
			createDisplay();
			list.setBackground(color);
		}
		public function setData(index:int, data:int):void
		{
			list.setData(index, data);
		}
		public function getSelectedIndex():int
		{
			return list.ySelected;
		}
		public function getString(index:int):String
		{
			return String(list.getString(index));
		}
		public function findString(search:String, startIndex:int):int
		{
			return list.findString(search, startIndex);	
		}
		public function findStringExact(search:String, startIndex:int):int
		{
			return list.findStringExact(search, startIndex);	
		}
		public function getData(index:int):int
		{
			return list.getData(index);	
		}
	}
}