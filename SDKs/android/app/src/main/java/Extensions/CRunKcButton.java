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
// CRUNKCBUTTON: extension object
//
//----------------------------------------------------------------------------------
package Extensions;

import Actions.CActExtension;
import Application.CRunApp;
import Banks.CImage;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import OpenGL.GLRenderer;
import Params.CPositionInfo;
import RunLoop.CCreateObjectInfo;
import Runtime.ITouchAware;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;

public class CRunKcButton extends CRunViewExtension implements ITouchAware
{
	public static final int CND_BOXCHECK = 0;
	public static final int CND_CLICKED = 1;
	public static final int CND_BOXUNCHECK = 2;
	public static final int CND_VISIBLE = 3;
	public static final int CND_ISENABLED = 4;
	public static final int CND_ISRADIOENABLED = 5;
	public static final int CND_LAST = 6;
	public static final int ACT_CHANGETEXT = 0;
	public static final int ACT_SHOW = 1;
	public static final int ACT_HIDE = 2;
	public static final int ACT_ENABLE = 3;
	public static final int ACT_DISABLE = 4;
	public static final int ACT_SETPOSITION = 5;
	public static final int ACT_SETXSIZE = 6;
	public static final int ACT_SETYSIZE = 7;
	public static final int ACT_CHGRADIOTEXT = 8;
	public static final int ACT_RADIOENABLE = 9;
	public static final int ACT_RADIODISABLE = 10;
	public static final int ACT_SELECTRADIO = 11;
	public static final int ACT_SETXPOSITION = 12;
	public static final int ACT_SETYPOSITION = 13;
	public static final int ACT_CHECK = 14;
	public static final int ACT_UNCHECK = 15;
	public static final int ACT_SETCMDID = 16;
	public static final int ACT_SETTOOLTIP = 17;
	public static final int ACT_LAST = 18;
	public static final int EXP_GETXSIZE = 0;
	public static final int EXP_GETYSIZE = 1;
	public static final int EXP_GETX = 2;
	public static final int EXP_GETY = 3;
	public static final int EXP_GETSELECT = 4;
	public static final int EXP_GETTEXT = 5;
	public static final int EXP_GETTOOLTIP = 6;
	public static final int EXP_LAST = 7;
	private static final int BTNTYPE_PUSHTEXT = 0;
	private static final int BTNTYPE_CHECKBOX = 1;
	private static final int BTNTYPE_RADIOBTN = 2;
	private static final int BTNTYPE_PUSHBITMAP = 3;
	private static final int BTNTYPE_PUSHTEXTBITMAP = 4;
	private static final int ALIGN_ONELINELEFT = 0;
	private static final int ALIGN_CENTER = 1;
	private static final int ALIGN_CENTERINVERSE = 2;
	private static final int ALIGN_ONELINERIGHT = 3;
	private static final int BTN_HIDEONSTART = 0x0001;
	private static final int BTN_DISABLEONSTART = 0x0002;
	private static final int BTN_TEXTONLEFT = 0x0004;
	private static final int BTN_TRANSP_BKD = 0x0008;
	private static final int BTN_SYSCOLOR = 0x0010;
	private static final int SX_TEXTIMAGE=6;
	private static final int SY_TEXTIMAGE=4;

	short buttonImages[];
	short buttonType;
	short buttonCount;
	int flags;
	short alignImageText;
	String tooltipText = "";
	CFontInfo font;
	int foreColour;
	int backColour;
	int clickedEvent = 0;
	int touchID = -1;
	boolean bEnabled=true;
	boolean bVisible=true;
	boolean bBitmapButtonPressed=false;
	String strings[]=null;
	int zone=-1;
	int oldZone=-1;
	int selected;
	int oldSelected;
	int oldKey;
	boolean radioEnabled[];
	int syButton;

	int radioReturn;

	Button button;
	RadioGroup radioGroup;
	CheckBox checkBox;

	float nDensity;
	private boolean firstTime;
	
	public CRunKcButton()
	{
	}

