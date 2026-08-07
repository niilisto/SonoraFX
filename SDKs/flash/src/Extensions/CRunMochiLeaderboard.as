//----------------------------------------------------------------------------------
//
// CRUNMOCHILEADERBOARD : Leaderboard object
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
	
	import flash.display.MovieClip;	
	
	public class CRunMochiLeaderboard extends CRunExtension
	{
		private static var FLAG_CHECKONSTART:int=0x0001;
		private static var FLAG_PRELOADER:int=0x0002;
		private static var FLAG_SHOWRANK:int=0x0004;
		private static var FLAG_PREVIEWSCORES:int=0x0008;
		private var flags:int;
		private var numScores:int;
		private var playerNumber:int;
		private var gameIDString:String;
		private var boardIDString:String;
		private var bToCheck:Boolean;
		private var movieClip:MovieClip;
		private var bConnectError:Boolean;
		private var bToConnect:Boolean;
		
		public function CRunMochiLeaderboard()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 0;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.hoImgWidth = file.readInt();
	        ho.hoImgHeight = file.readInt();
	        flags=file.readInt();
	        numScores=file.readShort();
	        playerNumber=file.readShort();
	        gameIDString=file.readStringSize(32);
	        boardIDString=file.readStringSize(32);
	        bToCheck=true;
	        
	        return false;
	    }

		public override function destroyRunObject(bFlag:Boolean):void
		{
		}
		
	    public override function handleRunObject():int
	    {
	    	if (bToCheck)
	    	{
	    		bToCheck=false;
		        movieClip = new MovieClip();
		        movieClip.width=rh.rhApp.gaCxWin;
		        movieClip.height=rh.rhApp.gaCyWin;
		       	rh.rhApp.planeControls.addChild(movieClip);
		       	
		       	bConnectError=false;
		       	MochiServices.connect(gameIDString, movieClip, onConnectError);
		       	bToConnect=true;
		    }
		    if (bToConnect)
		    {
		    	if (MochiServices.connected)
		    	{
			    	bToConnect=false;
		    	
		       		var playerScore:int=rh.rhApp.getScores()[playerNumber];
		       		var width:int=ho.hoImgWidth;
		       		var height:int=ho.hoImgWidth;
		       		var numScores:int=numScores;
		       		var showRankString:String="false";
					var resolutionString:String=rh.rhApp.gaCxWin.toString()+"x"+rh.rhApp.gaCyWin.toString();
		       		
		       		if ((flags&FLAG_SHOWRANK)!=0)
		       		{
		       			showRankString="true";
		       		}
		       		var previewScoresString:String="false";
		       		if ((flags&FLAG_PREVIEWSCORES)!=0)
		       		{
		       			previewScoresString="true";
		       		}
		       		var preloaderString:String="false";
		       		if ((flags&FLAG_PRELOADER)!=0)
		       		{
		       			preloaderString="true";
		       		}
		       		MochiScores.showLeaderboard({boardID:boardIDString, score:playerScore, onClose:closeLeaderBoard, res:resolutionString});
		       	}	    		
	    	}
	    	return 0;
	    }
	    
		public function onConnectError(status:String):void 
		{
    		bConnectError=true;
    		bToConnect=false;
		}
		
		public function closeLeaderBoard():void 
		{
			rh.rhApp.planeControls.removeChild(movieClip);
		}
	    
		public override function displayRunObject():void
		{
		}
	    
	}
}