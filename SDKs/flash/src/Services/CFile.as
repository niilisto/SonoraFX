//----------------------------------------------------------------------------------
//
// CFILE : chargement des fichiers dans le bon sens
//
//----------------------------------------------------------------------------------

// Assumptions: The datafile is always stored in a byte array in the swf file so no file handling, this bytearray is passed to this object

package Services 
{
	import flash.utils.ByteArray;
	
	import mx.core.ByteArrayAsset;

	/**
	 * ...
	 * @author Roman
	 */
	public class CFile 
	{
		public var data:ByteArrayAsset;
	    public var bUnicode:Boolean;
		
		
		public function CFile(d:ByteArrayAsset) 
		{
			data = d;
			data.position = 0;
		}

	    public function setUnicode(unicode:Boolean):void
	    {
	        bUnicode=unicode;
	    }

		public function readAByte():int
		{
			return data.readByte()&0xFF;
		}

		public function readAShort():int
		{		
			var b1:uint, b2:uint;
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			return int(b2*256+b1);
		}

		public function readShort():int
		{		
			var b1:uint, b2:uint;
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			var value:int=b2*256+b1;
			if (value<32768)
				return int(value);
			else
				return int(value-65536);
		}

	    public function readAChar():int
	    {
	        var b1:uint, b2:uint;
	        b1 = data.readUnsignedByte();
	        b2 = data.readUnsignedByte();
	        return int(b2 * 256 + b1);
	    }
	
	    public function readACharArray(size:int):Array
	    {
	    	var c:Array=new Array();
	        var b1:uint, b2:uint;
	        var n:int;
	        for (n=0; n<size; n++)
	        {
	            b1 = data.readUnsignedByte();
	            b2 = data.readUnsignedByte();
	            c[n]=(b2 * 256 + b1);
	        }
	        return c;
	    }

		public function readAInt():int
		{
			var b1:uint, b2:uint, b3:uint, b4:uint;	
			b1=data.readUnsignedByte()&0xFF;
			b2=data.readUnsignedByte()&0xFF;
			b3=data.readUnsignedByte()&0xFF;
			b4=data.readUnsignedByte()&0xFF;
			return int(b4*0x01000000+b3*0x00010000+b2*0x00000100+b1);
		}
		
		public function readAColor():int
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

		public function readAFloat():Number
		{
			var b1:uint, b2:uint, b3:uint, b4:uint;	
			
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			b3=data.readUnsignedByte();
			b4=data.readUnsignedByte();
			
			var total:int = b4 * 0x01000000 + b3 * 0x00010000 + b2 * 0x00000100 + b1;
			
			return Number(total)/65536.0;
 		}

		public function readADouble():Number
		{	
			var b1:uint, b2:uint, b3:uint, b4:uint, b5:uint, b6:uint, b7:uint, b8:uint;
			
			b1=data.readUnsignedByte();
			b2=data.readUnsignedByte();
			b3=data.readUnsignedByte();
			b4=data.readUnsignedByte();
			b5=data.readUnsignedByte();
			b6=data.readUnsignedByte();
			b7=data.readUnsignedByte();
			b8=data.readUnsignedByte();
			
			// replaced long with Number since this is the only datatype which can store 64 bit signed integer
			// NB - check this works!
//			var total1:Number=(Number(b4))*0x01000000+(Number(b3))*0x00010000+(Number(b2))*0x00000100+Number(b1);
//			var total2:Number = (Number(b8)) * 0x01000000 + (Number(b7)) * 0x00010000 + (Number(b6)) * 0x00000100 + Number(b5);
//			var total:Number = (total2*0x100000000) + total1;
//			var temp:Number = Number( total) / Number(65536.0);			
//			return temp/Number(65536.0);
			var total:Number=(Number(b8)) * 0x0100000000000000 + (Number(b7)) * 0x0001000000000000 + (Number(b6)) * 0x0000010000000000 + Number(b5)*0x0000000100000000;
			total+=(Number(b4))*0x01000000+(Number(b3))*0x00010000+(Number(b2))*0x00000100+Number(b1);
			if (total>0x8000000000000000)
			{
				total-=0xFFFFFFFFFFFFFFFF;
			}
			var ret:Number=total/0x100000000;
			return ret;
		}

		public function readAStringSize(size:int):String
		{
			var i:int;
            var n:int, m:int;
			
			if (bUnicode==false)
			{
				var b:ByteArray=readBuffer(size);
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
				var c:Array=readACharArray(size);
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
		
		public function readAString():String
		{
			var ret:String="";
			var debut:uint=data.position;
			var b:uint;
			var l:int;
			var end:uint;
			
			if (bUnicode==false)
			{
				do
				{
					b=readUnsignedByte();
				} while (b != 0);
					
				end=data.position;
				data.position = debut;
				
				if (end>debut+1)
				{
					// calculate length
					l= end - debut - 1;
					var bb:ByteArray=readBuffer(l);
					ret=bb.toString();
				}
				
				skipBytes(1);
			}
			else
			{
				do
				{
					b=readAChar();
				} while (b != 0);
					
				end=data.position;
				data.position = debut;
				
				if (end>debut+2)
				{
					// calculate length
					l = (end - debut - 2)/2;
					var cc:Array=readACharArray(l);
					ret=CServices.charArrayToString(cc);					
				}
					
				skipBytes(2);
			}
			return ret;
	    }

	    public function readAStringEOL():String
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
		        while(b!=10 && b!=13)
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
		            ret=readAStringSize(int(end-debut-delta));
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
		        b=readAChar();	        	        
		        while(b!=10 && b!=13)
		        {
		            b=readAChar();
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
		            ret=readAStringSize(int((end-debut-delta)/2));
		        }		        
		        if (b==10 || b==13)
		        {
		            skipBytes(2);
		            bb=readAChar();
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
		
		public function skipAString():void
		{
            var b:uint;
	        if (bUnicode==false)
	        {
	            do
	            {
	                b = data.readByte();
	            } while (b != 0);
	        }
	        else
	        {
	            do
	            {
	                b = readAChar();
	            } while (b != 0);
	        }
	    }	    

/*		public function readAUnicodeString():String
		{
			var debut:uint = data.position;
			var b1:int, b2:int, count:int;
			
			do
			{
				b1=data.readShort();
			} while (b1 != 0);
			
			var end:uint = data.position;
			data.position = debut;
			
			var len:int = (int((end - debut)) / 2 - 1);
			
			// java stuff : char c[] = new char[len];
			var c:ByteArray = new ByteArray();
			
			for (count=0; count<len; count++)
			{
				b1=data.readUnsignedByte();
				b2=data.readUnsignedByte();
				c.writeByte(((b2&0xFF)*255+b1&255));
			}
			skipBytes(2);
			
			return c.toString();
	    }
*/		
	    public function getFilePointer():uint
	    {
			return data.position;
	    }
	
	    public function seek(pos:uint):void
	    {
	        if (pos>=data.length)
            {
                pos=data.length;
            }				
		    data.position=pos;	
	    }

		public function skipBack(n:int):void
		{
		    var pos:uint=getFilePointer();
		    pos-=n;
		    if (pos<0)
		    {
		    	pos=0;
		    }
		    seek(pos);
		}

	    public function skipBytes(n:int):void
	    {		
	        if (data.position+n>=data.length)
			{
				n = data.length - data.position;
			}				
			data.position+=n;
	    }

	    public function readBuffer(size:int):ByteArray
	    {
			var buffer:ByteArray = new ByteArray();
			var i:int;
			
			for (i = 0; i < size; i++)
			{
				buffer.writeByte(data.readByte());
			}				
			return buffer;
	    }    

/*	    public function read(dest:ByteArray):int
	    {
		    var n:int;
		    for (n=0; n<dest.length; n++)
		    {
				dest.writeByte(data.readByte());
		    }
			
	        return n;
	    }
*/	    
		public function readBytesAsArray(a:Array):void
		{
			var n:int;
		    for (n=0; n<a.length; n++)
		    {
				a[n]=data.readByte()&0xFF;
		    }		
		}
	
	    public function readWithSize(dest:ByteArray, size:int):int
	    {	
		    var n:int;
			
		    for (n=0; n<size; n++)
		    {
				dest.writeByte(data.readByte());
		    }			
	        return n;
	    }

	    public function readUnsignedByte():uint
	    {		
			return data.readUnsignedByte();
	    }

	    public function close():void
	    {
			data = null;
	    }	
	}
}