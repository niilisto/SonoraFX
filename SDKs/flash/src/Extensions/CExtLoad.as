//----------------------------------------------------------------------------------
//
// CEXTLOADER: Chargement des extensions
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Services.*;

	public class CExtLoad
	{
	    public var handle:int;
	    public var name:String;
	    public var subType:String;

	    public function loadInfo(file:CFile):void
	    {
	        var debut:int = file.getFilePointer();
	
	        var size:int = Math.abs(file.readShort());
	        handle = file.readAShort();
	        file.skipBytes(12);
	        name = file.readAString();
	        var pos:int = name.lastIndexOf('.');
	        name = name.substring(0, pos);
	        var index:int = name.indexOf('-');
	        while (index > 0)
	        {
	            name = name.substring(0, index) + '_' + name.substring(index+1, name.length);
	            index = name.indexOf('-');
	        }
	        subType = file.readAString();
	
	        file.seek(debut + size);
	    }

	    public function loadRunObject():CRunExtension 
	    {
	    	var object:CRunExtension;
	    	
	    	// STARTCUT
	    	if (CServices.compareStringsIgnoreCase(name, "clickteam_movement_controller"))
	    	{
	    		object=new CRunclickteam_movement_controller();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcarray"))
	    	{
	    		object=new CRunKcArray();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "AdvDir"))
	    	{
	    		object=new CRunAdvDir();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "AdvPathMov"))
	    	{
	    		object=new CRunAdvPathMov();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "Layer"))
	    	{
	    		object=new CRunLayer();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcedit"))
	    	{
	    		object=new CRunkcedit();
	    	}
			if (CServices.compareStringsIgnoreCase(name, "kcboxa"))
			{
				object=new CRunKcBoxA();
			}
			if (CServices.compareStringsIgnoreCase(name, "kcboxb"))
			{
				object=new CRunKcBoxB();
			}
	    	if (CServices.compareStringsIgnoreCase(name, "kclist"))
	    	{
	    		object=new CRunkclist();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kccombo"))
	    	{
	    		object=new CRunkccombo();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcbutton"))
	    	{
	    		object=new CRunKcButton();
	    	}
	    	//if (CServices.compareStringsIgnoreCase(name, "ObjectMover"))
	    	//{
	    	//	object=new CRunObjectMover();
	    	//}
	    	if (CServices.compareStringsIgnoreCase(name, "KcDbl"))
	    	{
	    		object=new CRunKcDbl();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcdirect"))
	    	{
	    		object=new CRunkcdirect();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "Platform"))
	    	{
	    		object=new CRunPlatform();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "KcBoxA"))
	    	{
	    		object=new CRunKcBoxA();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "KcBoxB"))
	    	{
	    		object=new CRunKcBoxB();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "parser"))
	    	{
	    		object=new CRunparser();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcclock"))
	    	{
	    		object=new CRunkcclock();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "StaticText"))
	    	{
	    		object=new CRunStaticText();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "MoveSafely2"))
	    	{
	    		object=new CRunMoveSafely2();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "Flash"))
	    	{
	    		object=new CRunFlash();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "InAndOutController"))
	    	{
	    		object=new CRunInAndOutController();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "WargameMap"))
	    	{
	    		object=new CRunWargameMap();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "CalcRect"))
	    	{
	    		object=new CRunCalcRect();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "AdvGameBoard"))
	    	{
	    		object=new CRunAdvGameBoard();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "FlashVideo"))
	    	{
	    		object=new CRunFlashVideo();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "Get"))
	    	{
	    		object=new CRunGet();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kcini"))
	    	{
	    		object=new CRunkcini();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "kchisc"))
	    	{
	    		object=new CRunkchisc();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "StringTokenizer"))
	    	{
	    		object=new CRunStringTokenizer();
	    	}
	    	if (CServices.compareStringsIgnoreCase(name, "IIF"))
	    	{
	    		object=new CRunIIF();
	    	}
			if (CServices.compareStringsIgnoreCase(name, "ActiveBackdrop"))
			{
				object=new CRunActiveBackdrop();
			}
			if (CServices.compareStringsIgnoreCase(name, "kcwctrl"))
			{
				object=new CRunkcwctrl();
			}
			//if (CServices.compareStringsIgnoreCase(name, "Inventory"))
			//{
			//	object=new CRunInventory();
			//}
			//if (CServices.compareStringsIgnoreCase(name, "KcRuntime"))
			//{
			//	object=new CRunKcRuntime();
			//}
			if (CServices.compareStringsIgnoreCase(name, "ForEach"))
			{
				object=new CRunForEach();
			}			
			if (CServices.compareStringsIgnoreCase(name, "Easing"))
			{
				object=new CRunEasing();
			}			
			if (CServices.compareStringsIgnoreCase(name, "Lacewing"))
			{
				object=new CRunLacewing();
			}
			if (CServices.compareStringsIgnoreCase(name, "MultipleTouch"))
			{
				object=new CRunMultipleTouch();
			}
			if (CServices.compareStringsIgnoreCase(name, "Accelerometer"))
			{
				object=new CRunAccelerometer();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dbase"))
			{
				object=new CRunBox2DBase();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dfan"))
			{
				object=new CRunBox2DFan();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dmagnet"))
			{
				object=new CRunBox2DMagnet();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dtreadmill"))
			{
				object=new CRunBox2DTreadmill();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dparticules"))
			{
				object=new CRunBox2DParticules();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dropeandchain"))
			{
				object=new CRunBox2DRopeAndChain();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2dground"))
			{
				object=new CRunBox2DGround();
			}
			if (CServices.compareStringsIgnoreCase(name,"box2djoint"))
			{
				object=new CRunBox2DJoint();
			}			
	    	// ENDCUT
	    	
	    	if (object!=null)
	    	{
	    		return object;
	    	}
	    	trace("*** Object not found!");
	    	return null;
	    }

	}
}