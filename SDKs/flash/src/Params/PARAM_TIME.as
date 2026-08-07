//----------------------------------------------------------------------------------
//
// CPARAMTIME: un parametre duree
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_TIME extends CParam
	{
	    public var timer:int;
	    public var loops:int;
	    		
		public function PARAM_TIME()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        timer=app.file.readAInt();
	        loops=app.file.readAInt();
	    }
	}
}