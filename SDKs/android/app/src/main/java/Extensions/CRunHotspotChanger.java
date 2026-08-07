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
import Banks.CImage;
import Banks.CImageBank;
import Banks.CImageInfo;
import Objects.CObject;

public class CRunHotspotChanger extends CRunExtension
{
    @Override
    public void action(int num, CActExtension act)
    {
        switch (num)
        {
            case 0:
            {
                CObject object = act.getParamObject (rh, 0);

                int x = act.getParamExpression (rh, 1);
                int y = act.getParamExpression (rh, 2);

                CImageBank imageBank = ho.hoAdRunHeader.rhApp.imageBank;

                if (object.roc.rcImage < 0 || object.roc.rcImage >= imageBank.images.size ())
                    break;

                CImageBank.BankSlot imageSlot = imageBank.images.get (object.roc.rcImage);

                if (imageSlot == null)
                    break;

                if (imageSlot.texture != null)
                {
                    ((CImage) imageSlot.texture).setXSpot (x);
                    ((CImage) imageSlot.texture).setYSpot (y);
                }
                else
                {
                    if (imageSlot.info_backup != null)
                    {
                        imageSlot.info_backup.xSpot = x;
                        imageSlot.info_backup.ySpot = y;
                    }
                }

                CImageInfo info = ho.hoAdRunHeader.rhApp.imageBank.getImageInfoEx
                    (object.roc.rcImage, object.roc.rcAngle,
                            object.roc.rcScaleX, object.roc.rcScaleY);

                if(info != null) {
	                object.hoImgXSpot = info.xSpot;
	                object.hoImgYSpot = info.ySpot;
                }

                break;
            }

            case 1:
            {
                CObject object = act.getParamObject (rh, 0);

                int x = act.getParamExpression (rh, 1);
                int y = act.getParamExpression (rh, 2);

                CImageBank imageBank = ho.hoAdRunHeader.rhApp.imageBank;

                if (object.roc.rcImage < 0 || object.roc.rcImage >= imageBank.images.size ())
                    break;

                CImageBank.BankSlot imageSlot = imageBank.images.get (object.roc.rcImage);

                if (imageSlot == null)
                    break;

                if (imageSlot.texture != null)
                {
                    ((CImage) imageSlot.texture).setXAP (x);
                    ((CImage) imageSlot.texture).setYAP (y);
                }
                else
                {
                    if (imageSlot.info_backup != null)
                    {
                        imageSlot.info_backup.xAP = x;
                        imageSlot.info_backup.yAP = y;
                    }
                }

                CImageInfo info = ho.hoAdRunHeader.rhApp.imageBank.getImageInfoEx
                    (object.roc.rcImage, object.roc.rcAngle,
                            object.roc.rcScaleX, object.roc.rcScaleY);

                if(info != null) {
	                object.hoImgXAP = info.xAP;
	                object.hoImgYAP = info.yAP;
                }
                break;
            }
        };
    }
}