	@Override
	public int getNumberOfConditions()
	{
		return CND_LAST;
	}

	@Override
	public void createRunView(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		firstTime = true;
        // Read in edPtr values
		ho.hoImgWidth = file.readShort();
		ho.hoImgHeight = file.readShort();
		buttonType = file.readShort();
		buttonCount = file.readShort();
		flags = file.readInt();
		font = file.readLogFont();	
		foreColour = file.readColor();
		//    file.skipBytes(1);  // padding
		backColour = file.readColor();
		//    file.skipBytes(1);  // padding
		buttonImages = new short[3];
		int i;
		for (i = 0; i < 3; i++)
		{
			buttonImages[i] = file.readShort();
		}
		if ((buttonType == BTNTYPE_PUSHBITMAP) || (buttonType == BTNTYPE_PUSHTEXTBITMAP))
		{
			ho.loadImageList(buttonImages);
		}
		if (buttonType==BTNTYPE_PUSHBITMAP)
		{		
			ho.hoImgWidth = 1;
			ho.hoImgHeight = 1;
			for (i = 0; i < 3; i++)
			{
				if (buttonImages[i]!=-1)
				{
					CImage image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(buttonImages[i]);
					ho.hoImgWidth = Math.max(ho.hoImgWidth, image.getWidth());
					ho.hoImgHeight = Math.max(ho.hoImgHeight, image.getHeight());
				}
			}
		}
		file.readShort(); // fourth word in img array
		file.readInt(); // ebtnSecu
		alignImageText = file.readShort();

		selected=-1;
		oldSelected=-1;
		oldZone=-1;
		oldKey=-1;
		bEnabled=true;
		if ((flags&BTN_DISABLEONSTART)!=0)
		{
			bEnabled=false;
		}			
		bVisible=true;
		if ((flags&BTN_HIDEONSTART)!=0)
		{
			bVisible=false;
		}	
		
    	if ((rh.rhApp.hdr2Options & CRunApp.AH2OPT_SYSTEMFONT) != 0) {
    		font.font = Typeface.DEFAULT;
    		TextView textView = new TextView(ho.getControlsContext());
    		// Returned plain pixel size
    		//font.lfHeight = (int)(CServices.getDPFromPixels(textView.getTextSize())*96/72);
     	}
   		
		// In the file an array of strings follows. The first string is the button text,
		// the second is the tooltip. For a radio button, there are buttonCount strings
		// for each radio button in the group, and no tooltip.
		if (buttonType != BTNTYPE_RADIOBTN)
		{
			strings = new String[1];
			strings[0] = file.readString();
			tooltipText = file.readString();

			if(buttonType == BTNTYPE_CHECKBOX)
			{
				view = checkBox = new CheckBox(ho.getControlsContext());
				
				checkBox.setText (strings [0]);
				if((flags&BTN_SYSCOLOR) == 0 && (flags&BTN_TRANSP_BKD) == 0)
					checkBox.setTextColor(0xFF000000 |foreColour);
		        if(font.lfUnderline != 0)
		        	checkBox.setPaintFlags(Paint.UNDERLINE_TEXT_FLAG);
		        
			}
		}
		else
		{
			strings = new String[buttonCount];
			radioEnabled=new boolean[buttonCount];
			syButton=ho.hoImgHeight/buttonCount;

			view = radioGroup = new RadioGroup (ho.getControlsContext());

			radioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {

				@Override
				public void onCheckedChanged(RadioGroup radio, int id) {
					radioReturn = id-1;
					clickedEvent = rh.rh4EventCount;
					ho.pushEvent(CND_CLICKED, 0);

				}

			});

			if((flags&BTN_SYSCOLOR) == 0 && (flags&BTN_TRANSP_BKD) == 0)
				radioGroup.setBackgroundColor(0xFF000000 | backColour);

			for (i = 0; i < buttonCount; i++)
			{
				strings[i] = file.readString();
				radioEnabled[i]=true;

				RadioButton radioButton = new RadioButton (ho.getControlsContext());

				if((flags&BTN_SYSCOLOR) == 0)
					radioButton.setTextColor(0xFF000000 | foreColour);

		        if(font.lfUnderline != 0)
		        	radioButton.setPaintFlags(Paint.UNDERLINE_TEXT_FLAG);
		        
				radioButton.setText(strings[i]);
				radioGroup.addView(radioButton);
			}
		}

