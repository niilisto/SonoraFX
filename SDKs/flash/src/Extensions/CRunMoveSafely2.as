//----------------------------------------------------------------------------------
//
// CRUNMOVESAFELY2 : MoveSafely object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.*;
	import flash.utils.*;
	
	public class CRunMoveSafely2 extends CRunExtension
	{
    	private static var CID_OnSafety:int	=	0;
    	private static var AID_Prepare:int	=	0;
    	private static var AID_Start:int	=	1;
    	private static var AID_Stop:int		=	2;
    	private static var AID_SetObject:int=	3;
    	private static var AID_Stop2:int	=	4;
    	private static var AID_Setdist:int	=	5;
    	private static var AID_Reset:int	=	6;
    	private static var EID_GetX:int		=	0;
    	private static var EID_GetY:int		=		1;
    	private static var EID_Getfixed:int	=	2;
    	private static var EID_GetNumber:int=	3;
    	private static var EID_GetIndex:int	=	4;
    	private static var EID_Getdist:int	=	5;
		
    	public var mypointer:CRunMoveSafely2myclass;
    	public var X:int;
    	public var Y:int;
    	public var NewX:int;
    	public var NewY:int;
    	public var Debug:int;
    	public var Temp:int;
    	public var Temp2:int;
    	public var Loopindex:int;
    	public var Dist:int;
    	public var hasstopped:Boolean;
    	public var inobstacle:Boolean;
    	public var last:Boolean;

		public function CRunMoveSafely2()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 1;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        this.Dist = 1;
	        this.mypointer = new CRunMoveSafely2myclass();
	        return true;
	    }

	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        if (num == CID_OnSafety)
	        {
	            return true;
	        }
	        return false;
	    }

	    public override function action(num:int, act:CActExtension):void
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
	    private function Prepare():void
	    {
	    	var i:int;
	        for (i = 0; i < mypointer.Mirrorvector.size(); i++)
	        {
	            mypointer.iterator = CRunMoveSafely2CloneObjects(mypointer.Mirrorvector.get(i));
	            mypointer.iterator.OldX = mypointer.iterator.obj.hoX;
	            mypointer.iterator.OldY = mypointer.iterator.obj.hoY;
	        }
	    }
	    private function Start():void
	    {
	    	var i:int;
	        for (i = 0; i < mypointer.Mirrorvector.size(); i++)
	        {
	            mypointer.iterator = CRunMoveSafely2CloneObjects(mypointer.Mirrorvector.get(i));
	            mypointer.iterator.NewX = mypointer.iterator.obj.hoX;
	            mypointer.iterator.NewY = mypointer.iterator.obj.hoY;
	            X =  mypointer.iterator.OldX;
	            Y =  mypointer.iterator.OldY;
	            mypointer.iterator.obj.hoX = X;
	            mypointer.iterator.obj.hoY = Y;
	        }
	        for (i = 0; i < mypointer.Mirrorvector.size(); i++)
	        {
	            Loopindex = 0;
	            mypointer.iterator = CRunMoveSafely2CloneObjects(mypointer.Mirrorvector.get(i));
	            NewX =	mypointer.iterator.NewX;
	            NewY = 	mypointer.iterator.NewY;
	            Temp = Math.max(Math.abs(mypointer.iterator.OldX - NewX),
	                    Math.abs(mypointer.iterator.OldY - NewY));
	            if (Temp != 0) 
	            {
					Temp2 = 1;
					var first:Boolean = true;
					last = false;
					var doit:Boolean = true;
					while(true) 
					{
	                    if (!first)
	                        Temp2 += mypointer.iterator.Dist;
	                    if (first)
	                        first = false;
	                    if (Temp2 < Temp)
	                        doit = true;
	                    if (Temp2 >= Temp)
	                        doit = false;
	
	                    if(!doit && !last)
	                    {
	                        last = true;
	                        doit=true;
	                        Temp2 = Temp;
	                    }
	                    if(!doit)
	                        break;
	                    var x:int = NewX   -   mypointer.iterator.OldX ;
	                    var y:int = NewY   -   mypointer.iterator.OldY;
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
	
	    private function Stop():void
	    {
	        //If the below happens, we are using the 'push out of obsticle' ruitine.
			if(hasstopped) 
			{
	            inobstacle = true;
	            return;
	        }
	        //If the below happens, then we have specified for a 'push out of obstacle' routine.
	
			//I will need to make a loop, if the 'has stopped' is true, then you are still in an obstacle
			//if it's false, then you CAN stop the object moving :D
	        hasstopped = true;
	        inobstacle = true;
	        var loop:int = 0;
	        if  (mypointer.iterator != null)
	        {
	            while (inobstacle)
	            {
	                loop++;
	                inobstacle = false;
	
	                var x:int = NewX   -   mypointer.iterator.OldX;
	                var y:int = NewY   -   mypointer.iterator.OldY;
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
	    
	    private function SetObject(object:CObject, distance:int):void
	    {
	    	if (object!=null)
	    	{
	        	mypointer.Mirrorvector.add(new CRunMoveSafely2CloneObjects(object, distance));
	    	}
	    }
	    private function Stop2():void
	    {
	        //If the below happens, we are using the 'push out of obsticle' ruitine.
	        if(hasstopped) 
	        {
	            inobstacle = true;
	            return;
	        }
	        //stop movin
	        Temp2 = Temp;
	        if (mypointer.iterator != null)
	        {
	            mypointer.iterator.obj.roc.rcChanged = true;
	        }
	    }
	    private function SetDist(dist:int):void
	    {
	        Dist = dist;
	    }
	    private function Reset():void
	    {
	        mypointer.Mirrorvector.clear();
	        mypointer.iterator = null;
	    }

	    public override function expression(num:int):CValue
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
	
	    private function Getfixed():CValue
	    {
	        if (mypointer.iterator != null)
	        {
	            return new CValue((mypointer.iterator.obj.hoCreationId << 16) + mypointer.iterator.obj.hoNumber);
	        }
	        return new CValue(0);
	    }
	}
}