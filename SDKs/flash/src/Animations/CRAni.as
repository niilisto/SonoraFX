//----------------------------------------------------------------------------------
//
// CRANI : Animations des objets
//
//----------------------------------------------------------------------------------
package Animations
{
	import Application.*;
	
	import Banks.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CRAni
	{
	    // -------------------------------------------------
	    // Initialisation de la partie ANIMATIONS d'un objet
	    // -------------------------------------------------
	    public static var anim_Defined:Array=
	    [
			CAnim.ANIMID_STOP,
			CAnim.ANIMID_WALK,
			CAnim.ANIMID_RUN,
			CAnim.ANIMID_BOUNCE,
			CAnim.ANIMID_SHOOT,
			CAnim.ANIMID_JUMP,
			CAnim.ANIMID_FALL,
			CAnim.ANIMID_CLIMB,
			CAnim.ANIMID_CROUCH,
			CAnim.ANIMID_UNCROUCH,
			12,
			13,
			14,
			15,
			-1 
		];
	
	    public var hoPtr:CObject;
	    public var raAnimForced:int;				// Flags if forced
	    public var raAnimDirForced:int;
	    public var raAnimSpeedForced:int;
	    public var raAnimStopped:Boolean;
	    public var raAnimOn:int;				// Current animation
	    public var raAnimOffset:CAnim;
	    public var raAnimDir:int;				// Direction of current animation
	    public var raAnimPreviousDir:int;                       // Previous OK direction
	    public var raAnimDirOffset:CAnimDir;
	    public var raAnimSpeed:int;
	    public var raAnimMinSpeed:int;                          // Minimum speed of movement
	    public var raAnimMaxSpeed:int;                          // Maximum speed of movement
	    public var raAnimDeltaSpeed:int;
	    public var raAnimCounter:int;                           // Animation speed counter
	    public var raAnimDelta:int;				// Speed counter
	    public var raAnimRepeat:int;				// Number of repeats
	    public var raAnimRepeatLoop:int;			// Looping picture
	    public var raAnimFrame:int;				// Current frame
	    public var raAnimNumberOfFrame:int;                     // Number of frames
	    public var raAnimFrameForced:int;
	    public var raRoutineAnimation:int;
		public var raOldAngle:Number;
		
		public function CRAni()
		{
			raOldAngle=-1;
		}

	    // Initialisation des animations d'un objet
	    public function init(ho:CObject):void
	    {
	        hoPtr=ho;
	
	        // Init de l'animation normale
			// ---------------------------
			raRoutineAnimation=0;
			init_Animation(CAnim.ANIMID_WALK);
		
			// Animation APPEAR au debut?
			// --------------------------
			if (anim_Exist(CAnim.ANIMID_APPEAR))
			{
	            raRoutineAnimation=1;
	            animation_Force(CAnim.ANIMID_APPEAR);
	            animation_OneLoop();
	            animations();
			}
			else
			{
	            // Si pas d'autre anims que disappear : on fait un disappear!
	            // ----------------------------------------------------------
	            var i:int;
	            for (i=0; anim_Defined[i]>=0; i++)
	            {
					if (anim_Exist(anim_Defined[i])) 
	                    break;
	            }
	            if (anim_Defined[i]<0)
	            {
	            	if (anim_Exist(CAnim.ANIMID_DISAPPEAR))
	                {
	                    raRoutineAnimation=2;
	                    animation_Force(CAnim.ANIMID_DISAPPEAR);
	                    animation_OneLoop();
	                    animations();
					}
	            }
			}
	    }

	    // ---------------------------------------------------------------------------
	    // Initialisation d'un animation
	    // ---------------------------------------------------------------------------
	    public function init_Animation(anim:int):void
	    {
			hoPtr.roc.rcAnim=anim;
			raAnimStopped=false;
			raAnimForced=0;
			raAnimDirForced=0;
			raAnimSpeedForced=0;
			raAnimFrameForced=0;
			raAnimCounter=0;
			raAnimFrame=0;
			raAnimOffset=null;
			raAnimDirOffset=null;
			raAnimOn=-1;
			raAnimMinSpeed=-1;
			raAnimPreviousDir=-1;
	        raAnimOffset=null;
	        raAnimDirOffset=null;
			animations();
	    }

	    // ---------------------------------------------------------------------------
	    // VERIFICATION D'UNE DIRECTION: ro.roAnim, ro.roDir
	    // ---------------------------------------------------------------------------
	    public function check_Animate():void
	    {
			animIn(0);
	    }

	    // ---------------------------------------------------------------------------
	    // ANIMATION ENTREE POUR LES EXTENSIONS MOVEMENT 
	    // ---------------------------------------------------------------------------
	    public function extAnimations(anim:int):void
	    {
			hoPtr.roc.rcAnim=anim;
			animate();
	    }
	
	    // ---------------------------------------------------------------------------
	    // ENTREE DES ANIMATIONS
	    // ---------------------------------------------------------------------------
	    public function animate():Boolean
	    {
			CRun.bMoveChanged=false;
	        switch(raRoutineAnimation)
	        {
	            case 0:
	                return animations();
	            case 1:
	                anim_Appear();
	                return false;
	            case 2:
	                anim_Disappear();
	                return false;
	        }
			return false;
	    }

	    // ---------------------------------------------------------------------------
	    // ANIMATION D'UN OBJET: ro.roAnim, ro.roSpeed, ro.roDir
	    // ---------------------------------------------------------------------------
	    public function animations():Boolean
	    {
	    	var x:int=hoPtr.hoX;									// Stocke la zone exacte du sprite actuel
			hoPtr.roc.rcOldX=x;
			x-=hoPtr.hoImgXSpot;
			hoPtr.roc.rcOldX1=x;
			x+=hoPtr.hoImgWidth;
			hoPtr.roc.rcOldX2=x;
		
			var y:int=hoPtr.hoY;
			hoPtr.roc.rcOldY=y;
			y-=hoPtr.hoImgYSpot;
			hoPtr.roc.rcOldY1=y;
			y+=hoPtr.hoImgHeight;
			hoPtr.roc.rcOldY2=y;
		
			hoPtr.roc.rcOldImage=hoPtr.roc.rcImage;			// Stocke l'ancienne image
			hoPtr.roc.rcOldAngle=hoPtr.roc.rcAngle;
		
			return animIn(1);
	    }

	    public function animIn(vbl:int):Boolean
	    {
			CRun.bMoveChanged=false;

			var ocPtr:CObjectCommon=hoPtr.hoCommon;
	
			var speed:int=hoPtr.roc.rcSpeed;
			var anim:int=hoPtr.roc.rcAnim;								//; L'animation voulue
	
			// Brancher une nouvelle animation?
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (raAnimSpeedForced!=0)						//; Une vitesse forcee?
			{
	            speed=raAnimSpeedForced-1;
			}
			if (anim==CAnim.ANIMID_WALK)									//; Si marcher, courir?
			{
	            if (speed==0)
	            {
	            	anim=CAnim.ANIMID_STOP;
	            }
	            if (speed>=75)
	            {
	            	anim=CAnim.ANIMID_RUN;
	            }
			}
			if (raAnimForced!=0)								//; Une animation forcee?
			{
	            anim=raAnimForced-1;
			}
			if (anim!=raAnimOn)								//; La meme?
			{	
	            raAnimOn=anim;
	            if (anim>=ocPtr.ocAnimations.ahAnimMax)
	            {
	            	anim=ocPtr.ocAnimations.ahAnimMax-1;
	            }
	            var anPtr:CAnim=ocPtr.ocAnimations.ahAnims[anim];
	            if (anPtr!=raAnimOffset)
	            {
					raAnimOffset=anPtr;
					raAnimDir=-1;					//; Force le recalcul de la direction
					raAnimFrame=0;					//; Repointe l'image 0
	            }
			}
	
			// Brancher une nouvelle direction?
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var frame:int;
			var ifo:CImage;
			var dir:int=hoPtr.roc.rcDir%32;						//; Une modification?
			var bAngle:Boolean=false;
			
			if(dir < 0)
				dir += 32;
			
			if (raAnimDirForced!=0)						//; Une direction forcee?
			{
	            dir=raAnimDirForced-1;
			}
			var adPtr:CAnimDir;
			if (raAnimDir!=dir)
			{
	            raAnimDir=dir;
	
	            // Trouve le sens d'exploration des approximations
	            adPtr=raAnimOffset.anDirs[dir];
	            if (adPtr==null)
	            {
					// De quel cote est t'on le plus proche?
					if ((raAnimOffset.anAntiTrigo[dir]&0x40)!=0)
	                {
	                    dir=raAnimOffset.anAntiTrigo[dir]&0x3F;
	                }
	                else if ((raAnimOffset.anTrigo[dir]&0x40)!=0)
	                {
	                    dir=raAnimOffset.anTrigo[dir]&0x3F;
	                }
	                else
	                {
						var offset:int=dir;
						if (raAnimPreviousDir<0)
						{
							dir=raAnimOffset.anTrigo[dir]&0x3F;
						}
						else
						{
							dir-=raAnimPreviousDir;
							dir&=31;
							if (dir>15)
							{
								dir=raAnimOffset.anTrigo[offset]&0x3F;
							}
							else
							{
								dir=raAnimOffset.anAntiTrigo[offset]&0x3F;
							}
						}
	                }		
	                adPtr=raAnimOffset.anDirs[dir];
	            }
	            else
	            {
	                raAnimPreviousDir=dir;
					adPtr=raAnimOffset.anDirs[dir];
	            }
	            
	            // Rotations automatiques? 	
	            if (raAnimOffset.anDirs[0]!=null && (hoPtr.hoCommon.ocFlags2 & CObjectCommon.OCFLAGS2_AUTOMATICROTATION) != 0)
	            {
	                hoPtr.roc.rcAngle=(raAnimDir*360)/32;
	                adPtr=raAnimOffset.anDirs[0];
	                raAnimDirOffset=null;
					bAngle=true;
	            }
	
	            if (raAnimDirOffset!=adPtr)
	            {		
					raAnimDirOffset=adPtr;
					raAnimRepeat=adPtr.adRepeat;			//; Nombre de repeat
					raAnimRepeatLoop=adPtr.adRepeatFrame;	//; Image du repeat
			
					var minSpeed:int=adPtr.adMinSpeed;
					var maxSpeed:int=adPtr.adMaxSpeed;
			
					if (minSpeed!=raAnimMinSpeed || maxSpeed!=raAnimMaxSpeed)		//; Calcul de la nouvelle vitesse
					{
	                    raAnimMinSpeed=minSpeed;
	                    raAnimMaxSpeed=maxSpeed;
	                    maxSpeed-=minSpeed;
	                    raAnimDeltaSpeed=maxSpeed;
	                    raAnimDelta=minSpeed;
	                    raAnimSpeed=-1;
					}
	
					raAnimNumberOfFrame=adPtr.adNumberOfFrame;
					if (raAnimFrameForced!=0 && (raAnimFrameForced - 1 >= raAnimNumberOfFrame))
	                    raAnimFrameForced=0;
					
					if (raAnimFrame>=raAnimNumberOfFrame)		//; Charge l'image
	                    raAnimFrame=0;
					
					frame=adPtr.adFrames[raAnimFrame];
					
					if (raAnimStopped==false)
					{
	                    hoPtr.roc.rcImage=frame;
	                    ifo=hoPtr.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(frame, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY);
	                    hoPtr.hoImgWidth=ifo.width;
	                    hoPtr.hoImgHeight=ifo.height;
	                    hoPtr.hoImgXSpot=ifo.xSpot;
	                    hoPtr.hoImgYSpot=ifo.ySpot;
						hoPtr.hoImgXAP=ifo.xAP;
						hoPtr.hoImgYAP=ifo.yAP;
	                    hoPtr.roc.rcChanged=true;
	                    hoPtr.roc.rcCheckCollides=true;
					}
					if (raAnimNumberOfFrame==1)				//; Si une seule image : on la met directement!
					{
	                    if (raAnimMinSpeed==0)				//; Si vitesse mini non nulle, on anime
	                    {
							raAnimNumberOfFrame=0;			//; Sinon, rien a faire!
	                    }
	                    frame=hoPtr.roc.rcImage;					//; Recupere taille
	                    if (frame==0) 
	                        return false;						//; Securite pour jeu casses!
	
	                    ifo=hoPtr.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(frame, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY);
	                    hoPtr.hoImgWidth=ifo.width;
	                    hoPtr.hoImgHeight=ifo.height;
	                    hoPtr.hoImgXSpot=ifo.xSpot;
	                    hoPtr.hoImgYSpot=ifo.ySpot;
						hoPtr.hoImgXAP = ifo.xAP;
						hoPtr.hoImgYAP = ifo.yAP; 
	                    return false;
					}
	            }
			}
	
			// Si objet non anime : on s'en va!
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (vbl==0 && raAnimFrameForced==0) 
                return false;	//; Des VBL a faire?
			if (bAngle==false && raAnimNumberOfFrame==0) 
                return false;			//; Une seule frame?

			// Calcul de la vitesse relative au deplacement
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var delta:int=raAnimDeltaSpeed;					// Des calculs a faire?
			if (speed!=raAnimSpeed)
			{
	            raAnimSpeed=speed;
			
	            if (delta==0)
	            {
	            	raAnimDelta=raAnimMinSpeed;
	            	if (raAnimSpeedForced!=0)			//; Une vitesse forcee?
	                    raAnimDelta=raAnimSpeedForced-1;
	            }
	            else
	            {
					var deltaSpeed:int=hoPtr.roc.rcMaxSpeed-hoPtr.roc.rcMinSpeed;		//; Vitesse mini et maxi pour le mouvement
	                if (deltaSpeed==0)
					{	
						if (raAnimSpeedForced!=0)
						{
							delta*=speed;								//; Calcule la nouvelle vitesse
							delta/=100;
							delta+=raAnimMinSpeed;
							if (delta>raAnimMaxSpeed)
								delta=raAnimMaxSpeed;
							raAnimDelta=delta;					//; Valeur finale!
						}
						else
						{
		                    delta/=2;
		                    delta+=raAnimMinSpeed;
		                    raAnimDelta=delta;					//; Valeur finale!
						}
					}
					else
					{
	                    delta*=speed;								//; Calcule la nouvelle vitesse
	                    delta/=deltaSpeed;
	                    delta+=raAnimMinSpeed;
	                    if (delta>raAnimMaxSpeed)
							delta=raAnimMaxSpeed;
		                raAnimDelta=delta;					//; Valeur finale!
					}
	            }
			}
	
			// Fait l'animation...
			// ~~~~~~~~~~~~~~~~~~~
			adPtr=raAnimDirOffset;
			frame=raAnimFrameForced;
			var counter:int;
			if (frame==0)
			{
	            if (raAnimDelta==0) 
	                return false;					//; Si vitesse nulle : pas d'anim
	            if (raAnimStopped) 
	                return false;					//; Si animation arretee
	
	            counter=raAnimCounter;
	            frame=raAnimFrame;
	            var aDelta:int=raAnimDelta;
	            if ((hoPtr.hoAdRunHeader.rhFrame.leFlags&CRunFrame.LEF_TIMEDMVTS)!=0 && hoPtr.hoAdRunHeader.rh4EventCount > 0)
	                aDelta=(Number(aDelta))*hoPtr.hoAdRunHeader.rh4MvtTimerCoef;           
	            counter+=aDelta;
	            while (counter>100)
	            {
					counter-=100;
					frame++;
					if (frame>=raAnimNumberOfFrame)
					{
	                    frame=raAnimRepeatLoop;				//; Image ou reboucler
	                    if (raAnimRepeat!=0)					//; On boucle?
	                    {
	                    	raAnimRepeat--;
	                    	if (raAnimRepeat==0)
	                    	{
								raAnimFrame=raAnimNumberOfFrame-1;

								// Pas de boucle : envoie un message
	                            raAnimNumberOfFrame=0;
	                            // Si animation forcee, la deforce pour la prochaine fois
	                            if (raAnimForced!=0)
	                            {
	                            	raAnimForced=0;
	                            	raAnimDirForced=0;
									raAnimSpeedForced=0;
	                            }
	                            if ((hoPtr.hoAdRunHeader.rhGameFlags&CRun.GAMEFLAGS_INITIALISING)!=0)
	                                return false;
								
								if (bAngle)
								{
									hoPtr.roc.rcChanged=true;
									hoPtr.roc.rcCheckCollides=true;
									
									ifo=hoPtr.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY);
									
									hoPtr.hoImgWidth=ifo.width;
									hoPtr.hoImgHeight=ifo.height;
									hoPtr.hoImgXSpot=ifo.xSpot;
									hoPtr.hoImgYSpot=ifo.ySpot;									
									hoPtr.hoImgXAP = ifo.xAP;
									hoPtr.hoImgYAP = ifo.yAP;
									
								}
							    var cond:int=(-2 <<16);	    // CNDL_EXTANIMENDOF;
	                            cond|=(hoPtr.hoType&0xFFFF);
	                            hoPtr.hoAdRunHeader.rhEvtProg.rhCurParam0=hoPtr.roa.raAnimOn;
	                            return hoPtr.hoAdRunHeader.rhEvtProg.handle_Event(hoPtr, cond);
							}
	                    }
					}
	            };
	            raAnimCounter=counter;
	        }
	        else
	        {
	            frame--;
	        }
			raAnimFrame=frame;
			hoPtr.roc.rcChanged=true;
			hoPtr.roc.rcCheckCollides=true;
	        var image:int=adPtr.adFrames[frame];
	        if (hoPtr.roc.rcImage!=image || raOldAngle!=hoPtr.roc.rcAngle)
	        {
				hoPtr.roc.rcImage=image;
				raOldAngle=hoPtr.roc.rcAngle;
				if (image<0) 
		            return false;								//; Securite pour jeux casses
				ifo=hoPtr.hoAdRunHeader.rhApp.imageBank.getImageInfoEx(image, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY);
				hoPtr.hoImgWidth=ifo.width;
				hoPtr.hoImgHeight=ifo.height;
				hoPtr.hoImgXSpot=ifo.xSpot;
				hoPtr.hoImgYSpot=ifo.ySpot;
				hoPtr.hoImgXAP = ifo.xAP;
				hoPtr.hoImgYAP = ifo.yAP;
	        }
			return false;
	    }

	    // ---------------------------------------------------------------------------
	    // Verifie qu'une animation existe bien pour l'objet [esi]
	    // ---------------------------------------------------------------------------
	    public function anim_Exist(animId:int):Boolean
	    {
			var ahPtr:CAnimHeader=hoPtr.hoCommon.ocAnimations;                 // Pointe AnimHeader
			if (ahPtr.ahAnimExists[animId]==0)
	            return false;
			return true;
	    }

	    // ---------------------------------------------------------------------------
	    // MET L'ANIMATION EN ONE LOOP
	    // ---------------------------------------------------------------------------
	    public function animation_OneLoop():void
	    {
			if (raAnimRepeat==0)
			{
	            raAnimRepeat=1;								// Force un seul tour
			}
	    }
	    // ---------------------------------------------------------------------------
	    // FORCE ANIMATION, ax=animation
	    // ---------------------------------------------------------------------------
	    public function animation_Force(anim:int):void
	    {
			raAnimForced=anim+1;
			animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // RESTORE ANIMATION
	    // ---------------------------------------------------------------------------
	    public function animation_Restore():void
	    {
			raAnimCounter=0;
			raAnimForced=0;
			animIn(0);
	    }	
	    // ---------------------------------------------------------------------------
	    // FORCE DIRECTION, ax=direction
	    // ---------------------------------------------------------------------------
	    public function animDir_Force(dir:int):void
	    {
			dir&=31;
			raAnimDirForced=dir+1;
			animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // RESTORE DIRECTION
	    // ---------------------------------------------------------------------------
	    public function animDir_Restore():void
	    {
			raAnimCounter=0;
			raAnimDirForced=0;
			animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // FORCE SPEED, ax=speed
	    // ---------------------------------------------------------------------------
	    public function animSpeed_Force(speed:int):void
	    {
			if (speed<0) 
				speed=0;
			if (speed>100) 
				speed=100;
			raAnimSpeedForced=speed+1;
	        animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // RESTORE SPEED
	    // ---------------------------------------------------------------------------
	    public function animSpeed_Restore():void
	    {
			raAnimCounter=0;
			raAnimSpeedForced=0;
			animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // RESTART ANIMATION
	    // ---------------------------------------------------------------------------
	    public function anim_Restart():void
	    {
			raAnimOn=-1;
			animIn(0);
	    }   
	    // ---------------------------------------------------------------------------
	    // FORCE FRAME, ax=frame
	    // ---------------------------------------------------------------------------
	    public function animFrame_Force(frame:int):void
	    {
			if (frame>=raAnimNumberOfFrame) {
	            frame=raAnimNumberOfFrame-1;
			}
			if (frame<0) {
	            frame=0;
			}
			raAnimFrameForced=frame+1;
			animIn(0);
	    }
	    // ---------------------------------------------------------------------------
	    // RESTORE FRAME
	    // ---------------------------------------------------------------------------
	    public function animFrame_Restore():void
	    {
			raAnimCounter=0;
			raAnimFrameForced=0;
			animIn(0);
	    }

	    //  --------------------------------------------------------------------------
	    //	ANIMATION APPEAR
	    //  --------------------------------------------------------------------------
	    public function anim_Appear():void
	    {
			animIn(1);
		
			// Attend la fin de l'apparition
			if (raAnimForced!=CAnim.ANIMID_APPEAR+1)
			{
	            // Regarde si existe des animations STOP/WALK/RUN, sinon fait un DISAPPEAR
	            if (anim_Exist(CAnim.ANIMID_STOP) || anim_Exist(CAnim.ANIMID_WALK) || anim_Exist(CAnim.ANIMID_RUN))
	            {
					// Initialise le vrai mouvement de l'objet
					raRoutineAnimation=0;
					animation_Restore();
	            }
	            else
	            {
					raRoutineAnimation=2;
	            	hoPtr.hoAdRunHeader.init_Disappear(hoPtr);
	            }
			}
    	}

	    //  --------------------------------------------------------------------------
	    //	ANIMATION DISAPPEAR
	    //  --------------------------------------------------------------------------
	    public function anim_Disappear():void
	    {
			if ((hoPtr.hoFlags&CObject.HOF_FADEOUT)==0)
			{
	            animIn(1);									// Un cran d'animations
	            if (raAnimForced!=CAnim.ANIMID_DISAPPEAR+1)
	            {
	                hoPtr.hoAdRunHeader.destroy_Add(hoPtr.hoNumber);
	            }
			}
	    }

	}
}