//----------------------------------------------------------------------------------
//
// CSYSEVENTKEYDOWN : un evenement keydown
//
//----------------------------------------------------------------------------------
package Application
{
	import RunLoop.CRun;
	
	public class CSysEventKeyDown extends CSysEvent
	{
	    public var key:int;

		public function CSysEventKeyDown(kk:int)
		{
			key=kk;
		}
	    public override function execute(rhPtr:CRun):void
	    {
			rhPtr.rhEvtProg.onKeyDown(key);
	    }	    
	}
}