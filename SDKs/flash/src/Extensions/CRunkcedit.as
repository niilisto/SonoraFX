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
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CRunkcedit extends CRunExtension
	{
	    // Fields
		public static var CND_VISIBLE:int = 0;
	    public static var CND_ENABLE:int = 1;
	    public static var CND_CANUNDO:int = 2;
	    public static var CND_MODIFIED:int = 3;
	    public static var CND_HAVEFOCUS:int = 4;
	    public static var CND_ISNUMBER:int = 5;
	    public static var CND_ISSELECTED:int = 6;
	    public static var CND_LAST:int = 7;
	    public static var ACT_LOADTEXT:int = 0;
	    public static var ACT_LOADTEXTSELECT:int = 1;
	    public static var ACT_SAVETEXT:int = 2;
	    public static var ACT_SAVETEXTSELECT:int = 3;
	    public static var ACT_SETTEXT:int = 4;
	    public static var ACT_REPLACESELECTION:int = 5;
	    public static var ACT_CUT:int = 6;
	    public static var ACT_COPY:int = 7;
	    public static var ACT_PASTE:int = 8;
	    public static var ACT_CLEAR:int = 9;
	    public static var ACT_UNDO:int = 10;
	    public static var ACT_CLEARUNDOBUFFER:int = 11;
	    public static var ACT_SHOW:int = 12;
	    public static var ACT_HIDE:int = 13;
	    public static var ACT_SETFONTSELECT:int = 14;
	    public static var ACT_SETCOLORSELECT:int = 15;
	    public static var ACT_ACTIVATE:int = 16;
	    public static var ACT_ENABLE:int = 17;
	    public static var ACT_DISABLE:int = 18;
	    public static var ACT_READONLYON:int = 19;
	    public static var ACT_READONLYOFF:int = 20;
	    public static var ACT_TEXTMODIFIED:int = 21;
	    public static var ACT_TEXTNOTMODIFIED:int = 22;
	    public static var ACT_LIMITTEXTSIZE:int = 23;
	    public static var ACT_SETPOSITION:int = 24;
	    public static var ACT_SETXPOSITION:int = 25;
	    public static var ACT_SETYPOSITION:int = 26;
	    public static var ACT_SETSIZE:int = 27;
	    public static var ACT_SETXSIZE:int = 28;
	    public static var ACT_SETYSIZE:int = 29;
	    public static var ACT_DESACTIVATE:int = 30;
	    public static var ACT_SCROLLTOTOP:int = 31;
	    public static var ACT_SCROLLTOLINE:int = 32;
	    public static var ACT_SCROLLTOEND:int = 33;
	    public static var ACT_SETCOLOR:int = 34;
	    public static var ACT_SETBKDCOLOR:int = 35;
	    public static var ACT_LAST:int = 36;
	    public static var EXP_GETTEXT:int = 0;
	    public static var EXP_GETSELECTION:int = 1;
	    public static var EXP_GETXPOSITION:int = 2;
	    public static var EXP_GETYPOSITION:int = 3;
	    public static var EXP_GETXSIZE:int = 4;
	    public static var EXP_GETYSIZE:int = 5;
	    public static var EXP_GETVALUE:int = 6;
	    public static var EXP_GETFIRSTLINE:int = 7;
	    public static var EXP_GETLINECOUNT:int = 8;
	    public static var EXP_GETCOLOR:int = 9;
	    public static var EXP_GETBKDCOLOR:int = 10;
	    public static var EXP_LAST:int = 11;
	    public static var EDIT_HSCROLLBAR:int = 0x0001;
	    public static var EDIT_HSCROLLAUTOSCROLL:int = 0x0002;
	    public static var EDIT_VSCROLLBAR:int = 0x0004;
	    public static var EDIT_VSCROLLAUTOSCROLL:int = 0x0008;
	    public static var EDIT_READONLY:int = 0x0010;
	    public static var EDIT_MULTILINE:int = 0x0020;
	    public static var EDIT_PASSWORD:int = 0x0040;
	    public static var EDIT_BORDER:int = 0x0080;
	    public static var EDIT_HIDEONSTART:int = 0x0100;
	    public static var EDIT_UPPERCASE:int = 0x0200;
	    public static var EDIT_LOWERCASE:int = 0x0400;
	    public static var EDIT_TABSTOP:int = 0x0800;
	    public static var EDIT_SYSCOLOR:int = 0x1000;
	    public static var EDIT_3DLOOK:int = 0x2000;
	    public static var EDIT_TRANSP:int = 0x4000;
	    public static var EDIT_ALIGN_HCENTER:int = 0x00010000;
	    public static var EDIT_ALIGN_RIGHT:int = 0x00020000;
	    
	    public var textField:TextField;
	    public var displayObject:DisplayObject;
	    
		public var textFontInfo:CFontInfo;
		public var textForeColour:int;
		public var textBackColour:int;
		public var textStyle:String;
		public var flags:int;
		public var wasmodified:Boolean;
		public var textFormat:TextFormat;
		public var bVisible:Boolean;
		public var bModified:Boolean;
		public var bEditable:Boolean;
		public var oldWidth:int;
		public var oldHeight:int;		
		public var bFocus:Boolean;
		public var limitTextSize:int;
		public var bHaveFocus:Boolean;
		public var bEnabled:Boolean;
		public var bEmbedFont:Boolean;
												
		public function CRunkcedit()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return CND_LAST;
	    }
		public function createTextFormat():TextFormat
		{
			var tf:TextFormat=new TextFormat();
			tf.align=TextFormatAlign.LEFT;
			if ((flags&EDIT_ALIGN_RIGHT)!=0)
				tf.align=TextFormatAlign.RIGHT;
			else if ((flags&EDIT_ALIGN_HCENTER)!=0)
				tf.align=TextFormatAlign.CENTER;
			tf.color=textForeColour;

			var embeddedName:String=textFontInfo.getEmbeddedName();
			var embeddedFont:int=rh.rhApp.getEmbeddedFont(embeddedName);
			bEmbedFont=false;
			if (embeddedFont>=0)
			{
				bEmbedFont=true;
				tf.font=embeddedName;
			}
			else
			{
				tf.font=textFontInfo.lfFaceName;
				if (textFontInfo.lfWeight>600)
				{
					tf.bold=true;
				}
				else
				{
					tf.bold=false;
				}
				if (textFontInfo.lfItalic!=0)
				{
					tf.italic=true;
				}
				else
				{
					tf.italic=false;
				}
				if (textFontInfo.lfUnderline!=0)
				{
					tf.underline=true;
				}
				else
				{
					tf.underline=false;
				}
			}
			tf.size=textFontInfo.lfHeight;			
			return tf;
		}
			
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        // Read in edPtr values
	        ho.hoImgWidth = file.readShort();
	        ho.hoImgHeight = file.readShort();
	        if (ho.hoAdRunHeader.rhApp.bUnicode==false)
	        {
	            textFontInfo = file.readLogFont16();
	        }
	        else
	        {
	            textFontInfo = file.readLogFont();
	        }
	        file.skipBytes(4 * 16); // Skip custom colours
	        textForeColour = file.readColor();
	        textBackColour = file.readColor();
	        file.readStringSize(40);			// TextStyle
	        flags = file.readInt();
	
	        // Init fields
	        bModified=false;
			bFocus=false;
			limitTextSize=-1;
				
        	textField=new TextField();
        	displayObject=textField;
            if ((flags & EDIT_MULTILINE) != 0)
            {
            	textField.multiline=true;
            	textField.wordWrap=true;
            }
            else
            {
            	textField.multiline=false;
            }
        	if ((flags&EDIT_TRANSP)==0)
        	{
				textField.background=true;
				textField.backgroundColor=textBackColour;
        	}
        	else
        	{
				textField.background=false;
        	}
			if ((flags&EDIT_BORDER)!=0)
			{
				textField.border=true;
				textField.borderColor=0;
			}
			else
			{
				textField.border=false;
			}		        	            	
            if ((flags & EDIT_READONLY)!=0)
            {
            	textField.selectable=false;
            	textField.type=TextFieldType.DYNAMIC;
            	bEditable=false;
            }
            else
            {
            	textField.selectable=true;
            	textField.type=TextFieldType.INPUT;
            	bEditable=true;
            }
            if ((flags&EDIT_PASSWORD)!=0)
            {
            	textField.displayAsPassword=true;
            }
            textField.tabEnabled=false;
			textFormat=createTextFormat();
			textField.setTextFormat(textFormat);
			textField.embedFonts=bEmbedFont;
			textField.defaultTextFormat=textFormat;
			textField.addEventListener(Event.CHANGE, changeHandler);
			textField.addEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler);
			textField.addEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler);

            displayObject.width=ho.hoImgWidth;
            displayObject.height=ho.hoImgHeight;
            oldWidth=ho.hoImgWidth;
            oldHeight=ho.hoImgHeight;
            bVisible=true;
            if ((flags & EDIT_HIDEONSTART) != 0)
            {
                bVisible=false;
            }
			ho.hoAdRunHeader.rhApp.planeControls.addChild(displayObject);
			displayObject.visible=bVisible;				
			displayObject.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			displayObject.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			bHaveFocus=false;
			bEnabled=true;
			
	        return false;
	    }

		public override function destroyRunObject(bFast:Boolean):void
		{
			if (textField!=null)
			{
				textField.removeEventListener(Event.CHANGE, changeHandler);
				textField.removeEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler);
				textField.removeEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler);
			}
			ho.hoAdRunHeader.rhApp.planeControls.removeChild(displayObject);
		}
		
        public function changeHandler(e:Event):void 
        {
			bModified=true;
			var bToChange:Boolean=false;
    		var s:String=textField.text;
			if (limitTextSize>0)			
			{
	    		if (s.length>limitTextSize)
	    		{
	    			s=s.substr(0, limitTextSize);
	    			bToChange=true;
	   			}			
			}
            if ((flags & EDIT_UPPERCASE) != 0)
            {
            	s=s.toUpperCase();
            	bToChange=true;
            }
            if ((flags & EDIT_LOWERCASE) != 0)
            {
            	s=s.toLowerCase();
            	bToChange=true;
            }
            if (bToChange)
            {
				textField.text=s;
            }
        }
        public function focusInHandler(e:FocusEvent):void 
        {
        	bHaveFocus=true;
        }
        public function focusOutHandler(e:FocusEvent):void 
        {
        	bHaveFocus=false;
        }


		public override function displayRunObject():void
		{
			displayObject.x=ho.hoX-ho.hoAdRunHeader.rhWindowX;
			displayObject.y=ho.hoY-ho.hoAdRunHeader.rhWindowY;
			if (ho.hoImgWidth!=oldWidth)
			{
				displayObject.width=ho.hoImgWidth;
				oldWidth=ho.hoImgWidth;
			}
			if (ho.hoImgHeight!=oldHeight)
			{
				displayObject.height=ho.hoImgHeight;
				oldHeight=ho.hoImgHeight;
			}
		}
		
	    public override function getRunObjectFont():CFontInfo 
	    {
	        return textFontInfo;
	    }
	
	    public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void
	    {
	        textFontInfo = fi;
	        textFormat=createTextFormat();
	        if (textField!=null)
	        {
				textField.setTextFormat(textFormat);
				textField.defaultTextFormat=textFormat;
	        }
	        if (rc!=null)
	        {
	        	ho.hoImgWidth=rc.right-rc.left;
	        	ho.hoImgHeight=rc.bottom-rc.top;
	        	ho.redraw();
	        }
	    }
	
	    public override function getRunObjectTextColor():int
	    {
	        return textForeColour;
	    }
	
	    public override function setRunObjectTextColor(rgb:int):void
	    {
	        textForeColour = rgb;
	        textFormat=createTextFormat();
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat=textFormat;
	    }

		public override function setFocus(bFlag:Boolean):void
		{
            if ((flags & EDIT_READONLY)==0)
            {
            	if (bFocus!=bFlag)            	
            	{
            		bFocus=bFlag;
            		/*if (bFlag==false)
            		{
            			textField.selectable=false;
            			textField.type=TextFieldType.DYNAMIC;
            			bEditable=false;			
            		}
		            else
		            {							
		            	textField.selectable=true;
		            	textField.type=TextFieldType.INPUT;
		            	bEditable=true;
		            }*/
            	}
            }
		}
		
	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_VISIBLE:
	                return cndVISIBLE(cnd);
	            case CND_ENABLE:
	                return cndENABLE(cnd);
	            case CND_CANUNDO:
	                return cndCANUNDO(cnd);
	            case CND_MODIFIED:
	                return cndMODIFIED(cnd);
	            case CND_HAVEFOCUS:
	                return cndHAVEFOCUS(cnd);
	            case CND_ISNUMBER:
	                return cndISNUMBER(cnd);
	            case CND_ISSELECTED:
	                return cndISSELECTED(cnd);
	        }
	        return false;
	    }

	    public function cndVISIBLE(cnd:CCndExtension):Boolean
	    {
	        return bVisible;
	    }
	
	    public function cndENABLE(cnd:CCndExtension):Boolean
	    {
	        return bEditable;
	    }
	
	    public function cndCANUNDO(cnd:CCndExtension):Boolean
	    {
	        return false;
	    }
	
	    public function cndMODIFIED(cnd:CCndExtension):Boolean
	    {	
	    	var bRet:Boolean=bModified;
			return bRet;
		}
	
	    public function cndHAVEFOCUS(cnd:CCndExtension):Boolean
	    {
	        return bHaveFocus;
	    }
	
	    public function cndISNUMBER(cnd:CCndExtension):Boolean
	    {
	    	var text:String;
	    	text=textField.text;

			if (text.length>0)
			{
				var first:int=0;
				while(text.charCodeAt(first)==32)
					first++;
				if (text.charCodeAt(first)>=48 && text.charCodeAt(first)<=57)
				{
					return true;
				}	    	
			}
			return false;
	    }
	
	    private function cndISSELECTED(cnd:CCndExtension):Boolean
	    {
	    	var x1:int;
	    	var x2:int;
	    	if (textField!=null)
	    	{
	    		x1=textField.selectionBeginIndex;
	    		x2=textField.selectionEndIndex;	
	    	}
	    	if (x2>x1)
	    	{
	    		return true;
	    	}
	    	return false;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_LOADTEXT:
	                break;
	            case ACT_LOADTEXTSELECT:
	                break;
	            case ACT_SAVETEXT:
	                break;
	            case ACT_SAVETEXTSELECT:
	                break;
	            case ACT_SETTEXT:
	                actSETTEXT(act);
	                break;
	            case ACT_REPLACESELECTION:
	                actREPLACESELECTION(act);
	                break;
	            case ACT_CUT:
	                break;
	            case ACT_COPY:
	                break;
	            case ACT_PASTE:
	                break;
	            case ACT_CLEAR:
	                actCLEAR(act);
	                break;
	            case ACT_UNDO:
	                break;
	            case ACT_CLEARUNDOBUFFER:
	                break;
	            case ACT_SHOW:
	                actSHOW(act);
	                break;
	            case ACT_HIDE:
	                actHIDE(act);
	                break;
	            case ACT_SETFONTSELECT:
	                break;
	            case ACT_SETCOLORSELECT:
	                break;
	            case ACT_ACTIVATE:
					actACTIVATE(act);
					break;
	            case ACT_ENABLE:
	                actENABLE(act);
	                break;
	            case ACT_DISABLE:
	                actDISABLE(act);
	                break;
	            case ACT_READONLYON:
	                actREADONLYON(act);
	                break;
	            case ACT_READONLYOFF:
	                actREADONLYOFF(act);
	                break;
	            case ACT_TEXTMODIFIED:
	                actTEXTMODIFIED(act);
	                break;
	            case ACT_TEXTNOTMODIFIED:
	                actTEXTNOTMODIFIED(act);
	                break;
	            case ACT_LIMITTEXTSIZE:
	            	actLimitTextSize(act);
	                break;
	            case ACT_SETPOSITION:
	                actSETPOSITION(act);
	                break;
	            case ACT_SETXPOSITION:
	                actSETXPOSITION(act);
	                break;
	            case ACT_SETYPOSITION:
	                actSETYPOSITION(act);
	                break;
	            case ACT_SETSIZE:
	                actSETSIZE(act);
	                break;
	            case ACT_SETXSIZE:
	                actSETXSIZE(act);
	                break;
	            case ACT_SETYSIZE:
	                actSETYSIZE(act);
	                break;
	            case ACT_DESACTIVATE:
					actDESACTIVATE(act);		
	                break;
	            case ACT_SCROLLTOTOP:
	                actSCROLLTOTOP(act);
	                break;
	            case ACT_SCROLLTOLINE:
	                actSCROLLTOLINE(act);
	                break;
	            case ACT_SCROLLTOEND:
	                actSCROLLTOEND(act);
	                break;
	            case ACT_SETCOLOR:
	                actSETCOLOR(act);
	                break;
	            case ACT_SETBKDCOLOR:
	                actSETBKDCOLOR(act);
	                break;
	        }
	    }

		public function actDESACTIVATE(act:CActExtension):void
		{
			if(bHaveFocus == true)
			{
				if (rh.rhApp.stage!=null)
					rh.rhApp.stage.focus = rh.rhApp.stage;
			}
		}

		public function actACTIVATE(act:CActExtension):void
		{
			if(textField != null)
			{
				textFormat=createTextFormat();
				textField.defaultTextFormat=textFormat;
	        	textField.setTextFormat(textFormat);
				if (rh.rhApp.stage!=null)
					rh.rhApp.stage.focus = textField;
				textField.setSelection(0,0);
			}
		}

	    public function actLimitTextSize(act:CActExtension):void
	    {
	    	limitTextSize=act.getParamExpression(rh, 0);
	    }
	    public function actSETTEXT(act:CActExtension):void
	    {
	    	if (textField!=null)
	    	{
	    		var s:String=act.getParamExpString(rh, 0);
            	if ((flags & EDIT_UPPERCASE) != 0)
            	{
            		s=s.toUpperCase();
	            }
    	        if ((flags & EDIT_LOWERCASE) != 0)
        	    {
            		s=s.toLowerCase();
	            }
	    		textField.text=s;
	    	}
	    }
	    private function actREPLACESELECTION(act:CActExtension):void
	    {
	    	if (textField!=null)
	    	{
	    		textField.replaceSelectedText(act.getParamExpString(rh, 0));
	    	}
	    }

	    private function actCLEAR(act:CActExtension):void
	    {
	    	if (textField!=null)
	    	{
	    		textField.text="";
	    	}
	    }

	    public function actSHOW(act:CActExtension):void
	    {
    		bVisible=true;
			displayObject.visible=true;
	    }
	    
	    public function actHIDE(act:CActExtension):void
	    {
    		bVisible=false;
			displayObject.visible=false;
	    }

	    public function actENABLE(act:CActExtension):void
	    {
	    	if (bEditable)
	    	{
	    		if (textField!=null)
	    		{
	    			bEnabled=true;
                	textField.type=TextFieldType.INPUT;
            		textField.selectable=true;
       			}
	    	}
	    }
	
	    public function actDISABLE(act:CActExtension):void
	    {
    		if (textField!=null)
    		{
    			bEnabled=false;
            	textField.type=TextFieldType.DYNAMIC;
            	textField.selectable=false;
   			}
	    }

	    public function actREADONLYON(act:CActExtension):void
	    {
    		if (textField!=null)
    		{
    			bEditable=false;
    			flags|=EDIT_READONLY;
            	textField.type=TextFieldType.DYNAMIC;
            	textField.selectable=false;
				textField.mouseEnabled=false;
   			}
	    }
	
	    public function actREADONLYOFF(act:CActExtension):void
	    {
    		if (textField!=null)
    		{
    			bEditable=true;
    			flags&=~EDIT_READONLY;
            	textField.type=TextFieldType.INPUT;
            	textField.selectable=true;
				textField.mouseEnabled=false;
   			}
	    }

	    public function actTEXTMODIFIED(act:CActExtension):void
	    {
	        bModified = true;
	    }

	    public function actTEXTNOTMODIFIED(act:CActExtension):void
	    {
	        bModified = false;
	    }

	    public function actSETPOSITION(act:CActExtension):void
	    {
	        var pos:CPositionInfo = act.getParamPosition(rh, 0);
	        ho.setPosition(pos.x, pos.y);
	        ho.redraw();
	    }

	    public function actSETXPOSITION(act:CActExtension):void
	    {
	        ho.setPosition(act.getParamExpression(rh, 0), ho.hoY);
	        ho.redraw();
	    }
	
	    public function actSETYPOSITION(act:CActExtension):void
	    {
	        ho.setPosition(ho.hoX, act.getParamExpression(rh, 0));
	        ho.redraw();
    	}

	    public function actSETSIZE(act:CActExtension):void
	    {
	        ho.hoImgWidth = act.getParamExpression(rh, 0);
	        ho.hoImgHeight = act.getParamExpression(rh, 1);
	        ho.redraw();
	    }
	
	    public function actSETXSIZE(act:CActExtension):void
	    {
	        ho.hoImgWidth = act.getParamExpression(rh, 0);
	        ho.redraw();
	    }
	
	    public function actSETYSIZE(act:CActExtension):void
	    {
	        ho.hoImgHeight = act.getParamExpression(rh, 0);
	        ho.redraw();
	    }

	    public function actSCROLLTOTOP(act:CActExtension):void
	    {
	        if ((flags & EDIT_MULTILINE) != 0 && textField != null)
	        {
				textField.scrollV = 0;
	        }
	    }
	
	    public function actSCROLLTOLINE(act:CActExtension):void
	    {
	        if ((flags & EDIT_MULTILINE) != 0 && textField != null)
	        {
				textField.scrollV = act.getParamExpression(rh, 0) + 1; // +1 so it behaves like the standard runtime
	        }
	    }
	
	    public function actSCROLLTOEND(act:CActExtension):void
	    {
	        if ((flags & EDIT_MULTILINE) != 0 && textField != null)
	        {
				textField.scrollV = textField.numLines;
	        }
	    }
	
	    public function actSETCOLOR(act:CActExtension):void
	    {
	        flags = flags | ~EDIT_SYSCOLOR;
	        textForeColour = act.getParamColour(rh, 0);
	        textFormat=createTextFormat();
	        if (textField!=null)
	        {
	        	textField.defaultTextFormat=textFormat;
	        	textField.setTextFormat(textFormat);
	        }
	    }
	
	    public function actSETBKDCOLOR(act:CActExtension):void
	    {
	        flags = flags &(~(EDIT_SYSCOLOR | EDIT_TRANSP));
	    	if (textField!=null)
	    	{
	    		textField.backgroundColor=act.getParamColour(rh, 0);
	    	}
	    }
	    
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_GETTEXT:
	                return expGETTEXT();
	            case EXP_GETSELECTION:
	                return expGETSELECTION();
	            case EXP_GETXPOSITION:
	                return expGETXPOSITION();
	            case EXP_GETYPOSITION:
	                return expGETYPOSITION();
	            case EXP_GETXSIZE:
	                return expGETXSIZE();
	            case EXP_GETYSIZE:
	                return expGETYSIZE();
	            case EXP_GETVALUE:
	                return expGETVALUE();
	            case EXP_GETFIRSTLINE:
	                return expGETFIRSTLINE();
	            case EXP_GETLINECOUNT:
	                return expGETLINECOUNT();
	            case EXP_GETCOLOR:
	                return expGETCOLOR();
	            case EXP_GETBKDCOLOR:
	                return expGETBKDCOLOR();
	        }
	        return null;
	    }

	    public function expGETTEXT():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	if (textField!=null)
	    	{
	    		ret.forceString(textField.text);
	    	}
	    	return ret;
	    }
	
	    public function expGETSELECTION():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	var x1:int;
	    	var x2:int;
	    	var text:String;
	    	if (textField!=null)
	    	{
	    		text=textField.text;
	    		x1=textField.selectionBeginIndex;
	    		x2=textField.selectionEndIndex;
	    	}
	    	var sel:String;
	    	if (x2>x1)
	    	{
	    		sel=text.substring(x1, x2);
	    	}
			if (sel==null)
			{
				sel="";
			}
	    	ret.forceString(sel);
	    	return ret;
	    }
	    
	    public function expGETXPOSITION():CValue
	    {
	        return new CValue(ho.hoX);
	    }
	
	    public function expGETYPOSITION():CValue
	    {
	        return new CValue(ho.hoY);
	    }
	
	    public function expGETXSIZE():CValue
	    {
	        return new CValue(ho.hoImgWidth);
    	}

	    public function expGETYSIZE():CValue
	    {
	        return new CValue(ho.hoImgHeight);
	    }

	    public function expGETVALUE():CValue
	    {
	    	var text:String;
	    	if (textField!=null)
	    	{
	    		text=textField.text;
	    	}
			var val:CFuncVal=new CFuncVal();
			var ret:CValue=new CValue(0);
			switch(val.parse(text))
			{
				case 0:
					ret.forceInt(val.intValue);
					break;
				case 1:
					ret.forceDouble(val.doubleValue);
					break;
			}
			return ret;
	    }
	    
	    public function expGETFIRSTLINE():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	
	        if ((flags & EDIT_MULTILINE) != 0)
	        {
	        }
	        return ret;
	    }
	
	    public function expGETLINECOUNT():CValue
	    {
	    	var ret:CValue=new CValue(1);
	        if ((flags & EDIT_MULTILINE) != 0 && textField != null)
	        {
				ret = new CValue(textField.numLines);
        	}
        	return ret;
	    }
	
	    public function expGETCOLOR():CValue
	    {
	        return new CValue(textForeColour);
	    }
	
	    public function expGETBKDCOLOR():CValue
	    {
	        return new CValue(textBackColour);
	    }
	    
	}
}