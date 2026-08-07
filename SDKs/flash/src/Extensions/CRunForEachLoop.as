package Extensions
{
	import Services.CArrayList;
	import Objects.CObject;
	
	public class CRunForEachLoop
	{
		public var name:String;
		public var fvs:CArrayList;
		public var loopIndex:int;
		public var loopMax:int;
		public var paused:Boolean;	

		public function CRunForEachLoop()
		{
			this.name=null;
			this.fvs=new CArrayList();
			this.loopIndex=0;
			this.loopMax=0;
			this.paused=false;	
		}
		public function addObject(object:CObject):void
		{
			var id:int=(object.hoCreationId<<16)|((int(object.hoNumber))&0xFFFF);
			this.fvs.add(id);
		}
		
		public function addFixed(fixed:int):void
		{
			this.fvs.add(fixed);
		}
	}
}