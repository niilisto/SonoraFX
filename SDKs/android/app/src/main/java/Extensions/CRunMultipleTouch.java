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

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Events.CEventProgram;
import Expressions.CValue;
import OI.COI;
import OI.CObjectCommon;
import Objects.CExtension;
import Objects.CObject;
import Params.PARAM_OBJECT;
import Params.PARAM_ZONE;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import RunLoop.CRun;
import Runtime.ITouchAware;
import Runtime.Log;
import Runtime.MMFRuntime;
import Services.CArrayList;
import Services.CBinaryFile;
import Services.CFuncVal;
import Sprites.CSpriteGen;
import android.graphics.Point;

public class CRunMultipleTouch extends CRunExtension
{

	public static class MultiTouch implements ITouchAware
	{

		public ArrayList<CRunMultipleTouchItem> touches = new ArrayList<CRunMultipleTouchItem>();
		private CRunMultipleTouchItem lastValidTouch;
		public int lastTouch = -1, lastNewTouch = -1, lastEndTouch = -1, touchCount = 0, lastNewTouchId=-1;

		public Set<CRunMultipleTouch> objects = new HashSet<CRunMultipleTouch>();

		public MultiTouch()
		{
			MMFRuntime.inst.touchManager.addTouchAware(this);
			lastValidTouch = new CRunMultipleTouchItem(-1,0,0);
		}

