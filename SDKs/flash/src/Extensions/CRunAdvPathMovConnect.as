//----------------------------------------------------------------------------------
//
// CRunAdvPathMov: advanced path movement object
//
//----------------------------------------------------------------------------------
package Extensions
{
	public class CRunAdvPathMovConnect
	{
	    public var PointID:int;
		public var Distance:Number;
		
		public function CRunAdvPathMovConnect(PID:int, Dist:Number)
		{
	        PointID = PID;
	        Distance = Dist;
		}
	}
}