//----------------------------------------------------------------------------------
//
// CRunWargameMap: Wargame Map object
//
//----------------------------------------------------------------------------------
package Extensions
{
	public class CRunWargameMapPathPoint
	{
	    public var x:int;
	    public var y:int;
	    public var cumulativeCost:int;
	    
		public function CRunWargameMapPathPoint(x:int, y:int, cumulativeCost:int)
		{
	        this.x = x;
	        this.y = y;
	        this.cumulativeCost = cumulativeCost;
		}
	}
}