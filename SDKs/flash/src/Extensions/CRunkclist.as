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
	
	
	public class CRunkclist extends CRunExtension
	{
	    // Flags
	    public static var LIST_FREEFLAG:int = 0x0001;
	    public static var LIST_VSCROLLBAR:int = 0x0002;
	    public static var LIST_SORT:int = 0x0004;
	    public static var LIST_BORDER:int = 0x0008;
	    public static var LIST_HIDEONSTART:int = 0x0010;
	    public static var LIST_SYSCOLOR:int = 0x0020;
	    public static var LIST_3DLOOK:int = 0x0040;
	    public static var LIST_SCROLLTONEWLINE:int = 0x0080;
	    public static var LIST_JUSTCREATED:int = 0x8000;
	
	    // Condition identifiers
	    public static var CND_VISIBLE:int = 0;
	    public static var CND_ENABLE:int = 1;
	    public static var CND_DOUBLECLICKED:int = 2;
	    public static var CND_SELECTIONCHANGED:int = 3;
	    public static var CND_HAVEFOCUS:int = 4;
	    public static var CND_LAST:int = 5;
	    // Action identifiers
	    public static var ACT_LOADLIST:int = 0;
	    public static var ACT_LOADDRIVESLIST:int = 1;
	    public static var ACT_LOADDIRECTORYLIST:int = 2;
	    public static var ACT_LOADFILESLIST:int = 3;
	    public static var ACT_SAVELIST:int = 4;
	    public static var ACT_RESET:int = 5;
	    public static var ACT_ADDLINE:int = 6;
	    public static var ACT_INSERTLINE:int = 7;
	    public static var ACT_DELLINE:int = 8;
	    public static var ACT_SETCURRENTLINE:int = 9;
	    public static var ACT_SHOW:int = 10;
	    public static var ACT_HIDE:int = 11;
	    public static var ACT_ACTIVATE:int = 12;
	    public static var ACT_ENABLE:int = 13;
	    public static var ACT_DISABLE:int = 14;
	    public static var ACT_SETPOSITION:int = 15;
	    public static var ACT_SETXPOSITION:int = 16;
	    public static var ACT_SETYPOSITION:int = 17;
	    public static var ACT_SETSIZE:int = 18;
	    public static var ACT_SETXSIZE:int = 19;
	    public static var ACT_SETYSIZE:int = 20;
	    public static var ACT_DESACTIVATE:int = 21;
	    public static var ACT_SCROLLTOTOP:int = 22;
	    public static var ACT_SCROLLTOLINE:int = 23;
	    public static var ACT_SCROLLTOEND:int = 24;
	    public static var ACT_SETCOLOR:int = 25;
	    public static var ACT_SETBKDCOLOR:int = 26;
	    public static var ACT_LOADFONTSLIST:int = 27;
	    public static var ACT_LOADFONTSIZESLIST:int = 28;
	    public static var ACT_SETLINEDATA:int = 29;
	    public static var ACT_CHANGELINE:int = 30;
	    public static var ACT_LAST:int = 31;
	    // Expression identifiers
	    public static var EXP_GETSELECTINDEX:int = 0;
	    public static var EXP_GETSELECTTEXT:int = 1;
	    public static var EXP_GETSELECTDIRECTORY:int = 2;
	    public static var EXP_GETSELECTDRIVE:int = 3;
	    public static var EXP_GETLINETEXT:int = 4;
	    public static var EXP_GETLINEDIRECTORY:int = 5;
	    public static var EXP_GETLINEDRIVE:int = 6;
	    public static var EXP_GETNBLINE:int = 7;
	    public static var EXP_GETXPOSITION:int = 8;
	    public static var EXP_GETYPOSITION:int = 9;
	    public static var EXP_GETXSIZE:int = 10;
	    public static var EXP_GETYSIZE:int = 11;
	    public static var EXP_GETCOLOR:int = 12;
	    public static var EXP_GETBKDCOLOR:int = 13;
	    public static var EXP_FINDSTRING:int = 14;
	    public static var EXP_FINDSTRINGEXACT:int = 15;
	    public static var EXP_GETLASTINDEX:int = 16;
	    public static var EXP_GETLINEDATA:int = 17;
	    public static var EXP_LAST:int = 18;
	
    	public var list:CRunList;
	    public var listFontInfo:CFontInfo;
	    public var listFontFore:int;
    	public var listFontBack:int;
    	public var flags:int;
    	public var indexOffset:int;
    	public var scrollToNewLine:Boolean;
	    public var selectionChangedIgnore:Boolean = false;
    	public var bVisible:Boolean;
    	public var oldWidth:int;
    	public var oldHeight:int;
    	public var array:Array;
    	public var doubleClickedEvent:int;
    	public var selectionChangedEvent:int;
    	public var lastIndex:int;
    	
		public function CRunkclist()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return CND_LAST;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        // Read from edPtr
	        ho.hoImgWidth = file.readShort();
	        ho.hoImgHeight = file.readShort();
			oldWidth=ho.hoImgWidth;
			oldHeight=ho.hoImgHeight;
				        
	        // This is a 16-bit logfont structure
	        if (ho.hoAdRunHeader.rhApp.bUnicode==false)
	        {
	            listFontInfo = file.readLogFont16();
	        }
	        else
	        {
	            listFontInfo = file.readLogFont();
	        }
	        listFontFore = file.readColor();
	        file.readStringSize(40);
	        file.skipBytes(16 * 4);
	        listFontBack = file.readColor();
	        flags = file.readInt();

	        var lineNumbers:int = file.readShort();

	        // If TRUE, indexes are 1-based. So the index offset is -1 when true
	        // (subtract one from value provided) and 0 when false (no modification)
	        indexOffset = file.readInt() == 1 ? -1 : 0;
	        
	        // Skip three longs (lSecu)
	        file.skipBytes(4 * 3);
	        
			// Creates the list
			var newFlags:int=0;
			if ((flags&LIST_VSCROLLBAR)!=0)
			{
				newFlags|=CRunList.LISTFLAG_SCROLLBAR;
			}
			if ((flags&LIST_HIDEONSTART)!=0)
			{
				newFlags|=CRunList.LISTFLAG_HIDDEN;
			}
			if ((flags&LIST_SORT)!=0)
			{
				newFlags|=CRunList.LISTFLAG_SORT;
			}
			if ((flags&LIST_BORDER)!=0)
			{
				newFlags|=CRunList.LISTFLAG_BORDER;
			}
			if ((flags&LIST_3DLOOK)!=0)
			{
				newFlags|=CRunList.LISTFLAG_3DLOOK;
			}
			if ((flags&LIST_SCROLLTONEWLINE)!=0)
			{
				newFlags|=CRunList.LISTFLAG_SCROLLTONEWLINE;
			}
			list=new CRunList(ho.hoAdRunHeader.rhApp.planeControls, 
							  ho.hoX-ho.hoAdRunHeader.rhWindowX, ho.hoY-ho.hoAdRunHeader.rhWindowY, 
							  ho.hoImgWidth, ho.hoImgHeight,
							  listFontInfo, listFontFore, listFontBack, newFlags);

			// Insert the strings			
	        while (lineNumbers > 0)
	        {
	            var line:String = file.readString();
	            list.addString(line, false);
	            lineNumbers--;
	        }
	        list.displayStrings();

    		doubleClickedEvent=-1;
    		selectionChangedEvent=-1;
			lastIndex=0;
									
	        return false;
	    }

		public override function destroyRunObject(bFast:Boolean):void
		{
			list.destroy();
		}

		public override function setHandCursor(bOn:Boolean):void
		{
			list.setHandCursor(bOn);
		}
		
		public override function handleRunObject():int
		{
			list.handle(ho.hoAdRunHeader.rh2MouseX-ho.hoX, ho.hoAdRunHeader.rh2MouseY-ho.hoY, ho.hoAdRunHeader.rhApp.keyBuffer);
			
			if (list.bSelChanged)
			{
				list.bSelChanged=false;
                selectionChangedEvent = ho.getEventCount();
            	ho.pushEvent(CND_SELECTIONCHANGED, 0);
			}
			if (list.bDoubleClick)
			{
				list.bDoubleClick=false;
	            doubleClickedEvent = ho.getEventCount();
	            ho.pushEvent(CND_DOUBLECLICKED, 0);
	  		}
			return 0;	
		}
		public override function setFocus(bFlag:Boolean):void
		{
			list.setFocus(bFlag);
		}
		public override function click():void
		{
			list.click();
		}
		public override function doubleClick():void
		{
			list.doubleClick();
		}
		public override function displayRunObject():void
		{
			list.setPosition(ho.hoX-ho.hoAdRunHeader.rhWindowX, ho.hoY-ho.hoAdRunHeader.rhWindowY);
			var bDisplay:Boolean=false;
			if (ho.hoImgWidth!=oldWidth)
			{
				list.width=ho.hoImgWidth;
				oldWidth=ho.hoImgWidth;
				bDisplay=true;
			}
			if (ho.hoImgHeight!=oldHeight)
			{
				list.height=ho.hoImgHeight;
				oldHeight=ho.hoImgHeight;
				bDisplay=true;		
			}
			if (bDisplay)
			{
				list.createDisplay();
			}
		}

	    public override function getRunObjectFont():CFontInfo 
	    {
	        return listFontInfo;
	    }
	
	    public override function setRunObjectFont(fi:CFontInfo, rc:CRect):void
	    {
	        listFontInfo = fi;
	        list.setFont(listFontInfo);
	        if (rc!=null)
	        {
	        	list.setSize(rc.right, rc.bottom);
	        }
	    }
	
	    public override function getRunObjectTextColor():int
	    {
	        return listFontFore;
	    }
	
	    public override function setRunObjectTextColor(rgb:int):void
	    {
	        listFontFore = rgb;
	        list.setForeground(listFontFore);
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_VISIBLE:
	                return cndIsVisible(cnd);
	            case CND_ENABLE:
	                return cndIsEnable(cnd);
	            case CND_DOUBLECLICKED:
	                return cndDoubleClicked(cnd);
	            case CND_SELECTIONCHANGED:
	                return cndSelectionChanged(cnd);
	            case CND_HAVEFOCUS:
	                return cndHaveFocus(cnd);
	        }
	        return false;
	    }

	    public function cndIsVisible(cnd:CCndExtension):Boolean
	    {
	        return list.bVisible;
	    }
	
	    public function cndIsEnable(cnd:CCndExtension):Boolean
	    {
	        return list.bEnabled;
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
	        return list.bFocus;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_LOADLIST:
					actLoad(act);
	                break;
	            case ACT_LOADDRIVESLIST:
	                break;
	            case ACT_LOADDIRECTORYLIST:
	                break;
	            case ACT_LOADFILESLIST:
	                break;
	            case ACT_SAVELIST:
					actSave(act);
	                break;
	            case ACT_RESET:
	                actReset(act);
	                break;
	            case ACT_ADDLINE:
	                actAddLine(act);
	                break;
	            case ACT_INSERTLINE:
	                actInsertLine(act);
	                break;
	            case ACT_DELLINE:
	                actDelLine(act);
	                break;
	            case ACT_SETCURRENTLINE:
	                actSetCurrentLine(act);
	                break;
	            case ACT_SHOW:
	                actShow(act);
	                break;
	            case ACT_HIDE:
	                actHide(act);
	                break;
	            case ACT_ACTIVATE:
	                actActivate(act);
	                break;
	            case ACT_ENABLE:
	                actEnable(act);
	                break;
	            case ACT_DISABLE:
	                actDisable(act);
	                break;
	            case ACT_SETPOSITION:
	                actSetPosition(act);
	                break;
	            case ACT_SETXPOSITION:
	                actSetXPosition(act);
	                break;
	            case ACT_SETYPOSITION:
	                actSetYPosition(act);
	                break;
	            case ACT_SETSIZE:
	                actSetSize(act);
	                break;
	            case ACT_SETXSIZE:
	                actSetXSize(act);
	                break;
	            case ACT_SETYSIZE:
	                actSetYSize(act);
	                break;
	            case ACT_DESACTIVATE:
	                actDesactivate(act);
	                break;
	            case ACT_SCROLLTOTOP:
	                actScrollToTop(act);
	                break;
	            case ACT_SCROLLTOLINE:
	                actScrollToLine(act);
	                break;
	            case ACT_SCROLLTOEND:
	                actScrollToEnd(act);
	                break;
	            case ACT_SETCOLOR:
	                actSetColor(act);
	                break;
	            case ACT_SETBKDCOLOR:
	                actSetBkdColor(act);
	                break;
	            case ACT_LOADFONTSLIST:
	                break;
	            case ACT_LOADFONTSIZESLIST:
	                break;
	            case ACT_SETLINEDATA:
	                actSetLineData(act);
	                break;
	            case ACT_CHANGELINE:
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
				list.reset();
				while (file.isEOF() == false)
				{
					var s:String = file.readStringEOL();
					list.addString(s, true);
				}
				list.sortStrings();
			}
		}
		public function actSave(act:CActExtension):void
		{
			
			var fileName:String=parseName(act.getParamFilename(rh, 0));
			var file:CBinaryFile = new CBinaryFile(null, false);
			var n:int;
			for (n = 0; n < list.strings.size(); n++)
			{
				var s:String = String(list.strings.get(n));
				file.writeString(s);
				file.writeByte(13);
				file.writeByte(10);
			}
			file.save(fileName);
		}
	    public function actReset(act:CActExtension):void
	    {
	        list.reset();
	    }
	
	    public function actAddLine(act:CActExtension):void
	    {
	        list.addString(act.getParamExpString(rh, 0));
	        lastIndex=list.strings.size()-1;
	    }
	
	    public function actInsertLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if (index < 0)
	        {
	            index = 0;
	        }
	        if (index > list.strings.size())
	        {
	            index = list.strings.size();
	        }
	        list.insertString(index, act.getParamExpString(rh, 1));
	        lastIndex=index;
	    }

	    public function actChangeLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if (index >= 0)
	        {
		        list.setString(index, act.getParamExpString(rh, 1));
	        }
	    }
	
	    public function actDelLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if (index < 0)
	        {
	            return;
	        }
	        if (index >= list.strings.size())
	        {
	            return;
	        }
	        list.delString(index);
	    }
	
	    public function actSetCurrentLine(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        if (index == -1)
	        {
	            // No selection
	            list.setSelected(-1);
	        }
	        else if ((index >= 0) && (index < list.strings.size()))
	        {
	            list.setSelected(index);
	        }
			list.bSelChanged=false;
	    }
	
	    public function actShow(act:CActExtension):void
	    {
	    	list.setVisible(true);
	    }
	
	    public function actHide(act:CActExtension):void
	    {
	        list.setVisible(false);
	    }
	
	    public function actActivate(act:CActExtension):void
	    {
	        list.setFocus(true);
	    }
	
	    public function actEnable(act:CActExtension):void
	    {
	        list.setEnabled(true);
	    }
	
	    public function actDisable(act:CActExtension):void
	    {
	        list.setEnabled(false);
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
	        ho.setPosition(ho.getX(), act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actSetSize(act:CActExtension):void
	    {
	        ho.setWidth(act.getParamExpression(rh, 0));
	        ho.setHeight(act.getParamExpression(rh, 1));
	        ho.redraw();
	    }
	
	    public function actSetXSize(act:CActExtension):void
	    {
	        ho.setWidth(act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actSetYSize(act:CActExtension):void
	    {
	        ho.setHeight(act.getParamExpression(rh, 0));
	        ho.redraw();
	    }
	
	    public function actDesactivate(act:CActExtension):void
	    {
	    	list.setFocus(false);
	    }
	
	    public function actScrollToTop(act:CActExtension):void
	    {
	        list.ensureIndexIsVisible(0);
	    }
	
	    public function actScrollToLine(act:CActExtension):void
	    {
	        list.ensureIndexIsVisible(act.getParamExpression(rh, 0));
	    }
	
	    public function actScrollToEnd(act:CActExtension):void
	    {
	        list.ensureIndexIsVisible(list.strings.size() - 1);
	    }
	
	    public function actSetColor(act:CActExtension):void
	    {
	        listFontFore = act.getParamColour(rh, 0);
	        list.setForeground(listFontFore);
	    }
	
	    public function actSetBkdColor(act:CActExtension):void
	    {
	        listFontBack = act.getParamColour(rh, 0);
	        list.setBackground(listFontBack);
	    }
	
	    public function actSetLineData(act:CActExtension):void
	    {
	        var index:int = act.getParamExpression(rh, 0) + indexOffset;
	        // Must be an existing element
	        if (index < 0)
	        {
	            return;
	        }
	        if (index >= list.strings.size())
	        {
	            return;
	        }
	        list.setData(index, act.getParamExpression(rh, 1));
	    }

	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        switch (num)
	        {
	            case EXP_GETSELECTINDEX:
	                return expGetSelectIndex();
	            case EXP_GETSELECTTEXT:
	                return expGetSelectText();
	            case EXP_GETSELECTDIRECTORY:
	                return ret;
	            case EXP_GETSELECTDRIVE:
	                return ret;
	            case EXP_GETLINETEXT:
	                return expGetLineText();
	            case EXP_GETLINEDIRECTORY:
	                return ret;
	            case EXP_GETLINEDRIVE:
	                return ret;
	            case EXP_GETNBLINE:
	                return expGetNbLine();
	            case EXP_GETXPOSITION:
	                return expGetXPosition();
	            case EXP_GETYPOSITION:
	                return expGetYPosition();
	            case EXP_GETXSIZE:
	                return expGetXSize();
	            case EXP_GETYSIZE:
	                return expGetYSize();
	            case EXP_GETCOLOR:
	                return expGetColor();
	            case EXP_GETBKDCOLOR:
	                return expGetBkdColor();
	            case EXP_FINDSTRING:
	                return expFindString();
	            case EXP_FINDSTRINGEXACT:
	                return expFindStringExact();
	            case EXP_GETLASTINDEX:
	                return expGetLastIndex();
	            case EXP_GETLINEDATA:
	                return expGetLineData();
	        }
	        return null;
	    }

	    public function expGetSelectIndex():CValue
	    {
	    	var y:int=list.ySelected;
	    	if (y>=0)							// Bug dans la version C++
	    	{
	    		y-=indexOffset;
	    	}
	        return new CValue(y);
	    }
	
	    public function getText(index:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	        if ((index < 0) || (index >= list.strings.size()))
	        {
	        	ret.forceString("");
	        }
	        else
	        {
	        	ret.forceString(String(list.strings.get(index)));
	        }
	        return ret;
	    }
	
	    public function expGetSelectText():CValue
	    {
	        return getText(list.ySelected);
	    }
		
	    public function expGetLineText():CValue
	    {
	        return getText(ho.getExpParam().getInt() + indexOffset);
	    }
	
	    public function expGetNbLine():CValue
	    {
	        return new CValue(list.strings.size());
	    }
	
	    public function expGetXPosition():CValue
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
	
	    public function expGetColor():CValue
	    {
	        return new CValue(listFontFore);
	    }
	
	    public function expGetBkdColor():CValue
	    {
	        return new CValue(listFontBack);
	    }
	    
	    public function expFindString():CValue
	    {
	        var search:String = ho.getExpParam().getString();
	        var startIndex:int = ho.getExpParam().getInt();
	        if (startIndex != -1)
	        {
	            startIndex += indexOffset;
	        }
	        if ((startIndex < 0) || (startIndex >= list.strings.size()))
	        {
	            startIndex = -1;
	        }
	        var ret:int=list.findString(search, startIndex);
	        if (ret>=0)
	        {
	        	ret-=indexOffset;
	        }
	        return new CValue(ret);	    
	    }
	
	    public function expFindStringExact():CValue
	    {
	        var search:String = ho.getExpParam().getString();
	        var startIndex:int = ho.getExpParam().getInt();
	        if (startIndex != -1)
	        {
	            startIndex += indexOffset;
	        }
	        if ((startIndex < 0) || (startIndex >= list.strings.size()))
	        {
	            startIndex = -1;
	        }
	        var ret:int=list.findStringExact(search, startIndex);
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
	        if ((index < 0) || (index >= list.datas.size()))
	        {
	            return new CValue(0);
	        }
	        return new CValue(int(list.getData(index)));
	    }	    
	}
}