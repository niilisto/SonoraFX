//----------------------------------------------------------------------------------
//
// CMOVEDEF : classe de base movement definitions
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDef
	{
	    // Definition of movement types
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    public static var MVTYPE_STATIC:int=0;
	    public static var MVTYPE_MOUSE:int=1;
	    public static var MVTYPE_RACE:int=2;
	    public static var MVTYPE_GENERIC:int=3;
	    public static var MVTYPE_BALL:int=4;
	    public static var MVTYPE_TAPED:int=5;
	    public static var MVTYPE_PLATFORM:int=9;
	    public static var MVTYPE_DISAPPEAR:int=11;
	    public static var MVTYPE_APPEAR:int=12;
	    public static var MVTYPE_BULLET:int=13;
	    public static var MVTYPE_EXT:int=14;
	
	    public var mvType:int;
	    public var mvControl:int;
	    public var mvMoveAtStart:int;
	    public var mvDirAtStart:int;
	    public var mvOpt:int;

		public function CMoveDef()
		{
		}
	    
	    public function load(file:CFile, length:int):void
		{			
		}
		    
    	public function setData(t:int, c:int, m:int, d:int, mo:int):void
	    {
	        mvType=t;
	        mvControl=c;
	        mvMoveAtStart=m;
	        mvDirAtStart=d;
	        mvOpt=mo;
	    }
	}
}