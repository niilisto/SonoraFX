package Application 
{
	import Events.*;
	
	import Frame.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	//----------------------------------------------------------------------------------
	//
	// CRUNFRAME : contenu d'une frame
	//
	//----------------------------------------------------------------------------------
	public class CRunFrame 
	{
		public var app:CRunApp;
		public var rhPtr:CRun;
    
		// Flags
		public static var LEF_DISPLAYNAME:int=0x0001;
		public static var LEF_GRABDESKTOP:int=0x0002;
		public static var LEF_KEEPDISPLAY:int=0x0004;
		public static var LEF_TOTALCOLMASK:int=0x0020;
		public static var LEF_RESIZEATSTART:int=0x0100;
		public static var LEF_NOSURFACE:int=0x0800;
		public static var LEF_TIMEDMVTS:int=0x8000;

		// Colmask flags    
	    public static var CM_TEST_OBSTACLE:int=0;
	    public static var CM_TEST_PLATFORM:int=1;
	    public static var CM_OBSTACLE:int=0x0001;
	    public static var CM_PLATFORM:int=0x0002;
	    public static var HEIGHT_PLATFORM:int=6;
    
		// Frameheader
		public var leWidth:int;			// Playfield width in pixels
		public var leHeight:int;		// Playfield height in pixels
		public var leBackground:int;
		public var leFlags:int;
    
		public var leVirtualRect:CRect;
		public var leEditWinWidth:int;
		public var leEditWinHeight:int;
		public var frameName:String;
		public var nLayers:int;
		public var layers:Array;
		public var LOList:CLOList;
		public var evtProg:CEventProgram;
		public var maxObjects:int;
    
		// Coordinates of top-level pixel in edit window
		public var leX:int;
		public var leY:int;
		public var leLastScrlX:int;
		public var leLastScrlY:int;

		// Exit code
		public var levelQuit:int;

		// Events
		public var rhOK:Boolean;				// TRUE when the events are initialized

		public var startLeX:int;
		public var startLeY:int;
		public var fade:Boolean;
		public var fadeTimerDelta:int;
		public var fadeVblDelta:int;
//		public var dwColMaskBits:int;
//		public var colMask:CColMask;
		public var m_wRandomSeed:int;
		public var m_dwMvtTimerBase:int;
		
		public function CRunFrame(pApp:CRunApp ) 
		{
			app=pApp;
		}

		// Charge la frame
		public function loadFullFrame(index:int):void
		{
			// Positionne le fichier
			app.file.seek(app.frameOffsets[index]);
	
			// Charge la frame
			evtProg=new CEventProgram();
			LOList=new CLOList();
			leVirtualRect=new CRect();
	
			var chk:CChunk=new CChunk();
			var posEnd:int;
			var nOldFrameWidth:int=0;
			var nOldFrameHeight:int=0;
			m_wRandomSeed=-1;
			while (chk.chID!=0x7F7F)	// CHUNK_LAST
			{
				chk.readHeader(app.file);
				if (chk.chSize==0)
				{
					continue;
				}
				posEnd=app.file.getFilePointer()+chk.chSize;
				switch(chk.chID)
				{
				// CHUNK_FRAMEHEADER
				case 0x3334:
					loadHeader();
					
					if ( (leFlags & LEF_RESIZEATSTART)!=0 )
					{
						nOldFrameWidth = leWidth;
						nOldFrameHeight = leHeight;
						
						leWidth = app.gaCxWin;
						leHeight = app.gaCyWin;
						
						// To keep compatibility with previous versions without virtual rectangle (necessaire ?)
						leVirtualRect.left = leVirtualRect.top = 0;
						leVirtualRect.right = leWidth;
						leVirtualRect.bottom = leHeight;
					}

					// B243 
					if ( app.parentApp!=null && (app.parentOptions & CCCA.CCAF_DOCKED) != 0 )
					{
						leEditWinWidth = app.cx;
						leEditWinHeight = app.cy;
					}
					else
					{
						leEditWinWidth=Math.min(app.gaCxWin, leWidth);
						leEditWinHeight=Math.min(app.gaCyWin, leHeight);
					}
					break;
		    
				// CHUNK_FRAMEVIRTUALRECT
				case 0x3342:
					leVirtualRect.load(app.file);
					if ( (leFlags & LEF_RESIZEATSTART)!=0 )
					{
						if ( leVirtualRect.right - leVirtualRect.left == nOldFrameWidth || leVirtualRect.right - leVirtualRect.left < leWidth )
							leVirtualRect.right = leVirtualRect.left + leWidth;
						if ( leVirtualRect.bottom - leVirtualRect.top == nOldFrameHeight || leVirtualRect.bottom - leVirtualRect.top < leHeight )
							leVirtualRect.bottom = leVirtualRect.top + leHeight;
					}
					
					break;

				// CHUNK_RANDOMSEED
				case 0x3344:
					m_wRandomSeed=app.file.readAShort();
					break;
                    
                // CHUNK_MVTTIMERBASE
                case 0x3347:
                    m_dwMvtTimerBase=app.file.readAInt();
                    break;
		    
				// CHUNK_FRAMENAME
				case 0x3335:
					frameName=app.file.readAString();
					break;
		    
				// CHUNK_FRAMELAYERS
				case 0x3341:
					loadLayers();
					break;

				// CHUNK_FRAMELAYEREFFECTS
				case 0x3345:
					loadLayerEffects();
					break;
				
				// CHUNK_FRAMEITEMINSTANCES
				case 0x3338:
					LOList.load(app);
					break;
		    
				// CHUNK_FRAMEEVENTS
				case 0x333D:
					evtProg.load(app);
					maxObjects=evtProg.maxObjects;
//					evtProg.relocatePath(app);
					break;
				}
				// Positionne a la fin du chunk
				app.file.seek(posEnd);
			}
	
			// Marque les OI a charger
			app.OIList.resetToLoad();
			var n:int;
			for (n=0; n<LOList.nIndex; n++)
			{
				var loTemp:CLO=LOList.getLOFromIndex(n);
				app.OIList.setToLoad(loTemp.loOiHandle);
			}
	
			// Charge les OI et les elements des banques
			app.imageBank.resetToLoad();
			app.fontBank.resetToLoad();
			app.OIList.load(app.file);
			app.OIList.enumElements(app.imageBank, app.fontBank);
			app.imageBank.load(app.file);
			app.fontBank.load(app.file);
			evtProg.enumSounds(app.soundBank);
			app.soundBank.load();
	
			// Marque les OI de la frame
			app.OIList.resetOICurrent();
			for (n=0; n<LOList.nIndex; n++)
			{
				var lo:CLO=LOList.list[n];
				if (lo.loType>=COI.OBJ_SPR)
				{
					app.OIList.setOICurrent(lo.loOiHandle);
				}
			}
		}

		public function loadLayers():void
		{
			nLayers=app.file.readAInt();
			layers=new Array(nLayers);
	
			var n:int;
			for (n=0; n<nLayers; n++)
			{
				layers[n]=new CLayer(app);
				layers[n].load(app.file);
			}
		}
		
		public function loadLayerEffects():void
		{
			var l:int;
			for (l=0; l<nLayers; l++)
			{
				layers[l].effect=app.file.readAInt();
				layers[l].effectParam=app.file.readAInt();
				app.file.skipBytes(12);				
			}
		}

		public function loadHeader():void
		{
			leWidth=app.file.readAInt();
			leHeight=app.file.readAInt();
			leBackground=app.file.readAColor();
			leFlags=app.file.readAInt();
		}

	}
}