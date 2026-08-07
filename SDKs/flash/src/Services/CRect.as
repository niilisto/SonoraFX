//----------------------------------------------------------------------------------
//
// CRECT : classe rectangle similaire a celle de windows
//
//----------------------------------------------------------------------------------

package Services 
{
	public class CRect 
	{
		
		public function CRect() 
		{
			
		}
		
		public var left:int=0;
		public var top:int=0;
		public var right:int=0;
		public var bottom:int=0;
        
		public function load(file:CFile):void // throws IOException
		{
			left=file.readAInt();
			top=file.readAInt();
			right=file.readAInt();
			bottom=file.readAInt();
		}
		
		public function copyRect(srce:CRect):void
		{
			left=srce.left;
			right=srce.right;
			top=srce.top;
			bottom=srce.bottom;
		}
		
		//public function write(DataOutputStream s) // throws IOException
		//{	
			//s.writeInt(left);
			//s.writeInt(top);
			//s.writeInt(right);
			//s.writeInt(bottom);
		//}	
		//
		//public function read(DataInputStream s) //throws IOException
		//{	
			//left=s.readInt();
			//top=s.readInt();
			//right=s.readInt();
			//bottom=s.readInt();
		//}
		
		public function ptInRect(x:int, y:int):Boolean
		{
			if (x>=left && x<right && y>=top && y<bottom)
				return true;
			return false;
		}
		
		public function intersectRect(rc:CRect):Boolean
		{
			if ((left>=rc.left && left<rc.right) || (right>=rc.left && right<rc.right) || (rc.left>=left && rc.left<right) || (rc.right>=left && rc.right<right))
			{
				if ((top>=rc.top && top<rc.bottom) || (bottom>=rc.top && bottom<rc.bottom) || (rc.top>=top && rc.top<bottom) || (rc.bottom>=top && rc.bottom<bottom))
				{
					return true;
				}		
			}
			return false;
		}
		
		public function inflateRect(dx:int, dy:int):void
		{
			left -= dx;
			top -= dy;
			right += dx;
			top += dy;
		}
		
	}
	
}