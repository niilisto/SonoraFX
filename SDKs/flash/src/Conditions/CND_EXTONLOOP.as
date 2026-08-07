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
// ------------------------------------------------------------------------------
// 
// OBJECT ONLOOP
// 
// ------------------------------------------------------------------------------
package Conditions {
import Events.CForEach;
import Objects.CObject;
import Params.CParamExpression;
import RunLoop.CRun;
import Services.CServices;

public class CND_EXTONLOOP extends CCnd
{
    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean {
        var pName:String= rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
        if (rhPtr.rh4CurrentForEach != null)
        {
            if (CServices.compareStringsIgnoreCase(pName, rhPtr.rh4CurrentForEach.name))
            {
                rhPtr.rhEvtProg.evt_ForceOneObject(this.evtOiList, hoPtr);
                return true;
            }
        }
        if (rhPtr.rh4CurrentForEach2 != null)
        {
            if (CServices.compareStringsIgnoreCase(pName, rhPtr.rh4CurrentForEach2.name))
            {
                rhPtr.rhEvtProg.evt_ForceOneObject(this.evtOiList, hoPtr);
                return true;
            }
        }
        return false;
    }
    public override function eva2(rhPtr:CRun):Boolean {
        var pName:String= rhPtr.get_EventExpressionString(CParamExpression(evtParams[0]));
        var pForEach:CForEach=rhPtr.rh4CurrentForEach;
        var pHo2:CObject= null;
        if (pForEach!=null)
        {
            if (CServices.compareStringsIgnoreCase(pForEach.name, pName))
            {
                if (pForEach.oi==this.evtOiList)
                {
                    pHo2=pForEach.objects[pForEach.index%pForEach.number];
                }
            }
        }
        pForEach = rhPtr.rh4CurrentForEach2;
        if (pForEach!=null)
        {
            if (CServices.compareStringsIgnoreCase(pForEach.name, pName))
            {
                if (pForEach.oi==this.evtOiList)
                {
                    pHo2=pForEach.objects[pForEach.index%pForEach.number];
                }
            }
        }
        if (pHo2!=null)
        {
            rhPtr.rhEvtProg.evt_ForceOneObject(this.evtOiList, pHo2);
            return true;
        }
        return false;
    }
}
}