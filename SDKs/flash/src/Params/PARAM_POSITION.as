//----------------------------------------------------------------------------------
//
// CPARAMPOSITION: creation d'objets
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;

	public class PARAM_POSITION extends CPosition
	{
		public function PARAM_POSITION()
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
	    }
	}
}