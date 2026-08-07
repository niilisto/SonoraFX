//----------------------------------------------------------------------------------
//
// CEMBEDDEDFILE: Fichier binaire
//
//----------------------------------------------------------------------------------
package Application
{
	import Services.*;
	
	import flash.utils.ByteArray;

	public class CEmbeddedFile
	{
	    public var app:CRunApp;
	    public var path:String;
	    public var tempPath:String;
	    public var length:int;
	    public var offset:int;
	    public var data:CBinaryFile;
	    public var useCountMem:int;
	    public var useCountFile:int;
	    
	    public function CEmbeddedFile(a:CRunApp)
	    {
	        app = a;
	    }

	    public function preLoad():void
	    {
	    	// Charge le nom, ne garde que le nom de fichier
	        var l:int = app.file.readAShort();
	        path=app.file.readAStringSize(l);
	    	var pos:int=path.lastIndexOf("\\");
			if (pos>=0)
			{
				path=path.substring(pos+1);
			}			

	        length = app.file.readAInt();
	        offset = app.file.getFilePointer();
	        app.file.skipBytes(length);
	
	        useCountFile = 0;
	        data = null;
	    }

	    public function openMem():CBinaryFile
	    {
	        if (data == null)
	        {
                app.file.seek(offset);
                var array:ByteArray=app.file.readBuffer(length);
                data=new CBinaryFile(array, app.bUnicode);
	        }
	        else
	        {
	        	data.seek(0);
	        }
	        return data;
	    }

	    public function releaseFile():void
	    {
	    	data=null;
	    }
	}
}