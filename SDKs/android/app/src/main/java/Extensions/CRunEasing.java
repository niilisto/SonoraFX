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

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Events.CEvent;
import Expressions.CValue;
import Objects.CObject;
import Params.PARAM_OBJECT;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.ObjectSelection;


public class CRunEasing extends CRunExtension
{
    public final static short HOF_DESTROYED=0x0001;

	final int CND_ANYOBJECTSTOPPED 		= 0;
	final int CND_SPECIFICOBJECTSTOPPED	= 1;
	final int CND_ISOBJECTMOVING 		= 2;
	final int CND_LAST 					= 3;

	final int ACT_MOVEOBJ 				= 0;
	final int ACT_STOPOBJECT 			= 1;
	final int ACT_STOPALLOBJECTS 		= 2;
	final int ACT_REVERSEOBJECT 		= 3;
	final int ACT_SETAMPLITUDE			= 4;
	final int ACT_SETOVERSHOOT 			= 5;
	final int ACT_SETPERIOD 			= 6;
	final int ACT_SETOBJECTAMPLITUDE 	= 7;
	final int ACT_SETOBJECTOVERSHOOT 	= 8;
	final int ACT_SETOBJECTPERIOD 		= 9;

	final int EXP_GETNUMCONTROLLED 				= 0;
	final int EXP_GETSTOPPEDFIXED 				= 1;
	final int EXP_CALCULATE_EASEIN 				= 2;
	final int EXP_CALCULATE_EASEOUT 			= 3;
	final int EXP_CALCULATE_EASEINOUT 			= 4;
	final int EXP_CALCULATE_EASEOUTIN 			= 5;
	final int EXP_CALCULATEBETWEEN_EASEIN 		= 6;
	final int EXP_CALCULATEBETWEEN_EASEOUT 		= 7;
	final int EXP_CALCULATEBETWEEN_EASEINOUT 	= 8;
	final int EXP_CALCULATEBETWEEN_EASEOUTIN 	= 9;
	final int EXP_GETAMPLITUDE 					= 10;
	final int EXP_GETOVERSHOOT 					= 11;
	final int EXP_GETPERIOD 					= 12;
	final int EXP_GETDEFAULTAMPLITUDE 			= 13;
	final int EXP_GETDEFAULTOVERSHOOT 			= 14;
	final int EXP_GETDEFAULTPERIOD 				= 15;

	final int EASEIN 		= 0;
	final int EASEOUT 		= 1;
	final int EASEINOUT 	= 2;
	final int EASEOUTIN 	= 3;
	
	CValue expRet;
	
	//Custom action parameter struct
	class EasingParam
	{
		public char version;
		public char method;
		public char firstFunction;
		public char secondFunction;
	};

	class TimeModeParam
	{
		public char type;
	};

	//Easing parameter value struct
	class Easevarxs
	{
		public float overshoot;
		public float amplitude;
		public float period;
	};

	//Runtime structures:
	class MoveStruct
	{
		CObject mobject;
		int		startX;
		int		startY;
		int		destX;
		int		destY;
		
		Easevarxs vars;
		
		public char 	easingMode;
		public char 	functionA;
		public char 	functionB;
		
		public char 	timeMode;
		public Date		starttime;
		public long		timespan;
		public long		eventloop_step;
	};
	

	double linear(double step, 	Easevarxs varxs)		{ return step; }
	double quad(double step, 	Easevarxs varxs)		{ return Math.pow(step, 2.0); }
	double cubic(double step, 	Easevarxs varxs)		{ return Math.pow(step, 3.0); }
	double quart(double step, 	Easevarxs varxs)		{ return Math.pow(step, 4.0); }
	double quint(double step, 	Easevarxs varxs)		{ return Math.pow(step, 5.0); }
	double sine(double step, 	Easevarxs varxs)		{ return 1.0-Math.sin((1-step)*90.0 * Math.PI/180.0); }
	double expo(double step, 	Easevarxs varxs)		{ return Math.pow(2.0, step*10.0)/1024.0; }
	double circ(double step, 	Easevarxs varxs)		{ return 1.0f-Math.sqrt(1.0-Math.pow(step,2.0)); }
	double back(double step, 	Easevarxs varxs)		{ return (varxs.overshoot+1.0)* Math.pow(step, 3.0) - varxs.overshoot*Math.pow(step, 2.0); }

	private List<MoveStruct> controlled;
	private List<MoveStruct> deleted;

