//----------------------------------------------------------------------------------
//
// PARAM_COLOUR : une valeur RGB
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_COLOUR extends CParam	
	{
	    public var color:int;

		public function PARAM_COLOUR()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        color=app.file.readAColor();
	    }    
	}
}