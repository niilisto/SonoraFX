//----------------------------------------------------------------------------------
//
// PARAM_STRING : une chaine
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_STRING extends CParam
	{
	    public var string:String;
		
		public function PARAM_STRING()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        string=app.file.readAString();
	    }    
	}
}