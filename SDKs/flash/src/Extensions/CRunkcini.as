//----------------------------------------------------------------------------------
//
// CRUNKCINI : objet INI
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Application.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;

	public class CRunkcini extends CRunExtension
	{
	    private var ini:CRunIni=null;
	    private var iniFlags:int;
	    private var iniName:String;
	    private var iniCurrentGroup:String;
	    private var iniCurrentItem:String;
	    
		public function CRunkcini()
		{
		}
	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        iniFlags = file.readShort();
	        iniName = parseName(file.readString());
			if (iniName.length==0)
			{
				iniName="Ini.ini";
			}
	        ini = new CRunIni(ho.hoAdRunHeader.rhApp);
	        iniCurrentGroup = "Group";
	        iniCurrentItem = "Item";
	
	        return false;
	    }
	    private function parseName(name:String):String
	    {
	    	var pos:int=name.lastIndexOf("\\");
	    	if (pos>0)
	    	{
	    		name=name.substring(pos+1);
	    	}
            var n:int;
			for (n=0; n<name.length; n++)
			{
				if (name.charCodeAt(n)==32)
				{
					name=name.substring(0, n)+name.substring(n+1);
					n--;
				}	
			}				
	    	return name;	    			
	    }	    
	    public override function destroyRunObject(bFast:Boolean):void
	    {
	        ini.saveIni();
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case 0:
	                SetCurrentGroup(act);
	                break;
	            case 1:
	                SetCurrentItem(act);
	                break;
	            case 2:
	                SetValue(act);
	                break;
	            case 3:
	                SavePosition(act);
	                break;
	            case 4:
	                LoadPosition(act);
	                break;
	            case 5:
	                SetString(act);
	                break;
	            case 6:
	                SetCurrentFile(act);
	                break;
	            case 7:
	                SetValueItem(act);
	                break;
	            case 8:
	                SetValueGroupItem(act);
	                break;
	            case 9:
	                SetStringItem(act);
	                break;
	            case 10:
	                SetStringGroupItem(act);
	                break;
	            case 11:
	                DeleteItem(act);
	                break;
	            case 12:
	                DeleteGroupItem(act);
	                break;
	            case 13:
	                DeleteGroup(act);
	                break;
	        }
	
	    }
	
	    private function SetCurrentGroup(act:CActExtension):void
	    {
	        iniCurrentGroup = act.getParamExpString(rh, 0);
	    }
	
	    private function SetCurrentItem(act:CActExtension):void
	    {
	        iniCurrentItem = act.getParamExpString(rh, 0);
	    }
	
	    private function SetValue(act:CActExtension):void
	    {
	        var value:int = act.getParamExpression(rh, 0);
	        var s:String = value.toString();
	        ini.writePrivateProfileString(iniCurrentGroup, iniCurrentItem, s, iniName);
	    }
	
	    private function SavePosition(act:CActExtension):void
	    {
	        var hoPtr:CObject = act.getParamObject(rh, 0);
	        var s:String = hoPtr.hoX.toString() + "," + hoPtr.hoY.toString();
	        var item:String = "pos." + hoPtr.hoOiList.oilName;
	        ini.writePrivateProfileString(iniCurrentGroup, item, s, iniName);
	    }
	
	    private function LoadPosition(act:CActExtension):void
	    {
	        var hoPtr:CObject = act.getParamObject(rh, 0);
	        var item:String = "pos." + hoPtr.hoOiList.oilName;
	        var s:String = ini.getPrivateProfileString(iniCurrentGroup, item, "X", iniName);
	        if (s!="X")
	        {
	            var virgule:int = s.indexOf(",");
	            var left:String = s.substring(0, virgule);
	            var right:String = s.substring(virgule + 1);
	            hoPtr.hoX = parseInt(left, 10);
	            hoPtr.hoY = parseInt(right, 10);
	            hoPtr.roc.rcChanged = true;
	            hoPtr.roc.rcCheckCollides = true;
	        }
	    }
	
	    public function SetString(act:CActExtension):void
	    {
	        var s:String = act.getParamExpString(rh, 0);
	        ini.writePrivateProfileString(iniCurrentGroup, iniCurrentItem, s, iniName);
	    }
	
	    private function SetCurrentFile(act:CActExtension):void
	    {
	        iniName = parseName(act.getParamExpString(rh, 0));
	    }
	
	    private function SetValueItem(act:CActExtension):void
	    {
	        var item:String = act.getParamExpString(rh, 0);
	        var value:int = act.getParamExpression(rh, 1);
	        var s:String = value.toString();
	        ini.writePrivateProfileString(iniCurrentGroup, item, s, iniName);
	    }
	
	    private function SetValueGroupItem(act:CActExtension):void
	    {
	        var group:String = act.getParamExpString(rh, 0);
	        var item:String = act.getParamExpString(rh, 1);
	        var value:int = act.getParamExpression(rh, 2);
	        var s:String = value.toString();
	        ini.writePrivateProfileString(group, item, s, iniName);
	    }
	
	    private function SetStringItem(act:CActExtension):void
	    {
	        var item:String = act.getParamExpString(rh, 0);
	        var s:String = act.getParamExpString(rh, 1);
	        ini.writePrivateProfileString(iniCurrentGroup, item, s, iniName);
	    }
	
	    private function SetStringGroupItem(act:CActExtension):void
	    {
	        var group:String = act.getParamExpString(rh, 0);
	        var item:String = act.getParamExpString(rh, 1);
	        var s:String = act.getParamExpString(rh, 2);
	        ini.writePrivateProfileString(group, item, s, iniName);
	    }
	
	    private function DeleteItem(act:CActExtension):void
	    {
	        ini.deleteItem(iniCurrentGroup, act.getParamExpString(rh, 0), iniName);
	    }
	
	    private function DeleteGroupItem(act:CActExtension):void
	    {
	        ini.deleteItem(act.getParamExpString(rh, 0), act.getParamExpString(rh, 1), iniName);
	    }
	
	    private function DeleteGroup(act:CActExtension):void
	    {
	        ini.deleteGroup(act.getParamExpString(rh, 0), iniName);
	    }
	
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue 
	    {
	        switch (num)
	        {
	            case 0:
	                return GetValue();
	            case 1:
	                return GetString();
	            case 2:
	                return GetValueItem();
	            case 3:
	                return GetValueGroupItem();
	            case 4:
	                return GetStringItem();
	            case 5:
	                return GetStringGroupItem();
	        }
	        return null;
	    }
	
	    private function GetValue():CValue
	    {
	        var s:String = ini.getPrivateProfileString(iniCurrentGroup, iniCurrentItem, "", iniName);
	        var value:int = 0;
            value = parseInt(s, 10);
	        return new CValue(value);
	    }
	
	    private function GetString():CValue 
	    {
	        var s:String = ini.getPrivateProfileString(iniCurrentGroup, iniCurrentItem, "", iniName);
	        var ret:CValue=new CValue(0);
	        ret.forceString(s);
	        return ret;
	    }
	
	    private function GetValueItem():CValue
	    {
	        var item:String = ho.getExpParam().getString();
	        var s:String = ini.getPrivateProfileString(iniCurrentGroup, item, "", iniName);
	        var value:int = parseInt(s, 10);
	        return new CValue(value);
	    }
	
	    private function GetValueGroupItem():CValue
	    {
	        var group:String = ho.getExpParam().getString();
	        var item:String = ho.getExpParam().getString();
	        var s:String = ini.getPrivateProfileString(group, item, "", iniName);
	        var value:int = parseInt(s, 10);;
	        return new CValue(value);
	    }
	
	    private function GetStringItem():CValue
	    {
	        var item:String = ho.getExpParam().getString();
	        var s:String = ini.getPrivateProfileString(iniCurrentGroup, item, "", iniName);
	        var ret:CValue=new CValue(0);
	        ret.forceString(s);
	        return ret;
	    }
	
	    private function GetStringGroupItem():CValue
	    {
	        var group:String = ho.getExpParam().getString();
	        var item:String = ho.getExpParam().getString();
	        var s:String = ini.getPrivateProfileString(group, item, "", iniName);
	        var ret:CValue=new CValue(0);
	        ret.forceString(s);
	        return ret;
	    }	
	}
}