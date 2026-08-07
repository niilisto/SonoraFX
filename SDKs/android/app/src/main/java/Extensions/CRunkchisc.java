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
// CRunkchisc: high score object
//
//greyhill
//----------------------------------------------------------------------------------

package Extensions;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import Actions.CActExtension;
import Application.CRunApp;
import Conditions.CCndExtension;
import Expressions.CValue;
import OpenGL.CTextSurface;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import RunLoop.CRun;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CINI;
import Services.CRect;
import Services.CServices;
import Sprites.CMask;
import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.EditText;

public class CRunkchisc extends CRunExtension
{
    public static final int SCR_HIDEONSTART = 0x0001;
    public static final int SCR_NAMEFIRST = 0x0002;
    public static final int SCR_CHECKONSTART = 0x0004;
    public static final int SCR_DONTDISPLAYSCORES = 0x0008;
    public static final int SCR_FULLPATH = 0x0010;
//typedef struct tagEDATA_V1
//{
//	extHeader		eHeader;
//
//	short			NbScores;
//	short			NameSize;
//	short			Flags;
//	LOGFONT16		Logfont;
//	COLORREF		Colorref;
//	char			Style[40];
//	char			Names[20][41];
//	ulong			Scores[20];
//	short			sSizeX;
//	short			sSizeY;
//	char			einiName[_MAX_PATH];
//	long			Secu[2];
//
//} editData;
//typedef struct tagRDATA
//{
//	headerObject 	rHo;
//	rCom			roc;
//	rSpr			rsp;
//
//	short			sVisible;
//	short			NbScores;
//	short			NameSize;
//	short			Flags;
//	LOGFONT			Logfont;
//	COLORREF		Colorref;
//	char			Names[20][41];
//	ulong			Scores[20];
//	short			nFont;
//	char			IniName[_MAX_PATH];
//	char			RealIniName[_MAX_PATH];
//
//} runData;
    boolean sVisible;
    short NbScores;
    short NameSize;
    short Flags;
    short iniFlags=0;
    CFontInfo Logfont;
    int Colorref;
    String Names[] = new String[20];
    int Scores[] = new int[20];
    String originalNames[] = new String[20]; //used for reset action
    int originalScores[] = new int[20];
    int scrPlayer[] = new int[4]; //used for high score condition
    String IniName;
    CINI realIni;
    kchiscActs actions;
    kchiscCnds conditions;
    kchiscExpr expressions;
    short started = 0;
    CTextSurface textSurface;

	private static int PERMISSIONS_HISC_REQUEST = 12377888;
	private HashMap<String, String> permissionsApi23;
	private boolean enabled_perms;
    private boolean api23_started;

    public CRunkchisc()
    {
    }

    @Override
	public int getNumberOfConditions()
    {
        return 2;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        actions = new kchiscActs(this);
        conditions = new kchiscCnds(this);
        expressions = new kchiscExpr(this);

        ho.setX(cob.cobX);
        ho.setY(cob.cobY);

        this.NbScores = file.readShort();
        this.NameSize = file.readShort();
        this.Flags = file.readShort();
        if (ho.hoAdRunHeader.rhApp.bUnicode == false)
        {
            this.Logfont = file.readLogFont16();
        }
        else
        {
            this.Logfont = file.readLogFont();
        }
        this.Colorref = file.readColor();
        file.readString(40);
        for (int i = 0; i < 20; i++)
        {
            this.originalNames[i] = this.Names[i] = file.readString(41);
        }
        for (int i = 0; i < 20; i++)
        {
            this.originalScores[i] = this.Scores[i] = file.readInt();
        }
        ho.setWidth(file.readShort());
        ho.setHeight(file.readShort());

		textSurface = new CTextSurface(ho.getApplication(),ho.hoImgWidth, ho.hoImgHeight);

        if ((this.Flags & SCR_HIDEONSTART) == 0)
        {
            this.sVisible = true;
        }
        this.IniName = file.readString(260);
        
        if(this.IniName.length()==0)        
        	this.IniName = "Hi_Score.ini";
        
        this.iniFlags = (short) (((this.Flags & 0x0020) != 0) ? 8 : 0);
        
        //Api23 Permissions
        
        enabled_perms = false;
        
		if(MMFRuntime.deviceApi > 22) {
			permissionsApi23 = new HashMap<String, String>();
			permissionsApi23.put(Manifest.permission.WRITE_EXTERNAL_STORAGE, "Write Storage");
			permissionsApi23.put(Manifest.permission.READ_EXTERNAL_STORAGE, "Read Storage");
			if(!MMFRuntime.inst.verifyOkPermissionsApi23(permissionsApi23))
				MMFRuntime.inst.pushForPermissions(permissionsApi23, PERMISSIONS_HISC_REQUEST);
			else
				enabled_perms = true;
		}
		else
			enabled_perms = true;

        if(enabled_perms) {
        	hisc_filler();
        }
        return true;
    }

