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

package Extensions;

import java.util.StringTokenizer;
import java.util.Vector;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunStringTokenizer extends CRunExtension
{
    Vector<String> Tokens;
    Vector<Vector<String>> Tokens2D;
    
    private CValue expRet;

    public CRunStringTokenizer()
    {
        Tokens = new Vector<String>();
        Tokens2D = new Vector<Vector<String>>();
        expRet = new CValue(0);
    }

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return false;
    }

    @Override
	public void destroyRunObject(boolean flag)
    {
    }

    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return false;
    }

    @Override
	public void action(int num, CActExtension act)
    {
        switch(num)
        {
            case 0: // '\0'
                act0_Splitstring0withdelimiters11D(act);
                break;

            case 1: // '\001'
                act1_Splitstring0withdelimiters1and22D(act);
                break;
        }
    }

    @Override
	public CValue expression(int num)
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
    
    ///////////////////////////////////////////////////////////////
    //
    //				Actions
    //
    ///////////////////////////////////////////////////////////////

    private void act0_Splitstring0withdelimiters11D(CActExtension act)
    {
        String param0 = act.getParamExpString(rh, 0);
        String param1 = act.getParamExpString(rh, 1);
        Tokens.clear();
        StringTokenizer Tokenizer = new StringTokenizer(param0, param1);
        int TokenCount = Tokenizer.countTokens();

        for(int i = 0; i < TokenCount; i++)
            Tokens.add(Tokenizer.nextToken(param1));

    }

    private void act1_Splitstring0withdelimiters1and22D(CActExtension act)
    {
        String param0 = act.getParamExpString(rh, 0);
        String param1 = act.getParamExpString(rh, 1);
        String param2 = act.getParamExpString(rh, 2);
        
        Tokens2D.clear();
        
        StringTokenizer XTokenizer = new StringTokenizer(param0, param1);
        
        int XTokenCount = XTokenizer.countTokens();
        for(int x = 0; x < XTokenCount; x++)
        {
            Vector<String> New = new Vector<String>();
            StringTokenizer YTokenizer = new StringTokenizer(XTokenizer.nextToken(param1), param2);
            
            int YTokenCount = YTokenizer.countTokens();
            for(int y = 0; y < YTokenCount; y++)
                New.add((YTokenizer.nextToken(param2)));

            Tokens2D.add(New);
        }

    }
    
    ///////////////////////////////////////////////////////////////
    //
    //				Expressions
    //
    ///////////////////////////////////////////////////////////////

    private CValue exp0_ElementCount()
    {
    	
        expRet.forceInt(Tokens.size());
        return expRet;
    }

    private CValue exp1_Element()
    {
    	expRet.forceString("");
        int param0 = ho.getExpParam().getInt();
        
        if(param0 < 0 || param0 >= Tokens.size())
        	return expRet;
        
        expRet.forceString(Tokens.get(param0));
        return expRet;
    }

    private CValue exp2_Element2D()
    {
    	expRet.forceString("");
        int param0 = ho.getExpParam().getInt();
        int param1 = ho.getExpParam().getInt();
        if(param0 < 0 || param0 >= Tokens2D.size())
        	return expRet;
		Vector<String> v = Tokens2D.get(param0);
        if(param1 < 0 || param1 >= v.size() || v.isEmpty())
        	return expRet;
        expRet.forceString(v.get(param1));
        return expRet;
    }

    private CValue exp3_ElementCountX()
    {
        expRet.forceInt(Tokens2D.size());
        return expRet;
   }

    private CValue exp4_ElementCountY()
    {
        expRet.forceInt(0);
        int param0 = ho.getExpParam().getInt();
        if(param0 < 0 || param0 >= Tokens2D.size())
        	return expRet;
        expRet.forceInt(Tokens2D.get(param0).size());
        return expRet;
   }

}
