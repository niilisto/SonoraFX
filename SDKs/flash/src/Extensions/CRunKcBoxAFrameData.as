//----------------------------------------------------------------------------------
//
// CRUNBOXFRAMEDATA : Objet Active System Box
//
//----------------------------------------------------------------------------------
package Extensions
{
	import RunLoop.*;
	
	import Services.*;
	
	public class CRunKcBoxAFrameData extends CExtStorage
	{
        public static var TYPE_OBJECT:int=0;
        public static var TYPE_CONTAINER:int=1;
        public static var TYPE_BUTTON:int=2;
	    public static var FLAG_CONTAINED:int = 0x00002000;
		
	    public var pObjects:CArrayList;
	    public var pContainers:CArrayList;	    
	    public var pButtons:CArrayList;
	    
	    public var gClickedButton:int;
	    public var gHighlightedButton:int;
		
		public function CRunKcBoxAFrameData()
		{
		}

	    public function IsEmpty():Boolean
	    {
	    	var i:int;
	        if (pObjects != null)
	        {
	            for (i = 0; i < pObjects.size(); i++)
	            {
	                if (pObjects.get(i) != null)
	                {
	                    return false;
	                }
	            }
	        }
	        if (pContainers != null)
	        {
	            for (i = 0; i < pContainers.size(); i++)
	            {
	                if (pContainers.get(i) != null)
	                {
	                    return false;
	                }
	            }
	        }
	        return true;
	    }
	    public function AddObjAddr(t:int, reObject:CRunKcBoxA):int
	    {
	    	var i:int;
	        if (t == TYPE_OBJECT)
	        {
	           // 1st allocation
	            if (pObjects == null)
	            {
	                pObjects = new CArrayList();
	                pObjects.add(reObject);
	                return 0;
	            }
	            // Search for free place
	            for (i=0; i < pObjects.size(); i++)
	            {
	                if (pObjects.get(i) == null)
	                {
	                    pObjects.set(i, reObject);
	                    return i;
	                }
	            }
	            // Reallocation
	            pObjects.add(reObject);
	            return pObjects.size() - 1;
	        }
	        if (t == TYPE_CONTAINER)
	        {
	            if (pContainers == null)
	            {
	                pContainers = new CArrayList();
	                pContainers.add(reObject);
	                return 0;
	            }
	            // Search for free place
	            for (i=0; i < pContainers.size(); i++)
	            {
	                if (pContainers.get(i) == null )
	                {
	                    pContainers.set(i, reObject);
	                    return i;
	                }
	            }
	            // Reallocation
	            pContainers.add(reObject);
	            return pContainers.size() - 1;
	        }
	        if (t == TYPE_BUTTON)
	        {
	            if (pButtons == null)
	            {
	                pButtons = new CArrayList();
	                pButtons.add(reObject);
	                return 0;
	            }
	            // Search for free place
	            for (i=0; i < pButtons.size(); i++)
	            {
	                if (pButtons.get(i) == null )
	                {
	                    pButtons.set(i, reObject);
	                    return i;
	                }
	            }
	            // Reallocation
	            pButtons.add(reObject);
	            return pButtons.size() - 1;
	        }
	        return 0; //won't happen
	    }
	    // Remove object from list
	    public function RemoveObjAddr(t:int, reObject:CRunKcBoxA):void
	    {
	    	var i:int;
	        if (t == TYPE_OBJECT)
	        {
	            if (pObjects != null)
	            {
	                i = pObjects.indexOf(reObject);
	                if (i != -1)
	                {
	                    pObjects.set(i, null);
	                }                
	            }
	        }
	        if (t == TYPE_CONTAINER)
	        {
	            if (pContainers != null)
	            {
	                i = pContainers.indexOf(reObject);
	                if (i != -1)
	                {
	                    pContainers.set(i, null);
	                } 
	            }
	        }
	        if (t == TYPE_BUTTON)
	        {
	            if (pButtons != null)
	            {
	                i = pButtons.indexOf(reObject);
	                if (i != -1)
	                {
	                    pButtons.set(i, null);
	                } 
	            }
	        }
	      
	     }
	    
	   // Add objects
	    public function AddContainer(re:CRunKcBoxA):int
	    {
	        return AddObjAddr(TYPE_CONTAINER, re);
	    }
	    public function AddObject(re:CRunKcBoxA):int
	    {
	        return AddObjAddr(TYPE_OBJECT, re);
	    }
	    public function AddButton(re:CRunKcBoxA):int
	    {
	        return AddObjAddr(TYPE_BUTTON, re);
	    }
	    public function RemoveContainer(re:CRunKcBoxA):void
	    {
	        RemoveObjAddr(TYPE_CONTAINER, re);
	    }
	    public function RemoveObjectFromList(re:CRunKcBoxA):void
	    {
	        RemoveObjAddr(TYPE_OBJECT, re);
	    }
	    public function RemoveButton(re:CRunKcBoxA):void
	    {
	        RemoveObjAddr(TYPE_BUTTON, re);
	    }
	    // Get objects
	    public function GetContainer(re:CRunKcBoxA):int
	    {
	        var left:int = re.ho.getX();
	        var top:int = re.ho.getY();
	        var right:int = re.ho.getX() + re.ho.getWidth();
	        var bottom:int = re.ho.getY() + re.ho.getHeight();
			
			var i:int;
	        if (this.pContainers != null)
	        {
	            for (i=0; i < this.pContainers.size(); i++)
	            {
	                if ((this.pContainers.get(i) != null) && (this.pContainers.get(i) != re))
	                {
	                    var reThisOne:CRunKcBoxA = CRunKcBoxA(this.pContainers.get(i));
	                    if ((left >= reThisOne.ho.getX()) && 
	                            (right <= reThisOne.ho.getX() + reThisOne.ho.getWidth()) && 
	                            (top >= reThisOne.ho.getY()) && 
	                            (bottom <= reThisOne.ho.getY() + reThisOne.ho.getHeight()))
	                    {
	                        return i;
	                    }
	                }
	            } 
	        }
	        return -1;
	    }
	    public function GetObjectFromList(x:int, y:int):int
	    {
	        var r:int = -1;
	        var i:int;
	        if (this.pObjects != null)
	        {
	            for (i = this.pObjects.size() - 1; i >= 0; i--)
	            {
	                if (this.pObjects.get(i) != null)
	                {
	                    var reThisOne:CRunKcBoxA = CRunKcBoxA(this.pObjects.get(i));
	                    var rhPtr:CRun = reThisOne.ho.hoAdRunHeader;
	                    if ((x >= reThisOne.ho.getX() - rhPtr.rhWindowX) &&
	                             (x <= (reThisOne.ho.getX() - rhPtr.rhWindowX + reThisOne.ho.getWidth())) &&
	                             (y >= (reThisOne.ho.getY() - rhPtr.rhWindowY)) &&
	                             (y <= (reThisOne.ho.getY() - rhPtr.rhWindowY + reThisOne.ho.getHeight())))
	                    {
	                        r = i;
	                        break;
	                    }
	                }
	            }
	        }
			return r;
	    }
	    // Update position of contained objects
	    public function UpdateContainedPos():void//CRunKcBoxA re)
	    {
	    	var i:int;
	    	var rdPtrCont:CRunKcBoxA;
			if (this.pObjects != null)
	        {
	            for (i=0; i < this.pObjects.size(); i++)
	            {
	                if (this.pObjects.get(i) != null)
	                {
	                    var reThisOne:CRunKcBoxA = CRunKcBoxA(this.pObjects.get(i));
	                    // Contained ? must update coordinates
	                    if ((reThisOne.rData_dwFlags & FLAG_CONTAINED) != 0)
	                    {
	                        // Not yet a container? search Medor, search!
	                        if (reThisOne.rContNum == -1 )
	                        {
	                            reThisOne.rContNum = GetContainer(reThisOne);
	                            if (reThisOne.rContNum != -1 )
	                            {
	                                rdPtrCont = CRunKcBoxA(this.pContainers.get(reThisOne.rContNum));
	                                reThisOne.rContDx = (reThisOne.ho.getX() - rdPtrCont.ho.getX());
	                                reThisOne.rContDy = (reThisOne.ho.getY() - rdPtrCont.ho.getY());
	                            }
	                        }
	
	                        if ((reThisOne.rContNum != -1) && (reThisOne.rContNum < this.pContainers.size() ))
	                        {
	                            rdPtrCont = CRunKcBoxA(this.pContainers.get(reThisOne.rContNum));
	                            if (rdPtrCont != null )
	                            {
	                                var newX:int = rdPtrCont.ho.getX() + reThisOne.rContDx;
	                                var newY:int = rdPtrCont.ho.getY() + reThisOne.rContDy;
	                                if ((newX != reThisOne.ho.getX()) || (newY != reThisOne.ho.getY()))
	                                {
	                                    reThisOne.ho.setX(newX);
	                                    reThisOne.ho.setY(newY);
	                                    // Update tooltip position
	                                    //UpdateToolTipRect(reThisOne);
	                                    reThisOne.ho.redraw();
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	    }
	}
}