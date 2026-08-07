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
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunMobileUtilities extends CRunExtension
{
    public CRunMobileUtilities()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 6;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {

        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch(num)
        {
            case 0: // Left key pressed
                return false;

            case 1: // Right key pressed
                return false;

            case 2: // Left key down
                return false;

            case 3: // Right key down
                return false;

            case 4: // Orientation
                return false;

            case 5: // Is mobile?
                return true;
        }
        
        return false;
    }

    @Override
	public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case 0: // Set rotation
                break;

            case 1: // Refresh all
                break;
        }
    }

    @Override
	public CValue expression(int num)
    {
        switch (num)
        {
            case 0: // Get orientation
                return new CValue(0);

            case 1: // Get rotation
                return new CValue(0);

            case 2: // Get width
                return new CValue(rh.rhApp.gaCxWin);

            case 3: // Get height
                return new CValue(rh.rhApp.gaCyWin);
        }

        return null;
    }
  
}
