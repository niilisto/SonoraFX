/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
/**
 * by Greyhill
 * @author Admin
 */
package Extensions;

import Expressions.CValue;

public class KcArrayExpr 
{
	public static int	ARRAY_TYPENUM = 0x0001;
	public static int	ARRAY_TYPETXT = 0x0002;
	public static int	INDEX_BASE1 = 0x0004;

	static final int EXP_INDEXA = 0;
	static final int EXP_INDEXB = 1;
	static final int EXP_INDEXC = 2;
	static final int EXP_READVALUE = 3;
	static final int EXP_READSTRING = 4;
	static final int EXP_READVALUE_X = 5;
	static final int EXP_READVALUE_XY = 6;
	static final int EXP_READVALUE_XYZ = 7;
	static final int EXP_READSTRING_X = 8;
	static final int EXP_READSTRING_XY = 9;
	static final int EXP_READSTRING_XYZ = 10;
	static final int EXP_DIMX = 11;
	static final int EXP_DIMY = 12;
	static final int EXP_DIMZ = 13;

	public static CValue get(int num, CRunKcArray thisObject)
	{
		switch (num)
		{
		case EXP_INDEXA:
			return IndexA(thisObject);
		case EXP_INDEXB:  
			return IndexB(thisObject);
		case EXP_INDEXC:
			return IndexC(thisObject);
		case EXP_READVALUE:
			return ReadValue(thisObject);
		case EXP_READSTRING:
			return ReadString(thisObject);
		case EXP_READVALUE_X:
			return ReadValue_X(thisObject, thisObject.ho.getExpParam().getInt());
		case EXP_READVALUE_XY:
			return ReadValue_XY(thisObject, 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt());
		case EXP_READVALUE_XYZ:
			return ReadValue_XYZ(thisObject, 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt());
		case EXP_READSTRING_X:
			return ReadString_X(thisObject, thisObject.ho.getExpParam().getInt());
		case EXP_READSTRING_XY:
			return ReadString_XY(thisObject, 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt());
		case EXP_READSTRING_XYZ:
			return ReadString_XYZ(thisObject, 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt(), 
					thisObject.ho.getExpParam().getInt());
		case EXP_DIMX:
			return Exp_DimX(thisObject);
		case EXP_DIMY:
			return Exp_DimY(thisObject);
		case EXP_DIMZ:
			return Exp_DimZ(thisObject);
		}
		return new CValue(0);//won't be used
	}
	private static CValue IndexA(CRunKcArray thisObject) 
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexA + 1);
		}
		else
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexA);
		}
		return thisObject.tempValue;
	}
	private static CValue IndexB(CRunKcArray thisObject)
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexB + 1);
		}
		else
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexB);
		}
		return thisObject.tempValue;
	}
	private static CValue IndexC(CRunKcArray thisObject)
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexC + 1);
		}
		else
		{
			thisObject.tempValue.forceInt(thisObject.pArray.lIndexC);
		}
		return thisObject.tempValue;
	}
	private static CValue ReadValue(CRunKcArray thisObject)
	{
		return ReadValueXYZ(thisObject, 
				thisObject.pArray.lIndexA, 
				thisObject.pArray.lIndexB, 
				thisObject.pArray.lIndexC);
	}
	private static CValue ReadString(CRunKcArray thisObject) 
	{
		return ReadStringXYZ(thisObject, 
				thisObject.pArray.lIndexA, 
				thisObject.pArray.lIndexB, 
				thisObject.pArray.lIndexC);
	}

	private static CValue ReadValue_X(CRunKcArray thisObject, int x)
	{
		return ReadValueXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				thisObject.pArray.lIndexB, 
				thisObject.pArray.lIndexC);
	}
	private static CValue ReadValue_XY(CRunKcArray thisObject, int x, int y)
	{
		return ReadValueXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				y - thisObject.pArray.oneBased(), 
				thisObject.pArray.lIndexC);
	}
	private static CValue ReadValue_XYZ(CRunKcArray thisObject, int x, int y, int z)
	{	
		return ReadValueXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				y - thisObject.pArray.oneBased(), 
				z - thisObject.pArray.oneBased());
	}
	private static CValue ReadValueXYZ(CRunKcArray thisObject, int x, int y, int z)
	{	
		//x y z should be fixed for 1-based, if so
		if (( x < 0) || (y < 0) || (z < 0 ))
		{
			thisObject.tempValue.forceInt(0);
			return thisObject.tempValue;
		}
		if ((thisObject.pArray.lFlags & ARRAY_TYPENUM) != 0)
		{
			if ((x < thisObject.pArray.lDimensionX) && (y < thisObject.pArray.lDimensionY) && (z < thisObject.pArray.lDimensionZ))
			{
				thisObject.tempValue.forceInt(thisObject.pArray.numberArray[z][y][x]);
				return thisObject.tempValue;
			}
		}
		thisObject.tempValue.forceInt(0);
		return thisObject.tempValue;
	}
	private static CValue ReadString_X(CRunKcArray thisObject, int x)
	{
		return ReadStringXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				thisObject.pArray.lIndexB, 
				thisObject.pArray.lIndexC);
	}
	private static CValue ReadString_XY(CRunKcArray thisObject, int x, int y)
	{
		return ReadStringXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				y - thisObject.pArray.oneBased(), 
				thisObject.pArray.lIndexC);
	}
	private static CValue ReadString_XYZ(CRunKcArray thisObject, int x, int y, int z)
	{	
		return ReadStringXYZ(thisObject, 
				x - thisObject.pArray.oneBased(), 
				y - thisObject.pArray.oneBased(), 
				z - thisObject.pArray.oneBased());
	}
	private static CValue ReadStringXYZ(CRunKcArray thisObject, int x, int y, int z)
	{	
		//x y z should be fixed for 1-based, if so
		if (( x < 0) || (y < 0) || (z < 0 ))
		{
			thisObject.tempValue.forceString("");
			return thisObject.tempValue;
		}
		if ((thisObject.pArray.lFlags & ARRAY_TYPETXT) != 0)
		{
			if ((x < thisObject.pArray.lDimensionX) && (y < thisObject.pArray.lDimensionY) && (z < thisObject.pArray.lDimensionZ))
			{
				String r = thisObject.pArray.stringArray[z][y][x];
				if (r != null)
				{
					thisObject.tempValue.forceString(r);
					return thisObject.tempValue;
				}
			}          
		}
		thisObject.tempValue.forceString("");
		return thisObject.tempValue;
	}
	private static CValue Exp_DimX(CRunKcArray thisObject)
	{
		thisObject.tempValue.forceInt(thisObject.pArray.lDimensionX);
		return thisObject.tempValue;
	}
	private static CValue Exp_DimY(CRunKcArray thisObject)
	{
		thisObject.tempValue.forceInt(thisObject.pArray.lDimensionY);
		return thisObject.tempValue;
	}
	private static CValue Exp_DimZ(CRunKcArray thisObject)
	{
		thisObject.tempValue.forceInt(thisObject.pArray.lDimensionZ);
		return thisObject.tempValue;
	}


}
