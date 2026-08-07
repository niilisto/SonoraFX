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

import java.io.BufferedOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import Actions.CActExtension;
import Application.CRunApp.HFile;
import Runtime.MMFRuntime;


public class KcArrayActs 
{
	public static int	ARRAY_TYPENUM = 0x0001;
	public static int	ARRAY_TYPETXT = 0x0002;
	public static int	INDEX_BASE1 = 0x0004;

	static final int ACT_SETINDEXA = 0;
	static final int ACT_SETINDEXB = 1;
	static final int ACT_SETINDEXC = 2;
	static final int ACT_ADDINDEXA = 3;
	static final int ACT_ADDINDEXB = 4;
	static final int ACT_ADDINDEXC = 5;
	static final int ACT_WRITEVALUE = 6;
	static final int ACT_WRITESTRING = 7;
	static final int ACT_CLEARARRAY = 8;
	static final int ACT_LOAD = 9;
	static final int ACT_LOADSELECTOR = 10;
	static final int ACT_SAVE	= 11;
	static final int ACT_SAVESELECTOR	= 12;
	static final int ACT_WRITEVALUE_X	= 13;
	static final int ACT_WRITEVALUE_XY = 14;
	static final int ACT_WRITEVALUE_XYZ = 15;
	static final int ACT_WRITESTRING_X = 16;
	static final int ACT_WRITESTRING_XY = 17;
	static final int ACT_WRITESTRING_XYZ = 18;

	public static void action(int num, CActExtension act, CRunKcArray thisObject)
	{
		switch (num)
		{        
		case ACT_SETINDEXA:
			SetIndexA(thisObject, act.getParamExpression(thisObject.rh, 0));
			break;        
		case ACT_SETINDEXB:       
			SetIndexB(thisObject, act.getParamExpression(thisObject.rh, 0));
			break;
		case ACT_SETINDEXC:       
			SetIndexC(thisObject, act.getParamExpression(thisObject.rh, 0));
			break;
		case ACT_ADDINDEXA:
			IncIndexA(thisObject);
			break;
		case ACT_ADDINDEXB:
			IncIndexB(thisObject);
			break;
		case ACT_ADDINDEXC:
			IncIndexC(thisObject);
			break;
		case ACT_WRITEVALUE:
			WriteValue(thisObject, act.getParamExpression(thisObject.rh, 0));
			break;
		case ACT_WRITESTRING:
			WriteString(thisObject, act.getParamExpString(thisObject.rh, 0));
			break;
		case ACT_CLEARARRAY:
			ClearArray(thisObject);
			break;
		case ACT_LOAD:
			Load(thisObject, act.getParamFilename(thisObject.rh, 0));
			break;
		case ACT_LOADSELECTOR:
			LoadSelector(thisObject);
			break;
		case ACT_SAVE:
			Save(thisObject, act.getParamFilename(thisObject.rh, 0));
			break;
		case ACT_SAVESELECTOR:
			SaveSelector(thisObject);
			break;
		case ACT_WRITEVALUE_X:
			WriteValue_X(thisObject,
					act.getParamExpression(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1));
			break;
		case ACT_WRITEVALUE_XY:
			WriteValue_XY(thisObject, 
					act.getParamExpression(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1), 
					act.getParamExpression(thisObject.rh, 2));
			break;
		case ACT_WRITEVALUE_XYZ:
			WriteValue_XYZ(thisObject, 
					act.getParamExpression(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1), 
					act.getParamExpression(thisObject.rh, 2), 
					act.getParamExpression(thisObject.rh, 3));
			break;
		case ACT_WRITESTRING_X:
			WriteString_X(thisObject, 
					act.getParamExpString(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1));
			break;
		case ACT_WRITESTRING_XY:
			WriteString_XY(thisObject, 
					act.getParamExpString(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1),
					act.getParamExpression(thisObject.rh, 2));
			break; 
		case ACT_WRITESTRING_XYZ:
			WriteString_XYZ(thisObject, 
					act.getParamExpString(thisObject.rh, 0), 
					act.getParamExpression(thisObject.rh, 1), 
					act.getParamExpression(thisObject.rh, 2), 
					act.getParamExpression(thisObject.rh, 3));
			break;
		}
	}

