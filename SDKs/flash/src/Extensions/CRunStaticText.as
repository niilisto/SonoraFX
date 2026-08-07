//----------------------------------------------------------------------------------
//
// CRUNSTATICTEXT: extension object
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
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CRunStaticText extends CRunExtension
	{
	    public var styles:int;
	    public var exStyles:int;
	    public var backColor:int;
	    public var fontColor:int;
	    public var fontInfo:CFontInfo;
	    public var alignement:int;
	    public var text:String;
	    public var lClickCount:int=-1;
	    public var rClickCount:int=-1;
	    public var dblClickCount:int=-1;
	    public var bVisible:Boolean;
		public var plane:Sprite;
		public var textField:TextField;
		public var sprite:Sprite;
		
		public function CRunStaticText()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 4;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoImgWidth = file.readInt();
	        ho.hoImgHeight = file.readInt();
	        styles = file.readInt();
	        exStyles = file.readInt();
	        fontInfo = file.readLogFont();
	        file.readStringSize(40);
	        fontColor = file.readColor();
	        backColor = file.readColor();
	        alignement = file.readInt();
	        text = file.readString();
	        bVisible = false;
	        if ((styles & 0x10000000) != 0)	// WS_VISIBLE
	        {
	            bVisible = true;
	        }
	
			plane=ho.hoAdRunHeader.rhApp.planeControls;
			sprite=new Sprite();
			plane.addChild(sprite);
			textField=new TextField();
			sprite.addChild(textField);
			sprite.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			sprite.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			createDisplay();
		
	        return false;
	    }

		public function createDisplay():void
		{
			// Le sprite
			var sBorder:int=0;
			if ((styles & 0x00800000) != 0)
			{
				sBorder=1;
				if ((exStyles & 0x00020200) != 0)
				{
					sBorder=3;
				}
			}
			sprite.graphics.clear();
			sprite.graphics.beginFill(backColor);
			sprite.graphics.drawRect(0, 0, ho.hoImgWidth, ho.hoImgHeight);
			sprite.graphics.endFill();
			if (sBorder!=0)
			{
				if (sBorder==1)
				{
					sprite.graphics.lineStyle(1, 0x000000);
					sprite.graphics.drawRect(0, 0, ho.hoImgWidth-1, ho.hoImgHeight-1);
				}
				else
				{
					sprite.graphics.lineStyle(1, 0x698790);
					sprite.graphics.drawRect(0, 0, ho.hoImgWidth-1, ho.hoImgHeight-1);
					sprite.graphics.lineStyle(1, 0xFFFFFF);
					sprite.graphics.drawRect(1, 1, ho.hoImgWidth-3, ho.hoImgHeight-3);
					sprite.graphics.lineStyle(1, 0x696969);
					sprite.graphics.moveTo(2, ho.hoImgHeight-3);
					sprite.graphics.lineTo(2,2);
					sprite.graphics.lineTo(ho.hoImgWidth-3, 2);
					sprite.graphics.lineStyle(1, 0xE3E3E3);
					sprite.graphics.lineTo(ho.hoImgWidth-3, ho.hoImgHeight-3);
					sprite.graphics.lineTo(2, ho.hoImgHeight-3);
				}
			}

			// Le textfield	
			textField.width=ho.hoImgWidth;
			textField.height=1000;			
			var textFormat:TextFormat=fontInfo.getTextFormat();
			textFormat.align=TextFormatAlign.LEFT;
	        switch (alignement)
	        {
	            case 1:
	                textFormat.align=TextFormatAlign.CENTER;
	                break;
	            case 2:
	                textFormat.align=TextFormatAlign.RIGHT;
	                break;
	        }
			textFormat.color=fontColor;
			textField.border=false;			
	        textField.background=false;
	        textField.text=text;
	        textField.setTextFormat(textFormat);
	        textField.selectable=true;
	     	textField.x=sBorder;
	        if ((styles&0x00000200)==0)
	        {
	        	textField.y=sBorder;
	        }
	        else
	        {
		        var syText:int=textField.textHeight+4;
				textField.y=ho.hoImgHeight/2-syText/2;
	        }
		}

		public override function click():void
		{
            lClickCount = ho.getEventCount();
            ho.pushEvent(0, 0);	    // CND_LCLICK
	    }

		public override function doubleClick():void
		{
            dblClickCount = ho.getEventCount();
            ho.pushEvent(2, 0);	    // CND_DBLCLICK
	    }

		public override function destroyRunObject(bFlag:Boolean):void
		{
			plane.removeChild(sprite);
		}

		public override function displayRunObject():void
		{
			sprite.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			sprite.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
		}
		
	    public override function getRunObjectFont():CFontInfo 
	    {
	        return fontInfo;
	    }
	
	    public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void
	    {
	        fontInfo = fi;
	        if (rc != null)
	        {
	            ho.setWidth(rc.right);
	            ho.setHeight(rc.bottom);
	        }
	        createDisplay();
	    }
	
	    public override function getRunObjectTextColor():int
	    {
	        return fontColor;
	    }
	
	    public override function setRunObjectTextColor(rgb:int):void
	    {
	        fontColor = rgb;
	        createDisplay();
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case 0:
	                return cndLClick(cnd);
	            case 1:
	                return cndRClick(cnd);
	            case 2:
	                return cndDblClick(cnd);
	            case 3:
	                return cndIsVisible(cnd);
	        }
	        return false;
	    }
	
	    public function cndLClick(cnd:CCndExtension):Boolean
	    {
	        // Si condition placee en premier: toujours vrai!
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	
	        // Si condition en second, regarder le numero de la boucle
	        if (lClickCount == ho.getEventCount())
	        {
	            return true;
	        }
	
	        return false;
	    }
	
	    public function cndRClick(cnd:CCndExtension):Boolean
	    {
	        // Si condition placee en premier: toujours vrai!
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	
	        // Si condition en second, regarder le numero de la boucle
	        if (rClickCount == ho.getEventCount())
	        {
	            return true;
	        }
	
	        return false;
	    }
	
	    public function cndDblClick(cnd:CCndExtension):Boolean
	    {
	        // Si condition placee en premier: toujours vrai!
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	
	        // Si condition en second, regarder le numero de la boucle
	        if (dblClickCount == ho.getEventCount())
	        {
	            return true;
	        }
	
	        return false;
	    }
	
	    public function cndIsVisible(cnd:CCndExtension):Boolean
	    {
	        return bVisible;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case 0:
	                actHide(act);
	                break;
	            case 1:
	                actShow(act);
	                break;
	            case 2:
	                actSetWidth(act);
	                break;
	            case 3:
	                actSetHeight(act);
	                break;
	            case 4:
	                actSetText(act);
	                break;
	            case 5:
	                actSetTextColor(act);
	                break;
	            case 6:
	                actSetBackColor(act);
	                break;
	        }
	    }
	
	    public function actHide(act:CActExtension):void
	    {
	        bVisible = false;
	        sprite.visible=false;
	    }
	
	    public function actShow(act:CActExtension):void
	    {
	        bVisible = true;
	        sprite.visible=true;
	    }
	
	    public function actSetWidth(act:CActExtension):void
	    {
	        var width:int = act.getParamExpression(rh, 0);
	        if (width > 0)
	        {
	            ho.setWidth(width);
	            createDisplay();
	        }
	    }
	
	    public function actSetHeight(act:CActExtension):void
	    {
	        var height:int = act.getParamExpression(rh, 0);
	        if (height > 0)
	        {
	            ho.setHeight(height);
	            createDisplay();
	        }
	    }
	
	    public function actSetText(act:CActExtension):void
	    {
	        text = act.getParamExpString(rh, 0);
	        createDisplay();
	    }
	
	    public function actSetTextColor(act:CActExtension):void
	    {
	        var color:int = act.getParamExpression(rh, 0);
	        fontColor=color;
	        createDisplay();
	    }
	
	    public function actSetBackColor(act:CActExtension):void
	    {
	        var color:int = act.getParamExpression(rh, 0);
	        backColor=color;
	        createDisplay();
	    }

	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case 0:
	                return expGetWidth();
	            case 1:
	                return expGetHeight();
	            case 2:
	                return expGetText();
	        }
	        return null;
	    }
	
	    public function expGetWidth():CValue
	    {
	        return new CValue(ho.getWidth());
	    }
	
	    public function expGetHeight():CValue
	    {
	        return new CValue(ho.getHeight());
	    }
	
	    public function expGetText():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(text);
	        return ret;
	    }
		
	}
}