//----------------------------------------------------------------------------------
//
// PARAM_CMPTIME
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_CMPTIME extends CParam
	{
	    public var timer:int;
	    public var loops:int;
	    public var comparaison:int;

		public function PARAM_CMPTIME()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        timer=app.file.readAInt();
	        loops=app.file.readAInt();
	        comparaison=app.file.readAShort();
	    }    
	}
}