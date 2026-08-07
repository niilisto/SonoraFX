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

package OpenGL;


import Application.CRunApp;
import Banks.CImage;
import RunLoop.CObjInfo;
import Runtime.Log;
import Runtime.MMFRuntime;
import Runtime.SurfaceView;
import Services.CFontInfo;
import Services.CRect;
import Services.CServices;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.text.Layout.Alignment;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.TextUtils.TruncateAt;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager.LayoutParams;
import android.widget.Button;
import android.widget.LinearLayout;
//import android.util.LayoutDirection;
import android.widget.TextView;


public class CTextSurface
{
	CRunApp app;

	String prevText;
	short prevFlags;
	int prevColor;
	CFontInfo prevFont;
	
	public int width;
	public int height;

	public int Imgwidth;
	public int Imgheight;

	//private boolean bAntialias;

	int effect;
	int effectParam;

	int drawOffset;

	public Bitmap textBitmap;
	public Canvas textCanvas;
	public TextPaint textPaint;

	class CTextTexture extends CImage
	{
		public CTextTexture ()
		{
			allocNative2 ((MMFRuntime.inst.app.hdr2Options & CRunApp.AH2OPT_ANTIALIASED) != 0, (short) -1, CServices.getBitmapPixels (textBitmap), 0, 0, 0,
					0, textBitmap.getWidth(), textBitmap.getHeight (), SurfaceView.ES);
		}

		@Override
		public void onDestroy ()
		{
			textTexture = null;
		}
	}

	CTextTexture textTexture;

	public CTextSurface(CRunApp app, int width, int height)
	{
		this.app = app;
		
		this.Imgwidth = this.width = width;
		this.Imgheight = this.height = height;

		int bmpWidth = 1;
		int bmpHeight = 1;

		while(bmpWidth < width)
			bmpWidth *= 2;

		while(bmpHeight < height)
			bmpHeight *= 2;

		textBitmap = Bitmap.createBitmap(bmpWidth, bmpHeight, Bitmap.Config.ARGB_8888);
		textTexture = null;


		textBitmap.eraseColor(Color.TRANSPARENT);

		textCanvas = new Canvas(textBitmap);
		textPaint  = new TextPaint();

		//textPaint.density = CServices.deviceDensity(); 

		prevText = "";
		prevFlags = 0;
		prevFont = null;
		prevColor = 0;
	}

	public void resize(int width, int height, boolean backingOnly)
	{
		if (!backingOnly)
		{
			this.width = width;
			this.height = height;
		}

		this.Imgwidth = width;
		this.Imgheight = height;

		if(textBitmap.getWidth() >= width && textBitmap.getHeight() >= height)
			return;

		int bmpWidth = 1;
		int bmpHeight = 1;

		while(bmpWidth < width)
			bmpWidth *= 2;

		while(bmpHeight < height)
			bmpHeight *= 2;

		while(true)
		{
			try 
			{
				textBitmap = Bitmap.createBitmap(bmpWidth, bmpHeight, Bitmap.Config.ARGB_8888);
				textCanvas = new Canvas(textBitmap);
				textTexture = null;
				break;
			} 
			catch (OutOfMemoryError e) {
				Log.Log("Text too big to create ...");
				bmpWidth  = SurfaceView.maxSize;
				bmpHeight = SurfaceView.maxSize;
			}
		}

	}

	public void measureText (String s, short flags, CFontInfo font, CRect rect, int newWidth)
	{
		textPaint.setTypeface(font.createFont());
		textPaint.setTextSize(font.lfHeight);
		if(font.lfUnderline != 0)
			textPaint.setUnderlineText(true);
		else
			textPaint.setUnderlineText(false);

		int lWidth = newWidth;
		if ( newWidth == 0 )
			lWidth = width;

		Alignment alignment = CServices.textAlignment(flags, CServices.containsRtlChars(s));
		StaticLayout layout = new StaticLayout
				(s, textPaint, lWidth, alignment, 1.0f, 0.0f, false);

		int height = layout.getHeight ();
		if ((rect.top + height) <= rect.bottom)
			height = rect.bottom - rect.top;

		rect.bottom = rect.top + height;
		rect.right = rect.left + lWidth;
	}

	public void setDimension(int width, int height) {
		Imgwidth  = width;
		Imgheight = height;
	}

	public boolean setText(String s, short flags, int color, CFontInfo font, boolean dynamic)
	{
		if(s.equals(prevText) && color == prevColor && flags == prevFlags && font.equals(prevFont))
			return false;

		textBitmap.eraseColor(color & 0x00FFFFFF);

		prevFont = font;
		prevText = s;
		prevColor = color;
		prevFlags = flags;

		CRect rect = new CRect ();

		rect.left = 0;

		if(Imgwidth != width)
			rect.right = Imgwidth;
		else	
			rect.right = width;

		rect.top = 0;

		if(Imgheight != height)
			rect.bottom = Imgheight;
		else
			rect.bottom = height;

		manualDrawText(s, flags, rect, color, font, dynamic);
		updateTexture();
		return true;
	}

