//----------------------------------------------------------------------------------
//
// COILIST : liste des OI de l'application
//
//----------------------------------------------------------------------------------
package OI
{
	import Services.CChunk;
	import Services.CFile;
	import Banks.IEnum;
	
	public class COIList
	{
	    public var oiMaxIndex:int;
	    public var ois:Array;
	    public var oiMaxHandle:int;
	    public var oiHandleToIndex:Array;
	    public var oiToLoad:Array;
	    public var oiLoaded:Array;
	    public var currentOI:int;
	    
		public function COIList()
		{
		}

	    public function preLoad(file:CFile):void 
	    {
			// Alloue la table de OI
			oiMaxIndex=file.readAInt();
			ois=new Array(oiMaxIndex);
			
			// Explore les chunks
			var index:int
			oiMaxHandle=0;
			for (index=0; index<oiMaxIndex; index++)
			{
			    var chk:CChunk=new CChunk();
			    var posEnd:int;
			    while (chk.chID!=CChunk.CHUNK_LAST)
			    {
					chk.readHeader(file);
					if (chk.chSize==0)
				    	continue;
					posEnd=file.getFilePointer()+chk.chSize;
					switch(chk.chID)
					{
				    // CHUNK_OBJINFOHEADER
				    case 0x4444:
						ois[index]=new COI();
						ois[index].loadHeader(file);
						if (ois[index].oiHandle>=oiMaxHandle)
					    	oiMaxHandle=(ois[index].oiHandle+1);
						break;
				    // CHUNK_OBJINFONAME
				    case 0x4445:
						ois[index].oiName=file.readAString();
						break;
				    // CHUNK_OBJECTSCOMMON
				    case 0x4446:
						ois[index].oiFileOffset=file.getFilePointer();
						break;
					}
					// Positionne a la fin du chunk
					file.seek(posEnd);
			    }
			}
			
			// Table OI To Handle
			oiHandleToIndex=new Array(oiMaxHandle);
			for (index=0; index<oiMaxIndex; index++)
			{
			    oiHandleToIndex[ois[index].oiHandle] = index;
			}
		
			// Tables de chargement
			oiToLoad=new Array(oiMaxHandle);
			oiLoaded=new Array(oiMaxHandle);
			var n:int;
			for (n=0; n<oiMaxHandle; n++)
			{
			    oiToLoad[n]=0;
			    oiLoaded[n]=0;
			}
	    }
    	public function getOIFromHandle(handle:int):COI
    	{
			return ois[oiHandleToIndex[handle]];
    	}
    	public function getOIFromIndex(index:int):COI
    	{
			return ois[index];
    	}

    	// Exploration des OI de la frame courante
    	public function resetOICurrent():void
    	{
			var n:int;
			for (n=0; n<oiMaxIndex; n++)
			{
	    		ois[n].oiFlags&=~COI.OILF_CURFRAME;
			}
    	}
    	public function setOICurrent(handle:int):void 
    	{
			ois[oiHandleToIndex[handle]].oiFlags|=COI.OILF_CURFRAME;
    	}
    	public function getFirstOI():COI
    	{
			var n:int;
			for (n=0; n<oiMaxIndex; n++)
			{
	    		if ((ois[n].oiFlags&COI.OILF_CURFRAME)!=0)
	    		{
					currentOI=n;
					return ois[n];
	    		}
			}
			return null;
    	}
    	public function getNextOI():COI
    	{
			if (currentOI<oiMaxIndex)
			{
	    		var n:int;
	    		for (n=currentOI+1; n<oiMaxIndex; n++)
	    		{
					if ((ois[n].oiFlags&COI.OILF_CURFRAME)!=0)
					{
		    			currentOI=n;
		    			return ois[n];
					}
	    		}
			}
			return null;
    	}

    	// Chargement des OI
    	public function resetToLoad():void
    	{
			var n:int;
			for (n=0; n<oiMaxHandle; n++)
			{
	    		oiToLoad[n]=0;
			}
    	}
    	public function setToLoad(n:int):void 
    	{
			oiToLoad[n]=1;
    	}
    	public function load(file:CFile):void
    	{
			var h:int;
			for (h=0; h<oiMaxHandle; h++)
			{
	    		if (oiToLoad[h]!=0)
	    		{
					if (oiLoaded[h]==0 || (oiLoaded[h]!=0 && (ois[oiHandleToIndex[h]].oiLoadFlags&COI.OILF_TORELOAD)!=0) )
					{
		    			ois[oiHandleToIndex[h]].load(file);
		    			oiLoaded[h]=1;
					}
	    		}
	    		else
	    		{
					if (oiLoaded[h]!=0)
					{
		    			ois[oiHandleToIndex[h]].unLoad();
		    			oiLoaded[h]=0;
					}
	    		}
			}
			resetToLoad();
    	}
    	public function enumElements(enumImages:IEnum, enumFonts:IEnum):void
    	{
			var h:int;
			for (h=0; h<oiMaxHandle; h++)
			{
	    		if (oiLoaded[h]!=0)
	    		{
					ois[oiHandleToIndex[h]].enumElements(enumImages, enumFonts);
	    		}
			}
    	}
	}
}