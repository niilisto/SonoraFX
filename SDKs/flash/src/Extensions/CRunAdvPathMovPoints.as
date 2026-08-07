//----------------------------------------------------------------------------------
//
// CRunAdvPathMov: advanced path movement object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Services.*;
	
	public class CRunAdvPathMovPoints
	{
	    public var X:int;
	    public var Y:int;
	    public var Connections:CArrayList;
	    public var ConnectIterator:CRunAdvPathMovConnect;
	
		public function CRunAdvPathMovPoints(XX:int, YY:int)
		{
			Connections=new CArrayList();
			X=XX;
			Y=YY;
		}

	}
}