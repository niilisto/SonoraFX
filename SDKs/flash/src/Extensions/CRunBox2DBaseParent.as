package Extensions {
	
	import RunLoop.*;
	import Actions.CActExtension;
	import Conditions.CCndExtension;
	import Expressions.CValue;
	import Extensions.*;
	import Services.CBinaryFile;
	import Services.CFontInfo;
	import Services.CRect;
	import Services.CArrayList;
	import Objects.*;

	import Sprites.CMask;
	
	import Box2D.Dynamics.b2Body;
	
	public class CRunBox2DBaseParent extends CRunBaseParent
	{
		public var base:CRunBox2DBase = null;
		public var parent:CRunBox2DBaseParent;
		public var currentParticule1:CRunBox2DBaseElementParent;
		public var currentParticule2:CRunBox2DBaseElementParent;
		public var currentElement:CRunBox2DBaseElementParent;
		public var collidingHO:CObject;
		//public CRunMBase currentObject;
		public var stopped:Boolean;
		public var particules:CArrayList;
		public var toDestroy:CArrayList;
		public var gObstacle:Number= 0;
		public var gDirection:Number= 0;
		public var gFriction:Number= 0;
		public var gRestitution:Number= 0;
		
		
		
		public override function getNumberOfConditions():int {
			return 0;
		}
		
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean {
			return false;
		}
		
		
		public override function handleRunObject():int {
			return REFLAG_ONESHOT;
		}
		
		
		public override function displayRunObject():void {
		}		
		
		public override function destroyRunObject(bFast:Boolean):void {
		}
		
		
		public override function pauseRunObject():void {
		}
		
		
		public override function continueRunObject():void {
		}
		
		
		public override function getZoneInfos():void {
		}
		
		
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			return false;
		}
		
		
		public override function action(num:int, act:CActExtension):void {
		}
		
		
		public override function expression(num:int):CValue {
			return new CValue(0);
		}
		
		
		public override function getRunObjectCollisionMask(flags:int):CMask {
			return null;
		}
		
		
		public override function getRunObjectFont():CFontInfo {
			return null;
		}
		
		
		public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void {
		}
		
		
		public override function getRunObjectTextColor():int {
			return 0;
		}
		
		
		public override function setRunObjectTextColor(rgb:int):void {
		}
		
		public override function rStartObject():Boolean {
			return false;
		}
		
		public override function rAddNormalObject(pHo:CObject):void {
		}
		
		public override function rAddObject(mBase:CRunMBase):void {
		}
		
		public override function rRemoveObject(mBase:CRunMBase):void {
		}
		
		public override function rCreateBullet(angle:Number, speed:Number, pMBase:CRunMBase):b2Body {
			return null;
		}
		public override function rDestroyBody(body:b2Body):void {
		}
	}
}