//----------------------------------------------------------------------------------
//
// CRunFlash : objet Flash
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
	
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class CRunFlash extends CRunExtension
	{
	    private static var CND_JSCRIPT_ONERROR:int=0;
	    private static var CND_ISPRELOADER:int=1;
		private static var CND_STRINGRECEIVED:int=2;	    
		private static var CND_ISACTIVATED:int=3;
		private static var CND_MOUSEIN:int=4;

	    private static var ACT_OPENURL_SELF:int=0;
	    private static var ACT_OPENURL_PARENT:int=1;
	    private static var ACT_OPENURL_TOP:int=2;
	    private static var ACT_OPENURL_NEW:int=3;
	    private static var ACT_OPENURL_TARGET:int=4;
	    private static var ACT_JSCRIPT_RESETPARAMS:int=5;
	    private static var ACT_JSCRIPT_ADDINTPARAM:int=6;
	    private static var ACT_JSCRIPT_ADDFLOATPARAM:int=7;
	    private static var ACT_JSCRIPT_ADDSTRPARAM:int=8;
	    private static var ACT_JSCRIPT_CALLFUNCTION:int=9;
	    private static var ACT_SETHANDCURSOR:int=10;
	    private static var ACT_SETHANDCURSORON:int=11;
	    private static var ACT_SETHANDCURSOROFF:int=12;
	    private static var ACT_SETGLOBALHANDCURSOR:int=13;
	    private static var ACT_SETGLOBALHANDCURSORON:int=14;
	    private static var ACT_SETGLOBALHANDCURSOROFF:int=15;
	    private static var ACT_OPENSENDCONNECTION:int=16;
	    private static var ACT_OPENRECEIVECONNECTION:int=17;
	    private static var ACT_SENDSTRING:int=18;
	    	    
	    private static var EXP_JSCRIPT_GETINTRESULT:int=0;
	    private static var EXP_JSCRIPT_GETFLOATRESULT:int=1;
	    private static var EXP_JSCRIPT_GETSTRRESULT:int=2;
		private static var EXP_TOTAL:int=3;
		private static var EXP_LOADED:int=4;
		private static var EXP_PERCENT:int=5;
		private static var EXP_GETSTRING:int=6;
		private static var EXP_GETDOMAIN:int=7;
		private static var EXP_GETWINDOWDOMAIN:int=8;
		private static var EXP_GETLANGAGE:int=9;
		
		protected static const WINDOW_OPEN_FUNCTION:String = "window.open";
		
		private var parameters:CArrayList;
		private var retNumber:Number;
		private var retString:String;
		private var bError:Boolean;
		private var onErrorCount:int;
		private var receiveConnection:LocalConnection;
		private var sendConnection:LocalConnection;
		private var stringReceivedCount:int;
		private var sendConnectionName:String;
		private var receiveConnectionName:String;
		private var receivedString:String;
		
	    public override function getNumberOfConditions():int
	    {
	        return 5;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	parameters=new CArrayList();
	    	retNumber=0;
	    	retString=null;
	    	bError=false;
	    	onErrorCount=-1;
	    	receiveConnection=null;
	    	sendConnection=null;
	    	stringReceivedCount=-1;
	    	receivedString="";
	        return true;
	    }
	    public override function destroyRunObject(bFast:Boolean):void
	    {
	    	if (receiveConnection!=null)
	    	{
	    		receiveConnection.close();
	    	}
	    }
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        switch (num)
	        {
	    		case CND_JSCRIPT_ONERROR:
	    			return onError();
	    		case CND_ISPRELOADER:
	    			return isPreloader();
				case CND_STRINGRECEIVED:
					return stringReceived();
				case CND_ISACTIVATED:
					return ho.hoAdRunHeader.rhApp.bActivated;
				case CND_MOUSEIN:
					return ho.hoAdRunHeader.rhApp.bMouseIn;
	        }
	        return false;//won't happen
		}
		public function stringReceived():Boolean
		{
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	        if (rh.rh4EventCount == stringReceivedCount)
	        {
	            return true;
	        }
	        return false;
		}
		public function isPreloader():Boolean
		{
			return ho.hoAdRunHeader.rhApp.bPreloader;
		}
		public function onError():Boolean
		{
	        // If this condition is first, then always true
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }	
	        // If condition second, check event number matches
	        if (rh.rh4EventCount == onErrorCount)
	        {
	            return true;
	        }
	        return false;
		}
		
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
				case ACT_OPENURL_SELF:
					actOpenURLSelf(act);
					break;
				case ACT_OPENURL_PARENT:
					actOpenURLParent(act);
					break;
				case ACT_OPENURL_TOP:
					actOpenURLTop(act);
					break;
				case ACT_OPENURL_NEW:
					actOpenURLNew(act);
					break;
				case ACT_OPENURL_TARGET:
					actOpenURLTarget(act);
					break;
				case ACT_JSCRIPT_RESETPARAMS:
					actResetParams();
					break;
				case ACT_JSCRIPT_ADDINTPARAM:
					actAddIntegerParam(act);
					break;
				case ACT_JSCRIPT_ADDFLOATPARAM:
					actAddFloatParam(act);
					break;
				case ACT_JSCRIPT_ADDSTRPARAM:
					actAddStringParam(act);
					break;
				case ACT_JSCRIPT_CALLFUNCTION:
					actCallFunction(act);
					break;
				case ACT_SETHANDCURSOR:
					actSetHandCursor(act);
					break;
				case ACT_SETHANDCURSORON:
					actSetHandCursorON(act);
					break;
				case ACT_SETHANDCURSOROFF:
					actSetHandCursorOFF(act);
					break;
				case ACT_SETGLOBALHANDCURSOR:
					actSetGlobalHandCursor(act);
					break;
				case ACT_SETGLOBALHANDCURSORON:
					actSetGlobalHandCursorON(act);
					break;
				case ACT_SETGLOBALHANDCURSOROFF:
					actSetGlobalHandCursorOFF(act);
					break;
				case ACT_OPENRECEIVECONNECTION:
					actOpenReceiveConnection(act);
					break;
				case ACT_OPENSENDCONNECTION:
					actOpenSendConnection(act);
					break;
				case ACT_SENDSTRING:
					actSendString(act);
					break;
	        }
	    }
		private function actOpenReceiveConnection(act:CActExtension):void
		{
			if (receiveConnection==null)
			{
				receiveConnectionName=act.getParamExpString(rh, 0);
				receiveConnection=new LocalConnection();
				receiveConnection.allowDomain("*");
				receiveConnection.client=this;
				try
				{
					receiveConnection.connect(receiveConnectionName);
				}
				catch(error:ArgumentError)
				{
					receiveConnection=null;
				}					
			}
		}
		private function actOpenSendConnection(act:CActExtension):void
		{
			if (sendConnection==null)
			{
				sendConnectionName=act.getParamExpString(rh, 0);
				sendConnection=new LocalConnection();
				sendConnection.allowDomain("*");
			}
		}
		private function actSendString(act:CActExtension):void
		{
			if (sendConnection!=null)
			{
				var string:String=act.getParamExpString(rh, 0);
				sendConnection.send(sendConnectionName, "connectionHandler", string);
			}			
		}
		public function connectionHandler(string:String):void
		{
			receivedString=string;
            stringReceivedCount=rh.rh4EventCount;
            ho.pushEvent(CND_STRINGRECEIVED, ho.getEventParam());			
		}
		private function actSetHandCursor(act:CActExtension):void
		{
			var object:CObject=act.getParamObject(rh, 0);
			var onOff:int=act.getParamExpression(rh, 1);
			if (object!=null)
			{
				object.setHandCursor(onOff!=0);
			}
		}
		private function actSetHandCursorON(act:CActExtension):void
		{
			var object:CObject=act.getParamObject(rh, 0);
			if (object!=null)
			{
				object.setHandCursor(true);
			}
		}
		private function actSetHandCursorOFF(act:CActExtension):void
		{
			var object:CObject=act.getParamObject(rh, 0);
			if (object!=null)
			{
				object.setHandCursor(false);
			}
		}
		private function actSetGlobalHandCursor(act:CActExtension):void
		{
			var onOff:int=act.getParamExpression(rh, 0);
			rh.rhFrame.layers[0].setHandCursor(onOff!=0);
			setGlobalHandCursor(onOff!=0);
		}
		private function actSetGlobalHandCursorON(act:CActExtension):void
		{
			rh.rhFrame.layers[0].setHandCursor(true);
			setGlobalHandCursor(true);
		}
		private function actSetGlobalHandCursorOFF(act:CActExtension):void
		{
			rh.rhFrame.layers[0].setHandCursor(false);
			setGlobalHandCursor(false);
		}
		private function setGlobalHandCursor(bOn:Boolean):void
		{
			var object:CObject;
			for (object=ho.getFirstObject(); object!=null; object=ho.getNextObject())
			{
				object.setHandCursor(bOn);
			}
		}
		private function actOpenURLSelf(act:CActExtension):void
		{
			var url:String=act.getParamExpString(rh, 0);
			openURL(url, "_self");
		}
		private function actOpenURLParent(act:CActExtension):void
		{
			var url:String=act.getParamExpString(rh, 0);
			openURL(url, "_parent");
		}
		private function actOpenURLTop(act:CActExtension):void
		{
			var url:String=act.getParamExpString(rh, 0);
			openURL(url, "_top");
		}
		private function actOpenURLNew(act:CActExtension):void
		{
			var url:String=act.getParamExpString(rh, 0);
			openURL(url, "_blank");
		}
		private function actOpenURLTarget(act:CActExtension):void
		{
			var url:String=act.getParamExpString(rh, 0);
			var target:String=act.getParamExpString(rh, 1);
			openURL(url, target);
		}
		
		private function openURL(address:String, type:String):void
		{
			var request:URLRequest;
			if (ho.hoAdRunHeader.buttonClickCount==ho.getEventCount())
			{
				var s:String=address.substr(0, 7);
				s=s.toUpperCase();
				if (s!="HTTP://" && s!="HTTPS:/")
				{
					address="http://"+address;
				}
				request=new URLRequest(address);
				try
				{
					navigateToURL(request, type);
				}	
				catch(e:Error)
				{				
				}
			}
			else
			{
				var localMode:Boolean = new RegExp("file://").test(ho.hoAdRunHeader.rhApp.loaderInfo.url);
				var ss:String=address.substring(0, 7).toUpperCase();
				if (ss!="HTTP://")
				{
					localMode=true;
				}				
				if (ExternalInterface.available==false)
				{
					localMode=true;
				}
				if (localMode)
				{
					request=new URLRequest(address);
					try
					{
						navigateToURL(request, type);
					}	
					catch(e:Error)
					{				
					}
				}
				else
				{
					openWindow(address, type);
				}
			}			
		}
		
		public static function openWindow(url:String, window:String = "_blank", features:String = ""):void
		{
			var browserName:String = getBrowserName();
			
			if(browserName == "Firefox")
			{
				ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
			}
			//If IE,
			else if(browserName == "IE")
			{
				ExternalInterface.call("function setWMWindow() {window.open('" + url + "');}");
			}
			//If Safari
			else 
			{
				try
				{
					navigateToURL(new URLRequest(url), window);
				}	
				catch(e:Error)
				{				
				}
			}
		}
		private static function getBrowserName():String
		{
			var browser:String;
			//Uses external interface to reach out to browser and grab browser useragent info.
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			
			//Determines brand of browser using a find index. If not found indexOf returns (-1).
			if(browserAgent != null && browserAgent.indexOf("Firefox") >= 0)
			{
				browser = "Firefox";
			}
			else if(browserAgent != null && browserAgent.indexOf("MSIE") >= 0)
			{
				browser = "IE";
			}
			else
			{
				browser = "Undefined";
			}
			return (browser);
		}

		private function actResetParams():void
		{
			parameters.clear();
		} 
		private function actAddIntegerParam(act:CActExtension):void
		{
			var p:int=act.getParamExpression(rh, 0);
			parameters.add(p);
		}
		private function actAddStringParam(act:CActExtension):void
		{
			var p:String=act.getParamExpString(rh, 0);
			parameters.add(p);
		}
		private function actAddFloatParam(act:CActExtension):void
		{
			var p:Number=act.getParamExpDouble(rh, 0);
			parameters.add(p);
		}
		private function actCallFunction(act:CActExtension):void
		{
			var func:String=act.getParamExpString(rh, 0);
			var ret:Object;
			bError=false;
			try
			{
				switch(parameters.size())
				{
					case 0:
						ret=ExternalInterface.call(func);
						break;
					case 1:
						ret=ExternalInterface.call(func, parameters.get(0));
						break;
					case 2:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1));
						break;
					case 3:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2));
						break;
					case 4:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3));
						break;
					case 5:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4));
						break;
					case 6:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4), parameters.get(5));
						break;
					case 7:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4), parameters.get(5), parameters.get(6));
						break;
					case 8:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4), parameters.get(5), parameters.get(6), parameters.get(7));
						break;
					case 9:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4), parameters.get(5), parameters.get(6), parameters.get(7), parameters.get(8));
						break;
					case 10:
						ret=ExternalInterface.call(func, parameters.get(0), parameters.get(1), parameters.get(2), parameters.get(3), parameters.get(4), parameters.get(5), parameters.get(6), parameters.get(7), parameters.get(8), parameters.get(9));
						break;
				}
				if (ret!=null)
				{
					if (ret is int)
					{
						retNumber=Number(ret);
					}
					if (ret is Number)
					{
						retNumber=Number(ret);
					}
					if (ret is String)
					{
						retString=String(ret);
					}
				}
			}
			catch(e:Error)
			{
		        onErrorCount = rh.rh4EventCount;
		        ho.pushEvent(CND_JSCRIPT_ONERROR, 0);					
				bError=true;
			}			
		}

		
		public function getLocation(urlStr:String):String {
			
			var found:Array = urlStr.split("/");
			if(found.length >= 3)
				return (found[0]+"/"+found[1]+"/"+found[2]).toString();
			else
				return "not found";
		}
		
	    public override function expression(num:int):CValue
	    {
	    	var ret:CValue;
	        switch (num)
	        {
				case EXP_JSCRIPT_GETINTRESULT:
					return expGetIntResult();
				case EXP_JSCRIPT_GETFLOATRESULT:
					return expGetFloatResult();
				case EXP_JSCRIPT_GETSTRRESULT:
					return expGetStringResult();
				case EXP_TOTAL:
					return expTotal();
				case EXP_LOADED:
					return expLoaded();
				case EXP_PERCENT:
					return expPercent();
				case EXP_GETSTRING:
					return expReceivedString();
				case EXP_GETDOMAIN:
					return expGetDomain();
				case EXP_GETWINDOWDOMAIN:
					return expGetWindowDomain();
				case EXP_GETLANGAGE:
					return expGetLangage();
	        }
	        return new CValue(0);//won't be used
	    }
		private function expGetWindowDomain():CValue
		{
			var domain:CValue = new CValue(0);			
			try
			{
				domain.forceString(ExternalInterface.call("function domain() {return window.location.href}"));
			}
			catch(e:Error)
			{
				domain.forceString(getLocation(ho.getApplication().loaderInfo.url));
			}		
			return domain;			
		}
		private function expGetLangage():CValue
		{
			var l:CValue = new CValue(0);			
			l.forceString(flash.system.Capabilities.language);
			return l;
		}
		private function expGetDomain():CValue
	    {
	    	var lc:LocalConnection=null;
	    	if (receiveConnection!=null)
	    	{
	    		lc=receiveConnection;
	    	}
	    	if (sendConnection!=null)
	    	{
	    		lc=sendConnection;
	    	}
	    	if (lc==null)
	    	{
	    		lc=new LocalConnection();
	    	}
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(lc.domain);
	    	return ret;
	    }
	    private function expReceivedString():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString(receivedString);
	    	return ret;
	    }
	    private function expTotal():CValue
	    {
	    	return new CValue(ho.hoAdRunHeader.rhApp.preloaderTotal);
	    }
	    private function expLoaded():CValue
	    {
	    	return new CValue(ho.hoAdRunHeader.rhApp.preloaderLoaded);
	    }
	    private function expPercent():CValue
	    {
	    	if (ho.hoAdRunHeader.rhApp.preloaderTotal!=0)
	    	{
	    		return new CValue((ho.hoAdRunHeader.rhApp.preloaderLoaded*100)/ho.hoAdRunHeader.rhApp.preloaderTotal);
	    	}
	    	return new CValue(0);
	    }
	    private function expGetIntResult():CValue
	    {
	    	return new CValue(int(retNumber));
	    }
	    private function expGetFloatResult():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceDouble(retNumber);
	    	return ret;
	    }
	    private function expGetStringResult():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	
	    	if (retString!=null)
	    	{
	    		ret.forceString(retString);
	    	}
	    	else
	    	{
	    		ret.forceString("");
	    	}
	    	return ret;
	    }
	}
}