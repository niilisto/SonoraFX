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

package Extensions {
	
	import Actions.CActExtension;
	
	import Conditions.CCndExtension;
	
	import Events.CEventProgram;
	
	import Expressions.CValue;
	
	import OI.COI;
	
	import Objects.CExtension;
	import Objects.CObject;
	
	import Params.PARAM_ZONE;
	
	import RunLoop.CCreateObjectInfo;
	import RunLoop.CObjInfo;
	import RunLoop.CRun;
	
	import Services.CArrayList;
	import Services.CBinaryFile;
	import Services.CFuncVal;
	
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.IViewCursor;
	import mx.managers.SystemManager;
	
	
	
	public class CRunMultipleTouch extends CRunExtension
	{
		
		public static const MTFLAG_RECOGNITION:int= 0x0001;
		public static const MTFLAG_AUTO:int=0x0002;
		public static const CND_NEWTOUCHOBJECT:int=6;
		public static const CND_TOUCHACTIVEOBJECT:int=7;
		public static const CND_NEWPITCH:int=8;
		public static const CND_PITCHACTIVE:int=9;
		public static const CND_NEWGESTURE:int=10;
		public static const CND_LAST:int=11;
		public static const ACT_RECOGNIZE:int=2;
		public static const ACT_SETRECOGNITION:int=3;
		public static const ACT_SETZONE:int=4;
		public static const ACT_SETZONECOORD:int=5;
		public static const ACT_LOADINI:int=6;
		public static const ACT_RECOGNIZEG:int=7;
		public static const ACT_CLEARGESTURES:int=8;
		public static const EXP_PITCHDISTANCE:int= 12;
		public static const EXP_PITCHANGLE:int= 13;
		public static const EXP_PITCHPERCENTAGE:int= 14;
		public static const EXP_RECOGNIZEDNAME:int= 15;
		public static const EXP_RECOGNIZEDPERCENT:int= 16;
		
		public var touches:CArrayList = new CArrayList();
		public var lastTouch:int = -1;
		public var lastNewTouch:int = -1;
		public var lastEndTouch:int = -1;
		public var touchCount:int = 0;
		public var lastNewTouchId:int = -1;
		
		private var MyStage:Stage;
		private var pApp:SystemManager;
		
		
		private var pitch1:int=-1;
		private var pitch2:int=-1;
		private var newPitchCount:int;
		private var pitchDistance:int;
		private var touchArray:CArrayList;
		private var gestureName:String;
		private var gestureNumber:int;
		private var gesturePercent:Number;
		private var width:int;
		private var height:int;
		private var flags:int;
		private var depth:int;
		private var touchXPrevious:Number;
		private var touchYPrevious:Number;
		private var recognizer:PDollarRecognizer;
		private var OiUnder:Number;
		private var newTouchCount:int;
		private var endTouchCount:int;
		private var movedTouchCount:int;
		private var newGestureCount:int;
		private var touchRecord:Boolean;
		private var wasOn:Boolean= false;
		
		public function newTouch(event:TouchEvent):void
		{
			++ touchCount;
			
			var found:Boolean= false;
			
			var touch:CRunMultipleTouchItem=null;
			var i:int;
			var touches_size:int= touches.size();
			
			for(i = 0; i < touches_size; ++ i)
			{
				touch = CRunMultipleTouchItem(touches.get(i));
				
				if(touch != null && touch.free)
				{
					touch.id = event.touchPointID;
					touch.free = false;
					
					touch.startX = touch.dragX = touch.x = event.localX;
					touch.startY = touch.dragY = touch.y = event.localY;
					
					lastTouch = lastNewTouch = i;
					lastNewTouchId=event.touchPointID;
					found = true;
					
					break;
				}
			}
			
			if(!found)
			{
				lastTouch = lastNewTouch = touches.size();
				touch=new CRunMultipleTouchItem(touch.id, touch.x, touch.y);
				touches.add(touch);
			}
			
			newTouchCount=ho.getEventCount();
			ho.generateEvent(0, 0); // New touch
			ho.generateEvent(2, 0); // New touch (no ID)
			
			callObjectConditions(int(touch.x), int(touch.y));
			
			if (pitch1<0)
			{
				pitch1=touch.id;
			}
			else if (pitch2<0)
			{
				pitch2=touch.id;
				ho.generateEvent(CRunMultipleTouch.CND_NEWPITCH, 0);
				newPitchCount=ho.getEventCount();
				pitchDistance=getDistance();
			}
			else
			{
				pitch1=-1;
				pitch2=-1;
			}
			
			if ((flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
			{
				if (touch.x>=ho.hoX && touch.x<ho.hoX+width && touch.y>=ho.hoY && touch.y<ho.hoY+height)
				{
					touchRecord=true;
					if (touchArray.size()>=depth)
					{
						touchArray.removeIndex(0);
					}
					var l:int= touchArray.size();
					touchArray.add(new CArrayList());
					(CArrayList(touchArray.get(l))).add(int((touch.x-ho.hoX)));
					(CArrayList(touchArray.get(l))).add(int((touch.y-ho.hoY)));
					touchXPrevious=touchYPrevious=0x7FFFFFFF;
				}
			}
		}
		
		public function touchMoved(event:TouchEvent):void 
		{
			var multiTouch_touches_size:int= touches.size();
			for(var i:int= 0; i < multiTouch_touches_size; ++ i)
			{
				var touch:CRunMultipleTouchItem= CRunMultipleTouchItem(touches.get(i));
				
				if( (!touch.free) && touch.id == event.touchPointID)
				{
					lastTouch = i;
					
					touch.x = touch.dragX = event.localX;
					touch.y = touch.dragY = event.localY;
					
					ho.generateEvent(4, 0); // Touch moved
					
					if ((flags&MTFLAG_RECOGNITION)!=0&& touchRecord==true)
					{
						if (touch.x!=touchXPrevious || touch.y!=touchYPrevious)
						{
							touchXPrevious=touch.x;
							touchYPrevious=touch.y;
							(CArrayList(touchArray.get(touchArray.size()-1))).add(int((touch.x-ho.hoX)));
							(CArrayList(touchArray.get(touchArray.size()-1))).add(int((touch.y-ho.hoY)));
						}
					}
					
					break;
				}
			}
			
		}
		
		public function endTouch(event:TouchEvent):void 
		{
			for(var i:int= 0; i < touches.size(); ++ i)
			{
				var touch:CRunMultipleTouchItem = CRunMultipleTouchItem(touches.get(i));
				
				if( touch != null && (!touch.free) && touch.id == event.touchPointID)
				{
					-- touchCount;
					
					lastTouch = lastEndTouch = i;
					
					ho.generateEvent(1, 0); // End touch
					ho.generateEvent(3, 0); // End touch (no ID)
					
					if (event.touchPointID==pitch1)
						pitch1=-1;
					else if (event.touchPointID==pitch2)
						pitch2=-1;
					
					if ((flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0&& touchRecord==true)
					{
						if (touch.x!=touchXPrevious || touch.y!=touchYPrevious)
						{
							(CArrayList(touchArray.get(touchArray.size()-1))).add(int((touch.x-ho.hoX)));
							(CArrayList(touchArray.get(touchArray.size()-1))).add(int((touch.y-ho.hoY)));
						}
					}
					
					if(i == (touches.size() - 1))
						touches.removeIndex(i);
					else
						touch.free = true;
					
					
					break;
				}
			}
		}
		
		public override function getNumberOfConditions():int
		{
			return CND_LAST;
		}
		
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			
			var rhPtr:CRun = ho.hoAdRunHeader;
			width = file.readShort();
			height = file.readShort();
			flags = file.readInt();
			depth = file.readShort();
			var text:String= file.readString();
			
			pApp = (rhPtr.rhApp.mainSprite.stage.getChildByName("root1") as SystemManager);
			
			MyStage = pApp.stage;
			
			touches = new CArrayList();
			
			//MyStage = ho.hoAdRunHeader.rhApp.planeControls.stage;
			pitch1=-1;
			pitch2=-1;
			touchRecord=false;
			newTouchCount=endTouchCount=movedTouchCount=newGestureCount=-1;
			
			lastTouch = lastNewTouch = lastEndTouch = -1;
			touchCount = 0;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			MyStage.addEventListener(TouchEvent.TOUCH_BEGIN, newTouch);
			MyStage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoved);
			MyStage.addEventListener(TouchEvent.TOUCH_END, endTouch);
			
			
			if ((flags & MTFLAG_RECOGNITION)!=0)
			{
				createRecognizer();
				addGestures(getStrings(text));
				touchArray = new CArrayList();
			}
			
			return true;
		}
		
		
		public override function destroyRunObject(bFast:Boolean):void
		{
			MyStage.removeEventListener(TouchEvent.TOUCH_BEGIN, newTouch);
			MyStage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoved);
			MyStage.removeEventListener(TouchEvent.TOUCH_END, endTouch);
		}
		
		
		public override function handleRunObject():int
		{
			return 0;
		}
		
		private function createRecognizer():void
		{
			if ((this.flags&MTFLAG_RECOGNITION)!=0)
			{
				if (this.recognizer==null)
				{
					this.recognizer=new PDollarRecognizer();
				}
			}
		}
		
		public function growPointArray(tpoints:Array, size:int):Array
		{
			var oldPoints:Array = tpoints;
			tpoints = new Array(oldPoints.length+size);
			for (var n:int=0; n < oldPoints.length; n++)
				tpoints[n]=oldPoints[n];
			return tpoints;
		}
		
		private function addGestures(strings:Array):void
		{
			var number:int, end:int;
			var name:String;
			var line:int=0;
			var start:int=0;
			var val:CFuncVal=new CFuncVal();
			
			while(true)
			{
				var strings_length:int= strings.length;
				for (; line<strings_length; line++)
				{
					start=strings[line].indexOf("[");
					if (start>=0)
					{
						start++;
						break;
					}
				}
				if (line>=strings_length)
					break;
				end=strings[line].indexOf("]", start);
				if (end<0)
					continue;
				name=strings[line].substring(1, end);
				
				var points:Array=new Array(0);
				var count:int=0;
				for (line++, number=0; line<strings_length; number++, line++)
				{
					var equal:int=strings[line].indexOf("=");
					if (equal<0)
						break;
					
					var str:String=strings[line].substring(equal+1);
					var bracket:int=0;
					var comma:int, x:int, y:int;
					
					var size:int=0;
					var pos:int=str.indexOf("(");
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
		
		private function recognize(depth:int, name:String):void
		{
			this.createRecognizer();
			
			var position:int;
			var points:Array=new Array(0);
			
			for (position=0; position<depth; position++)
			{
				if (position>=this.touchArray.size())
					break;
				
				var t:CArrayList=CArrayList(this.touchArray.get(this.touchArray.size()-position-1));
				var l:int= points.length;
				points=growPointArray(points, t.size()/2);
				var n:int;
				var count:int= 0;
				for (n=0; n<t.size()/2; n++)
				{
					var ix:int=int(t.get(n*2));
					var iy:int=int(t.get(n*2+1));
					points[l+n]=new TPoint(ix, iy, position);
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
		
		public function callObjectConditions(x:int, y:int):void {
			var rhPtr:CRun=this.ho.hoAdRunHeader;
			
			var list:CArrayList =new CArrayList();
			var pHox:CObject;
			var count:int=0, i:int;
			for (i=0; i<rhPtr.rhNObjects; i++)
			{
				while(rhPtr.rhObjectList[count]==null)
					count++;
				pHox=rhPtr.rhObjectList[count];
				count++;
				
				if (this.isObjectUnder(pHox, x, y))
				{
					list.add(pHox);
				}
			}
			var list_size:int= list.size();
			for (count = 0; count < list_size; count++)
			{
				pHox = CObject(list.get(count));
				this.OiUnder = pHox.hoOi;
				this.ho.generateEvent(CRunMultipleTouch.CND_NEWTOUCHOBJECT, 0);
			}
		}
		
		private function isObjectUnder(pHox:CObject, x:int, y:int):Boolean
		{
			var x1:int, y1:int, x2:int, y2:int;
			var rhPtr:CRun=this.ho.hoAdRunHeader;
			
			x1=pHox.hoX-pHox.hoImgXSpot;
			y1=pHox.hoY-pHox.hoImgYSpot;
			x2=x1+pHox.hoImgWidth;
			y2=y1+pHox.hoImgHeight;
			
			var mx:int= x + rhPtr.rhWindowX;
			var my:int= y + rhPtr.rhWindowY;
			
			if (mx >= x1 && mx < x2 && my >= y1 && my < y2)
			{
				if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
				{
					if (pHox.hoType==COI.OBJ_SPR)
					{
						return rhPtr.colMask_TestObject_IXY(pHox, pHox.roc.rcImage, 0, 1.0, 1.0, x, y, 0, 0);
					}
					else
					{
						return true;
					}
				}
				
			}
			return false;
		}
		
		public function isActiveRoutine(id:int, oiList:Number):Boolean 
		{
			if (id< this.touches.size())
			{
				var touch:CRunMultipleTouchItem = CRunMultipleTouchItem(this.touches.get(id));
				if (touch!=null)
				{
					var rhPtr:CRun=this.ho.hoAdRunHeader;
					var rhEvtProg:CEventProgram=rhPtr.rhEvtProg;
					
					var rh2EventPrev:CObject=rhEvtProg.rh2EventPrev;
					var rh2EventPrevOiList:CObjInfo= rhEvtProg.rh2EventPrevOiList;
					var rh2EventPos:CObject= rhEvtProg.rh2EventPos;
					var rh2EventPosOiList:int= rhEvtProg.rh2EventPosOiList;
					var evtNSelectedObjects:int= rhEvtProg.evtNSelectedObjects;
					
					var result:Boolean=false;
					do
					{
						var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(oiList);
						if (pHo==null)
							break;
						var count:int= rhPtr.rhEvtProg.evtNSelectedObjects;
						
						do
						{
							if (!this.isObjectUnder(pHo, int(touch.x), int(touch.y)))
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
		
		private function getDistance():int {
			if (this.pitch1>=0&& this.pitch2>=0)
			{
				var touch1:CRunMultipleTouchItem = CRunMultipleTouchItem(this.touches.get(this.pitch1));
				var touch2:CRunMultipleTouchItem = CRunMultipleTouchItem(this.touches.get(this.pitch2));
				var deltaX:Number=touch2.x-touch1.x;
				var deltaY:Number=touch2.y-touch1.y;
				return int(Math.sqrt(deltaX*deltaX+deltaY*deltaY));
			}
			return -1;
		}
		
		
		public override function condition(num:int, cnd:CCndExtension):Boolean {
			switch (num)
			{
				case 0: /* On new touch */
					return (lastNewTouch == cnd.getParamExpression(rh, 0));
					
				case 1: /* On end touch */
					return (lastEndTouch == cnd.getParamExpression(rh, 0));
					
				case 2: /* On new touch (no ID) */
					return true;
					
				case 3: /* On end touch (no ID) */
					return true;
					
				case 4: /* On touch moved */
					return (lastTouch == cnd.getParamExpression(rh, 0));
					
				case 5: /* Touch active */
				{
					var id:int= cnd.getParamExpression(rh, 0);
					
					if(id < 0|| id >= touches.size())
						break;
					
					return !touches.get(id).free;
				}
					
				case CND_NEWTOUCHOBJECT:
					return cndNewTouchObject(cnd);
				case CND_TOUCHACTIVEOBJECT:
					return this.isActiveRoutine(cnd.getParamExpression(this.rh, 0), cnd.getParamObject(this.rh, 1).oiList);
				case CND_NEWPITCH:
					return true;
				case CND_PITCHACTIVE:
					return (this.pitch1>=0&& this.pitch2>=0);
				case CND_NEWGESTURE:
					return this.cndNewGesture(cnd);
			}
			
			return false;
		}
		
		private function cndNewGesture(cnd:CCndExtension):Boolean {
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
		
		private function cndNewTouchObject(cnd:CCndExtension):Boolean {
			if ((this.ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return this.OiUnder == cnd.getParamObject(this.rh, 0).oi;
			}
			if (this.ho.getEventCount() == this.newTouchCount)
			{
				return this.isActiveRoutine(lastNewTouchId, cnd.getParamObject(this.rh, 0).oiList);
			}
			return false;
		}
		
		
		public override function action(num:int, act:CActExtension):void {
			var id:int= 0;
			var touch:CRunMultipleTouchItem = null;
			
			switch(num)
			{
				case 0: /* Set origin X */
				{
					id = act.getParamExpression(rh, 0);
					
					if(id < 0|| id >= touches.size())
						break;
					
					touch = CRunMultipleTouchItem(touches.get(id));
					touch.startX = act.getParamExpression(rh, 1) - rh.rhWindowX;
					
					break;
				}
					
				case 1: /* Set origin Y */
				{
					id = act.getParamExpression(rh, 0);
					
					if(id < 0|| id >= touches.size())
						break;
					
					touch = CRunMultipleTouchItem(touches.get(id));
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
		
		private function actSetZone(act:CActExtension):void {
			var zone:PARAM_ZONE=act.getParamZone(this.rh, 0);
			this.ho.hoX=zone.x1;
			this.ho.hoY=zone.y1;
			this.width=zone.x2-zone.x1;
			this.height=zone.y2-zone.y1;
		}
		private function actSetZoneCoords(act:CActExtension):void {
			this.ho.hoX=act.getParamExpression(this.rh, 0);
			this.ho.hoY=act.getParamExpression(this.rh, 1);
			this.width=act.getParamExpression(this.rh, 2);
			this.height=act.getParamExpression(this.rh, 3);
		}
		
		private function getStrings(text:String):Array
		{
			var end:int=-1;
			var end1:int=-1;
			var end2:int=-1;
			var begin:int=0;
			var count:int=0;
			
			while(begin < text.length)
			{
				end1 = text.indexOf("\n", begin);
				end2 = text.indexOf("\r", begin);
				end = Math.min(end1, end2);
				count++;
				begin = Math.max(end1+1, end2+1);
			}
			var strings:Array=new Array(count);
			count=begin=0;
			while(begin<text.length)
			{
				end1 = text.indexOf("\n", begin);
				end2 = text.indexOf("\r", begin);
				end = Math.min(end1, end2);
				strings[count++] = text.substring(begin, end);
				begin = Math.max(end1+1, end2+1);
			}
			return strings;
		}
		private function cleanName(name:String):String {
			var pos:int= name.lastIndexOf('\\');
			if (pos < 0)
			{
				pos = name.lastIndexOf('/');
			}
			if (pos >= 0&& pos + 1< name.length)
			{
				name = name.substring(pos + 1);
			}
			return name;
		}
		
		private function actClearGestures():void {
			if ((this.flags&MTFLAG_RECOGNITION)==0)
			{
				this.createRecognizer();
				this.recognizer.ClearGestures();
			}
		}
		private function actRecognize(act:CActExtension):void {
			if ((this.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
			{
				var depth:int=act.getParamExpression(this.rh, 0);
				if (depth<0)
					depth=1;
				if (depth>this.depth)
					depth=this.depth;
				this.recognize(depth, null);
			}
		}
		private function actRecognizeG(act:CActExtension):void {
			if ((this.flags&CRunMultipleTouch.MTFLAG_RECOGNITION)!=0)
			{
				var name:String=act.getParamExpString(this.rh, 0);
				var d:int=act.getParamExpression(this.rh, 1);
				if (d<0)
					d=1;
				if (d>this.depth)
					d=this.depth;
				this.recognize(d, name);
			}
		}
		private function actSetRecognition(act:CActExtension):void {
			var onOff:int=act.getParamExpression(this.rh, 0);
			this.depth=act.getParamExpression(this.rh, 1);
			
			if (onOff!=0)
			{
				this.flags=this.flags|CRunMultipleTouch.MTFLAG_RECOGNITION;
				this.touchArray=new CArrayList();
			}
			else
			{
				this.flags&=~CRunMultipleTouch.MTFLAG_RECOGNITION;
				this.touchArray=null;
			}
		}
		public function getTouchParam(ho:CExtension):CRunMultipleTouchItem {
			var id:int = ho.getExpParam().getInt();
			
			if(id < 0|| id >= touches.size())
				return null;
			
			return CRunMultipleTouchItem(touches.get(id));
		}
		
		
		public override function expression(num:int):CValue {
			var touch:CRunMultipleTouchItem = null;
			var deltaX:Number= 0.0;
			var deltaY:Number= 0.0;
			switch (num)
			{
				case 0: /* Number of touches */
					return new CValue(touchCount);
					
				case 1: /* Last touch */
					return new CValue(lastTouch);
					
				case 2: /* Touch X */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.x + rh.rhWindowX)));
				}
					
				case 3: /* Touch Y */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.y + rh.rhWindowY)));
				}
					
				case 4: /* Last new touch */
					return new CValue(lastNewTouch);
					
				case 5: /* Last end touch */
					return new CValue(lastEndTouch);
					
				case 6: /* Origin X */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.startX + rh.rhWindowX)));
				}
					
				case 7: /* Origin Y */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.startY + rh.rhWindowY)));
				}
					
				case 8: /* Delta X */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.dragX - touch.startX)));
				}
					
				case 9: /* Delta Y */
				{
					touch = getTouchParam(ho);
					
					if(touch == null)
						break;
					
					return new CValue(int(Math.round(touch.dragY - touch.startY)));
				}
					
				case 10: /* Touch angle */
				{
					touch = getTouchParam(ho);
					
					if(touch != null) {
						
						deltaX = touch.dragX - touch.startX;
						deltaY = touch.dragY - touch.startY;
						
						var angle:Number=((Math.PI*2- Math.atan2(deltaY, deltaX))%(Math.PI*2))*180/Math.PI;
						
						return new CValue(angle);
					}
					return new CValue(-1);
				}
					
				case 11: /* Distance */
				{
					var id:int= ho.getExpParam().getInt();
					
					if(id < 0|| id >= touches.size())
						break;
					
					touch = CRunMultipleTouchItem(touches.get(id));
					
					deltaX = touch.dragX - touch.startX;
					deltaY = touch.dragY - touch.startY;
					
					return new CValue(int(Math.round(Math.sqrt(deltaX * deltaX + deltaY * deltaY))));
				}
					
				case EXP_PITCHDISTANCE:
					return new CValue(getDistance());
				case EXP_PITCHANGLE:
					return this.expPitchAngle();
				case EXP_PITCHPERCENTAGE:
					return this.expPitchPercentage();
				case EXP_RECOGNIZEDNAME:
					return this.expGetName();
				case EXP_RECOGNIZEDPERCENT:
					return new CValue(int(this.gesturePercent*100));
			}
			
			return new CValue(-1);
		}
		
		private function expPitchPercentage():CValue {
			var ret:CValue=new CValue(-1);
			var distance:Number=getDistance();
			if (distance>=0&& this.pitchDistance>0)
			{
				var percent:Number=(distance/this.pitchDistance)*100;
				ret.forceInt(int(percent));
			}
			return ret;
		}
		
		private function expPitchAngle():CValue {
			var ret:CValue = new CValue(-1);
			if (this.pitch1>=0&& this.pitch2>=0)
			{
				var touch1:CRunMultipleTouchItem= CRunMultipleTouchItem(this.touches.get(this.pitch1));
				var touch2:CRunMultipleTouchItem= CRunMultipleTouchItem(this.touches.get(this.pitch2));
				var deltaX:Number=touch2.x-touch1.x;
				var deltaY:Number=touch2.y-touch1.y;
				
				var angle:Number=((Math.PI*2- Math.atan2(deltaY, deltaX))%(Math.PI*2))*180/Math.PI;
				
				ret;
			}
			return ret;
		}
		
		private function expGetName():CValue {
			var ret:CValue = new CValue(0);
			return CValue(ret.forceString(this.gestureName));
		}
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

