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

import Actions.CActExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunOldini extends CRunExtension
{
    XINI oINI;

    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        String filename = null;
        
        oINI = new XINI (ho, filename);
        
        return false;
    }


    @Override
    public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case 0: // Set current group

                oINI.setCurrentGroup (act.getParamExpString(rh, 0));
                break;

            case 1: // Set current item

                oINI.setCurrentItem (act.getParamExpString(rh, 0));
                break;

            case 2: // Set value

                oINI.setValue (act.getParamExpression(rh, 0));
                break;
                
            case 3: // Save position of object

                oINI.saveObjectPos (act.getParamObject(rh, 0));
                break;

            case 4: // Load position of object

                oINI.loadObjectPos (act.getParamObject(rh, 0));
                break;


            case 5: // Set string

                oINI.setString (act.getParamExpString(rh, 0));
                break;

            case 6: // Set current file

                oINI.setCurrentFile (act.getParamExpString(rh, 0));
                break;

            case 7: // Set value (item)

                oINI.setItemValue (act.getParamExpString(rh, 0), act.getParamExpression(rh, 1));
                break;

            case 8: // Set value (group, item)

                oINI.setGroupItemValue (act.getParamExpString(rh, 0),
                                       act.getParamExpString(rh, 1),
                                       act.getParamExpression(rh, 2));
                break;

            case 9: // Set string (item)

                oINI.setItemString (act.getParamExpString(rh, 0), act.getParamExpString(rh, 1));
                break;

            case 10: // Set string (group, item)

                oINI.setGroupItemString (act.getParamExpString(rh, 0),
                                        act.getParamExpString (rh, 1),
                                        act.getParamExpString (rh, 2));
                break;

            case 11: // Delete item

                oINI.deleteItem (act.getParamExpString(rh, 0));
                break;

            case 12: // Delete group's item

                oINI.deleteGroupItem (act.getParamExpString(rh, 0), act.getParamExpString (rh, 1));
                break;

            case 13: // Delete group

                oINI.deleteGroup (act.getParamExpString(rh, 0));
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
                return new CValue(oINI.getValue());
            }

            case 1: // Get string
            {
                return new CValue(oINI.getString());
            }

            case 2: // Get value (item)
            {
              	return new CValue (oINI.getItemValue (ho.getExpParam().getString()));
            }

            case 3: // Get value (group, item)
            {
                String group = ho.getExpParam().getString();
                String item = ho.getExpParam().getString();
                return new CValue (oINI.getGroupItemValue (group, item));
            }

            case 4: // Get string (item)
            {
                String item = ho.getExpParam().getString();
               	return new CValue (oINI.getItemString (item));
            }
            
            case 5: // Get string (group, item)
            {
               	String group = ho.getExpParam().getString();
               	String item = ho.getExpParam().getString();
                
               	return new CValue (oINI.getGroupItemString (group, item));
             }
         }

        return new CValue(0);
    }
    
}
