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
// CRunKcDbl: Double precision calculator object
// fin 30/1/09
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;
import java.util.Locale;

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

public class CRunKcDbl extends CRunExtension
{
//typedef struct tagEDATA_V0
//{
//	extHeader		eHeader;
//
//	DWORD			dwFree1;
//	DWORD			dwFree2;
//
//} EDITDATA;
//typedef EDITDATA _far *			LPEDATA;
    static final int ACT_SETFORMAT_STD = 0;
    static final int ACT_SETFORMAT_NDIGITS = 1;
    static final int ACT_SETFORMAT_NDECIMALS = 2;
    static final int EXP_ADD = 0;
    static final int EXP_SUB = 1;
    static final int EXP_MUL = 2;
    static final int EXP_DIVIDE = 3;
    static final int EXP_FMT_NDIGITS = 4;
    static final int EXP_FMT_NDECIMALS = 5;

	int m_nDigits;
    int m_nDecimals;

    public CRunKcDbl()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        ho.hoX = cob.cobX;
        ho.hoY = cob.cobY;
        ho.hoImgWidth = 32;
        ho.hoImgHeight = 32;

        this.m_nDigits = 32;
        this.m_nDecimals = -1;

        return true;
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

    public void saveBackground(Bitmap img)
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
    	return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case ACT_SETFORMAT_STD:
                Act_SetFormat_Std();
                break;
            case ACT_SETFORMAT_NDIGITS:
                Act_SetFormat_NDigits(act.getParamExpression(rh, 0));
                break;
            case ACT_SETFORMAT_NDECIMALS:
                Act_SetFormat_NDecimals(act.getParamExpression(rh, 0));
                break;
        }
    }

    private void Act_SetFormat_Std()
    {
        m_nDigits = 32;
        m_nDecimals = -1;
    }

    private void Act_SetFormat_NDigits(int n)
    {
        m_nDigits = n;
        if (m_nDigits <= 0)
        {
            m_nDigits = 1;
        }
        if (m_nDigits > 256)
        {
            m_nDigits = 256;
        }
        m_nDecimals = -1;
    }

    private void Act_SetFormat_NDecimals(int n)
    {
        m_nDecimals = n;
        if (m_nDecimals < 0)
        {
            m_nDecimals = 0;
        }
        else if (m_nDecimals > 256)
        {
            m_nDecimals = 256;
        }
    }
    
    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EXP_ADD:
                return Exp_Add(ho.getExpParam().getString(), ho.getExpParam().getString());
            case EXP_SUB:
                return Exp_Sub(ho.getExpParam().getString(), ho.getExpParam().getString());
            case EXP_MUL:
                return Exp_Mul(ho.getExpParam().getString(), ho.getExpParam().getString());
            case EXP_DIVIDE:
                return Exp_Div(ho.getExpParam().getString(), ho.getExpParam().getString());
            case EXP_FMT_NDIGITS:
                return Exp_Fmt_NDigits(ho.getExpParam().getString(), ho.getExpParam().getInt());
            case EXP_FMT_NDECIMALS:
                return Exp_Fmt_NDecimals(ho.getExpParam().getString(), ho.getExpParam().getInt());
        }
        return new CValue(0);//won't be used
    }
    
    double StringToDouble(String ps)
    {
        double r = 0;
        try
        {
        	NumberFormat nf = NumberFormat.getInstance(Locale.US);
        	r = nf.parse(ps).doubleValue();
        }
        catch (Exception e)
        {
        }
        return r;
    }

    String DoubleToString(double v)
    {
        DecimalFormatSymbols otherSymbols = new DecimalFormatSymbols(Locale.US);
        DecimalFormat fmt = new DecimalFormat();
        fmt.setDecimalFormatSymbols(otherSymbols);
        String param = fmt.format(v).replace(",",  "");
        if (m_nDecimals == -1)
        {
            //ignore decimal place settings
            if ((param.length() > 2) && (param.substring(param.length() - 2).equals(".0")))
            {
                param = param.substring(0, param.length() - 2);
            }
            if(v-(int)v > 0) //if (param.indexOf(".") >= 0)
            {
                //is decimal number
                if (param.substring(0, param.indexOf(".")).length() > m_nDigits + ((param.indexOf("-") >= 0) ? 1 : 0))
                { //allow a "." and/or "-"
                    //exponential
                    String formatDig = "";
                    for (int i = 0; i < m_nDigits - 1; i++)
                    {
                        if (i == 0)
                        {
                            formatDig = ".";
                        }
                        formatDig += "0";
                    }
                    DecimalFormat fmtObj = new DecimalFormat("0" + formatDig + "E000", otherSymbols);
                    String plusLess = fmtObj.format(v);
                    return plusLess.substring(0, plusLess.indexOf("E")) + "e+" + plusLess.substring(plusLess.indexOf("E") + 1);
                }
                //or just remove some decimal places
                String prefix = param.substring(0, param.indexOf("."));
                String formatDec = "";
                for (int i = 0; i < prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0); i++)
                {
                    formatDec += "#";
                }
                formatDec += ".";
                //String suffix = param.substring(param.indexOf(".") + 1);
                for (int i = formatDec.length() - 1; i < m_nDigits; i++)
                {
                    formatDec += "0";
                }
                NumberFormat fmtObj = new DecimalFormat(formatDec, otherSymbols);                //DecimalFormat fmtObj = new DecimalFormat(formatDec);
                fmtObj.setMinimumIntegerDigits(prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0));
                return fmtObj.format(v);
            }
            else
            {
                //is an int
                if (param.length() > m_nDigits + ((param.indexOf("-") >= 0) ? 1 : 0))
                {
                    //exponential
                    String formatDig = "";
                    for (int i = 0; i < m_nDigits - 1; i++)
                    {
                        if (i == 0)
                        {
                            formatDig = ".";
                        }
                        formatDig += "0";
                    }
                    NumberFormat fmtObj = new DecimalFormat("0" + formatDig + "E000",otherSymbols);
                    String plusLess = fmtObj.format(v);
                    return plusLess.substring(0, plusLess.indexOf("E")) + "e+" + plusLess.substring(plusLess.indexOf("E") + 1);
                }
                return String.valueOf((int)v); //normal int
            }
        }
        else
        {
            //don't ignore decimal place settings
            String format = "";
            String prefix = param.indexOf(".") >= 0 ? param.substring(0, param.indexOf(".")) : param;
            for (int i = 0; i < prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0); i++)
            {
                format += "#";
            }
            String decimalPlaces = "";
            for (int i = 0; i < m_nDecimals; i++)
            {
                decimalPlaces += "0";
            }
            if (!decimalPlaces.equals(""))
            {
                format += "." + decimalPlaces;
            }
            NumberFormat fmtObj = new DecimalFormat(format, otherSymbols);
            fmtObj.setMinimumIntegerDigits(prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0));
            return fmtObj.format(v);
        }
    }

    private CValue Exp_Add(String pValStr1, String pValStr2)
    {
        String pDest = "";
        if (pValStr1 != null && pValStr2 != null)
        {
            double val1 = StringToDouble(pValStr1);
            double val2 = StringToDouble(pValStr2);
            val1 += val2;
            pDest = DoubleToString(val1);
        }
        return new CValue(pDest);
    }

    private CValue Exp_Sub(String pValStr1, String pValStr2)
    {
        String pDest = "";
        if (pValStr1 != null && pValStr2 != null)
        {
            double val1 = StringToDouble(pValStr1);
            double val2 = StringToDouble(pValStr2);
            val1 -= val2;
            pDest = DoubleToString(val1);
        }
        return new CValue(pDest);
    }

    private CValue Exp_Mul(String pValStr1, String pValStr2)
    {
        String pDest = "";
        if (pValStr1 != null && pValStr2 != null)
        {
            double val1 = StringToDouble(pValStr1);
            double val2 = StringToDouble(pValStr2);
            val1 *= val2;
            pDest = DoubleToString(val1);
        }
        return new CValue(pDest);
    }

    private CValue Exp_Div(String pValStr1, String pValStr2)
    {
        String pDest = "";
        if (pValStr1 != null && pValStr2 != null)
        {
            double val1 = StringToDouble(pValStr1);
            double val2 = StringToDouble(pValStr2);
            if (val2 != 0.0)
            {
                val1 /= val2;
                pDest = DoubleToString(val1);
            }
        }
        return new CValue(pDest);
    }

    private CValue Exp_Fmt_NDigits(String param, int n)
    {
        n = Math.min(Math.max(0, n), 256);
        if ((param.length() > 2) && (param.substring(param.length() - 2).equals(".0")))
        {
            param = param.substring(0, param.length() - 2);
        }
        if (param.indexOf(".") >= 0)
        {
            //is decimal number
            if (param.substring(0, param.indexOf(".")).length() > n + ((param.indexOf("-") >= 0) ? 1 : 0))
            { //allow a "." and/or "-"
                //exponential
                String formatDig = "";
                for (int i = 0; i < n - 1; i++)
                {
                    if (i == 0)
                    {
                        formatDig = ".";
                    }
                    formatDig += "0";
                }
                DecimalFormat fmtObj = new DecimalFormat("0" + formatDig + "E000");
                String plusLess = fmtObj.format(StringToDouble(param));
                return new CValue(plusLess.substring(0, plusLess.indexOf("E")) + "e+" + plusLess.substring(plusLess.indexOf("E") + 1));
            }
            //or just remove some decimal places
            String prefix = param.substring(0, param.indexOf("."));
            String formatDec = "";
            for (int i = 0; i < prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0); i++)
            {
                formatDec += "#";
            }
            formatDec += ".";
            //String suffix = param.substring(param.indexOf(".") + 1);
            for (int i = formatDec.length() - 1; i < n; i++)
            {
                formatDec += "0";
            }
            DecimalFormat fmtObj = new DecimalFormat(formatDec);
            return new CValue(fmtObj.format(StringToDouble(param)));
        }
        else
        {
            //is an int
            if (param.length() > n + ((param.indexOf("-") >= 0) ? 1 : 0))
            {
                //exponential
                String formatDig = "";
                for (int i = 0; i < n - 1; i++)
                {
                    if (i == 0)
                    {
                        formatDig = ".";
                    }
                    formatDig += "0";
                }
                DecimalFormat fmtObj = new DecimalFormat("0" + formatDig + "E000");
                String plusLess = fmtObj.format(StringToDouble(param));
                return new CValue(plusLess.substring(0, plusLess.indexOf("E")) + "e+" + plusLess.substring(plusLess.indexOf("E") + 1));
            }
            return new CValue(param); //normal int
        }
    }

    private CValue Exp_Fmt_NDecimals(String param, int n)
    {
        n = Math.min(Math.max(0, n), 256);
        String format = "";
        String prefix = param.substring(0, param.indexOf("."));
        for (int i = 0; i < prefix.length() - ((param.indexOf("-") >= 0) ? 1 : 0); i++)
        {
            format += "#";
        }
        String decimalPlaces = "";
        for (int i = 0; i < n; i++)
        {
            decimalPlaces += "0";
        }
        if (!decimalPlaces.equals(""))
        {
            format += "." + decimalPlaces;
        }
        DecimalFormat fmtObj = new DecimalFormat(format);
        return new CValue(fmtObj.format(StringToDouble(param)));
    }
    
}
