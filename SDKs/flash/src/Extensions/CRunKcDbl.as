//----------------------------------------------------------------------------------
//
// CRunKcDbl: Double precision calculator object
//
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunKcDbl extends CRunExtension	
	{
	    public static var ACT_SETFORMAT_STD:int = 0;
	    public static var ACT_SETFORMAT_NDIGITS:int = 1;
	    public static var ACT_SETFORMAT_NDECIMALS:int = 2;
	    public static var EXP_ADD:int = 0;
	    public static var EXP_SUB:int = 1;
	    public static var EXP_MUL:int = 2;
	    public static var EXP_DIVIDE:int = 3;
	    public static var EXP_FMT_NDIGITS:int = 4;
	    public static var EXP_FMT_NDECIMALS:int = 5;
		
	    public var m_nDigits:int;
	    public var m_nDecimals:int;

	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoX = cob.cobX;
	        ho.hoY = cob.cobY;
	        ho.hoImgWidth = 32;
	        ho.hoImgHeight = 32;
	
	        m_nDigits = 32;
	        m_nDecimals = -1;
	
	        return true;
	    }
	
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SETFORMAT_STD:
	                Act_SetFormat_Std();
	                break;
	            case ACT_SETFORMAT_NDIGITS:
	                Act_SetFormat_NDigits(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETFORMAT_NDECIMALS:
	                Act_SetFormat_NDecimals(act.getParamExpression(rh, 0));
	                break;
	        }
	    }
	    
	    public function Act_SetFormat_Std():void
	    {
	        m_nDigits = 32;
	        m_nDecimals = -1;
	    }
	
	    public function Act_SetFormat_NDigits(n:int):void
	    {
	        m_nDigits = n;
	        if (m_nDigits <= 0)
	        {
	            m_nDigits = 1;
	        }
	        if (m_nDigits > 256)
	        {
	            m_nDigits = 256;
	        }
	        m_nDecimals = -1;
	    }
	
	    public function Act_SetFormat_NDecimals(n:int):void
	    {
	        m_nDecimals = n;
	        if (m_nDecimals < 0)
	        {
	            m_nDecimals = 0;
	        }
	        else if (m_nDecimals > 256)
	        {
	            m_nDecimals = 256;
	        }
	    }
	
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_ADD:
	                return Exp_Add(ho.getExpParam().getString(), ho.getExpParam().getString());
	            case EXP_SUB:
	                return Exp_Sub(ho.getExpParam().getString(), ho.getExpParam().getString());
	            case EXP_MUL:
	                return Exp_Mul(ho.getExpParam().getString(), ho.getExpParam().getString());
	            case EXP_DIVIDE:
	                return Exp_Div(ho.getExpParam().getString(), ho.getExpParam().getString());
	            case EXP_FMT_NDIGITS:
	                return Exp_Fmt_NDigits(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_FMT_NDECIMALS:
	                return Exp_Fmt_NDecimals(ho.getExpParam().getString(), ho.getExpParam().getInt());
	        }
	        return new CValue(0);//won't be used
	    }
	
	    public function StringToDouble(ps:String):Number
	    {
	    	var val:CFuncVal=new CFuncVal();
	    	val.parse(ps);
	    	return val.doubleValue;
	    }
	
	    public function DoubleToString(v:Number):String
	    {
	        var param:String=v.toString();
	        return param;
	    }
	
	    public function Exp_Add(pValStr1:String, pValStr2:String):CValue
	    {
	        var pDest:String = "";
	        if (pValStr1 != null && pValStr2 != null)
	        {
	            var val1:Number = StringToDouble(pValStr1);
	            var val2:Number = StringToDouble(pValStr2);
	            val1 += val2;
	            pDest = DoubleToString(val1);
	        }
	        var ret:CValue=new CValue(0);
	        ret.forceString(pDest);
	        return ret;
	    }
	
	    public function Exp_Sub(pValStr1:String, pValStr2:String):CValue
	    {
	        var pDest:String = "";
	        if (pValStr1 != null && pValStr2 != null)
	        {
	            var val1:Number = StringToDouble(pValStr1);
	            var val2:Number = StringToDouble(pValStr2);
	            val1 -= val2;
	            pDest = DoubleToString(val1);
	        }
	        var ret:CValue=new CValue(0);
	        ret.forceString(pDest);
	        return ret;
	    }
	
	    public function Exp_Mul(pValStr1:String, pValStr2:String):CValue
	    {
	        var pDest:String = "";
	        if (pValStr1 != null && pValStr2 != null)
	        {
	            var val1:Number = StringToDouble(pValStr1);
	            var val2:Number = StringToDouble(pValStr2);
	            val1 *= val2;
	            pDest = DoubleToString(val1);
	        }
	        var ret:CValue=new CValue(0);
	        ret.forceString(pDest);
	        return ret;
	    }
	
	    public function Exp_Div(pValStr1:String, pValStr2:String):CValue
	    {
	        var pDest:String = "";
	        if (pValStr1 != null && pValStr2 != null)
	        {
	            var val1:Number = StringToDouble(pValStr1);
	            var val2:Number = StringToDouble(pValStr2);
	            if (val2 != 0.0)
	            {
	                val1 /= val2;
	                pDest = DoubleToString(val1);
	            }
	        }
	        var ret:CValue=new CValue(0);
	        ret.forceString(pDest);
	        return ret;
	    }
	
	    public function Exp_Fmt_NDigits(param:String, n:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(param);
	    	return ret;
	    }
	
	    public function Exp_Fmt_NDecimals(param:String, n:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(param);
	    	return ret;
	    }

	}
	
}