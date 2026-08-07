//----------------------------------------------------------------------------------
//
// CRunAdvPathMov: advanced path movement object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Services.*;
	
	public class CRunAdvPathMovmyclass
	{
	    public var myvector:CArrayList;
		public var theIterator:CRunAdvPathMovPoints ;
	
		public var myjourney:CArrayList; 
		public var JourneyIterator:CRunAdvPathMovJourney;
	
		public function CRunAdvPathMovmyclass()
		{
			myvector=new CArrayList();
			myjourney=new CArrayList();
		}
	}
}