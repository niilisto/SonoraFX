//----------------------------------------------------------------------------------
//
// PARAM_GROUPOINTER pointeur sur groupe d'evenements 
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_GROUPOINTER extends CParam
	{
	    public var pointer:int;
	    public var id:int;
		
		public function PARAM_GROUPOINTER()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        app.file.skipBytes(4);
	        id=app.file.readAShort();
	    }    
	}
}