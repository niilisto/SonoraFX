//----------------------------------------------------------------------------------
//
// CRUNAPP : Classe Application
//
//----------------------------------------------------------------------------------

package Application 
{
	import Banks.*;
	
	import Expressions.*;
	
	import Extensions.CExtLoader;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import mx.core.ByteArrayAsset;
	import mx.managers.SystemManager;
	
	
	public class CRunApp 
	{
		public static var RUNTIME_VERSION:int=0x0302;
		public static var MAX_PLAYER:int=4;
		public static var MAX_KEY:int=8;
		public const GA_NOHEADING:int=0x0002;
		public const GA_SPEEDINDEPENDANT:int=0x0008;
		public const GA_STRETCH:int=0x0010;
		public const GA_MENUHIDDEN:int=0x0080;
		public const GA_MENUBAR:int=0x0100;
		public const GA_MAXIMISE:int=0x0200;
		public const GA_MIX:int=0x0400;
		public const GA_FULLSCREENATSTART:int = 0x0800;
		public static var GANF_SAMPLESOVERFRAMES:int=0x0001;
		public const GANF_RUNFRAME:int=0x0004;
		public const GANF_NOTHICKFRAME:int=0x0040;
		public const GANF_DONOTCENTERFRAME:int=0x0080;
		public const GANF_DISABLE_CLOSE:int=0x0200;
		public const GANF_HIDDENATSTART:int=0x0400;
		public const GAOF_JAVASWING:int=0x1000;
		public const GAOF_JAVAAPPLET:int=0x2000;
		public static var SL_RESTART:int=0;
		public static var SL_STARTFRAME:int=1;
		public static var SL_FRAMEFADEINLOOP:int=2;
		public static var SL_FRAMELOOP:int=3;
		public static var SL_FRAMEFADEOUTLOOP:int=4;
		public static var SL_ENDFRAME:int=5;		
		public static var SL_QUIT:int=6;
		public static var SL_WAITFORMOCHI:int=7;
		
		public static var MAX_VK:int=261;

		public static var CTRLTYPE_MOUSE:int=0;	
		public static var CTRLTYPE_JOY1:int=1;
		public static var CTRLTYPE_JOY2:int=2;
		public static var CTRLTYPE_JOY3:int=3;
		public static var CTRLTYPE_JOY4:int=4;
		public static var CTRLTYPE_KEYBOARD:int=5;
		public static var ARF_INGAMELOOP:int=0x0004;
		public static var BUILDFLAG_TEST:int=0x0080;
    
		public var frameOffsets:Array;
		public var frameEffects:Array;
		public var frameEffectParams:Array;
		public var frameMaxIndex:int=0;
		public var framePasswords:Array;
		public var appName:String;
		public var appCopyright:String;
		public var appAboutText:String;
		public var appDoc:String;
		public var nGlobalValuesInit:int;
		public var globalValuesInitTypes:Array;
		public var globalValuesInit:Array;
		public var nGlobalStringsInit:int;
		public var globalStringsInit:Array;
		public var OIList:COIList;
		public var imageBank:CImageBank;
		public var fontBank:CFontBank;
		public var soundBank:CSoundBank;
		public var soundPlayer:CSoundPlayer;
		public var appRunningState:int;
		public var lives:Array;
		public var scores:Array;
		public var playerNames:Array;
		public var gValues:CArrayList;
		public var gStrings:CArrayList;
		public var tempGValue:CValue;
		public var startFrame:int;
		public var nextFrame:int;
		public var currentFrame:int;
		//public var mochiFrame:int;
		//public var mochiFrameLast:int=-1;
		public var frame:CRunFrame;
		public var ccj:ByteArrayAsset;
		public var file:CFile;
		public var parentApp:CRunApp;
		public var parentOptions:int;
		public var parentWidth:int;
		public var parentHeight:int;
		public var refTime:int;
		public var run:CRun;
    
		// Application header
		public var xOffset:int;
		public var yOffset:int;
		public var gaFlags:int;				// Flags
		public var gaNewFlags:int;				// New flags
		public var gaMode:int;				// graphic mode
		public var gaOtherFlags:int;				// Other Flags	
		public var gaCxWin:int;				// Window x-size
		public var gaCyWin:int;				// Window y-size
		public var gaScoreInit:int;				// Initial score
		public var gaLivesInit:int;				// Initial number of lives
		public var gaBorderColour:uint;				// Border colour
		public var gaNbFrames:int;				// Number of frames
		public var gaFrameRate:int;				// Number of frames per second
		public var pcCtrlType:Array;		// Control type per player (0=mouse,1=joy1, 2=joy2, 3=keyb)
		public var pcCtrlKeys:Array;	// Control keys per player
		public var frameHandleToIndex:Array;
		public var frameMaxHandle:int;
		public var cx:int;
		public var cy:int;
		public var pathname:String;
		public var appPathname:String;
		public var extPathname:String;
		public var jarPathname:String;
		public var appEditorFilename:String;
		public var appTargetFilename:String;
		public var appArgs:String;
		public var mouseX:int;
		public var mouseY:int;
		public var keyBuffer:ByteArray;
		
		public var cursorCount:int;
		public var pLoadFilename:String;
		public var appRunFlags:int;
		public var adGO:CArrayList;
		public var sysEvents:CArrayList;
		public var quit:Boolean;
		public var m_bLoading:Boolean;
		public var stage:Stage;
		public var mainSprite:Sprite;
	    public var extensionStorage:CArrayList;
    	public var extLoader:CExtLoader;
	    public var embeddedFiles:Array;
		public var doubleClickTime:int;
		public var planeControls:Sprite;
		public var adClip:MovieClip;
		//public var mochiStart:CMoStart;
		public var bUnicode:Boolean;
		public var sounds:Array;
		public var flashVars:Object;
		public var keyNew:Boolean;
		public var xMouseOffset:int;
		public var yMouseOffset:int;
		public var bPreloader:Boolean;
		public var preloaderTotal:int;
		public var preloaderLoaded:int;
		public var deltaWheel:int;
		public var embeddedFonts:Array;
		public var debugShape:Shape;			// Debuggage masques>
		public var startDemoWarning:int;
		public var demoWarning:CDemoWarning;
//		public var debugValue:int;
		public var loaderInfo:LoaderInfo;
		public var bFlashAd:Boolean;
		public var bShiftFrameNumber:Boolean;
		public var bActivated:Boolean;
		public var bMouseIn:Boolean;
		public var effect:int;
		public var effectParam:int;
		public var alpha:int;
		
		// AppHeader2
		public var dwOptions:int;
		public var dwBuildType:int;
		public var dwBuildFlags:int;
		public var wScreenRatioTolerance:int;
		public var wScreenAngle:int;			// 0 (no rotation), 1 (90 clockwise), 2 (90 anticlockwise)
//		public static var debug:String;

		
		public static var data:Array=
		[0xD2, 0x30, 0xCC, 0xB6, 0x87, 0x9D, 0x95, 0x0E, 0xCA];


		public function CRunApp(application:ByteArrayAsset, s:Stage, fv:Object, li:LoaderInfo) 
		{
			loaderInfo=li;
			ccj=application;
			stage=s;
			flashVars=fv;	
			sounds=null;
			keyNew=false;
			bPreloader=false;
			deltaWheel=0;
			embeddedFonts=null;
			demoWarning=null;
			startDemoWarning=0;
		}
		public function setDemoWarning(warning:int):void
		{
			startDemoWarning=warning;
		}
		public function setSounds(s:Array):void
		{
			sounds=s;	
		}
		public function setFonts(f:Array):void
		{
			var nFonts:int=f.length;
			embeddedFonts=new Array(nFonts);
			var n:int;
			for (n=0; n<nFonts; n++)
			{
				var font:Class=Class(f[n]);
				Font.registerFont(font);
				embeddedFonts[n]=new font();
			}
		}
		public function getEmbeddedFont(name:String):int
		{
			var nFont:int=-1;
			if (embeddedFonts!=null)
			{
				var n:int;
				for (n=0; n<embeddedFonts.length; n++)
				{
					if (embeddedFonts[n].fontName==name)
					{
						nFont=n;
						break;
					}
				}
			}
			return nFont;
		}
	    public function setParentApp(pApp:CRunApp, sFrame:int, options:int, sprite:Sprite, width:int, height:int):void
	    {
	        parentApp = pApp;
	        parentOptions = options;
	       	mainSprite=sprite;
	        startFrame = sFrame;
	        parentWidth = width;
	        parentHeight = height;
			mainSprite.scrollRect=new Rectangle(0, 0, width, height);
	        embeddedFonts=parentApp.embeddedFonts;
	    }
		
		public function changeWindowDimensions(width:int, height:int):void 
		{
			if (width>=0)
				gaCxWin=width;
			if (height>0)
				gaCyWin=height;
			if (frame!=null)
			{
				if (width>0)
				{
					frame.leEditWinWidth = width;
					frame.leWidth=width;
					frame.leVirtualRect.right = width;
				}
				if (height>0)
				{
					frame.leEditWinHeight = height;
					frame.leHeight=height;
					frame.leVirtualRect.bottom = height;
				}
				
				run.updateFrameDimensions(width, height);
			}
		}
		
		public function setPreloader(sp:Sprite):void
	    {
	    	parentApp=null;
	    	mainSprite=sp;
	    	bPreloader=true;
	    }
	    public function setPreloaderProgress(total:int, loaded:int):void
	    {
	    	preloaderTotal=total;
	    	preloaderLoaded=loaded;
	    }
		public function load():void
		{
			file = new CFile(ccj);
	
			// Charge le mini-header
			var b:ByteArray=file.readBuffer(4);
			bUnicode=false;
			if (b[0]==80 && b[1]==65 && b[2]==77 && b[3]==85)		// "PAMU"
			{
				bUnicode=true;
			} 
			file.setUnicode(bUnicode);
			file.skipBytes(2);			// gaVersion
			file.skipBytes(2);			// gaSubVersion
			file.skipBytes(4);			// gaPrdVersion
			file.skipBytes(4);		    // gaPrdBuild

			// Reserve les objets
			OIList=new COIList();
			imageBank=new CImageBank(this);
			fontBank=new CFontBank();
			soundBank=new CSoundBank(this);
			soundPlayer=new CSoundPlayer(this);
        
			// Lis les chunks
			var chk:CChunk=new CChunk();
			var posEnd:int;
			var nbPass:int = 0, n:int
			while (chk.chID!=CChunk.CHUNK_LAST)
			{
				chk.readHeader(file);    
				if (chk.chSize == 0)
				{
					continue;
				}
				posEnd=file.getFilePointer()+chk.chSize;
				switch(chk.chID)
				{
				// CHUNK_APPHEADER
				case 0x2223:		
					loadAppHeader(file);
					// Buffer pour les offsets frame
					frameOffsets=new Array(gaNbFrames);
					frameEffects=new Array(gaNbFrames);
					frameEffectParams=new Array(gaNbFrames);
					// Pour les password
					framePasswords=new Array(gaNbFrames);
					for (n = 0; n < gaNbFrames; n++)
					{
						framePasswords[n] = null;
					}
					break;
				// CHUNK_APPHDR2
				case 0x2245:
					dwOptions=file.readAInt();
					dwBuildType=file.readAInt();
					dwBuildFlags=file.readAInt();
					wScreenRatioTolerance=file.readAShort();
					wScreenAngle=file.readAShort();			// 0 (no rotation), 1 (90 clockwise), 2 (90 anticlockwise)
					break;
				// CHUNK_APPNAME
				case 0x2224:		
					appName=file.readAString();
					break;
				// CHUNK_COPYRIGHT
				case 0x223B:		
					appCopyright=file.readAString();
					break;
				// CHUNK_ABOUTTEXT
				case 0x223A:		
					appAboutText=file.readAString();
					break;
				// CHUNK_APPEDITORFILENAME:
//				case 0x222E:
//					appEditorFilename=file.readAString();
//					appEditorFilename=getParent(appEditorFilename);
//					break;
				// CHUNK_APPTARGETFILENAME:
//				case 0x222F:
//					appTargetFilename=file.readAString();
//					appTargetFilename=getParent(appTargetFilename);
//					break;
				// CHUNK_APPDOC
				case 0x2230:		
					appDoc=file.readAString();
					break;
				// CHUNK_GLOBALVALUES
				case 0x2232:	
					loadGlobalValues(file);
					break;
				// CHUNK_GLOBALSTRINGS
				case 0x2233:
					loadGlobalStrings(file);
					break;
				// CHUNK_FRAMEITEMS
				// CHUNK_FRAMEITEMS_2 
				case 0x2229:		
				case 0x223F:		
					OIList.preLoad(file);
					break;
				// CHUNK_FRAMEHANDLES
				case 0x222B:		
					loadFrameHandles(file, chk.chSize);
					break;

				// CHUNK_FRAME
				case 0x3333:		
					// Repere les positions des frames dans le fichier
					frameOffsets[frameMaxIndex]=file.getFilePointer();
					var frChk:CChunk=new CChunk();
					while (frChk.chID!=0x7F7F)		// CHUNK_LAST
					{
						frChk.readHeader(file);
						if (frChk.chSize == 0)
						{
							continue;
						}
						var frPosEnd:int=file.getFilePointer()+frChk.chSize;
			
						switch (frChk.chID)
						{
						// CHUNK_FRAMEHEADER
						case 0x3334:		
							break;
						// CHUNK_FRAMEPASSWORD			
						case 0x3336:	
							var pass:String=file.readAString();
							framePasswords[frameMaxIndex]=pass;
							nbPass++;
							break;
						// CHUNK_FRAMEEFFECTS
						case 0x3349:
							frameEffects[frameMaxIndex]=file.readAInt();
							frameEffectParams[frameMaxIndex]=file.readAInt();
							break;
						}
						file.seek(frPosEnd);
					}
					frameMaxIndex++;
					break;
                // CHUNK_EXTENSIONS2
                case 0x2234:
                    extLoader = new CExtLoader(this);
                    extLoader.loadList(file);
                    break;
                // CHUNK_BINARYFILES
                case 0x2238:
                    var nFiles:int=file.readAInt();
                    embeddedFiles=new Array(nFiles);
                    for (n=0; n<nFiles; n++)
                    {
                        embeddedFiles[n]=new CEmbeddedFile(this);
                        embeddedFiles[n].preLoad();
                    }                    
                    break;
				// CHUNK_IMAGE
				case 0x6666:
					imageBank.preLoad(file);
					break;
				// CHUNK_FONT
				case 0x6667:
					fontBank.preLoad(file);
					break;
				// CHUNK_SOUNDS
				case 0x6668:
					soundBank.preLoad(file);
					break;
				// CHUNK_MUSICS
				//case 0x6669:
				//	musicBank.preLoad(file);
				//	break;
				}
	    
				// Positionne a la fin du chunk
				file.seek(posEnd);
			}
	
			// Fixe le flags multiple samples
			soundPlayer.setMultipleSounds((gaFlags&GA_MIX)!=0);

			// Cree le sprite principal
			if (parentApp==null && bPreloader==false)
			{
				mainSprite=new Sprite();
				
				if ((stage.getChildByName("root1") as SystemManager)!=null)
				{
					(stage.getChildByName("root1") as SystemManager).addChild(mainSprite);	
				}
				else
				{
					stage.addChild(mainSprite);
				}
			}
		}
		// Lancement de l'application
		public function startApplication():void
		{
			

			// Initialisation des events 
			sysEvents = new CArrayList();
			keyBuffer=new ByteArray();
			var n:int;
			for (n=0; n<MAX_VK; n++)
			{
				keyBuffer.writeByte(0);
			}
			mainSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mainSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mainSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mainSprite.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			if (parentApp==null && bPreloader==false)
			{
				// Strech display
				if ((gaFlags&GA_STRETCH)!=0)
					stage.scaleMode = "exactFit";
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(Event.ENTER_FRAME, stepApplication);
				stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				stage.addEventListener(Event.ACTIVATE, onActivate);
				stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			}
			xMouseOffset=0;
			yMouseOffset=0;
			
			// Branche la boucle principale
			appRunningState=0;	    // SL_RESTART
			currentFrame=-2;
			
		}

		// Fait fonctionner l'application
		public function playApplication(bOnlyRestartApp:Boolean):Boolean
		{
   			// Le warning pour la démo?      
			if (startDemoWarning!=0)
			{
				if (demoWarning==null)
				{
					demoWarning=new CDemoWarning(this, startDemoWarning);
				}
				if (demoWarning.handle()==false)
				{
					return true; 
				}
				demoWarning=null;
				startDemoWarning=0;
			}
			
			var bLoop:Boolean=true;
			var bContinue:Boolean=true;
			do
			{
				switch (appRunningState)
				{
				// SL_RESTART
				case SL_RESTART:	   
					initGlobal();
					nextFrame=startFrame;
					appRunningState=1;		    
					killGlobalData();
                    // Build 248 : only restart application?
                    if (bOnlyRestartApp)
                    {
                        // Used in Sub-Applications, initializes application global data and exit
                        // (= don't execute the first frame loop now, it will be executed at the end
                        // of the first loop of the parent frame as usual)
                        bLoop = false;
                        break;
                    }
				// SL_STARTFRAME
				case SL_STARTFRAME:	    
					startTheFrame();
					//if (mochiStart.startIntroAd())
					//{
					//	return true;
					//}
					
					break;
				// SL_FRAMELOOP
				case SL_FRAMELOOP:	    
					if ( loopFrame()==false )
					{
						endFrame();
						//if (mochiStart.startFrameAd())
						//{
						//	mochiFrameLast=mochiFrame;
						//	return true;
						//}
					}
					else
					{
						bLoop = false;
					}
					break;
				// SL_ENDFRAME
				case SL_ENDFRAME:
					endFrame();
					//if (mochiStart.startFrameAd())
					//{
					//	mochiFrameLast=mochiFrame;
					//	return true;
					//}
					break;
				case SL_WAITFORMOCHI:
					appRunningState=SL_QUIT;
					break;
				default:
					bLoop=false;
					break;
				}
			} while(bLoop==true && quit==false);
	    
			// Quit ?
			if ( appRunningState == SL_QUIT )
			{
				//if (mochiFrame!=mochiFrameLast)
				//{
					//if (mochiStart.startEndAd())
					//{
					//	appRunningState=SL_WAITFORMOCHI;
					//	return true;
					//}
				//}
				bContinue = false;
			}

			// Continue?
			return bContinue;
		}

    public function onConnectError(status:String):void {
    	// handle error here...
    }


		// End application
		public function endApplication():void
		{
			// Remove listeners
			if (parentApp==null)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.removeEventListener(Event.ENTER_FRAME, stepApplication);
				stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				stage.removeEventListener(Event.ACTIVATE, onActivate);
				stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			}
			mainSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mainSprite.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mainSprite.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mainSprite.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			// Remove temp files
//			if (embeddedFiles!=null)
//			{
//				var n:int;
//				for (n=0; n<embeddedFiles.length; n++)
//				{
//					embeddedFiles[n].releaseFileAlways();
//				}
//				embeddedFiles=null;
//			}
        
			// Stop sounds 
			if (soundPlayer!=null)
			{
				soundPlayer.stopAllSounds();
			}
	
//			if (parentApp!=null)
//			{
//				// Ferme la fenetre / component
//			}
 	
			if (file!=null)
			{
				// Fin du programme
				file.close();
			} 
		}
		
		// Un cran d'animation
		public function stepApplication(event:Event):void
		{
			if (playApplication(false)==false)
			{
				endApplication();
			}
		}
		
		// Charge la frame
		public function startTheFrame():void
		{
			// Charge la frame
			if ( nextFrame!=currentFrame )
			{
				frame=new CRunFrame(this);
				frame.loadFullFrame(nextFrame);
			}
			currentFrame=nextFrame;
	    
			// Init runtime variables
			frame.leX = frame.leY = 0;
			frame.leLastScrlX = frame.leLastScrlY = 0;
			frame.rhOK = false;
			frame.levelQuit = 0;

			// Playfield = fond blanc
			if (parentApp==null)
			{
				mainSprite.graphics.clear();
				mainSprite.graphics.beginFill(gaBorderColour);
				mainSprite.graphics.drawRect(0, 0, gaCxWin, gaCyWin);
				mainSprite.graphics.endFill();
				
				setEffect(frameEffects[currentFrame], frameEffectParams[currentFrame]);
			}
			
			// Creates display planes
			var n:int;
			if (parentApp!=null)
			{
				xOffset=0;
				yOffset=0;	
			}
			else
			{
				xOffset=gaCxWin/2-frame.leEditWinWidth/2;
				yOffset=gaCyWin/2-frame.leEditWinHeight/2;
			}
			for (n=0; n<frame.nLayers; n++)
			{
				frame.layers[n].createPlanes(xOffset, yOffset);
			}
			
			// Ajout du plan control
			planeControls=new Sprite();
			planeControls.x=xOffset;
			planeControls.y=yOffset;
			mainSprite.addChild(planeControls);
			
/*			// DEBUGGAGE MASQUE
			debugShape=new Shape();
			debugShape.x=0;
			debugShape.y=0;
			planeControls.addChild(debugShape);
*/			
			// Flush du clavier
			flushKeyboard();
	
			// Init RUN LOOP
			run=new CRun(this, frame);

			// Init runloop
			run.initRunLoop(false);
			frame.rhPtr=run;			

			appRunningState = SL_FRAMELOOP;
		}

		public function resetLayers():void
		{
			if (parentApp!=null)
			{
				xOffset=0;
				yOffset=0;	
			}
			else
			{
				xOffset=gaCxWin/2-frame.leEditWinWidth/2;
				yOffset=gaCyWin/2-frame.leEditWinHeight/2;
			}
			var n:int;
			for (n=0; n<frame.nLayers; n++)
			{
				frame.layers[n].resetPlanes(xOffset, yOffset);
			}
			
			// Ajout du plan control
			planeControls.x=xOffset;
			planeControls.y=yOffset;			
		}
		
		// Un tour de boucle
		public function loopFrame():Boolean
		{
			if ( frame.levelQuit == 0 )
			{
				// One frame loop
				frame.levelQuit = run.doRunLoop();
			}
			return (frame.levelQuit==0);
		}
			    	
		// Sortie d'une boucle
		public function endFrame():void
		{
			var ul:int;

			// Stocke pour Mochi
			//mochiFrame=currentFrame;
			
			// Fin de la boucle => renvoyer code de sortie
			ul= run.killRunLoop(frame.levelQuit, false);

			// Run Frame?
			if ( (gaNewFlags&GANF_RUNFRAME)!=0 )
			{
				appRunningState=SL_QUIT;
			}
			// Calculer event en fonction du code de sortie
			else 
			{
				switch (CServices.LOWORD(ul)) 
				{
				// Next frame
				case 1:				// LOOPEXIT_NEXTLEVEL
					nextFrame=currentFrame+1;
					appRunningState=SL_STARTFRAME;
					break;

				// Previous frame
				case 2:				// LOOPEXIT_PREVLEVEL:
					nextFrame=Math.max(0, currentFrame-1);
					appRunningState=SL_STARTFRAME;
					break;
		    
				// Jump to frame
				case 3:				// LOOPEXIT_GOTOLEVEL:
					appRunningState=SL_STARTFRAME;
					if ( (CServices.HIWORD(ul)&0x8000)!=0 )			// Si flag 0x8000, numero de cellule direct
					{
						nextFrame=CServices.HIWORD(ul)&0x7FFF;
						if ( nextFrame>=gaNbFrames )
						{
							nextFrame=gaNbFrames-1;
						}
						if ( nextFrame<0 )
						{
							nextFrame=0;
						}
					}
					else											// Sinon, HCELL
					{
						if ( CServices.HIWORD(ul)<frameMaxHandle )
						{
							nextFrame=frameHandleToIndex[CServices.HIWORD(ul)];
							if ( nextFrame==-1 )
							{
								nextFrame=currentFrame+1;
							}
						}
						else
						{
							nextFrame=currentFrame+1;
						}
					}
					break;

				// Restart application
				case 4:				// LOOPEXIT_NEWGAME:
					// Restart application
					appRunningState=SL_RESTART;
					nextFrame=startFrame;
					break;

				// Quit
				default:
					appRunningState=SL_QUIT;
					break;
				}
			}

			if ( appRunningState == SL_STARTFRAME )
			{
				// If invalid frame number, quit current game
				if ( nextFrame<0 || nextFrame>=gaNbFrames )
				{
					appRunningState = SL_QUIT;
				}
			}

			// Flush keyboard
			flushKeyboard();

			// Unload current frame if frame change
			if ( appRunningState!=SL_STARTFRAME || nextFrame!=currentFrame )
			{
				// Vire les layers
				var n:int;
				for (n=0; n<frame.nLayers; n++)
				{
					frame.layers[n].deletePlanes();
				}
				mainSprite.removeChild(planeControls);

				// Unload frame
				frame=null;
				run=null;

				// Reset current frame
				currentFrame=-1;
			}
		}

		// RAZ des donnes objets globaux
		public function killGlobalData():void
		{
			adGO=null;
		}
		
		// Initialise les variables globales
		public function initGlobal():void
		{
			var n:int;
	
			// Vies et score
			if (parentApp==null || (parentApp!=null && (parentOptions&CCCA.CCAF_SHARE_LIVES)==0))
			{
				lives=new Array(MAX_PLAYER);
				for (n = 0; n < MAX_PLAYER; n++)
				{
					lives[n] = gaLivesInit ^ 0xFFFFFFFF;
				}
			}
			else
			{
				lives=null;
			}
			if (parentApp==null || (parentApp!=null && (parentOptions&CCCA.CCAF_SHARE_SCORES)==0))
			{
				scores=new Array(MAX_PLAYER);
				for (n = 0; n < MAX_PLAYER; n++)
				{
					scores[n] = gaScoreInit ^ 0xFFFFFFFF;
				}
			}
			else
			{
				scores=null;
			}
			playerNames=new Array(MAX_PLAYER);
			for (n = 0; n < MAX_PLAYER; n++)
			{
				playerNames[n] = new String("");
			}
	
			// Global values
			if (parentApp==null || (parentApp!=null && (parentOptions&CCCA.CCAF_SHARE_GLOBALVALUES)==0))
			{
				gValues=new CArrayList();
				for (n=0; n<nGlobalValuesInit; n++)
				{
					var val:CValue=new CValue(globalValuesInit[n]);
					gValues.add(val);
				}
			}
			else
			{
				gValues=null;
			}
			tempGValue=new CValue(0);
	
			// Global strings
			if (parentApp==null || (parentApp!=null && (parentOptions&CCCA.CCAF_SHARE_GLOBALVALUES)==0))
			{
				gStrings=new CArrayList();
				for (n=0; n<nGlobalStringsInit; n++)
				{
					gStrings.add(new String(globalStringsInit[n]));
				}
			}
			else
			{
				gStrings=null;
			}
		}

		// Retourne les vies et les scores
		public function getLives():Array
		{
			var app:CRunApp=this;
			while(app.lives==null)
			{
				app=app.parentApp;
			}
			return app.lives;
		}
		public function getScores():Array
		{
			var app:CRunApp=this;
			while(app.scores==null)
			{
				app=app.parentApp;
			}
			return app.scores;
		}
		// Retourne les controles joueur
		public function getCtrlType():Array
		{
			var app:CRunApp=this;
			while(app.parentApp!=null && (app.parentOptions&CCCA.CCAF_SHARE_PLAYERCTRLS)!=0)
			{
				app=app.parentApp;
			}
			return app.pcCtrlType;
		}
		public function getCtrlKeys():Array
		{
			var app:CRunApp=this;
			while(app.parentApp!=null && (app.parentOptions&CCCA.CCAF_SHARE_PLAYERCTRLS)!=0)
			{
				app=app.parentApp;
			}
			return app.pcCtrlKeys;
		}
		// Recherche les global values dans les parents
		public function getGlobalValues():CArrayList
		{
			var app:CRunApp=this;
			while(app.gValues==null)
			{
				app=parentApp;
			}
			return app.gValues;
		}
		public function getNGlobalValues():int
		{
			if (gValues!=null)
			{
				return gValues.size();
			}
			return 0;
		}	
		public function getGlobalStrings():CArrayList
		{
			var app:CRunApp=this;
			while(app.gStrings==null)
			{
				app=parentApp;
			}
			return app.gStrings;
		}
		public function getNGlobalStrings():int
		{
			if (gStrings!=null)
			{
				return gStrings.size();
			}
			return 0;
		}	
		public function checkGlobalValue(num:int):CArrayList
		{
			var values:CArrayList=getGlobalValues();
	
			if (num<0 || num>1000)
			{
				return null;
			}
			var oldSize:int=values.size();
			if (num>=oldSize)
			{
				values.ensureCapacity(num);
				var n:int;
				for (n=oldSize; n<=num; n++)
				{
					values.add(new CValue(0));
				}
			}
			return values;
		}
		public function getGlobalValueAt(num:int):CValue
		{
			var values:CArrayList=checkGlobalValue(num);
			if (values!=null)
			{
				return CValue(values.get(num));
			}
			return tempGValue;
		}
		public function setGlobalValueAt(num:int, value:CValue):void
		{
			var values:CArrayList=checkGlobalValue(num);
			if (values!=null)
			{
				CValue(values.get(num)).forceValue(value);
			}
		}
		public function checkGlobalString(num:int):CArrayList
		{
			var strings:CArrayList=getGlobalStrings();
	
			if (num<0 || num>1000)
			{
				return null;
			}
			var oldSize:int=strings.size();
			if (num>=oldSize)
			{
				strings.ensureCapacity(num);
				var n:int;
				for (n=oldSize; n<=num; n++)
				{
					strings.add(new String(""));
				}
			}
			return strings;
		}
		public function getGlobalStringAt(num:int):String
		{
			var strings:CArrayList=checkGlobalString(num);
			if (strings!=null)
			{
				return String(strings.get(num));
			}
			return "";
		}
		public function setGlobalStringAt(num:int, value:String):void
		{
			var strings:CArrayList=checkGlobalString(num);
			if (strings!=null)
			{
				strings.set(num, new String(value));
			}
		}

		// Charge le header de l'application
		public function loadAppHeader(file:CFile):void
		{
			file.skipBytes(4);			// Structure size
			gaFlags=file.readAShort();   		// Flags
			gaNewFlags=file.readAShort();		// New flags
			gaMode=file.readAShort();		// graphic mode
			gaOtherFlags=file.readAShort();		// Other Flags
			gaCxWin=file.readAShort();		// Window x-size
			gaCyWin=file.readAShort();		// Window y-size
			gaScoreInit=file.readAInt();		// Initial score
			gaLivesInit=file.readAInt();		// Initial number of lives
			var n:int, m:int;
			pcCtrlType=new Array(MAX_PLAYER);
			for (n = 0; n < MAX_PLAYER; n++)
			{
				pcCtrlType[n] = file.readAShort();	// Control type per player (0=mouse,1=joy1, 2=joy2, 3=keyb)
			}
			pcCtrlKeys=new Array(MAX_PLAYER*MAX_KEY); 
			for (n=0; n<MAX_PLAYER; n++)
			{
				for (m=0; m<MAX_KEY; m++)
				{
					pcCtrlKeys[n*MAX_KEY+m]=CKeyConvert.getFlashKey(file.readAShort());
				}
			}
			gaBorderColour=file.readAColor();	// Border colour
			gaNbFrames=file.readAInt();		// Number of frames
			gaFrameRate = file.readAInt();		// Number of frames per second
			file.skipBytes(1);				// Index of Window menu for MDI applications
			file.skipBytes(3);
		}

		// Charge le chunk GlobalValues
		public function loadGlobalValues(file:CFile):void
		{
			nGlobalValuesInit=file.readAShort();
			globalValuesInit=new Array(nGlobalValuesInit);
			globalValuesInitTypes=new Array(nGlobalValuesInit);
			var n:int;
			for (n=0; n<nGlobalValuesInit; n++)
			{
				globalValuesInit[n]=file.readAInt();
			}
			file.readBytesAsArray(globalValuesInitTypes);
		}
		
		// Charge le chunk GlobalStrings
		public function loadGlobalStrings(file:CFile):void
		{
			nGlobalStringsInit=file.readAInt();
			globalStringsInit=new Array(nGlobalStringsInit);
			var n:int;
			for (n=0; n<nGlobalStringsInit; n++)
			{
				globalStringsInit[n]=file.readAString();
			}
		}

		// Charge le chunk Frame handles
		public function loadFrameHandles(file:CFile, size:int):void
		{
			frameMaxHandle=(size/2);
			frameHandleToIndex=new Array(frameMaxHandle);

			var n:int;
			for (n=0; n<frameMaxHandle; n++)
			{
				frameHandleToIndex[n]=file.readAShort();
			}
		}

		// Transformation d'un HCELL en numero de cellule
		public function HCellToNCell ( hCell:int ):int
		{
			if ( frameHandleToIndex == null || hCell == -1 || hCell >= frameMaxHandle)
			{
				return -1;
			}
			return frameHandleToIndex[hCell];
		}


	    // ---------------------------------------------------------------------------------
	    // EMBEDDED FILES
	    // ---------------------------------------------------------------------------------
	    public function getEmbeddedFile(path:String):CEmbeddedFile 
	    {
			var fName:String=path;
	    	var pos:int;
	    	pos=path.lastIndexOf("\\");
			if (pos>=0)
			{
				fName=path.substring(pos+1);
			}			
				    	 
	        var n:int;
	        if (embeddedFiles != null)
	        {
	            for (n = 0; n < embeddedFiles.length; n++)
	            {
	                if (CServices.compareStringsIgnoreCase(embeddedFiles[n].path, fName))
	                {
	                    return embeddedFiles[n];
	                }
	            }
	        }
	        return null;
	    }
	
	    public function openHFile(path:String):CBinaryFile
	    {
	        if (path != null && path.length>0)
	        {
	            var embed:CEmbeddedFile;
	            embed = getEmbeddedFile(path);
	            if (embed != null)
	            {
	            	return embed.openMem();
	            }
	        }
	        return null;
	    }
		
		public function closeHFile(path:String):void
		{
			if (path != null && path.length>0)
			{
				var embed:CEmbeddedFile;
				embed = getEmbeddedFile(path);
				if (embed != null)
				{
					embed.releaseFile();
				}
			}
		}
	
		public function openFile(fileName:String):CBinaryFile
		{
			if (fileName != null && fileName.length>0)
			{
				var array:ByteArray=null;			
				try
				{
					var sharedObject:SharedObject=SharedObject.getLocal(fileName, "/");
					if (sharedObject.data.byteArray!=null)
					{
						array=ByteArray(sharedObject.data.byteArray);
					}
					else
					{
					}
				}
				catch(error:Error)
				{
				}
				if (array!=null)
				{
					return new CBinaryFile(array, false);					
				}
				var embed:CEmbeddedFile;
				embed = getEmbeddedFile(fileName);
				if (embed != null)
				{
					return embed.openMem();
				}				
			}
			return null;			
		}
		
		public function closeFile(fileName:String):void
		{
			closeHFile(fileName);	
		}

		// Offsets mouse pour sous application
		// -----------------------------------
		public function setMouseOffsets(xOffset:int, yOffset:int):void
		{
			xMouseOffset=xOffset;
			yMouseOffset=yOffset;
		}
		
		// ---------------------------------------------------------------------------------
		// CURSOR
		// ---------------------------------------------------------------------------------
		public function showCursor(count:int):void
		{
			cursorCount=count;
			if (cursorCount>=0)
			{
				Mouse.show();
			}
			else
			{
				Mouse.hide();
			}
		}

	    public function flushKeyboard():void
	    {
			var k:int;
			for (k=0; k<MAX_VK; k++)
			{
			    keyBuffer[k]=0;
			}
			keyNew=false;
	    }

		// -----------------------------------------------------------------------
		// Evenements Clavier
		// -----------------------------------------------------------------------
	    public function receiveKey(keyCode:int, bState:Boolean):void
	    {
			if (keyCode<MAX_VK)
	        {
		    	if (bState)
			    {
					keyBuffer[keyCode]=1;
					if (run!=null && run.rhEvtProg!=null)
					{
					    // Empile
					    var sys:CSysEventKeyDown=new CSysEventKeyDown(keyCode);
					    sysEvents.add(sys);
					}
					keyNew=true;
		    	}
			    else
			    {
					keyBuffer[keyCode]=0;
			    }
			}	
    	}
		public function onStatusEvent(event:StatusEvent):void
		{
		}
		public function onActivate(event:Event):void
		{
			bActivated=true;
		}
		public function onDeactivate(event:Event):void
		{
			bActivated=false;
		}
		public function onKeyDown(event:KeyboardEvent):void
		{
			var code:int=event.keyCode;
			if (code<MAX_VK)
		    {
		    	if (keyBuffer[code]==0)
		    	{	        
		    		if (run!=null && run.rhEvtProg!=null)
				    {
						// Empile
						var sys:CSysEventKeyDown=new CSysEventKeyDown(code);
						sysEvents.add(sys);
						
						// Si sous application, envoie le message à la sous app
						run.sendKey(code, true);

						keyNew=true;
				    }
		    	}
		        keyBuffer[code]=1;
	        }
		}
		public function onKeyUp(event:KeyboardEvent):void
		{
			var code:int=event.keyCode;
	        if (code<MAX_VK)
	        {
	            keyBuffer[code]=0;
            
		    	if (run!=null && run.rhEvtProg!=null)
		    	{
					run.sendKey(code, false);		
		    	}
		    }
        }		
        public function getKeyState(code:int):Boolean
        {
        	return keyBuffer[code]!=0;
        }
        public function onMouseMove(event:MouseEvent):void
        {
			bMouseIn=true;
        	mouseX=event.stageX-xMouseOffset-xOffset;
        	mouseY=event.stageY-yMouseOffset-yOffset;
        }
        public function onMouseLeave(event:Event):void
        {
			bMouseIn=false;
        	keyBuffer[260]=0;
        }
		
		public function click(clicks:int):void
		{
			if (run!=null)
			{
				run.rhEvtProg.onMouseButton(0, clicks);
				run.setFocus();
				if (clicks==1)
				{
					run.click();
				}
				if (clicks==2)
				{
					run.doubleClick();
				}
			}
		}	    

        public function onMouseDown(event:MouseEvent):void
        {
			bMouseIn=true;
        	keyBuffer[260]=1;
        	
		    var time:int=getTimer();
		    if (time-doubleClickTime>=0 && time-doubleClickTime<200)
		    {
//			    var mm:CSysEventClick=new CSysEventClick(0, 2);
//			    sysEvents.add(mm);
				click(2);
			    doubleClickTime=0;        	
		    }
		    else
		    {
//			    var m:CSysEventClick=new CSysEventClick(0, 1);
//			    sysEvents.add(m);
				click(1);
			    doubleClickTime=getTimer();       	
		    }
        }
        public function onMouseUp(event:MouseEvent):void
        {
        	keyBuffer[260]=0;
        }
		
        public function onMouseWheel(event:MouseEvent):void
        {
			bMouseIn=true;
        	deltaWheel=event.delta;
		    var mm:CSysEventWheel=new CSysEventWheel(deltaWheel);
		    sysEvents.add(mm);        	
        }

		public function setEffect(e:int, eParam:int):void
		{
			var eMasked:int=effect&CRSpr.BOP_MASK;
			
			var alpha:Number=1.0;
			var r:int=255;
			var g:int=255;
			var b:int=255;
			if ((effect & CRSpr.BOP_RGBAFILTER) != 0)
			{
				r=((effectParam&0xFFFFFF)>>16)&0xFF;
				g=((effectParam&0xFFFFFF)>>8)&0xFF;
				b=(effectParam&0xFFFFFF)&0xFF;
				alpha = (((effectParam >> 24) & 0xFF) / 255.0);
			}
			else if (eMasked == CRSpr.BOP_BLEND)
			{
				alpha = ((128 - effectParam) / 128.0);
			}
			switch(eMasked)
			{
				case CRSpr.BOP_ADD:
					mainSprite.blendMode = "add";
					mainSprite.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
				case CRSpr.BOP_SUB:
					mainSprite.blendMode = "subtract";
					mainSprite.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
				case CRSpr.BOP_INVERT:
					mainSprite.blendMode = "normal";
					mainSprite.transform.colorTransform = new ColorTransform(-r/255.0, -g/255.0, -b/255.0, 1, 255, 255, 255, 0);  
					break;
				default: 
					mainSprite.blendMode = "normal";
					mainSprite.transform.colorTransform = new ColorTransform(r/255.0, g/255.0, b/255.0, 1, 0, 0, 0, 0);  
					break;
			}
			mainSprite.alpha=(alpha);
		}		
		public function setTransparency(t:Number):void
		{
			mainSprite.alpha=t*alpha;
		}
		/*
		import flash.desktop.Clipboard;
		import flash.desktop.ClipboardFormats;
		import flash.desktop.ClipboardTransferMode;
		
		
		public function copy(text:String):void 
		{
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}
		
		public function paste():String
		{
			if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
			{
				return String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
			} 
			else 
			{
				return null;
			}
		}
		*/
	}
	
}