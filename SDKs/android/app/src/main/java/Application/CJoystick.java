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
package Application;

import Banks.CImage;
import OpenGL.GLRenderer;
import Runtime.ITouchAware;
import Runtime.MMFRuntime;
import android.util.DisplayMetrics;

public class CJoystick implements ITouchAware
{
	public static final int KEY_JOYSTICK = 0;
	public static final int KEY_FIRE1 = 1;
	public static final int KEY_FIRE2 = 2;
	public static final int KEY_NONE = -1;

	public static final int MAX_TOUCHES = 3;

	public static final int JFLAG_JOYSTICK = 0x0001;
	public static final int JFLAG_FIRE1 = 0x0002;
	public static final int JFLAG_FIRE2 = 0x0004;
	public static final int JFLAG_LEFTHANDED = 0x0008;

	public static final int JPOS_NOTDEFINED = 0x80000000;

	private static final float DEADZONE = 0.5f;
	private static final int JOY_ANGLEGAP = 70;
	private static final int DPAD_ANGLEGAP = 60;

	public CRunApp app;
	
	class LastJoystickPosition
	{
		LastJoystickPosition()
		{
			flag = posX = posY = 0;
		}
		
		public int flag;
		public int posX;
		public int posY;
	}

	class CJoystickImage extends CImage
	{
		CJoystickImage (String name)
		{
			super (name, true);
		}

		@Override
		public void onDestroy ()
		{
			joyBack = null;
			joyFront = null;
			fire1U = null;
			fire2U = null;
			fire1D = null;
			fire2D = null;

		}
	}

	public CJoystickImage joyBack;
	public CJoystickImage joyFront;
	public CJoystickImage fire1U;
	public CJoystickImage fire2U;
	public CJoystickImage fire1D;
	public CJoystickImage fire2D;

	/* To avoid getWidth/getHeight JNI overhead */

	public int joyBack_width, joyBack_height;
	public int joyFront_width, joyFront_height;
	public int fire1U_width, fire1U_height;
	public int fire2U_width, fire2U_height;
	public int fire1D_width, fire1D_height;
	public int fire2D_width, fire2D_height;

	public boolean bLandScape;
	public int [] imagesX = new int[3];
	public int [] imagesY = new int[3];
	public int joystickX;
	public int joystickY;
	public int joystick;
	public int flags;
	
	private LastJoystickPosition[] lastJoyPos;

	//private double old_angle = 0.0;

	boolean staticPosition = false;

	private float nScale = 1.0f;
	private static int nDensityDPI;
	private static int nDensityProm;
	private static int nDensityAvg;

	private double joydeadzone = 0.0;	
	private double joyanglezone = 0.0;
	private int joyradsize = 0;

	// set to true to act like a Joystick
	public static final boolean isJoystick = true;

	public int [] touches = new int[MAX_TOUCHES];


	private static double deviceInch()
	{
		DisplayMetrics matrix = new DisplayMetrics();
		MMFRuntime.inst.getWindowManager().getDefaultDisplay().getMetrics(matrix);

		int width = matrix.widthPixels;
		int height = matrix.heightPixels;

		float xdpi = matrix.xdpi;
		float ydpi = matrix.ydpi;

		double a = width / xdpi;
		double b= height / ydpi;

		double display = Math.sqrt(a * a + b * b);

		nDensityProm = (int)((xdpi+ydpi)/2);
		nDensityDPI = matrix.densityDpi;
		nDensityAvg = Math.max(nDensityProm, nDensityDPI);
		return display;
	}

	public void loadImages ()
	{
		if (joyBack != null)
			return; /* still loaded */

		joyBack = new CJoystickImage("drawable/joyback");
		joyFront = new CJoystickImage("drawable/joyfront");
		fire1U = new CJoystickImage("drawable/fire1u");
		fire2U = new CJoystickImage("drawable/fire2u");
		fire1D = new CJoystickImage("drawable/fire1d");
		fire2D = new CJoystickImage("drawable/fire2d");

		joyBack_width = (int)(joyBack.getWidth ()*nScale);
		joyBack_height = (int)(joyBack.getHeight ()*nScale);

		joyFront_width = (int)(joyFront.getWidth ()*nScale);
		joyFront_height = (int)(joyFront.getHeight ()*nScale);

		fire1U_width = (int)(fire1U.getWidth ()*nScale);
		fire1U_height = (int)(fire1U.getHeight ()*nScale);

		fire2U_width = (int)(fire2U.getWidth ()*nScale);
		fire2U_height = (int)(fire2U.getHeight ()*nScale);

		fire1D_width = (int)(fire1D.getWidth ()*nScale);
		fire1D_height = (int)(fire1D.getHeight ()*nScale);

		fire2D_width = (int)(fire2D.getWidth ()*nScale);
		fire2D_height = (int)(fire2D.getHeight ()*nScale);
	}