	private MoveStruct	currentMoved;
	private Easevarxs	easingvarxs;
	
	double elastic(double step, Easevarxs varxs)
	{
		step -= 1.0;
		double amp = Math.max(1.0f, varxs.amplitude);
		double s = varxs.period / (2.0 * Math.PI) * Math.asin(1.0 / amp);
		return -(amp*Math.pow(2.0f,10*step) * Math.sin((step-s)*(2.0*Math.PI)/varxs.period));
	}
	double bounce(double step, Easevarxs varxs)
	{
		step = 1-step;
		if (step < (8/22.0))
			return 1 - 7.5625*Math.pow(step,2.0);
		else if (step < (16/22.0))
			return 1 - varxs.amplitude * (7.5625*Math.pow(step-(12/22.0), 2.0) + 0.75);
		else if (step < (20/22.0))
			return 1 - varxs.amplitude * (7.5625*Math.pow(step-(18/22.0), 2.0) + 0.9375);
		else
			return 1 - varxs.amplitude * (7.5625*Math.pow(step-(21/22.0), 2.0) + 0.984375);
	}

	double doFunction(int number, double step, Easevarxs varxs)
	{
		switch(number)
		{
			default:
			case 0: return linear(step, varxs);
			case 1: return quad(step, varxs);
			case 2: return cubic(step, varxs);
			case 3: return quart(step, varxs);
			case 4: return quint(step, varxs);
			case 5: return sine(step, varxs);
			case 6: return expo(step, varxs);
			case 7: return circ(step, varxs);
			case 8: return back(step, varxs);
			case 9: return elastic(step, varxs);
			case 10: return bounce(step, varxs);
		}
	}

	double easeIn(int function, double step, Easevarxs varxs)
	{
		return doFunction(function, step, varxs);
	}

	double easeOut(int function, double step, Easevarxs varxs)
	{
		return 1.0-doFunction(function, 1.0-step, varxs);
	}

	double easeInOut(int functionA, int functionB, double step, Easevarxs varxs)
	{
		if(step < 0.5)
			return easeIn(functionA, step*2.0, varxs)/2.0;
		else
			return easeOut(functionB, (step-0.5)*2.0, varxs)/2.0 + 0.5;
	}

	double easeOutIn(int functionA, int functionB, double step, Easevarxs varxs)
	{
		if(step < 0.5)
			return easeOut(functionA, step*2.0, varxs)/2.0;
		else
			return easeIn(functionB, (step-0.5)*2.0, varxs)/2.0 + 0.5;
	}

	double calculateEasingValue(int mode, int functionA, int functionB, double step, Easevarxs varxs)
	{
		switch(mode)
		{
			default:
			case EASEIN:		return easeIn(functionA,step,varxs);
			case EASEOUT:		return easeOut(functionA,step,varxs);
			case EASEINOUT:		return easeInOut(functionA,functionB,step,varxs);
			case EASEOUTIN:		return easeOutIn(functionA,functionB,step,varxs);
		}
	}
	
	
    public CRunEasing()
    {
		controlled 		= new ArrayList <MoveStruct>();
		deleted 		= new ArrayList <MoveStruct>();
		currentMoved 	= new MoveStruct();
		easingvarxs 	= new Easevarxs();
		expRet          = new CValue(0);
    }

    @Override
	public int getNumberOfConditions()
    {
        return CND_LAST;
    }

    public float readFloat(CBinaryFile file) {
        int bits = 0;
        for (int idx = 0; idx <= 3; idx++) {
        	bits |= (file.readByte() & 0xff) << (idx * 8);
        }
        return Float.intBitsToFloat(bits);
    }  
   
    
 	@Override
	public boolean createRunObject (final CBinaryFile file, final CCreateObjectInfo cob, final int version)
	{
				
		float overshootI = this.readFloat(file);
		float amplitudeI = this.readFloat(file);
		float periodI 	 = this.readFloat(file);
		
		easingvarxs.overshoot = overshootI;
		easingvarxs.amplitude = amplitudeI;
		easingvarxs.period = periodI;

		controlled.clear();
		deleted.clear();
		return true;
	}

    @Override
	public void destroyRunObject(boolean bFast)
	{
		controlled.clear();
		deleted.clear();
	}

