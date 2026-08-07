//----------------------------------------------------------------------------------
//
// CMOVEDEFMOUSE : données du mouvement mouse
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDefMouse extends CMoveDef
	{
	    public var mmDx:int;      				
	    public var mmFx:int;
	    public var mmDy:int;
	    public var mmFy:int;
	    public var mmFlags:int;

		public function CMoveDefMouse()
		{
		}
		
	    public override function load(file:CFile, length:int):void
	    {
	        mmDx=file.readShort();
	        mmFx=file.readShort();
	        mmDy=file.readShort();
	        mmFy=file.readShort();
	        mmFlags=file.readAShort();
	    }
	}
}