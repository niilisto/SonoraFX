//----------------------------------------------------------------------------------
//
// CRCOM : Structure commune aux objets animes
//
//----------------------------------------------------------------------------------
package Objects
{
	public class CRCom
	{
	    public var rcPlayer:int=0;					// Player who controls
	    public var rcMovementType:int;				// Number of the current movement
	    public var rcAnim:int=0;						// Wanted animation
	    public var rcImage:int=-1;					// Current frame
	    public var rcScaleX:Number;					
	    public var rcScaleY:Number;
	    public var rcAngle:Number;
	    public var rcDir:int;						// Current direction
	    public var rcSpeed:int;					// Current speed
	    public var rcMinSpeed:int;					// Minimum speed
	    public var rcMaxSpeed:int;					// Maximum speed
	    public var rcChanged:Boolean;					// Flag: modified object
	    public var rcCheckCollides:Boolean;			// For static objects
	
	    public var rcOldX:int;            			// Previous coordinates
	    public var rcOldY:int;
	    public var rcOldImage:int=-1;
	    public var rcOldAngle:Number;
	    public var rcOldDir:int;
	    public var rcOldX1:int;					// For zone detections
	    public var rcOldY1:int;
	    public var rcOldX2:int;
	    public var rcOldY2:int;
	    
		public function CRCom()
		{
		}
	    public function init():void
	    {
	        rcScaleX = 1.0;
	        rcScaleY = 1.0;
	        rcAngle=0;
	        rcMovementType = -1;
	    }
	    public function kill(bFast:Boolean):void
	    {
	    }
	}
}