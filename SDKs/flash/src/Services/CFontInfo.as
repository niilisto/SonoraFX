//----------------------------------------------------------------------------------
//
// CFONTINFO : informations sur une fonte
//
//----------------------------------------------------------------------------------

package Services 
{
	import Application.CRunApp;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * ...
	 * @author Roman
	 * 
	 * NEED TO CHECK FONT HANDLING TO MAKE THIS  FILE WORK PROPERLY LATER!
	 */
	public class CFontInfo 
	{
		
		public function CFontInfo() 
		{
			
		}
		
		public var lfHeight:int=0; 
		public var lfWeight:int=0; 
		public var lfItalic:int=0; 
		public var lfUnderline:int=0; 
		public var lfStrikeOut:int=0; 
		public var lfFaceName:String=null;
    
	    public function createFont():void //: Font 
	    {
			//var style:int = Font.PLAIN;
			//
			//if (lfItalic!=0)
				//style|=Font.ITALIC;
			//if (lfWeight>600)
				//style|=Font.BOLD;
	/*
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
		Font fonts[]=ge.getAllFonts();
		int n;
		String name;
		for (n=0; n<fonts.length; n++)
		{
		    if (lfFaceName.compareToIgnoreCase(fonts[n].getName())==0)
		    {
			Font newFont=fonts[n].deriveFont(style, lfHeight);
			return newFont;
		    }
		}
	*/	
			// return new Font(lfFaceName, style, lfHeight);
	    }
		
	    public function copy( f:CFontInfo ):void
	    {
	        lfHeight=f.lfHeight; 
	        lfWeight=f.lfWeight; 
	        lfItalic=f.lfItalic; 
	        lfUnderline=f.lfUnderline; 
	        lfStrikeOut=f.lfStrikeOut; 
	        lfFaceName=f.lfFaceName;
	    }
		public function getTextFormat():TextFormat
		{
			var textFormat:TextFormat=new TextFormat();
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.color=0x000000;
			textFormat.font=lfFaceName;
			textFormat.size=lfHeight;
			if (lfWeight>600)
				textFormat.bold=true;
			if (lfItalic!=0)
				textFormat.italic=true;
			if (lfUnderline!=0)
				textFormat.underline=true;
				
			return textFormat;						
		}
		public function init():void
		{
			lfFaceName="Arial";
			lfHeight=13;
			lfWeight=400;
			lfItalic=0;
			lfUnderline=0;
			lfStrikeOut=0;			
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
	    //public void write(DataOutputStream stream) throws IOException
	    //{
		//stream.writeInt(lfHeight);
		//stream.writeInt(lfWeight);
		//stream.writeByte(lfItalic);
		//stream.writeByte(lfUnderline);
		//stream.writeByte(lfStrikeOut);
		//stream.writeUTF(lfFaceName);
	    //}	
		//
	    //public void read(DataInputStream stream) throws IOException
	    //{
		//lfHeight=stream.readInt();
		//lfWeight=stream.readInt();
		//lfItalic=stream.readByte();
		//lfUnderline=stream.readByte();
		//lfStrikeOut=stream.readByte();
		//lfFaceName=stream.readUTF();
	    //}		
	}
	
}