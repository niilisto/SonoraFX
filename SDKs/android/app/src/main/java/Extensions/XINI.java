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

import java.io.BufferedReader;
import java.io.InputStreamReader;
import Application.CRunApp;
import Objects.CExtension;
import Objects.CObject;
import Runtime.MMFRuntime;
import Runtime.Log;
import Services.CServices;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;

@SuppressLint("DefaultLocale")
public class XINI
{
    CExtension ho;

    String currentGroup;
    String currentItem;

    String currentFile;

    SharedPreferences data;
    SharedPreferences.Editor editor;

    public void update()
    {
        data = MMFRuntime.inst.getSharedPreferences
            (("MMF_" + currentFile + "_" + currentGroup)
                .replace("/", "_")
                .replace("\\", "_"), 0);

        editor = data.edit();
        
    }

    public XINI (CExtension ho, String filename)
    {
        this.ho = ho;

        currentGroup = "Group";
        currentItem = "Item";

        setCurrentFile(filename);

    }

    public void setCurrentGroup (String group)
    {
        currentGroup = group.toLowerCase();
        update();
    }

    public void setCurrentItem (String item)
    {
        currentItem = item.toLowerCase();
        update();
    }

    public void setValue (int value)
    {
        editor.putString(currentItem, Integer.toString(value));
        
        editor.commit();
    }

    public void saveObjectPos (CObject object)
    {
        String item = "pos." + object.hoOiList.oilName;
        String value = Integer.toString(object.hoX) + "," + Integer.toString(object.hoY);

        editor.putString(item, value);
        
        editor.commit();
    }

    public void loadObjectPos (CObject object)
    {
        String item = "pos." + object.hoOiList.oilName;
        String value = data.getString(item, "");

        if(value.length() == 0)
            return;

        String[] tokens = value.split("\\,");

        object.hoX = CServices.parseInt(tokens[0]);
        object.hoY = CServices.parseInt(tokens[1]);

        object.roc.rcChanged = true;
        object.roc.rcCheckCollides = true;
    }

    public void setString (String s)
    {
        editor.putString(currentItem, s);
        
        editor.commit();
    }

    public void setCurrentFile (String filename)
    {
        if(filename == null)
        	return;
        
    	currentFile = filename;

        if(ho != null)
        {
            try
            {
                CRunApp.HFile file = ho.openHFile(filename, false);

                if(file != null)
                {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(file.stream));

                    String group = "";

                    for(String s = reader.readLine(); s != null; s = reader.readLine())
                    {
                        try
                        {
                            if(s.length() == 0 || s.charAt(0) == ';')
                                continue;

                            if(s.trim().charAt(0) == '[')
                            {
                                group = s.split("\\[")[1].split("]")[0];
                                continue;
                            }

                            int eq = s.indexOf("=");

                            if(eq != -1)
                            {
                                String key = s.substring(0, eq);
                                String value = s.substring(eq + 1, s.length());

                                if(!getGroupItemString(group, key + "_modif").equals("1"))
                                    setGroupItemString(group, key, value);
                            }
                        }
                        catch(Exception e)
                        {
                            Log.Log(e.toString());
                        }
                    }
                    file.close();
                }
            }
            catch(Exception e)
            {
                Log.Log(e.toString());
            }
        }

        update();
    }

    public void setItemValue (String item, int value)
    {
    	editor.putString(item.toLowerCase(), Integer.toString(value));
        editor.putString(item + "_modif", "1");

        editor.commit();
    }

    public void setGroupItemValue (String group, String item, int value)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        editor.putString(item.toLowerCase(), Integer.toString(value));
        editor.putString(item.toLowerCase() + "_modif", "1");

        editor.commit();

        currentGroup = oldGroup;
        update();

    }

    public void setItemString (String item, String s)
    {
        editor.putString(item.toLowerCase(), s);
        editor.putString(item.toLowerCase() + "_modif", "1");

        editor.commit();
    }

    public void setGroupItemString (String group, String item, String s)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        editor.putString(item.toLowerCase(), s);
        editor.putString(item.toLowerCase() + "_modif", "1");
        
        editor.commit();

        currentGroup = oldGroup;
        update();
    }

    public void deleteItem (String item)
    {
        editor.remove(item);
        
        editor.commit();
    }

    public void deleteGroupItem (String group, String item)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        editor.remove(item.toLowerCase());
        editor.remove(item.toLowerCase() + "_modif");
        
        editor.commit();

        currentGroup = oldGroup;
        update();
    }

    public void deleteGroup (String group)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        editor.clear();
        
        editor.commit();

        currentGroup = oldGroup;
        update();
    }

    public int getValue ()
    {
        return CServices.parseInt(data.getString(currentItem, ""));
    }

    public String getString ()
    {
        return data.getString(currentItem, "");
    }

    public int getItemValue (String item)
    {
        return CServices.parseInt(data.getString(item.toLowerCase(), ""));
    }

    public int getGroupItemValue (String group, String item)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        int value = CServices.parseInt(data.getString(item.toLowerCase(), ""));

        currentGroup = oldGroup;
        update();

        return value;
    }

    public String getItemString (String item)
    {
        return data.getString(item.toLowerCase(), "");
    }

    public String getGroupItemString (String group, String item)
    {
        String oldGroup = currentGroup;

        currentGroup = group.toLowerCase();
        update();

        String value = data.getString(item.toLowerCase(), "");

        currentGroup = oldGroup;
        update();

        return value;
    }



}
