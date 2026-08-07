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
// CRunAdvPathMov: advanced path movement object
// fin 6th march 09
//greyhill
//---------------------------------------------------------------------------------

package Extensions;

import java.io.BufferedOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PushbackInputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import Actions.CActExtension;
import Application.CEmbeddedFile;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import Runtime.Log;
import Runtime.MMFRuntime;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunAdvPathMov extends CRunExtension
{  
//typedef struct tagEDATA_V1
//{
//	extHeader		eHeader;
//	short			sx;
//	short			sy;
//	short			swidth;
//	short			sheight;
//	int           speed;
//	int OffsetX,OffsetY;
//	bool ChangeX,
//		ChangeY,
//		ChangeDir,

    //		Autostepping;
//
//
//} EDITDATA;
    static final int CID_ismoving = 0;
    static final int CID_nodesconnected = 1;
    static final int CID_isstopping = 2;
    static final int CID_Hasreachedend = 3;
    static final int CID_touchednewnod = 4;
    
    static final int AID_creatpathnod = 0;
    static final int AID_removepathnod = 1;
    static final int AID_Clearpath = 2;
    static final int AID_Connectnods = 3;
    static final int AID_Addnodjourney = 4;
    static final int AID_Insertnodjourney = 5;
    static final int AID_Removelastnodjourney = 6;
    static final int AID_Deletenodjourney = 7;
    static final int AID_Findjourney = 8;
    static final int AID_LoadPath = 9;
    static final int AID_SavePath = 10;
    static final int AID_MovementStart = 11;
    static final int AID_MovementStop = 12;
    static final int AID_MovementPause = 13;
    static final int AID_Setspeed = 14;
    static final int AID_Setobject = 15;
    static final int AID_setXoffset = 16;
    static final int AID_setYoffset = 17;
    static final int AID_Enableautostep = 18;
    static final int AID_Disableautostep = 19;
    static final int AID_Forcemovexsteps = 20;
    static final int AID_SetNodeX = 21;
    static final int AID_SetNodeY = 22;
    static final int AID_Disconnectnode = 23;
    static final int AID_ClearJourney = 24;
    static final int AID_ChangeX = 25;
    static final int AID_ChangeY = 26;
    static final int AID_ChangeDirection = 27;
    
    static final int EID_Findnode  = 0;
    static final int EID_Numberofnods = 1;
    static final int EID_GetJourneynode              =2;
    static final int EID_Countjourneynode            =3;
    static final int EID_ObjectGetX                  =4;
    static final int EID_ObjectGetY                  =5;
    static final int EID_ObjectGetSpeed              =6;
    static final int EID_NodeDistance                =7;
    static final int EID_NodeX                       =8;
    static final int EID_NodeY                       =9;
    static final int EID_GetCurrentSpeed             =10;
    static final int EID_GetXoffset                  =11;
    static final int EID_GetYoffset                  =12;
    static final int EID_GetAngle                    =13;
    static final int EID_GetDirection                =14;
    static final int EID_Getconnection               =15;
    static final int EID_GetNumberconnections        =16;
    static final int EID_GetNodesSpeed               =17;
    static final int EID_AutochangeX                 =18;
    static final int EID_AutochangeY                 =19;
    static final int EID_AutochangeDirection         =20;
    
    CRunAdvPathMovmyclass mypointer;
    float distance, speed, totaldist;
    boolean ismoving, muststop, enableautostep, ChangeX, ChangeY, ChangeDirection;
    int debug, x, y, xoffset, yoffset, angle;
    CObject myObject;
                
	//private String currentFile;
	//private boolean saving;
	//private String JourneyType;
	//private String JourneyExt;

    public CRunAdvPathMov()
    {
    }
    @Override
	public int getNumberOfConditions()
    {
        return 5;
    }
    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        file.setUnicode(false);
        this.mypointer = new CRunAdvPathMovmyclass();
        ho.hoX = cob.cobX;
        ho.hoY = cob.cobY;
        file.skipBytes(4);
        ho.hoImgWidth = file.readShort();
        ho.hoImgHeight = file.readShort();
        this.speed = file.readInt() / 100.0f;
        this.xoffset = file.readInt();
        this.yoffset = file.readInt();
        this.ChangeX = file.readByte() == 1 ? true : false;
        this.ChangeY = file.readByte() == 1 ? true : false;
        this.ChangeDirection = file.readByte() == 1 ? true : false;
        this.enableautostep = file.readByte() == 1 ? true : false;
        
        return true;
    }
    @Override
	public void destroyRunObject(boolean bFast)
    {
    	if(this.mypointer != null) {
    		this.mypointer.myjourney.clear();
    		this.mypointer.myvector.clear();
    		this.mypointer = null;    		
    	}
    }    
    
    @Override
	public int handleRunObject()
    {
       if (this.mypointer.myjourney.size() == 1){
            //	MessageBox(NULL,"Hi",NULL,NULL);
            //This is so the object is at the first point if its not moving.
            this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(0);
            this.mypointer.theIterator = (CRunAdvPathMovPoints)this.mypointer.myvector.get(this.mypointer.JourneyIterator.Node);
            this.x = this.mypointer.theIterator.X;
            this.y = this.mypointer.theIterator.Y;
            if( this.ChangeX == true ){ this.myObject.hoX = this.x;}
            if( this.ChangeY == true ){ this.myObject.hoY = this.y;}
            this.myObject.roc.rcChanged = true;
        }
        if(this.ismoving == false) {
        	return 0; 
        }
        if(this.enableautostep == false) {
        	return 0;
        }
        this.distance += this.speed;

        int FirstNode = 0;
        int NextNode  = 0;
        boolean connectfound = false;

        while ((this.ismoving == true) && (this.distance >= this.totaldist)){

            //Take away the distance travelled so far :)
            this.mypointer.myjourney.remove(0);

            ////Calculate position ( for when it touches a new node )
            this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(0);
            FirstNode = this.mypointer.JourneyIterator.Node;
            this.mypointer.theIterator = (CRunAdvPathMovPoints)this.mypointer.myvector.get(FirstNode);
            this.x = this.mypointer.theIterator.X + this.xoffset;
            this.y = this.mypointer.theIterator.Y + this.yoffset;

        	
            if(this.ChangeX == true )
            {
            	myObject.hoX = x;
            }
            if(this.ChangeY == true )
            {
            	myObject.hoY = y;
            }

            this.myObject.roc.rcChanged = true;
            ho.generateEvent(CID_touchednewnod, ho.getEventParam());
            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 4, 0);

            if((this.mypointer.myjourney.size()) <= 1
                || (this.muststop ==true)){
                this.ismoving = false;
                this.distance = 0;
                this.muststop = false;
                this.totaldist = 0;
                ho.generateEvent(CID_Hasreachedend, ho.getEventParam());
                //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 3, 0);
            }

            if(this.ismoving == true) {
                this.distance -= this.totaldist;

                //Set the iterator to the first journey step
                this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(0);
                //Now we know what the current point has to be :)
                FirstNode = this.mypointer.JourneyIterator.Node;
                this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(1);
                //Now we what what the next point is going to be :)
                NextNode = this.mypointer.JourneyIterator.Node;

                //now we select the first point
                this.mypointer.theIterator = (CRunAdvPathMovPoints)this.mypointer.myvector.get(FirstNode);
                //Great...now we need to run through all the connections and find the right one
                int iterConn_size = this.mypointer.theIterator.Connections.size();
                for (int i = 0; i < iterConn_size; i++)
                {
                    this.mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect)this.mypointer.theIterator.Connections.get(i);
                    if( this.mypointer.theIterator.ConnectIterator.PointID == NextNode)
                    {
                         this.totaldist = this.mypointer.theIterator.ConnectIterator.Distance;
                         connectfound = true;
                    }
                }
                if(connectfound == false ){
                    this.ismoving = false;
                    this.distance = 0;
                    this.muststop = false;
                    this.totaldist = 0;
                }
            }
        }

        if((this.ismoving == true) && (this.distance != 0))
        {
            ////Get points
            this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(0);
            //Now we know what the current point has to be :)
            FirstNode = this.mypointer.JourneyIterator.Node;
            this.mypointer.JourneyIterator = (CRunAdvPathMovJourney)this.mypointer.myjourney.get(1);
            //Now we want what the next point is going to be :)
            NextNode = this.mypointer.JourneyIterator.Node;

            this.mypointer.theIterator = (CRunAdvPathMovPoints)this.mypointer.myvector.get(FirstNode);
            int x1 = this.mypointer.theIterator.X;
            int y1 = this.mypointer.theIterator.Y;

            this.mypointer.theIterator = (CRunAdvPathMovPoints)this.mypointer.myvector.get(NextNode);
            int x2 = this.mypointer.theIterator.X;
            int y2 = this.mypointer.theIterator.Y;
            int deltax= x2 - x1;
            int deltay= y2 - y1;

            /////Below need to go in main

            if(this.totaldist!= 0){
                float myval = (float)(Math.atan2((deltax+0.0),(deltay+0.0))/3.1415926535897932384626433832795 * 180.0);
                this.angle = (int)(180.0-myval);
            }


///////////////////////////End
            /////Below need to go in main
            if(this.totaldist!=0)
            {
                this.x = (int)(x1 + deltax * (this.distance / this.totaldist )+ this.xoffset);
                this.y = (int)(y1 + deltay * (this.distance / this.totaldist )+ this.yoffset);
                if(this.ChangeX == true )
                {
                	myObject.hoX = x;
                }
                if(this.ChangeY == true )
                {
                	myObject.hoY = y;
                }

                if(this.ChangeDirection == true ){
                    int direction = (this.angle *32+180)/ 360;
                    direction = 8-direction;
                    if ( direction < 0){direction +=32;}
                //	return direction;
                    this.myObject.roc.rcDir = direction;
                }
                this.myObject.roc.rcChanged = true;
            }
        }
        return 0;
    }
        
    public void displayRunObject(Canvas c, Paint p)
    {       
    }
   
    @Override
	public void pauseRunObject()
    {
    }
    @Override
	public void continueRunObject()
    {
    }
    public void saveBackground(Bitmap img)
    {
    }
    public void restoreBackground(Canvas c, Paint p)
    {
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
            case CID_ismoving:
                return ismoving;
            case CID_nodesconnected:
                return nodesconnected(cnd.getParamExpression(rh, 0), cnd.getParamExpression(rh, 1));
            case CID_isstopping:
                return muststop;
            case CID_Hasreachedend:
                return true;
            case CID_touchednewnod:
                return true;
        }
        return false;//won't happen
    }

    private boolean nodesconnected(int param1, int param2)
    {
        param1--;
        param2--;
        if(param1 < 0||param2 < 0){return false;}
        if((param1 >= mypointer.myvector.size())
            || (param2 >= mypointer.myvector.size())) {
        	return false;
        	
        }

        //param1 contains the number inputed by the user
        //param2 contains the number inputed by the user
        mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(param1);
        int Connections_size = mypointer.theIterator.Connections.size();
        for(int i = 0; i < Connections_size; i++)
        {
            mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect)mypointer.theIterator.Connections.get(i);
            if(mypointer.theIterator.ConnectIterator.PointID == param2)
            {
                return true;
            }
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
            case AID_creatpathnod:
                creatpathnod(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
                break;
            case AID_removepathnod:
                removepathnod(act.getParamExpression(rh, 0));
                break;
            case AID_Clearpath:
                Clearpath(act.getParamExpression(rh, 0));
                break;
            case AID_Connectnods:
                Connectnods(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1), act.getParamExpDouble(rh, 2));
                break;
            case AID_Addnodjourney:
                Addnodjourney(act.getParamExpression(rh, 0));
                break;
            case AID_Insertnodjourney:
                Insertnodjourney(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
                break;
            case AID_Removelastnodjourney:
                mypointer.myjourney.remove(mypointer.myjourney.size() - 1);
                break;
            case AID_Deletenodjourney:
                Deletenodjourney(act.getParamExpression(rh, 0));
                break;
            case AID_Findjourney:
            	Findjourney(act.getParamExpression(rh, 0));
                break;
            case AID_LoadPath:
                LoadPath(act.getParamExpString(rh, 0));
                break;
            case AID_SavePath:
                SavePath(act.getParamExpString(rh, 0));
                break;
            case AID_MovementStart:
                MovementStart();
                break;
            case AID_MovementStop:
                muststop = true;
                break;
            case AID_MovementPause:
                ismoving = false;
                break;
            case AID_Setspeed:
                Setspeed(act.getParamExpDouble(rh, 0));
                break;
            case AID_Setobject:
                Setobject(act.getParamObject(rh, 0));
                break;
            case AID_setXoffset:
                xoffset = act.getParamExpression(rh, 0);
                break;
            case AID_setYoffset:
                yoffset = act.getParamExpression(rh, 0);
                break;
            case AID_Enableautostep:
                enableautostep = true;
                break;
            case AID_Disableautostep:
                enableautostep = true;
                break;
            case AID_Forcemovexsteps:
                Forcemovexsteps(act.getParamExpDouble(rh, 0));
                break;
            case AID_SetNodeX:
                SetNodeX(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
                break;
            case AID_SetNodeY:
                SetNodeY(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
                break;
            case AID_Disconnectnode:
                Disconnectnode(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
                break;
            case AID_ClearJourney:
                ClearJourney();
                break;
            case AID_ChangeX:
                ChangeX(act.getParamExpression(rh, 0));
                break;
            case AID_ChangeY:
                ChangeY(act.getParamExpression(rh, 0));
                break;
            case AID_ChangeDirection:
                ChangeDirection(act.getParamExpression(rh, 0));
                break;
        }
    }

    private void creatpathnod(int param1, int param2)
    {
        mypointer.myvector.add(new CRunAdvPathMovPoints(param1, param2));
    }

    private void removepathnod(int param1)
    {
        if (distance != 0)
        {
            return;
        }
        if (mypointer.myjourney.size() != 0)
        {
            return;
        }
        if (param1 < 1)
        {
            return;
        }
        if (param1 > mypointer.myvector.size())
        {
            return;
        }
        mypointer.myvector.remove(param1 - 1);
        int connectionspot;
        ///Loop through all the vectors!
        int myvector_size = mypointer.myvector.size();
        for (int i = 0; i < myvector_size; i++)
        {
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(i);
            connectionspot = -1;
            for (int j = 0; j < mypointer.theIterator.Connections.size(); j++)
            {
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(j);
                connectionspot++;
                if (mypointer.theIterator.ConnectIterator.PointID == param1 - 1)
                {
                    mypointer.theIterator.Connections.remove(connectionspot);
                }
                if (mypointer.theIterator.ConnectIterator.PointID >= param1 - 1)
                {
                    mypointer.theIterator.ConnectIterator.PointID -= 1;
                }
            }
        }
    }

    private void remove(ArrayList<?> array, int from, int to)
    {
    	//Log.Log("from: "+from+" to: "+to);
        int i = from;
        while (i < to)
        {
            array.remove(from);
            i++;
        }  
    }

    private void Clearpath(int param1)
    {
        ////THIS IS ACTUALLY CLEAR JOURNEY
        if (mypointer.myjourney.size() < 2)
        {
            distance = 0;
            totaldist = 0;
            ismoving = false;
            return;
        }
        if (param1 == 0)
        {
            mypointer.myjourney.clear();
            distance = 0;
            totaldist = 0;
            ismoving = false;
            return;
        }
        if ((param1 == 1) && (distance == 0))
        {
            remove(mypointer.myjourney, 1, mypointer.myjourney.size());

            distance = 0;
            totaldist = 0;
        }

        if ((param1 == 1) && (distance > 0))
        {
            remove(mypointer.myjourney, 2, mypointer.myjourney.size());
        }
    }

    private void Connectnods(int p1, int p2, double p3)
    {
        p1--;
        p2--;
        /// Idiot Proof :P
        if (p1 < 0 || p2 < 0 || p1 >= mypointer.myvector.size() || p2 >= mypointer.myvector.size() || p1 == p2)
        {
            return;
        }
        //int myval = 0;
        /////Check for existing connections.
        mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(p1);

        for (int i = 0; i < mypointer.theIterator.Connections.size(); i++)
        {
            mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);

            if (mypointer.theIterator.ConnectIterator.PointID == p2)
            {
                mypointer.theIterator.Connections.remove(mypointer.theIterator.ConnectIterator);
            }
        //	myval ++;
        }

        /////
        //Get second vector
        mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(p2);
        int v2x = mypointer.theIterator.X;
        int v2y = mypointer.theIterator.Y;

        //Get first vector
        mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(p1);
        int v1x = mypointer.theIterator.X;
        int v1y = mypointer.theIterator.Y;
        int deltax = v2x - v1x;
        int deltay = v2y - v1y;
        float distance = (float) Math.sqrt(deltax * deltax + deltay * deltay);
        float vectorentry = (float) (distance / p3);
        // now stick the data into the first vector
        if (p3 == 0)
        {
            p3 = 1;
        }
        mypointer.theIterator.Connections.add(new CRunAdvPathMovConnect(p2, vectorentry));
    }

    private void Addnodjourney(int param1)
    {
        if (param1 < 1 || param1 > mypointer.myvector.size())
        {
            return;
        }
        if (mypointer.myjourney.size() > 0)
        {
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(mypointer.myjourney.size() - 1);
            if (param1 - 1 == mypointer.JourneyIterator.Node)
            {
                return;
            }
        }
        mypointer.myjourney.add(new CRunAdvPathMovJourney(param1 - 1));
    }

    private void Insertnodjourney(int param1, int param2)
    {
        //param1 is the Node

        if (param1 < 0)
        {
            param1 = 0;
        }
        param1--;

        //param2 is the position ( starting at 0 )
        if (param2 >= mypointer.myjourney.size())
        {
            mypointer.myjourney.add(new CRunAdvPathMovJourney(param1));
            return;
        }

        if (param2 < 0)
        {
            param2 = 0;
        }
        //param2--;
        //	int temp;
        int myjourney_size = mypointer.myjourney.size();
        for (int i = myjourney_size - 1; i >= 0; i--)
        {
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(i);

            if (i == myjourney_size - 1)
            {
                mypointer.myjourney.add(new CRunAdvPathMovJourney(mypointer.JourneyIterator.Node));
                myjourney_size = mypointer.myjourney.size();
            }
            else
            {
                int temp = mypointer.JourneyIterator.Node;
                mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(i + 1);
                mypointer.JourneyIterator.Node = temp;
            }

        }

        mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(param2);
        mypointer.JourneyIterator.Node = param1;
    }

    private void Deletenodjourney(int param1)
    {
        ///FOOL PROOF
        if (param1 < 0 || param1 > mypointer.myjourney.size())
        {
            return;
        }
        ///////////

        if (distance == 0)
        {
            mypointer.myjourney.remove(param1);
        }
    //param1 contains the number inputed by the user
    }

    private void Findjourney(int param1)
    {
        param1--;
        if (param1 < 0)
        {
            return;
        }
        if (param1 > mypointer.myvector.size())
        {
            return;
        }
        if (mypointer.myjourney.size() == 0)
        {
            return;
        }

        /////stuff from the class
        ArrayList<Object> ThePoints = new ArrayList<Object>();//holds the point numbers
        ArrayList<Object> Connection = new ArrayList<Object>();//holds which connection id it has
        ArrayList<Object> distance = new ArrayList<Object>();
        ArrayList<Object> Results = new ArrayList<Object>();
        Integer Get;
        //all ArrayList<Integer>

        int Resultdistance = 0;
        boolean Resultfound = false;
        int TheDistance = 0;
        //Put the first point into the point array
        mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(mypointer.myjourney.size() - 1);
        ThePoints.add(Integer.valueOf(mypointer.JourneyIterator.Node));
        Connection.add(Integer.valueOf(0));
        distance.add(Integer.valueOf(0));
        Resultfound = false;

        boolean dontstop = true;
        debug = -1;

        while (dontstop)
        {
            // Get the point we need to check for connections
            Get = (Integer) ThePoints.get(ThePoints.size() - 1);
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(Get.intValue());
            // Check the point
            //check that there will be another conection spot
            if (mypointer.theIterator.Connections.size() > ((Integer) Connection.get(Connection.size() - 1)).intValue())
            {
                //Select the next connection point
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(((Integer) Connection.get(Connection.size() - 1)).intValue());


                /// We look through all the points used so far ( this is necassary so not to go over the same point twice)
                boolean worked = true;
                for (int Currentpos = 0;
                        Currentpos < ThePoints.size();
                        Currentpos++)
                {
                    Get = (Integer) ThePoints.get(Currentpos);

                    if (mypointer.theIterator.ConnectIterator.PointID == Get.intValue())
                    {
                        worked = false;

                        if (ThePoints.size() == 0)
                        {
                            dontstop = false;
                        }
                        else
                        {
                            int v = ((Integer) Connection.get(Connection.size() - 1)).intValue();
                            Connection.set(Connection.size() - 1, Integer.valueOf(v + 1));
                        }
                    }
                }
                //// MUST STICK SOMETHING IN HERE FOR ADDING TO THE DISTANCE
                if (worked)
                {
                    ThePoints.add(Integer.valueOf(mypointer.theIterator.ConnectIterator.PointID));
                    distance.add(Integer.valueOf((int) mypointer.theIterator.ConnectIterator.Distance));
                    TheDistance += mypointer.theIterator.ConnectIterator.Distance;

                    Connection.add(Integer.valueOf(0));
                    if (TheDistance > Resultdistance && Resultfound == true)
                    {
                        Connection.remove(Connection.size() - 1);
                        TheDistance -= ((Integer) distance.get(distance.size() - 1)).intValue();
                        distance.remove(distance.size() - 1);
                        ThePoints.remove(ThePoints.size() - 1);
                        int v = ((Integer) Connection.get(Connection.size() - 1)).intValue();
                        Connection.set(Connection.size() - 1, Integer.valueOf(v + 1));
                    }
                    ///check if the point we have just added is the one we are after
                    Get = (Integer) ThePoints.get(ThePoints.size() - 1);
                    if (Get.intValue() == param1)
                    {
                        ///////////////////////////////////////////////////////////////////////////////
                        /////    WOOOHOOOOO PATH HAS BEEN FOUND FRIGGIN AWSOME :D!!!!                //
                        ///////////////////////////////////////////////////////////////////////////////

                        ////first we calculate the total distance of the journey....i love C++ :)
                        //   int totaldis = 0;
                        // for(int x = 0;x<distance.size();x++)
                        // {
                        //	   totaldis += distance.at(x);}


                        ///no point doing anything if the route is longer

                        if (Resultdistance > TheDistance || Resultfound == false)
                        {
                            Resultfound = true;
                            Resultdistance = TheDistance;
                            Results.clear();

                            //////Now we must stick the distance in the vector and copy all the points
                            for (int y = 0; y < ThePoints.size(); y++)
                            {
                                Get = (Integer) ThePoints.get(y);
                                Results.add(Integer.valueOf(Get.intValue()));
                            }
                        }
                        Connection.remove(Connection.size() - 1);
                        TheDistance -= ((Integer) distance.get(distance.size() - 1)).intValue();
                        distance.remove(distance.size() - 1);
                        ThePoints.remove(ThePoints.size() - 1);
                        int v = ((Integer) Connection.get(Connection.size() - 1)).intValue();
                        Connection.set(Connection.size() - 1, Integer.valueOf(v + 1));
                    }
                }
            }
            else
            {
                ThePoints.remove(ThePoints.size() - 1);
                Connection.remove(Connection.size() - 1);
                TheDistance -= ((Integer) distance.get(distance.size() - 1)).intValue();
                distance.remove(distance.size() - 1);
                if (ThePoints.size() == 0)
                {
                    dontstop = false;
                }
                else
                {
                    int v = ((Integer) Connection.get(Connection.size() - 1)).intValue();
                    Connection.set(Connection.size() - 1, Integer.valueOf(v + 1));
                }
            }
        }

        ///Now we have found all the paths, we must stick them into the journey:)
        int Results_size = Results.size();
        for (int z = 1; z < Results_size; z++)
        {
            Get = (Integer) Results.get(z);
            mypointer.myjourney.add(new CRunAdvPathMovJourney(Get.intValue()));
        }
        //param1 contains the number inputed by the user
        Results.clear();
        ThePoints.clear();
        Connection.clear();
        distance.clear();
        debug = ThePoints.size() + Connection.size() + distance.size() + Results.size();

    }

	private String makeFile(String cFile) {
		String filename = null;
		//JourneyType = "external";
		if(cFile.length() > 0) 
		{
			if(!cFile.contains("/") && !cFile.contains("\\"))
				filename = MMFRuntime.inst.getFilesDir ().toString ()+"/"+cFile;
			else
				filename = cFile;
		}
		
		
		return filename;
	}

	private boolean checkFile(String filename)
	{
		boolean bRet  = false;
		File    file = null;

		try
		{
			file = new File(filename);
			bRet = (file.exists() && file.isFile());
		}
		catch (Exception e)
		{
			bRet = false;
		}
		finally
		{
			if (file != null) 
				file = null;
		}
		return bRet;
	}

	public class JourneyFile
	{
		public InputStream stream;
		public HttpURLConnection connection;

		public void close()
		{
			if(stream != null)
			{
				try
				{	stream.close();
				}
				catch (IOException e)
				{
				}

				stream = null;
			}

			if (connection != null)
			{
				connection.disconnect();
				connection = null;
			}
		}
		@Override
		public void finalize()
		{
			close();
		}
	}

	public JourneyFile openJourneyFile(String path)
	{
		JourneyFile file = new JourneyFile();

		if (path != null && path.length() > 0)
		{
			if(!checkFile(makeFile(path))) {
				CEmbeddedFile embed = null;
				embed = ho.hoAdRunHeader.rhApp.getEmbeddedFile(path);
				if (embed != null)
				{
					file.stream = embed.getInputStream();
					return file;
				}
			}
			else
			{
				try
				{
					file.stream = new FileInputStream(makeFile(path));
					return file;
				}
				catch (IOException e)
				{
					try
					{
						URL url = new URL(path);

						file.connection = (HttpURLConnection) url.openConnection();
						file.stream = file.connection.getInputStream();

						return file;
					}
					catch(Exception ue)
					{
						Log.Log(ue.toString());
					}
				}
			}
		}

		return null;
	}    

    private void LoadPath(String fileName)
    {
    	JourneyFile file = null;

    	try
    	{
    		mypointer.myjourney.clear();
    		file = openJourneyFile(fileName); 
			PushbackInputStream pushbackInputStream = new PushbackInputStream(file.stream);

    		boolean finishedloading = false;

    		int special = 0;
    		int Loadnumber = 0;
    		int Currentpos = 0;
    		int vectorpos = -1;
    		float Loadfloat = 0.0f;
    		int nCount = 0;
    		
    		while(file.stream.available() < 12 || nCount < 10000) {nCount++;} // let wait for some info available to start reading
    		
    		while (!finishedloading)
    		{
    			try
    			{
    				int b = pushbackInputStream.read(); 				
    				if(b == -1)
    					throw(new Exception("End of file ..."));
    				pushbackInputStream.unread(b);
    			}
    			catch (IOException ex)
    			{
    				finishedloading = true;
    			}
    			
    			if ((!finishedloading) && !((Currentpos > 1) && ((Currentpos % 2) == 1)))
    			{
    				Loadnumber = readAnInt(pushbackInputStream);
    			}
    			
    			if ((!finishedloading) && ((Currentpos > 1) && ((Currentpos % 2) == 1)))
    			{
    				int readf = readAnInt(pushbackInputStream);
    				Loadfloat = Float.intBitsToFloat(readf);
    			}
    			if ((special > 0) && (!finishedloading))
    			{
    				if (Currentpos == 0)
    				{
    					mypointer.myvector.add(new CRunAdvPathMovPoints(Loadnumber, 0));
    				}
    				if (Currentpos == 1)
    				{
     					mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(vectorpos);
    					mypointer.theIterator.Y = Loadnumber;
    				}
    				if (Currentpos > 1 && (Currentpos % 2) == 0)
    				{//MessageBox(NULL, "Loading Point ID", NULL,MB_OK );
      					mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(vectorpos);
    					mypointer.theIterator.Connections.add(new CRunAdvPathMovConnect(Loadnumber, 5));
    				}
    				if (Currentpos > 1 && (Currentpos % 2) == 1)
    				{//MessageBox(NULL, "Loading float", NULL,MB_OK );
    					mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(vectorpos);
    					mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get((Currentpos - 3) / 2);
    					mypointer.theIterator.ConnectIterator.Distance = Loadfloat + 20.0f;
    				}
    				Currentpos++;
    			}
    			if ((special == 0) && (!finishedloading))
    			{
    				//	MessageBox(NULL, "New Vector", NULL,MB_OK );
    				special = Loadnumber + 1;
    				vectorpos++;
    				Currentpos = 0;
    			}
    			special -= 1;
    		}
    	}
    	catch (Exception e)
    	{
    	}
    	try
    	{
    		if (file != null)
    		{
    			file.close();
    		}
    	}
    	catch (Exception e)
    	{
    	}
     }
  
    private static int readAnInt(PushbackInputStream stream) throws IOException {
        int val = 0;
        val += stream.read();
        val += (stream.read() << 8);
        val += (stream.read() << 16);
        val += (stream.read() << 24);
        return val;
    }

    private static void writeAFloat(DataOutputStream dataOutputStream, float f) throws IOException {
        dataOutputStream.writeInt(Integer.reverseBytes(Float.floatToIntBits(f)));
    }

    private static void writeAnInt(DataOutputStream dataOutputStream, int i) throws IOException {
        dataOutputStream.writeInt(Integer.reverseBytes(i));
    }

    private void SavePath(String fileName)
    {
    	File file = null;
    	FileOutputStream fos = null;
    	BufferedOutputStream bos = null;
    	DataOutputStream dos = null;
    	try
    	{
    		String filename = makeFile(fileName);
    		file = new File(filename);
    		fos = new FileOutputStream(file);
    		bos = new BufferedOutputStream(fos);
    		dos = new DataOutputStream(bos);
    		for (int i = 0;
    			 i < mypointer.myvector.size();
    			 i++)
    		{
    			mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(i);
    			writeAnInt(dos, mypointer.theIterator.Connections.size() * 2 + 2);
    			writeAnInt(dos, mypointer.theIterator.X);
    			writeAnInt(dos, mypointer.theIterator.Y);
    			
    			for (int j = 0;
    				 j < mypointer.theIterator.Connections.size();
    				 j++)
    			{
    				mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(j);
    				writeAnInt(dos, mypointer.theIterator.ConnectIterator.PointID);
    				writeAFloat(dos, mypointer.theIterator.ConnectIterator.Distance);
    			}
    		}
    		dos.flush();
    	}
    	catch (Exception e)
    	{
    	}
    	try
    	{
    		if (dos != null)
    		{
    			dos.close();
    		}
    		if (bos != null)
    		{
    			bos.close();
    		}
    		if (fos != null)
    		{
    			fos.close();
    		}
    	}
    	catch (Exception e)
    	{
    	}
    }

    private void MovementStart()
    {
        if (mypointer.myjourney.size() < 1)
        {
            return;
        }
        ismoving = true;
        muststop = false;

        //Set the iterator to the first journey step
        mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(0);
        //Now we know what the current point has to be :)
        int FirstNode = mypointer.JourneyIterator.Node;
        int NextNode = 0;
        if (mypointer.myjourney.size() > 1)
        {
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(1);
            //Now we what what the next point is going to be :)
            NextNode = mypointer.JourneyIterator.Node;
        }

        boolean connectfound = false;

        //now we select the first point
        mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(FirstNode);
        //Great...now we need to run through all the connections and find the right one
        int iterConn_size = mypointer.theIterator.Connections.size();
        for (int i = 0;
                i < iterConn_size;
                i++)
        {
            mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);
            if (mypointer.theIterator.ConnectIterator.PointID == NextNode)
            {
                totaldist = mypointer.theIterator.ConnectIterator.Distance;
                connectfound = true;
            }
        }
        if (connectfound == false)
        {
            ismoving = false;
            distance = 0;
            muststop = false;
            totaldist = 0;
        }
    }

    private void Setspeed(double speed)
    {
        if (speed <= 0)
        {
            return;
        }
        speed = (float) speed;
    }

    private void Setobject(CObject object)
    {
        myObject = object;
    }

    private void Forcemovexsteps(double p1)
    {
        if (p1 <= 0)
        {
            return;
        }
        float oldspeed = speed;
        speed = (float) p1;

        ///////////////////////////////////////////////////
        //////////////////////////////////////////////////
        /////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ///////////////////////////////////////////////
        //////////////////////////////////////////////
        if (mypointer.myjourney.size() == 1)
        {
            //	MessageBox(NULL,"Hi",NULL,NULL);
            //This is so the object is at the first point if its not moving.
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(0);
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(mypointer.JourneyIterator.Node);
            x = mypointer.theIterator.X;
            y = mypointer.theIterator.Y;
            if (ChangeX == true)
            {
                myObject.hoX = x;
            }
            if (ChangeY == true)
            {
                myObject.hoY = y;
            }
            myObject.roc.rcChanged = true;
        }

        if (ismoving == false)
        {
            return;
        }

        distance += speed;

        int FirstNode = 0;
        int NextNode = 0;
        boolean connectfound = false;
        while ((ismoving == true) && (distance >= totaldist))
        {
            //Take away the distance travelled so far :)
            mypointer.myjourney.remove(0);

            ////Calculate position ( for when it touches a new node )
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(0);
            FirstNode = mypointer.JourneyIterator.Node;
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(FirstNode);
            x = mypointer.theIterator.X + xoffset;
            y = mypointer.theIterator.Y + yoffset;

            if (ChangeX == true)
            {
                myObject.hoX = x;
            }
            if (ChangeY == true)
            {
                myObject.hoY = y;
            }

            myObject.roc.rcChanged = true;
            ho.generateEvent(CID_touchednewnod, ho.getEventParam());
            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 4, 0);

            if (mypointer.myjourney.size() <= 1 || muststop == true)
            {
                ismoving = false;
                distance = 0;
                muststop = false;
                totaldist = 0;
                ho.generateEvent(CID_Hasreachedend, ho.getEventParam());
            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 3, 0);
            }
            if (ismoving == true)
            {
                distance -= totaldist;

                //Set the iterator to the first journey step
                mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(0);
                //Now we know what the current point has to be :)
                FirstNode = mypointer.JourneyIterator.Node;
                mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(1);
                //Now we what what the next point is going to be :)
                NextNode = mypointer.JourneyIterator.Node;

                //now we select the first point
                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(FirstNode);
                //Great...now we need to run through all the connections and find the right one
                for (int i = 0;
                        i < mypointer.theIterator.Connections.size();
                        i++)
                {
                    mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);
                    if (mypointer.theIterator.ConnectIterator.PointID == NextNode)
                    {
                        totaldist = mypointer.theIterator.ConnectIterator.Distance;
                        connectfound = true;
                    }
                }
                if (connectfound == false)
                {
                    ismoving = false;
                    distance = 0;
                    muststop = false;
                    totaldist = 0;
                }
            }
        }
        if ((ismoving == true) && (distance != 0))
        {
            ////Get points
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(0);
            //Now we know what the current point has to be :)
            FirstNode = mypointer.JourneyIterator.Node;
            mypointer.JourneyIterator = (CRunAdvPathMovJourney) mypointer.myjourney.get(1);
            //Now we want what the next point is going to be :)
            NextNode = mypointer.JourneyIterator.Node;


            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(FirstNode);
            int x1 = mypointer.theIterator.X;
            int y1 = mypointer.theIterator.Y;

            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(NextNode);
            int x2 = mypointer.theIterator.X;
            int y2 = mypointer.theIterator.Y;
            int deltax = x2 - x1;
            int deltay = y2 - y1;

            /////Below need to go in main

            if (totaldist != 0)
            {
                float myval = (float) (Math.atan2((deltax + 0.0), (deltay + 0.0)) / 3.1415926535897932384626433832795 * 180);
                angle = (int) (180 - myval);
            }


            ///////////////////////////End


            /////Below need to go in main
            if (totaldist != 0)
            {
                x = (int) (x1 + deltax * (distance / totaldist) + xoffset);
                y = (int) (y1 + deltay * (distance / totaldist) + yoffset);
                if (ChangeX == true)
                {
                    myObject.hoX = x;
                }
                if (ChangeY == true)
                {
                    myObject.hoY = y;
                }

                if (ChangeDirection == true)
                {
                    int direction = (angle * 32 + 180) / 360;
                    direction = 8 - direction;
                    if (direction < 0)
                    {
                        direction += 32;
                    }
                    //	return direction;
                    myObject.roc.rcDir = direction;
                }
                myObject.roc.rcChanged = true;
            }
        }
        /////////////////////////////////////
        /////////////////
        ////////////////
        ///////////////
        speed = oldspeed;
    }

    private void SetNodeX(int param1, int param2)
    {
        param1--; // 1 based index convert to 0 based
        //use param1
        // and 2
        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
        {
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);
            int OldX = mypointer.theIterator.X;
            int OldY = mypointer.theIterator.Y;
            mypointer.theIterator.X = param2;
            int NewX = mypointer.theIterator.X;
            int NewY = mypointer.theIterator.Y;
            int myvector_size = mypointer.myvector.size();
            int iterConn_size = mypointer.theIterator.Connections.size();
            for (int i = 0;
                    i < myvector_size;
                    i++)
            {
                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(i);
                if (mypointer.theIterator != (CRunAdvPathMovPoints) mypointer.myvector.get(param1))
                {
                    iterConn_size = mypointer.theIterator.Connections.size();
                	for (int j = 0;
                            j < iterConn_size;
                            j++)
                    {
                        mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(j);
                        if (mypointer.theIterator.ConnectIterator.PointID == param1)
                        {
                            //we need to figure the speed
                            int X1 = mypointer.theIterator.X;
                            int Y1 = mypointer.theIterator.Y;
                            float Olddist = (float) (Math.sqrt((X1 - OldX) * (X1 - OldX) + (Y1 - OldY) * (Y1 - OldY)));
                            float vecspeed = mypointer.theIterator.ConnectIterator.Distance / Olddist;
                            float Newdist = (float) (Math.sqrt((X1 - NewX) * (X1 - NewX) + (Y1 - NewY) * (Y1 - NewY)));
                            mypointer.theIterator.ConnectIterator.Distance = vecspeed * Newdist;
                        }
                    }
                }
            }
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);


            for (int i = 0;
                    i < iterConn_size;
                    i++)
            {
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);
                //rdPtr->mypointer->theIterator->ConnectIterator = rdPtr->mypointer->theIterator->Connections.begin() + temp;

                float Distancexspeed = mypointer.theIterator.ConnectIterator.Distance;

                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(mypointer.theIterator.ConnectIterator.PointID);
                int X1 = mypointer.theIterator.X;
                int Y1 = mypointer.theIterator.Y;
                float Olddist = (float) (Math.sqrt((X1 - OldX) * (X1 - OldX) + (Y1 - OldY) * (Y1 - OldY)));
                float vecspeed = Distancexspeed / Olddist;
                float Newdist = (float) (Math.sqrt((X1 - NewX) * (X1 - NewX) + (Y1 - NewY) * (Y1 - NewY)));
                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);
                mypointer.theIterator.ConnectIterator.Distance = vecspeed * Newdist;

            }
        }
    }

    private void SetNodeY(int param1, int param2)
    {
        param1--; // 1 based index convert to 0 based
        //use param1
        // and 2
        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
        {
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);
            int OldX = mypointer.theIterator.X;
            int OldY = mypointer.theIterator.Y;
            mypointer.theIterator.Y = param2;
            int NewX = mypointer.theIterator.X;
            int NewY = mypointer.theIterator.Y;
            int myvector_size = mypointer.myvector.size();
            int iterConn_size = mypointer.theIterator.Connections.size();
            for (int i = 0;
                    i < myvector_size;
                    i++)
            {
                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(i);
                // For points that are connected to the just moved one we need to update
                if (mypointer.theIterator != (CRunAdvPathMovPoints) mypointer.myvector.get(param1))
                {

                    for (int j = 0;
                            j < iterConn_size;
                            j++)
                    {
                        mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(j);
                        if (mypointer.theIterator.ConnectIterator.PointID == param1)
                        {
                            //we need to figure the speed
                            int X1 = mypointer.theIterator.X;
                            int Y1 = mypointer.theIterator.Y;
                            float Olddist = (float) (Math.sqrt((X1 - OldX) * (X1 - OldX) + (Y1 - OldY) * (Y1 - OldY)));
                            float vecspeed = mypointer.theIterator.ConnectIterator.Distance / Olddist;
                            float Newdist = (float) (Math.sqrt((X1 - NewX) * (X1 - NewX) + (Y1 - NewY) * (Y1 - NewY)));
                            mypointer.theIterator.ConnectIterator.Distance = vecspeed * Newdist;
                        }
                    }
                }
            }
            ///Ok now we must update the point so all the things its connected to will change

            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);

            for (int i = 0;
                    i < iterConn_size;
                    i++)
            {
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);
                //rdPtr->mypointer->theIterator->ConnectIterator = rdPtr->mypointer->theIterator->Connections.begin() + temp;

                float Distancexspeed = mypointer.theIterator.ConnectIterator.Distance;

                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(mypointer.theIterator.ConnectIterator.PointID);
                int X1 = mypointer.theIterator.X;
                int Y1 = mypointer.theIterator.Y;
                float Olddist = (float) (Math.sqrt((X1 - OldX) * (X1 - OldX) + (Y1 - OldY) * (Y1 - OldY)));
                float vecspeed = Distancexspeed / Olddist;
                float Newdist = (float) (Math.sqrt((X1 - NewX) * (X1 - NewX) + (Y1 - NewY) * (Y1 - NewY)));
                mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);
                mypointer.theIterator.ConnectIterator.Distance = vecspeed * Newdist;

            }
        }
    }

    private void Disconnectnode(int param1, int param2)
    {
        param1--;
        param2--;
        //param 1 and param 2
        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
        {
            mypointer.theIterator = (CRunAdvPathMovPoints) mypointer.myvector.get(param1);
            for (int i = 0; i < mypointer.theIterator.Connections.size(); i++)
            {
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect) mypointer.theIterator.Connections.get(i);
                if (mypointer.theIterator.ConnectIterator.PointID == param2)
                {
                    mypointer.theIterator.Connections.remove(mypointer.theIterator.ConnectIterator);
                }
            }
        }
    }

    private void ClearJourney()
    {
        ////THIS IS ACTUALLY CLEAR PATH!!!!!!
        mypointer.myvector.clear();
        mypointer.myjourney.clear();
        ismoving = false;
    }

    private void ChangeX(int param1)
    {
        if (param1 == 1)
        {
            ChangeX = true;
        }
        if (param1 == 0)
        {
            ChangeX = false;
        }
    }

    private void ChangeY(int param1)
    {
        if (param1 == 1)
        {
            ChangeY = true;
        }
        if (param1 == 0)
        {
            ChangeY = false;
        }
    }

    private void ChangeDirection(int param1)
    {
        if (param1 == 1)
        {
            ChangeDirection = true;
        }
        if (param1 == 0)
        {
            ChangeDirection = false;
        }
    }
    
    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
    {
        switch (num){
	        case EID_Findnode:
	            return Findnode(ho.getExpParam().getInt(), ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        case EID_Numberofnods:
	            return new CValue(mypointer.myvector.size());
	        case EID_GetJourneynode:
	            return GetJourneynode(ho.getExpParam().getInt());
	        case EID_Countjourneynode:
	            return new CValue(mypointer.myjourney.size());
	        case EID_ObjectGetX:
	            return new CValue(x);
	        case EID_ObjectGetY:
	            return new CValue(y);
	        case EID_ObjectGetSpeed:
	            return new CValue(speed);
	        case EID_NodeDistance:
	            return NodeDistance(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        case EID_NodeX:
	            return NodeX(ho.getExpParam().getInt());
	        case EID_NodeY:
	            return NodeY(ho.getExpParam().getInt());
	        case EID_GetCurrentSpeed:
	            return new CValue(0);
	        case EID_GetXoffset:
	            return new CValue(xoffset);
	        case EID_GetYoffset:
	            return new CValue(yoffset);
	        case EID_GetAngle:
	            return new CValue(angle);
	        case EID_GetDirection:
	            return GetDirection();
	        case EID_Getconnection:
	            return Getconnection(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        case EID_GetNumberconnections:
	            return GetNumberconnections(ho.getExpParam().getInt());
	        case EID_GetNodesSpeed:
	            return GetNodesSpeed(ho.getExpParam().getInt(), ho.getExpParam().getInt());
	        case EID_AutochangeX:
	            return new CValue(ChangeX ? 1 : 0);
	        case EID_AutochangeY:
	            return new CValue(ChangeY ? 1 : 0);
	        case EID_AutochangeDirection:
	            return new CValue(ChangeDirection ? 1 : 0);
        }
        return new CValue(0);//won't be used
    }
    private CValue Findnode(int p1, int p2, int p3){
        int Answer = p3*p3;
        int result = 0;
        int deltaX = 0;
        int deltaY = 0;
        int loopcount =0;

        int myvector_size = mypointer.myvector.size();
        for(int i = 0;
            i < myvector_size;
            i++){
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(i);
            loopcount ++;
            deltaX = Math.abs(mypointer.theIterator.X - p1);
            deltaY = Math.abs(mypointer.theIterator.Y - p2);

            if(Answer > (deltaX * deltaX + deltaY * deltaY ))
            {
                Answer = (deltaX * deltaX + deltaY * deltaY );
                result = loopcount;
            }
        }
        return new CValue(result);
    }

    private CValue GetJourneynode(int p1){
        if(p1 < 0){return new CValue(0);}
        if(mypointer.myjourney.size() == 0){return new CValue(0);}
        if(p1 >= mypointer.myjourney.size() ){return new CValue(0);}
        mypointer.JourneyIterator = (CRunAdvPathMovJourney)mypointer.myjourney.get(p1);
        return new CValue(mypointer.JourneyIterator.Node + 1);
    }
    private CValue NodeDistance(int p1, int p2){
        p1 --;
        p2 --;
        if ((p1 >= 0) && (p1 < mypointer.myvector.size()) &&
            (p2 >= 0) && (p2 < mypointer.myvector.size())){
            //Get second vector
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p2);
            int v2x = mypointer.theIterator.X;
            int v2y = mypointer.theIterator.Y;

            //Get first vector
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1);
            int v1x = mypointer.theIterator.X;
            int v1y = mypointer.theIterator.Y;
            int deltax = v2x - v1x;
            int deltay = v2y - v1y;
            float distance = (float)Math.sqrt(deltax * deltax + deltay * deltay );
            return new CValue(distance);
        }
        return new CValue(0);
    }
    private CValue NodeX(int p1){
        if(p1 < 1){return new CValue(0);}
        if(mypointer.myvector.size() == 0){return new CValue(0);}
        if(p1 > mypointer.myvector.size() ){return new CValue(0);}
        mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1 - 1);
        return new CValue(mypointer.theIterator.X);
    }
    private CValue NodeY(int p1){
        if(p1 < 1){return new CValue(0);}
        if(mypointer.myvector.size() == 0){return new CValue(0);}
        if(p1 > mypointer.myvector.size() ){return new CValue(0);}
        mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1 - 1);
        return new CValue(mypointer.theIterator.Y);
    }
    private CValue GetDirection(){
        int direction = (angle *32+180)/ 360;
        direction = 8-direction;
        if ( direction < 0){direction +=32;}
        return new CValue(direction);
    }
    private CValue Getconnection(int p1, int p2){
        p1--;
        if(p1 < 0){return new CValue(0);}
        if(p1 >= mypointer.myvector.size()){return new CValue(0);}

        mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1);
        if(p2 < 0){return new CValue(0);}
        if(mypointer.theIterator.Connections.size() <= p2){return new CValue(0);}
        mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect)mypointer.theIterator.Connections.get(p2);
        return new CValue(mypointer.theIterator.ConnectIterator.PointID + 1);
    }
    private CValue GetNumberconnections(int p1){
        p1--;
        if(p1 < 0){return new CValue(0);}
        if(p1 >= mypointer.myvector.size()){return new CValue(0);}
        mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1);
        return new CValue(mypointer.theIterator.Connections.size());
    }
    private CValue GetNodesSpeed(int p1, int p2){
        p1--;
        p2--;
        float speed = 0;
        boolean cont = true;
        //param1 contains the number inputed by the user
        //param2 contains the number inputed by the user
        if ((p1 >= 0) && (p1 < mypointer.myvector.size()) &&
            (p2 >= 0) && (p2 < mypointer.myvector.size())){
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1);
            int Connections_size = mypointer.theIterator.Connections.size();
            for(int i = 0;
                i < Connections_size;
                i++){
                mypointer.theIterator.ConnectIterator = (CRunAdvPathMovConnect)mypointer.theIterator.Connections.get(i);
                if(mypointer.theIterator.ConnectIterator.PointID == p2)
                {
                    speed = mypointer.theIterator.ConnectIterator.Distance;
                    cont = false;
                }
            }

            if (cont){return new CValue(0.0f);}
            //Get second vector
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p2);
            int v2x = mypointer.theIterator.X;
            int v2y = mypointer.theIterator.Y;

            //Get first vector
            mypointer.theIterator = (CRunAdvPathMovPoints)mypointer.myvector.get(p1);
            int v1x = mypointer.theIterator.X;
            int v1y = mypointer.theIterator.Y;
            int deltax = v2x - v1x;
            int deltay = v2y - v1y;
            float distance = (float)Math.sqrt(deltax * deltax + deltay * deltay );
            if(distance == 0){
                return new CValue(1.0f);
            }
            return new CValue(distance/speed);
        }
        return new CValue(0.0f);
    }
    
}
