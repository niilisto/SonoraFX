//----------------------------------------------------------------------------------
//
// CPARAMKEY: une touche
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_KEY extends CParam
	{
	    public var key:int;
		
		public function PARAM_KEY()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        key=app.file.readAShort();
	        key=CKeyConvert.getFlashKey(key);
	    }    
	}
}