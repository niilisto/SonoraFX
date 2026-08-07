//----------------------------------------------------------------------------------
//
// CLOLIST : liste de levelobjects
//
//----------------------------------------------------------------------------------
package Frame
{
	import Application.CRunApp;
	import OI.*;
	
	public class CLOList
	{
	    public var list:Array;
	    public var handleToIndex:Array;
	    public var nIndex:int;
	    public var loFranIndex:int;
	    
		public function CLOList()
		{
		}
		
	    public function load(app:CRunApp):void
	    {
			nIndex=app.file.readAInt();
			list=new Array(nIndex);
			var n:int;
			var maxHandles:int=0;
			for (n=0; n<nIndex; n++)
			{ 
		    	list[n]=new CLO();
		    	list[n].load(app.file);
		    	if (list[n].loHandle+1>maxHandles)
		    	{
					maxHandles=list[n].loHandle+1;
		    	}
		    	var pOI:COI=app.OIList.getOIFromHandle(list[n].loOiHandle);
		    	list[n].loType=pOI.oiType;
			}
			handleToIndex=new Array(maxHandles);
			for (n=0; n<nIndex; n++)
			{
		    	handleToIndex[list[n].loHandle]=n;
			}
	    }
    	public function getLOFromIndex(index:int):CLO
    	{
			return list[index];
    	}
    	public function getLOFromHandle(handle:int):CLO
    	{
    		if (handle<handleToIndex.length)
    		{
				return list[handleToIndex[handle]];
    		}
    		return null;
    	}
    
    	// Get next LevObj
    	public function next_LevObj():CLO
    	{
			var plo:CLO;

			if ( loFranIndex < nIndex )
			{
	            do
	            {
	                plo = list[loFranIndex++];
					if ( plo.loType>=COI.OBJ_SPR )
					{
		                    return plo;
		   			}
		       	} while(loFranIndex<nIndex);
			}
			return null;
    	}

    	// Get first levObj address
    	public function first_LevObj():CLO
    	{
			loFranIndex=0;
			return next_LevObj();                     
    	}
	}
}