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
// GET X ACTION POINT
//
//----------------------------------------------------------------------------------
package Expressions {
import RunLoop.*;
import Objects.*;
import Banks.*;

public class EXP_EXTDISTANCE extends CExpOi
{
    public override function evaluate(rhPtr:CRun):void {
        var pHo:CObject=rhPtr.rhEvtProg.get_ExpressionObjects(oiList);
        rhPtr.rh4CurToken++;
        var x2:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var y2:int= rhPtr.getExpression().getInt();
        if (pHo==null)
        {
            rhPtr.getCurrentResult().forceInt(0);
            return;
        }
        var deltaX:int=x2-pHo.hoX;
        var deltaY:int=y2-pHo.hoY;
		rhPtr.getCurrentResult().forceInt(int((Math.floor(Math.sqrt(deltaX*deltaX+deltaY*deltaY)))));
    }
}
}