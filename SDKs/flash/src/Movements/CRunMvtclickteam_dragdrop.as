//----------------------------------------------------------------------------------
//
// CRUNMVTCLICKTEAM-DRAGDROP
//
//----------------------------------------------------------------------------------
package Movements
{
	import Animations.*;
	
	import Extensions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Services.*;
	
	import Sprites.*;
	import Banks.*;
	import Application.*;
	
	public class CRunMvtclickteam_dragdrop extends CRunMvtExtension
	{
		public static var FLAG_LIMITAREA:int = 1;
		public static var FLAG_SNAPTO:int = 2;
		public static var FLAG_DROPWHENLEAVE:int = 4;
		public static var FLAG_FORCELIMITS:int = 8;
	    public static var VK_LBUTTON:int=260;
	    public static var VK_RBUTTON:int=2;
	
	    public static var SET_DragDrop_Method:int = 4145;
	    public static var SET_DragDrop_IsLimited:int=4146;
	    public static var SET_DragDrop_DropOutsideArea:int=4147;
	    public static var SET_DragDrop_ForceWithinLimits:int=4148;
	    public static var SET_DragDrop_AreaX:int=4149;
	    public static var SET_DragDrop_AreaY:int=4150;
	    public static var SET_DragDrop_AreaW:int=4151;
	    public static var SET_DragDrop_AreaH:int=4152;
	    public static var SET_DragDrop_SnapToGrid:int=4153;
	    public static var SET_DragDrop_GridX:int=4154;
	    public static var SET_DragDrop_GridY:int=4155;
	    public static var SET_DragDrop_GridW:int=4156;
	    public static var SET_DragDrop_GridH:int=4157;
	    public static var GET_DragDrop_AreaX:int=4158;
	    public static var GET_DragDrop_AreaY:int=4159;
	    public static var GET_DragDrop_AreaW:int=4160;
	    public static var GET_DragDrop_AreaH:int=4161;
	    public static var GET_DragDrop_GridX:int=4162;
	    public static var GET_DragDrop_GridY:int=4163;
	    public static var GET_DragDrop_GridW:int=4164;
	    public static var GET_DragDrop_GridH:int=4165;
	
	    // Données edittime
		public var ed_dragWithSelected:int;
		public var ed_limitX:int;
		public var ed_limitY:int;
		public var ed_limitWidth:int;
		public var ed_limitHeight:int;
		public var ed_gridOriginX:int;
		public var ed_gridOriginY:int;
		public var ed_gridDx:int;
		public var ed_gridDy:int;
		public var ed_flags:int;
	
	    // Donnéez runtime
		public var dragWith:int;
	
		public var lastMouseX:int;
		public var lastMouseY:int;
		public var keyDown:Boolean=false;
		public var drag:Boolean=false;
	
		// Variables for limited area dragging
		public var snapToGrid:Boolean=false;
		public var limitedArea:Boolean=false;
		public var dropWhenLeaveArea:Boolean=false;
		public var forceWithinLimits:Boolean=false;
		public var minX:int;
		public var minY:int;
		public var maxX:int;
		public var maxY:int;
	
		public var gridOriginX:int;
		public var gridOriginY:int;
		public var gridSizeX:int;
		public var gridSizeY:int;
		public var x:int;
		public var y:int;
	
		public var lastX:int;
		public var lastY:int;
	
	    public var bLeftLast:Boolean=false;
	    public var bRightLast:Boolean=false;
	    public var clickLoop:int = 0;
	    public var clickLeft:Boolean=false;
	    public var clickRight:Boolean=false;

	    public override function initialize(file:CBinaryFile):void
	    {
	        file.skipBytes(1);
	
	        //Flags
	        ed_flags = file.readInt();
	        ed_dragWithSelected = file.readInt();
	        ed_limitX = file.readInt();
	        ed_limitY = file.readInt();
	        ed_limitWidth = file.readInt();
	        ed_limitHeight = file.readInt();
	        ed_gridOriginX = file.readInt();
	        ed_gridOriginY = file.readInt();
	        ed_gridDx = file.readInt();
	        ed_gridDy = file.readInt();
	
	        //*** General variables
	        dragWith = ed_dragWithSelected;
	        drag = false;
	        keyDown = false;
	        snapToGrid = ((ed_flags & FLAG_SNAPTO) != 0);
	        limitedArea = ((ed_flags & FLAG_LIMITAREA) != 0);
	        dropWhenLeaveArea = ((ed_flags & FLAG_DROPWHENLEAVE) != 0);
	        forceWithinLimits = ((ed_flags & FLAG_FORCELIMITS) != 0);
	
	        // Limit area settings
	        minX = ed_limitX;
	        minY = ed_limitY;
	        maxX = minX + ed_limitWidth;
	        maxY = minY + ed_limitHeight;
	
	        // Grid settings
	        gridOriginX = ed_gridOriginX;
	        gridOriginY = ed_gridOriginY;
	        gridSizeX = ed_gridDx;
	        gridSizeY = ed_gridDy;
	
	        lastX = ho.hoX;
	        lastY = ho.hoY;
	    }

	    public function handleMouseKeys():void
	    {
	        var bLeft:Boolean=ho.hoAdRunHeader.rhApp.getKeyState(VK_LBUTTON);
	        if (bLeft!=bLeftLast)
	        {
	            bLeftLast=bLeft;
	            if (bLeft)
	            {
	                if (clickLoop != ho.hoAdRunHeader.rhLoopCount + 1)
	                    clickRight = false;
	                clickLoop = ho.hoAdRunHeader.rhLoopCount + 1;
	                clickLeft = true;
	            }
	        }
/*	        var bRight:Boolean=ho.hoAdRunHeader.rhApp.getKeyState(VK_RBUTTON);
	        if (bRight!=bRightLast)
	        {
	            bRightLast=bRight;
	            if (bRight)
	            {
	                if (clickLoop != ho.hoAdRunHeader.rhLoopCount + 1)
	                    clickLeft = false;
	                clickLoop = ho.hoAdRunHeader.rhLoopCount + 1;
	                clickRight = true;
	            }
	        }
*/	    }
		public function getObjectAtXY(x:int, y:int):CObject
		{
	        // Explore les sprites en collision
	        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			var count:int=0;
			var i:int;
			var pHox:CObject;
			var x1:int, y1:int, x2:int, y2:int;
			var currentHo:CObject=null;
			var currentIndex:int=-1;
			var index:int;
			
			for (i=0; i<ho.hoAdRunHeader.rhNObjects; i++)
			{
			    while(ho.hoAdRunHeader.rhObjectList[count]==null)
					count++;
			    pHox=ho.hoAdRunHeader.rhObjectList[count];
			    count++;

				x1=pHox.hoX-pHox.hoImgXSpot;
				y1=pHox.hoY-pHox.hoImgYSpot;
				x2=x1+pHox.hoImgWidth;
				y2=y1+pHox.hoImgHeight;
				if (x>=x1 && x<x2 && y>=y1 && y<y2)
				{
		            if ((pHox.hoFlags & CObject.HOF_DESTROYED) == 0)
		            {
						var bOK:Boolean=true;
						if (pHox.hoType==COI.OBJ_SPR)
						{
							if ((pHox.ros.rsFlags&CRSpr.RSFLAG_COLBOX)==0)
							{
								var image:CImage=ho.hoAdRunHeader.rhApp.imageBank.getImageFromHandle(pHox.roc.rcImage);
								var mask:CMask=image.getMask(CMask.GCMF_OBSTACLE, pHox.roc.rcAngle, pHox.roc.rcScaleX, pHox.roc.rcScaleY);
								if (mask.testPoint(x1, y1, x, y)==false)
								{
									bOK=false;
								}
							}
						}
						if (bOK)
						{
							index=pHox.getChildIndex();
							if (index>currentIndex)
							{
								currentIndex=index;
								currentHo=pHox;
							}
						}
		            }
				}
			}
			return currentHo;
		}

	    public function isTopMostAOAtXY_Transparent(x:int, y:int):Boolean
	    {
	        var pRo:CObject;
	        	
            pRo=getObjectAtXY(x, y);
	        if( pRo != null )
	        {
	            if( pRo == ho )
	            {
	                return true;
	            }
	        }
	        return false;
	    }

	    public override function move():Boolean
	    {
	        handleMouseKeys();
	        handleDragAndDrop();
	
	        // Handle the objects movement, if it needs to be moved.
	        if( drag )
	        {
	            var dX:int = ho.hoAdRunHeader.rhApp.mouseX - lastMouseX;
	            var dY:int = ho.hoAdRunHeader.rhApp.mouseY - lastMouseY;
	
	            lastMouseX = ho.hoAdRunHeader.rhApp.mouseX;
	            lastMouseY = ho.hoAdRunHeader.rhApp.mouseY;
	
	            animations(CAnim.ANIMID_WALK);
	            x += dX;
	            y += dY;
	
	            ho.hoX = x;
	            ho.hoY = y;
	
	            if(snapToGrid)
	            {
	                var topX:int = ((ho.hoX - ho.hoImgXSpot) - gridOriginX) % gridSizeX;
	                var topY:int = ((ho.hoY - ho.hoImgYSpot) - gridOriginY) % gridSizeY;
	
	                ho.hoX -= topX;
	                ho.hoY -= topY;
	            }
	
	            checkLimitedArea();
	            collisions();
	
	            return true;
	        }
	        else
	        {
	            var hasChanged:Boolean = false;
	            if (forceWithinLimits)
	            {
	                var oldX:int = ho.hoX;
	                var oldY:int = ho.hoY;
	                checkLimitedArea();
	                if ((oldX != ho.hoX) || (oldY != ho.hoY))
	                    hasChanged = true;
	            }
	            animations(CAnim.ANIMID_STOP);
	            collisions();
	            return hasChanged;
	        }
	    }
	    
	    public function handleDragAndDrop():void
	    {
	        if( !drag )
	        {
	            // Check if dragging of object has started
	            if( dragWith == 0)
	            {
	                // Left mouse button is down
	                if( ho.hoAdRunHeader.rhApp.getKeyState(VK_LBUTTON))
	                {
	                    if( keyDown == false )
	                    {
	                        keyDown = true;
	
	                        if( isTopMostAOAtXY_Transparent(ho.hoAdRunHeader.rhApp.mouseX, ho.hoAdRunHeader.rhApp.mouseY) )
	                        {
	                            startDragging();
	                        }
	                    }
	                }
	                else
	                {
	                    keyDown = false;
	                }
	            }
/*	            else if( dragWith == 1)
	            {
	                // Right mouse button is down
	                if( ho.hoAdRunHeader.rhApp.getKeyState(VK_RBUTTON))
	                {
	                    if( keyDown == false )
	                    {
	                        keyDown = true;
	
	                        if( isTopMostAOAtXY_Transparent(ho.hoAdRunHeader.rhApp.mouseX, ho.hoAdRunHeader.rhApp.mouseY) )
	                        {
	                            startDragging();
	                        }
	                    }
	                }
	                else
	                {
	                    keyDown = false;
	                }
	            }
*/	            else if( dragWith == 2)
	            {
	                // Left mouse button clicked or currently down
	                if (ho.hoAdRunHeader.rhApp.getKeyState(VK_LBUTTON))
	                {
	                    if( keyDown == false )
	                    {
	                        keyDown = true;
	                    }
	                }
	                else
	                {
	                    if(keyDown == true)
	                    {
	                        if( isTopMostAOAtXY_Transparent(ho.hoAdRunHeader.rhApp.mouseX, ho.hoAdRunHeader.rhApp.mouseY) )
	                        {
	                            startDragging();
	                        }
	                    }
	
	                    keyDown = false;
	                }
	            }
	
/*	            else if( dragWith == 3)
	            {
	                // Right mouse button clicked or currently down
	                if (((clickLoop == ho.hoAdRunHeader.rhLoopCount) && clickRight) || (ho.hoAdRunHeader.rhApp.getKeyState(VK_RBUTTON)))
	                {
	                    if( keyDown == false )
	                    {
	                        keyDown = true;
	                    }
	                }
	                else
	                {
	                    if(keyDown == true)
	                    {
	                        if( isTopMostAOAtXY_Transparent(ho.hoAdRunHeader.rhApp.mouseX, ho.hoAdRunHeader.rhApp.mouseY) )
	                        {
	                            startDragging();
	                        }
	                    }
	
	                    keyDown = false;
	                }
	            }
*/	        }
	        else
	        {
	            // Check if dragging of object has ended.
	            if( dragWith == 0)
	            {
	                // Left mouse button released
	                if( ho.hoAdRunHeader.rhApp.getKeyState(VK_LBUTTON)==false)
	                {
	                    stop(true);
	                }
	            }
/*	            else if( dragWith == 1)
	            {
	                // Right mouse button released
	                if(ho.hoAdRunHeader.rhApp.getKeyState(VK_RBUTTON)==false)
	                {
	                    stop(true);
	                }
	            }
*/	            else if( dragWith == 2)
	            {
	                // Left mouse button clicked or currently down
	                if (((clickLoop == ho.hoAdRunHeader.rhLoopCount) && clickLeft) || (ho.hoAdRunHeader.rhApp.getKeyState(VK_LBUTTON)))
	                {
	                    keyDown = true;
	                }
	                else
	                {
	                    if(keyDown)
	                    {
	                        stop(true);
	                    }
	                }
	            }
/*	            else if( dragWith == 3)
	            {
	                // Right mouse button clicked or currently down
	                if (((clickLoop == ho.hoAdRunHeader.rhLoopCount) && clickRight) || (ho.hoAdRunHeader.rhApp.getKeyState(VK_RBUTTON)))
	                {
	                    keyDown = true;
	                }
	                else
	                {
	                    if(keyDown)
	                    {
	                        stop(true);
	                    }
	                }
	            }
*/	        }
	    }

	    public function startDragging():void
	    {
	        lastMouseX = ho.hoAdRunHeader.rhApp.mouseX;
	        lastMouseY = ho.hoAdRunHeader.rhApp.mouseY;
	
	        lastX = ho.hoX;
	        lastY = ho.hoY;
	
	        x = ho.hoX;
	        y = ho.hoY;
	
	        drag = true;
	
	        ho.roc.rcSpeed = 50;
	    }

	    public function checkLimitedArea():void
	    {
	        if( limitedArea )
	        {
	            // Check x-coordinates
	            if( ho.hoX < minX)
	            {
	                ho.hoX = minX;
	                if(dropWhenLeaveArea) drag = false;
	            }
	            else if( ho.hoX > maxX)
	            {
	                ho.hoX = maxX;
	                if(dropWhenLeaveArea) drag = false;
	            }
	
	            // Check y-coordinates
	            if( ho.hoY < minY)
	            {
	                ho.hoY = minY;
	                if(dropWhenLeaveArea) drag = false;
	            }
	            else if( ho.hoY > maxY)
	            {
	                ho.hoY = maxY;
	                if(dropWhenLeaveArea) drag = false;
	            }
	        }
	    }

	    public override function setPosition(x:int, y:int):void
	    {
	        ho.hoX=x;
	        ho.hoY=y;
	    }
	
	    public override function setXPosition(x:int):void
	    {
	        ho.hoX=x;
	    }
	
	    public override function setYPosition(y:int):void
	    {
	        ho.hoY=y;
	    }
	
	    public override function stop(bCurrent:Boolean):void
	    {
	        drag = false;
	        keyDown = false;
	
	        ho.roc.rcSpeed = 0;
	    }
	
	    public override function start():void
	    {
	        startDragging();
	    }
	
	    public override function bounce(bCurrent:Boolean):void
	    {
	        if( drag )
	        {
	            setPosition(lastX, lastY);
	            stop(true);
	        }
	    }

	    public override function actionEntry(action:int):Number
	    {
	        var param:int;
	        switch (action)
	        {
	            case SET_DragDrop_Method:
	                {
	                    param=getParamDouble();
	                    // Methods 0-4 supported
	                    if ((param >= 0) && (param < 5))
	                    {
	                        dragWith = param;
	                    }
	                }
	                break;
	
	            case SET_DragDrop_IsLimited:
	                {
	                    param=getParamDouble();
	                    limitedArea = param != 0;
	                }
	                break;
	
	            case SET_DragDrop_DropOutsideArea:
	                {
	                    param=getParamDouble();
	                    dropWhenLeaveArea = param != 0;
	                }
	                break;
	
	            case SET_DragDrop_ForceWithinLimits:
	                {
	                    param=getParamDouble();
	                    forceWithinLimits = param != 0;
	                }
	                break;
	
	            case SET_DragDrop_AreaX:
	                {
	                    param=getParamDouble();
	                    minX = param;
	                }
	                break;
	
	            case SET_DragDrop_AreaY:
	                {
	                    param=getParamDouble();
	                    minY = param;
	                }
	                break;
	
	            case SET_DragDrop_AreaW:
	                {
	                    param=getParamDouble();
	                    maxX = minX + param;
	                }
	                break;
	
	            case SET_DragDrop_AreaH:
	                {
	                    param=getParamDouble();
	                    maxY = minY + param;
	                }
	                break;
	
	            case SET_DragDrop_SnapToGrid:
	                {
	                    param=getParamDouble();
	                    snapToGrid = param != 0;
	                }
	                break;
	
	            case SET_DragDrop_GridX:
	                {
	                    param=getParamDouble();
	                    gridOriginX = param;
	                }
	                break;
	
	            case SET_DragDrop_GridY:
	                {
	                    param=getParamDouble();
	                    gridOriginY = param;
	                }
	                break;
	
	            case SET_DragDrop_GridW:
	                {
	                    param=getParamDouble();
	                    gridSizeX = param;
	                }
	                break;
	
	            case SET_DragDrop_GridH:
	                {
	                    param=getParamDouble();
	                    gridSizeY = param;
	                }
	                break;
	
	            case GET_DragDrop_AreaX:
	                {
	                    return minX;
	                }
	
	            case GET_DragDrop_AreaY:
	                {
	                    return minY;
	                }
	
	            case GET_DragDrop_AreaW:
	                {
	                    return maxX - minX;
	                }
	
	            case GET_DragDrop_AreaH:
	                {
	                    return maxY - minY;
	                }
	
	            case GET_DragDrop_GridX:
	                {
	                    return gridOriginX;
	                }
	
	            case GET_DragDrop_GridY:
	                {
	                    return gridOriginY;
	                }
	
	            case GET_DragDrop_GridW:
	                {
	                    return gridSizeX;
	                }
	
	            case GET_DragDrop_GridH:
	                {
	                    return gridSizeY;
	                }
	        }
	        return 0;
	    }

	    public override function getSpeed():int
	    {
	        return ho.roc.rcSpeed;
	    }
	
	    public override function getAcceleration():int
	    {
	        return 100;
	    }
	
	    public override function getDeceleration():int
	    {
	        return 100;
    	}
	}
}