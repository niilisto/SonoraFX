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

import Actions.CActExtension;
import Application.CRunApp;
import Banks.CImage;
import Conditions.CCndExtension;
import Expressions.CValue;
import OpenGL.GLRenderer;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import Runtime.MMFRuntime;
import Services.CBinaryFile;

public class CRunActiveBackdrop extends CRunExtension
{
	private short [] imageList;
	private boolean visible;
	private int currentImage;
	private CImage image;
	private CValue expRet;
	
	public CRunActiveBackdrop() {
		expRet = new CValue(0);
	}
	
	@Override 
	public int getNumberOfConditions()
	{
		return 1;
	}
	
    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
    	ho.hoImgWidth = file.readInt();
    	ho.hoImgHeight = file.readInt();

    	imageList = new short [file.readShort()];
    	
    	visible = file.readInt() != 0;
    	
    	for (int n = 0; n < imageList.length; ++ n)
    		imageList [n] = file.readShort();

    	if (imageList.length > 0)
    	{
    		ho.loadImageList (imageList);
    		currentImage = 0;
    		image = ho.getImageBank().getImageFromHandle(imageList [currentImage]);
    	}
    	else
    	{
    		currentImage = -1;
    	}

        return false;
    }

    @Override
    public void displayRunObject()
    {
    	if (currentImage >= 0)
    	{
    		if (visible)
    		{
    	        int drawX = ho.hoX;
    	        int drawY = ho.hoY;
    	        
    	        drawX -= rh.rhWindowX;
    	        drawY -= rh.rhWindowY;
    	        
    			if(image != null)
    			{
    				image.setResampling(ho.bAntialias);
    				GLRenderer.inst.renderImage(image, drawX, drawY, -1, -1, 0, 0);
    			}
    			
    		}
    	}
    }
    
    @Override
    public void pauseRunObject() {
    	//No need it since texture are destroyed and recreated according surfaceView destroy method.
    	//if(image != null)
    	//	image = null;
    }
    
    @Override
    public void continueRunObject() {
    	if(visible && currentImage >= 0 )
    		image = ho.getImageBank ().getImageFromHandle (imageList [currentImage]);

    }
    
    @Override
    public void getZoneInfos()
    {
    	if (currentImage >= 0)
    	{
			//CImage image = ho.getImageBank ().getImageFromHandle (imageList [currentImage]);

            if (image != null)
            {
			    ho.hoImgWidth = image.getWidth();
			    ho.hoImgHeight = image.getHeight();
            }
    	}
    	else
    	{
    		ho.hoImgWidth = 1;
    		ho.hoImgHeight = 1;
    	}
    }
    
    @Override
    public boolean condition (int num, CCndExtension cnd)
    {
    	switch (num)
    	{
    	case 0:
			return visible;  		
    	};
    	
    	return false;
    }
    
    @Override
    public void action (int num, CActExtension act)
    {
    	switch (num)
    	{
    		case 0:
    		{
				int nimage = act.getParamExpression (rh, 0);
				
				if (nimage >= 0 && nimage < imageList.length)
				{
					currentImage = nimage;
					image = null;
					image = ho.getImageBank().getImageFromHandle(imageList [currentImage]);
					ho.redisplay();
					ho.modif();
				}
				
				return;
			}
    		
    		case 1:    			
    		{
				ho.hoX = act.getParamExpression(rh, 0);
				ho.redisplay();
				ho.modif();
				
				return;
    		}

    		case 2:    			
    		{
				ho.hoY = act.getParamExpression(rh, 0);
				ho.redisplay();
				ho.modif();
				
				return;
    		}
    		
    		case 3:
    		{
    			visible = true;
    			return;
    		}

    		case 4:
    		{
    			visible = false;
    			return;
    		}
    	};    	
    }
    
    @Override
    public CValue expression (int num)
    {
    	switch (num)
    	{
	    	case 0:
	    		expRet.forceInt(currentImage);
	    		return expRet;
	    	case 1:
	    		expRet.forceInt(ho.hoX);
	    		return expRet;
	    	case 2:
	    		expRet.forceInt(ho.hoY);
	    		return expRet;
    	};   	
    	return expRet;
    }
   
}