	public CJoystick(CRunApp app, int flags)
	{
		//Log.Log("Init joystick with flags " + flags);

		// Read the screen density for resize the joystick control
		double Size = deviceInch();
		// 80 is the joystick size in pixel
		double promRatiotoSize = nDensityAvg*80.0/160;
		if (Size < 5.1) {
			// 0.56 for small size
			this.nScale = (float)(0.56*nDensityDPI/promRatiotoSize);
		}
		else if (Size > 9.0){
			// 0.80 for large size
			this.nScale = (float)(0.80*nDensityDPI/promRatiotoSize);
		}	
		else {
			// 0.60 for large size
			this.nScale = (float)(0.60*nDensityDPI/promRatiotoSize);
		}

		loadImages ();

		this.app = app;
		this.flags = flags;

		joystickX = 0;
		joystickY = 0;

		joyradsize = 0;
		
		lastJoyPos = new LastJoystickPosition[3];
		
		lastJoyPos[KEY_JOYSTICK] = new LastJoystickPosition();
		lastJoyPos[KEY_FIRE1] = new LastJoystickPosition();
		lastJoyPos[KEY_FIRE2] = new LastJoystickPosition();

		lastJoyPos[KEY_JOYSTICK].flag = JFLAG_JOYSTICK;
		lastJoyPos[KEY_JOYSTICK].posX = imagesX[KEY_JOYSTICK]=JPOS_NOTDEFINED;
		lastJoyPos[KEY_JOYSTICK].posY = imagesY[KEY_JOYSTICK]=JPOS_NOTDEFINED;
		
		lastJoyPos[KEY_FIRE1].flag = JFLAG_FIRE1;
		lastJoyPos[KEY_FIRE1].posX = imagesX[KEY_FIRE1]=JPOS_NOTDEFINED;
		lastJoyPos[KEY_FIRE1].posY = imagesY[KEY_FIRE1]=JPOS_NOTDEFINED;
		
		lastJoyPos[KEY_FIRE2].flag = JFLAG_FIRE2;
		lastJoyPos[KEY_FIRE2].posX = imagesX[KEY_FIRE2]=JPOS_NOTDEFINED;
		lastJoyPos[KEY_FIRE2].posY = imagesY[KEY_FIRE2]=JPOS_NOTDEFINED;

		// Dead Zone where virtual control will not interact
		joydeadzone = DEADZONE*Math.ceil(Math.sqrt(joyBack_width/2*joyBack_width/2+joyBack_height/2*joyBack_height/2));

		// Set the angle gap according the type joystick or D-pad
		if(isJoystick)
			joyanglezone = JOY_ANGLEGAP*Math.PI/180;
		else
			joyanglezone = DPAD_ANGLEGAP*Math.PI/180;

		int touches_length = touches.length;
		for (int i = 0; i < touches_length; ++ i)
			touches [i] = -1;
	}

