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

import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunIIF extends CRunExtension
{
    private static final int EXP_INT_INT=0;
    private static final int EXP_INT_STRING=1;
    private static final int EXP_INT_FLOAT=2;
    private static final int EXP_STRING_INT=3;
    private static final int EXP_STRING_STRING=4;
    private static final int EXP_STRING_FLOAT=5;
    private static final int EXP_FLOAT_INT=6;
    private static final int EXP_FLOAT_STRING=7;
    private static final int EXP_FLOAT_FLOAT=8;
    private static final int EXP_INT_BOOL=9;
    private static final int EXP_STRING_BOOL=10;
    private static final int EXP_FLOAT_BOOL=11;
    private static final int EXP_BOOL_INT=12;
    private static final int EXP_BOOL_STRING=13;
    private static final int EXP_BOOL_FLOAT=14;
    private static final int EXP_LAST_COMP=15;

    private boolean Last;

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }
    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        Last=false;
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

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EXP_INT_INT:
                return IntInt();
            case EXP_INT_STRING:
                return IntString();
            case EXP_INT_FLOAT:
                return IntFloat();
            case EXP_STRING_INT:
                return StringInt();
            case EXP_STRING_STRING:
                return StringString();
            case EXP_STRING_FLOAT:
                return StringFloat();
            case EXP_FLOAT_INT:
                return FloatInt();
            case EXP_FLOAT_STRING:
                return FloatString();
            case EXP_FLOAT_FLOAT:
                return FloatFloat();
            case EXP_INT_BOOL:
                return IntBool();
            case EXP_STRING_BOOL:
                return StringBool();
            case EXP_FLOAT_BOOL:
                return FloatBool();
            case EXP_BOOL_INT:
                return BoolInt();
            case EXP_BOOL_STRING:
                return BoolString();
            case EXP_BOOL_FLOAT:
                return BoolFloat();
            case EXP_LAST_COMP:
                return LastComp();
        }
        return null;
    }
    private CValue IntInt()
    {
        //get parameters
        int p1=ho.getExpParam().getInt();
        String comp = ho.getExpParam().getString();
        int p2 = ho.getExpParam().getInt();
        int r1 = ho.getExpParam().getInt();
        int r2 = ho.getExpParam().getInt();

        Last = CompareInts(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue IntString()
    {
        //get parameters
        String p1 = ho.getExpParam().getString();
        String comp = ho.getExpParam().getString();
        String p2 = ho.getExpParam().getString();
        int r1 = ho.getExpParam().getInt();
        int r2 = ho.getExpParam().getInt();

        Last = CompareStrings(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue IntFloat()
    {
        //get parameters
        double p1 = ho.getExpParam().getDouble();
        String comp = ho.getExpParam().getString();
        double p2 = ho.getExpParam().getDouble();
        int r1 = ho.getExpParam().getInt();
        int r2 = ho.getExpParam().getInt();

        Last = CompareFloats(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue StringInt()
    {
        //get parameters
        int p1 = ho.getExpParam().getInt();
        String comp = ho.getExpParam().getString();
        int p2 = ho.getExpParam().getInt();
        String r1 = ho.getExpParam().getString();
        String r2 = ho.getExpParam().getString();

        Last = CompareInts(p1,comp,p2);
        if (Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue StringString()
    {
        //get parameters
        String p1 = ho.getExpParam().getString();
        String comp = ho.getExpParam().getString();
        String p2 = ho.getExpParam().getString();
        String r1 = ho.getExpParam().getString();
        String r2 = ho.getExpParam().getString();

        Last = CompareStrings(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue StringFloat()
    {
        //get parameters
        double p1 = ho.getExpParam().getDouble();
        String comp = ho.getExpParam().getString();
        double p2 = ho.getExpParam().getDouble();
        String r1 = ho.getExpParam().getString();
        String r2 = ho.getExpParam().getString();

        Last = CompareFloats(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue FloatInt()
    {
        //get parameters
        int p1 = ho.getExpParam().getInt();
        String comp = ho.getExpParam().getString();
        int p2 = ho.getExpParam().getInt();
        double r1 = ho.getExpParam().getDouble();
        double r2 = ho.getExpParam().getDouble();

        Last = CompareInts(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue FloatString()
    {
        //get parameters
        String p1 =ho.getExpParam().getString();
        String comp =ho.getExpParam().getString();
        String p2 =ho.getExpParam().getString();
        double r1 = ho.getExpParam().getDouble();
        double r2 = ho.getExpParam().getDouble();

        Last = CompareStrings(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue FloatFloat()
    {
        //get parameters
        double p1=ho.getExpParam().getDouble();
        String comp = ho.getExpParam().getString();
        double p2 = ho.getExpParam().getDouble();
        double r1=ho.getExpParam().getDouble();
        double r2 = ho.getExpParam().getDouble();

        Last = CompareFloats(p1,comp,p2);
        if(Last)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue IntBool()
    {
        //get parameters
        boolean p1 = ho.getExpParam().getInt()!=0;
        int r1 = ho.getExpParam().getInt();
        int r2 = ho.getExpParam().getInt();

        if(p1)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue StringBool()
    {
        //get parameters
        boolean p1 = ho.getExpParam().getInt()!=0;
        String r1 = ho.getExpParam().getString();
        String r2 = ho.getExpParam().getString();

        if(p1)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue FloatBool()
    {
        //get parameters
        boolean p1 = ho.getExpParam().getInt()!=0;
        double r1=ho.getExpParam().getDouble();
        double r2 =ho.getExpParam().getDouble();

        if(p1)
            return new CValue(r1);
        else
            return new CValue(r2);
    }

    private CValue BoolInt()
    {
        //get parameters
        int p1 = ho.getExpParam().getInt();
        String comp = ho.getExpParam().getString();
        int p2 = ho.getExpParam().getInt();

        Last = CompareInts(p1,comp,p2);
        if (Last)
            return new CValue(1);
        else
            return new CValue(0);
    }

    public CValue BoolString()
    {
        //get parameters
        String p1 = ho.getExpParam().getString();
        String comp = ho.getExpParam().getString();
        String p2 = ho.getExpParam().getString();

        Last = CompareStrings(p1,comp,p2);
        if (Last)
            return new CValue(1);
        else
            return new CValue(0);
    }

    public CValue BoolFloat()
    {
        //get parameters
        double p1 = ho.getExpParam().getDouble();
        String comp = ho.getExpParam().getString();
        double p2 = ho.getExpParam().getDouble();

        Last = CompareFloats(p1,comp,p2);
        if (Last)
            return new CValue(1);
        else
            return new CValue(0);
    }

    public CValue LastComp()
    {
        if (Last)
            return new CValue(1);
        else
            return new CValue(0);
    }

    // ============================================================================
    //
    // MATT'S FUNCTIONS
    //
    // ============================================================================
    private boolean CompareInts(int p1, String comp, int p2)
    {
        //catch NULL
        if(comp == null)
            return p1 == p2;

        if((comp.charAt(0)=='=') || (comp.charAt(0) == '\0'))
            return p1 == p2;
        if(comp.charAt(0) == '!')
            return p1 != p2;

        if(comp.charAt(0) == '>')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1>=0;
            return p1>0;
        }

        if(comp.charAt(0) == '<')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1 <= p2;
            if(comp.length()>1 && comp.charAt(1) == '>')
                return p1 != p2;
            return p1 < p2;
        }

        //default
        return p1 == p2;
    }

    private boolean CompareStrings(String p1, String comp, String p2)
    {
        //catch NULLs
        String NullStr = "";
        if(p1 == null)
            p1 = NullStr;
        if(p2 == null)
            p2 = NullStr;

        if(comp == null)
            return p1.compareTo(p2) == 0;

        if((comp.charAt(0) == '=') || (comp.charAt(0) == '\0'))
            return p1.compareTo(p2) == 0;
        if(comp.charAt(0) == '!')
            return p1.compareTo(p2) != 0;

        if(comp.charAt(0) == '>')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1.compareTo(p2) >= 0;
            return p1.compareTo(p2) > 0;
        }

        if(comp.charAt(0) == '<')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1.compareTo(p2) <= 0;
            if(comp.length()>1 && comp.charAt(1) == '>')
                return p1.compareTo(p2) != 0;
            return p1.compareTo(p2) < 0;
        }

        return p1.compareTo(p2) == 0;
    }

    private boolean CompareFloats(double p1, String comp, double p2)
    {
        //catch NULL
        if(comp == null)
            return p1 == p2;

        if((comp.charAt(0) == '=') || (comp.charAt(0) == '\0'))
            return p1 == p2;
        if(comp.charAt(0) == '!')
            return p1 != p2;

        if(comp.charAt(0) == '>')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1 >= p2;
            return p1 > p2;
        }

        if(comp.charAt(0) == '<')
        {
            if(comp.length()>1 && comp.charAt(1) == '=')
                return p1 <= p2;
            if(comp.length()>1 && comp.charAt(1) == '>')
                return p1 != p2;
            return p1 < p2;
        }

        //default
        return p1 == p2;
    }


}
