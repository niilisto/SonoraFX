//----------------------------------------------------------------------------------
//
// COBJECTCOMMON : Données d'un objet normal
//
//----------------------------------------------------------------------------------

package OI
{
	import Animations.*;
	
	import Banks.IEnum;
	
	import Movements.*;
	
	import Services.CFile;
	
	import Values.*;
	
	import flash.utils.ByteArray;
	
	public class CObjectCommon extends COC
	{
    	// Flags 
    	public static var OEFLAG_DISPLAYINFRONT:int=0x0001;
    	public static var OEFLAG_BACKGROUND:int=0x0002;
    	public static var OEFLAG_BACKSAVE:int=0x0004;
    	public static var OEFLAG_RUNBEFOREFADEIN:int=0x0008;
    	public static var OEFLAG_MOVEMENTS:int=0x0010;
    	public static var OEFLAG_ANIMATIONS:int=0x0020;
    	public static var OEFLAG_TABSTOP:int=0x0040;
    	public static var OEFLAG_WINDOWPROC:int=0x0080;
    	public static var OEFLAG_VALUES:int=0x0100;
    	public static var OEFLAG_SPRITES:int=0x0200;
    	public static var OEFLAG_INTERNALBACKSAVE:int=0x0400;
    	public static var OEFLAG_SCROLLINGINDEPENDANT:int=0x0800;
    	public static var OEFLAG_QUICKDISPLAY:int=0x1000;
    	public static var OEFLAG_NEVERKILL:int=0x2000;
    	public static var OEFLAG_NEVERSLEEP:int=0x4000;
    	public static var OEFLAG_MANUALSLEEP:int=0x8000;
    	public static var OEFLAG_TEXT:int=0x10000;
    	public static var OEFLAG_DONTCREATEATSTART:int=0x20000;
    	public static var OCFLAGS2_DONTSAVEBKD:int=0x0001;
    	public static var OCFLAGS2_SOLIDBKD:int=0x0002;
    	public static var OCFLAGS2_COLBOX:int=0x0004;
    	public static var OCFLAGS2_VISIBLEATSTART:int=0x0008;
    	public static var OCFLAGS2_OBSTACLESHIFT:int=4;
    	public static var OCFLAGS2_OBSTACLEMASK:int=0x0030;
    	public static var OCFLAGS2_OBSTACLE_SOLID:int=0x0010;
    	public static var OCFLAGS2_OBSTACLE_PLATFORM:int=0x0020;
    	public static var OCFLAGS2_OBSTACLE_LADDER:int=0x0030;
    	public static var OCFLAGS2_AUTOMATICROTATION:int=0x0040;

    	// Flags modifiable by the program
    	public const OEPREFS_BACKSAVE:int=0x0001;
    	public const OEPREFS_SCROLLINGINDEPENDANT:int=0x0002;
    	public const OEPREFS_QUICKDISPLAY:int=0x0004;
    	public const OEPREFS_SLEEP:int=0x0008;
    	public const OEPREFS_LOADONCALL:int=0x0010;
    	public const OEPREFS_GLOBAL:int=0x0020;
    	public const OEPREFS_BACKEFFECTS:int=0x0040;
    	public const OEPREFS_KILL:int=0x0080;
    	public const OEPREFS_INKEFFECTS:int=0x0100;
    	public const OEPREFS_TRANSITIONS:int=0x0200;
    	public const OEPREFS_FINECOLLISIONS:int=0x0400;

    
    	public var ocOEFlags:int;		    // New flags
    	public var ocQualifiers:Array;	    // Qualifier list
    	public var ocFlags2:int;		    // New news flags, before was ocEvents
    	public var ocOEPrefs:int;		    // Automatically modifiable flags
    	public var ocIdentifier:int;		    // Identifier d'objet
    	public var ocBackColor:int;		    // Background color
    	public var ocMovements:CMoveDefList;     // La liste des mouvements
    	public var ocValues:CDefValues;          // Les alterable values par defaut
    	public var ocStrings:CDefStrings;        // Les alterable strings
    	public var ocAnimations:CAnimHeader;     // Les animations
    	public var ocCounters:CDefCounters;   // Settings lives / scores / counter
    	public var ocObject:CDefObject;          // L'objet lui meme'
    	public var ocExtension:ByteArray;	// Les données objets extension
    	public var ocVersion:int;
    	public var ocID:int;
    	public var ocPrivate:int;
    	public var ocFadeInLength:int;
    	public var ocFadeOutLength:int;

		public function CObjectCommon()
		{
		}

	    public override function load(file:CFile, type:int):void
	    {
			// Position de debut
			var debut:int=file.getFilePointer();
			ocQualifiers=new Array(8);		    // OC_MAX_QUALIFIERS 
	
			// Lis le header
			var n:int;
			file.skipBytes(4);			    // DWORD ocDWSize;	Total size of the structures
			var oMovements:int=file.readAShort();	    // WORD Offset of the movements
			var oAnimations:int=file.readAShort();	    // WORD Offset of the animations
			file.skipBytes(2);			    // WORD For version versions > MOULI 
			var oCounter:int=file.readAShort();             // WORD Pointer to COUNTER structure
			var oData:int=file.readAShort();		    // WORD Pointer to DATA structure
			file.skipBytes(2);			    // WORD ocFree;
			ocOEFlags=file.readAInt();		    // New flags
			for (n=0; n<8; n++)
			{
			    ocQualifiers[n]=int(file.readShort());	    // OC_MAX_QUALIFIERS Qualifier list
			}
			var oExtension:int=file.readAShort();	    // WORD Extension structure 
			var oValues:int=file.readAShort();		    // WORD Values structure
			var oStrings:int=file.readAShort();             // WORD String structure
			ocFlags2=file.readAShort();		    // WORD New news flags, before was ocEvents
			ocOEPrefs=file.readAShort();		    // WORD Automatically modifiable flags
			ocIdentifier=file.readAInt();		    // DWORD Identifier d'objet
			ocBackColor=file.readAColor();		    // COLORREF Background color
			var oFadeIn:int=file.readAInt();		    // oFadeIn DWORD Offset fade in 
			var oFadeOut:int=file.readAInt();		    // oFadeOut DWORD Offset fade out 
			ocFadeInLength=0;
			ocFadeOutLength=0;
			
			// Charge les movements
			if (oMovements!=0)
			{
			    file.seek(debut+oMovements);
			    ocMovements=new CMoveDefList();
			    ocMovements.load(file);
			}
	        // Charge les values
	        if (oValues!=0)
	        {
	            file.seek(debut+oValues);
	            ocValues=new CDefValues();
	            ocValues.load(file);
	        }
	        // Charge les strings
	        if (oStrings!=0)
	        {
	            file.seek(debut+oStrings);
	            ocStrings=new CDefStrings();
	            ocStrings.load(file);
	        }
	        // Charge les animations
	        if (oAnimations!=0)
	        {
	            file.seek(debut+oAnimations);
	            ocAnimations=new CAnimHeader();
	            ocAnimations.load(file);
	        }
	        // Les données counters
	        if (oCounter!=0)
	        {
	            file.seek(debut+oCounter);
	            ocObject=new CDefCounter();
	            ocObject.load(file);
	        }
			// Les données extension
			if (oExtension!=0)
			{
	            file.seek(debut+oExtension);
			    var size:int=file.readAInt();
			    file.skipBytes(4);
			    ocVersion=file.readAInt();
			    ocID=file.readAInt();
			    ocPrivate=file.readAInt();
			    size-=20;
			    if (size!=0)
			    {
					ocExtension=file.readBuffer(size);
			    }
			}
	        // Le fade in
	        if (oFadeIn!=0)
	        {
	            file.seek(debut+oFadeIn);
	            file.skipBytes(8);
	            ocFadeInLength=file.readAInt();
	        }
	        // Le fade out
	        if (oFadeOut!=0)
	        {
	            file.seek(debut+oFadeOut);
	            file.skipBytes(8);
	            ocFadeOutLength=file.readAInt();
	        }

			// Les données score/live/counter
	        if (oData!=0)
	        {
	            file.seek(debut+oData);
	            switch (type)
	            {
	                case 3:         // OBJ_TEXT
	                case 4:         // OBJ_QUEST 
	                    ocObject=new CDefTexts();
	                    ocObject.load(file);
	                    break;
	                
	                case 5:         // OBJ_SCORE
	                case 6:         // OBJ_LIVES
	                case 7:         // OBJ_COUNTER
	                    ocCounters=new CDefCounters();
	                    ocCounters.load(file);
	                    break;
	                
	                case 8:         // OBJ_RTF
	                    ocObject=new CDefRtf();
	                    ocObject.load(file);
					    // Change les OEFLAGS pour virer les attributs sprite
					    ocOEFlags&=~(OEFLAG_SPRITES|OEFLAG_QUICKDISPLAY|OEFLAG_BACKSAVE);
	                    break;
	                case 9:         // OBJ_CCA
	                    ocObject=new CDefCCA();
	                    ocObject.load(file);
	                    break;
	            }
	        }
	    }
	    public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
			if (ocAnimations!=null)
	        {
	            ocAnimations.enumElements(enumImages);
	        }
			if (ocObject!=null)
			{
			    ocObject.enumElements(enumImages, enumFonts);
			}
			if (ocCounters!=null)
			{
			    ocCounters.enumElements(enumImages, enumFonts);
			}
	    }
	}
}