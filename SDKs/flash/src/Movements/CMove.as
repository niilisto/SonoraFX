//----------------------------------------------------------------------------------
//
// CMOVE : Classe de base des mouvements
//
//----------------------------------------------------------------------------------
package Movements
{
	import Application.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.CArrayList;
	import Services.CPoint;
	
	public class CMove
	{
	    // Table de sinus/cosinus sur 32 angles en ",256"
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    public static var Cosinus32:Array=
	    [
			256,251,236,212,181,142,97,49,
			0,-49,-97,-142,-181,-212,-236,-251,
			-256,-251,-236,-212,-181,-142,-97,-49,
			0,49,97,142,181,212,236,251 
		];
	    public static var Sinus32:Array=
	    [
	    	0,-49,-97,-142,-181,-212,-236,-251,
			-256,-251,-236,-212,-181,-142,-97,-49,
			0,49,97,142,181,212,236,251,
			256,251,236,212,181,142,97,49 
		];

	    // Table d'acceleration reguliere de 0 a 100
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    public static var accelerators:Array=
		[
			0x0002,0x0003,0x0004,0x0006,0x0008,0x000a,0x000c,0x0010,0x0014,0x0018,
			0x0030,0x0038,0x0040,0x0048,0x0050,0x0058,0x0060,0x0068,0x0070,0x0078,
			0x0090,0x00A0,0x00B0,0x00c0,0x00d0,0x00e0,0x00f0,0x0100,0x0110,0x0120,
			0x0140,0x0150,0x0160,0x0170,0x0180,0x0190,0x01a0,0x01b0,0x01c0,0x01e0,
			0x0200,0x0220,0x0230,0x0250,0x0270,0x0280,0x02a0,0x02b0,0x02d0,0x02e0,
			0x0300,0x0310,0x0330,0x0350,0x0360,0x0380,0x03a0,0x03b0,0x03d0,0x03e0,
			0x0400,0x0460,0x04c0,0x0520,0x05a0,0x0600,0x0660,0x06c0,0x0720,0x07a0,
			0x0800,0x08c0,0x0980,0x0a80,0x0b40,0x0c00,0x0cc0,0x0d80,0x0e80,0x0f40,
			0x1000,0x1990,0x1332,0x1460,0x1664,0x1800,0x1999,0x1b32,0x1cc6,0x1e64,
			0x2000,0x266c,0x2d98,0x3404,0x3a70,0x40dc,0x4748,0x4db4,0x5400,0x6400,
			0x6400
		];

	    // Table: direction joystick . direction KNP
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    public static var Joy2Dir:Array = 
	    [
			-1,				// 0000 Static
			8,					// 0001
			24,					// 0010
			-1,				// 0011 Static
			16,					// 0100
			12,					// 0101
			20,					// 0110
			16,					// 0111
			0,					// 1000
			4,					// 1001
			28,					// 1010
			0,					// 1011
			-1,				// 1100 Static
			8,					// 1101
			24,					// 1110
			-1				// 1111 Static
		];

	    // Table des COS() / SIN() pour la recherche d'une direction   
	    public static var CosSurSin32:Array=[2599,0,844,31,479,30,312,29,210,28,137,27,78,26,25,25,0,24];

	    public static var mvap_TableDirs:Array=
	    [
			0,-2, 	0,2, 	0,-4, 	0,4, 	0,-8, 	0,8, 	-4,0, 	-8,0, 	0,0,	    // 0
			-2,-2,	2,2,	-4,-4,	4,4,	-8,-8,	8,8,	-4,4,	-8,8,	0,0,	    // 16
			-2,0,	2,0,	-4,0,	4,0,	-8,0,	8,0,	0,4,	0,8,	0,0,	    // 32
			-2,2,	2,-2,	-4,4,	4,-4,	-8,8,	8,-8,	4,4,	8,8,	0,0,	    // 48
			0,2,	0,-2,	0,4,	0,-4,	0,8,	0,-8,	4,0,	8,0,	0,0,	    // 64
			2,2,	-2,-2,	4,4,	-4,-4,	8,8,	-8,-8,	4,-4,	8,-8,	0,0,	    // 80
			2,0,	-2,0,	4,0,	-4,0,	8,0,	-8,0,	0,-4,	0,-8,	0,0,	    // 96
			2,-2,	-2,2,	4,-4,	-4,4,	8,-8,	-8,8,	-4,-4,	-8,-8,	0,0	    // 112
	    ];

		public static var MVTOPT_8DIR_STICK:int=0x01;
	
	    public var hoPtr:CObject;
	    public var rmAcc:int;						// Current acceleration
	    public var rmDec:int;						// Current Decelaration 
	    public var rmCollisionCount:int;			// Collision counter
	    public var rmStopSpeed:int;				// If stopped: speed to take again
	    public var rmAccValue:int;					// Acceleration calculation
	    public var rmDecValue:int;					// Deceleration calculation
		public var rmOpt:int;
		
		public function CMove()
		{
		}

	    public function newMake_Move(speed:int, angle:int):Boolean
	    {
	        hoPtr.hoAdRunHeader.rh3CollisionCount++;			//; Marque l'objet pour ce cycle
			rmCollisionCount=hoPtr.hoAdRunHeader.rh3CollisionCount;
			hoPtr.rom.rmMoveFlag=false;
		
			// Mode de gestion du mouvement
			// ----------------------------
			if (speed==0)
			{
	            // On ne bouge pas: appel des collisions directes!
	            // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	            hoPtr.hoAdRunHeader.newHandle_Collisions(hoPtr);		//; Appel les collisions
	            return false;
			}
				
			// Fait le mouvement?
			// ~~~~~~~~~~~~~~~~~~
	        var x:int, y:int;
			var speedShift:int;
			if ((hoPtr.hoAdRunHeader.rhFrame.leFlags&CRunFrame.LEF_TIMEDMVTS)!=0)
			{
	            speedShift=(int)( (Number(speed))*hoPtr.hoAdRunHeader.rh4MvtTimerCoef*32.0 );
			}
			else
			{
	            speedShift=speed<<5;
			}
			while(speedShift>0x0800)
			{
				x=hoPtr.hoX<<16|(hoPtr.hoCalculX&0x0000FFFF);
				y=hoPtr.hoY<<16|(hoPtr.hoCalculY&0x0000FFFF);
				x+= (Cosinus32[angle]) * 0x0800;
				y+= (  Sinus32[angle]) * 0x0800;
				hoPtr.hoCalculX=x&0x0000FFFF;
				hoPtr.hoX=(x>>16);
				hoPtr.hoCalculY=y&0x0000FFFF;
				hoPtr.hoY=(y>>16);

				if (hoPtr.hoAdRunHeader.newHandle_Collisions(hoPtr))		//; Appel les collisions
				{
					return true;	
				}
				if (hoPtr.rom.rmMoveFlag)
	            {
	                break;
	            }
	            speedShift-=0x0800;
			};
			if (!hoPtr.rom.rmMoveFlag)
			{
				x=hoPtr.hoX<<16|(hoPtr.hoCalculX&0x0000FFFF);
				y=hoPtr.hoY<<16|(hoPtr.hoCalculY&0x0000FFFF);
				x+= (Cosinus32[angle]) * speedShift;
				y+= (  Sinus32[angle]) * speedShift;
				hoPtr.hoCalculX=x&0x0000FFFF;
				hoPtr.hoX=(x>>16);
				hoPtr.hoCalculY=y&0x0000FFFF;
				hoPtr.hoY=(y>>16);
			
	            if (hoPtr.hoAdRunHeader.newHandle_Collisions(hoPtr))		//; Appel les collisions
				{
					return true;	
				}
			}
			hoPtr.roc.rcChanged=true;                                             //; Sprite bouge!
			if (!hoPtr.rom.rmMoveFlag)
			{
	            hoPtr.hoAdRunHeader.rhVBLObjet=0;			//; Stocke le VBL actuel
			}
			return hoPtr.rom.rmMoveFlag;
	    }    

	    // Initialise le move at start
	    public function moveAtStart(mvPtr:CMoveDef):void
	    {
	        if (mvPtr.mvMoveAtStart==0)
	        {
	            stop();
	        }
	    }
    	public function getAccelerator(acceleration:int):int
    	{
	        if (acceleration<=100)
	        {
	            return accelerators[acceleration];
	        }
	        return acceleration<<8;
	    }

	    // --------------------------------------------------------------------------------
	    // --------------------------------------------------------------------------------
	    // POSITIONNE UN SPRITE EN TRAIN DE BOUGER TOUT CONTRE UN OBSTACLE, SI NECESSAIRE
	    // --------------------------------------------------------------------------------
	    // --------------------------------------------------------------------------------
	    public function mv_Approach(bStickToObject:Boolean):void
	    {
	    	if (bStickToObject)
	    	{
	    		mb_Approach(false);
	    		return;
	    	}
	    	
	    	var flag:Boolean=false;
	    	
        	switch(hoPtr.hoAdRunHeader.rhEvtProg.rhCurCode&0xFFFF0000)
			{
	            case (-12<<16):         // CNDL_EXTOUTPLAYFIELD:
	                // --------------------------------------------------------------------------------
	                // Sortie du terrain...
	                // --------------------------------------------------------------------------------
	                // Recadre le sprite dans le terrain
	                // ---------------------------------
	                var x:int=hoPtr.hoX-hoPtr.hoImgXSpot;
	                var y:int=hoPtr.hoY-hoPtr.hoImgYSpot;
	                var dir:int=hoPtr.hoAdRunHeader.quadran_Out(x, y, x+hoPtr.hoImgWidth, y+hoPtr.hoImgHeight);
	                x=hoPtr.hoX;
	                y=hoPtr.hoY;
	                if ((dir&CRun.BORDER_LEFT)!=0)
	                    x=hoPtr.hoImgXSpot;
	                if ((dir&CRun.BORDER_RIGHT)!=0)
	                {
	                    x=hoPtr.hoAdRunHeader.rhLevelSx-hoPtr.hoImgWidth+hoPtr.hoImgXSpot;
	                }
	                if ((dir&CRun.BORDER_TOP)!=0)
	                    y=hoPtr.hoImgYSpot;
	                if ((dir&CRun.BORDER_BOTTOM)!=0)
	                {
	                    y=hoPtr.hoAdRunHeader.rhLevelSy-hoPtr.hoImgHeight+hoPtr.hoImgYSpot;
	                }
	                hoPtr.hoX=x;
	                hoPtr.hoY=y;
					return;
			    case (-13<<16):	    // CNDL_EXTCOLBACK:
			    case (-14<<16):	    // CNDL_EXTCOLLISION:	
					var index:int=(hoPtr.roc.rcDir>>2)*18;
					do
					{
					    if (tst_Position(hoPtr.hoX+mvap_TableDirs[index], hoPtr.hoY+mvap_TableDirs[index+1], flag))
					    {
							// Positionne le sprite au plus pres de la position
							// ------------------------------------------------
				
							hoPtr.hoX+=mvap_TableDirs[index];
							hoPtr.hoY+=mvap_TableDirs[index+1];
							return;
					    }
					    index+=2;
					}while(mvap_TableDirs[index]!=0 || mvap_TableDirs[index+1]!=0);
		
					// On arrive pas : ancienne position / ancienne animation!
					// -------------------------------------------------------
					if (flag==false)
					{
					    hoPtr.hoX=hoPtr.roc.rcOldX;
					    hoPtr.hoY=hoPtr.roc.rcOldY;
					    hoPtr.roc.rcImage=hoPtr.roc.rcOldImage;
					    hoPtr.roc.rcAngle=hoPtr.roc.rcOldAngle;
					    return;
					}
					break;
			    default:
					break;
			}
	    }
	    public function mb_Approach(flag:Boolean):void
	    {
        	switch(hoPtr.hoAdRunHeader.rhEvtProg.rhCurCode&0xFFFF0000)
			{
	            case (-12<<16):         // CNDL_EXTOUTPLAYFIELD:
	                // --------------------------------------------------------------------------------
	                // Sortie du terrain...
	                // --------------------------------------------------------------------------------
	                // Recadre le sprite dans le terrain
	                // ---------------------------------
	                var x:int=hoPtr.hoX-hoPtr.hoImgXSpot;
	                var y:int=hoPtr.hoY-hoPtr.hoImgYSpot;
	                var dir:int=hoPtr.hoAdRunHeader.quadran_Out(x, y, x+hoPtr.hoImgWidth, y+hoPtr.hoImgHeight);
	                x=hoPtr.hoX;
	                y=hoPtr.hoY;
	                if ((dir&CRun.BORDER_LEFT)!=0)
	                    x=hoPtr.hoImgXSpot;
	                if ((dir&CRun.BORDER_RIGHT)!=0)
	                {
	                    x=hoPtr.hoAdRunHeader.rhLevelSx-hoPtr.hoImgWidth+hoPtr.hoImgXSpot;
	                }
	                if ((dir&CRun.BORDER_TOP)!=0)
	                    y=hoPtr.hoImgYSpot;
	                if ((dir&CRun.BORDER_BOTTOM)!=0)
	                {
	                    y=hoPtr.hoAdRunHeader.rhLevelSy-hoPtr.hoImgHeight+hoPtr.hoImgYSpot;
	                }
	                hoPtr.hoX=x;
	                hoPtr.hoY=y;
					return;
			    case (-13<<16):	    // CNDL_EXTCOLBACK:
			    case (-14<<16):	    // CNDL_EXTCOLLISION:	
					// --------------------------------------------------------------------------------
					// Contre un objet de decor...
					// --------------------------------------------------------------------------------
					// Essaye de sortir le sprite de la collision dans les 8 directions, avec la nouvelle image
					// ----------------------------------------------------------------------------------------
					var pt:CPoint=new CPoint();
					if (mbApproachSprite(hoPtr.hoX, hoPtr.hoY, hoPtr.roc.rcOldX, hoPtr.roc.rcOldY, flag, pt))
					{
					    hoPtr.hoX=pt.x;
					    hoPtr.hoY=pt.y;
					    return;
					}		
					var index:int=(hoPtr.roc.rcDir>>2)*18;
					do
					{
					    if (tst_Position(hoPtr.hoX+mvap_TableDirs[index], hoPtr.hoY+mvap_TableDirs[index+1], flag))
					    {
							// Positionne le sprite au plus pres de la position
							// ------------------------------------------------
				
							hoPtr.hoX+=mvap_TableDirs[index];
							hoPtr.hoY+=mvap_TableDirs[index+1];
							return;
					    }
					    index+=2;
					}while(mvap_TableDirs[index]!=0 || mvap_TableDirs[index+1]!=0);
		
					// On arrive pas : ancienne position / ancienne animation!
					// -------------------------------------------------------
					if (flag==false)
					{
					    hoPtr.hoX=hoPtr.roc.rcOldX;
					    hoPtr.hoY=hoPtr.roc.rcOldY;
					    hoPtr.roc.rcImage=hoPtr.roc.rcOldImage;
					    hoPtr.roc.rcAngle=hoPtr.roc.rcOldAngle;
					    return;
					}
					break;
			    default:
					break;
			}
    	}

	    // ------------------------------------------------------------------------
	    // Verification de la position d'un sprite : prend TOUT en compte
	    // Bordure / Decor / Sprites interdits ...
	    // ------------------------------------------------------------------------
	    public function tst_SpritePosition(x:int, y:int, htFoot:int, planCol:int, flag:Boolean):Boolean
	    {
			var sprOi:int;
			sprOi=-1;
			if (flag)
			{
		    	sprOi=hoPtr.hoOi;
			}
			var oilPtr:CObjInfo=hoPtr.hoOiList;
	
			// Verification de la bordure
			// --------------------------
			if ((oilPtr.oilLimitFlags&0x000F)!=0)
			{
	            var xx:int=x-hoPtr.hoImgXSpot;
	            var yy:int=y-hoPtr.hoImgYSpot;
	            if ((hoPtr.hoAdRunHeader.quadran_Out(xx, yy, xx+hoPtr.hoImgWidth, yy+hoPtr.hoImgHeight)&oilPtr.oilLimitFlags)!=0) 
	                return false;
			}
	
			// Verification du decor
			// ---------------------
			if ((oilPtr.oilLimitFlags&0x0010)!=0)
			{
	            if (hoPtr.hoAdRunHeader.colMask_TestObject_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, x, y, htFoot, planCol)) // FRAROT
					return false;
			}
	
			// Verification des sprites
			// ------------------------
			if (oilPtr.oilLimitList==-1) 
	            return true;
	
			// Demande les collisions a cette position...
			var list:CArrayList=hoPtr.hoAdRunHeader.objectAllCol_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, x, y, oilPtr.oilColList);	
			if (list==null) 
	            return true;
		
			// Exploration de la liste: recherche les sprites marque STOP pour ce sprite
			var lb:Array=hoPtr.hoAdRunHeader.rhEvtProg.limitBuffer;
			var index:int;
			for (index=0; index<list.size(); index++)
			{
			    var hoSprite:CObject=CObject(list.get(index));		//; Le sprite en collision
			    var oi:int=hoSprite.hoOi;
			    if (oi!=sprOi)						//; Ne pas tenir compte de lui-meme?
			    {
					var ll:int;
					for (ll=oilPtr.oilLimitList; lb[ll]>=0; ll++)
					{
					    if (lb[ll]==oi) 
					    {
					    	return false;	
					    }
					}
			    }
			}

	 		// On peut aller
			// -------------
			return true;
	    }

	    // ------------------------------------------------------------------------
	    // Verification de la position d'un sprite : prend TOUT en compte
	    // Bordure / Decor / Sprites interdits ... CX!=0 :  ne pas tenir compte du sprite lui-meme
	    //	return	C set=> OK, on peut y aller
	    // ------------------------------------------------------------------------
	    public function tst_Position(x:int, y:int, flag:Boolean):Boolean
	    {
			var sprOi:int;
	
	        sprOi=-1;
			if (flag)
			{
	            sprOi=hoPtr.hoOi;
			}
			var oilPtr:CObjInfo=hoPtr.hoOiList;
	
			// Verification de la bordure
			// --------------------------
			if ((oilPtr.oilLimitFlags&0x000F)!=0)
			{
	            var xx:int=x-hoPtr.hoImgXSpot;
	            var yy:int=y-hoPtr.hoImgYSpot;
	            var dir:int=hoPtr.hoAdRunHeader.quadran_Out(xx, yy, xx+hoPtr.hoImgWidth, yy+hoPtr.hoImgHeight);
	            if ((dir&oilPtr.oilLimitFlags)!=0)
	                return false;
			}
	
			// Verification du decor
			// ---------------------
			if ((oilPtr.oilLimitFlags&0x0010)!=0)
			{
	            if (hoPtr.hoAdRunHeader.colMask_TestObject_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, x, y, 0, CRunFrame.CM_TEST_PLATFORM)) // FRAROT
					return false;
			}
	
			// Verification des sprites
			// ------------------------
			if (oilPtr.oilLimitList==-1) 
	            return true;
	
			// Demande les collisions a cette position...
			var list:CArrayList=hoPtr.hoAdRunHeader.objectAllCol_IXY(hoPtr, hoPtr.roc.rcImage, hoPtr.roc.rcAngle, hoPtr.roc.rcScaleX, hoPtr.roc.rcScaleY, x, y, oilPtr.oilColList);
			if (list==null) 
	            return true;
	
			// Exploration de la liste: recherche les sprites marque STOP pour ce sprite
			var lb:Array=hoPtr.hoAdRunHeader.rhEvtProg.limitBuffer;
			var index:int;
			for (index=0; index<list.size(); index++)
			{
			    var hoSprite:CObject=CObject(list.get(index));		//; Le sprite en collision
			    var oi:int=hoSprite.hoOi;
			    if (oi!=sprOi)						//; Ne pas tenir compte de lui-meme?
			    {
					var ll:int;
					for (ll=oilPtr.oilLimitList; lb[ll]>=0; ll++)
					{
					    if (lb[ll]==oi) return false;
					}
			    }
			}
	        
			// On peut aller
			// -------------
			return true;
		}

	    //-----------------------------------------------------//
	    //	Approcher un sprite au maximum d'un obstacle       //
	    //-----------------------------------------------------//
	    // Le sprite est approche au maximum de (destX, destY) //
	    // et la position la plus eloignee est donnee par	   //
	    // (maxX, maxY). Le sprite est deplace vers maxX-Y	.  //
	    public function mpApproachSprite(destX:int, destY:int, maxX:int, maxY:int, htFoot:int, planCol:int, ptFinal:CPoint):Boolean
	    {
			var presX:int=destX;
			var presY:int=destY;
			var loinX:int=maxX;
			var loinY:int=maxY;
		
			var x:int=(presX+loinX)/2;
			var y:int=(presY+loinY)/2;
			var oldX:int, oldY:int;
		
			do
			{
	            if (tst_SpritePosition(x+hoPtr.hoAdRunHeader.rhWindowX, y+hoPtr.hoAdRunHeader.rhWindowY, htFoot, planCol, false))	
	            {
	                // On peut y aller
	                loinX=x;
	                loinY=y;
	                oldX=x;
	                oldY=y;
	                x=(loinX+presX)/2;
	                y=(loinY+presY)/2;
	                if (x==oldX && y==oldY)
	                {
	                    if (loinX!=presX || loinY!=presY)
	                    {
	                        if (tst_SpritePosition(presX+hoPtr.hoAdRunHeader.rhWindowX, presY+hoPtr.hoAdRunHeader.rhWindowY, htFoot, planCol, false))
	                        {
	                            x=presX;
	                            y=presY;
	                        }
	                    }
	                    ptFinal.x=x;
	                    ptFinal.y=y;
	                    return true;
	                }
	            }
	            else
	            {
	                // On ne peut pas y aller
	                presX=x;
	                presY=y;
	                oldX=x;
	                oldY=y;
	                x=(loinX+presX)/2;
	                y=(loinY+presY)/2;
	                if (x==oldX && y==oldY)
	                {
	                    if (loinX!=presX || loinY!=presY)
	                    {
	                        if (tst_SpritePosition(loinX+hoPtr.hoAdRunHeader.rhWindowX, loinY+hoPtr.hoAdRunHeader.rhWindowY, htFoot, planCol, false))
	                        {
	                            ptFinal.x=loinX;
	                            ptFinal.y=loinY;
	                            return true;
	                        }
	                    }
	                    ptFinal.x=x;
	                    ptFinal.y=y;
	                    return false;
	                }
	            }
			} while(true);
			return false;
	    }

	    //-----------------------------------------------------//
	    //	Approcher un sprite au maximum d'un obstacle BALLE //
	    //-----------------------------------------------------//
	    // Le sprite est approche au maximum de (destX, destY) //
	    // et la position la plus eloignee est donnee par	   //
	    // (maxX, maxY). Le sprite est deplace vers maxX-Y	.  //
	    public function mbApproachSprite(destX:int, destY:int, maxX:int, maxY:int, flag:Boolean, ptFinal:CPoint):Boolean
	    {
			var presX:int=destX;
			var presY:int=destY;
			var loinX:int=maxX;
			var loinY:int=maxY;
		
			var x:int=(presX+loinX)/2;
			var y:int=(presY+loinY)/2;
			var oldX:int, oldY:int;
		
			do
			{
	            if (tst_Position(x, y, flag))	
	            {
	                // On peut y aller
	                loinX=x;
	                loinY=y;
	                oldX=x;
	                oldY=y;
	                x=(loinX+presX)/2;
	                y=(loinY+presY)/2;
	                if (x==oldX && y==oldY)
	                {
	                    if (loinX!=presX || loinY!=presY)
	                    {
	                        if (tst_Position(presX, presY, flag))
	                        {
	                            x=presX;
	                            y=presY;
	                        }
	                    }
	                    ptFinal.x=x;
	                    ptFinal.y=y;
	                    return true;
	                }
	            }
	            else
	            {
	                // On ne peut pas y aller
	                presX=x;
	                presY=y;
	                oldX=x;
	                oldY=y;
	                x=(loinX+presX)/2;
	                y=(loinY+presY)/2;
	                if (x==oldX && y==oldY)
	                {
	                    if (loinX!=presX || loinY!=presY)
	                    {
	                        if (tst_Position(loinX, loinY, flag))
	                        {
	                            ptFinal.x=loinX;
	                            ptFinal.y=loinY;
	                            return true;
	                        }
	                    }
	                    ptFinal.x=x;
	                    ptFinal.y=y;
	                    return false;
	                }
	            }
			} while(true);
			return false;
	    }
	    public static function getDeltaX(pente:int, angle:int):int
	    {
			return (pente*Cosinus32[angle])/256;	//; Fois cosinus-> penteX
	    }
	    public static function getDeltaY(pente:int, angle:int):int
	    {
			return (pente*Sinus32[angle])/256;		//; Fois sinus-> penteY
	    }

	    // Changement acceleration / deceleration
	    public function setAcc(acc:int):void
	    {
			if (acc>250) acc=250;
			if (acc<0) acc=0;
			rmAcc=acc;
			rmAccValue=getAccelerator(acc);
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
				var mvt:CMoveExtension=CMoveExtension(this);
			    mvt.movement.setAcc(acc);
			}
	    }
	    public function setDec(dec:int):void
	    {
			if (dec>250) dec=250;
			if (dec<0) dec=0;
			rmDec=dec;
			rmDecValue=getAccelerator(dec);
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
				var mvt:CMoveExtension =CMoveExtension(this);
			    mvt.movement.setDec(dec);
			}
	    }
	    public function setRotSpeed(speed:int):void
	    {
			if (speed>250) speed=250;
			if (speed<0) speed=0;
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_RACE)
			{
			    var mRace:CMoveRace=CMoveRace(this);
			    mRace.setRotSpeed(speed);
			}
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
			    var mvt:CMoveExtension=CMoveExtension(this);
			    mvt.movement.setRotSpeed(speed);
			}
	    }    
	    public function set8Dirs(dirs:int):void
	    {
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_GENERIC)
			{
			    var mGeneric:CMoveGeneric=CMoveGeneric(this);
			    mGeneric.set8DirsGeneric(dirs);
			}
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
				var mvt:CMoveExtension=CMoveExtension(this);
			    mvt.movement.set8Dirs(dirs);
			}
	    }    
	    public function setGravity(gravity:int):void
	    {
			if (gravity>250) gravity=250;
			if (gravity<0) gravity=0;
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_PLATFORM)
			{
			    var mPlatform:CMovePlatform=CMovePlatform(this);
			    mPlatform.setGravity(gravity);
			}
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
			    var mvt:CMoveExtension=CMoveExtension(this);
			    mvt.movement.setGravity(gravity);
			}
	    } 
		public function getDir():int {
			if (this.hoPtr.roc.rcMovementType == CMoveDef.MVTYPE_EXT)
			{
				var mvt:CMoveExtension= CMoveExtension(this);
				return mvt.movement.getDir();
			}
			return this.hoPtr.roc.rcDir;
		}		
	    public function getSpeed():int
	    {
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
				var mvt:CMoveExtension=CMoveExtension(this);
			    return mvt.movement.getSpeed();
			}
			return hoPtr.roc.rcSpeed;
	    }
	    public function getAcc():int
	    {
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
			    var mvt:CMoveExtension=CMoveExtension(this);
			    return mvt.movement.getAcceleration();
			}
			return rmAcc;
	    }
	    public function getDec():int
	    {
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
			    var mvt:CMoveExtension=CMoveExtension(this);
			    return mvt.movement.getDeceleration();
			}
			return rmDec;
	    }
	    public function getGravity():int
	    {
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_PLATFORM)
			{
			    var mp:CMovePlatform=CMovePlatform(this);
			    return mp.MP_Gravity;
			}
			if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
			{
			    var mvt:CMoveExtension=CMoveExtension(this);
			    return mvt.movement.getGravity();
			}
			return 0;
	    }

	    public function init(hoPtr:CObject, mvPtr:CMoveDef):void
	    {
	    	
	    }
	    public function kill():void
	    {
	    	
	    }
	    public function move():void
	    {
	    	
	    }	    
	    public function stop():void
	    {
	    	
	    }
	    public function start():void
	    {
	    	
	    }
	    public function bounce():void
	    {
	    	
	    }
	    public function reverse():void
	    {
	    	
	    }
	    public function setXPosition(x:int):void
	    {
	    	
	    }
	    public function setYPosition(u:int):void
	    {
	    	
	    }
	    public function setSpeed(speed:int):void
	    {
	    	
	    }
	    public function setMaxSpeed(speed:int):void
	    {
	    	
	    }
	    public function setDir(dir:int):void
	    {
	    	
	    }

	}
}