		@Override
		public void newTouch(int id, float x, float y)
		{

			synchronized(multiTouch.touches) {
				
				boolean found = false;
				CRunMultipleTouchItem touch=null;
				int i = 0;
				for(Iterator<CRunMultipleTouchItem> iterator = multiTouch.touches.iterator(); iterator.hasNext();)
				{
					touch = iterator.next();
					i = multiTouch.touches.indexOf(touch);

					if(touch.free)
					{
						touch.id = id;
						touch.free = false;

						touch.startX = touch.dragX = touch.x = x;
						touch.startY = touch.dragY = touch.y = y;

						multiTouch.lastTouch = multiTouch.lastNewTouch = i;
						multiTouch.lastNewTouchId=id;
						found = true;

						break;
					}
				}

				if(!found)
				{
					multiTouch.lastTouch = multiTouch.lastNewTouch = multiTouch.touches.size();
					//multiTouch.lastNewTouchId = id;
					touch=new CRunMultipleTouchItem(id, x, y);
					multiTouch.touches.add(touch);
					found = true;
				}

				if(found)
					++ multiTouch.touchCount;
					
				for(Iterator<CRunMultipleTouch> iter = multiTouch.objects.iterator(); iter.hasNext();)
				{
					CRunMultipleTouch object = iter.next();
					object.newTouchCount=object.ho.getEventCount();

					object.callObjectConditions((int)touch.x, (int)touch.y);

					if (object.pitch1<0)
					{
						object.pitch1=id;
					}
					else if (object.pitch2<0)
					{
						object.pitch2=id;
						object.ho.generateEvent(CRunMultipleTouch.CND_NEWPITCH, 0);
						object.newPitchCount=object.ho.getEventCount();
						object.pitchDistance=object.getDistance();
					}
					else
					{
						object.pitch1=-1;
						object.pitch2=-1;
					}

					if ((object.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
					{
						if (touch.x>=object.ho.hoX && touch.x<object.ho.hoX+object.width && touch.y>=object.ho.hoY && touch.y<object.ho.hoY+object.height)
						{
							object.touchRecord=true;
							if (object.touchArray.size()>=object.depth)
							{
								object.touchArray.remove(0);
							}
							int l = object.touchArray.size();
							object.touchArray.add(new CArrayList<Integer>());
							object.touchArray.get(l).add(Integer.valueOf((int)(touch.x-object.ho.hoX)));
							object.touchArray.get(l).add(Integer.valueOf((int)(touch.y-object.ho.hoY)));
							object.touchXPrevious=object.touchYPrevious=0x7FFFFFFF;
						}
					}
					object.ho.generateEvent(0, 0); // New touch
					object.ho.generateEvent(2, 0); // New touch (no ID)
				}
			}
		}

		@Override
		public void touchMoved(int id, float x, float y)
		{
			//synchronized(multiTouch.touches) {

				int i = 0;
				for(Iterator<CRunMultipleTouchItem> iterator = multiTouch.touches.iterator(); iterator.hasNext();)
				{

					CRunMultipleTouchItem touch = iterator.next();
					i = multiTouch.touches.indexOf(touch);
					multiTouch.lastTouch = i;
					
					if( touch.id == id)
					{

						touch.x = touch.dragX = x;
						touch.y = touch.dragY = y;


						for(Iterator<CRunMultipleTouch> iter = multiTouch.objects.iterator(); iter.hasNext();)
						{
							CRunMultipleTouch object = iter.next();

							if ((object.flags&MTFLAG_RECOGNITION)!=0 && object.touchRecord==true)
							{
								if (touch.x!=object.touchXPrevious || touch.y!=object.touchYPrevious)
								{
									object.touchXPrevious=touch.x;
									object.touchYPrevious=touch.y;
									object.touchArray.get(object.touchArray.size()-1).add(Integer.valueOf((int)(touch.x-object.ho.hoX)));
									object.touchArray.get(object.touchArray.size()-1).add(Integer.valueOf((int)(touch.y-object.ho.hoY)));
								}
							}
							object.ho.generateEvent(4, 0); // Touch moved
						}

						break;
					}
				}
			//}
		}

		@Override
		public void endTouch(int id)
		{
			synchronized(multiTouch.touches) {

				int i = 0;
				for(Iterator<CRunMultipleTouchItem> iterator = multiTouch.touches.iterator(); iterator.hasNext();)
				{

					CRunMultipleTouchItem touch = iterator.next();
					i = multiTouch.touches.indexOf(touch);

					if( (!touch.free) && (touch.id == id || id == -1)) //Added cancel feature with (-1) remove all touches.
					{
						-- multiTouch.touchCount;

						multiTouch.lastTouch = multiTouch.lastEndTouch = i;


						for(Iterator<CRunMultipleTouch> iter = multiTouch.objects.iterator(); iter.hasNext();)
						{
							CRunMultipleTouch object = iter.next();

							if (id==object.pitch1)
								object.pitch1=-1;
							else if (id==object.pitch2)
								object.pitch2=-1;

							if ((object.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0 && object.touchRecord==true)
							{
								if (touch.x!=object.touchXPrevious || touch.y!=object.touchYPrevious)
								{
									object.touchArray.get(object.touchArray.size()-1).add(Integer.valueOf((int)(touch.x-object.ho.hoX)));
									object.touchArray.get(object.touchArray.size()-1).add(Integer.valueOf((int)(touch.y-object.ho.hoY)));
								}
							}
							object.ho.generateEvent(1, 0); // End touch
							object.ho.generateEvent(3, 0); // End touch (no ID)
						}

						lastValidTouch = (CRunMultipleTouchItem) touch.clone(); 
						
						if(!iterator.hasNext())
							iterator.remove();
						else
							touch.free = true;
						if(id != -1)
							break;
					}
				}
			}
		}
	};		// End of TouchAware

	public static MultiTouch multiTouch = null;
	public static final int MTFLAG_RECOGNITION = 0x0001;
	public static final int MTFLAG_AUTO=0x0002;
	public static final int CND_NEWTOUCHOBJECT=6;
	public static final int CND_TOUCHACTIVEOBJECT=7;
	public static final int CND_NEWPITCH=8;
	public static final int CND_PITCHACTIVE=9;
	public static final int CND_NEWGESTURE=10;
	public static final int CND_LAST=11;
	public static final int ACT_RECOGNIZE=2;
	public static final int ACT_SETRECOGNITION=3;
	public static final int ACT_SETZONE=4;
	public static final int ACT_SETZONECOORD=5;
	public static final int ACT_LOADINI=6;
	public static final int ACT_RECOGNIZEG=7;
	public static final int ACT_CLEARGESTURES=8;
	public static final int EXP_PITCHDISTANCE = 12;
	public static final int EXP_PITCHANGLE = 13;
	public static final int EXP_PITCHPERCENTAGE = 14;
	public static final int EXP_RECOGNIZEDNAME = 15;
	public static final int EXP_RECOGNIZEDPERCENT = 16;
	int pitch1=-1;
	int pitch2=-1;
	int newPitchCount;
	int pitchDistance;
	CArrayList<CArrayList<Integer>> touchArray;
	String gestureName;
	int gestureNumber;
	double gesturePercent;
	int width;
	int height;
	int flags;
	int depth;
	float touchXPrevious, touchYPrevious;
	PDollarRecognizer recognizer;
	short OiUnder;
	int hoUnder;
	int newTouchCount;
	int endTouchCount;
	int movedTouchCount;
	int newGestureCount;
	boolean touchRecord;

	private CValue expRet;
	
	@Override public int getNumberOfConditions()
	{
		return CND_LAST;
	}

	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		ho.hoOEFlags |= CObjectCommon.OEFLAG_NEVERKILL;
		
		if(multiTouch == null)
			multiTouch = new MultiTouch();

		multiTouch.objects.add(this);

		width = file.readShort();
		height = file.readShort();
		flags = file.readInt();
		depth = file.readShort();
		String text = file.readString();
		pitch1=-1;
		pitch2=-1;
		touchRecord=false;
		newTouchCount=endTouchCount=movedTouchCount=newGestureCount=-1;

		expRet = new CValue(0);
		
		if ((flags & MTFLAG_RECOGNITION)!=0)
		{
			createRecognizer();
			addGestures(getStrings(text));
			touchArray = new CArrayList<CArrayList<Integer>>();
		}

		return true;
	}

	@Override
	public void destroyRunObject(boolean bFast)
	{
		multiTouch.objects.remove(this);
	}

	@Override
	public int handleRunObject()
	{

		return 0;
	}

	private void createRecognizer()
	{
		if ((this.flags&MTFLAG_RECOGNITION)!=0)
		{
			if (this.recognizer==null)
			{
				this.recognizer=new PDollarRecognizer();
			}
		}
	}

	private TPoint[] growPointArray(TPoint[] points, int size)
	{
		TPoint[] oldPoints=points;
		points=new TPoint[oldPoints.length+size];
		for (int n=0; n<oldPoints.length; n++)
			points[n]=oldPoints[n];
		return points;
	}
	private void addGestures(String[] strings)
	{
		int number, end;
		String name;
		int line=0;
		int start=0;
		CFuncVal val=new CFuncVal();
		while(true)
		{
			for (; line<strings.length; line++)
			{
				start=strings[line].indexOf("[");
				if (start>=0)
				{
					start++;
					break;
				}
			}
			if (line>=strings.length)
				break;
			end=strings[line].indexOf("]", start);
			if (end<0)
				continue;
			name=strings[line].substring(1, end);

			TPoint[] points=new TPoint[0];
			int count=0;
			for (line++, number=0; line<strings.length; number++, line++)
			{
				int equal=strings[line].indexOf("=");
				if (equal<0)
					break;

				String str=strings[line].substring(equal+1);
				int bracket=0;
				int comma, x, y;

				int size=0;
				int pos=str.indexOf("(");
				while(pos>=0)
				{
					size++;
					pos=str.indexOf("(", pos+1);
				}
				if (size>0)
				{
					points=growPointArray(points, size);
					while(true)
					{
						bracket=str.indexOf("(", bracket);
						if (bracket<0)
							break;
						comma=str.indexOf(",", bracket);
						if (comma<0)
							break;

						val.parse(str.substring(bracket+1, comma));
						x=val.intValue;
						bracket=str.indexOf(")", comma);
						if (bracket<0)
							break;
						val.parse(str.substring(comma+1, bracket));
						y=val.intValue;

						points[count++]=new TPoint(x, y, number);
					}
				}
			}
			if (points.length>=2)
			{
				this.recognizer.AddGesture(name, points);
			}
		}
	}

	private void recognize(int depth, String name)
	{
		this.createRecognizer();

		int position;
		TPoint[] points=new TPoint[0];

		for (position=0; position<depth; position++)
		{
			if (position>=this.touchArray.size())
				break;

			CArrayList<Integer> t=this.touchArray.get(this.touchArray.size()-position-1);
			int l = points.length;
			points=growPointArray(points, t.size()/2);
			int n;
			int count = 0;
			for (n=0; n<t.size()/2; n++)
			{
				Integer ix=t.get(n*2);
				Integer iy=t.get(n*2+1);
				points[l+n]=new TPoint(ix.intValue(), iy.intValue(), position);
				count++;
			}
		}
		if (points.length>=2)
		{
			this.recognizer.Recognize(points, name);
			this.gestureNumber=this.recognizer.gestureNumber;
			this.gesturePercent=this.recognizer.gesturePercent;
			this.gestureName=this.recognizer.gestureName;
			if (this.gestureNumber>=0)
			{
				this.newGestureCount = ho.getEventCount();
				this.ho.generateEvent(CRunMultipleTouch.CND_NEWGESTURE, 0);
			}
		}
		else
		{
			this.gestureNumber = -1;
			this.gesturePercent = 0;
			this.gestureName = "";
		}
	}

	public void callObjectConditions(int x, int y)
	{
		CRun rhPtr=this.ho.hoAdRunHeader;

		CArrayList<CObject> list=new CArrayList<CObject>();
		CObject pHox;
		int count=rhPtr.rhNObjects;
		for (CObject pHoa : rhPtr.rhObjectList)
		{
			if(pHoa != null) {
				--count;
	
				if (this.isObjectUnder(pHoa, x, y))
				{
					list.add(pHoa);
				}
			}
			if(count == 0)
				break;
		}

		for (Iterator<CObject> iter = list.iterator(); iter.hasNext() ;)
		{
			pHox = iter.next();
			this.OiUnder = pHox.hoOi;
			this.hoUnder = (pHox.hoCreationId << 16) | (pHox.hoNumber & 0xFFFF);
			this.ho.generateEvent(CRunMultipleTouch.CND_NEWTOUCHOBJECT, 0);
		}
	}

	private boolean isObjectUnder(CObject pHox, int x, int y)
	{
		int x1, y1, x2, y2;
		CRun rhPtr=this.ho.hoAdRunHeader;

		x1=pHox.hoX-pHox.hoImgXSpot;
		y1=pHox.hoY-pHox.hoImgYSpot;
		x2=x1+pHox.hoImgWidth;
		y2=y1+pHox.hoImgHeight;
		//
		// Referenced for sub-apps and screen
		//
		x -= rhPtr.rhApp.absoluteX;
		y -= rhPtr.rhApp.absoluteY;

		int mx = x + rhPtr.rhWindowX;
		int my = y + rhPtr.rhWindowY;

		if (mx >= x1 && mx < x2 && my >= y1 && my < y2)
		{
			//Log.Log("inside area");
			if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
			{
				if (pHox.hoType==COI.OBJ_SPR && (pHox.hoCommon.ocFlags2 & CObjectCommon.OCFLAGS2_COLBOX) == 0)
				{
					return (rhPtr.spriteGen.spriteCol_TestPointOne(pHox.roc.rcSprite, CSpriteGen.LAYER_ALL, x, y, 0) != null);
				}
				else
				{
					return true;
				}
			}
		}
		//Log.Log("outside area");
		return false;
	}

	private boolean isActiveRoutine(int id, short oiList)
	{
		if (id>=0 && id<multiTouch.touches.size())
		{
			CRunMultipleTouchItem touch = multiTouch.touches.get(id);
			if (touch!=null && !touch.free)
			{
				CRun rhPtr=this.ho.hoAdRunHeader;
				CEventProgram rhEvtProg=rhPtr.rhEvtProg;

				CObject rh2EventPrev=rhEvtProg.rh2EventPrev;
				CObjInfo rh2EventPrevOiList = rhEvtProg.rh2EventPrevOiList;
				CObject rh2EventPos = rhEvtProg.rh2EventPos;
				int rh2EventPosOiList = rhEvtProg.rh2EventPosOiList;
				int evtNSelectedObjects = rhEvtProg.evtNSelectedObjects;

				boolean result=false;
				do
				{
					CObject pHo=rhPtr.rhEvtProg.evt_FirstObject(oiList);
					if (pHo==null)
						break;
					int count = rhPtr.rhEvtProg.evtNSelectedObjects;

					do
					{
						if (!this.isObjectUnder(pHo, (int)touch.x, (int)touch.y))
						{
							count--;
							rhPtr.rhEvtProg.evt_DeleteCurrentObject();
						}
						pHo=rhPtr.rhEvtProg.evt_NextObject();
					} while(pHo!=null);

					result=(count!=0);
				}while(false);

				rhEvtProg.rh2EventPrev=rh2EventPrev;
				rhEvtProg.rh2EventPrevOiList=rh2EventPrevOiList;
				rhEvtProg.rh2EventPos=rh2EventPos;
				rhEvtProg.rh2EventPosOiList=rh2EventPosOiList;
				rhEvtProg.evtNSelectedObjects=evtNSelectedObjects;

				return result;
			}
		}
		return false;
	}

	private boolean selectObjectByFixedValue(short oiList, int hoFV)
	{
		CRun rhPtr=this.ho.hoAdRunHeader;
		CEventProgram rhEvtProg=rhPtr.rhEvtProg;

		CObject rh2EventPrev=rhEvtProg.rh2EventPrev;
		CObjInfo rh2EventPrevOiList = rhEvtProg.rh2EventPrevOiList;
		CObject rh2EventPos = rhEvtProg.rh2EventPos;
		int rh2EventPosOiList = rhEvtProg.rh2EventPosOiList;
		int evtNSelectedObjects = rhEvtProg.evtNSelectedObjects;

		boolean result=false;
		do
		{
			CObject pHo=rhPtr.rhEvtProg.evt_FirstObject(oiList);
			if (pHo==null)
				break;
			int count = rhPtr.rhEvtProg.evtNSelectedObjects;

			do
			{
		        int fv = (pHo.hoCreationId << 16) | (pHo.hoNumber & 0xFFFF);
		        if (fv != hoFV)
				{
					count--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();
				}
				pHo=rhPtr.rhEvtProg.evt_NextObject();
			} while(pHo!=null);

			result=(count!=0);
		}while(false);

		rhEvtProg.rh2EventPrev=rh2EventPrev;
		rhEvtProg.rh2EventPrevOiList=rh2EventPrevOiList;
		rhEvtProg.rh2EventPos=rh2EventPos;
		rhEvtProg.rh2EventPosOiList=rh2EventPosOiList;
		rhEvtProg.evtNSelectedObjects=evtNSelectedObjects;

		return result;
	}

	private int getDistance()
	{
		if (this.pitch1>=0 && this.pitch2>=0 
				&& this.pitch1 < multiTouch.touches.size() 
					&& this.pitch2 < multiTouch.touches.size() )
		{
			CRunMultipleTouchItem touch1 = multiTouch.touches.get(this.pitch1);
			CRunMultipleTouchItem touch2 = multiTouch.touches.get(this.pitch2);
			float deltaX=touch2.x-touch1.x;
			float deltaY=touch2.y-touch1.y;
			return (int)Math.sqrt(deltaX*deltaX+deltaY*deltaY);
		}
		return -1;
	}

	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case 0: /* On new touch */
		{
			int iTouch = cnd.getParamExpression(rh, 0);
			return (multiTouch.lastNewTouch == iTouch || iTouch < 0);
		}
		case 1: /* On end touch */
		{
			int iTouch = cnd.getParamExpression(rh, 0);
			return (multiTouch.lastEndTouch == iTouch || iTouch < 0);
		}
		case 2: /* On new touch (no ID) */
			return true;

		case 3: /* On end touch (no ID) */
			return true;

		case 4: /* On touch moved */
		{
			int iTouch = cnd.getParamExpression(rh, 0);
			//Log.Log("Moved Lasttouch: "+ multiTouch.lastTouch + " and value to compare: "+ iTouch);
			return (multiTouch.lastTouch == iTouch || iTouch < 0);
		}
		case 5: /* Touch active */
		{
			int id = cnd.getParamExpression(rh, 0);

			if(id < 0 || id >= multiTouch.touches.size())
				break;

			return !multiTouch.touches.get(id).free;
		}

		case CND_NEWTOUCHOBJECT:
			return cndNewTouchObject(cnd);
		case CND_TOUCHACTIVEOBJECT:
			return this.isActiveRoutine(cnd.getParamExpression(this.rh, 0), cnd.getParamObject(this.rh, 1).oiList);
		case CND_NEWPITCH:
			return true;
		case CND_PITCHACTIVE:
			return (this.pitch1>=0 && this.pitch2>=0);
		case CND_NEWGESTURE:
			return this.cndNewGesture(cnd);
		}