	@Override
	public int handleRunObject()
	{
		boolean finnishedMoving = false;
		double step;
		//int i;
		//int controlled_size = controlled.size();
		//for(i = 0; i< controlled_size; i++) 
		Iterator<MoveStruct> iterator = controlled.iterator();
		while(iterator.hasNext())
		{
			//final MoveStruct moved = controlled.get(i);
			final MoveStruct moved = iterator.next();
			if(moved == null)
				continue;
			
			CObject object = moved.mobject;		
			
			if ( (object.hoFlags & HOF_DESTROYED) == 0 )
			{
				if(moved.timeMode == 0)
				{
					double seconds = moved.timespan;
					Date currentTime = new Date();
					long diff = currentTime.getTime() - moved.starttime.getTime();
					
	 				step = diff / seconds;
					
					if(diff >= seconds)
						finnishedMoving = true;
				}
				else
				{
					moved.eventloop_step++;
					step = moved.eventloop_step / (double)moved.timespan;
					
					if(moved.eventloop_step >= moved.timespan)
						finnishedMoving = true;
				}
				
				double easeStep = calculateEasingValue(moved.easingMode, moved.functionA, moved.functionB, step, moved.vars);
				
				object.hoX = (int)(moved.startX + (moved.destX-moved.startX)*easeStep + 0.5f);
				object.hoY = (int)(moved.startY + (moved.destY-moved.startY)*easeStep + 0.5f);
				
				//Log.Log("X: "+object.hoX+" "+"Y: "+object.hoY+" "+"EsaseStep: "+easeStep+" using functionA as "+
		        //        Integer.toString(moved.functionA, 10)+" finished moving: "+ (finnishedMoving == true ? "true" : "false"));
				
				object.roc.rcChanged = true;
							
								
				if(finnishedMoving)
				{
					finnishedMoving = false;
					
					object.hoX = moved.destX;
					object.hoY = moved.destY;
					
					deleted.add(moved);
					iterator.remove();
					//controlled.remove(i);
					//controlled_size = controlled.size();
					//i--;
				}
			}
			else
			{
				if(moved.starttime != null)
					moved.starttime=null;

				iterator.remove();
				//controlled.remove(i);
				//controlled_size = controlled.size();
				//i--;
			}
			
		}
		
		//Trigger the 'Object stopped moving' events
		Iterator<MoveStruct> iteratorDeleted = deleted.iterator();
	    while(iteratorDeleted.hasNext())
		{
	    	currentMoved = iteratorDeleted.next();
			ho.generateEvent(CND_SPECIFICOBJECTSTOPPED, 0);
			ho.generateEvent(CND_ANYOBJECTSTOPPED, 0);
			if(currentMoved.starttime != null)
				currentMoved.starttime=null;
			
			iteratorDeleted.remove();
		}

		return 0;
	}

