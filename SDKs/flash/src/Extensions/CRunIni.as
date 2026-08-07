//----------------------------------------------------------------------------------
//
// CRUNINI : gestion d'un fichier INI
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Application.CRunApp;
	
	import Services.*;
	
	import flash.net.*;
	import flash.utils.ByteArray;
	
	public class CRunIni
	{
	    private var strings:CArrayList = null;
    	private var currentFileName:String = null;
    	private var sharedObject:SharedObject;
		private var app:CRunApp;
    	
		public function CRunIni(a:CRunApp)
		{
			app=a;
		}

		public function loadIni(fileName:String):void
		{
	        var reload:Boolean = true;
	        if (currentFileName != null)
	        {
	            if (CServices.compareStringsIgnoreCase(fileName, currentFileName))
	            {
	                reload = false;
	            }
	        }
	        if (reload)
	        {
	            saveIni();
	
	            currentFileName = fileName;
	            strings = new CArrayList();
	            do
	            {					
					var bLoaded:Boolean=false;
	            	sharedObject=SharedObject.getLocal(fileName, "/");
	            	if (sharedObject.data.array!=null)
	            	{
	            		var array:Array=sharedObject.data.array;
	            		var n:int;
	            		for (n=0; n<array.length; n++)
	            		{
	            			strings.add(String(array[n]));
	            		}
						bLoaded=true;
	            	}
					if (bLoaded==false)
					{
						var file:CBinaryFile = app.openHFile(fileName);
						if (file!=null)	
						{
							while(file.isEOF()==false)
							{
								strings.add(file.readStringEOL());
							}
							app.closeHFile(fileName);
						}
					}
	            }while(false);
	        }				
		}
	    public function saveIni():void
	    {
	        if (strings != null && currentFileName != null)
	        {
            	var array:Array=new Array(strings.size());
            	var n:int;
            	for (n=0; n<strings.size(); n++)
            	{
            		array[n]=String(strings.get(n));
            	}

                // Enregistre les données
                try
                {
					sharedObject=SharedObject.getLocal(currentFileName, "/");
					sharedObject.data.array=array;
                	sharedObject.flush();
                }
                catch(error:Error)
                {	                	
                }
	        }
	    }
		
	    private function findSection(sectionName:String):int
	    {
	        var l:int;
	        var s:String, s2:String;
	        for (l = 0; l < strings.size(); l++)
	        {
	            s = String(strings.get(l));
	            if (s.charAt(0) == "[")
	            {
	                var last:int = s.lastIndexOf("]");
	                if (last >= 1)
	                {
	                    s2 = s.substring(1, last);
	                    if (CServices.compareStringsIgnoreCase(sectionName, s2))
	                    {
	                        return l;
	                    }
	                }
	            }
	        }
	        return -1;
	    }
	
	    private function findKey(l:int, keyName:String):int
	    {
	        var s:String, s2:String;
	        var last:int;
	        for (; l < strings.size(); l++)
	        {
	            s = String(strings.get(l));
	            if (s.charAt(0) == "[")
	            {
	                return -1;
	            }
	            last = s.indexOf('=');
	            if (last >= 0)
	            {
					var start:int=0;
					while(start<last && s.charCodeAt(start)==32)
					{
						start++;
					}
					while(last>start && s.charCodeAt(last-1)==32)
					{
						last--;
					}
					if (last>start)
					{
						s2 = s.substring(0, last);			
		                if (CServices.compareStringsIgnoreCase(s2, keyName))
		                {
		                    return l;
		                }
					}
	            }
	        }
	        return -1;
	    }

	    public function getPrivateProfileString(sectionName:String, keyName:String, defaultString:String, fileName:String):String
	    {
	        loadIni(fileName);
	
	        var l:int = findSection(sectionName);
	        if (l >= 0)
	        {
	            l = findKey(l + 1, keyName);
	            if (l >= 0)
	            {
	                var s:String = String(strings.get(l));
	                var last:int = s.indexOf("=");
	                return s.substring(last + 1);
	            }
	        }
	        return defaultString;
	    }
	
	    public function writePrivateProfileString(sectionName:String, keyName:String, name:String, fileName:String):void
	    {
	        loadIni(fileName);
	
	        var s:String;
	        var section:int = findSection(sectionName);
	        if (section < 0)
	        {
	            s = "[" + sectionName + "]";
	            strings.add(s);
	            s = keyName + "=" + name;
	            strings.add(s);
	            saveIni();
	            return;
	        }
	
	        var key:int = findKey(section + 1, keyName);
	        if (key >= 0)
	        {
	            s = keyName + "=" + name;
	            strings.set(key, s);
	            saveIni();
	            return;
	        }
	
	        for (key = section + 1; key < strings.size(); key++)
	        {
	            s = String(strings.get(key));
	            if (s.charAt(0) == '[')
	            {
	                s = keyName + "=" + name;
	                strings.insert(key, s);
		            saveIni();
	                return;
	            }
	        }
	        s = keyName + "=" + name;
	        strings.add(s);
            saveIni();
	    }
	
	    public function deleteItem(group:String, item:String, iniName:String):void
	    {
	        loadIni(iniName);
	
	        var s:int = findSection(group);
	        if (s >= 0)
	        {
	            var k:int = findKey(s + 1, item);
	            if (k >= 0)
	            {
	                strings.removeIndex(k);
	            }
	            saveIni();
	        }
	    }
	
	    public function deleteGroup(group:String, iniName:String):void
	    {
	        loadIni(iniName);
	
	        var s:int = findSection(group);
	        if (s >= 0)
	        {
	            strings.removeIndex(s);
	            while (true)
	            {
	            	s++;
	                if (s >= strings.size())
	                {
	                    break;
	                }
	                if (( String(strings.get(s))).charAt(0) == '[')
	                {
	                    break;
	                }
	                strings.removeIndex(s);
	            }
	            saveIni();
	        }
	    }
		
	}
}