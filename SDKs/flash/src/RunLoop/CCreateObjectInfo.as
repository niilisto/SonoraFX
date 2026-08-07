//----------------------------------------------------------------------------------
//
// CCREATEOBJECTINFO: informations pour la creation des objets
//
//----------------------------------------------------------------------------------
package RunLoop
{
	import Frame.CLO;
	
	public class CCreateObjectInfo
	{
	    public static var COF_HIDDEN:int=0x0002;
	    
	    public var cobLevObj:CLO;				// Leave first!
	    public var cobLevObjSeg:int;
	    public var cobFlags:int;
	    public var cobX:int;
	    public var cobY:int;
	    public var cobDir:int;
	    public var cobLayer:int;
	    public var cobZOrder:int;
	
		public function CCreateObjectInfo()
		{
		}

	}
}