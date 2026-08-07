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
import Actions.CActExtension;

public class MTRandomActs
{
    static final int AID_aSeedClock	=	0;
    static final int AID_aSeedOne	=	1;
    static final int AID_aSeedTwo	=	2;
    static final int AID_aSeedThree =	3;
    static final int AID_aSeedFour =	4;
    static final int AID_aSeedSix =	5;
    static final int AID_aSeedEight =	6;
    static final int AID_aSeedTen =	7;
    static final int AID_aExpire =	8;
    static final int AID_aExpireX =	9;
    
    CRunMTRandom thisObject;

    public MTRandomActs(CRunMTRandom object) {
        thisObject = object;
    }
    
    public void action(int num, CActExtension act)
    {   
        switch (num)
        {        
            case AID_aSeedClock:
                thisObject.rand.setSeed(System.currentTimeMillis());
                break;        
            case AID_aSeedOne:
                thisObject.rand.setSeed(act.getParamExpression(thisObject.rh, 0));
                break;
            case AID_aSeedTwo:
                int randvals2[] = new int[2];
                for (int i = 0; i < randvals2.length; i++){
                    randvals2[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals2);
                break;
            case AID_aSeedThree:
                int randvals3[] = new int[3];
                for (int i = 0; i < randvals3.length; i++){
                    randvals3[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals3);
                break;
            case AID_aSeedFour:
                int randvals4[] = new int[4];
                for (int i = 0; i < randvals4.length; i++){
                    randvals4[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals4);
                break;
            case AID_aSeedSix:
                int randvals6[] = new int[6];
                for (int i = 0; i < randvals6.length; i++){
                    randvals6[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals6);
                break;
            case AID_aSeedEight:
                int randvals8[] = new int[8];
                for (int i = 0; i < randvals8.length; i++){
                    randvals8[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals8);
                break;
            case AID_aSeedTen:
                int randvals10[] = new int[10];
                for (int i = 0; i < randvals10.length; i++){
                    randvals10[i] = act.getParamExpression(thisObject.rh, i);
                }
                thisObject.rand.setSeed(randvals10);
                break;
            case AID_aExpire:
                thisObject.rand.nextDouble();
                break;
            case AID_aExpireX:
                int x = act.getParamExpression(thisObject.rh, 0);
                for (int i=0; i<x; i++)
                    thisObject.rand.nextDouble();
                break;
        }
    }
    
    
}
