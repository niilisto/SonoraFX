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
// CRunMoveSafely2 : MoveSafely2 object
// fin: 13/5/2009
//greyhill
//----------------------------------------------------------------------------------
package Extensions;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunMoveSafely2 extends CRunExtension
{
    public static final int CID_OnSafety = 0;
    static final int AID_Prepare = 0;
    static final int AID_Start = 1;
    static final int AID_Stop =	2;
    static final int AID_SetObject = 3;
    static final int AID_Stop2 = 4;
    static final int AID_Setdist = 5;
    static final int AID_Reset = 6;	
    static final int EID_GetX =	0;
    static final int EID_GetY = 1;
    static final int EID_Getfixed = 2;
    static final int EID_GetNumber = 3;
    static final int EID_GetIndex = 4;
    static final int EID_Getdist = 5;

	CRunMoveSafely2myclass mypointer;
	int X;
	int Y;
	int NewX;
	int NewY;
	int Debug;
	int Temp;
	int Temp2;
	int Loopindex;
	int Dist;
	boolean hasstopped;
	boolean inobstacle;
	boolean last;

	public CRunMoveSafely2()
	{
	}
	@Override
	public int getNumberOfConditions()
	{
		return 1;
	}
	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		this.Dist = 1;
		this.mypointer = new CRunMoveSafely2myclass();
		return true;
	}
	@Override
	public void destroyRunObject(boolean bFast)
	{
	}

	@Override
	public int handleRunObject()
	{
		return REFLAG_ONESHOT;
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
		if (num == CID_OnSafety)
		{
			return true;
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
		case AID_Prepare:
			Prepare();
			break;
		case AID_Start:
			Start();
			break;
		case AID_Stop:
			Stop();
			break;
		case AID_SetObject:
			SetObject(act.getParamObject(rh, 0), act.getParamExpression(rh, 1));
			break;
		case AID_Stop2:
			Stop2();
			break;
		case AID_Setdist:
			SetDist(act.getParamExpression(rh, 0));
			break;
		case AID_Reset:
			Reset();
			break;
		}
	}
	private void Prepare(){
		int mypointer_Mirrorvector_size = mypointer.Mirrorvector.size();
		for (int i = 0; i < mypointer_Mirrorvector_size; i++){
			mypointer.iterator = mypointer.Mirrorvector.get(i);
			mypointer.iterator.OldX = mypointer.iterator.obj.hoX;
			mypointer.iterator.OldY = mypointer.iterator.obj.hoY;
		}
	}
	private void Start(){
		int mypointer_Mirrorvector_size = mypointer.Mirrorvector.size();
		for (int i = 0; i < mypointer_Mirrorvector_size; i++){
			mypointer.iterator = mypointer.Mirrorvector.get(i);
			mypointer.iterator.NewX = mypointer.iterator.obj.hoX;
			mypointer.iterator.NewY = mypointer.iterator.obj.hoY;
			X =  mypointer.iterator.OldX;
			Y =  mypointer.iterator.OldY;
			mypointer.iterator.obj.hoX = X;
			mypointer.iterator.obj.hoY = Y;
		}
		for (int i = 0; i < mypointer_Mirrorvector_size; i++){
			Loopindex = 0;
			mypointer.iterator = mypointer.Mirrorvector.get(i);
			NewX =	mypointer.iterator.NewX;
			NewY = 	mypointer.iterator.NewY;
			Temp = Math.max(Math.abs(mypointer.iterator.OldX - NewX),
					Math.abs(mypointer.iterator.OldY - NewY));
			if (Temp != 0) {
				Temp2 = 1;
				boolean first = true;
				last = false;
				boolean doit = true;
				while(true) {
					if (!first)
						Temp2 += mypointer.iterator.Dist;
					if (first)
						first = false;
					if (Temp2 < Temp)
						doit = true;
					if (Temp2 >= Temp)
						doit = false;

					if(!doit && !last){
						last = true;
						doit=true;
						Temp2 = Temp;
					}
					if(!doit)
						break;
					int x = NewX   -   mypointer.iterator.OldX ;
					int y = NewY   -   mypointer.iterator.OldY;
					X = mypointer.iterator.OldX + x * Temp2 / Temp;
					Y =  mypointer.iterator.OldY + y * Temp2 / Temp;
					mypointer.iterator.obj.hoX = X;
					mypointer.iterator.obj.hoY = Y;

					Debug++;
					ho.generateEvent(CID_OnSafety, ho.getEventParam());
					Loopindex++;
				}
			}
			//get rid of the stopped or other objects will be piseed off :)
			hasstopped = false;
		}
	}

	private void Stop(){
		//If the below happens, we are using the 'push out of obsticle' ruitine.
		if(hasstopped) {
			inobstacle = true;
			return;
		}
		//If the below happens, then we have specified for a 'push out of obstacle' routine.

		//I will need to make a loop, if the 'has stopped' is true, then you are still in an obstacle
		//if it's false, then you CAN stop the object moving :D
		hasstopped = true;
		inobstacle = true;
		int loop = 0;
		if  (mypointer.iterator != null){
			while (inobstacle)
			{
				loop++;
				inobstacle = false;

				int x = NewX   -   mypointer.iterator.OldX;
				int y = NewY   -   mypointer.iterator.OldY;
				X = mypointer.iterator.OldX + x * (Temp2 - loop) / Temp;
				Y =  mypointer.iterator.OldY + y * (Temp2 - loop) / Temp;
				mypointer.iterator.obj.hoX = X;
				mypointer.iterator.obj.hoY = Y;
				ho.generateEvent(CID_OnSafety, ho.getEventParam());
			}
			//stop movin
			Temp2 = Temp;
			last = true;
			mypointer.iterator.obj.roc.rcChanged = true;
		}
	}

	private void SetObject(CObject object, int distance){
		mypointer.Mirrorvector.add(new CRunMoveSafely2CloneObjects(object, distance));
	}
	private void Stop2(){
		//If the below happens, we are using the 'push out of obsticle' ruitine.
		if(hasstopped) {
			inobstacle = true;
			return;
		}
		//stop movin
		Temp2 = Temp;
		if (mypointer.iterator != null){
			mypointer.iterator.obj.roc.rcChanged = true;
		}
	}
	private void SetDist(int dist){
		Dist = dist;
	}
	private void Reset(){
		mypointer.Mirrorvector.clear();
		mypointer.iterator = null;
	}

	// Expressions
	// --------------------------------------------
	@Override
	public CValue expression(int num)
	{
		switch (num){
		case EID_GetX:
			return new CValue(X);
		case EID_GetY:
			return new CValue(Y);
		case EID_Getfixed:
			return Getfixed();
		case EID_GetNumber:
			return new CValue(mypointer.Mirrorvector.size());
		case EID_GetIndex:
			return new CValue(Loopindex);
		case EID_Getdist:
			return new CValue(Debug);
		}
		return new CValue(0);//won't be used
	}
	private CValue Getfixed(){
		if (mypointer.iterator != null){
			return new CValue((mypointer.iterator.obj.hoCreationId << 16) + mypointer.iterator.obj.hoNumber);
		}
		return new CValue(0);
	}
}
