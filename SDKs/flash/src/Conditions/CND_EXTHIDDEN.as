// ------------------------------------------------------------------------------
// 
// CACHE?
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Conditions.*;

	import Objects.*;

	import RunLoop.*;

	import Sprites.*;

	public class CND_EXTHIDDEN extends CCnd implements IEvaObject
	{
		public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
		{
			return evaObject(rhPtr, this);
		}
		public override function eva2(rhPtr:CRun):Boolean
		{
			return evaObject(rhPtr, this);
		}
		public function evaObjectRoutine(hoPtr:CObject):Boolean
		{
			if ( (hoPtr.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)!=0 ) 
				return true;
			return false;
		}
	}
}