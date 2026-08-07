//----------------------------------------------------------------------------------
//
// CVALUE : classe de calcul et de stockage de valeurs
//
//----------------------------------------------------------------------------------

package Expressions
{
	public class CValue
	{
	    public static var TYPE_INT:int=0;
	    public static var TYPE_DOUBLE:int=1;
	    public static var TYPE_STRING:int=2;
	
	    public var type:int;
	    public var intValue:int;
	    public var doubleValue:Number;
	    public var stringValue:String;

		public function CValue(v:int)
		{
			type=TYPE_INT;
			intValue=v;
		}
	    public function getType():int
	    {
			return type;
	    }
	    public function getInt():int
	    {
			switch(type)
			{
			    case 0:
					return intValue;
			    case 1:
					return int(doubleValue);
			}
			return 0;
	    }
	    public function getDouble():Number
	    {
			switch(type)
			{
			    case 0:
					return Number(intValue);
			    case 1:
					return doubleValue;
			}
			return 0;
	    }
	    public function getString():String
	    {
			if (type==TYPE_STRING)
			    return stringValue;
			return "";
	    }
	    public function forceInt(value:int):void
	    {
			type=TYPE_INT;
			intValue=value;
	    }
	    public function forceDouble(value:Number):void
	    {
			type=TYPE_DOUBLE;
			doubleValue=value;
	    }
	    public function forceString(value:String):void
	    {
			type=TYPE_STRING;
			stringValue=new String(value);
	    }
	    public function forceValue(value:CValue):void
	    {
			type=value.type;
			switch (type)
			{
			    case 0:
					intValue=value.intValue;
					break;
			    case 1:
					doubleValue=value.doubleValue;
					break;
			    case 2:
					stringValue=new String(value.stringValue);
					break;
			}
	    }
	    public function setValue(value:CValue):void
	    {
			switch (type)
			{
			    case 0:
					intValue=value.getInt();
					break;
			    case 1:
					doubleValue=value.getDouble();
					break;
			    case 2:
					stringValue=new String(value.stringValue);
					break;
			}
	    }
	    public function getCompatibleTypes(value:CValue):void
	    {
			if (type==TYPE_INT && value.type==TYPE_DOUBLE)
		    	convertToDouble();
			else if (type==TYPE_DOUBLE && value.type==TYPE_INT)
		    	value.convertToDouble();
	    }
	    public function convertToDouble():void
	    {
			if (type==TYPE_INT)
			{
			    doubleValue=Number(intValue);
			    type=TYPE_DOUBLE;
			}
	    }
	    public function convertToInt():void
	    {
			if (type==TYPE_DOUBLE)
			{
			    intValue=int(doubleValue);
			    type=TYPE_INT;
			}
	    }
	    public function add(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:	// TYPE_INT:
					intValue+=value.intValue;
					break;
			    case 1:	// TYPE_DOUBLE:
					doubleValue+=value.doubleValue;
					break;
			    case 2:	// TYPE_STRING:
					stringValue=new String(stringValue+value.stringValue);
					break;
			}
	    }
	    public function sub(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:	// TYPE_INT:
					intValue-=value.intValue;
					break;
			    case 1:	// TYPE_DOUBLE:
					doubleValue-=value.doubleValue;
					break;
			}
	    }
	    public function negate():void
	    {
			switch (type)
			{
			    case 0:
					intValue=-intValue;
					break;
			    case 1:
					doubleValue=-doubleValue;
					break;
			}
	    }
	    public function mul(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					intValue*=value.intValue;
					break;
			    case 1:
					doubleValue*=value.doubleValue;
					break;
			}
	    }
	    public function div(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					if ( value.intValue != 0 )
					    intValue/=value.intValue;
					else
					    intValue=0;
					break;
			    case 1:
					if ( value.doubleValue != 0.0 )
					    doubleValue/=value.doubleValue;
					else
					    doubleValue=0.0;
					break;
			}
	    }
	    public function pow(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					doubleValue=Math.pow(getDouble(), value.getDouble());
					type=TYPE_DOUBLE;
					break;
			    case 1:
					doubleValue=Math.pow(doubleValue, value.doubleValue);
					break;
			}
	    }
	    public function mod(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					if (value.intValue==0)
					    intValue=0;
					else
					    intValue%=value.intValue;
					break;
			    case 1:
					if (value.doubleValue==0.0)
					    doubleValue=0.0;
					else
					    doubleValue%=value.doubleValue;
					break;
			}
	    }
	    public function andLog(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					intValue&=value.intValue;
					break;
			    case 1:
					forceInt(getInt()&value.getInt());
					break;
			}
	    }
	    public function orLog(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					intValue|=value.intValue;
					break;
			    case 1:
					forceInt(getInt()|value.getInt());
					break;
			}
	    }
	    public function xorLog(value:CValue):void
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					intValue^=value.intValue;
					break;
			    case 1:
					forceInt(getInt()^value.getInt());
					break;
			}
	    }
	    public function equal(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					return (intValue==value.intValue);
			    case 1:
					return (doubleValue==value.doubleValue);
			    case 2:
					return stringValue==value.stringValue;
			}
			return false;
	    }
	    public function greater(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					return (intValue>=value.intValue);
			    case 1:
					return (doubleValue>=value.doubleValue);
			    case 2:
					return stringValue>=value.stringValue;
			}
			return false;
	    }
	    public function lower(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					return (intValue<=value.intValue);
			    case 1:
					return (doubleValue<=value.doubleValue);
			    case 2:
					return stringValue<=value.stringValue;
			}
			return false;
	    }
	    public function greaterThan(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					return (intValue>value.intValue);
			    case 1:
					return (doubleValue>value.doubleValue);
			    case 2:
					return stringValue>value.stringValue;
			}
			return false;
	    }
	    public function lowerThan(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
	
			switch (type)
			{
			    case 0:
					return (intValue<value.intValue);
			    case 1:
					return (doubleValue<value.doubleValue);
			    case 2:
					return stringValue<value.stringValue;
			}
			return false;
	    }
	    public function notEqual(value:CValue):Boolean
	    {
			if (type!=value.type)
			{
			    getCompatibleTypes(value);
			}
		
			switch (type)
			{
			    case 0:
					return (intValue!=value.intValue);
			    case 1:
					return (doubleValue!=value.doubleValue);
			    case 2:
					return stringValue!=value.stringValue;
			}
			return false;
	    }

	}
}