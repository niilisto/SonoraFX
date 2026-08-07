//----------------------------------------------------------------------------------
//
// CRUNMVTEXTENSION : classe abstraite de mouvement extension
//
//----------------------------------------------------------------------------------
package Movements
{
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class CRunMvtExtension
	{
	    public var ho:CObject;
	    public var rh:CRun;

		public function CRunMvtExtension()
		{
		}

	    public function init(hoPtr:CObject):void
	    {
	        ho = hoPtr;
	        rh = ho.hoAdRunHeader;
	    }
	
	    public function initialize(file:CBinaryFile):void
	    {	    	
	    }
	
	    public function kill():void
	    {	    	
	    }
	
	    public function move():Boolean
	    {
	    	return false;	    	
	    }
	
	    public function setPosition(x:int, y:int):void
	    {	    	
	    }
	
	    public function setXPosition(x:int):void
	    {	    	
	    }
	
	    public function setYPosition(y:int):void
		{			
		}
			
	    public function stop(bCurrent:Boolean):void
	    {	    	
	    }
	
	    public function bounce(bCurrent:Boolean):void
	    {	    	
	    }
	
	    public function reverse():void
	    {	    	
	    }
	
	    public function start():void
	    {	    	
	    }
	
	    public function setSpeed(speed:int):void
	    {	    	
	    }
	
	    public function setMaxSpeed(speed:int):void
	    {	    	
	    }
	
	    public function setDir(dir:int):void
	    {	    	
	    }
	
	    public function setAcc(acc:int):void
	    {	    	
	    }
	
	    public function setDec(dec:int):void
	    {	    	
	    }
	
	    public function setRotSpeed(speed:int):void
	    {	    	
	    }
	
	    public function set8Dirs(dirs:int):void
	    {	    	
	    }
	
	    public function setGravity(gravity:int):void
	    {	    	
	    }
	
	    public function extension(func:int, param:int):int
	    {
	    	return 0;
	    }
	
	    public function actionEntry(action:int):Number
	    {
	    	return 0;	
	    }
	
	    public function getSpeed():int
	    {
	    	return 0;
	    }
	
	    public function getAcceleration():int
	    {
	    	return 0;
	    }
	
	    public function getDeceleration():int
	    {
	    	return 0;
	    }
	
	    public function getGravity():int
	    {
	    	return 0;
	    }

		public function getDir():int {
			return ho.roc.rcDir;
		}

		public function stopped():Boolean {
			return ho.roc.rcSpeed == 0;
		}
		
	    // Callback routines
	    // -------------------------------------------------------------------------
	    public function dirAtStart(dir:int):int
	    {
	        return ho.rom.dirAtStart(ho, dir, 32);
	    }
	
	    public function animations(anm:int):void
	    {
	        ho.roc.rcAnim = anm;
	        if (ho.roa != null)
	        {
	            ho.roa.animate();
	        }
	    }
	
	    public function collisions():void
	    {
	        ho.hoAdRunHeader.rh3CollisionCount++;
	        ho.rom.rmMovement.rmCollisionCount = ho.hoAdRunHeader.rh3CollisionCount;
	        ho.hoAdRunHeader.newHandle_Collisions(ho);
	    }
	
	    public function approachObject(destX:int, destY:int, originX:int, originY:int, htFoot:int, planCol:int, ptDest:CPoint):Boolean
	    {
	        destX -= ho.hoAdRunHeader.rhWindowX;
	        destY -= ho.hoAdRunHeader.rhWindowY;
	        originX -= ho.hoAdRunHeader.rhWindowX;
	        originY -= ho.hoAdRunHeader.rhWindowY;
	        var bRet:Boolean = ho.rom.rmMovement.mpApproachSprite(destX, destY, originX, originY, htFoot, planCol, ptDest);
	        ptDest.x += ho.hoAdRunHeader.rhWindowX;
	        ptDest.y += ho.hoAdRunHeader.rhWindowY;
	        return bRet;
	    }
	
	    public function moveIt():Boolean
	    {
	        if (ho.rom.rmMovement.newMake_Move(ho.roc.rcSpeed, ho.roc.rcDir))
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function testPosition(x:int, y:int, htFoot:int, planCol:int, flag:Boolean):Boolean
	    {
	        return ho.rom.rmMovement.tst_SpritePosition(x, y, htFoot, planCol, flag);
	    }
	
	    public function getJoystick(player:int):int
	    {
	        return ho.hoAdRunHeader.rhPlayer[player];
	    }
	
	    public function colMaskTestRect(x:int, y:int, sx:int, sy:int, layer:int, plan:int):Boolean
	    {
	        if (ho.hoAdRunHeader.colMask_Test_Rect(x, y, sx, sy, layer, plan))
	        {
	            return false;
	        }
	        return true;
	    }
	
	    public function colMaskTestPoint(x:int, y:int, layer:int, plan:int):Boolean
	    {
	        if (ho.hoAdRunHeader.colMask_Test_XY(x, y, layer, plan))
	        {
	            return false;
	        }
	        return true;
	    }
	
	    public function getParamDouble():Number
	    {
	        var mvt:CMoveExtension = CMoveExtension(ho.rom.rmMovement);
	        return mvt.callParam1;
	    }	
		
		public function getParam1():Number {
			var mvt:CMoveExtension=CMoveExtension(ho.rom.rmMovement);
			return mvt.callParam1;
		}
		
		public function getParam2():Number {
			var mvt:CMoveExtension=CMoveExtension(ho.rom.rmMovement);
			return mvt.callParam2;
		}	
		
		public function AngleToDir(angle:Number):int {
			var nDir:int=int(Math.floor((angle%360)/11.25));
			nDir += (nDir<0 ? 32: 0);
			return nDir;
		}
		
		
	}
}