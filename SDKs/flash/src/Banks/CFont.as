//----------------------------------------------------------------------------------
//
// CFONT : une fonte
//
//----------------------------------------------------------------------------------
package Banks
{
	import Services.CFile;
	import Services.CFontInfo;
	
	public class CFont
	{
	    public var useCount:int;
	    public var handle:int;
	    public var lfHeight:int; 
	    public var lfWidth:int; 
	    public var lfEscapement:int; 
	    public var lfOrientation:int; 
	    public var lfWeight:int; 
	    public var lfItalic:int; 
	    public var lfUnderline:int; 
	    public var lfStrikeOut:int; 
	    public var lfCharSet:int; 
	    public var lfOutPrecision:int; 
	    public var lfClipPrecision:int; 
	    public var lfQuality:int; 
	    public var lfPitchAndFamily:int; 
	    public var lfFaceName:String;
//	    public Font font=null;

		public function CFont()
		{
		}
	    public function loadHandle(file:CFile):void
	    {
			handle=file.readAInt();
	        if (file.bUnicode==false)
	        {
	            file.skipBytes(0x48);
	        }
	        else
	        {
	            file.skipBytes(0x68);
	        }
	    }
	    public function load(file:CFile):void
	    {
			handle=file.readAInt();
			file.skipBytes(12);		    // Trois DWORD d'entete
		
			var debut:int=file.getFilePointer();
			lfHeight=file.readAInt(); 
			if (lfHeight<0)
			    lfHeight=-lfHeight;
			lfWidth=file.readAInt(); 
			lfEscapement=file.readAInt(); 
			lfOrientation=file.readAInt(); 
			lfWeight=file.readAInt(); 
			lfItalic=file.readAByte(); 
			lfUnderline=file.readAByte(); 
			lfStrikeOut=file.readAByte(); 
			lfCharSet=file.readAByte(); 
			lfOutPrecision=file.readAByte(); 
			lfClipPrecision=file.readAByte(); 
			lfQuality=file.readAByte(); 
			lfPitchAndFamily=file.readAByte(); 
			lfFaceName=file.readAString();
			
			// Positionne a la fin
	        if (file.bUnicode==false)
	        {
	            file.seek(debut+0x3C);
	        }
	        else
	        {
	            file.seek(debut+0x5C);
	        }
//			font=null;
	    }
	    public function getFontInfo():CFontInfo
	    {
			var info:CFontInfo=new CFontInfo();
			info.lfHeight=lfHeight; 
			info.lfWeight=lfWeight; 
			info.lfItalic=lfItalic; 
			info.lfUnderline=lfUnderline; 
			info.lfStrikeOut=lfStrikeOut; 
			info.lfFaceName=new String(lfFaceName);
			return info;
	    }	  
	    public function createDefaultFont():void
	    {
			lfHeight=12; 
			lfWeight=400; 
			lfItalic=0; 
			lfUnderline=0; 
			lfStrikeOut=0; 
			lfFaceName="Arial";
	    }
		public function getEmbeddedName():String
		{
			var name:String;
			name="Emb";
			name+=lfFaceName;
			if (lfItalic!=0)
			{
				name+="Italic";
			}
			if (lfWeight>600)
			{
				name+="Bold";
			}
			return name;
		}

	}
}