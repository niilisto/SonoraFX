//----------------------------------------------------------------------------------
//
// CRUNMVTPRESENTAION
//
//----------------------------------------------------------------------------------
package Movements
{
	import Extensions.CExtStorage;
	
	import Services.*;
	
	public class CRunMvtGlobalPres extends CExtStorage
	{
	    public var count:int = 0;
	    public var orderPosition:int = 0;
	    public var finalOrder:int = -1;
	    public var keyNext:int = 0;
	    public var keyPrev:int = 0;
	    public var reset:Boolean = true;
	    public var resetToEnd:Boolean = false;
	    public var autoControl:Boolean = true;
	    public var autoFrameJump:Boolean = true;
	    public var autoComplete:Boolean = true;
	    public var myList:CArrayList = null;
	}
}