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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Events.CEvent;
import Expressions.CValue;
import Objects.CObject;
import Params.PARAM_OBJECT;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.ObjectSelection;

public class CRunForEach extends CRunExtension
{
    final int CON_ONFOREACHLOOPSTRING = 0;
    final int CON_FOREACHLOOPISPAUSED = 1;
    final int CON_OBJECTISPARTOFLOOP = 2;
    final int CON_OBJECTISPARTOFGROUP = 3;
    final int CON_ONFOREACHLOOPOBJECT = 4;
    final int CON_LAST = 5;

    final int ACT_STARTFOREACHLOOPFOROBJECT = 0;
    final int ACT_PAUSEFOREACHLOOP = 1;
    final int ACT_RESUMEFOREACHLOOP = 2;
    final int ACT_SETFOREACHLOOPITERATION = 3;
    final int ACT_STARTFOREACHLOOPFORGROUP = 4;
    final int ACT_ADDOBJECTTOGROUP = 5;
    final int ACT_ADDFIXEDTOGROUP = 6;
    final int ACT_REMOVEOBJECTFROMGROUP = 7;
    final int ACT_REMOVEFIXEDFROMGROUP = 8;

    final int EXP_LOOPFV = 0;
    final int EXP_LOOPITERATION = 1;
    final int EXP_LOOPMAXITERATION = 2;
    final int EXP_GROUPSIZE = 3;

    class ForEachLoop
    {
        String name;
        List<Integer> fvs;
        int loopIndex = 0;
        int loopMax = 0;
        boolean paused = false;

        public ForEachLoop ()
        {
            fvs = new ArrayList <Integer> ();
        }

        public void addObject (CObject object)
        {
            fvs.add (object.fixedValue ());
        }

        public void addFixed (int fixed)
        {
            fvs.add (fixed);
        }
    }

    Map <String, ForEachLoop> forEachLoops; // Name => ForEachLoop lookup
    Map <String, ForEachLoop> pausedLoops; // Name => Paused ForEachLoop lookup
    Map <String, List <Integer>> groups;// Groupname => CArrayList of objects
    ForEachLoop currentForEach;
    String currentGroup;
    ObjectSelection selection = null;
    CObject currentLooped;

    //Variables for the ObjectSelection framework to access
    ForEachLoop populateLoop; //To fill with all currently selected objects
    ForEachLoop partOfLoop; //To access the loop in question
    List <Integer> partOfGroup; //To access the group in question
    int oiToCheck;


    @Override
	public int getNumberOfConditions ()
    {
        return CON_LAST;
    }

    @Override
    public boolean createRunObject
        (final CBinaryFile file, final CCreateObjectInfo cob, final int version)
    {
        currentGroup = null;

        forEachLoops = new HashMap <String, ForEachLoop> ();
        pausedLoops = new HashMap <String, ForEachLoop> ();
        groups = new HashMap <String, List<Integer> > ();

        //selection = new ObjectSelection (rh.rhApp);

        return true;
    }

    final ObjectSelection.Filter FilterPartOfLoop = new ObjectSelection.Filter()
    {
        @Override
        public boolean filter (Object rdPtr, CObject object)
        {
            if(object != null)
				return ((CRunForEach) rdPtr).partOfLoop.fvs.contains(object.fixedValue());
				
			return false;
        }
    };

    final ObjectSelection.Filter FilterPartOfGroup = new ObjectSelection.Filter()
    {
        @Override
        public boolean filter (Object rdPtr, CObject object)
        {
            if(object != null)
				return ((CRunForEach) rdPtr).partOfGroup.contains(object.fixedValue());
				
			return false;
        }
    };