	public void setPositions()
	{
		int fsize = (int)(40*nScale);
		int hsize = (int)(20*nScale);

		if (staticPosition)
			return;

		int sx, sy;
		sx=MMFRuntime.inst.currentWidth;
		sy=MMFRuntime.inst.currentHeight;
		if ((flags&JFLAG_LEFTHANDED)==0)
		{
			if ((flags&JFLAG_JOYSTICK)!=0)
			{
				imagesX[KEY_JOYSTICK]=hsize+joyBack_width/2;
				imagesY[KEY_JOYSTICK]=sy-hsize-joyBack_height/2;
			}
			if ((flags&JFLAG_FIRE1)!=0 && (flags&JFLAG_FIRE2)!=0)
			{
				imagesX[KEY_FIRE1]=sx-fire1U_width/2-(int)(fsize*0.75);
				imagesY[KEY_FIRE1]=sy-fire1U_height/2-hsize;
				imagesX[KEY_FIRE2]=sx-fire2U_width/2-(int)(hsize*0.75);
				imagesY[KEY_FIRE2]=sy-fire2U_height/2-fire1U_height-(int)(fsize*0.75);
			}
			else if ((flags&JFLAG_FIRE1)!=0)
			{
				imagesX[KEY_FIRE1]=sx-fire1U_width/2-(int)(hsize*0.75);
				imagesY[KEY_FIRE1]=sy-fire1U_height/2-hsize;
			}
			else if ((flags&JFLAG_FIRE2)!=0)
			{
				imagesX[KEY_FIRE2]=sx-fire2U_width/2-(int)(hsize*0.75);
				imagesY[KEY_FIRE2]=sy-fire2U_height/2-hsize;
			}
		}
		else
		{
			if ((flags&JFLAG_JOYSTICK)!=0)
			{
				imagesX[KEY_JOYSTICK]=sx-hsize-joyBack_width/2;
				imagesY[KEY_JOYSTICK]=sy-hsize-joyBack_height/2;
			}
			if ((flags&JFLAG_FIRE1)!=0 && (flags&JFLAG_FIRE2)!=0)
			{
				imagesX[KEY_FIRE1]=fire1U_width/2+hsize+fire2U_width*2/3;
				imagesY[KEY_FIRE1]=sy-fire1U_height/2-hsize;
				imagesX[KEY_FIRE2]=fire2U_width/2+hsize;
				imagesY[KEY_FIRE2]=sy-fire2U_height/2-fire1U_height-(int)(fsize*0.75);
			}
			else if ((flags&JFLAG_FIRE1)!=0)
			{
				imagesX[KEY_FIRE1]=fire1U_width/2+hsize;
				imagesY[KEY_FIRE1]=sy-fire1U_height/2-hsize;
			}
			else if ((flags&JFLAG_FIRE2)!=0)
			{
				imagesX[KEY_FIRE2]=fire2U_width/2+hsize;
				imagesY[KEY_FIRE2]=sy-fire2U_height/2-hsize;
			}
		}
	}


	public void setXPosition(int f, int p)
	{
		staticPosition = true;

		int P = p;
		
		p *= MMFRuntime.inst.scaleX;
		p += MMFRuntime.inst.viewportX;

		if ((f&JFLAG_JOYSTICK)!=0)
		{
			lastJoyPos[KEY_JOYSTICK].flag = JFLAG_JOYSTICK;
			lastJoyPos[KEY_JOYSTICK].posX = P;
			imagesX[KEY_JOYSTICK]=p;
		}
		else if ((f&JFLAG_FIRE1)!=0)
		{
			lastJoyPos[KEY_FIRE1].flag = JFLAG_FIRE1;
			lastJoyPos[KEY_FIRE1].posX = P;
			imagesX[KEY_FIRE1]=p;
		}
		else if ((f&JFLAG_FIRE2)!=0)
		{
			lastJoyPos[KEY_FIRE2].flag = JFLAG_FIRE2;
			lastJoyPos[KEY_FIRE2].posX = P;
			imagesX[KEY_FIRE2]=p;
		}
	}

	public void setYPosition(int f, int p)
	{
		staticPosition = true;

		int P = p;
		
		p *= MMFRuntime.inst.scaleY;
		p += MMFRuntime.inst.viewportY;

		if ((f&JFLAG_JOYSTICK)!=0)
		{
			lastJoyPos[KEY_JOYSTICK].flag = JFLAG_JOYSTICK;
			lastJoyPos[KEY_JOYSTICK].posY = P;
			imagesY[KEY_JOYSTICK]=p;
		}
		else if ((f&JFLAG_FIRE1)!=0)
		{
			lastJoyPos[KEY_FIRE1].flag = JFLAG_FIRE1;
			lastJoyPos[KEY_FIRE1].posY = P;
			imagesY[KEY_FIRE1]=p;
		}
		else if ((f&JFLAG_FIRE2)!=0)
		{
			lastJoyPos[KEY_FIRE2].flag = JFLAG_FIRE2;
			lastJoyPos[KEY_FIRE2].posY = P;
			imagesY[KEY_FIRE2]=p;
		}
	}

	public void updatePosition()
	{
		setPositions();
		
		if (!staticPosition)
			return;
		
		for(LastJoystickPosition ljp : lastJoyPos)
		{
			setXPosition(ljp.flag, ljp.posX);
			setYPosition(ljp.flag, ljp.posY);
		}
	}
	
