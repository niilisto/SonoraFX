package Services
{
	import Application.CRunApp;
	
	import Events.CEventProgram;
	import Events.CQualToOiList;
	
	import Objects.CObject;
	
	import RunLoop.CObjInfo;
	import RunLoop.CRun;
	
	public class CObjectSelection
	{
		private var rhPtr:CRunApp;
		private var run:CRun;
		private var eventProgram:CEventProgram;
		private var ObjectList:Array;				//get a pointer to the mmf object list
		private var OiList:Array;						//get a pointer to the mmf object info list
		private var QualToOiList:Array;	//get a pointer to the mmf qualifier to Oi list
		
		public function CObjectSelection(runApp:CRunApp)
		{
			this.rhPtr=runApp;
			this.run= this.rhPtr.run;
			this.eventProgram= this.run.rhEvtProg;
			this.ObjectList= this.run.rhObjectList;				//get a pointer to the mmf object list
			this.OiList= this.run.rhOiList;						//get a pointer to the mmf object info list
			this.QualToOiList= this.eventProgram.qualToOiList;	//get a pointer to the mmf qualifier to Oi list
		}
		
		//Selects *all* objects of the given object-type
		public function selectAll(OiList:int):void
		{
			var pObjectInfo:CObjInfo = this.OiList[OiList];
			
			if(pObjectInfo == null) {
				trace("No ObjectInfo");
				return;
			}
			
			pObjectInfo.oilNumOfSelected = pObjectInfo.oilNObjects;
			pObjectInfo.oilListSelected = pObjectInfo.oilObject;
			pObjectInfo.oilEventCount = this.eventProgram.rh2EventCount;
			
			var i:int = pObjectInfo.oilObject;
			var pObject:CObject;
			while(i >= 0)
			{
				try {
					pObject = this.ObjectList[i];
					pObject.hoNextSelected = pObject.hoNumNext;
					i = pObject.hoNumNext;
				}
				catch (e: RangeError)
				{
					break;
				}
			}
			return;
		}
		
		//Resets all objects of the given object-type
		public function selectNone(OiList:int):void
		{
			var pObjectInfo:CObjInfo = this.OiList[OiList];
			if(pObjectInfo == null)
				return;
			pObjectInfo.oilNumOfSelected = 0;
			pObjectInfo.oilListSelected = -1;
			pObjectInfo.oilEventCount = this.eventProgram.rh2EventCount;
		}
		
		//Resets the SOL and inserts only one given object
		public function selectOneObject(object:CObject):void
		{
			var pObjectInfo:CObjInfo = object.hoOiList;
			pObjectInfo.oilNumOfSelected = 1;
			pObjectInfo.oilEventCount = this.eventProgram.rh2EventCount;
			pObjectInfo.oilListSelected = object.hoNumber;
			this.ObjectList[object.hoNumber].hoNextSelected = -1;
		}
		
		//Resets the SOL and inserts the given list of objects
		public function selectObjects(OiList:int, objects:Array):void
		{
			var pObjectInfo:CObjInfo = this.OiList[OiList];
			
			if(pObjectInfo == null)
				return;
			
			pObjectInfo.oilNumOfSelected = objects.length;
			pObjectInfo.oilEventCount = eventProgram.rh2EventCount;
			
			if (objects.length==0)
				return;
			
			var i:int=0;
			var prevNumber:int = objects[i].hoNumber;
			var currentNumber:int;
			pObjectInfo.oilListSelected = prevNumber;
			while(i<objects.length)
			{
				currentNumber = objects[i++].hoNumber;
				this.ObjectList[prevNumber].hoNextSelected = currentNumber;
				prevNumber = currentNumber;
			}
			this.ObjectList[prevNumber].hoNextSelected = -1;
		}
		
		//Run a custom filter on the SOL (via function callback)
		public function filterObjects(rdPtr:Object, OiList:int, negate:Boolean, filter:Function):Boolean
		{
			if ((OiList & 0x8000) != 0)
			{
				return ((this.filterQualifierObjects(rdPtr, OiList & 0x7FFF, negate, filter) ? 1 : 0) ^ (negate ? 1 : 0)) != 0;
			}
			return ((this.filterNonQualifierObjects(rdPtr, OiList, negate, filter) ? 1 : 0) ^ (negate ? 1 : 0)) != 0;
		}
		
		//Filter qualifier objects
		public function filterQualifierObjects(rdPtr:Object, OiList:int, negate:Boolean, filter:Function):Boolean
		{
			var CurrentQualToOi:CQualToOiList = this.QualToOiList[OiList];
			
			var hasSelected:Boolean = false;
			var i:int = 0;
			
			while(i<CurrentQualToOi.qoiList.length)
			{
				var CurrentOi:int = CurrentQualToOi.qoiList[i+1];
				hasSelected = (((hasSelected ? 1 : 0) |
					(this.filterNonQualifierObjects(rdPtr, CurrentOi, negate, filter) ? 1 : 0))) != 0;
				
				i+=2;
			}
			return hasSelected;
		}
		
		//Filter normal objects
		public function filterNonQualifierObjects(rdPtr:Object, OiList:int, negate:Boolean, filter:Function):Boolean
		{
			var pObjectInfo:CObjInfo = this.OiList[OiList];
			if(pObjectInfo == null)
				return false;
			var hasSelected:Boolean = false;
			if (pObjectInfo.oilEventCount != this.eventProgram.rh2EventCount)
			{
				this.selectAll(OiList);	//The SOL is invalid, must reset.
			}
			
			//If SOL is empty
			if(pObjectInfo.oilNumOfSelected <= 0)
			{
				return false;
			}
			
			var firstSelected:int = -1;
			var count:int = 0;
			var current:int = pObjectInfo.oilListSelected;
			var previous:CObject = null;
			
			while(current>=0)
			{
				var pObject:CObject = this.ObjectList[current];
				var filterResult:Boolean = filter(rdPtr, pObject);
				var useObject:Boolean = ((filterResult ? 1 : 0) ^ (negate ? 1 : 0)) != 0;
				hasSelected = ((hasSelected ? 1 : 0) | (useObject ? 1 : 0)) != 0;
				
				if(useObject)
				{
					if(firstSelected == -1)
					{
						firstSelected = current;
					}
					
					if(previous != null)
					{
						previous.hoNextSelected = current;
					}
					
					previous = pObject;
					count++;
				}
				current = pObject.hoNextSelected;
			}
			if(previous != null)
			{
				previous.hoNextSelected = -1;
			}
			
			pObjectInfo.oilListSelected = firstSelected;
			pObjectInfo.oilNumOfSelected = count;
			
			return hasSelected;
		}
		
		//Return the number of selected objects for the given object-type
		public function getNumberOfSelected(OiList:int):int
		{
			if((OiList & 0x8000) != 0)
			{
				OiList &= 0x7FFF;	//Mask out the qualifier part
				var numberSelected:int = 0;
				
				var CurrentQualToOi:CQualToOiList= this.QualToOiList[OiList];
				
				var i:int = 0;
				while(i<CurrentQualToOi.qoiList.length)
				{
					var CurrentOi:CObjInfo = this.OiList[CurrentQualToOi.qoiList[i+1]];
					numberSelected += CurrentOi.oilNumOfSelected;
					i+=2;
				}
				return numberSelected;
			}
			else
			{
				var pObjectInfo:CObjInfo = this.OiList[OiList];
				return pObjectInfo.oilNumOfSelected;
			}
		}
		
		public function objectIsOfType(obj:CObject, OiList:int):Boolean
		{
			if((OiList & 0x8000) != 0)
			{
				OiList &= 0x7FFF;	//Mask out the qualifier part
				var CurrentQualToOi:CQualToOiList= this.QualToOiList[OiList];
				
				var i:int = 0;
				while(i<CurrentQualToOi.qoiList.length)
				{
					var CurrentOi:CObjInfo = this.OiList[CurrentQualToOi.qoiList[i+1]];
					if(CurrentOi.oilOi == obj.hoOi)
						return true;
					i+=2;
				}
				return false;
			}
			return (obj.hoOi == this.OiList[OiList].oilOi);
		}
		
		//Returns the object-info structure from a given object-type
		public function GetOILFromOI(Oi:int):CObjInfo
		{
			var i:int;
			for(i=0; i < this.run.rhMaxOI; ++i)
			{
				var oil:CObjInfo = this.OiList[i];
				if(oil.oilOi == Oi)
					return oil;
			}
			return null;
		}
	}
}