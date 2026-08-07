//----------------------------------------------------------------------------------
//
// COI: un objet
//
//----------------------------------------------------------------------------------
package OI
{
	import Services.CFile;
	import Banks.IEnum;
	
	public class COI
	{
	    // Flags
	    public const OILF_OCLOADED:int=0x0001;
	    public const OILF_ELTLOADED:int=0x0002;
	    public const OILF_TOLOAD:int=0x0004;
	    public const OILF_TODELETE:int=0x0008;
	    public static var OILF_CURFRAME:int=0x0010;
	    public static var OILF_TORELOAD:int=0x0020;
	    public const OILF_IGNORELOADONCALL:int=0x0040;
	    public const OIF_LOADONCALL:int=0x0001;
	    public const OIF_DISCARDABLE:int=0x0002;
	    public static var OIF_GLOBAL:int=0x0004;
	
	    public static var NUMBEROF_SYSTEMTYPES:int=7;
	    public static var OBJ_PLAYER:int=-7;
	    public static var OBJ_KEYBOARD:int=-6;
	    public static var OBJ_CREATE:int=-5;
	    public static var OBJ_TIMER:int=-4;
	    public static var OBJ_GAME:int=-3;
	    public static var OBJ_SPEAKER:int=-2;
	    public static var OBJ_SYSTEM:int=-1;
	    public static var OBJ_BOX:int=0;
	    public static var OBJ_BKD:int=1;
	    public static var OBJ_SPR:int=2;
	    public static var OBJ_TEXT:int=3;
	    public static var OBJ_QUEST:int=4;
	    public static var OBJ_SCORE:int=5;
	    public static var OBJ_LIVES:int=6;
	    public static var OBJ_COUNTER:int=7;
	    public static var OBJ_RTF:int=8;
	    public static var OBJ_CCA:int=9;
	    public static var NB_SYSOBJ:int=10;
	    public static var OBJ_PASTED:int=11;
	    public static var OBJ_LAST:int=10;
	    public static var KPX_BASE:int=32;
	    public static var OIFLAG_QUALIFIER:int=0x8000;
	    
	    // objInfoHeader
	    public var oiHandle:int;
	    public var oiType:int;
	    public var oiFlags:int;			// Memory flags
	    public var oiInkEffect:int;			// Ink effect
	    public var oiInkEffectParam:int;	        // Ink effect param
	
	    // OI
	    public var oiName:String;			// Name
	    public var oiOC:COC;			// ObjectsCommon
	    public var oiFileOffset:int=0;
	    public var oiLoadFlags:int=0;
	    public var oiLoadCount:int=0;
	    public var oiCount:int=0;

		public function COI()
		{
		}
	    public function loadHeader(file:CFile):void
	    {
			oiHandle=file.readAShort();
			oiType=file.readAShort();
			oiFlags=file.readAShort();
			file.skipBytes(2);
			oiInkEffect=file.readAInt();
			oiInkEffectParam=file.readAInt();
	    }
	    public function load(file:CFile):void
	    {
			// Positionne au debut
			file.seek(oiFileOffset);
			
			// En fonction du type
			switch (oiType)
			{
			    case 0:		// Quick background
					oiOC=new COCQBackdrop();
					break;
			    case 1:
					oiOC=new COCBackground();
					break;
			    default:
					oiOC=new CObjectCommon();
					break;
			}			
			oiOC.load(file, oiType);
			oiLoadFlags=0;
	    }
	    public function unLoad():void
	    {
			oiOC=null;
	    }
	    public function enumElements(enumImages:IEnum, enumFonts:IEnum):void
	    {
			oiOC.enumElements(enumImages, enumFonts);
	    }

	}
}