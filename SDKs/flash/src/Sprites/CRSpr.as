//----------------------------------------------------------------------------------
//
// CRSPR : Gestion des objets sprites
//
//----------------------------------------------------------------------------------
package Sprites
{
	import Frame.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import flash.system.*;
	import flash.utils.*;

	public class CRSpr
	{
	    public static var RSFLAG_HIDDEN:int=0x0001;
	    public static var RSFLAG_INACTIVE:int=0x0002;
	    public static var RSFLAG_SLEEPING:int=0x0004;
//	    public static var RSFLAG_SCALE_RESAMPLE:int=0x0008;
	    public static var RSFLAG_ROTATE_ANTIA:int=0x0010;
	    public static var RSFLAG_VISIBLE:int=0x0020;
	    public static var RSFLAG_RAMBO:int=0x0040;
	    public static var RSFLAG_COLBOX:int=0x0080;
	    public static var SPRTYPE_TRUESPRITE:int=0;
	    public static var SPRTYPE_OWNERDRAW:int=1;
		public static var BOP_COPY:int=0;					// None
		public static var BOP_BLEND:int=1;					// dest = ((dest * coef) + (src * (128-coef)))/128
		public static var BOP_INVERT:int=2;					// dest = src XOR 0xFFFFFF
		public static var BOP_XOR:int=3;					// dest = src XOR dest
		public static var BOP_AND:int=4;					// dest = src AND dest
		public static var BOP_OR:int=5;						// dest = src OR dest
		public static var BOP_BLEND_REPLACETRANSP:int=6;	// dest = ((dest * coef) + ((src==transp)?replace:src * (128-coef)))/128
		public static var BOP_DWROP:int=7;
		public static var BOP_ANDNOT:int=8;
		public static var BOP_ADD:int=9;
		public static var BOP_MONO:int=10;
		public static var BOP_SUB:int=11;
		public static var BOP_BLEND_DONTREPLACECOLOR:int=12;
		public static var BOP_EFFECTEX:int=13;
		public static var BOP_MAX:int=13;
		public static var BOP_MASK:int=0x0000FFF;
		public static var BOP_RGBAFILTER:int = 0x1000;
	    
	    public var hoPtr:CObject;
	    public var rsFlash:int;				// Flash objets
	    public var rsFlashCpt:int;
	    public var rsLayer:int;				// Layer
	    public var rsZOrder:int;			// Z-order value
	    public var rsCreaFlags:int;			// Creation flags
	    public var rsBackColor:int;			// background saving color
	    public var rsEffect:int;			// Sprite effects
	    public var rsEffectParam:int;
	    public var rsFlags:int;			// Handling flags
	    public var rsFadeCreaFlags:int;		// Saved during a fadein
	    public var rsSpriteType:int;
	    public var rsTransparency:int;
//	    public var rsTrans:CTrans=null;
	
		public function CRSpr()
		{
		}
		
	    public function init1(ho:CObject, ocPtr:CObjectCommon, cobPtr:CCreateObjectInfo):void
	    {
	        hoPtr=ho;
	        
			rsLayer = cobPtr.cobLayer;					// Layer
			rsZOrder = cobPtr.cobZOrder;				// Creation z-order
	
			rsFlags=0;
			
			rsFlags|=RSFLAG_RAMBO;
			if ((hoPtr.hoLimitFlags&CObjInfo.OILIMITFLAGS_QUICKCOL)==0)
	        	rsFlags&=~RSFLAG_RAMBO;
	
			if ((hoPtr.hoOiList.oilOCFlags2&CObjectCommon.OCFLAGS2_COLBOX)!=0)		//; Collision en mode box?
	            rsFlags|=RSFLAG_COLBOX;
	
			if ((cobPtr.cobFlags&CRun.COF_HIDDEN)!=0)				//; Faut-il le cacher a l'ouverture?
			{
	            rsFlags|=RSFLAG_HIDDEN;
	            if (hoPtr.hoType==COI.OBJ_TEXT)
	            {
					hoPtr.hoFlags|=CObject.HOF_NOCOLLISION;		//; Cas particulier pour cette merde d'objet texte
					rsFlags&=~RSFLAG_RAMBO;
	            }
			}
			else
			{
				rsFlags|=RSFLAG_VISIBLE;
			}
			rsEffect=hoPtr.hoOiList.oilInkEffect;
			rsEffectParam=hoPtr.hoOiList.oilEffectParam;	//; Le parametre de l'ink effect
			
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_STATIC)		// Sprite inactif, si pas de mouvement
			{
				rsFlags|=RSFLAG_INACTIVE;
			}	
	    }

	    // -------------------------------------------------
	    // Initialisation sprite deuxieme partie
	    // -------------------------------------------------
	    public function init2(bTransition:Boolean):void
	    {
			createSprite(bTransition);
	    }

	    // Routine de display 
	    // ------------------
	    public function displayRoutine():void
	    {	    	
	        switch(rsSpriteType)
	        {
	            case 0:         // SPRTYPE_TRUESPRITE
			    	hoPtr.modifSprite(hoPtr.hoX, hoPtr.hoY, hoPtr.roc.rcImage, 
                                	hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, hoPtr.roc.rcAngle);
	                break;
	            case 1:         // SPRTYPE_OWNERDRAW
	            	hoPtr.modifOwnerDrawSprite(hoPtr.hoX, hoPtr.hoY);
	                break;
	        }
	    }

	    // -------------------------------------------------------------------
	    // GESTION D'UN OBJET SPRITE
	    // -------------------------------------------------------------------
	    public function handle():void
	    {
	        var rhPtr:CRun=hoPtr.hoAdRunHeader;
            var x1:int;
            var y1:int;
            var x2:int;
            var y2:int;
	
			// Transition?
			// -----------
	        if ((hoPtr.hoFlags & CObject.HOF_FADEIN) != 0)
    	    {
    	    	performFadeIn();
    	    	return;
    	    }
	        if ((hoPtr.hoFlags & CObject.HOF_FADEOUT) != 0)
    	    {
    	    	performFadeOut();
    	    	return;
    	    }
    	    
	        // En marche ou pas?
			// -----------------
			if ((rsFlags&RSFLAG_SLEEPING)==0)
			{
	            // Gestion du flash
	            // ----------------
	            if (rsFlash!=0)
	            {
	                rsFlashCpt-=rhPtr.rhTimerDelta;
	                if (rsFlashCpt<0)
	                {
	                    rsFlashCpt=rsFlash;
	                    if ((rsFlags&RSFLAG_VISIBLE)==0)
	                    {
	                        rsFlags|=RSFLAG_VISIBLE;
	                        obShow();
	                    }
	                    else
	                    {
	                        rsFlags&=~RSFLAG_VISIBLE;
	                        obHide();
	                    }
	                }
	            }
	
	            // Appel de la routine de mouvement	
	            // --------------------------------
	            if (hoPtr.rom!=null)
	                hoPtr.rom.move();
	
	            // Verifie que l'objet n'est pas trop en dehors du terrain
	            // -------------------------------------------------------
	            if (hoPtr.roc.rcPlayer!=0) 
	                return;			//; Seulement les objets de l'ordinateur
	            if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_NEVERSLEEP)!=0) 
	                return;
	
	            x1=hoPtr.hoX-hoPtr.hoImgXSpot;
	            y1=hoPtr.hoY-hoPtr.hoImgYSpot;
	            x2=x1+hoPtr.hoImgWidth;
	            y2=y1+hoPtr.hoImgHeight;
	                       
	            // Faire disparaitre le sprite?
	            if (x2>=rhPtr.rh3XMinimum && x1<=rhPtr.rh3XMaximum && y2>=rhPtr.rh3YMinimum && y1<=rhPtr.rh3YMaximum) 
	                return;
	
	            // Detruit/Faire disparaitre l'objet
	            // ---------------------------------
	            if (x2>=rhPtr.rh3XMinimumKill && x1<=rhPtr.rh3XMaximumKill && y2>=rhPtr.rh3YMinimumKill && y1<=rhPtr.rh3YMaximumKill)
	            {
	                // Simplement faire disparaitre
	                rsFlags|=RSFLAG_SLEEPING;

                    // Save Z-order value before deleting sprite
                    rsZOrder=hoPtr.delSprite();
                    return;
	            }
	            else
	            {
	                // Detruire l'objet, si son flag NEVER KILL est a zero
	                if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_NEVERKILL)==0)
	                {
	                    rhPtr.destroy_Add(hoPtr.hoNumber);
	                }
	                return;
	            }
			}
			else 
			{
	            // Un objet qui dort, le faire reapparaitre ?
	            // ------------------------------------------
	            x1=hoPtr.hoX-hoPtr.hoImgXSpot;
	            y1=hoPtr.hoY-hoPtr.hoImgYSpot;
	            x2=x1+hoPtr.hoImgWidth;
	            y2=y1+hoPtr.hoImgHeight;
	            if (x2>=rhPtr.rh3XMinimum && x1<=rhPtr.rh3XMaximum && y2>=rhPtr.rh3YMinimum && y1<=rhPtr.rh3YMaximum)
	            {
	                rsFlags&=~RSFLAG_SLEEPING;
	                init2(false);
	                hoPtr.setChildIndex(rsZOrder);
	            }
			}
	    }
	    
	    // Routine de modif
	    // ----------------
	    public function modifRoutine():void
	    {
	        switch(rsSpriteType)
	        {
	            case 0:         // SPRTYPE_TRUESPRITE
			    	hoPtr.modifSprite(hoPtr.hoX-hoPtr.hoAdRunHeader.rhWindowX, hoPtr.hoY-hoPtr.hoAdRunHeader.rhWindowY, hoPtr.roc.rcImage, 
                                	hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, hoPtr.roc.rcAngle);
	                break;
	            case 1:         // SPRTYPE_OWNERDRAW
	            	hoPtr.modifOwnerDrawSprite(hoPtr.hoX-hoPtr.hoAdRunHeader.rhWindowX, hoPtr.hoY-hoPtr.hoAdRunHeader.rhWindowY);
	                break;
	        }
	    }

	    // CREATION D'UN VRAI SPRITE SIMPLE
	    // --------------------------------
	    public function createSprite(bTransition:Boolean):Boolean
	    {
			// Un vrai sprite
			// --------------
			if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
			{
				hoPtr.addSprite(hoPtr.hoX-hoPtr.hoAdRunHeader.rhWindowX, hoPtr.hoY-hoPtr.hoAdRunHeader.rhWindowY, hoPtr.roc.rcImage, rsLayer, (rsFlags&RSFLAG_HIDDEN)==0);
				rsSpriteType=SPRTYPE_TRUESPRITE;
				var alpha:int=hoPtr.setEffect(rsEffect, rsEffectParam);
				rsTransparency=(1.0-alpha)*128;
				if (bTransition==true)
				{
					if (hoPtr.hoCommon.ocFadeInLength!=0)
					{
						hoPtr.hoFlags|=CObject.HOF_FADEIN;
						var activePtr:CActive=CActive(hoPtr);
						activePtr.setTransparency(0);
						hoPtr.hoFlags|=CObject.HOF_NOCOLLISION;
						activePtr.startFade=getTimer();						
					}					
				} 
	            return true;
			}
			
			// Un faux sprite, ou owner draw
			// ----------------------------------
            hoPtr.hoFlags|=CObject.HOF_OWNERDRAW;
			hoPtr.addOwnerDrawSprite(hoPtr.hoX-hoPtr.hoAdRunHeader.rhWindowX, hoPtr.hoY-hoPtr.hoAdRunHeader.rhWindowY, 
									 rsLayer, (hoPtr.hoOEFlags&CObjectCommon.OEFLAG_QUICKDISPLAY)!=0, (rsFlags&RSFLAG_HIDDEN)==0, -1); 	
			hoPtr.setEffect(rsEffect, rsEffectParam);
            rsSpriteType=SPRTYPE_OWNERDRAW;
            return true;
	    }

		// Gestion du fadein
		// -----------------
		public function performFadeIn():void
		{
			var activePtr:CActive=CActive(hoPtr);
			var deltaTime:int=getTimer()-activePtr.startFade;
			if (deltaTime>=hoPtr.hoCommon.ocFadeInLength)
			{
				activePtr.setTransparency(1.0);
				hoPtr.hoFlags&=~CObject.HOF_FADEIN;
				hoPtr.hoFlags&=~CObject.HOF_NOCOLLISION;
				return;
			}
			var alpha:Number=deltaTime/hoPtr.hoCommon.ocFadeInLength;
			activePtr.setTransparency(alpha);
		}
				
		// Gestion du fadeout
		// -----------------
		public function initFadeOut():Boolean
		{
			if (hoPtr.hoCommon.ocFadeOutLength!=0)
			{
				hoPtr.hoFlags|=CObject.HOF_FADEOUT;
				var activePtr:CActive=CActive(hoPtr);
	    		var v:Number=(Number(128-rsTransparency))/128.0;				
				activePtr.setTransparency(v);
				hoPtr.hoFlags|=CObject.HOF_NOCOLLISION;
				activePtr.startFade=getTimer();
				return true;						
			}
			return false;					
		}
		public function performFadeOut():void
		{
			var activePtr:CActive=CActive(hoPtr);
			var deltaTime:int=getTimer()-activePtr.startFade;
			if (deltaTime>=hoPtr.hoCommon.ocFadeOutLength)
			{
				activePtr.setTransparency(0.0);
			    hoPtr.hoCallRoutine=false;
			    hoPtr.hoAdRunHeader.destroy_Add(hoPtr.hoNumber);
				return;
			}
    		var v:Number=(Number(128-rsTransparency))/128.0;				
			var alpha:Number=v-(Number(deltaTime)/Number(hoPtr.hoCommon.ocFadeOutLength))*v;
			activePtr.setTransparency(alpha);
		}
		
	    // DESTRUCTION D'UN SPRITE
	    // -----------------------
	    public function kill(fast:Boolean):void
	    {
            // Save Z-order value before deleting sprite
            rsZOrder = hoPtr.delSprite();	
		}				

	    // CACHE/MONTRE UN SPRITE
	    // ----------------------
	    public function obHide():void
	    {
			if ((rsFlags&RSFLAG_HIDDEN)==0)
			{
	            rsFlags|=RSFLAG_HIDDEN;
	            hoPtr.roc.rcChanged=true;
	            hoPtr.hideSprite();
			}
	    }
	    public function obShow():void
	    {
			if ((rsFlags&RSFLAG_HIDDEN)!=0)
			{
	            // Test if layer shown
	            var pLayer:CLayer = hoPtr.hoAdRunHeader.rhFrame.layers[hoPtr.hoLayer];
	            if ( (pLayer.dwOptions & (CLayer.FLOPT_TOHIDE|CLayer.FLOPT_VISIBLE)) == CLayer.FLOPT_VISIBLE )
	            {
	                rsFlags&=~RSFLAG_HIDDEN;
	                hoPtr.hoFlags&=~CObject.HOF_NOCOLLISION;				//; Des collisions de nouveau (objet texte)
	                hoPtr.roc.rcChanged=true;
	                hoPtr.showSprite();
				}
	    	}
	    }
	    public function setSemiTransparency(trans:int):void
	    {
	    	if (trans>=0 && trans<=128)
	    	{
	    		rsTransparency=trans;
	    		var v:Number=(Number(128-trans))/128.0;
		    	hoPtr.setTransparency(v);
				if (hoPtr.hoType==2)
				{
					(CActive(hoPtr)).alpha=1.0;
				}
	    	}
	    }
	    public function getSemiTransparency():int
	    {
	    	return rsTransparency;	
	    }
	    public function setColFlag(flag:Boolean):void
	    {
	    	if (flag)
	    	{
	    		rsFlags|=RSFLAG_RAMBO;	    		
	    	}
	    	else
	    	{
	    		rsFlags&=~RSFLAG_RAMBO;
	    	}
	    }
		public function modifSpriteEffect(effect:int, effectParam:int):void
		{
			rsEffect &= ~CRSpr.BOP_MASK;
			rsEffect |= effect;
			rsEffectParam = effectParam;
			hoPtr.roc.rcChanged = true;
			hoPtr.setEffect(rsEffect, rsEffectParam);
		}
		
	}
}