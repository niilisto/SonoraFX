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
//----------------------------------------------------------------------------------
//
// CRunKcArray: array object
//
//greyhill
//----------------------------------------------------------------------------------

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRun;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.Manifest;

public class CRunKcArray extends CRunExtension
{    
    public static int	ARRAY_GLOBAL = 0x0008;
	public CValue		tempValue;
    
//   typedef struct tagEDATA
//{
//	extHeader		eHeader;
//
//	long			lDimensionX;
//	long			lDimensionY;
//	long			lDimensionZ;
//
//	long			lFlags;
//
//} editData;
    
//typedef struct ARRAYHEADER
//{
//	long			lDimensionX;
//	long			lDimensionY;
//	long			lDimensionZ;
//
//	long			lFlags;
//
//	long			lIndexA;
//	long			lIndexB;
//	long			lIndexC;
//
//	long			lArraySize;
//
//} ARRAYHEADER;
//typedef ARRAYHEADER _far *LPARRAYHEADER;
//
//typedef struct tagRDATA
//{
//	headerObject 	rHo;
//
//	LPARRAYHEADER	pArray;
//
//} runData;
    public KcArrayData         pArray;
       
	private static int PERMISSIONS_ARRAY_REQUEST = 12377897;
	private HashMap<String, String> permissionsApi23;
	boolean enabled_perms;

	public CRunKcArray() 
    {
		tempValue = new CValue();
    }
    @Override
	public int getNumberOfConditions()
    {
	return 3;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        CRun rhPtr = this.ho.hoAdRunHeader;       
        
        int lDimensionX = file.readInt();
        int lDimensionY = file.readInt();
        int lDimensionZ = file.readInt();
        int lFlags = file.readInt();
        
        KcArrayCGlobalDataList pData = null;
        if ((lFlags & ARRAY_GLOBAL) != 0)
        {
            CExtStorage pExtData = rhPtr.getStorage(ho.hoIdentifier);
            if (pExtData == null) //first global object of this type
            {
                pArray = new KcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
                pData = new KcArrayCGlobalDataList();
                pData.AddObject(this);
                rhPtr.addStorage(pData, ho.hoIdentifier);
            }
            else
            {
                pData = (KcArrayCGlobalDataList)pExtData;
                KcArrayData found = pData.FindObject(ho.hoOiList.oilName);
                if (found != null) //found array object of same name
                {
                    pArray = found; //share data
                }
                else
                {
                    pArray = new KcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
                    pData.AddObject(this);
                }
            }             
        }       
        else
        {
            pArray = new KcArrayData(lFlags, lDimensionX, lDimensionY, lDimensionZ);
        }
        
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_ARRAY_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;


        return true;
    }
    @Override
	public void destroyRunObject(boolean bFast)
    {              
    }    
    
    @Override
	public int handleRunObject()
    {
		if(MMFRuntime.inst != null) {
			MMFRuntime.inst.askForPermissionsApi23();		
		}
        return CRunExtension.REFLAG_ONESHOT;  
    }
    @Override
	public void pauseRunObject()
    {
    }
    @Override
	public void continueRunObject()
    {
    }
    
	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_ARRAY_REQUEST))
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
		else
			enabled_perms = false;
	} 
    
    public boolean saveRunObject(DataOutputStream stream)
    {
        CRun rhPtr = this.ho.hoAdRunHeader; 
        try
        {
            stream.writeInt(1); // version 1
            return pArray.write(stream);
        }
        catch (IOException e)
        {
        }
        return false;
    }
    public boolean loadRunObject(DataInputStream stream)
    {
        CRun rhPtr = this.ho.hoAdRunHeader; 
	try
        {
            int savedVersion = stream.readInt();
            if (savedVersion != 1)
            {
                return false;
            }
            return pArray.read(stream);
        }
        catch (IOException e)
        {
        }
        return false;
    }
    public void killBackground()
    {
    }
    @Override
	public CFontInfo getRunObjectFont()
    {
        return null;
         //return this.wFont;
    }
    @Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
    {      

    }
    @Override
	public int getRunObjectTextColor()
    {
      return 0;
    }
    @Override
	public void setRunObjectTextColor(int rgb)
    {
       
    }
    @Override
	public CMask getRunObjectCollisionMask(int flags)
    {
	return null;
    }
    @Override
	public void getZoneInfos()
    {
    }
    
    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return KcArrayCnds.get(num, cnd, this);
    }
    
    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
	KcArrayActs.action(num, act, this);
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
	return KcArrayExpr.get(num, this);
    }
}