    private void hisc_filler () {
        this.realIni = new CINI (ho, this.IniName, this.iniFlags);
        
        if(this.realIni.getItemValue("_saved") == 1)
        {
	        for (int a = 0; a < 20; a++)
	        {
	            String name = this.realIni.getItemString ("N" + Integer.valueOf(a).toString());
	
	            if (name.length() > 0)
	                this.Names[a] = name;

	            this.Scores[a] = this.realIni.getItemValue ("S" + Integer.valueOf(a).toString());
	        }
        }
        else
        {
        	saveScores();
        }

        render ();

    }
    
    @Override
    public void destroyRunObject(boolean bFast)
    {
    	if(this.realIni != null)
    		this.realIni.close();
    	
    	this.realIni = null;
    }

    public void saveScores()
    {
    	realIni.setItemValue("_saved", 1);
    	
        for (int a = 0; a < this.NbScores; a++)
        {
            realIni.setItemString ("N" + Integer.valueOf(a).toString(), this.Names[a]);
            realIni.setItemValue ("S" + Integer.valueOf(a).toString(), this.Scores[a]);
        }
        realIni.update();
    }
    
	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults, List<Integer> permissionsReturned) {
		if(permissionsReturned.contains(PERMISSIONS_HISC_REQUEST)) {
			enabled_perms = verifyResponseApi23(permissions, permissionsApi23);
			if(enabled_perms)
				hisc_filler();
		}
		else
			enabled_perms = false;
	}

    @Override
    public int handleRunObject()
    {
		if(MMFRuntime.inst != null && !api23_started) {
			api23_started = true;
			MMFRuntime.inst.askForPermissionsApi23();		
		}

		if ((this.Flags & SCR_CHECKONSTART) != 0 && this.started == 0)
        {
            short a, b;
            short players[] = new short[4];
            boolean TriOk;
            CRun rhPtr = ho.hoAdRunHeader;
            long score1, score2;

            // Init player order
            for (a = 0; a < 4; a++)
            {
                players[a] = a;
            }
            // Sort player order (bigger score asked first)
            do
            {
                TriOk = true;
                for (a = 1; a < 4; a++)
                {
                    score1 = rhPtr.rhApp.getScores()[players[a]];
                    score2 = rhPtr.rhApp.getScores()[players[a - 1]];
                    if (score1 > score2)
                    {
                        b = players[a - 1];
                        players[a - 1] = players[a];
                        players[a] = b;
                        TriOk = false;
                    }
                }
            } while (false == TriOk);
            this.started++;

            checkScores (players, 0);
        }

        if(ho.roc.rcChanged)
        {
            ho.roc.rcChanged = false;
            render ();
        }

        return 0;
    }

    void checkScores (final short [] players, int index)
    {
        final int next = index + 1;

        if (next == 4)
            return;

        if (players[index] <= rh.rhNPlayers)
        {
            actions.CheckScore (players [index], new Runnable ()
            {
                @Override
				public void run ()
                {
                    checkScores (players, next);
                }
            });
        }
        else
        {
            checkScores (players, next);
        }
    }

    void render()
    {
        int lineHeight = ho.hoImgHeight / this.NbScores + 4;

        textSurface.manualClear(0);

        String[] names = new String[20];
        for (int i = 0; i < 20; i++)
        {
            names[i] = this.Names[i];
            if (names[i].length() > this.NameSize)
            {
                names[i] = names[i].substring(0, this.NameSize);
            }
        }

        CRect rc = new CRect();

        rc.left = 0;
        rc.right = ho.hoImgWidth;
        rc.top = 0;
        rc.bottom = ho.hoImgHeight;

        for (int a = 0; a < this.NbScores; a++)
        {
            if ((this.Flags & SCR_NAMEFIRST) != 0)
            {
                textSurface.manualDrawText(names[a],
                        (short) (CServices.DT_LEFT | CServices.DT_SINGLELINE),
                        rc, this.Colorref, this.Logfont, false);

                if ((this.Flags & SCR_DONTDISPLAYSCORES) == 0)
                {
                    textSurface.manualDrawText(Integer.toString(Scores[a]),
                            (short) (CServices.DT_RIGHT | CServices.DT_SINGLELINE),
                            rc, this.Colorref, this.Logfont, false);
                }
            }
            else
            {
                if ((this.Flags & SCR_DONTDISPLAYSCORES) == 0)
                {
                    textSurface.manualDrawText(Integer.toString(Scores[a]),
                            (short) (CServices.DT_LEFT | CServices.DT_SINGLELINE),
                            rc, this.Colorref, this.Logfont, false);
                }

                textSurface.manualDrawText(names[a],
                        (short) (CServices.DT_RIGHT | CServices.DT_SINGLELINE),
                        rc, this.Colorref, this.Logfont, false);
            }

            rc.top += lineHeight;
        }

        textSurface.updateTexture();
    }

    @Override
    public void displayRunObject()
    {
        if (this.sVisible)
        {
            textSurface.draw(ho.hoX - rh.rhWindowX, ho.hoY - rh.rhWindowY, 0, 0);
        }
    }

    abstract public static class InputDoneCallback
    {
        abstract public void run (String input);
    };

    public void getInput (String title, String message, final InputDoneCallback callback)
    {
        ho.pause();

        AlertDialog.Builder alert = new AlertDialog.Builder(ho.getControlsContext());

        alert.setTitle(title);
        alert.setMessage(message);
        alert.setIcon(android.R.drawable.ic_dialog_info);

        final EditText input = new EditText(ho.getControlsContext());

        alert.setView(input);

        alert.setPositiveButton("Submit", new DialogInterface.OnClickListener()
        {
            @Override
			public void onClick(DialogInterface dialog, int whichButton)
            {
                ho.resume ();

                callback.run (input.getText().toString());
            }
        });

        alert.setOnCancelListener(new DialogInterface.OnCancelListener()
        {
            @Override
			public void onCancel (DialogInterface dialog)
            {
                ho.resume ();
            }
        });

        alert.show();
    }

    @Override
	public void pauseRunObject()
    {
    	if(this.realIni != null)
    		this.realIni.update();
    }

    @Override
	public void continueRunObject()
    {
    }

    public boolean saveRunObject(DataOutputStream stream)
    {
        try
        {
            stream.writeInt(1); // version 1
            stream.writeBoolean(this.sVisible);
            stream.writeShort(this.NbScores);
            stream.writeShort(this.NameSize);
            stream.writeShort(this.Flags);
            this.Logfont.write(stream);
            stream.writeInt(this.Colorref);
            for (int i = 0; i < 20; i++)
            {
                stream.writeUTF(this.Names[i]);
                stream.writeInt(this.Scores[i]);
                stream.writeUTF(this.originalNames[i]);
                stream.writeInt(this.originalScores[i]);
            }
            for (int i = 0; i < 4; i++)
            {
                stream.writeInt(this.scrPlayer[i]);
            }
            stream.writeUTF(this.IniName);
            stream.writeShort(this.started);
        }
        catch (IOException e)
        {
            return false;
        }
        return true;
    }

    public boolean loadRunObject(DataInputStream stream)
    {
        try
        {
            int savedVersion = stream.readInt();
            if (savedVersion != 1)
            {
                return false;
            }
            this.sVisible = stream.readBoolean();
            this.NbScores = stream.readShort();
            this.NameSize = stream.readShort();
            this.Flags = stream.readShort();
            this.Logfont.read(stream);
            this.Colorref = stream.readInt();
            for (int i = 0; i < 20; i++)
            {
                this.Names[i] = stream.readUTF();
                this.Scores[i] = stream.readInt();
                this.originalNames[i] = stream.readUTF();
                this.originalScores[i] = stream.readInt();
            }
            for (int i = 0; i < 4; i++)
            {
                this.scrPlayer[i] = stream.readInt();
            }
            this.IniName = stream.readUTF();
            this.started = stream.readShort();
            
            if(this.IniName.length() > 0)
                this.iniFlags = 0x0004;
            
            this.realIni = new CINI(ho, this.IniName, this.iniFlags);
            this.actions = new kchiscActs(this); //necessary?
            this.conditions = new kchiscCnds(this); //necessary?
            this.expressions = new kchiscExpr(this); //necessary?
        }
        catch (IOException e)
        {
            return false;
        }
        return true;
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

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
    {
        return conditions.get(num, cnd);
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
    {
        actions.action(num, act);
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        return expressions.get(num);
    }
}
