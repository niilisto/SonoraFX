//----------------------------------------------------------------------------------
//
// CCCA : Objet sub-application
//
//----------------------------------------------------------------------------------

package Objects
{
	import Application.CRunApp;
	
	import Expressions.CValue;
	
	import Frame.CLayer;
	
	import OI.CDefCCA;
	import OI.CObjectCommon;
	
	import RunLoop.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class CCCA extends CObject
	{
	    public static var CCAF_SHARE_GLOBALVALUES:int=0x00000001;
	    public static var CCAF_SHARE_LIVES:int=0x00000002;
	    public static var CCAF_SHARE_SCORES:int=0x00000004;
	    public const CCAF_SHARE_WINATTRIB:int=0x00000008;
	    public const CCAF_STRETCH:int=0x00000010;
	    public const CCAF_POPUP:int=0x00000020;
	    public const CCAF_CAPTION:int=0x00000040;
	    public const CCAF_TOOLCAPTION:int=0x00000080;
	    public const CCAF_BORDER:int=0x00000100;
	    public const CCAF_WINRESIZE:int=0x00000200;
	    public const CCAF_SYSMENU:int=0x00000400;
	    public const CCAF_DISABLECLOSE:int=0x00000800;
	    public const CCAF_MODAL:int=0x00001000;
	    public const CCAF_DIALOGFRAME:int=0x00002000;
	    public const CCAF_INTERNAL:int=0x00004000;
	    public const CCAF_HIDEONCLOSE:int=0x00008000;
	    public const CCAF_CUSTOMSIZE:int=0x00010000;
	    public const CCAF_INTERNALABOUTBOX:int=0x00020000;
	    public const CCAF_CLIPSIBLINGS:int=0x00040000;
	    public static var CCAF_SHARE_PLAYERCTRLS:int=0x00080000;
	    public const CCAF_MDICHILD:int=0x00100000;
	    public static var CCAF_DOCKED:int=0x00200000;
	    public const CCAF_DOCKING_AREA:int=0x00C00000;
	    public const CCAF_DOCKED_LEFT:int=0x00000000;
	    public const CCAF_DOCKED_TOP:int=0x00400000;
	    public const CCAF_DOCKED_RIGHT:int=0x00800000;
	    public const CCAF_DOCKED_BOTTOM:int=0x00C00000;
	    public const CCAF_REOPEN:int=0x01000000;
	    public const CCAF_MDIRUNEVENIFNOTACTIVE:int=0x02000000;
	    public static var CCAF_HIDDENATSTART:int=0x04000000;

	    public var flags:int;
	    public var odOptions:int;
	    public var subApp:CRunApp;
	    public var oldX:int;
	    public var oldY:int;
		public var oldWidth:int;
		public var oldHeight:int;
	    public var level:int=-1;
	    public var oldLevel:int=-1;
		public var appSprite:Sprite;
		public var layer:CLayer;
		public var bVisible:Boolean;
		
	    public function startCCA(ocPtr:CObjectCommon, bInit:Boolean, nStartFrame:int):void
	    {
	        var defCCA:CDefCCA = CDefCCA(ocPtr.ocObject);
	
	        hoImgWidth = defCCA.odCx;
	        hoImgHeight = defCCA.odCy;
	        odOptions = defCCA.odOptions;
	
	        // Stretch? force custom size option
	        if ((odOptions & CCAF_STRETCH) != 0)
	        {
	            odOptions |= CCAF_CUSTOMSIZE;
	        }
	
	        // Get start frame
	        if (nStartFrame == -1)
	        {
	            nStartFrame = 0;
	            if ((odOptions & CCAF_INTERNAL) != 0)
	            {
	                nStartFrame = defCCA.odNStartFrame;
	            }
	        }
	
	        // Change l'extension
	        if (defCCA.odName==null || defCCA.odName.length!=0)
	        {
	        	return;
	        }
            if ((odOptions & CCAF_INTERNAL) == 0)
            {
                return;
            }
            // Internal frame, check it exists and is different from the current one
            if (nStartFrame >= hoAdRunHeader.rhApp.gaNbFrames)
            {
                return;
            }
            if (nStartFrame == hoAdRunHeader.rhApp.currentFrame)
            {
                return;
            }
	
	        // Starts the application
			layer=hoAdRunHeader.rhFrame.layers[hoAdRunHeader.rhFrame.nLayers-1];
	        appSprite=new Sprite();
	        appSprite.x=hoX-hoAdRunHeader.rhWindowX;
	        appSprite.y=hoY-hoAdRunHeader.rhWindowY;
	        appSprite.visible=true;
	        oldX=hoX;
	        oldY=hoY;
			oldWidth=hoImgWidth;
			oldHeight=hoImgHeight;
	        if ((ocPtr.ocFlags2 & CObjectCommon.OCFLAGS2_VISIBLEATSTART)!=0)
	        {
				hoAdRunHeader.rhApp.planeControls.addChild(appSprite);
				bVisible=true;
	        }
	        else
	        {
				hoAdRunHeader.rhApp.planeControls.addChild(appSprite);
				appSprite.visible=false;
	        	bVisible=false;
	        }
	        subApp = new CRunApp(hoAdRunHeader.rhApp.ccj, null, null, null);
	        subApp.setParentApp(hoAdRunHeader.rhApp, nStartFrame, odOptions, appSprite, hoImgWidth, hoImgHeight);
	
	        // Chargement de l'application
            subApp.load();
            subApp.startApplication();
        	subApp.setMouseOffsets(hoAdRunHeader.rhApp.xMouseOffset+appSprite.x, hoAdRunHeader.rhApp.yMouseOffset+appSprite.y);
            subApp.playApplication(true);
	    }
	    public override function init(ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
	    {
            startCCA(ocPtr, true, -1);
	    }
		public override function setHandCursor(bOn:Boolean):void
		{
			appSprite.buttonMode=bOn;
			appSprite.useHandCursor=bOn;
		}
	    public override function handle():void
	    {
	        rom.move();
	        if (subApp != null)
	        {
	            if (oldX != hoX || oldY != hoY)
	            {
					if (hoImgWidth!=oldWidth || hoImgHeight!=oldHeight)
					{
						subApp.changeWindowDimensions(hoImgWidth, hoImgHeight);
						oldWidth = hoImgWidth;
						oldHeight = hoImgHeight;
					}

	            	appSprite.x=hoX-hoAdRunHeader.rhWindowX;
	            	appSprite.y=hoY-hoAdRunHeader.rhWindowY;	            	
	            	oldX=hoX;
	            	oldY=hoY;
	            	subApp.setMouseOffsets(appSprite.x, appSprite.y);
	            }
                if (subApp.playApplication(false) == false)
                {
                	destroyObject();
                    subApp.endApplication();
                    subApp = null;
                    return;
                }
                oldLevel = level;
                level = subApp.currentFrame;
	        }
	    }
	    public override function kill(bFast:Boolean):void
	    {
	        if (subApp != null)
	        {
	            // End of current frame
	            switch (subApp.appRunningState)
	            {
	                // Frame loop
	                case 3:	    // SL_FRAMELOOP:
	                    subApp.endFrame();
	                    break;
	            }
	
	            // End of application
	            destroyObject();
	            subApp.endApplication();
	            subApp = null;
	        }
	    }
	    public function destroyObject():void
	    {
	    	if (bVisible)
	    	{
	    		hoAdRunHeader.rhApp.planeControls.removeChild(appSprite);
	    	}
	    }
	    public function restartApp():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.rhQuit = CRun.LOOPEXIT_NEWGAME;
	                return;
	            }
	            kill(true);
	        }
	        startCCA(hoCommon, false, -1);
	    }

	    public function endApp():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.rhQuit = CRun.LOOPEXIT_ENDGAME;
	            }
	        }
	    }
	
	    public function hide():void
	    {
	    	appSprite.visible=false;
	    	bVisible=false;
	    }
	
	    public function show():void
	    {
			if (subApp != null)
			{
				subApp.flushKeyboard();
			}
	    	appSprite.visible=true;
	    	bVisible=true;
	    }

	    public function jumpFrame(frame:int):void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	            	if (frame>=0 && frame<4096)
	            	{
		                subApp.run.rhQuit = CRun.LOOPEXIT_GOTOLEVEL;
		                subApp.run.rhQuitParam = 0x8000 | frame;
		            }
	            }
	        }
	    }
	
	    public function nextFrame():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.rhQuit = CRun.LOOPEXIT_NEXTLEVEL;
	            }
	        }
	    }
	
	    public function previousFrame():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.rhQuit = CRun.LOOPEXIT_PREVLEVEL;
	            }
	        }
	    }
	
	    public function restartFrame():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.rhQuit = CRun.LOOPEXIT_RESTART;
	            }
	        }
	    }

	    public function pause():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.pause();
	            }
	        }
	    }
	
	    public function resume():void
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                subApp.run.resume();
	            }
	        }
	    }
	
		public function setWidth(width:int):void {
			if (subApp!=null)
			{
				hoImgWidth=width;
			}
		}
		
		public function setHeight(height:int):void {
			if (subApp!=null)
			{
				hoImgHeight=height;
			}
		}
		
		public function setGlobalValue(number:int, value:CValue):void
	    {
	        if (subApp != null)
	        {
	            subApp.setGlobalValueAt(number, value);
	        }
	    }
	
	    public function setGlobalString(number:int, value:String):void
	    {
	        if (subApp != null)
	        {
	            subApp.setGlobalStringAt(number, value);
	        }
	    }

	    public function isPaused():Boolean
	    {
	        if (subApp != null)
	        {
	            if (subApp.run != null)
	            {
	                return subApp.run.rh2PauseCompteur != 0;
	            }
	        }
	        return false;
	    }
	
	    public function appFinished():Boolean
	    {
	        return subApp == null;
	    }
	
	    public function isVisible():Boolean
	    {
	    	return bVisible;
	    }

	    public function frameChanged():Boolean
	    {
	        return level != oldLevel;
	    }
	
	    public function getGlobalString(num:int):String
	    {
	        if (subApp != null)
	        {
	            return subApp.getGlobalStringAt(num);
	        }
	        return "";
	    }
	
	    public function getGlobalValue(num:int):CValue
	    {
	        if (subApp != null)
	        {
	            return subApp.getGlobalValueAt(num);
	        }
	        return new CValue(0);
	    }

	    public function getFrameNumber():int
	    {
	        return level + 1;
	    }
	
	    public function bringToFront():void
	    {
	        if (subApp != null)
	        {
	        	if (bVisible)
	        	{
	        		hoAdRunHeader.rhApp.planeControls.removeChild(appSprite);
	        		hoAdRunHeader.rhApp.planeControls.addChild(appSprite);
	        	}
	        }
	    }

	    public function sendKey(keyCode:int, bState:Boolean):void
	    {
	        if (subApp != null)
	        {
                subApp.receiveKey(keyCode, bState);
	        }
    	}
	}
}