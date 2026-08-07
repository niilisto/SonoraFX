//----------------------------------------------------------------------------------
//
// CMOVEDEFLIST : liste des mouvements d'un objet'
//
//----------------------------------------------------------------------------------

package Movements
{
	import Services.CFile;
	
	public class CMoveDefList
	{
    	public var nMovements:int;
    	public var moveList:Array;
    
		public function CMoveDefList()		
		{
		}
	    public function load(file:CFile):void
	    {
	        var debut:int=file.getFilePointer();
	        nMovements=file.readAInt();
	        moveList=new Array(nMovements);
	        var n:int;
	        for (n=0; n<nMovements; n++)
	        {
	            file.seek(debut+4+16*n);              // sizeof(MvtHrd)
	            
	            // Lis les donnée
	            var moduleNameOffset:int=file.readAInt();
	            var mvtID:int=file.readAInt();
	            var dataOffset:int=file.readAInt();
	            var dataLength:int=file.readAInt();
	        
	            // Lis le debut du header movement
	            file.seek(debut+dataOffset);
	            var control:int=file.readAShort();
	            var type:int=file.readAShort();
	            var move:int=file.readAByte();
	            var mo:int=file.readAByte();
	            file.skipBytes(2);	           
	            var dirAtStart:int=file.readAInt();
	            switch (type)
	            {
	                // MVTYPE_STATIC
	                case 0:
	                    moveList[n]=new CMoveDefStatic();
	                    break;
	                // MVTYPE_MOUSE
	                case 1:
	                    moveList[n]=new CMoveDefMouse();
	                    break;
	                // MVTYPE_RACE
	                case 2:
	                    moveList[n]=new CMoveDefRace();
	                    break;
	                // MVTYPE_GENERIC
	                case 3:
	                    moveList[n]=new CMoveDefGeneric();
	                    break;
	                // MVTYPE_BALL
	                case 4:
	                    moveList[n]=new CMoveDefBall();
	                    break;
	                // MVTYPE_TAPED
	                case 5:
	                    moveList[n]=new CMoveDefPath();
	                    break;
	                // MVTYPE_PLATFORM
	                case 9:
	                    moveList[n]=new CMoveDefPlatform();
	                    break;
	                // MVTYPE_EXT				
	                case 14:
	                    moveList[n]=new CMoveDefExtension();
	                    break;
	            }
	            moveList[n].setData(type, control, move, dirAtStart, mo);
	            moveList[n].load(file, dataLength-12);
	            if (type==14)       // MVTYPE_EXT
	            {
	                file.seek(debut+moduleNameOffset);
	                var name:String=file.readAString();
					name=name.substring(0, name.length-4);
	                CMoveDefExtension(moveList[n]).setModuleName(name, mvtID);
	            }
	        }
	    }
	}
}