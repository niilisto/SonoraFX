//----------------------------------------------------------------------------------
//
// CRUNCALCRECT
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
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class CRunCalcRect extends CRunExtension
	{
		private static var ACT_SetFont:int = 0;
		private static var ACT_SetText:int = 1;
		private static var ACT_SetMaxWidth:int = 2;
		private static var ACT_CalcRect:int = 3;
		private static var EXP_GetWidth:int = 0;
		private static var EXP_GetHeight:int = 1;

	    private var text:String = "";
	    private var fontName:String = "";
	    private var fontHeight:int = 10;
	    private var fontBold:Boolean = false;
	    private var fontItalic:Boolean = false;
	    private var fontUnderline:Boolean = false;
	    private var maxWidth:int = 10000;
	    private var calcWidth:int = 0;
	    private var calcHeight:int = 0;

	    private static var MAX_HEIGHTS:int = 40;
    	private var aHeightNormalToLF:Array=
	    [
	        0, // 0
	        1, // 1
	        2, // 2
	        3, // 3
	        5, // 4
	        7, // 5
	        8, // 6
	        9, // 7
	        11, // 8
	        12, // 9
	        13, // 10
	        15, // 11
	        16, // 12
	        17, // 13
	        19, // 14
	        20, // 15
	        21, // 16
	        23, // 17
	        24, // 18
	        25, // 19
	        27, // 20
	        28, // 21
	        29, // 22
	        31, // 23
	        32, // 24
	        33, // 25
	        35, // 26
	        36, // 27
	        37, // 28
	        39, // 29
	        40, // 30
	        41, // 31
	        43, // 32
	        44, // 33
	        45, // 34
	        47, // 35
	        48, // 36
	        49, // 37
	        51, // 38
	        52		// 39
	    ];
		
		public function CRunCalcRect()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        return true;
	    }


	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SetFont:
	                SetFont(act.getParamExpString(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2));
	                break;
	
	            case ACT_SetText:
	                SetText(act.getParamExpString(rh, 0));
	                break;
	
	            case ACT_SetMaxWidth:
	                SetMaxWidth(act.getParamExpression(rh, 0));
	                break;
	
	            case ACT_CalcRect:
	                CalcRect();
	                break;
	        }
	    }
		
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue;
	        switch (num)
	        {
	            case EXP_GetWidth:
	                return GetWidth();
	
	            case EXP_GetHeight:
	                return GetHeight();
	        }
	        return new CValue(0);//won't be used
	    }

	    private function CalcRect():void
	    {
	    	var textFormat:TextFormat=new TextFormat();
			textFormat.align=TextFormatAlign.LEFT;
			textFormat.font=this.fontName;
			textFormat.size=this.fontHeight;
			textFormat.bold=this.fontBold;
			textFormat.italic=this.fontItalic;
			textFormat.underline=this.fontUnderline;
	    	
	    	var textField:TextField=new TextField();
			textField.multiline=true;
			textField.wordWrap=true;
			textField.width=maxWidth;
			textField.text=text;
			textField.setTextFormat(textFormat);

			this.calcHeight=textField.textHeight;
			this.calcWidth=textField.textWidth;
	    }
	
	    private function GetHeight():CValue
	    {
	        return new CValue(this.calcHeight);
	    }
	
	    private function GetWidth():CValue
	    {
	        return new CValue(this.calcWidth);
	    }
	
	    private function SetFont(name:String, height:int, style:int):void
	    {
	        this.fontName = name;
	        this.fontHeight = heightNormalToLF(height);
	        this.fontBold = (style & 1) == 1;
	        this.fontItalic = (style & 2) == 2;
	        this.fontUnderline = (style & 4) == 4;
	    }
	
	    private function SetMaxWidth(width:int):void
	    {
	        if (width <= 0)
	        {
	            this.maxWidth = 10000;
	        }
	        else
	        {
	            this.maxWidth = width;
	        }
	    }
	
	    private function SetText(text:String):void
	    {
	        this.text = text;
	    }

	    private function heightNormalToLF(height:int):int
	    {
	        if (height < MAX_HEIGHTS)
	        {
	            return aHeightNormalToLF[height];
	        }
	        var nLogVert:int = 96;
	        return (height * nLogVert) / 72;
	    }
	
	}
}