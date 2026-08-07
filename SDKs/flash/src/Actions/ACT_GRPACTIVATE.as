// -----------------------------------------------------------------------------
//
// ACTIVATE GROUP
//
// -----------------------------------------------------------------------------
package Actions
{
	import Events.*;
	
	import Params.*;
	
	import RunLoop.*;

	public class ACT_GRPACTIVATE extends CAct
	{
		public override function execute(rhPtr:CRun):void
		{
			var p:PARAM_GROUPOINTER=PARAM_GROUPOINTER(evtParams[0]);
			var evg:int=p.pointer;
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.events[evg];
			var evtPtr:CEvent=evgPtr.evgEvents[0];
	
			var grpPtr:PARAM_GROUP=PARAM_GROUP(evtPtr.evtParams[0]);
			var bFlag:Boolean=(grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_GROUPINACTIVE)!=0;
			grpPtr.grpFlags&=~PARAM_GROUP.GRPFLAGS_GROUPINACTIVE;
	
			if (bFlag)
			{
				grpActivate(rhPtr, evg);
			}        
		}
		public function grpActivate(rhPtr:CRun, evg:int):int
		{
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.events[evg];
			var evtPtr:CEvent=evgPtr.evgEvents[0];
			var grpPtr:PARAM_GROUP=PARAM_GROUP(evtPtr.evtParams[0]);
			var cpt:int;
			var bQuit:Boolean=false;
	
			if ((grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_PARENTINACTIVE)==0)
			{
				evgPtr.evgFlags&=~CEventGroup.EVGFLAGS_INACTIVE;
	
				for (evg++, bQuit=false, cpt=1; ;)
				{
					evgPtr=rhPtr.rhEvtProg.events[evg];
					evtPtr=evgPtr.evgEvents[0];
					switch (evtPtr.evtCode)
					{
						case ((-10<<16)|65535):	    // CNDL_GROUP:
							grpPtr=PARAM_GROUP(evtPtr.evtParams[0]);
							if (cpt==1)
							{
								grpPtr.grpFlags&=~PARAM_GROUP.GRPFLAGS_PARENTINACTIVE;
							}
							if ((grpPtr.grpFlags&PARAM_GROUP.GRPFLAGS_GROUPINACTIVE)==0)
							{
								evg=grpActivate(rhPtr, evg);
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
								evgPtr.evgFlags&=~CEventGroup.EVGFLAGS_INACTIVE;
								bQuit=true;
								evg++;
							}
							break;
						case ((-23<<16)|65535):	    // CNDL_GROUPSTART:
							if (cpt==1)
							{
								evgPtr.evgFlags&=~CEventGroup.EVGFLAGS_INACTIVE;
								evgPtr.evgFlags&=~CEventGroup.EVGFLAGS_ONCE;
							}
							break;
						default:
							if (cpt==1)
							{
								evgPtr.evgFlags&=~CEventGroup.EVGFLAGS_INACTIVE;
							}
							break;
					}
					if (bQuit)
						break;
					evg++;
				}
			}
			else
			{
				// Saute le groupe et les sous-groupes
				for (evg++, bQuit=false, cpt=1; ; evg++)
				{
					evgPtr=rhPtr.rhEvtProg.events[evg];
					evtPtr=evgPtr.evgEvents[0];
					switch (evtPtr.evtCode)
					{
						case ((-10<<16)|65535):	    // CNDL_GROUP:
							cpt++;
							break;
						case ((-11<<16)|65535):	    // CNDL_ENDGROUP:
							cpt--;
							if (cpt==0)
							{
								bQuit=true;
								evg++;
							}
							break;
					}
					if (bQuit)
						break;
				}
			}
			return evg;
		}	    
	}
}