//----------------------------------------------------------------------------------
//
// CRUNEXTENSION: Classe abstraite run extension
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunExtension
	{
	    public static var REFLAG_DISPLAY:int=1;
	    public static var REFLAG_ONESHOT:int=2;
	    public var ho:CExtension;
	    public var rh:CRun;
	    
	    public function init(hoPtr:CExtension):void
	    {
	        ho = hoPtr;
	        rh = hoPtr.hoAdRunHeader;
	    }
	    
	    public function getNumberOfConditions():int
	    {
	    	return 0;	
	    }
	    	
	    public function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	return false;	
	    }
	
	    public function handleRunObject():int
	    {
	    	return REFLAG_ONESHOT;
	    }
	
	    public function displayRunObject():void
	    {
	    	
	    }
	
	    public function destroyRunObject(bFast:Boolean):void
	    {
	    	
	    }
	
	    public function pauseRunObject():void
	    {
	    	
	    }
	
	    public function continueRunObject():void
	    {
	    	
	    }
	
	    public function getZoneInfos():void
	    {
	    	
	    }
	
	    public function condition(num:int, cnd:CCndExtension):Boolean
	    {
	    	return false;	
	    }
	
	    public function action(num:int, act:CActExtension):void
	    {
	    	
	    }
	
	    public function expression(num:int):CValue
	    {
	    	return null;
	    }
	
	    public function getRunObjectCollisionMask(flags:int):CMask
	    {
	    	return null;
	    }
	
	    public function getRunObjectFont():CFontInfo
	    {
	    	return null;	
	    }
	
	    public function setRunObjectFont(fi:CFontInfo, rc:CRect):void
	    {
	    	
	    }
	
	    public function getRunObjectTextColor():int
	    {
	    	return 0;
	    }
	
	    public function setRunObjectTextColor(rgb:int):void
	    {
	    	
	    }

		public function setFocus(bFlag:Boolean):void
		{
			
		}	    

		public function click():void
		{
			
		}	    

		public function doubleClick():void
		{
			
		}	    

		public function showSprite():void
		{
		}

		public function hideSprite():void
		{			
		}

		public function getChildIndex():int
		{	
			return -1;
		}

		public function getChildMaxIndex():int
		{
			return 0;
		}

		public function setChildIndex(index:int):void
		{
		}
		
		public function setHandCursor(bOn:Boolean):void
		{			
		}
		
	}
}