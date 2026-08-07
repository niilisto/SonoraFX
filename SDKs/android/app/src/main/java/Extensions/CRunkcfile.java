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
// CRunkcfile: extension object
//
//----------------------------------------------------------------------------------

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import Actions.CActExtension;
import Application.CRunApp;
import Conditions.CCndExtension;
import Expressions.CValue;
import Params.PARAM_PROGRAM;
import RunLoop.CCreateObjectInfo;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.Log;
import android.webkit.MimeTypeMap;

import android.support.v4.provider.*;


public class CRunkcfile extends CRunExtension
{
	private File currentDirectory;
	private File originalDirectory;
	private long lastError;
	private int fcDefaultFilter;
	private String fcDefaultExtension;
	private String fcResultPath;
	private String fcSelectorTitle;
	private boolean fileselect;
	private short objOi;

	// <editor-fold defaultstate="collapsed" desc=" A/C/E Constants ">
	public static final int CND_OK = 0;
	public static final int CND_EXISTS = 1;
	public static final int CND_ISREADABLE = 2;
	public static final int CND_ISWRITABLE = 3;
	public static final int CND_ISFILE = 4;
	public static final int CND_ISDIR = 5;
	public static final int CND_SELECTOR_OK = 6;
	public static final int CND_SELECTOR_CANCEL = 7;
	public static final int CND_LAST = 8;	

	public static final int ACT_DIRSET = 0;
	public static final int ACT_DIRSETORG = 1;
	public static final int ACT_DIRCREATE = 2;
	public static final int ACT_DIRDELETE = 3;
	public static final int ACT_FILECREATE = 4;
	public static final int ACT_FILEDELETE = 5;
	public static final int ACT_FILERENAME = 6;
	public static final int ACT_FILEAPPEND = 7;
	public static final int ACT_FILECOPY = 8;
	public static final int ACT_FILEMOVE = 9;
	public static final int ACT_FILEWRITE = 10;
	public static final int ACT_CLEARERROR = 11;
	public static final int ACT_RUN = 12;
	public static final int ACT_SETFSTITLE = 13;
	public static final int ACT_SETFSFLAGS = 14;
	public static final int ACT_RESETFSFLAGS = 15;
	public static final int ACT_SETFSFILTER = 16;
	public static final int ACT_SETFSEXT = 17;
	public static final int ACT_OPENLOADFS = 18;
	public static final int ACT_OPENSAVEFS = 19;
	public static final int ACT_SETFSSINGLESEL = 20;
	public static final int ACT_SETFSMULTIPLESEL = 21;
	public static final int ACT_OPENDIRSELECTOR = 22;
	public static final int ACT_LAST = 23;

	public static final int EXP_SIZE = 0;
	public static final int EXP_CREATEDATE = 1;
	public static final int EXP_MODIFDATE = 2;
	public static final int EXP_ACCESSDATE = 3;
	public static final int EXP_DRIVENAME = 4;
	public static final int EXP_DIRNAME = 5;
	public static final int EXP_FILENAME = 6;
	public static final int EXP_EXTNAME = 7;
	public static final int EXP_TOTALNAME = 8;
	public static final int EXP_CURRENTDIR = 9;
	public static final int EXP_FILEVERSIONMS = 10;
	public static final int EXP_FILEVERSIONLS = 11;
	public static final int EXP_LASTERROR = 12;
	public static final int EXP_TEMPFILE = 13;
	public static final int EXP_WINDIR = 14;
	public static final int EXP_GETFSRESULT = 15;
	public static final int EXP_CREATEPROMPT = 16;
	public static final int EXP_ALLOWBADFILE = 17;
	public static final int EXP_CHANGEDIR = 18;
	public static final int EXP_NONETWORKBUTTON = 19;
	public static final int EXP_NOOVERWRITEPROMPT = 20;
	public static final int EXP_ALLOWBADPATH = 21;
	public static final int EXP_GETFSDFILTER = 22;
	public static final int EXP_GETFSNUMBER = 23;
	public static final int EXP_GETFSRESULTAT = 24;
	public static final int EXP_DRIVEDIRFROMLABEL = 25;
	public static final int EXP_SYSDIR = 26;
	public static final int EXP_MYDOCDIR = 27;
	public static final int EXP_APPDATADIR = 28;
	public static final int EXP_USERDIR = 29;
	public static final int EXP_ALLUSERDIR = 30;
	public static final int EXP_ALLUSERDOCDIR = 31;
	public static final int EXP_ALLUSERAPPDATADIR = 32;
	public static final int EXP_LAST = 33;
	// </editor-fold>

