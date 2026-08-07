// -----------------------------------------------------------------------------
//
// DEACTIVATE GROUP
//
// -----------------------------------------------------------------------------
package Actions
{
	import Events.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_GRPDEACTIVATE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_GROUPOINTER=PARAM_GROUPOINTER(evtParams[0]);
			var evg:int=p.pointer;
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.events[evg];
			var evtPtr:CEvent=evgPtr.evgEvents[0];
	
			var grpPtr:PARAM_GROUP=PARAM_GROUP(evtPtr.evtParams[0]);
			var bFlag:Boolean=(grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_GROUPINACTIVE)==0;
			grpPtr.grpFlags|=PARAM_GROUP.GRPFLAGS_GROUPINACTIVE;
	
			if (bFlag==true && (grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_PARENTINACTIVE)==0)
			{
				grpDeactivate(rhPtr, evg);
			}        
		}
		public function grpDeactivate(rhPtr:CRun, evg:int):int
		{
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.events[evg];
			var evtPtr:CEvent=evgPtr.evgEvents[0];
			var grpPtr:PARAM_GROUP=PARAM_GROUP(evtPtr.evtParams[0]);
	
			evgPtr.evgFlags|=CEventGroup.EVGFLAGS_INACTIVE;
	
			var cpt:int;
			var bQuit:Boolean, bFlag:Boolean;

			for (evg++, bQuit=false, cpt=1; ;)
			{
				evgPtr=rhPtr.rhEvtProg.events[evg];
				evtPtr=evgPtr.evgEvents[0];
				switch (evtPtr.evtCode)
				{
					case ((-10<<16)|65535):	    // CNDL_GROUP:
						grpPtr=PARAM_GROUP(evtPtr.evtParams[0]);
						bFlag=(grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_PARENTINACTIVE)==0;
						if (cpt==1)
						{
							grpPtr.grpFlags|=PARAM_GROUP.GRPFLAGS_PARENTINACTIVE;
	    				}
						if (bFlag!=false && (grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_GROUPINACTIVE)==0)
						{
							evg=grpDeactivate(rhPtr, evg);
							continue;
						}
						else
						{
							cpt++;
						}
						break;
					case ((-11<<16)|65535):	    // CNDL_ENDGROUP:
						cpt--;
						if (cpt==0)
						{
							evgPtr.evgFlags|=CEventGroup.EVGFLAGS_INACTIVE;
							bQuit=true;
							evg++;
						}
						break;
					default:
						if (cpt==1)
						{
							evgPtr.evgFlags|=CEventGroup.EVGFLAGS_INACTIVE;
						}
						break;
				}
				if (bQuit)
					break;
	
				evg++;
			}
			return evg;
		}
	    
	}
}