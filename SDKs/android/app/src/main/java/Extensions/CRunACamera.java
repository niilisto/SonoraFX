/* Copyright (c) 1996-2014 Clickteam
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
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.hardware.Camera;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.provider.MediaStore.MediaColumns;

@SuppressWarnings("deprecation")
@SuppressLint("NewApi")
public class CRunACamera extends CRunExtension{

	public static final int CND_LAST = 4;

	private boolean actiondone=false;
	private String szError;
	private String AlbumName;
	private String picturepath;
	private String videopath;
	private String selectedpath;
	private int nError;
	private int nCamera;
	private int angle;
	
	private Uri retFile;

	private static final int ACTION_TAKE_PHOTO = 10001;
	private static final int ACTION_TAKE_VIDEO = 10002;
	private static final int SELECT_GALLERY = 10009;

	private String mCurrentPhotoPath;

	private static final String JPEG_FILE_PREFIX = "IMG_";
	private static final String JPEG_FILE_SUFFIX = ".jpg";

	private AlbumStorageDirFactory mAlbumStorageDirFactory = null;
	
	private static int PERMISSIONS_ACAMERA_REQUEST = 12377899;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
	
    private boolean appEndOn = false;
	//////////////////////////////////////////////////////////////////////
	//
	//			Control functions
	//
	/////////////////////////////////////////////////////////////////////

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


	public CRunACamera() {
		// TODO Auto-generated constructor stub
	}

	public @Override int getNumberOfConditions()
	{
		return CND_LAST;
	}

	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		nError = 0;
		szError="";
		actiondone = false;
		picturepath = "";
		videopath = "";
		selectedpath = "";
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
			mAlbumStorageDirFactory = new FroyoAlbumDirFactory();
		} else {
			mAlbumStorageDirFactory = new BaseAlbumDirFactory();
		}

		if(MMFRuntime.deviceApi > Build.VERSION_CODES.FROYO)
			nCamera = Camera.getNumberOfCameras();
		else
			nCamera = 1;
			
		
		// For Api 23
		enabled_perms = false;
		
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.CAMERA, "Camera");
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_ACAMERA_REQUEST);
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
	public void continueRunObject()
	{
		if(actiondone && picturepath.length()> 0)
			ho.pushEvent(0, 0);

		if(actiondone && videopath.length()> 0)
			ho.pushEvent(1, 0);

		if(actiondone && selectedpath.length()> 0)
			ho.pushEvent(2, 0);

		if(nError != 0)
			ho.pushEvent(3, 0);
		
	}

	@Override
	public int handleRunObject()
	{
		if(MMFRuntime.inst != null) {
			MMFRuntime.inst.askForPermissionsApi23();		
		}
		return REFLAG_ONESHOT;
	}
	
	private String getPathfromUri(Intent data) {
		Uri selectedImage;
		String filePath="";
		selectedImage = data.getData();
		if(selectedImage != null) {
			String[] filePathColumn = {MediaColumns.DATA};

			Cursor cursor = MMFRuntime.inst.getContentResolver().query(
					selectedImage, filePathColumn, null, null, null);
			if(cursor != null) {
				cursor.moveToFirst();

				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				filePath = cursor.getString(columnIndex);
				cursor.close();
			}
		}
		if (mCurrentPhotoPath != null) {
			filePath = mCurrentPhotoPath;
			mCurrentPhotoPath = null;
		}
		return filePath;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		nError = 0;
		szError="";
		actiondone = true;
		picturepath = "";
		videopath = "";
		selectedpath = "";
		if (resultCode == Activity.RESULT_OK) {
			switch (requestCode) 
			{
			case ACTION_TAKE_PHOTO:
				if(data != null) {
					picturepath = getPathfromUri(data);
					if(picturepath != null) {
						galleryAddPic(picturepath);
						angle = AngleImage(picturepath);
					}
				} else {
					if (mCurrentPhotoPath != null) {
						galleryAddPic(mCurrentPhotoPath);
						picturepath = mCurrentPhotoPath;
						mCurrentPhotoPath = null;
						angle = AngleImage(picturepath);
					}
				}


				break;
			case ACTION_TAKE_VIDEO:
				if(data != null)
					videopath = getPathfromUri(data);
				
				break;
				
			case SELECT_GALLERY:
				if(data != null) {
					selectedpath = getPathfromUri(data);
					angle = AngleImage(selectedpath);
				} else {
					selectedpath = "";
					angle = 0;
				}
				break;
			} 
		}
		else 
		{
			nError = 1;
			szError="Process cancelled";
			actiondone = false;			
		}
		RestoreAutoEnd();
		MMFRuntime.inst.mainView.requestFocus();
	}
	
	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_ACAMERA_REQUEST))
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
		else
			enabled_perms = false;
	}

	// Conditions
	// -------------------------------------------------	
	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case 0: /* on Picture Taken? */
			return true;

		case 1: /* On Video Taken? */
			return true;

		case 2: /* On Gallery Return? */
			return true;

		case 3: /* On Error */	            	
			return true;	            	
		}

		return false;
	}

	private int AngleImage(String file) {
		int angle = 0;
		ExifInterface ei;
		try {
			ei = new ExifInterface(file);
			int orientation = ei.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

			switch(orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				angle = 90;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				angle = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				angle = 270;
				break;
			}
			// etc.
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return angle;
	}
	
	private void galleryAddPic(String file) {
		Intent mediaScanIntent = new Intent("android.intent.action.MEDIA_SCANNER_SCAN_FILE");
		File f = new File(file);
		Uri contentUri = Uri.fromFile(f);
		mediaScanIntent.setData(contentUri);
		MMFRuntime.inst.sendBroadcast(mediaScanIntent);
	}

	private File getAlbumDir() {
		File storageDir = null;

		if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {

			if(AlbumName == null)
					AlbumName = ho.hoAdRunHeader.rhApp.appName;

			storageDir = mAlbumStorageDirFactory.getAlbumStorageDir(AlbumName);

			if (storageDir != null) {
				if (! storageDir.mkdirs()) {
					if (! storageDir.exists()){
						Log.Log("failed to create directory");
						nError = 3;
						szError="Failing to create album directory";
						ho.pushEvent(3, 0);
						return null;
					}
				}
			}

		} else {
			Log.Log("External storage is not mounted READ/WRITE.");
			nError = 2;
			szError="Problem using external storage";
			ho.pushEvent(3, 0);
			
		}

		return storageDir;
	}

	private File createImageFile() throws IOException {
		// Create an image file name
		String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
		String imageFileName = JPEG_FILE_PREFIX + timeStamp + "_";
		File albumF = getAlbumDir();
		File imageF = File.createTempFile(imageFileName, JPEG_FILE_SUFFIX, albumF);
		return imageF;
	}

	private File setUpPhotoFile() throws IOException {

		File f = createImageFile();
		mCurrentPhotoPath = f.getAbsolutePath();

		return f;
	}


	private void TakeImageCamera(int camera, String title, String description) {
		
		if(!enabled_perms) {
			MMFRuntime.inst.askForPermissionsApi23();
			return;
		}
		
		String manufacturer = android.os.Build.MANUFACTURER;
		Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

		StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
	    StrictMode.setVmPolicy(builder.build());
	    
		if(!((manufacturer.contains("samsung")) || (manufacturer.contains("sony")) || (manufacturer.contains("lge"))) || MMFRuntime.deviceApi > 18) {
			File f = null;
	
			try {
				f = setUpPhotoFile();
				mCurrentPhotoPath = f.getAbsolutePath();
				takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f));
			} catch (IOException e) {
				e.printStackTrace();
				f = null;
				mCurrentPhotoPath = null;
			}
	
			if(nCamera > 1) {
				if(camera == 1)
					takePictureIntent.putExtra("android.intent.extras.CAMERA_FACING", 1);
				else 
					takePictureIntent.putExtra("android.intent.extras.CAMERA_FACING", 0);
			}
		}
		if (MMFRuntime.deviceApi > 20)
			takePictureIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);

		actiondone = false;
		SuspendAutoEnd();
		MMFRuntime.inst.startActivityForResult(takePictureIntent, ACTION_TAKE_PHOTO);

	}
	private void TakeVideoCamera(int camera) {
		if(!enabled_perms) {
			MMFRuntime.inst.askForPermissionsApi23();
			return;
		}
		
		Intent takeVideoIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
		takeVideoIntent.putExtra(android.provider.MediaStore.EXTRA_VIDEO_QUALITY, 1);
		
		if(nCamera > 1) {
			if(camera == 1)
				takeVideoIntent.putExtra("android.intent.extras.CAMERA_FACING", 1);
			else 
				takeVideoIntent.putExtra("android.intent.extras.CAMERA_FACING", 0);
		}
		actiondone = false;
		SuspendAutoEnd();
		MMFRuntime.inst.startActivityForResult(takeVideoIntent, ACTION_TAKE_VIDEO);

	}

	private void selectFromGallery(int type) {
		Intent galleryPickerIntent = new Intent(Intent.ACTION_PICK);
		
		if(type == 0)
			galleryPickerIntent.setType("image/*,video/*");
		else if (type == 1)
			galleryPickerIntent.setType("image/*");
		else
			galleryPickerIntent.setType("video/*");
		
		actiondone = false;
		SuspendAutoEnd();
		MMFRuntime.inst.startActivityForResult(galleryPickerIntent, SELECT_GALLERY);
	}

	// Actions
	// -------------------------------------------------
	@Override
	public void action(int num, CActExtension act)
	{

		switch (num)
		{
		/* actions */

		case 0:	/* Set Album name */	 	
			AlbumName = act.getParamExpString(rh, 0);
			break;
		case 1: /* Take an Image by Camera */   	
			TakeImageCamera(act.getParamExpression(rh, 0), act.getParamExpString(rh, 1),act.getParamExpString(rh, 2));
			break;
		case 2: /* Take a Video by Camera */ 
			TakeVideoCamera(act.getParamExpression(rh, 0));
			break;
		case 3: /* Select from Gallery */ 
			selectFromGallery(act.getParamExpression(rh, 0));
			break;
		}
	}


	// Expressions
	// -------------------------------------------------
	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case 0: /* Error Number */
			return new CValue(nError);

		case 1: /* Error String$ */
			return new CValue(szError);

		case 2: /* Picture path$ */
			return new CValue(picturepath);

		case 3: /* Video path$ */
			return new CValue(videopath);

		case 4: /* Gallery path$ */
			return new CValue(selectedpath);
			
		case 5: /* Cameras Numbers */
			return new CValue(nCamera);

		case 6: /* Picture Rotation */
			return new CValue(angle);
		}

		return new CValue(0);
	}

}
