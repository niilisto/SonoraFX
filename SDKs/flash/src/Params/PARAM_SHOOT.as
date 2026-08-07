//----------------------------------------------------------------------------------
//
// PARAM_SHOOT : creation d'objets
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_SHOOT extends CCreate
	{
	    public var shtSpeed:int;		// Speed

		public function PARAM_SHOOT()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        posOINUMParent=app.file.readShort();
	        posFlags=app.file.readShort();
	        posX=app.file.readShort();
	        posY=app.file.readShort();
	        posSlope=app.file.readShort();
	        posAngle=app.file.readShort();
	        posDir=app.file.readAInt();
	        posTypeParent=app.file.readShort();
	        posOiList=app.file.readShort();
	        posLayer=app.file.readShort();
	        cdpHFII=app.file.readShort();
	        cdpOi=app.file.readShort();
			app.file.skipBytes(4);		//cdpFree
	        shtSpeed=app.file.readAShort();
	    }
	}
}