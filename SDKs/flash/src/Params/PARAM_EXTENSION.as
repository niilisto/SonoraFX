//----------------------------------------------------------------------------------
//
// PARAM_EXTENSION : un parametre extension
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	import flash.utils.ByteArray;
	
	public class PARAM_EXTENSION extends CParam
	{
	    public var data:ByteArray;
    
	    public override function load(app:CRunApp):void
	    {
	        var size:int = app.file.readAShort();
	        app.file.skipBytes(4);	    // type + code
	        if (size > 6)
	        {
	            data = app.file.readBuffer(size - 6);
	        }
	    }
	}
}