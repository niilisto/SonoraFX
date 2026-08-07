package Extensions
{
	import Actions.CActExtension;
	
	import Conditions.CCndExtension;
	
	import Events.CEvent;
	
	import Expressions.CValue;
	
	import Objects.CObject;
	
	import Params.PARAM_OBJECT;
	
	import RunLoop.CCreateObjectInfo;
	
	import Services.CArrayList;
	import Services.CBinaryFile;
	import Services.CObjectSelection;
	
	public class CRunForEach extends CRunExtension
	{
		private static var CON_ONFOREACHLOOPSTRING:int = 0;
		private static var CON_FOREACHLOOPISPAUSED:int = 1;
		private static var CON_OBJECTISPARTOFLOOP:int = 2;
		private static var CON_OBJECTISPARTOFGROUP:int = 3;
		private static var CON_ONFOREACHLOOPOBJECT:int = 4;
		private static var CON_LAST:int = 5;
		private static var ACT_STARTFOREACHLOOPFOROBJECT:int = 0;
		private static var ACT_PAUSEFOREACHLOOP:int = 1;
		private static var ACT_RESUMEFOREACHLOOP:int = 2;
		private static var ACT_SETFOREACHLOOPITERATION:int = 3;
		private static var ACT_STARTFOREACHLOOPFORGROUP:int = 4;
		private static var ACT_ADDOBJECTTOGROUP:int = 5;
		private static var ACT_ADDFIXEDTOGROUP:int = 6;
		private static var ACT_REMOVEOBJECTFROMGROUP:int = 7;
		private static var ACT_REMOVEFIXEDFROMGROUP:int = 8;
		private static var EXP_LOOPFV:int = 0;
		private static var EXP_LOOPITERATION:int = 1;
		private static var EXP_LOOPMAXITERATION:int = 2;
		private static var EXP_GROUPSIZE:int = 3;

		public var name:String;
		public var fvs:CArrayList;
		public var loopIndex:int;
		public var loopMax:int;
		public var paused:Boolean;
		public var forEachLoops:Array; // Name => ForEachLoop lookup
		public var pausedLoops:Array; // Name => Paused ForEachLoop lookup
		public var groups:Array;// Groupname => CArrayList of objects
		public var currentForEach:CRunForEachLoop;
		public var currentGroup:String;
		public var selection:CObjectSelection;
		public var currentLooped:CObject;
		
		//Variables for the ObjectSelection framework to access
		public var populateLoop:CRunForEachLoop; //To fill with all currently selected objects
		public var partOfLoop:CRunForEachLoop; //To access the loop in question
		public var partOfGroup:CArrayList; //To access the group in question
		public var oiToCheck:int;	
		   
		public function CRunForEach()
		{
		}
		public override function getNumberOfConditions():int
	    {
	        return CON_LAST;
	    }
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
			this.currentGroup = null;
			
			this.forEachLoops = new Array();
			this.pausedLoops = new Array();
			this.groups = new Array();

			return true;
	    }
		
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			if (this.selection==null)
				this.selection = new CObjectSelection (this.rh.rhApp);
			
			switch (num)
			{
				case CON_ONFOREACHLOOPSTRING:
					return cnd.getParamExpString(this.rh, 0)==this.currentForEach.name;
					
				case CON_FOREACHLOOPISPAUSED:
				{
					var loop:CRunForEachLoop = this.forEachLoops[cnd.getParamExpString(this.rh, 0)];
					return loop != null && loop.paused == true;
				}
					
				case CON_OBJECTISPARTOFLOOP:
				{
					var param:int = (PARAM_OBJECT(cnd.evtParams[0])).oiList;
					
					if ((partOfLoop = this.forEachLoops[cnd.getParamExpString (this.rh, 1)]) == null)
						return false;
					
					return this.selection.filterObjects(this, param, (cnd.evtFlags2 & CEvent.EVFLAG2_NOT) != 0, this.filterPartOfLoop);
				}
					
				case CON_OBJECTISPARTOFGROUP:
				{
					var param2:int = (PARAM_OBJECT(cnd.evtParams[0])).oiList;
					
					if ((this.partOfGroup = this.groups[cnd.getParamExpString(this.rh, 1)]) == null)
						return false;
					
					return this.selection.filterObjects(this, param2, (cnd.evtFlags2 & CEvent.EVFLAG2_NOT) != 0, this.filterPartOfGroup);
				}
					
				case CON_ONFOREACHLOOPOBJECT:
					
					if(this.currentForEach != null && cnd.getParamExpString(this.rh, 0)==this.currentForEach.name)
					{
						this.selection.selectOneObject(this.currentLooped);
						return true;
					}
					
					return false;
			}
			
			return false;
		}
		
		public override function action(num:int, act:CActExtension):void
		{
			if (this.selection==null)
				this.selection = new CObjectSelection (this.rh.rhApp);
			
			var loop:CRunForEachLoop;
			var group:CArrayList;
			var groupName:String;
			var loopName:String;
			var oi:int, fixed:int;
			switch (num)
			{
				case ACT_STARTFOREACHLOOPFOROBJECT:
				{
					loopName= act.getParamExpString (this.rh, 0);
					oi=(PARAM_OBJECT(act.evtParams[1])).oiList;                
					
					loop= new CRunForEachLoop ();
					this.populateLoop = loop;
					
					//Populate the current foreachloop with all the fixed values of the currently selected objects
					this.selection.filterObjects(this, oi, false, filterGetSelected);
					
					loop.name = loopName;
					loop.loopMax = loop.fvs.size();
					
					this.executeForEachLoop (loop);
					
					break;
				}
				case ACT_PAUSEFOREACHLOOP:
				{
					loop= this.forEachLoops[act.getParamExpString (this.rh, 0)];
					if(loop != null){
						loop.paused = true;
					}
					break;
				}
				case ACT_RESUMEFOREACHLOOP:
				{
					loopName= act.getParamExpString (this.rh, 0);
					loop= this.forEachLoops[loopName];
					if(loop != null)
					{
						loop.paused = false;
						this.pausedLoops.splice(loopName, 1);
						this.executeForEachLoop(loop);
					}
					break;
				}
				case ACT_SETFOREACHLOOPITERATION:
				{
					loop= this.forEachLoops[act.getParamExpString(this.rh, 0)];
					if(loop != null)
					{
						loop.loopIndex = act.getParamExpression(this.rh, 1);
					}
					break;
				}
				case ACT_STARTFOREACHLOOPFORGROUP:
				{
					loopName= act.getParamExpString (this.rh, 0);
					group= this.groups[act.getParamExpString (this.rh, 1)];
					if(group != null)
					{
						loop = new CRunForEachLoop ();
						loop.name = loopName;
						loop.loopMax = group.size();
						var i:int;
						for(i=0; i<group.size(); i++)
						{
							if (group.get(i)!=null)
							{
								loop.fvs.add(group);
							}
						}
						this.executeForEachLoop (loop);
					}
					break;
				}
				case ACT_ADDOBJECTTOGROUP:
				{
					if(this.ho.hoAdRunHeader.rhEvtProg.rh2ActionLoopCount != 0)
						return;
					
					oi=act.evtParams[0].oiList;                
					this.currentGroup = act.getParamExpString (this.rh, 1);
					group= this.groups[this.currentGroup];
					
					//Create group if it doesn't exist
					if(group == null)
					{
						group = new CArrayList();
						this.groups[currentGroup]=group;
					}
					
					this.selection.filterObjects(this, oi, false, filterGetSelectedForGroup);
					this.currentGroup = null;
					
					break;
				}
				case CRunForEach.ACT_ADDFIXEDTOGROUP:
				{
					fixed= act.getParamExpression (this.rh, 0);
					groupName= act.getParamExpString (this.rh, 1);
					group= this.groups[groupName];
					
					if(fixed == 0)
						break;
					
					//Create group if it doesn't exist
					if(group == null)
					{
						group = new CArrayList();
						this.groups[groupName]=group;
					}
					
					group.add(fixed);
					break;
				}
				case CRunForEach.ACT_REMOVEOBJECTFROMGROUP:
				{
					var object:CObject = act.getParamObject (this.rh, 0);
					var id:int=(object.hoCreationId<<16)|((int(object.hoNumber))&0xFFFF);
					groupName= act.getParamExpString (this.rh, 1);
					group= this.groups[groupName];
					
					if(group == null || object == null)
						break;
					
					group.removeObject(id);
					
					//Delete group if empty
					if(group.size() == 0)
						this.groups.splice(groupName, 1);
					
					break;
				}
				case CRunForEach.ACT_REMOVEFIXEDFROMGROUP:
				{
					fixed= act.getParamExpression (this.rh, 0);
					groupName= act.getParamExpString (this.rh, 1);
					group= this.groups[groupName];
					
					if(group == null || fixed == 0)
						break;
					
					group.removeObject (fixed);
					
					//Delete group if empty
					if(group.size() == 0)
						this.groups.splice(groupName, 1);
					
					break;
				}
			}
		}
		
		public function executeForEachLoop(loop:CRunForEachLoop):void
		{
			//Store current loop
			var prevLoop:CRunForEachLoop = this.currentForEach;
			this.forEachLoops[loop.name]=loop;
			this.currentForEach = loop;
			for(;loop.loopIndex < loop.loopMax; ++loop.loopIndex)
			{
				//Was the loop paused?
				if(loop.paused)
				{
					//Move the fastloop to the 'paused' table
					this.pausedLoops[loop.name]=loop;
					this.forEachLoops.splice(loop.name, 1);
					break;
				}
				this.ho.generateEvent (CRunForEach.CON_ONFOREACHLOOPSTRING, 0);
				
				this.currentLooped = this.ho.getObjectFromFixed(int(loop.fvs.get (loop.loopIndex)));
				if(this.currentLooped != null)
					this.ho.generateEvent (CRunForEach.CON_ONFOREACHLOOPOBJECT, 0);
			}
			//Release the loop?
			if(!loop.paused)
				this.forEachLoops.splice(loop.name, 1);
			
			//Restore the previous loop (in case of nested loops)
			this.currentForEach = prevLoop;
		}
		
		public override function expression(num:int):CValue
		{
			var loop:CRunForEachLoop;
			var ret:CValue=new CValue(0);
			switch(num)
			{
				case EXP_LOOPFV:
				{
					loop= this.forEachLoops[this.ho.getExpParam()];
					if(loop == null)
						break;
					ret.forceInt(int(loop.fvs.get(loop.loopIndex)));
					break;
				}
				case EXP_LOOPITERATION:
				{
					loop= this.forEachLoops[this.ho.getExpParam()];
					if(loop == null)
						break;
					ret.forceInt(loop.loopIndex);
					break;
				}
				case EXP_LOOPMAXITERATION:
				{
					loop= this.forEachLoops[this.ho.getExpParam()];
					if(loop == null)
						break;
					ret.forceInt(loop.loopMax);
					break;
				}
				case CRunForEach.EXP_GROUPSIZE:
				{
					var group:CArrayList = this.groups[this.ho.getExpParam()];
					if(group == null)
						break;
					ret.forceInt(group.size());
					break;
				}
			}
			return ret;
		}    
		
		public function filterPartOfLoop(rdPtr:CRunForEach, object:CObject):Boolean
		{
			var id:int=(object.hoCreationId<<16)|((int(object.hoNumber))&0xFFFF);
			return rdPtr.partOfLoop.fvs.contains(id);
		}
		
		public function filterPartOfGroup(rdPtr:CRunForEach, object:CObject):Boolean
		{
			var id:int=(object.hoCreationId<<16)|((int(object.hoNumber))&0xFFFF);
			return rdPtr.partOfGroup.contains(id);
		}
		//Adds all selected objects to the list of fixed values
		
		public function filterGetSelectedForGroup(rdPtr:CRunForEach, object:CObject):Boolean
		{
			var foreach:CRunForEach = rdPtr;
			var array:CArrayList = foreach.groups[foreach.currentGroup];
			var currentFixed:int = (object.hoCreationId<<16)|((int(object.hoNumber))&0xFFFF);
			
			if(array != null)
			{
				var i:int;
				for(i = 0; i < array.size(); ++ i)
				{
					var fixedInArray:int = int(array.get(i));
					
					if(currentFixed == fixedInArray)
						return true;
				}
				array.add(currentFixed);
			}
			return true; //Don't filter out any objects
		}
		
		//Adds all selected objects to the current group
		public function filterGetSelected(rdPtr:CRunForEach, object:CObject):Boolean
		{
			rdPtr.populateLoop.addObject(object);
			return true; 
		}				
	}
}