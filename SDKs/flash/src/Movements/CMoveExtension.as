//----------------------------------------------------------------------------------
//
// CMOVEEXTENSIOn : Mouvement extension
//
//----------------------------------------------------------------------------------
package Movements
{
	import Objects.*;
	
	import Services.*;
	import Application.*;

	public class CMoveExtension extends CMove
	{
	    public var movement:CRunMvtExtension;
		public var callParam1:Number;
		public var callParam2:Number;

		public function CMoveExtension(m:CRunMvtExtension)
		{
			movement=m;
		}
	    public override function init(ho:CObject, mvPtr:CMoveDef):void
	    {
	        hoPtr = ho;
	
	        var mdExt:CMoveDefExtension = CMoveDefExtension(mvPtr);
	        var file:CBinaryFile = new CBinaryFile(mdExt.data, ho.hoAdRunHeader.rhApp.bUnicode);
	        movement.initialize(file);
	        hoPtr.roc.rcCheckCollides = true;			//; Force la detection de collision
	        hoPtr.roc.rcChanged = true;
	    }

	    public override function kill():void
	    {
	        movement.kill();
	    }
	
	    public override function move():void
	    {
			if (movement.move())
			{
	        	hoPtr.roc.rcChanged = true;
			}
	    }
	
	    public override function stop():void
	    {
	        movement.stop(rmCollisionCount == hoPtr.hoAdRunHeader.rh3CollisionCount);	    // Sprite courant?
	    }
	
	    public override function start():void
	    {
	        movement.start();
	    }
	
	    public override function bounce():void
	    {
	        movement.bounce(rmCollisionCount == hoPtr.hoAdRunHeader.rh3CollisionCount);    // Sprite courant?
	    }
	
	    public override function setSpeed(speed:int):void
	    {
	        movement.setSpeed(speed);
	    }
	
	    public override function setMaxSpeed(speed:int):void
	    {
	        movement.setMaxSpeed(speed);
	    }
	
	    public override function reverse():void
	    {
	        movement.reverse();
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        movement.setXPosition(x);
	        hoPtr.roc.rcChanged = true;
	        hoPtr.roc.rcCheckCollides = true;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        movement.setYPosition(y);
	        hoPtr.roc.rcChanged = true;
	        hoPtr.roc.rcCheckCollides = true;
	    }
	
	    public override function setDir(dir:int):void
	    {
	        movement.setDir(dir);
	        hoPtr.roc.rcChanged = true;
	        hoPtr.roc.rcCheckCollides = true;
	    }
	
		public function callMovement(func:int, param:Number):Number
	    {
	        callParam1 = param;
	        return movement.actionEntry(func);
	    }
		public function callMovement2(func:int, param1:Number, param2:Number):Number
		{
				callParam1=param1;
				callParam2=param2;
				return movement.actionEntry(func);
		}
		public function stopped():Boolean
		{
			return this.movement.stopped();
		}
	}
}