package RunLoop {
	import Actions.CActExtension;
	import Conditions.CCndExtension;
	import Expressions.CValue;
	import Extensions.*;
	import Services.CBinaryFile;
	import Services.CFontInfo;
	import Services.CRect;
	import Sprites.CMask;
	import Objects.*;
	import Box2D.Dynamics.b2Body;
	
	public class CRunBaseParent extends CRunExtension
	{
		public var identifier:int;
		public var RunFactor:Number = 1.0;
		
		
		public override function getNumberOfConditions():int
		{
			return 0;
		}
		
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			return false;
		}
		
		
		public override function handleRunObject():int
		{
			return REFLAG_ONESHOT;
		}
		
		
		public override function displayRunObject():void
		{
		}
		
		
		//public override function reinitDisplay():void
		//{
		//}
		
		
		public override function destroyRunObject(bFast:Boolean):void
		{
		}
		
		
		public override function pauseRunObject():void
		{
		}
		
		
		public override function continueRunObject():void
		{
		}
		
		
		public override function getZoneInfos():void
		{
		}
		
		
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			return false;
		}
		
		
		public override function action(num:int, act:CActExtension):void
		{
		}
		
		
		public override function expression(num:int):CValue
		{
			return new CValue(0);
		}
		
		
		public override function getRunObjectCollisionMask(flags:int):CMask
		{
			return null;
		}
		
		
		public override function getRunObjectFont():CFontInfo {
			return null;
		}
		
		
		public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void {
		}
		
		
		public override function getRunObjectTextColor():int
		{
			return 0;
		}
		
		
		public override function setRunObjectTextColor(rgb:int):void
		{
		}
		
		public function rStartObject():Boolean
		{
			return false;
		}
		
		public function rAddNormalObject(pHo:CObject):void
		{
		}
		
		public function rAddObject(mBase:CRunMBase):void
		{
		}
		
		public function rRemoveObject(mBase:CRunMBase):void
		{
		}
		
		public function rCreateBullet(angle:Number, speed:Number, pMBase:CRunMBase):b2Body
		{
			return null;
		}
		public function rDestroyBody(body:b2Body):void {
		}
		public function rGetBodyPosition(pBody:b2Body, o:CRunBox2DBasePosAndAngle):void {
		}		
		public function rAddABackdrop(x:int, y:int, img:Number, colType:Number):b2Body
		{
			return null;
		}
		
		public function rSubABackdrop(body:b2Body):void
		{
			
		}
	}
}