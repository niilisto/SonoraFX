//----------------------------------------------------------------------------------
//
// CMOVEDEFPLATFORM : données du mouvement platforme
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDefPlatform extends CMoveDef
	{
	    public var mpSpeed:int;
	    public var mpAcc:int;	
	    public var mpDec:int;	
	    public var mpJumpControl:int;
	    public var mpGravity:int;
	    public var mpJump:int;

		public function CMoveDefPlatform()
		{
		}

	    public override function load(file:CFile, length:int):void
	    {
	        mpSpeed=file.readAShort();
	        mpAcc=file.readAShort();	
	        mpDec=file.readAShort();	
	        mpJumpControl=file.readAShort();
	        mpGravity=file.readAShort();
	        mpJump=file.readAShort();        
	    }
	}
}