package Extensions
{
    import Actions.*;
    import Conditions.*;
    import Expressions.*; 
    import Objects.CObject;    
    import RunLoop.*;
    import Services.*;
    import Sprites.*;

    public class CRunMoveIt extends CRunExtension
    {
        private static var CND_ONOBJECTFINNISHED:int = 0;
        private static var CND_LAST:int = 1;

        private static var ACTMOVEOBJSPEED:int = 0;
        private static var ACTMOVEOBJTIME:int = 1;
        private static var ACTSTOPMOVEMENTUSINGFIXED:int = 2;
        private static var ACTSTOPMOVEMENTUSINGINDEXVALUE:int = 3;
        private static var ACTSTOPMOVEMENTUSINGSELECTOR:int = 4;
        private static var ACTADDOBJECTS:int = 5;
        private static var ACTCLEARQUEUE:int = 6;
        private static var ACTSTOPALL:int = 7;
        private static var ACTFORCEMOVE:int = 8;

        private static var EXPGETNUMMOVING:int = 0;
        private static var EXPGETFIXEDVALUE:int = 1;
        private static var EXPGETTOTALDISTANCE:int = 2;
        private static var EXPGETREMAINING:int = 3;
        private static var EXPGETANGLE:int = 4;
        private static var EXPGETDIRECTION:int = 5;
        private static var EXPGETINDEXFIXEDVALUE:int = 6;
        private static var EXPGETINDEXTOTALDISTANCE:int = 7;
        private static var EXPGETINDEXREMAINING:int = 8;
        private static var EXPGETINDEXANGLE:int = 9;
        private static var EXPGETINDEXDIR:int = 10;
        private static var EXPGETONSTOPPEDFIXED:int = 11;
        
        public var head:CRunMoveItItem = null;
        public var tail:CRunMoveItItem = null;
        public var movingCount:int = 0;
        
    	public var queue:Array = new Array();
    	public var triggeredObject:CObject = null;

        public override function getNumberOfConditions():int
        {
            return CND_LAST;
        }
        public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
        {
            return false;
        }
        public override function destroyRunObject(bFast:Boolean):void
        {
        	queue = new Array();
        	head = tail = null;
        }
        public override function handleRunObject():int
        {
        	if(movingCount > 0)
        		DoMoveStep();
            return 0;
        }
        
        private function DoMoveStep():void
        {
        	for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if ((it.object.hoFlags & CObject.HOF_DESTROYED) != 0 )
	            {
        			DeleteItem(it);	            	
	                continue;
	            }
	
				it.step++;
				it.object.hoX = ((it.destX-it.sourceX)*it.step)/it.cycles + it.sourceX;
				it.object.hoY = ((it.destY-it.sourceY)*it.step)/it.cycles + it.sourceY;
				it.object.roc.rcChanged = true;
	
				if(it.step >= it.cycles)
				{
	                this.triggeredObject = it.object;
					DeleteItem(it);
					ho.generateEvent(CND_ONOBJECTFINNISHED, 0);
				}
        	}
        }
        
	    private function MoveObject(object:CObject, destX:int, destY:int, cycles:int):void
	    {
	        //First check if the object added allready exist in MoveIt
	        var foundObject:Boolean = false;
	        
			for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{  
	            if(object == it.object)
	            {
	                //If the object allready exists, then update the data
	                foundObject = true;
	                it.sourceX = object.hoX;
	                it.sourceY = object.hoY;
	                it.destX = destX;
	                it.destY = destY;
	                it.step = 0;
	                it.cycles = Math.max(cycles,1);
	            }
	        }

	        //If the object wasn't in the MoveIt object, then add it.
	        if(!foundObject)
	        {
	            var item:CRunMoveItItem = new CRunMoveItItem(
	                    object,
	                    object.hoX,
	                    object.hoY,
	                    destX,
	                    destY,
	                    Math.max(cycles,1)
	            );
	            AddItem(item);
	        }
	    }
                
        private function DeleteItem(it:CRunMoveItItem):void
        {
        	//Deleting this object and fixing pointers
	    	if(it.prev != null)
	    		it.prev.next = it.next;
	    	else
	    		head = it.next;	
	    		
	    	if(it.next != null)
	    		it.next.prev = it.prev;
	    	else
	    		tail = it.prev;
	    		
	    	movingCount--;
		}
		
		private function AddItem(it:CRunMoveItItem):void
		{
			if(tail == null)
			{
				head = tail = it;
				it.prev = it.next = null;
			}
			else
			{
				tail.next = it;
				it.prev = tail;
				it.next = null;
				tail = it;
			}
			
			movingCount++;
		}

	    private function GetFixedValue(obj:CObject):int
	    {
	        return (obj.hoCreationId << 16) + (obj.hoNumber & 0xFFFF);
	    }

        // Conditions
        // -------------------------------------------------
        public override function condition(num:int, cnd:CCndExtension):Boolean
        {
            if(num == CND_ONOBJECTFINNISHED )
                return true;

            return false;
        }

        // Actions
        // -------------------------------------------------
        public override function action(num:int, act:CActExtension):void
        {
            switch (num)
            {
            case ACTMOVEOBJSPEED:
                actMoveObjSpeed(act.getParamExpression(rh,0), act.getParamExpression(rh,1), act.getParamExpression(rh,2));
                break;
            case ACTMOVEOBJTIME:
                actMoveObjTime(act.getParamExpression(rh,0), act.getParamExpression(rh,1), act.getParamExpression(rh,2));
                break;
            case ACTSTOPMOVEMENTUSINGFIXED:
                actStopMovementUsingFixed(act.getParamExpression(rh,0));
                break;
            case ACTSTOPMOVEMENTUSINGINDEXVALUE:
                actStopMovementUsingIndexValue(act.getParamExpression(rh,0));
                break;
            case ACTSTOPMOVEMENTUSINGSELECTOR:
                actStopMovementUsingSelector(act.getParamObject(rh,0));
                break;
            case ACTADDOBJECTS:
                actAddObjects(act.getParamObject(rh,0));
                break;
            case ACTCLEARQUEUE:
                actClearQueue();
                break;
            case ACTSTOPALL:
                actStopAll();
                break;
            case ACTFORCEMOVE:
                actForceMove();
                break;
            }
        }

        // Expressions
        // -------------------------------------------------
        public override function expression(num:int):CValue
        {
            switch (num)
            {
            case EXPGETNUMMOVING:
                return expGetNumMoving();
            case EXPGETFIXEDVALUE:
                return expGetFixedValue(ho.getExpParam().getInt());
            case EXPGETTOTALDISTANCE:
                return expGetTotalDistance(ho.getExpParam().getInt());
            case EXPGETREMAINING:
                return expGetRemaining(ho.getExpParam().getInt());
            case EXPGETANGLE:
                return expGetAngle(ho.getExpParam().getInt());
            case EXPGETDIRECTION:
                return expGetDirection(ho.getExpParam().getInt());
            case EXPGETINDEXFIXEDVALUE:
                return expGetIndexFixedValue(ho.getExpParam().getInt());
            case EXPGETINDEXTOTALDISTANCE:
                return expGetIndexTotalDistance(ho.getExpParam().getInt());
            case EXPGETINDEXREMAINING:
                return expGetIndexRemaining(ho.getExpParam().getInt());
            case EXPGETINDEXANGLE:
                return expGetIndexAngle(ho.getExpParam().getInt());
            case EXPGETINDEXDIR:
                return expGetIndexDir(ho.getExpParam().getInt());
            case EXPGETONSTOPPEDFIXED:
                return expGetOnStoppedFixed();
            }
            return new CValue(0);
        }


	    ///////////
	    //ACTIONS//
	    ///////////

        private function actAddObjects(object:CObject):void
        {
        	queue.push(object);
        }

        private function actClearQueue():void
        {
        	queue = new Array();
        }

        private function actMoveObjSpeed(destX:int, destY:int, intspeed:int):void
        {
        	var speed:Number = intspeed/10.0;
        
	        if( intspeed <= 0 )
	            return;
	
			for(var i:int=0; i<queue.length; i++)
			{
				var object:CObject = queue[i];
	            var distance:Number = Math.sqrt(
	                                  Math.pow(object.hoX-destX,2.0)
	                                + Math.pow(object.hoY-destY,2.0)
	                              );
	            var cycles:int = (int)(distance/speed);
	            MoveObject(object,destX,destY,cycles);
	        }
	        actClearQueue();
        }

        private function actMoveObjTime(destX:int, destY:int, time:int):void
        {
        	for(var i:int=0; i<queue.length; i++)
			{
				var object:CObject = queue[i];
				MoveObject(object,destX,destY,time);
			}
			actClearQueue();
        }

        private function actStopMovementUsingFixed(fixedvalue:int):void
        {
        	for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{     
	            if(GetFixedValue(it.object) == fixedvalue)
	            {
	            	DeleteItem(it);
	            	return;
	            }
	        }
        }

        private function actStopMovementUsingIndexValue(index:int):void
        {
        	var i:int = 0;
        	for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if(i == index)
	            {
	            	DeleteItem(it);
	            	return;
	            }
	            i++;
	        }
        }

        private function actStopMovementUsingSelector(object:CObject):void
        {
        	actStopMovementUsingFixed(GetFixedValue(object));
        }

        private function actStopAll():void
        {
        	head = tail = null;
        }

        private function actForceMove():void
        {
        	DoMoveStep();
        }
	
	    ///////////////
	    //EXPRESSIONS//
	    ///////////////

		private function GetItemFromFixed(fixed:int):CRunMoveItItem
		{
		    for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if(GetFixedValue(it.object) == fixed)	            	
					return it;
	        }
	        return null;
		}
		
		private function GetItemFromIndex(index:int):CRunMoveItItem
		{
			var i:int = 0;
		    for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if(i == index)
	            	return it;					
				i++;
	        }
	        return null;
		}

        private function expGetNumMoving():CValue
        {
            return new CValue(movingCount);
        }

        private function expGetFixedValue(fixedvalue:int):CValue
        {
        	//From fixed get index
        	var i:int = 0;
        	for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if(GetFixedValue(it.object) == fixedvalue)	            	
	            	return new CValue(i);
	            i++;
	        }
            return new CValue(-1);
        }

        private function expGetTotalDistance(fixedvalue:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromFixed(fixedvalue);
        	if(item != null)
	        	return new CValue(Math.sqrt(
	                Math.pow(item.sourceX-item.destX,2.0)+
	                Math.pow(item.sourceY-item.destY,2.0))
	             );
            else
            	return new CValue(-1);
        }

        private function expGetRemaining(fixedvalue:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromFixed(fixedvalue);
        	if(item != null)
	        	return new CValue(Math.sqrt(
	                Math.pow(item.object.hoX-item.destX,2.0)+
	                Math.pow(item.object.hoY-item.destY,2.0))
	             );
	        else
            	return new CValue(-1);
        }

        private function expGetAngle(fixedvalue:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromFixed(fixedvalue);
        	if(item != null)
        		return new CValue( Math.atan2(item.destX-item.sourceX,item.destY-item.sourceY) * 180.0/Math.PI + 270 );
        	else
            	return new CValue(-1);
        }

        private function expGetDirection(fixedvalue:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromFixed(fixedvalue);
        	if(item != null)
        		return new CValue( Math.atan2(item.destX-item.sourceX,item.destY-item.sourceY) * 16.0/Math.PI + 24 );
        	else
            	return new CValue(-1);
        }

        private function expGetIndexFixedValue(index:int):CValue
        {
			var i:int = 0;
		    for(var it:CRunMoveItItem = head; it != null; it = it.next)
        	{
	            if(i == index)
	            	return new CValue(GetFixedValue(it.object));					
				i++;
	        }
            return new CValue(-1);
        }

        private function expGetIndexTotalDistance(index:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromIndex(index);
        	if(item != null)
	        	return new CValue(Math.sqrt(
	                Math.pow(item.sourceX-item.destX,2.0)+
	                Math.pow(item.sourceY-item.destY,2.0))
	             );
            else
            	return new CValue(-1);
        }

        private function expGetIndexRemaining(index:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromIndex(index);
        	if(item != null)
	        	return new CValue(Math.sqrt(
	                Math.pow(item.object.hoX-item.destX,2.0)+
	                Math.pow(item.object.hoY-item.destY,2.0))
	             );
	        else
            	return new CValue(-1);
        }

        private function expGetIndexAngle(index:int):CValue
        {
         	var item:CRunMoveItItem = GetItemFromIndex(index);
        	if(item != null)
        		return new CValue( Math.atan2(item.destX-item.sourceX,item.destY-item.sourceY) * 180.0/Math.PI + 270 );
        	else
            	return new CValue(-1);
        }

        private function expGetIndexDir(index:int):CValue
        {
        	var item:CRunMoveItItem = GetItemFromIndex(index);
        	if(item != null)
        		return new CValue( Math.atan2(item.destX-item.sourceX,item.destY-item.sourceY) * 16.0/Math.PI + 24 );
        	else
            	return new CValue(-1);
        }

        private function expGetOnStoppedFixed():CValue
        {
        	if(triggeredObject != null)
	        	return new CValue(GetFixedValue(triggeredObject));
	        else
	        	return new CValue(-1);
        }

    }
}
