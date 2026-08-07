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
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CServices;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Point;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.view.Display;


public class CRunAccelerometer extends CRunExtension
{
    private SensorManager manager = null;
    private boolean accelerometerSupported;
    private double[] direct;
    private double[] filtered;
    private double[] instant;

    private int orientation;
    private int New_orientation;
    private int Old_orientation;
    
    private float nominalG = 9.8f;

    public CRunAccelerometer()
    {
        direct = new double[3];
        filtered = new double[3];
        instant = new double[3];
    }

    private SensorEventListener accelerometerListener = new SensorEventListener()
    {

        @Override
		public void onSensorChanged(SensorEvent e)
        {
         	CServices.filterAccelerometer(e, direct, filtered, instant, nominalG);
         	
         	New_orientation = CServices.getActualOrientation();
         	
         	if(New_orientation != Old_orientation) {
         		ho.generateEvent(0, 0);
         		Old_orientation = New_orientation;
         	}

        }

        @Override
		public void onAccuracyChanged(Sensor sensor, int accuracy)
        {
        }
    };

    @Override
	public int handleRunObject()
    {
        if(orientation != MMFRuntime.inst.orientation)
        {
            orientation = MMFRuntime.inst.orientation;
            ho.generateEvent(0, 0);
        }

        return 0;
    }

    @Override
	public int getNumberOfConditions()
    {
        return 1;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        orientation = MMFRuntime.inst.orientation;
        orientation = CServices.getActualOrientation();

        manager = (SensorManager) MMFRuntime.inst.getSystemService(Context.SENSOR_SERVICE);

        if(manager != null) {
	        accelerometerSupported = manager.registerListener(accelerometerListener,
	                manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
	                SensorManager.SENSOR_DELAY_GAME);
        }
        
     	New_orientation = Old_orientation = CServices.getActualOrientation();
        return true;
    }

    public @Override void pauseRunObject()
    {
        manager.unregisterListener(accelerometerListener);
     }
    
    public @Override void continueRunObject()
    {
    	accelerometerSupported = manager.registerListener(accelerometerListener,
                manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
                SensorManager.SENSOR_DELAY_GAME);
    }
   
    
    @Override
	public void destroyRunObject(boolean bFast)
    {
        manager.unregisterListener(accelerometerListener);
        accelerometerListener = null;
        
    }

    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case 0: // Orientation changed
            {
            	if(accelerometerSupported)
            		return true;
            	
            	return false;
            }

        }

        return false;
    }

    @Override
	public void action(int num, CActExtension act)
    {
    }

    ///////////////////////////////////////////////////
    //
    //     Note: Inverted Y Axis to work like iOS
    //
    ///////////////////////////////////////////////////
    @Override
	@SuppressWarnings("deprecation")
	public CValue expression(int num)
    {
        CValue value = new CValue(0);

        switch (num)
        {
            case 0: // X direct

                value.forceDouble(direct[0]);
                break;

            case 1: // Y direct

                value.forceDouble(direct[1]);
                break;

            case 2: // Z direct

                value.forceDouble(direct[2]);
                break;

            case 3: // X gravity

                value.forceDouble(filtered[0]);
                break;

            case 4: // Y gravity

                value.forceDouble(filtered[1]);
                break;

            case 5: // Z gravity

                value.forceDouble(filtered[2]);
                break;

            case 6: // X instant

                value.forceDouble(instant[0]);
                break;

            case 7: // Y instant

                value.forceDouble(instant[1]);
                break;

            case 8: // Z instant

                value.forceDouble(instant[2]);
                break;

            case 9: // Orientation

            	
                switch(orientation)
                {
                    case Configuration.ORIENTATION_PORTRAIT:
                    case Configuration.ORIENTATION_SQUARE:

                        value.forceInt(0);
                        break;

                    case Configuration.ORIENTATION_LANDSCAPE:

                        value.forceInt(3);
                        break;
                        
                    case Configuration.ORIENTATION_UNDEFINED:

                    	value.forceInt(NaturalOrientation());
                        break;
    
                }
				
                break;
        }

        return value;
    }
    
    @SuppressLint("NewApi")
	@SuppressWarnings("deprecation")
    private int NaturalOrientation() {
    	
		Display display = MMFRuntime.inst.getWindowManager().getDefaultDisplay();

		final int ScreenWidth, ScreenHeight;
		
		if(Build.VERSION.SDK_INT > 12) {
			Point size = new Point();
			display.getSize(size);
			ScreenWidth = size.x;
			ScreenHeight = size.y;
		}else {
			//Below API 13
			ScreenWidth = display.getWidth();  // deprecated
			ScreenHeight = display.getHeight();  // deprecated
		}
    	
		if(ScreenWidth > ScreenHeight)
			return 3;
		
		return 0;
    }
}
