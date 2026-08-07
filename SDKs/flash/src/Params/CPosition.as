//----------------------------------------------------------------------------------
//
// CPOSITION: parametre position données
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	import Banks.*;
	import Movements.*;
	import OI.*;
	import Objects.*;
	import RunLoop.*;

	public class CPosition extends CParam
	{
	    public var posOINUMParent:int;			//0
	    public var posFlags:int;
	    public var posX:int;					//4
	    public var posY:int;
	    public var posSlope:int;				//8
	    public var posAngle:int;
	    public var posDir:int;					//12
	    public var posTypeParent:int;                         //16
	    public var posOiList:int;				//18
	    public var posLayer:int;				//20
	
	    public static var CPF_DIRECTION:int=0x0001;
	    public static var CPF_ACTION:int=0x0002;
	    public static var CPF_INITIALDIR:int=0x0004;
	    public static var CPF_DEFAULTDIR:int=0x0008;
	    
		public function CPosition()
		{
		}

	    // ----------------------------------
	    // Interprete une structure POSITION EAX=Structure position
	    // ----------------------------------
	    public function read_Position(rhPtr:CRun, getDir:int, pInfo:CPositionInfo):Boolean
	    {
	        pInfo.layer=-1;
	
			if (posOINUMParent==-1)
			{
	            // Pas d'objet parent
	            // ~~~~~~~~~~~~~~~~~~
	            if (getDir!=0)									// Tenir compte de la direction?
	            {
	                pInfo.dir=-1;
	                if ((posFlags&CPF_DEFAULTDIR)==0)		// Garder la direction de l'objet
	                {
	                    pInfo.dir=rhPtr.get_Direction(posDir);		// Va chercher la direction
	                }
	            }
	            pInfo.x=posX;
	            pInfo.y=posY;
	            var nLayer:int = posLayer;
	            if ( nLayer > rhPtr.rhFrame.nLayers - 1 )
	                nLayer = rhPtr.rhFrame.nLayers - 1 ;
	            pInfo.layer=nLayer;
	            pInfo.bRepeat=false;
			}
			else
			{
	            // Trouve le parent
	            rhPtr.rhEvtProg.rh2EnablePick=false;
	            var pHo:CObject;
				pHo=rhPtr.rhEvtProg.get_CurrentObjects(posOiList);
	            pInfo.bRepeat=rhPtr.rhEvtProg.repeatFlag;
	            if (pHo==null) 
	                return false;
	            pInfo.x=pHo.hoX;
	            pInfo.y=pHo.hoY;
	            pInfo.layer=pHo.hoLayer;
	
	            if ((posFlags&CPF_ACTION)!=0)					// Relatif au point d'action?
	            {
	                if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
	                {
	                    if ( pHo.roc.rcImage>=0 )
	                    {
							var angle:Number= pHo.roc.rcAngle;
							var pMBase:CRunMBase=null;
							if(rhPtr.rh4Box2DObject)
								pMBase=rhPtr.GetMBase(pHo);
							if (pMBase!=null)
								angle=pMBase.getAngle();
							
	                        var ifo:CImage;
	                        ifo=rhPtr.rhApp.imageBank.getImageInfoEx(pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY);
	                        pInfo.x+=ifo.xAP-ifo.xSpot;
	                        pInfo.y+=ifo.yAP-ifo.ySpot;
	                    }
	                }
	            }
	
	            if ((posFlags&CPF_DIRECTION)!=0)				// Tenir compte de la direction?
	            {
	                var dir:int=(posAngle+pHo.roc.rcDir)&0x1F;	// La direction courante
	                var px:int=CMove.getDeltaX(posSlope, dir);
	                var py:int=CMove.getDeltaY(posSlope, dir);
	                pInfo.x+=px;
	                pInfo.y+=py;
	            }
	            else
	            {
	                pInfo.x+=posX;								// Additionne la position relative
	                pInfo.y+=posY;		
	            }
	
	            if ((getDir&0x01)!=0)
	            {
	                if ((posFlags&CPF_DEFAULTDIR)!=0)			// Mettre la direction par defaut?
	                {
	                    pInfo.dir=-1;
	                }
	                else if ((posFlags&CPF_INITIALDIR)!=0)		// Mettre la direction initiale?
	                {
	                    pInfo.dir=pHo.roc.rcDir;
	                }
	                else
	                {
	                    pInfo.dir=rhPtr.get_Direction(posDir);		// Va cherche la direction
	                }
	            }
			}
	
			// Verification des directions: dans le terrain!!
			if ((getDir&0x02)!=0)
			{
	            if (pInfo.x<rhPtr.rh3XMinimumKill || pInfo.x>rhPtr.rh3XMaximumKill) 
	                return false;
	            if (pInfo.y<rhPtr.rh3YMinimumKill || pInfo.y>rhPtr.rh3YMaximumKill) 
	                return false;
			}
			return true;
	    }

	    public override function load(app:CRunApp):void
	    {
	    	
	    }
	}
}