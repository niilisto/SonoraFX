//----------------------------------------------------------------------------------
//
// CSYSEVENTCLICK : un evenement click
//
//----------------------------------------------------------------------------------
package Application
{
	import RunLoop.*;
	
	public class CSysEventClick extends CSysEvent
	{
    	public var key:int;
    	public var clicks:int;

		public function CSysEventClick(kk:int, cl:int)
		{
			key=kk;
			clicks=cl;
		}
	    public override function execute(rhPtr:CRun):void
	    {
			rhPtr.rhEvtProg.onMouseButton(key, clicks);
			rhPtr.setFocus();
			if (clicks==1)
			{
				rhPtr.click();
			}
			if (clicks==2)
			{
				rhPtr.doubleClick();
			}
	    }	    
	}
}