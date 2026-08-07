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

package Extensions;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import Actions.CActExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CINI;
import android.Manifest;

public class CRunkcini extends CRunExtension
{
    CINI INI;
    
    String filename = null;
    int flags = 0;

    CValue expRet;
    
	private static int PERMISSIONS_INI_REQUEST = 12377868;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
    private boolean api23_started;

    public boolean isFileInternal(String fileName) {
        String path = ho.getControlsContext().getFilesDir().getAbsolutePath() + "/" + fileName;
        File file = new File(path);
        return file.exists();
    }
    
    public CRunkcini () {
    	expRet = new CValue(0);
    }
    
    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        flags = file.readShort();
        
        filename = file.readString();
        
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
			{
				if(MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_INI_REQUEST) != PERMISSIONS_INI_REQUEST)
					enabled_perms = isFileInternal(filename);
			}
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;
			
		if(enabled_perms)
			INI = new CINI (ho, filename, flags);
		else
			api23_started = false;
		
        return false;
    }

	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_INI_REQUEST)) {
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
			if(enabled_perms)
				INI = new CINI (ho, filename, flags);
		}
		else
			enabled_perms = false;
	}

	@Override
	public int handleRunObject()
	{
		if(MMFRuntime.inst != null && !api23_started) {
			api23_started = true;
			MMFRuntime.inst.askForPermissionsApi23();		
		}
		return REFLAG_ONESHOT;
	}

	@Override
    public void destroyRunObject(boolean bFast)
    {
        if(INI != null) {
        	//Log.Log("INI destroy ...");
        	INI.close();
        	INI = null;
        }
    }

    @Override
    public void pauseRunObject()
    {
    	if(INI != null) {
        	//Log.Log("INI paused ...");
    		INI.update();
    	}
    }

    @Override
    public void continueRunObject()
    {    
    	if(INI == null)
    		INI = new CINI (ho, filename, flags);
    }

    public void onEndOfGameLoop ()
    {
    	if (INI != null)
    		INI.update();
    }
    
    @Override
    public void onDestroy()
    {
        if(INI != null) {
        	//Log.Log("INI onDestroy ...");
        	INI = null;
        }
    }
    
    @Override
    public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case 0: // Set current group

            	if(INI != null)
            		INI.setCurrentGroup (act.getParamExpString(rh, 0));
                break;

            case 1: // Set current item

               	if(INI != null)
               		INI.setCurrentItem (act.getParamExpString(rh, 0));
                break;

            case 2: // Set value

               	if(INI != null)
               		INI.setValue (act.getParamExpression(rh, 0));
				rh.eoglList_addObject(this);
                break;
                
            case 3: // Save position of object

               	if(INI != null)
               		INI.saveObjectPos (act.getParamObject(rh, 0));
				rh.eoglList_addObject(this);
                break;

            case 4: // Load position of object

               	if(INI != null)
               		INI.loadObjectPos (act.getParamObject(rh, 0));
                break;


            case 5: // Set string

               	if(INI != null)
               		INI.setString (act.getParamExpString(rh, 0));
				rh.eoglList_addObject(this);
                break;

            case 6: // Set current file

               	if(INI != null)
               		INI.setCurrentFile (act.getParamExpString(rh, 0));
                break;

            case 7: // Set value (item)

               	if(INI != null)
               		INI.setItemValue (act.getParamExpString(rh, 0), act.getParamExpression(rh, 1));
				rh.eoglList_addObject(this);
                break;

            case 8: // Set value (group, item)

               	if(INI != null)
               		INI.setGroupItemValue (act.getParamExpString(rh, 0),
                                       act.getParamExpString(rh, 1),
                                       act.getParamExpression(rh, 2));
				rh.eoglList_addObject(this);
                break;

            case 9: // Set string (item)

               	if(INI != null)
               		INI.setItemString (act.getParamExpString(rh, 0), act.getParamExpString(rh, 1));
				rh.eoglList_addObject(this);
                break;

            case 10: // Set string (group, item)

               	if(INI != null)
               		INI.setGroupItemString (act.getParamExpString(rh, 0),
                                        act.getParamExpString (rh, 1),
                                        act.getParamExpString (rh, 2));
				rh.eoglList_addObject(this);
                break;

            case 11: // Delete item

               	if(INI != null)
               		INI.deleteItem (act.getParamExpString(rh, 0));
				rh.eoglList_addObject(this);
                break;

            case 12: // Delete group's item

               	if(INI != null)
               		INI.deleteGroupItem (act.getParamExpString(rh, 0), act.getParamExpString (rh, 1));
				rh.eoglList_addObject(this);
                break;

            case 13: // Delete group

               	if(INI != null)
               		INI.deleteGroup (act.getParamExpString(rh, 0));
				rh.eoglList_addObject(this);
                break;
        }
    }

    @Override
    public CValue expression(int num)
    {
        switch (num)
        {
            case 0: // Get value
            {
           		expRet.forceInt(0);
               	if(INI != null)
               		expRet.forceInt(INI.getValue());
                return expRet;
            }

            case 1: // Get string
            {
            	
           		expRet.forceString("");
               	if(INI != null)
               		expRet.forceString(INI.getString());
                return expRet;
            }

            case 2: // Get value (item)
            {
           		expRet.forceInt(0);
               	if(INI != null)
               		expRet.forceInt(INI.getItemValue (ho.getExpParam().getString()));
                return expRet;
            }

            case 3: // Get value (group, item)
            {
                String group = ho.getExpParam().getString();
                String item = ho.getExpParam().getString();
           		expRet.forceInt(0);
               	if(INI != null)
               		expRet.forceInt(INI.getGroupItemValue (group, item));
                return expRet;
           }

            case 4: // Get string (item)
            {
                String item = ho.getExpParam().getString();
           		expRet.forceString("");
               	if(INI != null)
               		expRet.forceString(INI.getItemString (item));
                return expRet;
           }
            
            case 5: // Get string (group, item)
            {
               	String group = ho.getExpParam().getString();
               	String item = ho.getExpParam().getString();
                
           		expRet.forceString("");
               	if(INI != null)
               		expRet.forceString(INI.getGroupItemString (group, item));
                return expRet;
             }
         }

        return expRet;
    }
    
}