    @Override
    public boolean condition (int num, CCndExtension cnd)
    {
    	if (this.selection == null)
        	this.selection = new ObjectSelection (this.rh.rhApp);
    	
        switch (num)
        {
            case CON_ONFOREACHLOOPSTRING:
                return cnd.getParamExpString (rh, 0).equals (this.currentForEach.name);

            case CON_FOREACHLOOPISPAUSED:
            {
                ForEachLoop loop = forEachLoops.get(cnd.getParamExpString(rh, 0));
                return (loop != null && loop.paused == true);
            }

            case CON_OBJECTISPARTOFLOOP:
            {
                PARAM_OBJECT param = cnd.getParamObject (rh, 0);

                if ((partOfLoop = forEachLoops.get (cnd.getParamExpString (rh, 1))) == null)
                    return false;

                oiToCheck = param.oi;

                return selection.filterObjects
                        (this, oiToCheck, (cnd.evtFlags2 & CEvent.EVFLAG2_NOT) != 0, FilterPartOfLoop);
            }

            case CON_OBJECTISPARTOFGROUP:
            {
                PARAM_OBJECT param = cnd.getParamObject (rh, 0);

                if ((partOfGroup = groups.get (cnd.getParamExpString (rh, 1))) == null)
                    return false;

                oiToCheck = param.oi;

                return selection.filterObjects
                    (this, oiToCheck, (cnd.evtFlags2 & CEvent.EVFLAG2_NOT) != 0, FilterPartOfGroup);
            }

            case CON_ONFOREACHLOOPOBJECT:

                if(this.currentForEach != null
                    && cnd.getParamExpString(rh, 0).equals(this.currentForEach.name))
                {
                    this.selection.selectOneObject(currentLooped);
                    return true;
                }

                return false;
        }

        return false;
    }

    // This functions where changed in their name
    //Adds all selected objects to the current group
    final ObjectSelection.Filter GetSelectedForGroup = new ObjectSelection.Filter()
    {
        @Override
        public boolean filter (Object rdPtr, CObject object)
        {
            CRunForEach foreach = (CRunForEach) rdPtr;
            List<Integer> array = foreach.groups.get(foreach.currentGroup);
            int currentFixed = object.fixedValue();

            if(array != null)
            {
                int array_size = array.size();
            	for(int i = 0; i < array_size; ++ i)
                {
                    int fixedInArray = array.get(i);

                    if(currentFixed == fixedInArray)
                        return true;
                }
                array.add(currentFixed);
            }
            return true; //Don't filter out any objects
        }
    };

    //Adds all selected objects to the list of fixed values
    final ObjectSelection.Filter GetSelected = new ObjectSelection.Filter()
    {
        @Override
        public boolean filter (Object rdPtr, CObject object)
        {
            ((CRunForEach) rdPtr).populateLoop.addObject(object);

            return true; //Don't filter out any objects
        }
    };

