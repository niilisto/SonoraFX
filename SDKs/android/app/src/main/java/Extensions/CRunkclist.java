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
import RunLoop.CRun;
import Runtime.Log;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Services.CServices;
import Services.UnicodeReader;
import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.GradientDrawable.Orientation;
import android.os.Build;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class CRunkclist extends CRunViewExtension
{
	List<ListData> list;

	BaseAdapter adapter;

	boolean modified;
	boolean onfocus;
	boolean oneBased, sort, scrollToNewLine, system_color, b3dlook;
	int selection;
	int list_idx;
	int flags;
	int clickLoop;
	
	float scale;

	int fColor;
	int bColor;

	boolean firstTime;
	boolean bVisible;
	boolean UseSystemFont;
	CValue expRet;
	
	private ListView field;
	
	private static int PERMISSIONS_LIST_REQUEST = 12377819;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
    private boolean api23_started;
 
    public static Comparator<ListData> fusionListComparator = new Comparator<ListData>() {

		@Override
		public int compare(ListData a, ListData b) {	
			//Log.Log("comparing: "+a.getData()+" to:"+b.getData());
			return (a.getData().compareTo(b.getData()));
		}

	};

	public class ListData {
		public String data;
		public int storage;
		
		public String getData() {
			return data;
		}
		public void setData(String data) {
			this.data = data;
		}
		public int getStorage() {
			return storage;
		}
		public void setStorage(int storage) {
			this.storage = storage;
		}
				
	}
	/*
	 * 	Class to handle fusion list
	 */
    class fusionListAdapter extends BaseAdapter {
    	
		private List<ListData> data;
        private Context context;
        LayoutInflater inflator;
        ViewHolder holder;
        
        public fusionListAdapter() {
            data = null;
        }

        public fusionListAdapter(List<ListData> values) {
            data = values;
        }

        public fusionListAdapter(Context context, List<ListData> values) {
            this.context = context;
            inflator = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        	data = values;
        }

        public fusionListAdapter(Context context, int resId, List<ListData> values) {
            this.context = context;
        	data = values;
            inflator = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
       	
        	if(resId != 0) {

                View view = inflator.inflate(resId, null);
                holder = new ViewHolder();
                holder.text = (TextView) view.findViewById(MMFRuntime.inst.getIDsByName("list_text1"));
                return;
        	}
        }

        private class ViewHolder {
            public TextView text;
        }

         @Override
		public int getCount() {
            return data.size();
        }

        @Override
		public Object getItem(int position) {
             return data.get(position);
        }

        @Override
		public long getItemId(int position) {
             return position;
        }

        public int addLine(String dataString, int dataInt) {
    		ListData listData = new ListData();
    		listData.setData(dataString);
    		listData.setStorage(dataInt);
    		data.add(listData);
    		if (sort)
    			Collections.sort(data, fusionListComparator);
        	return data.size();
        }
        
        public void sort() {
    		if (sort)
    			Collections.sort(data, fusionListComparator);
       	
        }
        
        @Override
		public View getView(int position, View convertView, ViewGroup parent) {
        	if(inflator == null)
                inflator = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            if (convertView == null) {
                convertView = inflator.inflate(MMFRuntime.inst.getResourceID("layout/fusion_simple_list"), null);

                holder = new ViewHolder();
                holder.text = (TextView) convertView.findViewById(MMFRuntime.inst.getIDsByName("list_text1"));

                convertView.setTag(holder);
           } else {
                holder = (ViewHolder) convertView.getTag();
            }

            holder.text.setText(data.get(position).getData());
			if(!system_color)
				holder.text.setTextColor((0xFF << 24) | fColor);
			else
				holder.text.setTextColor(MMFRuntime.inst.getResources().getColor(android.R.color.primary_text_dark));

			if(!UseSystemFont) {
				holder.text.setTypeface(font.createFont());
				holder.text.setTextSize(TypedValue.COMPLEX_UNIT_SP, (font.lfHeight*72.0F/92.0F));
				holder.text.setMinimumHeight(54);
				holder.text.setGravity(Gravity.CENTER_VERTICAL);
				holder.text.setText(holder.text.getText(),TextView.BufferType.SPANNABLE);
			}
            return convertView;
        }
       
    }

	public CRunkclist()
	{
		expRet = new CValue(0);
	}

	class BadIndexException extends Exception
	{
		private static final long serialVersionUID = 45324678821L;
	}

	@Override
	public int getNumberOfConditions()
	{
		return 5;
	}

	private void addLine(String text)
	{
		ListData listData = new ListData();
		listData.setData(text);
		listData.setStorage(0);
		list.add(listData);

		list_idx = list.size()-1;

		if(sort)
			Collections.sort(list, fusionListComparator);
		
		if ( adapter != null )
			(adapter).notifyDataSetChanged();
		
		if ( view != null )
			((ListView) view).setSelection(list_idx);
	}

	private CFontInfo font;

	@Override
	public void createRunView(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		this.ho.hoOEFlags |= CObjectCommon.OEFLAG_NEVERKILL;

		ho.hoImgWidth = file.readShort();
		ho.hoImgHeight = file.readShort();

		if(rh.rhApp.bUnicode)
			font = file.readLogFont();
		else
			font = file.readLogFont16();

		//file.skipBytes(4); // Foreground color
		fColor = file.readColor();  // Foreground color

		if(rh.rhApp.bUnicode)
			file.skipBytes(80);
		else
			file.skipBytes(40);

		file.skipBytes(16 * 4); // Custom colors
		//file.skipBytes(4); // Background color
		bColor = file.readColor();  // Background color

		flags = file.readInt();
		int lineCount = file.readShort();

		oneBased = file.readInt() == 1;

		Log.Log ("kclist - oneBased = " + oneBased);

		file.skipBytes(4 * 3); // lSecu, whatever that is

		sort = ((flags & 0x0004) != 0);
		scrollToNewLine = ((flags & 0x0080) != 0);
		system_color = ((flags & 0x0020) != 0);

		b3dlook = ((flags & 0x0040) != 0);
		
		UseSystemFont = (rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) != 0;

		list = new ArrayList<ListData>();

		while (lineCount > 0)
		{
			ListData listData = new ListData();
			listData.setData(file.readString());
			listData.setStorage(0);
			list.add(listData);
			-- lineCount;
		}

		list_idx = 0;
		selection = -1;

		if (sort)
			Collections.sort(list, fusionListComparator);

		//if ((flags & 0x0010) != 0) // Hide on start
		bVisible = ((flags & 0x0010) == 0); // Show on start
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_LIST_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;
	}

	@SuppressWarnings("deprecation")
	@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
	private void createView()
	{
		Context context = ho.getControlsContext();

		field = new ListView(context);

		field.setFocusable (true);
		field.setFocusableInTouchMode (true);
		field.setClickable (true);

		field.setSelected(true);

		field.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener()
		{

			@Override
			public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
			{
				selection = position;
				if(view != null && view.hasFocus())
				{
					clickLoop = ho.getEventCount();
					ho.pushEvent(3, 0);
				}
			}

			@Override
			public void onNothingSelected(AdapterView<?> parent)
			{
				onfocus = false;
			}
		});

		field.setOnItemClickListener(new ListView.OnItemClickListener()
		{
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id)
			{
				if(view != null)
				{
					selection = position;
					onfocus = true;
					clickLoop = ho.getEventCount();
					ho.pushEvent(2, 0);
					ho.pushEvent(3, 0);
				}
			}
		});

		field.setVerticalScrollBarEnabled((flags & 0x0002) != 0);

		// 285.2 now using fusion list item added selector to handle different states in listview
		adapter = new fusionListAdapter (context, MMFRuntime.inst.getResourceID("layout/fusion_simple_list"), list);

		listBackColor();
		listTextColor();
		
		field.setDividerHeight((font.lfHeight+5)/10);	

		field.setChoiceMode(AbsListView.CHOICE_MODE_SINGLE);

		field.setAdapter(adapter);

		adapter.notifyDataSetChanged();

		setView (field);
		field.setVisibility(View.INVISIBLE); 
		firstTime = true;
		
	}

	@Override
	public int handleRunObject()
	{
		super.handleRunObject ();

		if (view == null && bVisible)
			createView();

		if (view != null) {
			if(bVisible && firstTime) {
				view.setVisibility(View.VISIBLE);
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
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_LIST_REQUEST))
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
		else
			enabled_perms = false;
	}

	@Override
	public void destroyRunObject(boolean bFast) {
		list.clear();
		list = null;
		adapter = null;
		setView(null);
	}

	@Override
	public CFontInfo getRunObjectFont()
	{
		return font;
	}
	
	@Override
	public void setRunObjectFont(CFontInfo font, CRect rc)
	{
		UseSystemFont = false;
		this.font = font;

		listTextColor();	

		if(rc != null) {
			setViewSize(rc.right - rc.left, rc.bottom - rc.top);
			updateLayout();
		}			
		if(adapter != null)
			adapter.notifyDataSetChanged();
	}
	
    @Override
	public void setRunObjectTextColor(int rgb)  
    {
		this.fColor = rgb;
		listTextColor();
		if(adapter != null)
			adapter.notifyDataSetChanged();
    }
    
    @SuppressLint("NewApi")
	private void listBackColor() {
		int[] bck_colors = {0,0,0};
		
		if(field != null ) {
			if(b3dlook) {
				bck_colors[0] = 0; // back color used as 3D background
				bck_colors[1] = 0xFF<<24 | (bColor); 
				bck_colors[2] = 0;
				if(MMFRuntime.deviceApi < android.os.Build.VERSION_CODES.JELLY_BEAN)
					field.setBackgroundDrawable(new GradientDrawable(Orientation.LEFT_RIGHT, bck_colors));
				else
					field.setBackground(new GradientDrawable(Orientation.LEFT_RIGHT, bck_colors));
			} else
				field.setBackgroundColor((0xFF << 24) | bColor);
	
			field.setCacheColorHint(0);
			
		}
    }
    
    @SuppressLint("NewApi")
	private void listTextColor() {
		if(field != null ) {
			int[] sep_colors = {0,0,0};
	
			// Set line Separator
			if(b3dlook) {
				sep_colors[0] = 0; // fore and back color used as line separator
				sep_colors[1] = 0xFF000000 + (fColor);
				sep_colors[2] = 0; 
			}
			else {
				sep_colors[0] = 0xFF000000 + (fColor); // fore and back color used as line separator
				sep_colors[1] = 0xFF000000 + (fColor); 
				sep_colors[2] = 0xFF000000 + (fColor);
			}
			field.setDivider(new GradientDrawable(Orientation.RIGHT_LEFT, sep_colors));
			field.setDividerHeight((font.lfHeight+5)/10);	
		}
    }
    
	private int getIndexParameter(CActExtension act, int index, boolean verify) throws BadIndexException
	{
		if (act == null)
			index = ho.getExpParam().getInt() - (oneBased ? 1 : 0);
		else
			index = act.getParamExpression(rh, index) - (oneBased ? 1 : 0);

		if (verify && (index >= list.size () || index < 0))
			throw new BadIndexException ();

		return index;
	}

	private int fixIndexBase(int index)
	{
		return index + (oneBased ? 1 : 0);
	}

	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		CRun rhPtr = ho.hoAdRunHeader;
		switch (num)
		{
		case 0: // Is visible?

			if ( view != null )
				return view.getVisibility() == View.VISIBLE;
			return false;

		case 1: // Is enabled?

			if ( view != null )
				return view.isEnabled();
			return true;

		case 2: // Double clicked

			if(clickLoop ==  rhPtr.rh4EventCount)
				return true;

			return false;

		case 3: // Selection changed

			if(clickLoop ==  rhPtr.rh4EventCount)
				return true;

			return false;
			
		case 4: // Has focus
			boolean temp = onfocus;
			onfocus = false;
			return temp;
		}
		;

		return false;
	}

	private void setListLine(int index) {	
		if ( view != null )
		{
			((ListView) view).requestFocusFromTouch ();
			((ListView) view).setSelection(index);
		}
		selection = index;
	}

	@Override
	public void action(int num, CActExtension act)
	{
		try {
			switch (num)
			{
			case 0: // Load list file

				if(list != null)
					list.clear();
				list_idx = 0;
				selection = -1;
				try
				{
					CRunApp.HFile file = ho.openHFile(act.getParamFilename(rh, 0), enabled_perms);

					if(file != null) {
						UnicodeReader ur = new UnicodeReader(file.stream, MMFRuntime.inst.charSet);
						BufferedReader reader = new BufferedReader(ur);
						String s;
						while ((s = reader.readLine()) != null) {
							//addLine(s);
							ListData listData = new ListData();
							listData.setData(s);
							listData.setStorage(0);
							list.add(listData);
						}
						list_idx = list.size()-1;

						if (sort)
							Collections.sort(list, fusionListComparator);

						reader.close();
						file.close();

					}
				}
				catch(Exception e)
				{
				}

				if ( adapter != null )
					adapter.notifyDataSetChanged();
				break;

			case 1: // Load drives list

				break;

			case 2: // Load directory list

				if(!enabled_perms) {
					MMFRuntime.inst.askForPermissionsApi23();
					return;
				}

				if(list != null)
					list.clear();
				selection = -1;
				try
				{

					for(File file : CServices.getFiles(act.getParamExpString(rh, 0)))
						if(file.isDirectory())
							addLine(file.getName());

				}
				catch(Exception e)
				{
				}

				if ( adapter != null )
					adapter.notifyDataSetChanged();
				list_idx = list.size()-1;
				break;

			case 3: // Load files list

				if(!enabled_perms) {
					MMFRuntime.inst.askForPermissionsApi23();
					return;
				}

				if(list != null)
					list.clear();
				list_idx = 0;
				selection = -1;
				try
				{
					for(File file : CServices.getFiles(act.getParamExpString(rh, 0)))
						if(!file.isDirectory())
							addLine(file.getName());
				}
				catch(Exception e)
				{
				}

				if ( adapter != null )
					adapter.notifyDataSetChanged();
				list_idx = list.size()-1;
				break;

			case 4: // Save list

				if(!enabled_perms) {
					MMFRuntime.inst.askForPermissionsApi23();
					return;
				}

				try
				{
					FileOutputStream file = new FileOutputStream(act.getParamExpString(rh, 0), false);

					if(file != null) {
						for(ListData l : list)
						{
							file.write(l.data.getBytes(MMFRuntime.inst.charSet));
							file.write("\n".getBytes());
						}

						file.close();
					}
				}
				catch(Exception e)
				{
				}
				break;

			case 5: // Reset

				if(list != null)
					list.clear();
				list_idx = 0;
				selection = -1;
				if ( adapter != null )
					adapter.notifyDataSetChanged();
				break;

			case 6: // Add line

				addLine(act.getParamExpString(rh, 0));
				break;

			case 7: // Insert line
			{
				int index = getIndexParameter(act, 0, false);
				final String line = act.getParamExpString(rh, 1);

				if (index < 0 || index >= list.size()) {
					//list.add (line);
					ListData listData = new ListData();
					listData.setData(line);
					listData.setStorage(0);
					list.add(listData);
					
				}
				else {
					//list.add (index, line);
					ListData listData = new ListData();
					listData.setData(line);
					listData.setStorage(0);
					list.add(index, listData);
				}
				list_idx = list.size()-1;

				if (list != null && sort)
				{   Collections.sort(list, fusionListComparator);
				}

				if ( adapter != null )
					adapter.notifyDataSetChanged();
				break;
			}

			case 8: // Delete line
			{
				int index = getIndexParameter(act, 0, true);
				if (list != null && index >= 0 && index < list.size())
					list.remove(index);
				selection = list.size()-1;		// O_o where does this come from? that makes no sense
				if ( adapter != null )
					adapter.notifyDataSetChanged();
				break;
			}

			case 9: // Set current line
			{
				// This is passive select
				int index = getIndexParameter(act, 0, true);

				setListLine(index);
				break;
			}

			case 10: // Show

				if( view == null )
					bVisible = true;
				else
					view.setVisibility (View.VISIBLE);
				break;

			case 11: // Hide

				if ( view != null )
					view.setVisibility (View.INVISIBLE);
				break;

			case 12: // Activate

				if ( view != null )
					view.requestFocus ();
				break;

			case 13: // Enable

				if ( view != null )
					view.setEnabled (true);
				break;

			case 14: // Disable

				if ( view != null )
					view.setEnabled (false);
				break;

			case 15: // Set position

				CPositionInfo position = act.getParamPosition(rh, 0);

				ho.setPosition(position.x, position.y);

				break;

			case 16: // Set X position

				ho.setX (act.getParamExpression(rh, 0));
				break;

			case 17: // Set Y position

				ho.setY (act.getParamExpression(rh, 0));
				break;

			case 18: // Set size

				ho.setSize (act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
				break;

			case 19: // Set X size

				ho.setWidth (act.getParamExpression(rh, 0));
				break;

			case 20: // Set Y size

				ho.setHeight (act.getParamExpression(rh, 0));
				break;

			case 21: // Deactivate

				if(view != null)
					view.clearFocus ();
				break;

			case 22: // Scroll to top

				selection = 0;
				if(view != null)
					((ListView) view).setSelection (0);
				list_idx = 0;
				break;

			case 23: // Scroll to line
				// This is an active select, triggering events.
				int index = getIndexParameter(act, 0, true);
				selection = index;
				if(view != null)
					((ListView) view).setSelection(index);

				break;

			case 24: // Scroll to end

				selection = list.size () - 1;
				if(view != null)
					((ListView) view).setSelection (list.size () - 1);

				break;

			case 25: // Set color

				fColor = act.getParamColour(rh, 0);
				if(view != null)
					view.forceLayout();
				break;

			case 26: // Set background color

				bColor = act.getParamColour(rh, 0);
				if(view != null)
					view.forceLayout();
				break;

			case 27: // Load fonts list

				break;

			case 28: // Load font sizes list

				break;

			case 29: // Set line data
				ListData listData = list.get(getIndexParameter(act, 0, true));
				listData.setStorage(act.getParamExpression(rh, 1));

				break;

			case 30: // Change line

				final int indexc = getIndexParameter(act, 0, true);
				final String text = act.getParamExpString(rh, 1);

				ListData listDataChg = new ListData();
				listDataChg.setData(text);
				listDataChg.setStorage(0);
				list.set(indexc, listDataChg);
				
				if ( adapter != null )
					adapter.notifyDataSetChanged();
				break;
			}
			;
		}
		catch (BadIndexException e)
		{
		}
	}

	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case 0: // Get selection index

			expRet.forceInt(fixIndexBase(selection));
			return expRet;

		case 1: // Get selection text

			expRet.forceString("");
			if (selection >= list.size())
				return expRet;

			if(!list.isEmpty()) {
				try {
					if (selection == -1)
						expRet.forceString(list.get (list.size()-1).getData());
					else
						expRet.forceString(list.get (selection).getData());

				} catch (ArrayIndexOutOfBoundsException e) {
					e.printStackTrace();
				}
			}
			return expRet;

		case 2: // Get selection directory

			expRet.forceString("");
			return expRet;

		case 3: // Get selection drive

			expRet.forceString("");
			return expRet;

		case 4: // Get line text

			try
			{
				expRet.forceString(list.get (getIndexParameter(null, 0, true)).getData());
				return expRet;
			}
			catch (Throwable t)
			{
				expRet.forceString("");
				return expRet;
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

			expRet.forceInt(-1);
			if(list != null)
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

			expRet.forceInt(ho.hoImgHeight);
			return expRet;

		case 12: // Get color

			expRet.forceInt(fColor);
			return expRet;

		case 13: // Get background color

			expRet.forceInt(bColor);
			return expRet;

		case 14: // Find string
		{
			String string = ho.getExpParam().getString();
			int startIndex = ho.getExpParam().getInt()-(oneBased ? 1 : 0);
			expRet.forceInt(-1);

			if(list == null)
				return expRet;

			if ((startIndex < 0) || (startIndex >= list.size()))
				startIndex = 0;

			for (int i = 0; i < list.size(); ++i) {
				if(list.size() <= (startIndex))
					startIndex = 0;
				if (list.get(startIndex).getData().contains(string)) {
					expRet.forceInt(fixIndexBase (startIndex));
					return expRet;
				}
				startIndex++;
			}
			return expRet;
		}

		case 15: // Find string exact
		{
			String string = ho.getExpParam().getString();
			int startIndex = ho.getExpParam().getInt()-(oneBased ? 1 : 0);
			expRet.forceInt(-1);

			if(list == null)
				return expRet;

			if ((startIndex < 0) || (startIndex >= list.size()))
				startIndex = 0;

			for (int i = 0; i < list.size(); ++i) {
				if(list.size() <= (startIndex))
					startIndex = 0;
				if (list.get(startIndex).getData().compareTo(string) == 0) {
					expRet.forceInt(fixIndexBase (startIndex));
					return expRet;
				}
				startIndex++;
			}
			return expRet;
		}

		case 16: // Get last index

			expRet.forceInt(0);
			if(list != null)
				expRet.forceInt(list_idx + (oneBased ? 1 : 0));

			return expRet;

		case 17: // Get line data
			int Value = 0;
			try {
				int Index = getIndexParameter(null, 0, true);
				if(list.get(Index) != null) {
					Value = list.get(Index).getStorage();
				}
			} 
			catch (BadIndexException e) {
				Value = 0;
			}
			catch (NullPointerException e) {
				Value = 0;
			}
			finally {
				expRet.forceInt(Value);
			}

			return expRet;

		}

		return expRet;
	}
}
