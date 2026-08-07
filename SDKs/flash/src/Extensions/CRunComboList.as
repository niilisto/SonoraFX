//----------------------------------------------------------------------------------
//
// CRUNLIST : List control
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Application.CRunApp;
	
	import Services.CArrayList;
	import Services.CFontInfo;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class CRunComboList
	{
		public static var LISTFLAG_SCROLLBAR:int=0x0001;
		public static var LISTFLAG_SORT:int=0x0002;
		public static var LISTFLAG_BORDER:int=0x0004;
		public static var LISTFLAG_3DLOOK:int=0x0008;
		public static var LISTFLAG_HIDDEN:int=0x0010;
		public static var LISTFLAG_SCROLLTONEWLINE:int=0x0020;
		public static var SY_TEXTBORDERS:int=4;
		public static var SELECTED_COLOR:int=0x7FCEFF;
		public static var HILIGHT_COLOR:int=0xB2E1FF;
		
		public var parent:DisplayObjectContainer;
		public var width:int;
		public var height:int;
		public var trueHeight:int;
		public var x:int;
		public var y:int;
		public var backColor:int;
		public var fontColor:int;
		public var flags:int;
		public var font:CFontInfo;
		public var textFormat:TextFormat;
		public var sprite:Sprite;
		public var nLines:int;
		public var bVisible:Boolean;
		public var yPos:int;
		public var sxLine:int;
		public var syLine:int;
		public var yHilight:int;
		public var ySelected:int;
		public var oldHilight:int;
		public var oldSelected:int;
		public var sBorder:int;
		public var bFocus:Boolean;
		public var oldKey:int;
		public var lineSprites:Array;
		public var lineTexts:Array;
		public var strings:CArrayList;
		public var datas:CArrayList;
		public var slider:CRunComboVScrollBar;
		public var bClick:Boolean;
		public var bDoubleClick:Boolean;
		public var bEnabled:Boolean;
		public var bSelChanged:Boolean;
		public var bEmbedFont:Boolean;
		public var rhApp:CRunApp;
		
		public function CRunComboList(app:CRunApp, p:DisplayObjectContainer, xx:int, yy:int, w:int, h:int, ft:CFontInfo, ftColor:int, bkColor:int, fl:int)
		{
			rhApp=app;
			parent=p;
			x=xx;
			y=yy;
			width=w;
			height=h;
			backColor=bkColor;
			fontColor=ftColor;
			font=ft;
			flags=fl;
			strings=new CArrayList();
			datas=new CArrayList();

			yPos=0;
			yHilight=-1;
			ySelected=-1;
			oldHilight=-1;
			oldSelected=-1;
			oldKey=0;
			bFocus=false;
			bEnabled=true;
			
			bVisible=true;
			if ((flags&LISTFLAG_HIDDEN)!=0)
			{
				bVisible=false;
			}
			createDisplay();
		}
		public function destroy():void
		{
			parent.removeChild(sprite);				
		}
		public function handle(xMouse:int, yMouse:int, keyBuffer:ByteArray):void
		{
			if (bVisible==false || bEnabled==false)
			{
				return;
			}
			
			yHilight=getLine(xMouse, yMouse);
			hilightCurrentLine();

			if (bFocus)
			{
				var key:int=0;
				if (keyBuffer[38]!=0)		// UP
				{
					key=1;
				}
				if (keyBuffer[40]!=0)		// DOWN
				{
					key=2;
				}
				if (keyBuffer[13]!=0)		// RETURN
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
					var y:int=ySelected;
					switch(key)
					{
						case 1:		// Up
							if (ySelected>0)
							{
								ySelected--;
								if (ySelected<yPos)
								{
									eraseHilight();
									eraseSelected();
									yPos--;									
									displayStrings();										
								}
								hilightCurrentLine();
								ensureIndexIsVisible(ySelected);
								bSelChanged=true;
							}
							break;
						case 2:
							if (ySelected<strings.size()-1)
							{
								ySelected++;
								if (ySelected-yPos>=nLines)
								{
									eraseHilight();
									eraseSelected();
									yPos++;
									displayStrings();
								}
								hilightCurrentLine();
								ensureIndexIsVisible(ySelected);
								bSelChanged=true;
							}
							break;
						case 3:
							hilightCurrentLine();
							break;
						case 4:
							if (y>=0)
							{
								y-=nLines;
								if (y<0)
								{
									y=0;
								}
								if (y!=ySelected)
								{
									ySelected=y;
									if (ySelected-yPos<0)
									{
										eraseHilight();
										eraseSelected();
										yPos=ySelected;
										displayStrings();
									}
									hilightCurrentLine();
									ensureIndexIsVisible(ySelected);
									bSelChanged=true;
								}
							}
							break;
						case 5:
							if (y<strings.size())
							{
								y+=nLines;
								if (y>=strings.size())
								{
									y=strings.size()-1;
								}
								if (y!=ySelected)
								{
									ySelected=y;
									if (ySelected-yPos>=nLines)
									{
										eraseHilight();
										eraseSelected();
										yPos=ySelected-nLines+1;
										if (yPos+nLines>strings.size())
										{
											yPos=strings.size()-nLines;
										}
										displayStrings();
									}
									hilightCurrentLine();
									ensureIndexIsVisible(ySelected);
									bSelChanged=true;
								}
							}
							break;
					}			
				}
			}
			
			if (slider!=null)
			{
				slider.handle(xMouse-slider.x, yMouse-slider.y, keyBuffer);
				if (slider.yPos!=yPos)
				{
					eraseHilight();
					eraseSelected();
					yPos=slider.yPos;
					displayStrings();
				}
			}
		}
		public function setPosition(xx:int, yy:int):void
		{
			sprite.x=xx;
			sprite.y=yy;
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
		public function createDisplay():void
		{
			if (sprite!=null)
			{
				parent.removeChild(sprite);
			}
			sprite=new Sprite();
			sprite.x=x;
			sprite.y=y;
			
			var xx:int, yy:int;
			sBorder=0;
			xx=0; 
			yy=0;
			if ((flags&LISTFLAG_BORDER)!=0)
			{
				xx=1;
				yy=1;
				sBorder=1;
				if ((flags&LISTFLAG_3DLOOK)!=0)
				{
					xx=3;
					yy=3;
					sBorder=3;
				}
			}

			var textField:TextField=new TextField();
			textField.text="AqYy";
			createTextFormat();				
			textField.setTextFormat(textFormat);
			sxLine=width-xx*2;
			var syText:int=textField.textHeight;
			syLine=syText+SY_TEXTBORDERS;						
			nLines=(height-yy*2)/syLine;
			trueHeight=yy*2+syLine*nLines;
			drawBackground();
			lineSprites=new Array(nLines);
			lineTexts=new Array(nLines);
			var n:int;
			for (n=0; n<nLines; n++)
			{
				lineSprites[n]=new Sprite();
				lineSprites[n].x=xx;
				lineSprites[n].y=yy;
				lineTexts[n]=new TextField();
				lineTexts[n].x=0;
				lineTexts[n].y=0;		//syLine/2-syText/2;
				lineTexts[n].width=width-xx*2;
				lineTexts[n].height=syLine;
				lineTexts[n].mouseEnabled=false;
				lineTexts[n].selectable=false;
				lineSprites[n].addChild(lineTexts[n]);
				sprite.addChild(lineSprites[n]);
				yy+=syLine;
			}
			
			// Slider
			slider=null;
			if (flags&LISTFLAG_SCROLLBAR)
			{
				slider=new CRunComboVScrollBar(sprite, width-sBorder-CRunComboVScrollBar.SX_BUTTON, sBorder, CRunComboVScrollBar.SX_BUTTON, trueHeight-sBorder*2);
				slider.setRange(strings.size(), yPos, nLines);
			}

			// Strings
			displayStrings();
			
			// Event listener
			sprite.visible=bVisible;
			parent.addChild(sprite);
		}
		public function click():void
		{
			if (bVisible==false || bEnabled==false)
			{
				return;
			}			
			if (yHilight>=0)
			{
				bClick=true;
//				if (ySelected!=yHilight)
				{
					ySelected=yHilight;						
					hilightCurrentLine();
					bSelChanged=true;
				}
			}			
		}
		public function doubleClick():void
		{
			if (bVisible==false || bEnabled==false)
			{
				return;
			}
			if (yHilight>=0)
			{
				click();
				bClick=false;
				bDoubleClick=true;
			}			
		}
		public function setFocus(bFlag:Boolean):void
		{
			bFocus=bFlag;
			if (ySelected<0)
			{
				ySelected=0;
				hilightCurrentLine();
			}
		}
		public function getLine(x:int, y:int):int
		{
			if (x>sBorder && y>sBorder)
			{
				var sx:int=width-sBorder;
				if (slider!=null)
				{
					sx-=CRunComboVScrollBar.SX_BUTTON;
				}
				if (x<sx && y<trueHeight-sBorder)
				{
					var y:int=yPos+(y-sBorder)/syLine
					if (y<strings.size())
					{
						return y;
					}					
				}
			}
			return -1;
		}
		public function drawBackground():void
		{
			sprite.graphics.clear();
			sprite.graphics.beginFill(backColor);
			sprite.graphics.drawRect(0, 0, width, trueHeight);
			sprite.graphics.endFill();
			if ((flags&LISTFLAG_BORDER)!=0)
			{
				if ((flags&LISTFLAG_3DLOOK)==0)
				{
					sprite.graphics.lineStyle(1, 0x000000);
					sprite.graphics.drawRect(0, 0, width-1, trueHeight-1);
				}
				else
				{
					sprite.graphics.lineStyle(1, 0x698790);
					sprite.graphics.drawRect(0, 0, width-1, trueHeight-1);
					sprite.graphics.lineStyle(1, 0xFFFFFF);
					sprite.graphics.drawRect(1, 1, width-3, trueHeight-3);
					sprite.graphics.lineStyle(1, 0x696969);
					sprite.graphics.moveTo(2, trueHeight-3);
					sprite.graphics.lineTo(2,2);
					sprite.graphics.lineTo(width-3, 2);
					sprite.graphics.lineStyle(1, 0xE3E3E3);
					sprite.graphics.lineTo(width-3, trueHeight-3);
					sprite.graphics.lineTo(2, trueHeight-3);
				}
			}
		}
		public function displayStrings():void
		{
			var y:int;
			var maxY:int;
			maxY=Math.min(nLines, strings.size());
			for (y=0; y<maxY; y++)
			{
				lineTexts[y].text=String(strings.get(yPos+y));
				lineTexts[y].setTextFormat(textFormat);		
				lineTexts[y].embedFonts=bEmbedFont;
			}
			for (; y<nLines; y++)
			{
				lineTexts[y].text="";
			}
			eraseHilight();
			eraseSelected();
			hilightCurrentLine();
			if (slider!=null)
			{
				slider.setRange(strings.size(), yPos, nLines);
			}
		}
		public function eraseHilight():void
		{
			if (oldHilight>=0)
			{
				if (oldHilight-yPos>=0 && oldHilight-yPos<nLines)
				{
					lineSprites[oldHilight-yPos].graphics.clear();
				}
				oldHilight=-1;
			}
		}
		public function eraseSelected():void
		{
			if (oldSelected>=0)
			{
				if (oldSelected-yPos>=0 && oldSelected-yPos<nLines)
				{
					lineSprites[oldSelected-yPos].graphics.clear();
				}
				if (oldSelected==oldHilight)
				{
					eraseHilight();
				}
				oldSelected=-1;
			}
		}
		public function hilightCurrentLine():void
		{
			var y:int;
			if (yHilight!=oldHilight)
			{
				eraseHilight();
				if (yHilight>=0 && yHilight!=ySelected)
				{
					oldHilight=yHilight;
					y=yHilight-yPos;
					if (y>=0 && y<nLines)
					{
						lineSprites[y].graphics.clear();
						lineSprites[y].graphics.beginFill(HILIGHT_COLOR);
						lineSprites[y].graphics.drawRect(0, 0, sxLine, syLine);
						lineSprites[y].graphics.endFill();
					}
				}
				eraseSelected();
			}
			if (ySelected!=oldSelected)
			{
				eraseSelected();
				if (ySelected>=0)
				{
					oldSelected=ySelected;
					y=ySelected-yPos;
					if (y>=0 && y<nLines)
					{
						lineSprites[y].graphics.clear();
						lineSprites[y].graphics.beginFill(SELECTED_COLOR);
						lineSprites[y].graphics.drawRect(0, 0, sxLine, syLine);
						lineSprites[y].graphics.endFill();
					}
				}
			}
		}
		public function sortStrings():void
		{
			if ((flags&LISTFLAG_SORT)!=0)
			{
				if (strings.size()>1)
				{
					do
					{
						var bCount:int=0;
						var n:int;
						for (n=0; n<strings.size()-1; n++)
						{
							var s1:String=String(strings.get(n));
							var s2:String=String(strings.get(n+1));
							if (compareStrings(s1, s2)>0)
							{
								strings.set(n, s2);
								strings.set(n+1, s1);
								var tmp:int=int(datas.get(n));
								datas.set(n, datas.get(n+1));
								datas.set(n+1, tmp);
								bCount++;
							}
						}
					}while(bCount!=0)
				}
			}
		}
		public function compareStrings(s1:String, s2:String):int
		{
			var s:int=Math.min(s1.length, s2.length);
			var n:int;
			var c1:int, c2:int;
			for (n=0; n<s; n++)
			{
				c1=s1.charCodeAt(n);
				c2=s2.charCodeAt(n);
				if (c1<c2)
				{
					return -1;
				}	
				if (c1>c2)
				{
					return 1;
				}
			}
			if (s1.length<s2.length)
			{
				return -1;
			}
			if (s1.length>s2.length)
			{
				return 1;
			}
			return 0;
		}
		
		public function addString(s:String, display:Boolean=true):void
		{
			strings.add(s);
			datas.add(0);
			sortStrings();
			if (display)
			{
				if ((flags&LISTFLAG_SCROLLTONEWLINE))
				{
					var index:int=strings.size()-1;
					if ((flags&LISTFLAG_SORT)!=0)
					{
						var n:int;
						for (n=0; n<strings.size(); n++)
						{
							var ss:String=String(strings.get(n));
							if (s==ss)
							{
								index=n;
								break;
							}
						}
					}
					ensureIndexIsVisible(index);
				}
				displayStrings();
			}
		} 
		public function insertString(index:int, s:String, display:Boolean=true):void
		{
			strings.insert(index, s);
			datas.insert(index, 0);
			if (ySelected>=index)
			{
				ySelected++;
			} 
			sortStrings();
			if (display)
			{
				if ((flags&LISTFLAG_SCROLLTONEWLINE))
				{
					if ((flags&LISTFLAG_SORT)!=0)
					{
						var n:int;
						for (n=0; n<strings.size(); n++)
						{
							var ss:String=String(strings.get(n));
							if (s==ss)
							{
								index=n;
								break;
							}
						}
					}
					ensureIndexIsVisible(index);
				}
				displayStrings();
			}
		}
		public function setString(index:int, s:String, display:Boolean=true):void
		{
			strings.set(index, s);
			sortStrings();
			if (display)
			{
				displayStrings();
			}
		}
		public function getString(index:int):String
		{
			if (index>=0 && index<strings.size())
			{
				return String(strings.get(index));
			}	
			return "";
		}
		public function setData(index:int, data:int):void
		{
			if (index>=0 && index<datas.size())
			{
				datas.set(index, data);
			}
		}
		public function getData(index:int):int
		{
			if (index>=0 && index<datas.size())
			{
				return int(datas.get(index));
			}
			return 0;
		}
		public function delString(index:int, display:Boolean=true):void
		{
			strings.removeIndex(index);
			datas.removeIndex(index);
			if (ySelected==index)
			{
				ySelected=-1;
			}
			if (ySelected>index)
			{
				ySelected--;
			}
			if (yPos>0)
			{
				if (yPos+nLines>strings.size())
				{
					yPos=strings.size()-nLines;
					if (yPos<0)
					{
						yPos=0;
					}
				}
			}
			if (display)
			{
				displayStrings();
			}
		}
		public function setFont(fi:CFontInfo):void
		{
			font=fi;
			createDisplay();
		}  
		public function setForeground(rgb:int):void
		{
			fontColor=rgb;
			createTextFormat();
			displayStrings();	
		}
	    public function setBackground(rgb:int):void
	    {
			backColor=rgb;
			drawBackground();	    	
	    }
		public function setSize(sx:int, sy:int):void
		{
			width=sx;
			height=sy;
			createDisplay();
		}
		public function reset():void
		{
			eraseHilight();
			eraseSelected();
			strings.clear();
			yPos=0;
			yHilight=-1;
			ySelected=-1;
			displayStrings();
		}
		public function setSelected(index:int):void
		{			
			if (index<0 || index>=strings.size())
			{
				index=-1;
			}
			else
			{
				index=index;
			}
			if (index!=ySelected)
			{
				eraseHilight();
				eraseSelected();
				ySelected=index;
				bSelChanged=true;
				hilightCurrentLine();
			}			
		}
		public function setVisible(b:Boolean):void
		{
			bVisible=b;
			sprite.visible=b;
		}
		public function setEnabled(b:Boolean):void
		{
			if (bEnabled!=b)
			{
				bEnabled=b;
				if (slider!=null)
				{
					slider.setEnabled(b);
				}
				createDisplay();
			}
		}
		public function ensureIndexIsVisible(index:int):void
		{
			if (index>=0 && index<strings.size())
			{
				if (index<yPos)
				{
					eraseHilight();
					eraseSelected();
					yPos=index;
					ySelected=index;
					displayStrings();
					bSelChanged=true;
				}
				else if (index>=yPos+nLines)				
				{
					eraseHilight();
					eraseSelected();
					yPos=index-nLines+1;
					ySelected=index;
					displayStrings();
					bSelChanged=true;	
				}
			}			
		}
		public function findString(search:String, startIndex:int):int
		{
			if (search.length>0)
			{			
		        var tries:int = strings.size();
		        var i:int = startIndex;
		        var subStringLength:int = search.length;
		        while (tries > 0)
		        {
		            tries--;
		            i++;
		            // Wrap around
		            if (i >= strings.size())
		            {
		                i = 0;
		            }
		            var cmp:String = String(strings.get(i));
		            cmp = cmp.substring(0, Math.min(subStringLength, cmp.length));
		            if (cmp==search)
		            {
		                // Found a line
		                return i;
		            }
		        }
		 	}
	        return -1;
		}
		public function findStringExact(search:String, startIndex:int):int
		{
			if (search.length>0)
			{			
		        var tries:int = strings.size();
		        var i:int = startIndex;
		        while (tries > 0)
		        {
		            tries--;
		            i++;
		            // Wrap around
		            if (i >= strings.size())
		            {
		                i = 0;
		            }
		            var cmp:String = String(strings.get(i));
		            if (cmp==search)
		            {
		                // Found a line
		                return i;
		            }
		        }
			}
	        return -1;			
		}
	}
}