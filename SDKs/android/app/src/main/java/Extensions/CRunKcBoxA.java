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

//ASB box greyhill
//updated 15/04/09

package Extensions;

import Actions.CActExtension;
import Application.CKeyConvert;
import Application.CRunApp;
import Banks.CImage;
import Conditions.CCndExtension;
import Expressions.CValue;
import OpenGL.CTextSurface;
import OpenGL.GLRenderer;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import RunLoop.CRun;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Services.CServices;
import Sprites.CMask;
import android.text.StaticLayout;
import android.text.TextPaint;

public class CRunKcBoxA extends CRunExtension 
{
    public static int FLAG_HYPERLINK = 0x00004000;
    public static int FLAG_CONTAINER = 0x00001000;
    public static int FLAG_CONTAINED = 0x00002000;
    public static int COLOR_NONE = 0xFFFF;
    public static int FLAG_BUTTON_PRESSED = 0x10000000;
    public static int FLAG_BUTTON_HIGHLIGHTED = 0x20000000;
    public static int  FLAG_HIDEIMAGE = 0x01000000;
    public static int  COLORFLAG_RGB = 0x80000000;
    public static int  COLOR_FLAGS = (COLORFLAG_RGB);
    public static int  FLAG_CHECKED = 0x80000000;
    public static int  COLOR_BTNFACE = 15;
    public static int  COLOR_3DLIGHT = 22;
    public static int  FLAG_BUTTON = 0x00100000;
    public static int  FLAG_CHECKBOX = 0x00200000;
    public static int  FLAG_IMAGECHECKBOX = 0x00800000;
    public static int  FLAG_DISABLED = 0x40000000;
    public static int  FLAG_FORCECLIPPING = 0x02000000;
    public static int  ALIGN_IMAGE_TOPLEFT = 0x00010000;
    public static int  ALIGN_IMAGE_CENTER = 0x00020000;
    public static int  ALIGN_IMAGE_PATTERN = 0x00040000;
    public static int  ALIGN_TOP = 0x00000001;
    public static int  ALIGN_VCENTER = 0x00000002;
    public static int  ALIGN_BOTTOM = 0x00000004;
    public static int  ALIGN_LEFT = 0x00000010;
    public static int  ALIGN_HCENTER = 0x00000020;
    public static int  ALIGN_RIGHT = 0x00000040;
    public static int  ALIGN_MULTILINE = 0x00000100;
    public static int  ALIGN_NOPREFIX = 0x00000200;
    public static int  ALIGN_ENDELLIPSIS = 0x00000400;
    public static int  ALIGN_PATHELLIPSIS = 0x00000800;
    public static int  FLAG_SHOWBUTTONBORDER = 0x00400000;
    public static boolean bSysColorTab = false;
    public static int  COLOR_GRADIENTINACTIVECAPTION = 25;//28;
    public static int sysColorTab[];
    public static int  DOCK_LEFT = 0x00000001;
    public static int  DOCK_RIGHT = 0x00000002;
    public static int  DOCK_TOP = 0x00000004;
    public static int  DOCK_BOTTOM = 0x00000008;
    public static int  DOCK_FLAGS = (DOCK_LEFT | DOCK_RIGHT | DOCK_TOP | DOCK_BOTTOM);
    public static int  PARAMFLAG_SYSTEMCOLOR = 0x80000000;
        
    static short HOF_TRUEEVENT	= 0x0002;
    
    static final int CND_CLICKED = 0;
    static final int CND_ENABLED = 1;
    static final int CND_CHECKED = 2;
    static final int CND_LEFTCLICK = 3;
    static final int CND_RIGHTCLICK = 4;
    static final int CND_MOUSEOVER = 5;
    static final int CND_IMAGESHOWN = 6;
    static final int CND_DOCKED = 7;
    final static int ACT_ACTION_SETDIM = 0;
    final static int ACT_ACTION_SETPOS = 1;
    final static int ACT_ACTION_ENABLE = 2;
    final static int ACT_ACTION_DISABLE = 3;
    final static int ACT_ACTION_CHECK = 4;
    final static int ACT_ACTION_UNCHECK = 5;
    final static int ACT_ACTION_SETCOLOR_NONE	= 6;
    final static int ACT_ACTION_SETCOLOR_3DDKSHADOW = 7;
    final static int ACT_ACTION_SETCOLOR_3DFACE = 8;
    final static int ACT_ACTION_SETCOLOR_3DHILIGHT = 9;
    final static int ACT_ACTION_SETCOLOR_3DLIGHT = 10;
    final static int ACT_ACTION_SETCOLOR_3DSHADOW = 11;
    final static int ACT_ACTION_SETCOLOR_ACTIVECAPTION = 12;
    final static int ACT_ACTION_SETCOLOR_APPWORKSPACE = 13; //mdi
    final static int ACT_ACTION_SETCOLOR_DESKTOP = 14;
    final static int ACT_ACTION_SETCOLOR_HIGHLIGHT = 15;
    final static int ACT_ACTION_SETCOLOR_INACTIVECAPTION = 16;
    final static int ACT_ACTION_SETCOLOR_INFOBK = 17;
    final static int ACT_ACTION_SETCOLOR_MENU = 18;
    final static int ACT_ACTION_SETCOLOR_SCROLLBAR = 19;
    final static int ACT_ACTION_SETCOLOR_WINDOW = 20;
    final static int ACT_ACTION_SETCOLOR_WINDOWFRAME = 21;
    final static int ACT_ACTION_SETB1COLOR_NONE = 22;
    final static int ACT_ACTION_SETB1COLOR_3DDKSHADOW	= 23;
    final static int ACT_ACTION_SETB1COLOR_3DFACE = 24;
    final static int ACT_ACTION_SETB1COLOR_3DHILIGHT = 25;
    final static int ACT_ACTION_SETB1COLOR_3DLIGHT = 26;
    final static int ACT_ACTION_SETB1COLOR_3DSHADOW = 27;
    final static int ACT_ACTION_SETB1COLOR_ACTIVEBORDER = 28;
    final static int ACT_ACTION_SETB1COLOR_INACTIVEBORDER = 29;
    final static int ACT_ACTION_SETB1COLOR_WINDOWFRAME = 30;
    final static int ACT_ACTION_SETB2COLOR_NONE = 31;
    final static int ACT_ACTION_SETB2COLOR_3DDKSHADOW	= 32;
    final static int ACT_ACTION_SETB2COLOR_3DFACE = 33;
    final static int ACT_ACTION_SETB2COLOR_3DHILIGHT = 34;
    final static int ACT_ACTION_SETB2COLOR_3DLIGHT = 35;
    final static int ACT_ACTION_SETB2COLOR_3DSHADOW = 36;
    final static int ACT_ACTION_SETB2COLOR_ACTIVEBORDER = 37;
    final static int ACT_ACTION_SETB2COLOR_INACTIVEBORDER = 38;
    final static int ACT_ACTION_SETB2COLOR_WINDOWFRAME = 39;
    final static int ACT_ACTION_TEXTCOLOR_NONE = 40;
    final static int ACT_ACTION_TEXTCOLOR_3DHILIGHT = 41;
    final static int ACT_ACTION_TEXTCOLOR_3DSHADOW = 42;
    final static int ACT_ACTION_TEXTCOLOR_BTNTEXT = 43;
    final static int ACT_ACTION_TEXTCOLOR_CAPTIONTEXT = 44;
    final static int ACT_ACTION_TEXTCOLOR_GRAYTEXT = 45;
    final static int ACT_ACTION_TEXTCOLOR_HIGHLIGHTTEXT = 46;
    final static int ACT_ACTION_TEXTCOLOR_INACTIVECAPTIONTEXT = 47;
    final static int ACT_ACTION_TEXTCOLOR_INFOTEXT = 48;
    final static int ACT_ACTION_TEXTCOLOR_MENUTEXT = 49;
    final static int ACT_ACTION_TEXTCOLOR_WINDOWTEXT = 50;
    final static int ACT_ACTION_SETCOLOR_OTHER = 51;
    final static int ACT_ACTION_SETB1COLOR_OTHER = 52;
    final static int ACT_ACTION_SETB2COLOR_OTHER = 53;
    final static int ACT_ACTION_TEXTCOLOR_OTHER = 54;
    final static int ACT_ACTION_SETTEXT = 55;
    final static int ACT_ACTION_SETTOOLTIPTEXT = 56;
    final static int ACT_ACTION_UNDOCK = 57;
    final static int ACT_ACTION_DOCK_LEFT = 58;
    final static int ACT_ACTION_DOCK_RIGHT = 59;
    final static int ACT_ACTION_DOCK_TOP = 60;
    final static int ACT_ACTION_DOCK_BOTTOM = 61;
    final static int ACT_ACTION_SHOWIMAGE = 62;
    final static int ACT_ACTION_HIDEIMAGE = 63;
    final static int ACT_ACTION_RESETCLICKSTATE = 64;
    final static int ACT_ACTION_HYPERLINKCOLOR_NONE = 65;
    final static int ACT_ACTION_HYPERLINKCOLOR_3DHILIGHT = 66;
    final static int ACT_ACTION_HYPERLINKCOLOR_3DSHADOW = 67;
    final static int ACT_ACTION_HYPERLINKCOLOR_BTNTEXT = 68;
    final static int ACT_ACTION_HYPERLINKCOLOR_CAPTIONTEXT = 69;
    final static int ACT_ACTION_HYPERLINKCOLOR_GRAYTEXT = 70;
    final static int ACT_ACTION_HYPERLINKCOLOR_HIGHLIGHTTEXT = 71;
    final static int ACT_ACTION_HYPERLINKCOLOR_INACTIVECAPTIONTEXT = 72;
    final static int ACT_ACTION_HYPERLINKCOLOR_INFOTEXT = 73;
    final static int ACT_ACTION_HYPERLINKCOLOR_MENUTEXT = 74;
    final static int ACT_ACTION_HYPERLINKCOLOR_WINDOWTEXT = 75;
    final static int ACT_ACTION_HYPERLINKCOLOR_OTHER = 76;
    final static int ACT_ACTION_SETCMDID = 77;
    static final int EXP_COLOR_BACKGROUND = 0;
    static final int EXP_COLOR_BORDER1 = 1;
    static final int EXP_COLOR_BORDER2 = 2;
    static final int EXP_COLOR_TEXT = 3;
    static final int EXP_COLOR_3DDKSHADOW = 4;
    static final int EXP_COLOR_3DFACE = 5;
    static final int EXP_COLOR_3DHILIGHT = 6;
    static final int EXP_COLOR_3DLIGHT = 7;
    static final int EXP_COLOR_3DSHADOW = 8;
    static final int EXP_COLOR_ACTIVEBORDER = 9;
    static final int EXP_COLOR_ACTIVECAPTION = 10;
    static final int EXP_COLOR_APPWORKSPACE = 11;
    static final int EXP_COLOR_DESKTOP = 12;
    static final int EXP_COLOR_BTNTEXT = 13;
    static final int EXP_COLOR_CAPTIONTEXT = 14;
    static final int EXP_COLOR_GRAYTEXT = 15;
    static final int EXP_COLOR_HIGHLIGHT = 16;
    static final int EXP_COLOR_HIGHLIGHTTEXT = 17;
    static final int EXP_COLOR_INACTIVEBORDER = 18;
    static final int EXP_COLOR_INACTIVECAPTION = 19;
    static final int EXP_COLOR_INACTIVECAPTIONTEXT = 20;
    static final int EXP_COLOR_INFOBK = 21;
    static final int EXP_COLOR_INFOTEXT = 22;
    static final int EXP_COLOR_MENU = 23;
    static final int EXP_COLOR_MENUTEXT = 24;
    static final int EXP_COLOR_SCROLLBAR = 25;
    static final int EXP_COLOR_WINDOW = 26;
    static final int EXP_COLOR_WINDOWFRAME = 27;
    static final int EXP_COLOR_WINDOWTEXT = 28;
    static final int EXP_GETTEXT = 29;
    static final int EXP_GETTOOLTIPTEXT = 30;
    static final int EXP_GETWIDTH = 31;
    static final int EXP_GETHEIGHT = 32;
    static final int EXP_COLOR_HYPERLINK = 33;
    static final int EXP_GETX = 34;
    static final int EXP_GETY = 35;
    static final int EXP_SYSTORGB = 36;
    
