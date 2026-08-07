//----------------------------------------------------------------------------------
//
// CPATHSTEP : un pas de mouvement path
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CPathStep
	{
	    public var mdSpeed:int;
	    public var mdDir:int;
	    public var mdDx:int;
	    public var mdDy:int;
	    public var mdCosinus:int;
	    public var mdSinus:int;
	    public var mdLength:int;
	    public var mdPause:int;
	    public var mdName:String;
	
		public function CPathStep()
		{
		}

	    public function load(file:CFile):void
	    {
	        mdSpeed=file.readAByte();
	        mdDir=file.readAByte();
	        mdDx=file.readShort();
	        mdDy=file.readShort();
	        mdCosinus=file.readShort();
	        mdSinus=file.readShort();
	        mdLength=file.readAShort();
	        mdPause=file.readAShort();
	        var name:String=file.readAString();
	        if (name.length>0)
	        {
	            mdName=name;
	        }
	    }       

	}
}