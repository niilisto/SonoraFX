//----------------------------------------------------------------------------------
//
// CRunparser : stringparser
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

	public class CRunparser extends CRunExtension
	{
	    public static var CASE_INSENSITIVE:int = 0;
	    public static var SEARCH_LITERAL:int = 0;

	    public static var CND_ISURLSAFE:int = 0;
	    public static var ACT_SETSTRING:int = 0;
	    public static var ACT_SAVETOFILE:int = 1;
	    public static var ACT_LOADFROMFILE:int = 2;
	    public static var ACT_APPENDTOFILE:int  = 3;
	    public static var ACT_APPENDFROMFILE:int = 4;
	    public static var ACT_RESETDELIMS:int= 5;
	    public static var ACT_ADDDELIM:int= 6;
	    public static var ACT_SETDELIM:int  = 7;
	    public static var ACT_DELETEDELIMINDEX:int = 8;
	    public static var ACT_DELETEDELIM:int  = 9;
	    public static var ACT_SETDEFDELIMINDEX:int  =10;
	    public static var ACT_SETDEFDELIM:int =11;
	    public static var ACT_SAVEASCSV:int  =12;
	    public static var ACT_LOADFROMCSV:int =13;
	    public static var ACT_SAVEASMMFARRAY:int  = 14;
	    public static var ACT_LOADFROMMMFARRAY:int = 15;
	    public static var ACT_SAVEASDYNAMICARRAY:int=16;
	    public static var ACT_LOADFROMDYNAMICARRAY:int= 17;
	    public static var ACT_CASEINSENSITIVE:int = 18;
	    public static var ACT_CASESENSITIVE:int = 19;
	    public static var ACT_SEARCHLITERAL:int=20;
	    public static var ACT_SEARCHWILDCARDS:int  =21;
	    public static var ACT_SAVEASINI:int=22;
	    public static var ACT_LOADFROMINI:int	=23;
	    public static var EXP_GETSTRING:int = 0;
	    public static var EXP_GETLENGTH:int = 1;
	    public static var EXP_LEFT:int = 2;
	    public static var EXP_RIGHT:int = 3;
	    public static var EXP_MIDDLE:int = 4;
	    public static var EXP_NUMBEROFSUBS:int = 5;
	    public static var EXP_INDEXOFSUB:int = 6;
	    public static var EXP_INDEXOFFIRSTSUB:int = 7;
	    public static var EXP_INDEXOFLASTSUB:int = 8;
	    public static var EXP_REMOVE:int = 9;
	    public static var EXP_REPLACE:int = 10;
	    public static var EXP_INSERT:int = 11;
	    public static var EXP_REVERSE:int = 12;
	    public static var EXP_UPPERCASE:int = 13;
	    public static var EXP_LOWERCASE:int = 14;
	    public static var EXP_URLENCODE:int = 15;
	    public static var EXP_CHR:int = 16;
	    public static var EXP_ASC:int = 17;
	    public static var EXP_ASCLIST:int = 18;
	    public static var EXP_NUMBEROFDELIMS:int = 19;
	    public static var EXP_GETDELIM:int = 20;
	    public static var EXP_GETDELIMINDEX:int = 21;
	    public static var EXP_GETDEFDELIM:int = 22;
	    public static var EXP_GETDEFDELIMINDEX:int = 23;
	    public static var EXP_LISTCOUNT:int = 24;
	    public static var EXP_LISTSETAT:int = 25;
	    public static var EXP_LISTINSERTAT:int = 26;
	    public static var EXP_LISTAPPEND:int = 27;
	    public static var EXP_LISTPREPEND:int = 28;
	    public static var EXP_LISTGETAT:int = 29;
	    public static var EXP_LISTFIRST:int = 30;
	    public static var EXP_LISTLAST:int = 31;
	    public static var EXP_LISTFIND:int = 32;
	    public static var EXP_LISTCONTAINS:int = 33;
	    public static var EXP_LISTDELETEAT:int = 34;
	    public static var EXP_LISTSWAP:int = 35;
	    public static var EXP_LISTSORTASC:int = 36;
	    public static var EXP_LISTSORTDESC:int = 37;
	    public static var EXP_LISTCHANGEDELIMS:int = 38;
	    public static var EXP_SETSTRING:int = 39;
	    public static var EXP_SETVALUE:int = 40;
	    public static var EXP_GETMD5:int = 41;

	    public var source:String = "";
	    public var caseSensitive:Boolean;
	    public var wildcards:Boolean;
	    public var delims:CArrayList = new CArrayList(); //Strings
	    public var defaultDelim:String;
	    public var tokensE:CArrayList = new CArrayList(); //parserElement
		
		public function CRunparser()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 1;
	    }

	    public function fixString(input:String):String
	    {
	    	var i:int;
	        for (i = 0; i < input.length; i++)
	        {
	            if (input.charCodeAt(i) < 10)
	            {
	                return input.substring(0, i);
	            }
	        }
	        return input;
	    }
	    
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	file.setUnicode(false);
	        file.skipBytes(4);
	        this.source = fixString(file.readStringSize(1025));
	        var nComparison:int = file.readShort();
	        if (nComparison == CASE_INSENSITIVE)
	        {
	            this.caseSensitive = false;
	        }
	        else
	        {
	            this.caseSensitive = true;
	        }
	        var nSearchMode:int = file.readShort();
	        if (nSearchMode == SEARCH_LITERAL)
	        {
	            this.wildcards = false;
	        }
	        else
	        {
	            this.wildcards = true;
	        }
			this.delims.add(",");
	        return true;
	    }

	    public function redoTokens():void
	    {
	        this.tokensE.clear();
	        var sourceToTest:String = this.source;
	        var i:int;
	        if (!sourceToTest=="")
	        {
	            var lastTokenLocation:int = 0;
	            var work:Boolean = true;
	            while (work)
	            {
	                var aTokenE:CArrayList = new CArrayList(); //parserElement
	                var aDelim:CArrayList = new CArrayList(); //String
	                var j:int;
	                for (j = 0; j < this.delims.size(); j++)
	                {
	                    var delim:String = String(this.delims.get(j));
	                    var index:int = getSubstringIndex(sourceToTest, delim, 0);
	                    if (index != -1)
	                    {
	                        aTokenE.add(new CRunparserElement(sourceToTest.substring(0, index), lastTokenLocation));
	                        aDelim.add(delim);
	                    }
	                }
	                //pick smallest token
	                var smallestC:int = int.MAX_VALUE;
	                var smallest:int = -1;
	                for (j = 0; j < aTokenE.size(); j++)
	                {
	                    if (( CRunparserElement(aTokenE.get(j))).text.length < smallestC)
	                    {
	                        smallestC = (CRunparserElement(aTokenE.get(j))).text.length;
	                        smallest = j;
	                    }
	                }
	                if (smallest != -1)
	                {
	                    this.tokensE.add(aTokenE.get(smallest));
	                    sourceToTest = sourceToTest.substring(
	                            (CRunparserElement(aTokenE.get(smallest))).text.length +
	                            ( String(aDelim.get(smallest))).length);
	                    lastTokenLocation += ( CRunparserElement(aTokenE.get(smallest))).text.length +
	                            ( String(aDelim.get(smallest))).length;
	                }
	                else
	                {
	                    //if at end of search, add remainder
	                    this.tokensE.add(new CRunparserElement(sourceToTest, lastTokenLocation));
	                    work = false;
	                }
	            }
	            for (i = 0; i < this.tokensE.size(); i++)
	            {
	                //remove ""
	                var e:CRunparserElement = CRunparserElement(this.tokensE.get(i));
	                if (e.text=="")
	                {
	                    this.tokensE.removeIndex(i);
	                    i--;
	                }
	            }
	        }
	    }
	    public function getSubstringIndex(source:String, find:String, occurance:int):int
	    { //occurance is 0-based	    
	        var theSource:String = source;
	        if (theSource.length==0)
	        {
	        	return -1;
	        }
	        if (!this.caseSensitive)
	        {
	            theSource = theSource.toLowerCase();
	            find = find.toLowerCase();
	        }
	        var i:int, j:int;
	        if (this.wildcards)
	        {
	            var st:CRunStringTokeniser = new CRunStringTokeniser(find, "*");
	            var ct:int = st.countTokens();
	            var asteriskless:Array = new Array(ct);
	            for (i = 0; i < ct; i++)
	            {
	                asteriskless[i] = st.nextToken();
	            }
	            var lastOccurance:int = -1;
	            var occ:int;
	            for (occ = 0; occ <= occurance; occ++)
	            {
	                var asterisklessLocation:Array = new Array(ct);
	                var asterisk:int;
	                for (asterisk = 0; asterisk < ct; asterisk++)
	                {
	                    for (i = 0; i < theSource.length; i++)
	                    {
	                        var findThis:String = asteriskless[asterisk];
	                        //replace "?" occurances with chars from source
	                        for (j = 0; j < findThis.length; j++)
	                        {
	                            if (findThis.substring(j, j + 1)=="?")
	                            {
	                                if (i + j < theSource.length)
	                                {
	                                    findThis = findThis.substring(0, j) +
	                                            theSource.substring(i + j, i + j + 1) +
	                                            findThis.substring(j + 1);
	                                }
	                            }
	                        }
	                        if ((asterisk == 0) || (asterisklessLocation[asterisk - 1] == -1))
	                        {
	                            asterisklessLocation[asterisk] = theSource.indexOf(findThis, lastOccurance + 1);
	                        }
	                        else
	                        {
	                            asterisklessLocation[asterisk] = theSource.indexOf(findThis, asterisklessLocation[asterisk - 1]);
	                        }
	                        if (asterisklessLocation[asterisk] != -1)
	                        {
	                            i = theSource.length; //stop
	                        }
	                    }
	                }
	                //now each int in asterisklessLocation should be in an acsending order (lowest first)
	                //if they are not, then the string wasn't found in the source
	                var last:int = -1;
	                for (i = 0; i < ct; i++)
	                {
	                    if (asterisklessLocation[i] > last)
	                    {
	                        last = asterisklessLocation[i];
	                    }
	                    else
	                    {
	                        lastOccurance = -1;
	                        i = ct; //stop
	                    }
	                }
	                if ((occ == 0) || (lastOccurance != -1))
	                {
	                    if (asterisklessLocation.length > 0)
	                    {
	                        lastOccurance = asterisklessLocation[0];
	                    }
	                    else
	                    {
	                        lastOccurance = -1;
	                    }
	                }
	            }
	            return lastOccurance<0?-1:lastOccurance;
	        }
	        else
	        { //no wildcards
	            var lastIndex:int = -1;
	            for (i = 0; i <= occurance; i++)
	            {
	                lastIndex = theSource.indexOf(find, lastIndex + 1);
	            }
	            return lastIndex<0?-1:lastIndex;
	        }
	    }

	    public function substringMatches(source:String, find:String):Boolean
	    {
	        var theSource:String = source;
	        if (!this.caseSensitive)
	        {
	            theSource = theSource.toLowerCase();
	            find = find.toLowerCase();
	        }
	        var i:int, j:int;
	        if (this.wildcards)
	        {
	            var st:CRunStringTokeniser = new CRunStringTokeniser(find, "*");
	            var ct:int = st.countTokens();
	            var asteriskless:Array = new Array(ct);
	            for (i = 0; i < ct; i++)
	            {
	                asteriskless[i] = st.nextToken();
	            }
	            var asterisklessLocation:Array = new Array(ct);
	            var asterisk:int;
	            for (asterisk = 0; asterisk < ct; asterisk++)
	            {
	                for (i = 0; i < theSource.length; i++)
	                {
	                    var findThis:String = asteriskless[asterisk];
	                    //replace "?" occurances with chars from source
	                    for (j = 0; j < findThis.length; j++)
	                    {
	                        if (findThis.substring(j, j + 1)=="?")
	                        {
	                            if (i + j < theSource.length)
	                            {
	                                findThis = findThis.substring(0, j) +
	                                        theSource.substring(i + j, i + j + 1) +
	                                        findThis.substring(j + 1);
	                            }
	                        }
	                    }
	                    if ((asterisk == 0) || (asterisklessLocation[asterisk - 1] == -1))
	                    {
	                        asterisklessLocation[asterisk] = theSource.indexOf(findThis);
	                    }
	                    else
	                    {
	                        asterisklessLocation[asterisk] = theSource.indexOf(findThis, asterisklessLocation[asterisk - 1]);
	                    }
	                    if (asterisklessLocation[asterisk] != -1)
	                    {
	                        i = theSource.length; //stop
	                    }
	                }
	            }
	            //now each int in asterisklessLocation should be in an acsending order (lowest first)
	            //if they are not, then the string wasn't found in the source
	            var last:int = -1;
	            var ok:Boolean = true;
	            for (i = 0; i < ct; i++)
	            {
	                if (asterisklessLocation[i] > last)
	                {
	                    last = asterisklessLocation[i];
	                }
	                else
	                {
	                    i = ct; //stop
	                    ok = false;
	                }
	            }
	            if ((ok) && (find.length > 0) && (asterisklessLocation.length > 0))
	            {
	                if (getSubstringIndex(theSource, find, 1) == -1)
	                { //no other occurances
	                    if (find.substring(0, 1)=="*")
	                    {
	                        if (find.substring(find.length - 1)=="*")
	                        {
	                            //if it starts with a * and ends with a *
	                            return true;
	                        }
	                        else
	                        {
	                            //if last element is at the end of the source
	                            if (asterisklessLocation[ct - 1] + asteriskless[ct - 1].length == theSource.length)
	                            {
	                                return true;
	                            }
	                        }
	                    }
	                    else
	                    {
	                        if (asterisklessLocation[0] == 0)
	                        {
	                            if (find.substring(find.length - 1)=="*")
	                            {
	                                //if it starts with a * and ends with a *
	                                return true;
	                            }
	                            else
	                            {
	                                //if last element is at the end of the source
	                                if (asterisklessLocation[ct - 1] + asteriskless[ct - 1].length == theSource.length)
	                                {
	                                    return true;
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        else
	        { //no wildcards
	            if ((theSource.length == find.length) && (theSource.indexOf(find, 0) == 0))
	            {
	                return true;
	            }
	        }
	        return false;
	    }

		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        if (num == CND_ISURLSAFE)
	        {
	        	var index:int;
	            for (index = 0; index < source.length; index++)
	            {
	                while (!isLetterOrDigit(source.charCodeAt(index)))
	                {
	                    if (source.charCodeAt(index) == 43)
	                    {
	                        break;
	                    }
	                    else if (source.charCodeAt(index) == 37)
	                    {
	                        if (source.length > index + 2)
	                        {
	                            if (isLetterOrDigit(source.charCodeAt(index + 1)) &&
	                                    isLetterOrDigit(source.charCodeAt(index + 2)))
	                            {
	                                index = index + 2;
	                            }
	                            else
	                            {
	                                return false;
	                            }
	                            break;
	                        }
	                        else
	                        {
	                            return false;
	                        }
	                    }
	                    else
	                    {
	                        return false;
	                    }
	                }
	            }
	            return true;
	        }
	        return false;
		}

	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SETSTRING:
	                source = act.getParamExpString(rh, 0);
	                redoTokens();
	                break;
	            case ACT_SAVETOFILE:
	                break;
	            case ACT_LOADFROMFILE:
	                break;
	            case ACT_APPENDTOFILE:
	                break;
	            case ACT_APPENDFROMFILE:
	                break;
	            case ACT_RESETDELIMS:
	                delims.clear();
	                break;
	            case ACT_ADDDELIM:
	                SP_addDelim(act.getParamExpString(rh, 0));
	                break;
	            case ACT_SETDELIM:
	                SP_setDelim(act.getParamExpString(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case ACT_DELETEDELIMINDEX:
	                SP_deleteDelimIndex(act.getParamExpression(rh, 0));
	            case ACT_DELETEDELIM:
	                SP_deleteDelim(act.getParamExpString(rh, 0));
	                break;
	            case ACT_SETDEFDELIMINDEX:
	                SP_setDefDelimIndex(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETDEFDELIM:
	                SP_setDefDelim(act.getParamExpString(rh, 0));
	                break;
	            case ACT_SAVEASCSV:
	                break;
	            case ACT_LOADFROMCSV:
	                break;
	            case ACT_SAVEASMMFARRAY:
	                break;
	            case ACT_LOADFROMMMFARRAY:
	                break;
	            case ACT_SAVEASDYNAMICARRAY:
	                break;
	            case ACT_LOADFROMDYNAMICARRAY:
	                break;
	            case ACT_CASEINSENSITIVE:
	                caseSensitive = false;
	                redoTokens();
	                break;
	            case ACT_CASESENSITIVE:
	                caseSensitive = true;
	                redoTokens();
	                break;
	            case ACT_SEARCHLITERAL:
	                wildcards = false;
	                redoTokens();
	                break;
	            case ACT_SEARCHWILDCARDS:
	                wildcards = true;
	                redoTokens();
	                break;
	            case ACT_SAVEASINI:
	                break;
	            case ACT_LOADFROMINI:
	                break;
	        }
	    }
	
	    public function SP_addDelim(delim:String):void
	    {
	        if (!delim=="")
	        {
	            var exists:Boolean = false;
	            var i:int;
	            for (i = 0; i < delims.size(); i++)
	            {
	                var thisDelim:String = String(delims.get(i));
	                if (getSubstringIndex(thisDelim, delim, 0) >= 0)
	                {
	                    exists = true;
	                }
	            }
	            if (exists == false)
	            {
	                delims.add(delim);
	                redoTokens();
	                defaultDelim = delim;
	            }
	        }
	    }
	
	    public function SP_setDelim(delim:String, index:int):void
	    {
	    	if (index==delims.size())
	    	{
	            delims.add(delim);
	            defaultDelim = delim;
	            redoTokens();	    		
	    	}
	        else if ((index >= 0) && (index < delims.size()))
	        {
	            delims.set(index, delim);
	            defaultDelim = delim;
	            redoTokens();
	        }
	    }
	
	    public function SP_deleteDelimIndex(index:int):void
	    {
	        if ((index >= 0) && (index < delims.size()))
	        {
	            delims.removeIndex(index);
	            if (index < delims.size())
	            {
	                defaultDelim = String(delims.get(index));
	            }
	            else
	            {
	                defaultDelim = null;
	            }
	            redoTokens();
	        }
	    }
	
	    public function SP_deleteDelim(delim:String):void
	    {
	    	var i:int;
	        for (i = 0; i < delims.size(); i++)
	        {
	            if (( String(delims.get(i)))==delim)
	            {
	                delims.removeIndex(i);
	                if (i < delims.size())
	                {
	                    defaultDelim = String(delims.get(i));
	                }
	                else
	                {
	                    defaultDelim = null;
	                }
	                redoTokens();
	                return;
	            }
	        }
	    }
	
	    public function SP_setDefDelimIndex(index:int):void
	    {
	        if ((index >= 0) && (index < delims.size()))
	        {
	            defaultDelim = String(delims.get(index));
	        }
	    }
	
	    public function SP_setDefDelim(delim:String):void
	    {
	    	var i:int;
	        for (i = 0; i < delims.size(); i++)
	        {
	            if (( String(delims.get(i)))==delim)
	            {
	                defaultDelim = String(delims.get(i));
	                return;
	            }
	        }
	    }

		// Expressions
		// ----------------------------------------------------------------------------
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue;
	        switch (num)
	        {
	            case EXP_GETSTRING:
	            	ret=new CValue(0);
	            	ret.forceString(source);
	                return ret;
	            case EXP_GETLENGTH:
	                return new CValue(source.length);
	            case EXP_LEFT:
	                return SP_left(ho.getExpParam().getInt());
	            case EXP_RIGHT:
	                return SP_right(ho.getExpParam().getInt());
	            case EXP_MIDDLE:
	                return SP_middle(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_NUMBEROFSUBS:
	                return SP_numberOfSubs(ho.getExpParam().getString());
	            case EXP_INDEXOFSUB:
	                return SP_indexOfSub(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_INDEXOFFIRSTSUB:
	                return SP_indexOfFirstSub(ho.getExpParam().getString());
	            case EXP_INDEXOFLASTSUB:
	                return SP_indexOfLastSub(ho.getExpParam().getString());
	            case EXP_REMOVE:
	                return SP_remove(ho.getExpParam().getString());
	            case EXP_REPLACE:
	                return SP_replace(ho.getExpParam().getString(), ho.getExpParam().getString());
	            case EXP_INSERT:
	                return SP_insert(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_REVERSE:
	                return SP_reverse();
	            case EXP_UPPERCASE:
	            	ret=new CValue(0);
	            	ret.forceString(source.toUpperCase());
	                return ret;
	            case EXP_LOWERCASE:
	            	ret=new CValue(0);
	            	ret.forceString(source.toLowerCase());
	                return ret;
	            case EXP_URLENCODE:
	                return SP_urlEncode();
	            case EXP_CHR:
	                return SP_chr(ho.getExpParam().getInt());
	            case EXP_ASC:
	                return SP_asc(ho.getExpParam().getString());
	            case EXP_ASCLIST:
	                return SP_ascList(ho.getExpParam().getString());
	            case EXP_NUMBEROFDELIMS:
	                return new CValue(delims.size());
	            case EXP_GETDELIM:
	                return SP_getDelim(ho.getExpParam().getInt());
	            case EXP_GETDELIMINDEX:
	                return SP_getDelimIndex(ho.getExpParam().getString());
	            case EXP_GETDEFDELIM:
	                return SP_getDefDelim();
	            case EXP_GETDEFDELIMINDEX:
	                return SP_getDefDelimIndex();
	            case EXP_LISTCOUNT:
	                return new CValue(tokensE.size());
	            case EXP_LISTSETAT:
	                return SP_listSetAt(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_LISTINSERTAT:
	                return SP_listInsertAt(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_LISTAPPEND:
	            	ret=new CValue(0);
	            	ret.forceString(source + ho.getExpParam().getString());
	                return ret;
	            case EXP_LISTPREPEND:
	            	ret=new CValue(0);
	            	ret.forceString(ho.getExpParam().getString() + source);
	                return ret;
	            case EXP_LISTGETAT:
	                return SP_listGetAt(ho.getExpParam().getInt());
	            case EXP_LISTFIRST:
	                return SP_listFirst();
	            case EXP_LISTLAST:
	                return SP_listLast();
	            case EXP_LISTFIND: //matching
	                return SP_listFind(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_LISTCONTAINS:
	                return SP_listContains(ho.getExpParam().getString(), ho.getExpParam().getInt());
	            case EXP_LISTDELETEAT:
	                return SP_listDeleteAt(ho.getExpParam().getInt());
	            case EXP_LISTSWAP:
	                return SP_listSwap(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	            case EXP_LISTSORTASC:
	                return SP_listSortAsc();
	            case EXP_LISTSORTDESC:
	                return SP_listSortDesc();
	            case EXP_LISTCHANGEDELIMS:
	                return SP_listChangeDelims(ho.getExpParam().getString());
	            case EXP_SETSTRING:
	                return SP_setStringEXP(ho.getExpParam().getString());
	            case EXP_SETVALUE:
	                return SP_setValueEXP(ho.getExpParam().getString());
	            case EXP_GETMD5:
	                return SP_getMD5();
	        }
	        return new CValue(0);//won't be used
	    }
	
	    public function SP_left(i:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((i >= 0) && (i <= source.length))
	        {
	        	ret.forceString(source.substring(0, i));
	        }
	        return ret;
	    }
	
	    public function SP_right(i:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	    	var i:int;
	        if ((i >= 0) && (i <= source.length))
	        {
	            ret.forceString(source.substring(source.length - i));
	        }
	        return ret;
	    }
	
	    public function SP_middle(i:int, length:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        length = Math.max(0, length);
	        var i:int;
	        if ((i >= 0) && (i + length <= source.length))
	        {
	            ret.forceString(source.substring(i, i + length));
	        }
	        return ret;
	    }
	
	    public function SP_numberOfSubs(sub:String):CValue
	    {
	        var count:int = 0;
	        while (getSubstringIndex(source, sub, count) != -1)
	        {
	            count++;
	        }
	        return new CValue(count);
	    }
	
	    public function SP_indexOfSub(sub:String, occurance:int):CValue
	    { //1-based
	        occurance = Math.max(1, occurance);
	        return new CValue(getSubstringIndex(source, sub, occurance - 1));
	    }
	
	    public function SP_indexOfFirstSub(sub:String):CValue
	    {
	        return new CValue(getSubstringIndex(source, sub, 0));
	    }
	
	    public function SP_indexOfLastSub(sub:String):CValue
	    {
	        var n:int = Math.max(1, SP_numberOfSubs(sub).getInt());
	        return new CValue(getSubstringIndex(source, sub, n - 1));
	    }
	
	    public function SP_remove(sub:String):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        var count:int = 0;
	        var parts:CArrayList = new CArrayList(); //Integer
	        var index:int = getSubstringIndex(source, sub, count);
	        while (index != -1)
	        {
	            parts.add(index);
	            count++;
	            index = getSubstringIndex(source, sub, count);
	        }
	        if (parts.size() == 0)
	        {
	        	ret.forceString(source);
	        	return ret;
	        }
	        var last:int = 0;
	        var r:String = "";
	        var i:int;
	        for (i = 0; i < parts.size(); i++)
	        {
	            r += source.substring(last,  int(parts.get(i)) );
	            last = ( int(parts.get(i)) ) + sub.length;
	            if (i == parts.size() - 1)
	            {
	                r += source.substring(last);
	            }
	        }
	        ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_replace(old:String, newString:String):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");

	        var count:int = 0;
	        var parts:CArrayList = new CArrayList(); //Integer
	        var index:int = getSubstringIndex(source, old, count);
	        while (index != -1)
	        {
	            parts.add(index);
	            count++;
	            index = getSubstringIndex(source, old, count);
	        }
	        if (parts.size() == 0)
	        {
	        	ret.forceString(source);
	        	return ret;
	        }
	        var last:int = 0;
	        var r:String = "";
	        var i:int;
	        for (i = 0; i < parts.size(); i++)
	        {
	            r += source.substring(last,  int(parts.get(i)) ) + newString;
	            last =   int(parts.get(i)) + old.length;
	            if (i == parts.size() - 1)
	            {
	                r += source.substring(last);
	            }
	        }
	        ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_insert(insert:String, index:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 1) && (index <= source.length))
	        {
	            ret.forceString(source.substring(0, index - 1) + insert + source.substring(index - 1));
	        }
	        return ret;
	    }
	
	    public function SP_reverse():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        var r:String = "";
	        var i:int;
	        for (i = source.length - 1; i >= 0; i--)
	        {
	            r += source.substring(i, i + 1);
	        }
	        ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_urlEncode():CValue
	    {
	        var r:String = "";
	        var i:int;
	        for (i = 0; i < source.length; i++)
	        {
	            if (isLetterOrDigit(source.charCodeAt(i)))
	            {
	                r += source.substring(i, i + 1);
	            }
	            else
	            {
	                if (isSpaceChar(source.charCodeAt(i)))
	                {
	                    r += "+";
	                }
	                else if (source.charCodeAt(i) == 13)
	                {
	                    r += "+";
	                    i++;
	                }
	                else
	                {
	                    r += "%";
	                    r += (source.charCodeAt(i) >> 4).toString(16);
	                    r += (source.charCodeAt(i) % 16).toString(16);
	                }
	            }
	        }
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_chr(value:int):CValue
	    {
	    	var r:String=String.fromCharCode(value);
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(r);
	    	return ret;
	    }
	
	    public function SP_asc(value:String):CValue
	    {
	        if (value.length > 0)
	        {
                var r:int = value.charCodeAt(0);
                return new CValue(r);
	        }
	        return new CValue(0);
	    }
	
	    public function SP_ascList(delim:String):CValue
	    {
            var r:String = "";
            var i:int;
            for (i = 0; i < source.length; i++)
            {
                r += (source.charCodeAt(i)).toString();
                if (i < source.length - 1)
                {
                    r += delim;
                }
            }
            var ret:CValue=new CValue(0);
            ret.forceString(r);
            return ret;
	    }
	
	    public function SP_getDelim(i:int):CValue
	    { //0-based, silly 3ee
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((i >= 0) && (i < delims.size()))
	        {
	            ret.forceString( String(delims.get(i)) );
	        }
	        return ret;
	    }
	
	    public function SP_getDelimIndex(delim:String):CValue
	    {
	    	var i:int;
	        for (i = 0; i < delims.size(); i++)
	        {
	            var thisDelim:String = String(delims.get(i));
	            if (getSubstringIndex(thisDelim, delim, 0) >= 0)
	            {
	                return new CValue(i);
	            }
	        }
	        return new CValue(-1);
	    }
	
	    public function SP_getDefDelim():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if (defaultDelim != null)
	        {
	            ret.forceString(defaultDelim);
	        }
	        return ret;
	    }
	
	    public function SP_getDefDelimIndex():CValue
	    {
	        if (defaultDelim != null)
	        {
	        	var i:int;
	            for (i = 0; i < delims.size(); i++)
	            {
	                var thisDelim:String = String(delims.get(i));
	                if (getSubstringIndex(thisDelim, defaultDelim, 0) >= 0)
	                {
	                    return new CValue(i);
	                }
	            }
	        }
	        return new CValue(-1);
	    }
	
	    public function SP_listSetAt(replace:String, index:int):CValue
	    { //1-based
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 1) && (index <= tokensE.size()))
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(index - 1));
	            var r:String = source.substring(0, e.index) + replace + source.substring(e.endIndex);
	            ret.forceString(r);
	        }
	        return ret;
	    }
	
	    public function SP_listInsertAt(insert:String, index:int):CValue
	    { //1-based
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 1) && (index <= tokensE.size()))
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(index - 1));
	            var r:String = source.substring(0, e.index) + insert + source.substring(e.index);
	            ret.forceString(r);
	        }
	        return ret;
	    }
	
	    public function SP_listGetAt(index:int):CValue
	    { //1-based
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 1) && (index <= tokensE.size()))
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(index - 1));
	            ret.forceString(e.text);
	        }
	        return ret;
	    }
	
	    public function SP_listFirst():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if (tokensE.size() > 0)
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(0));
	            ret.forceString(e.text);
	        }
	        return ret;
	    }
	
	    public function SP_listLast():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if (tokensE.size() > 0)
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(tokensE.size() - 1));
	            ret.forceString(e.text);
	        }
	        return ret;
	    }
	
	    public function SP_listFind(find:String, occurance:int):CValue
	    { //matching //1-based
	        if ((occurance > 0) && (find.length > 0))
	        {
	            var occuranceCount:int = 0;
	            var i:int;
	            for (i = 0; i < tokensE.size(); i++)
	            {
	                var e:CRunparserElement = CRunparserElement(tokensE.get(i));
	                if (substringMatches(e.text, find))
	                {
	                    occuranceCount++;
	                }
	                if (occuranceCount == occurance)
	                {
	                    return new CValue(i + 1);
	                }
	            }
	        }
	        return new CValue(0);
	    }
	
	    public function SP_listContains(find:String, occurance:int):CValue
	    { //matching //1-based
	        if ((occurance > 0) && (find.length > 0))
	        {
	            var occuranceCount:int = 0;
	            var i:int;
	            for (i = 0; i < tokensE.size(); i++)
	            {
	                var e:CRunparserElement = CRunparserElement(tokensE.get(i));
	                if (getSubstringIndex(e.text, find, 0) != -1)
	                {
	                    occuranceCount++;
	                }
	                if (occuranceCount == occurance)
	                {
	                    return new CValue(i + 1);
	                }
	            }
	        }
	        return new CValue(0);
	    }
	
	    public function SP_listDeleteAt(index:int):CValue
	    { //1-based
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((index >= 1) && (index <= tokensE.size()))
	        {
	            var e:CRunparserElement = CRunparserElement(tokensE.get(index - 1));
	            var r:String = source.substring(0, e.index) + source.substring(e.endIndex);
	            ret.forceString(r);
	        }
	        return ret;
	    }
	
	    public function SP_listSwap(i1:int, i2:int):CValue
	    { //1-based
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((i1 >= 1) && (i2 >= 1) && (i1 <= tokensE.size()) && (i2 <= tokensE.size()))
	        {
	            if (i1 == i2)
	            {
	            	ret.forceString(source);
	            	return ret;
	            }
	            var e1:CRunparserElement = CRunparserElement(tokensE.get(i1 - 1));
	            var e2:CRunparserElement = CRunparserElement(tokensE.get(i2 - 1));
	            var r:String = "";
	            if (i1 > i2)
	            {
	                //e2 comes sooner
	                r += source.substring(0, e2.index); //string leading up to e2
	                r += source.substring(e1.index, e1.endIndex); //e1
	                r += source.substring(e2.endIndex, e1.index); //string between e2 and e1
	                r += source.substring(e2.index, e2.endIndex); //e2
	                r += source.substring(e1.endIndex); //string from end of e1 to end
	            }
	            else
	            { //i1 < i2
	                //e1 comes sooner
	                r += source.substring(0, e1.index); //string leading up to e1
	                r += source.substring(e2.index, e2.endIndex); //e2
	                r += source.substring(e1.endIndex, e2.index); //string between e1 and e2
	                r += source.substring(e1.index, e1.endIndex); //e1
	                r += source.substring(e2.endIndex); //string from end of e2 to end
	            }
	            ret.forceString(r);
	        }
	        return ret;
	    }
	
	    public function SP_listSortAsc():CValue
	    {
	    	var e:CRunparserElement;
	        var sorted:CArrayList = new CArrayList(); //parserElement
	        var i:int;
	        for (i = 0; i < tokensE.size(); i++)
	        {
	            e = CRunparserElement(tokensE.get(i));
	            if (sorted.size() == 0)
	            {
	                sorted.add(e);
	            }
	            else
	            {
	                var index:int = 0;
	                var j:int;
	                for (j = 0; j < sorted.size(); j++)
	                {
	                    var element:CRunparserElement = CRunparserElement(sorted.get(j));
	                    if (caseSensitive)
	                    {
	                        if (compareStrings(e.text, element.text)>=0)
	                        {
	                            index = j;
	                        }
	                    }
	                    else
	                    {
	                        if (CServices.compareStringsIgnoreCase(e.text, element.text))
	                        {
	                            index = j;
	                        }
	                    }
	                }
	                sorted.insert(index, e);
	            }
	        }
	        var r:String = "";
	        for (i = 0; i < sorted.size(); i++)
	        {
	            e = CRunparserElement(sorted.get(i));
	            var oe:CRunparserElement  = CRunparserElement(tokensE.get(i));
	            if (i == 0)
	            {
	                r += source.substring(0, oe.index);
	            }
	            else
	            {
	                var lastOrigE:CRunparserElement  = CRunparserElement(tokensE.get(i - 1));
	                r += source.substring(lastOrigE.endIndex, oe.index);
	            }
	            r += source.substring(e.index, e.endIndex);
	            if (i == sorted.size() - 1)
	            {
	                r += source.substring(oe.endIndex);
	            }
	        }
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_listSortDesc():CValue
	    {
	        var sorted:CArrayList = new CArrayList(); //parserElement
	        var i:int;
	        var e:CRunparserElement;
	        for (i = 0; i < tokensE.size(); i++)
	        {
	            e = CRunparserElement(tokensE.get(i));
	            if (sorted.size() == 0)
	            {
	                sorted.add(e);
	            }
	            else
	            {
	                var index:int = sorted.size();
	                var j:int;
	                for (j = sorted.size() - 1; j >= 0; j--)
	                {
	                    var element:CRunparserElement = CRunparserElement(sorted.get(j));
	                    if (caseSensitive)
	                    {
	                        if (compareStrings(e.text, element.text) >= 0)
	                        {
	                            index = j;
	                        }
	                    }
	                    else
	                    {
	                        if (CServices.compareStringsIgnoreCase(e.text, element.text))
	                        {
	                            index = j;
	                        }
	                    }
	                }
	                sorted.insert(index, e);
	            }
	        }
	        var r:String = "";
	        for (i = 0; i < sorted.size(); i++)
	        {
	            e = CRunparserElement(sorted.get(i));
	            var oe:CRunparserElement = CRunparserElement(tokensE.get(i));
	            if (i == 0)
	            {
	                r += source.substring(0, oe.index);
	            }
	            else
	            {
	                var lastOrigE:CRunparserElement = CRunparserElement(tokensE.get(i - 1));
	                r += source.substring(lastOrigE.endIndex, oe.index);
	            }
	            r += source.substring(e.index, e.endIndex);
	            if (i == sorted.size() - 1)
	            {
	                r += source.substring(oe.endIndex);
	            }
	        }
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(r);
	        return ret;
	    }
	
	    public function SP_listChangeDelims(changeDelim:String):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if (defaultDelim != null)
	        {
	            var r:String = "";
	            var i:int;
	            for (i = 0; i < tokensE.size(); i++)
	            {
	                var e:CRunparserElement = CRunparserElement(tokensE.get(i));
	                var here:int = e.index - defaultDelim.length;
	                if ( (here >= 0) && source.substring(here, e.index)==defaultDelim )
	                {
	                    r += changeDelim;
	                }
	                else
	                {
	                    if (i == 0)
	                    {
	                        r += source.substring(0, e.index);
	                    }
	                    else
	                    {
	                        var lastOrigE:CRunparserElement = CRunparserElement(tokensE.get(i - 1));
	                        r += source.substring(lastOrigE.endIndex, e.index);
	                    }
	                }
	                r += source.substring(e.index, e.endIndex);
	                if (i == tokensE.size() - 1)
	                {
	                    if (source.substring(e.endIndex)==defaultDelim)
	                    {
	                        r += changeDelim;
	                    }
	                    else
	                    {
	                        r += source.substring(e.endIndex);
	                    }
	                }
	            }
	            ret.forceString(r);
	        }
	        return ret;
	    }
	
	    public function SP_setStringEXP(newSource:String):CValue
	    {
	        source = newSource;
	        redoTokens();
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        return ret;
	    }
	
	    public function SP_setValueEXP(newSource:String):CValue
	    {
	        source = newSource;
	        redoTokens();
	        return new CValue(0);
	    }
	
	    public function SP_getMD5():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(MD5(source));
	        return ret;
	    }
		
		private function MD5 (string:String):String 
		{	 
			function RotateLeft(lValue:int, iShiftBits:int):Number 
			{
				return (lValue<<iShiftBits) | (lValue>>>(32-iShiftBits));
			}
		 
			function AddUnsigned(lX:int,lY:int):int
			 {
				var lX4:int,lY4:int,lX8:int,lY8:int,lResult:int;
				lX8 = (lX & 0x80000000);
				lY8 = (lY & 0x80000000);
				lX4 = (lX & 0x40000000);
				lY4 = (lY & 0x40000000);
				lResult = (lX & 0x3FFFFFFF)+(lY & 0x3FFFFFFF);
				if (lX4 & lY4) {
					return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
				}
				if (lX4 | lY4) {
					if (lResult & 0x40000000) {
						return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
					} else {
						return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
					}
				} else {
					return (lResult ^ lX8 ^ lY8);
				}
		 	}
		 
		 	function F(x:int,y:int,z:int):int { return (x & y) | ((~x) & z); }
		 	function G(x:int,y:int,z:int):int { return (x & z) | (y & (~z)); }
		 	function H(x:int,y:int,z:int):int { return (x ^ y ^ z); }
			function I(x:int,y:int,z:int):int { return (y ^ (x | (~z))); }
		 
			function FF(a:int,b:int,c:int,d:int,x:int,s:int,ac:int):int 
			{
				a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac));
				return AddUnsigned(RotateLeft(a, s), b);
			};
		 
			function GG(a:int,b:int,c:int,d:int,x:int,s:int,ac:int):int
			{
				a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac));
				return AddUnsigned(RotateLeft(a, s), b);
			};
		 
			function HH(a:int,b:int,c:int,d:int,x:int,s:int,ac:int):int 
			{
				a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac));
				return AddUnsigned(RotateLeft(a, s), b);
			};
		 
			function II(a:int,b:int,c:int,d:int,x:int,s:int,ac:int):int 
			{
				a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac));
				return AddUnsigned(RotateLeft(a, s), b);
			};
		 
			function ConvertToWordArray(string:String):Array 
			{
				var lWordCount:int;
				var lMessageLength:int = string.length;
				var lNumberOfWords_temp1:int=lMessageLength + 8;
				var lNumberOfWords_temp2:int=(lNumberOfWords_temp1-(lNumberOfWords_temp1 % 64))/64;
				var lNumberOfWords:int = (lNumberOfWords_temp2+1)*16;
				var lWordArray:Array=new Array(lNumberOfWords-1);
				var lBytePosition:int = 0;
				var lByteCount:int = 0;
				while ( lByteCount < lMessageLength ) {
					lWordCount = (lByteCount-(lByteCount % 4))/4;
					lBytePosition = (lByteCount % 4)*8;
					lWordArray[lWordCount] = (lWordArray[lWordCount] | (string.charCodeAt(lByteCount)<<lBytePosition));
					lByteCount++;
				}
				lWordCount = (lByteCount-(lByteCount % 4))/4;
				lBytePosition = (lByteCount % 4)*8;
				lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80<<lBytePosition);
				lWordArray[lNumberOfWords-2] = lMessageLength<<3;
				lWordArray[lNumberOfWords-1] = lMessageLength>>>29;
				return lWordArray;
			};
		 
			function WordToHex(lValue:int):String
			{
				var WordToHexValue:String="",WordToHexValue_temp:String="",lByte:int,lCount:int;
				for (lCount = 0;lCount<=3;lCount++) {
					lByte = (lValue>>>(lCount*8)) & 255;
					WordToHexValue_temp = "0" + lByte.toString(16);
					WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2);
				}
				return WordToHexValue;
			};
		 
			function Utf8Encode(string:String):String 
			{
		 
				var utftext:String = "";
		 
				for (var n:int = 0; n < string.length; n++) {
		 
					var c:int = string.charCodeAt(n);
		 
					if (c < 128) {
						utftext += String.fromCharCode(c);
					}
					else if((c > 127) && (c < 2048)) {
						utftext += String.fromCharCode((c >> 6) | 192);
						utftext += String.fromCharCode((c & 63) | 128);
					}
					else {
						utftext += String.fromCharCode((c >> 12) | 224);
						utftext += String.fromCharCode(((c >> 6) & 63) | 128);
						utftext += String.fromCharCode((c & 63) | 128);
					}
		 
				}
		 
				return utftext;
			};
		 
			var x:Array;
			var k:int,AA:int,BB:int,CC:int,DD:int,a:int,b:int,c:int,d:int;
			var S11:int=7, S12:int=12, S13:int=17, S14:int=22;
			var S21:int=5, S22:int=9 , S23:int=14, S24:int=20;
			var S31:int=4, S32:int=11, S33:int=16, S34:int=23;
			var S41:int=6, S42:int=10, S43:int=15, S44:int=21;
		 
			string = Utf8Encode(string);
		 
			x = ConvertToWordArray(string);
		 
			a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;
		 
			for (k=0;k<x.length;k+=16) {
				AA=a; BB=b; CC=c; DD=d;
				a=FF(a,b,c,d,x[k+0], S11,0xD76AA478);
				d=FF(d,a,b,c,x[k+1], S12,0xE8C7B756);
				c=FF(c,d,a,b,x[k+2], S13,0x242070DB);
				b=FF(b,c,d,a,x[k+3], S14,0xC1BDCEEE);
				a=FF(a,b,c,d,x[k+4], S11,0xF57C0FAF);
				d=FF(d,a,b,c,x[k+5], S12,0x4787C62A);
				c=FF(c,d,a,b,x[k+6], S13,0xA8304613);
				b=FF(b,c,d,a,x[k+7], S14,0xFD469501);
				a=FF(a,b,c,d,x[k+8], S11,0x698098D8);
				d=FF(d,a,b,c,x[k+9], S12,0x8B44F7AF);
				c=FF(c,d,a,b,x[k+10],S13,0xFFFF5BB1);
				b=FF(b,c,d,a,x[k+11],S14,0x895CD7BE);
				a=FF(a,b,c,d,x[k+12],S11,0x6B901122);
				d=FF(d,a,b,c,x[k+13],S12,0xFD987193);
				c=FF(c,d,a,b,x[k+14],S13,0xA679438E);
				b=FF(b,c,d,a,x[k+15],S14,0x49B40821);
				a=GG(a,b,c,d,x[k+1], S21,0xF61E2562);
				d=GG(d,a,b,c,x[k+6], S22,0xC040B340);
				c=GG(c,d,a,b,x[k+11],S23,0x265E5A51);
				b=GG(b,c,d,a,x[k+0], S24,0xE9B6C7AA);
				a=GG(a,b,c,d,x[k+5], S21,0xD62F105D);
				d=GG(d,a,b,c,x[k+10],S22,0x2441453);
				c=GG(c,d,a,b,x[k+15],S23,0xD8A1E681);
				b=GG(b,c,d,a,x[k+4], S24,0xE7D3FBC8);
				a=GG(a,b,c,d,x[k+9], S21,0x21E1CDE6);
				d=GG(d,a,b,c,x[k+14],S22,0xC33707D6);
				c=GG(c,d,a,b,x[k+3], S23,0xF4D50D87);
				b=GG(b,c,d,a,x[k+8], S24,0x455A14ED);
				a=GG(a,b,c,d,x[k+13],S21,0xA9E3E905);
				d=GG(d,a,b,c,x[k+2], S22,0xFCEFA3F8);
				c=GG(c,d,a,b,x[k+7], S23,0x676F02D9);
				b=GG(b,c,d,a,x[k+12],S24,0x8D2A4C8A);
				a=HH(a,b,c,d,x[k+5], S31,0xFFFA3942);
				d=HH(d,a,b,c,x[k+8], S32,0x8771F681);
				c=HH(c,d,a,b,x[k+11],S33,0x6D9D6122);
				b=HH(b,c,d,a,x[k+14],S34,0xFDE5380C);
				a=HH(a,b,c,d,x[k+1], S31,0xA4BEEA44);
				d=HH(d,a,b,c,x[k+4], S32,0x4BDECFA9);
				c=HH(c,d,a,b,x[k+7], S33,0xF6BB4B60);
				b=HH(b,c,d,a,x[k+10],S34,0xBEBFBC70);
				a=HH(a,b,c,d,x[k+13],S31,0x289B7EC6);
				d=HH(d,a,b,c,x[k+0], S32,0xEAA127FA);
				c=HH(c,d,a,b,x[k+3], S33,0xD4EF3085);
				b=HH(b,c,d,a,x[k+6], S34,0x4881D05);
				a=HH(a,b,c,d,x[k+9], S31,0xD9D4D039);
				d=HH(d,a,b,c,x[k+12],S32,0xE6DB99E5);
				c=HH(c,d,a,b,x[k+15],S33,0x1FA27CF8);
				b=HH(b,c,d,a,x[k+2], S34,0xC4AC5665);
				a=II(a,b,c,d,x[k+0], S41,0xF4292244);
				d=II(d,a,b,c,x[k+7], S42,0x432AFF97);
				c=II(c,d,a,b,x[k+14],S43,0xAB9423A7);
				b=II(b,c,d,a,x[k+5], S44,0xFC93A039);
				a=II(a,b,c,d,x[k+12],S41,0x655B59C3);
				d=II(d,a,b,c,x[k+3], S42,0x8F0CCC92);
				c=II(c,d,a,b,x[k+10],S43,0xFFEFF47D);
				b=II(b,c,d,a,x[k+1], S44,0x85845DD1);
				a=II(a,b,c,d,x[k+8], S41,0x6FA87E4F);
				d=II(d,a,b,c,x[k+15],S42,0xFE2CE6E0);
				c=II(c,d,a,b,x[k+6], S43,0xA3014314);
				b=II(b,c,d,a,x[k+13],S44,0x4E0811A1);
				a=II(a,b,c,d,x[k+4], S41,0xF7537E82);
				d=II(d,a,b,c,x[k+11],S42,0xBD3AF235);
				c=II(c,d,a,b,x[k+2], S43,0x2AD7D2BB);
				b=II(b,c,d,a,x[k+9], S44,0xEB86D391);
				a=AddUnsigned(a,AA);
				b=AddUnsigned(b,BB);
				c=AddUnsigned(c,CC);
				d=AddUnsigned(d,DD);
			}
		 
			var temp:String = WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);
		 
			return temp.toLowerCase();
		}		
		
		
		
	    public function isLetterOrDigit(c:int):Boolean
	    {
	        if (c>=48 && c<=57)
	        {
	            return true;
	        }
	        if (c>=61 && c<=122)
	        {
	            return true;
	        }
	        if (c>=65 && c<=90)
	        {
	            return true;
	        }
	        return false;
	    }
	    public function isSpaceChar(c:int):Boolean
	    {
	        return c == 32;
	    }
	    public function compareStrings(s1:String, s2:String):int
	    {
	    	var nCommon:int=Math.min(s1.length, s2.length);
	    	var n:int;
	    	var c1:int, c2:int;
	    	for (n=0; n<nCommon; n++)
	    	{
	    		c1=s1.charCodeAt(n);
	    		c2=s2.charCodeAt(n);
	    		if (c1<c2)
	    		{
	    			return -1;
	    		}
	    		if (c1>c2)
	    		{
	    			return 1;
	    		}
	    	}
	    	if (s1.length<s2.length)
	    	{
	    		return -1;
	    	}
	    	if (s1.length>s2.length)
	    	{
	    		return 1;
	    	}
	    	return 0;
	    }		
	}
}