    CFontInfo wFont;
    CFontInfo wUnderlinedFont;
    CRunKcBoxACData rData;
    CRunKcBoxACData1 rData1;
    long dwRtFlags;
    String pText;
    String pToolTip;
//    int	httX;
//    int	ttY;
    int rNumInObjList;		// Index of this object in objects list
    int rNumInContList;		// Index of this object in container list
    int rContNum;			// Index of the container of this object in container list
    short rContDx;			// Coordinates
    short rContDy;
    int rNumInBtnList;		// Index of this object in button list
    int  rClickCount;
    int  rLeftClickCount;
    int  rRightClickCount;
	int oldKMouse;
    //int	nCommandID; //used for menu-attaching

    CTextSurface textSurface;
	boolean textNeedsRedraw = true;

    short imageHandle;

    public CRunKcBoxA()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 8;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        CRun fprh = ho.hoAdRunHeader;

        // Get FrameData        
        CRunKcBoxACFrameData pData = null;
        CExtStorage pExtData = fprh.getStorage(ho.hoIdentifier);
        if (pExtData == null)
        {
            pData = new CRunKcBoxACFrameData();
            fprh.addStorage(pData, ho.hoIdentifier);
        }
        else
        {
            pData = (CRunKcBoxACFrameData) pExtData;
        }

        // Set up parameters
        ho.setX(cob.cobX);
        ho.setY(cob.cobY);
        ho.setWidth(file.readShort());
        ho.setHeight(file.readShort());

		textSurface = new CTextSurface(ho.getApplication(), ho.hoImgWidth, ho.hoImgHeight);

        // Copy CDATA (memcpy(&rdPtr->rData, &edPtr->eData, sizeof(CDATA));)
        this.rData = new CRunKcBoxACData();
        this.rData.dwFlags = file.readInt();
        this.rData.fillColor = file.readInt();
        this.rData.borderColor1 = file.readInt();
        this.rData.borderColor2 = file.readInt();

        //file.skipBytes(2);
        short imageList[] = new short[1];
        imageList[0] = file.readShort();
        if (imageList[0] != -1)
            ho.loadImageList(imageList);
        imageHandle = imageList [0];

        this.rData.wFree = file.readShort();
        this.rData.textColor = (0xFF << 24) | file.readColor();
        this.rData.textMarginLeft = file.readShort();
        this.rData.textMarginTop = file.readShort();
        this.rData.textMarginRight = file.readShort();
        this.rData.textMarginBottom = file.readShort();

        // Init font
        this.wFont = new CFontInfo();
        this.wUnderlinedFont = new CFontInfo();

        CFontInfo textLf;
        if (ho.hoAdRunHeader.rhApp.bUnicode==false)
        {
            textLf = file.readLogFont16();
        }
        else
        {
            textLf = file.readLogFont();
        }
        if (textLf.lfFaceName != null)
        {
            this.wFont = textLf;//this.wFont.font = textLf.createFont();
            if ((this.rData.dwFlags & FLAG_HYPERLINK) != 0)
            {
                textLf.lfUnderline = 1;
                this.wUnderlinedFont = textLf;//this.wUnderlinedFont.font = textLf.createFont();
            }
        }

        // Copy text
        this.dwRtFlags = 0;
        this.pText = "";
        this.pToolTip = "";
        file.readString(40);
        if (ho.hoAdRunHeader.rhApp.bUnicode==false)
        {
            file.skipBytes(2);
        }
        int textSize = file.readInt();

        if (ho.hoAdRunHeader.rhApp.bUnicode)
        {
            textSize=textSize/2;
        }
        if (textSize != 0)
        {
            // Extract tool tip
            String lText = file.readString(textSize);//file.readString();
            textSize=lText.length();
            for (int i = textSize; i > 1; i--)
            {
                if ((lText.charAt(i - 1) == 'n') && (lText.charAt(i - 2) == '\\'))
                {
                    int toolTipSize = textSize - i;
                    textSize = textSize - toolTipSize - 2;
                    if (toolTipSize != 0)
                    {
                        this.pToolTip=lText.substring(i);
                    }
                    lText = lText.substring(0, textSize);
                    break;
                }
            }
            if (textSize != 0)
            {
                this.pText = lText;
            }
        }
        // Add to global list of objects
        this.rNumInObjList = pData.AddObject(this); //up to here

        // Container?
        this.rNumInContList = -1;
        if ((this.rData.dwFlags & FLAG_CONTAINER) != 0)
        {
            this.rNumInContList = pData.AddContainer(this);
        }

        // Contained?
        this.rContNum = -1;
        if ((this.rData.dwFlags & FLAG_CONTAINED) != 0)
        {
            this.rContNum = pData.GetContainer(this);
            if (this.rContNum != -1)
            {
                CRunKcBoxA rdPtrCont = pData.pContainers.get(this.rContNum);
                this.rContDx = (short) (ho.getX() - rdPtrCont.ho.getX());
                this.rContDy = (short) (ho.getY() - rdPtrCont.ho.getY());
            }
        }
        file.skipBytes(1); //don't ask why
        this.rData1 = new CRunKcBoxACData1();
        this.rData1.dwVersion = file.readInt();
        this.rData1.dwUnderlinedColor = file.readColor();

        // Button?
        this.rNumInBtnList = -1;
        this.rClickCount = -1;
        this.rLeftClickCount = -1;
        this.rRightClickCount = -1;
        if ((this.rData.dwFlags & (FLAG_BUTTON | FLAG_HYPERLINK)) != 0)
        {
            this.rNumInBtnList = pData.AddButton(this);
        }

        // Tool tip
        //CreateToolTip(rdPtr);

        // Command ID
        //this.nCommandID = 0;

        fprh.delStorage(ho.hoIdentifier);
        fprh.addStorage(pData, ho.hoIdentifier);

        oldKMouse=0;