		return false;
	}

	private boolean cndNewGesture(CCndExtension cnd)
	{
		if ((this.ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
		{
			return true;
		}
		if (this.ho.getEventCount() == this.newGestureCount)
		{
			return true;
		}
		return false;
	}

	private boolean cndNewTouchObject(CCndExtension cnd)
	{
		PARAM_OBJECT param = cnd.getParamObject(this.rh, 0);
		if ((this.ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
		{
			if ( this.OiUnder != param.oi && param.oi >= 0 )
				return false;
			return this.selectObjectByFixedValue(param.oiList, this.hoUnder);
		}
		if (this.ho.getEventCount() == this.newTouchCount)
		{
			return this.isActiveRoutine(multiTouch.lastNewTouchId, param.oiList);
		}
		return false;
	}

	@Override
	public void action(int num, CActExtension act)
	{
		switch(num)
		{
		case 0: /* Set origin X */
		{
			int id = act.getParamExpression(rh, 0);

			if(id < 0 || id >= multiTouch.touches.size())
				break;

			CRunMultipleTouchItem touch = multiTouch.touches.get(id);
			touch.startX = act.getParamExpression(rh, 1) - rh.rhWindowX;

			break;
		}

		case 1: /* Set origin Y */
		{
			int id = act.getParamExpression(rh, 0);

			if(id < 0 || id >= multiTouch.touches.size())
				break;

			CRunMultipleTouchItem touch = multiTouch.touches.get(id);
			touch.startY = act.getParamExpression(rh, 1) - rh.rhWindowY;

			break;
		}

		case ACT_RECOGNIZE:
			this.actRecognize(act);
			break;
		case ACT_SETRECOGNITION:
			this.actSetRecognition(act);
			break;
		case ACT_SETZONE:
			this.actSetZone(act);
			break;
		case ACT_SETZONECOORD:
			this.actSetZoneCoords(act);
			break;
		case ACT_LOADINI:
			//                this.actLoadIni(act);
			break;
		case ACT_RECOGNIZEG:
			this.actRecognizeG(act);
			break;
		case ACT_CLEARGESTURES:
			this.actClearGestures();
			break;
		}
	}

	private void actSetZone(CActExtension act)
	{
		PARAM_ZONE zone=act.getParamZone(this.rh, 0);
		this.ho.hoX=zone.x1;
		this.ho.hoY=zone.y1;
		this.width=zone.x2-zone.x1;
		this.height=zone.y2-zone.y1;
	}
	private void actSetZoneCoords(CActExtension act)
	{
		this.ho.hoX=act.getParamExpression(this.rh, 0);
		this.ho.hoY=act.getParamExpression(this.rh, 1);
		this.width=act.getParamExpression(this.rh, 2);
		this.height=act.getParamExpression(this.rh, 3);
	}
	private String[] getStrings(String text)
	{
		int end, end1, end2, begin=0, count=0;
		int text_len = text.length();
		while(begin<text_len)
		{
			end1=text.indexOf(10, begin);
			end2=text.indexOf(13, begin);
			end=Math.min(end1, end2);
			count++;
			begin=Math.max(end1, end2)+1;
			if(end < 0) {
				break;
			}
		}
		String[] strings=new String[count];
		count=begin=0;
		while(begin<text_len)
		{
			end1=text.indexOf(10, begin);
			end2=text.indexOf(13, begin);
			end=Math.min(end1, end2);
			if(end < 0) {
				strings[count++]=text.substring(begin);
				break;
			}
			strings[count++]=text.substring(begin, end);
			begin=Math.max(end1, end2)+1;
		}
		return strings;
	}
	private String cleanName(String name)
	{
		int pos = name.lastIndexOf('\\');
		if (pos < 0)
		{
			pos = name.lastIndexOf('/');
		}
		if (pos >= 0 && pos + 1 < name.length())
		{
			name = name.substring(pos + 1);
		}
		return name;
	}

	private void actClearGestures()
	{
		if ((this.flags&MTFLAG_RECOGNITION)==0)
		{
			this.createRecognizer();
			this.recognizer.ClearGestures();
		}
	}
	private void actRecognize(CActExtension act)
	{
		if ((this.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
		{
			int depth=act.getParamExpression(this.rh, 0);
			if (depth<0)
				depth=1;
			if (depth>this.depth)
				depth=this.depth;
			this.recognize(depth, null);
		}
	}
	private void actRecognizeG(CActExtension act)
	{
		if ((this.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
		{
			String name=act.getParamExpString(this.rh, 0);
			int d=act.getParamExpression(this.rh, 1);
			if (d<0)
				d=1;
			if (d>this.depth)
				d=this.depth;
			this.recognize(d, name);
		}
	}
	private void actSetRecognition(CActExtension act)
	{
		int onOff=act.getParamExpression(this.rh, 0);
		this.depth=act.getParamExpression(this.rh, 1);

		if (onOff!=0)
		{
			this.flags=this.flags|CRunMultipleTouch.MTFLAG_RECOGNITION;
			this.touchArray=new CArrayList<CArrayList<Integer>>();
		}
		else
		{
			this.flags&=~CRunMultipleTouch.MTFLAG_RECOGNITION;
			this.touchArray=null;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////
	//
	//                 Expressions
	//
	///////////////////////////////////////////////////////////////////////////////////
	public CRunMultipleTouchItem getTouchParam(CExtension ho)
	{
		int id = ho.getExpParam().getInt();

		if(id < 0) //|| id >= multiTouch.touches.size())
			return null;

		if(id < multiTouch.touches.size() && multiTouch.touches.get(id) != null)
			return multiTouch.touches.get(id);
		else if(multiTouch.lastValidTouch != null && multiTouch.lastValidTouch.id == id)
			return multiTouch.lastValidTouch;
		else
			return null;
	}

	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case 0: /* Number of touches */
			expRet.forceInt(multiTouch.touchCount);
			return expRet;

		case 1: /* Last touch */
			expRet.forceInt(multiTouch.lastTouch);
			return expRet;

		case 2: /* Touch X */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;

			expRet.forceInt(Math.round(touch.x + rh.rhWindowX-rh.rhApp.absoluteX));
			return expRet;
		}

		case 3: /* Touch Y */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;

			expRet.forceInt(Math.round(touch.y + rh.rhWindowY-rh.rhApp.absoluteY));
			return expRet;
		}

		case 4: /* Last new touch */
			expRet.forceInt(multiTouch.lastNewTouch);
			return expRet;

		case 5: /* Last end touch */
			expRet.forceInt(multiTouch.lastEndTouch);
			return expRet;

		case 6: /* Origin X */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;

			expRet.forceInt(Math.round(touch.startX + rh.rhWindowX-rh.rhApp.absoluteX));
			return expRet;
		}

		case 7: /* Origin Y */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;

			expRet.forceInt(Math.round(touch.startY + rh.rhWindowY-rh.rhApp.absoluteY));
			return expRet;
		}

		case 8: /* Delta X */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;

			expRet.forceInt(Math.round(touch.dragX - touch.startX));
			return expRet;
		}

		case 9: /* Delta Y */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);

			if(touch == null)
				break;
			
			expRet.forceInt(Math.round(touch.dragY - touch.startY));
			return expRet;
		}

		case 10: /* Touch angle */
		{
			CRunMultipleTouchItem touch = getTouchParam(ho);
			expRet.forceDouble(-1);
			if(touch != null) {

				float deltaX = touch.dragX - touch.startX;
				float deltaY = touch.dragY - touch.startY;

				double angle=((Math.PI*2 - Math.atan2(deltaY, deltaX))%(Math.PI*2))*180/Math.PI;

				expRet.forceDouble(angle);
				return expRet;
			}
			return expRet;

		}

		case 11: /* Distance */
		{
			int id = ho.getExpParam().getInt();

			if(id < 0 || id >= multiTouch.touches.size())
				break;

			CRunMultipleTouchItem touch = multiTouch.touches.get(id);
			
			if(touch == null)
				break;

			float deltaX = touch.dragX - touch.startX;
			float deltaY = touch.dragY - touch.startY;
			
			expRet.forceInt((int) Math.round(Math.sqrt(deltaX * deltaX + deltaY * deltaY)));
			return expRet;
		}

		case EXP_PITCHDISTANCE:
			expRet.forceInt(this.getDistance());
			return expRet;
		case EXP_PITCHANGLE:
			expRet.forceInt(this.expPitchAngle());
			return expRet;
		case EXP_PITCHPERCENTAGE:
			expRet.forceInt(this.expPitchPercentage());
			return expRet;
		case EXP_RECOGNIZEDNAME:
			expRet.forceString(this.gestureName);
			return expRet;
		case EXP_RECOGNIZEDPERCENT:
			expRet.forceInt((int)(this.gesturePercent*100));
			return expRet;
		}

		expRet.forceInt(-1);
		return expRet;
	}

	private int expPitchPercentage()
	{
		int percent = -1;
		double distance=getDistance();
		if (distance>=0 && this.pitchDistance>0)
		{
			percent=(int)((distance/this.pitchDistance)*100);
		}
		return percent;
	}

	private int expPitchAngle()
	{
		int angle = -1;
		if (this.pitch1>=0 && this.pitch2>=0)
		{
			CRunMultipleTouchItem touch1 = multiTouch.touches.get(this.pitch1);
			CRunMultipleTouchItem touch2 = multiTouch.touches.get(this.pitch2);
			float deltaX=touch2.x-touch1.x;
			float deltaY=touch2.y-touch1.y;

			angle=(int)(((Math.PI*2 - Math.atan2(deltaY, deltaX))%(Math.PI*2))*180/Math.PI);
		}
		return angle;
	}

}

/**
 * The $P Point-Cloud Recognizer (JavaScript version)
 *
 * 	Radu-Daniel Vatavu, Ph.D.
 *	University Stefan cel Mare of Suceava
 *	Suceava 720229, Romania
 *	vatavu@eed.usv.ro
 *
 *	Lisa Anthony, Ph.D.
 *      UMBC
 *      Information Systems Department
 *      1000 Hilltop Circle
 *      Baltimore, MD 21250
 *      lanthony@umbc.edu
 *
 *	Jacob O. Wobbrock, Ph.D.
 * 	The Information School
 *	University of Washington
 *	Seattle, WA 98195-2840
 *	wobbrock@uw.edu
 *
 * The academic publication for the $P recognizer, and what should be
 * used to cite it, is:
 *
 *	Vatavu, R.-D., Anthony, L. and Wobbrock, J.O. (2012).
 *	  Gestures as point clouds: A $P recognizer for user interface
 *	  prototypes. Proceedings of the ACM Int'l Conference on
 *	  Multimodal Interfaces (ICMI '12). Santa Monica, California
 *	  (October 22-26, 2012). New York: ACM Press, pp. 273-280.
 *
 * This software is distributed under the "New BSD License" agreement:
 *
 * Copyright (c) 2012, Radu-Daniel Vatavu, Lisa Anthony, and
 * Jacob O. Wobbrock. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *    * Neither the names of the University Stefan cel Mare of Suceava,
 *	University of Washington, nor UMBC, nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Radu-Daniel Vatavu OR Lisa Anthony
 * OR Jacob O. Wobbrock BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 **/

class TPoint
{
	public double X, Y;
	public int ID;
	public TPoint(double x, double y, int id)
	{
		this.X = x;
		this.Y = y;
		this.ID = id; // stroke ID to which this point belongs (1,2,...)
	}

}
class PointCloud
{
	public String Name;
	public TPoint[] Points;
	public PointCloud(PDollarRecognizer pRec, String name, TPoint[] points)
	{
		this.Name = name;
		this.Points = pRec.Resample(points, pRec.NumPoints);
		this.Points = pRec.Scale(this.Points);
		this.Points = pRec.TranslateTo(this.Points, pRec.Origin);
	}
}
class PDollarRecognizer
{
	public int NumPoints = 32;
	public TPoint Origin = new TPoint(0, 0, 0);
	public double gesturePercent=0;
	public int gestureNumber=-1;
	public String gestureName="";
	public PointCloud[] PointClouds=new PointCloud[0];

