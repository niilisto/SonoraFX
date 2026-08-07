package Extensions;

import com.google.android.gms.maps.LocationSource;

import Runtime.MMFRuntime;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;

public class FollowMe implements LocationSource, LocationListener {

    public OnLocationChangedListener mListener;
    private LocationManager locationManager;
    private final Criteria criteria = new Criteria();
    private String bestAvailableProvider;
    /* Updates are restricted to one every 10 seconds, and only when
     * movement of more than 10 meters has been detected.*/
    public int minTime = 10000;     // minimum time interval between location updates, in milliseconds
    public int minDistance = 10;    // minimum distance between location updates, in meters
    public float Latitude  = 0;
    public float Longitude = 0;

    public static final int OUT_OF_SERVICE = 0;
    public static final int TEMPORARILY_UNAVAILABLE = 1;
    public static final int AVAILABLE = 2;
    
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
    
    public FollowMe(Activity activity) {
        // Get reference to Location Manager
        locationManager = (LocationManager) MMFRuntime.inst.getSystemService(Context.LOCATION_SERVICE);

        boolean enabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

        if(!enabled) {
        	createLocationServiceError(activity);
        }
        // Specify Location Provider criteria
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        criteria.setAltitudeRequired(true);
        criteria.setBearingRequired(true);
        criteria.setSpeedRequired(true);
        criteria.setCostAllowed(true);
        
    }

    public void getBestAvailableProvider() {
        /* The preferred way of specifying the location provider (e.g. GPS, NETWORK) to use 
         * is to ask the Location Manager for the one that best satisfies our criteria.
         * By passing the 'true' boolean we ask for the best available (enabled) provider. */
        bestAvailableProvider = locationManager.getBestProvider(criteria, true);
    }

    /* Activates this provider. This provider will notify the supplied listener
     * periodically, until you call deactivate().
     * This method is automatically invoked by enabling my-location layer. */
    @Override
    public void activate(OnLocationChangedListener listener) {
        // We need to keep a reference to my-location layer's listener so we can push forward
        // location updates to it when we receive them from Location Manager.
        mListener = listener;

        // Request location updates from Location Manager
        if (bestAvailableProvider != null) {
            locationManager.requestLocationUpdates(bestAvailableProvider, minTime, minDistance, this);
        } else {
            // (Display a message/dialog) No Location Providers currently available.
        }
    }
    
    public OnLocationChangedListener getListener() {
    	return mListener;
    }

    public void updateAccuracy() {
        if (bestAvailableProvider != null)
            locationManager.requestLocationUpdates(bestAvailableProvider, minTime, minDistance, this);    	
    }
    /* Deactivates this provider.
     * This method is automatically invoked by disabling my-location layer. */
    @Override
    public void deactivate() {
        // Remove location updates from Location Manager
        locationManager.removeUpdates(this);

        mListener = null;
    }

    @Override
    public void onLocationChanged(Location location) {
        // Push location updates to the registered listener..
        if (mListener != null) {
            mListener.onLocationChanged(location);
         }
    	Longitude = (float) location.getLongitude();
    	Latitude  = (float) location.getLatitude();
    }

    public Location LastKnowLocation(){
        // Getting Current Location
        Location location = locationManager.getLastKnownLocation(bestAvailableProvider);
        return location;
    }
    
    @Override
    public void onStatusChanged(String s, int i, Bundle bundle) {

    }

    @Override
    public void onProviderEnabled(String s) {

    }

    @Override
    public void onProviderDisabled(String s) {

    }
}

    