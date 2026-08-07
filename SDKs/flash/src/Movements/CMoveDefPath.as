//----------------------------------------------------------------------------------
//
// CMOVEDEFPATH : données du mouvement path
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.*;
	
	public class CMoveDefPath extends CMoveDef
	{
	    public var mtNumber:int;				// Number of movement 
	    public var mtMinSpeed:int; 			// maxs and min speed in the movements 
	    public var mtMaxSpeed:int;
	    public var mtLoop:int;					// Loop at end
	    public var mtRepos:int;				// Reposition at end
	    public var mtReverse:int;				// Pingpong?
	    public var steps:Array;

		public function CMoveDefPath()
		{
		}

	    public override function load(file:CFile, length:int):void
	    {
	        mtNumber=file.readAShort();
	        mtMinSpeed=file.readAShort();
	        mtMaxSpeed=file.readAShort();
	        mtLoop=file.readAByte();	
	        mtRepos=file.readAByte();
	        mtReverse=file.readAByte();
	        file.skipBytes(1);
	
	        steps=new Array(mtNumber);
	        var n:int, next:int;
	        var debut:int;
	        for (n=0; n<mtNumber; n++)
	        {
	            debut=file.getFilePointer();
	            steps[n]=new CPathStep();
	            file.readUnsignedByte();
	            next=file.readUnsignedByte();
	            steps[n].load(file);
	            file.seek(debut+next);
	        }
	    }
	}
}