	public void Recognize(TPoint[] points, String name)
	{
		points = Resample(points, NumPoints);
		points = Scale(points);
		points = TranslateTo(points, Origin);

		double b = 1000000;
		int u = -1;
		if (name==null)
		{
			for (int i = 0; i < this.PointClouds.length; i++) // for each point-cloud template
			{
				double d = GreedyCloudMatch(points, this.PointClouds[i]);
				if (d < b) {
					b = d; // best (least) distance
					u = i; // point-cloud
				}
			}
		}
		else
		{
			int num;
			for (num = 0; num < this.PointClouds.length; num++)
			{
				if (name.compareTo(this.PointClouds[num].Name)==0)
					break;
			}
			if (num<this.PointClouds.length)
			{
				b=GreedyCloudMatch(points, this.PointClouds[num]);
				u=num;
			}
		}
		this.gesturePercent=Math.max((b - 2.0) / -2.0, 0.0);
		if (this.gesturePercent>0)
		{
			this.gestureNumber=u;
			this.gestureName=(u == -1) ? "" : this.PointClouds[u].Name;
		}
		else
		{
			this.gestureName = "";
			this.gestureNumber = -1;
		}
	}
	public int AddGesture(String name, TPoint[] points)
	{
		int num;
		for (num = 0; num < this.PointClouds.length; num++)
		{
			if (name.compareTo(this.PointClouds[num].Name)==0)
				break;
		}
		if (num<this.PointClouds.length)
			this.PointClouds[num]=new PointCloud(this, name, points);
		else
		{
			PointCloud[] oldArray=this.PointClouds;
			this.PointClouds=new PointCloud[oldArray.length+1];
			for (int n=0; n<oldArray.length; n++)
				this.PointClouds[n]=oldArray[n];
			this.PointClouds[this.PointClouds.length-1]=new PointCloud(this, name, points);
		}
		return num;
	}
	public void ClearGestures()
	{
		this.PointClouds = new PointCloud[0];
	}

