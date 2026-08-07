package Extensions
{
	import Services.*;

	public class CRunMultipleTouchItem
	{
		public var id:int;
		public var x:Number;
		public var y:Number;
		public var free:Boolean;
		
		public var startX:Number;
		public var startY:Number;
		public var dragX:Number;
		public var dragY:Number;
		
		public function CRunMultipleTouchItem(id:int, x:Number, y:Number)
		{
			this.id = id;
			
			this.startX = this.dragX = this.x = x;
			this.startY = this.dragY = this.y = y;	
			
			this.free = false;
		}
	}
}