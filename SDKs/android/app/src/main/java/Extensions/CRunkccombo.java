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
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import Actions.CActExtension;
import Application.CRunApp;
import Conditions.CCndExtension;
import Expressions.CValue;
import OI.CObjectCommon;
import Params.CPositionInfo;
import RunLoop.CCreateObjectInfo;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Services.CServices;
import Services.UnicodeReader;
import android.Manifest;
import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

public class CRunkccombo extends CRunViewExtension
{
	List<String> list;
	@SuppressWarnings("rawtypes")
	ArrayAdapter adapter;

	boolean modified, bItemClick = false;
	boolean oneBased, sort, scrollToNewLine, system_color, b3dlook;

	int fColor = 0xff000000;
	int bColor = 0xffffffff;
	int lColor = 0xff333333;

	int brightColor = 0xFFFFFFFF;

	int nHeight;
	float scale = 1;
	
	boolean firstTime;
	boolean bVisible;
	CValue expRet;

	private static int PERMISSIONS_COMBO_REQUEST = 12377859;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
	private boolean api23_started;

	public CRunkccombo()
	{
		expRet = new CValue(0);
	}

	@Override
	public int getNumberOfConditions()
	{
		return 6;
	}

	public static final Comparator<String> comparator = new Comparator<String>() {
		@Override
		public int compare(String a, String b) {
			return a.compareTo(b);
		}
	};

	private void addLine(String text)
	{
		list.add(text);

		if (sort)
			Collections.sort (list, comparator);

		adapter.notifyDataSetChanged();
	}

	private CFontInfo font;

	@Override
	public void createRunView(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		Context context = ho.getControlsContext();
		Spinner field = new Spinner (context);
		
		this.ho.hoOEFlags |= CObjectCommon.OEFLAG_NEVERKILL;

		
		field.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener()
		{
			@Override
			public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
			{            	
				// This avoid false triggering when creating
				if(view != null) {		
					ho.generateEvent(3, 0);
				}
			}

			@Override
			public void onNothingSelected(AdapterView<?> parent)
			{
				bItemClick = false;
				ho.generateEvent(3, 0);

			}
		});

		ho.hoImgWidth = file.readShort();

		nHeight = file.readShort();

		ho.hoImgHeight = -1;
		
		if(rh.rhApp.bUnicode)
			font = file.readLogFont();
		else
			font = file.readLogFont16();

		//file.skipBytes(4); // Foreground color
		fColor = file.readColor(); // Foreground color

		if(rh.rhApp.bUnicode)
			file.skipBytes(80);
		else
			file.skipBytes(40);

		int flags = file.readInt();
		int lineCount = file.readShort();

		//file.skipBytes(4); // Background color
		bColor = file.readColor(); // Background color

		file.skipBytes(12);

		oneBased = (flags & 0x0100) != 0;

		system_color = (flags & 0x0040) != 0;

		b3dlook = true;

		field.setVerticalScrollBarEnabled((flags & 0x0008) != 0);

		sort = ((flags & 0x0010) != 0);
		scrollToNewLine = ((flags & 0x0080) != 0);

		//int comboType = (flags & 0x0007);

		list = new ArrayList <String> ();

		while (lineCount > 0)
		{
			String text = file.readString();
			list.add (text);
			--lineCount;
		}

		if (sort)
			Collections.sort(list);

		if ((rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) != 0) {
			font.font = Typeface.DEFAULT;
		}

