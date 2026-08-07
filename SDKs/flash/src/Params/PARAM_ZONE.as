//----------------------------------------------------------------------------------
//
// PARAM_ZONE: zone a l'ecran
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;

	public class PARAM_ZONE extends CParam
	{
	    public var x1:int;
	    public var y1:int;
	    public var x2:int;
	    public var y2:int;
		
		public function PARAM_ZONE()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        x1=app.file.readShort();
	        y1=app.file.readShort();
	        x2=app.file.readShort();
	        y2=app.file.readShort();
	    }
	}
}