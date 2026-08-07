package Objects
{
	import Banks.*;
	
	import Frame.*;
	
	import OI.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.ColorTransform;
	
	public class CText extends CObject
	{
		public var rsTextBuffer:String;
		public var currentText:String;
	    public var rsMaxi:int;
    	public var rsMini:int;
	    public var rsFont:int;
	    public var rsTextColor:int;
	    public var bTxtChanged:Boolean;
		public var textField:TextField;
		public var tf:TextFormat;
		public var nLayer:int;
		public var font:CFont;
		public var bShown:Boolean;
		public var bQuickDisplay:Boolean;
		public var flags:int;
		public var rsHidden:int;
		public var pLayer:CLayer;
		public var plane:Sprite;
		public var sprite:Sprite;
		public var displayObject:DisplayObject;
		public var bEmbedFont:Boolean;
		public var alpha:Number=1.0;
										
		public function CText()
		{
		}
		public override function init(ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
		{
			var txt:CDefTexts=CDefTexts(ocPtr.ocObject);
			hoImgWidth = txt.otCx;
			hoImgHeight = txt.otCy;

			// Recuperer la couleur et le nombre de phrases
			rsMaxi = txt.otNumberOfText;
			rsTextColor=0;
			if (txt.otTexts.length>0)
			{
				rsTextColor = txt.otTexts[0].tsColor;
			}
			rsTextBuffer=null;
			rsFont = -1;
			rsMini=0;
			bShown=true;
			rsHidden=cob.cobFlags;
			if ( (cob.cobFlags&CRun.COF_FIRSTTEXT)!=0 )
			{
				if (txt.otTexts.length>0)
				{
			    	rsTextBuffer=new String(txt.otTexts[0].tsText);
			 	}
			}				
			bTxtChanged=true;
		} 
	    public override function handle():void
	    {
	        ros.handle();
	        if (roc.rcChanged)
	        {
	            roc.rcChanged=false;
	            modif();
	        }
	    }
	    public override function modif():void
	    {
	        ros.modifRoutine();
	    }
	    public override function display():void
	    {
	        ros.displayRoutine();
	    }
		public function getFont():CFontInfo
		{
	        var nFont:int = rsFont;
			if ( nFont == -1 )
			{
			    var txt:CDefTexts=CDefTexts(hoCommon.ocObject);
			    nFont = txt.otTexts[0].tsFont;
			}
			return hoAdRunHeader.rhApp.fontBank.getFontInfoFromHandle(nFont);
		}
		public function setFont(f:CFontInfo, size:CRect):void
		{
			rsFont=hoAdRunHeader.rhApp.fontBank.addFont(f);
			font=hoAdRunHeader.rhApp.fontBank.getFontFromHandle(rsFont);
			if ( size != null )
			{
			    hoImgWidth = size.right - size.left;
			    hoImgHeight = size.bottom - size.top;
			    var index:int=delSprite();
			    addOwnerDrawSprite(hoX, hoY, nLayer, bQuickDisplay, bShown, index);
			}
			bTxtChanged=true;
			modif();
			roc.rcChanged=true;			
		}
		public function getFontColor():int
		{
			return rsTextColor;
		}
		public function setFontColor(rgb:int):void
		{
			rsTextColor=rgb;
			modif();
			roc.rcChanged=true;
			bTxtChanged=true;			
		}
	    public function txtChange(num:int):Boolean
	    {
	        if (num < -1)
	        {
	            num = -1;							// -1==chaine stockee...
	        }
	        if (num >= rsMaxi)
	        {
	            num = rsMaxi - 1;
	        }
	        if (num == rsMini)
	        {
	            return false;
	        }
	
	        rsMini = num;
	
	        // -------------------------------
	        // Recopie le texte dans la chaine
	        // -------------------------------
	        if (num >= 0)
	        {
	            var txt:CDefTexts = CDefTexts(hoCommon.ocObject);
	            txtSetString(txt.otTexts[rsMini].tsText);
	        }
	
	        // Reafficher ou pas?
	        // ------------------
	        if ((ros.rsFlags & CRSpr.RSFLAG_HIDDEN) != 0)
	        {
	            return false;
	        }
	        return true;
	    }
	    public function txtSetString(s:String):void
	    {
	        rsTextBuffer = new String(s);
	        bTxtChanged=true;
	    }

		public override function addOwnerDrawSprite(xx:int, yy:int, layer:int, quickDisplay:Boolean, show:Boolean, index:int):void
		{
			nLayer=layer;
			pLayer=hoAdRunHeader.rhFrame.layers[layer];

			textField=new TextField();
			displayObject=textField;
			textField.width=hoImgWidth;
			textField.height=hoImgHeight+4;
			textField.multiline=true;
			textField.wordWrap=true;
			textField.blendMode = "layer";
			
			var txt:CDefTexts=CDefTexts(hoCommon.ocObject);
			flags=txt.otTexts[0].tsFlags;

			// Get font
			var nFont:int=rsFont;
			if (nFont==-1)
			{
				if (txt.otTexts.length>0)
				{
				    nFont=txt.otTexts[0].tsFont;
				}
			}
			font=hoAdRunHeader.rhApp.fontBank.getFontFromHandle(nFont);

			if (quickDisplay)
				plane=pLayer.planeQuickDisplay;
			else
				plane=pLayer.planeSprites;

			computeText();
			
			bShown=show;
			textField.text=currentText;
			textField.embedFonts=bEmbedFont;
			textField.setTextFormat(tf);
			
			textField.x=xx+pLayer.x;
			if ((flags&CServices.DT_VCENTER)!=0)
				textField.y=yy+hoImgHeight/2-textField.textHeight/2+pLayer.y;
			else if ((flags&CServices.DT_BOTTOM)!=0)
				textField.y=yy+hoImgHeight-textField.textHeight+pLayer.y;
			else			
				textField.y=yy+pLayer.y;
			textField.mouseEnabled=false;
			textField.selectable=false;
			textField.visible=bShown;
			
			bQuickDisplay=quickDisplay;
			if (index<0)
			{
				plane.addChild(textField);
			}
			else
			{
				plane.addChildAt(textField, index);
			}
		}
		public override function delSprite():int
		{
			if (displayObject!=null)
			{
				var pLayer:CLayer=hoAdRunHeader.rhFrame.layers[nLayer];
				var index:int;
				index=plane.getChildIndex(displayObject);					
				plane.removeChild(displayObject);
				textField=null;
				displayObject=null;
				return index;
			}
			return 0;
		}
		public override function getChildIndex():int
		{	
			if (bShown)
			{
		    	return plane.getChildIndex(displayObject);
			}
			return -1;
		}
		public override function getChildMaxIndex():int
		{
			return pLayer.planeSprites.numChildren;
		}
		public override function setChildIndex(index:int):void
		{
			if (textField!=null)
			{
				if (index>=plane.numChildren)
				{
					index=plane.numChildren-1;
				}
				if (index<0)
				{
					index=0;
				}
				plane.setChildIndex(displayObject, index);
			}
		}
		public override function modifOwnerDrawSprite(xx:int, yy:int):void
		{
			if (textField==null) return;
			
			if (bTxtChanged)
			{
				computeText();
				textField.text=currentText;
				textField.embedFonts=bEmbedFont;
				textField.setTextFormat(tf);					
			}
			displayObject.x=xx+pLayer.x;
			if ((flags&CServices.DT_VCENTER)!=0)
				displayObject.y=yy+hoImgHeight/2-textField.textHeight/2+pLayer.y;
			else if ((flags&CServices.DT_BOTTOM)!=0)
				displayObject.y=yy+hoImgHeight-textField.textHeight+pLayer.y;
			else			
				displayObject.y=yy+pLayer.y;
		}
		public override function setHandCursor(bOn:Boolean):void
		{
			if (bOn)
			{
				if (textField!=null && textField.visible==true)
				{
					if ((flags&(CServices.DT_VCENTER|CServices.DT_BOTTOM))==0)
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
							sprite.x=textField.x;
							sprite.y=textField.y;
							sprite.visible=textField.visible;
							textField.visible=true;
							textField.x=0;
							textField.y=0;
							sprite.buttonMode=true;
							sprite.useHandCursor=true;
							plane.removeChild(textField);
							sprite.addChild(textField);
							plane.addChildAt(sprite, index);
						}
						else if (sprite!=null && textField!=null)
						{
							sprite.buttonMode=true;
							sprite.useHandCursor=true;					
						}
					}
				}
			}
			else
			{
				if (sprite!=null)
				{	
					sprite.buttonMode=false;
					sprite.useHandCursor=false;
				}
			}			
		}
		public override function showSprite():void
		{
			if (bShown==false && textField!=null)
			{
				bShown=true;
				displayObject.visible=bShown;
			}
		}
		public override function hideSprite():void
		{
			if (bShown==true && textField!=null)
			{
				bShown=false;
				displayObject.visible=bShown;
			}
		}
		public function computeText():void
		{
			var txt:CDefTexts=CDefTexts(hoCommon.ocObject);

			// Affichage
			currentText=null;
			if (rsMini >= 0 )
			{
			    currentText=txt.otTexts[rsMini].tsText;
			}
			else
			{
			    currentText=rsTextBuffer;
			    if (currentText==null)
			    {
					currentText="";
			    }
			}

			// Vire les 13
			var n:int;
			var nPrevious:int;
			var c:int;
			var s:String=new String();
			for (n=0; n<currentText.length; n++)
			{
				c=currentText.charCodeAt(n);
				if (c==13)
				{
					s=s+currentText.substring(nPrevious, n);
					nPrevious=n+1;
				}
			}
			if (n>nPrevious)
			{
				s+=currentText.substring(nPrevious, n);
			}
			currentText=s;

			tf=new TextFormat();
			if ((flags&CServices.DT_RIGHT)!=0)
				tf.align=TextFormatAlign.RIGHT;
			else if ((flags&CServices.DT_CENTER)!=0)
				tf.align=TextFormatAlign.CENTER
			else
				tf.align=TextFormatAlign.LEFT;
			tf.color=rsTextColor;
			tf.size=font.lfHeight;
			
			var embeddedName:String=font.getEmbeddedName();
			var embeddedFont:int=hoAdRunHeader.rhApp.getEmbeddedFont(embeddedName);
			bEmbedFont=false;
			if (embeddedFont>=0)
			{
				bEmbedFont=true;
				tf.font=embeddedName;
			}
			else
			{
				tf.font=font.lfFaceName;
				if (font.lfWeight>600)
					tf.bold=true;
				if (font.lfItalic!=0)
					tf.italic=true;
				if (font.lfUnderline!=0)
					tf.underline=true;
			}
			
			bTxtChanged=false;
		}
		public override function setTransparency(t:Number):void
		{
			if (displayObject!=null)
			{
				displayObject.alpha=t*alpha;
			}
		}
		public override function setEffect(effect:int, effectParam:int):int
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
			return alpha;
		}
	}
}	