		if((rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) != 0) {
			adapter = new ArrayAdapter<String> (context, android.R.layout.simple_spinner_item, list); 
		}
		else {

			adapter = new ArrayAdapter<String> (context, MMFRuntime.inst.getResourceID("layout/custom_spinner_item"), list) {

				@Override
				public View getView(int position, View convertView, ViewGroup parent) {

					View view =super.getView(position, convertView, parent);

					TextView text=(TextView) view.findViewById(android.R.id.text1);

					text.setTypeface(font.font);    				
					text.setTextSize(TypedValue.COMPLEX_UNIT_PX, font.lfHeight*(float) Math.sqrt(MMFRuntime.inst.scaleX*MMFRuntime.inst.scaleY)); //*72.0f/96.0f
					text.setGravity(Gravity.CENTER_VERTICAL);
					if(!system_color)
						text.setTextColor((0xff << 24) | fColor);

					text.setText(text.getText(),TextView.BufferType.SPANNABLE);

				   	if ((rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) == 0 &&  MMFRuntime.deviceApi < 18)	
				   		text.setPadding(2, 2, 1, 2);
				   	else
				   		text.setPadding(2, 0, 2, 0);

			   		if(MMFRuntime.targetApi < 11)
						nHeight = (int) Math.max(48, text.getLineHeight() + text.getPaddingBottom() + text.getPaddingTop()*1.5);
			   		else
						nHeight = text.getLineHeight() + text.getPaddingBottom() + text.getPaddingTop();
					
					return view;
				}

				@Override
				public View getDropDownView(int position, View convertView, ViewGroup parent)
				{
					View view = super.getView(position, convertView, parent);

					TextView text = (TextView)view.findViewById(android.R.id.text1);

					if(!system_color) {
						//choose your color   
						text.setBackgroundColor((0xFF << 24) | (bColor));

						text.setTextColor(new ColorStateList(
								new int[][] {
										new int[] { android.R.attr.state_pressed},
										new int[] { -android.R.attr.state_focused},
										new int[0]},
										new int[] { 
										(0xff << 24) | ~fColor,
										(0xff << 24) | fColor,
										(0xff << 24) | ~fColor, 
								}
								));
					}

					text.setTypeface(font.font);
					text.setTextSize(TypedValue.COMPLEX_UNIT_PX, font.lfHeight*(float) Math.sqrt(MMFRuntime.inst.scaleX*MMFRuntime.inst.scaleY));
					text.setGravity(Gravity.CENTER_VERTICAL);
					text.setText(text.getText(),TextView.BufferType.SPANNABLE);
			   		if(MMFRuntime.deviceApi < 22)
				   		text.setPadding(2, 2, 0, 2);
			   		else
				   		text.setPadding(2, 2, 0, 4);

					return view;
				}

			};

		}

		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

		field.setAdapter(adapter);

		
		//field.setMinimumHeight(nHeight + field.getPaddingBottom() + field.getPaddingTop() + 2);

		setView (field);
		
		adapter.notifyDataSetChanged();
		
		//if ((flags & 0x0020) != 0) // Hide on start
		bVisible = (flags & 0x0020) == 0; // Show on start
		

		firstTime = true;
		
