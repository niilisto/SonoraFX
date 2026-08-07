// ------------------------------------------------------------------------------
// 
// COLLISION
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Events.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	public class CND_EXTCOLLISION extends CCnd
	{
	    public override function eva1(rhPtr:CRun, pHo:CObject):Boolean
	    {
			var pHo1:CObject=rhPtr.rhObjectList[rhPtr.rhEvtProg.rh1stObjectNumber];
			var oiEvent:int=evtOi;
			var p:PARAM_OBJECT=PARAM_OBJECT(evtParams[0]);
			var oiParam:int=p.oi;
		
			while(true)
			{
			    if (oiEvent==pHo.hoOi)							// Event== courant	
			    {
					// 1er=courant
					if (oiParam==pHo1.hoOi) 
					    break;
					if (oiParam>=0) 
					    return false;				// Un qualifier?
					if (colGetList(rhPtr, p.oiList, pHo1.hoOi)) 
					    break;
					return false;
			    }
			    if (oiParam==pHo.hoOi)							// parametre== courant
			    {
					// 2eme=courant
					if (oiEvent==pHo1.hoOi) 
					    break;
					if (oiEvent>=0) 
					    return false;
					if (colGetList(rhPtr, evtOiList, pHo1.hoOi)) 
					    break;
					return false;
			    }
			    if (oiEvent<0)
			    {
					// 1er=liste
					if (oiParam<0)
					{
					    // 1er=liste, 2eme=liste
					    if (colGetList(rhPtr, evtOiList, pHo.hoOi))	// Le courant fait-il partie de la liste 1
					    {
							if (colGetList(rhPtr, p.oiList, pHo1.hoOi))	//; Courant dans liste 1, collision dans liste 2?
							    break;	
							if (colGetList(rhPtr, p.oiList, pHo.hoOi)==false)  //; Derniere chance, courant dans liste 2?
							    return false;	
							if (colGetList(rhPtr, evtOiList, pHo1.hoOi)) 
							    break;
							return false;
					    }
					    else
					    {
							if (colGetList(rhPtr, evtOiList, pHo1.hoOi))	    //; Courant dans liste 2, collision dans liste 1?
							    break;
							return false;
					    }
					}
					else
					{
					    if (oiParam==pHo1.hoOi)
							break;
					    return false;
					}
			    }
			    if (oiParam>=0) 
					return false;
			    // 1er=oi, 2eme=qualif
			    if (oiEvent!=pHo1.hoOi) 
					return false;
			    break;
			}
			
			// Collision detectee, on ne veut pas de repeat
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var id:int=( (pHo1.hoCreationId)<<16)|((evtIdentifier)&0x0000FFFF);	//; Prend le numero de l'objet en collision
			if (compute_NoRepeatCol(id, pHo)==false) 
			{
			    // Si une action STOP dans le groupe, il faut la faire!!!
			    if ((rhPtr.rhEvtProg.rhEventGroup.evgFlags&CEventGroup.EVGFLAGS_STOPINGROUP)==0) 
					return false;
			    rhPtr.rhEvtProg.rh3DoStop=true;
			}
			id=( (pHo.hoCreationId)<<16)|((evtIdentifier)&0x0000FFFF);		//; Prend le numero de l'objet en collision
			if (compute_NoRepeatCol(id, pHo1)==false)			// Deja fait B et A?
			{
			    // Si une action STOP dans le groupe, il faut la faire!!!
			    if ((rhPtr.rhEvtProg.rhEventGroup.evgFlags&CEventGroup.EVGFLAGS_STOPINGROUP)==0) 
					return false;
			    rhPtr.rhEvtProg.rh3DoStop=true;
			}
		
			// Stocke le deuxieme sprite dans la list courante
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			rhPtr.rhEvtProg.evt_AddCurrentObject(pHo);
			rhPtr.rhEvtProg.evt_AddCurrentObject(pHo1);
		
			if (pHo1.rom.rmMovement.rmCollisionCount==rhPtr.rh3CollisionCount)
			    pHo.rom.rmMovement.rmCollisionCount=rhPtr.rh3CollisionCount;
			else if (pHo.rom.rmMovement.rmCollisionCount==rhPtr.rh3CollisionCount)
			    pHo1.rom.rmMovement.rmCollisionCount=rhPtr.rh3CollisionCount;
		
			return true;    
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			return isColliding(rhPtr);
	    }
	
	    // Procedure d'exploration d'un qualifier
	    public function colGetList(rhPtr:CRun, oiList:int, lookFor:int):Boolean
	    {
			if (oiList==-1) 
			    return false;
			var qoil:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[oiList&0x7FFF];
			var index:int;
			for (index=0; index<qoil.qoiList.length; index+=2)
			{
			    if (qoil.qoiList[index]==lookFor) 
					return true;
			}
			return false;
	    }
	}
}