//----------------------------------------------------------------------------------
//
// CRUNKCBOXA : Active System Box
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Application.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.CCreateObjectInfo;
	import RunLoop.CRun;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.*;
	import flash.geom.Matrix;
	
	public class CRunKcBoxA extends CRunExtension
	{
		public static var FLAG_HYPERLINK:int = 0x00004000;
		public static var FLAG_CONTAINER:int = 0x00001000;
		public static var FLAG_CONTAINED:int = 0x00002000;
		public static var COLOR_NONE:int = 0xFFFF;
		public static var FLAG_BUTTON_PRESSED:int = 0x10000000;
		public static var FLAG_BUTTON_HIGHLIGHTED:int = 0x20000000;
		public static var FLAG_HIDEIMAGE:int = 0x01000000;
		public static var COLORFLAG_RGB:int= 0;
		public static var FLAG_CHECKED:int = 0;
		public static var COLOR_FLAGS:int = (COLORFLAG_RGB);
		public static var COLOR_BTNFACE:int = 15;
		public static var COLOR_3DLIGHT:int = 22;
		public static var FLAG_BUTTON:int = 0x00100000;
		public static var FLAG_CHECKBOX:int = 0x00200000;
		public static var FLAG_IMAGECHECKBOX:int = 0x00800000;
		public static var FLAG_DISABLED:int = 0x40000000;
		public static var FLAG_FORCECLIPPING:int = 0x02000000;
		public static var ALIGN_IMAGE_TOPLEFT:int = 0x00010000;
		public static var ALIGN_IMAGE_CENTER:int = 0x00020000;
		public static var ALIGN_IMAGE_PATTERN:int = 0x00040000;
		public static var ALIGN_TOP:int = 0x00000001;
		public static var ALIGN_VCENTER:int = 0x00000002;
		public static var ALIGN_BOTTOM:int = 0x00000004;
		public static var ALIGN_LEFT:int = 0x00000010;
		public static var ALIGN_HCENTER:int = 0x00000020;
		public static var ALIGN_RIGHT:int = 0x00000040;
		public static var ALIGN_MULTILINE:int = 0x00000100;
		public static var ALIGN_NOPREFIX:int = 0x00000200;
		public static var ALIGN_ENDELLIPSIS:int = 0x00000400;
		public static var ALIGN_PATHELLIPSIS:int = 0x00000800;
		public static var FLAG_SHOWBUTTONBORDER:int = 0x00400000;
		public static var bSysColorTab:Boolean = false;
		public static var COLOR_GRADIENTINACTIVECAPTION:int = 25;//28;
		public static var sysColorTab:Array;
		public static var DOCK_LEFT:int = 0x00000001;
		public static var DOCK_RIGHT:int = 0x00000002;
		public static var DOCK_TOP:int = 0x00000004;
		public static var DOCK_BOTTOM:int = 0x00000008;
		public static var DOCK_FLAGS:int = (DOCK_LEFT | DOCK_RIGHT | DOCK_TOP | DOCK_BOTTOM);
		public static var PARAMFLAG_SYSTEMCOLOR:int=0;
		public static var TOOLTIP_TODISPLAY:int=0;
		public static var TOOLTIP_DISPLAYED:int=1;
		public static var TOOLTIP_HIDDEN:int=2;
		
		public static var CND_CLICKED:int = 0;
		public static var CND_ENABLED:int = 1;
		public static var CND_CHECKED:int = 2;
		public static var CND_LEFTCLICK:int = 3;
		public static var CND_RIGHTCLICK:int = 4;
		public static var CND_MOUSEOVER:int = 5;
		public static var CND_IMAGESHOWN:int = 6;
		public static var CND_DOCKED:int = 7;
		
		public static var ACT_ACTION_SETDIM:int = 0;
		public static var ACT_ACTION_SETPOS:int = 1;	
		public static var ACT_ACTION_ENABLE:int = 2;
		public static var ACT_ACTION_DISABLE:int = 3;
		public static var ACT_ACTION_CHECK:int = 4;
		public static var ACT_ACTION_UNCHECK:int = 5;	
		public static var ACT_ACTION_SETCOLOR_NONE:int	= 6;
		public static var ACT_ACTION_SETCOLOR_3DDKSHADOW:int = 7;
		public static var ACT_ACTION_SETCOLOR_3DFACE:int = 8;
		public static var ACT_ACTION_SETCOLOR_3DHILIGHT:int = 9;
		public static var ACT_ACTION_SETCOLOR_3DLIGHT:int = 10;
		public static var ACT_ACTION_SETCOLOR_3DSHADOW:int = 11;
		public static var ACT_ACTION_SETCOLOR_ACTIVECAPTION:int = 12;
		public static var ACT_ACTION_SETCOLOR_APPWORKSPACE:int = 13; //mdi
		public static var ACT_ACTION_SETCOLOR_DESKTOP:int = 14;
		public static var ACT_ACTION_SETCOLOR_HIGHLIGHT:int = 15;
		public static var ACT_ACTION_SETCOLOR_INACTIVECAPTION:int = 16;
		public static var ACT_ACTION_SETCOLOR_INFOBK:int = 17;
		public static var ACT_ACTION_SETCOLOR_MENU:int = 18;
		public static var ACT_ACTION_SETCOLOR_SCROLLBAR:int = 19;
		public static var ACT_ACTION_SETCOLOR_WINDOW:int = 20;
		public static var ACT_ACTION_SETCOLOR_WINDOWFRAME:int = 21;	
		public static var ACT_ACTION_SETB1COLOR_NONE:int = 22;
		public static var ACT_ACTION_SETB1COLOR_3DDKSHADOW:int	= 23;
		public static var ACT_ACTION_SETB1COLOR_3DFACE:int = 24;
		public static var ACT_ACTION_SETB1COLOR_3DHILIGHT:int = 25;
		public static var ACT_ACTION_SETB1COLOR_3DLIGHT:int = 26;
		public static var ACT_ACTION_SETB1COLOR_3DSHADOW:int = 27;
		public static var ACT_ACTION_SETB1COLOR_ACTIVEBORDER:int = 28;
		public static var ACT_ACTION_SETB1COLOR_INACTIVEBORDER:int = 29;
		public static var ACT_ACTION_SETB1COLOR_WINDOWFRAME:int = 30;	
		public static var ACT_ACTION_SETB2COLOR_NONE:int = 31;
		public static var ACT_ACTION_SETB2COLOR_3DDKSHADOW:int	= 32;
		public static var ACT_ACTION_SETB2COLOR_3DFACE:int = 33;
		public static var ACT_ACTION_SETB2COLOR_3DHILIGHT:int = 34;
		public static var ACT_ACTION_SETB2COLOR_3DLIGHT:int = 35;
		public static var ACT_ACTION_SETB2COLOR_3DSHADOW:int = 36;
		public static var ACT_ACTION_SETB2COLOR_ACTIVEBORDER:int = 37;
		public static var ACT_ACTION_SETB2COLOR_INACTIVEBORDER:int = 38;
		public static var ACT_ACTION_SETB2COLOR_WINDOWFRAME:int = 39;	
		public static var ACT_ACTION_TEXTCOLOR_NONE:int = 40;
		public static var ACT_ACTION_TEXTCOLOR_3DHILIGHT:int = 41;
		public static var ACT_ACTION_TEXTCOLOR_3DSHADOW:int = 42;
		public static var ACT_ACTION_TEXTCOLOR_BTNTEXT:int = 43;
		public static var ACT_ACTION_TEXTCOLOR_CAPTIONTEXT:int = 44;
		public static var ACT_ACTION_TEXTCOLOR_GRAYTEXT:int = 45;
		public static var ACT_ACTION_TEXTCOLOR_HIGHLIGHTTEXT:int = 46;
		public static var ACT_ACTION_TEXTCOLOR_INACTIVECAPTIONTEXT:int = 47;
		public static var ACT_ACTION_TEXTCOLOR_INFOTEXT:int = 48;
		public static var ACT_ACTION_TEXTCOLOR_MENUTEXT:int = 49;
		public static var ACT_ACTION_TEXTCOLOR_WINDOWTEXT:int = 50;	
		public static var ACT_ACTION_SETCOLOR_OTHER:int = 51;
		public static var ACT_ACTION_SETB1COLOR_OTHER:int = 52;
		public static var ACT_ACTION_SETB2COLOR_OTHER:int = 53;
		public static var ACT_ACTION_TEXTCOLOR_OTHER:int = 54;	
		public static var ACT_ACTION_SETTEXT:int = 55;
		public static var ACT_ACTION_SETTOOLTIPTEXT:int = 56;	
		public static var ACT_ACTION_UNDOCK:int = 57;
		public static var ACT_ACTION_DOCK_LEFT:int = 58;
		public static var ACT_ACTION_DOCK_RIGHT:int = 59;
		public static var ACT_ACTION_DOCK_TOP:int = 60;
		public static var ACT_ACTION_DOCK_BOTTOM:int = 61;	
		public static var ACT_ACTION_SHOWIMAGE:int = 62;
		public static var ACT_ACTION_HIDEIMAGE:int = 63;	
		public static var ACT_ACTION_RESETCLICKSTATE:int = 64;	
		public static var ACT_ACTION_HYPERLINKCOLOR_NONE:int = 65;
		public static var ACT_ACTION_HYPERLINKCOLOR_3DHILIGHT:int = 66;
		public static var ACT_ACTION_HYPERLINKCOLOR_3DSHADOW:int = 67;
		public static var ACT_ACTION_HYPERLINKCOLOR_BTNTEXT:int = 68;
		public static var ACT_ACTION_HYPERLINKCOLOR_CAPTIONTEXT:int = 69;
		public static var ACT_ACTION_HYPERLINKCOLOR_GRAYTEXT:int = 70;
		public static var ACT_ACTION_HYPERLINKCOLOR_HIGHLIGHTTEXT:int = 71;
		public static var ACT_ACTION_HYPERLINKCOLOR_INACTIVECAPTIONTEXT:int = 72;
		public static var ACT_ACTION_HYPERLINKCOLOR_INFOTEXT:int = 73;
		public static var ACT_ACTION_HYPERLINKCOLOR_MENUTEXT:int = 74;
		public static var ACT_ACTION_HYPERLINKCOLOR_WINDOWTEXT:int = 75;
		public static var ACT_ACTION_HYPERLINKCOLOR_OTHER:int = 76;	
		public static var ACT_ACTION_SETCMDID:int = 77;
		
		public static var EXP_COLOR_BACKGROUND:int = 0;
		public static var EXP_COLOR_BORDER1:int = 1;
		public static var EXP_COLOR_BORDER2:int = 2;
		public static var EXP_COLOR_TEXT:int = 3;	
		public static var EXP_COLOR_3DDKSHADOW:int = 4;
		public static var EXP_COLOR_3DFACE:int = 5;
		public static var EXP_COLOR_3DHILIGHT:int = 6;
		public static var EXP_COLOR_3DLIGHT:int = 7;
		public static var EXP_COLOR_3DSHADOW:int = 8;
		public static var EXP_COLOR_ACTIVEBORDER:int = 9;
		public static var EXP_COLOR_ACTIVECAPTION:int = 10;
		public static var EXP_COLOR_APPWORKSPACE:int = 11;
		public static var EXP_COLOR_DESKTOP:int = 12;
		public static var EXP_COLOR_BTNTEXT:int = 13;
		public static var EXP_COLOR_CAPTIONTEXT:int = 14;
		public static var EXP_COLOR_GRAYTEXT:int = 15;
		public static var EXP_COLOR_HIGHLIGHT:int = 16;
		public static var EXP_COLOR_HIGHLIGHTTEXT:int = 17;
		public static var EXP_COLOR_INACTIVEBORDER:int = 18;
		public static var EXP_COLOR_INACTIVECAPTION:int = 19;
		public static var EXP_COLOR_INACTIVECAPTIONTEXT:int = 20;
		public static var EXP_COLOR_INFOBK:int = 21;
		public static var EXP_COLOR_INFOTEXT:int = 22;
		public static var EXP_COLOR_MENU:int = 23;
		public static var EXP_COLOR_MENUTEXT:int = 24;
		public static var EXP_COLOR_SCROLLBAR:int = 25;
		public static var EXP_COLOR_WINDOW:int = 26;
		public static var EXP_COLOR_WINDOWFRAME:int = 27;
		public static var EXP_COLOR_WINDOWTEXT:int = 28;
		public static var EXP_GETTEXT:int = 29;
		public static var EXP_GETTOOLTIPTEXT:int = 30;
		public static var EXP_GETWIDTH:int = 31;
		public static var EXP_GETHEIGHT:int = 32;
		public static var EXP_COLOR_HYPERLINK:int = 33;
		public static var EXP_GETX:int = 34;
		public static var EXP_GETY:int = 35;
		public static var EXP_SYSTORGB:int = 36;
		
		public var wFont:CFontInfo;
		public var wUnderlinedFont:CFontInfo;
		public var dwRtFlags:int;
		public var pText:String;
		public var pToolTip:String;
		public var rNumInObjList:int;		// Index of this object in objects list
		public var rNumInContList:int;		// Index of this object in container list
		public var rContNum:int;			// Index of the container of this object in container list
		public var rContDx:int;			// Coordinates
		public var rContDy:int;
		public var rNumInBtnList:int;		// Index of this object in button list
		public var rClickCount:int;
		public var rLeftClickCount:int;
		public var rRightClickCount:int;
		public var sprite:Sprite;
		public var textField:TextField;
		public var bitmap:Bitmap;
		public var plane:Sprite;
		public var pLayer:CLayer;
		
		public var rData1_dwVersion:int;
		public var rData1_dwUnderlinedColor:int;
		public var rData_dwFlags:int;
		public var rData_fillColor:int;
		public var rData_borderColor1:int;
		public var rData_borderColor2:int;
		public var rData_wImage:CImage;
		public var rData_wFree:int;
		public var rData_textColor:int;
		public var rData_textMarginLeft:int;
		public var rData_textMarginTop:int;
		public var rData_textMarginRight:int;
		public var rData_textMarginBottom:int;
		public var oldKMouse:int;
		public var toolTip:Sprite;
		public var sxToolTip:int;
		public var syToolTip:int;
		public var toolTipStatus:int;
		public var toolTipTime:int;
		public var oldToolTipZone:int;
		
		public function CRunKcBoxA()
		{
		}
		
		public override function getNumberOfConditions():int
		{
			return 8;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			var fprh:CRun = ho.hoAdRunHeader;
			
			// Setup
			COLORFLAG_RGB=1<<31;
			FLAG_CHECKED=1<<31;
			PARAMFLAG_SYSTEMCOLOR=1<<31;
			
			// Get FrameData        
			var pData:CRunKcBoxAFrameData = null;
			var pExtData:CExtStorage = fprh.getStorage(ho.hoIdentifier);
			if (pExtData == null)
			{
				pData = new CRunKcBoxAFrameData();
				fprh.addStorage(pData, ho.hoIdentifier);
			}
			else
			{
				pData = CRunKcBoxAFrameData(pExtData);
			}
			
			// Set up parameters
			ho.setX(cob.cobX);
			ho.setY(cob.cobY);
			ho.setWidth(file.readShort());
			ho.setHeight(file.readShort());
			
			// Copy CDATA (memcpy(&rdPtr->rData, &edPtr->eData, sizeof(CDATA));)
			rData_dwFlags = file.readInt();
			rData_fillColor = file.readInt();
			rData_borderColor1 = file.readInt();
			rData_borderColor2 = file.readInt();
			
			//file.skipBytes(2);
			var imageList:Array = new Array(1);
			imageList[0] = file.readShort();
			if (imageList[0] != -1)
			{
				ho.loadImageList(imageList);
				rData_wImage = ho.getImage(imageList[0]);
			}
			
			rData_wFree = file.readShort();
			rData_textColor = file.readInt();
			rData_textMarginLeft = file.readShort();
			rData_textMarginTop = file.readShort();
			rData_textMarginRight = file.readShort();
			rData_textMarginBottom = file.readShort();
			
			// Init font
			wFont = new CFontInfo();
			wUnderlinedFont = new CFontInfo();
			
			var textLf:CFontInfo;
			if (ho.hoAdRunHeader.rhApp.bUnicode==false)
			{
				textLf = file.readLogFont16();
			}
			else
			{
				textLf = file.readLogFont();
			}
			if (textLf.lfFaceName != null)
			{
				wFont = textLf;//this.wFont.font = textLf.createFont();
				if ((rData_dwFlags & FLAG_HYPERLINK) != 0)
				{
					wUnderlinedFont.copy(textLf);
					wUnderlinedFont.lfUnderline = 1;
				}
			}
			
			// Copy text
			dwRtFlags = 0;
			pText = "";
			pToolTip = "";
			file.readStringSize(40);
			file.adjustTo8();
			var textSize:int = file.readInt();
			if (ho.hoAdRunHeader.rhApp.bUnicode)
			{
				textSize/=2;
			}
			if (textSize != 0)
			{
				// Extract tool tip
				var lText:String = file.readStringSize(textSize);//file.readString();
				textSize=lText.length;
				var i:int;
				for (i = textSize; i > 1; i--)
				{
					if ((lText.charAt(i - 1) == "n") && (lText.charAt(i - 2) == "\\"))
					{
						var toolTipSize:int = textSize - i;
						textSize = textSize - toolTipSize - 2;
						if (toolTipSize != 0)
						{
							this.pToolTip=lText.substring(i);
						}
						lText = lText.substring(0, textSize);
						break;
					}
				}
				if (textSize != 0)
				{
					pText = lText;
					var n:int;
					for (n=0; n<pText.length; n++)
					{
						if (pText.charCodeAt(n)==10)
						{
							pText=pText.substring(0, n)+pText.substring(n+1);
							n--;
						}	
					}				
				}
			}
			
			// Add to global list of objects
			rNumInObjList = pData.AddObject(this); //up to here
			
			// Container?
			rNumInContList = -1;
			if ((rData_dwFlags & FLAG_CONTAINER) != 0)
			{
				rNumInContList = pData.AddContainer(this);
			}
			
			// Contained?
			rContNum = -1;
			if ((rData_dwFlags & FLAG_CONTAINED) != 0)
			{
				rContNum = pData.GetContainer(this);
				if (this.rContNum != -1)
				{
					var rdPtrCont:CRunKcBoxA = CRunKcBoxA(pData.pContainers.get(this.rContNum));
					rContDx = (ho.getX() - rdPtrCont.ho.getX());
					rContDy = (ho.getY() - rdPtrCont.ho.getY());
				}
			}
			rData1_dwVersion = file.readInt();
			rData1_dwUnderlinedColor = file.readInt();
			
			// Button?
			rNumInBtnList = -1;
			rClickCount = -1;
			rLeftClickCount = -1;
			rRightClickCount = -1;
			if ((rData_dwFlags & (FLAG_BUTTON | FLAG_HYPERLINK)) != 0)
			{
				rNumInBtnList = pData.AddButton(this);
			}
			
			fprh.delStorage(ho.hoIdentifier);
			fprh.addStorage(pData, ho.hoIdentifier);
			
			oldKMouse=0;
			
			sprite=new Sprite();
			textField=new TextField();
			textField.selectable=false;
			textField.mouseEnabled=false;
			bitmap=new Bitmap();
			pLayer=rh.rhFrame.layers[ho.hoLayer];
			plane=pLayer.planeSprites;
			plane.addChild(sprite);
			sprite.addChild(bitmap);
			sprite.addChild(textField);
			createToolTip();
			if ((ho.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)!=0)
			{
				sprite.visible=false;
			}
			if ((rData_dwFlags & FLAG_HYPERLINK) != 0)
			{
				sprite.buttonMode=true;
				sprite.useHandCursor=true;
			}
			return false;
		}
		
		public override function destroyRunObject(bFast:Boolean):void
		{
			var rhPtr:CRun = this.ho.hoAdRunHeader;
			
			plane.removeChild(sprite);
			if (toolTip!=null)
			{
				plane.removeChild(toolTip);
			}
			
			// Get FrameData
			var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
			
			// Container?
			if ((rNumInContList != -1) && (pData != null))
			{
				pData.RemoveContainer(this);
			}
			
			// Remove from global list of objects
			if ((rNumInObjList != -1) && (pData != null))
			{
				pData.RemoveObjectFromList(this);
			}
			rhPtr.delStorage(ho.hoIdentifier);
			if (pData.IsEmpty() == false)
			{
				rhPtr.addStorage(pData, ho.hoIdentifier);
			}	
		}
		
		public function mouseClicked():void
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
			if (pData != null)
			{
				if ((this.rData_dwFlags & FLAG_DISABLED) == 0)
				{
					if (this.rNumInObjList == pData.GetObjectFromList(rh.rh2MouseX-rh.rhWindowX, rh.rh2MouseY-rh.rhWindowY))
					{
						this.rClickCount = ho.getEventCount();
						ho.pushEvent(CND_CLICKED, ho.getEventParam());
						if (toolTip!=null)
						{
							toolTip.visible=false;
							toolTipStatus=TOOLTIP_HIDDEN;
						}								
					}
				}
			}
		}
		
		public function mousePressed():void
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
			if (pData != null)
			{
				if ((this.rData_dwFlags & FLAG_DISABLED) == 0)
				{
					if (this.rNumInObjList == pData.GetObjectFromList(rh.rh2MouseX-rh.rhWindowX, rh.rh2MouseY-rh.rhWindowY))
					{
						if ((this.rData_dwFlags & FLAG_BUTTON) != 0)//is a button
						{
							this.rData_dwFlags |= FLAG_BUTTON_PRESSED;
							if ((this.rData_dwFlags & FLAG_CHECKBOX) != 0)//is a checkbox
							{
								if ((this.rData_dwFlags & FLAG_CHECKED) != 0) //is checked
								{
									this.rData_dwFlags &= ~FLAG_CHECKED;
								}
								else
								{
									this.rData_dwFlags |= FLAG_CHECKED;
								}
							}
						}
						if ((this.rData_dwFlags & FLAG_HYPERLINK) != 0) //if hyperlink
						{
							if ((this.rData_dwFlags & FLAG_BUTTON_HIGHLIGHTED) == 0)
							{
								this.rData_dwFlags |= FLAG_BUTTON_HIGHLIGHTED;
							}
						}
						this.rLeftClickCount = ho.getEventCount();
						ho.pushEvent(CND_LEFTCLICK, ho.getEventParam());
						ho.redraw();
					}
				}
			}
		}
		
		public function mouseReleased():void
		{
			var redraw:Boolean = false;
			if ((this.rData_dwFlags & FLAG_BUTTON_PRESSED) != 0)
			{
				this.rData_dwFlags &= ~FLAG_BUTTON_PRESSED;
				redraw = true;
			}
			if ((this.rData_dwFlags & FLAG_BUTTON_HIGHLIGHTED) != 0)
			{
				this.rData_dwFlags &= ~FLAG_BUTTON_HIGHLIGHTED;
				redraw = true;
			}
			if (redraw == true)
			{
				ho.redraw();
			}
		}
		
		public function createToolTip():void
		{
			if (toolTip!=null)
			{
				plane.removeChild(toolTip);
				toolTip=null;
				return;									
			}
			if (pToolTip!=null && pToolTip.length!=0)			
			{
				toolTip=new Sprite();
				plane.addChild(toolTip);
				
				var tf:TextFormat=new TextFormat();
				tf.align=TextFormatAlign.LEFT;
				tf.color=0x000000;
				tf.font="Arial";
				tf.size=12;
				
				var toolTextField:TextField=new TextField();
				toolTextField.text=pToolTip;
				toolTextField.setTextFormat(tf);
				toolTip.addChild(toolTextField);
				toolTextField.x=3;
				toolTextField.y=1;
				sxToolTip=toolTextField.textWidth+8;
				syToolTip=toolTextField.textHeight+4;
				toolTextField.width=sxToolTip;
				toolTextField.height=syToolTip;
				
				toolTip.graphics.clear();
				toolTip.graphics.lineStyle(1, 0x000000);
				toolTip.graphics.drawRect(0, 0, sxToolTip, syToolTip);
				toolTip.graphics.lineStyle(1, 0xDBFFD3);
				toolTip.graphics.beginFill(0xDBFFD3);
				toolTip.graphics.drawRect(1, 1, sxToolTip-2, syToolTip-2);
				toolTip.graphics.endFill();
				
				toolTip.visible=false;
			}
		}
		
		public override function handleRunObject():int
		{
			var rhPtr:CRun = this.ho.hoAdRunHeader;

			sprite.x=ho.hoX-rhPtr.rhWindowX;
			sprite.y=ho.hoY-rhPtr.rhWindowY;
			
			// Gestion touches souris
			var kMouse:int=rhPtr.rhApp.keyBuffer[260];
			if (kMouse!=oldKMouse)
			{
				oldKMouse=kMouse;
				if (kMouse!=0)
				{
					mousePressed();
				}
				else
				{
					mouseClicked();
					mouseReleased();
				}
			}
			
			var time:int;
			var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
			if (toolTip!=null)
			{					
				pData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
				if (pData != null)
				{
					if ((this.rData_dwFlags & FLAG_DISABLED) == 0)
					{
						if (this.rNumInObjList == pData.GetObjectFromList(rhPtr.rh2MouseX, rhPtr.rh2MouseY))
						{
							if (oldToolTipZone<0)
							{
								oldToolTipZone=0;
								toolTipTime=getTimer();
								toolTipStatus=TOOLTIP_TODISPLAY;							
							}
							switch (toolTipStatus)
							{
								case TOOLTIP_TODISPLAY:
									time=getTimer();
									if (time-toolTipTime>=1000)
									{
										toolTip.visible=true;								
										toolTip.x=ho.hoAdRunHeader.rh2MouseX+16;
										toolTip.y=ho.hoAdRunHeader.rh2MouseY+16;
										if (toolTip.x+sxToolTip>ho.hoAdRunHeader.rhApp.gaCxWin)
										{
											toolTip.x=ho.hoAdRunHeader.rh2MouseX-sxToolTip;
										}
										if (toolTip.y+syToolTip>ho.hoAdRunHeader.rhApp.gaCyWin)
										{
											toolTip.y=ho.hoAdRunHeader.rh2MouseY-syToolTip-16;
										}
										toolTipTime=time;
										toolTipStatus=TOOLTIP_DISPLAYED;
									}
									break;
								case TOOLTIP_DISPLAYED:
									time=getTimer();
									if (time-toolTipTime>4000)
									{
										toolTip.visible=false;
										toolTipStatus=TOOLTIP_HIDDEN;								
									}							
									break;
								case TOOLTIP_HIDDEN:
									break;
							}
						}
						else
						{
							if (oldToolTipZone>=0)
							{
								oldToolTipZone=-1;
								toolTip.visible=false;
							}
						}
					}
				}
			}
			
			var oldX:int = ho.getX();
			var oldY:int = ho.getY();
			var newX:int = oldX;
			var newY:int = oldY;
			var reCode:int = 0;
			
			if (pData != null)
			{
				var bActive:Boolean = true;
				if (bActive == true)
				{
					if (((this.rData_dwFlags & FLAG_BUTTON) != 0) || ((this.rData_dwFlags & FLAG_HYPERLINK) != 0)) //15th april 09 change
					{
						if ((this.rData_dwFlags & FLAG_DISABLED) == 0)
						{
							if (this.rNumInObjList == pData.GetObjectFromList(rh.rh2MouseX, rh.rh2MouseY))
							{
								if ((this.rData_dwFlags & FLAG_BUTTON_HIGHLIGHTED) == 0)
								{
									this.rData_dwFlags |= FLAG_BUTTON_HIGHLIGHTED;
								}
							}
							else
							{
								if ((this.rData_dwFlags & FLAG_BUTTON_HIGHLIGHTED) != 0)
								{
									this.rData_dwFlags &= ~FLAG_BUTTON_HIGHLIGHTED;
								}
							}
							reCode = REFLAG_DISPLAY;
						}
					}
				}
			}
			
			// Docking
			if ((this.dwRtFlags & DOCK_FLAGS) != 0 && (this.rData_dwFlags & FLAG_CONTAINED) == 0)
			{
				var windowWidth:int = rhPtr.rhApp.gaCxWin;
				var windowHeight:int = rhPtr.rhApp.gaCyWin;
				var x:int = 0;
				var y:int = 0;
				var w:int = rhPtr.rhApp.gaCxWin;
				var h:int = rhPtr.rhApp.gaCyWin;
				// Dock
				if ((this.dwRtFlags & DOCK_LEFT) != 0)
				{
					if (windowWidth > w)
					{
						newX = rh.rhFrame.leX + Math.abs(x) - (windowWidth - w) / 2;
					}
					else
					{
						newX = rh.rhFrame.leX + Math.abs(x);
					}
				}
				if ((this.dwRtFlags & DOCK_RIGHT) != 0)
				{
					if (windowWidth > w)
					{
						newX = rh.rhFrame.leX + Math.abs(x) + w - ho.getWidth() - (windowWidth - w) / 2;
					}
					else
					{
						newX = rh.rhFrame.leX + Math.abs(x) + w - ho.getWidth();
					}
				}
				if ((this.dwRtFlags & DOCK_TOP) != 0)
				{
					if (windowHeight > h)
					{
						newY = rh.rhFrame.leY + Math.abs(y) - (windowHeight - h) / 2;
					}
					else
					{
						newY = rh.rhFrame.leY + Math.abs(y);
					}
				}
				if ((this.dwRtFlags & DOCK_BOTTOM) != 0)
				{
					if (windowHeight > h)
					{
						newY = rh.rhFrame.leY + Math.abs(y) + h - ho.getHeight() - (windowHeight - h) / 2;
					}
					else
					{
						newY = rh.rhFrame.leY - Math.abs(y) + h - ho.getHeight(); //requires - here for some reason.
					}
				}
			}
			
			var rdPtrCont:CRunKcBoxA;
			// Contained ? must update coordinates
			if ((this.rData_dwFlags & FLAG_CONTAINED) != 0)
			{
				// Not yet a container? search Medor, search!
				if (this.rContNum == -1)
				{
					if (pData != null)
					{
						this.rContNum = pData.GetContainer(this);
						if (this.rContNum != -1)
						{
							rdPtrCont = CRunKcBoxA(pData.pContainers.get(this.rContNum));
							this.rContDx = (ho.getX() - rdPtrCont.ho.getX());
							this.rContDy = (ho.getY() - rdPtrCont.ho.getY());
						}
					}
				}
				
				if ((this.rContNum != -1) && (pData != null) && (this.rContNum < pData.pContainers.size()))
				{
					rdPtrCont = CRunKcBoxA(pData.pContainers.get(this.rContNum));
					if (rdPtrCont != null)
					{
						newX = rdPtrCont.ho.getX() + this.rContDx;
						newY = rdPtrCont.ho.getY() + this.rContDy;
					}
				}
			}
			
			if ((newX != oldX) || (newY != oldY))
			{
				ho.setX(newX);
				ho.setY(newY);
				
				// Update tooltip position
				//UpdateToolTipRect(rdPtr);
				
				reCode = REFLAG_DISPLAY;
			}
			
			// Moved by Set X/Y Coordinate function? Update tooltip position
			//        if (((this.ttX != -1) && (this.ttY != -1)) && 
			//            ((this.ttX != ho.getX() - rhPtr.rhWindowX) || (this.ttY != ho.getY() - rhPtr.rhWindowY)))
			//        {
			//            UpdateToolTipRect(rdPtr);
			//        }
			
			return reCode;	// REFLAG_ONESHOT+REFLAG_DISPLAY;	
		}
		
		public override function displayRunObject():void
		{
			// Get rhPtr
			var rhPtr:CRun = ho.hoAdRunHeader;
			
			var rc:CRect = new CRect();
			
			rc.left = 0;
			rc.top = 0;
			rc.right = ho.hoImgWidth;
			rc.bottom = ho.hoImgHeight;
			
			var hFn:CFontInfo=this.wFont;
			if ((this.pText.length!=0) && (this.rData_textColor!=COLOR_NONE))
			{
				if (((this.rData_dwFlags & FLAG_HYPERLINK) != 0) && (this.wUnderlinedFont != null))
				{
					if ((this.rData_dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED)) != 0)
					{
						hFn = this.wUnderlinedFont;//.font;
					}
				}
			}
			DisplayObject(ho.hoAdRunHeader.rhApp, rc, this.pText, hFn);
		}
		
		public function BuildSysColorTable():void
		{
			sysColorTab = new Array(COLOR_GRADIENTINACTIVECAPTION);
			sysColorTab[0] = 0xc8c8c8;
			sysColorTab[1] = 0x000000;
			sysColorTab[2] = 0x99b4d1;
			sysColorTab[3] = 0xbfcddb;//SystemColor.activeCaptionBorder;
			sysColorTab[4] = 0xf0f0f0;
			sysColorTab[5] = 0xffffff;
			sysColorTab[6] = 0x646464;//SystemColor.inactiveCaptionBorder;
			sysColorTab[7] = 0x000000;
			sysColorTab[8] = 0x000000;
			sysColorTab[9] = 0x000000;
			sysColorTab[10] = 0xb4b4b4;//new
			sysColorTab[11] = 0xf4f7fc;//new
			sysColorTab[12] = 0xababab;//mdi one, doesn't quite match. There is no java mdi background colour./ AppWorksapce
			sysColorTab[13] = 0x3399ff;//SystemColor.textText;
			sysColorTab[14] = 0xffffff; //new //SystemColor.textHighlight;
			sysColorTab[15] = 0xf0f0f0;//SystemColor.textHighlightText;
			sysColorTab[16] = 0xa0a0a0;//SystemColor.textInactiveText;
			sysColorTab[17] = 0x808080;
			sysColorTab[18] = 0x000000;
			sysColorTab[19] = 0x434e54;
			sysColorTab[20] = 0xffffff;
			sysColorTab[21] = 0x696969;
			sysColorTab[22] = 0xe3e3e3;
			sysColorTab[23] = 0x000000;
			sysColorTab[24] = 0xffffe1;
		}
		
		public function myGetSysColor(colorIndex:int):int
		{
			// Build table
			if (!bSysColorTab)
			{
				BuildSysColorTable();
				bSysColorTab = true;
			}
			
			// Get color
			if (colorIndex < COLOR_GRADIENTINACTIVECAPTION)
			{
				return sysColorTab[colorIndex];
			}
			
			// Unknown color
			//return GetSysColor(colorIndex);
			return 0;
		}
		
		public function fromC(c:int):int //convert from c++ colour to java
		{
			var r:int = c&0x0000FF;
			var g:int = (c&0x00FF00)>>8;
			var b:int = (c&0xFF0000)>>16;
			return (r<<16)|(g<<8)|b;
		}
		
		public function DisplayObject(idApp:CRunApp, rc:CRect, pText:String, hFnt:CFontInfo):void
		{
			var x:int = rc.left;
			var y:int = rc.top;
			var w:int = rc.right - rc.left;
			var h:int = rc.bottom - rc.top;
			
			sprite.graphics.clear();
			
			// Background
			var color:int;
			if (rData_fillColor != COLOR_NONE)
			{
				var clr:int = rData_fillColor;
				if ((clr & COLORFLAG_RGB) != 0)
				{
					color = clr & ~COLOR_FLAGS;
					color = fromC(color);
				}
				else
				{
					if (((rData_dwFlags & FLAG_CHECKED) != 0) && (clr == COLOR_BTNFACE))
					{
						clr = COLOR_3DLIGHT;
					}
					color = myGetSysColor(clr);
				}
				sprite.graphics.beginFill(color);
				sprite.graphics.drawRect(x, y, w, h);
				sprite.graphics.endFill();
			}
			
			// Image
			if ((rData_wImage != null))
			{
				if (((rData_dwFlags & FLAG_HIDEIMAGE) == 0))
				{
					var bDisplayImage:Boolean = true;
					if ((rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) == (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
					{
						if ((rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) == 0)
						{
							bDisplayImage = false;
						}
					}
					if (bDisplayImage == true)
					{
						
						//                BlitOp bop = BOP_COPY;
						//                long dwParam = 0L;
						//                if ( (pc.dwFlags & FLAG_DISABLED) != 0)
						//                {
						//                    bop = BOP_BLEND;
						//                    dwParam = 70;
						//                }
						
						var dx:int=0, dy:int=0;
						var xc:int, yc:int, wc:int, hc:int;
						if ((rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
							(rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
						{
							x += 2;
							y += 2;
							dx+=2;
							dy+=2;
						}
						
						xc = x;
						wc = w;
						yc = y;
						hc = h;
						
						if ((rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
							(rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
						{
							wc -= 2;
							hc -= 2;
						}
						
						if (wc > 0 && hc > 0)
						{
							if ((rData_dwFlags & ALIGN_IMAGE_TOPLEFT) != 0)
							{
								bitmap.visible=true;
								bitmap.bitmapData=this.rData_wImage.img;
								bitmap.x=x;
								bitmap.y=y;
							}
							else if ((rData_dwFlags & ALIGN_IMAGE_CENTER) != 0)
							{
								bitmap.visible=true;
								bitmap.bitmapData=this.rData_wImage.img;
								bitmap.x=x + (w - this.rData_wImage.width) / 2;
								bitmap.y=y + (h - this.rData_wImage.height) / 2;
							}
							else if ((rData_dwFlags & ALIGN_IMAGE_PATTERN) != 0)
							{
								bitmap.visible=false;
								if (dx!=0)
								{
									var matrix:Matrix;
									matrix = new Matrix(); 
									matrix.translate(2, 2);
									sprite.graphics.beginBitmapFill(rData_wImage.img, matrix);
								}
								else
								{
									sprite.graphics.beginBitmapFill(rData_wImage.img);
								}
								sprite.graphics.drawRect(dx, dy, wc, hc);
								sprite.graphics.endFill();
							}
						}
						
						rData_dwFlags &= ~FLAG_FORCECLIPPING;
						
						if ((rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
							(rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
						{
							x -= 2;
							y -= 2;
						}
					}
				}
				else
				{
					if (bitmap!=null)
					{
						bitmap.visible=false;
					}
				}
			}
			
			// Text
			if ((pText.length != 0) && (rData_textColor != COLOR_NONE))
			{
				var textLocation:CRect = new CRect();
				textLocation.left = rc.left + rData_textMarginLeft;
				textLocation.top = rc.top + rData_textMarginTop;
				textLocation.right = rc.right - rData_textMarginRight;
				textLocation.bottom = rc.bottom - rData_textMarginBottom;
				
				if ((rData_dwFlags & FLAG_BUTTON) != 0 &&
					(rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
					(rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
				{
					textLocation.left += 2;
					textLocation.top += 2;
				}
				
				if ((rData_dwFlags & FLAG_DISABLED) != 0)
				{
					clr = myGetSysColor(20);		// SystemColor.controlLtHighlight;
					textLocation.left++;
					textLocation.top++;
					textLocation.right++;
					textLocation.bottom++;
					drawText(pText, textLocation, hFnt, rData_dwFlags, false, clr);
					/*	                //ps->DrawText(pText, -1, rc, dtFlags, clr, hFnt);
					clr = mySysGetColor[16];		// SystemColor.controlShadow;
					textLocation.left--;
					textLocation.top--;
					textLocation.right--;
					textLocation.bottom--;
					g2.setColor(clr);
					drawText(pText, textLocation, rData_dwFlags, false, clr);
					*/
				}
				else
				{
					clr = rData_textColor;
					var hyperlink:Boolean = false;
					if ((rData_dwFlags & FLAG_HYPERLINK) != 0)
					{
						if ((rData_dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED)) != 0)
						{
							clr = rData1_dwUnderlinedColor;		// COLORFLAG_RGB | 0x0000FF;
							hyperlink = true;
						}
					}
					
					if ((clr & COLORFLAG_RGB) != 0)
					{
						clr &= ~COLOR_FLAGS;
						clr = fromC(clr);
					}
					else
					{
						clr = myGetSysColor(clr);
					}
					drawText(pText, textLocation, hFnt, rData_dwFlags, hyperlink, clr);
				}
			}
			
			// Border
			var color1:int = rData_borderColor1;
			var color2:int = rData_borderColor2;
			var bDisplayBorder:Boolean = true;
			if ((rData_dwFlags & FLAG_BUTTON) != 0)
			{
				if ((rData_dwFlags & FLAG_SHOWBUTTONBORDER) == 0)
				{
					bDisplayBorder = ((rData_dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0);
				}
				if ((rData_dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
					(rData_dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
				{
					color1 = rData_borderColor2;
					color2 = rData_borderColor1;
				}
			}
			if (bDisplayBorder == true)
			{
				if (color1 != COLOR_NONE)
				{
					if ((color1 & COLORFLAG_RGB) != 0)
					{
						color1 &= ~COLOR_FLAGS;
						color1 = fromC(color1);
					}
					else
					{
						color1 = myGetSysColor(color1);
					}
					sprite.graphics.lineStyle(1, color1);
					sprite.graphics.moveTo(x, y);
					sprite.graphics.lineTo(x + w - 1, y);
					sprite.graphics.moveTo(x, y);
					sprite.graphics.lineTo(x, y + h - 1);
				}
				if (color2 != COLOR_NONE)
				{
					if ((color2 & COLORFLAG_RGB) != 0)
					{
						color2 &= ~COLOR_FLAGS;
						color2 = fromC(color2);
					}
					else
					{
						color2 = myGetSysColor(color2);
					}
					sprite.graphics.lineStyle(1, color2);
					sprite.graphics.moveTo(x, y + h - 1);
					sprite.graphics.lineTo(x + w - 1, y + h - 1);
					sprite.graphics.moveTo(x + w - 1, y);
					sprite.graphics.lineTo(x + w - 1, y + h - 1);
				}
			}
		}
		
		public function drawText(text:String, textLocation:CRect, font:CFontInfo, flags:int, hyperlink:Boolean, clr:int):void
		{
			var textFormat:TextFormat=font.getTextFormat();
			textFormat.color=clr;
			
			textField.x=textLocation.left;
			textField.width=textLocation.right-textLocation.left;
			if ( (rData_dwFlags & ALIGN_LEFT)!=0 )
			{
				textFormat.align=TextFormatAlign.LEFT;
			}
			if ( (rData_dwFlags & ALIGN_HCENTER)!=0 )
			{
				textFormat.align=TextFormatAlign.CENTER;
			}
			if ( (rData_dwFlags & ALIGN_RIGHT)!=0 )
			{
				textFormat.align=TextFormatAlign.RIGHT;
			}
			
			if ( (rData_dwFlags & ALIGN_MULTILINE) == 0 )
			{
				textField.multiline=false;
				textField.wordWrap=false;
			}
			else
			{
				textField.multiline=true;
				textField.wordWrap=true;
			}
			
			if ( (rData_dwFlags & ALIGN_NOPREFIX)==0 )
			{
				var n:int;
				var temp:String;
				for (n=0; n<text.length; n++)
				{
					if (text.charAt(n)=="&")
					{
						temp=text.substring(0, n)+text.substring(n+1);
						if (temp.length>n && temp.charAt(n)=="&")
						{
							n++;
						}
						text=temp;
					}	
				}				
			} 
			
			var sy:int=textLocation.bottom-textLocation.top;
			textField.height=sy+4;
			textField.text=text;
			textField.setTextFormat(textFormat);		
			textField.y=textLocation.top;
			var syText:int=textField.textHeight+4;
			if ( (rData_dwFlags & ALIGN_VCENTER)!=0 )
			{
				textField.y=textLocation.top+sy/2-syText/2;
			}
			if ( (rData_dwFlags & ALIGN_BOTTOM)!=0 )
			{
				textField.y=textLocation.top+sy-syText;
			}
		}
		
		public override function setHandCursor(bOn:Boolean):void
		{
			sprite.buttonMode=bOn;
			sprite.useHandCursor=bOn;
		}
		
		public override function getRunObjectFont():CFontInfo
		{
			return this.wFont;
		}
		
		public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			this.wFont = fi;
			if ((this.rData_dwFlags & FLAG_HYPERLINK) != 0)
			{
				fi.lfUnderline = 1;
				this.wUnderlinedFont = fi;
			}
			
			if (rc != null)
			{
				ho.setWidth(rc.right);
				ho.setHeight(rc.bottom);
			}
			ho.redraw();
		}
		
		public override function getRunObjectTextColor():int
		{
			var clr:int = this.rData_textColor;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr&=~COLORFLAG_RGB;
				return CServices.swapRGB(clr);
			}
			return myGetSysColor(clr);
		}
		
		public override function setRunObjectTextColor(rgb:int):void
		{
			this.rData_textColor = CServices.swapRGB(rgb)|COLORFLAG_RGB;
			ho.redraw();
		}
		
		// Hide and show
		// -------------
		public override function showSprite():void
		{
			sprite.visible=true;
		}
		
		public override function hideSprite():void
		{			
			sprite.visible=false;
		}
		
		// Priority
		// --------
		public override function getChildIndex():int
		{	
			return pLayer.planeSprites.getChildIndex(sprite);
		}
		public override function getChildMaxIndex():int
		{
			return pLayer.planeSprites.numChildren;
		}
		public override function setChildIndex(index:int):void
		{
			if (index>=pLayer.planeSprites.numChildren)
			{
				index=pLayer.planeSprites.numChildren-1;
				if (index<0)
				{
					index=0;
				}
			}
			pLayer.planeSprites.setChildIndex(sprite, index);
		}
		
		// CONDITIONS
		// ------------------------------------------------------------------------	    
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			switch (num)
			{
				case CND_CLICKED:
					return IsClicked();
				case CND_ENABLED:
					return IsEnabled();
				case CND_CHECKED:
					return IsChecked();
				case CND_LEFTCLICK:
					return LeftClick();
				case CND_RIGHTCLICK:
					return RightClick();
				case CND_MOUSEOVER:
					return MouseOver();
				case CND_IMAGESHOWN:
					return IsImageShown();
				case CND_DOCKED:
					return IsDocked();
			}
			return false;
		}
		
		public function IsClicked():Boolean
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			if (rClickCount == -1)
			{
				return false;
			}
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}
			if (rhPtr.rh4EventCount == rClickCount)
			{
				return true;
			}
			return false;
		}
		
		public function IsEnabled():Boolean
		{
			return ((rData_dwFlags & FLAG_DISABLED) == 0);
		}
		
		public function IsChecked():Boolean
		{
			return ((rData_dwFlags & FLAG_CHECKED) != 0);
		}
		
		public function LeftClick():Boolean
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}
			if (rhPtr.rh4EventCount == rLeftClickCount)
			{
				return true;
			}
			return false;
		}
		
		public function RightClick():Boolean
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}
			if (rhPtr.rh4EventCount == rRightClickCount)
			{
				return true;
			}
			return false;
		}
		
		public function MouseOver():Boolean
		{
			var rhPtr:CRun = ho.hoAdRunHeader;
			var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
			if (pData != null)
			{
				return (rNumInObjList == pData.GetObjectFromList(rh.rh2MouseX, rh.rh2MouseY));
			}
			return false;
		}
		
		public function IsImageShown():Boolean
		{
			return ((rData_dwFlags & FLAG_HIDEIMAGE) == 0);
		}
		
		public function IsDocked():Boolean
		{
			return ((dwRtFlags & DOCK_FLAGS) != 0);
		}
		
		public override function action(num:int, act:CActExtension):void
		{
			switch (num)
			{
				case ACT_ACTION_SETDIM:
					SetDimensions(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
					break;
				case ACT_ACTION_SETPOS:
					SetPosition(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
					break;
				case ACT_ACTION_ENABLE:
					Enable();
					break;
				case ACT_ACTION_DISABLE:
					Disable();
					break;
				case ACT_ACTION_CHECK:
					Check();
					break;
				case ACT_ACTION_UNCHECK:
					Uncheck();
					break;
				case ACT_ACTION_SETCOLOR_NONE:
					SetFillColor_None();
					break;
				case ACT_ACTION_SETCOLOR_3DDKSHADOW:
					SetFillColor_3DDKSHADOW();
					break;
				case ACT_ACTION_SETCOLOR_3DFACE:
					SetFillColor_3DFACE();
					break;
				case ACT_ACTION_SETCOLOR_3DHILIGHT:
					SetFillColor_3DHIGHLIGHT();
					break;
				case ACT_ACTION_SETCOLOR_3DLIGHT:
					SetFillColor_3DLIGHT();
					break;
				case ACT_ACTION_SETCOLOR_3DSHADOW:
					SetFillColor_3DSHADOW();
					break;
				case ACT_ACTION_SETCOLOR_ACTIVECAPTION:
					SetFillColor_ACTIVECAPTION();
					break;
				case ACT_ACTION_SETCOLOR_APPWORKSPACE:
					SetFillColor_APPWORKSPACE();
					break;
				case ACT_ACTION_SETCOLOR_DESKTOP:
					SetFillColor_DESKTOP();
					break;
				case ACT_ACTION_SETCOLOR_HIGHLIGHT:
					SetFillColor_HIGHLIGHT();
					break;
				case ACT_ACTION_SETCOLOR_INACTIVECAPTION:
					SetFillColor_INACTIVECAPTION();
					break;
				case ACT_ACTION_SETCOLOR_INFOBK:
					SetFillColor_INFOBK();
					break;
				case ACT_ACTION_SETCOLOR_MENU:
					SetFillColor_MENU();
					break;
				case ACT_ACTION_SETCOLOR_SCROLLBAR:
					SetFillColor_SCROLLBAR();
					break;
				case ACT_ACTION_SETCOLOR_WINDOW:
					SetFillColor_WINDOW();
					break;
				case ACT_ACTION_SETCOLOR_WINDOWFRAME:
					SetFillColor_WINDOWFRAME();
					break;
				case ACT_ACTION_SETCOLOR_OTHER:
					SetFillColor_Other(act.getParamExpression(rh, 0));
					break;
				case ACT_ACTION_SETB1COLOR_NONE:
					SetB1Color_None();
					break;
				case ACT_ACTION_SETB1COLOR_3DDKSHADOW:
					SetB1Color_3DDKSHADOW();
					break;
				case ACT_ACTION_SETB1COLOR_3DFACE:
					SetB1Color_3DFACE();
					break;
				case ACT_ACTION_SETB1COLOR_3DHILIGHT:
					SetB1Color_3DHIGHLIGHT();
					break;
				case ACT_ACTION_SETB1COLOR_3DSHADOW:
					SetB1Color_3DSHADOW();
					break;
				case ACT_ACTION_SETB1COLOR_ACTIVEBORDER:
					SetB1Color_ACTIVEBORDER();
					break;
				case ACT_ACTION_SETB1COLOR_INACTIVEBORDER:
					SetB1Color_INACTIVEBORDER();
					break;
				case ACT_ACTION_SETB1COLOR_WINDOWFRAME:
					SetB1Color_WINDOWFRAME();
					break;
				case ACT_ACTION_SETB1COLOR_OTHER:
					SetB1Color_Other(act.getParamExpression(rh, 0));
					break;
				case ACT_ACTION_SETB2COLOR_NONE:
					SetB2Color_None();
					break;
				case ACT_ACTION_SETB2COLOR_3DDKSHADOW:
					SetB2Color_3DDKSHADOW();
					break;
				case ACT_ACTION_SETB2COLOR_3DFACE:
					SetB2Color_3DFACE();
					break;
				case ACT_ACTION_SETB2COLOR_3DHILIGHT:
					SetB2Color_3DHIGHLIGHT();
					break;
				case ACT_ACTION_SETB2COLOR_3DLIGHT:
					SetB2Color_3DLIGHT();
					break;
				case ACT_ACTION_SETB2COLOR_3DSHADOW:
					SetB2Color_3DSHADOW();
					break;
				case ACT_ACTION_SETB2COLOR_ACTIVEBORDER:
					SetB2Color_ACTIVEBORDER();
					break;
				case ACT_ACTION_SETB2COLOR_INACTIVEBORDER:
					SetB2Color_INACTIVEBORDER();
					break;
				case ACT_ACTION_SETB2COLOR_WINDOWFRAME:
					SetB2Color_WINDOWFRAME();
					break;
				case ACT_ACTION_SETB2COLOR_OTHER:
					SetB2Color_Other(act.getParamExpression(rh, 0));
					break;
				case ACT_ACTION_TEXTCOLOR_NONE:
					SetTxtColor_None();
					break;
				case ACT_ACTION_TEXTCOLOR_3DHILIGHT:
					SetTxtColor_3DHIGHLIGHT();
					break;
				case ACT_ACTION_TEXTCOLOR_3DSHADOW:
					SetTxtColor_3DSHADOW();
					break;
				case ACT_ACTION_TEXTCOLOR_BTNTEXT:
					SetTxtColor_BTNTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_CAPTIONTEXT:
					SetTxtColor_CAPTIONTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_GRAYTEXT:
					SetTxtColor_GRAYTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_HIGHLIGHTTEXT:
					SetTxtColor_HIGHLIGHTTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_INACTIVECAPTIONTEXT:
					SetTxtColor_INACTIVECAPTIONTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_INFOTEXT:
					SetTxtColor_INFOTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_MENUTEXT:
					SetTxtColor_MENUTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_WINDOWTEXT:
					SetTxtColor_WINDOWTEXT();
					break;
				case ACT_ACTION_TEXTCOLOR_OTHER:
					SetTxtColor_Other(act.getParamExpression(rh, 0));
					break;
				case ACT_ACTION_HYPERLINKCOLOR_NONE:
					SetHyperlinkColor_None();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_3DHILIGHT:
					SetHyperlinkColor_3DHIGHLIGHT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_3DSHADOW:
					SetHyperlinkColor_3DSHADOW();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_BTNTEXT:
					SetHyperlinkColor_BTNTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_CAPTIONTEXT:
					SetHyperlinkColor_CAPTIONTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_GRAYTEXT:
					SetHyperlinkColor_GRAYTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_HIGHLIGHTTEXT:
					SetHyperlinkColor_HIGHLIGHTTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_INACTIVECAPTIONTEXT:
					SetHyperlinkColor_INACTIVECAPTIONTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_INFOTEXT:
					SetHyperlinkColor_INFOTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_MENUTEXT:
					SetHyperlinkColor_MENUTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_WINDOWTEXT:
					SetHyperlinkColor_WINDOWTEXT();
					break;
				case ACT_ACTION_HYPERLINKCOLOR_OTHER:
					SetHyperlinkColor_Other(act.getParamExpression(rh, 0));
					break;
				case ACT_ACTION_SETTEXT:
					SetText(act.getParamExpString(rh, 0));
					break;
				case ACT_ACTION_SETTOOLTIPTEXT:
					SetToolTipText(act.getParamExpString(rh, 0));
					break;
				case ACT_ACTION_UNDOCK:
					Undock();
					break;
				case ACT_ACTION_DOCK_LEFT:
					DockLeft();
					break;
				case ACT_ACTION_DOCK_RIGHT:
					DockRight();
					break;
				case ACT_ACTION_DOCK_TOP:
					DockTop();
					break;
				case ACT_ACTION_DOCK_BOTTOM:
					DockBottom();
					break;
				case ACT_ACTION_SHOWIMAGE:
					ShowImage();
					break;
				case ACT_ACTION_HIDEIMAGE:
					HideImage();
					break;
				case ACT_ACTION_RESETCLICKSTATE:
					ResetClickState();
					break;
				case ACT_ACTION_SETCMDID: //non operational
					AttachMenuCmd();
					break;
			}
		}
		
		public function SetDimensions(w:int, h:int):void
		{
			// Set dimensions
			if ((ho.getWidth() != w) || (ho.getHeight() != h))
			{
				ho.setWidth(w);//rdPtr->rHohoImgWidth = (short)p1;
				ho.setHeight(h);//rdPtr->rHohoImgHeight = (short)p2;
				// Update tooltip rectangle
				//UpdateToolTipRect(rdPtr);
				ho.redraw();
			}
		}
		
		public function SetPosition(x:int, y:int):void
		{
			if ((ho.getX() != x) || (ho.getY() != y))
			{
				ho.setX(x);//rdPtr->rHohoX = (short)p1;
				ho.setY(y);//rdPtr->rHohoY = (short)p2;
				
				// Update tooltip position
				//UpdateToolTipRect(rdPtr);
				
				// Container ? must update coordinates of contained objects
				if ((rData_dwFlags & CRunKcBoxA.FLAG_CONTAINER) != 0)
				{
					var rhPtr:CRun = ho.hoAdRunHeader;
					// Get FrameData
					var pData:CRunKcBoxAFrameData = CRunKcBoxAFrameData(rhPtr.getStorage(ho.hoIdentifier));
					if (pData != null)
					{
						pData.UpdateContainedPos();// = new CFrameData();
						rhPtr.delStorage(ho.hoIdentifier);
						rhPtr.addStorage(pData, ho.hoIdentifier);
					}
				}
				ho.redraw();
			}
		}
		
		public function Enable():void
		{
			if ((rData_dwFlags & FLAG_DISABLED) != 0)
			{
				rData_dwFlags &= ~FLAG_DISABLED;
				ho.redraw();
			}
		}
		
		public function Disable():void
		{
			if ((rData_dwFlags & FLAG_DISABLED) == 0)
			{
				rData_dwFlags |= FLAG_DISABLED;
				ho.redraw();
			}
		}
		
		public function Check():void
		{
			if ((rData_dwFlags & FLAG_CHECKED) == 0)
			{
				rData_dwFlags |= FLAG_CHECKED;
				ho.redraw();
			}
		}
		
		public function Uncheck():void
		{
			if ((rData_dwFlags & FLAG_CHECKED) != 0)
			{
				rData_dwFlags &= ~FLAG_CHECKED;
				ho.redraw();
			}
		}
		
		public function SetFillColor_None():void
		{
			if (rData_fillColor != COLOR_NONE)
			{
				rData_fillColor = COLOR_NONE;
				ho.redraw();
			}
		}
		
		public function SetFillColor_3DDKSHADOW():void
		{
			if (rData_fillColor != 21)
			{
				rData_fillColor = 21;
				ho.redraw();
			}
		}
		
		public function SetFillColor_3DFACE():void
		{
			if (rData_fillColor != 15)
			{
				rData_fillColor = 15;
				ho.redraw();
			}
		}
		
		public function SetFillColor_3DHIGHLIGHT():void
		{
			if (rData_fillColor != 20)
			{
				rData_fillColor = 20;
				ho.redraw();
			}
		}
		
		public function SetFillColor_3DLIGHT():void
		{
			if (rData_fillColor != 22)
			{
				rData_fillColor = 22;
				ho.redraw();
			}
		}
		
		public function SetFillColor_3DSHADOW():void
		{
			if (rData_fillColor != 16)
			{
				rData_fillColor = 16;
				ho.redraw();
			}
		}
		
		public function SetFillColor_ACTIVECAPTION():void
		{
			if (rData_fillColor != 2)
			{
				rData_fillColor = 2;
				ho.redraw();
			}
		}
		
		public function SetFillColor_APPWORKSPACE():void
		{
			if (rData_fillColor != 12)
			{
				rData_fillColor = 12;
				ho.redraw();
			}
		}
		
		public function SetFillColor_DESKTOP():void
		{
			if (rData_fillColor != 1)
			{
				rData_fillColor = 1;
				ho.redraw();
			}
		}
		
		public function SetFillColor_HIGHLIGHT():void
		{
			if (rData_fillColor != 13)
			{
				rData_fillColor = 13;
				ho.redraw();
			}
		}
		
		public function SetFillColor_INACTIVECAPTION():void
		{
			if (rData_fillColor != 3)
			{
				rData_fillColor = 3;
				ho.redraw();
			}
		}
		
		public function SetFillColor_INFOBK():void
		{
			if (rData_fillColor != 24)
			{
				rData_fillColor = 24;
				ho.redraw();
			}
		}
		
		public function SetFillColor_MENU():void
		{
			if (rData_fillColor != 4)
			{
				rData_fillColor = 4;
				ho.redraw();
			}
		}
		
		public function SetFillColor_SCROLLBAR():void
		{
			if (rData_fillColor != 0)
			{
				rData_fillColor = 0;
				ho.redraw();
			}
		}
		
		public function SetFillColor_WINDOW():void
		{
			if (rData_fillColor != 5)
			{
				rData_fillColor = 5;
				ho.redraw();
			}
		}
		
		public function SetFillColor_WINDOWFRAME():void
		{
			if (rData_fillColor != 6)
			{
				rData_fillColor = 6;
				ho.redraw();
			}
		}
		
		public function SetFillColor_Other(c:int):void
		{
			if ((c & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				c &= 0xFFFF;
			}
			else
			{
				c |= COLORFLAG_RGB;
			}
			if (rData_fillColor != c)
			{
				rData_fillColor = c;
				ho.redraw();
			}
		}
		
		public function SetB1Color_None():void
		{
			if (rData_borderColor1 != COLOR_NONE)
			{
				rData_borderColor1 = COLOR_NONE;
				ho.redraw();
			}
		}
		
		public function SetB1Color_3DDKSHADOW():void
		{
			if (rData_borderColor1 != 21)
			{
				rData_borderColor1 = 21;
				ho.redraw();
			}
		}
		
		public function SetB1Color_3DFACE():void
		{
			if (rData_borderColor1 != 15)
			{
				rData_borderColor1 = 15;
				ho.redraw();
			}
		}
		
		public function SetB1Color_3DHIGHLIGHT():void
		{
			if (rData_borderColor1 != 20)
			{
				rData_borderColor1 = 20;
				ho.redraw();
			}
		}
		
		public function SetB1Color_3DLIGHT():void
		{
			if (rData_borderColor1 != 22)
			{
				rData_borderColor1 = 22;
				ho.redraw();
			}
		}
		
		public function SetB1Color_3DSHADOW():void
		{
			if (rData_borderColor1 != 16)
			{
				rData_borderColor1 = 16;
				ho.redraw();
			}
		}
		
		public function SetB1Color_ACTIVEBORDER():void
		{
			if (rData_borderColor1 != 10)
			{
				rData_borderColor1 = 10;
				ho.redraw();
			}
		}
		
		public function SetB1Color_INACTIVEBORDER():void
		{
			if (rData_borderColor1 != 11)
			{
				rData_borderColor1 = 11;
				ho.redraw();
			}
		}
		
		public function SetB1Color_WINDOWFRAME():void
		{
			if (rData_borderColor1 != 6)
			{
				rData_borderColor1 = 6;
				ho.redraw();
			}
		}
		
		public function SetB1Color_Other(c:int):void
		{
			if ((c & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				c &= 0xFFFF;
			}
			else
			{
				c |= COLORFLAG_RGB;
			}
			if (rData_borderColor1 != c)
			{
				rData_borderColor1 = c;
				ho.redraw();
			}
		}
		
		public function SetB2Color_None():void
		{
			if (rData_borderColor2 != COLOR_NONE)
			{
				rData_borderColor2 = COLOR_NONE;
				ho.redraw();
			}
		}
		
		public function SetB2Color_3DDKSHADOW():void
		{
			if (rData_borderColor2 != 21)
			{
				rData_borderColor2 = 21;
				ho.redraw();
			}
		}
		
		public function SetB2Color_3DFACE():void
		{
			if (rData_borderColor2 != 15)
			{
				rData_borderColor2 = 15;
				ho.redraw();
			}
		}
		
		public function SetB2Color_3DHIGHLIGHT():void
		{
			if (rData_borderColor2 != 20)
			{
				rData_borderColor2 = 20;
				ho.redraw();
			}
		}
		
		public function SetB2Color_3DLIGHT():void
		{
			if (rData_borderColor2 != 22)
			{
				rData_borderColor2 = 22;
				ho.redraw();
			}
		}
		
		public function SetB2Color_3DSHADOW():void
		{
			if (rData_borderColor2 != 16)
			{
				rData_borderColor2 = 16;
				ho.redraw();
			}
		}
		
		public function SetB2Color_ACTIVEBORDER():void
		{
			if (rData_borderColor2 != 10)
			{
				rData_borderColor2 = 10;
				ho.redraw();
			}
		}
		
		public function SetB2Color_INACTIVEBORDER():void
		{
			if (rData_borderColor2 != 11)
			{
				rData_borderColor2 = 11;
				ho.redraw();
			}
		}
		
		public function SetB2Color_WINDOWFRAME():void
		{
			if (rData_borderColor2 != 6)
			{
				rData_borderColor2 = 6;
				ho.redraw();
			}
		}
		
		public function SetB2Color_Other(c:int):void
		{
			if ((c & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				c &= 0xFFFF;
			}
			else
			{
				c |= COLORFLAG_RGB;
			}
			if (rData_borderColor2 != c)
			{
				rData_borderColor2 = c;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_None():void
		{
			if (rData_textColor != COLOR_NONE)
			{
				rData_textColor = COLOR_NONE;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_3DHIGHLIGHT():void
		{
			if (rData_textColor != 20)
			{
				rData_textColor = 20;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_3DSHADOW():void
		{
			if (rData_textColor != 16)
			{
				rData_textColor = 16;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_BTNTEXT():void
		{
			if (rData_textColor != 18)
			{
				rData_textColor = 18;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_CAPTIONTEXT():void
		{
			if (rData_textColor != 9)
			{
				rData_textColor = 9;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_GRAYTEXT():void
		{
			if (rData_textColor != 17)
			{
				rData_textColor = 17;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_HIGHLIGHTTEXT():void
		{
			if (rData_textColor != 14)
			{
				rData_textColor = 14;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_INACTIVECAPTIONTEXT():void
		{
			if (rData_textColor != 19)
			{
				rData_textColor = 19;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_INFOTEXT():void
		{
			if (rData_textColor != 23)
			{
				rData_textColor = 23;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_MENUTEXT():void
		{
			if (rData_textColor != 7)
			{
				rData_textColor = 7;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_WINDOWTEXT():void
		{
			if (rData_textColor != 8)
			{
				rData_textColor = 8;
				ho.redraw();
			}
		}
		
		public function SetTxtColor_Other(c:int):void
		{
			if ((c & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				c &= 0xFFFF;
			}
			else
			{
				c |= COLORFLAG_RGB;
			}
			if (rData_textColor != c)
			{
				rData_textColor = c;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_None():void
		{
			if (rData1_dwUnderlinedColor != COLOR_NONE)
			{
				rData1_dwUnderlinedColor = COLOR_NONE;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_3DHIGHLIGHT():void
		{
			if (rData1_dwUnderlinedColor != 20)
			{
				rData1_dwUnderlinedColor = 20;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_3DSHADOW():void
		{
			if (rData1_dwUnderlinedColor != 16)
			{
				rData1_dwUnderlinedColor = 16;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_BTNTEXT():void
		{
			if (rData1_dwUnderlinedColor != 18)
			{
				rData1_dwUnderlinedColor = 18;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_CAPTIONTEXT():void
		{
			if (rData1_dwUnderlinedColor != 9)
			{
				rData1_dwUnderlinedColor = 9;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_GRAYTEXT():void
		{
			if (rData1_dwUnderlinedColor != 17)
			{
				rData1_dwUnderlinedColor = 17;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_HIGHLIGHTTEXT():void
		{
			if (rData1_dwUnderlinedColor != 14)
			{
				rData1_dwUnderlinedColor = 14;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_INACTIVECAPTIONTEXT():void
		{
			if (rData1_dwUnderlinedColor != 19)
			{
				rData1_dwUnderlinedColor = 19;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_INFOTEXT():void
		{
			if (rData1_dwUnderlinedColor != 23)
			{
				rData1_dwUnderlinedColor = 23;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_MENUTEXT():void
		{
			if (rData1_dwUnderlinedColor != 7)
			{
				rData1_dwUnderlinedColor = 7;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_WINDOWTEXT():void
		{
			if (rData1_dwUnderlinedColor != 8)
			{
				rData1_dwUnderlinedColor = 8;
				ho.redraw();
			}
		}
		
		public function SetHyperlinkColor_Other(c:int):void
		{
			if ((c & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				c &= 0xFFFF;
			}
			else
			{
				c |= COLORFLAG_RGB;
			}
			if (rData1_dwUnderlinedColor != c)
			{
				rData1_dwUnderlinedColor = c;
				ho.redraw();
			}
		}
		
		public function SetText(s:String):void
		{
			pText = s;
			ho.redraw();
		}
		
		public function SetToolTipText(s:String):void
		{
			pToolTip = s;
			createToolTip();
		}
		
		public function Undock():void
		{
			if ((dwRtFlags & DOCK_FLAGS) != 0)
			{
				dwRtFlags &= ~DOCK_FLAGS;
			}
		}
		
		public function DockLeft():void
		{
			if ((dwRtFlags & DOCK_LEFT) == 0)
			{
				dwRtFlags |= DOCK_LEFT;
				ho.reHandle();
			}
		}
		
		public function DockRight():void
		{
			if ((dwRtFlags & DOCK_RIGHT) == 0)
			{
				dwRtFlags |= DOCK_RIGHT;
				ho.reHandle();
			}
		}
		
		public function DockTop():void
		{
			if ((dwRtFlags & DOCK_TOP) == 0)
			{
				dwRtFlags |= DOCK_TOP;
				ho.reHandle();
			}
		}
		
		public function DockBottom():void
		{
			if ((dwRtFlags & DOCK_BOTTOM) == 0)
			{
				dwRtFlags |= DOCK_BOTTOM;
				ho.reHandle();
			}
		}
		
		public function ShowImage():void
		{
			if ((rData_dwFlags & FLAG_HIDEIMAGE) != 0)
			{
				rData_dwFlags &= ~FLAG_HIDEIMAGE;
				ho.redraw();
			}
		}
		
		public function HideImage():void
		{
			if ((rData_dwFlags & FLAG_HIDEIMAGE) == 0)
			{
				rData_dwFlags |= FLAG_HIDEIMAGE;
				ho.redraw();
			}
		}
		
		public function ResetClickState():void
		{
			rClickCount = -1;
		}
		
		public function AttachMenuCmd():void
		{
		}
		
		// EXPRESSIONS
		// -------------------------------------------------------------------------
		public override function expression(num:int):CValue
		{
			switch (num)
			{
				case EXP_COLOR_BACKGROUND:
					return ExpColorBackground();
				case EXP_COLOR_BORDER1:
					return ExpColorBorder1();
				case EXP_COLOR_BORDER2:
					return ExpColorBorder2();
				case EXP_COLOR_TEXT:
					return ExpColorText();
				case EXP_COLOR_HYPERLINK:
					return ExpColorHyperlink();
				case EXP_COLOR_3DDKSHADOW:
					return ExpColor_3DDKSHADOW();
				case EXP_COLOR_3DFACE:
					return ExpColor_3DFACE();
				case EXP_COLOR_3DHILIGHT:
					return ExpColor_3DHILIGHT();
				case EXP_COLOR_3DLIGHT:
					return ExpColor_3DLIGHT();
				case EXP_COLOR_3DSHADOW:
					return ExpColor_3DSHADOW();
				case EXP_COLOR_ACTIVEBORDER:
					return ExpColor_ACTIVEBORDER();
				case EXP_COLOR_ACTIVECAPTION:
					return ExpColor_ACTIVECAPTION();
				case EXP_COLOR_APPWORKSPACE:
					return ExpColor_APPWORKSPACE();
				case EXP_COLOR_DESKTOP:
					return ExpColor_DESKTOP();
				case EXP_COLOR_BTNTEXT:
					return ExpColor_BTNTEXT();
				case EXP_COLOR_CAPTIONTEXT:
					return ExpColor_CAPTIONTEXT();
				case EXP_COLOR_GRAYTEXT:
					return ExpColor_GRAYTEXT();
				case EXP_COLOR_HIGHLIGHT:
					return ExpColor_HIGHLIGHT();
				case EXP_COLOR_HIGHLIGHTTEXT:
					return ExpColor_HIGHLIGHTTEXT();
				case EXP_COLOR_INACTIVEBORDER:
					return ExpColor_INACTIVEBORDER();
				case EXP_COLOR_INACTIVECAPTION:
					return ExpColor_INACTIVECAPTION();
				case EXP_COLOR_INACTIVECAPTIONTEXT:
					return ExpColor_INACTIVECAPTIONTEXT();
				case EXP_COLOR_INFOBK:
					return ExpColor_INFOBK();
				case EXP_COLOR_INFOTEXT:
					return ExpColor_INFOTEXT();
				case EXP_COLOR_MENU:
					return ExpColor_MENU();
				case EXP_COLOR_MENUTEXT:
					return ExpColor_MENUTEXT();
				case EXP_COLOR_SCROLLBAR:
					return ExpColor_SCROLLBAR();
				case EXP_COLOR_WINDOW:
					return ExpColor_WINDOW();
				case EXP_COLOR_WINDOWFRAME:
					return ExpColor_WINDOWFRAME();
				case EXP_COLOR_WINDOWTEXT:
					return ExpColor_WINDOWTEXT();
				case EXP_GETTEXT:
					return ExpGetText();
				case EXP_GETTOOLTIPTEXT:
					return ExpGetToolTipText();
				case EXP_GETWIDTH:
					return ExpGetWidth();
				case EXP_GETHEIGHT:
					return ExpGetHeight();
				case EXP_GETX:
					return ExpGetX();
				case EXP_GETY:
					return ExpGetY();
				case EXP_SYSTORGB:
					return ExpSysToRGB();
			}
			return new CValue(0);
		}
		
		public function ExpColorBackground():CValue
		{
			var clr:int = rData_fillColor;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr &= 0xFFFFFF;
			}
			else
			{
				clr |= PARAMFLAG_SYSTEMCOLOR;
			}
			return new CValue(clr);
		}
		
		public function ExpColorBorder1():CValue
		{
			var clr:int = rData_borderColor1;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr &= 0xFFFFFF;
			}
			else
			{
				clr |= PARAMFLAG_SYSTEMCOLOR;
			}
			return new CValue(clr);
		}
		
		public function ExpColorBorder2():CValue
		{
			var clr:int = rData_borderColor2;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr &= 0xFFFFFF;
			}
			else
			{
				clr |= PARAMFLAG_SYSTEMCOLOR;
			}
			return new CValue(clr);
		}
		
		public function ExpColorText():CValue
		{
			var clr:int = rData_textColor;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr &= 0xFFFFFF;
			}
			else
			{
				clr |= PARAMFLAG_SYSTEMCOLOR;
			}
			return new CValue(clr);
		}
		
		public function ExpColorHyperlink():CValue
		{
			var clr:int = rData1_dwUnderlinedColor;
			if ((clr & COLORFLAG_RGB) != 0)
			{
				clr &= 0xFFFFFF;
			}
			else
			{
				clr |= PARAMFLAG_SYSTEMCOLOR;
			}
			return new CValue(clr);
		}
		
		public function ExpColor_3DDKSHADOW():CValue
		{
			return new CValue((21 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_3DFACE():CValue
		{
			return new CValue((15 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_3DHILIGHT():CValue
		{
			return new CValue((20 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_3DLIGHT():CValue
		{
			return new CValue((22 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_3DSHADOW():CValue
		{
			return new CValue((16 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_ACTIVEBORDER():CValue
		{
			return new CValue((10 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_ACTIVECAPTION():CValue
		{
			return new CValue((2 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_APPWORKSPACE():CValue
		{
			return new CValue((12 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_DESKTOP():CValue
		{
			return new CValue((1 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_BTNTEXT():CValue
		{
			return new CValue((18 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_CAPTIONTEXT():CValue
		{
			return new CValue((9 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_GRAYTEXT():CValue
		{
			return new CValue((17 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_HIGHLIGHT():CValue
		{
			return new CValue((13 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_HIGHLIGHTTEXT():CValue
		{
			return new CValue((14 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_INACTIVEBORDER():CValue
		{
			return new CValue((11 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_INACTIVECAPTION():CValue
		{
			return new CValue((3 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_INACTIVECAPTIONTEXT():CValue
		{
			return new CValue((19 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_INFOBK():CValue
		{
			return new CValue((24 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_INFOTEXT():CValue
		{
			return new CValue((23 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_MENU():CValue
		{
			return new CValue((4 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_MENUTEXT():CValue
		{
			return new CValue((7 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_SCROLLBAR():CValue
		{
			return new CValue((0 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_WINDOW():CValue
		{
			return new CValue((5 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_WINDOWFRAME():CValue
		{
			return new CValue((6 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpColor_WINDOWTEXT():CValue
		{
			return new CValue((8 | PARAMFLAG_SYSTEMCOLOR));
		}
		
		public function ExpGetText():CValue
		{
			var ret:CValue=new CValue(0);
			ret.forceString(pText);
			return ret;
		}
		
		public function ExpGetToolTipText():CValue
		{
			var ret:CValue=new CValue(0);
			ret.forceString(pToolTip);
			return ret;
		}
		
		public function ExpGetWidth():CValue
		{
			return new CValue(ho.getWidth());
		}
		
		public function ExpGetHeight():CValue
		{
			return new CValue(ho.getHeight());
		}
		
		public function ExpGetX():CValue
		{
			return new CValue(ho.getX());
		}
		
		public function ExpGetY():CValue
		{
			return new CValue(ho.getY());
		}
		
		public function ExpSysToRGB():CValue
		{
			var rgb:int;
			var paramColor:int = ho.getExpParam().getInt();//DWORD)CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);
			
			if ((paramColor & PARAMFLAG_SYSTEMCOLOR) != 0)
			{
				var sc:int = (paramColor & 0xFFFF);
				rgb = myGetSysColor(sc);
			}
			else
			{
				rgb = paramColor & 0xFFFFFF;
				rgb = fromC(rgb);
			}
			//int ii = rgb.getRGB();
			var r:int = (rgb&0xFF0000)>>16;
			var g:int = (rgb&0x00FF00)>>8;
			var b:int = (rgb&0x0000FF);
			return new CValue(b * 65536 + g * 256 + r);
		}
		
	}
}