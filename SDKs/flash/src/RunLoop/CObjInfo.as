//----------------------------------------------------------------------------------
//
// COBJINFO: information sur un type d'objet
//
//----------------------------------------------------------------------------------
package RunLoop
{
	import OI.*;
	
	public class CObjInfo
	{
	    public static var OILIMITFLAGS_BORDERS:int=0x000F;
	    public static var OILIMITFLAGS_BACKDROPS:int=0x0010;
		public static var OILIMITFLAGS_ONCOLLIDE:int=0x0080;
	    public static var OILIMITFLAGS_QUICKCOL:int=0x0100;
	    public static var OILIMITFLAGS_QUICKBACK:int=0x0200;
	    public static var OILIMITFLAGS_QUICKBORDER:int=0x0400;
	    public static var OILIMITFLAGS_QUICKSPR:int=0x0800;
	    public static var OILIMITFLAGS_QUICKEXT:int=0x1000;
	    public static var OILIMITFLAGS_ALL:int=0xFFFF;
	
	    public var oilOi:int;  			// THE oi
	    public var oilListSelected:int;               // First selection !!! DO NOT CHANGE POSITION !!!
	    public var oilType:int;			// Type of the object
	    public var oilObject:int;			// First objects in the game
	    public var oilEvents:int;			// Events
	    public var oilWrap:int;			// WRAP flags
	    public var oilNextFlag:Boolean;
	    public var oilNObjects:int;                     // Current number
	    public var oilActionCount:int;			// Action loop counter
	    public var oilActionLoopCount:int;              // Action loop counter
	    public var oilCurrentRoutine:int;               // Current routine for the actions
	    public var oilCurrentOi:int;			// Current object
	    public var oilNext:int;				// Pointer on the next
	    public var oilEventCount:int;			// When the event list is done
	    public var oilNumOfSelected:int;                // Number of selected objects
	    public var oilOEFlags:int;			// Object's flags
	    public var oilLimitFlags:int;			// Movement limitation flags
	    public var oilLimitList:int;                    // Pointer to limitation list
	    public var oilOIFlags:int;			// Objects preferences
	    public var oilOCFlags2:int;			// Objects preferences II
	    public var oilInkEffect:int;			// Ink effect
	    public var oilEffectParam:int;			// Ink effect param
	    public var oilHFII:int;			// First available frameitem
	    public var oilBackColor:int;			// Background erasing color
	    public var oilQualifiers:Array;               // Qualifiers for this object
	    public var oilName:String;                 // Name	
	    public var oilEventCountOR:int;                 // Selection in a list of events with OR
		public var oilColList:Array;
		

		public function CObjInfo()
		{
		}
	    public function copyData(oiPtr:COI):void
	    {
	        // Met dans l'OiList
	    	oilOi=oiPtr.oiHandle;			
	    	oilType=oiPtr.oiType;			
	
	    	oilOIFlags=oiPtr.oiFlags;			
	        var ocPtr:CObjectCommon=CObjectCommon(oiPtr.oiOC);
	        oilOCFlags2=ocPtr.ocFlags2;		
	    	oilInkEffect=oiPtr.oiInkEffect;		
	    	oilEffectParam=oiPtr.oiInkEffectParam;	
	    	oilOEFlags=ocPtr.ocOEFlags;
	    	oilBackColor=ocPtr.ocBackColor;			
			oilEventCount=0;
	    	oilObject=-1;
	    	oilLimitFlags=OILIMITFLAGS_ALL;	
	    	if ( oiPtr.oiName!=null )
	        {
	            oilName=new String(oiPtr.oiName);
	        }
	        var q:int;
	        oilQualifiers=new Array(8);
	        for (q=0; q<8; q++) 
	        {
	            oilQualifiers[q]=ocPtr.ocQualifiers[q];
	        }	
	    }

	}
}