		if(buttonType == BTNTYPE_PUSHTEXT)
		{
			view = button = new Button (ho.getControlsContext());
			view.setSoundEffectsEnabled(false);
			button.setText(strings[0]);
			if((flags&BTN_SYSCOLOR) == 0 && (flags&BTN_TRANSP_BKD) == 0)
				button.setTextColor(0xFF000000 |foreColour);
	        if(font.lfUnderline != 0)
	        	button.setPaintFlags(Paint.UNDERLINE_TEXT_FLAG);
	        //else
	        //	button.setPaintFlags(Paint.);
	        	

		}

		if(view != null)
		{
			if(!bEnabled)
				view.setEnabled(false);

			//if(!bVisible)
			view.setVisibility(View.INVISIBLE);
			updateFont(font);
			
			setView (view);

			view.setOnClickListener(new View.OnClickListener()
			{
				@Override
				public void onClick(View view)
				{
					if(selected == 0)
						selected = -1;
					else
						selected = 0;
						
					clickedEvent = rh.rh4EventCount;
					ho.pushEvent(CND_CLICKED, 0);
				}
			});
		}
		else
		{
			MMFRuntime.inst.touchManager.addTouchAware(this);
		}

	}

	@Override
	public void destroyRunObject(boolean bFast)
	{
		if (view == null)
			MMFRuntime.inst.touchManager.removeTouchAware(this);
		else
			setView(null);
	}

	@Override
	public void newTouch (int id, float x, float y)
	{
		if (buttonType==BTNTYPE_PUSHBITMAP)
		{
			if(!bVisible)
				return;
			
			if(rh.rhApp.container != null) {
				x -= rh.rhApp.absoluteX;
				y -= rh.rhApp.absoluteY;
			}
			zone = getZone((int) x+rh.rhWindowX, (int) y+rh.rhWindowY);

			if (zone == 0)
			{
				if (bBitmapButtonPressed)
					return;

				bBitmapButtonPressed = true;
				touchID = id;

				clickedEvent = rh.rh4EventCount;
				if(bEnabled)
					ho.pushEvent(CND_CLICKED, 0);
			}
		}
	}

	@Override
	public void endTouch (int id)
	{
		if(bBitmapButtonPressed && (id == touchID || id == -1))
		{
			bBitmapButtonPressed = false;
		}
	}

	@Override
	public void touchMoved (int id, float x, float y)
	{
	}

	@Override
	public int handleRunObject()
	{
		super.handleRunObject ();

		if (view == null)
			return REFLAG_DISPLAY;
		else {
			if(bVisible && firstTime) {
				firstTime = false;
				view.setVisibility(View.VISIBLE);
			}
			return 0;
		}
	}


	int getZone(int xMouse, int yMouse)
	{

		//Log.Log(ho.hoOiList.oilName+", Mouse: "+xMouse+", "+yMouse+" ho: "+ho.hoX+", "+ho.hoY+" W: "+ho.hoImgWidth+", H: "+ho.hoImgHeight);
		if (xMouse>=ho.hoX && xMouse<ho.hoX+ho.hoImgWidth)
		{
			if (yMouse>=ho.hoY && yMouse<ho.hoY+ho.hoImgHeight)
			{
				return 0;
			}
		}

		return -1; 
	}

	@Override
	public void continueRunObject() {
		if (bVisible && view != null)
			view.invalidate();    				
	}

	@Override
	public void displayRunObject()
	{
        //Log.Log(" Object KcButton displayRunObject: "+ ho.hoOiList.oilName);
		if (bVisible==false || view != null)
		{
			return;    		
		}

		CImage image;
		CRect crc=new CRect();
		crc.left=ho.hoX;
		crc.top=ho.hoY;
		crc.right=ho.hoX+ho.hoImgWidth;
		crc.bottom=ho.hoY+ho.hoImgHeight;
		switch (buttonType)
		{
		case BTNTYPE_PUSHBITMAP:
			if (bEnabled==false)
			{
				image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(buttonImages[2]);
			}
			else
			{
				if (bBitmapButtonPressed)
				{
					image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(buttonImages[1]);
				}
				else
				{
					image=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(buttonImages[0]);
				}
			}

			int x = ho.hoX;
			int y = ho.hoY;

			//Log.Log("Bmp Button previous "+(((ho.hoOEFlags & CObjectCommon.OEFLAG_SCROLLINGINDEPENDANT) != 0 ) ? "yes" : "no ") + " x: " + x + " y: " + y);

			//if((ho.hoOEFlags & CObjectCommon.OEFLAG_SCROLLINGINDEPENDANT) != 0)
			//{
			x -= rh.rhWindowX;
			y -= rh.rhWindowY;
			//}

			//Log.Log("Bmp Button "+(((ho.hoOEFlags & CObjectCommon.OEFLAG_SCROLLINGINDEPENDANT) != 0 ) ? "yes" : "no ") + " x: " + x + " y: " + y);

			if (image != null)
				image.setResampling(ho.bAntialias);		//will use the App Anti-alias flag if set
				GLRenderer.inst.renderImage
				(image, x, y, image.getWidth(), image.getHeight(), 0, 0);
			break;
		}
	}

	@Override
	public CFontInfo getRunObjectFont()
	{
		return font;
	}

	@Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
	{
		font = fi;

		updateFont();
	}

	private void updateFont()
	{
		if(view != null)
		{
			if(radioGroup != null)
			{
				for(int i = 0; i < radioGroup.getChildCount(); ++ i)
				{
					updateFont((TextView) radioGroup.getChildAt(i), font);
				}
			}
			else
			{
				updateFont((TextView) view, font);				
			}
		}
	}
	
	@Override
    public void updateFont (CFontInfo font)
    {
		this.font.copy(font);
		updateFont ();   			
    }


	@Override
	public int getRunObjectTextColor()
	{
		return foreColour;
	}

	@Override
	public void setRunObjectTextColor(int rgb)
	{
		foreColour = rgb;
	}

	@Override
	public CMask getRunObjectCollisionMask(int flags)
	{
		return null;
	}

	public Bitmap getRunObjectSurface()
	{
		return null;
	}

	@Override
	public void getZoneInfos()
	{
	}

	// Conditions
	// --------------------------------------------------
	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case CND_BOXCHECK:
			return cndBOXCHECK(cnd);
		case CND_CLICKED:
			return cndCLICKED(cnd);
		case CND_BOXUNCHECK:
			return cndBOXUNCHECK(cnd);
		case CND_VISIBLE:
			return cndVISIBLE(cnd);
		case CND_ISENABLED:
			return cndISENABLED(cnd);
		case CND_ISRADIOENABLED:
			return cndISRADIOENABLED(cnd);
		}
		return false;
	}

	private boolean cndBOXCHECK(CCndExtension cnd)
	{
		if (buttonType == BTNTYPE_CHECKBOX)
		{
			return ((CheckBox) view).isChecked();
		}
		return false;
	}

	private boolean cndCLICKED(CCndExtension cnd)
	{
		// If this condition is first, then always true
		if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
		{
			return true;
		}

		// If condition second, check event number matches
		if (rh.rh4EventCount == clickedEvent)
		{
			return true;
		}

		return false;
	}

	private boolean cndBOXUNCHECK(CCndExtension cnd)
	{
		if (buttonType == BTNTYPE_CHECKBOX)
		{
			return !((CheckBox) view).isChecked();
		}
		return false;
	}

	private boolean cndVISIBLE(CCndExtension cnd)
	{
		return bVisible;
	}

	private boolean cndISENABLED(CCndExtension cnd)
	{
		return bEnabled;
	}

	private boolean cndISRADIOENABLED(CCndExtension cnd)
	{
		if(radioEnabled == null)
			return false;

		int index = cnd.getParamExpression(rh, 0);
		if ((index >= 0) && (index < buttonCount))
		{
			return radioEnabled[index];
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
		case ACT_CHANGETEXT:
			actCHANGETEXT(act);
			break;
		case ACT_SHOW:
			actSHOW(act);
			break;
		case ACT_HIDE:
			actHIDE(act);
			break;
		case ACT_ENABLE:
			actENABLE(act);
			break;
		case ACT_DISABLE:
			actDISABLE(act);
			break;
		case ACT_SETPOSITION:
			actSETPOSITION(act);
			break;
		case ACT_SETXSIZE:
			actSETXSIZE(act);
			break;
		case ACT_SETYSIZE:
			actSETYSIZE(act);
			break;
		case ACT_CHGRADIOTEXT:
			actCHGRADIOTEXT(act);
			break;
		case ACT_RADIOENABLE:
			actRADIOENABLE(act);
			break;
		case ACT_RADIODISABLE:
			actRADIODISABLE(act);
			break;
		case ACT_SELECTRADIO:
			actSELECTRADIO(act);
			break;
		case ACT_SETXPOSITION:
			actSETXPOSITION(act);
			break;
		case ACT_SETYPOSITION:
			actSETYPOSITION(act);
			break;
		case ACT_CHECK:
			actCHECK(act);
			break;
		case ACT_UNCHECK:
			actUNCHECK(act);
			break;
		case ACT_SETCMDID:
			actSETCMDID(act);
			break;
		case ACT_SETTOOLTIP:
			actSETTOOLTIP(act);
			break;
		}
	}

	private void actCHANGETEXT(CActExtension act)
	{
		final String text = act.getParamExpString(rh, 0);

		strings[0]=text;
		ho.redraw();

		if(view != null) {
			if(radioGroup == null)
			{
				((TextView) view).setText(text);
			}
		}
	}

	private void actSHOW(CActExtension act)
	{
		bVisible=true;
		ho.redraw();

		if(view != null)
			view.setVisibility(View.VISIBLE);
	}

	private void actHIDE(CActExtension act)
	{
		bVisible=false;
		ho.redraw();

		if(view != null)
			view.setVisibility(View.INVISIBLE);
	}

	private void actENABLE(CActExtension act)
	{
		bEnabled=true;
		ho.redraw();

		if(view != null)
			view.setEnabled(true);
	}

	private void actDISABLE(CActExtension act)
	{
		bEnabled=false;
		ho.redraw();

		if(view != null)
			view.setEnabled(false);
	}

	private void actSETPOSITION(CActExtension act)
	{
		CPositionInfo pos = act.getParamPosition(rh, 0);
		ho.setPosition(pos.x, pos.y);
		ho.redraw();
	}

	private void actSETXSIZE(CActExtension act)
	{
		ho.setWidth(act.getParamExpression(rh, 0));
		ho.redraw();
	}

	private void actSETYSIZE(CActExtension act)
	{
		ho.setHeight(act.getParamExpression(rh, 0));
		ho.redraw();
	}

	private void actCHGRADIOTEXT(CActExtension act)
	{
		int index = act.getParamExpression(rh, 0);
		String newText = act.getParamExpString(rh, 1);
		if(view != null) {
			if(radioGroup != null)
			{
				if ((index >= 0) && (index < buttonCount))
					((RadioButton)radioGroup.getChildAt(index)).setText(newText);				
			}
		}
		ho.redraw();
	}

	@SuppressLint("NewApi")
	private void actRADIOENABLE(CActExtension act)
	{
		if(radioEnabled == null)
			return;

		int index = act.getParamExpression(rh, 0);
		if ((index >= 0) && (index < buttonCount))
		{
			if (radioEnabled[index]==false)
			{
				radioEnabled[index]=true;
				if(MMFRuntime.deviceApi > 10)
					((RadioButton)radioGroup.getChildAt(index)).setAlpha(1.0f);				
				((RadioButton)radioGroup.getChildAt(index)).setClickable(true);				
				ho.redraw();
			}
		}
	}

	@SuppressLint("NewApi")
	private void actRADIODISABLE(CActExtension act)
	{
		if(radioEnabled == null)
			return;

		int index = act.getParamExpression(rh, 0);
		if ((index >= 0) && (index < buttonCount))
		{
			if (radioEnabled[index]==true)
			{
				radioEnabled[index]=false;
				if(MMFRuntime.deviceApi > 10)
					((RadioButton)radioGroup.getChildAt(index)).setAlpha(0.4f);				
				((RadioButton)radioGroup.getChildAt(index)).setClickable(false);				
				ho.redraw();
			}
		}
	}

	private void actSELECTRADIO(CActExtension act)
	{
		if(radioEnabled == null)
			return;

		int index = act.getParamExpression(rh, 0);
		if ((index >= 0) && (index < buttonCount))
		{
			if (radioEnabled[index])
			{
				radioReturn=index;
				((RadioButton)radioGroup.getChildAt(index)).setChecked(true);	
				ho.redraw();
			}
		}
		if(index < 0)
		{
			for(int i = 0; i < buttonCount; i++)
			{
				((RadioButton)radioGroup.getChildAt(i)).setChecked(false);					
			}
			radioReturn=-1;
			ho.redraw();
		}
	}

	private void actSETXPOSITION(CActExtension act)
	{
		ho.setPosition(act.getParamExpression(rh, 0), ho.hoY);
		ho.redraw();
	}

	private void actSETYPOSITION(CActExtension act)
	{
		ho.setPosition(ho.hoX, act.getParamExpression(rh, 0));
		ho.redraw();
	}

	private void actCHECK(CActExtension act)
	{
		if (buttonType == BTNTYPE_CHECKBOX)
		{
			if (selected==-1)
			{				
				selected=0;
				if(view != null)
					((CheckBox) view).setChecked(true);
				ho.redraw();
			}
		}
	}

	private void actUNCHECK(CActExtension act)
	{
		if (buttonType == BTNTYPE_CHECKBOX)
		{
			if (selected==0)
			{
				selected=-1;
				if(view != null)
					((CheckBox) view).setChecked(false);
				ho.redraw();
			}
		}
	}

	private void actSETCMDID(CActExtension act)
	{
		// TODO set menu item
	}

	private void actSETTOOLTIP(CActExtension act)
	{
		tooltipText = act.getParamExpString(rh, 0);
	}

	// Expressions
	// --------------------------------------------
	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case EXP_GETXSIZE:
			return expGETXSIZE();
		case EXP_GETYSIZE:
			return expGETYSIZE();
		case EXP_GETX:
			return expGETX();
		case EXP_GETY:
			return expGETY();
		case EXP_GETSELECT:
			return expGETSELECT();
		case EXP_GETTEXT:
			return expGETTEXT();
		case EXP_GETTOOLTIP:
			return expGETTOOLTIP();
		}
		return null;
	}

	private CValue expGETXSIZE()
	{
		return new CValue(ho.getWidth());
	}

	private CValue expGETYSIZE()
	{
		return new CValue(ho.getHeight());
	}

	private CValue expGETX()
	{
		return new CValue(ho.getX());
	}

	private CValue expGETY()
	{
		return new CValue(ho.getY());
	}

	private CValue expGETSELECT()
	{
		return new CValue(radioReturn);
	}

	private CValue expGETTEXT()
	{
		int index = ho.getExpParam().getInt();
		CValue ret=new CValue("");

		if (buttonType == BTNTYPE_RADIOBTN)
		{
			if ((index < 0) || (index >= buttonCount))
			{
				return ret;
			}
		}
		else
		{
			index = 0;
		}
		ret.forceString(strings[index]);
		return ret;
	}

	private CValue expGETTOOLTIP()
	{
		return new CValue(tooltipText);
	}
}
