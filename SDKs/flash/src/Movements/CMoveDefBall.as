//----------------------------------------------------------------------------------
//
// CMOVEDEFBALL : données du mouvement ball
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.*;
	
	public class CMoveDefBall extends CMoveDef
	{
	    public var mbSpeed:int;
	    public var mbBounce:int;
	    public var mbAngles:int;
	    public var mbSecurity:int;
	    public var mbDecelerate:int;

		public function CMoveDefBall()
		{
		}
	    public override function load(file:CFile, length:int):void
	    {
	        mbSpeed=file.readAShort();
	        mbBounce=file.readAShort();
	        mbAngles=file.readAShort();
	        mbSecurity=file.readAShort();
	        mbDecelerate=file.readAShort();       
	    }
	}
}