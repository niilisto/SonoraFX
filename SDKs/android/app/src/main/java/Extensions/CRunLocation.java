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

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import Actions.CActExtension;
import Application.CRunApp;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Runtime.Log;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.provider.Settings.SettingNotFoundException;

public class CRunLocation extends CRunExtension
{

    private LocationManager manager = null;
    private double longitude, latitude, altitude, speed, accuracy, bearing;
    private boolean supported;
    private long deltaTime;
    private String provider;
	private boolean appEndOn = false;
    private boolean gpsIsEnabled;
    private boolean networkIsEnabled;
    private Handler handler = new Handler();
    private Runnable test;
    private boolean fromDialog;

	private static int PERMISSIONS_LOCATION_REQUEST = 12377886;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
	private boolean fromAction;
	private int locMode = -1;

	private AlertDialog alert;
	
    public void createLocationServiceError(final Activity activity) {

        // show alert dialog if Internet is not connected
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        builder.setMessage(
                "You need to activate location service to use this feature. Please turn on network or GPS mode in location settings")
                .setTitle("GPS Location")
                .setCancelable(false)
                .setPositiveButton("Settings",
                        new DialogInterface.OnClickListener() {
                            @Override
							public void onClick(DialogInterface dialog, int id) {
                                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                                activity.startActivity(intent);
                                alert.dismiss();
                        		fromDialog = true;
                            }
                        })
                .setNegativeButton("Cancel",
                        new DialogInterface.OnClickListener() {
                            @Override
							public void onClick(DialogInterface dialog, int id) {
                                alert.dismiss();
                            }
                        });
        alert = builder.create();
        alert.show();
    }


    private LocationListener locationListener = new LocationListener()
    {

        @Override
		public void onLocationChanged(Location location)
        {
        	if (location == null)
                return;
            longitude = location.getLongitude();
            latitude = location.getLatitude();
            altitude = location.getAltitude();
            speed = location.getSpeed();
            accuracy = location.getAccuracy();
            bearing = location.getBearing();

            Calendar calendar = new GregorianCalendar();
            Date nowTime = new Date();
            calendar.setTime(nowTime);

            supported = true;
            deltaTime = calendar.getTimeInMillis() - location.getTime();
            
            ho.pushEvent(1, 0);
        }

        @Override
		public void onStatusChanged(String p, int status, Bundle extras)
        {
        	if (provider.contentEquals(p))
                supported = (status == LocationProvider.AVAILABLE);
        }

        @Override
		public void onProviderEnabled(String p)
        {
         	if (provider.contentEquals(p))
                supported = true;
        }

        @Override
		public void onProviderDisabled(String p)
        {
        	if (provider.contentEquals(p))
                supported = false;
        }
    };

	private void RestoreAutoEnd() {
		if(appEndOn) {
			appEndOn = false;
			MMFRuntime.inst.app.hdr2Options |= CRunApp.AH2OPT_AUTOEND;
		}
	}

	private void SuspendAutoEnd() {
		//AH2OPT_AUTOEND
		if (!appEndOn && MMFRuntime.inst.app != null && (MMFRuntime.inst.app.hdr2Options & CRunApp.AH2OPT_AUTOEND) != 0) {
			appEndOn = true;
			MMFRuntime.inst.app.hdr2Options &= ~ CRunApp.AH2OPT_AUTOEND;
		}
	}

