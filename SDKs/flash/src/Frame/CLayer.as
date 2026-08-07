//----------------------------------------------------------------------------------
//
// CRUNFRAME : Classe Frame
//
//----------------------------------------------------------------------------------
package Frame
{
	import Application.CRunApp;
	
	import Services.*;
	
	import Sprites.*;
	
	import RunLoop.CRun;
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class CLayer
	{
    	public static var FLOPT_XCOEF:int=0x0001;
    	public static var FLOPT_YCOEF:int=0x0002;
    	public static var FLOPT_NOSAVEBKD:int=0x0004;
    	public static var FLOPT_VISIBLE:int=0x0010;
    	public static var FLOPT_WRAP_HORZ:int=0x0020;
    	public static var FLOPT_WRAP_VERT:int=0x0040;
    	public static var FLOPT_REDRAW:int=0x000010000;
    	public static var FLOPT_TOHIDE:int=0x000020000;
    	public static var FLOPT_TOSHOW:int=0x000040000;
    
    	public var app:CRunApp;
    	public var pName:String;			// Name

	    // Offset
	    public var x:int;				// Current offset
	    public var y:int;
	    public var dx:int;				// Offset to apply to the next refresh
	    public var dy:int;

		public var pObstacles:CArrayList;
		public var pPlatforms:CArrayList;
		
    	public var addedBackdrops:CArrayList;
    	public var bVisible:Boolean;
    	
    	// Ladders
    	public var pLadders:CArrayList;

    	// Z-order max index for dynamic objects
    	public var nZOrderMax:int;

    	// Permanent data (EditFrameLayer)
    	public var dwOptions:int;			// Options
    	public var xCoef:Number;
    	public var yCoef:Number;
    	public var nBkdLOs:int;				// Number of backdrop objects
    	public var nFirstLOIndex:int;			// Index of first backdrop object in LO table
		
		public var effect:int;
		public var effectParam:int;

    	// Backup for restart
    	public var backUp_dwOptions:int;
    	public var backUp_xCoef:Number;
    	public var backUp_yCoef:Number;
    	public var backUp_nBkdLOs:int;
    	public var backUp_nFirstLOIndex:int;
		// Specific fro Flash Runtime
    	public var planeBack:Sprite;
    	public var planeQuickDisplay:Sprite;
    	public var planeSprites:Sprite;
		
		public function CLayer(a:CRunApp)
		{
			app=a;
		}
    	public function load(file:CFile):void
    	{
			dwOptions=file.readAInt();
			xCoef=file.readAFloat();
			yCoef=file.readAFloat();
			nBkdLOs=file.readAInt();
			nFirstLOIndex=file.readAInt();
			pName=file.readAString();

			backUp_dwOptions=dwOptions;
			backUp_xCoef=xCoef;
			backUp_yCoef=yCoef;
			backUp_nBkdLOs=nBkdLOs;
			backUp_nFirstLOIndex=nFirstLOIndex;
    	}
    	public function reset():void
    	{    		
		    // Initialize permanent data
		    dwOptions = backUp_dwOptions;
		    xCoef = backUp_xCoef;
		    yCoef = backUp_yCoef;
		    nBkdLOs = backUp_nBkdLOs;
		    nFirstLOIndex = backUp_nFirstLOIndex;
	
		    // Initialize volatil data
		    x = y = dx = dy = 0;
	
		    // Free additional backdrops
		    pObstacles=null;
		    pPlatforms=null;
		    pLadders=null;
		    addedBackdrops=null;

		    // Reset show
		    if ((dwOptions&FLOPT_TOHIDE)!=0)
			{
				bVisible=true;
				hide();
			}
			else
			{
				bVisible=false;
				hide();
			}
			show();
    	}
    	public function deleteBackObjects():void
    	{
    		while(planeBack.numChildren>0)
    		{
    			planeBack.removeChildAt(0);
    		}
    	}
    	public function addObstacle(bi:CBackInstance):void
    	{
    		if (pObstacles==null)
    		{
    			pObstacles=new CArrayList();
    		}
    		pObstacles.add(bi);
    	}
    	public function delObstacle(bi:CBackInstance):void
    	{
    		if (pObstacles!=null)
    		{
    			pObstacles.removeObject(bi);
    		}
    	}
    	public function addPlatform(bi:CBackInstance):void
    	{
    		if (pPlatforms==null)
    		{
    			pPlatforms=new CArrayList();
    		}
    		pPlatforms.add(bi);
    	}
    	public function delPlatform(bi:CBackInstance):void
    	{
    		if (pPlatforms!=null)
    		{
    			pPlatforms.removeObject(bi);
    		}
    	}
    	public function addBackdrop(bi:CBackInstance):void
    	{
    		if (addedBackdrops==null)
    		{
    			addedBackdrops=new CArrayList();
    		}
    		addedBackdrops.add(bi);
    	}
    	public function resetLevelBackground():void
    	{
			pPlatforms=null;
			pObstacles=null;
			pLadders=null;
			addedBackdrops=null;    		
			while(planeBack.numChildren>0)
			{
				planeBack.removeChildAt(0);
			}			
    	}
    	public function createPlanes(xOffset:int, yOffset:int):void
    	{
			planeBack=new Sprite();
			planeBack.x=xOffset;
			planeBack.y=yOffset;
			planeQuickDisplay=new Sprite();
			planeQuickDisplay.x=xOffset;
			planeQuickDisplay.y=yOffset;
			
			planeSprites=new Sprite();
			planeSprites.x=xOffset;
			planeSprites.y=yOffset;
			
			app.mainSprite.addChild(planeBack);
			app.mainSprite.addChild(planeQuickDisplay);
			app.mainSprite.addChild(planeSprites);
			bVisible=true;    		
			
			setEffect(effect, effectParam);
    	}
    	public function resetPlanes(xOffset:int, yOffset:int):void
    	{
			planeBack.x=xOffset;
			planeBack.y=yOffset;
			planeQuickDisplay.x=xOffset;
			planeQuickDisplay.y=yOffset;			
			planeSprites.x=xOffset;
			planeSprites.y=yOffset;			
			show();    		
    	}
    	
    	public function fillBack(sx:int, sy:int, color:int):void
    	{
			planeBack.graphics.clear();
			planeBack.graphics.beginFill(color);
			planeBack.graphics.drawRect(0, 0, sx, sy);
			planeBack.graphics.endFill();	
    	}
    	public function setHandCursor(bOn:Boolean):void
    	{
			planeBack.buttonMode=bOn;
			planeBack.useHandCursor=bOn;
    	}
    	public function hide():void
    	{
    		if(bVisible) {
				planeBack.visible=false;
    			planeQuickDisplay.visible=false;
    			planeSprites.visible=false;
    			bVisible=false;
			}
    	}
    	public function show():void
    	{
			if(!bVisible) {
    			planeBack.visible=true;
    			planeQuickDisplay.visible=true;
    			planeSprites.visible=true;
    			bVisible=true;
			}
    	}
    	public function deletePlanes():void
    	{
    		if (planeBack!=null)
    		{
	    		app.mainSprite.removeChild(planeBack);
	    		planeBack=null;
	    	}
	    	if (planeQuickDisplay!=null)
	    	{
	    		app.mainSprite.removeChild(planeQuickDisplay);
	    		planeQuickDisplay=null;
	    	}
	    	if (planeSprites!=null)
	    	{
	    		app.mainSprite.removeChild(planeSprites);
	    		planeSprites=null;
	    	}
    	}
    	public function deleteAddedBackdrops():void
    	{
    		var n:int;
    		if (addedBackdrops!=null)
    		{
    			for (n=0; n<addedBackdrops.size(); n++)
    			{
    				var bi:CBackInstance=CBackInstance(addedBackdrops.get(n));
					if (app.run.rh4Box2DObject && app.run.rh4Box2DBase != null && bi != null)
					{
						app.run.rh4Box2DBase.rSubABackdrop(bi.body);
					}
    				bi.delInstance(this);
    			}
    		}

    		addedBackdrops=null;
			
    	}
    	public function deleteAddedBackdropsAt(xx:int, yy:int, fine:Boolean):Boolean
    	{
    		xx+=x;
    		yy+=y;
    		
    		var n:int;
    		if (addedBackdrops!=null)
    		{
    			for (n=0; n<addedBackdrops.size(); n++)
    			{
    				var bi:CBackInstance=CBackInstance(addedBackdrops.get(n));
    				if (xx>=bi.x && xx<bi.x+bi.width)
    				{
    					if (yy>=bi.y && yy<bi.y+bi.height)
    					{
    						var flag:Boolean=true;
    						if (fine)
    						{
								flag=bi.testPoint(xx, yy);
    						}
    						if (flag)
    						{
								if (app.run.rh4Box2DObject && app.run.rh4Box2DBase != null && bi != null)
								{
									app.run.rh4Box2DBase.rSubABackdrop(bi.body);
								}
    							bi.delInstance(this);
    							addedBackdrops.removeObject(bi);
    							return true;
    						}
    					}
    				}
    			}
    		}
			return false;
    	}

    	// Add ladder
    	public function addLadder(x1:int, y1:int, x2:int, y2:int):void
    	{
		    var rc:CRect=new CRect();
		    rc.left = x1;
		    rc.top = y1;
		    rc.right = x2;
		    rc.bottom = y2;				    
		    if (pLadders==null)
		    {
				pLadders=new CArrayList();
		    }
		    pLadders.add(rc);    		
    	}
	    // Remove ladder
	    public function ladderSub(x1:int, y1:int, x2:int, y2:int):void
	    {
		    if ( pLadders != null )
		    {
				var rc:CRect=new CRect();
				rc.left = Math.min (x1, x2);
				rc.top = Math.min (y1, y2);
				rc.right = Math.max (x1, x2);
				rc.bottom = Math.max (y1, y2);
		
				var i:int;
				var rcDst:CRect;
				var ladder_size:int = pLadders.size();
				for (i=0; i<ladder_size; i++)
				{
				    rcDst=CRect(pLadders.get(i));
				    if (rcDst.intersectRect(rc)==true)
				    {
						pLadders.removeIndex(i);
						ladder_size = pLadders.size();
						i--;
				    }
				}
			}
	    }
	    public function getLadderAt(xx:int, yy:int):CRect
	    {
			var nl:int, nLayers:int;
			xx+=x;
			yy+=y;
			
		    if (pLadders!=null)
		    {
				var i:int;
				var rc:CRect;
				var ladder_size:int = pLadders.size();
				for (i=0; i<ladder_size; i++)
				{
				    rc=CRect(pLadders.get(i));
				    if ( xx >= rc.left )
				    {
						if ( yy >= rc.top )
						{
						    if ( xx < rc.right )
						    {
								if ( yy < rc.bottom )
								{
								    return rc;
								}
						    }
						}
				    }
				}
		    }
			return null;
    	}
    	public function testMask(mask:CMask, xx:int, yy:int, htFoot:int, plan:int):CBackInstance
    	{
    		var xLeft:int=xx+x-mask.xSpot;
    		var yTop:int=yy+y-mask.ySpot;
    		var xRight:int=xLeft+mask.width;
    		var yBottom:int=yTop+mask.height;
    		var yFoot:int=yTop;
    		if (htFoot!=0)
    		{
    			yFoot=yBottom-htFoot;    			
    		}

    		var o:int;
			var bi:CBackInstance;
    		var list:CArrayList;
    		if (plan==CColMask.CM_TEST_OBSTACLE)
    		{
    			list=pObstacles;
    		}
    		else
    		{
    			list=pPlatforms;
    		}
    		if (list==null)
    		{
    			return null;
    		}
    		var list_size:int = list.size();
    		for (o=0; o<list_size; o++)
    		{
    			bi=CBackInstance(list.get(o));
    			if (bi.x<xRight && bi.x+bi.width>xLeft)
    			{
    				if (bi.y<yBottom && bi.y+bi.height>yFoot)
    				{
    					if (bi.testMask(mask, xLeft, yTop, htFoot))
    					{
    						return bi;
    					}
    				}
    			}
    		}
    		return null;
    	}
    	public function testRect(x1:int, y1:int, x2:int, y2:int, htFoot:int, plan:int):CBackInstance
    	{
    		var list:CArrayList;
    		if (plan==CColMask.CM_TEST_OBSTACLE)
    		{
    			list=pObstacles;
    		}
    		else
    		{
    			list=pPlatforms;
    		}
    		if (list==null)
    		{
    			return null;
    		}
    		
    		x1+=x;
    		y1+=y;
    		x2+=x;
    		y2+=y;
    		if (htFoot!=0)
    		{
    			y1=y2-htFoot;    			
    		}

    		var o:int;
			var list_size:int = list.size();
    		for (o=0; o<list_size; o++)
    		{
    			var bi:CBackInstance=CBackInstance(list.get(o));
    			if (bi.x<x2 && bi.x+bi.width>x1)
    			{
    				if (bi.y<y2&& bi.y+bi.height>y1)
    				{
    					if (bi.testRect(x1, y1, x2, y2))
    					{
    						return bi;
    					}
    				}
    			}
    		}
    		return null;
    	}
    	public function testPoint(x1:int, y1:int, plan:int):CBackInstance
    	{
    		var list:CArrayList;
    		if (plan==CColMask.CM_TEST_OBSTACLE)
    		{
    			list=pObstacles;
    		}
    		else
    		{
    			list=pPlatforms;
    		}
    		if (list==null)
    		{
    			return null;
    		}
    		
    		x1+=x;
    		y1+=y;

    		var o:int;
			var list_size:int = list.size();
    		for (o=0; o<list_size; o++)
    		{
    			var bi:CBackInstance=CBackInstance(list.get(o));
    			if (x1>=bi.x && x1<bi.x+bi.width)
    			{
    				if (y1>=bi.y && y1<bi.y+bi.height)
    				{
    					if (bi.testPoint(x1, y1))
    					{
    						return bi;
    					}
    				}
    			}
    		}
    		return null;
    	}
		public function setEffect(e:int, eParam:int):void
		{
			var eMasked:int=effect&CRSpr.BOP_MASK;
			
			var alpha:Number=1.0;
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
			else if (eMasked == CRSpr.BOP_BLEND)
			{
				alpha = ((128 - effectParam) / 128.0);
			}
			switch(eMasked)
			{
				case CRSpr.BOP_ADD:
					setBlendMode("add");
					setTransform(new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0));  
					break;
				case CRSpr.BOP_SUB:
					setBlendMode("subtract");
					setTransform(new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0));  
					break;
				case CRSpr.BOP_INVERT:
					setBlendMode("normal");
					setTransform(new ColorTransform(-r/255.0, -g/255.0, -b/255.0, 1, 255, 255, 255, 0));  
					break;
				default: 
					setBlendMode("normal");
					setTransform(new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0));  
					break;
			}
			setAlpha(alpha);
		}
		public function setBlendMode(mode:String):void
		{
			planeBack.blendMode=mode;
			planeQuickDisplay.blendMode=mode;
			planeSprites.blendMode=mode;			
		}
		public function setTransform(transform:ColorTransform):void
		{
			planeBack.transform.colorTransform=transform;
			planeQuickDisplay.transform.colorTransform=transform;
			planeSprites.transform.colorTransform=transform;			
		}
		public function setAlpha(alpha:Number):void
		{
			planeBack.alpha=alpha;
			planeQuickDisplay.alpha=alpha;
			planeSprites.alpha=alpha;			
		}
	}
}