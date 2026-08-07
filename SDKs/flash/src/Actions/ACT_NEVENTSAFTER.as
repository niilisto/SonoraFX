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
// -----------------------------------------------------------------------------
//
// N EVENTS AFTER
//
// -----------------------------------------------------------------------------
package Actions {
import Params.CParamExpression;
import Params.PARAM_TIME;
import RunLoop.CRun;
import RunLoop.TimerEvents;

public class ACT_NEVENTSAFTER extends CAct
{
    public override function execute(rhPtr:CRun):void {
        var timer:Number;
        if (evtParams[0].code==22)	    // PARAM_EXPRESSION
            timer=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
        else
            timer=(PARAM_TIME(evtParams[0])).timer;
        var loops:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
        var timerNext:Number;
        if (this.evtParams[2].code == 22)
            timerNext = rhPtr.get_EventExpressionInt(CParamExpression(this.evtParams[2]));
        else
            timerNext = (PARAM_TIME(evtParams[2])).timer;
        var pName:String=rhPtr.get_EventExpressionString(CParamExpression(evtParams[3]));

        var pLoop:TimerEvents=rhPtr.rh4TimerEvents;
        var pPrevious:TimerEvents=null;
        while(pLoop!=null)
        {
            pPrevious=pLoop;
            pLoop=pLoop.next;
        }
        var pEvent:TimerEvents=new TimerEvents();
        if (pPrevious==null)
            rhPtr.rh4TimerEvents=pEvent;
        else
            pPrevious.next=pEvent;
        pEvent.type=TimerEvents.TIMEREVENTTYPE_REPEAT;
        pEvent.timer=rhPtr.rhTimer+timer;
        pEvent.timerNext=timerNext;
        pEvent.timerPosition=0;
        pEvent.loops=loops;
        pEvent.index=0;
        pEvent.next=null;
        pEvent.name=pName;
    }
}
}