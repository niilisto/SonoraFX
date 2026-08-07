// -----------------------------------------------------------------------------
//
// START LOOP
//
// -----------------------------------------------------------------------------
package Actions {
	import Events.CEventGroup;
	import Events.CPosOnLoop;
	import Params.CParamExpression;
	import RunLoop.CRun;
	
	public class ACT_STARTLOOP extends CAct
	{
		public override function execute(rhPtr:CRun):void {
			var name:String;
			var number:int;
			var bInfinite:Boolean=false;
			var pLoop:CLoop= null;
			var save:String=null;
			var actionLoop:Boolean=false;		// Flag boucle
			var actionLoopCount:int=0;			// Numero de boucle d'actions
			var eventGroup:CEventGroup=null;
			
			// Fast handling
			var pExp:CParamExpression= CParamExpression(evtParams[0]);
			if (rhPtr.rhEvtProg.complexOnLoop == false && pExp.comparaison > 0)
			{
				var posOnLoop:CPosOnLoop= CPosOnLoop(rhPtr.rh4PosOnLoop.get(pExp.comparaison - 1));
				if (posOnLoop != null && posOnLoop.m_bOR == false)
				{
					name = posOnLoop.m_name;
					number=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
					
					bInfinite=false;
					pLoop = rhPtr.findFastLoop(name);
					if (pLoop == null)
					{
						rhPtr.rh4FastLoops.put (name, pLoop);
					}
					pLoop.flags&=~CLoop.FLFLAG_STOP;
					bInfinite=false;
					if (number<0)
					{
						bInfinite=true;
						number=10;
					}
					save=rhPtr.rh4CurrentFastLoop;
					actionLoop=rhPtr.rhEvtProg.rh2ActionLoop;				// Flag boucle
					actionLoopCount=rhPtr.rhEvtProg.rh2ActionLoopCount;		// Numero de boucle d'actions
					eventGroup=rhPtr.rhEvtProg.rhEventGroup;
					for (pLoop.index=0; pLoop.index<number; pLoop.index++)
					{
						rhPtr.rh4CurrentFastLoop=name;
						rhPtr.rhEvtProg.rh2ActionOn=false;
						rhPtr.rhEvtProg.computeEventFastLoopList(posOnLoop.m_pointers);
						if ((pLoop.flags&CLoop.FLFLAG_STOP)!=0)
							break;
						if (bInfinite)
							number=pLoop.index+10;
					}
					rhPtr.rhEvtProg.rhEventGroup=eventGroup;
					rhPtr.rhEvtProg.rh2ActionLoopCount=actionLoopCount;			// Numero de boucle d'actions
					rhPtr.rhEvtProg.rh2ActionLoop=actionLoop;					// Flag boucle
					rhPtr.rh4CurrentFastLoop=save;
					rhPtr.rhEvtProg.rh2ActionOn=true;
					//rhPtr.rh4FastLoops.remove (name);
					return;
				}
			}
			
			// Normal handling
			name=rhPtr.get_EventExpressionStringLowercase(CParamExpression(evtParams[0]));
			if (name.length==0)
				return;
			number=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[1]));
			if (number == 0)
				return;
			
			bInfinite=false;
			
			pLoop = rhPtr.findFastLoop (name);
			
			if (pLoop == null)
			{
				pLoop=new CLoop();
				
				pLoop.name = name;
				rhPtr.rh4FastLoops.put (name, pLoop);
			}
			
			pLoop.flags&=~CLoop.FLFLAG_STOP;
			
			bInfinite=false;
			if (number<0)
			{
				bInfinite=true;
				number=10;
			}
			save=rhPtr.rh4CurrentFastLoop;
			actionLoop=rhPtr.rhEvtProg.rh2ActionLoop;				// Flag boucle
			actionLoopCount=rhPtr.rhEvtProg.rh2ActionLoopCount;		// Numero de boucle d'actions
			eventGroup=rhPtr.rhEvtProg.rhEventGroup;
			for (pLoop.index=0; pLoop.index<number; pLoop.index++)
			{
				rhPtr.rh4CurrentFastLoop=name;
				rhPtr.rhEvtProg.rh2ActionOn=false;
				rhPtr.rhEvtProg.handle_GlobalEvents(((-16<<16)|65535));	// CNDL_ONLOOP;
				if ((pLoop.flags&CLoop.FLFLAG_STOP)!=0)
					break;
				if (bInfinite)
					number=pLoop.index+10;
			}
			rhPtr.rhEvtProg.rhEventGroup=eventGroup;
			rhPtr.rhEvtProg.rh2ActionLoopCount=actionLoopCount;			// Numero de boucle d'actions
			rhPtr.rhEvtProg.rh2ActionLoop=actionLoop;					// Flag boucle
			rhPtr.rh4CurrentFastLoop=save;
			rhPtr.rhEvtProg.rh2ActionOn=true;
			//rhPtr.rh4FastLoops.remove (name);
		}
	}
}