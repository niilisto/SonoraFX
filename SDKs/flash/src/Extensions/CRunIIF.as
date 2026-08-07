//----------------------------------------------------------------------------------
//
// CRUNIIF
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunIIF extends CRunExtension
	{
	    private static var EXP_INT_INT:int=0;
	    private static var EXP_INT_STRING:int=1;
	    private static var EXP_INT_FLOAT:int=2;
	    private static var EXP_STRING_INT:int=3;
	    private static var EXP_STRING_STRING:int=4;
	    private static var EXP_STRING_FLOAT:int=5;
	    private static var EXP_FLOAT_INT:int=6;
	    private static var EXP_FLOAT_STRING:int=7;
	    private static var EXP_FLOAT_FLOAT:int=8;
	    private static var EXP_INT_BOOL:int=9;
	    private static var EXP_STRING_BOOL:int=10;
	    private static var EXP_FLOAT_BOOL:int=11;
	    private static var EXP_BOOL_INT:int=12;
	    private static var EXP_BOOL_STRING:int=13;
	    private static var EXP_BOOL_FLOAT:int=14;
	    private static var EXP_LAST_COMP:int=15;
	
	    private var Last:Boolean;
	    
		public function CRunIIF()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        Last=false;
	        return false;
	    }

	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_INT_INT:
	                return IntInt();
	            case EXP_INT_STRING:
	                return IntString();
	            case EXP_INT_FLOAT:
	                return IntFloat();
	            case EXP_STRING_INT:
	                return StringInt();
	            case EXP_STRING_STRING:
	                return StringString();
	            case EXP_STRING_FLOAT:
	                return StringFloat();
	            case EXP_FLOAT_INT:
	                return FloatInt();
	            case EXP_FLOAT_STRING:
	                return FloatString();
	            case EXP_FLOAT_FLOAT:
	                return FloatFloat();
	            case EXP_INT_BOOL:
	                return IntBool();
	            case EXP_STRING_BOOL:
	                return StringBool();
	            case EXP_FLOAT_BOOL:
	                return FloatBool();
	            case EXP_BOOL_INT:
	                return BoolInt();
	            case EXP_BOOL_STRING:
	                return BoolString();
	            case EXP_BOOL_FLOAT:
	                return BoolFloat();
	            case EXP_LAST_COMP:
	                return LastComp();
	        }
	        return null;
	    }

	    private function IntInt():CValue
	    {
	        //get parameters
	        var p1:int=ho.getExpParam().getInt();
	        var comp:String = ho.getExpParam().getString();
	        var p2:int = ho.getExpParam().getInt();
	        var r1:int = ho.getExpParam().getInt();
	        var r2:int = ho.getExpParam().getInt();
	
	        Last = CompareInts(p1,comp,p2);
	        if(Last)
	            return new CValue(r1);
	        else
	            return new CValue(r2);
	    }
	
	    private function IntString():CValue
	    {
	        //get parameters
	        var p1:String = ho.getExpParam().getString();
	        var comp:String = ho.getExpParam().getString();
	        var p2:String = ho.getExpParam().getString();
	        var r1:int = ho.getExpParam().getInt();
	        var r2:int = ho.getExpParam().getInt();
	
	        Last = CompareStrings(p1,comp,p2);
	        if(Last)
	            return new CValue(r1);
	        else
	            return new CValue(r2);
	    }
	
	    private function IntFloat():CValue
	    {
	        //get parameters
	        var p1:Number = ho.getExpParam().getDouble();
	        var comp:String = ho.getExpParam().getString();
	        var p2:Number = ho.getExpParam().getDouble();
	        var r1:int = ho.getExpParam().getInt();
	        var r2:int = ho.getExpParam().getInt();
	
	        Last = CompareFloats(p1,comp,p2);
	        if(Last)
	            return new CValue(r1);
	        else
	            return new CValue(r2);
	    }
	
	    private function StringInt():CValue
	    {
	        //get parameters
	        var p1:int = ho.getExpParam().getInt();
	        var comp:String = ho.getExpParam().getString();
	        var p2:int = ho.getExpParam().getInt();
	        var r1:String = ho.getExpParam().getString();
	        var r2:String = ho.getExpParam().getString();
	
	        Last = CompareInts(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceString(r1);
	        else
	        	ret.forceString(r2);
	        return ret;
	    }
	
	    private function StringString():CValue
	    {
	        //get parameters
	        var p1:String = ho.getExpParam().getString();
	        var comp:String = ho.getExpParam().getString();
	        var p2:String = ho.getExpParam().getString();
	        var r1:String = ho.getExpParam().getString();
	        var r2:String = ho.getExpParam().getString();
	
	        Last = CompareStrings(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceString(r1);
	        else
	        	ret.forceString(r2);
	        return ret;
	    }
	
	    private function StringFloat():CValue
	    {
	        //get parameters
	        var p1:Number = ho.getExpParam().getDouble();
	        var comp:String = ho.getExpParam().getString();
	        var p2:Number = ho.getExpParam().getDouble();
	        var r1:String = ho.getExpParam().getString();
	        var r2:String = ho.getExpParam().getString();
	
	        Last = CompareFloats(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceString(r1);
	        else
	        	ret.forceString(r2);
	        return ret;
	    }
	
	    private function FloatInt():CValue
	    {
	        //get parameters
	        var p1:int = ho.getExpParam().getInt();
	        var comp:String = ho.getExpParam().getString();
	        var p2:int = ho.getExpParam().getInt();
	        var r1:Number = ho.getExpParam().getDouble();
	        var r2:Number = ho.getExpParam().getDouble();
	
	        Last = CompareInts(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceDouble(r1);
	        else
	        	ret.forceDouble(r2);
	        return ret;
	    }
	
	    private function FloatString():CValue
	    {
	        //get parameters
	        var p1:String =ho.getExpParam().getString();
	        var comp:String =ho.getExpParam().getString();
	        var p2:String =ho.getExpParam().getString();
	        var r1:Number = ho.getExpParam().getDouble();
	        var r2:Number = ho.getExpParam().getDouble();
	
	        Last = CompareStrings(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceDouble(r1);
	        else
	        	ret.forceDouble(r2);
	        return ret;
	    }
	
	    private function FloatFloat():CValue
	    {
	        //get parameters
	        var p1:Number=ho.getExpParam().getDouble();
	        var comp:String = ho.getExpParam().getString();
	        var p2:Number = ho.getExpParam().getDouble();
	        var r1:Number=ho.getExpParam().getDouble();
	        var r2:Number = ho.getExpParam().getDouble();
	
	        Last = CompareFloats(p1,comp,p2);
	        var ret:CValue=new CValue(0);
	        if (Last)
	        	ret.forceDouble(r1);
	        else
	        	ret.forceDouble(r2);
	        return ret;
	    }
	
	    private function IntBool():CValue
	    {
	        //get parameters
	        var p1:Boolean = ho.getExpParam().getInt()!=0;
	        var r1:int = ho.getExpParam().getInt();
	        var r2:int = ho.getExpParam().getInt();
	
	        if(p1)
	            return new CValue(r1);
	        else
	            return new CValue(r2);
	    }
	
	    private function StringBool():CValue
	    {
	        //get parameters
	        var p1:Boolean = ho.getExpParam().getInt()!=0;
	        var r1:String = ho.getExpParam().getString();
	        var r2:String = ho.getExpParam().getString();
	
	        var ret:CValue=new CValue(0);
	        if (p1)
	        	ret.forceString(r1);
	        else
	        	ret.forceString(r2);
	        return ret;
	    }
	
	    private function FloatBool():CValue
	    {
	        //get parameters
	        var p1:Boolean = ho.getExpParam().getInt()!=0;
	        var r1:Number=ho.getExpParam().getDouble();
	        var r2:Number =ho.getExpParam().getDouble();
	
	        var ret:CValue=new CValue(0);
	        if (p1)
	        	ret.forceDouble(r1);
	        else
	        	ret.forceDouble(r2);
	        return ret;
	    }
	
	    private function BoolInt():CValue
	    {
	        //get parameters
	        var p1:int = ho.getExpParam().getInt();
	        var comp:String = ho.getExpParam().getString();
	        var p2:int = ho.getExpParam().getInt();
	
	        Last = CompareInts(p1,comp,p2);
	        if (Last)
	            return new CValue(1);
	        else
	            return new CValue(0);
	    }
	
	    public function BoolString():CValue
	    {
	        //get parameters
	        var p1:String = ho.getExpParam().getString();
	        var comp:String = ho.getExpParam().getString();
	        var p2:String = ho.getExpParam().getString();
	
	        Last = CompareStrings(p1,comp,p2);
	        if (Last)
	            return new CValue(1);
	        else
	            return new CValue(0);
	    }
	
	    public function BoolFloat():CValue
	    {
	        //get parameters
	        var p1:Number = ho.getExpParam().getDouble();
	        var comp:String = ho.getExpParam().getString();
	        var p2:Number = ho.getExpParam().getDouble();
	
	        Last = CompareFloats(p1,comp,p2);
	        if (Last)
	            return new CValue(1);
	        else
	            return new CValue(0);
	    }
	
	    public function LastComp():CValue
	    {
	        if (Last)
	            return new CValue(1);
	        else
	            return new CValue(0);
	    }

	    // ============================================================================
	    //
	    // MATT'S FUNCTIONS
	    //
	    // ============================================================================
	    private function CompareInts(p1:int, comp:String, p2:int):Boolean
	    {
	        //catch NULL
	        if(comp == null)
	            return p1 == p2;
	
	        if((comp.charAt(0)=="=") || (comp.charAt(0) == "\0"))
	            return p1 == p2;
	        if(comp.charAt(0) == "!")
	            return p1 != p2;
	
	        if(comp.charAt(0) == ">")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1>=p2;
	            return p1>p2;
	        }
	
	        if(comp.charAt(0) == "<")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1 <= p2;
	            if(comp.length>1 && comp.charAt(1) == ">")
	                return p1 != p2;
	            return p1 < p2;
	        }
	
	        //default
	        return p1 == p2;
	    }
	
	    private function CompareStrings(p1:String, comp:String, p2:String):Boolean
	    {
	        //catch NULLs
	        var NullStr:String = "";
	        if(p1 == null)
	            p1 = NullStr;
	        if(p2 == null)
	            p2 = NullStr;
	
	        if(comp == null)
	            return p1==p2;
	
	        if((comp.charAt(0) == "=") || (comp.charAt(0) == "\0"))
	            return p1==p2;
	        if(comp.charAt(0) == "!")
	            return p1!=p2;
	
	        if(comp.charAt(0) == ">")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1>=p2;
	            return p1>p2;
	        }
	
	        if(comp.charAt(0) == "<")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1<=p2;
	            if(comp.length>1 && comp.charAt(1) == ">")
	                return p1!=p2;
	            return p1<p2;
	        }
	
	        return p1==p2;
	    }
	
	    private function CompareFloats(p1:Number, comp:String, p2:Number):Boolean
	    {
	        //catch NULL
	        if(comp == null)
	            return p1 == p2;
	
	        if((comp.charAt(0) == "=") || (comp.charAt(0) == "\0"))
	            return p1 == p2;
	        if(comp.charAt(0) == "!")
	            return p1 != p2;
	
	        if(comp.charAt(0) == ">")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1 >= p2;
	            return p1 > p2;
	        }
	
	        if(comp.charAt(0) == "<")
	        {
	            if(comp.length>1 && comp.charAt(1) == "=")
	                return p1 <= p2;
	            if(comp.length>1 && comp.charAt(1) == ">")
	                return p1 != p2;
	            return p1 < p2;
	        }
	
	        //default
	        return p1 == p2;
	    }

	}
}