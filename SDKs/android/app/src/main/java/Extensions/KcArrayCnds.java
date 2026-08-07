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
/*
 * AVI OBJECT
 * 
 */

/**
 * by Greyhill
 * @author Admin
 */

package Extensions;

import Conditions.CCndExtension;

public class KcArrayCnds 
{
    static final int CND_INDEXAEND = 0;
    static final int CND_INDEXBEND = 1;
    static final int CND_INDEXCEND = 2;
    
    public static boolean get(int num, CCndExtension cnd, CRunKcArray thisObject)
    {
        switch (num)
        {
            case CND_INDEXAEND:
                return EndIndexA(thisObject);
            case CND_INDEXBEND:
                return EndIndexB(thisObject);
            case CND_INDEXCEND:
                return EndIndexC(thisObject);
        }        
        return false;
    }
    
    private static boolean EndIndexA(CRunKcArray thisObject)
    {
        if (thisObject.pArray.lIndexA >= thisObject.pArray.lDimensionX - 1)
        {
            return true;
        }
        return false;
    }
   
    private static boolean EndIndexB(CRunKcArray thisObject)
    {
        if (thisObject.pArray.lIndexB >= thisObject.pArray.lDimensionY - 1)
        {
            return true;
        }
        return false;
    }        
    private static boolean EndIndexC(CRunKcArray thisObject)
    {        
        if (thisObject.pArray.lIndexC >= thisObject.pArray.lDimensionZ - 1)
        {
            return true;
        }
        return false;
    }   
 
}
