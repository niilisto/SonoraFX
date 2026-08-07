//----------------------------------------------------------------------------------
//
// CRUNGET : Get object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.events.*;
	import flash.net.*;

	public class CRunGet extends CRunExtension
	{
		public var bComplete:Boolean;
		public var url:String;
		public var bError:Boolean;
		
		private static var ACT_GETURL:int=0;
		private static var CND_ONCOMPLETE:int=0;
		private static var CND_PENDING:int=1;
		private static var EXP_CONTENT:int=0;

		private var loader:URLLoader;
		private var completeEventCount:int;
			 
		public function CRunGet()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 2;
	    }
		
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	    	try
	    	{
				loader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, errorHandler);
				loader.dataFormat=URLLoaderDataFormat.TEXT;
	    	}
	    	catch(error:Error)
	    	{
	    		loader=null;
	    	}
	    	catch(error:SecurityError)
	    	{
	    		loader=null;
	    	}
			
			bComplete=false;
			completeEventCount=-1;
	    	return false;
	    }
		public override function destroyRunObject(bFlag:Boolean):void
		{
			if (loader!=null)
			{
				loader.removeEventListener(Event.COMPLETE, completeHandler);
			}
		}
	    private function completeHandler(event:Event):void
	    {
	    	bComplete=true;	    	
	        completeEventCount = rh.rh4EventCount;
	        ho.pushEvent(CND_ONCOMPLETE, 0);	
	    }
	    private function errorHandler(event:Event):void
	    {
	    	bError=true;	    	
	    }

 	     // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	    	if (num==ACT_GETURL)
	    	{
	    		actGetURL(act);
	    	}
	    }

		private function actGetURL(act:CActExtension):void
		{
			url=act.getParamExpString(rh, 0);
			var request:URLRequest = new URLRequest(url);
			bComplete=false;
			bError=false;
			if (loader!=null)
			{
				try 
				{
	                loader.load(request);
	            } 
	            catch (error:Error) 
	            {
	            }
		    	catch(error:SecurityError)
		    	{
		    		loader=null;
		    	}
	  		}
		}
		
		// EXPRESSIONS
		// -------------------------------------------------------------------------
	    public override function expression(num:int):CValue
	    {
	    	if (num==EXP_CONTENT)
	    	{
				return expContent();	    		
	    	}
	    	return null;
	    }
	    private function expContent():CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	    	if (loader!=null)
	    	{
		    	if (bComplete==true && bError==false)
		    	{
		    		var s:String=loader.data;
		    		ret.forceString(s);	    		
		    	}
		    }
	    	return ret;
	    }
	}
}