	public CRunLocation()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 2;
    }

    private float requiredDistance;
    private int   requiredAccuracy;

    private String getPossibleProvider() {
    	String ret = null;
        gpsIsEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        networkIsEnabled = manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        
    	if (networkIsEnabled == true)
    		ret = LocationManager.NETWORK_PROVIDER;
    	else if (networkIsEnabled != true && gpsIsEnabled == true)
    		ret = LocationManager.GPS_PROVIDER;

    	return ret;
    	
    }
    
    public int getLocationMode()
    {
    	try {
			return Settings.Secure.getInt(ho.getControlsContext().getContentResolver(), Settings.Secure.LOCATION_MODE);
		} catch (SettingNotFoundException e) {
			return -1;
		}
    }
    
    private void restart()
    {
        Criteria criteria = new Criteria();
        
        if(requiredAccuracy > 3)
        	criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        else if (requiredAccuracy > 1)
        	criteria.setAccuracy(Criteria.ACCURACY_MEDIUM);
        else 
        	criteria.setAccuracy(Criteria.ACCURACY_FINE);
        	
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        criteria.setAltitudeRequired(true);
        criteria.setBearingRequired(true);
        criteria.setSpeedRequired(true);
        criteria.setCostAllowed(true);

        provider = manager.getBestProvider(criteria, true);

        manager.removeUpdates(locationListener);

        if(provider == null)
        	provider = getPossibleProvider();
        
        if (provider != null)
        {
            
        	if(provider.contentEquals(LocationManager.GPS_PROVIDER))
        	{
	            manager.requestLocationUpdates
	                (provider, requiredAccuracy >= 4 ? 60000 : (int)(requiredAccuracy * 1500 + 400),
	                    requiredDistance, locationListener, Looper.getMainLooper());
	            Log.Log("Request GPS ...");
        	}
        	if(provider.contentEquals(LocationManager.NETWORK_PROVIDER))
        	{
	            manager.requestLocationUpdates(provider, 0, 0, locationListener, Looper.getMainLooper());
	            Log.Log("Request Network ...");
        	}
           
        }
        
		handler = new Handler();
		test = new Runnable() {
		    @Override
		    public void run() {
		        gpsIsEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
		        networkIsEnabled = manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
		        handler.postDelayed(test, 1400); //1 sec.
		    }
		};
		handler.postDelayed(test, 1500);
    }

    private Location getLastKnownLocation() 
    {
        List<String> providers = manager.getProviders(true);
        Location bestLocation = null;
        
        for (String provider : providers) 
        {
            Location loc = manager.getLastKnownLocation(provider);
            if (loc == null) 
                continue;

            if (bestLocation == null || loc.getAccuracy() < bestLocation.getAccuracy())
                  bestLocation = loc;

        }
        return bestLocation;
    }
    
    private void locationLastKnown()
    {
    	if(manager == null)
    		return;
    	try 
    	{
    		Location llocation = manager.getLastKnownLocation(provider);
    		
    		if(llocation != null) 
    		{
    			longitude = llocation.getLongitude();
    			latitude = llocation.getLatitude();
    			altitude = llocation.getAltitude();
    			speed = llocation.getSpeed();
    			accuracy = llocation.getAccuracy();
    			bearing = llocation.getBearing();
    			ho.pushEvent(1, 0);
    		}
    		else
    			getLastKnownLocation();
    	} 
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}

    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        requiredDistance = file.readInt();
        requiredAccuracy = file.readInt();

        manager = (LocationManager) MMFRuntime.inst.getSystemService(Context.LOCATION_SERVICE);
        
        gpsIsEnabled = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        networkIsEnabled = manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
 
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.ACCESS_COARSE_LOCATION, "Coarse Location");
			permissionsApi23.put(Manifest.permission.ACCESS_FINE_LOCATION, "Fine location");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_LOCATION_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;

		if (enabled_perms && manager != null)
        	restart();

		/*  from API 19 until API 28
		 * 0 = LOCATION_MODE_OFF
		 * 1 = LOCATION_MODE_SENSORS_ONLY
		 * 2 = LOCATION_MODE_BATTERY_SAVING
		 * 3 = LOCATION_MODE_HIGH_ACCURACY
		 */
		locMode = getLocationMode();
        return true;
    }    
    
    @Override
	public void destroyRunObject(boolean bFast)
    {
        manager.removeUpdates(locationListener);
        if(handler != null && test != null)
            handler.removeCallbacks(test);

    }

	@Override
	public int handleRunObject()
	{
		if(MMFRuntime.inst != null) {
			MMFRuntime.inst.askForPermissionsApi23();		
		}
		return REFLAG_ONESHOT;
	}	
	
	@Override
	public void continueRunObject()
	{
		RestoreAutoEnd();
		if(fromDialog)
		{
			restart();
			fromDialog = false;
		}
	}
	
	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_LOCATION_REQUEST)) {
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
			if(enabled_perms) {
				if(!fromAction)
					restart();
				else
					startLocation();
			}
		}
		else
			enabled_perms = false;
	} 
   
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch (num)
        {
            case 0: // Enabled?
                return gpsIsEnabled;

            case 1: // Location changed
                return true;
        }

        return false;
    }

    private void startLocation() {
    	
    	if(!gpsIsEnabled && locMode == 0 ) {			// Only GPS off will turn ON location settings
    		SuspendAutoEnd();
    		fromDialog = false;
    		createLocationServiceError(MMFRuntime.inst);
    		restart();
    	}
		
		locationLastKnown();
    }
    @Override
	public void action(int num, CActExtension act)
    {
    	switch (num)
    	{
	    	case 0:
	    	{
	    		if(!enabled_perms) {
	    			MMFRuntime.inst.askForPermissionsApi23();
	    			return;
	    		}
	    		startLocation();
	    	}
	    	break;

    	case 1:

    		requiredDistance = (float) act.getParamExpDouble(rh, 0);
    		restart();

    		break;

    	case 2:

    		requiredAccuracy = act.getParamExpression(rh, 0);
    		restart();

    		break;
    	}
    }

    @Override
	public CValue expression(int num)
    {
        CValue value = new CValue(0);

        switch (num)
        {
            case 0: // Latitude

                value.forceDouble(latitude);
                break;

            case 1: // Longitude

                value.forceDouble(longitude);
                break;

            case 2: // Altitude

                value.forceDouble(altitude);
                break;

            case 3: // Course

                value.forceDouble(bearing);
                break;

            case 4: // Speed

                value.forceDouble(speed);
                break;

            case 5: // Time last

                value.forceInt((int) deltaTime);
                break;

            case 6: // Distance filter

                value.forceDouble(requiredDistance);
                break;

            case 7: // Accuracy

                value.forceDouble(accuracy);
                break;

        }

        return value;
    }

}
