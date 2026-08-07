//----------------------------------------------------------------------------------
//
// CRunKcArray: array object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	import Application.*;

	public class CRunKcArray extends CRunExtension
	{
	    public static var ARRAY_GLOBAL:int = 0x0008;    
	
	    public static var ARRAY_TYPENUM:int = 0x0001;
	    public static var ARRAY_TYPETXT:int = 0x0002;
	    public static var INDEX_BASE1:int = 0x0004;
    
	    public static var ACT_SETINDEXA:int = 0;
	    public static var ACT_SETINDEXB:int = 1;
	    public static var ACT_SETINDEXC:int = 2;
	    public static var ACT_ADDINDEXA:int = 3;
	    public static var ACT_ADDINDEXB:int = 4;
	    public static var ACT_ADDINDEXC:int = 5;
	    public static var ACT_WRITEVALUE:int = 6;
	    public static var ACT_WRITESTRING:int = 7;
	    public static var ACT_CLEARARRAY:int = 8;
	    public static var ACT_LOAD:int = 9;
	    public static var ACT_LOADSELECTOR:int = 10;
	    public static var ACT_SAVE:int	= 11;
	    public static var ACT_SAVESELECTOR:int	= 12;
	    public static var ACT_WRITEVALUE_X:int	= 13;
	    public static var ACT_WRITEVALUE_XY:int = 14;
	    public static var ACT_WRITEVALUE_XYZ:int = 15;
	    public static var ACT_WRITESTRING_X:int = 16;
	    public static var ACT_WRITESTRING_XY:int = 17;
	    public static var ACT_WRITESTRING_XYZ:int = 18;
	    
	    public static var CND_INDEXAEND:int = 0;
	    public static var CND_INDEXBEND:int = 1;
	    public static var CND_INDEXCEND:int = 2;
	
	    public static var EXP_INDEXA:int = 0;
	    public static var EXP_INDEXB:int = 1;
	    public static var EXP_INDEXC:int = 2;
	    public static var EXP_READVALUE:int = 3;
	    public static var EXP_READSTRING:int = 4;
	    public static var EXP_READVALUE_X:int = 5;
	    public static var EXP_READVALUE_XY:int = 6;
	    public static var EXP_READVALUE_XYZ:int = 7;
	    public static var EXP_READSTRING_X:int = 8;
	    public static var EXP_READSTRING_XY:int = 9;
	    public static var EXP_READSTRING_XYZ:int = 10;
	    public static var EXP_DIMX:int = 11;
	    public static var EXP_DIMY:int = 12;
	    public static var EXP_DIMZ:int = 13;
	    
	    public var pArray:CRunKcArrayData;
	    
	    public override function getNumberOfConditions():int
	    {
	        return 3;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        var rhPtr:CRun = this.ho.hoAdRunHeader;
	
	        var lDimensionX:int = file.readInt();
	        var lDimensionY:int = file.readInt();
	        var lDimensionZ:int = file.readInt();
	        var lFlags:int = file.readInt();
	
	        var pData:CRunKcArrayCGlobalDataList = null;
	        if ((lFlags & ARRAY_GLOBAL) != 0)
	        {
	            var pExtData:CExtStorage = rhPtr.getStorage(ho.hoIdentifier);
	            if (pExtData == null) //first global object of this type
	            {
	                pArray = new CRunKcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
	                pData = new CRunKcArrayCGlobalDataList();
	                pData.AddObject(this);
	                rhPtr.addStorage(pData, ho.hoIdentifier);
	            }
	            else
	            {
	                pData = CRunKcArrayCGlobalDataList(pExtData);
	                var found:CRunKcArrayData = pData.FindObject(ho.hoOiList.oilName);
	                if (found != null) //found array object of same name
	                {
	                    pArray = found; //share data
	                }
	                else
	                {
	                    pArray = new CRunKcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
	                    pData.AddObject(this);
	                }
	            }
	        }
	        else
	        {
	            pArray = new CRunKcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
	        }
	        return true;
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_INDEXAEND:
	                return EndIndexA();
	            case CND_INDEXBEND:
	                return EndIndexB();
	            case CND_INDEXCEND:
	                return EndIndexC();
	        }
	        return false;
	    }

	    public function EndIndexA():Boolean
	    {
	        if (pArray.lIndexA >= pArray.lDimensionX - 1)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function EndIndexB():Boolean
	    {
	        if (pArray.lIndexB >= pArray.lDimensionY - 1)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function EndIndexC():Boolean
	    {
	        if (pArray.lIndexC >= pArray.lDimensionZ - 1)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SETINDEXA:
	                SetIndexA(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETINDEXB:
	                SetIndexB(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETINDEXC:
	                SetIndexC(act.getParamExpression(rh, 0));
	                break;
	            case ACT_ADDINDEXA:
	                IncIndexA();
	                break;
	            case ACT_ADDINDEXB:
	                IncIndexB();
	                break;
	            case ACT_ADDINDEXC:
	                IncIndexC();
	                break;
	            case ACT_WRITEVALUE:
	                WriteValue(act.getParamExpression(rh, 0));
	                break;
	            case ACT_WRITESTRING:
	                WriteString(act.getParamExpString(rh, 0));
	                break;
	            case ACT_CLEARARRAY:
	                ClearArray();
	                break;
	            case ACT_LOAD:
	                load(parseName(act.getParamFilename(rh, 0)));
	                break;
	            case ACT_LOADSELECTOR:
	                break;
	            case ACT_SAVE:
					save(parseName(act.getParamFilename(rh, 0)));
	                break;
	            case ACT_SAVESELECTOR:
	                break;
	            case ACT_WRITEVALUE_X:
	                WriteValue_X(act.getParamExpression(rh, 0),
	                        act.getParamExpression(rh, 1));
	                break;
	            case ACT_WRITEVALUE_XY:
	                WriteValue_XY(act.getParamExpression(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2));
	                break;
	            case ACT_WRITEVALUE_XYZ:
	                WriteValue_XYZ(act.getParamExpression(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2),
	                        act.getParamExpression(rh, 3));
	                break;
	            case ACT_WRITESTRING_X:
	                WriteString_X(act.getParamExpString(rh, 0),
	                        act.getParamExpression(rh, 1));
	                break;
	            case ACT_WRITESTRING_XY:
	                WriteString_XY(act.getParamExpString(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2));
	                break;
	            case ACT_WRITESTRING_XYZ:
	                WriteString_XYZ(act.getParamExpString(rh, 0),
	                        act.getParamExpression(rh, 1),
	                        act.getParamExpression(rh, 2),
	                        act.getParamExpression(rh, 3));
	                break;
	        }
	    }
		private function parseName(name:String):String
		{
			var pos:int=name.lastIndexOf("\\");
			if (pos>0)
			{
				name=name.substring(pos+1);
			}
			return name;	    			
		}	    
	    public function SetIndexA(i:int):void
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            pArray.lIndexA = i - 1;
	        }
	        else
	        {
	            pArray.lIndexA = i;
	        }
	    }
	
	    public function SetIndexB(i:int):void
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            pArray.lIndexB = i - 1;
	        }
	        else
	        {
	            pArray.lIndexB = i;
	        }
	    }
	
	    public function SetIndexC(i:int):void
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            pArray.lIndexC = i - 1;
	        }
	        else
	        {
	            pArray.lIndexC = i;
	        }
	    }
	
	    public function IncIndexA():void
	    {
	        pArray.lIndexA++;
	    }
	
	    public function IncIndexB():void
	    {
	        pArray.lIndexB++;
	    }
	
	    public function IncIndexC():void
	    {
	        pArray.lIndexC++;
	    }
	
	    public function WriteValue(value:int):void
	    {
	        WriteValueXYZ(value, pArray.lIndexA, pArray.lIndexB, pArray.lIndexC);
	    }
	
	    public function WriteString(value:String):void
	    {
	        WriteStringXYZ(value, pArray.lIndexA, pArray.lIndexB, pArray.lIndexC);
	    }
	
	    public function ClearArray():void
	    {
	        pArray.clean();
	    }
	
	    public function WriteValue_X(value:int, x:int):void
	    {
	        x -= pArray.oneBased();
	        WriteValueXYZ(value, x, pArray.lIndexB, pArray.lIndexC);
	    }
	
	    public function WriteValue_XY(value:int, x:int, y:int):void
	    {
	        x -= pArray.oneBased();
	        y -= pArray.oneBased();
	        WriteValueXYZ(value, x, y, pArray.lIndexC);
	    }
	
	    public function WriteValue_XYZ(value:int, x:int, y:int, z:int):void
	    {
	        x -= pArray.oneBased();
	        y -= pArray.oneBased();
	        z -= pArray.oneBased();
	        WriteValueXYZ(value, x, y, z);
	    }
	
	    public function WriteValueXYZ(value:int, x:int, y:int, z:int):void
	    {
	        //x,y,z should be fixed for 1-based index if used before this function
	        if ((x < 0) || (y < 0) || (z < 0))
	        {
	            return;
	        }
	        if ((pArray.lFlags & ARRAY_TYPENUM) != 0)
	        {
	            // Expand if required
	            if ((x >= pArray.lDimensionX) || (y >= pArray.lDimensionY) || (z >= pArray.lDimensionZ))
	            {
	                var newDimX:int = Math.max(pArray.lDimensionX, x + 1);
	                var newDimY:int = Math.max(pArray.lDimensionY, y + 1);
	                var newDimZ:int = Math.max(pArray.lDimensionZ, z + 1);
	                pArray.expand(newDimX, newDimY, newDimZ);
	            }
	            //write
	            pArray.lIndexA = x;
	            pArray.lIndexB = y;
	            pArray.lIndexC = z;
	            pArray.numberArray[z*pArray.lDimensionY*pArray.lDimensionX+y*pArray.lDimensionX+x] = value;
	        }
	    }
	
	    public function WriteString_X(value:String, x:int):void
	    {
	        x -= pArray.oneBased();
	        WriteStringXYZ(value, x, pArray.lIndexB, pArray.lIndexC);
	    }
	
	    public function WriteString_XY(value:String, x:int, y:int):void
	    {
	        x -= pArray.oneBased();
	        y -= pArray.oneBased();
	        WriteStringXYZ(value, x, y, pArray.lIndexC);
	    }
	
	    public function WriteString_XYZ(value:String, x:int, y:int, z:int):void
	    {
	        x -= pArray.oneBased();
	        y -= pArray.oneBased();
	        z -= pArray.oneBased();
	        WriteStringXYZ(value, x, y, z);
	    }
	
	    public function WriteStringXYZ(value:String, x:int, y:int, z:int):void
	    {
	        //x,y,z should be fixed for 1-based index if used before this function
	        if ((x < 0) || (y < 0) || (z < 0))
	        {
	            return;
	        }
	        if ((pArray.lFlags & ARRAY_TYPETXT) != 0)
	        {
	            // Expand if required
	            if ((x >= pArray.lDimensionX) || (y >= pArray.lDimensionY) || (z >= pArray.lDimensionZ))
	            {
	                var newDimX:int = Math.max(pArray.lDimensionX, x + 1);
	                var newDimY:int = Math.max(pArray.lDimensionY, y + 1);
	                var newDimZ:int = Math.max(pArray.lDimensionZ, z + 1);
	                pArray.expand(newDimX, newDimY, newDimZ);
	            }
	            //write
	            pArray.lIndexA = x;
	            pArray.lIndexB = y;
	            pArray.lIndexC = z;
	            pArray.stringArray[z*pArray.lDimensionY*pArray.lDimensionX+y*pArray.lDimensionX+x] = value;
	        }
	    }

	    public function load(fileName:String):void
	    {
			var x:int, y:int, z:int;
			
            //String t = thisObject.ho.getFile(fileName);
            var file:CBinaryFile = rh.rhApp.openFile(fileName);
			if (file!=null)
			{
				file.bUnicode=false;
	            var headerHead:String=file.readStringSize(9);
	            var newArray:Array;
	            if (headerHead=="CNC ARRAY" || headerHead=="MFU ARRAY")
	            {
					file.skipBytes(1);

					if (headerHead=="MFU ARRAY")
						file.bUnicode=true;

	                var version:int = file.readShort();
	                var revision:int = file.readShort();
	                if (((version == 1) || (version == 2)) && (revision == 0))
	                {
	                    var dimX:int = file.readInt();
	                    var dimY:int = file.readInt();
	                    var dimZ:int = file.readInt();
	                    var flags:int = file.readInt();
	                    //header read
	                    if ((dimX >= 0) && (dimY >= 0) && (dimZ >= 0))
	                    {
	                        if ((flags & ARRAY_TYPENUM) != 0)
	                        {
	                            newArray = new Array(dimZ*dimY*dimX);
	                            for (z = 0; z < dimZ; z++)
	                            {
	                                for (y = 0; y < dimY; y++)
	                                {
	                                    for (x = 0; x < dimX; x++)
	                                    {
	                                        newArray[z*dimY*dimX+y*dimX+x] = file.readInt();
	                                    }
	                                }
	                            }
	                            //if no try error thus far
	                            pArray.lFlags = flags;
	                            pArray.lDimensionX = dimX;
	                            pArray.lDimensionY = dimY;
	                            pArray.lDimensionZ = dimZ;
	                            pArray.lIndexA = 0;
	                            pArray.lIndexB = 0;
	                            pArray.lIndexC = 0;
	                            pArray.numberArray = newArray;
	                            //fin
	                        }
	                        else if ((flags & ARRAY_TYPETXT) != 0)
	                        {
	                            newArray = new Array(dimZ*dimY*dimX);                           
	                            for (z = 0; z < dimZ; z++)
	                            {
	                                for (y = 0; y < dimY; y++)
	                                {
	                                    for (x = 0; x < dimX; x++)
	                                    {
	                                        var length:int = file.readInt();
	                                        if (length>0)
	                                        {
	                                            newArray[z*dimY*dimX+y*dimX+x] = file.readStringSize(length);
	                                        }
	                                    }
	                                }
	                            }
	                            //if no try error thus far
	                            pArray.lFlags = flags;
	                            pArray.lDimensionX = dimX;
	                            pArray.lDimensionY = dimY;
	                            pArray.lDimensionZ = dimZ;
	                            pArray.lIndexA = 0;
	                            pArray.lIndexB = 0;
	                            pArray.lIndexC = 0;
	                            pArray.stringArray = newArray;
	                            //fin
	                        }
	                    }
	                }
	            }
				rh.rhApp.closeFile(fileName);
			}
	    }

		private function save(fileName:String):void
		{
			var file:CBinaryFile = new CBinaryFile(null, false);
			
			file.writeString("CNC ARRAY");
			file.writeByte(0);
			file.writeShort(2);//version
			file.writeShort(0);//revision
			file.writeInt(pArray.lDimensionX);
			file.writeInt(pArray.lDimensionY);
			file.writeInt(pArray.lDimensionZ);
			file.writeInt(pArray.lFlags);
			var z:int, y:int, x:int;
			if ((pArray.lFlags & ARRAY_TYPENUM) != 0)
			{
				//reverse loop order for save
				for (z = 0; z < pArray.lDimensionZ; z++)
				{
					for (y=0; y < pArray.lDimensionY; y++)
					{ 
						for (x = 0; x < pArray.lDimensionX; x++)
						{
							file.writeInt(pArray.numberArray[z * pArray.lDimensionY * pArray.lDimensionX + y * pArray.lDimensionX + x]);
						}
					}
				}
			}
			else if ((pArray.lFlags & ARRAY_TYPETXT) != 0)
			{
				//reverse loop order for save
				for (z= 0; z < pArray.lDimensionZ; z++)
				{
					for (y= 0; y < pArray.lDimensionY; y++)
					{
						for (x= 0; x < pArray.lDimensionX; x++)
						{
							var g:String = pArray.stringArray[z * pArray.lDimensionY * pArray.lDimensionX + y * pArray.lDimensionX + x];
							if (g == null)
							{
								file.writeInt(0);
							}
							else
							{
								file.writeInt(g.length);
								if (g.length > 0)
								{
									file.writeString(g);
								}
							}
						}
					}
				}
			}
			
			file.save(fileName);
		}
		
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_INDEXA:
	                return IndexA();
	            case EXP_INDEXB:
	                return IndexB();
	            case EXP_INDEXC:
	                return IndexC();
	            case EXP_READVALUE:
	                return ReadValue();
	            case EXP_READSTRING:
	                return ReadString();
	            case EXP_READVALUE_X:
	                return ReadValue_X(ho.getExpParam().getInt());
	            case EXP_READVALUE_XY:
	                return ReadValue_XY(ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt());
	            case EXP_READVALUE_XYZ:
	                return ReadValue_XYZ(ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt());
	            case EXP_READSTRING_X:
	                return ReadString_X(ho.getExpParam().getInt());
	            case EXP_READSTRING_XY:
	                return ReadString_XY(ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt());
	            case EXP_READSTRING_XYZ:
	                return ReadString_XYZ(ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt(),
	                        ho.getExpParam().getInt());
	            case EXP_DIMX:
	                return Exp_DimX();
	            case EXP_DIMY:
	                return Exp_DimY();
	            case EXP_DIMZ:
	                return Exp_DimZ();
	        }
	        return new CValue(0);//won't be used
	    }

	    public function IndexA():CValue
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            return new CValue(pArray.lIndexA + 1);
	        }
	        else
	        {
	            return new CValue(pArray.lIndexA);
	        }
	    }
	
	    public function IndexB():CValue
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            return new CValue(pArray.lIndexB + 1);
	        }
	        else
	        {
	            return new CValue(pArray.lIndexB);
	        }
	    }
	
	    public function IndexC():CValue
	    {
	        if ((pArray.lFlags & INDEX_BASE1) != 0)
	        {
	            return new CValue(pArray.lIndexC + 1);
	        }
	        else
	        {
	            return new CValue(pArray.lIndexC);
	        }
	    }
	
	    public function ReadValue():CValue
	    {
	        return ReadValueXYZ(pArray.lIndexA,
	                pArray.lIndexB,
	                pArray.lIndexC);
	    }
	
	    public function ReadString():CValue
	    {
	        return ReadStringXYZ(pArray.lIndexA,
	                pArray.lIndexB,
	                pArray.lIndexC);
	    }
	
	    public function ReadValue_X(x:int):CValue
	    {
	        return ReadValueXYZ(x - pArray.oneBased(),
	                pArray.lIndexB,
	                pArray.lIndexC);
	    }
	
	    public function ReadValue_XY(x:int, y:int):CValue
	    {
	        return ReadValueXYZ(x - pArray.oneBased(),
	                y - pArray.oneBased(),
	                pArray.lIndexC);
	    }
	
	    public function ReadValue_XYZ(x:int, y:int, z:int):CValue
	    {
	        return ReadValueXYZ(x - pArray.oneBased(),
	                y - pArray.oneBased(),
	                z - pArray.oneBased());
	    }
	
	    public function ReadValueXYZ(x:int, y:int, z:int):CValue
	    {
	        //x y z should be fixed for 1-based, if so
	        if ((x < 0) || (y < 0) || (z < 0))
	        {
	            return new CValue(0);
	        }
	        if ((pArray.lFlags & ARRAY_TYPENUM) != 0)
	        {
	            if ((x < pArray.lDimensionX) && (y < pArray.lDimensionY) && (z < pArray.lDimensionZ))
	            {
	                return new CValue(pArray.numberArray[z*pArray.lDimensionY*pArray.lDimensionX+y*pArray.lDimensionX+x]);
	            }
	        }
	        return new CValue(0);
	    }
	
	    public function ReadString_X(x:int):CValue
	    {
	        return ReadStringXYZ(x - pArray.oneBased(),
	                pArray.lIndexB,
	                pArray.lIndexC);
	    }
	
	    public function ReadString_XY(x:int, y:int):CValue
	    {
	        return ReadStringXYZ(x - pArray.oneBased(),
	                y - pArray.oneBased(),
	                pArray.lIndexC);
	    }
	
	    public function ReadString_XYZ(x:int, y:int, z:int):CValue
	    {
	        return ReadStringXYZ(x - pArray.oneBased(),
	                y - pArray.oneBased(),
	                z - pArray.oneBased());
	    }
	
	    public function ReadStringXYZ(x:int, y:int, z:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
			ret.forceString("");
			
	        //x y z should be fixed for 1-based, if so
	        if ((x < 0) || (y < 0) || (z < 0))
	        {
				ret.forceString("");	        	
	        }
	        if ((pArray.lFlags & ARRAY_TYPETXT) != 0)
	        {
	            if ((x < pArray.lDimensionX) && (y < pArray.lDimensionY) && (z < pArray.lDimensionZ))
	            {
	                var r:String = pArray.stringArray[z*pArray.lDimensionY*pArray.lDimensionX+y*pArray.lDimensionX+x];
	                if (r != null)
	                {
	                	ret.forceString(r);
	                }
	            }
	        }
	        return ret;
	    }
	
	    public function Exp_DimX():CValue
	    {
	        return new CValue(pArray.lDimensionX);
	    }
	
	    public function Exp_DimY():CValue
	    {
	        return new CValue(pArray.lDimensionY);
	    }
	
	    public function Exp_DimZ():CValue
	    {
	        return new CValue(pArray.lDimensionZ);
	    }

	}
}