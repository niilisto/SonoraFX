//----------------------------------------------------------------------------------
//
// CLO : un level object
//
//----------------------------------------------------------------------------------
package Frame
{
	import Services.CFile;
	
	public class CLO
	{
    	public static var PARENT_NONE:int=0;
    	public static var PARENT_FRAME:int=1;
    	public static var PARENT_FRAMEITEM:int=2;
    	public static var PARENT_QUALIFIER:int=3;
    
    	public var loHandle:int;			// Le handle
    	public var loOiHandle:int;			// HOI
    	public var loX:int;				// Coords
    	public var loY:int;
    	public var loParentType:int;			// Parent type
    	public var loOiParentHandle:int;		// HOI Parent
    	public var loLayer:int;			// Layer
    	public var loType:int;
    	public var loInstances:Array;			// Sprite handles for backdrop objects from layers > 1

		public function CLO()
		{
			loInstances=new Array(4);
			var i:int;
			for (i=0; i<4; i++)
			{
	    		loInstances[i]=null;
			}
		}
	    public function load(file:CFile):void
	    {
			loHandle=file.readAShort();
			loOiHandle=file.readAShort();
			loX=file.readAInt();
			loY=file.readAInt();
			loParentType=file.readAShort();
			loOiParentHandle=file.readAShort();
			loLayer=file.readAShort();
			file.skipBytes(2);
	    }
	    public function addInstance(num:int, bi:CBackInstance):void
	    {
	    	loInstances[num]=bi;
	    }
	}
}