    @Override
	public void action (int num, CActExtension act)
    {
    	if (this.selection == null)
        	this.selection = new ObjectSelection (this.rh.rhApp);
    	
        switch (num)
        {
            case ACT_STARTFOREACHLOOPFOROBJECT:
            {
                String loopName = act.getParamExpString (rh, 0);
                //CObject objectType = act.getParamObject(rh, 1);

                //if(objectType == null)
                //    break;

                //int oi = objectType.hoOi;
                
                int oi = ((PARAM_OBJECT)act.evtParams[1]).oiList;

                ForEachLoop loop = new ForEachLoop ();
                populateLoop = loop;

                //Populate the current foreachloop with all the fixed values of the currently selected objects
                this.selection.filterObjects (this, oi, false, GetSelected);

                loop.name = loopName;
                loop.loopMax = loop.fvs.size();

                executeForEachLoop (loop);

                break;
            }
            case ACT_PAUSEFOREACHLOOP:
            {
                ForEachLoop loop = forEachLoops.get (act.getParamExpString (rh, 0));
                if(loop != null){
                    loop.paused = true;
                }
                break;
            }
            case ACT_RESUMEFOREACHLOOP:
            {
                String loopName = act.getParamExpString (rh, 0);
                ForEachLoop loop = forEachLoops.get (loopName);
                if(loop != null){
                    loop.paused = false;
                    this.pausedLoops.remove(loopName);
                    executeForEachLoop(loop);
                }
                break;
            }
            case ACT_SETFOREACHLOOPITERATION:
            {
                ForEachLoop loop = forEachLoops.get (act.getParamExpString (rh, 0));
                if(loop != null){
                    loop.loopIndex = act.getParamExpression(rh, 1);
                }
                break;
            }
            case ACT_STARTFOREACHLOOPFORGROUP:
            {
                String loopName = act.getParamExpString (rh, 0);
                List <Integer> group = this.groups.get (act.getParamExpString (rh, 1));
                if(group != null)
                {
                    ForEachLoop loop = new ForEachLoop ();
                    loop.name = loopName;
                    loop.loopMax = group.size();

                    loop.fvs.addAll (group);

                    executeForEachLoop (loop);
                }
                break;
            }
            case ACT_ADDOBJECTTOGROUP:
            {
                if(ho.hoAdRunHeader.rhEvtProg.rh2ActionLoopCount != 0)
                    return;

                CObject object = act.getParamObject (rh, 0);
                this.currentGroup = act.getParamExpString (rh, 1);
                List <Integer> group = this.groups.get (this.currentGroup);

                if(object == null)
                    break;

                //Create group if it doesn't exist
                if(group == null){
                    group = new ArrayList <Integer> ();
                    this.groups.put (this.currentGroup, group);
                }

                selection.filterObjects(this, object.hoOi, false, GetSelectedForGroup);
                this.currentGroup = null;

                break;
            }
            case ACT_ADDFIXEDTOGROUP:
            {
                int fixed = act.getParamExpression (rh, 0);
                String groupName = act.getParamExpString (rh, 1);
                List <Integer> group = this.groups.get (groupName);

                if(fixed == 0)
                    break;

                //Create group if it doesn't exist
                if(group == null){
                    group = new ArrayList <Integer> ();
                    this.groups.put (groupName, group);
                }

                group.add (fixed);
                break;
            }
            case ACT_REMOVEOBJECTFROMGROUP:
            {
                CObject object = act.getParamObject (rh, 0);
                String groupName = act.getParamExpString (rh, 1);
                List <Integer> group = this.groups.get (groupName);

                if(group == null || object == null)
                    break;

                group.remove (object.fixedValue ());

                //Delete group if empty
                if(group.size() == 0)
                    this.groups.remove (groupName);

                break;
            }
            case ACT_REMOVEFIXEDFROMGROUP:
            {
                int fixed = act.getParamExpression (rh, 0);
                String groupName = act.getParamExpString (rh, 1);
                List <Integer> group = groups.get (groupName);

                if(group == null || fixed == 0)
                    break;

                group.remove (fixed);

                //Delete group if empty
                if(group.size() == 0)
                    groups.remove (groupName);

                break;
            }
        }
    }

    void executeForEachLoop (ForEachLoop loop)
    {
        //Store current loop
        ForEachLoop prevLoop = this.currentForEach;
        forEachLoops.put (loop.name, loop);
        this.currentForEach = loop;
        for(;loop.loopIndex < loop.loopMax; ++loop.loopIndex)
        {
            //Was the loop paused?
            if(loop.paused){
                //Move the fastloop to the 'paused' table
                this.pausedLoops.put (loop.name, loop);
                this.forEachLoops.remove (loop.name);
                break;
            }
            ho.generateEvent (CON_ONFOREACHLOOPSTRING, 0);

            this.currentLooped = ho.getObjectFromFixed (loop.fvs.get (loop.loopIndex));
            if(this.currentLooped != null)
                ho.generateEvent (CON_ONFOREACHLOOPOBJECT, 0);
        }
        //Release the loop?
        if(!loop.paused)
            forEachLoops.remove (loop.name);

        //Restore the previous loop (in case of nested loops)
        this.currentForEach = prevLoop;
    }

    @Override
    public CValue expression (int num)
    {
        switch(num){
            case EXP_LOOPFV:
            {
                ForEachLoop loop = forEachLoops.get(ho.getExpParam().getString());
                if(loop == null)
                    break;
                return new CValue (loop.fvs.get(loop.loopIndex));
            }
            case EXP_LOOPITERATION:
            {
                ForEachLoop loop = forEachLoops.get(ho.getExpParam().getString());
                if(loop == null)
                    break;
                return new CValue (loop.loopIndex);
            }
            case EXP_LOOPMAXITERATION:
            {
                ForEachLoop loop = forEachLoops.get(ho.getExpParam().getString());
                if(loop == null)
                    break;
                return new CValue (loop.loopMax);
            }
            case EXP_GROUPSIZE:
            {
                List<Integer> group = groups.get(ho.getExpParam().getString());
                if(group == null)
                    break;
                return new CValue (group.size());
            }
        }
        return new CValue (0);
    }



}