	//Should it select the given object?
    final ObjectSelection.Filter filterMoving = new ObjectSelection.Filter()
    {
        @Override
        public boolean filter (Object rdPtr, CObject object)
        {
    		CRunEasing easing = ((CRunEasing)rdPtr);
        	/*
			//Log.Log("object list "+object);
    		int easing_cont_size = easing.controlled.size();
    		for( int i=0; i< easing_cont_size; ++i)
    		{
    			MoveStruct moved = easing.controlled.get(i);
    			//Log.Log("checking filtering "+moved.mobject + " "+ object);
    			if(moved.mobject == object)
    				return true;
    		}
        	*/
        	for(MoveStruct moved : easing.controlled) {
    			if(moved != null && moved.mobject == object)
    				return true;        		
        	}
    		return false;
        }
    };	
	

	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
			case CND_ANYOBJECTSTOPPED:
				return true;
			case CND_SPECIFICOBJECTSTOPPED:
			{
				PARAM_OBJECT param = cnd.getParamObject (rh, 0);
                short oi = param.oiList;	
                
				CObject object = currentMoved.mobject;
				ObjectSelection select = new ObjectSelection (rh.rhApp);
				
				if(object != null && select.objectIsOfType(object,oi))
				{
					select.selectOneObject(object);
					select = null;
					return true;
				}
				select = null;
				return false;
			}
			case CND_ISOBJECTMOVING:
			{
				ObjectSelection select = new ObjectSelection (rh.rhApp);
                PARAM_OBJECT param = cnd.getParamObject (rh, 0);

                short oiToCheck = param.oiList;				
				
				boolean ret = select.filterObjects(this, oiToCheck, (cnd.evtFlags2 & CEvent.EVFLAG2_NOT) != 0, filterMoving);

				return ret;
			}
		}
		return false;
	}



	@Override
	public void action(int num, CActExtension act)
	{
		switch (num)
		{
			case ACT_MOVEOBJ:
				moveObject(act.getParamObject(rh, 0), act.getParamExtension(rh, 1), act.getParamExpression(rh, 2), 
						act.getParamExpression(rh, 3), act.getParamExtension(rh, 4), act.getParamExpression(rh, 5));
				break;
			case ACT_STOPOBJECT:
				stopObject(act.getParamObject(rh, 0));
				break;
			case ACT_STOPALLOBJECTS:
			{
				/*
				int controlled_size = controlled.size();
				for(int i=0; i<controlled_size; ++i)
				{
					MoveStruct item = controlled.get(i);
					if(item.starttime != null)
						item.starttime=null;
				}
				*/
				for(MoveStruct item : controlled) {
					if(item != null && item.starttime != null)
						item.starttime=null;					
				}
				controlled.clear();
				break;
			}
			case ACT_REVERSEOBJECT:
				reverseObject(act.getParamObject(rh, 0));
				break;
			case ACT_SETAMPLITUDE:
				easingvarxs.amplitude = act.getParamExpFloat(rh, 0);
				break;
			case ACT_SETOVERSHOOT:
				easingvarxs.overshoot = act.getParamExpFloat(rh, 0);
				break;
			case ACT_SETPERIOD:
				easingvarxs.period = act.getParamExpFloat(rh, 0);
				break;
			case ACT_SETOBJECTAMPLITUDE:
				setObjectAmplitude(act.getParamObject(rh, 0), act.getParamExpDouble(rh, 1));
				break;
			case ACT_SETOBJECTOVERSHOOT:
				setObjectOvershoot(act.getParamObject(rh, 0), act.getParamExpDouble(rh, 1));
				break;
			case ACT_SETOBJECTPERIOD:
				setObjectPeriod(act.getParamObject(rh, 0), act.getParamExpDouble(rh, 1));
				break;
		}
	}

	@Override
	public CValue expression(int num)
	{
		//int controlled_size = controlled.size();
		switch(num)
		{
			case EXP_GETNUMCONTROLLED:
				expRet.forceInt(controlled.size());
				return expRet;
			case EXP_GETSTOPPEDFIXED:
				expRet.forceInt(currentMoved.mobject.fixedValue());
				return expRet;
			case EXP_CALCULATE_EASEIN:
			{
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				expRet.forceDouble(calculateEasingValue(EASEIN, function, 0, step, easingvarxs));
				return expRet;
			}
			case EXP_CALCULATE_EASEOUT:
			{
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				expRet.forceDouble(calculateEasingValue(EASEOUT, function, 0, step, easingvarxs));
				return expRet;
			}
			case EXP_CALCULATE_EASEINOUT:
			{
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				expRet.forceDouble(calculateEasingValue(EASEINOUT, function, 0, step, easingvarxs));
				return expRet;
			}
			case EXP_CALCULATE_EASEOUTIN:
			{
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				expRet.forceDouble(calculateEasingValue(EASEOUTIN, function, 0, step, easingvarxs));
				return expRet;
			}
			case EXP_CALCULATEBETWEEN_EASEIN:
			{
				double valueA = ho.getExpParam().getDouble();
				double valueB = ho.getExpParam().getDouble();
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				double ease = calculateEasingValue(EASEIN, function, 0, step, easingvarxs);
				expRet.forceDouble(valueA + (valueB-valueA)*ease);
				return expRet;
			}
			case EXP_CALCULATEBETWEEN_EASEOUT:
			{
				double valueA = ho.getExpParam().getDouble();
				double valueB = ho.getExpParam().getDouble();
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				double ease = calculateEasingValue(EASEOUT, function, 0, step, easingvarxs);
				expRet.forceDouble(valueA + (valueB-valueA)*ease);
				return expRet;
			}
			case EXP_CALCULATEBETWEEN_EASEINOUT:
			{
				double valueA = ho.getExpParam().getDouble();
				double valueB = ho.getExpParam().getDouble();
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				double ease = calculateEasingValue(EASEINOUT, function, 0, step, easingvarxs);
				expRet.forceDouble(valueA + (valueB-valueA)*ease);
				return expRet;
			}
			case EXP_CALCULATEBETWEEN_EASEOUTIN:
			{
				double valueA = ho.getExpParam().getDouble();
				double valueB = ho.getExpParam().getDouble();
				int function = ho.getExpParam().getInt();
				double step = ho.getExpParam().getDouble();
				double ease = calculateEasingValue(EASEOUTIN, function, 0, step, easingvarxs);
				expRet.forceDouble(valueA + (valueB-valueA)*ease);
				return expRet;
			}
			case EXP_GETAMPLITUDE:
			{
				int fixed = ho.getExpParam().getInt();
				/*
				int controlled_size = controlled.size();
				for(int i=0; i<controlled_size; ++i)
				{
					MoveStruct moved = controlled.get(i);
					if(moved.mobject.fixedValue() == fixed)
						return new CValue(moved.vars.amplitude);
				}
				*/
				expRet.forceDouble(0);
				for(MoveStruct moved : controlled) {
					if(moved.mobject.fixedValue() == fixed) {
						expRet.forceDouble(moved.vars.amplitude);
						break;
					}
				}
				return expRet;
			}
			case EXP_GETOVERSHOOT:
			{
				int fixed = ho.getExpParam().getInt();
				/*
				int controlled_size = controlled.size();
				for(int i=0; i<controlled_size; ++i)
				{
					MoveStruct moved = controlled.get(i);
					if(moved.mobject.fixedValue() == fixed)
						return new CValue(moved.vars.overshoot);
				}
				*/
				expRet.forceDouble(0);
				for(MoveStruct moved : controlled) {
					if(moved.mobject.fixedValue() == fixed) {
						expRet.forceDouble(moved.vars.overshoot);
						break;
					}
				}
				return expRet;
			}
			case EXP_GETPERIOD:
			{
				int fixed = ho.getExpParam().getInt();
				/*
				int controlled_size = controlled.size();
				for(int i=0; i<controlled_size; ++i)
				{
					MoveStruct moved = controlled.get(i);
					if(moved.mobject.fixedValue() == fixed)
						return new CValue(moved.vars.period);
				}
				*/
				expRet.forceDouble(0);
				for(MoveStruct moved : controlled) {
					if(moved.mobject.fixedValue() == fixed) {
						expRet.forceDouble(moved.vars.period);
						break;
					}
				}
				return expRet;
			}
			case EXP_GETDEFAULTAMPLITUDE:
				expRet.forceDouble(easingvarxs.amplitude);
				return expRet;
			case EXP_GETDEFAULTOVERSHOOT:
				expRet.forceDouble(easingvarxs.overshoot);
				return expRet;
			case EXP_GETDEFAULTPERIOD:
				expRet.forceDouble(easingvarxs.period);
				return expRet;
		}
		return new CValue(0);
	}


	public void moveObject(CObject object,  CBinaryFile easeParam , int x,  int y,  CBinaryFile timeParam, int timespan)
	{
		EasingParam easing = new EasingParam();
		TimeModeParam time = new TimeModeParam();

		easing.version = (char)easeParam.readByte();
		easing.method = (char)easeParam.readByte();
		easing.firstFunction = (char)easeParam.readByte();
		easing.secondFunction = (char)easeParam.readByte();
		
		time.type = (char)timeParam.readByte();
		
		if(object == null)
			return;
		
		//Remove object if it exists
		int fixed = object.fixedValue();
		//int controlled_size = controlled.size();
		//for(int i = 0; i < controlled_size; ++i)
		for(MoveStruct moved : controlled)
		{
			//MoveStruct moved = controlled.get(i);
			if(moved.mobject.fixedValue() == fixed)
			{
				if(moved.starttime != null)
					moved.starttime = null;
				controlled.remove(moved);
				//controlled.remove(i);
				//controlled_size = controlled.size();
				break;
			}
		}
		MoveStruct move = new MoveStruct();
		move.startX = object.hoX;
		move.startY = object.hoY;
		move.mobject = object;
		move.destX = x;
		move.destY = y;
		move.starttime = null;
		
		move.easingMode = easing.method;
		move.functionA = easing.firstFunction;
		move.functionB = easing.secondFunction;
		
		move.timeMode = time.type;
		move.timespan = timespan;
		move.eventloop_step = 0;
		
		if(move.timeMode == 0)
		{
			move.starttime = new Date();
		}
		
		move.vars = easingvarxs;
		controlled.add(move);
		
	}

	public void stopObject(CObject object)
	{
		//int controlled_size = controlled.size();
		//for(int i = 0; i < controlled_size; i++)
		for(MoveStruct moved : controlled)
		{
			//MoveStruct moved = controlled.get(i);
			
			if(moved != null && moved.mobject == object)
			{
				if(moved.starttime != null)
					moved.starttime = null;
				
				controlled.remove(moved);
				//controlled.remove(i);
				//controlled_size = controlled.size();
				return;
			}
		}

	}

	public void reverseObject(CObject object)
	{
		MoveStruct reversed = new MoveStruct();
		
		//Otherwise remove the object and reinsert it with new coordinates.
		//int controlled_size = controlled.size();
		//for(int i = 0; i < controlled_size; i++)
		for(MoveStruct moved : controlled)
		{
			//MoveStruct moved = controlled.get(i);
			if(moved.mobject == object)
			{
				reversed=moved;
				controlled.remove(moved);
				//controlled.remove(i);
				//controlled_size = controlled.size();
				break;
			}
		}
		
		//If it was the object that was just stopped then use that one.
		if(reversed.mobject == null)
		{
			if(currentMoved.mobject == object)
			{
				// Build 284.11: copy structure content instead of object reference!
				reversed.mobject = currentMoved.mobject;
				reversed.startX = currentMoved.startX;
				reversed.startY = currentMoved.startY;
				//reversed.destX = currentMoved.destX;
				//reversed.destY = currentMoved.destY;
				reversed.vars = easingvarxs;
				reversed.vars.overshoot = currentMoved.vars.overshoot;
				reversed.vars.amplitude = currentMoved.vars.amplitude;
				reversed.vars.period = currentMoved.vars.period;
				reversed.easingMode = currentMoved.easingMode;
				reversed.functionA = currentMoved.functionA;
				reversed.functionB = currentMoved.functionB;
				reversed.timeMode = currentMoved.timeMode;
				reversed.starttime = currentMoved.starttime;
				reversed.timespan = currentMoved.timespan;
				reversed.eventloop_step = currentMoved.eventloop_step;
			}
			else	//If NO object found, abort
				return;
		}
		
		reversed.destX = reversed.startX;
		reversed.destY = reversed.startY;
		
		reversed.startX = object.hoX;
		reversed.startY = object.hoY;
		
		//Recalculate the time it should take moving to the previous position
		if(reversed.timeMode == 0)
		{
			Date currentTime =  new Date();
			long timeSoFar = currentTime.getTime() - reversed.starttime.getTime();
			
			//reversed.timespan = (int)(timeSoFar*1000);
			reversed.timespan = (int)(timeSoFar);
			reversed.starttime = currentTime;
		}
		else
		{
			reversed.timespan = reversed.eventloop_step;
			reversed.eventloop_step = 0;
		}
		
		controlled.add(reversed);
	}

	public void setObjectAmplitude(CObject object, double amplitude)
	{
		/*
		int controlled_size = controlled.size();
		for(int i = 0; i < controlled_size; i++)
		{
			MoveStruct moved = controlled.get(i);
			if(moved.mobject == object)
			{
				moved.vars.amplitude = (float)amplitude;
				return;
			}
		}
		*/
		for(MoveStruct moved : controlled) {
			if(moved.mobject == object)
			{
				moved.vars.amplitude = (float)amplitude;
				return;
			}			
		}
	}

	public void setObjectOvershoot(CObject object, double overshoot)
	{
		/*
		int controlled_size = controlled.size();
		for(int i = 0; i < controlled_size; i++)
		{
			MoveStruct moved = controlled.get(i);
			if(moved.mobject == object)
			{
				moved.vars.overshoot = (float)overshoot;
				return;
			}
		}
		*/
		for(MoveStruct moved : controlled) {
			if(moved.mobject == object)
			{
				moved.vars.overshoot = (float)overshoot;
				return;
			}
		}
	}

	public void setObjectPeriod(CObject object, double period)
	{
		/*
		int controlled_size = controlled.size();
		for(int i = 0; i < controlled_size; i++)
		{
			MoveStruct moved = controlled.get(i);
			if(moved.mobject == object)
			{
				moved.vars.period = (float)period;
				return;
			}
		}
		*/
		for(MoveStruct moved : controlled) {
			if(moved.mobject == object)
			{
				moved.vars.period = (float)period;
				return;
			}
		}
	}

}
