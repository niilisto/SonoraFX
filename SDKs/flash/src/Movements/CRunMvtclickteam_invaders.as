//----------------------------------------------------------------------------------
//
// CRUNMVTINVADERS
//
	//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Extensions.*;
	
	import Objects.*;
	
	import Services.*;

	public class CRunMvtclickteam_invaders extends CRunMvtExtension
	{
	    public static var IDENTIFIER:int=2;

		public function CRunMvtclickteam_invaders()
		{
		}

	    public override function initialize(file:CBinaryFile):void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data == null)
	        {
	            file.skipBytes(1);
	            var m_dwFlagMoveAtStart:int = file.readInt();
	            var m_dwFlagAutoSpeed:int = file.readInt();
	            var m_dwInitialDirection:int = file.readInt();
	            var m_dwDX:int = file.readInt();
	            var m_dwDY:int = file.readInt();
	            var m_dwSpeed:int = file.readInt();
	            var m_dwGroup:int = file.readInt();
	
	            data = new CRunMvtGlobalDataInvader();
	            data.count = 0;
	
	            if (m_dwFlagMoveAtStart == 1)
	            {
	                data.isMoving = true;
	            }
	            else
	            {
	                data.isMoving = false;
	            }
	
	            data.autoSpeed = m_dwFlagAutoSpeed == 1;
	            data.dx = m_dwDX;
	            data.dy = m_dwDY;
	            data.minX = 0;
	            data.maxX = ho.hoAdRunHeader.rhLevelSx;
	            data.initialSpeed = m_dwSpeed;
	            if (m_dwInitialDirection == 0)
	            {
	                data.cdx = -data.dx;
	            }
	            else
	            {
	                data.cdx = data.dx;
	            }
	            data.speed = 101 - data.initialSpeed;
	
	            data.myList = new CArrayList();
	            rh.addStorage(data, IDENTIFIER);
	        }
	        //*** Adds this object to the end of our list
	        data.count++;
	        data.myList.add(ho);
	    }

	    public override function kill():void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            var n:int;
	            for (n = 0; n < data.myList.size(); n++)
	            {
	                var obj:CObject = CObject(data.myList.get(n));
	                if (obj == CObject(ho))
	                {
	                    data.myList.removeIndex(n);
	                    break;
	                }
	            }
	            data.count--;
	            if (data.count == 0)
	            {
	                rh.delStorage(IDENTIFIER);
	            }
	        }
	    }

	    public override function move():Boolean
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            if (!data.isMoving)
	            {
	                return false;
	            }
	            if (data.myList.size() > 0)
	            {
	                var myObject:CObject = CObject(data.myList.get(0));
	                if (myObject == ho)
	                {
	                    data.frames++;
	                    if (data.frames % data.speed == 0)
	                    {
	                        data.cdy = 0;
	
	                        //*** Loop over all objects to ensure non have left the playing field
	                        var index:int;
	                        var hoPtr:CObject;
	                        for (index = 0; index < data.myList.size(); index++)
	                        {
	                            hoPtr = CObject(data.myList.get(index));
	                            if ((hoPtr.hoX < data.minX + hoPtr.hoImgXSpot) && data.cdx < 0)
	                            {
	                                data.cdx = data.dx;
	                                data.cdy = data.dy;
	                                break;
	                            }
	                            else if (hoPtr.hoX > (data.maxX + hoPtr.hoImgXSpot - hoPtr.hoImgWidth) && data.cdx > 0)
	                            {
	                                data.cdx = -data.dx;
	                                data.cdy = data.dy;
	                                break;
	                            }
	                        }
	
	                        //*** Loop over all objects and move them
	                        for (index = 0; index < data.myList.size(); index++)
	                        {
	                            hoPtr = CObject(data.myList.get(index));
	                            if (data.cdy != 0)
	                            {
	                                hoPtr.hoY = (hoPtr.hoY + data.cdy);
							        ho.roc.rcAnim = CAnim.ANIMID_WALK;
	                                if (hoPtr.roa!=null)
	                                {
	                                	hoPtr.roa.animations();
	                                }
	                                moveIt();
	                            }
	                            else
	                            {
	                                hoPtr.hoX = (hoPtr.hoX + data.cdx);
							        ho.roc.rcAnim = CAnim.ANIMID_WALK;
	                                if (hoPtr.roa!=null)
	                                {
	                                	hoPtr.roa.animations();
	                                }
	                                moveIt();
	                            }
	                        }
	                    }
	                }
	            }
	            //*** Objects have been moved return true
	            if (data.frames % data.speed == 0)
	            {
	                return true;
	            }
	        }
	        //** The object has not been moved
	        return false;
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        ho.hoX = x;
	        ho.hoY = y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        ho.hoX = x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        ho.hoY = y;
	    }

	    public override function stop(bCurrent:Boolean):void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            data.isMoving = false;
	        }
    	}

	    public override function reverse():void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            data.cdx *= -1;
	        }
	    }
	
	    public override function start():void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            data.isMoving = true;
	        }
	    }

	    public override function setSpeed(speed:int):void
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            data.speed = 101 - speed;
	            if (data.speed < 1)
	            {
	                data.speed = 1;
	            }
	        }
	    }

	    public override function actionEntry(action:int):Number
	    {
	        var data:CRunMvtGlobalDataInvader = CRunMvtGlobalDataInvader(rh.getStorage(IDENTIFIER));
	        if (data == null)
	        {
	            return 0;
	        }
	
	        var param:int;
	        switch (action)
	        {
	            case 3745:		// SET_INVADERS_SPEED = 3745,
	                param = getParamDouble();
	                data.speed = param;
	                if (data.speed < 1)
	                {
	                    data.speed = 1;
	                }
	                break;
	            case 3746:		// SET_INVADERS_STEPX,
	                param = getParamDouble();
	                data.dx = param;
	                break;
	            case 3747:		// SET_INVADERS_STEPY,
	                param = getParamDouble();
	                data.dy = param;
	                break;
	            case 3748:		// SET_INVADERS_LEFTBORDER,
	                param = getParamDouble();
	                data.minX = param;
	                break;
	            case 3749:		// SET_INVADERS_RIGHTBORDER,
	                param = getParamDouble();
	                data.maxX = param;
	                break;
	            case 3750:		// GET_INVADERS_SPEED,
	                return data.speed;
	            case 3751:		// GET_INVADERS_STEPX,
	                return data.dx;
	            case 3752:		// GET_INVADERS_STEPY,
	                return data.dy;
	            case 3753:		// GET_INVADERS_LEFTBORDER,
	                return data.minX;
	            case 3754:		// GET_INVADERS_RIGHTBORDER,
	                return data.maxX;
	        }
	        return 0;
	    }

	}
}