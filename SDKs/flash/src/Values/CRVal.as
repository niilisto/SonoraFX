//----------------------------------------------------------------------------------
//
// CRVAL : Alterable values et strings
//
//----------------------------------------------------------------------------------
package Values
{
	import Expressions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	public class CRVal
	{
	    public static var VALUES_NUMBEROF_ALTERABLE:int=26;
	    public static var STRINGS_NUMBEROF_ALTERABLE:int=10;
	    
	    public var rvValueFlags:int;
	    public var rvValues:Array;
	    public var rvStrings:Array;
	
		public function CRVal()
		{
		}

	    public function init(ho:CObject, ocPtr:CObjectCommon, cob:CCreateObjectInfo):void
	    {
			// Creation des tableaux
	        rvValueFlags=0;
			rvValues=new Array(VALUES_NUMBEROF_ALTERABLE);
			rvStrings=new Array(STRINGS_NUMBEROF_ALTERABLE);
			var n:int;
			for (n=0; n<VALUES_NUMBEROF_ALTERABLE; n++)
			{
			    rvValues[n]=null;
			}
			for (n=0; n<STRINGS_NUMBEROF_ALTERABLE; n++)
			{
			    rvStrings[n]=null;
			}
		
			// Initialisation des valeurs
			if (ocPtr.ocValues!=null)
			{
			    var value:CValue;
			    for (n=0; n<ocPtr.ocValues.nValues; n++)
			    {
					value=getValue(n);
					value.forceInt(ocPtr.ocValues.values[n]);
			    }
			}
			if (ocPtr.ocStrings!=null)
			{
			    for (n=0; n<ocPtr.ocStrings.nStrings; n++)
			    {
					rvStrings[n]=ocPtr.ocStrings.strings[n];
			    }
			}
	    }
	    public function kill(bFast:Boolean):void
	    {
			var n:int;
			for (n=0; n<VALUES_NUMBEROF_ALTERABLE; n++)
			{
			    rvValues[n]=null;
			}
			for (n=0; n<STRINGS_NUMBEROF_ALTERABLE; n++)
			{
			    rvStrings[n]=null;
			}
	    }
	    public function getValue(n:int):CValue
	    {
			if (rvValues[n]==null)
			{
			    rvValues[n]=new CValue(0);
			}
			return rvValues[n];
	    }
	    public function getString(n:int):String
	    {
			if (rvStrings[n]==null)
			{
			    rvStrings[n]=new String("");
			}
			return rvStrings[n];
	    }
	    public function setString(n:int, s:String):void
	    {
			rvStrings[n]=new String(s);
	    }

	}
}