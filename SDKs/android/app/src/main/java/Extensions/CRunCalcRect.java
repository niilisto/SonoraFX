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
// CRUNSTATICTEXT: extension object
//
//----------------------------------------------------------------------------------

package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CServices;
import android.graphics.Rect;
import android.text.DynamicLayout;
import android.text.TextPaint;

public class CRunCalcRect extends CRunExtension
{
    public static final int MAX_HEIGHTS = 40;
    int heightNormalToLF[] =
    {
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
    };
    public static final int ACT_SetFont = 0;
    public static final int ACT_SetText = 1;
    public static final int ACT_SetMaxWidth = 2;
    public static final int ACT_CalcRect = 3;
    public static final int EXP_GetWidth = 0;
    public static final int EXP_GetHeight = 1;
    String text = "";
    String fontName = "";
    int fontHeight = 10;
    boolean fontBold = false;
    boolean fontItalic = false;
    boolean fontUnderline = false;
    int maxWidth = Integer.MAX_VALUE;
    int calcWidth = 0;
    int calcHeight = 0;

    private CValue expRet;
    
    public CRunCalcRect()
    {
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

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case EXP_GetWidth:
                return GetWidth();

            case EXP_GetHeight:
                return GetHeight();

            default:
                return null;
        }
    }

    TextPaint textPaint;

    private void CalcRect()
    {
        CFontInfo fontInfo = new CFontInfo();
        fontInfo.lfFaceName = this.fontName;
        fontInfo.lfHeight = this.fontHeight;
        fontInfo.lfItalic = (byte) (this.fontItalic ? 1 : 0);
        fontInfo.lfUnderline = (byte) (this.fontUnderline ? 1 : 0);

        if (textPaint == null)
            textPaint = new TextPaint();

        textPaint.setTypeface(fontInfo.createFont());
        textPaint.setTextSize(fontInfo.lfHeight);
        textPaint.setAntiAlias(true);
        
        if(this.fontUnderline)
        	textPaint.setUnderlineText(true);

        if (this.maxWidth != Integer.MAX_VALUE)
        {
        	/*
            StaticLayout layout = new StaticLayout
                    (this.text, textPaint, this.maxWidth,
                            CServices.textAlignment(0), 1.0f, 0.0f, false);
                            */
            DynamicLayout layout = new DynamicLayout
                    (this.text, textPaint, this.maxWidth,
                            CServices.textAlignment(0, CServices.containsRtlChars(this.text)), 1.0f, 0.0f, false);

            this.calcWidth = layout.getWidth();
            this.calcHeight = layout.getHeight();
        }
        else
        {
            Rect rc = new Rect();
            textPaint.getTextBounds (this.text, 0, this.text.length(), rc);

            this.calcWidth = rc.right - rc.left;
            this.calcHeight = rc.bottom - rc.top;
        }

    }

    private CValue GetHeight()
    {
    	expRet.forceInt(this.calcHeight);
        return expRet;
    }

    private CValue GetWidth()
    {
    	expRet.forceInt(this.calcWidth);
        return expRet;
    }

    private void SetFont(String name, int height, int style)
    {
        this.fontName = name;
        this.fontHeight = heightNormalToLF(height);
        this.fontBold = (style & 1) == 1;
        this.fontItalic = (style & 2) == 2;
        this.fontUnderline = (style & 4) == 4;
    }

    private void SetMaxWidth(int width)
    {
        if (width <= 0)
        {
            this.maxWidth = Integer.MAX_VALUE;
        }
        else
        {
            this.maxWidth = width;
        }
    }

    private void SetText(String text)
    {
        this.text = text;
    }

    int heightNormalToLF(int height)
    {
        if (height < MAX_HEIGHTS)
        {
            return heightNormalToLF[height];
        }
        int nLogVert = 96;
        return (height * nLogVert) / 72;
    }
}
