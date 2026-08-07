package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import FGLX.FGLAds;
	
	import Objects.CObject;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	public class CRunFGLflash extends CRunExtension
	{
		private static var CND_LAST:int = 6;

		private var nError:int;
		private var szError:String = "";
		private var GameID:String;
		private var localStage:Stage;
		private var fglAd:FGLAds=null;
		private var SizeAd:String;
		private var DelayAd:int;
		private var TimeoutAd:int;
		private var FGLenable:Boolean = true;
		private var FGLok:Boolean;
		
		private var onErrorCount:int;
		private var onAPICount:int;
		private var onLoadEventCount:int;
		private var onShowEventCount:int;
		private var onClickEventCount:int;
		private var onCloseEventCount:int;
		
		public function CRunFGLflash()
		{
		}
		
		public override function getNumberOfConditions():int
		{
			return CND_LAST;
		}
		
		public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
		{
			localStage = rh.rhApp.stage;
			return true;
		}
		
		public override function destroyRunObject(bFast:Boolean):void
		{
			if(fglAd != null) {
				fglAd.removeEventListener(FGLAds.EVT_API_READY, isAPIReady);
				fglAd.removeEventListener(FGLAds.EVT_AD_LOADING_ERROR, isError);
				fglAd.removeEventListener(FGLAds.EVT_NETWORKING_ERROR, isError);
				fglAd.removeEventListener(FGLAds.EVT_AD_LOADED, onLoaded);
				fglAd.removeEventListener(FGLAds.EVT_AD_SHOWN, onShown);
				fglAd.removeEventListener(FGLAds.EVT_AD_CLICKED, onClicked);
				fglAd.removeEventListener(FGLAds.EVT_AD_CLOSED, onClosed);
				fglAd = null; 
			}
		}
		
		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
			switch (num)
			{
				case 0:				// "On API Ready"
					return onAPI();
				case 1:				// "On Loaded Ads"
					return onLoadEvent();
				case 2:				// "On Show Ads"
					return onShowEvent();
				case 3:				// "On Clicked Ads"
					return onClickEvent();
				case 4:				// "On Close Ads"
					return onCloseEvent();
				case 5:				// "On Ads Error"
					return onError();
			}
			return false;//won't happen
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

		public function onAPI():Boolean
		{
			// If this condition is first, then always true
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}	
			// If condition second, check event number matches
			if (rh.rh4EventCount == onAPICount)
			{
				return true;
			}
			return false;
		}

		public function onLoadEvent():Boolean
		{
			// If this condition is first, then always true
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}	
			// If condition second, check event number matches
			if (rh.rh4EventCount == onLoadEventCount)
			{
				return true;
			}
			return false;
		}
		
		public function onShowEvent():Boolean
		{
			// If this condition is first, then always true
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}	
			// If condition second, check event number matches
			if (rh.rh4EventCount == onShowEventCount)
			{
				return true;
			}
			return false;
		}
		
		public function onClickEvent():Boolean
		{
			// If this condition is first, then always true
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}	
			// If condition second, check event number matches
			if (rh.rh4EventCount == onClickEventCount)
			{
				return true;
			}
			return false;
		}
		
		public function onCloseEvent():Boolean
		{
			// If this condition is first, then always true
			if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
			{
				return true;
			}	
			// If condition second, check event number matches
			if (rh.rh4EventCount == onCloseEventCount)
			{
				return true;
			}
			return false;
		}
		
		public override function action(num:int, act:CActExtension):void
		{
			switch (num)
			{
				case 0:					// Set Game ID
					GameID = act.getParamExpString(rh, 0);
					break;
				case 1:					// Request Ad
					actRequestAd();
					break;
				case 2:					// Show Ad
					actShowAd();
					break;
				case 3:					// Set Ads Size
					if(act.getParamExpression(rh, 0) != 0)
						SizeAd = FGLAds.FORMAT_300x250;
					else
						SizeAd = FGLAds.FORMAT_90x90;
					break;
				case 4:					// Set Ads Delay
					DelayAd = act.getParamExpression(rh,0);
					break;
				case 5:					// Set Ads Timeout
					TimeoutAd = act.getParamExpression(rh,0);
					break;
				case 6:					// Disable Ads
					FGLenable = false;
					ToggleAPI();
					break;
				case 7:					// Enable Ads
					FGLenable = true;
					ToggleAPI();
					break;
			}
		}
		
		private function actRequestAd():void
		{
			if(GameID.length > 0 && localStage != null) {
				fglAd = new FGLAds(localStage, GameID);
				if(fglAd != null) {
					fglAd.addEventListener(FGLAds.EVT_API_READY, isAPIReady);
					fglAd.addEventListener(FGLAds.EVT_AD_LOADING_ERROR, isError);
					fglAd.addEventListener(FGLAds.EVT_NETWORKING_ERROR, isError);
				}
			}
		}
		
		private function actShowAd():void
		{
			if(FGLok) {
				
				DelayAd = Math.max(1000, DelayAd);
				TimeoutAd <= 0 ? 0 : TimeoutAd;
				
				fglAd.removeEventListener(FGLAds.EVT_AD_CLICKED, onClicked);
				fglAd.removeEventListener(FGLAds.EVT_AD_CLOSED, onClosed);
								
				fglAd.showAdPopup(SizeAd, DelayAd, TimeoutAd);
				
				fglAd.addEventListener(FGLAds.EVT_AD_LOADED, onLoaded);
				fglAd.addEventListener(FGLAds.EVT_AD_SHOWN, onShown);
				fglAd.addEventListener(FGLAds.EVT_AD_CLICKED, onClicked);
				fglAd.addEventListener(FGLAds.EVT_AD_CLOSED, onClosed);
			}
		}

		//////////////////////////////////////////////////////////
		//
		//             Handling Events from Listener
		//
		//////////////////////////////////////////////////////////
		
		private function isAPIReady(e:Event):void 
		{
			FGLok = true;
			onAPICount = rh.rh4EventCount;
			ho.generateEvent(0,0);
		}
		
		private function isError(e:Event):void 
		{
			szError = ""+e;		// translating all to string
			nError  =  int(e.type.toString());			
			onErrorCount = rh.rh4EventCount;
			ho.generateEvent(5,0);
		}
		
		private function onLoaded(e:Event):void 
		{
			szError = "";
			nError  = 0;			
			onLoadEventCount = rh.rh4EventCount;
			ho.generateEvent(1,0);
			fglAd.removeEventListener(FGLAds.EVT_AD_LOADED, onLoaded);
		}
		
		private function onShown(e:Event):void 
		{
			szError = "";
			nError  = 0;			
			onShowEventCount = rh.rh4EventCount;
			ho.generateEvent(2,0);
			fglAd.removeEventListener(FGLAds.EVT_AD_SHOWN, onShown);
		}
		
		private function onClicked(e:Event):void 
		{
			szError = "";
			nError  = 0;			
			onClickEventCount = rh.rh4EventCount;
			ho.generateEvent(3,0);
			fglAd.removeEventListener(FGLAds.EVT_AD_CLICKED, onClicked);
		}
		
		private function onClosed(e:Event):void 
		{
			szError = "";
			nError  = 0;			
			onCloseEventCount = rh.rh4EventCount;
			ho.generateEvent(4,0);
			fglAd.removeEventListener(FGLAds.EVT_AD_CLOSED, onClosed);
		}
		
		/////////////////////////////////////////////////////
		
		public function getStatus():CValue
		{
			var ret:CValue = new CValue(0);
			var retStr:String="";
			
			if(fglAd != null)
				retStr= fglAd.status;
			
			ret.forceString(retStr);
			
			return ret;
		}
		
		public function getError():CValue
		{
			var ret:CValue = new CValue(0);
			ret.forceString(szError);			
			return ret;
		}
		
		public function ToggleAPI():void
		{
			if(fglAd != null) {
				if(FGLenable)
					fglAd.enable();
				else
					fglAd.disable();
			}
		}
		
		public override function expression(num:int):CValue
		{
			var ret:CValue;
			switch (num)
			{
				case 0:
					return new CValue(nError);
				case 1:
					return getError();
				case 2:
					return getStatus();
			}
			return new CValue(0);//won't be used
		}

	}
}