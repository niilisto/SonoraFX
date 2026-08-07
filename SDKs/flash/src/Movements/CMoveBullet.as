//----------------------------------------------------------------------------------
//
// CMOVEBULLET : Movement balle
//
//----------------------------------------------------------------------------------
package Movements
{
	import Extensions.CRunBox2DBasePosAndAngle;
	import Objects.*;
	import Sprites.*;
	import Animations.*;
	import RunLoop.*;
	
	import Box2D.Dynamics.b2Body;
	
	public class CMoveBullet extends CMove
	{
	    public var MBul_Wait:Boolean;
	    public var MBul_ShootObject:CObject;
		public var MBul_MBase:CRunMBase=null;
		public var MBul_Body:b2Body =null;
		
		public var posAndAngle:CRunBox2DBasePosAndAngle = new CRunBox2DBasePosAndAngle();

		public function CMoveBullet()
		{
		}
	    public override function init(ho:CObject, mvPtr:CMoveDef):void
	    {
	        hoPtr=ho;
			if (hoPtr.ros!=null)						// Est-il active?
			{
			    hoPtr.ros.setColFlag(false);			//; Pas dans les collisions
			}
			if ( hoPtr.ros!=null )
			{
			    hoPtr.ros.rsFlags&=~CRSpr.RSFLAG_VISIBLE;
			    hoPtr.ros.obHide();									//; Cache pour le moment
			}
			MBul_Wait=true;
			hoPtr.hoCalculX=0;
			hoPtr.hoCalculY=0;
			if (hoPtr.roa!=null)
			{
			    hoPtr.roa.init_Animation(CAnim.ANIMID_WALK);
			}
			hoPtr.roc.rcSpeed=0;
			hoPtr.roc.rcCheckCollides=true;			//; Force la detection de collision
			hoPtr.roc.rcChanged=true;
	    }
	    public function init2(parent:CObject):void
	    {
			hoPtr.roc.rcMaxSpeed=hoPtr.roc.rcSpeed;
			hoPtr.roc.rcMinSpeed=hoPtr.roc.rcSpeed;				
			MBul_ShootObject=parent;			// Met l'objet source	
	    }
		public override function kill():void
		{
			if (MBul_Body!=null)
			{
				if(hoPtr.hoAdRunHeader.rh4Box2DObject) {
					var pBase:CRunBaseParent = hoPtr.hoAdRunHeader.rh4Box2DBase;
					pBase.rDestroyBody(MBul_Body);
				}
				MBul_Body=null;
			}
			if (MBul_MBase!=null)
			{
				MBul_MBase=null;
			}
		}
		public override function move():void
	    {
			if (MBul_Wait)
			{
			    // Attend la fin du mouvement d'origine
			    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			    if (MBul_ShootObject.roa!=null)
			    {			    	
					if (MBul_ShootObject.roa.raAnimOn==CAnim.ANIMID_SHOOT) 
					    return;
			    }
			    startBullet();
			}
	
			// Fait fonctionner la balle
			// ~~~~~~~~~~~~~~~~~~~~~~~~~
	        if (hoPtr.roa!=null)
	        {
	            hoPtr.roa.animate();
	        }
			
			if(MBul_Body != null) {
				var rhPtr:CRun = hoPtr.hoAdRunHeader;
				if (rhPtr.rh4Box2DObject && rhPtr.rh4Box2DBase!=null)
				{
					var pBase:CRunBaseParent = hoPtr.hoAdRunHeader.rh4Box2DBase;
					pBase.rGetBodyPosition(MBul_Body, posAndAngle);
					hoPtr.hoX=posAndAngle.x;
					hoPtr.hoY=posAndAngle.y;
					hoPtr.roc.rcAngle = posAndAngle.angle;
					//hoPtr.roc.rcDir=int(Math.floor((posAndAngle.angle%360)/11.25));
					hoPtr.roc.rcDir=0;
					hoPtr.roc.rcChanged=true;				
				}
			}
			else
			{
				newMake_Move(hoPtr.roc.rcSpeed, hoPtr.roc.rcDir);
				if (CRun.bMoveChanged)
				{
					return;
				}
			}

			// Verifie que la balle ne sort pas du terrain (assez loin des bords!)
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (hoPtr.hoX<-64 || hoPtr.hoX>hoPtr.hoAdRunHeader.rhLevelSx+64 || hoPtr.hoY<-64 || hoPtr.hoY>hoPtr.hoAdRunHeader.rhLevelSy+64)
			{
			    // Detruit la balle, sans explosion!
			    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			    hoPtr.hoCallRoutine=false;
			    hoPtr.hoAdRunHeader.destroy_Add(hoPtr.hoNumber);
			}	
			if (hoPtr.roc.rcCheckCollides)			//; Faut-il tester les collisions?
			{
	            hoPtr.roc.rcCheckCollides=false;		//; Va tester une fois!
	            hoPtr.hoAdRunHeader.newHandle_Collisions(hoPtr);
			}        
	    }
	    public function startBullet():void
	    {
			// Fait demarrer la balle
			// ~~~~~~~~~~~~~~~~~~~~~~
			if (hoPtr.ros!=null)				//; Est-il active?
			{
			    hoPtr.ros.setColFlag(true);
			}
			if ( hoPtr.ros!=null )
			{
			    hoPtr.ros.rsFlags|=CRSpr.RSFLAG_VISIBLE;
			    hoPtr.ros.obShow();					//; Plus cache
			}
			var rhPtr:CRun = hoPtr.hoAdRunHeader;
			if (rhPtr.rh4Box2DObject && rhPtr.rh4Box2DBase!=null)
			{
				var hoParent:CObject = MBul_ShootObject;
				var pMovement:CRunMBase = null;
				if(rhPtr.rh4Box2DObject)
					pMovement=rhPtr.GetMBase(hoParent);
				if (pMovement!=null)
				{
					var pMBase:CRunMBase=new CRunMBase();
					MBul_MBase=pMBase;
					pMBase.InitBase(hoPtr, CRunMBase.MTYPE_OBJECT);
					pMBase.m_identifier=rhPtr.rh4Box2DBase.identifier;
					MBul_Body=rhPtr.rh4Box2DBase.rCreateBullet(pMovement.m_currentAngle, hoPtr.roc.rcSpeed, pMBase);
					pMBase.m_body = MBul_Body;
					if (MBul_Body==null)
					{
						MBul_MBase=null;
					}
				}
			}

			MBul_Wait=false; 					//; On y va!
			MBul_ShootObject=null;
	    }	
	    public override function setXPosition(x:int):void
	    {        
			if (hoPtr.hoX!=x)
			{
			    hoPtr.hoX=x;
			    hoPtr.rom.rmMoveFlag=true;
			    hoPtr.roc.rcChanged=true;
			    hoPtr.roc.rcCheckCollides=true;					//; Force la detection de collision
			}
	    }
	    public override function setYPosition(y:int):void
	    {
			if (hoPtr.hoY!=y)
			{
			    hoPtr.hoY=y;
			    hoPtr.rom.rmMoveFlag=true;
			    hoPtr.roc.rcChanged=true;
			    hoPtr.roc.rcCheckCollides=true;					//; Force la detection de collision
			}
	    }
	}
}