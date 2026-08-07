//----------------------------------------------------------------------------------
//
// CMOVEDEFRACE : données du mouvement racecar
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDefRace extends CMoveDef
	{
	    public var mrSpeed:int;
	    public var mrAcc:int;	
	    public var mrDec:int;	
	    public var mrRot:int;	
	    public var mrBounceMult:int;
	    public var mrAngles:int;
	    public var mrOkReverse:int;

		public function CMoveDefRace()
		{
		}

	    public override function load(file:CFile, length:int):void
	    {
	        mrSpeed=file.readAShort();
	        mrAcc=file.readAShort();	
	        mrDec=file.readAShort();	
	        mrRot=file.readAShort();	
	        mrBounceMult=file.readAShort();
	        mrAngles=file.readAShort();
	        mrOkReverse=file.readAShort();        
	    }

	}
}