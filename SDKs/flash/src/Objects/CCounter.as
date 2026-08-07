package Objects
{
	import Banks.*;
	
	import Expressions.*;
	
	import Frame.CLayer;
	
	import OI.*;
	
	import RunLoop.*;
	
	import Services.*;
	import Sprites.*;
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.ColorTransform;
	
	public class CCounter extends CObject
	{
		public var type:int;
		public var rsValue:CValue;
		public var rsMini:int;
		public var rsMaxi:int;
		public var rsMiniDouble:Number;
		public var rsMaxiDouble:Number;
    	public var rsBoxCx:int;			// Dimensions box (for lives, counters, texts)
    	public var rsBoxCy:int;			
    	public var bShown:Boolean;
    	public var bQuickDisplay:Boolean;
    	public var bCounterChanged:Boolean;
    	public var rsFont:int;				// Temporary font for texts
    	public var rsColor1:int;			// Bar color
    	public var rsColor2:int
    	public var rsOldFrame:int;
    	public var nLayer:int;
    	public var format:TextFormat;
    	public var textField:TextField;
    	public var bitmaps:Array;
    	public var deltaX:Array;
    	public var shape:Shape;
		public var nIndex:int;
		public var plane:Sprite;
		public var displayFlags:int;
		public var pLayer:CLayer;
		public var bDeleted:Boolean;
		public var displayObjects:Array;
		public var alpha:Number=1.0;
		
		public function CCounter()
		{
		}
	    public override function init(ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
	    {        
			// Hidden counter?	
			rsFont = -1;
			rsColor1 = 0;
			rsColor2 = 0;
			hoImgWidth = hoImgHeight = 1;		// 0
		
			if (hoCommon.ocCounters==null)
			{
			    hoImgWidth = rsBoxCx = 1;
			    hoImgHeight = rsBoxCy = 1;
			}
			else
			{
			    var ctPtr:CDefCounters=CDefCounters(hoCommon.ocCounters);
			    hoImgWidth = rsBoxCx = ctPtr.odCx;
			    hoImgHeight = rsBoxCy = ctPtr.odCy;
				displayFlags=ctPtr.odDisplayFlags;
			    type=ctPtr.odDisplayType;
			    switch (type) 
			    {
				case 5:	    // CTA_TEXT:
				    rsColor1= ctPtr.ocColor1;
					displayObjects=new Array(1);
				    break;
				case 2:	    // CTA_VBAR:
				case 3:	    // CTA_HBAR:
				    rsColor1 = ctPtr.ocColor1;
				    rsColor2 = ctPtr.ocColor2;
					displayObjects=new Array(1);
				    break;
				case 1:		// CTA_DIGITS
					bitmaps=new Array(32);
					deltaX=new Array(32);
					displayObjects=new Array(32);
					break;
				case 4:		// CTA_ANIM
				    bitmaps=new Array(1);				    
					displayObjects=new Array(1);
					break;				
			    }
			}
	
			var cPtr:CDefCounter=CDefCounter(hoCommon.ocObject);
			rsMini = cPtr.ctMini;
			rsMaxi = cPtr.ctMaxi;
			rsMiniDouble=Number(rsMini);
			rsMaxiDouble=Number(rsMaxi);
			rsValue=new CValue(cPtr.ctInit);
			bCounterChanged=true;			
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
				
		public function cpt_ToFloat(pValue:CValue):void
	    {
			if (rsValue.getType()==CValue.TYPE_INT)
			{
			    if (pValue.getType()==CValue.TYPE_INT) 
					return;
			    rsValue.forceDouble(Number(rsValue.getInt()));
			    bCounterChanged=true;
			    roc.rcChanged=true;
			}
			else
			{
			    pValue.convertToDouble();
			}	
	    }
	    public function cpt_Change(pValue:CValue):void
	    {
			if (rsValue.getType()==CValue.TYPE_INT)
			{
			    // Compteur entier
			    var value:int=pValue.getInt();
			    if (value<rsMini) 
					value=rsMini;
			    if (value>rsMaxi) 
					value=rsMaxi;
			    if (value!=rsValue.getInt())
			    {
					rsValue.forceInt(value);
					bCounterChanged=true;
					modifOwnerDrawSprite(0, 0);
					roc.rcChanged=true;
			    }
			}
			else
			{
			    // Compteur float
			    var d:Number=pValue.getDouble();
			    if (d<rsMiniDouble) 
					d=rsMiniDouble;
			    if (d>rsMaxiDouble) 
					d=rsMaxiDouble;
			    if (d!=rsValue.getDouble())
			    {
					rsValue.forceDouble(d);
					bCounterChanged=true;
					modifOwnerDrawSprite(0, 0);
					roc.rcChanged=true;
			    }
			}
	    }
	    public function cpt_Add(pValue:CValue):void
	    {
			cpt_ToFloat(pValue);
			var val:CValue=new CValue(0);
			val.forceValue(rsValue);
			val.add(pValue);
			cpt_Change(val);
	    }
	    public function cpt_Sub(pValue:CValue):void
	    {
			cpt_ToFloat(pValue);
			var val:CValue=new CValue(0);
			val.forceValue(rsValue);
			val.sub(pValue);
			cpt_Change(val);
	    }
	    public function cpt_SetMin(value:CValue):void
	    {
			rsMini=value.getInt();
			rsMiniDouble=value.getDouble();
			var val:CValue=new CValue(0);
			val.forceValue(rsValue);
			cpt_Change(val);
	    }
	    public function cpt_SetMax(value:CValue):void
	    {
			rsMaxi=value.getInt();
			rsMaxiDouble=value.getDouble();
			var val:CValue=new CValue(0);
			val.forceValue(rsValue);
			cpt_Change(val);
	    }
	    public function cpt_SetColor1(rgb:int):void
	    {
			rsColor1=rgb;
			roc.rcChanged=true;
			bCounterChanged=true;
	    }
	    public function cpt_SetColor2(rgb:int):void
	    {
			rsColor2=rgb;
			roc.rcChanged=true;
			bCounterChanged=true;
	    }
	    public function cpt_GetValue():CValue
	    {
			return rsValue;
	    }
	    public function cpt_GetMin():CValue
	    {
			var v:CValue=new CValue(0);
			if (rsValue.type==CValue.TYPE_INT)
			    v.forceInt(rsMini);
			else 
			    v.forceDouble(rsMiniDouble);
			return v;
	    }
	    public function cpt_GetMax():CValue
	    {
			var v:CValue=new CValue(0);
			if (rsValue.type==CValue.TYPE_INT)
			    v.forceInt(rsMaxi);
			else 
			    v.forceDouble(rsMaxiDouble);
			return v;
	    }
	    public function cpt_GetColor1():int
	    {
			return rsColor1;
	    }
	    public function cpt_GetColor2():int
	    {
			return rsColor2;
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
			if (nIndex>=plane.numChildren)
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
			    case 4:	    // CTA_ANIM:
			    	bitmaps[0]=new Bitmap();
			    	computeNewDisplay();
					if (index<0)
						plane.addChild(bitmaps[0]);
					else
						plane.addChildAt(bitmaps[0], index);
					break;
			    case 2:	    // CTA_VBAR:
			    case 3:	    // CTA_HBAR:
			    	shape=new Shape();
			    	computeNewDisplay();
					if (index<0)
						plane.addChild(shape);
					else
						plane.addChildAt(shape, index);
			    	break;
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
			if ( hoCommon.ocCounters==null ) return;

			if (bCounterChanged)
				computeNewDisplay();
			else
			{
				switch(type)
				{
					case 4:
				    	bitmaps[0].x=hoX-hoAdRunHeader.rhWindowX-hoImgXSpot+pLayer.x;
				    	bitmaps[0].y=hoY-hoAdRunHeader.rhWindowY-hoImgYSpot+pLayer.y;
				    	break;
				    case 2:
				    case 3:
				    	shape.x=hoX-hoAdRunHeader.rhWindowX+pLayer.x;
				    	shape.y=hoY-hoAdRunHeader.rhWindowY+pLayer.y;
				    	break;
				    case 1:
				    	var i:int;
				    	for (i=0; i<bitmaps.length; i++)
				    	{
				    		if (bitmaps[i]!=null)
				    		{
				    			bitmaps[i].x=hoX-hoAdRunHeader.rhWindowX+pLayer.x-deltaX[i];
				    			bitmaps[i].y=hoY-hoAdRunHeader.rhWindowY+pLayer.y-hoImgYSpot;
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
					index=plane.getChildIndex(bitmaps[0]);
					plane.removeChild(bitmaps[0]);
					bitmaps[0]=null;
					break;
				case 2:		// CTA_VBAR
				case 3:		// CTA_HBAR
					index=plane.getChildIndex(shape);
					plane.removeChild(shape);
					shape=null;
					break;
				case 1:		// CTA_DIGITS
					var i:int;
					index=plane.getChildIndex(bitmaps[0]);
					for (i=0; i<bitmaps.length; i++)
					{
						if (bitmaps[i]!=null)
						{
							plane.removeChild(bitmaps[i]);
							bitmaps[i]=null;
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
					case 2:
				    case 3:
				    	if (shape!=null)
				    	{
				    		return plane.getChildIndex(shape);
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
					if (bitmaps[0]!=null)
					{
						plane.setChildIndex(bitmaps[0], index);
					}
			    	break;
			    case 2:
			    case 3:
			    	if (shape!=null)
			    	{
			    		plane.setChildIndex(shape, index);
			    	}
			    	break;
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
			var color1:int, color2:int;
	    	var s:String;
			if (bCounterChanged==true)
			{
				bCounterChanged=false;
				
				var adCta:CDefCounters=CDefCounters(hoCommon.ocCounters);
				var vInt:int=0;
				var vDouble:Number=0;
				var nbl:int;
				if ( rsValue.getType()== CValue.TYPE_INT )
				{
				    vInt = rsValue.getInt();
				}
				else
				{
				    vDouble=rsValue.getDouble();
				    vInt = int(vDouble);
				}
				switch (type) 
				{
				    case 4:	    // CTA_ANIM:
						nbl = adCta.nFrames;
						if ( rsMaxi <= rsMini )
						    rsOldFrame = 0;
						else
						    rsOldFrame = Math.min(((vInt - rsMini) * nbl) / (rsMaxi - rsMini), adCta.nFrames-1);
				    	image=hoAdRunHeader.rhApp.imageBank.getImageFromHandle(adCta.frames[Math.max(0, rsOldFrame-1)]);
						hoImgWidth = image.width;
						hoImgHeight = image.height;
						hoImgXSpot = image.xSpot;
						hoImgYSpot = image.ySpot;
				    	bitmaps[0].bitmapData=image.img;
				    	bitmaps[0].x=hoX-hoImgXSpot-hoAdRunHeader.rhWindowX+pLayer.x;
				    	bitmaps[0].y=hoY-hoImgYSpot-hoAdRunHeader.rhWindowY+pLayer.y;
				    	bitmaps[0].visible=bShown;
						var transparency:int=0;
						if ((hoOiList.oilInkEffect&0xFFFF)==1)		// SEMITRANSP
						{			
							transparency=hoOiList.oilEffectParam;
						}	
			    		var v:Number=(Number(128-transparency))/128.0;
						bitmaps[0].alpha=v;
						displayObjects[0]=bitmaps[0];
						break;
				    case 2:	    // CTA_VBAR:
				    case 3:	    // CTA_HBAR:
						nbl = rsBoxCx; 
						if (adCta.odDisplayType == CDefCounters.CTA_VBAR) 
						    nbl=rsBoxCy;
						if ( rsMaxi <= rsMini )
						    rsOldFrame = 0;
						else
						    rsOldFrame = ((vInt - rsMini) * nbl) / (rsMaxi-rsMini);
						hoImgXSpot=0;
					    hoImgYSpot=0;
					    hoImgHeight=rsBoxCy;
					    hoImgWidth=rsBoxCx;

				    	shape.graphics.clear();
				    	shape.x=hoX-hoAdRunHeader.rhWindowX+pLayer.x;
				    	shape.y=hoY-hoAdRunHeader.rhWindowY+pLayer.y;
						shape.visible=bShown;
						
						// Si gradient, calcul de la couleur destination
						if ( adCta.ocFillType == 2 )	// FILLTYPE_GRADIENT 
						{
						    color1 = rsColor1;	// shape.ocFillData.ocColor1;
						    color2 = rsColor2;	// shape.ocFillData.ocColor2;
						    var dl:int = CServices.getRValueFlash(color2)-CServices.getRValueFlash(color1);
						    var r:int = ( (dl * rsOldFrame)/nbl  + CServices.getRValueFlash(color1))&0xFF;
						    dl = CServices.getGValueFlash(color2)-CServices.getGValueFlash(color1);
						    var g:int = ((dl * rsOldFrame)/nbl  + CServices.getGValueFlash(color1))&0xFF;
						    dl = CServices.getBValueFlash(color2)-CServices.getBValueFlash(color1);
						    var b:int = ((dl * rsOldFrame)/nbl  + CServices.getBValueFlash(color1))&0xFF;
						    color2 = CServices.RGBFlash(r,g,b);
				
						    if ( (adCta.odDisplayFlags & CDefCounters.BARFLAG_INVERSE)!=0 )
						    {
								dl = color1;
								color1 = color2;
								color2 = dl;
						    }
						}					
						switch (adCta.ocFillType)
						{
						    case 1:			    // FILLTYPE_SOLID
						    	shape.graphics.beginFill(rsColor1);
								break;
						    case 2:			    // FILLTYPE_GRADIENT
						    	var colors:Array=[color1, color2];
						    	var alphas:Array=[1, 1];
						    	var ratios:Array=[0, 255];
						    	var matr:Matrix=new Matrix();
						    	if (adCta.odDisplayType==3)
						    	{
							    	if (adCta.ocGradientFlags==0)
							    	{
							    		matr.createGradientBox(rsOldFrame, hoImgHeight, 0, 0, 0);
							    	}
							    	else
							    	{
				    					matr.createGradientBox(rsOldFrame, hoImgHeight, Math.PI/2, 0, 0);				    									    	
				    				}
				    			}
				    			else
				    			{
							    	if (adCta.ocGradientFlags==0)
							    	{
							    		matr.createGradientBox(hoImgWidth, rsOldFrame, 0, 0, 0);
							    	}
							    	else
							    	{
				    					matr.createGradientBox(rsOldFrame, hoImgHeight, Math.PI/2, 0, 0);				    									    	
				    				}
				    			}
						    	shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);
								break;
						    default:
								break;
						}
						if ( adCta.odDisplayType == CDefCounters.CTA_HBAR )
						{
						    if ( (adCta.odDisplayFlags & CDefCounters.BARFLAG_INVERSE)==0 )
						    	shape.graphics.drawRect(0, 0, rsOldFrame, hoImgHeight);
						    else
						    	shape.graphics.drawRect(hoImgWidth-rsOldFrame, 0, rsOldFrame, hoImgHeight);
						}
						else
						{
						    if ( (adCta.odDisplayFlags & CDefCounters.BARFLAG_INVERSE)==0 )
						    	shape.graphics.drawRect(0, 0, hoImgWidth, rsOldFrame);
						    else
						    	shape.graphics.drawRect(0, hoImgHeight-rsOldFrame, hoImgWidth, rsOldFrame);
						}
						shape.graphics.endFill();
						displayObjects[0]=shape;

						break;						    
				    case 1:	    // CTA_DIGITS:
						if (rsValue.getType()==CValue.TYPE_INT)
						    s=CServices.intToString(vInt, displayFlags);
						else
						    s=CServices.doubleToString(vDouble, displayFlags);
						
						if (bitmaps[0]!=null)
						{
							nIndex=plane.getChildIndex(bitmaps[0]);
						}
						if (nIndex>=plane.numChildren)
						{
							nIndex=plane.numChildren-1;
							if (nIndex<0)
							{
								nIndex=0;
							}
						}
						
						var i:int;
					    var c:int;
					    var img:int;
						var ifo:CImage;
						var dx:int=0, dy:int=0;
					    var bAdd:Boolean;
					    
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
						var count:int=0;
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
						if (rsValue.getType()==CValue.TYPE_INT)
						    s=CServices.intToString(vInt, displayFlags);
						else
						    s=CServices.doubleToString(vDouble, displayFlags);

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
						if (bShown)
						{
							textField.text=s;
							textField.setTextFormat(format);
						}
						else
						{
							textField.text="";
						}												    
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