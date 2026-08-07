//----------------------------------------------------------------------------------
//
// CRUNKCBUTTON : objet bouton
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.*;

	public class CRunKcButton extends CRunExtension
	{
	    public static var BTNTYPE_PUSHTEXT:int = 0;
	    public static var BTNTYPE_CHECKBOX:int = 1;
	    public static var BTNTYPE_RADIOBTN:int = 2;
	    public static var BTNTYPE_PUSHBITMAP:int = 3;
	    public static var BTNTYPE_PUSHTEXTBITMAP:int = 4;
	    public static var MAX_BUTTONS:int = 32;
	    public static var MAX_TEXTSIZE:int = 4096;
	    public static var ALIGN_ONELINELEFT:int = 0;
	    public static var ALIGN_CENTER:int = 1;
	    public static var ALIGN_CENTERINVERSE:int = 2;
	    public static var ALIGN_ONELINERIGHT:int = 3;
	    public static var BTN_HIDEONSTART:int = 0x0001;
	    public static var BTN_DISABLEONSTART:int = 0x0002;
	    public static var BTN_TEXTONLEFT:int = 0x0004;
	    public static var BTN_TRANSP_BKD:int = 0x0008;
	    public static var BTN_SYSCOLOR:int = 0x0010;
		public static var SX_BUTTONBORDER:int=4;
		public static var SY_BUTTONBORDER:int=4;
		public static var SX_TEXTIMAGE:int=6;
		public static var SY_TEXTIMAGE:int=4;
		public static var SX_CHECKBOX:int=12;
		public static var SY_CHECKBOX:int=13;
		public static var R_RADIO:int=5;
		public static var TOOLTIP_TODISPLAY:int=0;
		public static var TOOLTIP_DISPLAYED:int=1;
		public static var TOOLTIP_HIDDEN:int=2;
		
	    public static var CND_BOXCHECK:int = 0;
	    public static var CND_CLICKED:int = 1;
	    public static var CND_BOXUNCHECK:int = 2;
	    public static var CND_VISIBLE:int = 3;
	    public static var CND_ISENABLED:int = 4;
	    public static var CND_ISRADIOENABLED:int = 5;
	    public static var CND_LAST:int = 6;
	    public static var ACT_CHANGETEXT:int = 0;
	    public static var ACT_SHOW:int = 1;
	    public static var ACT_HIDE:int = 2;
	    public static var ACT_ENABLE:int = 3;
	    public static var ACT_DISABLE:int = 4;
	    public static var ACT_SETPOSITION:int = 5;
	    public static var ACT_SETXSIZE:int = 6;
	    public static var ACT_SETYSIZE:int = 7;
	    public static var ACT_CHGRADIOTEXT:int = 8;
	    public static var ACT_RADIOENABLE:int = 9;
	    public static var ACT_RADIODISABLE:int = 10;
	    public static var ACT_SELECTRADIO:int = 11;
	    public static var ACT_SETXPOSITION:int = 12;
	    public static var ACT_SETYPOSITION:int = 13;
	    public static var ACT_CHECK:int = 14;
	    public static var ACT_UNCHECK:int = 15;
	    public static var ACT_SETCMDID:int = 16;
	    public static var ACT_SETTOOLTIP:int = 17;
	    public static var ACT_LAST:int = 18;
	    public static var EXP_GETXSIZE:int = 0;
	    public static var EXP_GETYSIZE:int = 1;
	    public static var EXP_GETX:int = 2;
	    public static var EXP_GETY:int = 3;
	    public static var EXP_GETSELECT:int = 4;
	    public static var EXP_GETTEXT:int = 5;
	    public static var EXP_GETTOOLTIP:int = 6;
	    public static var EXP_LAST:int = 7;

	    public var buttonImages:Array;
	    public var buttonType:int;
	    public var buttonCount:int;
	    public var flags:int;
	    public var alignImageText:int;
	    public var font:CFontInfo;
	    public var fontColor:int;
	    public var backColor:int;
	    public var clickedEvent:int;
		public var strings:Array;
		public var toolTipText:String;
		public var sprites:Array;
		public var textFields:Array;
		public var bitmap:Bitmap;
		public var focus:int;
		public var oldFocus:int;
		public var hilight:int;
		public var oldHilight:int;
		public var selected:int;
		public var oldSelected:int;
		public var checked:int;
		public var oldChecked:int;
		public var textFormat:TextFormat;
		public var syText:int;
		public var oldWidth:int;
		public var oldHeight:int;
		public var zone:int;
		public var oldZone:int;
		public var oldKey:int;
		public var bEnabled:Boolean;
		public var bVisible:Boolean;
		public var sprite:Sprite;
		public var syButton:int;
		public var radioEnabled:Array;
		public var toolTip:Sprite;
		public var sxToolTip:int;
		public var syToolTip:int;
		public var toolTipStatus:int;
		public var toolTipTime:int;
		public var oldToolTipZone:int;
		
		public function CRunKcButton()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return CND_LAST;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        // Read in edPtr values
	        ho.hoImgWidth = file.readShort();
	        ho.hoImgHeight = file.readShort();
	        oldWidth=ho.hoImgWidth;
	        oldHeight=ho.hoImgHeight;
	        buttonType = file.readShort();
	        buttonCount = file.readShort();
	        flags = file.readInt();
	        font = file.readLogFont();
	        fontColor = file.readColor();
	        backColor = file.readColor();
	        buttonImages = new Array(3);
	        var i:int;
	        for (i = 0; i < 3; i++)
	        {
	            buttonImages[i] = file.readShort();
	        }
	        if ((buttonType == BTNTYPE_PUSHBITMAP) || (buttonType == BTNTYPE_PUSHTEXTBITMAP))
	        {
	            ho.loadImageList(buttonImages);
	        }
			if (buttonType==BTNTYPE_PUSHBITMAP)
			{
				ho.hoImgWidth = 0;
				ho.hoImgHeight = 0;
				for (i = 0; i < 3; i++)
				{
					if (buttonImages[i]!=-1)
					{
						var image:CImage=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(buttonImages[i]);
						ho.hoImgWidth = Math.max(ho.hoImgWidth, image.width);
						ho.hoImgHeight = Math.max(ho.hoImgHeight, image.height);
					}
				}
				if (ho.hoImgWidth==0)
				{
					ho.hoImgWidth=32;
				}
				if (ho.hoImgHeight==0)
				{
					ho.hoImgHeight=32;
				}
			}
	        file.readShort(); // fourth word in img array
	        file.readInt(); // ebtnSecu
	        alignImageText = file.readShort();
	
	        if (buttonType!=BTNTYPE_RADIOBTN)
	        {
	        	buttonCount=1;
	            strings = new Array(1);
	            strings[0] = file.readString();
	            toolTipText = file.readString();
	        }
	        else
	        {
	            strings = new Array(buttonCount);
	            for (i = 0; i < buttonCount; i++)
	            {
	                strings[i] = file.readString();
	            }
	        }
			var b:int;
            var n:int;
			for (b=0; b<buttonCount; b++)
			{
				var s:String=strings[b];
				for (n=0; n<s.length; n++)
				{
					if (s.charAt(n)=="&")
					{
						s=s.substring(0, n)+s.substring(n+1);
						if (s.charAt(n)!="&")
						{
							n--;
						}
					}	
				}				
				strings[b]=s;
			}	
			
			focus=-1;
			oldFocus=-1;
			hilight=-1;
			oldHilight=-1;
			selected=-1;
			oldSelected=-1;
			oldZone=-1;
			oldKey=-1;
			checked=-1;			
			oldChecked=-1;
			oldToolTipZone=-1;
			bEnabled=true;			
			clickedEvent=-1;
			if ((flags&BTN_DISABLEONSTART)!=0)
			{
				bEnabled=false;
			}			
			bVisible=true;
			if ((flags&BTN_HIDEONSTART)!=0)
			{
				bVisible=false;
			}
					
			if (buttonType!=BTNTYPE_RADIOBTN)
			{
				sprite=new Sprite();
				textFields=new Array(1);
				textFields[0]=new TextField();
				textFields[0].mouseEnabled=false;
				textFields[0].selectable=false;
				sprite.addChild(textFields[0]);
				sprite.visible=bVisible;
				if (buttonType==BTNTYPE_PUSHBITMAP || buttonType==BTNTYPE_PUSHTEXTBITMAP)
				{
					bitmap=new Bitmap();
					sprite.addChild(bitmap);
				}
			}	
			else
			{
				sprite=new Sprite();
				sprites=new Array(buttonCount);
				textFields=new Array(buttonCount);
				radioEnabled=new Array(buttonCount);
				for (n=0; n<buttonCount; n++)
				{
					sprites[n]=new Sprite();
					textFields[n]=new TextField();
					sprites[n].addChild(textFields[n]);
					sprite.addChild(sprites[n]);
					textFields[n].mouseEnabled=false;
					textFields[n].selectable=false;
					radioEnabled[n]=true;
				}
			}
			ho.hoAdRunHeader.rhApp.planeControls.addChild(sprite);
			sprite.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			sprite.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			createDisplay();
			createToolTip();
	
	        return false;
	    }
		public override function displayRunObject():void
		{
			sprite.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			sprite.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			var bDisplay:Boolean=false;
			if (ho.hoImgWidth!=oldWidth)
			{
				oldWidth=ho.hoImgWidth;
				bDisplay=true;
			}
			if (ho.hoImgHeight!=oldHeight)
			{
				oldHeight=ho.hoImgHeight;
				bDisplay=true;		
			}
			if (bDisplay)
			{
				createDisplay();
			}
		}
		public override function setHandCursor(bOn:Boolean):void
		{
			sprite.buttonMode=bOn;
			sprite.useHandCursor=bOn;
		}
		public override function destroyRunObject(bFlag:Boolean):void
		{
			ho.hoAdRunHeader.rhApp.planeControls.removeChild(sprite);		
			if (toolTip!=null)
			{
				ho.hoAdRunHeader.rhApp.planeControls.removeChild(toolTip);
			}
		}
		public function createTextFormat():void
		{
			textFormat=new TextFormat();
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.color=fontColor;
			textFormat.font=font.lfFaceName;
			textFormat.size=font.lfHeight;
			if (font.lfWeight>600)
				textFormat.bold=true;
			if (font.lfItalic!=0)
				textFormat.italic=true;
			if (font.lfUnderline!=0)
				textFormat.underline=true;						
		}
		public function createToolTip():void
		{
			if (toolTip!=null)
			{
				ho.hoAdRunHeader.rhApp.planeControls.removeChild(toolTip);
				toolTip=null;
				return;									
			}
			if (toolTipText!=null && toolTipText.length!=0)			
			{
				toolTip=new Sprite();
				ho.hoAdRunHeader.rhApp.planeControls.addChild(toolTip);

				var tf:TextFormat=new TextFormat();
				tf.align=TextFormatAlign.LEFT;
				tf.color=0x000000;
				tf.font="Arial";
				tf.size=12;
				
				var toolTextField:TextField=new TextField();
				toolTextField.text=toolTipText;
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
		public function createDisplay():void
		{
			var color:int;
			var x:int, y:int;
			
			// Trouve la hauteur du texte
			var tf:TextField=new TextField();
			tf.text="AqWqjYy";
			createTextFormat();
			textFormat.color=0x000000;
			tf.setTextFormat(textFormat);
			syText=tf.textHeight+4;

			var i:int=0;
			var image:CImage=null;
			var sxText:int;		
	    	var colorsRect:Array;
	    	var colorsFill:Array;
			var colorsCheck:int;
	    	var alphas:Array;
	    	var ratios:Array;
	    	var matr:Matrix;
			if (buttonType==BTNTYPE_PUSHTEXT || buttonType==BTNTYPE_PUSHTEXTBITMAP)
			{
				sprite.graphics.clear();

		    	colorsRect=[0xB7BABC, 0x5E6162];
		    	colorsFill=[0xDBE1E5, 0x9EABB2];
		    	if (focus>=0)
		    	{
		    		colorsRect[0]=0x009BFC;
		    		colorsRect[1]=0x0078C4;
		    	}
		    	if (hilight>=0)
		    	{
		    		colorsRect[0]=0x009DFF;
		    		colorsRect[1]=0x0076C1;
		    		colorsFill[0]=0xE8EDEF;
		    		colorsFill[1]=0xC7CFD2;
		    	}
		    	if (selected>=0)
		    	{
		    		colorsRect[0]=0x0081FF;
		    		colorsRect[1]=0x0076C1;
		    		colorsFill[0]=0xD8F0FF;
		    		colorsFill[1]=0x9BD8FF;
				}
		    	alphas=[1, 1];
		    	ratios=[0, 255];
		    	matr=new Matrix();
	    		matr.createGradientBox(ho.hoImgWidth-1, ho.hoImgHeight-1, Math.PI/2, 0, 0);
		    	sprite.graphics.lineStyle(1);
		    	sprite.graphics.lineGradientStyle(GradientType.LINEAR, colorsRect, alphas, ratios, matr, SpreadMethod.PAD);
		    	sprite.graphics.beginGradientFill(GradientType.LINEAR, colorsFill, alphas, ratios, matr, SpreadMethod.PAD);
				sprite.graphics.drawRoundRect(0, 0, ho.hoImgWidth-1, ho.hoImgHeight-1, 7);
				sprite.graphics.endFill();
				
				if (buttonType==BTNTYPE_PUSHTEXT)
				{
					textFormat.align=TextFormatAlign.CENTER;
					textFormat.color=0x000000;
					if (bEnabled==false)
					{
						textFormat.color=0xA0A0A0;
					}
					textFields[0].width=ho.hoImgWidth;
					textFields[0].height=syText;
					textFields[0].text=strings[0];
					textFields[0].setTextFormat(textFormat);
					textFields[0].x=0;
					textFields[0].y=ho.hoImgHeight/2-syText/2;
				}				
			}	
			if (buttonType==BTNTYPE_PUSHBITMAP)
			{
				sprite.graphics.clear();

				i=0;
				if (selected==0)
				{
					i=1;
				}
				if (bEnabled==false)
				{
					i=2;
				}
				i=buttonImages[i];
				if (i<0)
				{
					i=buttonImages[0];
				}
				if (i>=0)
				{
					image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(i);
					bitmap.bitmapData=image.img;
					bitmap.x=ho.hoImgWidth/2-image.width/2;
					bitmap.y=ho.hoImgHeight/2-image.height/2;
				}
			} 
			if (buttonType==BTNTYPE_PUSHTEXTBITMAP)
			{
				var sx:int;
				if (selected==0)
				{
					i=1;
				}
				if (bEnabled==false)
				{
					i=2;
				}
				i=buttonImages[i];
				if (i<0)
				{
					i=buttonImages[0];
				}
				if (i>=0)
				{
					image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(i);
					bitmap.bitmapData=image.img;
				}
				textFields[0].x=SX_BUTTONBORDER;
				textFormat.color=0;
				if (bEnabled==false)
				{
					textFormat.color=0xA0A0A0;
				}
				textFields[0].text=strings[0];
				textFields[0].setTextFormat(textFormat);
				textFields[0].y=ho.hoImgHeight/2-syText/2;
				if (image!=null)
				{
					switch (alignImageText)
					{					
						case ALIGN_ONELINELEFT:
							textFormat.align=TextFormatAlign.LEFT;
							textFields[0].width=ho.hoImgWidth;
							textFields[0].height=syText;
							sxText=textFields[0].textWidth;
							sx=sxText+image.width+SX_TEXTIMAGE;
							textFields[0].x=ho.hoImgWidth/2-sx/2+image.width+SX_TEXTIMAGE;
							textFields[0].y=ho.hoImgHeight/2-syText/2;
							bitmap.x=ho.hoImgWidth/2-sx/2;
							bitmap.y=ho.hoImgHeight/2-image.height/2;
							break;					
						case ALIGN_ONELINERIGHT:
							textFormat.align=TextFormatAlign.LEFT;
							textFields[0].width=ho.hoImgWidth;
							textFields[0].height=syText;
							sxText=textFields[0].textWidth;
							sx=sxText+image.width+SX_TEXTIMAGE;
							textFields[0].x=ho.hoImgWidth/2-sx/2;
							textFields[0].y=ho.hoImgHeight/2-syText/2;
							bitmap.x=ho.hoImgWidth/2-sx/2+sxText+SX_TEXTIMAGE;
							bitmap.y=ho.hoImgHeight/2-image.height/2;
							break;					
						case ALIGN_CENTER:
							textFormat.align=TextFormatAlign.CENTER;
							textFields[0].width=ho.hoImgWidth;
							textFields[0].height=syText;
							sxText=textFields[0].textWidth;
							bitmap.x=ho.hoImgWidth/2-image.width/2;
							bitmap.y=ho.hoImgHeight/2-(syText+image.height+SY_TEXTIMAGE)/2;
							textFields[0].y=ho.hoImgHeight/2-(syText+image.height+SY_TEXTIMAGE)/2+image.height+SY_TEXTIMAGE;
							textFields[0].x=0;
							break;					
						case ALIGN_CENTERINVERSE:
							textFormat.align=TextFormatAlign.CENTER;
							textFields[0].width=ho.hoImgWidth;
							textFields[0].height=syText;
							textFields[0].x=ho.hoImgWidth/2-sxText/2;
							textFields[0].y=ho.hoImgHeight/2-(syText+image.height+SY_TEXTIMAGE)/2;
							bitmap.x=0;
							bitmap.y=ho.hoImgHeight/2-(syText+image.height+SY_TEXTIMAGE)/2+syText+SY_TEXTIMAGE;
							break;					
					}
				}
			}
			if (buttonType==BTNTYPE_CHECKBOX)
			{
				sprite.graphics.clear();
				if ((flags&BTN_TRANSP_BKD)==0)
				{
					if ((flags&BTN_SYSCOLOR)==0)
					{
						color=backColor;
					}
					else
					{
						color=0xFFFFFF;
					}
					sprite.graphics.beginFill(color);
					sprite.graphics.lineStyle(1, color);
					sprite.graphics.drawRect(0, 0, ho.hoImgWidth-1, ho.hoImgHeight-1);
					sprite.graphics.endFill();
				}
				if (bEnabled)
				{
			    	colorsRect=[0xB7BABC, 0x5E6162];
			    	colorsFill=[0xDBE1E5, 0x9EABB2];
			    	if (focus>=0)
			    	{
			    		colorsRect[0]=0x009BFC;
			    		colorsRect[1]=0x0078C4;
			    	}
			    	if (hilight>=0)
			    	{
			    		colorsRect[0]=0x009DFF;
			    		colorsRect[1]=0x0076C1;
			    		colorsFill[0]=0xE8EDEF;
			    		colorsFill[1]=0xC7CFD2;
			    	}
			    	if (selected>=0)
			    	{
			    		colorsRect[0]=0x0081FF;
			    		colorsRect[1]=0x0076C1;
			    		colorsFill[0]=0xD8F0FF;
			    		colorsFill[1]=0x9BD8FF;
					}
				}
				else {
					colorsRect=[0xB7BABC, 0xB7BABC];
					colorsFill=[0xDBE1E5, 0xDBE1E5];
				}
 		    	alphas=[1, 1];
		    	ratios=[0, 255];
		    	matr=new Matrix();
	    		matr.createGradientBox(SX_CHECKBOX, SY_CHECKBOX, Math.PI/2, 0, 0);
		    	sprite.graphics.lineStyle(1);
		    	sprite.graphics.lineGradientStyle(GradientType.LINEAR, colorsRect, alphas, ratios, matr, SpreadMethod.PAD);
		    	sprite.graphics.beginGradientFill(GradientType.LINEAR, colorsFill, alphas, ratios, matr, SpreadMethod.PAD);
		    	x=0;
		    	if ((flags&BTN_TEXTONLEFT)!=0)
		    	{
		    		x=ho.hoImgWidth-SX_CHECKBOX-1;
		    	}
				sprite.graphics.drawRect(x, ho.hoImgHeight/2-SY_CHECKBOX/2, SX_CHECKBOX, SY_CHECKBOX);
				sprite.graphics.endFill();
				
				if (checked==0)
				{
					if(bEnabled == true)
						colorsCheck = 0x000000;
					else
						colorsCheck = 0xA0A0A0;
					sprite.graphics.lineStyle(2, colorsCheck);
					y=ho.hoImgHeight/2-SY_CHECKBOX/2+SY_CHECKBOX/5;
					sprite.graphics.moveTo(x+SX_CHECKBOX/3+1, y+(SY_CHECKBOX*2)/5);
					sprite.graphics.lineTo(x+SX_CHECKBOX/2, y+(SY_CHECKBOX*2)/3);
					sprite.graphics.lineTo(x+SX_CHECKBOX-3, y+1);								
				}
				textFormat.color=0x000000;
				if ((flags&BTN_SYSCOLOR)==0)
				{
					textFormat.color=fontColor;
				}
				if (bEnabled==false)
				{
					textFormat.color=0xA0A0A0;
				}
		    	if ((flags&BTN_TEXTONLEFT)==0)
		    	{
					textFormat.align=TextFormatAlign.LEFT;
					textFields[0].x=SX_CHECKBOX+6;
		    	}
		    	else
		    	{
					textFormat.align=TextFormatAlign.RIGHT;
					textFields[0].x=0;
		    	}
				textFields[0].width=ho.hoImgWidth-SX_CHECKBOX-6;
				textFields[0].height=syText;
				textFields[0].text=strings[0];
				textFields[0].setTextFormat(textFormat);
				textFields[0].y=ho.hoImgHeight/2-syText/2;				
			}
			if (buttonType==BTNTYPE_RADIOBTN)
			{
				sprite.graphics.clear();
				if ((flags&BTN_TRANSP_BKD)==0)
				{
					if ((flags&BTN_SYSCOLOR)==0)
					{
						color=backColor;
					}
					else
					{
						color=0xFFFFFF;
					}
					sprite.graphics.beginFill(color);
					sprite.graphics.lineStyle(1, color);
					sprite.graphics.drawRect(0, 0, ho.hoImgWidth-1, ho.hoImgHeight-1);
					sprite.graphics.endFill();
				}

				var n:int;
				syButton=ho.hoImgHeight/buttonCount;
				for (n=0; n<buttonCount; n++)
				{
					sprites[n].x=0;
					sprites[n].y=n*syButton;
					sprites[n].graphics.clear();

					if (bEnabled && radioEnabled[n]==true)
					{
				    	colorsRect=[0xB7BABC, 0x5E6162];
				    	colorsFill=[0xDBE1E5, 0x9EABB2];
				    	if (focus==n)
				    	{
				    		colorsRect[0]=0x00FFFF;
				    		colorsRect[1]=0x00FFFF;
				    	}
				    	if (hilight==n)
				    	{
				    		colorsRect[0]=0x009DFF;
				    		colorsRect[1]=0x0076C1;
				    		colorsFill[0]=0xE8EDEF;
				    		colorsFill[1]=0xC7CFD2;
				    	}
				    	if (selected==n)
				    	{
				    		colorsRect[0]=0x0081FF;
				    		colorsRect[1]=0x0076C1;
				    		colorsFill[0]=0xD8F0FF;
				    		colorsFill[1]=0x9BD8FF;
						}
					}
					else
					{
				    	colorsRect=[0xB7BABC, 0xB7BABC];
				    	colorsFill=[0xDBE1E5, 0xDBE1E5];
					}
			    	alphas=[1, 1];
			    	ratios=[0, 255];
			    	matr=new Matrix();
		    		matr.createGradientBox(R_RADIO, R_RADIO, Math.PI/2, 0, 0);
			    	sprites[n].graphics.lineStyle(1);
			    	sprites[n].graphics.lineGradientStyle(GradientType.LINEAR, colorsRect, alphas, ratios, matr, SpreadMethod.PAD);
			    	sprites[n].graphics.beginGradientFill(GradientType.LINEAR, colorsFill, alphas, ratios, matr, SpreadMethod.PAD);
			    	x=R_RADIO+2;
			    	if ((flags&BTN_TEXTONLEFT)!=00)
			    	{
			    		x=ho.hoImgWidth-R_RADIO-2;
			    	}
					
					sprites[n].graphics.drawCircle(x, syButton/2, R_RADIO);
					sprites[n].graphics.endFill();
					
					if (checked==n)
					{
						if (bEnabled && radioEnabled[n]==true)
						{
							color=0x000000;
						}
						else
						{
							color=0xA0A0A0;
						}
						sprites[n].graphics.lineStyle(2, color);
						sprites[n].graphics.beginFill(color);
						sprites[n].graphics.drawCircle(x, syButton/2, 2);
						sprites[n].graphics.endFill();
					}
					textFormat.color=0x000000;
					if ((flags&BTN_SYSCOLOR)==0)
					{
						textFormat.color=fontColor;
					}
					if (bEnabled==false || radioEnabled[n]==false)
					{
						textFormat.color=0xA0A0A0;
					}
			    	if ((flags&BTN_TEXTONLEFT)==0)
			    	{					
						textFields[n].x=R_RADIO+9;
						textFormat.align=TextFormatAlign.LEFT;
			    	}
			    	else
			    	{
						textFields[n].x=0;
						textFormat.align=TextFormatAlign.RIGHT;
			    	}
					textFields[n].width=ho.hoImgWidth-R_RADIO-9;
					textFields[n].height=syText;
					textFields[n].text=strings[n];
					textFields[n].setTextFormat(textFormat);
					textFields[n].y=syButton/2-syText/2;				
				}	
			}
		}
		public override function handleRunObject():int
		{
			var bDisplay:Boolean=false;
			zone=getZone(ho.hoAdRunHeader.rh2MouseX, ho.hoAdRunHeader.rh2MouseY);
			if (zone!=oldZone)
			{
				oldZone=zone;
				if (bEnabled && bVisible)
				{
					hilight=zone;
					bDisplay=true;
				}
			}	
						
			// Tooltip
			if (buttonType==BTNTYPE_PUSHTEXT || buttonType==BTNTYPE_PUSHBITMAP || buttonType==BTNTYPE_PUSHTEXTBITMAP)
			{
				var time:int;
				if (zone>=0)
				{
					if (toolTip!=null)
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
			
			var n:int;
			var key:int=-1;
			if (ho.hoAdRunHeader.rhApp.keyBuffer[260]!=0)
			{
				key=0;
			}
			if (ho.hoAdRunHeader.rhApp.keyBuffer[38]!=0)
			{
				key=1;			// Up
			}
			if (ho.hoAdRunHeader.rhApp.keyBuffer[40]!=0)
			{
				key=2;			// Down
			}
			if (ho.hoAdRunHeader.rhApp.keyBuffer[13]!=0 || ho.hoAdRunHeader.rhApp.keyBuffer[32]!=0)
			{
				key=3;			// Down
			}
			if (key!=oldKey)
			{
				if (bEnabled && bVisible)
				{				
					if (buttonType==BTNTYPE_PUSHTEXT || buttonType==BTNTYPE_PUSHBITMAP || buttonType==BTNTYPE_PUSHTEXTBITMAP)
					{
						if (key==0)
						{
							if (zone==0)
							{
								selected=0;						        						
								bDisplay=true;
								if (toolTip!=null)
								{
									toolTip.visible=false;
									toolTipStatus=TOOLTIP_HIDDEN;
								}								
							}
						}
						if (key==-1)
						{
							if (zone==0 && selected==0)
							{
								if (oldKey==0)
								{
							        clickedEvent = rh.rh4EventCount;
							        ho.pushEvent(CND_CLICKED, 0);	
									ho.hoAdRunHeader.rhApp.sysEvents.clear();		// Vire le click des evenements
									ho.hoAdRunHeader.buttonClickCount=ho.getEventCount();
								}
							}
						}
						if (key==3)
						{
							if (focus==0)
							{
								if (selected==0)
								{
									selected=-1;
									bDisplay=true;
								}					
								else
								{
									selected=0;
									bDisplay=true;
							        clickedEvent = rh.rh4EventCount;
							        ho.pushEvent(CND_CLICKED, 0);							
								}			
							}
						}
						if (key==-1)
						{
							selected=-1;
							bDisplay=true;
						}
					}
					if (buttonType==BTNTYPE_CHECKBOX)
					{
						if (key==0)
						{
							if (zone==0)
							{
								selected=0;
								if (checked==0)
								{
									checked=-1;
									bDisplay=true;
									clickedEvent = rh.rh4EventCount;
									ho.pushEvent(CND_CLICKED, 0);							
								}
								else if (checked<0)
								{
									checked=0;
							        clickedEvent = rh.rh4EventCount;
							        ho.pushEvent(CND_CLICKED, 0);							
									bDisplay=true;
								}
							}
						}
						else if (key==3)
						{
							if (focus==0)
							{
								if (checked==0)
								{
									checked=-1;
									bDisplay=true;
									clickedEvent = rh.rh4EventCount;
									ho.pushEvent(CND_CLICKED, 0);							
								}
								else if (checked<0)
								{
									checked=0;
							        clickedEvent = rh.rh4EventCount;
							        ho.pushEvent(CND_CLICKED, 0);							
									bDisplay=true;
								}
							}
						}
						else
						{
							selected=-1;
							bDisplay=true;
						}
					}
					if (buttonType==BTNTYPE_RADIOBTN)
					{
						if (key==0 || (key==3 && focus>=0))
						{
							if (zone>=0)
							{
								focus=zone;
							}
							if (focus>=0)
							{
								selected=focus;
								if (checked!=focus)
								{
									checked=focus;
							        clickedEvent = rh.rh4EventCount;
							        ho.pushEvent(CND_CLICKED, 0);							
									bDisplay=true;
								}
							}
						}
						else if (key==1)
						{
							if (focus>=0)
							{
								n=focus;
								if (n>0)
								{
									n--;
									while(n>0 && radioEnabled[n]==false)
									{
										n--;
									}
									if (radioEnabled[n]==true)
									{
										focus=n;
										bDisplay=true;
									}
								}
							}
						}
						else if (key==2)
						{
							if (focus>=0)
							{
								n=focus;
								if (n<buttonCount-1)
								{
									n++;
									while(n<buttonCount-1 && radioEnabled[n]==false)
									{
										n++;
									}
									if (radioEnabled[n]==true)
									{
										focus=n;
										bDisplay=true;
									}
								}
							}
						}
						else
						{
							selected=-1;
							bDisplay=true;
						}
					}
				}
				oldKey=key;
			}
			if (bDisplay)
			{
				createDisplay();				
			}
			return 0;
		}
		public override function setFocus(bFlag:Boolean):void
		{
			var n:int;
			var bDisplay:Boolean=false;
			if (buttonType!=BTNTYPE_RADIOBTN)
			{
				if (bFlag)
				{
					if (focus<0)
					{
						focus=0;
						bDisplay=true;
					}
				}
				else
				{
					if (focus>=0)
					{
						focus=-1;
						bDisplay=false;
					}
				}
			}
			else
			{
				if (bFlag)
				{
					if (focus<0)
					{
						for (n=0; n<buttonCount; n++)
						{
							if (radioEnabled[n])
							{
								focus=n;
								break;
							}
						}
						focus=0;
						if (zone>=0)
						{
							focus=zone;
						}
						bDisplay=true;
					}
				}
				else
				{
					if (focus>=0)
					{
						focus=-1;
						bDisplay=false;
					}
				}
			}
			if (bDisplay)
			{
				createDisplay();
			}
		}
		public function getZone(xMouse:int, yMouse:int):int
		{
			if (buttonType!=BTNTYPE_RADIOBTN)
			{
				if (xMouse>=ho.hoX && xMouse<ho.hoX+ho.hoImgWidth)
				{
					if (yMouse>=ho.hoY && yMouse<ho.hoY+ho.hoImgHeight)
					{
						return 0;
					}
				}
			}
			else
			{
				if (xMouse>=ho.hoX && xMouse<ho.hoX+ho.hoImgWidth)
				{
					if (yMouse>=ho.hoY && yMouse<ho.hoY+ho.hoImgHeight)
					{
						var n:int=(yMouse-ho.hoY)/syButton;
						if (radioEnabled[n]==true)
						{
							return n;
						}
						return -1;
					}
				}
			}
			return -1; 
		}
	    public override function getRunObjectFont():CFontInfo
	    {
	        return font;
	    }
	
	    public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void
	    {
	        font = fi;
	        if (rc!=null)
	        {
	        	ho.hoImgWidth=rc.right;
	        	ho.hoImgHeight=rc.bottom;
	        }
	        createDisplay();
	    }
	
	    public override function getRunObjectTextColor():int
	    {
	        return fontColor;
	    }
	
	    public override function setRunObjectTextColor(rgb:int):void
	    {
	        fontColor = rgb;
	        createDisplay();
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_BOXCHECK:
	                return cndBOXCHECK(cnd);
	            case CND_CLICKED:
	                return cndCLICKED(cnd);
	            case CND_BOXUNCHECK:
	                return cndBOXUNCHECK(cnd);
	            case CND_VISIBLE:
	                return cndVISIBLE(cnd);
	            case CND_ISENABLED:
	                return cndISENABLED(cnd);
	            case CND_ISRADIOENABLED:
	                return cndISRADIOENABLED(cnd);
	        }
	        return false;
	    }
	
	    public function cndBOXCHECK(cnd:CCndExtension):Boolean
	    {
	        if (buttonType == BTNTYPE_CHECKBOX)
	        {
	            return checked==0;
	        }
	        return false;
	    }
	
	    public function cndCLICKED(cnd:CCndExtension):Boolean
	    {
	        // If this condition is first, then always true
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	
	        // If condition second, check event number matches
	        if (rh.rh4EventCount == clickedEvent)
	        {
	            return true;
	        }
	
	        return false;
	    }
	
	    public function cndBOXUNCHECK(cnd:CCndExtension):Boolean
	    {
	        if (buttonType == BTNTYPE_CHECKBOX)
	        {
	            return checked<0;
	        }
	        return false;
	    }
	
	    public function cndVISIBLE(cnd:CCndExtension):Boolean
	    {
	        return bVisible;
	    }
	
	    public function cndISENABLED(cnd:CCndExtension):Boolean
	    {
	        return bEnabled;
	    }
	
	    public function cndISRADIOENABLED(cnd:CCndExtension):Boolean
	    {
	        var index:int = cnd.getParamExpression(rh, 0);
	        if ((index >= 0) && (index < buttonCount))
	        {
	            return radioEnabled[index];
	        }
	        return false;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_CHANGETEXT:
	                actCHANGETEXT(act);
	                break;
	            case ACT_SHOW:
	                actSHOW(act);
	                break;
	            case ACT_HIDE:
	                actHIDE(act);
	                break;
	            case ACT_ENABLE:
	                actENABLE(act);
	                break;
	            case ACT_DISABLE:
	                actDISABLE(act);
	                break;
	            case ACT_SETPOSITION:
	                actSETPOSITION(act);
	                break;
	            case ACT_SETXSIZE:
	                actSETXSIZE(act);
	                break;
	            case ACT_SETYSIZE:
	                actSETYSIZE(act);
	                break;
	            case ACT_CHGRADIOTEXT:
	                actCHGRADIOTEXT(act);
	                break;
	            case ACT_RADIOENABLE:
	                actRADIOENABLE(act);
	                break;
	            case ACT_RADIODISABLE:
	                actRADIODISABLE(act);
	                break;
	            case ACT_SELECTRADIO:
	                actSELECTRADIO(act);
	                break;
	            case ACT_SETXPOSITION:
	                actSETXPOSITION(act);
	                break;
	            case ACT_SETYPOSITION:
	                actSETYPOSITION(act);
	                break;
	            case ACT_CHECK:
	                actCHECK(act);
	                break;
	            case ACT_UNCHECK:
	                actUNCHECK(act);
	                break;
	            case ACT_SETCMDID:
	                actSETCMDID(act);
	                break;
	            case ACT_SETTOOLTIP:
	                actSETTOOLTIP(act);
	                break;
	        }
	    }
	
	    public function actCHANGETEXT(act:CActExtension):void
	    {
	        strings[0]=act.getParamExpString(rh, 0);
			createDisplay();
	    }
	
	    public function actSHOW(act:CActExtension):void
	    {
	    	sprite.visible=true;
	    	bVisible=true;
	    }
	
	    public function actHIDE(act:CActExtension):void
	    {
	    	sprite.visible=false;
	    	bVisible=false;
	    }
	
	    public function actENABLE(act:CActExtension):void
	    {
	    	if (bEnabled==false)
	    	{
	    		bEnabled=true;
	    		createDisplay();
	    	}
	    }
	
	    public function actDISABLE(act:CActExtension):void
	    {
	    	if (bEnabled)
	    	{
	    		bEnabled=false;
	    		createDisplay();
	    	}
	    }
	
	    public function actSETPOSITION(act:CActExtension):void
	    {
	        var pos:CPositionInfo = act.getParamPosition(rh, 0);
	        ho.setPosition(pos.x, pos.y);
	        ho.redraw();
	    }
	
	    public function actSETXSIZE(act:CActExtension):void
	    {
	        ho.setWidth(act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actSETYSIZE(act:CActExtension):void
	    {
	        ho.setHeight(act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actCHGRADIOTEXT(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0);
	        var newText:String = act.getParamExpString(rh, 1);
	        if ((index >= 0) && (index < buttonCount))
	        {
	            strings[index]=newText;
	            createDisplay();
	        }
	    }
	
	    public function actRADIOENABLE(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0);
	        if ((index >= 0) && (index < buttonCount))
	        {
	        	if (radioEnabled[index]==false)
	        	{
	        		radioEnabled[index]=true;
	        		createDisplay();
	        	}
	        }
	    }
	
	    public function actRADIODISABLE(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0);
	        if ((index >= 0) && (index < buttonCount))
	        {
	        	if (radioEnabled[index]==true)
	        	{
	        		radioEnabled[index]=false;
	        		createDisplay();
	        	}
	        }
	    }
	
	    public function actSELECTRADIO(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0);
	
	        if (checked!=index)
	        {
	        	if (radioEnabled[index])
	        	{
	        		checked=index;
	        		createDisplay();
	        	}
	        }
			if(index == -1) {
				var i:int;
				for(i=0; i < radioEnabled.length ; i++) {
					checked = radioEnabled.length;
				}
				createDisplay();				
			}
	    }
	
	    public function actSETXPOSITION(act:CActExtension):void
	    {
	        ho.setPosition(act.getParamExpression(rh, 0), ho.hoY);
	        ho.redraw();
	    }
	
	    public function actSETYPOSITION(act:CActExtension):void
	    {
	        ho.setPosition(ho.hoX, act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actCHECK(act:CActExtension):void
	    {
	        if (buttonType == BTNTYPE_CHECKBOX)
	        {
	        	if (checked==-1)
	        	{
	        		checked=0;
	        		createDisplay();
	        	}
	        }
	    }
	
	    public function actUNCHECK(act:CActExtension):void
	    {
	        if (buttonType == BTNTYPE_CHECKBOX)
	        {
	        	if (checked==0)
	        	{
	        		checked=-1;
	        		createDisplay();
	        	}
	        }
	    }
	
	    public function actSETCMDID(act:CActExtension):void
	    {
	    }
	
	    public function actSETTOOLTIP(act:CActExtension):void
	    {
	        toolTipText = act.getParamExpString(rh, 0);
	        createToolTip();
	    }

	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_GETXSIZE:
	                return expGETXSIZE();
	            case EXP_GETYSIZE:
	                return expGETYSIZE();
	            case EXP_GETX:
	                return expGETX();
	            case EXP_GETY:
	                return expGETY();
	            case EXP_GETSELECT:
	                return expGETSELECT();
	            case EXP_GETTEXT:
	                return expGETTEXT();
	            case EXP_GETTOOLTIP:
	                return expGETTOOLTIP();
	        }
	        return null;
	    }
	
	    public function expGETXSIZE():CValue
	    {
	        return new CValue(ho.getWidth());
	    }
	
	    public function expGETYSIZE():CValue
	    {
	        return new CValue(ho.getHeight());
	    }
	
	    public function expGETX():CValue
	    {
	        return new CValue(ho.getX());
	    }
	
	    public function expGETY():CValue
	    {
	        return new CValue(ho.getY());
	    }
	
	    public function expGETSELECT():CValue
	    {
	        if (buttonType == BTNTYPE_RADIOBTN)
	        {
	        	return new CValue(checked);
	        }
	        return new CValue(0);
	    }
	
	    public function expGETTEXT():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	    	
	        var index:int = ho.getExpParam().getInt();
	        if (buttonType == BTNTYPE_RADIOBTN)
	        {
	            if ((index < 0) || (index >= buttonCount))
	            {
	                return ret;
	            }
	        }
	        else
	        {
	            index = 0;
	        }
			ret.forceString(strings[index]);
			return ret;
	    }
	
	    public function expGETTOOLTIP():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(toolTipText);
	    	return ret;
	    }
	}
}