package Services
{
	public class Enum
	{
		public function Enum(values:Array, initialValue:String)
		{
			if (values == null)
				_values = new Array();
			else
				_values = values;
			this.value = initialValue;
		}
		
		protected var _values:Array;
		
		private var _index:int;
		
		public function get index():int
		{
			return _index;
		}
		public function set index(val:int):void
		{
			if(val = _values.length)
				throw new ArgumentError("Enum set index : supplied value of " + val + " is outside current range of 0 – " + _values.length – 1 + ", determined by this Enum’s array [" + _values.toString()"]");
			_index = value;
		}
		
		public function set value(value:String):void
		{
			_index = _values.indexOf(value);
			if(_index == -1)
				throw new ArgumentError("Enum set value : supplied value of " + value + " is not a recognized entry, available values are " + _values.toString());
		}
		public function get value():String
		{
			return _values[_index].toString();
		}
	}
}