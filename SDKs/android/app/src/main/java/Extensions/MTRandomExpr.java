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
/**
 * by Greyhill
 * @author Admin
 */

import Expressions.CValue;

public class MTRandomExpr
{
    static final int EID_eRandDbl1			=		0;
    static final int EID_eRandDbl1Ex		=	1;
    static final int EID_eRandDbl		=		2;
    static final int EID_eRandDblEx		=	3;
    static final int EID_eRandInt	=		4;
    static final int EID_eRandIntEx		=		5;
    
    CRunMTRandom thisObject;

    public MTRandomExpr(CRunMTRandom object){
        thisObject = object;
    }
    public CValue get(int num)
    {
        switch (num){
            case EID_eRandDbl1:
                return new CValue(thisObject.rand.nextDouble());
            case EID_eRandDbl1Ex:
                return new CValue(thisObject.rand.nextDoubleEx());
            case EID_eRandDbl:
                double p1 = thisObject.ho.getExpParam().getDouble();
                double p2 = thisObject.ho.getExpParam().getDouble();
                return new CValue(thisObject.rand.nextDouble(p1, p2));
            case EID_eRandDblEx:
                double p1ex = thisObject.ho.getExpParam().getDouble();
                double p2ex = thisObject.ho.getExpParam().getDouble();
                return new CValue(thisObject.rand.nextDoubleEx(p1ex, p2ex));
            case EID_eRandInt:
                int p1int = thisObject.ho.getExpParam().getInt();
                int p2int = thisObject.ho.getExpParam().getInt() + 1;
                return new CValue(thisObject.rand.nextIntEx(p2int - p1int) + p1int);
            case EID_eRandIntEx:
                int p1intex = thisObject.ho.getExpParam().getInt();
                int p2intex = thisObject.ho.getExpParam().getInt();
                return new CValue(thisObject.rand.nextIntEx(p2intex - p1intex) + p1intex);
        }
        return new CValue(0);//won't be used
    }

}

