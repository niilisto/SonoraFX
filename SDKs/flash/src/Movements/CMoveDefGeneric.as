//----------------------------------------------------------------------------------
//
// CMOVEDEFGENERIC : données du mouvement generique
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDefGeneric extends CMoveDef
	{
    	public var mgSpeed:int;
	    public var mgAcc:int;
	    public var mgDec:int;
	    public var mgBounceMult:int;
	    public var mgDir:int;

		public function CMoveDefGeneric()
		{
		}
	    public override function load(file:CFile, length:int):void
	    {
	        mgSpeed=file.readAShort();
	        mgAcc=file.readAShort();
	        mgDec=file.readAShort();
	        mgBounceMult=file.readAShort();
	        mgDir=file.readAInt();        
	    }
	}
}