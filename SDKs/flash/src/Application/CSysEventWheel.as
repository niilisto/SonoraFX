//----------------------------------------------------------------------------------
//
// CSYSEVENTWHEEL : un evenement mouse wheel
//
//----------------------------------------------------------------------------------
package Application
{
	import RunLoop.*;
	import Events.*;

	public class CSysEventWheel extends CSysEvent
	{
		private var delta:int;
		
		public function CSysEventWheel(d:int)
		{
			delta=d;	
		}
	    public override function execute(rhPtr:CRun):void
	    {
	    	rhPtr.rhWheelCount=rhPtr.rh4EventCount;
	    	if (delta<0)
	    	{
	        	rhPtr.rhEvtProg.handle_GlobalEvents(((-12 << 16) | 0xFFFA));		// CNDL_ONMOUSEHWEELDOWN
	     	}
	     	else
	     	{
	        	rhPtr.rhEvtProg.handle_GlobalEvents(((-11 << 16) | 0xFFFA));		// CNDL_ONMOUSEHWEELUP
	     	}
	    }	    
	}
}