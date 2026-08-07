//----------------------------------------------------------------------------------
//
// PARAM_SHORT : un parametre sur un short
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;

	public class PARAM_SHORT extends CParam
	{
	    public var value:int;
		
		public function PARAM_SHORT()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        value=app.file.readAShort();
	    }    
	}
}