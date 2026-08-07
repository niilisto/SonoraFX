//----------------------------------------------------------------------------------
//
// CRUNKCLIST: extension object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.CLayer;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunkccombo extends CRunExtension
	{
	    public static var COMBO_SIMPLE:int=0x0001;
	    public static var COMBO_DROPDOWN:int=0x0002;
	    public static var COMBO_DROPDOWNLIST:int=0x0004;
	    public static var COMBO_SCROLLBAR:int=0x0008;
	    public static var COMBO_SORT:int=0x0010;
	    public static var COMBO_HIDEONSTART:int=0x0020;
	    public static var COMBO_SYSCOLOR:int=0x0040;
	    public static var COMBO_SCROLLTONEWLINE:int=0x0080;
	    public static var COMBO_ONEBASE:int=0x0100;
	    public static var COMBO_JUSTCREATED:int=0x8000;
	
	    public var fontInfo:CFontInfo;
    	public var crefListFontColor:int;
    	public var flags:int;
    	public var crefListFontBkColor:int;
    	public var combo:CRunCombo;
    	public var oldWidth:int;
    	public var oldHeight:int;
		public var selectionChangedEvent:int;
		public var doubleClickedEvent:int;
		public var indexOffset:int;
		public var lastIndex:int;
		public var skipChangedCounter:int;
		
		public function CRunkccombo()
		{
		}
	    public override function getNumberOfConditions():int
    	{
			return 6;
    	}
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoImgWidth=file.readShort();
	        ho.hoImgHeight=file.readShort();
	        oldWidth=ho.hoImgWidth;
	        oldHeight=ho.hoImgHeight;
	        if (ho.hoAdRunHeader.rhApp.bUnicode==false)
	        {
	            fontInfo = file.readLogFont16();
	        }
	        else
	        {
	            fontInfo = file.readLogFont();
	        }
	        crefListFontColor=file.readColor();
	        file.readStringSize(40);
	        flags=file.readInt();
	        var lineNumbers:int=file.readShort();
	        crefListFontBkColor=file.readColor();
	        file.skipBytes(12);
	        indexOffset=0;
	        if ((flags&COMBO_ONEBASE)!=0)
	        {
	            indexOffset=-1;
	        }
	        lastIndex=-1;

			// Creates the list
			var newFlags:int=0;
			if ((flags&COMBO_SCROLLBAR)!=0)
			{
				newFlags|=CRunCombo.COMBOFLAG_SCROLLBAR;
			}
			if ((flags&COMBO_HIDEONSTART)!=0)
			{
				newFlags|=CRunCombo.COMBOFLAG_HIDDEN;
			}
			if ((flags&COMBO_SORT)!=0)
			{
				newFlags|=CRunCombo.COMBOFLAG_SORT;
			}
			if ((flags&COMBO_SCROLLTONEWLINE)!=0)
			{
				newFlags|=CRunCombo.COMBOFLAG_SCROLLTONEWLINE;
			}
            var type:int;
            type=CRunCombo.COMBOTYPE_SIMPLE;
            if (flags&COMBO_DROPDOWN)
            {
            	type=CRunCombo.COMBOTYPE_DROPDOWN;
            }
            if (flags&COMBO_DROPDOWNLIST)
            {
            	type=CRunCombo.COMBOTYPE_DROPDOWNLIST;
            }
			var bSystemColor:Boolean=(flags&COMBO_SYSCOLOR)!=0;
			combo=new CRunCombo(rh.rhApp, ho.hoAdRunHeader.rhApp.planeControls,
							  	ho.hoX-ho.hoAdRunHeader.rhWindowX, ho.hoY-ho.hoAdRunHeader.rhWindowY, 
							  	ho.hoImgWidth, ho.hoImgHeight,
							  	fontInfo, bSystemColor, crefListFontColor, crefListFontBkColor, newFlags, type);
							  	
			// Insert the strings			
	        while (lineNumbers > 0)
	        {
	            var line:String = file.readString();
	            combo.addString(line, false);
	            lineNumbers--;
	        }
	        combo.displayStrings();
	        
	        selectionChangedEvent=-1;
	        doubleClickedEvent=-1;
			skipChangedCounter=0;
	        
	        return false;
	    }
	    public override function destroyRunObject(bFlag:Boolean):void
	    {
	    	combo.destroy();
	    }
		public override function setHandCursor(bOn:Boolean):void
		{
			combo.setHandCursor(bOn);
		}
		public override function handleRunObject():int
		{
			combo.handle(ho.hoAdRunHeader.rh2MouseX-ho.hoX, ho.hoAdRunHeader.rh2MouseY-ho.hoY, ho.hoAdRunHeader.rhApp.keyBuffer);			
	
			if (combo.bSelChanged)
			{
				if (skipChangedCounter==0)
				{
	            	selectionChangedEvent = ho.getEventCount();
	            	ho.pushEvent(3, 0);             // CND_SELECTIONCHANGED
				}
				else
				{
					skipChangedCounter--;					
				}
				combo.bSelChanged=false;
			}
			if (combo.bDoubleClick)
			{
				combo.bDoubleClick=false;
            	doubleClickedEvent = ho.getEventCount();
            	ho.pushEvent(2, 0);             // CND_DOUBLECLICKED
   			}
			return 0;	
		}
		public override function displayRunObject():void
		{
			combo.setPosition(ho.hoX-ho.hoAdRunHeader.rhWindowX, ho.hoY-ho.hoAdRunHeader.rhWindowY);
			var bDisplay:Boolean=false;
			if (ho.hoImgWidth!=oldWidth)
			{
				combo.width=ho.hoImgWidth;
				oldWidth=ho.hoImgWidth;
				bDisplay=true;
			}
			if (ho.hoImgHeight!=oldHeight)
			{
				combo.height=ho.hoImgHeight;
				oldHeight=ho.hoImgHeight;
				bDisplay=true;		
			}
			if (bDisplay)
			{
				combo.createDisplay();
			}
		}
		public override function click():void
		{
			combo.click();
		}
		public override function setFocus(bFlag:Boolean):void
		{
			combo.setFocus(bFlag);
		}

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case 0:
	                return cndVisible(cnd);
	            case 1:
	                return cndEnable(cnd);
	            case 2:
	                return cndDoubleClicked(cnd);
	            case 3:
	                return cndSelectionChanged(cnd);
	            case 4:
	                return cndHaveFocus(cnd);
	            case 5:
	                return cndIsDropped(cnd);
	        }
			return false;
	    }
	    public function cndVisible(cnd:CCndExtension):Boolean
	    {
	        return combo.bVisible;
	    }
	    public function cndEnable(cnd:CCndExtension):Boolean
	    {
	        return combo.bEnabled;
	    }
	    public function cndDoubleClicked(cnd:CCndExtension):Boolean
	    {
	        // This is a true event, so was pushed
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	        // Event occured this event loop
	        if (doubleClickedEvent == ho.getEventCount())
	        {
	            return true;
	        }
	        return false;
	    }
	    public function cndSelectionChanged(cnd:CCndExtension):Boolean
	    {
	        // This is a true event, so was pushed
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	        // Event occured this event loop
	        if (selectionChangedEvent == ho.getEventCount())
	        {
	            return true;
	        }
	        return false;
	    }
	    public function cndHaveFocus(cnd:CCndExtension):Boolean
	    {
	        return combo.bFocus;
	    }
	    public function cndIsDropped(cnd:CCndExtension):Boolean
	    {
			return combo.list.bVisible;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case 0:
					actLoad(act);
	                break;
	            case 1:
	                break;
	            case 2:
	                break;
	            case 3:
	                break;
	            case 4:
					actSave(act);
	                break;
	            case 5:
	                actReset(act);
	                break;
	            case 6:
	                actAddLine(act);
	                break;
	            case 7:
	                actInsertLine(act);
	                break;
	            case 8:
	                actDelLine(act);
	                break;
	            case 9: 
	                actSetCurrentLine(act);
	                break;
	            case 10:
	                actShow(act);
	                break;
	            case 11:
	                actHide(act);
	                break;
	            case 12:
	                actActivate(act);
	                break;
	            case 13:
	                actEnable(act);
	                break;
	            case 14:
	                actDisable(act);
	                break;
	            case 15:
	                actSetPosition(act);
	                break;
	            case 16:
	                actSetXPosition(act);
	                break;
	            case 17: 
	                actSetYPosition(act);
	                break;
	            case 18:
	                actSetSize(act);
	                break;
	            case 19:
	                actSetXSize(act);
	                break;
	            case 20:
	                actSetYSize(act);
	                break;
	            case 21:
	                actDesactivate(act);
	                break;
	            case 22:
	                actSetEditText(act);
	                break;
	            case 23:
	                actScrollToTop(act);
	                break;
	            case 24:
	                actScrollToLine(act);
	                break;
	            case 25:
	                actScrollToEnd(act);
	                break;
	            case 26:
	                actSetColor(act);
	                break;
	            case 27:
	                actSetBkdColor(act);
	                break;
	            case 28:
	                break;
	            case 29:
	                break;
	            case 30:
	                break;
			    case 31:	
					actChangeLine(act);
					break;
	        }
	    }
		private function parseName(name:String):String
		{
			var pos:int=name.lastIndexOf("\\");
			if (pos>0)
			{
				name=name.substring(pos+1);
			}
			return name;	    			
		}	 
		
		public function actLoad(act:CActExtension):void
		{
			var fileName:String=parseName(act.getParamFilename(rh, 0));
			var file:CBinaryFile = rh.rhApp.openFile(fileName);
			if (file!=null)
			{
				combo.reset();
				while (file.isEOF() == false)
				{
					var s:String = file.readStringEOL();
					combo.addString(s, true);
				}
			}
		}
		public function actSave(act:CActExtension):void
		{
			
			var fileName:String=parseName(act.getParamFilename(rh, 0));
			var file:CBinaryFile = new CBinaryFile(null, false);
			var n:int;
			for (n = 0; n < combo.list.strings.size(); n++)
			{
				var s:String = String(combo.list.strings.get(n));
				file.writeString(s);
				file.writeByte(13);
				file.writeByte(10);
			}
			file.save(fileName);
		}
	    public function actReset(act:CActExtension):void
	    {
	    	combo.reset();
	    }
	    public function actAddLine(act:CActExtension):void
	    {
	        lastIndex = combo.getSize();
	        combo.addString(act.getParamExpString(rh, 0));
	    }
	    public function actInsertLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if (index < 0)
	        {
	            // append to end
	            index = combo.getSize();
	        }
	        if (index > combo.getSize())
	        {
	            index = combo.getSize();
	        }
	        lastIndex = index;
	        combo.insertString(index, act.getParamExpString(rh, 1));
	    }
	    public function actDelLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        // Must be an existing element
	        if (index < 0)
	            return;
	        if (index >= combo.getSize())
	            return;
	        combo.delString(index);
	    }
	    public function actSetCurrentLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if ((index >= 0) && (index < combo.getSize()))
	        {
	            combo.setSelected(index);
				skipChangedCounter=1;
	        }
	    }
	    public function actShow(act:CActExtension):void
	    {
	        combo.setVisible(true);
	    }
	    public function actHide(act:CActExtension):void
	    {
	        combo.setVisible(false);
	    }
	    public function actActivate(act:CActExtension):void
	    {
	        combo.setFocus(true);
	    }
	    public function actEnable(act:CActExtension):void
	    {
	        combo.setEnabled(true);
	    }
	    public function actDisable(act:CActExtension):void
	    {
	        combo.setEnabled(false);
	    }
	    public function actSetPosition(act:CActExtension):void
	    {
	        ho.setPosition(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	        ho.redraw();
	    }
	    public function actSetXPosition(act:CActExtension):void
	    {
	        ho.setPosition(act.getParamExpression(rh, 0), ho.getY());
	        ho.redraw();
	    }
	    public function actSetYPosition(act:CActExtension):void
	    {
	        ho.setPosition(act.getParamExpression(rh, 0), ho.getY());
	        ho.redraw();
	    }
	    public function actSetSize(act:CActExtension):void
	    {
	        var width:int=act.getParamExpression(rh, 0);
	        var height:int=act.getParamExpression(rh, 1);
	        if (width>=0 && height>=0)
	        {
	            ho.setWidth(width);
	            ho.setHeight(height);
	            ho.redraw();
	        }
	    }
	    public function actSetXSize(act:CActExtension):void
	    {
	        var width:int=act.getParamExpression(rh, 0);
	        if (width>=0)
	        {
	            ho.setWidth(width);
	            ho.redraw();
	        }
	    }
	    public function actSetYSize(act:CActExtension):void
	    {
	        var height:int=act.getParamExpression(rh, 1);
	        if (height>=0)
	        {
	            ho.setHeight(height);
	            ho.redraw();
	        }
	   	}
	    public function actDesactivate(act:CActExtension):void
	    {
	    	combo.setFocus(false);
	    }
	    public function actSetEditText(act:CActExtension):void
	    {
	        var s:String=act.getParamExpString(rh, 0);
	        combo.setCurrentText(s);
	    }
	    public function actScrollToTop(act:CActExtension):void
	    {
	    	combo.ensureLineIsVisible(0);
	    }
	    public function actScrollToLine(act:CActExtension):void
	    {
	        var line:int=act.getParamExpression(rh, 0)+indexOffset;
	        if (line>=0 && line<combo.getSize())
	        {
	            lastIndex=line;
		    	combo.ensureLineIsVisible(line);
	        }
	    }
	    public function actScrollToEnd(act:CActExtension):void
	    {
	        if (combo.getSize()>0)
	        {
	            lastIndex=combo.getSize()-1;
		    	combo.ensureLineIsVisible(lastIndex);
	        }
	    }
	    public function actSetColor(act:CActExtension):void
	    {
	        crefListFontColor=act.getParamColour(rh, 0);
	        combo.setForeground(crefListFontColor);
	    }
	    public function actSetBkdColor(act:CActExtension):void
	    {
	        crefListFontBkColor=act.getParamColour(rh, 0);
	        combo.setBackground(crefListFontBkColor);
	    }
	    public function actSetLineData(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        // Must be an existing element
	        if (index < 0)
	            return;
	        if (index >= combo.getSize())
	            return;
	        combo.setData(index, act.getParamExpression(rh, 1));       
	    }
	    public function actChangeLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        // Must be an existing element
	        if (index < 0)
	            return;
	        if (index >= combo.getSize())
	            return;
	        combo.setString(index, act.getParamExpString(rh, 1));       
	    }		
	    
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        switch (num)
	        {
	            case 0:
	                return expGetSelectIndex();
	            case 1:
	                return expGetSelectText();
	            case 2:
	                return ret;
	            case 3:
	                return ret;
	            case 4:
	                return expGetLineText();
	            case 5:
	                return ret;
	            case 6:
	                return ret;
	            case 7:
	                return exGetNbLine();
	            case 8:
	                return exGetXPosition();
	            case 9:
	                return expGetYPosition();
	            case 10:
	                return expGetXSize();
	            case 11:
	                return expGetYSize();
	            case 12:
	                return expGetEditText();
	            case 13:
	                return expGetColor();
	            case 14:
	                return expGetBkdColor();
	            case 15:
	                return expFindString();
	            case 16:
	                return expFinStringExact();
	            case 17:
	                return expGetLastIndex();
	            case 18:
	                return expGetLineData();
	        }
			return null;
	    }
	
	    public function expGetSelectIndex():CValue
	    {
	        var index:int=combo.getSelectedIndex();
	        if (index>=0)
	        {
	            return new CValue(index-indexOffset);
	        }
	        return new CValue(-1);
	    }
	    public function getText(index:int):CValue
	    {	    	
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 0) && (index < combo.getSize()))
	        {
	        	ret.forceString(combo.getString(index));
	        }
	        return ret;
	    }	  
	    public function expGetSelectText():CValue
	    {
	        return getText(combo.getSelectedIndex());
	    }
	    public function expGetLineText():CValue
	    {
	        return getText(ho.getExpParam().getInt() + indexOffset);
	    }
	    public function exGetNbLine():CValue
	    {
	        return new CValue(combo.getSize());
	    }
	    public function exGetXPosition():CValue
	    {
	        return new CValue(ho.getX());
	    }
	    public function expGetYPosition():CValue
	    {
	        return new CValue(ho.getY());
	    }
	    public function expGetXSize():CValue
	    {
	        return new CValue(ho.getWidth());
	    }
	    public function expGetYSize():CValue
	    {
	        return new CValue(ho.getHeight());
	    }
	    public function expGetEditText():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(combo.currentText);
	    	return ret;
	    }
	    public function expGetColor():CValue
	    {
	        return new CValue(crefListFontColor);
	    }
	    public function expGetBkdColor():CValue
	    {
	        return new CValue(crefListFontBkColor);
	    }
	    public function expFindString():CValue
	    {
	        var search:String = ho.getExpParam().getString();
	        var startIndex:int = ho.getExpParam().getInt();
	        if (startIndex != -1)
	        {
	            startIndex += indexOffset;
	        }
	        if ((startIndex < 0) || (startIndex >= combo.getSize()))
	        {
	            startIndex = -1;
	        }
	        var ret:int=combo.findString(search, startIndex);
	        if (ret>=0)
	        {
	        	ret-=indexOffset;
	        }
	        return new CValue(ret);	    
	    }
	    public function expFinStringExact():CValue
	    {
	        var search:String = ho.getExpParam().getString();
	        var startIndex:int = ho.getExpParam().getInt();
	        if (startIndex != -1)
	        {
	            startIndex += indexOffset;
	        }
	        if ((startIndex < 0) || (startIndex >= combo.getSize()))
	        {
	            startIndex = -1;
	        }
	        var ret:int=combo.findStringExact(search, startIndex);
	        if (ret>=0)
	        {
	        	ret-=indexOffset;
	        }
	        return new CValue(ret);	    
	    }
	    public function expGetLastIndex():CValue
	    {
	        return new CValue(lastIndex);
	    }
	    public function expGetLineData():CValue
	    {
	        var index:int = ho.getExpParam().getInt() + indexOffset;
	        if ((index < 0) || (index >= combo.getSize()))
	            return new CValue(0);
	        return new CValue(combo.getData(index));
	    }
	    
	}
}