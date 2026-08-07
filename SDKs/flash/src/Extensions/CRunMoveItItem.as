package Extensions
{
	import Objects.CObject;
	
	public class CRunMoveItItem
	{
        public var object:CObject;
        public var sourceX:int;
        public var sourceY:int;
        public var destX:int;
        public var destY:int;
        public var cycles:int;
        public var step:int;
        
        public var next:CRunMoveItItem = null;
        public var prev:CRunMoveItItem = null;

        public function CRunMoveItItem( object:CObject, sourceX:int, sourceY:int, destX:int, destY:int, cycles:int )
        {
            this.object = object;
            this.sourceX = sourceX;
            this.sourceY = sourceY;
            this.destX = destX;
            this.destY = destY;
            this.cycles = cycles;
            this.step = 0;
        }
	}
}