	private static int PERMISSIONS_FILE_REQUEST = 12377869;
	private static int LOAD_FILE = 11177111;
	private static int LOAD_DIR  = 11199111;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
	
	private CValue expRet;
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

	public CRunkcfile()
	{
		expRet = new CValue();
	}
	@Override
	public int getNumberOfConditions()
	{
		return CND_LAST;
	}
	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		originalDirectory = new File(System.getProperty("user.dir"));
		currentDirectory = originalDirectory;
		lastError = 0;
		fcDefaultFilter = 0;
		fcDefaultExtension = "";
		fcResultPath = "";

		enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_FILE_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;
		return false;
	}
	@Override
	public void destroyRunObject(boolean bFast)
	{
	}
	@Override
	public void pauseRunObject()
	{
	}
	@Override
	public int handleRunObject()
	{
		if(MMFRuntime.inst != null && MMFRuntime.deviceApi > 22) {
			MMFRuntime.inst.askForPermissionsApi23();		
		}
		return REFLAG_ONESHOT;
	}	
	@Override
	public void continueRunObject()
	{
	}
	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_FILE_REQUEST))
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
		else
			enabled_perms = false;
	} 
	public boolean saveRunObject(DataOutputStream stream)
	{
		return true;
	}
	public boolean loadRunObject(DataInputStream stream)
	{
		return true;
	}
	public void killBackground()
	{
	}
	@Override
	public CFontInfo getRunObjectFont()
	{
		return null;
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
	
	public static String getDataColumn(Context context, Uri uri, String selection,
			String[] selectionArgs) {

		Cursor cursor = null;
		final String column = "_data";
		final String[] projection = {
				column
		};

		try {
			String filePath = getRealPathFromUri(context, uri);
			if(filePath == null) {
				cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs, null);
				if (cursor != null && cursor.moveToFirst()) {
					final int index = cursor.getColumnIndexOrThrow(column);
					return cursor.getString(index);
				}
			}
			else
				return filePath;
		} 
		catch(Exception e) {
			Log.d("AndroidRuntime", e.getMessage());
		}
		finally {
			if (cursor != null)
				cursor.close();
		}
		return null;
	}
	
	public static boolean isGooglePhotosUri(Uri uri) 
	{
	    return "com.google.android.apps.photos.content".equals(uri.getAuthority());
	}
	
	public static boolean isExternalStorageDocument(Uri uri)
	{
	    return "com.android.externalstorage.documents".equals(uri.getAuthority());
	}

	public static boolean isDownloadsDocument(Uri uri)
	{
	    return "com.android.providers.downloads.documents".equals(uri.getAuthority());
	}


	public static boolean isMediaDocument(Uri uri)
	{
	    return "com.android.providers.media.documents".equals(uri.getAuthority());
	}

	public static String getPath(Context context, Uri uri) throws URISyntaxException {
		   final boolean isKitKat = MMFRuntime.deviceApi >= 19;

		    // DocumentProvider
		    if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
		        // ExternalStorageProvider
		        if (isExternalStorageDocument(uri)) {
		            final String docId = DocumentsContract.getDocumentId(uri);
		            final String[] split = docId.split(":");
		            final String type = split[0];

		            if ("primary".equalsIgnoreCase(type)) 
		            {
		                return Environment.getExternalStorageDirectory() + "/" + split[1];
		            }

		            if ("secondary".equalsIgnoreCase(type)) 
		            {
		                return Environment.getExternalStorageDirectory() + "/" + split[1];
		            }
		            
		            if(new File("/storage/extSdCard/").exists()) 
		            {
		            	return "/storage/extSdCard/" + "/" + split[1];
		            }
		        }
		        // DownloadsProvider
		        else if (isDownloadsDocument(uri)) {

		            final String id = DocumentsContract.getDocumentId(uri);
		            final Uri contentUri = ContentUris.withAppendedId(
		                    Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

		            return getDataColumn(context, contentUri, null, null);
		        }
		        // MediaProvider
		        else if (isMediaDocument(uri)) {
		            final String docId = DocumentsContract.getDocumentId(uri);
		            final String[] split = docId.split(":");
		            final String type = split[0];

		            Uri contentUri = null;
		            if ("image".equals(type)) {
		                contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
		            } else if ("video".equals(type)) {
		                contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
		            } else if ("audio".equals(type)) {
		                contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
		            }

		            final String selection = "_id=?";
		            final String[] selectionArgs = new String[] {
		                    split[1]
		            };

		            return getDataColumn(context, contentUri, selection, selectionArgs);
		        }
		    }
		    // MediaStore (and general)
		    else if ("content".equalsIgnoreCase(uri.getScheme())) {

		        // Return the remote address
		        if (isGooglePhotosUri(uri))
		            return uri.getLastPathSegment();

		        return getDataColumn(context, uri, null, null);
		    }
		    // File
		    else if ("file".equalsIgnoreCase(uri.getScheme())) {
		        return uri.getPath();
		    }
		    
	    return null;
	} 
	
	public static String getRealPathFromUri(Context context, final Uri contentUri) {
		Cursor cursor = null;
		try {
			String[] proj = {MediaStore.Images.Media.DATA};
			cursor = context.getContentResolver().query(contentUri, proj, null, null, null);
			if (cursor == null) {
				return null;
			}
			int columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
			cursor.moveToFirst();
			return cursor.getString(columnIndex);
		}
		catch (Exception e) {
			return null;
		}
		finally {
			if (cursor != null) {
				cursor.close();
			}
		}
	}
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		fileselect = true;
		String filename=null;
		if (requestCode == LOAD_FILE && resultCode == Activity.RESULT_OK) {

			if(data == null)
			{
				objOi = -1;
				return;
			}

			Uri selectedFile = data.getData();
            try {
				filename = getPath(MMFRuntime.inst, selectedFile);
				if(filename != null && objOi == ho.hoOi) 			
				{
					fileselect = true;
					fcResultPath = filename;
					ho.activityEvent(CND_SELECTOR_OK, 0);
					return;
				}
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
			}

		}
		else if(requestCode == LOAD_FILE) {
			fileselect = false;	
			fcResultPath = "";
			ho.activityEvent(CND_SELECTOR_CANCEL, 0);
		}
		
		if (requestCode == LOAD_DIR && resultCode == Activity.RESULT_OK) {
			fcResultPath = "";
			Uri selectedFile = data.getData();
			Uri treeUri = null;
			DocumentFile document = DocumentFile.fromTreeUri(ho.getControlsContext(), treeUri);
			MMFRuntime.inst.grantUriPermission(MMFRuntime.inst.getPackageName(), treeUri, Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
			MMFRuntime.inst.getContentResolver().takePersistableUriPermission(treeUri, Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            try {
				filename = getPath(MMFRuntime.inst, selectedFile);
				if(filename != null && objOi == ho.hoOi) 			
				{
					fileselect = true;
					fcResultPath = filename;
					ho.activityEvent(CND_SELECTOR_OK, 0);
					return;
				}
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
			}

		}
		else if(requestCode == LOAD_DIR) {
			fileselect = false;	
			fcResultPath = "";
			ho.activityEvent(CND_SELECTOR_CANCEL, 0);			
		}
		objOi = -1;
		RestoreAutoEnd();
	}
    

	// Conditions
	// --------------------------------------------------
	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case CND_OK:
			return cndOK(cnd);
		case CND_EXISTS:
			return cndEXISTS(cnd);
		case CND_ISREADABLE:
			return cndISREADABLE(cnd);
		case CND_ISWRITABLE:
			return cndISWRITABLE(cnd);
		case CND_ISFILE:
			return cndISFILE(cnd);
		case CND_ISDIR:
			return cndISDIR(cnd);
		case CND_SELECTOR_OK:
			return cndSelectorOK(cnd);
		case CND_SELECTOR_CANCEL:
			return cndSelectorCancel(cnd);
		}
		return false;
	}

	// Actions
	// -------------------------------------------------
	@Override
	public void action(int num, CActExtension act)
	{
		switch (num)
		{
		case ACT_DIRSET:
			actDIRSET(act);
			break;
		case ACT_DIRSETORG:
			actDIRSETORG(act);
			break;
		case ACT_DIRCREATE:
			actDIRCREATE(act);
			break;
		case ACT_DIRDELETE:
			actDIRDELETE(act);
			break;
		case ACT_FILECREATE:
			actFILECREATE(act);
			break;
		case ACT_FILEDELETE:
			actFILEDELETE(act);
			break;
		case ACT_FILERENAME:
			actFILERENAME(act);
			break;
		case ACT_FILEAPPEND:
			actFILEAPPEND(act);
			break;
		case ACT_FILECOPY:
			actFILECOPY(act);
			break;
		case ACT_FILEMOVE:
			actFILEMOVE(act);
			break;
		case ACT_FILEWRITE:
			actFILEWRITE(act);
			break;
		case ACT_CLEARERROR:
			actCLEARERROR(act);
			break;
		case ACT_RUN:
			actRUN(act);
			break;
		case ACT_SETFSTITLE:
			actSETFSTITLE(act);
			break;
		case ACT_SETFSFLAGS:
			actSETFSFLAGS(act);
			break;
		case ACT_RESETFSFLAGS:
			actRESETFSFLAGS(act);
			break;
		case ACT_SETFSFILTER:
			actSETFSFILTER(act);
			break;
		case ACT_SETFSEXT:
			actSETFSEXT(act);
			break;
		case ACT_OPENLOADFS:
			actOPENLOADFS(act);
			break;
		case ACT_OPENSAVEFS:
			actOPENSAVEFS(act);
			break;
		case ACT_SETFSSINGLESEL:
			actSETFSSINGLESEL(act);
			break;
		case ACT_SETFSMULTIPLESEL:
			actSETFSMULTIPLESEL(act);
			break;
		case ACT_OPENDIRSELECTOR:
			actOPENDIRSELECTOR(act);
			break;
		}
		return;
	}

	// Expressions
	// --------------------------------------------
	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case EXP_SIZE:
			return expSIZE();
		case EXP_CREATEDATE:
			return expCREATEDATE();
		case EXP_MODIFDATE:
			return expMODIFDATE();
		case EXP_ACCESSDATE:
			return expACCESSDATE();
		case EXP_DRIVENAME:
			return expDRIVENAME();
		case EXP_DIRNAME:
			return expDIRNAME();
		case EXP_FILENAME:
			return expFILENAME();
		case EXP_EXTNAME:
			return expEXTNAME();
		case EXP_TOTALNAME:
			return expTOTALNAME();
		case EXP_CURRENTDIR:
			return expCURRENTDIR();
		case EXP_FILEVERSIONMS:
			return expFILEVERSIONMS();
		case EXP_FILEVERSIONLS:
			return expFILEVERSIONLS();
		case EXP_LASTERROR:
			return expLASTERROR();
		case EXP_TEMPFILE:
			return expTEMPFILE();
		case EXP_WINDIR:
			return expWINDIR();
		case EXP_GETFSRESULT:
			return expGETFSRESULT();
		case EXP_CREATEPROMPT:
			return expCREATEPROMPT();
		case EXP_ALLOWBADFILE:
			return expALLOWBADFILE();
		case EXP_CHANGEDIR:
			return expCHANGEDIR();
		case EXP_NONETWORKBUTTON:
			return expNONETWORKBUTTON();
		case EXP_NOOVERWRITEPROMPT:
			return expNOOVERWRITEPROMPT();
		case EXP_ALLOWBADPATH:
			return expALLOWBADPATH();
		case EXP_GETFSDFILTER:
			return expGETFSDFILTER();
		case EXP_GETFSNUMBER:
			return expGETFSNUMBER();
		case EXP_GETFSRESULTAT:
			return expGETFSRESULTAT();
		case EXP_DRIVEDIRFROMLABEL:
			return expDRIVEDIRFROMLABEL();
		case EXP_SYSDIR:
			return expSYSDIR();
		case EXP_MYDOCDIR:
			return expMYDOCDIR();
		case EXP_APPDATADIR:
			return expAPPDATADIR();
		case EXP_USERDIR:
			return expUSERDIR();
		case EXP_ALLUSERDIR:
			return expALLUSERDIR();
		case EXP_ALLUSERDOCDIR:
			return expALLUSERDOCDIR();
		case EXP_ALLUSERAPPDATADIR:
			return expALLUSERAPPDATADIR();
		}
		return null;
	}
	// Helper functions
	File getAbsoluteFile(String path)
	{
		if(!enabled_perms) {
			MMFRuntime.inst.askForPermissionsApi23();
			return null;
		}
		File f = new File(path);
		if (f.isAbsolute())
		{
			return f;
		}
		else
		{
			return new File(currentDirectory, path);
		}
	}

	// Conditions

	private boolean cndOK(CCndExtension cnd)
	{
		return lastError == 0;
	}
	private boolean cndEXISTS(CCndExtension cnd)
	{
		try
		{
			return getAbsoluteFile(cnd.getParamExpString(rh, 0)).exists();
		}
		catch (Exception e)
		{
			return false;
		}
	}
	private boolean cndISREADABLE(CCndExtension cnd)
	{
		try
		{
			return getAbsoluteFile(cnd.getParamExpString(rh, 0)).canRead();
		}
		catch (Exception e)
		{
			return false;
		}
	}
	private boolean cndISWRITABLE(CCndExtension cnd)
	{
		try
		{
			return getAbsoluteFile(cnd.getParamExpString(rh, 0)).canWrite();
		}
		catch (Exception e)
		{
			return false;
		}
	}
	boolean cndISFILE(CCndExtension cnd)
	{
		try
		{
			return getAbsoluteFile(cnd.getParamExpString(rh, 0)).isFile();
		}
		catch (Exception e)
		{
			return false;
		}
	}
	private boolean cndISDIR(CCndExtension cnd)
	{
		try
		{
			return getAbsoluteFile(cnd.getParamExpString(rh, 0)).isDirectory();
		}
		catch (Exception e)
		{
			return false;
		}
	}
	private boolean cndSelectorOK(CCndExtension cnd)
	{
		return true;
	}
	private boolean cndSelectorCancel(CCndExtension cnd)
	{
		return true;
	}

	private void actDIRSET(CActExtension act)
	{
		File f = getAbsoluteFile(act.getParamExpString(rh, 0));
		try {
			if (f.isDirectory())
			{
				currentDirectory = f;
			}
		}
		catch(Exception e)
		{
			lastError = -1;
		}
	}
	private void actDIRSETORG(CActExtension act)
	{
		currentDirectory = originalDirectory;
	}
	private void actDIRCREATE(CActExtension act)
	{
		File f = getAbsoluteFile(act.getParamExpString(rh, 0));
		try
		{
			if (f.mkdir())
			{
				return; // all ok
			}
		}
		catch (Exception e)
		{
			// Swallow exception
		}
		lastError = -1;
	}
	private void actDIRDELETE(CActExtension act)
	{
		File f = getAbsoluteFile(act.getParamExpString(rh, 0));
		try
		{
			if (f.isDirectory()) 
			{
			    String[] infiles = f.list();
			    for (int i = 0; i < infiles.length; i++)
			    {
			    	File fi = new File(f, infiles[i]);
			    	if(!(fi.getCanonicalFile().delete()))
			    		deleteAsContent(ho.getControlsContext(), fi);
			    }
			}
			if (f.delete())
			{
				return; // all ok
			}
		}
		catch (Exception e)
		{
			// Swallow exception
		}
		lastError = -1;
	}
	private void actFILECREATE(CActExtension act)
	{
		File f = getAbsoluteFile(act.getParamExpString(rh, 0));
		try
		{
			if (f.createNewFile())
			{
				return; // all ok
			}
		}
		catch (Exception e)
		{
			// Swallow exception
		}
		lastError = -1;
	}
	private void actFILEDELETE(CActExtension act)
	{
		File f = getAbsoluteFile(act.getParamExpString(rh, 0));
		try
		{
			if (!f.getCanonicalFile().delete())
			{
				if (deleteAsContent(ho.getControlsContext(), f)) 
				{
					return; // all ok
				}
			}
		}
		catch (Exception e)
		{
			// Swallow exception
			Log.d("AndroidRuntime", e.getMessage());
		}
		lastError = -1;
		
	}
	private void actFILERENAME(CActExtension act)
	{
		File fOld = getAbsoluteFile(act.getParamExpString(rh, 0));
		File fNew = getAbsoluteFile(act.getParamExpString(rh, 1));
		try
		{
			if (fOld.renameTo(fNew))
			{
				return; // all ok
			}
		}
		catch (Exception e)
		{
			// Swallow exception
		}
		lastError = -1;
	}

	// Copies or appends a file
	private boolean copyFile(File src, File dest, boolean append)
	{
		try
		{
			FileInputStream input = new FileInputStream(src);
			try
			{
				FileOutputStream output = new FileOutputStream(dest, append);
				try
				{
					byte[] buffer = new byte[65536];
					int bytesRead = 0;
					while ((bytesRead = input.read(buffer)) != -1)
					{
						output.write(buffer, 0, bytesRead);
					}
					// All done!
					return true;
				}
				finally
				{
					output.close();
				}
			}
			finally
			{
				input.close();
			}
		}
		catch (Exception e)
		{
			// Swallow exceptions
		}
		return false;
	}
	private void actFILEAPPEND(CActExtension act)
	{
		File fSrc = getAbsoluteFile(act.getParamExpString(rh, 0));
		File fDest = getAbsoluteFile(act.getParamExpString(rh, 1));
		if (!copyFile(fSrc, fDest, true))
		{
			lastError = -1;
		}
	}
	private void actFILECOPY(CActExtension act)
	{
		File fSrc = getAbsoluteFile(act.getParamExpString(rh, 0));
		File fDest = getAbsoluteFile(act.getParamExpString(rh, 1));
		if (!copyFile(fSrc, fDest, false))
		{
			lastError = -1;
		}
	}
	void actFILEMOVE(CActExtension act)
	{
		File fSrc = getAbsoluteFile(act.getParamExpString(rh, 0));
		File fDest = getAbsoluteFile(act.getParamExpString(rh, 1));
		// Check we can read first
		if (fSrc.canRead())
		{
			lastError = -1;
			return;
		}
		// Try a rename if possible
		if (fSrc.renameTo(fDest))
		{
			// Ok!
			return;
		}
		// If not, (over)write the destination, then delete the old file
		if (copyFile(fSrc, fDest, false))
		{
			if (fSrc.delete())
			{
				// Ok!
				return;
			}
		}
		lastError = -1;
	}
	// Append text to a file
	void actFILEWRITE(CActExtension act)
	{
		String text = act.getParamExpString(rh, 0);
		File fDest = getAbsoluteFile(act.getParamExpString(rh, 1));
		try
		{
			FileWriter output = new FileWriter(fDest, true);
			try
			{
				output.write(text);
				return;
			}
			finally
			{
				output.close();
			}
		}
		catch (Exception e)
		{
			lastError = -1;
		}
	}
	void actCLEARERROR(CActExtension act)
	{
		lastError = 0;
	}
	void actRUN(CActExtension act)
	{
		String cmd = act.getParamExpString(rh, 0);
		String arg = act.getParamExpString(rh, 1);
		short flags = 0;

		// Get program flags
		Pattern p = Pattern.compile("^\\((WAIT|HIDE)?,?(WAIT|HIDE)?\\)(.*)", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(arg);
		if (m.matches())
		{
			if (m.group(1).equals("WAIT") || m.group(2).equals("WAIT"))
			{
				flags |= PARAM_PROGRAM.PRGFLAGS_WAIT;
			}
			if (m.group(1).equals("HIDE") || m.group(2).equals("HIDE"))
			{
				flags |= PARAM_PROGRAM.PRGFLAGS_HIDE;
			}
			arg = m.group(3);
		}

		ho.execProgram(cmd, arg, flags);
	}
	private void actSETFSTITLE(CActExtension act)
	{
		fcSelectorTitle = act.getParamExpString(rh, 0);
	}
	private void actSETFSFLAGS(CActExtension act)
	{
	}
	private void actRESETFSFLAGS(CActExtension act)
	{
	}
	private void actSETFSFILTER(CActExtension act)
	{
	}
	private void actSETFSEXT(CActExtension act)
	{
		fcDefaultExtension = act.getParamExpString(rh, 0);
	}
	private void selectorFiles(String defaultdir)
	{
		Uri selectedUri = Uri.parse(defaultdir);
		String type = "resource/folder";
		
		Intent intent;

        if (MMFRuntime.deviceApi >= 19)
        {
            intent = new Intent("android.intent.action.ACTION_OPEN_DOCUMENT");
            intent.setType("*/*");
        } 
        else
        {
            PackageManager packageManager = MMFRuntime.inst.getPackageManager();
            intent = new Intent("android.intent.action.GET_CONTENT");
            intent.setType("file*//*");
        }
        
        if(fcDefaultExtension.length() > 0)
            type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(fcDefaultExtension);

        if(defaultdir.length() > 0)
        	intent.setDataAndType(selectedUri, type );
        
        if (intent.resolveActivity(MMFRuntime.inst.getPackageManager()) != null)
        {
        	SuspendAutoEnd();
    		objOi = ho.hoOi;
    		if(fcSelectorTitle != null && fcSelectorTitle.length() > 0)
    			intent.putExtra("KEY", fcSelectorTitle);

        	MMFRuntime.inst.startActivityForResult(intent, LOAD_FILE);
        }

	}
	private void actOPENLOADFS(CActExtension act)
	{
		selectorFiles(act.getParamExpString(rh, 0));
	}
	private void actOPENSAVEFS(CActExtension act)
	{
	}
	private void actSETFSSINGLESEL(CActExtension act)
	{
	}
	private void actSETFSMULTIPLESEL(CActExtension act)
	{
	}
	private void actOPENDIRSELECTOR(CActExtension act)
	{
		String defaultdir = act.getParamExpString(rh, 0);
		Uri selectedUri = Uri.parse(defaultdir);
		String type = "resource/folder";
		
		Intent intent;

        if (MMFRuntime.deviceApi >= 19)
        {
            intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
          	SuspendAutoEnd();
       		objOi = ho.hoOi;
            MMFRuntime.inst.startActivityForResult(intent, LOAD_DIR);
        } 
       
 		
	}

	// Expressions
	// -------------------------------------------------
	private CValue expSIZE()
	{
		expRet.forceInt(0);
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if(f != null)
			expRet.forceInt((int)f.length());
		return expRet;
	}
	private CValue expCREATEDATE()
	{
		expRet.forceString("");
		return expRet;
	}
	private CValue expMODIFDATE()
	{
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if(f != null) {
			Date date = new Date(f.lastModified());
			DateFormat dateFormat = DateFormat.getDateInstance();
			expRet.forceString(dateFormat.format(date));
		}
		else
			expRet.forceString("");
			
		return expRet;
	}
	private CValue expACCESSDATE()
	{
		expRet.forceString("");
		return expRet;
	}
	private CValue expDRIVENAME()
	{
		expRet.forceString("");
		return expRet;
	}
	private CValue expDIRNAME()
	{
		expRet.forceString("");
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if (f.isDirectory())
		{
			expRet.forceString(f.getAbsolutePath());
		}
		else
		{
			expRet.forceString(f.getParentFile().getAbsolutePath());
		}
		return expRet;
	}
	private CValue expFILENAME()
	{
		expRet.forceString("");
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if(f!= null)
			expRet.forceString(f.getName());
		return expRet;
		
	}
	private CValue expEXTNAME()
	{
		expRet.forceString("");
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if(f!= null) {
			String ext = f.getName();
			int cutPos = ext.lastIndexOf('.');
			if (cutPos != -1)
				expRet.forceString(ext.substring(cutPos + 1));
		}
		return expRet;
	}
	private CValue expTOTALNAME()
	{
		expRet.forceString("");
		File f = getAbsoluteFile(ho.getExpParam().getString());
		if(f!= null)
			expRet.forceString(f.getAbsolutePath());

		return expRet;
	}
	private CValue expCURRENTDIR()
	{
		expRet.forceString(currentDirectory.getAbsolutePath());
		return expRet;
	}
	private CValue expFILEVERSIONMS()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expFILEVERSIONLS()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expLASTERROR()
	{
		expRet.forceInt((int)lastError);
		return expRet;
	}
	private CValue expTEMPFILE()
	{
		expRet.forceString("");
		try
		{
			File f = File.createTempFile(ho.getExpParam().getString(), null);
			expRet.forceString(f.getAbsolutePath());
		}
		catch (Exception e)
		{
		}
		return expRet;		
	}
	private CValue expWINDIR()
	{
		expRet.forceString("");
		return expRet;		
	}
	private CValue expGETFSRESULT()
	{
		expRet.forceString(fcResultPath);
		return expRet;		
	}
	private CValue expCREATEPROMPT()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expALLOWBADFILE()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expCHANGEDIR()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expNONETWORKBUTTON()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expNOOVERWRITEPROMPT()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expALLOWBADPATH()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expGETFSDFILTER()
	{
		expRet.forceInt(fcDefaultFilter);
		return expRet;	
	}
	private CValue expGETFSNUMBER()
	{
		expRet.forceInt(0);
		return expRet;
	}
	private CValue expGETFSRESULTAT()
	{
		expRet.forceString("");
		return expRet;
	}
	private CValue expDRIVEDIRFROMLABEL()
	{
		expRet.forceString("");
		return expRet;
	}
	private CValue expSYSDIR()
	{
		expRet.forceString("");
		return expRet;
	}
	@SuppressLint("NewApi")
	private CValue expMYDOCDIR()
	{
		if(MMFRuntime.deviceApi < 19)
			expRet.forceString(System.getProperty("user.home"));
		else
			expRet.forceString(Environment.getExternalStoragePublicDirectory("Documents").getAbsolutePath());
			
		return expRet;
	}
	private CValue expAPPDATADIR()
	{
		expRet.forceString(Environment.getDataDirectory().getAbsolutePath());
		return expRet;
	}
	private CValue expUSERDIR()
	{
		expRet.forceString(System.getProperty("user.home"));
		return expRet;
	}
	private CValue expALLUSERDIR()
	{
		expRet.forceString("");
		return expRet;	}
	private CValue expALLUSERDOCDIR()
	{
		expRet.forceString("");
		return expRet;	}
	private CValue expALLUSERAPPDATADIR()
	{
		expRet.forceString("");
		return expRet;	}
	
	//////////////////////////////////////////////
	//
	//
	//
	//////////////////////////////////////////////
	private boolean deleteAsContent(final Context context, final File file) {
		final String where = MediaStore.MediaColumns.DATA + "=?";
		final String[] selectionArgs = new String[] {
				file.getAbsolutePath()
		};
		final ContentResolver contentResolver = context.getContentResolver();
		final Uri filesUri = MediaStore.Files.getContentUri("external");

		contentResolver.delete(filesUri, where, selectionArgs);

		if(file.exists())
		{
	            DocumentFile document = DocumentFile.fromFile(file);
	            return document != null && document.delete();
		}
		return !file.exists();
	}

	@TargetApi(11)
	private static Uri getUriFromFile(Context context, File file) 
	{
		// Note: check outside this class whether the OS version is >= 11 
		Uri uri = null; 
		Cursor cursor = null; 
		ContentResolver contentResolver = null;

		try
		{ 
			contentResolver=context.getContentResolver(); 
			if (contentResolver == null)
				return null;

			uri=MediaStore.Files.getContentUri("external"); 
			String[] projection = new String[2]; 
			projection[0] = "_id"; 
			projection[1] = "_data"; 
			String selection = "_data = ? ";    // this avoids SQL injection 
			String[] selectionParams = new String[1]; 
			selectionParams[0] = file.getName(); 
			String sortOrder = "_id"; 
			cursor=contentResolver.query(uri, projection, selection, selectionParams, sortOrder); 

			if (cursor!=null) 
			{ 
				try 
				{ 
					if (cursor.getCount() > 0) // file present! 
					{   
						cursor.moveToFirst(); 
						int dataColumn=cursor.getColumnIndex("_data"); 
						String s = cursor.getString(dataColumn); 
						if (!s.equals(file.getName())) 
							return null; 
						int idColumn = cursor.getColumnIndex("_id"); 
						long id = cursor.getLong(idColumn); 
						uri= MediaStore.Files.getContentUri("external",id); 
					} 
					else // file isn't in the media database! 
					{   
						ContentValues contentValues=new ContentValues(); 
						contentValues.put("_data",file.getName()); 
						uri = MediaStore.Files.getContentUri("external"); 
						uri = contentResolver.insert(uri,contentValues); 
					} 
				} 
				catch (Throwable e) 
				{ 
					uri = null; 
				}
				finally
				{
					cursor.close();
				}
			} 
		} 
		catch (Throwable e) 
		{ 
			uri=null; 
		} 
		return uri; 
	} 
	
}
