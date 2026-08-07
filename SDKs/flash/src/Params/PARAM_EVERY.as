//----------------------------------------------------------------------------------
//
// CPARAMEVERY: duree
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;

	public class PARAM_EVERY extends CParam
	{
	    public var delay:int;
	    public var compteur:int;
	
		public function PARAM_EVERY()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        delay=app.file.readAInt();
	        compteur=app.file.readAInt();
	    }
	}
}