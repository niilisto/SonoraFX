//----------------------------------------------------------------------------------
//
// CRUNMVTINVADERS : classe interne
//
//----------------------------------------------------------------------------------
package Movements
{
	import Extensions.CExtStorage;	
	import Services.*;
	
	public class CRunMvtGlobalDataInvader extends CExtStorage
	{
	    public var count:int=0;
	    public var tillSpeedIncrease:int=0;
	    public var dx:int = 1;
	    public var dy:int = 0;
	    public var cdx:int = 0;
	    public var cdy:int = 0;
	    public var speed:int = 0;
	    public var frames:int = 0;
	    public var initialSpeed:int = 0;
	    public var minX:int = 0;
	    public var maxX:int = 640;
	    public var isMoving:Boolean = false;
	    public var autoSpeed:Boolean = false;
	    public var myList:CArrayList = null;		
	}
}