        return false;
    }

    @Override
    public void destroyRunObject(boolean bFast)
    {
        CRun rhPtr = ho.hoAdRunHeader;

        // Get FrameData
        CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData) rhPtr.getStorage(ho.hoIdentifier);

        // Button?
        if ((this.rNumInBtnList != -1) && (pData != null))
        {
            pData.RemoveButton(this);
        }

        // Container?
        if ((this.rNumInContList != -1) && (pData != null))
        {
            pData.RemoveContainer(this);
        }

        // Remove from global list of objects
        if ((this.rNumInObjList != -1) && (pData != null))
        {
            pData.RemoveObjectFromList(this);
        }
        
        rhPtr.delStorage(ho.hoIdentifier);
        
        if (pData.ImEmpty() == false)
        {
            rhPtr.addStorage(pData, ho.hoIdentifier);
        }

        if (textSurface != null)
            textSurface.recycle();
    }

    public void mouseClicked()
    {
        CRun rhPtr = ho.hoAdRunHeader;
        CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData) rhPtr.getStorage(ho.hoIdentifier);
        if (pData != null)
        {
            if ((this.rData.dwFlags & FLAG_DISABLED) == 0)
            {
                if (this.rNumInObjList == pData.GetObjectFromList(rh.getMouseFrameX()-rh.rhWindowX, rh.getMouseFrameY()-rh.rhWindowY))
                {
                    this.rClickCount = ho.getEventCount();
                    this.ho.pushEvent(CND_CLICKED, ho.getEventParam());
                    //Log.Log("Button: "+this.pText);
                }
            }
        }
    }

    public void mousePressed()
    {
        CRun rhPtr = ho.hoAdRunHeader;
        CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData) rhPtr.getStorage(ho.hoIdentifier);
        if (pData != null)
        {
            if ((this.rData.dwFlags & FLAG_DISABLED) == 0)
            {
                if (this.rNumInObjList == pData.GetObjectFromList(rh.getMouseFrameX()-rh.rhWindowX, rh.getMouseFrameY()-rh.rhWindowY))
                {
                    if ((this.rData.dwFlags & FLAG_BUTTON) != 0)//is a button
                    {
                        this.rData.dwFlags |= FLAG_BUTTON_PRESSED;
                        if ((this.rData.dwFlags & FLAG_CHECKBOX) != 0)//is a checkbox
                        {
                            if ((this.rData.dwFlags & FLAG_CHECKED) != 0) //is checked
                            {
                                this.rData.dwFlags &= ~FLAG_CHECKED;
                            }
                            else
                            {
                                this.rData.dwFlags |= FLAG_CHECKED;
                            }
                        }
                    }
                    if ((this.rData.dwFlags & FLAG_HYPERLINK) != 0) //if hyperlink
                    {
                        if ((this.rData.dwFlags & FLAG_BUTTON_HIGHLIGHTED) == 0)
                        {
                            this.rData.dwFlags |= FLAG_BUTTON_HIGHLIGHTED;
                        }
                    }
                    this.rLeftClickCount = ho.getEventCount();
                    this.ho.pushEvent(CND_LEFTCLICK, ho.getEventParam());
                    this.ho.redraw();
                    //Log.Log("Button: "+this.pText);
                }
            }
        }
    }

    public void mouseReleased()
    {
        boolean redraw = false;
        if ((this.rData.dwFlags & FLAG_BUTTON_PRESSED) != 0)
        {
            this.rData.dwFlags &= ~FLAG_BUTTON_PRESSED;
            redraw = true;
        }
        if ((this.rData.dwFlags & FLAG_BUTTON_HIGHLIGHTED) != 0)
        {
            this.rData.dwFlags &= ~FLAG_BUTTON_HIGHLIGHTED;
            redraw = true;
        }
        if (redraw == true)
        {
            ho.redraw();
        }
    }

    @Override
	public int handleRunObject()
    {
    	CRun rhPtr = this.ho.hoAdRunHeader;
        int oldX = this.ho.getX();
        int oldY = this.ho.getY();
        int newX = oldX;
        int newY = oldY;
        int reCode = 0;
        int kMouse = this.oldKMouse;
        
        // Gestion touches souris
        synchronized(rhPtr.rhApp.keyBuffer)		// Hold any possible change
        {
	        if(this.oldKMouse != rhPtr.rhApp.keyBuffer[CKeyConvert.VK_LBUTTON])
	        {
	        	kMouse = rhPtr.rhApp.keyBuffer[CKeyConvert.VK_LBUTTON]; 
	        	//Log.Log("kMouse: "+kMouse + " oldKMouse: "+oldKMouse);
	        }
	        
	        if (kMouse!=this.oldKMouse)
	        {
	            this.oldKMouse=kMouse;
	        	if (kMouse!=0)
	        	{
	        		//mouseClicked();
	        		mousePressed();
	        		//Log.Log("Pressed ....");
	        	}
	        	else
	        	{
	        		mouseClicked();
	        		mouseReleased();
	           		//Log.Log("Clicked ....");
	        	}
	        }
        }
        
        CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData) rhPtr.getStorage(ho.hoIdentifier);
        if (pData != null)
        {
            boolean bActive = true;
            if (bActive == true)
            {
                if (((this.rData.dwFlags & FLAG_BUTTON) != 0) || ((this.rData.dwFlags & FLAG_HYPERLINK) != 0)) //15th april 09 change
                {
                    if ((this.rData.dwFlags & FLAG_DISABLED) == 0)
                    {
                        if (this.rNumInObjList == pData.GetObjectFromList(rh.getMouseFrameX(), rh.getMouseFrameY()))
                        {
                            if ((this.rData.dwFlags & FLAG_BUTTON_HIGHLIGHTED) == 0)
                            {
                                this.rData.dwFlags |= FLAG_BUTTON_HIGHLIGHTED;
                            }
                        }
                        else
                        {
                            if ((this.rData.dwFlags & FLAG_BUTTON_HIGHLIGHTED) != 0)
                            {
                                this.rData.dwFlags &= ~FLAG_BUTTON_HIGHLIGHTED;
                            }
                        }
                        reCode = REFLAG_DISPLAY;
                    }
                }
            }
        }

        // Docking
        if ((this.dwRtFlags & DOCK_FLAGS) != 0 && (this.rData.dwFlags & FLAG_CONTAINED) == 0)
        {
            int windowWidth = rhPtr.rhApp.gaCxWin;
            int windowHeight = rhPtr.rhApp.gaCyWin;
            int x = 0;
            int y = 0;
            int w = rhPtr.rhApp.gaCxWin;
            int h = rhPtr.rhApp.gaCyWin;
            // Dock
            if ((this.dwRtFlags & DOCK_LEFT) != 0)
            {
                if (windowWidth > w)
                {
                    newX = rh.rhFrame.leX + Math.abs(x) - (windowWidth - w) / 2;
                }
                else
                {
                    newX = rh.rhFrame.leX + Math.abs(x);
                }
            }
            if ((this.dwRtFlags & DOCK_RIGHT) != 0)
            {
                if (windowWidth > w)
                {
                    newX = rh.rhFrame.leX + Math.abs(x) + w - ho.getWidth() - (windowWidth - w) / 2;
                }
                else
                {
                    newX = rh.rhFrame.leX + Math.abs(x) + w - ho.getWidth();
                }
            }
            if ((this.dwRtFlags & DOCK_TOP) != 0)
            {
                if (windowHeight > h)
                {
                    newY = rh.rhFrame.leY + Math.abs(y) - (windowHeight - h) / 2;
                }
                else
                {
                    newY = rh.rhFrame.leY + Math.abs(y);
                }
            }
            if ((this.dwRtFlags & DOCK_BOTTOM) != 0)
            {
                if (windowHeight > h)
                {
                    newY = rh.rhFrame.leY + Math.abs(y) + h - ho.getHeight() - (windowHeight - h) / 2;
                }
                else
                {
                    newY = rh.rhFrame.leY - Math.abs(y) + h - ho.getHeight(); //requires - here for some reason.
                }
            }
        }

        // Contained ? must update coordinates
        if ((this.rData.dwFlags & FLAG_CONTAINED) != 0)
        {
            // Not yet a container? search Medor, search!
            if (this.rContNum == -1)
            {
                if (pData != null)
                {
                    this.rContNum = pData.GetContainer(this);
                    if (this.rContNum != -1)
                    {
                        CRunKcBoxA rdPtrCont = pData.pContainers.get(this.rContNum);
                        this.rContDx = (short) (ho.getX() - rdPtrCont.ho.getX());
                        this.rContDy = (short) (ho.getY() - rdPtrCont.ho.getY());
                    }
                }
            }

            if ((this.rContNum != -1) && (pData != null) && (this.rContNum < pData.pContainers.size()))
            {
                CRunKcBoxA rdPtrCont = pData.pContainers.get(this.rContNum);
                if (rdPtrCont != null)
                {
                    newX = rdPtrCont.ho.getX() + this.rContDx;
                    newY = rdPtrCont.ho.getY() + this.rContDy;
                }
            }
        }

        if ((newX != oldX) || (newY != oldY))
        {
            ho.setX(newX);
            ho.setY(newY);

            // Update tooltip position
            //UpdateToolTipRect(rdPtr);

            reCode = REFLAG_DISPLAY;
        }

        // Moved by Set X/Y Coordinate function? Update tooltip position
