//----------------------------------------------------------------------------------
//
// CLives : Objet lives
//
//----------------------------------------------------------------------------------
package Objects
{
	import Banks.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import OI.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CLives extends CObject
	{
		public var rsPlayer:int;
		public var rsValue:CValue;
	    public var rsBoxCx:int;			// Dimensions box (for lives, counters, texts)
    	public var rsBoxCy:int;			
    	public var rsFont:int;				// Temporary font for texts
    	public var rsColor1:int;			// Bar color
    	public var displayFlags:int;
    	public var bShown:Boolean;
    	public var bQuickDisplay:Boolean;
    	public var bCounterChanged:Boolean;
    	public var nLayer:int;
    	public var format:TextFormat;
    	public var textField:TextField;
    	public var bitmaps:Array;
    	public var deltaX:Array;
    	public var deltaY:Array;
		public var nIndex:int;
		public var plane:Sprite;
		public var type:int;
		public var pLayer:CLayer;
		public var bDeleted:Boolean;
		public var displayObjects:Array;
		public var alpha:Number=1.0;
		
		public function CLives()
		{
		}
		public override function init(ocPtr:CObjectCommon, cod:CCreateObjectInfo):void
		{
			rsFont = -1;
			rsColor1 = 0;
			hoImgWidth = hoImgHeight = 0;		// 0
			
			var adCta:CDefCounters=CDefCounters(hoCommon.ocCounters);
			hoImgWidth = rsBoxCx = adCta.odCx;
			hoImgHeight = rsBoxCy = adCta.odCy;
			rsColor1= adCta.ocColor1;
			rsPlayer = adCta.odPlayer;
		    displayFlags=adCta.odDisplayFlags;
			rsValue=new CValue(0);
			rsValue.forceInt(hoAdRunHeader.rhApp.getLives()[rsPlayer-1]);
		    type=adCta.odDisplayType;
			if (type==1)		// CTA_DIGITS 
			{
				bitmaps=new Array(32);
				deltaX=new Array(32);
				displayObjects=new Array(32);
		    }
	    	else if (type==4)	// CTA_ANIM
	    	{
	    		bitmaps=new Array(100);
	    		deltaX=new Array(100);
	    		deltaY=new Array(100);
				displayObjects=new Array(100);
	    	}
			else
			{
				displayObjects=new Array[1];				
			}
			
		}
	    public override function handle():void
	    {
			var lives:Array=hoAdRunHeader.rhApp.getLives();
			if ( rsPlayer>0 && rsValue.getInt()!=lives[rsPlayer-1] )
			{
			    rsValue.forceInt(lives[rsPlayer-1]);
			    bCounterChanged=true;
			    roc.rcChanged=true;
			}
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
			var adCta:CDefCounters=CDefCounters(hoCommon.ocCounters);
			if (adCta.odDisplayType==5)	// CTA_TEXT
			{
			    var nFont:int = rsFont;
			    if ( nFont == -1 )
					nFont = adCta.odFont;
			    return hoAdRunHeader.rhApp.fontBank.getFontInfoFromHandle(nFont);
			}
			return null;
		}
		public function setFont(font:CFontInfo, size:CRect):void
		{
			if (type==5)	// CTA_TEXT
			{
			    rsFont=hoAdRunHeader.rhApp.fontBank.addFont(font);
			    if ( size != null )
			    {
					hoImgWidth = rsBoxCx = size.right - size.left;
					hoImgHeight = rsBoxCy = size.bottom - size.top;
				    var index:int=delSprite();
				    addOwnerDrawSprite(hoX, hoY, nLayer, bQuickDisplay, bShown, index);
			    }
			    modif();
			    roc.rcChanged=true;
			}
		}
		public function getFontColor():int
		{
			return rsColor1;
		}
		public function setFontColor(rgb:int):void
		{
			rsColor1=rgb;
			modif();
			bCounterChanged=true;
			roc.rcChanged=true;
		}

		// GESTION SPRITES ///////////////////////////////////////////////////////////////		   
		public override function addOwnerDrawSprite(xx:int, yy:int, layer:int, quickDisplay:Boolean, shown:Boolean, index:int):void
		{
			if ( hoCommon.ocCounters==null )
			    return;

			nLayer=layer;
			bQuickDisplay=quickDisplay;
			bShown=shown;

			// Trouve le plan
			pLayer=hoAdRunHeader.rhFrame.layers[nLayer];
			if (bQuickDisplay)
				plane=pLayer.planeQuickDisplay;
			else
				plane=pLayer.planeSprites;

			nIndex=index;
			if (nIndex>plane.numChildren)
			{
				nIndex=plane.numChildren-1;
				if (nIndex<0)
				{
					nIndex=0;
				}
			}
			
			// Dispatcher suivant l'objet et son ctaType
			// -----------------------------------------
			var adCta:CDefCounters=CDefCounters(hoCommon.ocCounters);			
			bCounterChanged=true;
			switch (type) 
			{
				case 4:		// CTA_ANIM
			    case 1:		// CTA_DIGITS
			    	computeNewDisplay();
			    	break;
			    case 5:		// CTA_TEXT
			    	textField=new TextField();
					textField.mouseEnabled=false;
					textField.selectable=false;
			    	computeNewDisplay();
					if (index<0)
						plane.addChild(textField);
					else
						plane.addChildAt(textField, index);
					break;
			}
			bDeleted=false;			
		}
		public override function modifOwnerDrawSprite(xx:int, yy:int):void
		{
			if (bDeleted) return;
			if ( hoCommon.ocCounters==null )
			    return;

	    	var i:int;
			if (bCounterChanged)
				computeNewDisplay();
			else
			{
				switch(type)
				{
					case 4:
						for (i=0; i<bitmaps.length; i++)
						{
							if (bitmaps[i]!=null)
							{
								bitmaps[i].x=hoX+deltaX[i]-hoAdRunHeader.rhWindowX+pLayer.x;
								bitmaps[i].y=hoY+deltaY[i]-hoAdRunHeader.rhWindowY+pLayer.y;
							}
						}						
						break;
				    case 1:
				    	for (i=0; i<bitmaps.length; i++)
				    	{
				    		if (bitmaps[i]!=null)
				    		{
				    			bitmaps[i].x=hoX-deltaX[i]-hoAdRunHeader.rhWindowX+pLayer.x;
				    			bitmaps[i].y=hoY-hoImgYSpot-hoAdRunHeader.rhWindowY+pLayer.y;
				    		}
				    	}
				    	break;
				    case 5:
				    	textField.x=hoX-hoImgWidth-hoAdRunHeader.rhWindowX+pLayer.x;
						textField.y=hoY-hoImgHeight/2-textField.textHeight/2-hoAdRunHeader.rhWindowY+pLayer.y;
				    	break;
				}
			}			
		}
		public override function delSprite():int
		{
			if ( hoCommon.ocCounters==null )
			    return -1;
			if (bDeleted) 
				return -1;

			var index:int;			
			switch(type)
			{				
				case 4:		// CTA_ANIM
				case 1:		// CTA_DIGITS
					var i:int;
					if (bitmaps[0]!=null)
					{
						index=plane.getChildIndex(bitmaps[0]);
						for (i=0; i<bitmaps.length; i++)
						{
							if (bitmaps[i]!=null)
							{
								plane.removeChild(bitmaps[i]);
								bitmaps[i]=null;
							}
						}
					}
					break;
				case 5: 	// CTA_TEXT
					index=plane.getChildIndex(textField);
					plane.removeChild(textField);
					textField=null;
					break; 
			}
			bDeleted=true;
			return index;
		}
		public override function getChildIndex():int
		{
			if (bShown)
			{
				switch(type)
				{
					case 4:
						if (bitmaps[0]!=null)
						{
							return plane.getChildIndex(bitmaps[0]);
						}
						break;
				    case 1:
						if (bitmaps[0]!=null)
						{
							return plane.getChildIndex(bitmaps[0]);
						}
						break;			    	
				    case 5:
				    	if (textField!=null)
				    	{				    
				    		return plane.getChildIndex(textField);
				    	}
				    	break;
				}
			}
			return -1;
		}
		public override function getChildMaxIndex():int
		{
			return pLayer.planeSprites.numChildren;
		}
		public override function setChildIndex(index:int):void
		{
			if (index>=plane.numChildren)
			{
				index=plane.numChildren-1;
			}
			if (index<0)
			{
				index=0;
			}
			switch(type)
			{
				case 4:
				case 1:
			    	var i:int;
			    	for (i=0; i<bitmaps.length; i++)
			    	{
			    		if (bitmaps[i]!=null)
			    		{
			    			plane.setChildIndex(bitmaps[i], index);
			    		}
			    	}
			    	break;
			    case 5:
			    	if (textField!=null)
			    	{
			    		plane.setChildIndex(textField, index);
			    	}
			    	break;
			}
		}
		public override function showSprite():void
		{
			if ( hoCommon.ocCounters==null )
			    return;

			if (bShown==false)
			{
				bShown=true;
				bCounterChanged=true;
				computeNewDisplay();
			}
		}
		public override function hideSprite():void
		{
			if ( hoCommon.ocCounters==null )
			    return;

			if (bShown==true)
			{
				bShown=false;
				bCounterChanged=true;
				computeNewDisplay();
			}
		}
		public function computeNewDisplay():void
		{
			var image:CImage;
			var bAdd:Boolean;
			var count:int;
			var s:String;
			if (bCounterChanged==true)
			{
				bCounterChanged=false;
				
				var adCta:CDefCounters=CDefCounters(hoCommon.ocCounters);
				var vInt:int=rsValue.getInt();
				switch (type) 
				{
					case 4:		// CTA_ANIM
						if (bitmaps[0]!=null)
						{
							nIndex=plane.getChildIndex(bitmaps[0]);
							if (nIndex>=plane.numChildren)
							{
								nIndex=plane.numChildren-1;
								if (nIndex<0)
								{
									nIndex=0;
								}
							}
						}

						hoImgXSpot=0;
						hoImgYSpot=0;
						if (vInt>=100)
						{
							vInt=99;
						}
						if (vInt==0)
						{
							hoImgWidth=0;
							hoImgHeight=0;
							for (count=0; count<bitmaps.length; count++)
							{
								if (bitmaps[count]!=null)
								{
									plane.removeChild(bitmaps[count]);
									bitmaps[count]=null;
									displayObjects[count]=null;
								}
							}
							break;							
						}
						else
						{
						    image=hoAdRunHeader.rhApp.imageBank.getImageFromHandle(adCta.frames[0]);
						    var lg:int = vInt * image.width;
						    if ( lg <= rsBoxCx )
						    {
								hoImgWidth = lg;
								hoImgHeight = image.height;
						    }
						    else
						    {
								hoImgWidth = rsBoxCx;
								hoImgHeight = ((rsBoxCx / image.width) + vInt - 1) * image.height;
						    }
						    						    
			    			var x1:int = hoX;
			    			var y1:int = hoY;
			    			var x2:int = hoX+hoImgWidth;
			    			var y2:int = hoY+hoImgHeight;
			    			var x:int, y:int;
			    			count=0;
			    			for (y=y1; y<y2 && vInt>0; y+=image.height)
			   	 			{
								for (x=x1; x<x2 && vInt>0; x += image.width, vInt-=1)
								{
									bAdd=false;
									if (bitmaps[count]==null)
									{
										bitmaps[count]=new Bitmap();
										bAdd=true;
									}
									bitmaps[count].bitmapData=image.img;
									bitmaps[count].x=x-hoAdRunHeader.rhWindowX+pLayer.x;
									bitmaps[count].y=y-hoAdRunHeader.rhWindowY+pLayer.y;
									bitmaps[count].visible=bShown;
									deltaX[count]=x-hoX;
									deltaY[count]=y-hoY;
									if (bAdd)
									{
								    	if (nIndex<0)
								    		plane.addChild(bitmaps[count]);
								    	else
								    		plane.addChildAt(bitmaps[count], nIndex);
									}
									count++;
								}
		    				}
							for (i=0; i<count; i++)
							{
								displayObjects[i]=bitmaps[i];
							}
							for (; count<bitmaps.length; count++)
							{
								if (bitmaps[count]!=null)
								{
									plane.removeChild(bitmaps[count]);
									bitmaps[count]=null;
									displayObjects[count]=null;
								}
							}																					
						}
						break;
				    case 1:	    // CTA_DIGITS:					
						s=CServices.intToString(vInt, displayFlags);
						if (bitmaps[0]!=null)
						{
							nIndex=plane.getChildIndex(bitmaps[0]);
							if (nIndex>=plane.numChildren)
							{
								nIndex=plane.numChildren-1;
								if (nIndex<0)
								{
									nIndex=0;
								}
							}
						}
						
						var i:int;
					    var c:int;
					    var img:int;
						var ifo:CImage;
						var dx:int=0, dy:int=0;					    
					    // Calcule la taille
						for (i=s.length-1; i>=0; i--)
						{
							bAdd=true;
					    	c=s.charCodeAt(i);
						    if ( c == 45 )		// -
								img = adCta.frames[10];		// COUNTER_IMAGE_SIGN_NEG
						    else if ( c == 46 )	// .
								img = adCta.frames[12];		// COUNTER_IMAGE_POINT
						    else if ( c == 43 ) // +
								img = adCta.frames[11];	// COUNTER_IMAGE_SIGN_PLUS
					    	else if ( c == 101 || c == 69 )		// e E
								img = adCta.frames[13];	// COUNTER_IMAGE_EXP
						    else if ( c>=48 && c<=57 )
								img = adCta.frames[c-48];
							else
								bAdd=false;								
							if (bAdd)
							{
							    ifo=hoAdRunHeader.rhApp.imageBank.getImageFromHandle(img);
							    dx+=ifo.width;
							    dy=Math.max(dy, ifo.height);
							}
						}
						hoImgXSpot=dx;
						hoImgYSpot=dy;
						hoImgWidth=dx;
						hoImgHeight=dy;
						
						// Cree les images
						count=0;
						dx=0;
						for (i=s.length-1; i>=0; i--)
						{
						    c=s.charCodeAt(i);
						    bAdd=true;
						    if ( c == 45 )		// -
								img = adCta.frames[10];		// COUNTER_IMAGE_SIGN_NEG
						    else if ( c == 46 )	// .
								img = adCta.frames[12];		// COUNTER_IMAGE_POINT
						    else if ( c == 43 ) // +
								img = adCta.frames[11];	// COUNTER_IMAGE_SIGN_PLUS
					    	else if ( c == 101 || c == 69 )		// e E
								img = adCta.frames[13];	// COUNTER_IMAGE_EXP
						    else if ( c>=48 && c<=57 )
								img = adCta.frames[c-48];
							else
								bAdd=false;
								
							if (bAdd)
							{
							    ifo=hoAdRunHeader.rhApp.imageBank.getImageFromHandle(img);
							    dx+=ifo.width;
							    deltaX[count]=dx;
							    bAdd=false;
							    if (bitmaps[count]==null)
							    {
							    	bitmaps[count]=new Bitmap();
							    	bAdd=true;
							    }
							    bitmaps[count].x=hoX-dx-hoAdRunHeader.rhWindowX+pLayer.x;
							    bitmaps[count].y=hoY-hoImgHeight-hoAdRunHeader.rhWindowY+pLayer.y;
						    	bitmaps[count].bitmapData=ifo.img;
						    	bitmaps[count].visible=bShown;
							    if (bAdd)
							    {
							    	if (nIndex<0)
							    		plane.addChild(bitmaps[count]);
							    	else
							    		plane.addChildAt(bitmaps[count], nIndex);
							    }
							    count++;
							}
						}
						for (i=0; i<count; i++)
						{
							displayObjects[i]=bitmaps[i];
						}
						for (i=count; i<bitmaps.length; i++)
						{
							if (bitmaps[i]!=null)
							{
								plane.removeChild(bitmaps[i]);
								bitmaps[i]=null;
								displayObjects[i]=null;
							}
						}
						break;
					case 5: 	// CTA_TEXT
						s=CServices.intToString(vInt, displayFlags);

						textField.width=hoImgWidth;
						textField.height=hoImgHeight;
						textField.visible=bShown;
						
						var nFont:int=rsFont;
						if ( nFont == -1 )
						    nFont = adCta.odFont;
						var font:CFont=hoAdRunHeader.rhApp.fontBank.getFontFromHandle(nFont);

						if (format==null)
						{
							format=new TextFormat();
						}
						format.align=TextFormatAlign.RIGHT;
						format.color=rsColor1;
						format.font=font.lfFaceName;
						format.size=font.lfHeight;
						if (font.lfWeight>600)
							format.bold=true;
						if (font.lfItalic!=0)
							format.italic=true;
						if (font.lfUnderline!=0)
							format.underline=true;
						textField.text=s;
						textField.setTextFormat(format);
						textField.x=hoX-hoImgWidth-hoAdRunHeader.rhWindowX+pLayer.x;
						textField.y=hoY-hoImgHeight/2-textField.textHeight/2-hoAdRunHeader.rhWindowY+pLayer.y;
						hoImgXSpot=rsBoxCx;
						hoImgYSpot=rsBoxCy;
						hoImgWidth=rsBoxCx;
						hoImgHeight=rsBoxCy;	
						displayObjects[0]=textField;
						break;
		    	}
			}
		}
		public override function setEffect(effect:int, effectParam:int):int
		{
			if (displayObjects==null)
			{
				return 0;
			}

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
			
			var i:int;
			for (i=0; i<displayObjects.length; i++)
			{
				if (displayObjects[i]!=null)
				{					
					switch(effectMasked)
					{
						case CRSpr.BOP_ADD:
							displayObjects[i].blendMode = "add";
							displayObjects[i].transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
							break;
						case CRSpr.BOP_SUB:
							displayObjects[i].blendMode = "subtract";
							displayObjects[i].transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
							break;
						case CRSpr.BOP_INVERT:
							displayObjects[i].blendMode = "normal";
							displayObjects[i].transform.colorTransform = new ColorTransform(-r/255.0, -g/255.0, -b/255.0, 1, 255, 255, 255, 0);  
							break;
						default: 
							displayObjects[i].blendMode = "normal";
							displayObjects[i].transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
							break;
					}
				}
				else
				{
					break;
				}
			}
			setTransparency(alpha);
			return alpha;
		}
		public override function setTransparency(t:Number):void
		{
			if (displayObjects==null)
			{
				return;
			}

			var i:int;
			for (i=0; i<displayObjects.length; i++)
			{
				if (displayObjects[i]!=null)
				{					
					displayObjects[i].alpha=t*alpha;
				}
				else
				{
					break;					
				}
			}
		}			
	}
}