	public void manualDrawText(String s, short flags, CRect rect, int color, CFontInfo font, boolean dynamic)
	{
		int rectWidth = rect.right - rect.left;
		int rectHeight = rect.bottom - rect.top;

		Alignment alignment = CServices.textAlignment(flags, CServices.containsRtlChars(s));

		textPaint.setAntiAlias(true);
		textPaint.setColor(0xFF000000|color);
		textPaint.setTypeface(font.createFont());
		textPaint.setTextSize(font.lfHeight);

		if(font.lfUnderline != 0)
			textPaint.setUnderlineText(true);
		else
			textPaint.setUnderlineText(false);

		StaticLayout layout = new StaticLayout
				(s, textPaint, rectWidth, alignment, 1.0f, 0.0f, false);

		if (dynamic && (height < layout.getHeight () || width < layout.getWidth()))
		{
			resize (rectWidth, layout.getHeight (), true); 

			layout.draw (textCanvas);

			if ((flags & CServices.DT_BOTTOM) != 0)
				drawOffset = - (layout.getHeight () - rectHeight);
			else if ((flags & CServices.DT_VCENTER) != 0)
				drawOffset = - ((layout.getHeight () - rectHeight) / 2);

			Imgheight = layout.getHeight();
			Imgwidth = rectWidth;
		}
		else
		{
			drawOffset = 0;

			textCanvas.save();

			if ((flags & CServices.DT_BOTTOM) != 0)
				textCanvas.translate (rect.left, rect.bottom - layout.getHeight());
			else if ((flags & CServices.DT_VCENTER) != 0)
				textCanvas.translate (rect.left, rect.top + rectHeight / 2 - layout.getHeight() / 2);
			else
				textCanvas.translate (rect.left, rect.top);

			textCanvas.clipRect (0, 0, Imgwidth, Imgheight);

			layout.draw (textCanvas);

			textCanvas.restore();

		}
	}

	public void manualDrawTextEllipsis(String s, short flags, CRect rect, int color, CFontInfo font, boolean dynamic, int ellipsis_mode)
	{
		int rectWidth = rect.right - rect.left;
		int rectHeight = rect.bottom - rect.top;

		Alignment alignment = CServices.textAlignment(flags, CServices.containsRtlChars(s));

		TextView view = new TextView(MMFRuntime.inst);
		if(view == null)
			return;
		view.setText(s);

		int widthSpec = View.MeasureSpec.makeMeasureSpec(rectWidth, View.MeasureSpec.EXACTLY);
		int heightSpec = View.MeasureSpec.makeMeasureSpec(rectHeight, View.MeasureSpec.EXACTLY);
		view.measure(widthSpec, heightSpec);

        view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());

		view.setBackgroundColor(Color.TRANSPARENT);
		view.setTextColor(0xFF000000|color);
		view.setTypeface(font.createFont());
		view.setTextSize(TypedValue.COMPLEX_UNIT_PX, font.lfHeight); 

		if (ellipsis_mode == 0)
		{
			view.setEllipsize(TruncateAt.START);
		}
		else if (ellipsis_mode == 1)
		{
			view.setEllipsize(TruncateAt.END);
		}
		else if (ellipsis_mode == 2)
		{
			view.setEllipsize(TruncateAt.MIDDLE);
		}

		
		int gravity = 0;
		
		if ((flags & CServices.DT_CENTER) != 0)
			gravity |= Gravity.CENTER_HORIZONTAL;
		else {
			if(!CServices.containsRtlChars(s))
			{
				if ((flags & CServices.DT_RIGHT) != 0)
					gravity |= Gravity.RIGHT;
				else
					gravity |= Gravity.LEFT;
			}
			else
			{
				if ((flags & CServices.DT_RIGHT) != 0)
					gravity |= Gravity.LEFT;

				else
					gravity |= Gravity.RIGHT;
			}
		}
		

		if ((flags & CServices.DT_BOTTOM) != 0)
			gravity |= Gravity.BOTTOM;
		else if ((flags & CServices.DT_VCENTER) != 0)
			gravity |= Gravity.CENTER_VERTICAL;
		else
			gravity |= Gravity.TOP;

		view.setGravity(gravity);
		view.setTextAlignment(View.TEXT_ALIGNMENT_GRAVITY);
		//Log.Log("Gravity is: "+gravity);
		
		if((flags & CServices.DT_SINGLELINE) == 0)
			view.setSingleLine(false);
		else
		{
			view.setLines(1);
			view.setMaxLines(1);
		}
		
		view.setDrawingCacheEnabled(true);
        view.forceLayout();

        //Translate the Canvas into position and draw it
        textCanvas.save();

        int left = rect.left;

        if ((flags & CServices.DT_BOTTOM) != 0)
            textCanvas.translate (left, rect.bottom - view.getHeight());
        else if ((flags & CServices.DT_VCENTER) != 0)
            textCanvas.translate (left, rect.top + rectHeight / 2 - view.getHeight() / 2);
        else
            textCanvas.translate (left, rect.top);

        textCanvas.clipRect (0, 0, Imgwidth, Imgheight);


        view.draw(textCanvas);
		textCanvas.restore();

		view.destroyDrawingCache();
		view = null;
	}

	public void updateTexture()
	{
		if(textTexture != null)
			textTexture.updateWith(textBitmap);
		else
			textTexture = new CTextTexture();
	}

	public void manualClear(int color)
	{
		textBitmap.eraseColor(color & 0x00FFFFFF);
	}


	public void draw(int x, int y, int effect, int effectParam)
	{
		if (textTexture == null)
			updateTexture();
		
		// Not need of setAntialias it is done when surface is created ???
        textTexture.setResampling((MMFRuntime.inst.app.hdr2Options & CRunApp.AH2OPT_ANTIALIASED) != 0);
		GLRenderer.inst.renderImage
		(textTexture, x, y + drawOffset, -1, -1, effect, effectParam);
	}

	public void recycle ()
	{
		if (textBitmap != null)
		{
			textBitmap.recycle();
			textBitmap = null;
		}

		if (textTexture != null)
			textTexture.destroy (); /* will also set textTexture to null */
	}

	public int getWidth() {
		return this.Imgwidth;   	
	}

	public int getHeight() {
		return this.Imgheight;
	}

}