	private static void SetIndexA(CRunKcArray thisObject, int i)
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.pArray.lIndexA = i - 1;
		}
		else
		{
			thisObject.pArray.lIndexA = i;
		}
	}
	private static void SetIndexB(CRunKcArray thisObject, int i)
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.pArray.lIndexB = i - 1;
		}
		else
		{
			thisObject.pArray.lIndexB = i;
		}
	}
	private static void SetIndexC(CRunKcArray thisObject, int i)
	{
		if ((thisObject.pArray.lFlags & INDEX_BASE1) != 0)
		{
			thisObject.pArray.lIndexC = i - 1;
		}
		else
		{
			thisObject.pArray.lIndexC = i;
		}
	}
	private static void IncIndexA(CRunKcArray thisObject)
	{
		thisObject.pArray.lIndexA++;
	}

	private static void IncIndexB(CRunKcArray thisObject)
	{
		thisObject.pArray.lIndexB++;
	}
	private static void IncIndexC(CRunKcArray thisObject)
	{
		thisObject.pArray.lIndexC++;
	}
	private static void WriteValue(CRunKcArray thisObject, int value)
	{
		WriteValueXYZ(thisObject, value, thisObject.pArray.lIndexA, thisObject.pArray.lIndexB, thisObject.pArray.lIndexC);
	}
	private static void WriteString(CRunKcArray thisObject, String value)
	{
		WriteStringXYZ(thisObject, value, thisObject.pArray.lIndexA, thisObject.pArray.lIndexB, thisObject.pArray.lIndexC);
	}
	private static void ClearArray(CRunKcArray thisObject)
	{
		thisObject.pArray.Clean();
	}
	private static void Load(CRunKcArray thisObject, String fileName)
	{
		try 
		{
			//String t = thisObject.ho.getFile(fileName);
			if(!fileName.contains("/") && !fileName.contains("\\"))
				fileName = MMFRuntime.inst.getFilesDir ().toString ()+"/"+fileName;

			HFile hFile = thisObject.ho.openHFile(fileName, thisObject.enabled_perms);
			if ( hFile == null )
				return;

			byte data[] = new byte [hFile.stream.available()];
			hFile.stream.read(data);
			ByteBuffer buffer = ByteBuffer.wrap(data);

			if(buffer == null || data.length == 0)
				return;

			buffer.order(ByteOrder.LITTLE_ENDIAN);
			byte[] headerHead = new byte[9];
			buffer.get(headerHead);
			String cncArray = new String(headerHead);
			boolean bUnicode = false;
			boolean bValidMark = false;
			if ( cncArray.equals("CNC ARRAY") )
				bValidMark = true;
			else if ( cncArray.equals("MFU ARRAY") )
			{
				bValidMark = true;
				bUnicode = true;
			}
			else {
				if(hFile != null)
					hFile.close();
				return;
			}
			if ( bValidMark )
			{
				byte a = buffer.get();
				short version = buffer.getShort();
				short revision = buffer.getShort();
				if (((version == 1) || (version == 2)) && (revision == 0))
				{
					int dimX = buffer.getInt(); 
					int dimY = buffer.getInt();
					int dimZ = buffer.getInt();
					int flags = buffer.getInt();
					//header read
					if ((dimX >= 0) && (dimY >= 0) && (dimZ >= 0))
					{
						if ((flags & ARRAY_TYPENUM) != 0)
						{
							int newArray[][][] = new int[dimZ][dimY][dimX];                          
							for (int z = 0; z < dimZ; z++)
							{
								for (int y = 0; y < dimY; y++)
								{
									for (int x = 0; x < dimX; x++)
									{
										newArray[z][y][x] = buffer.getInt();
									}
								}
							}
							//if no try error thus far
							thisObject.pArray.lFlags = flags;
							thisObject.pArray.lDimensionX = dimX;
							thisObject.pArray.lDimensionY = dimY;
							thisObject.pArray.lDimensionZ = dimZ;
							thisObject.pArray.lIndexA = 0;
							thisObject.pArray.lIndexB = 0;
							thisObject.pArray.lIndexC = 0;
							thisObject.pArray.numberArray = newArray;
							newArray = null;
							//fin
						}
						else if ((flags & ARRAY_TYPETXT) != 0)
						{
							String newArray[][][] = new String[dimZ][dimY][dimX];                           
							for (int z = 0; z < dimZ; z++)
							{
								for (int y = 0; y < dimY; y++)
								{
									for (int x = 0; x < dimX; x++)
									{
										int length = buffer.getInt();

										if (length>0)
										{
											if ( bUnicode )
											{
												byte[] txt = new byte[length*2];
												buffer.get(txt);
												char[] txtu = new char[length];
												int b1, b2;
												int n;
												for (n=0; n<length; n++)
												{
													b1 = txt[n*2]&255;
													b2 = txt[n*2+1]&255;
													txtu[n]=(char) (b2 * 256 + b1);
												}
												newArray[z][y][x] = new String(txtu);
											}
											else
											{
												byte[] txt = new byte[length];
												buffer.get(txt);
												newArray[z][y][x] = new String(txt);
											}
										}
									}
								}
							}
							//if no try error thus far
							thisObject.pArray.lFlags = flags;
							thisObject.pArray.lDimensionX = dimX;
							thisObject.pArray.lDimensionY = dimY;
							thisObject.pArray.lDimensionZ = dimZ;
							thisObject.pArray.lIndexA = 0;
							thisObject.pArray.lIndexB = 0;
							thisObject.pArray.lIndexC = 0;
							thisObject.pArray.stringArray = newArray;
							newArray = null;
							//fin
						}
					}
				}
			} 
			buffer.clear();
			buffer = null;
			if(hFile != null)
				hFile.close();
		} 
		catch (Exception e) 
		{
			throw new RuntimeException(e);
		}
	}

	private static void LoadSelector(CRunKcArray thisObject)
	{
	}
	private static void Save(CRunKcArray thisObject, String fileName)
	{
		File file = null;
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		DataOutputStream dos = null;
		
		if(!thisObject.enabled_perms) {
			MMFRuntime.inst.askForPermissionsApi23();
			return;
		}

		try
		{
			if(!fileName.contains("/") && !fileName.contains("\\"))
				fileName = MMFRuntime.inst.getFilesDir ().toString ()+"/"+fileName;

			file = new File(fileName);
			fos = new FileOutputStream(file);
			bos = new BufferedOutputStream(fos);
			dos = new DataOutputStream(bos);

			dos.writeBytes("MFU ARRAY");
			dos.writeByte(0);
			dos.writeShort(Short.reverseBytes((short) 2));//version
			dos.writeShort((short)0);//revision
			dos.writeInt(Integer.reverseBytes(thisObject.pArray.lDimensionX));
			dos.writeInt(Integer.reverseBytes(thisObject.pArray.lDimensionY));
			dos.writeInt(Integer.reverseBytes(thisObject.pArray.lDimensionZ));
			dos.writeInt(Integer.reverseBytes(thisObject.pArray.lFlags));
			if ((thisObject.pArray.lFlags & ARRAY_TYPENUM) != 0)
			{
				//reverse loop order for save
				for (int z = 0; z < thisObject.pArray.lDimensionZ; z++)
				{
					for (int y = 0; y < thisObject.pArray.lDimensionY; y++)
					{
						for (int x = 0; x < thisObject.pArray.lDimensionX; x++)
						{
							dos.writeInt(Integer.reverseBytes(thisObject.pArray.numberArray[z][y][x]));
						}
					}
				}
			}
			else if ((thisObject.pArray.lFlags & ARRAY_TYPETXT) != 0)
			{
				//reverse loop order for save
				for (int z = 0; z < thisObject.pArray.lDimensionZ; z++)
				{
					for (int y = 0; y < thisObject.pArray.lDimensionY; y++)
					{
						for (int x = 0; x < thisObject.pArray.lDimensionX; x++)
						{
							String g = thisObject.pArray.stringArray[z][y][x];

							if(g == null)
								g="";

							int l = g.length();
							dos.writeInt(Integer.reverseBytes(l));
							if (l>0)
							{
								// Old code, doesn't support Unicode
								//byte[] item = new byte[g.length()];
								//item = g.getBytes();

								// New code, supports Unicode
								byte[] item = new byte[l*2];
								char c;
								int n;
								for (n=0; n<l; n++)
								{
									c = g.charAt(n);
									item[n*2] = (byte)(c & 255);
									item[n*2+1] = (byte)((c/256) & 255);
								}

								dos.write(item);
								item = null;
							}
						}
					}
				}
			}
			//dos.flush();
			bos.flush();
		}
		catch(FileNotFoundException e)
		{
			throw new RuntimeException(e);
		}
		catch(Exception e)
		{
			throw new RuntimeException(e);
		}
		finally {
			try
			{
				if (bos != null) {
					bos.flush();
					bos.close();
				}            

			}
			catch (Exception e) 
			{
			}
		}   
	}
	private static void SaveSelector(CRunKcArray thisObject)
	{
	}
	private static void WriteValue_X(CRunKcArray thisObject, int value, int x)
	{
		x -= thisObject.pArray.oneBased();
		WriteValueXYZ(thisObject, value, x, thisObject.pArray.lIndexB, thisObject.pArray.lIndexC);
	}
	private static void WriteValue_XY(CRunKcArray thisObject, int value, int x, int y)
	{
		x -= thisObject.pArray.oneBased();
		y -= thisObject.pArray.oneBased();
		WriteValueXYZ(thisObject, value, x, y, thisObject.pArray.lIndexC);
	}
	private static void WriteValue_XYZ(CRunKcArray thisObject, int value, int x, int y, int z)
	{
		x -= thisObject.pArray.oneBased();
		y -= thisObject.pArray.oneBased();
		z -= thisObject.pArray.oneBased();
		WriteValueXYZ(thisObject, value, x, y, z);
	}
	private static void WriteValueXYZ(CRunKcArray thisObject, int value, int x, int y, int z)
	{
		//x,y,z should be fixed for 1-based index if used before this function
		if ((x < 0) || (y < 0) || (z < 0))
		{
			return;
		}
		if ((thisObject.pArray.lFlags & ARRAY_TYPENUM) != 0)
		{
			// Expand if required
			if ((x >= thisObject.pArray.lDimensionX) || (y >= thisObject.pArray.lDimensionY) || (z >= thisObject.pArray.lDimensionZ))
			{
				int newDimX = java.lang.Math.max(thisObject.pArray.lDimensionX, x+1);
				int newDimY = java.lang.Math.max(thisObject.pArray.lDimensionY, y+1);
				int newDimZ = java.lang.Math.max(thisObject.pArray.lDimensionZ, z+1);
				thisObject.pArray.Expand(newDimX, newDimY, newDimZ);
			}
			//write
			thisObject.pArray.lIndexA = x;
			thisObject.pArray.lIndexB = y;
			thisObject.pArray.lIndexC = z;
			thisObject.pArray.numberArray[z][y][x] = value;
		}
	}

	private static void WriteString_X(CRunKcArray thisObject, String value, int x)
	{
		x -= thisObject.pArray.oneBased();
		WriteStringXYZ(thisObject, value, x, thisObject.pArray.lIndexB, thisObject.pArray.lIndexC);
	}
	private static void WriteString_XY(CRunKcArray thisObject, String value, int x, int y)
	{
		x -= thisObject.pArray.oneBased();
		y -= thisObject.pArray.oneBased();
		WriteStringXYZ(thisObject, value, x, y, thisObject.pArray.lIndexC);
	}
	private static void WriteString_XYZ(CRunKcArray thisObject, String value, int x, int y, int z)
	{
		x -= thisObject.pArray.oneBased();
		y -= thisObject.pArray.oneBased();
		z -= thisObject.pArray.oneBased();
		WriteStringXYZ(thisObject, value, x, y, z);
	}
	private static void WriteStringXYZ(CRunKcArray thisObject, String value, int x, int y, int z)
	{
		//x,y,z should be fixed for 1-based index if used before this function
		if ((x < 0) || (y < 0) || (z < 0))
		{
			return;
		}
		if ((thisObject.pArray.lFlags & ARRAY_TYPETXT) != 0)
		{
			// Expand if required
			if ((x >= thisObject.pArray.lDimensionX) || (y >= thisObject.pArray.lDimensionY) || (z >= thisObject.pArray.lDimensionZ))
			{
				int newDimX = java.lang.Math.max(thisObject.pArray.lDimensionX, x+1);
				int newDimY = java.lang.Math.max(thisObject.pArray.lDimensionY, y+1);
				int newDimZ = java.lang.Math.max(thisObject.pArray.lDimensionZ, z+1);
				thisObject.pArray.Expand(newDimX, newDimY, newDimZ);
			}
			//write
			thisObject.pArray.lIndexA = x;
			thisObject.pArray.lIndexB = y;
			thisObject.pArray.lIndexC = z;
			thisObject.pArray.stringArray[z][y][x] = value;
		}
	}

}