	public double GreedyCloudMatch(TPoint[] points, PointCloud P)
	{
		double e = 0.50;
		int step = (int)Math.pow(points.length, 1 - e);
		double min = 1000000000;
		for (int i = 0; i < points.length; i += step)
		{
			double d1 = CloudDistance(points, P.Points, i);
			double d2 = CloudDistance(P.Points, points, i);
			min = Math.min(min, Math.min(d1, d2)); // min3
		}
		return min;
	}
	public double CloudDistance(TPoint[] pts1, TPoint[] pts2, int start)
	{
		boolean[] matched = new boolean[pts1.length]; // pts1.length == pts2.length
		for (int k = 0; k < pts1.length; k++)
			matched[k] = false;
		double sum = 0;
		int i = start;
		do
		{
			int index = -1;
			double min = 1000000000;
			for (int j = 0; j < matched.length; j++)
			{
				if (!matched[j])
				{
					double d = Distance(pts1[i], pts2[j]);
					if (d < min)
					{
						min = d;
						index = j;
					}
				}
			}
			matched[index] = true;
			double weight = 1 - ((double)((i - start + pts1.length) % pts1.length)) / pts1.length;
			sum += weight * min;
			i = (i + 1) % pts1.length;
		} while (i != start);
		return sum;
	}
	public TPoint[] Resample(TPoint[] points, int n)
	{
		double I = PathLength(points) / (n - 1); // interval length
		double D = 0.0;
		TPoint[] newpoints = new TPoint[1];
		newpoints[0]=points[0];
		for (int i = 1; i < points.length; i++)
		{
			if (points[i].ID == points[i-1].ID)
			{
				double d = Distance(points[i - 1], points[i]);
				if ((D + d) >= I)
				{
					double qx = points[i - 1].X + ((I - D) / d) * (points[i].X - points[i - 1].X);
					double qy = points[i - 1].Y + ((I - D) / d) * (points[i].Y - points[i - 1].Y);
					TPoint q = new TPoint(qx, qy, points[i].ID);
					newpoints=this.insertPoint(newpoints, newpoints.length, q);
					points=this.insertPoint(points, i, q); // insert 'q' at position i in points s.t. 'q' will be the next i
					D = 0.0;
				}
				else D += d;
			}
		}
		while (newpoints.length < n) // sometimes we fall a rounding-error short of adding the last point, so add it if so
			newpoints=this.insertPoint(newpoints, newpoints.length, new TPoint(points[points.length - 1].X, points[points.length - 1].Y, points[points.length - 1].ID));
		return newpoints;
	}
	public TPoint[] insertPoint(TPoint[] points, int position, TPoint point)
	{
		TPoint[] oldPoints=points;
		int l=points.length+1;
		points=new TPoint[l];
		int c;
		for (c=0; c<position; c++)
			points[c]=oldPoints[c];
		for (c=l-1; c>position; c--)
			points[c]=oldPoints[c-1];
		points[position]=point;
		return points;
	}
	public TPoint[] Scale(TPoint[] points)
	{
		double minX = 1000000000, maxX = -1000000000, minY = +1000000000, maxY = -1000000000;
		for (int i = 0; i < points.length; i++)
		{
			minX = Math.min(minX, points[i].X);
			minY = Math.min(minY, points[i].Y);
			maxX = Math.max(maxX, points[i].X);
			maxY = Math.max(maxY, points[i].Y);
		}
		double size = Math.max(maxX - minX, maxY - minY);
		TPoint[] newpoints = new TPoint[points.length];
		for (int i = 0; i < points.length; i++)
		{
			double qx = (points[i].X - minX) / size;
			double qy = (points[i].Y - minY) / size;
			newpoints[i] = new TPoint(qx, qy, points[i].ID);
		}
		return newpoints;
	}
	public TPoint[] TranslateTo(TPoint[] points, TPoint pt) // translates points' centroid
	{
		TPoint c = Centroid(points);
		TPoint[] newpoints = new TPoint[points.length];
		for (int i = 0; i < points.length; i++)
		{
			double qx = points[i].X + pt.X - c.X;
			double qy = points[i].Y + pt.Y - c.Y;
			newpoints[i] = new TPoint(qx, qy, points[i].ID);
		}
		return newpoints;
	}
	public TPoint Centroid(TPoint[] points)
	{
		double x = 0.0, y = 0.0;
		for (int i = 0; i < points.length; i++)
		{
			x += points[i].X;
			y += points[i].Y;
		}
		x /= points.length;
		y /= points.length;
		return new TPoint(x, y, 0);
	}
	public double PathDistance(TPoint[] pts1, TPoint[] pts2) // average distance between corresponding points in two paths
	{
		double d = 0.0;
		for (int i = 0; i < pts1.length; i++) // assumes pts1.length == pts2.length
			d += Distance(pts1[i], pts2[i]);
		return d / pts1.length;
	}
	public double PathLength(TPoint[] points) // length traversed by a point path
	{
		double d = 0.0;
		for (int i = 1; i < points.length; i++)
		{
			if (points[i].ID == points[i-1].ID)
				d += Distance(points[i - 1], points[i]);
		}
		return d;
	}
	public double Distance(TPoint p1, TPoint p2) // Euclidean distance between two points
	{
		double dx = p2.X - p1.X;
		double dy = p2.Y - p1.Y;
		return Math.sqrt(dx * dx + dy * dy);
	}
}