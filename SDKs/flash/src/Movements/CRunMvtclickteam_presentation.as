//----------------------------------------------------------------------------------
//
// CRUNMVTPRESENTAION
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Application.*;
	
	import Extensions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;

	public class CRunMvtclickteam_presentation extends CRunMvtExtension
	{
	    public static var IDENTIFIER:int=3;
	    
		//*** Fly In/Out effects
	    public static var FLYEFFECT_NONE:int = 0;
	    public static var FLYEFFECT_APPEAR:int=1;
	    public static var FLYEFFECT_BOTTOM:int=2;
	    public static var FLYEFFECT_LEFT:int=3;
	    public static var FLYEFFECT_RIGHT:int=4;
	    public static var FLYEFFECT_TOP:int=5;
	
		//*** Movement status
	    public static var STOPPED:int = 0;
	    public static var ENTRANCE:int=1;
	    public static var EXIT:int=2;
	
		//*** Speed
	    public static var SPEED_VERYSLOW:int = 0;
	    public static var SPEED_SLOW:int=1;
	    public static var SPEED_MEDIUM:int=2;
	    public static var SPEED_FAST:int=3;
	    public static var SPEED_VERYFAST:int=4;
	
		//*** Global settings
	    public static var GLOBAL_AUTOCONTROL:int = 1;
	    public static var GLOBAL_AUTOFRAMEJUMP:int = 2;
	    public static var GLOBAL_AUTOCOMPLETE:int = 4;
	
	    public var m_dwEntranceType:int;
	    public var m_dwEntranceSpeed:int;
	    public var m_dwEntranceOrder:int;
	    public var m_dwExitType:int;
	    public var m_dwExitSpeed:int;
	    public var m_dwExitOrder:int;
	    public var m_dwFlagsGlobalSettings:int;
	    
	    public var pLPHO:CObject;
	    public var initialX:int;
	    public var initialY:int;
	    public var startEntranceX:int;
	    public var startEntranceY:int;
	    public var entranceEffect:int;
	    public var entranceOrder:int;
	    public var entranceSpeed:int;
	    public var entranceSpeedX:Number;
	    public var entranceSpeedY:Number;
	    public var finalExitX:int;
	    public var finalExitY:int;
	    public var exitEffect:int;
	    public var exitOrder:int;
	    public var exitSpeed:int;
	    public var exitSpeedX:Number;
	    public var exitSpeedY:Number;
	    public var isMoving:int;
	    
	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	        m_dwEntranceType = file.readInt();
	        m_dwEntranceSpeed = file.readInt();
	        m_dwEntranceOrder = file.readInt();
	        m_dwExitType = file.readInt();
	        m_dwExitSpeed = file.readInt();
	        m_dwExitOrder = file.readInt();
	        m_dwFlagsGlobalSettings = file.readInt();
	
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data == null)
	        {
	            data = new CRunMvtGlobalPres();
	            data.count = 1;
	            rh.addStorage(data, IDENTIFIER);
	            data.myList = new CArrayList();
	        }
	
	        // Store pointer to edit data
	        pLPHO = ho;
	        initialX = ho.hoX;
	        initialY = ho.hoY;
	        isMoving = STOPPED;
	
	        //*** Adds this object to the end of our list
	        data.myList.add(this);
	
	        data.autoControl = ((m_dwFlagsGlobalSettings & GLOBAL_AUTOCONTROL) != 0);
	        data.autoFrameJump = ((m_dwFlagsGlobalSettings & GLOBAL_AUTOFRAMEJUMP) != 0);
	        data.autoComplete = ((m_dwFlagsGlobalSettings & GLOBAL_AUTOCOMPLETE) != 0);
	    }

	    public function reset(data:CRunMvtGlobalPres):void
	    {
	        //*******************************************
	        //*** Entrance parameters *******************
	        //*******************************************
	        entranceEffect = m_dwEntranceType;
	        entranceOrder = m_dwEntranceOrder;
	
	        if (entranceOrder == 0 && entranceEffect != FLYEFFECT_NONE)
	        {
	            isMoving = ENTRANCE;
	        }
	
	        if (entranceOrder > data.finalOrder && entranceEffect != FLYEFFECT_NONE)
	        {
	            data.finalOrder = entranceOrder;
	        }
	
	        switch (m_dwEntranceSpeed)
	        {
	            case 0:	    // SPEED_VERYSLOW:
	                entranceSpeed = 1;
	                break;
	            case 1:	    // SPEED_SLOW:
	                entranceSpeed = 2;
	                break;
	            case 2:	    // SPEED_MEDIUM:
	                entranceSpeed = 4;
	                break;
	            case 3:	    // SPEED_FAST:
	                entranceSpeed = 8;
	                break;
	            case 4:	    // SPEED_VERYFAST:
	                entranceSpeed = 16;
	                break;
	        }
	
	        switch (entranceEffect)
	        {
	            case 0:	    // FLYEFFECT_NONE:
	                entranceOrder = -1;
	                break;
	            case 1:	    // FLYEFFECT_APPEAR:
	                startEntranceX = initialX;
	                startEntranceY = -10 - pLPHO.hoImgWidth + pLPHO.hoImgXSpot;
	                entranceSpeedX = 0;
	                entranceSpeedY = 0;
	                break;
	            case 2:	    // FLYEFFECT_BOTTOM:
	                startEntranceX = initialX;
	                startEntranceY = pLPHO.hoAdRunHeader.rhLevelSy + 10 - pLPHO.hoImgYSpot;
	                entranceSpeedX = 0;
	                entranceSpeedY = entranceSpeed;
	                break;
	            case 3:	    // FLYEFFECT_LEFT:
	                startEntranceX = -10 - pLPHO.hoImgWidth + pLPHO.hoImgXSpot;
	                startEntranceY = initialY;
	                entranceSpeedX = entranceSpeed;
	                entranceSpeedY = 0;
	                break;
	            case 4:	    // FLYEFFECT_RIGHT:
	                startEntranceX = pLPHO.hoAdRunHeader.rhLevelSx + 10 - pLPHO.hoImgXSpot;
	                startEntranceY = initialY;
	                entranceSpeedX = entranceSpeed;
	                entranceSpeedY = 0;
	                break;
	            case 5:	    // FLYEFFECT_TOP:
	                startEntranceX = initialX;
	                startEntranceY = -10 - pLPHO.hoImgHeight + pLPHO.hoImgYSpot;
	                entranceSpeedX = 0;
	                entranceSpeedY = entranceSpeed;
	                break;
	        }
	
	        //*******************************************
	        //*** Exit parameters ***********************
	        //*******************************************
	        exitEffect = m_dwExitType;
	        exitOrder = m_dwExitOrder;
	
	        if (exitOrder == 0 && exitEffect != FLYEFFECT_NONE)
	        {
	            isMoving = EXIT;
	        }
	
	        if (exitOrder > data.finalOrder && exitEffect != FLYEFFECT_NONE)
	        {
	            data.finalOrder = exitOrder;
	        }
	
	        switch (m_dwExitSpeed)
	        {
	            case 0:	    // SPEED_VERYSLOW:
	                exitSpeed = 1;
	                break;
	            case 1:	    // SPEED_SLOW:
	                exitSpeed = 2;
	                break;
	            case 2:	    // SPEED_MEDIUM:
	                exitSpeed = 4;
	                break;
	            case 3:	    // SPEED_FAST:
	                exitSpeed = 8;
	                break;
	            case 4:	    // SPEED_VERYFAST:
	                exitSpeed = 16;
	                break;
	        }
	
	        switch (exitEffect)
	        {
	            case 0:	    // FLYEFFECT_NONE:
	                exitOrder = -1;
	                break;
	            case 1:	    // FLYEFFECT_APPEAR:
	                finalExitX = initialX;
	                finalExitY = -10 - pLPHO.hoImgHeight;
	                exitSpeedX = 0;
	                exitSpeedY = 0;
	                break;
	            case 2:	    // FLYEFFECT_BOTTOM:
	                finalExitX = initialX;
	                finalExitY = pLPHO.hoAdRunHeader.rhLevelSy + 10 - pLPHO.hoImgYSpot;
	                exitSpeedX = 0;
	                exitSpeedY = exitSpeed;
	                break;
	            case 3:	    // FLYEFFECT_LEFT:
	                finalExitX = -10 - pLPHO.hoImgWidth + pLPHO.hoImgXSpot;
	                finalExitY = initialY;
	                exitSpeedX = exitSpeed;
	                exitSpeedY = 0;
	                break;
	            case 4:	    // FLYEFFECT_RIGHT:
	                finalExitX = pLPHO.hoAdRunHeader.rhLevelSx + 10 - pLPHO.hoImgXSpot;
	                finalExitY = initialY;
	                exitSpeedX = exitSpeed;
	                exitSpeedY = 0;
	                break;
	            case 5:	    // FLYEFFECT_TOP:
	                finalExitX = initialX;
	                finalExitY = -10 - pLPHO.hoImgHeight + pLPHO.hoImgYSpot;
	                exitSpeedX = 0;
	                exitSpeedY = exitSpeed;
	                break;
	        }
	
	        //**************************************
	        //*** Calculate the initial position ***
	        //**************************************
	        if (exitOrder == -1)
	        {
	            if (entranceOrder != -1)
	            {
	                pLPHO.hoX = startEntranceX;
	                pLPHO.hoY = startEntranceY;
	                pLPHO.roc.rcChanged=true;
	            }
	        }
	        else if (entranceOrder != -1 && exitOrder != -1)
	        {
	            if (exitOrder > entranceOrder)
	            {
	                pLPHO.hoX = startEntranceX;
	                pLPHO.hoY = startEntranceY;
	                pLPHO.roc.rcChanged=true;
	            }
	        }
	    }
	    
	    public function moveToEnd():void
	    {
	        if (entranceOrder != -1 && exitOrder == -1)
	        {
	            pLPHO.hoX = initialX;
	            pLPHO.hoY = initialY;
                pLPHO.roc.rcChanged=true;
	        }
	        else if (entranceOrder == -1 && exitOrder != -1)
	        {
	            pLPHO.hoX = finalExitX;
	            pLPHO.hoY = finalExitY;
                pLPHO.roc.rcChanged=true;
	        }
	        else if (entranceOrder != -1 && exitOrder != -1)
	        {
	            if (entranceOrder > exitOrder)
	            {
	                pLPHO.hoX = initialX;
	                pLPHO.hoY = initialY;
	            }
	            else
	            {
	                pLPHO.hoX = finalExitX;
	                pLPHO.hoY = finalExitY;
	            }
                pLPHO.roc.rcChanged=true;
	        }
	    }

	    public function checkKeyPresses(data:CRunMvtGlobalPres):void
	    {
	        //*** Has the user pressed a key so we need to increase / decrease the order?
	
	        //*******************************
	        //*** Check move foward keys    *
	        //*******************************
	        if (data.keyNext == 0)
	        {
	            if (ho.hoAdRunHeader.rhApp.getKeyState(40))	    // VK_DOWN
	            {
	                data.keyNext = 40;			// VK_DOWN;
	                moveForward();
	            }
	            else if (ho.hoAdRunHeader.rhApp.getKeyState(39))	// VK_RIGHT
	            {
	                data.keyNext = 39;			// VK_RIGHT;
	                moveForward();
	            }
	        }
	        else if (ho.hoAdRunHeader.rhApp.getKeyState(data.keyNext) == false)
	        {
	            data.keyNext = 0;
	        }
	
	        //*******************************
	        //*** Check move backwards keys *
	        //*******************************
	        if (data.keyPrev == 0)
	        {
	            if (ho.hoAdRunHeader.rhApp.getKeyState(38))	// VK_UP
	            {
	                data.keyPrev = 38;		// VK_UP;
	                moveBack();
	            }
	            else if (ho.hoAdRunHeader.rhApp.getKeyState(37))	// VK_LEFT
	            {
	                data.keyPrev = 37;		// VK_LEFT;
	                moveBack();
	            }
	        }
	        else if (ho.hoAdRunHeader.rhApp.getKeyState(data.keyPrev) == false)
	        {
	            data.keyPrev = 0;
	        }
	    }

	    public override function kill():void
	    {
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            data.count--;
	            if (data.count == 0)
	            {
	                rh.delStorage(IDENTIFIER);
	            }
	        }
	    }

	    public override function move():Boolean
	    {
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data == null)
	        {
	            return false;
	        }
	
	        //************************
	        //*** Reset workaround ***
	        //************************
	        var p:CRunMvtclickteam_presentation;
	        if (data.reset)
	        {
	            if (ho.hoImgHeight != 0)
	            {
	                var index:int;
	                for (index = 0; index < data.myList.size(); index++)
	                {
	                    p = CRunMvtclickteam_presentation(data.myList.get(index));
	                    p.reset(data);
	                    if (data.resetToEnd)
	                    {
	                        p.moveToEnd();
	                    }
	                }
	                if (data.resetToEnd)
	                {
	                    data.orderPosition = data.finalOrder;
	                }
	                data.reset = false;
	                data.resetToEnd = false;
	            }
	            else
	            {
	                return false;
	            }
	        }
	
	        if (data.myList.size() > 0)
	        {
	            p = CRunMvtclickteam_presentation(data.myList.get(0));
	            if (p == this)
	            {
	                checkKeyPresses(data);
	            }
	        }
	
	        //************************
	        //*** Move Object ********
	        //************************
	        var calculs:Number;
	        if (isMoving == ENTRANCE)
	        {
	            animations(CAnim.ANIMID_WALK);
	
	            //*** Entrance movement
	            switch (entranceEffect)
	            {
	                case 1:	    // FLYEFFECT_APPEAR:
	                    ho.hoX = initialX;
	                    ho.hoY = initialY;
	                    isMoving = STOPPED;
	                    break;
	                case 2:	    // FLYEFFECT_BOTTOM:
	                    calculs = entranceSpeedY;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoY -= Math.min(calculs, Math.abs(initialY - ho.hoY));
	                    if (ho.hoY == initialY)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 3:	    // FLYEFFECT_LEFT:
	                    calculs = entranceSpeedX;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoX += Math.min(calculs, Math.abs(initialX - ho.hoX));
	                    if (ho.hoX == initialX)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 4:	    // FLYEFFECT_RIGHT:
	                    calculs = entranceSpeedX;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoX -= Math.min(calculs, Math.abs(initialX - ho.hoX));
	                    if (ho.hoX == initialX)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 5:	    // FLYEFFECT_TOP:
	                    calculs = entranceSpeedY;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoY += Math.min(calculs, Math.abs(initialY - ho.hoY));
	                    if (ho.hoY == initialY)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	            }
	            collisions();
	            return true;
	        }
	        else if (isMoving == EXIT)
	        {
	            animations(CAnim.ANIMID_WALK);
	
	            //*** Exit movement
	            switch (exitEffect)
	            {
	                case 1:	    // FLYEFFECT_APPEAR:
	                    ho.hoY = finalExitY;
	                    isMoving = STOPPED;
	                    break;
	                case 2:	    // FLYEFFECT_BOTTOM:
	                    calculs = exitSpeedY;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoY += Math.min(calculs, Math.abs(finalExitY - ho.hoY));
	                    if (ho.hoY >= finalExitY)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 3:	    // FLYEFFECT_LEFT:
	                    calculs = exitSpeedX;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoX -= Math.min(calculs, Math.abs(finalExitX - ho.hoX));
	                    if (ho.hoX <= finalExitX)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 4:	    // FLYEFFECT_RIGHT:
	                    calculs = exitSpeedX;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoX += Math.min(calculs, Math.abs(finalExitX - ho.hoX));
	                    if (ho.hoX >= finalExitX)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	                case 5:	    // FLYEFFECT_TOP:
	                    calculs = exitSpeedY;
	                    if ((ho.hoAdRunHeader.rhFrame.leFlags & CRunFrame.LEF_TIMEDMVTS) != 0)
	                    {
	                        calculs = calculs * ho.hoAdRunHeader.rh4MvtTimerCoef;
	                    }
	                    ho.hoY -= Math.min(calculs, Math.abs(finalExitY - ho.hoY));
	                    if (ho.hoY <= finalExitY)
	                    {
	                        isMoving = STOPPED;
	                    }
	                    break;
	            }
	            collisions();
	            return true;
	        }
	        animations(CAnim.ANIMID_STOP);
	        collisions();
	
	        //** The object has not been moved
	        return ho.roc.rcChanged;
	    }

	    public function moveForward():void
	    {
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            var index:int;
	            var p:CRunMvtclickteam_presentation;
	            for (index = 0; index < data.myList.size(); index++)
	            {
	                p = CRunMvtclickteam_presentation(data.myList.get(index));
	
	                //*** Find any objects that did not complete from the last move and complete them!
	                if (data.autoComplete)
	                {
	                    if (p.entranceOrder == data.orderPosition && p.isMoving != STOPPED)
	                    {
	                        p.pLPHO.hoX = p.initialX;
	                        p.pLPHO.hoY = p.initialY;
	                        p.isMoving = STOPPED;
	                        p.pLPHO.roc.rcChanged=true;
	                    }
	                    if (p.exitOrder == data.orderPosition && p.isMoving != STOPPED)
	                    {
	                        p.pLPHO.hoX = p.finalExitX;
	                        p.pLPHO.hoY = p.finalExitY;
	                        p.isMoving = STOPPED;
	                        p.pLPHO.roc.rcChanged=true;
	                    }
	                }
	
	                //*** Find any objects to move at this order : Entrance
	                if (p.entranceOrder == (data.orderPosition + 1))
	                {
	                    p.pLPHO.hoX = p.startEntranceX;
	                    p.pLPHO.hoY = p.startEntranceY;
	                    p.isMoving = ENTRANCE;
                        p.pLPHO.roc.rcChanged=true;
	                }
	                //*** Find any objects to move at this order : Exit
	                if (p.exitOrder == (data.orderPosition + 1))
	                {
	                    p.isMoving = EXIT;
	                }
	            }
	            data.orderPosition++;
	
	            if (data.orderPosition > data.finalOrder && data.autoFrameJump == true)
	            {
	                ho.hoAdRunHeader.rhQuit = CRun.LOOPEXIT_NEXTLEVEL;
	            }
	        }
	    }

	    public function moveBack():void
	    {
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data != null)
	        {
	            var index:int;
	            var p:CRunMvtclickteam_presentation;
	            for (index = 0; index < data.myList.size(); index++)
	            {
	                p = CRunMvtclickteam_presentation(data.myList.get(index));
	
	                //*** Find any objects from the last move and reset them!
	                if (p.entranceOrder == data.orderPosition)
	                {
	                    p.pLPHO.hoX = p.startEntranceX;
	                    p.pLPHO.hoY = p.startEntranceY;
	                    p.isMoving = STOPPED;
	                    p.pLPHO.roc.rcChanged=true;
	                }
	                if (p.exitOrder == data.orderPosition)
	                {
	                    p.pLPHO.hoX = p.initialX;
	                    p.pLPHO.hoY = p.initialY;
	                    p.isMoving = STOPPED;
	                    p.pLPHO.roc.rcChanged=true;
	                }
	            }
	            data.orderPosition--;
	
	            if (data.orderPosition < 0)
	            {
	                if (data.autoFrameJump && ho.hoAdRunHeader.rhApp.currentFrame != 0)
	                {
	                    data.resetToEnd = true;
	                    ho.hoAdRunHeader.rhQuit = CRun.LOOPEXIT_PREVLEVEL;
	                }
	                else
	                {
	                    data.orderPosition = 0;
	                }
	            }
	        }
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

	    public override function actionEntry(action:int):Number
	    {
	        var data:CRunMvtGlobalPres = CRunMvtGlobalPres(rh.getStorage(IDENTIFIER));
	        if (data == null)
	        {
	            return 0;
	        }
	
	        var param:int;
	        var index:int;
	        var p:CRunMvtclickteam_presentation;
	        switch (action)
	        {
	            case 3945:		// SET_PRESENTATION_Next = 3945,
	                moveForward();
	                break;
	            case 3946:		// SET_PRESENTATION_Prev,
	                moveBack();
	                break;
	            case 3947:		// SET_PRESENTATION_ToStart,
	                for (index = 0; index < data.myList.size(); index++)
	                {
	                    p = CRunMvtclickteam_presentation(data.myList.get(index));
	                    p.isMoving = STOPPED;
	                    p.reset(data);
	                }
	                data.orderPosition = 0;
	                break;
	            case 3948:		// SET_PRESENTATION_ToEnd,
	                for (index = 0; index < data.myList.size(); index++)
	                {
	                    p = CRunMvtclickteam_presentation(data.myList.get(index));
	                    p.isMoving = STOPPED;
	                    p.moveToEnd();
	                }
	                data.orderPosition = data.finalOrder;
	                break;
	            case 3949:		// GET_PRESENTATION_Index,
	                return data.orderPosition;
	            case 3950:		// GET_PRESENTATION_LastIndex
	                return data.finalOrder;
	        }
	        return 0;
	    }

	}
}