//----------------------------------------------------------------------------------
//
// COBJECT : Classe de base d'un objet'
//
//----------------------------------------------------------------------------------
package Objects
{
	import Animations.*;
	
	import Banks.*;
	
	import Frame.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import Values.*;
	
	public class CObject
	{
	    public static var HOF_DESTROYED:int=0x0001;
	    public static var HOF_TRUEEVENT:int=0x0002;
	    public static var HOF_REALSPRITE:int=0x0004;
	    public static var HOF_FADEIN:int=0x0008;
	    public static var HOF_FADEOUT:int=0x0010;
	    public static var HOF_OWNERDRAW:int=0x0020;
	    public static var HOF_NOCOLLISION:int=0x2000;
	    public static var HOF_FLOAT:int=0x4000;
	    public static var HOF_STRING:int=0x8000;
		
	    // HeaderObject
	    public var hoNumber:int;					// Number of the object
	    public var hoNextSelected:int;				// Selected object list!!! DO NOT CHANGE POSITION!!!
	
	    public var hoAdRunHeader:CRun;                                  // Run-header address
	    public var hoHFII:int;					// Number of LevObj
	    public var hoOi:int;						// Number of OI
	    public var hoNumPrev:int;					// Same OI previous object
	    public var hoNumNext:int;					// ... next
	    public var hoType:int;					// Type of the object
	    public var hoCreationId:int;                                  // Number of creation
	    public var hoOiList:CObjInfo;                                   // Pointer to OILIST information
	    public var hoEvents:int;					// Pointer to specific events
	    public var hoPrevNoRepeat:CArrayList;                       // One-shot event handling
	    public var hoBaseNoRepeat:CArrayList;
	
	    public var hoMark1:int;                                         // #of loop marker for the events
	    public var hoMark2:int;
	    public var hoMT_NodeName:String;				// Name fo the current node for path movements
	
	    public var hoEventNumber:int;                                   // Number of the event called (for extensions)
	    public var hoCommon:CObjectCommon;				// Common structure address
	
	    public var hoCalculX:int;					// Low weight value
	    public var hoX:int;                                             // X coordinate
	    public var hoCalculY:int;					// Low weight value
	    public var hoY:int;						// Y coordinate
	    public var hoImgXSpot:int;					// Hot spot of the current image
	    public var hoImgYSpot:int;
	    public var hoImgWidth:int;					// Width of the current picture
	    public var hoImgHeight:int;
		
		public var hoImgXAP:int;
		public var hoImgYAP:int;
		
	    public var hoOEFlags:int;					// Objects flags
	    public var hoFlags:int;					// Flags
	    public var hoSelectedInOR:int;                                 // Selection lors d'un evenement OR
	    public var hoOffsetValue:int;                                   // Values structure offset
	    public var hoLayer:int;                                         // Layer
	
	    public var hoLimitFlags:int;                                  // Collision limitation flags
	    public var hoNextQuickDisplay:int;                            // Quickdraw list
	
	    public var hoCurrentParam:int;                                  // Address of the current parameter
	
	    public var hoIdentifier:int;                                    // ASCII identifier of the object
	    public var hoCallRoutine:Boolean;
	    
	    // Classes de gestion communes
	    public var roc:CRCom;       
	    public var rom:CRMvt;
	    public var roa:CRAni;
	    public var rov:CRVal;
	    public var ros:CRSpr;
	
		public function CObject()
		{
		}
		
	    // Routines diverses
	    public function setScale(fScaleX:Number, fScaleY:Number):void
	    {	    	
			if ( roc.rcScaleX != fScaleX || roc.rcScaleY != fScaleY )
			{
				if (fScaleX>=0)
				{
			    	roc.rcScaleX = fScaleX;
			 	}
			 	if (fScaleY>=0)
			 	{
			    	roc.rcScaleY = fScaleY;
			  	}
			    roc.rcChanged = true;

	            var ifo:CImage = hoAdRunHeader.rhApp.imageBank.getImageInfoEx(roc.rcImage, roc.rcAngle, roc.rcScaleX, roc.rcScaleY);
				
	            hoImgWidth=ifo.width;
	            hoImgHeight=ifo.height;
	            hoImgXSpot=ifo.xSpot;
	            hoImgYSpot=ifo.ySpot;			    
				hoImgXAP=ifo.xAP;
				hoImgYAP=ifo.yAP;			    
			}
	    }        

	    // SHOOT : Cree la balle
	    // ----------------------
	    public function shtCreate(p:PARAM_SHOOT, x:int, y:int, dir:int):void
	    {
			var nLayer:int = hoLayer;
			var num:int=hoAdRunHeader.f_CreateObject(p.cdpHFII, p.cdpOi, x, y, dir, CRun.COF_NOMOVEMENT|CRun.COF_HIDDEN, nLayer, -1);
			if (num>=0)
			{
			    // Cree le movement
			    // ----------------
			    var pHo:CObject=hoAdRunHeader.rhObjectList[num];
			    if (pHo.rom!=null)
			    {
					pHo.roc.rcDir=dir;						// Met la direction de depart
					pHo.rom.initSimple(pHo, CMoveDef.MVTYPE_BULLET, false);		
					pHo.roc.rcSpeed=p.shtSpeed;					// Met la vitesse
					var mBullet:CMoveBullet=CMoveBullet(pHo.rom.rmMovement);
					mBullet.init2(this);
		
					// Hide object if layer hidden
					// ---------------------------
					if (nLayer!=-1)
					{
					    if ( (pHo.hoOEFlags & CObjectCommon.OEFLAG_SPRITES) != 0 )
					    {
							// Hide object if layer hidden
							var layer:CLayer=hoAdRunHeader.rhFrame.layers[nLayer];
							if ( (layer.dwOptions & (CLayer.FLOPT_TOHIDE|CLayer.FLOPT_VISIBLE)) != CLayer.FLOPT_VISIBLE )
							{
							    pHo.ros.obHide();
							}
					    }
					}
		
					// Met l'objet dans la liste des objets selectionnes
					// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					hoAdRunHeader.rhEvtProg.evt_AddCurrentObject(pHo);
			
					// Force l'animation SHOOT si definie
					// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if ((hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
					{
					    if (roa.anim_Exist(CAnim.ANIMID_SHOOT))
					    {
							roa.animation_Force(CAnim.ANIMID_SHOOT);
							roa.animation_OneLoop();
					    }
					}		
			    }
			    else
			    {
					hoAdRunHeader.destroy_Add(pHo.hoNumber);
			    }
			}
    	}

	    // Fonctions de base
	    public function init(ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
	    {
	    	
	    }
	    public function handle():void
	    {
	    	
	    }
	    public function modif():void
	    {
	    	
	    }
	    public function display():void
	    {
	    	
	    }
	    public function kill(bFast:Boolean):void
	    {
	    	
	    }
	    public function getCollisionMask(flags:int):CMask
	    {
			return null;	    	
	    }
		
		public function setEffect(effect:int, effectParam:int):int
		{
			return 0;
		}
		
		
		public function fixedValue():int
		{
			return (hoCreationId << 16) | (int(hoNumber) & 0xFFFF);
		}
		
	    // Fonctions sprites
		public function addSprite(x:int, y:int, i:int, layer:int, bShow:Boolean):void
		{
		}
		public function addOwnerDrawSprite(x:int, y:int, layer:int, bQD:Boolean, bShow:Boolean, index:int):void
		{
		}
		public function modifSprite(x:int, y:int, i:int, xScale:Number, yScale:Number, rotAngle:int):void
		{
		}
		public function modifOwnerDrawSprite(x:int, y:int):void
		{
		}
		public function delSprite():int
		{
			return 0;
		}
		public function showSprite():void
		{
		}
		public function hideSprite():void
		{			
		}
		public function setTransparency(t:Number):void
		{			
		}		
		public function getChildIndex():int
		{	
			return -1;
		}
		public function getChildMaxIndex():int
		{
			return 0;
		}
		public function setChildIndex(index:int):void
		{
		}
		public function setHandCursor(bOn:Boolean):void
		{			
		}
	}
}