	public void draw()
	{
		GLRenderer renderer = GLRenderer.inst;
		
		boolean bAntialias = (MMFRuntime.inst.app.hdr2Options & CRunApp.AH2OPT_ANTIALIASED) != 0;
		
		renderer.beginWholeScreenDraw ();

		if ((flags&JFLAG_JOYSTICK)!=0)
		{		
			//if(isJoystick) {
			joyBack.setResampling(bAntialias);
			renderer.renderImage(joyBack, imagesX[KEY_JOYSTICK]-joyBack_width/2, imagesY[KEY_JOYSTICK]-joyBack_height/2, joyBack_width, joyBack_height, 0, 0);
			joyFront.setResampling(bAntialias);
			renderer.renderImage(joyFront, imagesX[KEY_JOYSTICK]+joystickX-joyFront_width/2, imagesY[KEY_JOYSTICK]+joystickY-joyFront_height/2, joyFront_width, joyFront_height, 0, 0);
			//}
			//else {
			// Drawing like Joystick will depend as the d-pad will be?
			//	renderer.renderImage(joyBack, imagesX[KEY_JOYSTICK]-joyBack_width/2, imagesY[KEY_JOYSTICK]-joyBack_height/2, joyBack_width, joyBack_height, 0, 0);
			//	renderer.renderImage(joyFront, imagesX[KEY_JOYSTICK]+joystickX-joyFront_width/2, imagesY[KEY_JOYSTICK]+joystickY-joyFront_height/2, joyFront_width, joyFront_height, 0, 0);
			//}
		}
		if ((flags&JFLAG_FIRE1)!=0)
		{
			CImage tex;
			int tw, th;

			if ((joystick&0x10)==0)
			{
				tex = fire1U;

				tw = fire1U_width;
				th = fire1U_height;
			}
			else
			{
				tex = fire1D;

				tw = fire1D_width;
				th = fire1D_height;
			}
			tex.setResampling(bAntialias);
			renderer.renderImage(tex, imagesX[KEY_FIRE1]-tw/2, imagesY[KEY_FIRE1]-th/2, tw, th, 0, 0);
		}
		if ((flags&JFLAG_FIRE2)!=0)
		{
			CImage tex;
			int tw, th;

			if ((joystick&0x20)==0)
			{
				tex = fire2U;

				tw = fire2U_width;
				th = fire2U_height;
			}
			else
			{
				tex = fire2D;

				tw = fire2D_width;
				th = fire2D_height;
			}

			tex.setResampling(bAntialias);
			renderer.renderImage(tex, imagesX[KEY_FIRE2]-tw/2, imagesY[KEY_FIRE2]-th/2, tw, th, 0, 0);
		}

		renderer.endWholeScreenDraw ();
	}

	@Override
	public void newTouch(int id, float x, float y)
	{
		x *= MMFRuntime.inst.scaleX;
		y *= MMFRuntime.inst.scaleY;

		x += MMFRuntime.inst.viewportX;
		y += MMFRuntime.inst.viewportY;

		int key = getKey((int) Math.floor(x), (int) Math.floor(y));

		joydeadzone = DEADZONE*Math.ceil(Math.sqrt(joyBack_width/2*joyBack_width/2+joyBack_height/2*joyBack_height/2));	//Radius Size percentage

		// Max circle radius for the joystick or d-pad
		joyradsize = (int) Math.ceil(Math.sqrt(joyBack_width/4*joyBack_width/4+joyBack_height/4*joyBack_height/4));

		if(key != KEY_NONE)
		{
			touches[key]=id;
			if (key==KEY_JOYSTICK)
			{
				joystick&=0xF0;
			}		
			else if (key==KEY_FIRE1)
			{
				joystick|=0x10;
			}
			else if (key==KEY_FIRE2)
			{
				joystick|=0x20;
			}
		}
	}

