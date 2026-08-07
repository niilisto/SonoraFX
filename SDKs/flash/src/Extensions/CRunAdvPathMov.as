//----------------------------------------------------------------------------------
//
// CRunAdvPathMov: advanced path movement object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunAdvPathMov extends CRunExtension
	{
    	public static var CID_ismoving:int = 0;
    	public static var CID_nodesconnected:int = 1;
    	public static var CID_isstopping:int = 2;
    	public static var CID_Hasreachedend:int = 3;
    	public static var CID_touchednewnod:int = 4;

    	public static var AID_creatpathnod:int = 0;
    	public static var AID_removepathnod:int = 1;
    	public static var AID_Clearpath:int  = 2;
    	public static var AID_Connectnods:int  = 3;
    	public static var AID_Addnodjourney:int = 4;
    	public static var AID_Insertnodjourney:int = 5;
    	public static var AID_Removelastnodjourney:int = 6;
    	public static var AID_Deletenodjourney:int = 7;
    	public static var AID_Findjourney:int = 8;
    	public static var AID_LoadPath:int  = 9;
    	public static var AID_SavePath:int = 10;
    	public static var AID_MovementStart:int = 11;
    	public static var AID_MovementStop:int  = 12;
    	public static var AID_MovementPause:int = 13;
    	public static var AID_Setspeed:int = 14;
    	public static var AID_Setobject:int = 15;
    	public static var AID_setXoffset:int = 16;
    	public static var AID_setYoffset:int = 17;
    	public static var AID_Enableautostep:int = 18;
    	public static var AID_Disableautostep:int = 19;
    	public static var AID_Forcemovexsteps:int = 20;
    	public static var AID_SetNodeX:int = 21;
    	public static var AID_SetNodeY:int = 22;
    	public static var AID_Disconnectnode:int  =23;
    	public static var AID_ClearJourney:int = 24;
    	public static var AID_ChangeX:int = 25;
    	public static var AID_ChangeY:int = 26;
    	public static var AID_ChangeDirection:int = 27;

    	public static var EID_Findnode:int  = 0;
    	public static var EID_Numberofnods:int = 1;
    	public static var EID_GetJourneynode:int              =2;
    	public static var EID_Countjourneynode:int            =3;
    	public static var EID_ObjectGetX:int                  =4;
    	public static var EID_ObjectGetY:int                  =5;
    	public static var EID_ObjectGetSpeed:int              =6;
    	public static var EID_NodeDistance:int                =7;
    	public static var EID_NodeX:int                       =8;
    	public static var EID_NodeY:int                       =9;
    	public static var EID_GetCurrentSpeed:int             =10;
    	public static var EID_GetXoffset:int                  =11;
    	public static var EID_GetYoffset:int                  =12;
    	public static var EID_GetAngle:int                    =13;
    	public static var EID_GetDirection:int                =14;
    	public static var EID_Getconnection:int               =15;
    	public static var EID_GetNumberconnections:int        =16;
    	public static var EID_GetNodesSpeed:int               =17;
    	public static var EID_AutochangeX:int                 =18;
    	public static var EID_AutochangeY:int                 =19;
    	public static var EID_AutochangeDirection:int         =20;

	    public var mypointer:CRunAdvPathMovmyclass;
	    public var distance:Number=0;
	    public var speed:Number=0;
	    public var totaldist:Number=0;
	    public var ismoving:Boolean;
	    public var muststop:Boolean;
	    public var enableautostep:Boolean;
	    public var ChangeX:Boolean;
	    public var ChangeY:Boolean;
	    public var ChangeDirection:Boolean;
	    public var debug:int;
	    public var x:int;
	    public var y:int;
	    public var xoffset:int;
	    public var yoffset:int;
	    public var angle:int;
	    public var myObject:CObject;
	                
		public function CRunAdvPathMov()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 5;
	    }
	    
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	file.setUnicode(false);
	        mypointer = new CRunAdvPathMovmyclass();
	        ho.hoX = cob.cobX;
	        ho.hoY = cob.cobY;
	        file.skipBytes(4);
	        ho.hoImgWidth = file.readShort();
	        ho.hoImgHeight = file.readShort();
	        speed = Number(file.readInt()) / 100.0;
	        xoffset = file.readInt();
	        yoffset = file.readInt();
	        ChangeX = file.readByte() == 1 ? true : false;
	        ChangeY = file.readByte() == 1 ? true : false;
	        ChangeDirection = file.readByte() == 1 ? true : false;
	        enableautostep = file.readByte() == 1 ? true : false;
	        
	        return true;
	    }
		
		public override function destroyRunObject(bFast:Boolean):void
		{
			if(this.mypointer != null) {
				this.mypointer.myjourney.clear();
				this.mypointer.myvector.clear();
				this.mypointer = null;    		
			}
		}    
		

	    public override function handleRunObject():int
	    {
	       if (mypointer.myjourney.size() == 1)
	       {
	            //	MessageBox(NULL,"Hi",NULL,NULL);
	            //This is so the object is at the first point if its not moving.
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(mypointer.JourneyIterator.Node));
	            x = mypointer.theIterator.X;
	            y = mypointer.theIterator.Y;
	            if( ChangeX == true )
	            { 
	            	myObject.hoX = x;
	            }
	            if( ChangeY == true )
	            { 
	            	myObject.hoY = y;
	            }
	            myObject.roc.rcChanged = true;
	        }
	        if(ismoving == false) 
	        { 
	        	return 0; 
	        }
	        if(enableautostep == false)
	        {
	        	return 0;
	        }
	        distance += speed;
	
	        var FirstNode:int = 0;
	        var NextNode:int = 0;
	        var connectfound:Boolean = false;
			var i:int;
			
	        while ((ismoving == true) && (distance >= totaldist))
	        {
	
	            //Take away the distance travelled so far :)
	            mypointer.myjourney.removeIndex(0);
	
	            ////Calculate position ( for when it touches a new node )
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            FirstNode = mypointer.JourneyIterator.Node;
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	            x = mypointer.theIterator.X + xoffset;
	            y = mypointer.theIterator.Y + yoffset;
	
	            if(ChangeX == true )
	            {
	            	myObject.hoX = x;
	            }
	            if(ChangeY == true )
	            {
	            	myObject.hoY = y;
	            }
	
	            myObject.roc.rcChanged = true;
	            ho.generateEvent(CID_touchednewnod, ho.getEventParam());
	            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 4, 0);
	
	            if((mypointer.myjourney.size()) <= 1 || (muststop ==true))
	            {
	                ismoving = false;
	                distance = 0;
	                muststop = false;
	                totaldist = 0;
	                ho.generateEvent(CID_Hasreachedend, ho.getEventParam());
	                //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 3, 0);
	            }
	
	            if(ismoving == true) 
	            {
	                distance -= totaldist;
	
	                //Set the iterator to the first journey step
	                mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	                //Now we know what the current point has to be :)
	                FirstNode = mypointer.JourneyIterator.Node;
	                mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(1));
	                //Now we what what the next point is going to be :)
	                NextNode = mypointer.JourneyIterator.Node;
	
	                //now we select the first point
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	                //Great...now we need to run through all the connections and find the right one
					var iterConn_size:int = this.mypointer.theIterator.Connections.size();
	                for (i = 0; i < iterConn_size; i++)
	                {
	                    mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                    if( mypointer.theIterator.ConnectIterator.PointID == NextNode)
	                    {
	                         totaldist = mypointer.theIterator.ConnectIterator.Distance;
	                         connectfound = true;
	                    }
	                }
	                if(connectfound == false )
	                {
	                    ismoving = false;
	                    distance = 0;
	                    muststop = false;
	                    totaldist = 0;
	                }
	            }
	        }
	
	        if((ismoving == true) && (distance != 0))
	        {
	            ////Get points
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            //Now we know what the current point has to be :)
	            FirstNode = mypointer.JourneyIterator.Node;
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(1));
	            //Now we want what the next point is going to be :)
	            NextNode = mypointer.JourneyIterator.Node;
	
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	            var x1:int = mypointer.theIterator.X;
	            var y1:int = mypointer.theIterator.Y;
	
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(NextNode));
	            var x2:int = mypointer.theIterator.X;
	            var y2:int = mypointer.theIterator.Y;
	            var deltax:int= x2 - x1;
	            var deltay:int= y2 - y1;
	
	            /////Below need to go in main
	
	            if(totaldist!= 0)
	            {
	                var myval:Number = Number(Math.atan2((deltax+0.0),(deltay+0.0))/3.1415926535897932384626433832795 * 180.0);
	                angle = int(180.0-myval);
	            }
	
	
	///////////////////////////End
	            /////Below need to go in main
	            if(totaldist!=0)
	            {
	                x = (int)(x1 + deltax * (distance / totaldist )+ xoffset);
	                y = (int)(y1 + deltay * (distance / totaldist )+ yoffset);
	                if(ChangeX == true )
	                {
	                	myObject.hoX = x;
	                }
	                if(ChangeY == true )
	                {
	                	myObject.hoY = y;
	                }
	
	                if(ChangeDirection == true )
	                {
	                    var direction:int = (angle *32+180)/ 360;
	                    direction = 8-direction;
	                    if ( direction < 0)
	                    {
	                    	direction +=32;
	                    }
	                //	return direction;
	                    myObject.roc.rcDir = direction;
	                }
	                myObject.roc.rcChanged = true;
	            }
	        }
	        return 0;
	    }

	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
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

	    public function nodesconnected(param1:int, param2:int):Boolean
	    {
	        param1--;
	        param2--;
	        if(param1 < 0||param2 < 0)
	        {
	        	return false;
	        }
	        if((param1 >= mypointer.myvector.size())|| (param2 >= mypointer.myvector.size()))
            {
            	return false;
            }
	
	        //param1 contains the number inputed by the user
	        //param2 contains the number inputed by the user
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	        var i:int;
			var Connections_size:int = mypointer.theIterator.Connections.size();
	        for(i = 0; i < Connections_size; i++)
	        {
	            mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	            if(mypointer.theIterator.ConnectIterator.PointID == param2)
	            {
	                return true;
	            }
	        }
	        return false;
	    }
	    
	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
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
	                mypointer.myjourney.removeIndex(mypointer.myjourney.size() - 1);
	                break;
	            case AID_Deletenodjourney:
	                Deletenodjourney(act.getParamExpression(rh, 0));
	                break;
	            case AID_Findjourney:
	                Findjourney(act.getParamExpression(rh, 0));
	                break;
	            case AID_LoadPath:
	                break;
	            case AID_SavePath:
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
	                DoChangeX(act.getParamExpression(rh, 0));
	                break;
	            case AID_ChangeY:
	                DoChangeY(act.getParamExpression(rh, 0));
	                break;
	            case AID_ChangeDirection:
	                DoChangeDirection(act.getParamExpression(rh, 0));
	                break;
	        }
	    }

	    public function creatpathnod(param1:int, param2:int):void
	    {
	        mypointer.myvector.add(new CRunAdvPathMovPoints(param1,param2));
	    }
	    private function removepathnod(param1:int):void
	    {
	        if(distance != 0)
			{
				return;
			}
	        if(mypointer.myjourney.size() != 0)
			{
				return;
			}
	        if(param1 < 1)
			{
				return;
			}
	        if(param1 > mypointer.myvector.size())
			{
				return;
			}
	        mypointer.myvector.removeIndex(param1 - 1);
	        var connectionspot:int;
	        ///Loop through all the vectors!
	
			var i:int, j:int;
			var myvector_size:int = mypointer.myvector.size();
	        for(i = 0;
	           i < myvector_size;
	           i++)
	        {
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(i));
	            connectionspot = -1;
				var iterConn_size:int = mypointer.theIterator.Connections.size();
	            for(j = 0;
	                j < iterConn_size;
	                j++)
	            {
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(j));
	                connectionspot++;
	                if(mypointer.theIterator.ConnectIterator.PointID == param1 - 1){
	                    mypointer.theIterator.Connections.removeIndex(connectionspot);
						iterConn_size = mypointer.theIterator.Connections.size();
	                }
	                if(mypointer.theIterator.ConnectIterator.PointID >= param1 - 1) {
	                    mypointer.theIterator.ConnectIterator.PointID -= 1;
	                }
	            }
	        }
	    }
        public function remove(array:CArrayList, from:int, max:int):void
        {
            var i:int = from;
            while (i <= max)
            {
                array.removeIndex(from);
                i++;
            }
        }
	    public function Clearpath(param1:int):void
	    {
	        ////THIS IS ACTUALLY CLEAR JOURNEY
	        if(mypointer.myjourney.size() < 2)
	        {
	            distance = 0;
	            totaldist = 0;
	            ismoving = false;
	            return;
	        }
	        if(param1 == 0)
	        {
	            mypointer.myjourney.clear();
	            distance = 0;
	            totaldist = 0;
	            ismoving = false;
	            return;
	        }
	        if((param1 == 1) && (distance == 0))
	        {
	            remove(mypointer.myjourney, 1, mypointer.myjourney.size());
	
	            distance = 0;
	            totaldist = 0;
	        }
	
	        if((param1 == 1) && (distance > 0))
	        {
	            remove(mypointer.myjourney, 2, mypointer.myjourney.size());
	        }
	    }
	    public function Connectnods(p1:int, p2:int, p3:Number):void
	    {
	        p1--;
	        p2--;
	        /// Idiot Proof :P
	        if(   p1 < 0
	           || p2< 0
	           ||p1 >= mypointer.myvector.size()
	           ||p2 >= mypointer.myvector.size()
	           || p1 == p2)
	        {return;}
	    //int myval = 0;
	    /////Check for existing connections.
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	
			var i:int;
			var iterConn_size:int = mypointer.theIterator.Connections.size();
	        for(i = 0;
	            i < iterConn_size;
	            i++)
	        {
	            mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	
	            if(mypointer.theIterator.ConnectIterator.PointID == p2 )
	            {
	                mypointer.theIterator.Connections.removeObject(mypointer.theIterator.ConnectIterator);
					iterConn_size = mypointer.theIterator.Connections.size();
	            }
	     //	myval ++;
	        }
	
	    /////
	        //Get second vector
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p2));
	        var v2x:int = mypointer.theIterator.X;
	        var v2y:int = mypointer.theIterator.Y;
	
	        //Get first vector
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	        var v1x:int = mypointer.theIterator.X;
	        var v1y:int = mypointer.theIterator.Y;
	        var deltax:int = v2x - v1x;
	        var deltay:int = v2y - v1y;
	        var distance:Number = Number(Math.sqrt(deltax * deltax + deltay * deltay ));
	        var vectorentry:Number = Number(distance/p3) ;
	        // now stick the data into the first vector
	        if(p3 == 0){p3 = 1;}
	        mypointer.theIterator.Connections.add(new CRunAdvPathMovConnect(p2,vectorentry));
	    }
	
	    public function Addnodjourney(param1:int):void
	    {
	        if(  param1 < 1
	           ||param1 > mypointer.myvector.size() )
	        {return;}
	        if(mypointer.myjourney.size() > 0){
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(mypointer.myjourney.size() - 1));
	            if (param1-1 == mypointer.JourneyIterator.Node){return;}
	        }
	        mypointer.myjourney.add(new CRunAdvPathMovJourney(param1-1));
	    }
	    public function Insertnodjourney(param1:int, param2:int):void
	    {
	        //param1 is the Node
	
	        if(param1 < 0){param1 = 0;}
	        param1--;
	
	        //param2 is the position ( starting at 0 )
	        if(param2 >= mypointer.myjourney.size())
	        {mypointer.myjourney.add(new CRunAdvPathMovJourney(param1));
	            return;
	        }
	
	        if(param2 < 0){param2 = 0;}
	        //param2--;
	        //	int temp;
	        var i:int;
			var myjourney_size:int = mypointer.myjourney.size();
	        for( i = myjourney_size - 1; i >= 0; i--)
	        {
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(i));
	
	            if (i == mypointer.myjourney.size() - 1)
	            {
	                mypointer.myjourney.add( new CRunAdvPathMovJourney(mypointer.JourneyIterator.Node));
					myjourney_size = mypointer.myjourney.size();
	            }
	            else
	            {
	                var temp:int = mypointer.JourneyIterator.Node;
	                mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(i + 1));
	                mypointer.JourneyIterator.Node = temp;
	            }
	
	        }
	
	        mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(param2));
	        mypointer.JourneyIterator.Node = param1;
	    }
	    public function Deletenodjourney(param1:int):void
	    {
	        ///FOOL PROOF
	        if(   param1 < 0
	            ||param1 > mypointer.myjourney.size()   )
	            {return;}
	        ///////////
	
	        if(distance == 0)
	        {
	            mypointer.myjourney.removeIndex(param1);
	        }
	        //param1 contains the number inputed by the user
	    }
	    public function Findjourney( param1:int):void
	    {
	        param1 --;
	        if(param1 < 0)
			{
				return;
			}
	        if(param1 > mypointer.myvector.size() )
			{
				return;
			}
	        if(mypointer.myjourney.size() == 0)
			{
				return;
			}
	
	        /////stuff from the class
	        var ThePoints:CArrayList = new CArrayList();//holds the point numbers
	        var Connection:CArrayList = new CArrayList();//holds which connection id it has
	        var distance:CArrayList = new CArrayList();
	        var Results:CArrayList = new CArrayList();
	        var Get:int;
	        //all ArrayList<Integer>
	
	        var Resultdistance:int=0;
	        var Resultfound:Boolean=false;
	        var TheDistance:int=0;
	        var v:int;
	        
	    //Put the first point into the point array
	        mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(mypointer.myjourney.size() - 1));
	        ThePoints.add(mypointer.JourneyIterator.Node);
	        Connection.add(0);
	        distance.add(0);
	        Resultfound = false;
	
	        var dontstop:Boolean = true;
	        debug = -1;
	
	        while (dontstop)
	        {
	            // Get the point we need to check for connections
	            Get = int(ThePoints.get(ThePoints.size() - 1));
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(Get));
	            // Check the point
	            //check that there will be another conection spot
	            if(mypointer.theIterator.Connections.size() > int(Connection.get(Connection.size() - 1)) )
	            {
	                //Select the next connection point
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get((int(Connection.get(Connection.size() - 1)))));
	
	
	        /// We look through all the points used so far ( this is necassary so not to go over the same point twice)
	                var worked:Boolean = true;
	                var Currentpos:int;
	                for(Currentpos = 0 ;
	                    Currentpos < ThePoints.size();
	                    Currentpos++)
	                {
	                    Get = int(ThePoints.get(Currentpos));
	
	                    if(mypointer.theIterator.ConnectIterator.PointID == Get)
	                    {
	                        worked = false;
	
	                        if(ThePoints.size() == 0){
	                            dontstop = false;
	                        }else{
	                            v= int(Connection.get(Connection.size() - 1));
	                            Connection.set(Connection.size() - 1, v + 1);
	                        }
	                    }
	                }
	                //// MUST STICK SOMETHING IN HERE FOR ADDING TO THE DISTANCE
	                if(worked)
	                {
	                    ThePoints.add(mypointer.theIterator.ConnectIterator.PointID);
	                    distance.add(int(mypointer.theIterator.ConnectIterator.Distance));
	                    TheDistance += mypointer.theIterator.ConnectIterator.Distance;
	
	                    Connection.add(0);
	                    if(TheDistance > Resultdistance && Resultfound ==true)
	                    {
	                       Connection.removeIndex(Connection.size() - 1);
	                       TheDistance -= int(distance.get(distance.size() - 1));
	                       distance.removeIndex(distance.size() - 1);
	                       ThePoints.removeIndex(ThePoints.size() - 1);
	                       v= int(Connection.get(Connection.size() - 1));
	                       Connection.set(Connection.size() - 1, (v + 1));
	                    }
	                    ///check if the point we have just added is the one we are after
	                    Get = int(ThePoints.get(ThePoints.size() - 1));
	                    if(Get == param1)
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
	
	                       if(Resultdistance > TheDistance || Resultfound == false )
	                       {
	                           Resultfound = true;
	                           Resultdistance = TheDistance;
	                           Results.clear();
	
	                       //////Now we must stick the distance in the vector and copy all the points
	                       		var y:int;
	                           for(y = 0;y<ThePoints.size();y++)
	                           {
	                                Get = int(ThePoints.get(y));
	                                Results.add(Get);
	                           }
	                       }
	                       Connection.removeIndex(Connection.size() - 1);
	                       TheDistance -= int(distance.get(distance.size() - 1));
	                       distance.removeIndex(distance.size() - 1);
	                       ThePoints.removeIndex(ThePoints.size() - 1);
	                       v= int(Connection.get(Connection.size() - 1));
	                       Connection.set(Connection.size() - 1, (v + 1));
	                    }
	                }
	            }else{
	                ThePoints.removeIndex(ThePoints.size() - 1);
	                Connection.removeIndex(Connection.size() - 1);
	                TheDistance -= int(distance.get(distance.size() - 1));
	                distance.removeIndex(distance.size() - 1);
	                if(ThePoints.size() == 0){
	                    dontstop = false;
	                }else{
	                    v= int(Connection.get(Connection.size() - 1));
	                    Connection.set(Connection.size() - 1, v + 1);
	                }
	            }
	        }
	
	        ///Now we have found all the paths, we must stick them into the journey:)
	
			var z:int;
	        for(z = 1;z< Results.size();z++)
	        {
	            Get = int(Results.get(z));
	            mypointer.myjourney.add( new CRunAdvPathMovJourney(Get));
	        }
	            //param1 contains the number inputed by the user
	        Results.clear();
	        ThePoints.clear();
	        Connection.clear();
	        distance.clear();
	        debug = ThePoints.size() + Connection.size() + distance.size() + Results.size();
	
	    }
	
	
	    public function MovementStart():void
	    {
	        if (mypointer.myjourney.size() < 1)
	        {
	            return;
	        }
	        ismoving = true;
	        muststop = false;
	
	        //Set the iterator to the first journey step
	        mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	        //Now we know what the current point has to be :)
	        var FirstNode:int = mypointer.JourneyIterator.Node;
	        var NextNode:int = 0;
	        if (mypointer.myjourney.size() > 1)
	        {
	             mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(1));
	            //Now we what what the next point is going to be :)
	            NextNode = mypointer.JourneyIterator.Node;
	        }
	
	        var connectfound:Boolean = false;
	
	        //now we select the first point
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	        //Great...now we need to run through all the connections and find the right one
	        var i:int;
	        for (i = 0;
	             i < mypointer.theIterator.Connections.size();
	             i++)
	         {
	            mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	             if( mypointer.theIterator.ConnectIterator.PointID == NextNode)
	             {
	                  totaldist = mypointer.theIterator.ConnectIterator.Distance;
	                  connectfound = true;
	             }
	         }
	         if(connectfound == false ){
	            ismoving = false;
	            distance = 0;
	            muststop = false;
	            totaldist = 0;
	         }
	    }
	    public function Setspeed(speed:Number):void
	    {
	        if(speed <= 0){return;}
	        speed = speed;
	    }
	    public function Setobject(object:CObject):void
	    {
	        myObject = object;
	    }
	    public function Forcemovexsteps(p1:Number):void
	    {
	        if(p1 <= 0){
	            return;
	        }
	        var oldspeed:Number = speed;
	        speed = p1;
	
	        ///////////////////////////////////////////////////
	        //////////////////////////////////////////////////
	        /////////////////////////////////////////////////
	        ////////////////////////////////////////////////
	        ///////////////////////////////////////////////
	        //////////////////////////////////////////////
	        if(mypointer.myjourney.size() == 1)
	        {
	        //	MessageBox(NULL,"Hi",NULL,NULL);
	            //This is so the object is at the first point if its not moving.
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(mypointer.JourneyIterator.Node));
	            x = mypointer.theIterator.X;
	            y = mypointer.theIterator.Y;
	            if(ChangeX == true ){myObject.hoX = x;}
	            if(ChangeY == true ){myObject.hoY = y;}
	            myObject.roc.rcChanged = true;
	        }
	
	        if(ismoving == false) { return; }
	
	        distance += speed;
	
	        var FirstNode:int = 0;
	        var NextNode:int  = 0;
	        var connectfound:Boolean = false;
	        while((ismoving == true) && (distance >= totaldist))
	        {
	            //Take away the distance travelled so far :)
	            mypointer.myjourney.removeIndex(0);
	
	            ////Calculate position ( for when it touches a new node )
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            FirstNode = mypointer.JourneyIterator.Node;
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	            x = mypointer.theIterator.X + xoffset;
	            y = mypointer.theIterator.Y + yoffset;
	
	            if(ChangeX == true ){myObject.hoX = x;}
	            if(ChangeY == true ){myObject.hoY = y;}
	
	            myObject.roc.rcChanged = true;
	            ho.generateEvent(CID_touchednewnod, ho.getEventParam());
	            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 4, 0);
	
				if(mypointer.myjourney.size() <= 1
					|| muststop ==true){
					ismoving = false;
					distance = 0;
					muststop = false;
					totaldist = 0;
	                ho.generateEvent(CID_Hasreachedend, ho.getEventParam());
		            //callRunTimeFunction(rdPtr, RFUNCTION_GENERATEEVENT, 3, 0);
				}
	            if(ismoving == true)
	            {
	                distance -= totaldist;
	
	                //Set the iterator to the first journey step
	                mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	                //Now we know what the current point has to be :)
	                FirstNode = mypointer.JourneyIterator.Node;
	                mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(1));
	                //Now we what what the next point is going to be :)
	                NextNode = mypointer.JourneyIterator.Node;
	
	                //now we select the first point
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	                //Great...now we need to run through all the connections and find the right one
	                var i:int;
	                for (i = 0;
	                     i < mypointer.theIterator.Connections.size();
	                     i++){
	                    mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                    if( mypointer.theIterator.ConnectIterator.PointID == NextNode)
	                    {
	                         totaldist = mypointer.theIterator.ConnectIterator.Distance;
	                         connectfound = true;
	                    }
	                 }
	                 if(connectfound == false ){
	                    ismoving = false;
	                    distance = 0;
	                    muststop = false;
	                    totaldist = 0;
	                 }
	            }
	        }
	        if((ismoving == true) && (distance != 0))
	        {
	            ////Get points
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(0));
	            //Now we know what the current point has to be :)
	            FirstNode = mypointer.JourneyIterator.Node;
	            mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(1));
	            //Now we want what the next point is going to be :)
	            NextNode = mypointer.JourneyIterator.Node;
	
	
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(FirstNode));
	            var x1:int = mypointer.theIterator.X;
	            var y1:int = mypointer.theIterator.Y;
	
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(NextNode));
	            var x2:int = mypointer.theIterator.X;
	            var y2:int = mypointer.theIterator.Y;
	            var deltax:int= x2 - x1;
	            var deltay:int= y2 - y1;
	
	            /////Below need to go in main
	
	            if(totaldist!= 0){
	                var myval:Number = (Math.atan2((deltax+0.0),(deltay+0.0))/3.1415926535897932384626433832795 * 180);
	                angle = (int)(180-myval);
	            }
	
	
	        ///////////////////////////End
	
	
	            /////Below need to go in main
	            if(totaldist!=0)
	            {
	                x = int(x1 + deltax * (distance / totaldist )+xoffset);
	                y = int(y1 + deltay * (distance / totaldist )+yoffset);
	                if(ChangeX == true ){myObject.hoX = x;}
	                if(ChangeY == true ){myObject.hoY = y;}
	
	                if(ChangeDirection == true )
	                {
	                    var direction:int = (angle *32+180)/ 360;
	                    direction = 8-direction;
	                    if ( direction < 0){direction +=32;}
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
	    public function SetNodeX(param1:int, param2:int):void
	    {
	        param1--; // 1 based index convert to 0 based
	        //use param1
	          // and 2
	        var i:int, j:int;
			var X1:int;
            var Y1:int;
            var Olddist:Number;
            var vecspeed:Number;
            var Newdist:Number; 	        
	        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
	        {
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	            var OldX:int = mypointer.theIterator.X;
	            var OldY:int = mypointer.theIterator.Y;
	            mypointer.theIterator.X = param2;
	            var NewX:int = mypointer.theIterator.X;
	            var NewY:int = mypointer.theIterator.Y;
	
	            for(i = 0;
	                i < mypointer.myvector.size();
	                i++){
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(i));
	                if(mypointer.theIterator != CRunAdvPathMovPoints(mypointer.myvector.get(param1)))
	                {
	                    for (j = 0;
	                        j < mypointer.theIterator.Connections.size();
	                        j++){
	                        mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(j));
	                        if( mypointer.theIterator.ConnectIterator.PointID == param1)
	                        {
	                            //we need to figure the speed
	                            X1 = mypointer.theIterator.X;
	                            Y1 = mypointer.theIterator.Y;
	                            Olddist = (Math.sqrt((X1 -OldX )*(X1 -OldX )+ (Y1 -OldY )*(Y1 -OldY )));
	                            vecspeed = mypointer.theIterator.ConnectIterator.Distance / Olddist;
	                            Newdist = (Math.sqrt((X1 -NewX )*(X1 -NewX ) + (Y1 -NewY )*(Y1 -NewY )));
	                            mypointer.theIterator.ConnectIterator.Distance = vecspeed*Newdist;
	                        }
	                    }
	                }
	            }
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	
	
	            for(i = 0;
	                i < mypointer.theIterator.Connections.size();
	                i++)
	            {
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                //rdPtr->mypointer->theIterator->ConnectIterator = rdPtr->mypointer->theIterator->Connections.begin() + temp;
	
	                var Distancexspeed:Number = mypointer.theIterator.ConnectIterator.Distance;
	
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(mypointer.theIterator.ConnectIterator.PointID));
	                X1 = mypointer.theIterator.X;
	                Y1 = mypointer.theIterator.Y;
	                Olddist = (Math.sqrt((X1 -OldX )*(X1 -OldX ) + (Y1 -OldY )*(Y1 -OldY )));
	                vecspeed = Distancexspeed / Olddist;
	                Newdist = (Math.sqrt((X1 -NewX )*(X1 -NewX ) + (Y1 -NewY )*(Y1 -NewY )));
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	                mypointer.theIterator.ConnectIterator.Distance = vecspeed*Newdist;
	
	            }
	        }
	    }
	
	    public function SetNodeY(param1:int, param2:int):void
	    {
	        param1--; // 1 based index convert to 0 based
	        //use param1
	          // and 2
	        var i:int, j:int;
			var X1:int;
            var Y1:int;
            var Olddist:Number;
            var vecspeed:Number;
            var Newdist:Number; 	        

	        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
	        {
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	            var OldX:int = mypointer.theIterator.X;
	            var OldY:int = mypointer.theIterator.Y;
	            mypointer.theIterator.Y = param2;
	            var NewX:int = mypointer.theIterator.X;
	            var NewY:int = mypointer.theIterator.Y;
	
	            for(i = 0;
	                i < mypointer.myvector.size();
	                i++) {
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(i));
	                    // For points that are connected to the just moved one we need to update
	                if(mypointer.theIterator != CRunAdvPathMovPoints(mypointer.myvector.get(param1)))
	                {
	
	                    for (j = 0;
	                        j < mypointer.theIterator.Connections.size();
	                        j++){
	                        mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(j));
	                        if(mypointer.theIterator.ConnectIterator.PointID == param1)
	                        {
	                            //we need to figure the speed
	                            X1 = mypointer.theIterator.X;
	                            Y1 = mypointer.theIterator.Y;
	                            Olddist = (Math.sqrt((X1 -OldX )*(X1 -OldX )+ (Y1 -OldY )*(Y1 -OldY )));
	                            vecspeed = mypointer.theIterator.ConnectIterator.Distance / Olddist;
	                            Newdist = (Math.sqrt((X1 -NewX )*(X1 -NewX ) + (Y1 -NewY )*(Y1 -NewY )));
	                            mypointer.theIterator.ConnectIterator.Distance = vecspeed*Newdist;
	                        }
	                    }
	                }
	            }
	            ///Ok now we must update the point so all the things its connected to will change
	
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	
	            for(i = 0;
	                i < mypointer.theIterator.Connections.size();
	                i++){
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                //rdPtr->mypointer->theIterator->ConnectIterator = rdPtr->mypointer->theIterator->Connections.begin() + temp;
	
	                var Distancexspeed:Number = mypointer.theIterator.ConnectIterator.Distance;
	
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(mypointer.theIterator.ConnectIterator.PointID));
	                X1 = mypointer.theIterator.X;
	                Y1 = mypointer.theIterator.Y;
	                Olddist = (Math.sqrt((X1 -OldX )*(X1 -OldX ) + (Y1 -OldY )*(Y1 -OldY )));
	                vecspeed = Distancexspeed / Olddist;
	                Newdist = (Math.sqrt((X1 -NewX )*(X1 -NewX ) + (Y1 -NewY )*(Y1 -NewY )));
	                mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
	                mypointer.theIterator.ConnectIterator.Distance = vecspeed*Newdist;
	
	            }
	        }
	    }
	    public function Disconnectnode(param1:int, param2:int):void
	    {
	        param1--;
	        param2--;
		//param 1 and param 2
	        if ((param1 >= 0) && (param1 < mypointer.myvector.size()))
	        {
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(param1));
				
				var i:int;
	            for(i = 0;
	                i < mypointer.theIterator.Connections.size();
	                i++) {
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                if(mypointer.theIterator.ConnectIterator.PointID == param2)
	                {
	                    mypointer.theIterator.Connections.removeObject(mypointer.theIterator.ConnectIterator);
	           //         rdPtr->mypointer->theIterator->ConnectIterator--;
	                }
	            }
	        }
	    }
	    public function ClearJourney():void
	    {
	        ////THIS IS ACTUALLY CLEAR PATH!!!!!!
	        mypointer.myvector.clear();
	        mypointer.myjourney.clear();
	        ismoving = false;
	    }
	    public function DoChangeX(param1:int):void
	    {
	        if(param1==1){ChangeX = true;}
	        if(param1==0){ChangeX = false;}
	    }
	    public function DoChangeY(param1:int):void
	    {
	        if(param1==1){ChangeY = true;}
	        if(param1==0){ChangeY = false;}
	    }
	    public function DoChangeDirection(param1:int):void
	    {
	        if(param1==1){ChangeDirection = true;}
	        if(param1==0){ChangeDirection = false;}
	    }
	
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
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

	    public function Findnode(p1:int, p2:int, p3:int):CValue
	    {
	        var Answer:int = p3*p3;
	        var result:int = 0;
	        var deltaX:int = 0;
	        var deltaY:int = 0;
	        var loopcount:int =0;
	
			var i:int;
	        for(i = 0;
	            i < mypointer.myvector.size();
	            i++)
	        {
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(i));
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
	
	    public function GetJourneynode(p1:int):CValue
	    {
	        if(p1 < 0){return new CValue(0);}
	        if(mypointer.myjourney.size() == 0){return new CValue(0);}
	        if(p1 >= mypointer.myjourney.size() ){return new CValue(0);}
	        mypointer.JourneyIterator = CRunAdvPathMovJourney(mypointer.myjourney.get(p1));
	        return new CValue(mypointer.JourneyIterator.Node + 1);
	    }
	    public function NodeDistance(p1:int, p2:int):CValue
	    {
	        p1 --;
	        p2 --;
	        if ((p1 >= 0) && (p1 < mypointer.myvector.size()) &&
	            (p2 >= 0) && (p2 < mypointer.myvector.size())){
	            //Get second vector
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p2));
	            var v2x:int = mypointer.theIterator.X;
	            var v2y:int = mypointer.theIterator.Y;
	
	            //Get first vector
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	            var v1x:int = mypointer.theIterator.X;
	            var v1y:int = mypointer.theIterator.Y;
	            var deltax:int = v2x - v1x;
	            var deltay:int = v2y - v1y;
	            var distance:Number = Math.sqrt(deltax * deltax + deltay * deltay );
	            var ret:CValue=new CValue(0);
	            ret.forceDouble(distance);
	            return ret;
	        }
	        return new CValue(0);
	    }
	    public function NodeX(p1:int):CValue
	    {
	        if(p1 < 1){return new CValue(0);}
	        if(mypointer.myvector.size() == 0){return new CValue(0);}
	        if(p1 > mypointer.myvector.size() ){return new CValue(0);}
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1 - 1));
	        return new CValue(mypointer.theIterator.X);
	    }
	    public function NodeY(p1:int):CValue
	    {
	        if(p1 < 1){return new CValue(0);}
	        if(mypointer.myvector.size() == 0){return new CValue(0);}
	        if(p1 > mypointer.myvector.size() ){return new CValue(0);}
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1 - 1));
	        return new CValue(mypointer.theIterator.Y);
	    }
	    public function GetDirection():CValue
	    {
	        var direction:int = (angle *32+180)/ 360;
	        direction = 8-direction;
	        if ( direction < 0){direction +=32;}
	        return new CValue(direction);
	    }
	    public function Getconnection(p1:int, p2:int):CValue
	    {
	        p1--;
	        if(p1 < 0){return new CValue(0);}
	        if(p1 >= mypointer.myvector.size()){return new CValue(0);}
	
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	        if(p2 < 0){return new CValue(0);}
	        if(mypointer.theIterator.Connections.size() <= p2){return new CValue(0);}
	        mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(p2));
	        return new CValue(mypointer.theIterator.ConnectIterator.PointID + 1);
	    }
	    public function GetNumberconnections(p1:int):CValue
	    {
	        p1--;
	        if(p1 < 0){return new CValue(0);}
	        if(p1 >= mypointer.myvector.size()){return new CValue(0);}
	        mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	        return new CValue(mypointer.theIterator.Connections.size());
	    }
	    public function GetNodesSpeed(p1:int, p2:int):CValue
	    {
	        p1--;
	        p2--;
	        var speed:Number = 0;
	        var cont:Boolean = true;
	        var ret:CValue=new CValue(0);
	        ret.forceDouble(0.0);
	        
	        //param1 contains the number inputed by the user
	        //param2 contains the number inputed by the user
	        if ((p1 >= 0) && (p1 < mypointer.myvector.size()) &&
	            (p2 >= 0) && (p2 < mypointer.myvector.size())){
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	            var i:int;
	            for(i = 0;
	                i < mypointer.theIterator.Connections.size();
	                i++)
	            {
	                mypointer.theIterator.ConnectIterator = CRunAdvPathMovConnect(mypointer.theIterator.Connections.get(i));
	                if(mypointer.theIterator.ConnectIterator.PointID == p2)
	                {
	                    speed = mypointer.theIterator.ConnectIterator.Distance;
	                    cont = false;
	                }
	            }
	
	            if (cont)
	            {
	            	return ret;
	            }
	            //Get second vector
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p2));
	            var v2x:int = mypointer.theIterator.X;
	            var v2y:int = mypointer.theIterator.Y;
	
	            //Get first vector
	            mypointer.theIterator = CRunAdvPathMovPoints(mypointer.myvector.get(p1));
	            var v1x:int = mypointer.theIterator.X;
	            var v1y:int = mypointer.theIterator.Y;
	            var deltax:int = v2x - v1x;
	            var deltay:int = v2y - v1y;
	            var distance:Number = Math.sqrt(deltax * deltax + deltay * deltay );
	            if(distance == 0)	            
	           	{
	           		ret.forceDouble(1.0);
	                return ret;
	            }
	            ret.forceDouble(distance/speed);
	            return ret;
	        }
	        return ret;
	    }
	

	}
}