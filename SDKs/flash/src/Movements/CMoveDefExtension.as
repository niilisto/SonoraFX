//----------------------------------------------------------------------------------
//
// CMOVEDEFEXTENSION : données d'un movement extension
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	import flash.utils.ByteArray;
	
	public class CMoveDefExtension extends CMoveDef
	{
	    public var moduleName:String;
	    public var mvtID:int;
	    public var data:ByteArray;

		public function CMoveDefExtension()
		{
		}
	    public override function load(file:CFile, length:int):void
	    {
			file.skipBytes(14);
			data=file.readBuffer(length-14);
	    }
	    public function setModuleName(name:String, id:int):void
	    {
	        moduleName=new String(name);
	        mvtID=id;
	    }
	}
}