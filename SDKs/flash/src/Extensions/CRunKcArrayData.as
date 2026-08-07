//----------------------------------------------------------------------------------
//
// CRunKcArray: array object
//
//----------------------------------------------------------------------------------
package Extensions
{
	public class CRunKcArrayData
	{
	    public var lDimensionX:int;
	    public var lDimensionY:int;
	    public var lDimensionZ:int;
	    public var lFlags:int;
	    //indicies will never be 1-based
	    public var lIndexA:int;
	    public var lIndexB:int;
	    public var lIndexC:int;
	     
	    //int			lArraySize;
	    public var numberArray:Array;
	    public var stringArray:Array;
		
	    public function CRunKcArrayData(flags:int, dimX:int, dimY:int, dimZ:int) 
	    {	    	
	        dimX = Math.max(1, dimX);
	        dimY = Math.max(1, dimY);
	        dimZ = Math.max(1, dimZ);
	    	
	        lFlags = flags;
	        lDimensionX = dimX;
	        lDimensionY = dimY;
	        lDimensionZ = dimZ;
	        if ((flags & 0x0001) != 0)          // ARRAY_TYPENUM
	        {
	            numberArray = new Array(dimZ*dimY*dimX);
	        }
	        else if ((flags & 0x0002) != 0)         // ARRAY_TYPETXT
	        {
	            stringArray = new Array(dimZ*dimY*dimX);
	        }
	    } 

	    public function oneBased():int
	    {
	        if ((lFlags & 0x0004) != 0)     // INDEX_BASE1
	        {
	            return 1;
	        }
	        return 0;
	    }
	    public function expand(newX:int, newY:int, newZ:int):void
	    {
	        //inputs should always be equal or larger than current dimensions
            var temp:Array = new Array(lDimensionZ*lDimensionY*lDimensionX);
            var x:int, y:int, z:int;
            if (numberArray!=null)
            {
	            for (z = 0; z < lDimensionZ; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        temp[z*lDimensionY*lDimensionX+y*lDimensionX+x] = numberArray[z*lDimensionY*lDimensionX+y*lDimensionX+x];
	                    }
	                }
	            }
	            numberArray = new Array(newZ*newY*newX);
	            for (z = 0; z < lDimensionZ; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        numberArray[z*newY*newX+y*newX+x] = temp[z*lDimensionY*lDimensionX+y*lDimensionX+x];
	                    }
	                }
	            }
            }
            else if (stringArray!=null)
            {
	            for (z = 0; z < lDimensionZ; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        temp[z*lDimensionY*lDimensionX+y*lDimensionX+x] = stringArray[z*lDimensionY*lDimensionX+y*lDimensionX+x];
	                    }
	                }
	            }
	            numberArray = new Array(newZ*newY*newX);
	            for (z = 0; z < lDimensionZ; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        stringArray[z*newY*newX+y*newX+x] = temp[z*lDimensionY*lDimensionX+y*lDimensionX+x];
	                    }
	                }
	            }
            }
	        lDimensionX = newX;
	        lDimensionY = newY;
	        lDimensionZ = newZ;
	    }
	    public function clean():void
	    {
	    	var x:int, y:int, z:int;
	        if ((lFlags & 0x0001) != 0)         // ARRAY_TYPENUM
	        {
	            for (z = 0; z < lDimensionZ; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        numberArray[z*lDimensionY*lDimensionX+y*lDimensionX+x] = 0;
	                    }
	                }
	            }
	        }
	        else if ((lFlags & 0x0002) != 0)        // ARRAY_TYPETXT
	        {
	            for (z = 0; z < lDimensionX; z++)
	            {
	                for (y = 0; y < lDimensionY; y++)
	                {
	                    for (x = 0; x < lDimensionX; x++)
	                    {
	                        stringArray[z*lDimensionY*lDimensionX+y*lDimensionX+x] = null;
	                    }
	                }
	            }           
	        }
	    }
	}
}