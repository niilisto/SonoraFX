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
/**
 * by Greyhill
 * @author Admin
 */

package Extensions;

import Expressions.CValue;
public class kchiscExpr 
{
    static final int EXP_VALUE = 0;
    static final int EXP_NAME = 1;
    static final int EXP_GETXPOSITION = 2;
    static final int EXP_GETYPOSITION = 3;
    CRunkchisc thisObject;
    public kchiscExpr(CRunkchisc object) {
        thisObject = object;
    }    
    public CValue get(int num)
    {
        switch (num)
        {
            case EXP_VALUE:               
                return GetValue(thisObject.ho.getExpParam().getInt());
            case EXP_NAME:
                return GetName(thisObject.ho.getExpParam().getInt());
            case EXP_GETXPOSITION:
                return GetXPosition();
            case EXP_GETYPOSITION:
                return GetYPosition();            
        }
        return new CValue(0);//won't happen
    }
    
    private CValue GetValue(int i) //1 based
    {
        if ((i > 0) && (i <= thisObject.NbScores))
        {
            return new CValue(thisObject.Scores[i - 1]);
        }
        return new CValue(0);
    }
    private CValue GetName(int i) //1 based
    {
        if ((i > 0) && (i <= thisObject.NbScores))
        {
            return new CValue(thisObject.Names[i - 1]);
        }
        return new CValue("");
    }
    private CValue GetXPosition()
    {
        return new CValue(thisObject.ho.hoX);
    }
    private CValue GetYPosition()
    {
        return new CValue(thisObject.ho.hoY);
    }
       

}
