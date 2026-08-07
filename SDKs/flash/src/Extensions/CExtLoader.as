//----------------------------------------------------------------------------------
//
// CEXTLOADER: Chargement des extensions
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Application.*;
	
	import Services.*;

	public class CExtLoader
	{
	    public static var KPX_BASE:int = 32;
	    public var app:CRunApp;
	    public var extensions:Array;
	    public var numOfConditions:Array;
	
	    public function CExtLoader(a:CRunApp)
	    {
	        app = a;
	    }
	    
	    public function loadList(file:CFile):void
	    {
	        var extCount:int = file.readAShort();
	        var extMaxHandle:int = file.readAShort();
	
	        extensions = new Array(extMaxHandle);
	        numOfConditions = new Array(extMaxHandle);
	        var n:int;
	        for (n = 0; n < extMaxHandle; n++)
	        {
	            extensions[n] = null;
	        }
	
	        for (n = 0; n < extCount; n++)
	        {
	            var e:CExtLoad = new CExtLoad();
	            e.loadInfo(file);
	
	            var ext:CRunExtension = e.loadRunObject();
				if (ext!=null)
				{
					extensions[e.handle] = e;
	            	numOfConditions[e.handle] = ext.getNumberOfConditions();
				}
	        }
	    }

	    public function loadRunObject(type:int):CRunExtension 
	    {
	        type -= KPX_BASE;
			var ext:CRunExtension=null;
			if (type<extensions.length && extensions[type]!=null)
			{
	        	 ext= extensions[type].loadRunObject();
			}
	        return ext;
	    }
	
	    public function getNumberOfConditions(type:int):int
	    {
			type-=KPX_BASE;
			if (type<extensions.length)
			{
		        return numOfConditions[type];
			}
			return 0;
	    }

	}
}