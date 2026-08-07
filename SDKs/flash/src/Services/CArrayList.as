package Services 
{
	//----------------------------------------------------------------------------------
	//
	// CARRAYLIST : classe extensible de stockage
	//
	//----------------------------------------------------------------------------------
	public class CArrayList 
	{
		private const GROWTH_STEP:int=5;
		
		private var array:Array;
		private var numberOfEntries:int;
		
		
		public function CArrayList() 
		{			
		}
		public function getArray(max:int):void
		{
			if (array==null)
			{            
				array=new Array(max+GROWTH_STEP);
			}
			else if (max>=array.length)
			{
				var tempArray:Array=new Array(max+GROWTH_STEP);
				var n:int;
				for (n=0; n<array.length; n++)
				{
					tempArray[n]=array[n];
				}
				array=tempArray;
			}
		}
		public function ensureCapacity(max:int):void
		{
			getArray(max);
		}
		public function add(o:Object):void
		{
			getArray(numberOfEntries);
			array[numberOfEntries++]=o;
		}
		public function isEmpty():Boolean
		{
			return numberOfEntries==0;
		}
		public function insert(index:int, o:Object):void
		{
			getArray(numberOfEntries);
			var n:int;
			for (n=numberOfEntries; n>index; n--)
			{
				array[n]=array[n-1];
			}
			array[index]=o;
			numberOfEntries++;
		}
		
		public function get(index:int):Object
		{
			if (array!=null)
			{
				if (index<array.length)
				{
					return array[index];
				}
			}
			return null;
		}
		public function set(index:int, o:Object):void 
		{
			if (array!=null)
			{
				if (index<array.length)
				{
					array[index]=o;
				}
			}
		}
		public function removeIndex(index:int):void
		{
			if (array!=null)
			{
				if (index<array.length && numberOfEntries>0)
				{
					var n:int;
					for (n=index; n<numberOfEntries-1; n++)
					{
						array[n]=array[n+1];
					}
					numberOfEntries--;
					array[numberOfEntries]=null;
				}
			}
		}
		public function indexOf(o:Object):int
		{
			var n:int;
			for (n=0; n<numberOfEntries; n++)
			{
				if (array[n]==o)
				{
					return n;
				}
			}
			return -1;
		}
		public function contains(o:Object): Boolean 
		{
			var ret:int = -1;
			if(o != null)
			{
				ret = indexOf(o);
			}			
			return (ret != -1 ? true : false);
		}
		public function removeObject(o:Object):void
		{
			var n:int=indexOf(o);
			if (n>=0)
			{
				removeIndex(n);
			}
		}
		public function size():int
		{
			return numberOfEntries;
		}
		public function clear():void
		{
			numberOfEntries=0;
		}		
		public function swap(object1:Object, object2:Object):void
		{
			var index1:int=indexOf(object1);
			var index2:int=indexOf(object2);
			if (index1>=0 && index2>=0)
			{
				var temp:Object=array[index1];
				array[index1]=array[index2];
				array[index2]=temp;
			}
		}
		
		public function swapindex(index1:int, index2:int):void
		{
			if (index1>=0 && index2>=0)
			{
				var temp:Object=array[index1];
				array[index1]=array[index2];
				array[index2]=temp;
			}
		}

	}
	
}