		field.setVisibility(View.INVISIBLE);
		
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_COMBO_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;
		return ;
	}

	@Override
	public int handleRunObject()
	{
		super.handleRunObject ();
		
		if (view != null) {
			if(bVisible && firstTime) {
				view.setVisibility(View.VISIBLE);
				this.setViewHeight(nHeight);
				firstTime = false;
			}
		}
		if(MMFRuntime.inst != null && !api23_started) {
			api23_started = true;
			MMFRuntime.inst.askForPermissionsApi23();		
		}
		return 0;
	}
	
	@Override
	public void destroyRunObject(boolean bFast) {
		adapter = null; 
		view.setVisibility(View.GONE);
		setView (null);
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_COMBO_REQUEST))
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
		else
			enabled_perms = false;
	}

	@Override
	public CFontInfo getRunObjectFont()
	{
		return font;
	}

	@Override
	public void setRunObjectFont(CFontInfo font, CRect rc)
	{
		if ((rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) != 0) {
			return;
		}

		this.font = font;

		if(rc != null) {
			setViewWidth(rc.right - rc.left);
			setViewHeight(rc.bottom - rc.top);
		}
		else
			setViewHeight(nHeight);

		updateLayout();
		if(adapter != null)
			adapter.notifyDataSetChanged();
		
	}
	
	@Override
    public void setRunObjectTextColor(int rgb)  
    {
		this.fColor = rgb;
		if(adapter != null)
			adapter.notifyDataSetChanged();
    }

	private int getIndexParameter(CActExtension act, int index)
	{
		if (act == null)
			return ho.getExpParam().getInt() - (oneBased ? 1 : 0);;

		return act.getParamExpression(rh, index) - (oneBased ? 1 : 0);
	}

	private int fixIndexBase(int index)
	{
		return index + (oneBased ? 1 : 0);
	}

	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case 0: // Is visible?

				return view.getVisibility() == View.VISIBLE;

		case 1: // Is enabled?

			return view.isEnabled();

		case 2: // Double clicked

			return true;

		case 3: // Selection changed

			return true;

		case 4: // Has focus

			return view.isFocused();

		case 5: // Is dropped

			return false;
		}
		;

		return false;
	}


	@Override
	public void action(int num, CActExtension act)
	{
		switch (num)
		{
		case 0: // Load list file
			
			list.clear();

			try
			{
				String filename = act.getParamFilename(rh, 0);
				File lfile = new File(filename);

				if(!lfile.exists()) {
					if(!enabled_perms) {
						MMFRuntime.inst.askForPermissionsApi23();
						return;
					}
				}

				CRunApp.HFile file = ho.openHFile(filename, enabled_perms);

				UnicodeReader ur = new UnicodeReader(file.stream, MMFRuntime.inst.charSet);
				BufferedReader reader = new BufferedReader(ur);

				String s;
				while ((s = reader.readLine()) != null) {
					addLine(s);
				}
				reader.close();
				file.close();
			}
			catch(Exception e)
			{
			}

			if(adapter != null)
				adapter.notifyDataSetChanged();

			break;

		case 1: // Load drives list

			break;

		case 2: // Load directory list

			if(!enabled_perms) {
				MMFRuntime.inst.askForPermissionsApi23();
				return;
			}

			list.clear();

			try
			{

				for(File files : CServices.getFiles(act.getParamExpString(rh, 0))) {
					if(files.isDirectory())
						addLine(files.getAbsolutePath());
				}
			}
			catch(Exception e)
			{
			}

			if(adapter != null)
				adapter.notifyDataSetChanged();
			break;

		case 3: // Load files list

			if(!enabled_perms) {
				MMFRuntime.inst.askForPermissionsApi23();
				return;
			}

			list.clear();

			try
			{
				for(File files : CServices.getFiles(act.getParamExpString(rh, 0))) {
					if(!files.isDirectory())
						addLine(files.getName());
				}
			}
			catch(Exception e)
			{
			}

			if(adapter != null)
				adapter.notifyDataSetChanged();
			break;

		case 4: // Save list

			if(!enabled_perms) {
				MMFRuntime.inst.askForPermissionsApi23();
				return;
			}

			try
			{
				FileOutputStream file = new FileOutputStream(act.getParamExpString(rh, 0), false);

				for(String s : list)
				{
					file.write(s.getBytes(MMFRuntime.inst.charSet));
					file.write("\n".getBytes());
				}

				file.close();
			}
			catch(Exception e)
			{
			}

			break;

		case 5: // Reset

			list.clear();
			if(adapter != null)
				adapter.notifyDataSetChanged();

			break;

		case 6: // Add line

			addLine(act.getParamExpString(rh, 0));
			break;

		case 7: // Insert line
		{
			final int position = getIndexParameter(act, 0);
			final String line = act.getParamExpString(rh, 1);

			if (position < 0 || position >= list.size())
				list.add (line);
			else
				list.add(position, line);
			if(adapter != null)
				adapter.notifyDataSetChanged();

			break;
		}

		case 8: // Delete line
		{
			int index = getIndexParameter(act, 0);
			if ( index >= 0 && index < list.size() )
				list.remove(index);
			if(adapter != null)
				adapter.notifyDataSetChanged();
			break;
		}

		case 9: // Set current line
		{
			((Spinner) view).setSelection(getIndexParameter(act, 0));
			break;
		}

		case 10: // Show

			view.setVisibility (View.VISIBLE);
			firstTime = false;
			break;

		case 11: // Hide

			view.setVisibility (View.INVISIBLE);
			break;

		case 12: // Activate

			view.requestFocus ();
			break;

		case 13: // Enable

			view.setEnabled (true);
			break;

		case 14: // Disable

			view.setEnabled (false);
			break;

		case 15: // Set position

			CPositionInfo position = act.getParamPosition(rh, 0);

			ho.hoX = position.x;
			ho.hoY = position.y;

			break;

		case 16: // Set X position

			ho.hoX = act.getParamExpression(rh, 0);
			break;

		case 17: // Set Y position

			ho.hoY = act.getParamExpression(rh, 0);
			break;

		case 18: // Set size

			ho.setSize (act.getParamExpression(rh, 0),
					act.getParamExpression(rh, 1));

			break;

		case 19: // Set X size

			ho.setWidth (act.getParamExpression(rh, 0));
			break;

		case 20: // Set Y size

			ho.setHeight (act.getParamExpression(rh, 0));
			break;

		case 21: // Deactivate

			view.clearFocus ();
			break;

		case 22: // Set edit text

			break;

		case 23: // Scroll to top

			break;

		case 24: // Scroll to line

			break;

		case 25: // Scroll to end

			break;

		case 26: // Set color

			break;

		case 27: // Set background color

			break;

		case 28:

			break;

		case 29:

			break;

		case 30:

			break;

		case 31: // Change line

			final int index = getIndexParameter(act, 0);
			final String text = act.getParamExpString(rh, 1);

			list.set (index, text);
			if(adapter != null)
				adapter.notifyDataSetChanged();

			break;
		}
		;
	}

	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
			case 0: // Get selection index
	
				expRet.forceInt(fixIndexBase(((Spinner) view).getSelectedItemPosition()));
				return expRet;
	
			case 1: // Get selection text
	
				int selectionIndex = ((Spinner) view).getSelectedItemPosition();
	
				try
				{   
					expRet.forceString(list.get (selectionIndex));
					return expRet;
				}
				catch (Throwable e)
				{   
					expRet.forceString("");
					return expRet;
				}
	
			case 2: // Get selection directory
	
				expRet.forceString("");
				return expRet;
	
			case 3: // Get selection drive
	
				expRet.forceString("");
				return expRet;
				
			case 4: // Get line text
	
				// return new CValue(getIndexParameter(null, 0));
				try
				{
					return new CValue(list.get (getIndexParameter(null, 0)));
				}
				catch (Throwable t)
				{
					return new CValue ("");
				}
	
			case 5: // Get line directory
	
				ho.getExpParam();
	
				expRet.forceString("");
				return expRet;
	
			case 6: // Get line drive
	
				ho.getExpParam();
	
				expRet.forceString("");
				return expRet;
				
			case 7: // Get number of lines
	
				expRet.forceInt(list.size());
				return expRet;
	
			case 8: // Get X
	
				expRet.forceInt(ho.hoX);
				return expRet;
	
			case 9: // Get Y
	
				expRet.forceInt(ho.hoY);
				return expRet;
	
			case 10: // Get X size
	
				expRet.forceInt(ho.hoImgWidth);
				return expRet;
	
			case 11: // Get Y size
	
				expRet.forceInt(ho.hoImgHeight != -1 ? ho.hoImgHeight : nHeight);
				return expRet;
	
			case 12: // Get edit text
	
				expRet.forceString("");
				return expRet;
	
			case 13: // Get color
	
				expRet.forceInt(0);
				return expRet;
	
			case 14: // Get background color
	
				expRet.forceInt(0);
				return expRet;
	
			case 15: // Find string
			{
				expRet.forceInt(-1);
				String string = ho.getExpParam().getString();
				int startIndex = getIndexParameter(null, 0);
	
				if (startIndex >= list.size())
					return expRet;
	
				if (startIndex < 0)
					startIndex = 0;
	
				for (int i = startIndex; i < list.size(); ++i)
					if (list.get(i).contains(string)) {
						expRet.forceInt(fixIndexBase (i));
						return expRet;
					}
				return expRet;
			}
	
			case 16: // Find string exact
			{
				expRet.forceInt(-1);
				String string = ho.getExpParam().getString();
				int startIndex = getIndexParameter(null, 0);
	
				if (startIndex >= list.size())
					return expRet;
	
				if (startIndex < 0)
					startIndex = 0;
	
				int list_size = list.size();
				for (int i = startIndex; i < list_size; ++i)
					if (list.get(i).compareToIgnoreCase(string) == 0) {
						expRet.forceInt(fixIndexBase (i));
						return expRet;
					}
				return expRet;
			}
	
			case 17: // Get last index
				expRet.forceInt(list.size() - (oneBased ? 0 : 1));
				return expRet;
	
			case 18: // Get line data
				expRet.forceString("");
				return expRet;
	
			}
	
			expRet.forceInt(0);
			return expRet;
	}
}
