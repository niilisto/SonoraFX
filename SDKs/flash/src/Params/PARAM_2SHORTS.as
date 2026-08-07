//----------------------------------------------------------------------------------
//
// PARAM_2SHORTS : deux shorts
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_2SHORTS extends CParam
	{
	    public var value1:int;
	    public var value2:int;
	    
		public function PARAM_2SHORTS()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        value1=app.file.readAShort();
	        value2=app.file.readAShort();
	    }    
	}
}