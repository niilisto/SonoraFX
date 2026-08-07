//----------------------------------------------------------------------------------
//
// CPARAMSAMPLE: un son
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;

	public class PARAM_SAMPLE extends CParam
	{
	    public var sndHandle:int;
	    public var sndFlags:int;
		public static const PSOUNDFLAG_UNINTERRUPTABLE:int=0x0001;

		public function PARAM_SAMPLE()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        sndHandle=app.file.readAShort();
	        sndFlags=app.file.readAShort();
	    }    
	}
}