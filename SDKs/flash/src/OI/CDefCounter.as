//----------------------------------------------------------------------------------
//
// CDEFCOUNTER : valeurs de depart counter
//
//----------------------------------------------------------------------------------
package OI
{
	import Banks.IEnum;
	import Services.CFile;
	
	public class CDefCounter extends CDefObject
	{
    	public var ctInit:int;				// Initial value
    	public var ctMini:int;				// Minimal value
    	public var ctMaxi:int;				// Maximal value
    	
		public function CDefCounter()
		{
		}
		
    	public override function load(file:CFile):void
    	{
        	file.skipBytes(2);              // Taille
        	ctInit=file.readAInt();
        	ctMini=file.readAInt();
        	ctMaxi=file.readAInt();
    	}
    	public override function enumElements(enumImages:IEnum, enumFonts:IEnum):void 
    	{
    	}	

	}
}