//        if (((this.ttX != -1) && (this.ttY != -1)) && 
//            ((this.ttX != ho.getX() - rhPtr.rhWindowX) || (this.ttY != ho.getY() - rhPtr.rhWindowY)))
//        {
//            UpdateToolTipRect(rdPtr);
//        }
 
        return reCode;	// REFLAG_ONESHOT+REFLAG_DISPLAY; 

    }

    @Override
	public void displayRunObject()
    {
        // Get rhPtr
        CRect rc = new CRect();

        int x = ho.hoX - rh.rhWindowX;
        int y = ho.hoY - rh.rhWindowY;
        
        rc.left = x;
        rc.top = y;
        //rc.left -= rh.a;
        //rc.top -= rh.rhWindowY;
        rc.right = x + ho.hoImgWidth;
        rc.bottom = y + ho.hoImgHeight;
        
        
        //Log.Log("DisplayObject-left "+rc.left+" top "+rc.top+" right "+rc.right+" bottom "+rc.bottom);

        // Check clipping
        //if ((rc.right > 0) && (rc.bottom > 0) && (rc.left < g2.->GetWidth()) && rc.top < ps->GetHeight() )
        //{
        // Font
        CFontInfo font=this.wFont;
        if ((this.wFont != null) && (this.pText.length() != 0) && (this.rData.textColor != COLOR_NONE))
        {
            if (((this.rData.dwFlags & FLAG_HYPERLINK) != 0) && (this.wUnderlinedFont != null))
            {
                if ((this.rData.dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED)) != 0)
                {
                    boolean bActive = true;
                    if (bActive == true)
                    {
                        font = this.wUnderlinedFont;//.font;
                    }
                }
            }
        }
        DisplayObject(ho.hoAdRunHeader.rhApp, rc, this.rData, this.pText, font, this.rData1);
    }

   
    public void BuildSysColorTable()
    {
        sysColorTab = new int[COLOR_GRADIENTINACTIVECAPTION];
        sysColorTab[0] = 0xc8c8c8;
        sysColorTab[1] = 0x000000;
        sysColorTab[2] = 0x99b4d1;
        sysColorTab[3] = 0xbfcddb;//SystemColor.activeCaptionBorder;
        sysColorTab[4] = 0xf0f0f0;
        sysColorTab[5] = 0xffffff;
        sysColorTab[6] = 0x646464;//SystemColor.inactiveCaptionBorder;
        sysColorTab[7] = 0x000000;
        sysColorTab[8] = 0x000000;
        sysColorTab[9] = 0x000000;
        sysColorTab[10] = 0xb4b4b4;//new
        sysColorTab[11] = 0xf4f7fc;//new
        sysColorTab[12] = 0xababab;//mdi one, doesn't quite match. There is no java mdi background colour./ AppWorksapce
        sysColorTab[13] = 0x3399ff;//SystemColor.textText;
        sysColorTab[14] = 0xffffff; //new //SystemColor.textHighlight;
        sysColorTab[15] = 0xf0f0f0;//SystemColor.textHighlightText;
        sysColorTab[16] = 0xa0a0a0;//SystemColor.textInactiveText;
        sysColorTab[17] = 0x808080;
        sysColorTab[18] = 0x000000;
        sysColorTab[19] = 0x434e54;
        sysColorTab[20] = 0xffffff;
        sysColorTab[21] = 0x696969;
        sysColorTab[22] = 0xe3e3e3;
        sysColorTab[23] = 0x000000;
        sysColorTab[24] = 0xffffe1;
    }

    int myGetSysColor(int colorIndex)
    {
        // Build table
        if (!bSysColorTab)
        {
            BuildSysColorTable();
            bSysColorTab = true;
        }

        // Get color
        if (colorIndex < COLOR_GRADIENTINACTIVECAPTION)
        {
            return sysColorTab[colorIndex];
        }

        // Unknown color
        //return GetSysColor(colorIndex);
        return 0;
    }

    public int fromC(int c) //convert from c++ colour to java
    {
        int r = c&0x0000FF;
        int g = (c&0x00FF00)>>8;
        int b = (c&0xFF0000)>>16;
        return (r<<16)|(g<<8)|b;
    }

    void DisplayObject(CRunApp idApp, CRect rc, CRunKcBoxACData pc, String pText, CFontInfo font, CRunKcBoxACData1 pdata1)
    {
        GLRenderer renderer = GLRenderer.inst;

        int x = rc.left;
        int y = rc.top;
        int w = rc.right - rc.left;
        int h = rc.bottom - rc.top;
        
		final int step = 2;

        CRect oldrc = new CRect();
        oldrc.copyRect(rc);
        
        rc.left = rc.top = 0;
        rc.bottom = h;
        rc.right = w;
        
        // Background
        if (pc.fillColor != COLOR_NONE)
        {
            int color;
            int clr = pc.fillColor;
            if ((clr & COLORFLAG_RGB) != 0)
            {
                color = clr & ~COLOR_FLAGS;
                color = fromC(color);
            }
            else
            {
                if (((pc.dwFlags & FLAG_CHECKED) != 0) && (clr == COLOR_BTNFACE))
                {
                    clr = COLOR_3DLIGHT;
                }
                color = myGetSysColor(clr);
            }
            renderer.fillZone(x, y, w, h, color|0xFF000000);
        }

        // Image
        if ((imageHandle != -1) && ((pc.dwFlags & FLAG_HIDEIMAGE) == 0))
        {
            CImage image = ho.getImageBank().getImageFromHandle (imageHandle);

            if(image != null)
            {
                Boolean bDisplayImage = true;
                if ((pc.dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) == (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
                {
                    if ((pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) == 0)
                    {
                        bDisplayImage = false;
                    }
                }
                if (bDisplayImage == true)
                {

    //                BlitOp bop = BOP_COPY;
    //                long dwParam = 0L;
    //                if ( (pc.dwFlags & FLAG_DISABLED) != 0)
    //                {
    //                    bop = BOP_BLEND;
    //                    dwParam = 70;
    //                }

                    int xc, yc, wc, hc;
                    if ((pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
                            (pc.dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
                    {
                        x += step;
                        y += step;
                    }

                    xc = x;
                    wc = w;
                    yc = y;
                    hc = h;

                    if ((pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
                            (pc.dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
                    {
                        wc -= step;
                        hc -= step;
                    }

                    if (wc > 0 && hc > 0)
                    {
                        renderer.pushClip(xc, yc, wc, hc);
                        if ((pc.dwFlags & ALIGN_IMAGE_TOPLEFT) != 0)
                        {
                        	image.setResampling(ho.bAntialias);
                            renderer.renderImage(image, x, y, image.getWidth (), image.getHeight (), 0, 0);
                        }
                        else if ((pc.dwFlags & ALIGN_IMAGE_CENTER) != 0)
                        {
                            int wi = image.getWidth ();
                            int hi = image.getHeight ();
                        	image.setResampling(ho.bAntialias);
                            renderer.renderImage(image, x + (w - wi) / 2, y + (h - hi) / 2,
                                                        wi, hi, 0, 0);
                        }
                        else if ((pc.dwFlags & ALIGN_IMAGE_PATTERN) != 0)
                        {
                            int wi = image.getWidth ();
                            int hi = image.getHeight ();
                            for (int yi = 0; yi < h; yi += hi)
                            {
                                for (int xi = 0; xi < w; xi += wi)
                                {
                                	image.setResampling(ho.bAntialias);
                                    renderer.renderImage(image, x + xi, y + yi,
                                                            wi, hi, 0, 0);
                                }
                            }
                        }
                        renderer.popClip();
                    }

                    pc.dwFlags &= ~FLAG_FORCECLIPPING;

                    if ((pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
                            (pc.dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
                    {
                        x -= step;
                        y -= step;
                    }
                }
            }
        }

        // Text
        if ((pText.length() != 0) && (pc.textColor != COLOR_NONE))
        {
			if(textNeedsRedraw)
        	{
        		textNeedsRedraw = false;
        		boolean cleared = false;
	
	        	int dtFlags = 0;
	        	
	    		if ( (pc.dwFlags & ALIGN_MULTILINE) == 0 )
	    			dtFlags |= CServices.DT_SINGLELINE;
	
	    		if ( (pc.dwFlags & ALIGN_LEFT) != 0 )
	    			dtFlags |= CServices.DT_LEFT;
	    		if (( pc.dwFlags & ALIGN_HCENTER) != 0 )
	    			dtFlags |= CServices.DT_CENTER;
	    		if (( pc.dwFlags & ALIGN_RIGHT) != 0 )
	    			dtFlags |= CServices.DT_RIGHT;

                if (( pc.dwFlags & ALIGN_TOP) != 0 )
                    dtFlags |= CServices.DT_TOP;
                if (( pc.dwFlags & ALIGN_VCENTER) != 0 )
                    dtFlags |= CServices.DT_VCENTER;
                if (( pc.dwFlags & ALIGN_BOTTOM) != 0 )
                    dtFlags |= CServices.DT_BOTTOM;

                //ALIGN_ENDELLIPSIS = 0x00000400;
                //ALIGN_PATHELLIPSIS = 0x00000800;
                int ellipsis_mode = 0;
                
                if ((pc.dwFlags & ALIGN_ENDELLIPSIS) != 0)
                	ellipsis_mode = 1;
                if ((pc.dwFlags & ALIGN_PATHELLIPSIS) != 0)
                	ellipsis_mode = 2;
                
	    		// Add margin
	    		rc.left += pc.textMarginLeft;
	    		rc.top += pc.textMarginTop;
	    		rc.right -= (pc.textMarginRight+1);
	    		rc.bottom -= (pc.textMarginBottom+1);
	    		
	    		
	    		if ( (pc.dwFlags & FLAG_BUTTON) != 0 && (pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
	    					(pc.dwFlags & (FLAG_BUTTON|FLAG_CHECKBOX|FLAG_IMAGECHECKBOX)) !=
	    						(FLAG_BUTTON|FLAG_CHECKBOX|FLAG_IMAGECHECKBOX) )
	    		{
	    			rc.left += step;
	    			rc.top += step;
	    		}

	    		// Text color...
	            if ((pc.dwFlags & FLAG_DISABLED) != 0)
	            {
	                int clr = myGetSysColor(20);
	                rc.left++;
	                rc.top++;
	                rc.right++;
	                rc.bottom++;
	
	                if(!cleared)
	                {
	                	
	                	textSurface.manualClear(clr);
	                	cleared = true;
	                }
	                
	                textSurface.manualDrawTextEllipsis(pText, (short) dtFlags, rc, clr, font, false, ellipsis_mode);
	                
	                clr = myGetSysColor(16);
	                rc.left--;
	                rc.top--;
	                rc.right--;
	                rc.bottom--;
	                
	                textSurface.manualDrawTextEllipsis(pText, (short) dtFlags, rc, clr, font, false, ellipsis_mode);
	            }
	            else
	            {
	                int clr = pc.textColor;
	                
	                if ((pc.dwFlags & FLAG_HYPERLINK) != 0)
	                {
	                    if ((pc.dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED)) != 0)
	                    {
	                        clr = pdata1.dwUnderlinedColor;		// COLORFLAG_RGB | 0x0000FF;
	                    }
	                }
	
	                if ((clr & COLORFLAG_RGB) != 0)
	                {
	                    clr &= ~COLOR_FLAGS;
	                }
	                else
	                {
	                    clr = myGetSysColor(clr);
	                }

	                if(!cleared)
	                {
	                	textSurface.manualClear(clr);
	                	cleared = true;
	                }
	                
	                //int lineCount = measureText (pText, (short) dtFlags, rc, font, 0);	                
	                textSurface.manualDrawTextEllipsis(pText, (short) dtFlags, rc, clr, font, false, ellipsis_mode);
	            }
	    		
	    		if ( (pc.dwFlags & FLAG_BUTTON) != 0 &&
	    				(pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 &&
	    				(pc.dwFlags & (FLAG_BUTTON|FLAG_CHECKBOX|FLAG_IMAGECHECKBOX)) !=
	    					(FLAG_BUTTON|FLAG_CHECKBOX|FLAG_IMAGECHECKBOX) )
	    		{
	    			rc.left -= step;
	    			rc.top  -= step;
	    		}
	    		
	    		// Remove margin
	    		rc.left -= pc.textMarginLeft;
	    		rc.top -= pc.textMarginTop;
	    		rc.right += pc.textMarginRight;
	    		rc.bottom += pc.textMarginBottom;
	    		
	    		textSurface.updateTexture();
        	}
        
    		textSurface.draw(oldrc.left, oldrc.top, 0, 0);
        }

        // Border
    	int color1 = pc.borderColor1;
    	int color2 = pc.borderColor2;
    	boolean bDisplayBorder = true;
    	if ((pc.dwFlags & FLAG_BUTTON) != 0)
    	{
    		if ((pc.dwFlags & FLAG_SHOWBUTTONBORDER) == 0)
    		{
    			// App active?
    			bDisplayBorder = ((pc.dwFlags & (FLAG_BUTTON_HIGHLIGHTED | FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0);
    		}
    		if ((pc.dwFlags & (FLAG_BUTTON_PRESSED | FLAG_CHECKED)) != 0 && (pc.dwFlags & (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX)) != (FLAG_BUTTON | FLAG_CHECKBOX | FLAG_IMAGECHECKBOX))
    		{
    			color1 = pc.borderColor2;
    			color2 = pc.borderColor1;
    		}
    	}
    	if (bDisplayBorder)
    	{
    		if (color1 != COLOR_NONE)
    		{
    			if ((color1 & COLORFLAG_RGB) != 0)
    			{
    				color1 &= ~COLOR_FLAGS;
    				color1 = fromC(color1);
    			}
    			else
    			{
    				color1 = myGetSysColor(color1);
    			}
    			renderer.fillZone(x, y, w-1, 1, color1);
    			renderer.fillZone(x, y, 1, h-1, color1);
    		}
    		if (color2 != COLOR_NONE)
    		{
    			if ((color2 & COLORFLAG_RGB) != 0)
    			{
    				color2 &= ~COLOR_FLAGS;
    				color2 = fromC(color2);
    			}
    			else
    			{
    				color2 = myGetSysColor(color2);
    			}
    			renderer.fillZone(x, y+h-1, w-1, 1, color2);
    			renderer.fillZone(x+w-1, y, 1, h, color2);
    		}
    	}
    }

    @Override
	public CFontInfo getRunObjectFont()
    {
        return this.wFont;
    }

    @Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
    {
    	//if(fi != this.wFont)
    	textNeedsRedraw = true;
    	
        this.wFont = fi;
        if ((this.rData.dwFlags & FLAG_HYPERLINK) != 0)
        {
            fi.lfUnderline = 1;
            this.wUnderlinedFont = fi;
        }

        if (rc != null)
        {
            ho.setWidth(rc.right);
            ho.setHeight(rc.bottom);
            ho.hoRect.right = ho.hoRect.left + rc.right;
            ho.hoRect.bottom = ho.hoRect.top + rc.bottom;
        }
        ho.redraw();

    }

    @Override
	public int getRunObjectTextColor()
    {
        int clr = this.rData.textColor;
        if ((clr & COLORFLAG_RGB) != 0)
        {
            return clr & ~COLORFLAG_RGB;
        }
        return myGetSysColor(clr);
    }

    @Override
	public void setRunObjectTextColor(int rgb)
    {
    	if(this.rData.textColor != (rgb | COLORFLAG_RGB))
    		textNeedsRedraw = true;
    	
        this.rData.textColor = (rgb | COLORFLAG_RGB);
        ho.redraw();
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

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        switch (num){
	        case CND_CLICKED:
	            return IsClicked();
	        case CND_ENABLED:
	            return IsEnabled();
	        case CND_CHECKED:
	            return IsChecked();
	        case CND_LEFTCLICK:
	            return LeftClick();
	        case CND_RIGHTCLICK:
	            return RightClick();
	        case CND_MOUSEOVER:
	            return MouseOver();
	        case CND_IMAGESHOWN:
	            return IsImageShown();
	        case CND_DOCKED:
	            return IsDocked();
	    }
	    return false;
    }
    private boolean IsClicked()
    {
        CRun rhPtr = ho.hoAdRunHeader;
        if (rClickCount == -1)
        {
            return false;
        }
        if ((ho.hoFlags & HOF_TRUEEVENT) != 0)
        {
            return true;
        }
        if (rhPtr.rh4EventCount == rClickCount)
        {
            return true;
        }
        return false;
    }
    private boolean IsEnabled()
    {
        return ((rData.dwFlags & CRunKcBoxA.FLAG_DISABLED) == 0);
    }
    private boolean IsChecked()
    {
        return ((rData.dwFlags & CRunKcBoxA.FLAG_CHECKED) != 0);
    }
    private boolean LeftClick()
    {
        CRun rhPtr = ho.hoAdRunHeader;
        if ((ho.hoFlags & HOF_TRUEEVENT) != 0)
        {
            return true;
        }
        if (rhPtr.rh4EventCount == rLeftClickCount)
        {
            return true;
        }
        return false;
    }
    private boolean RightClick()
    {
        CRun rhPtr = ho.hoAdRunHeader;
        if ((ho.hoFlags & HOF_TRUEEVENT) != 0)
        {
            return true;
        }
        if (rhPtr.rh4EventCount == rRightClickCount)
        {
            return true;
        }
        return false;
    }

    private boolean MouseOver()
    {
        CRun	rhPtr = ho.hoAdRunHeader;
        CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData)rhPtr.getStorage(ho.hoIdentifier);
        boolean bActive = true;
        if (bActive == true)
        {
            if (pData != null)
            {
                return (rNumInObjList == pData.GetObjectFromList(rh.getMouseFrameX(), rh.getMouseFrameY()));
            }
        }
        return false;
    }
        
    private boolean IsImageShown()
    {
    	return ((rData.dwFlags & CRunKcBoxA.FLAG_HIDEIMAGE) == 0);
    }
    private boolean IsDocked()
    {
    	return ((dwRtFlags & CRunKcBoxA.DOCK_FLAGS) != 0);
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        switch (num){
	        case ACT_ACTION_SETDIM:
	            SetDimensions(act.getParamExpression(rh, 0),act.getParamExpression(rh, 1));
	            break;
	        case ACT_ACTION_SETPOS:
	            SetPosition(act.getParamExpression(rh, 0),act.getParamExpression(rh, 1));
	            break;
	        case ACT_ACTION_ENABLE:
	            Enable();
	            break;
	        case ACT_ACTION_DISABLE:
	            Disable();
	            break;
	        case ACT_ACTION_CHECK:
	            Check();
	            break;
	        case ACT_ACTION_UNCHECK:
	            Uncheck();
	            break;
	        case ACT_ACTION_SETCOLOR_NONE:
	            SetFillColor_None();
	            break;
	        case ACT_ACTION_SETCOLOR_3DDKSHADOW:
	            SetFillColor_3DDKSHADOW();
	            break;
	        case ACT_ACTION_SETCOLOR_3DFACE:
	            SetFillColor_3DFACE();
	            break;
	        case ACT_ACTION_SETCOLOR_3DHILIGHT:
	            SetFillColor_3DHIGHLIGHT();
	            break;
	        case ACT_ACTION_SETCOLOR_3DLIGHT:
	            SetFillColor_3DLIGHT();
	            break;
	        case ACT_ACTION_SETCOLOR_3DSHADOW:
	            SetFillColor_3DSHADOW();
	            break;
	        case ACT_ACTION_SETCOLOR_ACTIVECAPTION:
	            SetFillColor_ACTIVECAPTION();
	            break;
	        case ACT_ACTION_SETCOLOR_APPWORKSPACE:
	            SetFillColor_APPWORKSPACE();
	            break;
	        case ACT_ACTION_SETCOLOR_DESKTOP:
	            SetFillColor_DESKTOP();
	            break;
	        case ACT_ACTION_SETCOLOR_HIGHLIGHT:
	            SetFillColor_HIGHLIGHT();
	            break;
	        case ACT_ACTION_SETCOLOR_INACTIVECAPTION:
	            SetFillColor_INACTIVECAPTION();
	            break;
	        case ACT_ACTION_SETCOLOR_INFOBK:
	            SetFillColor_INFOBK();
	            break;
	        case ACT_ACTION_SETCOLOR_MENU:
	            SetFillColor_MENU();
	            break;
	        case ACT_ACTION_SETCOLOR_SCROLLBAR:
	            SetFillColor_SCROLLBAR();
	            break;
	        case ACT_ACTION_SETCOLOR_WINDOW:
	            SetFillColor_WINDOW();
	            break;
	        case ACT_ACTION_SETCOLOR_WINDOWFRAME:
	            SetFillColor_WINDOWFRAME();
	            break;
	        case ACT_ACTION_SETCOLOR_OTHER:
	            SetFillColor_Other(act.getParamExpression(rh, 0));
	            break;
	        case ACT_ACTION_SETB1COLOR_NONE:
	            SetB1Color_None();
	            break;
	        case ACT_ACTION_SETB1COLOR_3DDKSHADOW:
	            SetB1Color_3DDKSHADOW();
	            break;
	        case ACT_ACTION_SETB1COLOR_3DFACE:
	            SetB1Color_3DFACE();
	            break;
	        case ACT_ACTION_SETB1COLOR_3DLIGHT:
	            SetB1Color_3DLIGHT();
	            break;
	        case ACT_ACTION_SETB1COLOR_3DHILIGHT:
	            SetB1Color_3DHIGHLIGHT();
	            break;
	        case ACT_ACTION_SETB1COLOR_3DSHADOW:
	            SetB1Color_3DSHADOW();
	            break;
	        case ACT_ACTION_SETB1COLOR_ACTIVEBORDER:
	            SetB1Color_ACTIVEBORDER();
	            break;
	        case ACT_ACTION_SETB1COLOR_INACTIVEBORDER:
	            SetB1Color_INACTIVEBORDER();
	            break;
	        case ACT_ACTION_SETB1COLOR_WINDOWFRAME:
	            SetB1Color_WINDOWFRAME();
	            break;
	        case ACT_ACTION_SETB1COLOR_OTHER:
	            SetB1Color_Other(act.getParamExpression(rh, 0));
	            break;
	        case ACT_ACTION_SETB2COLOR_NONE:
	            SetB2Color_None();
	            break;
	        case ACT_ACTION_SETB2COLOR_3DDKSHADOW:
	            SetB2Color_3DDKSHADOW();
	            break;
	        case ACT_ACTION_SETB2COLOR_3DFACE:
	            SetB2Color_3DFACE();
	            break;
	        case ACT_ACTION_SETB2COLOR_3DHILIGHT:
	            SetB2Color_3DHIGHLIGHT();
	            break;
	        case ACT_ACTION_SETB2COLOR_3DLIGHT:
	            SetB2Color_3DLIGHT();
	            break;
	        case ACT_ACTION_SETB2COLOR_3DSHADOW:
	            SetB2Color_3DSHADOW();
	            break;
	        case ACT_ACTION_SETB2COLOR_ACTIVEBORDER:
	            SetB2Color_ACTIVEBORDER();
	            break;
	        case ACT_ACTION_SETB2COLOR_INACTIVEBORDER:
	            SetB2Color_INACTIVEBORDER();
	            break;
	        case ACT_ACTION_SETB2COLOR_WINDOWFRAME:
	            SetB2Color_WINDOWFRAME();
	            break;
	        case ACT_ACTION_SETB2COLOR_OTHER:
	            SetB2Color_Other( act.getParamExpression(rh, 0));
	            break;
	        case ACT_ACTION_TEXTCOLOR_NONE:
	            SetTxtColor_None();
	            break;
	        case ACT_ACTION_TEXTCOLOR_3DHILIGHT:
	            SetTxtColor_3DHIGHLIGHT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_3DSHADOW:
	            SetTxtColor_3DSHADOW();
	            break;
	        case ACT_ACTION_TEXTCOLOR_BTNTEXT:
	            SetTxtColor_BTNTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_CAPTIONTEXT:
	            SetTxtColor_CAPTIONTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_GRAYTEXT:
	            SetTxtColor_GRAYTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_HIGHLIGHTTEXT:
	            SetTxtColor_HIGHLIGHTTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_INACTIVECAPTIONTEXT:
	            SetTxtColor_INACTIVECAPTIONTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_INFOTEXT:
	            SetTxtColor_INFOTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_MENUTEXT:
	            SetTxtColor_MENUTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_WINDOWTEXT:
	            SetTxtColor_WINDOWTEXT();
	            break;
	        case ACT_ACTION_TEXTCOLOR_OTHER:
	            SetTxtColor_Other( act.getParamExpression(rh, 0));
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_NONE:
	            SetHyperlinkColor_None();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_3DHILIGHT:
	            SetHyperlinkColor_3DHIGHLIGHT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_3DSHADOW:
	            SetHyperlinkColor_3DSHADOW();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_BTNTEXT:
	            SetHyperlinkColor_BTNTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_CAPTIONTEXT:
	            SetHyperlinkColor_CAPTIONTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_GRAYTEXT:
	            SetHyperlinkColor_GRAYTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_HIGHLIGHTTEXT:
	            SetHyperlinkColor_HIGHLIGHTTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_INACTIVECAPTIONTEXT:
	            SetHyperlinkColor_INACTIVECAPTIONTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_INFOTEXT:
	            SetHyperlinkColor_INFOTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_MENUTEXT:
	            SetHyperlinkColor_MENUTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_WINDOWTEXT:
	            SetHyperlinkColor_WINDOWTEXT();
	            break;
	        case ACT_ACTION_HYPERLINKCOLOR_OTHER:
	            SetHyperlinkColor_Other(act.getParamExpression(rh, 0));
	            break;
	        case ACT_ACTION_SETTEXT:
	            SetText(act.getParamExpString(rh, 0));
	            break;
	        case ACT_ACTION_SETTOOLTIPTEXT:
	            SetToolTipText(act.getParamExpString(rh, 0));
	            break;
	        case ACT_ACTION_UNDOCK:
	            Undock();
	            break;
	        case ACT_ACTION_DOCK_LEFT:
	            DockLeft();
	            break;
	        case ACT_ACTION_DOCK_RIGHT:
	            DockRight();
	            break;
	        case ACT_ACTION_DOCK_TOP:
	            DockTop();
	            break;
	        case ACT_ACTION_DOCK_BOTTOM:
	            DockBottom();
	            break;
	        case ACT_ACTION_SHOWIMAGE:
	            ShowImage();
	            break;
	        case ACT_ACTION_HIDEIMAGE:
	            HideImage();
	            break;
	        case ACT_ACTION_RESETCLICKSTATE:
	            ResetClickState();
	            break;
	        case ACT_ACTION_SETCMDID: //non operational
	            AttachMenuCmd();
	            break;
	    }
    }

    private void SetDimensions( int w, int h)
    {
       // Set dimensions
		if ((ho.getWidth() != w) ||  (ho.getHeight() != h))
		{
	            ho.setWidth(w);//rdPtr->rHo.hoImgWidth = (short)p1;
	            ho.setHeight(h);//rdPtr->rHo.hoImgHeight = (short)p2;
	
	            textSurface.resize(w, h, false);
	    		
				textNeedsRedraw = true;
	            
	            // Update tooltip rectangle
	            //UpdateToolTipRect(rdPtr);
	            ho.redraw();

				
		}
    }
    private void SetPosition( int x, int y)
    {
        if ((ho.getX() != x) ||  (ho.getY() != y))
        {
            ho.setX(x);//rdPtr->rHo.hoX = (short)p1;
            ho.setY(y);//rdPtr->rHo.hoY = (short)p2;

            // Update tooltip position
            //UpdateToolTipRect(rdPtr);

            // Container ? must update coordinates of contained objects
            if ((rData.dwFlags & CRunKcBoxA.FLAG_CONTAINER) != 0 )
            {
                CRun rhPtr = ho.hoAdRunHeader;
                // Get FrameData
                CRunKcBoxACFrameData pData = (CRunKcBoxACFrameData)rhPtr.getStorage(ho.hoIdentifier);
                if (pData != null)
                {
                    pData.UpdateContainedPos();// = new CFrameData();
                    rhPtr.delStorage(ho.hoIdentifier);
                    rhPtr.addStorage(pData, ho.hoIdentifier);
                }
            }
            ho.redraw();
	}
    }
    private void Enable()
    {
        if ((rData.dwFlags & CRunKcBoxA.FLAG_DISABLED ) != 0)
	{
        	textNeedsRedraw = true;
        	
            rData.dwFlags &= ~CRunKcBoxA.FLAG_DISABLED;
            ho.redraw();
	}

//	// Enable menu command
//	if ( rdPtr->nCommandID != 0 )
//	{
//		fprh rhPtr = rdPtr->rHo.hoAdRunHeader;
//		HMENU hMenu = ::GetMenu(rhPtr->rhHMainWin);
//		if ( hMenu != NULL )
//			EnableMenuItem(hMenu, rdPtr->nCommandID, MF_BYCOMMAND|MF_ENABLED);
//	}
    }
    private void Disable()
    {
        if ((rData.dwFlags & CRunKcBoxA.FLAG_DISABLED ) == 0)
	{
        	textNeedsRedraw = true;
        	
            rData.dwFlags |= CRunKcBoxA.FLAG_DISABLED;
            ho.redraw();
	}

//	// Enable menu command
//	if ( rdPtr->nCommandID != 0 )
//	{
//		fprh rhPtr = rdPtr->rHo.hoAdRunHeader;
//		HMENU hMenu = ::GetMenu(rhPtr->rhHMainWin);
//		if ( hMenu != NULL )
//			EnableMenuItem(hMenu, rdPtr->nCommandID, MF_BYCOMMAND|MF_ENABLED);
//	}
    }
    private void Check()
    {
        if ((rData.dwFlags & CRunKcBoxA.FLAG_CHECKED ) == 0)
	{
        	textNeedsRedraw = true;
        	
            rData.dwFlags |= CRunKcBoxA.FLAG_CHECKED;
            ho.redraw();
	}

//	// Enable menu command
//	if ( rdPtr->nCommandID != 0 )
//	{
//		fprh rhPtr = rdPtr->rHo.hoAdRunHeader;
//		HMENU hMenu = ::GetMenu(rhPtr->rhHMainWin);
//		if ( hMenu != NULL )
//			EnableMenuItem(hMenu, rdPtr->nCommandID, MF_BYCOMMAND|MF_ENABLED);
//	}
    }
    private void Uncheck()
    {
        if ((rData.dwFlags & CRunKcBoxA.FLAG_CHECKED ) != 0)
	{
        	textNeedsRedraw = true;
        	
            rData.dwFlags &= ~CRunKcBoxA.FLAG_CHECKED;
            ho.redraw();
	}

//	// Enable menu command
//	if ( rdPtr->nCommandID != 0 )
//	{
//		fprh rhPtr = rdPtr->rHo.hoAdRunHeader;
//		HMENU hMenu = ::GetMenu(rhPtr->rhHMainWin);
//		if ( hMenu != NULL )
//			EnableMenuItem(hMenu, rdPtr->nCommandID, MF_BYCOMMAND|MF_ENABLED);
//	}
    }
    private void SetFillColor_None()
    {
        if (rData.fillColor != CRunKcBoxA.COLOR_NONE )
	{
            rData.fillColor = CRunKcBoxA.COLOR_NONE;
            ho.redraw();
	}
    }
    private void SetFillColor_3DDKSHADOW()
    {
        if (rData.fillColor != 21)
	{
            rData.fillColor = 21;
            ho.redraw();
	}
    }
    private void SetFillColor_3DFACE()
    {
        if (rData.fillColor != 15)
	{
            rData.fillColor = 15;
            ho.redraw();
	}
    }
    private void SetFillColor_3DHIGHLIGHT()
    {
        if (rData.fillColor != 20)
	{
            rData.fillColor = 20;
            ho.redraw();
	}
    }
    private void SetFillColor_3DLIGHT()
    {
        if (rData.fillColor != 22)
	{
            rData.fillColor = 22;
            ho.redraw();
	}
    }
    private void SetFillColor_3DSHADOW()
    {
        if (rData.fillColor != 16)
	{
            rData.fillColor = 16;
            ho.redraw();
	}
    }
    private void SetFillColor_ACTIVECAPTION()
    {
        if (rData.fillColor != 2)
	{
            rData.fillColor = 2;
            ho.redraw();
	}
    }
    private void SetFillColor_APPWORKSPACE()
    {
        if (rData.fillColor != 12)
	{
            rData.fillColor = 12;
            ho.redraw();
	}
    }
    private void SetFillColor_DESKTOP()
    {
        if (rData.fillColor != 1)
	{
            rData.fillColor = 1;
            ho.redraw();
	}
    }
    private void SetFillColor_HIGHLIGHT()
    {
        if (rData.fillColor != 13)
	{
            rData.fillColor = 13;
            ho.redraw();
	}
    }
    private void SetFillColor_INACTIVECAPTION()
    {
        if (rData.fillColor != 3)
	{
            rData.fillColor = 3;
            ho.redraw();
	}
    }
    private void SetFillColor_INFOBK()
    {
        if (rData.fillColor != 24)
	{
            rData.fillColor = 24;
            ho.redraw();
	}
    }
    private void SetFillColor_MENU()
    {
        if (rData.fillColor != 4)
	{
            rData.fillColor = 4;
            ho.redraw();
	}
    }
    private void SetFillColor_SCROLLBAR()
    {
        if (rData.fillColor != 0)
	{
            rData.fillColor = 0;
            ho.redraw();
	}
    }
    private void SetFillColor_WINDOW()
    {
        if (rData.fillColor != 5)
	{
            rData.fillColor = 5;
            ho.redraw();
	}
    }
    private void SetFillColor_WINDOWFRAME()
    {
        if (rData.fillColor != 6)
	{
            rData.fillColor = 6;
            ho.redraw();
	}
    }
    private void SetFillColor_Other( int c)
    {
        if (( c & PARAMFLAG_SYSTEMCOLOR ) != 0)
        {
            c &= 0xFFFF;
        }
	else
        {
            c |= CRunKcBoxA.COLORFLAG_RGB;
        }
        if (rData.fillColor != c)
	{
            rData.fillColor = c;
            ho.redraw();
	}
    }
    
    private void SetB1Color_None()
    {
        if (rData.borderColor1 != CRunKcBoxA.COLOR_NONE )
	{
            rData.borderColor1 = CRunKcBoxA.COLOR_NONE;
            ho.redraw();
	}
    }
    private void SetB1Color_3DDKSHADOW()
    {
        if (rData.borderColor1 != 21)
	{
            rData.borderColor1 = 21;
            ho.redraw();
	}
    }
    private void SetB1Color_3DFACE()
    {
        if (rData.borderColor1 != 15)
	{
            rData.borderColor1 = 15;
            ho.redraw();
	}
    }
    private void SetB1Color_3DHIGHLIGHT()
    {
        if (rData.borderColor1 != 20)
	{
            rData.borderColor1 = 20;
            ho.redraw();
	}
    }
    private void SetB1Color_3DLIGHT()
    {
        if (rData.borderColor1 != 22)
	{
            rData.borderColor1 = 22;
            ho.redraw();
	}
    }
    private void SetB1Color_3DSHADOW()
    {
        if (rData.borderColor1 != 16)
	{
            rData.borderColor1 = 16;
            ho.redraw();
	}
    }
    private void SetB1Color_ACTIVEBORDER()
    {
        if (rData.borderColor1 != 10)
	{
            rData.borderColor1 = 10;
            ho.redraw();
	}
    }
    private void SetB1Color_INACTIVEBORDER()
    {
        if (rData.borderColor1 != 11)
	{
            rData.borderColor1 = 11;
            ho.redraw();
	}
    }
    private void SetB1Color_WINDOWFRAME()
    {
        if (rData.borderColor1 != 6)
	{
            rData.borderColor1 = 6;
            ho.redraw();
	}
    }
    private void SetB1Color_Other( int c)
    {
        if (( c & PARAMFLAG_SYSTEMCOLOR ) != 0)
        {
            c &= 0xFFFF;
        }
	else
        {
            c |= CRunKcBoxA.COLORFLAG_RGB;
        }
        if (rData.borderColor1 != c)
	{
            rData.borderColor1 = c;
            ho.redraw();
	}
    }
    
    private void SetB2Color_None()
    {
        if (rData.borderColor2 != CRunKcBoxA.COLOR_NONE )
	{
            rData.borderColor2 = CRunKcBoxA.COLOR_NONE;
            ho.redraw();
	}
    }
    private void SetB2Color_3DDKSHADOW()
    {
        if (rData.borderColor2 != 21)
	{
            rData.borderColor2 = 21;
            ho.redraw();
	}
    }
    private void SetB2Color_3DFACE()
    {
        if (rData.borderColor2 != 15)
	{
            rData.borderColor2 = 15;
            ho.redraw();
	}
    }
    private void SetB2Color_3DHIGHLIGHT()
    {
        if (rData.borderColor2 != 20)
	{
            rData.borderColor2 = 20;
            ho.redraw();
	}
    }
    private void SetB2Color_3DLIGHT()
    {
        if (rData.borderColor2 != 22)
	{
            rData.borderColor2 = 22;
            ho.redraw();
	}
    }
    private void SetB2Color_3DSHADOW()
    {
        if (rData.borderColor2 != 16)
	{
            rData.borderColor2 = 16;
            ho.redraw();
	}
    }
    private void SetB2Color_ACTIVEBORDER()
    {
        if (rData.borderColor2 != 10)
	{
            rData.borderColor2 = 10;
            ho.redraw();
	}
    }
    private void SetB2Color_INACTIVEBORDER()
    {
        if (rData.borderColor2 != 11)
	{
            rData.borderColor2 = 11;
            ho.redraw();
	}
    }
    private void SetB2Color_WINDOWFRAME()
    {
        if (rData.borderColor2 != 6)
	{
            rData.borderColor2 = 6;
            ho.redraw();
	}
    }
    private void SetB2Color_Other( int c)
    {
        if (( c & PARAMFLAG_SYSTEMCOLOR ) != 0)
        {
            c &= 0xFFFF;
        }
	else
        {
            c |= CRunKcBoxA.COLORFLAG_RGB;
        }
        if (rData.borderColor2 != c)
	{
            rData.borderColor2 = c;
            ho.redraw();
	}
    }
    
    private void SetTxtColor_None()
    {
        if (rData.textColor != CRunKcBoxA.COLOR_NONE )
	{
        	textNeedsRedraw = true;
            rData.textColor = CRunKcBoxA.COLOR_NONE;
            ho.redraw();
	}
    }
    private void SetTxtColor_3DHIGHLIGHT()
    {
        if (rData.textColor != 20 )
	{
        	textNeedsRedraw = true;
            rData.textColor = 20;
            ho.redraw();
	}
    }
    private void SetTxtColor_3DSHADOW()
    {
        if (rData.textColor != 16)
	{
        	textNeedsRedraw = true;
            rData.textColor = 16;
            ho.redraw();
	}
    }
    private void SetTxtColor_BTNTEXT()
    {
        if (rData.textColor != 18)
	{
        	textNeedsRedraw = true;
            rData.textColor = 18;
            ho.redraw();
	}
    }
    private void SetTxtColor_CAPTIONTEXT()
    {
        if (rData.textColor != 9)
	{
        	textNeedsRedraw = true;
            rData.textColor = 9;
            ho.redraw();
	}
    }
    private void SetTxtColor_GRAYTEXT()
    {
        if (rData.textColor != 17)
	{
        	textNeedsRedraw = true;
            rData.textColor = 17;
            ho.redraw();
	}
    }
    private void SetTxtColor_HIGHLIGHTTEXT()
    {
        if (rData.textColor != 14)
	{
        	textNeedsRedraw = true;
            rData.textColor = 14;
            ho.redraw();
	}
    }
    private void SetTxtColor_INACTIVECAPTIONTEXT()
    {
        if (rData.textColor != 19)
	{
        	textNeedsRedraw = true;
            rData.textColor = 19;
            ho.redraw();
	}
    }
    private void SetTxtColor_INFOTEXT()
    {
        if (rData.textColor != 23)
	{
        	textNeedsRedraw = true;
            rData.textColor = 23;
            ho.redraw();
	}
    }
    private void SetTxtColor_MENUTEXT()
    {
        if (rData.textColor != 7)
	{
        	textNeedsRedraw = true;
            rData.textColor = 7;
            ho.redraw();
	}
    }
    private void SetTxtColor_WINDOWTEXT()
    {
        if (rData.textColor != 8)
	{
        	textNeedsRedraw = true;
            rData.textColor = 8;
            ho.redraw();
	}
    }
    private void SetTxtColor_Other( int c)
    {
        if (( c & PARAMFLAG_SYSTEMCOLOR ) != 0)
        {
            c &= 0xFFFF;
        }
	else
        {
            c |= CRunKcBoxA.COLORFLAG_RGB;
        }
        if (rData.textColor != c)
	{
        	textNeedsRedraw = true;
            rData.textColor = c;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_None()
    {
        if (rData1.dwUnderlinedColor != CRunKcBoxA.COLOR_NONE )
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = CRunKcBoxA.COLOR_NONE;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_3DHIGHLIGHT()
    {
        if (rData1.dwUnderlinedColor != 20 )
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 20;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_3DSHADOW()
    {
        if (rData1.dwUnderlinedColor != 16)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 16;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_BTNTEXT()
    {
        if (rData1.dwUnderlinedColor != 18)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 18;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_CAPTIONTEXT()
    {
        if (rData1.dwUnderlinedColor != 9)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 9;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_GRAYTEXT()
    {
        if (rData1.dwUnderlinedColor != 17)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 17;
            ho.redraw();
	}
    }
    
    private void SetHyperlinkColor_HIGHLIGHTTEXT()
    {
        if (rData1.dwUnderlinedColor != 14)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 14;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_INACTIVECAPTIONTEXT()
    {
        if (rData1.dwUnderlinedColor != 19)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 19;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_INFOTEXT()
    {
        if (rData1.dwUnderlinedColor != 23)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 23;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_MENUTEXT()
    {
        if (rData1.dwUnderlinedColor != 7)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 7;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_WINDOWTEXT()
    {
        if (rData1.dwUnderlinedColor != 8)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = 8;
            ho.redraw();
	}
    }
    private void SetHyperlinkColor_Other( int c)
    {
        if (( c & PARAMFLAG_SYSTEMCOLOR ) != 0)
        {
            c &= 0xFFFF;
        }
	else
        {
            c |= CRunKcBoxA.COLORFLAG_RGB;
        }
        if (rData1.dwUnderlinedColor != c)
	{
        	textNeedsRedraw = true;
            rData1.dwUnderlinedColor = c;
            ho.redraw();
	}
    }
    
    private void SetText( String s)
    {
    	if(s.equals(pText))
            return;

        textNeedsRedraw = true;

        pText = s;
        ho.redraw();
    }
    private void SetToolTipText( String s)
    {
        pToolTip = s;
    }
    private void Undock()
    {
        if ((dwRtFlags & CRunKcBoxA.DOCK_FLAGS )!= 0)
        {
            dwRtFlags &= ~CRunKcBoxA.DOCK_FLAGS;
        }
    }
    private void DockLeft()
    {
       if ((dwRtFlags & CRunKcBoxA.DOCK_LEFT )== 0)
	{
            dwRtFlags |= CRunKcBoxA.DOCK_LEFT;
            ho.reHandle();
	}
    }
    private void DockRight()
    {
       if ((dwRtFlags & CRunKcBoxA.DOCK_RIGHT )== 0)
	{
            dwRtFlags |= CRunKcBoxA.DOCK_RIGHT;
            ho.reHandle();
	}
    }
    private void DockTop()
    {
       if ((dwRtFlags & CRunKcBoxA.DOCK_TOP)== 0)
	{
            dwRtFlags |= CRunKcBoxA.DOCK_TOP;
            ho.reHandle();
	}
    }
    private void DockBottom()
    {
       if ((dwRtFlags & CRunKcBoxA.DOCK_BOTTOM)== 0)
	{
            dwRtFlags |= CRunKcBoxA.DOCK_BOTTOM;
            ho.reHandle();
	}
    }
    private void ShowImage()
    {
	if ((rData.dwFlags & CRunKcBoxA.FLAG_HIDEIMAGE ) != 0)
	{
            rData.dwFlags &= ~CRunKcBoxA.FLAG_HIDEIMAGE;
            ho.redraw();
	}
    }
    private void HideImage()
    {
	if ((rData.dwFlags & CRunKcBoxA.FLAG_HIDEIMAGE ) == 0)
	{
            rData.dwFlags |= CRunKcBoxA.FLAG_HIDEIMAGE;
            ho.redraw();
	}
    }
    private void ResetClickState()
    {
	rClickCount = -1;
    }
    private void AttachMenuCmd()
    {
    }
    
    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num){
	        case EXP_COLOR_BACKGROUND:
	            return ExpColorBackground();
	        case EXP_COLOR_BORDER1:
	            return ExpColorBorder1();
	        case EXP_COLOR_BORDER2:
	            return ExpColorBorder2();
	        case EXP_COLOR_TEXT:
	            return ExpColorText();
	        case EXP_COLOR_HYPERLINK:
	            return ExpColorHyperlink();
	        case EXP_COLOR_3DDKSHADOW:
	            return ExpColor_3DDKSHADOW();
	        case EXP_COLOR_3DFACE:
	            return ExpColor_3DFACE();
	        case EXP_COLOR_3DHILIGHT:
	            return ExpColor_3DHILIGHT();
	        case EXP_COLOR_3DLIGHT:
	            return ExpColor_3DLIGHT();
	        case EXP_COLOR_3DSHADOW:
	            return ExpColor_3DSHADOW();
	        case EXP_COLOR_ACTIVEBORDER:
	            return ExpColor_ACTIVEBORDER();
	        case EXP_COLOR_ACTIVECAPTION:
	            return ExpColor_ACTIVECAPTION();
	        case EXP_COLOR_APPWORKSPACE:
	            return ExpColor_APPWORKSPACE();
	        case EXP_COLOR_DESKTOP:
	            return ExpColor_DESKTOP();
	        case EXP_COLOR_BTNTEXT:
	            return ExpColor_BTNTEXT();
	        case EXP_COLOR_CAPTIONTEXT:
	            return ExpColor_CAPTIONTEXT();
	        case EXP_COLOR_GRAYTEXT:
	            return ExpColor_GRAYTEXT();
	        case EXP_COLOR_HIGHLIGHT:
	            return ExpColor_HIGHLIGHT();
	        case EXP_COLOR_HIGHLIGHTTEXT:
	            return ExpColor_HIGHLIGHTTEXT();
	        case EXP_COLOR_INACTIVEBORDER:
	            return ExpColor_INACTIVEBORDER();
	        case EXP_COLOR_INACTIVECAPTION:
	            return ExpColor_INACTIVECAPTION();
	        case EXP_COLOR_INACTIVECAPTIONTEXT:
	            return ExpColor_INACTIVECAPTIONTEXT();
	        case EXP_COLOR_INFOBK:
	            return ExpColor_INFOBK();
	        case EXP_COLOR_INFOTEXT:
	            return ExpColor_INFOTEXT();
	        case EXP_COLOR_MENU:
	            return ExpColor_MENU();
	        case EXP_COLOR_MENUTEXT:
	            return ExpColor_MENUTEXT();
	        case EXP_COLOR_SCROLLBAR:
	            return ExpColor_SCROLLBAR();
	        case EXP_COLOR_WINDOW:
	            return ExpColor_WINDOW();
	        case EXP_COLOR_WINDOWFRAME:
	            return ExpColor_WINDOWFRAME();
	        case EXP_COLOR_WINDOWTEXT:
	            return ExpColor_WINDOWTEXT();
	        case EXP_GETTEXT:
	            return ExpGetText();
	        case EXP_GETTOOLTIPTEXT:
	            return ExpGetToolTipText();
	        case EXP_GETWIDTH:
	            return ExpGetWidth();
	        case EXP_GETHEIGHT:
	            return ExpGetHeight();
	        case EXP_GETX:
	            return ExpGetX();
	        case EXP_GETY:
	            return ExpGetY();
	        case EXP_SYSTORGB:
	            return ExpSysToRGB();
	    }
	    return new CValue();
    }
    private CValue ExpColorBackground()
    {
        long clr = rData.fillColor;
        if ((clr &  COLORFLAG_RGB )!= 0)
        {
            clr &= 0xFFFFFF;
        }
        else
        {
            clr |= PARAMFLAG_SYSTEMCOLOR;
        }
        return new CValue((int)clr);
    }
    private CValue ExpColorBorder1()
    {
        long clr = rData.borderColor1;
        if ((clr &  COLORFLAG_RGB )!= 0)
        {
            clr &= 0xFFFFFF;
        }
        else
        {
            clr |= PARAMFLAG_SYSTEMCOLOR;
        }
        return new CValue((int)clr);
    }
    private CValue ExpColorBorder2()
    {
        long clr = rData.borderColor2;
        if ((clr &  COLORFLAG_RGB )!= 0)
        {
            clr &= 0xFFFFFF;
        }
        else
        {
            clr |= PARAMFLAG_SYSTEMCOLOR;
        }
        return new CValue((int)clr);
    }
    private CValue ExpColorText()
    {
        long clr = rData.textColor;
        if ((clr &  COLORFLAG_RGB )!= 0)
        {
            clr &= 0xFFFFFF;
        }
        else
        {
            clr |= PARAMFLAG_SYSTEMCOLOR;
        }
        return new CValue((int)clr);
    }
    private CValue ExpColorHyperlink()
    {
        long clr = rData1.dwUnderlinedColor;
        if ((clr &  COLORFLAG_RGB )!= 0)
        {
            clr &= 0xFFFFFF;
        }
        else
        {
            clr |= PARAMFLAG_SYSTEMCOLOR;
        }
        return new CValue((int)clr);
    }
    private CValue ExpColor_3DDKSHADOW()
    {
        return new CValue(21 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_3DFACE()
    {
        return new CValue(15 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_3DHILIGHT()
    {
        return new CValue(20 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_3DLIGHT()
    {
        return new CValue(22 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_3DSHADOW()
    {
        return new CValue(16 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_ACTIVEBORDER()
    {
        return new CValue(10 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_ACTIVECAPTION()
    {
        return new CValue(2 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_APPWORKSPACE()
    {
        return new CValue(12 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_DESKTOP()
    {
        return new CValue(1 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_BTNTEXT()
    {
        return new CValue(18 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_CAPTIONTEXT()
    {
        return new CValue(9 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_GRAYTEXT()
    {
        return new CValue(17 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_HIGHLIGHT()
    {
        return new CValue(13 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_HIGHLIGHTTEXT()
    {
        return new CValue(14 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_INACTIVEBORDER()
    {
        return new CValue(11 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_INACTIVECAPTION()
    {
        return new CValue(3 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_INACTIVECAPTIONTEXT()
    {
        return new CValue(19 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_INFOBK()
    {
        return new CValue(24 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_INFOTEXT()
    {
        return new CValue(23 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_MENU()
    {
        return new CValue(4 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_MENUTEXT()
    {
        return new CValue(7 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_SCROLLBAR()
    {
        return new CValue(0 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_WINDOW()
    {
        return new CValue(5 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_WINDOWFRAME()
    {
        return new CValue(6 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpColor_WINDOWTEXT()
    {
        return new CValue(8 | CRunKcBoxA.PARAMFLAG_SYSTEMCOLOR);
    }
    private CValue ExpGetText()
    {
        return new CValue(pText);
    }
    private CValue ExpGetToolTipText()
    {
        return new CValue(pToolTip);
    }
    private CValue ExpGetWidth()
    {
        return new CValue(ho.getWidth());
    }
    private CValue ExpGetHeight()
    {
        return new CValue(ho.getHeight());
    }
    private CValue ExpGetX()
    {
        return new CValue(ho.getX());
    }
    private CValue ExpGetY()
    {
        return new CValue(ho.getY());
    }
    private CValue ExpSysToRGB()
    {
	int rgb;
	long paramColor = ho.getExpParam().getInt();//DWORD)CNC_GetFirstExpressionParameter(rdPtr, param1, TYPE_INT);

	if ((paramColor & PARAMFLAG_SYSTEMCOLOR )!=0)
        {
            int sc = (int)(paramColor & 0xFFFF);
            rgb = myGetSysColor(sc);
        }
	else
        {
            rgb = ((int)paramColor & 0xFFFFFF);
            rgb = fromC(rgb);
        }
        //int ii = rgb.getRGB();
        int r = CServices.getRValueJava(rgb);
        int g = CServices.getBValueJava(rgb);
        int b = CServices.getGValueJava(rgb);
        return new CValue(b*65536 + g*256 + r);
    }
    
    public int measureText (String s, short flags, CRect rect, CFontInfo font, int newWidth)
    {
    	TextPaint textPaint = new TextPaint();
        textPaint.setTypeface(font.createFont());
        textPaint.setTextSize(font.lfHeight);
        if(font.lfUnderline != 0)
        	textPaint.setUnderlineText(true);
        else
           	textPaint.setUnderlineText(false);

		int lWidth = newWidth;
		if ( newWidth == 0 )
			lWidth = rect.right;

        StaticLayout layout = new StaticLayout
                (s, textPaint, lWidth, CServices.textAlignment(flags, CServices.containsRtlChars(s)), 1.0f, 0.0f, false);

        int height = layout.getHeight ();
        if ((rect.top + height) <= rect.bottom)
            height = rect.bottom - rect.top;

        rect.bottom = rect.top + height;
        rect.right = rect.left + lWidth;
        
        return layout.getLineCount();
    }

}
