//----------------------------------------------------------------------------------
//
// CRunStringTokenizer
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunStringTokenizer extends CRunExtension
	{
//		private var Split:Array;
//    	private var Split2D:Array;
    	private var Initialised:Boolean;
    	private var Tokens:CArrayList;
    	private var Tokens2D:CArrayList;
    	
    	public static var CND_LAST:int = 0;
    	public static var ACT0_SPLITSTRING0WITHDELIMITERS11D:int = 0;
    	public static var ACT1_SPLITSTRING0WITHDELIMITERS1AND22D:int = 1;
    	public static var EXP0_ELEMENTCOUNT:int = 0;
    	public static var EXP1_ELEMENT:int = 1;
    	public static var EXP2_ELEMENT2D:int = 2;
    	public static var EXP3_ELEMENTCOUNTX:int = 3;
    	public static var EXP4_ELEMENTCOUNTY:int = 4;

		public function CRunStringTokenizer()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return CND_LAST;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	Tokens=new CArrayList();
	    	Tokens2D=new CArrayList();
	    	return false;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
		       case 0: // '\0'
        		    act0_Splitstring0withdelimiters11D(act);
            		break;

        		case 1: // '\001'
            		act1_Splitstring0withdelimiters1and22D(act);
            		break;
 	        }
	    }

		private function act0_Splitstring0withdelimiters11D(act:CActExtension):void
	    {
	        var param0:String = act.getParamExpString(rh, 0);
	        var param1:String = act.getParamExpString(rh, 1);
	        Tokens.clear();
	        var Tokenizer:CRunStringTokeniser = new CRunStringTokeniser(param0, param1);
	        var TokenCount:int = Tokenizer.countTokens();
	        var i:int;
	        for(i = 0; i < TokenCount; i++)
	        {
	            Tokens.add(Tokenizer.nextToken());
	        }
	    }
	
	    private function act1_Splitstring0withdelimiters1and22D(act:CActExtension):void
	    {
	        var param0:String = act.getParamExpString(rh, 0);
	        var param1:String = act.getParamExpString(rh, 1);
	        var param2:String = act.getParamExpString(rh, 2);
	        Tokens2D.clear();
	        var XTokenizer:CRunStringTokeniser  = new CRunStringTokeniser(param0, param1);
	        var XTokenCount:int = XTokenizer.countTokens();
	        var x:int;
	        for(x = 0; x < XTokenCount; x++)
	        {
	            var New:CArrayList = new CArrayList();
	            var YTokenizer:CRunStringTokeniser  = new CRunStringTokeniser(XTokenizer.nextToken(), param2);
	            var YTokenCount:int = YTokenizer.countTokens();
	            var y:int;
	            for(y = 0; y < YTokenCount; y++)
	            {
	                New.add(YTokenizer.nextToken());
	            }	
	            Tokens2D.add(New);
	        }
	
	    }

	  	public override function expression(num:int):CValue
	    {
	        switch(num)
	        {
	        case 0: // '\0'
	            return exp0_ElementCount();
	
	        case 1: // '\001'
	            return exp1_Element();
	
	        case 2: // '\002'
	            return exp2_Element2D();
	
	        case 3: // '\003'
	            return exp3_ElementCountX();
	
	        case 4: // '\004'
	            return exp4_ElementCountY();
	        }
	        return null;
	    }
	
	    private function exp0_ElementCount():CValue
	    {
	        return new CValue(Tokens.size());
	    }
	
	    private function exp1_Element():CValue
	    {
	        var param0:int = ho.getExpParam().getInt();
	        var ret:CValue=new CValue(0);
	        var s:String=String(Tokens.get(param0));
	        if (s=="null")
	        {
	        	s="";
	        }	        
	        ret.forceString(s);
	        return ret;
	    }
	
	    private function exp2_Element2D():CValue
	    {
	        var param0:int = ho.getExpParam().getInt();
	        var param1:int = ho.getExpParam().getInt();
	        var ret:CValue=new CValue(0);
			var array:CArrayList=CArrayList(Tokens2D.get(param0));
			var s:String="";
			if (array!=null)
	        	s=String(String(array.get(param1)));
	        if (s=="null")
	        {
	        	s="";
	        }	        
	        ret.forceString(s);
	        return ret;
	    }
	
	    private function exp3_ElementCountX():CValue
	    {
	        return new CValue(Tokens2D.size());
	    }
	
	    private function exp4_ElementCountY():CValue
	    {
	        var param0:int = ho.getExpParam().getInt();
	        return new CValue((CArrayList(Tokens2D.get(param0))).size());
	    }	    
	}
}