//----------------------------------------------------------------------------------
//
// CBINARYFILE: ficher binaire en indian PC
//
//----------------------------------------------------------------------------------
package Services
{
	import Application.*;
	
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	public class CBinaryFile
	{
	    public var data:ByteArray;
	    public var bUnicode:Boolean;
	    
		public function CBinaryFile(array:ByteArray, unicode:Boolean)
		{
			if (array!=null)
			{
				data=array;
			}
			else
			{
				data=new ByteArray();
			}
			data.position=0;
			bUnicode=unicode;
		}
		
	    public function setUnicode(unicode:Boolean):void
	    {
	        bUnicode=unicode;
	    }

		public function save(fileName:String):void
		{
			var sharedObject:SharedObject;		
			try
			{
				sharedObject=SharedObject.getLocal(fileName);
				sharedObject.data.byteArray=data;
				sharedObject.flush();
			}
			catch(error:Error)
			{	                	
			}
		}
		
		public function writeByte(b:int):void
		{
			data.writeByte(b);
		}
		public function writeInt(b:int):void
		{
			data.writeByte(b&0xFF);
			data.writeByte((b>>8)&0xFF);
			data.writeByte((b>>16)&0xFF);
			data.writeByte((b>>24)&0xFF);
		}
		public function writeShort(b:int):void
		{
			data.writeByte(b&0xFF);
			data.writeByte((b>>8)&0xFF);
		}
		public function writeString(s:String):void
		{
			data.writeUTFBytes(s);
		}
		
		public function isEOF():Boolean
		{
			return data.position>=data.length;
		}
		
	    public function readByteArray(length:int):ByteArray
	    {
	        var n:int;
	        var array:ByteArray=new ByteArray();
            for (n = 0; n < length; n++)
            {
                array.writeByte(data.readByte());
            }
            return array;
	    }
	    
	    public function skipBytes(n:int):void
	    {
	    	data.position+=n;
	    }

		public function skipBack(n:int):void
		{
			var pos:int=data.position;
			pos-=n;
			if (pos<0)
			{
				pos=0;
			}
			data.position=pos;
		}
		
	
	    public function getFilePointer():int
	    {
	        return data.position;
	    }

	    public function seek(pos:int):void
	    {
	        data.position=pos;
	    }

	    public function readByte():int
	    {
	    	return data.readByte();
	    }

	    public function readShort():int
	    {
			var b1:uint, b2:uint;
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			var value:int=b2*256+b1;
			if (value<32768)
				return value;
			else
				return value-65536;
	    }

		public function readInt():int
		{
			var b1:uint, b2:uint, b3:uint, b4:uint;	
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			b3=data.readUnsignedByte();
			b4=data.readUnsignedByte();
			return b4*0x01000000+b3*0x00010000+b2*0x00000100+b1;
		}
		public function readFloat():Number
		{
			var b1:uint, b2:uint, b3:uint, b4:uint;	
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			b3=data.readUnsignedByte();
			b4=data.readUnsignedByte();
			var total:int = b4 * 0x01000000 + b3 * 0x00010000 + b2 * 0x00000100 + b1;
			if (total>0x80000000)
				total-=0xFFFFFFFF;
			return (Number)(total/65536.0);
		}
		public function adjustTo8():void
		{
			if ((data.position&0x07)!=0)
			{
				data.position+=8-(data.position&0x07);
			}
		}
		public function readColor():int
		{
			var b1:uint, b2:uint, b3:uint; 
			var c:int;
			
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			b3=data.readUnsignedByte();
			data.readUnsignedByte();
			
			c = int(b1) * 0x00010000 + int(b2) * 0x00000100 + int(b3);
			return c;
		}

	    public function readChar():int
	    {
            var b1:int, b2:int;
            b1 = data.readUnsignedByte();
            b2 = data.readUnsignedByte();
            return (b2 * 256 + b1);
	    }
	
	    public function readCharArray(size:int):Array
	    {
	    	var b:Array=new Array();
            var b1:int, b2:int;
            var n:int;
            for (n=0; n<size; n++)
            {
                b1 = data.readUnsignedByte();
                b2 = data.readUnsignedByte();
                b[n]=(b2 * 256 + b1);
            }
            return b;
	    }

		public function readString():String
		{
			var ret:String="";
			var debut:uint=data.position;
			var b:uint;
			var end:uint;
			var l:int;
			
			if (bUnicode==false)
			{
				do
				{
					b=data.readUnsignedByte();
				} while (b != 0);
					
				end=data.position;
				data.position = debut;
				
				if (end>debut+1)
				{
					// calculate length
					l= end - debut - 1;
					var bb:ByteArray=readByteArray(l);
					ret=bb.toString();
				}
				
				skipBytes(1);
			}
			else
			{
				do
				{
					b=data.readShort();
				} while (b != 0);
				
				end=data.position;
				data.position = debut;
				
				if (end>debut+2)
				{
					// calculate length
					l= (end - debut - 2)/2;
					var cc:Array=readCharArray(l);
					ret=CServices.charArrayToString(cc);					
				}
				
				skipBytes(2);
			}
			return ret;
	    }
	    
		public function readStringSize(size:int):String
		{
			var i:int;
            var n:int, m:int;
			
			if (bUnicode==false)
			{
				var b:ByteArray=readByteArray(size);
	            for (n=0; n<size; n++)
	            {
	                if (b[n]==0)
	                {
	                    break;
	                }
	            }
	            b.position=0;
	            var bb:ByteArray=new ByteArray();
	            for (m=0; m<n; m++)
	            {
	                bb.writeByte(b.readByte());
	            }
	            return bb.toString();
			}
			else
			{
				var c:Array=readCharArray(size);
	            for (n=0; n<size; n++)
	            {
	                if (c[n]==0)
	                {
	                    break;
	                }
	            }
	            var cc:Array=new Array(n);
	            for (m=0; m<n; m++)
	            {
	                cc[m]=c[m];
	            }
	            return CServices.charArrayToString(cc);
			}
		}
		
		public function readStringEOL():String
		{
			var debut:uint=data.position;
			var b:uint;
			var ret:String="";
			var end:uint;
			var delta:int;
			var bb:uint;
			
			if (bUnicode==false)
			{
				b=data.readUnsignedByte();	        	        
				while(b!=10 && b!=13 && data.position<data.length)
				{
					b=data.readUnsignedByte();
				}
				
				end = data.position;
				data.position=debut;
				delta=1;
				if (b!=10 && b!=13)
				{
					delta=0;
				}
				if (end>debut+delta)
				{
					ret=readStringSize(int(end-debut-delta));
				}		        
				if (b==10 || b==13)
				{
					skipBytes(1);
					bb=data.readUnsignedByte();
					if (b==10 && bb!=13)
					{
						skipBack(1);
					}
					if (b==13 && bb!=10)
					{
						skipBack(1);
					}            
				}        
				return ret;
			}
			else
			{
				b=readChar();	        	        
				while(b!=10 && b!=13)
				{
					b=readChar();
				}
				
				end = data.position;
				data.position=debut;
				delta=2;
				if (b!=10 && b!=13)
				{
					delta=0;
				}
				if (end>debut+delta)
				{
					ret=readStringSize(int((end-debut-delta)/2));
				}		        
				if (b==10 || b==13)
				{
					skipBytes(2);
					bb=readChar();
					if (b==10 && bb!=13)
					{
						skipBack(2);
					}
					if (b==13 && bb!=10)
					{
						skipBack(2);
					}            
				}        
				return ret;
			}
		}
		
		
	    public function readLogFont():CFontInfo
	    {
	        var info:CFontInfo = new CFontInfo();
	
	        info.lfHeight = readInt();
	        if (info.lfHeight < 0)
	        {
	            info.lfHeight = -info.lfHeight;
	        }
	        skipBytes(12);	// width - escapement - orientation
	        info.lfWeight = readInt();
	        info.lfItalic = readByte();
	        info.lfUnderline = readByte();
	        info.lfStrikeOut = readByte();
	        skipBytes(5);
	        info.lfFaceName = readStringSize(32);
	
	        return info;
	    }
	    
	    public function readLogFont16():CFontInfo 
	    {
	        var info:CFontInfo = new CFontInfo();
	
	        info.lfHeight = readShort();
	        if (info.lfHeight < 0)
	        {
	            info.lfHeight = -info.lfHeight;
	        }
	        skipBytes(6);	// width - escapement - orientation
	        info.lfWeight = readShort();
	        info.lfItalic = readByte();
	        info.lfUnderline = readByte();
	        info.lfStrikeOut = readByte();
	        skipBytes(5);
	        var oldUnicode:Boolean=bUnicode;
	        bUnicode=false;
	        info.lfFaceName = readStringSize(32);
	        bUnicode=oldUnicode;
	
	        return info;
	    }
	    
	    public function skipString():void
	    {
            var b:int;
	        if (bUnicode==false)
	        {
	            do
	            {
	                b = readByte();
	            } while (b != 0);
	        }
	        else
	        {
	            do
	            {
	                b = readChar();
	            } while (b != 0);
	        }
	    }	    
	}
}