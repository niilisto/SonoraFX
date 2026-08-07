//----------------------------------------------------------------------------------
//
// CRUNLOOP : BOucle principale
//
//----------------------------------------------------------------------------------
package RunLoop
{
	import Actions.*;
	
	import Animations.*;
	
	import Application.*;
	
	import Banks.*;
	
	import Events.*;
	
	import Expressions.*;
	
	import Extensions.*;
	
	import Frame.*;
	
	import Movements.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import Values.*;
	
	import flash.system.*;
	import flash.ui.Mouse;
	import flash.utils.*;
	
	public class CRun
	{
		public static var INTBAD:int=0x7FFFFFFF;
		// Flags
		public static var GAMEFLAGS_VBLINDEP:int=0x0002;
		public static var GAMEFLAGS_LIMITEDSCROLL:int=0x0004;
		public static var GAMEFLAGS_FIRSTLOOPFADEIN:int=0x0010;
		public static var GAMEFLAGS_LOADONCALL:int=0x0020;
		public static var GAMEFLAGS_REALGAME:int=0x0040;
		public static var GAMEFLAGS_PLAY:int=0x0080;
		public static var GAMEFLAGS_INITIALISING:int=0x0200;
		
		// Flags pour DrawLevel
		public const DLF_DONTUPDATE:int=0x0002;
		public const DLF_DRAWOBJECTS:int=0x0004;
		public const DLF_RESTARTLEVEL:int=0x0008;
		public const DLF_DONTUPDATECOLMASK:int=0x0010;
		public const DLF_COLMASKCLIPPED:int=0x0020;
		public const DLF_SKIPLAYER0:int=0x0040;
		public const DLF_REDRAWLAYER:int=0x0080;
		public const DLF_STARTLEVEL:int=0x0100;
		public const GAME_XBORDER:int=480;
		public const GAME_YBORDER:int=300;
		public const COLMASK_XMARGIN:int=64;
		public const COLMASK_YMARGIN:int=16;
		public const WRAP_X:int=1;
		public const WRAP_Y:int=2;
		public const WRAP_XY:int=4;
		
		public static var plMasks:Array=
			[
				0x00, 0x00, 0x00, 0x00,
				0xFF, 0x00, 0x00, 0x00,
				0xFF, 0xFF, 0x00, 0x00,
				0xFF, 0xFF, 0xFF, 0x00,
				0xFF, 0xFF, 0xFF, 0xFF,
			];
		
		// Flags pour rh3Scrolling
		public static var RH3SCROLLING_SCROLL:int=0x0001;
		public static var RH3SCROLLING_REDRAWLAYERS:int=0x0002;
		public static var RH3SCROLLING_REDRAWALL:int=0x0004;
		public static var RH3SCROLLING_REDRAWTOTALCOLMASK:int=0x0008;
		
		// Types d'obstacles
		public const OBSTACLE_NONE:int=0;
		public const OBSTACLE_SOLID:int=1;
		public const OBSTACLE_PLATFORM:int=2;
		public const OBSTACLE_LADDER:int=3;
		public const OBSTACLE_TRANSPARENT:int=4;		// for Add Backdrop
		
		//Flags pour createobject
		public static var COF_NOMOVEMENT:int=0x0001;
		public static var COF_HIDDEN:int=0x0002;
		public static var COF_FIRSTTEXT:int=0x0004;
		public static var COF_CREATEDATSTART:int = 0x0008;
		public static var MAX_FRAMERATE:int=10;
		
		// Main loop exit codes
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~
		public static var LOOPEXIT_NEXTLEVEL:int=1;
		public static var LOOPEXIT_PREVLEVEL:int=2;
		public static var LOOPEXIT_GOTOLEVEL:int=3;
		public static var LOOPEXIT_NEWGAME:int=4;
		public static var LOOPEXIT_PAUSEGAME:int=5;
		public static var LOOPEXIT_SAVEAPPLICATION:int=6;
		public static var LOOPEXIT_LOADAPPLICATION:int=7;
		public static var LOOPEXIT_SAVEFRAME:int=8;
		public static var LOOPEXIT_LOADFRAME:int=9;
		public static var LOOPEXIT_ENDGAME:int=-2;
		public static var LOOPEXIT_QUIT:int=100;
		public static var LOOPEXIT_RESTART:int=101;
		
		public static var BORDER_LEFT:int=1;
		public static var BORDER_RIGHT:int=2;
		public static var BORDER_TOP:int=4;
		public static var BORDER_BOTTOM:int=8;
		public static var BORDER_ALL:int=15;
		
		public static const FANIDENTIFIER:int=0x42324641;
		public static const TREADMILLIDENTIFIER:int=0x4232544D;
		public static const PARTICULESIDENTIFIER:int= 0x42326AF3;
		public static const MAGNETIDENTIFIER:int= 0x42369856;
		public static const ROPEANDCHAINIDENTIFIER:int= 0x4232EFFA;
		public static const BASEIDENTIFIER:int= 0x42324547;
		
		// Table d'elimination des entrees/sorties impossibles
		// ---------------------------------------------------
		public static var Table_InOut:Array=
			[
				0,							// 0000
				BORDER_LEFT,                                            // 0001 BORDER_LEFT
				BORDER_RIGHT,                                           // 0010 BORDER_RIGHT
				0,							// 0011
				BORDER_TOP,                                             // 0100 BORDER_TOP
				BORDER_TOP+BORDER_LEFT,                                 // 0101
				BORDER_TOP+BORDER_RIGHT,                                // 0110
				0,							// 0111
				BORDER_BOTTOM,                                          // 1000 BORDER BOTTOM
				BORDER_BOTTOM+BORDER_LEFT,                              // 1001
				BORDER_BOTTOM+BORDER_RIGHT,                             // 1010
				0,							// 1011
				0,							// 1100
				0,							// 1101
				0,							// 1110
				0							// 1111
			];
		
		public static var bMoveChanged:Boolean;
		
		// RunHeader
		public var rhApp:CRunApp;
		public var rhFrame:CRunFrame;
		public var rhMaxOI:int;
		
		public var rhStopFlag:int;					// Current movement needs to be stopped
		public var rhEvFlag:int; 					// Event evaluation flag
		public var rhNPlayers:int;					// Number of players
		
		public var rhGameFlags:int;					// Game flags
		public var rhPlayer:Array;					// Current players entry
		
		public var rhQuit:int;
		public var rhQuitBis:int; 					// Secondary quit (scrollings)
		public var rhReturn:int;					// Value to return to the editor
		public var rhQuitParam:int;
		
		public var rhNObjects:int;
		public var rhMaxObjects:int;
		
		public var rhOiList:Array;                     		// ObjectInfo list
		public var rhEvtProg:CEventProgram;
		
		public var rhLevelSx:int;				// Window size
		public var rhLevelSy:int;
		public var rhWindowX:int;   				// Start of window in X/Y
		public var rhWindowY:int;
		
		public var rhVBLDeltaOld:int;				// Number of VBL
		public var rhVBLObjet:int;				// For the objects
		public var rhVBLOld:int;				// For the counter
		
		public var rhMT_VBLStep:int;   			// Path movement variables
		public var rhMT_VBLCount:int;
		public var rhMT_MoveStep:int;
		
		public var rhLoopCount:int;				// Number of loops since start of level
		public var rhTimer:int;				// Timer in 1/50 since start of level
		public var rhTimerOld:int;				// For delta calculation
		public var rhTimerDelta:int;				// For delta calculation
		
		public var rhOiListPtr:int;				// OI list enumeration
		public var rhObListNext:int;				// Branch label
		
		public var rhDestroyPos:int;
		public var rhMouseUsed:int;
		
		public var rh2OldPlayer:Array;				// Previous player entries
		public var rh2NewPlayer:Array;				// Modified player entries
		public var rh2InputMask:Array;				// Inhibated players entries
		public var rh2MouseKeys:int;				// Mousekey entries
		public var rh2CreationCount:int;			// Number of objects created since beginning of frame
		public var rh2MouseX:int;				// Mouse coordinate
		public var rh2MouseY:int;				// Mouse coordinate
		
		public var rh2MouseSaveX:int;				// Mouse saving when pause
		public var rh2MouseSaveY:int;				// Mouse saving when pause
		public var rh2PauseCompteur:int;
		public var rh2PauseTimer:int;
		public var rh2PauseVbl:int;
		
		public var rh3DisplayX:int;				// To scroll
		public var rh3DisplayY:int;
		
		public var rh3WindowSx:int;   				// Window size
		public var rh3WindowSy:int;
		
		public var rh3CollisionCount:int;			// Collision counter 
		public var rh3Scrolling:int;				// Flag: we need to scroll
		
		public var rh3XMinimum:int;   				// Object inactivation coordinates
		public var rh3YMinimum:int;
		public var rh3XMaximum:int;
		public var rh3YMaximum:int;
		public var rh3XMinimumKill:int;			// Object destruction coordinates
		public var rh3YMinimumKill:int;
		public var rh3XMaximumKill:int;
		public var rh3YMaximumKill:int;
		public var rh3Graine:int;
		
		public var rh4DemoMode:int;
		public var rh4Demo:CDemoRecord;
		public var rh4PauseKey:int;
		public var rh4CurrentFastLoop:String;
		public var rh4EndOfPause:int;
		public var rh4MouseWheelDelta:int;
		public var rh4OnMouseWheel:int;
		public var rh4PSaveFilename:String;
		public var rh4SaveVersion:int;
		public var rh4LoadCount:int;
		
		//public var rh4FastLoops:CArrayList;
		
		public var rh4ExpValue1:CValue;				// New V2
		public var rh4ExpValue2:CValue;
		
		public var rh4KpxReturn:int;				// WindowProc return 
		public var rh4ObjectCurCreate:int;
		public var rh4ObjectAddCreate:int;
		public var rh4FakeKey:int;				// For step through : fake key pressed
		public var rh4DoUpdate:int;				// Flag for screen update on first loop
		public var rh4MenuEaten:Boolean;			// Menu handled in an event?
		public var rh4OnCloseCount:int;			// For OnClose event
		public var rh4ScrMode:int;				// Current screen mode
		public var rh4VBLDelta:int;				// Number of VBL
		public var rh4LoopTheoric:int;				// Theorical VBL counter
		public var rh4EventCount:int;
		public var rh4BackDrawRoutines:CArrayList;
		
		public var rh4WindowDeltaX:int;			// For scrolling
		public var rh4WindowDeltaY:int;               
		public var rh4TimeOut:int;				// For time-out!
		public var rh4TabCounter:int;				// Objects with tabulation
		
		public var rh4PosPile:int;				// Expression evaluation pile position
		public var rh4Results:Array;				// Result pile
		public var rh4Operators:Array;				// Operators pile
		public var rh4OpeNull:CExp;
		public var rh4CurToken:int;
		public var rh4Tokens:Array;
		public static var MAX_INTERMEDIATERESULTS:int=128;
		public var rh4FrameRateArray:Array;             // Framerate calculation buffer
		public var rh4FrameRatePos:int;						// Position in buffer
		public var rh4FrameRatePrevious:int;					// Previous time 
		
		public var rhDestroyList:Array;			// Destroy list address
		public var rh4SaveFrame:int;
		public var rh4SaveFrameCount:int;
		public var rh4MvtTimerCoef:Number;
		public var questionObjectOn:CQuestion;
		public var bOperande:Boolean;
		public var rhWheelCount:int;
		public var rhObjectList:Array;			// Object list address
		public var currentTabObject:CObject;
		
		public var rh4Box2DBase:CRunBaseParent;
		public var rh4Box2DObject:Boolean = false;
		public var rh4Box2DSearched:Boolean = false;
		public var bodiesCreated:Boolean = false;
		public var rh4TimerEvents:TimerEvents;
		public var rh4PosOnLoop:CArrayList;
		public var debugString:String;
		public var rhHiscore:CExtension;
		public var buttonClickCount:int=-1;
		public var isColArray:Array;
		
		public var rh4ForEachs:CForEach=null;
		public var rh4CurrentForEach:CForEach;
		public var rh4CurrentForEach2:CForEach=null;
		
		public var OSversion:String;
		private var nLoopGC:int;
		// FastLoop HashMap
		public var rh4FastLoops:HashMap;
		
		public function CRun(a:CRunApp, f:CRunFrame)
		{
			rhApp=a;
			rhFrame=f;
			OSversion = flash.system.Capabilities.version;
			OSversion = OSversion.substr(0,3);
			isColArray=new Array(2);
		}
		
		public function findFastLoop (name:String):CLoop 
		{
			return rh4FastLoops.getValue(name);
		}
		
		public function allocRunHeader():void
		{
			// L'object list
			rhObjectList=new Array(rhFrame.maxObjects);
			
			// Le programme d'evenements
			rhEvtProg=rhFrame.evtProg;
			
			// Compte les objinfos
			rhMaxOI=0;
			var oi:COI;
			for (oi=rhApp.OIList.getFirstOI(); oi!=null; oi=rhApp.OIList.getNextOI())
			{
				if ( oi.oiType>=COI.OBJ_SPR )
				{
					rhMaxOI++;
				}
			}
			
			// Random generator
			if (rhFrame.m_wRandomSeed==-1)
			{
				var tick:int=getTimer();
				rh3Graine = tick&0xFFFF;				// Fait un randomize
			}
			else
			{
				rh3Graine=rhFrame.m_wRandomSeed;			// Fixe la valeur donnée
			}
			
			// La destroy-list
			rhDestroyList=new Array(int(rhFrame.maxObjects/32+1));
			
			// Les fast loops
			rh4FastLoops = new HashMap();
			rh4CurrentFastLoop=new String("");
			
			// Le buffer d'objets
			rhMaxObjects=rhFrame.maxObjects;
			
			// INITIALISATION DU RESTE DES DONNEES
			rhNPlayers=rhEvtProg.nPlayers;
			rhWindowX=rhFrame.leX;
			rhWindowY=rhFrame.leY;
			rhLevelSx=rhFrame.leVirtualRect.right;
			if ( rhLevelSx==-1 )
				rhLevelSx=0x7FFFF000;		// 2147479552
			rhLevelSy=rhFrame.leVirtualRect.bottom;
			if ( rhLevelSy == -1 )
				rhLevelSy = 0x7FFFF000;		// 2147479552
			rhNObjects=0;
			rhStopFlag=0;
			rhQuit=0;
			rhQuitBis=0;
			rhGameFlags&=(GAMEFLAGS_PLAY);
			rhGameFlags|=GAMEFLAGS_LIMITEDSCROLL;
			rh4FrameRatePos=0;
			rh4FrameRatePrevious=0;
			rh4FrameRateArray=new Array(MAX_FRAMERATE);
			rh4BackDrawRoutines=null;
			rh4SaveFrame=0;
			rh4SaveFrameCount=-3;
			rhWheelCount=-1;
			currentTabObject=null;
			
			rhGameFlags|=GAMEFLAGS_REALGAME;
			
			// Rempli les CValue pour l'evaluation d'expression
			rh4Results=new Array(MAX_INTERMEDIATERESULTS);
			rh4Operators=new Array(MAX_INTERMEDIATERESULTS);
			var n:int;
			for (n=0; n<MAX_INTERMEDIATERESULTS; n++)
			{
				rh4Results[n]=new CValue(0);
			}
			rh4OpeNull=new EXP_END();
			rh4OpeNull.code=0;
			
			// Inits players
			rh2OldPlayer=new Array(4);				// Previous player entries
			rh2NewPlayer=new Array(4);				// Modified player entries
			rh2InputMask=new Array(4);				// Inhibated players entries
			rhPlayer=new Array(4);		
			rhEvtProg.rh2CurrentClick = -1;
			rh4MvtTimerCoef=0;
			
			// Header valide!
			rhFrame.rhOK=true;
		}
		public function freeRunHeader():void
		{
			rhFrame.rhOK=false;
			
			// Si demo
			rh4Demo=null;
			rhObjectList=null;
			rhOiList=null;
			rhDestroyList=null;
			rh4PSaveFilename=null;
			rh4CurrentFastLoop=null;
			//Cleaning FastLoops
			if(this.rh4FastLoops != null && !this.rh4FastLoops.isEmpty())
			{
				this.rh4FastLoops.clear();                    
				this.rh4FastLoops = null;
			}
			
			rh4BackDrawRoutines=null;
			
			// Vire les CValues
			var n:int;
			for (n=0; n<MAX_INTERMEDIATERESULTS; n++)
			{
				rh4Results[n]=null;
			}
			rh4OpeNull=null;
			
			System.gc();
		}
		
		public function initRunLoop(bFade:Boolean):void
		{
			allocRunHeader();
			
			if (bFade) 
				rhGameFlags|=GAMEFLAGS_FIRSTLOOPFADEIN;
			
			initAsmLoop();			
			
			y_InitLevel();
			
			prepareFrame();
			
			drawLevel();
			hideShowLayers();
			
			createFrameObjects(bFade);		
			
			loadGlobalObjectsData();
			
			rhEvtProg.prepareProgram();
			rhEvtProg.assemblePrograms(this);		
			
			captureMouse();
			rhQuitParam = 0;
			f_InitLoop();
			rhEvtProg.HandleKeyRepeat();
		}
		// Un tour de boucle
		public function doRunLoop():int
		{
			if (rh2PauseCompteur>0)
			{
				if (rhQuit==LOOPEXIT_PAUSEGAME)
				{
					if (rhApp.keyNew==true)
					{
						if (rh4PauseKey>=0)
						{
							if (rhApp.keyBuffer[rh4PauseKey]!=0)
							{
								resume();
								rhQuit=0;
							}
						}
						else
						{
							if (rhApp.keyNew)
							{
								resume();
								rhQuit=0;
							}
						}
					}
					rhApp.keyNew=false;	
				}
				// Gestion de l'objet Hiscore?
				// ---------------------------
				if (rhHiscore!=null)
				{
					rhHiscore.ext.handleRunObject();
					return 0;
				}
				// Gestion de l'objet Question?
				// ----------------------------
				if (questionObjectOn!=null)
				{
					if (questionObjectOn.handleQuestion()==false)
					{
						return 0;
					}
				}
				return 0;
			}
			
			// Appel du jeu
			rhApp.appRunFlags |= CRunApp.ARF_INGAMELOOP;
			var quit:int=f_GameLoop();
			rhApp.appRunFlags &= ~CRunApp.ARF_INGAMELOOP;
			
			
			// Appel des evenements systeme
			if (rhApp.sysEvents.size()>0)
			{
				var n:int;
				for (n=0; n<rhApp.sysEvents.size(); n++)
				{
					var sys:CSysEvent=CSysEvent(rhApp.sysEvents.get(n));
					if (sys!=null)		    
					{		
						sys.execute(this);
					}
				}
				rhApp.sysEvents.clear();
			}
			
			if ( quit != 0 ) 
			{
				var frame:int=0;
				switch (quit)
				{
					// Passe en pause
					case 5:		// LOOPEXIT_PAUSEGAME:
						pause();
						rhApp.keyNew=false;
						quit=0;
						break;
					
					// Redémarre la frame
					case 101:	// LOOPEXIT_RESTART:
						if (rhFrame.fade) 
							break;
						
						// Sortie du niveau preceddent
						f_StopSamples();
						killFrameObjects();
						y_KillLevel(false);
						resetFrameLayers(-1, false);
						rhEvtProg.unBranchPrograms();
						freeMouse();
						freeRunHeader();
						
						// Redemarre la frame
						rhFrame.leX = rhFrame.leLastScrlX = rh3DisplayX=0;
						rhFrame.leY = rhFrame.leLastScrlY = rh3DisplayY=0;
						rhApp.resetLayers();
						allocRunHeader();
						initAsmLoop(); 
						y_InitLevel();
						drawLevel();
						prepareFrame(); 
						createFrameObjects(false); 
						loadGlobalObjectsData();
						rhEvtProg.prepareProgram();
						rhEvtProg.assemblePrograms(this); 
						f_InitLoop();
						rhEvtProg.HandleKeyRepeat();
						captureMouse();
						quit=0;
						rhQuitParam = 0;
						break;
					
					case 100:	    // LOOPEXIT_QUIT:
					case -2:	    // LOOPEXIT_ENDGAME:
						rhEvtProg.handle_GlobalEvents(((-4<<16)|65533));	// CNDL_QUITAPPLICATION
						break;
					
				}
			}
			return quit;
		}
		// Sortie de la boucle
		public function killRunLoop(quit:int, bLeaveSamples:Boolean):int
		{
			var quitParam:int;
			
			// Filtre les codes internes
			if (quit>100)
			{ 
				quit=LOOPEXIT_ENDGAME;
			}
			quitParam = rhQuitParam;
			saveGlobalObjectsData();
			killFrameObjects();
			
			y_KillLevel(bLeaveSamples);
			rhEvtProg.unBranchPrograms();
			freeMouse();
			freeRunHeader();
			
			// Vire les layers
			resetFrameLayers(-1, true);
			
			return (CServices.MAKELONG(quit, quitParam));
		}
		public function y_InitLevel():void
		{
			resetFrameLayers(-1, false);
		}
		public function initAsmLoop():void
		{
			f_ObjMem_Init();
		}
		public function f_ObjMem_Init():void
		{
			var i:int;
			for (i=0; i<rhMaxObjects; i++)
			{
				rhObjectList[i]=null;
			}
		}
		// PREPARATION DE LA FRAME AU RUN
		public function prepareFrame():int
		{
			var oiPtr:COI;
			var ocPtr:CObjectCommon;
			var n:int,type:int;
			
			// Flags de RUN
			rhGameFlags|=GAMEFLAGS_LOADONCALL;
			rhGameFlags|=GAMEFLAGS_INITIALISING;				// Empeche les evenements...
			
			// Initialisation du programme
			rh2CreationCount=0;
			
			// Initialise la table OiList
			var loPtr:CLO;
			var count:int=0;
			
			// L'OIlist
			rhOiList=new Array(rhMaxOI);
			for (oiPtr=rhApp.OIList.getFirstOI(); oiPtr!=null; oiPtr=rhApp.OIList.getNextOI())
			{
				type=oiPtr.oiType;
				if ( type>=COI.OBJ_SPR )
				{
					rhOiList[count]=new CObjInfo();
					rhOiList[count].copyData(oiPtr);
					
					// Retrouve un HFII pour les objets TEXT ou QUESTIONS (PARAM_SYSCREATE)
					rhOiList[count].oilHFII=-1;
					if (type==COI.OBJ_TEXT || type==COI.OBJ_QUEST)
					{
						for (loPtr=rhFrame.LOList.first_LevObj(); loPtr!=null; loPtr=rhFrame.LOList.next_LevObj())
						{
							if (loPtr.loOiHandle==rhOiList[count].oilOi)
							{
								rhOiList[count].oilHFII=loPtr.loHandle;
								break;
							}
						}
					}
					count++;
					
					// Flag mouse used...
					ocPtr = CObjectCommon(oiPtr.oiOC);
					if ((ocPtr.ocOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)!=0 && ocPtr.ocMovements!=null) 
					{
						for (n=0; n<ocPtr.ocMovements.nMovements; n++)
						{
							var mvPtr:CMoveDef=ocPtr.ocMovements.moveList[n];
							if (mvPtr.mvType==CMoveDef.MVTYPE_MOUSE)
							{
								rhMouseUsed|=1<<(mvPtr.mvControl-1);
							}
						}
					}
				}
			}
			
			var i:int;
			for (i=0; i<rhFrame.nLayers; i++)
			{
				var layer:CLayer=rhFrame.layers[i];
				layer.nZOrderMax = 1;
			}
			return 0;
		}
		// POSITIONNE LA FRAME AU DEBUT
		public function createFrameObjects(fade:Boolean):void
		{
			var oiPtr:COI;
			var ocPtr:CObjectCommon;
			var type:int;
			var n:int;
			var creatFlags:int;
			var loPtr:CLO;
			
			for (n=0, loPtr=rhFrame.LOList.first_LevObj(); loPtr!=null; n++, loPtr=rhFrame.LOList.next_LevObj())
			{
				oiPtr=rhApp.OIList.getOIFromHandle(loPtr.loOiHandle);
				ocPtr = CObjectCommon(oiPtr.oiOC);
				type=oiPtr.oiType;
				
				creatFlags = COF_CREATEDATSTART;
				
				// Objet pas dans le bon mode || cree au milieu du jeu. SKIP
				if ( loPtr.loParentType!=CLO.PARENT_NONE) 
					continue;
				
				// Objet texte: marque comme non destructible
				if (type==COI.OBJ_TEXT) 
					creatFlags|=COF_FIRSTTEXT;
				
				// Objet iconise non texte . SKIP
				if ( (ocPtr.ocFlags2 & CObjectCommon.OCFLAGS2_VISIBLEATSTART) == 0 )
				{
					if ( type==COI.OBJ_QUEST ) 
						continue;
					creatFlags|=COF_HIDDEN;
				}
								
				
				// Creation de l'objet                
				if ((ocPtr.ocOEFlags&CObjectCommon.OEFLAG_DONTCREATEATSTART)==0)
				{
					f_CreateObject(loPtr.loHandle, loPtr.loOiHandle, INTBAD, INTBAD, -1, creatFlags, -1, -1);
				}
			}
			rhGameFlags&=~GAMEFLAGS_INITIALISING;
		}
		// DESTRUCTION DES OBJETS DE LA SCENE
		public function killFrameObjects():void
		{
			// Arrete tous les sprites, en mode FAST
			var n:int;
			var pHo:CObject=null;
			// Kill all the objects except for the Physics Engine objects
			for (n=0; n<rhMaxObjects && rhNObjects!=0; n++)
			{
				if ( rhObjectList[n]!=null )
				{
					pHo=rhObjectList[n];
					if ( pHo.hoType<32 || pHo.hoCommon.ocIdentifier!=CRun.BASEIDENTIFIER )
						f_KillObject(n, true);
				}
			} 
			
			// Kill the Physics Engine objects
			for (n=0; n<rhMaxObjects && rhNObjects!=0; n++)
			{
				if ( rhObjectList[n]!=null )
				{
					pHo=rhObjectList[n];
					if ( pHo.hoType>=32 && pHo.hoCommon.ocIdentifier==CRun.BASEIDENTIFIER )
						f_KillObject(n, true);
				}
			}
		}
		// End frame
		public function y_KillLevel (bLeaveSamples:Boolean):void
		{
			// ++v1.03.35: stop sounds only if not GANF_SAMPLESOVERFRAMES
			if (!bLeaveSamples)
			{
				if ( (rhApp.gaNewFlags & CRunApp.GANF_SAMPLESOVERFRAMES) == 0 )
				{
					rhApp.soundPlayer.stopAllSounds();
				}
				else
				{
					rhApp.soundPlayer.keepCurrentSounds();
				}
			}
		}
		public function resetFrameLayers(nLayer:int, bDeleteFrame:Boolean):void
		{
			var i:int, nLayers:int;
			
			if ( nLayer == -1 )
			{
				i = 0;
				nLayers = rhFrame.nLayers;
			}
			else
			{
				i = nLayer;
				nLayers = (nLayer+1);
			}
			
			for (i=0; i<nLayers; i++)
			{
				var pLayer:CLayer=rhFrame.layers[i];
				
				// RAZ des layers
				pLayer.reset();
				pLayer.deleteBackObjects();
				if (bDeleteFrame)
				{
					pLayer.deletePlanes();
				}
			}
		}
		
		// ----------------------------------------------------------------------
		// SOURIS 
		// ----------------------------------------------------------------------
		public function captureMouse():void
		{
			if (rhMouseUsed!=0)
			{
				setCursorCount(-1);
			}
		}
		public function freeMouse():void
		{
			if (rhMouseUsed!=0)
			{
				setCursorCount(0);
			}
		}
		public function setCursorCount(count:int):void
		{
			if (count>=0)
				rhApp.showCursor(1);
			else
				rhApp.showCursor(-1);		
		}
		public function showMouse():void
		{
			rhApp.showCursor(1);
		}
		public function hideMouse():void
		{
			rhApp.showCursor(-1);
		}
		
		// -------------------------------------------------------------------------------
		// SAUVEGARDE / RESTAURATION DES OBJETS GLOBAUX
		// -------------------------------------------------------------------------------
		public function saveGlobalObjectsData():void
		{
			var hoPtr:CObject;
			var oilPtr:CObjInfo;	
			var oil:int, obj:int;
			var oiPtr:COI;
			var name:String;
			var o:int;
			
			for (oil=0; oil<rhOiList.length; oil++)
			{
				oilPtr=rhOiList[oil];
				
				// Un objet defini?
				o=oilPtr.oilObject;
				if ( oilPtr.oilOi!=0x7FFF && o>=0 )
				{
					oiPtr=rhApp.OIList.getOIFromHandle(oilPtr.oilOi);
					
					// Un objet global?
					if ((oiPtr.oiFlags&COI.OIF_GLOBAL)!=0)
					{
						hoPtr=rhObjectList[o];
						
						// Un objet sauvable?
						if (oilPtr.oilType!=COI.OBJ_TEXT && oilPtr.oilType!=COI.OBJ_COUNTER && hoPtr.rov==null)
							continue;
						
						// Recherche un element deja defini
						name=oilPtr.oilName+oilPtr.oilType.toString();
						
						if (rhApp.adGO==null)
						{
							rhApp.adGO=new CArrayList();
						}
						
						// Rechercher l'objet dans les objets déjà créés
						var flag:Boolean = false;
						var save:CSaveGlobal=null;
						for (obj=0; obj<rhApp.adGO.size(); obj++)
						{
							save=CSaveGlobal(rhApp.adGO.get(obj));
							if (name==save.name)
							{
								flag=true;
								break;
							}
						}
						if (flag==false)
						{
							save=new CSaveGlobal();
							save.name=name;
							save.objects=new CArrayList();
							rhApp.adGO.add(save);
						}
						else
						{
							save.objects.clear();
						}
						
						// Stockage des valeurs...
						var n:int;
						while(true)
						{
							hoPtr=rhObjectList[o];
							
							// Stocke
							if ( oilPtr.oilType == COI.OBJ_TEXT )
							{
								var text:CText=CText(hoPtr);
								var saveText:CSaveGlobalText=new CSaveGlobalText();
								saveText.text=text.rsTextBuffer;
								saveText.rsMini=text.rsMini;
								save.objects.add(saveText);
							}
							else if ( oilPtr.oilType==COI.OBJ_COUNTER )
							{
								var counter:CCounter=CCounter(hoPtr);
								var saveCounter:CSaveGlobalCounter=new CSaveGlobalCounter();
								saveCounter.value=new CValue(0);
								saveCounter.value.forceValue(counter.rsValue);
								saveCounter.rsMini=counter.rsMini;
								saveCounter.rsMaxi=counter.rsMaxi;
								saveCounter.rsMiniDouble=counter.rsMiniDouble;
								saveCounter.rsMaxiDouble=counter.rsMaxiDouble;
								save.objects.add(saveCounter);
							}
							else
							{
								var saveValues:CSaveGlobalValues=new CSaveGlobalValues();
								saveValues.flags=hoPtr.rov.rvValueFlags;
								saveValues.values=new Array(CRVal.VALUES_NUMBEROF_ALTERABLE);
								for (n=0; n<CRVal.VALUES_NUMBEROF_ALTERABLE; n++)
								{
									saveValues.values[n]=null;
									if (hoPtr.rov.rvValues[n]!=null)
									{
										saveValues.values[n]=new CValue(0);
										saveValues.values[n].forceValue(hoPtr.rov.rvValues[n]);
									}
								}
								saveValues.strings=new Array(CRVal.STRINGS_NUMBEROF_ALTERABLE);
								for (n=0; n<CRVal.STRINGS_NUMBEROF_ALTERABLE; n++)
								{
									saveValues.strings[n]=null;
									if (hoPtr.rov.rvStrings[n]!=null)
									{
										saveValues.strings[n]=new String(hoPtr.rov.rvStrings[n]);
									}
								}
								save.objects.add(saveValues);
							}
							
							// Un autre objet?
							o=hoPtr.hoNumNext;
							if ( (o&0x80000000)!=0 ) 
								break;
						}
					}
				}
			}
		}
		
		public function loadGlobalObjectsData():void
		{
			var hoPtr:CObject;
			var oilPtr:CObjInfo;	
			var oil:int, obj:int;
			var oiPtr:COI;
			var name:String;
			var o:int;
			
			if (rhApp.adGO==null) 
				return;
			
			for (oil=0; oil<rhOiList.length; oil++)
			{
				oilPtr=rhOiList[oil];
				
				// Un objet defini?
				o=oilPtr.oilObject;
				if ( oilPtr.oilOi!=0x7FFF && o>=0 )
				{
					oiPtr=rhApp.OIList.getOIFromHandle(oilPtr.oilOi);
					
					// Un objet global?
					if ((oiPtr.oiFlags&COI.OIF_GLOBAL)!=0)
					{
						name=oilPtr.oilName+oilPtr.oilType.toString();
						
						// Recherche dans les headers
						for (obj=0; obj<rhApp.adGO.size(); obj++)
						{
							var save:CSaveGlobal=CSaveGlobal(rhApp.adGO.get(obj));
							if (name==save.name)
							{
								var count:int=0;
								while(true)
								{
									hoPtr=rhObjectList[o];
									
									if (oilPtr.oilType==COI.OBJ_TEXT)
									{
										var saveText:CSaveGlobalText=CSaveGlobalText(save.objects.get(count));
										var text:CText=CText(hoPtr);
										text.rsTextBuffer=saveText.text;
										text.rsMini=saveText.rsMini;
										text.roc.rcChanged=true;
										text.bTxtChanged=true;
									}
									else if ( oilPtr.oilType == COI.OBJ_COUNTER )
									{
										var saveCounter:CSaveGlobalCounter=CSaveGlobalCounter(save.objects.get(count));
										var counter:CCounter=CCounter(hoPtr);
										counter.rsValue=new CValue(0);
										counter.rsValue.forceValue(saveCounter.value);
										counter.rsMini=saveCounter.rsMini;
										counter.rsMaxi=saveCounter.rsMaxi;
										counter.rsMiniDouble=saveCounter.rsMiniDouble;
										counter.rsMaxiDouble=saveCounter.rsMaxiDouble;
										counter.bCounterChanged=true;
										counter.roc.rcChanged=true;
									}
									else
									{
										var saveValues:CSaveGlobalValues=CSaveGlobalValues(save.objects.get(count));
										hoPtr.rov.rvValueFlags=saveValues.flags;
										var n:int;
										for (n=0; n<CRVal.VALUES_NUMBEROF_ALTERABLE; n++)
										{
											if (saveValues.values[n]!=null)
											{
												hoPtr.rov.rvValues[n]=new CValue(0);
												hoPtr.rov.rvValues[n].forceValue(saveValues.values[n]);
											}
										}
										for (n=0; n<CRVal.STRINGS_NUMBEROF_ALTERABLE; n++)
										{
											if (saveValues.strings[n]!=null)
											{
												hoPtr.rov.rvStrings[n]=new String(saveValues.strings[n]);
											}
										}
									}
									
									// Un autre objet?
									o=hoPtr.hoNumNext;
									if ( (o&0x80000000)!=0 ) 
										break;
									
									// Regarde si il existe un suivant...
									count++;
									if ( count>=save.objects.size() )
										break;
								}
								break;
							}
						}
					}
				}
			}	
		}
		
		
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////
		//
		// GAMEF.CPP
		//    
		public function f_CreateObject(hlo:int, oi:int, coordX:int, coordY:int, initDir:int, flags:int, nLayer:int, numCreation:int):int
		{
			while(true)
			{
				var cob:CCreateObjectInfo=new CCreateObjectInfo();	
				
				// Trouve l'adresse du LO	
				// ~~~~~~~~~~~~~~~~~~~~~~~~~
				var loPtr:CLO=null;
				if (hlo!=-1)
				{
					loPtr=rhFrame.LOList.getLOFromHandle(hlo);
				}
				
				// Trouve l'adresse du HFRAN
				// ~~~~~~~~~~~~~~~~~~~~~~~~~
				var oiPtr:COI=rhApp.OIList.getOIFromHandle(oi);
				var ocPtr:CObjectCommon=CObjectCommon(oiPtr.oiOC);
				
				// Flag visible at start
				// --------------------
				if ((ocPtr.ocFlags2 & CObjectCommon.OCFLAGS2_VISIBLEATSTART)==0)
				{
					flags|=COF_HIDDEN;
				}
				
				// Pas trop d'objets?
				// ~~~~~~~~~~~~~~~~~~
				if (rhNObjects >= rhMaxObjects) 
					break;
				
				// Cree l'objet
				var hoPtr:CObject=null;
				switch (oiPtr.oiType)
				{
					case 2:         // OBJ_SPR
						hoPtr=new CActive();
						break;
					case 3:         // OBJ_TEXT
						hoPtr=new CText();
						break;
					case 4:         // OBJ_QUEST
						hoPtr=new CQuestion();
						break;
					case 5:         // OBJ_SCORE
						hoPtr=new CScore();
						break;
					case 6:         // OBJ_LIVES
						hoPtr=new CLives();
						break;
					case 7:         // OBJ_COUNTER
						hoPtr=new CCounter();
						break;
					case 8:         // OBJ_RTF
						//	                    hoPtr=new CRtf();
						break;
					case 9:         // OBJ_CCA
						hoPtr=new CCCA();
						break;
					default:        // Extensions
						hoPtr=new CExtension(oiPtr.oiType, this);
						if (CExtension(hoPtr).ext==null)
						{
							hoPtr=null;
						}
						break;
				}
				if (hoPtr==null)
					break;
				
				// Insere l'objet dans la liste
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if (numCreation<0)
				{
					for (numCreation=0; numCreation<rhMaxObjects; numCreation++)
					{
						if (rhObjectList[numCreation]==null)
						{
							break;
						}
					}
				}
				if (numCreation>=rhMaxObjects)
					return -1;
				
				rhObjectList[numCreation]=hoPtr;
				rhNObjects++;
				hoPtr.hoIdentifier=ocPtr.ocIdentifier;			//; L'identifier ASCII de l'objet
				hoPtr.hoOEFlags=ocPtr.ocOEFlags;
				
				// Gestion de la boucle principale
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if (numCreation>rh4ObjectCurCreate)				// Si objet DEVANT l'objet courant
				{
					rh4ObjectAddCreate++;					// Il faut explorer encore!
				}
				
				// Rempli la structure headerObject
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				hoPtr.hoNumber=numCreation;					  			//; Numero de l'objet
				rh2CreationCount++;
				if (rh2CreationCount==0)					// V243 protection tour de compteur
					rh2CreationCount=1;
				
				hoPtr.hoCreationId=rh2CreationCount;		// Numero de creation!
				hoPtr.hoOi=oi;										//; L'OI
				hoPtr.hoHFII=hlo;									//; le HLO
				hoPtr.hoType=oiPtr.oiType;					//; Le type de l'objet
				oi_Insert(hoPtr);									//; Branche dans la liste
				hoPtr.hoAdRunHeader=this;							//; L'adresse de rhPtr
				hoPtr.hoCallRoutine=true;
				
				// Adresse de l'objectsCommon
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~
				hoPtr.hoCommon=ocPtr;
				
				// Rempli la structure CreateObjectInfo (virer X et Y)
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				var x:int=coordX;									// X
				if (x==INTBAD) 
					x=loPtr.loX;
				cob.cobX=x;
				hoPtr.hoX=x;
				
				var y:int=coordY;									// Y
				if (y==INTBAD) 
					y=loPtr.loY;
				cob.cobY=y;
				hoPtr.hoY=y;
				
				// Set layer
				if ( loPtr != null )
				{
					if ( nLayer == -1 )
					{
						nLayer = loPtr.loLayer;
					}
				}
				else
				{
					nLayer = 0;
				}
				cob.cobLayer = nLayer;
				hoPtr.hoLayer = nLayer;
				
				// Set z-order value
				var pLayer:CLayer = rhFrame.layers[nLayer];
				pLayer.nZOrderMax++;
				cob.cobZOrder = pLayer.nZOrderMax;
				
				cob.cobFlags=flags;								//; Flags creation
				cob.cobDir=initDir;								//; Direction initiale
				cob.cobLevObj=loPtr;							//; Huge levobj

				// --------------------------------------------
				// Gestion des Animations / Mouvements / Values
				// --------------------------------------------
				
				// Debut des structures facultatives	
				hoPtr.roc=null;                
				if ((hoPtr.hoOEFlags&(CObjectCommon.OEFLAG_ANIMATIONS|CObjectCommon.OEFLAG_MOVEMENTS|CObjectCommon.OEFLAG_SPRITES))!=0)
				{
					hoPtr.roc=new CRCom();
					hoPtr.roc.init();
				}
				
				// Appel des routines d'initialisation Movements
				// ---------------------------------------------
				hoPtr.rom=null;
				if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)!=0)
				{
					hoPtr.rom=new CRMvt();
					if ((cob.cobFlags&COF_NOMOVEMENT)==0)
					{
						hoPtr.rom.init(0, hoPtr, ocPtr, cob, -1);
					}
				}
				
				// Appel des routines d'initialisation Animation
				// ---------------------------------------------
				hoPtr.roa=null;
				if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
				{
					hoPtr.roa=new CRAni();
					hoPtr.roa.init(hoPtr);
				}
				
				// Appel des routines d'initialisation sprite 1
				// ---------------------------------------------
				hoPtr.ros=null;
				if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_SPRITES)!=0)
				{
					hoPtr.ros=new CRSpr();
					hoPtr.ros.init1(hoPtr, ocPtr, cob);
				}
				
				// Appel des routines d'initialisation Values
				// ---------------------------------------------
				hoPtr.rov=null;
				if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_VALUES)!=0)
				{
					hoPtr.rov=new CRVal();
					hoPtr.rov.init(hoPtr, ocPtr, cob);
				}
				
				// -----------------------------------------------
				// Appel de la routine d'initialisation standard
				// -----------------------------------------------
				hoPtr.init(ocPtr, cob);
				
				// Appel des routines d'initialisation sprite 2
				// ---------------------------------------------
				if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_SPRITES)!=0)
				{
					hoPtr.ros.init2(false);
				}
				
				// Sortie sans erreur
				return numCreation;									// Retourne avec EAX=NOBJECT
			}
			return -1;
		}
		
		// --------------------------------------------------------------------------
		// --------------------------------------------------------------------------
		// DESTRUCTION D'UN OBJET
		// --------------------------------------------------------------------------
		// --------------------------------------------------------------------------
		public function f_KillObject(nObject:int, bFast:Boolean):void
		{
			// Pointe l'objet
			// ~~~~~~~~~~~~~~
			var hoPtr:CObject=rhObjectList[nObject];
			if (hoPtr==null)
				return;
			
			// V243 Si sprite a moitie effacé
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (bFast==true && hoPtr.hoCreationId==0)
			{
				rhObjectList[nObject]=null;
				rhNObjects--;
				return;
			}
			
			// Vire les pointeurs dans les routines SHOOT
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			killShootPtr(hoPtr);
			
			// Detruit les mouvements, les values
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (hoPtr.rom!=null)
				hoPtr.rom.kill(bFast);
			if (hoPtr.rov!=null)
				hoPtr.rov.kill(bFast);
			if (hoPtr.ros!=null)
				hoPtr.ros.kill(bFast);
			if (hoPtr.roc!=null)
				hoPtr.roc.kill(bFast);
			
			// Appelle la routine de destruction specifique
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			hoPtr.kill(bFast);
			
			// Enleve le OI (pas en mode panique!)
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			oi_Delete(hoPtr);
			
			hoPtr.hoCreationId = 0;
			rhObjectList[nObject]=null;
			
			// Ajout Yves Build 242
			rhNObjects--;
			
			// Efface les appels aux routines d'affichage
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			hoPtr.hoCallRoutine = false;
		}
		
		// ---------------------------------------------------------------------------
		// ---------------------------------------------------------------------------
		// GESTION DE LA LISTE DE DESTROY
		// ---------------------------------------------------------------------------
		// ---------------------------------------------------------------------------
		
		// Additionne un objet a la liste de destroy
		// ------------------------------------------
		public function destroy_Add(hoNumber:int):void
		{
			var pos:int=hoNumber/32;
			var bit:int=1<<(hoNumber&31);
			rhDestroyList[pos]|=bit;
			rhDestroyPos++;
		}
		
		// Detruit tous les sprites de la liste
		// ------------------------------------
		public function destroy_List():void
		{
			if ( rhDestroyPos == 0 ) 
				return;
			
			var nob:int=0;
			var dw:int;
			var count:int;
			while(nob<rhMaxObjects)
			{
				dw=rhDestroyList[nob/32];
				if (dw!=0)
				{
					for (count=0; dw!=0 && count<32; count++)
					{
						if ((dw&1)!=0)
						{
							// Appeler le message NO MORE OBJECT juste avant la destruction (si objet sprite!)
							var pHo:CObject = rhObjectList[nob+count];
							if ( pHo != null )
							{
								if ( pHo.hoOiList.oilNObjects == 1 )
								{
									rhEvtProg.handle_Event(pHo, (pHo.hoType | (-33<<16)));	    // CNDL_EXTNOMOREOBJECT
								}
							}
							// Detruit l'objet!
							f_KillObject(nob+count, false);
							rhDestroyPos--;
						}
						dw=dw>>1;
					}
					rhDestroyList[nob/32]=0;
					if (rhDestroyPos==0)
					{
						return;
					}
				}
				nob+=32;
			}
		}
		
		// Detruit les references aux objets shoot
		// ---------------------------------------
		public function killShootPtr(hoSource:CObject):void
		{
			var count:int=0;
			var nObject:int;
			var hoPtr:CObject;	
			for (nObject=0; nObject<rhNObjects; nObject++)
			{
				while(rhObjectList[count]==null)
					count++;
				hoPtr=rhObjectList[count];
				count++;
				
				if (hoPtr.rom!=null)
				{
					if (hoPtr.roc.rcMovementType==CMoveDef.MVTYPE_BULLET)
					{
						var mBullet:CMoveBullet=CMoveBullet(hoPtr.rom.rmMovement);
						if (mBullet.MBul_ShootObject==hoSource && mBullet.MBul_Wait==true)
						{
							mBullet.startBullet();
						}
					}
				}
			}
		}
		
		// Insere l'objet [esi] dans les liste d'OI
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		public function oi_Insert (pHo:CObject):void
		{
			var oi:int = pHo.hoOi;
			
			var num:int;
			for (num=0; num<rhMaxOI; num++)
			{
				if (rhOiList[num].oilOi==oi)
				{
					break;
				}
			}
			var poil:CObjInfo=rhOiList[num];
			
			if ( (poil.oilObject & 0x80000000) != 0 )
			{
				// N'existe pas avant
				poil.oilObject = pHo.hoNumber;
				pHo.hoNumPrev = (num | 0x80000000);
				pHo.hoNumNext = 0x80000000;
			}
			else
			{
				// Existe avant: insere en tete de liste
				var pHo2:CObject = rhObjectList[poil.oilObject];
				pHo.hoNumPrev = pHo2.hoNumPrev;
				pHo2.hoNumPrev = pHo.hoNumber;
				pHo.hoNumNext = pHo2.hoNumber;
				poil.oilObject = pHo.hoNumber;
			}
			
			// Prend les donnees contenues dans oiList
			pHo.hoEvents = poil.oilEvents;					// Les evenements
			pHo.hoOiList = poil;							// L'adresse dans la liste OiList
			pHo.hoLimitFlags = poil.oilLimitFlags;
			if ( pHo.hoHFII == -1 )					// Si le HFII est mauvais, met le premier disponible
				pHo.hoHFII = poil.oilHFII;
			else
			{
				if ( poil.oilHFII == -1 )
					poil.oilHFII = pHo.hoHFII;	
			}
			poil.oilNObjects += 1;						// Un objet de plus de meme OI
		}	
		
		// Delete un OI retourne le numero de l'objet suivant en AX
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		public function oi_Delete(pHo:CObject):void
		{
			// Decremente dans la liste des OI
			var poil:CObjInfo = pHo.hoOiList;
			poil.oilNObjects -= 1;
			
			// Gere les precedents/suivants
			var pHo2:CObject;
			if ( pHo.hoNumPrev >= 0 )
			{
				pHo2= rhObjectList[pHo.hoNumPrev];
				if ( pHo.hoNumNext >= 0 )
				{
					// Au milieu
					var pHo3:CObject = rhObjectList[pHo.hoNumNext];
					if ( pHo2 != null )
						pHo2.hoNumNext = pHo.hoNumNext;
					if ( pHo3 != null )
						pHo3.hoNumPrev = pHo.hoNumPrev;
				}
				else
				{
					if ( pHo2 != null )
						pHo2.hoNumNext = 0x80000000;
				}
			}
			else
			{
				// Au debut de la liste
				if ( pHo.hoNumNext >= 0 )
				{
					pHo2= rhObjectList[pHo.hoNumNext];
					if ( pHo2 != null )
					{
						pHo2.hoNumPrev = pHo.hoNumPrev;
						poil.oilObject = pHo2.hoNumber;
					}
				}
					// Plus rien dans la liste!
				else
				{
					poil.oilObject = 0x80000000;
				}
			}
		}
		
		public function pause():void
		{
			// Le compteur de sauvegarde
			// ~~~~~~~~~~~~~~~~~~~~~~~~~
			if (rh2PauseCompteur==0)
			{
				rh2PauseCompteur=1;
				
				// Sauve le timer
				// ~~~~~~~~~~~~~~
				rh2PauseTimer=getTimer();
				
				// Arret de tous les objets
				// ~~~~~~~~~~~~~~~~~~~~~~~~                
				var count:int=0;
				var no:int;
				for (no=0; no<rhNObjects; no++)
				{
					while (rhObjectList[count]==null)
						count++;
					var hoPtr:CObject=rhObjectList[count];
					count++;
					if (hoPtr.hoType>=COI.KPX_BASE)
					{
						var e:CExtension=CExtension(hoPtr);
						e.ext.pauseRunObject();
					}
				}
				
				// Arret des musiques et des sons
				// ------------------------------
				rhApp.soundPlayer.pause();
				
				// Remet la souris
				// ---------------
				Mouse.show();
				
				rhApp.keyNew=false;
			}
		}
		
		public function resume():void
		{
			// Uniquement au dernier retour
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (rh2PauseCompteur!=0)
			{
				rh2PauseCompteur=0;
				
				// Cache la souris
				// ---------------
				captureMouse();
				
				// Remet tous les objets
				// ~~~~~~~~~~~~~~~~~~~~~
				var count:int=0;
				var no:int;
				for (no=0; no<rhNObjects; no++)
				{
					while (rhObjectList[count]==null)
						count++;
					var hoPtr:CObject=rhObjectList[count];
					count++;
					if (hoPtr.hoType>=COI.KPX_BASE)
					{
						var e:CExtension=CExtension(hoPtr);
						e.ext.continueRunObject();
					}
				}
				
				// Remet les musiques et les sons
				// ------------------------------
				rhApp.soundPlayer.resume();
				
				// Nettoie le clavier
				// ------------------
				rhApp.flushKeyboard();
				
				// Remet le timer
				// ~~~~~~~~~~~~~~
				var tick:int=getTimer();
				tick-=rh2PauseTimer;
				rhTimerOld+=tick;	
				rh4PauseKey=0;
				
				// Condition end of pause
				rhEvtProg.handle_GlobalEvents((-8<<16)|0xFFFD);		// CNDL_ONMOUSEHWEELDOWN						
				
			}
		}
		
		// --------------------------------------------------------------------
		// ARRET DE LA MUSIQUE ET DES SONS
		// --------------------------------------------------------------------
		public function f_StopSamples():void
		{
			//FRANCOIS:			rhApp.soundPlayer.stopAllSounds();
		}
		
		// -----------------------------------------------------------------------
		// Envoie les evenements aux sous applications
		// -----------------------------------------------------------------------
		public function sendKey(keyCode:int, bState:Boolean):void
		{
			var count:int=0;
			var no:int;
			for (no=0; no<rhNObjects; no++)
			{
				while (rhObjectList[count]==null)
					count++;
				var hoPtr:CObject=rhObjectList[count];
				count++;
				if (hoPtr is CCCA)
				{
					var cca:CCCA=CCCA(hoPtr);
					cca.sendKey(keyCode, bState);
				}
			}	
		}
		
		// -----------------------------------------------------------------------
		// Scale une coordonnÃ¯Â¿Â½Ã¯Â¿Â½Ã¯Â¿Â½e en fonction du strech de l'ecran
		// -----------------------------------------------------------------------
		
		public function scaleX(x:int):int
		{
			return x;
		}
		
		public function scaleY(y:int):int
		{
			return y;
		}
		
		
		// -----------------------------------------------------------------------
		// TROUVE LE HO
		// -----------------------------------------------------------------------
		public function find_HeaderObject(hlo:int):CObject
		{
			var count:int=0;
			var nObjects:int;
			for (nObjects=0; nObjects<rhNObjects; nObjects++)
			{
				while(rhObjectList[count]==null)
					count++;
				if (hlo==rhObjectList[count].hoHFII)
					return rhObjectList[count];
				count++;	
			}
			return null;
		}
		
		public function updateFrameDimensions(width:int, height:int):void
		{
			if (width>0)
			{
				rhLevelSx=width;
				rh3WindowSx=width;
				rh3XMaximumKill = rhLevelSx + GAME_XBORDER;
				
				var wx:int = rhWindowX;			// Maximum gestion droite
				wx += rh3WindowSx + COLMASK_XMARGIN;
				if (wx > rhLevelSx)
				{
					wx = rh3XMaximumKill;
				}
				rh3XMaximum = wx;
			}
			if (height>0)
			{
				rhLevelSy=height;
				rh3WindowSy = height;
				rh3YMaximumKill = rhLevelSy + GAME_YBORDER;
				
				var wy:int = rhWindowY;			// Maximum gestion bas
				wy += rh3WindowSy + COLMASK_YMARGIN;
				if (wy > rhLevelSy)
				{
					wy = rh3YMaximumKill;
				}
				rh3YMaximum = wy;
			}
		}
		
		// -----------------------------------------------------------------------
		// SCROLLING DU TERRAIN, UPDATE LES POSITIONS
		// -----------------------------------------------------------------------
		public function f_UpdateWindowPos(newX:int, newY:int):void
		{
			var pLayer:CLayer;
			
			// Change le pointeurs dans le segment de base
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			// Deltas pour le C
			var noMove:int=0;
			rh4WindowDeltaX=newX-rhWindowX;
			if (rh4WindowDeltaX!=0)
				noMove++;
			rh4WindowDeltaY=newY-rhWindowY;
			if (rh4WindowDeltaY!=0)
				noMove++;
			
			// Scan layers and check if dx/dy != 0
			if ( noMove == 0 )
			{
				var i:int;
				for (i=0; i<rhFrame.nLayers; i++)
				{
					pLayer= rhFrame.layers[i];
					if ( pLayer.dx != 0 || pLayer.dy != 0 )
					{ 
						noMove++; 
						break; 
					}
				}
			}
			
			// Store variables for faster access in object loop
			var nOldX:int = rhWindowX;
			var nOldY:int = rhWindowY;
			var nNewX:int = newX;
			var nNewY:int = newY;
			var nDeltaX:int = rh4WindowDeltaX;
			var nDeltaY:int = rh4WindowDeltaY;
			
			// Coordonnees limites de gestion
			rhWindowX = newX;									// Minimum gestion droite
			rh3XMinimum = newX - COLMASK_XMARGIN;
			if ( rh3XMinimum < 0 )
				rh3XMinimum = rh3XMinimumKill;
			
			rhWindowY = newY;									// Minimum gestion haut
			rh3YMinimum = newY - COLMASK_YMARGIN;
			if ( rh3YMinimum < 0 )
				rh3YMinimum = rh3YMinimumKill;
			
			rh3XMaximum = newX + rh3WindowSx + COLMASK_XMARGIN;	// Maximum gestion droite
			if ( rh3XMaximum > rhLevelSx )
				rh3XMaximum = rh3XMaximumKill;
			
			rh3YMaximum = newY + rh3WindowSy + COLMASK_YMARGIN;	// Maximum gestion bas
			if ( rh3YMaximum > rhLevelSy )
				rh3YMaximum = rh3YMaximumKill;
			
			
			// Reaffiche tous les objets du terrain en changeant eventuellement leurs coordonnees
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var count:int=0;
			var nObjects:int
			for (nObjects=0; nObjects<rhNObjects; nObjects++)
			{
				while(rhObjectList[count]==null)
					count++;
				var pHo:CObject=rhObjectList[count];
				count++;
				
				if (noMove!=0)
				{
					if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_SCROLLINGINDEPENDANT)!=0)
					{
						var x:int=nDeltaX;
						var y:int=nDeltaY;
						
						if (pHo.rom==null)
						{
							pHo.hoX+=x;
							pHo.hoY+=y;
						}
						else
						{
							x+=pHo.hoX;
							y+=pHo.hoY;
							pHo.rom.rmMovement.setXPosition(x);
							pHo.rom.rmMovement.setYPosition(y);
						}
					}
					else
					{
						var nLayer:int = pHo.hoLayer;
						if ( nLayer < rhFrame.nLayers )
						{
							var oldLayerDx:int = nOldX;
							var oldLayerDy:int = nOldY;
							var newLayerDx:int = nNewX;
							var newLayerDy:int = nNewY;
							
							pLayer=rhFrame.layers[nLayer];
							if ( (pLayer.dwOptions & CLayer.FLOPT_XCOEF) != 0 )
							{
								oldLayerDx = pLayer.xCoef * oldLayerDx;
								newLayerDx = pLayer.xCoef * newLayerDx;
							}
							if ( (pLayer.dwOptions & CLayer.FLOPT_YCOEF) != 0 )
							{
								oldLayerDy = pLayer.yCoef * oldLayerDy;
								newLayerDy = pLayer.yCoef * newLayerDy;
							}
							
							// Equivalent
							var nX:int = (pHo.hoX + oldLayerDx) - newLayerDx + nDeltaX - pLayer.dx;
							var nY:int = (pHo.hoY + oldLayerDy) - newLayerDy + nDeltaY - pLayer.dy;
							
							if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)==0)
							{
								pHo.hoX = nX;
								pHo.hoY = nY;
							}
							else
							{
								pHo.rom.rmMovement.setXPosition(nX);
								pHo.rom.rmMovement.setYPosition(nY);
							}
						}
					}
					pHo.modif();
				}
				else
				{
					pHo.modif();
				}
			}		
		}
		
		
		// -------------------------------------------------------------------------
		// GESTION DES ECHELLES
		// -------------------------------------------------------------------------	
		public function y_GetLadderAt(nLayer:int, x:int, y:int):CRect
		{
			x-=rhWindowX;
			y-=rhWindowY;
			
			var nl:int;
			var nLayers:int;
			if ( nLayer == -1 )
			{
				nl = 0;
				nLayers = rhFrame.nLayers;
			}
			else
			{
				nl = nLayer;
				nLayers = (nLayer+1);
			}
			for (; nl<nLayers; nl++)
			{
				var pLayer:CLayer=rhFrame.layers[nl];
				var rc:CRect=pLayer.getLadderAt(x, y);
				if (rc!=null)
				{
					return rc;			    	
				}
			}
			return null;
		}
		
		// --------------------------------------------------------------------------------
		//
		// MAIN LOOP
		//
		// --------------------------------------------------------------------------------
		public function f_InitLoop():void
		{
			var tick:int=getTimer();
			rhTimerOld=tick;
			rhTimer=0;
			
			rhLoopCount=0;
			rh4LoopTheoric=0;
			//	rh2PushedEvents=0;
			
			rhQuit=0;						// On ne sort pas!
			rhQuitBis=0;
			rhDestroyPos=0;				// Destroy list
			
			var n:int;
			for (n=0; n<(rhMaxObjects+31)/32; n++)		// Yves: ajout du +31: il faut aussi modifier la routine d'allocation
				rhDestroyList[n]=0;
			
			// Taille de la fenetre
			rh3WindowSx=rhFrame.leEditWinWidth;
			rh3WindowSy=rhFrame.leEditWinHeight;
			
			// Position de KILL des objets loin du terrain
			rh3XMinimumKill=-GAME_XBORDER;		// Les bordures externes
			rh3YMinimumKill=-GAME_YBORDER;
			rh3XMaximumKill=rhLevelSx+GAME_XBORDER;
			rh3YMaximumKill=rhLevelSy+GAME_YBORDER;
			
			// Coordonnees limites de gestion
			var dx:int=rhWindowX;
			rh3DisplayX=dx;				// Minimum gestion gauche
			dx-=COLMASK_XMARGIN;
			if (dx<0)
				dx=rh3XMinimumKill;
			rh3XMinimum=dx;
			
			var dy:int=rhWindowY;			// Minimum gestion haute
			rh3DisplayY=dy;
			dy-=COLMASK_YMARGIN;
			if (dy<0)
				dy=rh3YMinimumKill;
			rh3YMinimum=dy;
			
			var wx:int=rhWindowX;			// Maximum gestion droite
			wx+=rh3WindowSx+COLMASK_XMARGIN;
			if (wx>rhLevelSx)
				wx=rh3XMaximumKill;
			rh3XMaximum=wx;
			
			var wy:int=rhWindowY;			// Maximum gestion bas
			wy+=rh3WindowSy+COLMASK_YMARGIN;
			if (wy>rhLevelSy)
				wy=rh3YMaximumKill;
			rh3YMaximum=wy;
			
			// Inits diverses	
			rh3Scrolling=0;				// Pas de scrolling
			rh4DoUpdate=0;				// Premier tour de jeu non affiche...
			rh4EventCount=0;			// Compteur pour les evenements
			rh4TimeOut=0;				// Time Out a zero
			
			// Init compteur de sauvegarde des PAUSES
			rh2PauseCompteur=0;
			
			// Toutes les entrees sont selectionnees
			rh4FakeKey=0;
			for (n=0; n<4; n++)
			{
				rhPlayer[n]=0;
				rh2OldPlayer[n]=0;
				rh2InputMask[n]=0xFF;
			}
			rh2MouseKeys=0;
			
			// RAZ flags actions
			rhEvtProg.rh2ActionEndRoutine=false;
			rh4OnCloseCount=-1;
			rh4EndOfPause=-1;
			rh4OnMouseWheel=-1;
			rh4LoadCount=-1;
			rhEvtProg.rh4CheckDoneInstart=false;
			rh4PauseKey=0;
			bodiesCreated = false;
			rh4Box2DSearched = false;
			rh4Box2DBase = null;
			rh4TimerEvents=null;
			
			// Pas de demo
			rh4DemoMode=CDemoRecord.DEMONOTHING;
			rh4Demo=null;
			
			// RAZ du buffer de calcul du framerate
			for (n=0; n<MAX_FRAMERATE; n++)
				rh4FrameRateArray[n]=20;				// initialisation à 1/50eme de seconde
			rh4FrameRatePos=0;
		}
		
		public function f_GameLoop():int
		{
			// Recupere l'horloge, le nombre de loops
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var timerBase:int=getTimer();
			var delta:int = timerBase-rhTimerOld;
			var oldtimer:int= rhTimer;
			
			if(rhFrame == null)
				return 0;
			
			// On est en pause?
			// ~~~~~~~~~~~~~~~~
			if (rh2PauseCompteur != 0)
			{
				return 0;
			}
			
			
			// Create Box2D Bodies
			if (rh4Box2DObject && !bodiesCreated)
			{
				CreateBodies();
				bodiesCreated = true;
			}
			
			rhTimer = delta;
			delta -= oldtimer;
			rhTimerDelta = delta;				// Delta a la boucle precedente
			rh4TimeOut += delta;			// Compteur time-out.
			rhLoopCount += 1;
			rh4MvtTimerCoef=(Number(rhTimerDelta)) * (Number(rhFrame.m_dwMvtTimerBase)) / 1000.0;
			
			// Gestion du framerate
			rh4FrameRateArray[rh4FrameRatePos]=delta;
			rh4FrameRatePos++;
			if (rh4FrameRatePos>=MAX_FRAMERATE)
			{
				rh4FrameRatePos=0;
			}
			
			// Si mode demo
			// ~~~~~~~~~~~~
			if (rh4DemoMode==CDemoRecord.DEMOPLAY)
			{
				rh4Demo.playStep();
			}
			
			// Le joystick
			// ~~~~~~~~~~~
			var n:int;
			for (n=0; n<4; n++)
			{
				rh2OldPlayer[n] = rhPlayer[n];
			}
			if (rh4DemoMode==CDemoRecord.DEMOPLAY)
			{
				for (n=0; n<4; n++)
					rhPlayer[n]=rh4Demo.getJoystick(n);
			}
			else
			{
				joyTest();
			}
			
			// La souris, si un mouvement souris est defini
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ( rhMouseUsed!=0 )
			{
				if (rh4DemoMode==CDemoRecord.DEMOPLAY)
					rh4Demo.setMousePos();
				
				getMouseCoords();
				
				// Retrouve les touches de la souris 
				rh2MouseKeys = 0;
				var keyState:Boolean;
				
				if (rh4DemoMode==CDemoRecord.DEMOPLAY)
				{
					keyState=rh4Demo.getKeyState(0);		// VK_LBUTTON
				}
				else
				{
					keyState = rhApp.getKeyState(260);	// VK_LBUTTON);
				}
				if ( keyState )
				{
					rh2MouseKeys |= 0x10;				//00010000B;
				}
				
				/*            	if (rh4DemoMode==CDemoRecord.DEMOPLAY)
				{
				keyState=rh4Demo.getKeyState(2);	// VK_RBUTTON);
				}
				else
				{
				keyState = rhApp.getKeyState(2);	// VK_RBUTTON
				}
				if ( keyState )
				{
				rh2MouseKeys |= 0x20;				//00100000B;
				}
				*/
				// Force les touches souris comme joystick
				var mouseUsed:int = rhMouseUsed;
				for (n=0; n<rhNPlayers; n++)
				{
					if ((mouseUsed&1)!=0)
					{
						var key:int=(rhPlayer[n]&0xCF);		//11001111B;
						key|=rh2MouseKeys;
						rhPlayer[n]=key;
					}
					mouseUsed >>= 1;
				}
			}
				// Pas de souris, prend les coordonnees dans le playfield
			else
			{
				getMouseCoords();
			}
			
			// Appel des messages JOYSTICK PRESSED pour chaque joueur
			var b:int;
			for (n=0; n<4; n++)
			{
				b=(rhPlayer[n]&plMasks[rhNPlayers*4+n]);
				b&=rh2InputMask[n];
				rhPlayer[n]=b;
				b^=rh2OldPlayer[n];
				rh2NewPlayer[n]=b;
				if (b!=0)
				{
					b&=rhPlayer[n];
					if ((b&0xF0)!=0)
					{
						// Message bloquant pour les touches FEU seules
						rhEvtProg.rhCurOi=n;
						b=rh2NewPlayer[n];
						if ((b&0xF0)!=0)
						{
							rhEvtProg.rhCurParam0=b;
							rhEvtProg.handle_GlobalEvents(((-4<<16)|0xFFF9));	// CNDL_JOYPRESSED);
						}
						// Les autres touches...
						if ((b&0x0F)!=0)
						{
							rhEvtProg.rhCurParam0=b;
							rhEvtProg.handle_GlobalEvents(((-4<<16)|0xFFF9));	// CNDL_JOYPRESSED);
						}
					}
					else
					{
						// Le reste des touches
						var num:int=rhEvtProg.listPointers[rhEvtProg.rhEvents[-COI.OBJ_PLAYER]+4];		// -NUM_JOYPRESSEZD
						if ( num!=0 )
						{
							rhEvtProg.rhCurParam0=b;
							rhEvtProg.computeEventList(num, null);
						}
					}
				}
			}
			
			// Boucle de gestion des objets
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ( rhNObjects != 0 )					// Nombre d'objets
			{
				var cptObject:int = rhNObjects;
				var count:int=0;
				do 
				{
					rh4ObjectAddCreate = 0;
					while(rhObjectList[count]==null)
						count++;
					var pObject:CObject = rhObjectList[count];
					
					pObject.hoPrevNoRepeat = pObject.hoBaseNoRepeat;	// Echange les buffers no repeat
					pObject.hoBaseNoRepeat = null;							// RAZ du buffer actuel
					if (pObject.hoCallRoutine)
					{
						rh4ObjectCurCreate = count;		// En cas de create object
						pObject.handle();
					}
					
					cptObject += rh4ObjectAddCreate;	 	// Un objet nouveau DEVANT le courant
					count++;
					cptObject--;
				} while (cptObject != 0);
			}
			rh3CollisionCount++; 			// Pour la gestion des evenements: on est plus dans la boucle!
			
			// Appel de tous les evenements
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			rhEvtProg.compute_TimerEvents();			// Evenements timer normaux
			rhEvtProg.handle_TimerEvents();			    // On Timer
			
			if ( rhEvtProg.rhEventAlways )				// Les evenements ALWAYS
			{
				if ( (rhGameFlags&GAMEFLAGS_FIRSTLOOPFADEIN)==0 )
					rhEvtProg.computeEventList(0, null);
			}
			
			// Effectue les evenements pousses
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			rhEvtProg.handle_PushedEvents();
			
			// Detruit les objets marques
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~
			destroy_List();
			
			// Fait le scrolling
			// -----------------
			doScroll();
			
			// Modif les objets bouges par les evenements
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			modif_ChangedObjects();
			
			// RAZ du click
			// ~~~~~~~~~~~~
			rhEvtProg.rh2CurrentClick = -1;
			rh4EventCount++;
			rh4FakeKey = 0;
			
			// testing to avoid some pause during the execution
			if(rhApp.stage != null && (rhLoopCount - nLoopGC) >= int(rhApp.stage.frameRate*1.51)) {
				nLoopGC = rhLoopCount;
				System.gc();
			}
			
			// C'est fini!
			// ~~~~~~~~~~~
			if ( rhQuit == 0 )
			{
				return rhQuitBis;
			}
			
			// Appel eventuel des evenements fin de niveau
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ( rhQuit == LOOPEXIT_NEXTLEVEL ||
				rhQuit == LOOPEXIT_PREVLEVEL ||
				rhQuit == LOOPEXIT_ENDGAME ||
				rhQuit == LOOPEXIT_GOTOLEVEL ||
				rhQuit == LOOPEXIT_QUIT ||
				rhQuit == LOOPEXIT_NEWGAME)
			{
				rhEvtProg.handle_GlobalEvents((-2<<16)|0xFFFD);
			}
			
			return rhQuit;
		}
		
		// Bouge les objets changes par les evenements
		// -------------------------------------------
		public function modif_ChangedObjects():void
		{
			var count:int=0;
			var no:int;
			for (no=0; no<rhNObjects; no++)		// Des objets à voir?
			{
				while(rhObjectList[count]==null)
					count++;
				var pHo:CObject=rhObjectList[count];
				count++;
				
				if ( (pHo.hoOEFlags & (CObjectCommon.OEFLAG_ANIMATIONS|CObjectCommon.OEFLAG_MOVEMENTS|CObjectCommon.OEFLAG_SPRITES)) != 0 )
				{
					if ( pHo.roc.rcChanged )
					{
						pHo.modif();
						pHo.roc.rcChanged=false;
					}
				}
			}
		}
		
		//---------------------------------------------------------//
		//	Lecture lecture et clavier pour les 4 joueurs          //
		//---------------------------------------------------------//
		public function joyTest():void
		{
			var i:int;
			
			// Raz des entrees des joueurs
			for (i=0; i<4; i++)
				rhPlayer[i] = 0;
			
			// Pour chaque joueur, lire clavier ou joystick
			var ctrlType:Array=rhApp.getCtrlType();
			var ctrlKeys:Array=rhApp.getCtrlKeys();
			
			for (i=0; i<CRunApp.MAX_PLAYER; i++)
			{		
				switch (ctrlType[i]) 
				{	
					// Keyboard
					case 1:         // CTRLTYPE_JOY1:
					case 2:         // CTRLTYPE_JOY2:
					case 3:         // CTRLTYPE_JOY3:
					case 4:         // CTRLTYPE_JOY4:
					case 5:         // CTRLTYPE_KEYBOARD:
						var k:int;
						for (k=0; k<CRunApp.MAX_KEY; k++)
						{
							if (rhApp.getKeyState(ctrlKeys[i*CRunApp.MAX_KEY+k]))
							{
								rhPlayer[i]|=1<<k;
							}
						}
						break;
				}
			}
		}
		
		// --------------------------------------------------------------------------
		// Demande les coordonnees de la souris au systeme, retabli dans le playfield	  
		// --------------------------------------------------------------------------
		public function getMouseCoords():void
		{
			if (rh4DemoMode==CDemoRecord.DEMOPLAY)
			{
				rh2MouseX=rh4Demo.getMouseX();
				rh2MouseY=rh4Demo.getMouseY();
			}
			else
			{
				rh2MouseX=rhApp.mouseX+rhWindowX;
				rh2MouseY=rhApp.mouseY+rhWindowY;
			}
		}
		
		
		// -----------------------------------------------------------------------
		// DETECTION DE COLLISIONS
		// -----------------------------------------------------------------------
		public function newHandle_Collisions(pHo:CObject):Boolean
		{
			// Raz des flags pour le mouvement
			pHo.rom.rmMoveFlag=false;
			bMoveChanged=false;
			pHo.rom.rmEventFlags = 0;
			
			// ENTREE /SORTIE DU TERRAIN?
			// ---------------------------------------------------------------------------
			var cadran:int, cadran1:int, cadran2:int;
			var chgDir:int;
			if ( (pHo.hoLimitFlags & CObjInfo.OILIMITFLAGS_QUICKBORDER) != 0 )
			{
				// Regarde si on ENTRE dans le terrain
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				cadran1= quadran_In(pHo.roc.rcOldX1, pHo.roc.rcOldY1, pHo.roc.rcOldX2, pHo.roc.rcOldY2);
				if ( cadran1 != 0 )		// Si deja dedans, on ne teste pas
				{
					cadran2= quadran_In(pHo.hoX - pHo.hoImgXSpot, pHo.hoY - pHo.hoImgYSpot, pHo.hoX - pHo.hoImgXSpot + pHo.hoImgWidth, pHo.hoY - pHo.hoImgYSpot + pHo.hoImgHeight);
					if ( cadran2 == 0 )		// Teste si entre!
					{
						chgDir= (cadran1 ^ cadran2);	// Les directions qui ont change!
						if ( chgDir != 0 )
						{
							pHo.rom.rmEventFlags |= CRMvt.EF_GOESINPLAYFIELD;
							rhEvtProg.rhCurParam0=chgDir;
							rhEvtProg.handle_Event(pHo, (-11<<16) | (pHo.hoType&0xFFFF) );  // CNDL_EXTINPLAYFIELD 
						}
					}
				}
				
				// Gestion des flags WRAP
				// ~~~~~~~~~~~~~~~~~~~~~~
				cadran= quadran_In(pHo.hoX - pHo.hoImgXSpot, pHo.hoY - pHo.hoImgYSpot, pHo.hoX - pHo.hoImgXSpot + pHo.hoImgWidth, pHo.hoY - pHo.hoImgYSpot + pHo.hoImgHeight);
				if ( (cadran & pHo.rom.rmWrapping) != 0 )
				{
					if ( (cadran & BORDER_LEFT) != 0 )  
						pHo.rom.rmMovement.setXPosition(pHo.hoX + rhLevelSx);	// Sort a gauche
					else if ( (cadran & BORDER_RIGHT) != 0 )
						pHo.rom.rmMovement.setXPosition(pHo.hoX - rhLevelSx);	// Sort a droite
					
					if ( (cadran & BORDER_TOP) != 0 )
						pHo.rom.rmMovement.setYPosition(pHo.hoY + rhLevelSy);		// Sort en haut
					else if ( (cadran & BORDER_BOTTOM) != 0 )
						pHo.rom.rmMovement.setYPosition(pHo.hoY - rhLevelSy);		// Sort en bas
				}
				
				// Regarde si on SORT du le terrain
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				cadran1 = quadran_Out(pHo.roc.rcOldX1, pHo.roc.rcOldY1, pHo.roc.rcOldX2, pHo.roc.rcOldY2);
				if ( cadran1 != BORDER_ALL )		// Si deja completement dehors, on ne teste pas
				{
					cadran2= quadran_Out(pHo.hoX - pHo.hoImgXSpot, pHo.hoY - pHo.hoImgYSpot, 
						pHo.hoX - pHo.hoImgXSpot + pHo.hoImgWidth, pHo.hoY - pHo.hoImgYSpot + pHo.hoImgHeight);
					
					chgDir= (~cadran1 & cadran2);
					if ( chgDir != 0 )
					{
						pHo.rom.rmEventFlags |= CRMvt.EF_GOESOUTPLAYFIELD;
						rhEvtProg.rhCurParam0 = chgDir;		// ou LOWORD?
						rhEvtProg.handle_Event(pHo, (-12<<16) | (pHo.hoType&0xFFFF) );  // CNDL_EXTOUTPLAYFIELD 
					}
				}
			}
			
			// COLLISION AVEC DES ELEMENTS DE DECOR
			// ---------------------------------------------------------------------------
			if ( (pHo.hoLimitFlags & CObjInfo.OILIMITFLAGS_QUICKBACK) != 0 )
			{
				// Si movement platforme, YVES!
				if ( pHo.roc.rcMovementType == CMoveDef.MVTYPE_PLATFORM )
				{
					var platform:CMovePlatform=CMovePlatform(pHo.rom.rmMovement);
					platform.mpHandle_Background();
				}
					// Autres mouvements
					// ~~~~~~~~~~~~~~~~~
				else
				{
					if ( colMask_TestObject_IXY(pHo, pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY, pHo.hoX, pHo.hoY, 0, CRunFrame.CM_TEST_PLATFORM) )
					{
						rhEvtProg.handle_Event(pHo, ( (-13<<16) | (pHo.hoType&0xFFFF) ));
					}
				}
			}
			
			// COLLISION AVEC DES AUTRES SPRITES
			// ---------------------------------------------------------------------------
			if ( (pHo.hoLimitFlags & CObjInfo.OILIMITFLAGS_ONCOLLIDE) != 0 )
			{
				var cnt:CArrayList = objectAllCol_IXY(pHo, pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY, pHo.hoX, pHo.hoY, pHo.hoOiList.oilColList); 
				if ( cnt != null )
				{
					var obj:int;
					for (obj=0; obj<cnt.size(); obj++)
					{
						var pHox:CObject = CObject(cnt.get(obj));
						if ( (pHox.hoFlags & CObject.HOF_DESTROYED) == 0 )	// Detruit au cycle precedent?
						{
							// Genere la collision, TOUJOURS sur le type de l'objet inferieur
							var type:int = pHo.hoType;
							var pHo_esi:CObject = pHo;
							var pHo_ebx:CObject = pHox;
							if ( pHo_esi.hoType > pHo_ebx.hoType )
							{
								pHo_esi = pHox;
								pHo_ebx = pHo;
								type = pHo_esi.hoType;
							}
							rhEvtProg.rhCurParam0 = pHo_ebx.hoOi;
							rhEvtProg.rh1stObjectNumber = pHo_ebx.hoNumber;
							rhEvtProg.handle_Event(pHo_esi, (-14<<16)|(type&0xFFFF) );	// CNDL_EXTCOLLISION 
						}
					}
				}
			}	
			return bMoveChanged;
		}
		
		// ----------------------------------------------
		// Teste les collisions de tous les objets
		// ----------------------------------------------
		// Renvoie le nombre de collisions
		public function objectAllCol_IXY(pHo:CObject, newImg:int, newAngle:int, newScaleX:Number, newScaleY:Number, newX:int, newY:int, pOiColList:Array):CArrayList
		{
			var list:CArrayList=null;
			
			var rectX1:int = newX - pHo.hoImgXSpot;
			var rectX2:int = rectX1 + pHo.hoImgWidth;
			var rectY1:int = newY - pHo.hoImgYSpot;
			var rectY2:int = rectY1 + pHo.hoImgHeight;
			
			var image1:CImage;
			var pMask2:CMask;
			var image2:CImage;
			if ((pHo.hoFlags&CObject.HOF_NOCOLLISION)!=0 || (pHo.hoFlags&CObject.HOF_DESTROYED)!=0)
			{
				return list;
			}
			var bMask1:Boolean=false;
			var pMask1:CMask=null;
			var image:CImage;
			var nLayer:int=-1;
			if (pHo.hoType==COI.OBJ_SPR && (pHo.ros.rsFlags&CRSpr.RSFLAG_COLBOX)==0)
			{
				bMask1=true;
			}
			if (pHo.hoType==COI.OBJ_SPR)
			{
				nLayer=pHo.ros.rsLayer;
			}							
			
			var oldHoFlags:int = pHo.hoFlags;
			pHo.hoFlags |= CObject.HOF_NOCOLLISION;
			var count:int=0;
			var i:int;
			var pHox:CObject;
			var xHox:int, yHox:int;
			if (pOiColList!=null)
			{
				var nOi:int=0;
				for (nOi=0; nOi<pOiColList.length; nOi+=2)
				{
					var pOil:CObjInfo=rhOiList[pOiColList[nOi+1]];
					var object:int=pOil.oilObject;
					while(object>=0)
					{
						pHox=rhObjectList[object];
						object=pHox.hoNumNext;
						
						if ((pHox.hoFlags&CObject.HOF_NOCOLLISION)==0 && (pHo.hoFlags&CObject.HOF_DESTROYED)==0)
						{					
							xHox=pHox.hoX-pHox.hoImgXSpot;
							yHox=pHox.hoY-pHox.hoImgYSpot;
							if ( xHox < rectX2 && 
								xHox + pHox.hoImgWidth > rectX1 && 
								yHox < rectY2 && 
								yHox + pHox.hoImgHeight > rectY1 )
							{
								switch(pHox.hoType)
								{
									case COI.OBJ_SPR:
										if (nLayer<0 || (nLayer>=0 && nLayer==pHox.ros.rsLayer))
										{
											if ((pHox.ros.rsFlags&CRSpr.RSFLAG_RAMBO)!=0)
											{
												if (bMask1==false || (pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)!=0)
												{
													if (list==null)
													{
														list=new CArrayList();
													}
													list.add(pHox);
													break;
												}
												if (pMask1==null)
												{
													image=rhApp.imageBank.getImageFromHandle(newImg);
													if (image!=null)
													{
														pMask1=image.getMask(0, newAngle, newScaleX, newScaleY);
													}
												}
												image2=rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
												if (image2!=null)
												{
													pMask2=image2.getMask(0, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
												}
												if (pMask1!=null && pMask2!=null)
												{									
													if (pMask1.testMask(rectX1, rectY1, 0, pMask2, xHox, yHox, 0))
													{
														if (list==null)
														{
															list=new CArrayList();
														}
														list.add(pHox);
														break;
													}
												}									
											}
										}
										break;
									case COI.OBJ_TEXT:
									case COI.OBJ_COUNTER:
									case COI.OBJ_LIVES:
									case COI.OBJ_SCORE:
									case COI.OBJ_CCA:
										if (list==null)
										{
											list=new CArrayList();
										}
										list.add(pHox);
										break;
									default:
										if (list==null)
										{
											list=new CArrayList();
										}
										list.add(pHox);
										break;
								}
							}
						}									
					}
				}
			}
			else
			{
				for (i=0; i<rhNObjects; i++)
				{
					while(rhObjectList[count]==null)
						count++;
					pHox=rhObjectList[count];
					count++;
					
					if ((pHox.hoFlags&CObject.HOF_NOCOLLISION)==0)
					{					
						xHox=pHox.hoX-pHox.hoImgXSpot;
						yHox=pHox.hoY-pHox.hoImgYSpot;
						if ( xHox < rectX2 && 
							xHox + pHox.hoImgWidth > rectX1 && 
							yHox < rectY2 && 
							yHox + pHox.hoImgHeight > rectY1 )
						{
							switch(pHox.hoType)
							{
								case COI.OBJ_SPR:
									if (nLayer<0 || (nLayer>=0 && nLayer==pHox.ros.rsLayer))
									{
										if ((pHox.ros.rsFlags&CRSpr.RSFLAG_RAMBO)!=0)
										{
											if (bMask1==false || (pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)!=0)
											{
												if (list==null)
												{
													list=new CArrayList();
												}
												list.add(pHox);
												break;
											}
											if (pMask1==null)
											{
												image=rhApp.imageBank.getImageFromHandle(newImg);
												if (image!=null)
												{
													pMask1=image.getMask(0, newAngle, newScaleX, newScaleY);
												}
											}
											image2=rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
											if (image2!=null)
											{
												pMask2=image2.getMask(0, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
											}
											if (pMask1!=null && pMask2!=null)
											{									
												if (pMask1.testMask(rectX1, rectY1, 0, pMask2, xHox, yHox, 0))
												{
													if (list==null)
													{
														list=new CArrayList();
													}
													list.add(pHox);
													break;
												}
											}									
										}
									}
									break;
								case COI.OBJ_TEXT:
								case COI.OBJ_COUNTER:
								case COI.OBJ_LIVES:
								case COI.OBJ_SCORE:
								case COI.OBJ_CCA:
									if (list==null)
									{
										list=new CArrayList();
									}
									list.add(pHox);
									break;
								default:
									if (list==null)
									{
										list=new CArrayList();
									}
									list.add(pHox);
									break;
							}
						}
					}									
				}
			}
			// Remettre anciens flags
			pHo.hoFlags = oldHoFlags;    
			return list;
		}
		
		// ----------------------------------------------
		// Teste les collisions d'un objet avec le decor
		// Si collision, retourne la condition COLBACK
		// ----------------------------------------------
		public function colMask_TestObject_IXY(pHo:CObject, newImg:int, newAngle:int, newScaleX:Number, newScaleY:Number, newX:int, newY:int, htFoot:int, plan:int):Boolean
		{    	
			var image:CImage;
			var mask:CMask;
			var x1:int;
			var y1:int;
			var x2:int;
			var y2:int;
			
			var pLayer:CLayer=rhFrame.layers[pHo.hoLayer];
			switch (pHo.hoType)
			{
				case COI.OBJ_SPR:
					if ((pHo.ros.rsFlags&CRSpr.RSFLAG_COLBOX) == 0)
					{
						image=rhApp.imageBank.getImageFromHandle(pHo.roc.rcImage);
						if (image!=null)
						{
							mask=image.getMask(CMask.GCMF_OBSTACLE, newAngle, newScaleX, newScaleY);
							return pLayer.testMask(mask, newX-rhWindowX, newY-rhWindowY, htFoot, plan)!=null;
						}
					}
					else
					{
						x1=newX-pHo.hoImgXSpot-rhWindowX;
						y1=newY-pHo.hoImgYSpot-rhWindowY;
						x2=x1+pHo.hoImgWidth;
						y2=y1+pHo.hoImgHeight;
						return pLayer.testRect(x1, y1, x2, y2, htFoot, plan)!=null; 
					}
					return false;			
				case COI.OBJ_TEXT:
				case COI.OBJ_SCORE:
				case COI.OBJ_LIVES:
				case COI.OBJ_CCA:
					x1=newX-pHo.hoImgXSpot-rhWindowX;
					y1=newY-pHo.hoImgYSpot-rhWindowY;
					x2=x1+pHo.hoImgWidth;
					y2=y1+pHo.hoImgHeight;
					return pLayer.testRect(x1, y1, x2, y2, htFoot, plan)!=null; 
			}
			return false; 
		}
		public function colMask_Test_Rect(x1:int, y1:int, sx:int, sy:int, layer:int, plan:int):Boolean
		{
			var pLayer:CLayer;
			var nLayerMax:int=layer;
			if (layer==-1)
			{
				layer=0;
				nLayerMax=rhFrame.nLayers;
			}
			
			var n:int;
			var x2:int=x1+sx;
			var y2:int=y1+sy;
			for (n=layer; n<nLayerMax; n++)
			{
				pLayer=rhFrame.layers[n];
				if (pLayer.testRect(x1-rhWindowX+pLayer.x, y1-rhWindowY+pLayer.y, x2-rhWindowX+pLayer.x, y2-rhWindowY+pLayer.y, 0, plan)!=null)
				{
					return true;
				}
			}
			return false;    	
		} 
		public function colMask_Test_XY(newX:int, newY:int, layer:int, plan:int):Boolean
		{
			var pLayer:CLayer;
			var nLayerMax:int=layer;
			if (layer==-1)
			{
				layer=0;
				nLayerMax=rhFrame.nLayers;
			}
			
			var n:int;
			for (n=layer; n<nLayerMax; n++)
			{
				pLayer=rhFrame.layers[n];
				if (pLayer.testPoint(newX-rhWindowX+pLayer.x, newY-rhWindowY+pLayer.y, plan))
				{
					return true;
				}
			}    	
			return false; 
		}
		public function getObjectAtXY(x:int, y:int):CObject
		{
			// Explore les sprites en collision
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var count:int=0;
			var i:int;
			var pHox:CObject;
			var x1:int, y1:int, x2:int, y2:int;
			var currentHo:CObject=null;
			var currentIndex:int=-1;
			var index:int;
			
			for (i=0; i<rhNObjects; i++)
			{
				while(rhObjectList[count]==null)
					count++;
				pHox=rhObjectList[count];
				count++;
				
				x1=pHox.hoX-pHox.hoImgXSpot;
				y1=pHox.hoY-pHox.hoImgYSpot;
				x2=x1+pHox.hoImgWidth;
				y2=y1+pHox.hoImgHeight;
				if (x>=x1 && x<x2 && y>=y1 && y<y2)
				{
					if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
					{
						if (pHox.hoType==COI.OBJ_SPR)
						{
							if ((pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)==0)
							{
								var image:CImage=rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
								var mask:CMask=image.getMask(CMask.GCMF_OBSTACLE, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
								if (mask.testPoint(x1, y1, x, y))
								{
									index=pHox.getChildIndex();
									if (index>currentIndex)
									{
										currentIndex=index;
										currentHo=pHox;
									}
								}
							}
							else
							{
								index=pHox.getChildIndex();
								if (index>currentIndex)
								{
									currentIndex=index;
									currentHo=pHox;
								}
							}
						}
					}
				}
			}
			return currentHo;
		}
		
		// ---------------------------------------------------------------------------
		// Routine: retourne le quadran pointe par AX/BX lors de la sortie d'un sprite
		// ---------------------------------------------------------------------------
		public function quadran_Out (x1:int, y1:int, x2:int, y2:int):int
		{
			var cadran:int = 0;
			if ( x1 < 0 )
				cadran |= BORDER_LEFT;
			if ( y1 < 0 )
				cadran |= BORDER_TOP;
			if ( x2 > rhLevelSx )
				cadran |= BORDER_RIGHT;
			if ( y2 > rhLevelSy )
				cadran |= BORDER_BOTTOM;
			return Table_InOut[cadran];
		}
		
		// ---------------------------------------------------------------------------
		// Routine: retourne le quadran pointe par AX/BX lors de l'entree d'un sprite 
		// ---------------------------------------------------------------------------
		public function quadran_In (x1:int, y1:int, x2:int, y2:int):int
		{
			var cadran:int = 15;
			if ( x1 < rhLevelSx )
				cadran &= ~BORDER_RIGHT;
			if ( y1 < rhLevelSy )
				cadran &= ~BORDER_BOTTOM;
			if ( x2 > 0 )
				cadran &= ~BORDER_LEFT;
			if ( y2 > 0 )
				cadran &= ~BORDER_TOP;
			return Table_InOut[cadran];
		}
		
		// ---------------------------------------------------------------------------
		// Generateur aleatoire, entree AX= chiffre maxi
		// ---------------------------------------------------------------------------
		public function random(wMax:int):int
		{
			var calcul:int=rh3Graine*31415+1;
			calcul&=0x0000FFFF;
			rh3Graine = calcul;
			return ((calcul*wMax)>>>16);
		}
		
		// ----------------------------------
		// Interprete un parametre DIRECTION
		// ----------------------------------
		public function get_Direction(dir:int):int
		{
			if (dir==0 || dir==-1)
			{
				// Au hasard parmi les 32
				// ~~~~~~~~~~~~~~~~~~~~~~
				return random(32);
			}
			
			// Compte le nombre de directions demandees
			var loop:int;
			var found:int=0;
			var count:int=0;
			var dirShift:int=dir;
			for (loop=0; loop<32; loop++)
			{
				if ((dirShift&1)!=0)
				{
					count++;
					found=loop;
				}
				dirShift>>>=1;
			}
			
			// Une direction?
			// ~~~~~~~~~~~~~~
			if (count==1)
			{
				return found;
			}
			
			// Au hasard
			// ~~~~~~~~~
			count=random(count);
			dirShift=dir;
			for (loop=0; loop<32; loop++)
			{
				if ((dirShift&1)!=0)
				{
					count--;
					if (count<0)
					{ 
						return loop;
					}
				}
				dirShift>>>=1;
			}
			return 0;
		}
		
		// -----------------------------------------------------------------------
		// EVALUATION D'EXPRESSION
		// -----------------------------------------------------------------------
		public function get_EventExpressionAny(pExp:CParamExpression):CValue
		{
			rh4Tokens = pExp.tokens;
			rh4CurToken = 0;
			var value:CValue=getExpression();
			var ret:CValue=new CValue(0);
			ret.forceValue(value);
			return ret;
		}
		
		public function get_EventExpressionInt(pExp:CParamExpression):int
		{
			rh4Tokens = pExp.tokens;
			rh4CurToken = 0;
			return getExpression().getInt();
		}
		
		public function get_EventExpressionDouble(pExp:CParamExpression):Number
		{
			rh4Tokens = pExp.tokens;
			rh4CurToken = 0;
			return getExpression().getDouble();
		}
		
		public function get_EventExpressionString(pExp:CParamExpression):String
		{
			rh4Tokens = pExp.tokens;
			rh4CurToken = 0;
			return getExpression().getString();
		}
		
		public function get_EventExpressionStringLowercase (pExp:CParamExpression):String
		{
			if (pExp.tokens.length == 2 && pExp.tokens [0] is EXP_STRING)
				return (EXP_STRING( pExp.tokens [0]).getLowercase());
			
			return get_EventExpressionString (pExp).toLowerCase();
		}
		
		public function get_ExpressionInt():int
		{
			return getExpression().getInt();
		}
		
		public function get_ExpressionDouble():Number
		{
			return getExpression().getDouble();
		}
		
		public function get_ExpressionString():String
		{
			return getExpression().getString();
		}
		public function get_ExpressionAny():CValue
		{
			var ret:CValue=new CValue(0);
			ret.forceValue(getExpression());
			return ret;
		}
		
		public function evaluateAsLowercase (token:CExp):void 
		{
			if (token is EXP_STRING)
				(EXP_STRING( token).evaluateAsLowercase(this));
			else
			{
				token.evaluate (this);
				
				var currentResult:CValue = rh4Results[rh4PosPile];
				
				if (currentResult.type == CValue.TYPE_STRING)
					currentResult.forceString (currentResult.getString ().toLowerCase ());
			}
		}
		
		public function get_ExpressionStringLowercase():String
		{
			var ope:CExp;
			var pileStart:int = rh4PosPile;
			rh4Operators[rh4PosPile] = rh4OpeNull;
			do
			{
				rh4PosPile++;
				bOperande=true;
				evaluateAsLowercase (rh4Tokens[rh4CurToken]);
				bOperande=false;
				rh4CurToken++;
				
				// Regarde l'operateur
				do
				{
					ope = rh4Tokens[rh4CurToken];
					if (ope.code > 0 && ope.code < 0x00140000)	// (OPERATOR_START && ope<OPERATOR_END)
					{
						if (ope.code > rh4Operators[rh4PosPile - 1].code)
						{
							rh4Operators[rh4PosPile] = ope;
							rh4CurToken++;
							
							rh4PosPile++;
							bOperande=true;
							
							evaluateAsLowercase (rh4Tokens[rh4CurToken]);
							
							bOperande=false;
							rh4CurToken++;
						}
						else
						{
							rh4PosPile--;
							evaluateAsLowercase (rh4Operators[rh4PosPile]);
						}
					}
					else
					{
						rh4PosPile--;
						if (rh4PosPile == pileStart)
						{
							break;
						}
						evaluateAsLowercase (rh4Operators[rh4PosPile]);
					}
				} while (true);
			} while (rh4PosPile > pileStart + 1);
			
			return rh4Results[pileStart + 1].getString();
		}
		
		public function getExpression():CValue
		{
			var ope:CExp;
			var pileStart:int = rh4PosPile;
			rh4Operators[rh4PosPile] = rh4OpeNull;
			do
			{
				rh4PosPile++;
				bOperande=true;
				rh4Tokens[rh4CurToken].evaluate(this);
				bOperande=false;
				rh4CurToken++;
				
				// Regarde l'opérateur
				do
				{
					ope = rh4Tokens[rh4CurToken];
					if (ope.code > 0 && ope.code < 0x00140000)	// (OPERATOR_START && ope<OPERATOR_END)
					{
						if (ope.code > rh4Operators[rh4PosPile - 1].code)
						{
							rh4Operators[rh4PosPile] = ope;
							rh4CurToken++;
							
							rh4PosPile++;
							bOperande=true;
							rh4Tokens[rh4CurToken].evaluate(this);
							bOperande=false;
							rh4CurToken++;
						}
						else
						{
							rh4PosPile--;
							rh4Operators[rh4PosPile].evaluate(this);
						}
					}
					else
					{
						rh4PosPile--;
						if (rh4PosPile == pileStart)
						{
							break;
						}
						rh4Operators[rh4PosPile].evaluate(this);
					}
				} while (true);
			} while (rh4PosPile > pileStart + 1);
			
			return rh4Results[pileStart + 1];
		}
		
		public function getCurrentResult():CValue
		{
			return rh4Results[rh4PosPile];
		}
		
		public function getPreviousResult():CValue
		{
			return rh4Results[rh4PosPile - 1];
		}
		
		public function getNextResult():CValue
		{
			return rh4Results[rh4PosPile + 1];
		}
		
		// ROUTINE DE COMPARAISON GENERALE
		// -------------------------------
		public static function compareTo(pValue1:CValue, pValue2:CValue, comp:int):Boolean
		{
			switch (comp)
			{
				case 0:	// COMPARE_EQ:
					return pValue1.equal(pValue2);
				case 1:	// COMPARE_NE:
					return pValue1.notEqual(pValue2);
				case 2:	// COMPARE_LE:
					return pValue1.lower(pValue2);
				case 3:	// COMPARE_LT:
					return pValue1.lowerThan(pValue2);
				case 4:	// COMPARE_GE:
					return pValue1.greater(pValue2);
				case 5:	// COMPARE_GT:
					return pValue1.greaterThan(pValue2);
			}
			return false;
		}
		
		// Comparaison de deux entiers
		// ---------------------------
		public static function compareTer(value1:int, value2:int, comparaison:int):Boolean
		{
			switch (comparaison)
			{
				case 0:	// COMPARE_EQ:
					return (value1 == value2);
				case 1:	// COMPARE_NE:
					return (value1 != value2);
				case 2:	// COMPARE_LE:
					return (value1 <= value2);
				case 3:	// COMPARE_LT:
					return (value1 < value2);
				case 4:	// COMPARE_GE:
					return (value1 >= value2);
				case 5:	// COMPARE_GT:
					return (value1 > value2);
			}
			return false;
		}
		
		// ------------------------------------------------------------------------
		// MISE A JOUR DES OBJETS PLAYER
		// ------------------------------------------------------------------------
		public function update_PlayerObjects(joueur:int, type:int, value:int):void
		{
			joueur++;
			
			var count:int=0;
			var no:int;
			for (no=0; no<rhNObjects; no++)
			{
				while(rhObjectList[count]==null)
					count++;
				var pHo:CObject=rhObjectList[count];
				if (pHo.hoType==type)
				{
					switch(type)
					{
						case 5:	// OBJ_SCORE
							var pScore:CScore=CScore(pHo);
							if (pScore.rsPlayer==joueur)
							{
								pScore.rsValue.forceInt(value);
								pScore.bCounterChanged=true;
							}
							break;
						case 6:	// OBJ_LIVES
							var pLife:CLives=CLives(pHo);
							if (pLife.rsPlayer==joueur)
							{
								pLife.rsValue.forceInt(value);
								pLife.bCounterChanged=true;
							}
							break;
					}
					pHo.roc.rcChanged=true;
					pHo.modif();
				}
				count++;
			}
		}
		
		// Termine les vies, genere les evenements PLUS DE VIE
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		public function actPla_FinishLives(joueur:int, live:int):void
		{
			var lives:Array=rhApp.getLives();
			if (live==lives[joueur])
			{ 
				return;
			}
			
			// Nouvelle vie=0?
			if (live==0)
			{
				if (lives[joueur]!=0)
				{
					rhEvtProg.push_Event(0, ((-5<<16)|0xFFF9), 0, null, joueur);
				}
			}
			
			// Change les objets...
			lives[joueur]=live;
			update_PlayerObjects(joueur, COI.OBJ_LIVES, live);
		}
		
		// -----------------------------------
		// CONDITION: mouse lays on objects
		// -----------------------------------
		public function getMouseOnObjectsEDX(oiList:int, nega:Boolean):Boolean
		{
			// Des objets a voir?
			// ------------------
			var pHo:CObject=rhEvtProg.evt_FirstObject(oiList);
			if (pHo==null)
			{
				if (nega) 
				{
					return true;
				}
				return false;
			}
			var cpt:int=rhEvtProg.evtNSelectedObjects;
			
			// Demande les collisions des sprites
			// ----------------------------------
			var count:int=0;
			var i:int;
			var pHox:CObject;
			var x1:int, y1:int, x2:int, y2:int;
			var list:CArrayList=new CArrayList();
			for (i=0; i<rhNObjects; i++)
			{
				while(rhObjectList[count]==null)
					count++;
				pHox=rhObjectList[count];
				count++;
				
				x1=pHox.hoX-pHox.hoImgXSpot;
				y1=pHox.hoY-pHox.hoImgYSpot;
				x2=x1+pHox.hoImgWidth;
				y2=y1+pHox.hoImgHeight;
				if (rh2MouseX>=x1 && rh2MouseX<x2 && rh2MouseY>=y1 && rh2MouseY<y2)
				{
					if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
					{
						if (pHox.hoType==COI.OBJ_SPR)
						{
							if ((pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)==0)
							{
								var image:CImage=rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
								var mask:CMask=image.getMask(CMask.GCMF_OBSTACLE, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
								if (mask.testPoint(x1, y1, rh2MouseX, rh2MouseY))
								{
									list.add(pHox);								
								}
							}
							else
							{
								list.add(pHox);
							}
						}
						else
						{
							list.add(pHox);
						}
					}
				}
			}
			
			// Demande les objets selectionnes
			// -------------------------------
			if (list.size()==0)
			{
				if (nega)
				{ 
					return true;
				}
				return false;
			}
			
			if (nega==false)
			{
				do
				{
					for (count=0; count<list.size(); count++)
					{
						pHox=CObject(list.get(count));
						if (pHox==pHo)
							break;
					}
					if (count==list.size())
					{
						cpt--;						//; Pas trouve dans la liste-> on le vire
						rhEvtProg.evt_DeleteCurrentObject();
					}
					pHo=rhEvtProg.evt_NextObject();
				}while(pHo!=null);
				return cpt!=0;
			}
			else
			{
				// Avec negation
				do
				{
					for (count=0; count<list.size(); count++)
					{
						pHox=CObject(list.get(count));
						if (pHox==pHo)
							return false;
					}
					pHo=rhEvtProg.evt_NextObject();
				}while(pHo!=null);
				return true;
			}
			return false;			
		}
		
		// ------------------------------------------------------------------------
		// ROUTINES OBJETS TEXTE
		// ------------------------------------------------------------------------
		
		// PROCEDURE D'AFFICHAGE DE UN TEXTE DONT AUQUEL C'EST ALORS 
		public function txtDisplay(pe:CEvent, oi:int, txtNumber:int):int
		{	
			// Cherche la position de creation
			var pEvp:PARAM_CREATE=PARAM_CREATE(pe.evtParams[0]);
			var pInfo:CPositionInfo=new CPositionInfo();
			if (pEvp.read_Position(this, 0x10, pInfo))
			{
				// Regarde si le meme text n'existe pas deja
				var count:int=0;
				var no:int;
				for (no=0; no<rhNObjects; no++)
				{
					while(rhObjectList[count]==null)
						count++;
					var pHo:CObject=rhObjectList[count];
					count++;
					
					if (pHo.hoType==COI.OBJ_TEXT && pHo.hoOi==oi && pHo.hoX==pInfo.x && pHo.hoY==pInfo.y)
					{
						// Le texte existe deja a la meme position, SECURITE, on fait un SET TEXT
						pHo.ros.obShow();					// On le montre!
						pHo.hoFlags&=~CObject.HOF_NOCOLLISION;		//; Des collisions de nouveau
						var pText:CText=CText(pHo);
						pText.rsMini=-2;					// Force la copie
						pText.txtChange(txtNumber);
						pHo.roc.rcChanged=true;
						pHo.modif();
						pHo.ros.rsFlash=0;							//; Arrete le flash!
						pHo.ros.rsFlags|=CRSpr.RSFLAG_VISIBLE;
						return pHo.hoNumber;
					}
				}
				// Cree l'objet
				var num:int=f_CreateObject(-1, oi, pInfo.x, pInfo.y, 0, 0, rhFrame.nLayers-1, -1);
				if (num>=0)
				{
					// Poke le numero du texte dans la structure
					(CText(rhObjectList[num])).txtChange(txtNumber);
					return num;
				}
			}
			return -1;
		}
		// APPEL DE LA CREATION DE TOUS LES TEXTE
		public function txtDoDisplay(pe:CEvent, txtNumber:int):int
		{
			if ((pe.evtOiList&0x8000)==0)
			{
				return txtDisplay(pe, pe.evtOi, txtNumber);
			}
			
			// Un qualifier: on explore les listes
			if ((pe.evtOiList&0x7FFF)==0x7FFF) 
				return -1;
			var qoi:int=pe.evtOiList&0x7FFF;
			var  qoil:CQualToOiList=rhEvtProg.qualToOiList[qoi];
			var count:int=0;
			while(count<qoil.qoiList.length)
			{
				txtDisplay(pe, qoil.qoiList[count], txtNumber);
				count+=2;
			};
			return -1;
		}
		
		// Gestion generique fontes / objets
		public static function getObjectFont(hoPtr:CObject):CFontInfo
		{
			var info:CFontInfo=null;
			
			if (hoPtr.hoType>=COI.KPX_BASE)
			{
				var e:CExtension=CExtension(hoPtr);
				info=e.ext.getRunObjectFont();
			}
			else
			{
				switch (hoPtr.hoType) 
				{
					case 3:		// OBJ_TEXT:
						var pText:CText=CText(hoPtr);
						info=pText.getFont();
						break;
					case 5:		// OBJ_SCORE:
						var pScore:CScore=CScore(hoPtr);
						info=pScore.getFont();		
						break;
					case 6:		// OBJ_LIVES:
						var pLives:CLives=CLives(hoPtr);
						info=pLives.getFont();
						break;
					case 7:		// OBJ_COUNTER:
						var pCounter:CCounter=CCounter(hoPtr);
						info=pCounter.getFont();
						break;
				}
			}
			if (info==null)
			{
				info=new CFontInfo();
			}
			return info;
		}
		public static function setObjectFont(hoPtr:CObject, pLf:CFontInfo, pNewSize:CRect):void
		{
			if (hoPtr.hoType>=COI.KPX_BASE)
			{
				var e:CExtension=CExtension(hoPtr);
				e.ext.setRunObjectFont(pLf, pNewSize);
			}
			else
			{	    
				switch (hoPtr.hoType) 
				{
					case 3:		// OBJ_TEXT:
						var pText:CText=CText(hoPtr);
						pText.setFont(pLf, pNewSize);
						break;
					case 5:		// OBJ_SCORE:
						var pScore:CScore=CScore(hoPtr);
						pScore.setFont(pLf, pNewSize);		
						break;
					case 6:		// OBJ_LIVES:
						var pLives:CLives=CLives(hoPtr);
						pLives.setFont(pLf, pNewSize);
						break;
					case 7:		// OBJ_COUNTER:
						var pCounter:CCounter=CCounter(hoPtr);
						pCounter.setFont(pLf, pNewSize);
						break;
				}
			}
		}
		public static function getObjectTextColor(hoPtr:CObject):int
		{
			if (hoPtr.hoType>=COI.KPX_BASE)
			{
				var e:CExtension=CExtension(hoPtr);
				return e.ext.getRunObjectTextColor();
			}
			switch (hoPtr.hoType) 
			{
				case 3:		// OBJ_TEXT:
					var pText:CText=CText(hoPtr);
					return pText.getFontColor();
				case 5:		// OBJ_SCORE:
					var pScore:CScore=CScore(hoPtr);
					return pScore.getFontColor();		
				case 6:		// OBJ_LIVES:
					var pLives:CLives=CLives(hoPtr);
					return pLives.getFontColor();
				case 7:		// OBJ_COUNTER:
					var pCounter:CCounter=CCounter(hoPtr);
					return pCounter.getFontColor();
			}
			return 0;
		}
		public static function setObjectTextColor(hoPtr:CObject, rgb:int):void
		{
			if (hoPtr.hoType>=COI.KPX_BASE)
			{
				var e:CExtension=CExtension(hoPtr);
				e.ext.setRunObjectTextColor(rgb);
			}
			else
			{
				switch (hoPtr.hoType) 
				{
					case 3:		// OBJ_TEXT:
						var pText:CText=CText(hoPtr);
						pText.setFontColor(rgb);
						break;
					case 5:		// OBJ_SCORE:
						var pScore:CScore=CScore(hoPtr);
						pScore.setFontColor(rgb);		
						break;
					case 6:		// OBJ_LIVES:
						var pLives:CLives=CLives(hoPtr);
						pLives.setFontColor(rgb);
						break;
					case 7:		// OBJ_COUNTER:
						var pCounter:CCounter=CCounter(hoPtr);
						pCounter.setFontColor(rgb);
						break;
				}
			}
		}
		
		// SET POSITION OF OBJECTS
		// -----------------------------------------------------------------------
		public static function setXPosition(hoPtr:CObject, x:int):void
		{
			if (hoPtr.rom!=null)
			{
				hoPtr.rom.rmMovement.setXPosition(x);
			}
			else
			{
				if (hoPtr.hoX!=x)
				{
					hoPtr.hoX=x;
					if (hoPtr.roc!=null)
					{
						hoPtr.roc.rcChanged=true;
						hoPtr.roc.rcCheckCollides=true;
					}
				}
			}			    
		}
		public static function setYPosition(hoPtr:CObject, y:int):void
		{
			if (hoPtr.rom!=null)
			{
				hoPtr.rom.rmMovement.setYPosition(y);
			}
			else
			{
				if (hoPtr.hoY!=y)
				{
					hoPtr.hoY=y;
					if (hoPtr.roc!=null)
					{
						hoPtr.roc.rcChanged=true;
						hoPtr.roc.rcCheckCollides=true;
					}
				}
			}			    
		}
		
		// Trouve une direction à partir d'une pente AX/BX -> AX
		// -----------------------------------------------------
		public static function get_DirFromPente(x:int, y:int):int
		{
			if (x==0)							// Si nul en X
			{
				if (y>=0) return 24;	    // DIRID_S;
				return 8;			    // DIRID_N;
			}
			if (y==0)							// Si nul en Y
			{
				if (x>=0) return 0;		    // DIRID_E;
				return 16;			    // DIRID_W;
			}
			
			var dir:int;
			var flagX:Boolean=false;
			var flagY:Boolean=false;		// Flags de signe
			if (x<0)							// DX negatif?
			{
				flagX=true;
				x=-x;
			}
			if (y<0)							// DX negatif?
			{
				flagY=true;
				y=-y;
			}
			
			var d:int=(x*256)/y;					// Calcul de la pente *256 pour plus de precision
			var index:int;
			for (index=0; ; index+=2)
			{
				if (d>=CMove.CosSurSin32[index]) 
					break;
			}		
			dir=CMove.CosSurSin32[index+1];			//; Charge la direction
			
			if (flagY)
			{
				dir=-dir+32;						//; Rétablir en Y
				dir&=31;
			}
			if (flagX)
			{
				dir-=8;								//; Retablir en X
				dir&=31;
				dir=-dir;
				dir&=31;
				dir+=8;
				dir&=31;
			}
			return dir;
		}
		
		//  --------------------------------------------------------------------------
		//	ANIMATION DISAPPEAR
		//  --------------------------------------------------------------------------
		public function init_Disappear(hoPtr:CObject):void
		{
			var bFlag:Boolean=false;
			var dw:int=0;
			
			if ((hoPtr.hoOEFlags&CObjectCommon.OEFLAG_ANIMATIONS)!=0)
			{
				if (hoPtr.ros!=null)
				{
					if (hoPtr.ros.initFadeOut())
					{
						return;
					}
				}
				if (hoPtr.roa!=null)
				{
					if (hoPtr.roa.anim_Exist(CAnim.ANIMID_DISAPPEAR))
					{
						dw=1;								// Une animation presente?
					}
				}
			}
			if (dw==0)
			{
				bFlag=true;
			}
			
			// Rien du tout-> on detruit le sprite!
			if (bFlag)
			{
				hoPtr.hoCallRoutine=false;
				destroy_Add(hoPtr.hoNumber);
				return;
			}
			
			// Branche la fausse routine de mouvement
			if (hoPtr.ros!=null)
			{
				hoPtr.ros.setColFlag(false);
				hoPtr.hoFlags|=CObject.HOF_NOCOLLISION;
			}
			if (hoPtr.rom!=null)
			{
				hoPtr.rom.initSimple(hoPtr, CMoveDef.MVTYPE_DISAPPEAR, false);
				hoPtr.roc.rcSpeed=0;
			}
			if ((dw&1)!=0)
			{
				hoPtr.roa.animation_Force(CAnim.ANIMID_DISAPPEAR);
				hoPtr.roa.animation_OneLoop();
			}
		}
		
		// -------------------------------------------------------------------------
		// Conditions / Actions en +
		// -------------------------------------------------------------------------
		public function isMouseOn():Boolean
		{
			if (rhApp.cursorCount>0)
			{
				return true;
			}
			return false;
		}
		public static function objectHide(pHo:CObject):void
		{
			if (pHo.ros!=null)
			{
				pHo.ros.obHide();
				pHo.ros.rsFlags&=~CRSpr.RSFLAG_VISIBLE;
				pHo.ros.rsFlash=0;        
			}
			//			else
			//			{
			//			    ((CRtf)pHo).setVisible(false);
			//			}
		}
		public static function objectShow(pHo:CObject):void
		{
			if (pHo.ros!=null)
			{
				pHo.ros.obShow();
				pHo.ros.rsFlags|=CRSpr.RSFLAG_VISIBLE;
				pHo.ros.rsFlash=0;        
			}
			//			else if (pHo instanceof CRtf)	    
			//			{
			//			    ((CRtf)pHo).setVisible(true);
			//			}
		}
		public function getXMouse():int
		{
			if (rhMouseUsed!=0)
			{
				return 0;
			}
			return rh2MouseX;
		}
		public function getYMouse():int
		{
			if (rhMouseUsed!=0)
			{
				return 0;
			}
			return rh2MouseY;
		}
		public function getRGBAt(hoPtr:CObject, x:int, y:int):int
		{
			var rgb:int = 0;
			if ( hoPtr.roc.rcImage!=-1 )
			{
				var image:CImage=rhApp.imageBank.getImageFromHandle(hoPtr.roc.rcImage);
				rgb=image.img.getPixel(x, y);
				rgb=CServices.swapRGB(rgb);
			}
			return rgb;
		}
		
		// ------------------------------------------------------------------------	    
		//
		// DESSIN / SCROLLING DU DECOR
		//
		// ------------------------------------------------------------------------	    
		public function drawLevel():void
		{
			var plo:CLO;
			var rc:CRect=new CRect();
			var nLayer:int;
			
			// Display backdrop objects
			for ( nLayer=0; nLayer<rhFrame.nLayers; nLayer++)
			{
				var pLayer:CLayer = rhFrame.layers[nLayer];
				
				// Show layer?
				if ( (pLayer.dwOptions & CLayer.FLOPT_TOSHOW) != 0 )
					pLayer.dwOptions |= CLayer.FLOPT_VISIBLE;

				// Get layer offset
				var bWrapHorz:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_HORZ) != 0);
				var bWrapVert:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_VERT) != 0);
				
				if (nLayer==0)
				{
					var sx:int=rhFrame.leWidth;
					if (bWrapHorz)
					{
						sx*=2;
					}
					var sy:int=rhFrame.leHeight;
					if (bWrapVert)
					{
						sy*=2;
					}				
					pLayer.fillBack(sx, sy, rhFrame.leBackground);
				}
				

				// Display Bkd LOs
				var nLOs:int = pLayer.nBkdLOs;
				var i:int;
				for (i=0; i<nLOs; i++)
				{
					plo=rhFrame.LOList.getLOFromIndex(pLayer.nFirstLOIndex+i);			
					var typeObj:int = plo.loType;
					
					// Get object position
					if ( typeObj < COI.OBJ_SPR )
					{
						rc.left = plo.loX;
						rc.top = plo.loY;
					}
					else
					{
						continue;
					}
					
					// Instance en haut a gauche
					var bi:CBackInstance;
					bi=new CBackInstance(rhApp, rc.left, rc.top, plo, null, 0);
					bi.addInstance(0, pLayer);
					
					// Wrap
					if (bWrapHorz)
					{
						bi=new CBackInstance(rhApp, rhFrame.leWidth+rc.left, rc.top, plo, null, 0);
						bi.addInstance(1, pLayer);
						if (rc.left+bi.width>rhFrame.leWidth)
						{
							bi=new CBackInstance(rhApp, rc.left-rhFrame.leWidth, rc.top, plo, null, 0);
							bi.addInstance(4, pLayer);
						}
						if (bWrapVert)
						{
							bi=new CBackInstance(rhApp, rc.left, rhFrame.leHeight+rc.top, plo, null, 0);
							bi.addInstance(2, pLayer);
							bi=new CBackInstance(rhApp, rhFrame.leWidth+rc.left, rhFrame.leHeight+rc.top, plo, null, 0);
							bi.addInstance(3, pLayer);
							if (rc.top+bi.height>rhFrame.leHeight)
							{
								bi=new CBackInstance(rhApp, rc.left, rc.top-rhFrame.leHeight, plo, null, 0);
								bi.addInstance(5, pLayer);
							}
						}							
					}
					else if (bWrapVert)
					{
						bi=new CBackInstance(rhApp, rc.left, rhFrame.leHeight+rc.top, plo, null, 0);
						bi.addInstance(2, pLayer);
						if (rc.top+bi.height>rhFrame.leHeight)
						{
							bi=new CBackInstance(rhApp, rc.left, rc.top-rhFrame.leHeight, plo, null, 0);
							bi.addInstance(5, pLayer);
						}
					}

				}
			}
		}
		
		public function scrollLayers():void
		{
			var l:int;
			var layer:CLayer;
			
			var x:Number = rh3DisplayX;				//; Taille de la fenetre d'affichage
			var y:Number = rh3DisplayY;
			
			var dx:Number, dy:Number;
			for (l=0; l<rhFrame.nLayers; l++)
			{
				layer=rhFrame.layers[l];
				dx=x*layer.xCoef+layer.dx;
				dy=y*layer.yCoef+layer.dy;
				//				layer.dx=0;
				//				layer.dy=0;
				
				
				var bWrapHorz:Boolean = ((layer.dwOptions & CLayer.FLOPT_WRAP_HORZ) != 0);
				var bWrapVert:Boolean = ((layer.dwOptions & CLayer.FLOPT_WRAP_VERT) != 0);
				if (bWrapHorz)
				{
					if (dx<0)
					{
						dx=dx%rhFrame.leWidth+rhFrame.leWidth;
					}
					if (dx>rhFrame.leWidth)
					{
						dx=dx%rhFrame.leWidth;
					}
				}
				if (bWrapVert)
				{
					if (dy<0)
					{
						dy=dy%rhFrame.leHeight+rhFrame.leHeight;
					}
					if (dy>rhFrame.leHeight)
					{
						dy=dy%rhFrame.leHeight;
					}
				}
				layer.x=dx;
				layer.y=dy;
				layer.planeBack.x=-dx+rhApp.xOffset;
				layer.planeBack.y=-dy+rhApp.yOffset;
				layer.planeQuickDisplay.x=-dx+rhApp.xOffset;				
				layer.planeQuickDisplay.y=-dy+rhApp.yOffset;
				layer.planeSprites.x=-dx+rhApp.xOffset;
				layer.planeSprites.y=-dy+rhApp.yOffset;								
			} 		
			rhFrame.leX=rh3DisplayX;
			rhFrame.leY=rh3DisplayY;			
		}
		
		// Cache / Montre un layer
		// -----------------------
		public function hideLayer(nLayer:int):void
		{
			if (nLayer>=0 && nLayer<rhFrame.nLayers)
			{
				var layer:CLayer=rhFrame.layers[nLayer];
				layer.hide();
			}
		}
		public function showLayer(nLayer:int):void
		{
			if (nLayer>=0 && nLayer<rhFrame.nLayers)
			{
				var layer:CLayer=rhFrame.layers[nLayer];
				layer.show();
			}		
		}
		public function hideShowLayers():void
		{
			var n:int;
			for (n=0; n<rhFrame.nLayers; n++)
			{
				var layer:CLayer=rhFrame.layers[n];
				if (layer.dwOptions&CLayer.FLOPT_TOHIDE)
				{
					layer.hide();					
				}
			}
		}
		
		// Centre le display en respectant les bords
		// -----------------------------------------
		public function setDisplay(x:int, y:int, nLayer:int, flags:int):void
		{
			x -= rh3WindowSx / 2;				//; Taille de la fenetre d'affichage
			y -= rh3WindowSy / 2;
			
			var xf:Number = Number(x);
			var yf:Number = Number(y);
			
			if (nLayer != -1 && nLayer < rhFrame.nLayers)
			{
				var pLayer:CLayer = rhFrame.layers[nLayer];
				if (pLayer.xCoef > 1.0)
				{
					var dxf:Number = (xf - rhWindowX);
					dxf /= pLayer.xCoef;
					xf = rhWindowX + dxf;
				}
				if (pLayer.yCoef > 1.0)
				{
					var dyf:Number = (yf - rhWindowY);
					dyf /= pLayer.yCoef;
					yf = rhWindowY + dyf;
				}
			}
			
			x = int(xf);
			y = int(yf);
			
			// En mode jeu, on limite aux bordures du terrain...
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if (x < 0)
			{
				x = 0;					// Sort à haut/gauche?
			}
			if (y < 0)
			{
				y = 0;
			}
			var x2:int = x + rh3WindowSx;	// Sort a droite/bas?
			var y2:int = y + rh3WindowSy;
			if (x2 > rhLevelSx)
			{
				x2 = rhLevelSx - rh3WindowSx;
				if (x2 < 0)
				{
					x2 = 0;
				}
				x = x2;
			}
			if (y2 > rhLevelSy)
			{
				y2 = rhLevelSy - rh3WindowSy;
				if (y2 < 0)
				{
					y2 = 0;
				}
				y = y2;
			}
			
			// Pour la fin de la boucle...
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if ((flags & 1) != 0)
			{
				if (x != rhWindowX)
				{
					rh3DisplayX = x;
					rh3Scrolling |= RH3SCROLLING_SCROLL;
				}
			}
			if ((flags & 2) != 0)
			{
				if (y != rhWindowY)
				{
					rh3DisplayY = y;
					rh3Scrolling |= RH3SCROLLING_SCROLL;
				}
			}
		}
		
		// -----------------------------------------------------------------------
		// SCROLLING DU TERRAIN, UPDATE LES POSITIONS
		// -----------------------------------------------------------------------
		public function updateWindowPos(newX:int, newY:int):void
		{
			// Change le pointeurs dans le segment de base
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			// Deltas pour le C
			var noMove:int = 0;
			rh4WindowDeltaX = newX - rhWindowX;
			if (rh4WindowDeltaX != 0)
			{
				noMove++;
			}
			rh4WindowDeltaY = newY - rhWindowY;
			if (rh4WindowDeltaY != 0)
			{
				noMove++;
			}
			
			// Scan layers and check if dx/dy != 0
			var pLayer:CLayer;
			var i:int;
			if (noMove == 0)
			{
				for (i = 0; i < rhFrame.nLayers; i++)
				{
					pLayer = rhFrame.layers[i];
					if (pLayer.dx != 0 || pLayer.dy != 0)
					{
						noMove++;
						break;
					}
				}
			}
			
			// Store variables for faster access in object loop
			var nOldX:int = rhWindowX;
			var nOldY:int = rhWindowY;
			var nNewX:int = newX;
			var nNewY:int = newY;
			var nDeltaX:int = rh4WindowDeltaX;
			var nDeltaY:int = rh4WindowDeltaY;
			
			// Coordonnees limites de gestion
			rhWindowX = newX;									// Minimum gestion droite
			rh3XMinimum = newX - COLMASK_XMARGIN;
			if (rh3XMinimum < 0)
			{
				rh3XMinimum = rh3XMinimumKill;
			}
			
			rhWindowY = newY;									// Minimum gestion haut
			rh3YMinimum = newY - COLMASK_YMARGIN;
			if (rh3YMinimum < 0)
			{
				rh3YMinimum = rh3YMinimumKill;
			}
			
			rh3XMaximum = newX + rh3WindowSx + COLMASK_XMARGIN;	// Maximum gestion droite
			if (rh3XMaximum > rhLevelSx)
			{
				rh3XMaximum = rh3XMaximumKill;
			}
			
			rh3YMaximum = newY + rh3WindowSy + COLMASK_YMARGIN;	// Maximum gestion bas
			if (rh3YMaximum > rhLevelSy)
			{
				rh3YMaximum = rh3YMaximumKill;
			}
			
			
			// Reaffiche tous les objets du terrain en changeant eventuellement leurs coordonnees
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var count:int = 0;
			var nObjects:int;
			for (nObjects = 0; nObjects < rhNObjects; nObjects++)
			{
				while (rhObjectList[count] == null)
				{
					count++;
				}
				var pHo:CObject = rhObjectList[count];
				count++;
				
				if (noMove != 0)
				{
					if ((pHo.hoOEFlags & CObjectCommon.OEFLAG_SCROLLINGINDEPENDANT) != 0)
					{
						var x:int = nDeltaX;
						var y:int = nDeltaY;
						
						if (pHo.rom == null)
						{
							pHo.hoX += x;
							pHo.hoY += y;
						}
						else
						{
							x += pHo.hoX;
							y += pHo.hoY;
							pHo.rom.rmMovement.setXPosition(x);
							pHo.rom.rmMovement.setYPosition(y);
						}
					}
					else
					{
						var nLayer:int = pHo.hoLayer;
						if (nLayer < rhFrame.nLayers)
						{
							var oldLayerDx:int = nOldX;
							var oldLayerDy:int = nOldY;
							var newLayerDx:int = nNewX;
							var newLayerDy:int = nNewY;
							
							pLayer = rhFrame.layers[nLayer];
							if ((pLayer.dwOptions & CLayer.FLOPT_XCOEF) != 0)
							{
								oldLayerDx = (pLayer.xCoef * oldLayerDx);
								newLayerDx = (pLayer.xCoef * newLayerDx);
							}
							if ((pLayer.dwOptions & CLayer.FLOPT_YCOEF) != 0)
							{
								oldLayerDy = (pLayer.yCoef * oldLayerDy);
								newLayerDy = (pLayer.yCoef * newLayerDy);
							}
							
							// Equivalent
							var nX:int = (pHo.hoX + oldLayerDx) - newLayerDx + nDeltaX - pLayer.dx;
							var nY:int = (pHo.hoY + oldLayerDy) - newLayerDy + nDeltaY - pLayer.dy;
							
							if ((pHo.hoOEFlags & CObjectCommon.OEFLAG_MOVEMENTS) == 0)
							{
								pHo.hoX = nX;
								pHo.hoY = nY;
							}
							else
							{
								//trace(pHo.hoOiList.oilName +" Y: "+nY+" hoY: "+pHo.hoY);
								pHo.rom.rmMovement.setXPosition(nX);
								pHo.rom.rmMovement.setYPosition(nY);
							}
						}
					}
					
					if ((pHo.hoOEFlags & CObjectCommon.OEFLAG_BACKGROUND) == 0)					// protection ajoutée build 96: crash si Q/A object + scrolling
					{
						pHo.modif();
					}
				}
				else if ((pHo.hoOEFlags & CObjectCommon.OEFLAG_BACKGROUND) == 0)
				{
					pHo.modif();
				}
			}
		}
				
		public function doScroll():void
		{
			if ((rh3Scrolling & RH3SCROLLING_SCROLL) != 0)
			{
				rh3Scrolling = 0;
				
				// Si meme coordonnees, tout reafficher
				if (rhFrame.leX != rh3DisplayX || rhFrame.leY != rh3DisplayY)
				{
					scrollLayers();
					updateWindowPos(rhFrame.leX, rhFrame.leY);
				}
				rh3DisplayX = rhWindowX;
				rh3DisplayY = rhWindowY;
			}			
		}
		
		public function activeToBackdrop(pHo:CObject, colType:int):void
		{
			var pLayer:CLayer=rhFrame.layers[pHo.hoLayer];
			var image:CImage=rhApp.imageBank.getImageFromHandle(pHo.roc.rcImage);
			var bi:CBackInstance=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x, pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
			bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
			bi.addInstance(0, pLayer);
						
			var bWrapHorz:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_HORZ) != 0);
			var bWrapVert:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_VERT) != 0);
			
			// Wrap
			if (bWrapHorz)
			{
				bi=new CBackInstance(rhApp, rhFrame.leWidth+pHo.hoX-rhWindowX+pLayer.x, pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
				bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
				bi.addInstance(1, pLayer);
				if (pHo.hoX+bi.width>rhFrame.leWidth)
				{
					bi=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x-rhFrame.leWidth, pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
					bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
					bi.addInstance(4, pLayer);
				}
				if (bWrapVert)
				{
					bi=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x, rhFrame.leHeight+pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
					bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
					bi.addInstance(2, pLayer);
					bi=new CBackInstance(rhApp, rhFrame.leWidth+pHo.hoX-rhWindowX+pLayer.x, rhFrame.leHeight+pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
					bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
					bi.addInstance(3, pLayer);
					if (pHo.hoY+bi.height>rhFrame.leHeight)
					{
						bi=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x, pHo.hoY-rhWindowY+pLayer.y-rhFrame.leHeight, null, image, colType);
						bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
						bi.addInstance(5, pLayer);
					}
				}							
			}
			else if (bWrapVert)
			{
				bi=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x, rhFrame.leHeight+pHo.hoY-rhWindowY+pLayer.y, null, image, colType);
				bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
				bi.addInstance(2, pLayer);
				if (pHo.hoY+bi.height>rhFrame.leHeight)
				{
					bi=new CBackInstance(rhApp, pHo.hoX-rhWindowX+pLayer.x, pHo.hoY-rhWindowY+pLayer.y-rhFrame.leHeight, null, image, colType);
					bi.setTransparency((Number(128-pHo.ros.rsTransparency))/128.0);
					bi.addInstance(5, pLayer);
				}
			}
			// Add backdrop to physical world
			if (rh4Box2DObject && rh4Box2DBase != null)
			{
				if (bi.obstacleType == COC.OBSTACLE_SOLID || bi.obstacleType == COC.OBSTACLE_PLATFORM)
				{
					bi.body = rh4Box2DBase.rAddABackdrop(pHo.hoX-pHo.hoImgXSpot-rhWindowX+pLayer.x, pHo.hoY-pHo.hoImgYSpot-rhWindowY+pLayer.y, pHo.roc.rcImage, colType);
				}
			}
			
			
		}
		
		public function addBackdrop(srceImage:CImage, x:int, y:int, layer:int, colType:int	):void
		{
			var pLayer:CLayer=rhFrame.layers[layer];
			var bi:CBackInstance=new CBackInstance(rhApp, x-rhWindowX+pLayer.x, y-rhWindowX+pLayer.y, null, srceImage, colType);
			bi.addInstance(0, pLayer);	
			var bWrapHorz:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_HORZ) != 0);
			var bWrapVert:Boolean = ((pLayer.dwOptions & CLayer.FLOPT_WRAP_VERT) != 0);
			
			// Wrap
			if (bWrapHorz)
			{
				bi=new CBackInstance(rhApp, rhFrame.leWidth+x-rhWindowX+pLayer.x, y-rhWindowY+pLayer.y, null, srceImage, colType);
				bi.addInstance(1, pLayer);
				if (x+bi.width>rhFrame.leWidth)
				{
					bi=new CBackInstance(rhApp, x-rhWindowX+pLayer.x-rhFrame.leWidth, y-rhWindowY+pLayer.y, null, srceImage, colType);
					bi.addInstance(4, pLayer);
				}
				if (bWrapVert)
				{
					bi=new CBackInstance(rhApp, x-rhWindowX+pLayer.x, rhFrame.leHeight+y-rhWindowY+pLayer.y, null, srceImage, colType);
					bi.addInstance(2, pLayer);
					bi=new CBackInstance(rhApp, rhFrame.leWidth+x-rhWindowX+pLayer.x, rhFrame.leHeight+y-rhWindowY+pLayer.y, null, srceImage, colType);
					bi.addInstance(3, pLayer);
					if (y+bi.height>rhFrame.leHeight)
					{
						bi=new CBackInstance(rhApp, x-rhWindowX+pLayer.x, y-rhWindowY+pLayer.y-rhFrame.leHeight, null, srceImage, colType);
						bi.addInstance(5, pLayer);
					}
				}							
			}
			else if (bWrapVert)
			{
				bi=new CBackInstance(rhApp, x-rhWindowX+pLayer.x, rhFrame.leHeight+y-rhWindowY+pLayer.y, null, srceImage, colType);
				bi.addInstance(2, pLayer);
				if (y+bi.height>rhFrame.leHeight)
				{
					bi=new CBackInstance(rhApp, x-rhWindowX+pLayer.x, y-rhWindowY+pLayer.y-rhFrame.leHeight, null, srceImage, colType);
					bi.addInstance(5, pLayer);
				}
			}

			
		}
		public function deleteAllBackdrop2(layer:int):void
		{
			if (layer<0 || layer>=rhFrame.nLayers)
			{
				return;
			}
			var pLayer:CLayer=rhFrame.layers[layer];
			pLayer.deleteAddedBackdrops();
			
			// Force redraw
			pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
			rh3Scrolling |= RH3SCROLLING_REDRAWLAYERS;

		}    
		public function deleteBackdropAt(layer:int, xx:int, yy:int, fine:Boolean):void
		{
			if (layer<0 || layer>=rhFrame.nLayers)
			{
				return;
			}
			var pLayer:CLayer=rhFrame.layers[layer];
			var bSomethingDeleted:Boolean = pLayer.deleteAddedBackdropsAt(xx-rhWindowX, yy-rhWindowY, fine);
			
			// Force redraw
			if (bSomethingDeleted)
			{
				pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
				rh3Scrolling |= RH3SCROLLING_REDRAWLAYERS;
			}

		}
		
		// -------------------------------------------------------------------------
		// STOCKAGE GLOBAL POUR LES EXTENSIONS
		// -------------------------------------------------------------------------    
		public function getStorage(id:int):CExtStorage
		{
			if (rhApp.extensionStorage != null)
			{
				var n:int;
				for (n = 0; n < rhApp.extensionStorage.size(); n++)
				{
					var e:CExtStorage = CExtStorage(rhApp.extensionStorage.get(n));
					if (e.id == id)
					{
						return e;
					}
				}
			}
			return null;
		}
		
		public function delStorage(id:int):void
		{
			if (rhApp.extensionStorage != null)
			{
				var n:int;
				for (n = 0; n < rhApp.extensionStorage.size(); n++)
				{
					var e:CExtStorage = CExtStorage(rhApp.extensionStorage.get(n));
					if (e.id == id)
					{
						rhApp.extensionStorage.removeIndex(n);
					}
				}
			}
		}
		
		public function addStorage(data:CExtStorage, id:int):void
		{
			var e:CExtStorage = getStorage(id);
			if (e == null)
			{
				if (rhApp.extensionStorage == null)
				{
					rhApp.extensionStorage = new CArrayList();
				}
				data.id = id;
				rhApp.extensionStorage.add(data);
			}
		}
		
		public function setFocus():void
		{
			var count:int=0;
			var nObject:int;
			var hoPtr:CObject;	
			for (nObject=0; nObject<rhNObjects; nObject++)
			{
				while(rhObjectList[count]==null)
					count++;
				hoPtr=rhObjectList[count];
				count++;
				
				if (hoPtr is CExtension)
				{
					if (rh2MouseX>=hoPtr.hoX && rh2MouseX<hoPtr.hoX+hoPtr.hoImgWidth
						&& rh2MouseY>=hoPtr.hoY && rh2MouseY<hoPtr.hoY+hoPtr.hoImgHeight)
					{
						(CExtension(hoPtr)).setFocus(true);
					}
					else
					{
						(CExtension(hoPtr)).setFocus(false);
					}
				}
			}
		}
		
		public function click():void
		{
			var count:int=0;
			var nObject:int;
			var hoPtr:CObject;	
			for (nObject=0; nObject<rhNObjects; nObject++)
			{
				while(rhObjectList[count]==null)
					count++;
				hoPtr=rhObjectList[count];
				count++;
				
				if (hoPtr is CExtension)
				{
					(CExtension(hoPtr)).click();
				}
			}
		}
		public function doubleClick():void
		{
			var count:int=0;
			var nObject:int;
			var hoPtr:CObject;	
			for (nObject=0; nObject<rhNObjects; nObject++)
			{
				while(rhObjectList[count]==null)
					count++;
				hoPtr=rhObjectList[count];
				count++;
				
				if (hoPtr is CExtension)
				{
					(CExtension(hoPtr)).doubleClick();
				}
			}
		}
		
		public function getDir(hoPtr:CObject):int {
			if (hoPtr.rom != null)
				return hoPtr.rom.rmMovement.getDir();
			return hoPtr.roc.rcDir;
		}
		
		public function CreateBodies():void {
			var pBase:CRunBaseParent= this.GetBase();
			if (pBase == null)
				return;
			
			var pOL:int=0;
			var nObjects:int;
			var pHo:CObject=null;
			var flag:Boolean= false;
			for (nObjects=0; nObjects<rhNObjects; pOL++, nObjects++)
			{
				while(rhObjectList[pOL]==null) pOL++;
				pHo=rhObjectList[pOL];
				if (pHo.hoType>=32)
				{
					if (pHo.hoCommon.ocIdentifier==CRun.FANIDENTIFIER
						|| pHo.hoCommon.ocIdentifier==CRun.TREADMILLIDENTIFIER
						|| pHo.hoCommon.ocIdentifier == CRun.PARTICULESIDENTIFIER
						|| pHo.hoCommon.ocIdentifier == CRun.ROPEANDCHAINIDENTIFIER
						|| pHo.hoCommon.ocIdentifier == CRun.MAGNETIDENTIFIER
						|| pHo.hoCommon.ocIdentifier==CRun.BASEIDENTIFIER
					)
					{
						var pBaseParent:CRunBaseParent= CRunBaseParent(CExtension(pHo).ext);
						pBaseParent.rStartObject();
					}
				}
			}
			pOL=0;
			var mvPtr:CMoveDefExtension= null;
			var pMoveExtension:CMoveExtension= null;
			var pRunMBase:CRunMBase= null;
			
			for (nObjects=0; nObjects<rhNObjects; pOL++, nObjects++)
			{
				while(rhObjectList[pOL]==null) pOL++;
				pHo=rhObjectList[pOL];
				if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)!=0)
				{
					flag = false;
					if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
					{
						mvPtr = CMoveDefExtension(pHo.hoCommon.ocMovements.moveList[pHo.rom.rmMvtNum]);
						if(CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2d8directions") 
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dspring")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dspaceship")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dstatic")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dracecar")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2daxial")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dplatform")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbouncingball")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbackground")
						)
						{
							pMoveExtension = CMoveExtension(pHo.rom.rmMovement);
							pRunMBase = CRunMBase(pMoveExtension.movement);
							pRunMBase.CreateBody();
							flag = true;
						}
					}
					if (flag == false && pHo.hoType == 2)
					{
						pBase.rAddNormalObject(pHo);
					}
				}
			}
			pOL=0;
			for (nObjects=0; nObjects<rhNObjects; pOL++, nObjects++)
			{
				while(rhObjectList[pOL]==null) pOL++;
				pHo=rhObjectList[pOL];
				if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)!=0)
				{
					flag = false;
					if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
					{
						mvPtr = CMoveDefExtension(pHo.hoCommon.ocMovements.moveList[pHo.rom.rmMvtNum]);
						if(CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2d8directions") 
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dspring")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dspaceship")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dstatic")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dracecar")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2daxial")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dplatform")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbouncingball")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbackground")
						)
						{
							pMoveExtension = CMoveExtension(pHo.rom.rmMovement);
							pRunMBase = CRunMBase(pMoveExtension.movement);
							pRunMBase.CreateJoint();
						}
					}
				}
			}
		}
		
		public function GetBase():CRunBaseParent {
			if (rh4Box2DSearched == false)
			{
				rh4Box2DSearched = true;
				rh4Box2DBase = null;
				
				var pOL:int= 0;
				var nObjects:int;
				for (nObjects = 0; nObjects < rhNObjects; pOL++, nObjects++)
				{
					while (rhObjectList[pOL] == null) pOL++;
					var pHo:CObject= rhObjectList[pOL];
					if (pHo.hoType >= 32)
					{
						if (pHo.hoCommon.ocIdentifier == CRun.BASEIDENTIFIER)
						{
							rh4Box2DBase = CRunBaseParent(CExtension(pHo).ext);
							break;
						}
					}
				}
			}
			return rh4Box2DBase;
		}
		public function GetMBase(pHo:CObject):CRunMBase
		{
			if (rh4Box2DObject && pHo != null && (pHo.hoFlags & CObject.HOF_DESTROYED) == 0)
			{
				if ((pHo.hoOEFlags&CObjectCommon.OEFLAG_MOVEMENTS)!=0)
				{
					if (pHo.roc.rcMovementType==CMoveDef.MVTYPE_EXT)
					{
						var mvPtr:CMoveDefExtension = CMoveDefExtension(pHo.hoCommon.ocMovements.moveList[pHo.rom.rmMvtNum]);
						if(CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2d8directions") 
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName, "box2dspring")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dspaceship")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dstatic")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dracecar")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2daxial")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dplatform")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbouncingball")
							|| CServices.compareStringsIgnoreCase(mvPtr.moduleName,"box2dbackground")
						)
						{
							return CRunMBase(CMoveExtension(pHo.rom.rmMovement).movement);
						}
					}
				}
			}
			return null;
		}
	}	
}