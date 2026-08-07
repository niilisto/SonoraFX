//----------------------------------------------------------------------------------
//
// CRUNKCWCTRL Objet Window Control
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Application.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	import flash.system.Capabilities;

	public class CRunkcwctrl extends CRunExtension
	{

		public static var CND_ISICONIC:int=0;
		public static var CND_ISMAXIMIZED:int=1;
		public static var CND_ISVISIBLE:int=2;
		public static var CND_ISAPPACTIVE:int=3;
		public static var CND_HASFOCUS:int=4;
		public static var CND_ISATTACHEDTODESKTOP:int=5;
		public static var CND_LAST:int=6;
		
		public static var ACT_SETBACKCOLOR:int=23;
		
		public static var EXP_GETXPOSITION:int=0;
		public static var EXP_GETYPOSITION:int=1;
		public static var EXP_GETXSIZE:int=2;
		public static var EXP_GETYSIZE:int=3;
		public static var EXP_GETSCREENXSIZE:int=4;
		public static var EXP_GETSCREENYSIZE:int=5;
		public static var EXP_GETSCREENDEPTH:int=6;
		public static var EXP_GETCLIENTXSIZE:int=7;
		public static var EXP_GETCLIENTYSIZE:int=8;
		public static var EXP_GETTITLE:int=9;
		public static var EXP_GETBACKCOLOR:int=10;
		public static var EXP_GETXFRAME:int=11;
		public static var EXP_GETYFRAME:int=12;
		public static var EXP_GETWFRAME:int=13;
		public static var EXP_GETHFRAME:int=14;		
		
		public function CRunkcwctrl()
		{
					
		}
		public override function getNumberOfConditions():int
		{
			return CND_LAST;
		}
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			return false;
		}
		public override function destroyRunObject(bFast:Boolean):void
		{
		}

		// Conditions
		// --------------------------------------------------
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			switch (num)
			{
				case CND_ISICONIC:
					return false;
				case CND_ISMAXIMIZED:
					return false;
				case CND_ISVISIBLE:
					return true;
				case CND_ISAPPACTIVE:
					return true;
				case CND_HASFOCUS:
					return rh.rhApp.bActivated;
				case CND_ISATTACHEDTODESKTOP:
					return false;
			}
			return false;
		}
/*		
		// Actions
		// -------------------------------------------------
		public override function action(num:int, act:CActExtension):void
		{
			if (num==ACT_SETBORDERCOLOR)
			{
			}
		}
*/
		// Expressions
		// --------------------------------------------
		
		public function getScreenWidth():int
		{
			return flash.system.Capabilities.screenResolutionX;
		}
		public function getScreenHeight():int
		{
			return flash.system.Capabilities.screenResolutionY;
		}
		public override function expression(num:int):CValue 
		{
			switch (num)
			{
				case EXP_GETXPOSITION:
					return new CValue(0);
				case EXP_GETYPOSITION:
					return new CValue(0);
				case EXP_GETXSIZE:
					return new CValue(getScreenWidth());
				case EXP_GETYSIZE:
					return new CValue(getScreenHeight());
				case EXP_GETSCREENXSIZE:
					return new CValue(getScreenWidth());
				case EXP_GETSCREENYSIZE:
					return new CValue(getScreenHeight());
				case EXP_GETSCREENDEPTH:
					return new CValue(0);
				case EXP_GETCLIENTXSIZE:
					return new CValue(getScreenWidth());					
				case EXP_GETCLIENTYSIZE:
					return new CValue(getScreenHeight());
				case EXP_GETTITLE:
				{
					var ret:CValue=new CValue(0);
					ret.forceString("");
					return ret;
				}
				case EXP_GETBACKCOLOR:
					return new CValue(rh.rhApp.gaBorderColour);
				case EXP_GETXFRAME:
					return new CValue(0);
				case EXP_GETYFRAME:
					return new CValue(0);
				case EXP_GETWFRAME:
					return new CValue(getScreenWidth());					
				case EXP_GETHFRAME:
					return new CValue(getScreenHeight());
			}
			return null;
		}
	}
	
}