import Services.CServices;

internal class TPoint
{
	public var X:Number, Y:int;
	public var ID:int;
	public function TPoint(x:Number, y:Number, id:int)
	{
		this.X = x;
		this.Y = y;
		this.ID = id; // stroke ID to which this point belongs (1,2,...)
	}
	
}

internal class PointCloud
{
	public var Name:String;
	public var Points:Array;
	public function PointCloud(pRec:PDollarRecognizer, name:String, points:Array)
	{
		this.Name = name;
		this.Points = pRec.Resample(points, pRec.NumPoints);
		this.Points = pRec.Scale(this.Points);
		this.Points = pRec.TranslateTo(this.Points, pRec.Origin);
	}
}

internal class PDollarRecognizer
{
	public var NumPoints:int= 32;
	public var Origin:TPoint= new TPoint(0, 0, 0);
	public var gesturePercent:Number=0;
	public var gestureNumber:int=-1;
	public var gestureName:String="";
	public var PointClouds:Array=new PointCloud[0];
	
	public function Recognize(points:Array, name:String):void {
		points = Resample(points, NumPoints);
		points = Scale(points);
		points = TranslateTo(points, Origin);
		
		var b:Number= 1000000;
		var u:int= -1;
		if (name==null)
		{
			for (var i:int= 0; i < this.PointClouds.length; i++) // for each point-cloud template
			{
				var d:Number= GreedyCloudMatch(points, this.PointClouds[i]);
				if (d < b) {
					b = d; // best (least) distance
					u = i; // point-cloud
				}
			}
		}
		else
		{
			var num:int;
			for (num = 0; num < this.PointClouds.length; num++)
			{
				if (CServices.compareStringsIgnoreCase(name, this.PointClouds[num].Name))
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
	public function AddGesture(name:String, points:Array):int {
		var num:int;
		for (num = 0; num < this.PointClouds.length; num++)
		{
			if (CServices.compareStringsIgnoreCase(name, this.PointClouds[num].Name))
				break;
		}
		if (num<this.PointClouds.length)
			this.PointClouds[num]=new PointCloud(this, name, points);
		else
		{
			var oldArray:Array=this.PointClouds;
			this.PointClouds=new PointCloud[oldArray.length+1];
			for (var n:int=0; n<oldArray.length; n++)
				this.PointClouds[n]=oldArray[n];
			this.PointClouds[this.PointClouds.length-1]=new PointCloud(this, name, points);
		}
		return num;
	}
	public function ClearGestures():void {
		this.PointClouds = new PointCloud[0];
	}
	
	public function GreedyCloudMatch(points:Array, P:PointCloud):Number {
		var e:Number= 0.50;
		var step:int= int(Math.pow(points.length, 1 - e));
		var min:Number= 1000000000;
		for (var i:int= 0; i < points.length; i += step)
		{
			var d1:Number= CloudDistance(points, P.Points, i);
			var d2:Number= CloudDistance(P.Points, points, i);
			min = Math.min(min, Math.min(d1, d2)); // min3
		}
		return min;
	}
	public function CloudDistance(pts1:Array, pts2:Array, start:int):Number {
		var matched:Array= new Boolean[pts1.length]; // pts1.length == pts2.length
		for (var k:int= 0; k < pts1.length; k++)
			matched[k] = false;
		var sum:Number= 0;
		var i:int= start;
		do
		{
			var index:int= -1;
			var min:Number= 1000000000;
			for (var j:int= 0; j < matched.length; j++)
			{
				if (!matched[j])
				{
					var d:Number= Distance(pts1[i], pts2[j]);
					if (d < min)
					{
						min = d;
						index = j;
					}
				}
			}
			matched[index] = true;
			var weight:Number= 1- ((((i - start + pts1.length) % pts1.length))) / pts1.length;
			sum += weight * min;
			i = (i + 1) % pts1.length;
		} while (i != start);
		return sum;
	}
	public function Resample(points:Array, n:int):Array
	{
		var I:Number= PathLength(points) / (n - 1); // interval length
		var D:Number= 0.0;
		var newpoints:Array= new TPoint[1];
		newpoints[0] = points[0];
		for (var i:int= 1; i < points.length; i++)
		{
			if (points[i].ID == points[i-1].ID)
			{
				var d:Number= Distance(points[i - 1], points[i]);
				if ((D + d) >= I)
				{
					var qx:Number= points[i - 1].X + ((I - D) / d) * (points[i].X - points[i - 1].X);
					var qy:Number= points[i - 1].Y + ((I - D) / d) * (points[i].Y - points[i - 1].Y);
					var q:TPoint= new TPoint(qx, qy, points[i].ID);
					newpoints=this.insertPoint(newpoints, newpoints.length, q);
					points=this.insertPoint(points, i, q); // insert 'q' at position i in points s.t. 'q' will be the next i
					D = 0.0;
				}
				else D += d;
			}
		}
		if (newpoints.length == n - 1) // sometimes we fall a rounding-error short of adding the last point, so add it if so
			newpoints=this.insertPoint(newpoints, newpoints.length, new TPoint(points[points.length - 1].X, points[points.length - 1].Y, points[points.length - 1].ID));
		return newpoints;
	}
	public function insertPoint(points:Array, position:int, point:TPoint):Array
	{
		var oldPoints:Array=points;
		var l:int=points.length+1;
		points=new TPoint[l];
		var c:int;
		for (c=0; c<position; c++)
			points[c]=oldPoints[c];
		for (c=l-1; c>position; c--)
			points[c]=oldPoints[c-1];
		points[position]=point;
		return points;
	}		
	public function Scale(points:Array):Array
	{
		var minX:Number= 1000000000, maxX:int = -1000000000, minY:int = +1000000000, maxY:int = -1000000000;
		var i:int= 0;
		for (i = 0; i < points.length; i++)
		{
			minX = Math.min(minX, points[i].X);
			minY = Math.min(minY, points[i].Y);
			maxX = Math.max(maxX, points[i].X);
			maxY = Math.max(maxY, points[i].Y);
		}
		var size:Number= Math.max(maxX - minX, maxY - minY);
		var newpoints:Array= new TPoint[points.length];
		for (i = 0; i < points.length; i++)
		{
			var qx:Number= (points[i].X - minX) / size;
			var qy:Number= (points[i].Y - minY) / size;
			newpoints[i] = new TPoint(qx, qy, points[i].ID);
		}
		return newpoints;
	}
	public function TranslateTo(points:Array, pt:TPoint):Array // translates points' centroid
	{
		var c:TPoint= Centroid(points);
		var newpoints:Array= new Array(points.length);
		for (var i:int= 0; i < points.length; i++)
		{
			var qx:Number= points[i].X + pt.X - c.X;
			var qy:Number= points[i].Y + pt.Y - c.Y;
			newpoints[i] = new TPoint(qx, qy, points[i].ID);
		}
		return newpoints;
	}
	public function Centroid(points:Array):TPoint {
		var x:Number= 0.0, y:Number = 0.0;
		for (var i:int= 0; i < points.length; i++)
		{
			x += points[i].X;
			y += points[i].Y;
		}
		x /= points.length;
		y /= points.length;
		return new TPoint(x, y, 0);
	}
	public function PathDistance(pts1:Array, pts2:Array):Number // average distance between corresponding points in two paths
	{
		var d:Number= 0.0;
		for (var i:int= 0; i < pts1.length; i++) // assumes pts1.length == pts2.length
			d += Distance(pts1[i], pts2[i]);
		return d / pts1.length;
	}
	public function PathLength(points:Array):Number // length traversed by a point path
	{
		var d:Number= 0.0;
		for (var i:int= 1; i < points.length; i++)
		{
			if (points[i].ID == points[i-1].ID)
				d += Distance(points[i - 1], points[i]);
		}
		return d;
	}
	public function Distance(p1:TPoint, p2:TPoint):Number // Euclidean distance between two points
	{
		var dx:Number= p2.X - p1.X;
		var dy:Number= p2.Y - p1.Y;
		return Math.sqrt(dx * dx + dy * dy);
	}
}