	@Override
	public void touchMoved(int id, float _x, float _y)
	{
		_x *= MMFRuntime.inst.scaleX;
		_y *= MMFRuntime.inst.scaleY;

		_x += MMFRuntime.inst.viewportX;
		_y += MMFRuntime.inst.viewportY;

		int x = Math.round(_x);
		int y = Math.round(_y);

		int key = getKey(x, y);

		if (key==KEY_JOYSTICK)
		{
			touches[KEY_JOYSTICK]=id;
		}
		if (id==touches[KEY_JOYSTICK])
		{
			joystickX=x-imagesX[KEY_JOYSTICK];
			joystickY=y-imagesY[KEY_JOYSTICK];

			joystick&=0xF0;

			double h=Math.sqrt(joystickX*joystickX+joystickY*joystickY);	// vector to point

			// angles ranges from 0 to 360 degrees in radians
			double angle=(Math.PI*2 - Math.atan2(joystickY, joystickX))%(Math.PI*2);

			// For  testing purpose isJoystick (true) work as circle
			// else work as joypad a square sized.

			if(isJoystick) {
				joystickX= (int) (Math.cos(angle)*joyradsize);			
				joystickY= (int) (Math.sin(angle)*-joyradsize);
			}
			else {
				if (joystickX<-joyradsize)
				{
					joystickX=-joyradsize;
				}
				if (joystickX>joyradsize)
				{
					joystickX=joyradsize;
				}
				if (joystickY<-joyradsize)
				{
					joystickY=-joyradsize;
				}
				if (joystickY>joyradsize)
				{
					joystickY=joyradsize;
				}
			}
			//Log.Log("joystickX: "+joystickX+" joystickY: "+joystickY);

			// Is the radius vector above the deadzone and border of the joystick base
			if (h > joydeadzone && h < joyradsize*4)
			{			

				int j=0;
				// Checking in 45 degrees zone equal (PI/4); 1/4, 2/4, 3/4, 4/4, 5/4, 6/4, 7/4, 8/4
				// organized like 8/4, 2/4, 4/4, 6/4,  priority for right, up, left and down
				if (angle>=0.0)
				{ 
					while(true) {
						// Right
						if(InsideZone(angle, 0, joyanglezone) || InsideZone(angle, (Math.PI)*2, joyanglezone)) {
							j=8;
							break;
						}
						// Up
						if(InsideZone(angle, Math.PI/2, joyanglezone)) {
							j=1;
							break;
						}
						// Left
						if(InsideZone(angle, (Math.PI), joyanglezone)) {
							j=4;
							break;
						}
						// Down
						if(InsideZone(angle, (Math.PI/4)*6, joyanglezone)) {
							j=2;
							break;
						}
						// Right/Up
						if(InsideZone(angle, Math.PI/4, Math.PI/2-joyanglezone)) {
							j=9;
							break;
						}
						// Left/Up
						if(InsideZone(angle, (Math.PI/4)*3, Math.PI/2-joyanglezone)) {
							j=5;
							break;
						}
						// Left/Down
						if(InsideZone(angle, (Math.PI/4)*5, Math.PI/2-joyanglezone)) {
							j=6;
							break;
						}
						// Right/Down
						if(InsideZone(angle, (Math.PI/4)*7, Math.PI/2-joyanglezone)) {
							j=10;
							break;
						}

						break;
					}
				}

				//Log.Log("angle: "+angle*180/Math.PI+" joystick: "+j);
				joystick|=j;
			}

		}
	}

	@Override
	public void endTouch(int id)
	{
		int n;
		for (n=0; n<MAX_TOUCHES; n++)
		{
			if (touches[n]==id)
			{
				touches[n] = -1;
				switch (n)
				{
				case KEY_JOYSTICK:
					joystickX=0;
					joystickY=0;
					joystick&=0xF0;
					break;
				case KEY_FIRE1:
					joystick&=~0x10;
					break;
				case KEY_FIRE2:
					joystick&=~0x20;
					break;
				}
				break;
			}
		}	
	}

	public int getKey(int x, int y)
	{	
		if ((flags&JFLAG_JOYSTICK) != 0)
		{
			if (x>=imagesX[KEY_JOYSTICK]-joyBack_width/2 && x<imagesX[KEY_JOYSTICK]+joyBack_width/2)
			{
				if (y>imagesY[KEY_JOYSTICK]-joyBack_height/2 && y<imagesY[KEY_JOYSTICK]+joyBack_height/2)
				{
					return KEY_JOYSTICK;
				}
			}
		}
		if ((flags&JFLAG_FIRE1) != 0)
		{
			if (x>=imagesX[KEY_FIRE1]-fire1U_width/2 && x<imagesX[KEY_FIRE1]+fire1U_width/2)
			{
				if (y>imagesY[KEY_FIRE1]-fire1U_height/2 && y<imagesY[KEY_FIRE1]+fire1U_height/2)
				{
					return KEY_FIRE1;
				}
			}
		}
		if ((flags&JFLAG_FIRE2) != 0)
		{
			if (x>=imagesX[KEY_FIRE2]-fire2U_width/2 && x<imagesX[KEY_FIRE2]+fire2U_width/2)
			{
				if (y>imagesY[KEY_FIRE2]-fire2U_height/2 && y<imagesY[KEY_FIRE2]+fire2U_height/2)
				{
					return KEY_FIRE2;
				}
			}
		}
		return KEY_NONE;
	}

	public void reset(int f)
	{
		flags=f;
		setPositions();
	}

	private boolean InsideZone(double angle, double angle_ref, double gap) {
		// check if the angle is in the range, could be ported using degrees instead.
		return (angle > (angle_ref-gap/2) && angle < (angle_ref+gap/2));
	}
}
