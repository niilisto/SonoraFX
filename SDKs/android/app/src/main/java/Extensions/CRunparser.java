/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
//----------------------------------------------------------------------------------
//
// CRunparser: String Parser object
// fin 14/04/09
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.StringTokenizer;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunparser extends CRunExtension
{
	public static final int CASE_INSENSITIVE = 0;
	public static final int SEARCH_LITERAL = 0;

	static final int CND_ISURLSAFE = 0;
	static final int ACT_SETSTRING = 0;
	static final int ACT_SAVETOFILE = 1;
	static final int ACT_LOADFROMFILE = 2;
	static final int ACT_APPENDTOFILE  = 3;
	static final int ACT_APPENDFROMFILE = 4;
	static final int ACT_RESETDELIMS= 5;
	static final int ACT_ADDDELIM= 6;
	static final int ACT_SETDELIM  = 7;
	static final int ACT_DELETEDELIMINDEX = 8;
	static final int ACT_DELETEDELIM  = 9;
	static final int ACT_SETDEFDELIMINDEX  =10;
	static final int ACT_SETDEFDELIM =11;
	static final int ACT_SAVEASCSV  =12;
	static final int ACT_LOADFROMCSV =13;
	static final int ACT_SAVEASMMFARRAY  = 14;
	static final int ACT_LOADFROMMMFARRAY = 15;
	static final int ACT_SAVEASDYNAMICARRAY=16;
	static final int ACT_LOADFROMDYNAMICARRAY= 17;
	static final int ACT_CASEINSENSITIVE = 18;
	static final int ACT_CASESENSITIVE = 19;
	static final int ACT_SEARCHLITERAL=20;
	static final int ACT_SEARCHWILDCARDS  =21;
	static final int ACT_SAVEASINI=22;
	static final int ACT_LOADFROMINI	=23;
	static final int EXP_GETSTRING = 0;
	static final int EXP_GETLENGTH  = 1;
	static final int EXP_LEFT =  2;
	static final int EXP_RIGHT =3;
	static final int EXP_MIDDLE =4;
	static final int EXP_NUMBEROFSUBS =5;
	static final int EXP_INDEXOFSUB = 6;
	static final int EXP_INDEXOFFIRSTSUB  = 7;
	static final int EXP_INDEXOFLASTSUB =  8;
	static final int EXP_REMOVE = 9;
	static final int EXP_REPLACE  = 10;
	static final int EXP_INSERT = 11;
	static final int EXP_REVERSE = 12;
	static final int EXP_UPPERCASE = 13;
	static final int EXP_LOWERCASE = 14;
	static final int EXP_URLENCODE= 15;
	static final int EXP_CHR = 16;
	static final int EXP_ASC = 17;
	static final int EXP_ASCLIST  =18;
	static final int EXP_NUMBEROFDELIMS =  19;
	static final int EXP_GETDELIM = 20;
	static final int EXP_GETDELIMINDEX = 21;
	static final int EXP_GETDEFDELIM = 22;
	static final int EXP_GETDEFDELIMINDEX = 23;
	static final int EXP_LISTCOUNT = 24;
	static final int EXP_LISTSETAT = 25;
	static final int EXP_LISTINSERTAT = 26;
	static final int EXP_LISTAPPEND = 27;
	static final int EXP_LISTPREPEND = 28;
	static final int EXP_LISTGETAT  =29;
	static final int EXP_LISTFIRST = 30;
	static final int EXP_LISTLAST = 31;
	static final int EXP_LISTFIND = 32;
	static final int EXP_LISTCONTAINS = 33;
	static final int EXP_LISTDELETEAT =34;
	static final int EXP_LISTSWAP  = 35;
	static final int EXP_LISTSORTASC = 36;
	static final int EXP_LISTSORTDESC = 37;
	static final int EXP_LISTCHANGEDELIMS = 38;
	static final int EXP_SETSTRING = 39;
	static final int EXP_SETVALUE = 40;
	static final int EXP_GETMD5	 = 41;

	String source = "";
	boolean caseSensitive;
	boolean wildcards;
	ArrayList<String> delims = new ArrayList<String>(); //Strings
	String defaultDelim;
	ArrayList<CRunparserElement> tokensE = new ArrayList<CRunparserElement>(); //parserElement
	private CValue expRet;

	public CRunparser()
	{
		expRet = new CValue(0);
	}
	@Override
	public int getNumberOfConditions()
	{
		return 1;
	}
	private String fixString(String input){
		for (int i = 0; i < input.length(); i++){
			if (input.charAt(i) < 10){
				return input.substring(0, i);
			}
		}
		return input;
	}
	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		file.setUnicode(false);
		file.skipBytes(4);
		this.source = fixString(file.readString(1025));
		short nComparison = file.readShort();
		if (nComparison == CASE_INSENSITIVE){
			this.caseSensitive = false;
		} else {
			this.caseSensitive = true;
		}
		short nSearchMode = file.readShort();
		if (nSearchMode == SEARCH_LITERAL){
			this.wildcards = false;
		} else {
			this.wildcards = true;
		}
		this.delims.clear();
		defaultDelim = "";
		return true;
	}
	public void redoTokens(){
		this.tokensE.clear();
		String sourceToTest = this.source;
		if (!sourceToTest.equals("")){
			int lastTokenLocation = 0;
			boolean work = true;
			while (work){
				ArrayList<CRunparserElement> aTokenE = new ArrayList<CRunparserElement>(); //parserElement
				ArrayList<String> aDelim = new ArrayList<String>(); //String
				for (int j = 0; j < this.delims.size(); j++){
					String delim = this.delims.get(j);
					int index = getSubstringIndex(sourceToTest, delim, 0);
					if (index != -1){
						aTokenE.add(new CRunparserElement(sourceToTest.substring(0, index), lastTokenLocation));
						aDelim.add(delim);
					}
				}
				//pick smallest token
				int smallestC = Integer.MAX_VALUE;
				int smallest = -1;
				for (int j = 0; j < aTokenE.size(); j++){
					if ((aTokenE.get(j)).text.length() < smallestC)
					{
						smallestC = (aTokenE.get(j)).text.length();
						smallest = j;
					}
				}
				if (smallest != -1 && sourceToTest.length() > 0){
					this.tokensE.add(aTokenE.get(smallest));
					sourceToTest = sourceToTest.substring(
								(aTokenE.get(smallest)).text.length() +
								(aDelim.get(smallest)).length());
					lastTokenLocation += (aTokenE.get(smallest)).text.length() +
								(aDelim.get(smallest)).length();
				} else {
					//if at end of search, add remainder
					this.tokensE.add(new CRunparserElement(sourceToTest, lastTokenLocation));
					work = false;
				}
			}
			for (int i = 0; i < this.tokensE.size(); i++){
				//remove ""
				CRunparserElement e = this.tokensE.get(i);
				if (e.text.equals("")){
					this.tokensE.remove(i);
					i--;
				}
			}
		}
	}
	public int getSubstringIndex(String source, String find, int occurance){ //occurance is 0-based
		String theSource = source;
		if (!this.caseSensitive){
			theSource = theSource.toLowerCase();
			find = find.toLowerCase();
		}
		if (this.wildcards){
			StringTokenizer st = new StringTokenizer(find, "*");
			int ct = st.countTokens();
			String asteriskless[] = new String[ct];
			for (int i = 0; i < ct; i++){
				asteriskless[i] = st.nextToken();
			}
			int lastOccurance = -1;
			for (int occ = 0; occ <= occurance; occ++){
				int asterisklessLocation[] = new int[ct];
				for (int asterisk = 0; asterisk < ct; asterisk++){
					for (int i = 0; i < theSource.length(); i++){
						String findThis = asteriskless[asterisk];
						//replace "?" occurances with chars from source
								for (int j = 0; j < findThis.length(); j++){
									if (findThis.substring(j, j + 1).equals("?")){
										if (i + j < theSource.length()){
											findThis = findThis.substring(0, j) +
													theSource.substring(i + j, i + j + 1) +
													findThis.substring(j + 1);
										}
									}
								}
								if ((asterisk == 0) || (asterisklessLocation[asterisk - 1] == -1)){
									asterisklessLocation[asterisk] = theSource.indexOf(findThis, lastOccurance + 1);
								} else {
									asterisklessLocation[asterisk] = theSource.indexOf(findThis, asterisklessLocation[asterisk - 1]);
								}
								if (asterisklessLocation[asterisk] != -1){
									i = theSource.length(); //stop
								}
					}
				}
				//now each int in asterisklessLocation should be in an acsending order (lowest first)
				//if they are not, then the string wasn't found in the source
				int last = -1;
				for (int i = 0; i < ct; i++){
					if (asterisklessLocation[i] > last){
						last = asterisklessLocation[i];
					} else {
						lastOccurance = -1;
						i = ct; //stop
					}
				}
				if ((occ == 0) || (lastOccurance != -1)){
					if (asterisklessLocation.length > 0){
						lastOccurance = asterisklessLocation[0];
					} else {
						lastOccurance = -1;
					}
				}
			}
			return lastOccurance;
		} else { //no wildcards
			int lastIndex = -1;
			for (int i = 0; i <= occurance; i++){
				lastIndex = theSource.indexOf(find, lastIndex + 1);
			}
			return lastIndex;
		}
	}
	public boolean substringMatches(String source, String find){
		String theSource = source;
		if (!this.caseSensitive){
			theSource = theSource.toLowerCase();
			find = find.toLowerCase();
		}
		if (this.wildcards){
			StringTokenizer st = new StringTokenizer(find, "*");
			int ct = st.countTokens();
			String asteriskless[] = new String[ct];
			for (int i = 0; i < ct; i++){
				asteriskless[i] = st.nextToken();
			}
			int asterisklessLocation[] = new int[ct];
			for (int asterisk = 0; asterisk < ct; asterisk++){
				for (int i = 0; i < theSource.length(); i++){
					String findThis = asteriskless[asterisk];
					//replace "?" occurances with chars from source
							for (int j = 0; j < findThis.length(); j++){
								if (findThis.substring(j, j + 1).equals("?")){
									if (i + j < theSource.length()){
										findThis = findThis.substring(0, j) +
												theSource.substring(i + j, i + j + 1) +
												findThis.substring(j + 1);
									}
								}
							}
							if ((asterisk == 0) || (asterisklessLocation[asterisk - 1] == -1)){
								asterisklessLocation[asterisk] = theSource.indexOf(findThis);
							} else {
								asterisklessLocation[asterisk] = theSource.indexOf(findThis, asterisklessLocation[asterisk - 1]);
							}
							if (asterisklessLocation[asterisk] != -1){
								i = theSource.length(); //stop
							}
				}
			}
			//now each int in asterisklessLocation should be in an acsending order (lowest first)
			//if they are not, then the string wasn't found in the source
			int last = -1;
			boolean ok = true;
			for (int i = 0; i < ct; i++){
				if (asterisklessLocation[i] > last){
					last = asterisklessLocation[i];
				} else {
					i = ct; //stop
					ok = false;
				}
			}
			if ((ok) && (find.length() > 0) && (asterisklessLocation.length > 0)){
				if (getSubstringIndex(theSource, find, 1) == -1){ //no other occurances
					if (find.substring(0, 1).equals("*")){
						if (find.substring(find.length() - 1).equals("*")){
							//if it starts with a * and ends with a *
							return true;
						} else {
							//if last element is at the end of the source
							if (asterisklessLocation[ct - 1] + asteriskless[ct - 1].length() == theSource.length()){
								return true;
							}
						}
					} else {
						if (asterisklessLocation[0] == 0){
							if (find.substring(find.length() - 1).equals("*")){
								//if it starts with a * and ends with a *
								return true;
							} else {
								//if last element is at the end of the source
								if (asterisklessLocation[ct - 1] + asteriskless[ct - 1].length() == theSource.length()){
									return true;
								}
							}
						}
					}
				}
			}
		} else { //no wildcards
			if ((theSource.length() == find.length()) && (theSource.indexOf(find, 0) == 0)){
				return true;
			}
		}
		return false;
	}
	@Override
	public void destroyRunObject(boolean bFast)
	{
	}
	@Override
	public int handleRunObject()
	{
		return REFLAG_ONESHOT;
	}

	public void displayRunObject(Canvas c, Paint p)
	{       
	}

	@Override
	public void pauseRunObject()
	{
	}
	@Override
	public void continueRunObject()
	{
	}
	public void saveBackground(Bitmap b)
	{
	}
	public void restoreBackground(Canvas c, Paint p)
	{
	}	
	public void killBackground()
	{
	}
	@Override
	public CFontInfo getRunObjectFont()
	{
		return null;
	}
	@Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
	{      

	}
	@Override
	public int getRunObjectTextColor()
	{
		return 0;
	}
	@Override
	public void setRunObjectTextColor(int rgb)
	{

	}
	@Override
	public CMask getRunObjectCollisionMask(int flags)
	{
		return null;
	}
	public Bitmap getRunObjectSurface()
	{
		return null;
	}
	@Override
	public void getZoneInfos()
	{
	}

	// Conditions
	// --------------------------------------------------
	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		if (num == CND_ISURLSAFE)
		{
			for (int index = 0; index < source.length(); index++){
				while (!Character.isLetterOrDigit(source.charAt(index))){
					if (source.charAt(index) == '+'){
						break;
					} else if (source.charAt(index) == '%'){
						if (source.length() > index + 2){
							if (Character.isLetterOrDigit(source.charAt(index + 1)) &&
									Character.isLetterOrDigit(source.charAt(index + 2))){
								index = index + 2;
							} else {
								return false;
							}
							break;
						} else {
							return false;
						}
					} else {
						return false;
					}
				}
			}
			return true;
		}
		return false;
	}

	// Actions
	// -------------------------------------------------
	@Override
	public void action(int num, CActExtension act)
	{
		switch (num)
		{
		case ACT_SETSTRING:
			source = act.getParamExpString(rh, 0);
			redoTokens();
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
		}
	}

	private void SP_addDelim(String delim){
		if (!delim.equals("")){
			boolean exists = false;
			for (int i = 0; i < delims.size(); i++){
				String thisDelim = delims.get(i);
				if (getSubstringIndex(thisDelim, delim, 0) >= 0){
					exists = true;
				}
			}
			if (exists == false){
				delims.add(delim);
				redoTokens();
				defaultDelim = delim;
			}
		}
	}
	private void SP_setDelim(String delim, int index){
		if (index == delims.size())
		{
			delims.add(delim);
			defaultDelim = delim;
			redoTokens();
		}
		else if ((index >= 0) && (index < delims.size())){
			delims.set(index, delim);
			defaultDelim = delim;
			redoTokens();
		}
	}
	private void SP_deleteDelimIndex(int index){
		if ((index >= 0) && (index < delims.size())){
			delims.remove(index);
			if (index < delims.size()){
				defaultDelim = delims.get(index);
			} else {
				defaultDelim = null;
			}
			redoTokens();
		}
	}
	private void SP_deleteDelim(String delim){
		for (int i = 0; i < delims.size(); i++){
			if (delims.get(i).equals(delim)){
				delims.remove(i);
				if (i < delims.size()){
					defaultDelim = delims.get(i);
				} else {
					defaultDelim = null;
				}
				redoTokens();
				return;
			}
		}
	}
	private void SP_setDefDelimIndex(int index){
		if ((index >= 0) && (index < delims.size())){
			defaultDelim = delims.get(index);
		}
	}
	private void SP_setDefDelim(String delim){
		for (int i = 0; i < delims.size(); i++){
			if (delims.get(i).equals(delim)){
				defaultDelim = delims.get(i);
				return;
			}
		}

		// If the delimiter doesn't exist, add it
		delims.add(delim);
		defaultDelim = delim;
		redoTokens();
	}

	// Expressions
	// --------------------------------------------
	@Override
	public CValue expression(int num)
	{
		switch (num){
		case EXP_GETSTRING:
			expRet.forceString(source);
			return expRet;
		case EXP_GETLENGTH:
			expRet.forceInt(source.length());
			return expRet;
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
			expRet.forceString(source.toUpperCase());
			return expRet;
		case EXP_LOWERCASE:
			expRet.forceString(source.toLowerCase());
			return expRet;
		case EXP_URLENCODE:
			return SP_urlEncode();
		case EXP_CHR:
			return SP_chr(ho.getExpParam().getInt());
		case EXP_ASC:
			return SP_asc(ho.getExpParam().getString());
		case EXP_ASCLIST:
			return SP_ascList(ho.getExpParam().getString());
		case EXP_NUMBEROFDELIMS:
			expRet.forceInt(delims.size());
			return expRet;
		case EXP_GETDELIM:
			return SP_getDelim(ho.getExpParam().getInt());
		case EXP_GETDELIMINDEX:
			return SP_getDelimIndex(ho.getExpParam().getString());
		case EXP_GETDEFDELIM:
			return SP_getDefDelim();
		case EXP_GETDEFDELIMINDEX:
			return SP_getDefDelimIndex();
		case EXP_LISTCOUNT:
			expRet.forceInt(tokensE.size());
			return expRet;
		case EXP_LISTSETAT:
			return SP_listSetAt(ho.getExpParam().getString(), ho.getExpParam().getInt());
		case EXP_LISTINSERTAT:
			return SP_listInsertAt(ho.getExpParam().getString(), ho.getExpParam().getInt());
		case EXP_LISTAPPEND:
			expRet.forceString(source + ((delims.size() > 0 && source.length() > 0) ? delims.get(0):"") + ho.getExpParam().getString());
			return expRet;
		case EXP_LISTPREPEND:
			expRet.forceString(ho.getExpParam().getString() + ((delims.size() > 0 && source.length() > 0) ? delims.get(0):"") + source);
			return expRet;
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
		expRet.forceInt(0);//won't be used
		return expRet;
	}

	private CValue SP_left(int i){
		expRet.forceString("");
		if ((i >= 0) && (i <= source.length())){
			expRet.forceString(source.substring(0,i));
		}
		return expRet;
	}
	private CValue SP_right(int i){
		expRet.forceString("");
		if ((i >= 0) && (i <= source.length())){
			expRet.forceString(source.substring(source.length() - i));
		}
		return expRet;
	}
	private CValue SP_middle(int i, int length){
		expRet.forceString("");
		length = Math.max(0, length);
		if ((i >= 0) && (i + length <= source.length())){
			expRet.forceString(source.substring(i, i + length));
		}
		return expRet;
	}
	private CValue SP_numberOfSubs(String sub){
		int count = 0;
		while (getSubstringIndex(source, sub, count) != -1){
			count++;
		}
		expRet.forceInt(count);
		return expRet;
	}
	private CValue SP_indexOfSub(String sub, int occurance){ //1-based
		occurance = Math.max(1, occurance);
		expRet.forceInt(getSubstringIndex(source, sub, occurance - 1));
		return expRet;
	}
	private CValue SP_indexOfFirstSub(String sub){
		expRet.forceInt(getSubstringIndex(source, sub, 0));
		return expRet;
	}
	private CValue SP_indexOfLastSub(String sub){
		int n = Math.max(1, SP_numberOfSubs(sub).getInt());
		expRet.forceInt(getSubstringIndex(source, sub, n - 1));
		return expRet;
	}
	private CValue SP_remove(String sub){
		int count = 0;
		ArrayList<Integer> parts = new ArrayList<Integer>(); //Integer
		int index = getSubstringIndex(source, sub, count);
		while (index != -1){
			parts.add(Integer.valueOf(index));
			count++;
			index = getSubstringIndex(source, sub, count);
		}
		if (parts.size() == 0){
			expRet.forceString(source);
			return expRet;
		}
		int last = 0;
		String r = "";
		for (int i = 0; i < parts.size(); i++){
			r += source.substring(last, parts.get(i).intValue());
			last = (parts.get(i)).intValue() + sub.length();
			if (i == parts.size() - 1){
				r += source.substring(last);
			}
		}
		expRet.forceString(r);
		return expRet;
	}
	private CValue SP_replace(String old, String newString){
		int count = 0;
		ArrayList<Integer> parts = new ArrayList<Integer>(); //Integer
		int index = getSubstringIndex(source, old, count);
		while (index != -1){
			parts.add(Integer.valueOf(index));
			count++;
			index = getSubstringIndex(source, old, count);
		}
		if (parts.size() == 0){
			expRet.forceString(source);
			return expRet;
		}
		int last = 0;
		String r = "";
		for (int i = 0; i < parts.size(); i++){
			r += source.substring(last, parts.get(i).intValue()) + newString;
			last = (parts.get(i)).intValue() + old.length();
			if (i == parts.size() - 1){
				r += source.substring(last);
			}
		}
		expRet.forceString(r);
		return expRet;
	}
	private CValue SP_insert(String insert, int index){
		expRet.forceString("");
		if ((index >= 1) && (index <= source.length())){
			expRet.forceString(source.substring(0, index - 1) + insert + source.substring(index - 1));
		}
		return expRet;
	}
	private CValue SP_reverse(){
		String r = "";
		for (int i = source.length() - 1; i >= 0; i--){
			r += source.substring(i, i + 1);
		}
		expRet.forceString(r);
		return expRet;
	}
	private CValue SP_urlEncode(){
		String r = "";
		for (int i = 0; i < source.length(); i++){
			if (Character.isLetterOrDigit(source.charAt(i))){
				r += source.substring(i, i + 1);
			} else {
				if(Character.isSpaceChar(source.codePointAt(i))){
					r += "+";
				} else if (source.codePointAt(i) == 13){
					r += "+";
					i++;
				} else {
					r += "%";
					r += Integer.toHexString(source.charAt(i) >> 4);
					r += Integer.toHexString(source.charAt(i) % 16);
				}
			}
		}
		expRet.forceString(r);
		return expRet;
	}
	private CValue SP_chr(int value){
		expRet.forceString("");
		try{
			String r = new String(new char[]{(char)value});
			expRet.forceString(r);
		} catch (Exception e){}
		return expRet;
	}
	private CValue SP_asc(String value){
		expRet.forceInt(0);
		if (value.length() > 0){
			try{
				int r = value.charAt(0);
				expRet.forceInt(r);
				return expRet;
			} catch (Exception e){}
		}
		return expRet;
	}
	private CValue SP_ascList(String delim){
		expRet.forceString("");
		try{
			String r = "";
			for (int i = 0; i < source.length(); i++){
				r += Integer.valueOf(source.charAt(i)).toString();
				if (i < source.length() - 1){
					r += delim;
				}
			}
			expRet.forceString(r);
		} catch (Exception e){}
		return expRet;
	}
	private CValue SP_getDelim(int i){ //0-based, silly 3ee
		expRet.forceString("");
		if ((i >= 0) && (i < delims.size())){
			expRet.forceString(delims.get(i));
		}
		
		return expRet;
	}
	private CValue SP_getDelimIndex(String delim){
		expRet.forceInt(-1);
		for (int i = 0; i < delims.size(); i++){
			String thisDelim = delims.get(i);
			if (getSubstringIndex(thisDelim, delim, 0) >= 0){
				expRet.forceInt(i);
			}
		}
		return expRet;
	}
	private CValue SP_getDefDelim(){
		expRet.forceString("");
		if (defaultDelim != null){
			expRet.forceString(defaultDelim);
		}
		return expRet;
	}
	private CValue SP_getDefDelimIndex(){
		expRet.forceInt(-1);
		if (defaultDelim != null){
			for (int i = 0; i < delims.size(); i++){
				String thisDelim = delims.get(i);
				if (getSubstringIndex(thisDelim, defaultDelim, 0) >= 0){
					expRet.forceInt(i);
				}
			}
		}
		return expRet;
	}
	private CValue SP_listSetAt(String replace, int index){ //1-based
		expRet.forceString("");
		if ((index >= 1) && (index <= tokensE.size())){
			CRunparserElement e = tokensE.get(index - 1);
			if(e != null) {
				String r = source.substring(0, e.index) + replace + source.substring(e.endIndex);
				expRet.forceString(r);
			}
		}
		return expRet;
	}
	private CValue SP_listInsertAt(String insert, int index){ //1-based
		expRet.forceString("");
		if ((index >= 1) && (index <= tokensE.size())){
			CRunparserElement e = tokensE.get(index - 1);
			if(e != null) {
				String r = source.substring(0, e.index) + insert + source.substring(e.index);
				expRet.forceString(r);
			}
		}
		return expRet;
	}
	private CValue SP_listGetAt(int index){ //1-based
		expRet.forceString("");
		if ((index >= 1) && (index <= tokensE.size())){
			CRunparserElement e = tokensE.get(index - 1);
			if(e != null)
				expRet.forceString(e.text);
		}
		return expRet;
	}
	private CValue SP_listFirst(){
		expRet.forceString("");
		if (tokensE.size() > 0){
			CRunparserElement e = tokensE.get(0);
			if(e != null)
				expRet.forceString(e.text);
		}
		return expRet;
	}
	private CValue SP_listLast() {
		expRet.forceString("");
		if (tokensE.size() > 0){
			CRunparserElement e = tokensE.get(tokensE.size() - 1);
			if(e != null)
				expRet.forceString(e.text);
		}
		return expRet;
	}
	private CValue SP_listFind(String find, int occurance){ //matching //1-based
		expRet.forceInt(0);
		if ((occurance > 0) && (find.length() > 0)) {
			int occuranceCount = 0;
			for (int i = 0; i < tokensE.size(); i++){
				CRunparserElement e = tokensE.get(i);
				if(e == null)
					return expRet;
				if (substringMatches(e.text, find)){
					occuranceCount++;
					if (occuranceCount == occurance){
						expRet.forceInt(i + 1);
						break;
					}               
				}
			}
		}
		return expRet;
	}

	private CValue SP_listContains(String find, int occurance){ //matching //1-based
		expRet.forceInt(0);
		if ((occurance > 0) && (find.length() > 0)){
			int occuranceCount = 0;
			for (int i = 0; i < tokensE.size(); i++){
				CRunparserElement e = tokensE.get(i);
				if(e == null)
					continue;
				if (getSubstringIndex(e.text, find, 0) != -1){
					occuranceCount++;
					if (occuranceCount == occurance){
						expRet.forceInt(i + 1);
						break;
					}
				}

			}
		}
		return expRet;
	}
	private CValue SP_listDeleteAt(int index){ //1-based
		expRet.forceString("");
		if ((index >= 1) && (index <= tokensE.size())){
			CRunparserElement e = tokensE.get(index - 1);
			if(e != null) {
				String r = source.substring(0, e.index) + source.substring(e.endIndex);
				expRet.forceString(r);
			}
			return expRet;
		}
		expRet.forceString(source);
		return expRet;
	}
	private CValue SP_listSwap(int i1, int i2){ //1-based
		expRet.forceString("");
		if ((i1 >= 1) && (i2 >= 1) && (i1 <= tokensE.size()) && (i2 <= tokensE.size())){
			if (i1 == i2){
				expRet.forceString(source);
				return expRet;
			}
			CRunparserElement e1 = tokensE.get(i1 - 1);
			CRunparserElement e2 = tokensE.get(i2 - 1);
			String r = "";
			if(e1 == null || e2 == null) {
				expRet.forceString(r);
				return expRet;
			}

			if (i1 > i2){
				//e2 comes sooner
				r += source.substring(0, e2.index); //string leading up to e2
				r += source.substring(e1.index, e1.endIndex); //e1
				r += source.substring(e2.endIndex, e1.index); //string between e2 and e1
				r += source.substring(e2.index, e2.endIndex); //e2
				r += source.substring(e1.endIndex); //string from end of e1 to end
			} else { //i1 < i2
				//e1 comes sooner
				r += source.substring(0, e1.index); //string leading up to e1
				r += source.substring(e2.index, e2.endIndex); //e2
				r += source.substring(e1.endIndex, e2.index); //string between e1 and e2
				r += source.substring(e1.index, e1.endIndex); //e1
				r += source.substring(e2.endIndex); //string from end of e2 to end
			}
			expRet.forceString(r);
		}
		return expRet;
	}
	private CValue SP_listSortAsc(){
		ArrayList<CRunparserElement> sorted = new ArrayList<CRunparserElement>(); //parserElement
		for (int i = 0; i < tokensE.size(); i++){
			CRunparserElement e = tokensE.get(i);
            if(e == null)
            	continue;

			if (sorted.size() == 0){
				sorted.add(e);
			} else {
				int index = 0;
				for (int j = 0; j < sorted.size(); j++){
					CRunparserElement element = sorted.get(j);
					if (caseSensitive){
						if (e.text.compareTo(element.text) >= 0){
							index = j+1;
						}
					} else {
						if (e.text.compareToIgnoreCase(element.text) >= 0){
							index = j+1;
						}
					}
				}
				sorted.add(index, e);
			}
		}
		String r = "";
		for (int i = 0; i < sorted.size(); i++){
			CRunparserElement e = sorted.get(i);
			CRunparserElement oe = tokensE.get(i);
            if(e == null || oe == null)
            	continue;
			if (i == 0){
				r += source.substring(0, oe.index);
			} else {
				CRunparserElement lastOrigE = tokensE.get(i - 1);
				r += source.substring(lastOrigE.endIndex, oe.index);
			}
			r += source.substring(e.index, e.endIndex);
			if (i == sorted.size() - 1){
				r += source.substring(oe.endIndex);
			}
		}
		expRet.forceString(r);
		return expRet;
	}
	private CValue SP_listSortDesc(){
		ArrayList<CRunparserElement> sorted = new ArrayList<CRunparserElement>(); //parserElement
		for (int i = 0; i < tokensE.size(); i++){
			CRunparserElement e = tokensE.get(i);
            if(e == null)
            	continue;

			if (sorted.size() == 0){
				sorted.add(e);
			} else {
				int index = sorted.size();
				for (int j = sorted.size() - 1; j >= 0; j--){
					CRunparserElement element = sorted.get(j);
					if (caseSensitive){
						if (e.text.compareTo(element.text) >= 0){
							index = j;
						}
					} else {
						if (e.text.compareToIgnoreCase(element.text) >= 0){
							index = j;
						}
					}
				}
				sorted.add(index, e);
			}
		}
		String r = "";
		for (int i = 0; i < sorted.size(); i++){
			CRunparserElement e = sorted.get(i);
			CRunparserElement oe = tokensE.get(i);
            if(e == null || oe == null)
            	continue;

			if (i == 0){
				r += source.substring(0, oe.index);
			} else {
				CRunparserElement lastOrigE = tokensE.get(i - 1);
				r += source.substring(lastOrigE.endIndex, oe.index);
			}
			r += source.substring(e.index, e.endIndex);
			if (i == sorted.size() - 1){
				r += source.substring(oe.endIndex);
			}
		}
		expRet.forceString(r);
		return expRet;
	}

	private CValue SP_listChangeDelims(String changeDelim){
		expRet.forceString("");
		if (defaultDelim != null){
			String r = "";
			for (int i = 0; i < tokensE.size(); i++){
				CRunparserElement e = tokensE.get(i);
	            if(e == null)
	            	continue;

				int here = e.index - defaultDelim.length();
				if ((here >= 0) && (source.substring(here, e.index).equals(defaultDelim))){
					r += changeDelim;
				} else {
					if (i == 0){
						r += source.substring(0, e.index);
					} else {
						CRunparserElement lastOrigE = tokensE.get(i - 1);
						r += source.substring(lastOrigE.endIndex, e.index);
					}
				}
				r += source.substring(e.index, e.endIndex);
				if (i == tokensE.size() - 1){
					if (source.substring(e.endIndex).equals(defaultDelim)){
						r += changeDelim;
					} else {
						r += source.substring(e.endIndex);
					}
				}
			}
			expRet.forceString(r);
		}
		return expRet;
	}
	private CValue SP_setStringEXP(String newSource){
		source = newSource;
		redoTokens();
		expRet.forceString("");
		return expRet;
	}
	private CValue SP_setValueEXP(String newSource){
		source = newSource;
		redoTokens();
		expRet.forceInt(0);
		return expRet;
	}


	private CValue SP_getMD5(){
		MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("MD5");
		} catch(Exception e) {}
		String r = "";
		if (md != null){
			md.reset();
			md.update(source.getBytes());
			byte messageDigest[] = md.digest();
			for (int i=0;i<messageDigest.length;i++) {
				r += String.format("%02x", (0xFF & messageDigest[i]));
			}
		}
		expRet.forceString(r);
		return expRet;
	}
}
