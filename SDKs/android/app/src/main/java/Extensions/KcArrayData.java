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


import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;

public class KcArrayData 
{
    public static int	ARRAY_TYPENUM = 0x0001;
    public static int	ARRAY_TYPETXT = 0x0002;
    public static int	INDEX_BASE1 = 0x0004;
        
    int			lDimensionX;
    int			lDimensionY;
    int			lDimensionZ;
    int			lFlags;
    //indicies will never be 1-based
    int			lIndexA;
    int			lIndexB;
    int			lIndexC;
     //int			lArraySize;
    public int[][][]           numberArray;
    public String[][][]        stringArray;
    
    public KcArrayData(int flags, int dimX, int dimY, int dimZ) 
    {
        dimX = java.lang.Math.max(1, dimX);
        dimY = java.lang.Math.max(1, dimY);
        dimZ = java.lang.Math.max(1, dimZ);
        
        lFlags = flags;
        lDimensionX = dimX;
        lDimensionY = dimY;
        lDimensionZ = dimZ;
        if ((flags & ARRAY_TYPENUM) != 0)
        {
            numberArray = new int[dimZ][dimY][dimX];
        }
        else if ((flags & ARRAY_TYPETXT) != 0)
        {
            stringArray = new String[dimZ][dimY][dimX];

            for(int z = 0; z < dimZ; ++ z)
            {
                for(int y = 0; y < dimY; ++ y)
                {
                    for(int x = 0; x < dimX; ++ x)
                    {
                        stringArray[z][y][x] = "";
                    }
                }
            }
        }
    } 
    int oneBased()
    {
        if ((lFlags & INDEX_BASE1) != 0)
        {
            return 1;
        }
        return 0;
    }
    void Expand(int newX, int newY, int newZ)
    {
        //inputs should always be equal or larger than current dimensions
        if ((lFlags & ARRAY_TYPENUM) != 0)
        {
            int[][][] temp = numberArray.clone();
            numberArray = new int[newZ][newY][newX];
            for (int z = 0; z < lDimensionZ; z++)
            {
                for (int y = 0; y < lDimensionY; y++)
                {
                    for (int x = 0; x < lDimensionX; x++)
                    {
                        numberArray[z][y][x] = temp[z][y][x];
                    }
                }
            }
        }
        else if ((lFlags & ARRAY_TYPETXT) != 0)
        {
            String[][][] temp = stringArray.clone();
            stringArray = new String[newZ][newY][newX];
            for (int z = 0; z < lDimensionZ; z++)
            {
                for (int y = 0; y < lDimensionY; y++)
                {
                    for (int x = 0; x < lDimensionX; x++)
                    {
                        stringArray[z][y][x] = temp[z][y][x];
                    }
                }
            }           
        }
        lDimensionX = newX;
        lDimensionY = newY;
        lDimensionZ = newZ;
    }
    void Clean()
    {
        if ((lFlags & ARRAY_TYPENUM) != 0)
        {
            for (int z = 0; z < lDimensionZ; z++)
            {
                for (int y = 0; y < lDimensionY; y++)
                {
                    for (int x = 0; x < lDimensionX; x++)
                    {
                        numberArray[z][y][x] = 0;
                    }
                }
            }
        }
        else if ((lFlags & ARRAY_TYPETXT) != 0)
        {
            for (int z = 0; z < lDimensionZ; z++)
            {
                for (int y = 0; y < lDimensionY; y++)
                {
                    for (int x = 0; x < lDimensionX; x++)
                    {
                        stringArray[z][y][x] = null;
                    }
                }
            }           
        }
    }
    public boolean write(DataOutputStream stream)
    {
        try
        {
            stream.writeInt(lFlags);
            stream.writeInt(lDimensionX);
            stream.writeInt(lDimensionY);
            stream.writeInt(lDimensionZ);
            int x, y, z;

            if ((lFlags & ARRAY_TYPENUM) != 0)
            {
                for (z=0; z<lDimensionZ; z++)
                {
                    for (y=0; y<lDimensionY; y++)
                    {
                        for (x=0; x<lDimensionX; x++)
                        {
                            stream.writeInt(numberArray[z][y][x]);
                        }
                    }
                }
            }
            else
            {
                for (z=0; z<lDimensionZ; z++)
                {
                    for (y=0; y<lDimensionY; y++)
                    {
                        for (x=0; x<lDimensionX; x++)
                        {
                            if (stringArray[z][y][x]!=null)
                            {
                                stream.writeByte(1);
                                stream.writeUTF(stringArray[z][y][x]);
                            }
                            else
                            {
                                stream.writeByte(0);
                            }
                        }
                    }
                }
            }
            return true;
        }
        catch(IOException e){}
        return false;
    }
    public boolean read(DataInputStream stream)
    {
        try
        {
            lFlags=stream.readInt();
            lDimensionX=stream.readInt();
            lDimensionY=stream.readInt();
            lDimensionZ=stream.readInt();
            int x, y, z;

            stringArray=null;
            numberArray=null;
            if ((lFlags & ARRAY_TYPENUM) != 0)
            {
                numberArray=new int[lDimensionZ][lDimensionY][lDimensionX];
                for (z=0; z<lDimensionZ; z++)
                {
                    for (y=0; y<lDimensionY; y++)
                    {
                        for (x=0; x<lDimensionX; x++)
                        {
                            numberArray[z][y][x]=stream.readInt();
                        }
                    }
                }
            }
            else
            {
                stringArray=new String[lDimensionZ][lDimensionY][lDimensionX];
                for (z=0; z<lDimensionZ; z++)
                {
                    for (y=0; y<lDimensionY; y++)
                    {
                        for (x=0; x<lDimensionX; x++)
                        {
                            if (stream.readByte()==1)
                            {
                                stringArray[z][y][x]=stream.readUTF();
                            }
                        }
                    }
                }
            }
            return true;
        }
        catch(IOException e){}
        return false;
    }
}
