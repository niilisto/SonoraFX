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
// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   CRunFunctionEggtimer.java

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunFunctionEggtimer extends CRunExtension
{

    public CRunFunctionEggtimer()
    {
        lastFunctionName = "";
        functionList = new ArrayList<DelayedFunction>();
    }

    @Override
	public int getNumberOfConditions()
    {
        return 2;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return false;
    }

    @Override
	public void destroyRunObject(boolean flag)
    {
    }

    @Override
	public int handleRunObject()
    {
    	int fList_size = functionList.size();
    	for(int i = 0; i < fList_size; i++)
        {
            currentFunction = functionList.get(i);
            if(currentFunction == null)
                continue;
            if(currentFunction.deleteMe || currentFunction.immediateFunc && !currentFunction.immediateApproved)
            {
                functionList.remove(i);
                fList_size = functionList.size();
                i--;
                continue;
            }
            if(currentFunction.time <= 0L)
            {
                boolean deleteMe = true;
                lastFunctionName = currentFunction.name;
                if(currentFunction.repeat > 1L || currentFunction.repeat == -1L)
                {
                    currentFunction.time = currentFunction.initialTime;
                    currentFunction.repeat = Math.max(currentFunction.repeat - 1L, -1L);
                    deleteMe = false;
                }
                ho.generateEvent(0, 0);
                ho.generateEvent(1, 0);
                if(deleteMe && !currentFunction.waitForSuccellfull)
                {
                    functionList.remove(i);
                    fList_size = functionList.size();
                    i--;
                }
            } else
            {
                currentFunction.time--;
            }
        }

        return 0;
    }

    public boolean saveRunObject(DataOutputStream stream)
    {
        return true;
    }

    public boolean loadRunObject(DataInputStream stream)
    {
        return true;
    }

    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch(num)
        {
        case 0: // '\0'
            return conOnFunction(cnd);

        case 1: // '\001'
            return conAnyFunction(cnd);
        }
        return false;
    }

    @Override
	public void action(int num, CActExtension act)
    {
        switch(num)
        {
        case 0: // '\0'
            acDelayFunction(act);
            break;

        case 1: // '\001'
            actCancelFunction(act);
            break;

        case 2: // '\002'
            acSetRepeat(act);
            break;

        case 3: // '\003'
            acSetPrivateData(act);
            break;

        case 4: // '\004'
            acUseSuccessFlag(act);
            break;

        case 5: // '\005'
            acFunctionSuccessfull(act);
            break;

        case 6: // '\006'
            acImmediateFunction(act);
            break;

        case 7: // '\007'
            acStopAll(act);
            break;
        }
    }

    @Override
	public CValue expression(int num)
    {
        switch(num)
        {
        case 0: // '\0'
            return expGetFunctionsInQueue();

        case 1: // '\001'
            return extLastFunctionName();

        case 2: // '\002'
            return extPrivateData();

        case 3: // '\003'
            return extRemainingRepeats();
        }
        return null;
    }

    private boolean conOnFunction(CCndExtension cnd)
    {
        String param0 = cnd.getParamExpString(rh, 0);
        return lastFunctionName.equals(param0);
    }

    private boolean conAnyFunction(CCndExtension cnd)
    {
        return true;
    }

    private void acDelayFunction(CActExtension act)
    {
        String functionName = act.getParamExpString(rh, 0);
        int delay = act.getParamExpression(rh, 1);
        DelayedFunction newfunc = new DelayedFunction();
        newfunc.name = functionName;
        newfunc.initialTime = delay;
        newfunc.time = delay;
        newfunc.deleteMe = false;
        newfunc.privateData = 0L;
        newfunc.repeat = 0L;
        newfunc.waitForSuccellfull = false;
        newfunc.immediateFunc = false;
        newfunc.immediateApproved = false;
        functionList.add(newfunc);
    }

    private void actCancelFunction(CActExtension act)
    {
        String functionName = act.getParamExpString(rh, 0);
        int functionList_size = functionList.size();
    	for(int i = 0; i < functionList_size; i++)
            if(functionName.equals(functionList.get(i).name))
            {
                functionList.remove(i);
                i--;
            }

    }

    private void acSetRepeat(CActExtension act)
    {
        int repetitions = act.getParamExpression(rh, 0);
        if(functionList.size() == 0)
            return;
        DelayedFunction func = functionList.get(functionList.size() - 1);
        if(!func.immediateFunc)
            func.repeat = Math.max(repetitions, -1);
        else
        if(repetitions >= 0)
            func.repeat = Math.max(repetitions - 1, 0);
        else
            func.repeat = -1L;
        func.immediateApproved = true;
    }

    private void acSetPrivateData(CActExtension act)
    {
        int privatedata = act.getParamExpression(rh, 0);
        if(functionList.size() == 0)
        {
            return;
        } else
        {
            DelayedFunction func = functionList.get(functionList.size() - 1);
            func.privateData = privatedata;
            return;
        }
    }

    private void acUseSuccessFlag(CActExtension act)
    {
        if(functionList.size() == 0)
        {
            return;
        } else
        {
            DelayedFunction func = functionList.get(functionList.size() - 1);
            func.waitForSuccellfull = true;
            return;
        }
    }

    private void acFunctionSuccessfull(CActExtension act)
    {
        if(currentFunction != null)
            currentFunction.deleteMe = true;
    }

    private void acImmediateFunction(CActExtension act)
    {
        String functionName = act.getParamExpString(rh, 0);
        int delay = act.getParamExpression(rh, 1);
        DelayedFunction newfunc = new DelayedFunction();
        newfunc.name = functionName;
        newfunc.initialTime = delay;
        newfunc.time = delay;
        newfunc.deleteMe = false;
        newfunc.privateData = 0L;
        newfunc.repeat = 0L;
        newfunc.waitForSuccellfull = false;
        newfunc.immediateFunc = true;
        newfunc.immediateApproved = false;
        functionList.add(newfunc);
        lastFunctionName = functionName;
        ho.generateEvent(0, 0);
        ho.generateEvent(1, 0);
    }

    private void acStopAll(CActExtension act)
    {
        functionList.clear();
    }

    private CValue expGetFunctionsInQueue()
    {
        return new CValue(functionList.size());
    }

    private CValue extLastFunctionName()
    {
        return new CValue(lastFunctionName);
    }

    private CValue extPrivateData()
    {
        return new CValue(currentFunction.privateData);
    }

    private CValue extRemainingRepeats()
    {
        return new CValue(currentFunction.repeat);
    }

    public static final int CONONFUNCTION = 0;
    public static final int CONANYFUNCTION = 1;
    public static final int CND_LAST = 2;
    public static final int ACDELAYFUNCTION = 0;
    public static final int ACTCANCELFUNCTION = 1;
    public static final int ACSETREPEAT = 2;
    public static final int ACSETPRIVATEDATA = 3;
    public static final int ACUSESUCCESSFLAG = 4;
    public static final int ACFUNCTIONSUCCESSFULL = 5;
    public static final int ACIMMEDIATEFUNCTION = 6;
    public static final int ACSTOPALL = 7;
    public static final int EXPGETFUNCTIONSINQUEUE = 0;
    public static final int EXTLASTFUNCTIONNAME = 1;
    public static final int EXTPRIVATEDATA = 2;
    public static final int EXTREMAININGREPEATS = 3;
    String lastFunctionName;
    DelayedFunction currentFunction;
    ArrayList<DelayedFunction> functionList;
}
