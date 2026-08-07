//----------------------------------------------------------------------------------
//
// CPARAMOBJECT: un parametre objet
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_OBJECT extends CParam
	{
	    public var oiList:int;
	    public var oi:int;
	    public var type:int;  
	
		public function PARAM_OBJECT()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        oiList=app.file.readShort();
	        oi=app.file.readShort();
	        type=app.file.readShort();
	    }
	}
}