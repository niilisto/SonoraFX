//----------------------------------------------------------------------------------
//
// CEXTENSION: Objets d'extension
//
//----------------------------------------------------------------------------------
package Objects
{
	import Actions.*;
	
	import Application.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Events.*;
	
	import Expressions.*;
	
	import Extensions.*;
	
	import Frame.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CExtension extends CObject
	{
	    public var ext:CRunExtension;
	    public var noHandle:Boolean;
	    public var privateData:int = 0;
	    public var objectCount:int;
	    public var objectNumber:int;
	
		public function CExtension(type:int, rhPtr:CRun)
		{
			ext = rhPtr.rhApp.extLoader.loadRunObject(type);
		}
	
	    public override function init(ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
	    {
	        // Initialisation des pointeurs
	        ext.init(this);
	
	        // Initialisation de l'objet
	        var file:CBinaryFile = null;
	        if (ocPtr.ocExtension != null)
	        {
	            file = new CBinaryFile(ocPtr.ocExtension, hoAdRunHeader.rhApp.bUnicode);
	        }
	        privateData = ocPtr.ocPrivate;
	        ext.createRunObject(file, cob, ocPtr.ocVersion);
	        if (roc!=null)
	        {
            	roc.rcChanged = true;
         	}
	    }
	
	    public override function handle():void
	    {
	        // Routines standard;	
	        if ((hoOEFlags & 0x0200) != 0)	// OEFLAG_SPRITE
	        {
	            ros.handle();
	        }
	        else if ((hoOEFlags & 0x0030) == 0x0010 || (hoOEFlags & 0x0030) == 0x0030) // OEFLAG_MOVEMENTS / OEFLAG_ANIMATIONS|OEFLAG_MOVEMENTS
	        {
	            rom.move();
	        }
	        else if ((hoOEFlags & 0x0030) == 0x0020)	// OEFLAG_ANIMATION
	        {
	            roa.animate();
	        }
	
	        // Handle de l'objet
	        var ret:int = 0;
	        if (noHandle == false)
	        {
	            ret = ext.handleRunObject();
	        }
	
	        if ((ret & CRunExtension.REFLAG_ONESHOT) != 0)
	        {
	            noHandle = true;
	        }
	        if (roc != null)
	        {
	            if (roc.rcChanged)
	            {
	                ret |= CRunExtension.REFLAG_DISPLAY;
	                roc.rcChanged = false;
	            }
	        }
	        if ((ret & CRunExtension.REFLAG_DISPLAY) != 0)
	        {
	            modif();
	        }
	    }

	   	public override function modif():void
		{
		    if (ros != null)
		    {
		        ros.modifRoutine();
		    }
		    else 
		    {
		        ext.displayRunObject();
		    }
		}

	   	public override function kill(bFast:Boolean):void
	    {
	        ext.destroyRunObject(bFast);
	    }

		public override function modifSprite(x:int, y:int, i:int, xScale:Number, yScale:Number, rotAngle:int):void
		{
			hoX=x+hoAdRunHeader.rhWindowX;
			hoY=y+hoAdRunHeader.rhWindowY;
			ext.displayRunObject();
		}
		public override function modifOwnerDrawSprite(x:int, y:int):void
		{
			hoX=x+hoAdRunHeader.rhWindowX;
			hoY=y+hoAdRunHeader.rhWindowY;
			ext.displayRunObject();
		}

	    public override function getCollisionMask(flags:int):CMask
	    {
	        return ext.getRunObjectCollisionMask(flags);
	    }
	
	    public function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        return ext.condition(num, cnd);
	    }
	
	    public function action(num:int, act:CActExtension):void
	    {
	        ext.action(num, act);
	    }
	
	    public function expression(num:int):CValue
	    {
	        return ext.expression(num);
	    }
	    
		public function setFocus(bFlag:Boolean):void
		{
			ext.setFocus(bFlag);
		} 
		
		public function click():void
		{
			ext.click();
		} 

		public function doubleClick():void
		{
			ext.doubleClick();
		} 

		public override function showSprite():void
		{
			ext.showSprite();
		}

		public override function hideSprite():void
		{
			ext.hideSprite();			
		}

		public override function getChildIndex():int
		{	
			return ext.getChildIndex();
		}
		public override function getChildMaxIndex():int
		{
			return ext.getChildMaxIndex();
		}
		public override function setChildIndex(index:int):void
		{
			ext.setChildIndex(index);
		}
		public override function setHandCursor(bOn:Boolean):void
		{		
			ext.setHandCursor(bOn);	
		}

		public function pauseRunObject():void
		{
			ext.pauseRunObject();			
		}

		public function continueRunObject():void
		{
			ext.continueRunObject();			
		}
	    ////////////////////////////////////////////////////////////////////////
	    // CALL BACKS
	    ////////////////////////////////////////////////////////////////////////
	    public function loadImageList(list:Array):void
	    {
	        hoAdRunHeader.rhApp.imageBank.loadImageList(list);
	    }
	
	    public function getImage(handle:int):CImage
	    {
	        return hoAdRunHeader.rhApp.imageBank.getImageFromHandle(handle);
	    }
	
	    public function getApplication():CRunApp
	    {
	        return hoAdRunHeader.rhApp;
	    }
	
	    public function getX():int
	    {
	        return hoX;
	    }
	
	    public function getY():int
	    {
	        return hoY;
	    }
	
	    public function getWidth():int
	    {
	        return hoImgWidth;
	    }
	
	    public function getHeight():int
	    {
	        return hoImgHeight;
	    }
	
	    public function setX(x:int):void
	    {
	        if (rom != null)
	        {
	            rom.rmMovement.setXPosition(x);
	        }
	        else
	        {
	            hoX = x;
	            if (roc != null)
	            {
	                roc.rcChanged = true;
	                roc.rcCheckCollides = true;
	            }
	        }
	    }
	
	    public function setY(y:int):void
	    {
	        if (rom != null)
	        {
	            rom.rmMovement.setYPosition(y);
	        }
	        else
	        {
	            hoY = y;
	            if (roc != null)
	            {
	                roc.rcChanged = true;
	                roc.rcCheckCollides = true;
	            }
	        }
	    }
	
	    public function setWidth(width:int):void
	    {
	        hoImgWidth = width;
	    }
	
	    public function setHeight(height:int):void
	    {
	        hoImgHeight = height;
	    }
		
		public function scaleX(x:int):int
		{
			return hoAdRunHeader.scaleX(x);
		}
		
		public function scaleY(y:int):int
		{
			return hoAdRunHeader.scaleY(y);
		}
			
	    public function reHandle():void
	    {
	        noHandle = false;
	    }
	
	    public function generateEvent(code:int, param:int):void
	    {
	        if (hoAdRunHeader.rh2PauseCompteur == 0)
	        {
	            var p0:int = hoAdRunHeader.rhEvtProg.rhCurParam0;
	            hoAdRunHeader.rhEvtProg.rhCurParam0 = param;
	
	            code = (-(code + CEventProgram.EVENTS_EXTBASE + 1) << 16);
	            code |= (hoType & 0xFFFF);
	            hoAdRunHeader.rhEvtProg.handle_Event(this, code);
	
	            hoAdRunHeader.rhEvtProg.rhCurParam0 = p0;
	        }
	    }
	
	    public function pushEvent(code:int, param:int):void
	    {
	        if (hoAdRunHeader.rh2PauseCompteur == 0)
	        {
	            code = (-(code + CEventProgram.EVENTS_EXTBASE + 1) << 16);
	            code |= (hoType & 0xFFFF);
	            hoAdRunHeader.rhEvtProg.push_Event(1, code, param, this, hoOi);
	        }
	    }
	
	    public function pause():void
	    {
	        hoAdRunHeader.pause();
	    }
	
	    public function resume():void
	    {
	        hoAdRunHeader.resume();
	    }
	
	    public function redraw():void
	    {
	        if ((hoOEFlags & (CObjectCommon.OEFLAG_ANIMATIONS | CObjectCommon.OEFLAG_MOVEMENTS | CObjectCommon.OEFLAG_SPRITES)) != 0)
	        {
	            roc.rcChanged = true;
	        }
			else
			{
				modif();
			}
	    }
	
	    public function destroy():void
	    {
	        hoAdRunHeader.destroy_Add(hoNumber);
	    }
	
	    public function setPosition(x:int, y:int):void
	    {
	        if (rom != null)
	        {
	            rom.rmMovement.setXPosition(x);
	            rom.rmMovement.setYPosition(y);
	        }
	        else
	        {
	            hoX = x;
	            hoY = y;
	            if (roc != null)
	            {
	                roc.rcChanged = true;
	                roc.rcCheckCollides = true;
	            }
	        }
	    }
	
	    public function getExtUserData():int
	    {
	        return privateData;
	    }
	
	    public function setExtUserData(data:int):void
	    {
	        privateData = data;
	    }
	
	    public function addBackdrop(img:CImage, x:int, y:int, typeObst:int, nLayer:int):void
	    {
	    	hoAdRunHeader.addBackdrop(img, x, y, nLayer, typeObst);
	    }
	
	    public function getEventCount():int
	    {
	        return hoAdRunHeader.rh4EventCount;
	    }
	
	    public function getExpParam():CValue
	    {
	        hoAdRunHeader.rh4CurToken++;		// Saute la fonction
	        return hoAdRunHeader.getExpression();
	    }
	
	    public function getEventParam():int
	    {
	        return hoAdRunHeader.rhEvtProg.rhCurParam0;
	    }
	
	    public function callMovement(hoPtr:CObject, action:int, param:Number):Number
	    {
	        if ((hoPtr.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) != 0)
	        {
	            if (hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
	            {
	                var mvPtr:CMoveExtension = CMoveExtension(hoPtr.rom.rmMovement);
	                return mvPtr.callMovement(action, param);
	            }
	        }
	        return 0;
	    }
		
		public function callExpression(hoPtr:CObject, action:int, param:int):CValue {
			var pExtension:CExtension=CExtension(hoPtr);
			pExtension.privateData=param;
			return pExtension.expression(action);
		}
		
	    public function getFirstObject():CObject
	    {
	        objectCount = 0;
	        objectNumber = 0;
	        return getNextObject();
	    }
	
	    public function getNextObject():CObject 
	    {
	        if (objectNumber < hoAdRunHeader.rhNObjects)
	        {
	            while (hoAdRunHeader.rhObjectList[objectCount] == null)
	            {
	                objectCount++;
	            }
	            var hoPtr:CObject = hoAdRunHeader.rhObjectList[objectCount];
	            objectNumber++;
	            objectCount++;
	            return hoPtr;
	        }
	        return null;
	    }
	
	    public function getObjectFromFixed(fixed:int):CObject 
	    {
	        var count:int = 0;
	        var number:int;
	        for (number = 0; number < hoAdRunHeader.rhNObjects; number++)
	        {
	            while (hoAdRunHeader.rhObjectList[count] == null)
	            {
	                count++;
	            }
	            var hoPtr:CObject = hoAdRunHeader.rhObjectList[count];
	            count++;
	            var id:int = (hoPtr.hoCreationId << 16) | (hoPtr.hoNumber & 0xFFFF);
	            if (id == fixed)
	            {
	                return hoPtr;
	            }
	        }
	        return null;
	    }
	
	    public function openHFile(path:String):CBinaryFile
	    {
	        return hoAdRunHeader.rhApp.openHFile(path);
	    }	
		
		public function closeHFile(path:String):void
		{
			hoAdRunHeader.rhApp.closeHFile(path);
		}
	}
}