package Extensions;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ScreenListener extends BroadcastReceiver{

	private OnScreenResultListener mListener;
		
	public ScreenListener() {
	}
	
	public ScreenListener(OnScreenResultListener listener) {
		mListener = listener;
	}

	/////////////////////
	//
	// Listeners
	//
	/////////////////////
	
	public interface OnScreenResultListener {
		public abstract void onScreenOFF();
	}
	
	// Allows the user to set an Listener and react to the event
	public void setOnScreenResultListener(OnScreenResultListener listener) {
		mListener = listener;
	}
	@Override
	public void onReceive(Context arg0, Intent intent) {
	    if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
	    	mListener.onScreenOFF();
	    }       
	}

}
