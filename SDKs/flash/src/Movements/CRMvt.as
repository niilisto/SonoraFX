//----------------------------------------------------------------------------------
//
// CRMVT : Données de base d'un mouvement
//
//----------------------------------------------------------------------------------
package Movements
{
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	import Services.*;
	
	public class CRMvt
	{
	    public var rmMvtNum:int;					// Number of the current movement
	    public var rmMovement:CMove;
	    public var rmWrapping:int;					// For CHECK POSITION
	    public var rmMoveFlag:Boolean=false;		// Messages/movements
	    public var rmReverse:int;					// Ahaid or reverse?
	    public var rmBouncing:Boolean=false;		// Bouncing?
	    public var rmEventFlags:int;				// To accelerate events
	
	    public static var EF_GOESINPLAYFIELD:int=0x0001;
	    public static var EF_GOESOUTPLAYFIELD:int=0x0002;
	    public static var EF_WRAP:int=0x0004;

		public function CRMvt()
		{
		}

	    public function init(nMove:int, hoPtr:CObject, ocPtr:CObjectCommon, cob:CCreateObjectInfo, forcedType:int):void
	    {
			// Effacement du mouvement precedent
			if (rmMovement!=null)
			{
			    rmMovement.kill();
			}
	
			// Copie les donnees de base
			// -------------------------
			if (cob!=null)
			{
	            hoPtr.roc.rcDir=cob.cobDir;					//; Directions
			}
			rmWrapping=hoPtr.hoOiList.oilWrap;				//; Flag pour wrap
	
			// Initialise les mouvements
			// -------------------------
			var mvPtr:CMoveDef = null;
			hoPtr.roc.rcMovementType = -1;
			if ( ocPtr.ocMovements != null )
			{
	            if (nMove<ocPtr.ocMovements.nMovements)
	            {
					mvPtr=ocPtr.ocMovements.moveList[nMove];
					rmMvtNum=nMove;
	                if (forcedType==-1)
	                {
	                    forcedType=mvPtr.mvType;
	                }
					hoPtr.roc.rcMovementType=forcedType;					//; Le type
	                switch (forcedType)
	                {
	                    // MVTYPE_STATIC
	                    case 0:
	                        rmMovement=new CMoveStatic();
	                        break;
	                    // MVTYPE_MOUSE
	                    case 1:
	                        rmMovement=new CMoveMouse();
	                        break;
	                    // MVTYPE_RACE
	                    case 2:
	                        rmMovement=new CMoveRace();
	                        break;
	                    // MVTYPE_GENERIC
	                    case 3:
	                        rmMovement=new CMoveGeneric();
	                        break;
	                    // MVTYPE_BALL
	                    case 4:
	                        rmMovement=new CMoveBall();
	                        break;
	                    // MVTYPE_TAPED
	                    case 5:
	                        rmMovement=new CMovePath();
	                        break;
	                    // MVTYPE_PLATFORM
	                    case 9:
	                        rmMovement=new CMovePlatform();
	                        break;
	                    // MVTYPE_EXT				
	                    case 14:
							rmMovement=loadMvtExtension(hoPtr, CMoveDefExtension(mvPtr));
							if (rmMovement==null)
							{
							    rmMovement=new CMoveStatic();
							}
	                        break;
	                }
					hoPtr.roc.rcDir=dirAtStart(hoPtr, mvPtr.mvDirAtStart, hoPtr.roc.rcDir);			//; La direction par defaut
					rmMovement.init(hoPtr, mvPtr);                              //; Init des mouvements
	            }
			}
	
			if (hoPtr.roc.rcMovementType==-1) 
			{
	            hoPtr.roc.rcMovementType=0;
	            rmMovement=new CMoveStatic();
	            rmMovement.init(hoPtr, null);
	            hoPtr.roc.rcDir=0;
			}        
	    }
	    public function loadMvtExtension(hoPtr:CObject, mvDef:CMoveDefExtension):CMove
	    {	    	
	        var extName:String = mvDef.moduleName.toLowerCase();
	        var index:int = extName.indexOf('-');
	        while (index > 0)
	        {
	            extName = extName.substring(0, index) + '_' + extName.substring(index+1, extName.length);
	            index = extName.indexOf('-');
	        }

			var object:CRunMvtExtension;

			// STARTCUT 			
			if (CServices.compareStringsIgnoreCase(extName, "spaceship"))
			{
				object=new CRunMvtspaceship();
			}
			if (CServices.compareStringsIgnoreCase(extName, "pinball"))
			{
				object=new CRunMvtpinball();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_circular"))
			{
				object=new CRunMvtclickteam_circular();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_invaders"))
			{
				object=new CRunMvtclickteam_invaders();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_presentation"))
			{
				object=new CRunMvtclickteam_presentation();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_regpolygon"))
			{
				object=new CRunMvtclickteam_regpolygon();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_simple_ellipse"))
			{
				object=new CRunMvtclickteam_simple_ellipse();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_sinewave"))
			{
				object=new CRunMvtclickteam_sinewave();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_vector"))
			{
				object=new CRunMvtclickteam_vector();
			}
			if (CServices.compareStringsIgnoreCase(extName, "clickteam_dragdrop"))
			{
				object=new CRunMvtclickteam_dragdrop();
			}
			if (CServices.compareStringsIgnoreCase(extName, "inandout"))
			{
				object=new CRunMvtinandout();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2d8directions"))
			{
				object=new CRunMvtbox2d8directions();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dstatic"))
			{
				object=new CRunMvtbox2dstatic();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2daxial"))
			{
				object=new CRunMvtbox2daxial();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dbackground"))
			{
				object=new CRunMvtbox2dbackground();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dbouncingball"))
			{
				object=new CRunMvtbox2dbouncingball();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dracecar"))
			{
				object=new CRunMvtbox2dracecar();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dspaceship"))
			{
				object=new CRunMvtbox2dspaceship();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dplatform"))
			{
				object=new CRunMvtbox2dplatform();
			}
			if (CServices.compareStringsIgnoreCase(extName, "box2dspring"))
			{
				object=new CRunMvtbox2dspring();
			}
			// ENDCUT

			if (object!=null)
			{
				object.init(hoPtr);
				var mvExt:CMoveExtension=new CMoveExtension(object);
				return mvExt;
			}
			trace("*** Movement not found!");
			return null;				
	    }
	    public function initSimple(hoPtr:CObject, forcedType:int, bRestore:Boolean):void
	    {
			if (rmMovement!=null)
			{
			    rmMovement.kill();
			}
			hoPtr.roc.rcMovementType=forcedType;					//; Le type
			switch (forcedType)
			{
			    // MVTYPE_DISAPPEAR
			    case 11:
					rmMovement=new CMoveDisappear();
					CRun.bMoveChanged=true;
					break;
			    // MVTYPE_BULLET
			    case 13:
					rmMovement=new CMoveBullet();
					break;
			}
			rmMovement.hoPtr=hoPtr;
			if (bRestore==false)
			{
			    rmMovement.init(hoPtr, null);                              //; Init des mouvements
			}
	    }

	    public function kill(bFast:Boolean):void
	    {
	        rmMovement.kill();
	    }
	    
	    public function move():void
	    {
	        rmMovement.move();
	    }
    
	    public function nextMovement(hoPtr:CObject):void
	    {
			var ocPtr:CObjectCommon=hoPtr.hoCommon;
			if ( ocPtr.ocMovements != null )
			{
	            if (rmMvtNum+1<ocPtr.ocMovements.nMovements)
	            {
					kill(false);
					init(rmMvtNum+1, hoPtr, ocPtr, null, -1);
					
					var pMovement:CRunMBase= null;
					if(hoPtr.hoAdRunHeader.rh4Box2DObject)
						pMovement = hoPtr.hoAdRunHeader.GetMBase(hoPtr);
					if (pMovement != null)
						pMovement.CreateBody();

			    }
			}
	    }
	    public function previousMovement(hoPtr:CObject):void
	    {
			var ocPtr:CObjectCommon=hoPtr.hoCommon;
			if ( ocPtr.ocMovements != null )
			{
	            if (rmMvtNum-1>=0)
	            {
					kill(false);
					init(rmMvtNum-1, hoPtr, ocPtr, null, -1);
					
					var pMovement:CRunMBase= null;
					if(hoPtr.hoAdRunHeader.rh4Box2DObject)
						pMovement = hoPtr.hoAdRunHeader.GetMBase(hoPtr);
					if (pMovement != null)
						pMovement.CreateBody();
			    }
			}
	    }
	    public function selectMovement(hoPtr:CObject, mvt:int):void
	    {
			var ocPtr:CObjectCommon=hoPtr.hoCommon;
			if ( ocPtr.ocMovements != null )
			{
	            if (mvt>=0 && mvt<ocPtr.ocMovements.nMovements)
	            {
					kill(false);
					init(mvt, hoPtr, ocPtr, null, -1);
					
					var pMovement:CRunMBase= null;
					if(hoPtr.hoAdRunHeader.rh4Box2DObject)
						pMovement = hoPtr.hoAdRunHeader.GetMBase(hoPtr);
					if (pMovement != null)
						pMovement.CreateBody();
			    }
			}
	    }

	    public function dirAtStart(hoPtr:CObject, dirAtStart:int, dir:int):int
	    {
			if (dir<0 || dir>=32)
			{
	            // Compte le nombre de directions demandees
	            var cpt:int=0;
	            var das:int=dirAtStart;
	            var das2:int;
	            var n:int;
	            for (n=0; n<32; n++)
	            {
	                das2=das;
	                das>>=1;
	                if ((das2&1)!=0)
	                    cpt++;
	            }
	
	            // Une ou zero direction?
	            if (cpt==0)
	            {
	                dir=0;
	            }
	            else
	            {
	                // Appelle le hasard pour trouver le bit
	                cpt=hoPtr.hoAdRunHeader.random(cpt);
	                das=dirAtStart;
	                for (dir=0; ; dir++)
	                {
	                    das2=das;
	                    das>>=1;
	                    if ((das2&1)!=0)
	                    {
	                        cpt--;
	                        if (cpt<0) 
	                        {
	                            break;
	                        }
	                    }
	                }
	            }
			}
			// Direction trouvee, OUF
			return dir;
	    }

	}
}