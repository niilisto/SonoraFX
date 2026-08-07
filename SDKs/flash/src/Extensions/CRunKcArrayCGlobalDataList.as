//----------------------------------------------------------------------------------
//
// CRunKcArray: array object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Services.*;
	
	public class CRunKcArrayCGlobalDataList extends CExtStorage
	{
	    public var dataList:CArrayList;
	    public var names:CArrayList;
	        
		public function CRunKcArrayCGlobalDataList()
		{
	        dataList = new CArrayList();
	        names = new CArrayList();
		}
	    public function FindObject(objectName:String):CRunKcArrayData 
	    {
	    	var i:int;
	        for (i = 0; i < names.size(); i++)
	        {
	        	var s:String=String(names.get(i));
	            if (s==objectName)
	            {
	                return CRunKcArrayData(dataList.get(i));
	            }
	        }
	        return null;
	    }
	    public function AddObject(o:CRunKcArray):void
	    {
	        dataList.add(o.pArray);
	        names.add(o.ho.hoOiList.oilName);
	    }
	}
}