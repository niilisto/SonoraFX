//----------------------------------------------------------------------------------
//
// CRunkchisc: high score object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import Actions.CActExtension;
	
	import Conditions.CCndExtension;
	
	import Expressions.CValue;
	
	import Frame.CLayer;
	
	import OI.CObjectCommon;
	
	import Params.CPositionInfo;
	
	import RunLoop.CCreateObjectInfo;
	import RunLoop.CRun;
	
	import Services.CArrayList;
	import Services.CBinaryFile;
	import Services.CFontInfo;
	
	public class CRunkchisc extends  CRunExtension
	{
	    public static var SCR_HIDEONSTART:int = 0x0001;
	    public static var SCR_NAMEFIRST:int = 0x0002;
	    public static var SCR_CHECKONSTART:int = 0x0004;
	    public static var SCR_DONTDISPLAYSCORES:int = 0x0008;
	    public static var SCR_FULLPATH:int = 0x0010;

	    public static var CND_ISPLAYER:int = 0;
	    public static var CND_VISIBLE:int = 1;

	    public static var ACT_ASKNAME:int = 0;
	    public static var ACT_HIDE:int = 1;
	    public static var ACT_SHOW:int = 2;
	    public static var ACT_RESET:int = 3;
	    public static var ACT_CHANGENAME:int = 4;
	    public static var ACT_CHANGESCORE:int = 5;
	    public static var ACT_SETPOSITION:int = 6;
	    public static var ACT_SETXPOSITION:int = 7;
	    public static var ACT_SETYPOSITION:int = 8;
	    public static var ACT_INSERTNEWSCORE:int = 9;
	    public static var ACT_SETCURRENTFILE:int = 10;

	    public static var EXP_VALUE:int = 0;
	    public static var EXP_NAME:int = 1;
	    public static var EXP_GETXPOSITION:int = 2;
	    public static var EXP_GETYPOSITION:int = 3;

		public static var INPUTBOX_SX:int=320;
		public static var INPUTBOX_SY:int=140;
		public static var INPUTTITLE_Y:int=6;
		public static var INPUTNAME_X:int=10;
		public static var INPUTNAME_Y:int=35;
		public static var INPUTEDIT_X:int=10;
		public static var INPUTEDIT_Y:int=60;
		public static var INPUTBUTTON_SX:int=100;
		public static var INPUTBUTTON_SY:int=32;
		public static var INPUTBUTTON_Y:int=95;
		public static var INPUTBUTTONTEXT_Y:int=6;
		
	    private var sVisible:Boolean;
	    private var NbScores:int;
	    private var NameSize:int;
	    private var Flags:int;
	    private var Logfont:CFontInfo;
	    private var Colorref:int;
	    private var Names:Array;
	    private var Scores:Array;
	    private var originalNames:Array;
	    private var originalScores:Array;
	    private var scrPlayer:Array;
	    private var IniName:String;
	    private var started:int = 0;
    	private var sharedObject:SharedObject;
		private var textFieldNames:Array;
		private var textFieldScores:Array;
		private var sprite:Sprite;
		private var plane:Sprite;
		private var newScore:int;
		private var askForScore:CArrayList;
		private var oldReturnKey:Boolean;
		private var pLayer:CLayer;
		
		private var inputSprite:Sprite;
		private var inputTitle:TextField;
		private var inputEdit:TextField;
		private var inputName:TextField;
		private var inputButton:Sprite;
		private var inputButtonTextField:TextField;
		private var oldInputButtonState:int;
		private var xSave:int, ySave:int;
		
		public function CRunkchisc()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 2;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.setX(cob.cobX);
	        ho.setY(cob.cobY);
			xSave=ho.hoX;
			ySave=ho.hoY;
			
	        NbScores = file.readShort();
	        NameSize = file.readShort();
	        Flags = file.readShort();
	        if (ho.hoAdRunHeader.rhApp.bUnicode == false)
	        {
	            Logfont = file.readLogFont16();
	        }
	        else
	        {
	            Logfont = file.readLogFont();
	        }
	        Colorref = file.readColor();
	        file.readStringSize(40);
	        var i:int;
	       	Names=new Array(20);
	       	originalNames=new Array(20);
	        for (i = 0; i < 20; i++)
	        {
	            Names[i] = file.readStringSize(41);
	            originalNames[i]=Names[i];
	        }
	        Scores=new Array(20);
	        originalScores=new Array(20);
	        for (i = 0; i < 20; i++)
	        {
	            Scores[i] = file.readInt();
	            originalScores[i]=Scores[i];
	        }
	        ho.setWidth(file.readShort());
	        ho.setHeight(file.readShort());
	        if ((Flags & SCR_HIDEONSTART) == 0)
	        {
	            sVisible = true;
	        }
			if ((cob.cobFlags&CRun.COF_HIDDEN)!=0)
			{
				sVisible=false;
			}
	        IniName = file.readStringSize(260);
	        IniName=parseName(IniName);
	        if (IniName.length==0)
	        {
	        	IniName="Game.ini";
	        }
	        scrPlayer=new Array(4);
	        for (i=0; i<4; i++)
	        {
	        	scrPlayer[i]=0;
	        }
	        sharedObject=null;	      
	        loadScores(IniName);
	        textFieldNames=null;
	        textFieldScores=null;
	        sprite=null;
	        inputSprite=null;
	        oldInputButtonState=-1;
			pLayer=rh.rhFrame.layers[ho.hoLayer];
			plane=pLayer.planeSprites;
			askForScore=new CArrayList();
			oldReturnKey=false;
				
	        return true;
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
	        saveScores(IniName);
	    }
		public override function handleRunObject():int
		{
			if (sprite==null)
			{
				return 0;
			}
			ho.hoOEFlags|=CObjectCommon.OEFLAG_NEVERSLEEP;

			var a:int, b:int;
	        var players:Array = new Array(4);
	        var TriOk:Boolean;
	        var rhPtr:CRun = ho.hoAdRunHeader;
	        var score1:int, score2:int;
	        var ret:int=0;
	        if ((Flags & SCR_CHECKONSTART) != 0)
	        {
	            // Init player order
	            for (a = 0; a < 4; a++)
	            {
	                players[a] = a;
	            }
	            // Sort player order (bigger score asked first)
	            do
	            {
	                TriOk = true;
	                for (a = 1; a < 4; a++)
	                {
	                    score1 = rhPtr.rhApp.getScores()[players[a]];
	                    score2 = rhPtr.rhApp.getScores()[players[a - 1]];
	                    if (score1 > score2)
	                    {
	                        b = players[a - 1];
	                        players[a - 1] = players[a];
	                        players[a] = b;
	                        TriOk = false;
	                    }
	                }
	            } while (false == TriOk);
	            started++;
	            var shown:int = 0;
	            // Check for hi-scores
	            for (a = 0; a < rhPtr.rhNPlayers; a++)
	            {
	                CheckScore(players[a]);
	            }
            	Flags&=~SCR_CHECKONSTART;
	        }
	        if (inputSprite!=null)
	        {
	        	var inputButtonState:int=0;
	        	if (ho.hoAdRunHeader.rhApp.mouseX>=inputSprite.x+inputButton.x && ho.hoAdRunHeader.rhApp.mouseX<=inputSprite.x+inputButton.x+INPUTBUTTON_SX)
	        	{
		        	if (ho.hoAdRunHeader.rhApp.mouseY>=inputSprite.y+inputButton.y && ho.hoAdRunHeader.rhApp.mouseY<=+inputSprite.y+inputButton.y+INPUTBUTTON_SY)
		        	{
		        		inputButtonState=1;
		        	}
		        	if (ho.hoAdRunHeader.rhApp.keyBuffer[260]!=0)
		        	{
		        		inputButtonState=2;
		        	}
	        	} 
	        	var bReturn:Boolean=false;
	        	if (ho.hoAdRunHeader.rhApp.keyBuffer[13]!=0)
	        	{
	        		if (oldReturnKey==false)
	        		{
						bReturn=true;
						oldReturnKey=true;	        				
	        		}
	        	}
	        	else
	        	{
	        		oldReturnKey=false;
	        	}
	        	if (inputButtonState!=oldInputButtonState || bReturn)
	        	{
	        		if ((oldInputButtonState==2 && inputButtonState==1) || bReturn)
	        		{
	        			var inputPlayerName:String=inputEdit.text;
	        			rh.rhApp.planeControls.removeChild(inputSprite);	        			
	        			inputSprite=null;
	        			inputTitle=null;
	        			inputEdit=null;
	        			inputName=null;
	        			inputButton=null;
	        			inputButtonTextField=null;
	        			InsertNewScore(newScore, inputPlayerName)
	        			saveScores(IniName);
	        			ret=REFLAG_DISPLAY;
	        			rh.rhHiscore=null;
	        			rh.resume();	        			
	        		}
	        		else
	        		{
	        			oldInputButtonState=inputButtonState;
	        			displayButton(inputButtonState);
	        		}
	        	}
	        }
	        else
	        {
	        	if (askForScore.size()>0)
	        	{
	        		var player:int=int(askForScore.get(0));
		            newScore = rhPtr.rhApp.scores[player];
	        		askForScore.removeIndex(0);
		        	askForName("Hi-score - Player: "+player.toString()+" - Score: " + newScore.toString());
	        	}	        	
	        }
	        return ret;
		}
		private function askForName(title:String):void
		{
			inputSprite=new Sprite();
			rh.rhApp.planeControls.addChild(inputSprite);
			inputSprite.x=rh.rhApp.gaCxWin/2-INPUTBOX_SX/2;
			inputSprite.y=rh.rhApp.gaCyWin/2-INPUTBOX_SY/2;
			inputSprite.graphics.clear();
	    	inputSprite.graphics.beginFill(0xB9C3FF);
			inputSprite.graphics.lineStyle(5, 0);				
			inputSprite.graphics.drawRect(0, 0, INPUTBOX_SX, INPUTBOX_SY);
			inputSprite.graphics.endFill();
			rh.pause();
			rh.rhHiscore=ho;
			
			var fi:CFontInfo=new CFontInfo();
			fi.init();
			var tf:TextFormat=fi.getTextFormat();
			tf.align=TextFormatAlign.CENTER;
			tf.bold=true;
			inputTitle=new TextField();
			inputTitle.x=0;
			inputTitle.y=INPUTTITLE_Y;
			inputTitle.width=INPUTBOX_SX;
			inputTitle.text=title;
			inputTitle.setTextFormat(tf);
			inputTitle.mouseEnabled=false;
			inputTitle.selectable=false;
			inputSprite.addChild(inputTitle);
			
			tf.align=TextFormatAlign.LEFT;
			tf.bold=false;
			inputName=new TextField();
			inputName.x=INPUTNAME_X;
			inputName.y=INPUTNAME_Y;
			inputName.width=INPUTBOX_SX;
			inputName.text="Please enter your name :";
			inputName.setTextFormat(tf);
			inputName.mouseEnabled=false;
			inputName.selectable=false;
			inputSprite.addChild(inputName);
						
			inputEdit=new TextField();
			inputEdit.x=INPUTEDIT_X;
			inputEdit.y=INPUTEDIT_Y;
			inputEdit.width=INPUTBOX_SX-INPUTEDIT_X*2;
			inputEdit.height=20;
			inputEdit.border=true;
			inputEdit.borderColor=0;
        	inputEdit.type=TextFieldType.INPUT;
			inputEdit.background=true;
			inputEdit.backgroundColor=0xFFFFFF;
			inputEdit.setTextFormat(tf);
			inputEdit.mouseEnabled=true;
			inputEdit.selectable=true;
			inputSprite.addChild(inputEdit);

			inputButton=new Sprite();
			inputSprite.addChild(inputButton);
			inputButtonTextField=new TextField();
			inputButton.addChild(inputButtonTextField);
			inputButton.x=INPUTBOX_SX/2-INPUTBUTTON_SX/2;
			inputButton.y=INPUTBUTTON_Y;
			displayButton(0);
			
			oldInputButtonState=0;
		}
		private function displayButton(state:int):void
		{
			var color:int;
			var x:int, y:int;
			
	    	var colorsRect:Array;
	    	var colorsFill:Array;
	    	var alphas:Array;
	    	var ratios:Array;
	    	var matr:Matrix;

			inputButton.graphics.clear();
	    	colorsRect=[0xB7BABC, 0x5E6162];
	    	colorsFill=[0xDBE1E5, 0x9EABB2];
	    	if (state==1)
	    	{
	    		colorsRect[0]=0x009DFF;
	    		colorsRect[1]=0x0076C1;
	    		colorsFill[0]=0xE8EDEF;
	    		colorsFill[1]=0xC7CFD2;
	    	}
	    	if (state==2)
	    	{
	    		colorsRect[0]=0x0081FF;
	    		colorsRect[1]=0x0076C1;
	    		colorsFill[0]=0xD8F0FF;
	    		colorsFill[1]=0x9BD8FF;
			}
	    	alphas=[1, 1];
	    	ratios=[0, 255];
	    	matr=new Matrix();
    		matr.createGradientBox(ho.hoImgWidth-1, ho.hoImgHeight-1, Math.PI/2, 0, 0);
	    	inputButton.graphics.clear();
	    	inputButton.graphics.lineStyle(1);
	    	inputButton.graphics.lineGradientStyle(GradientType.LINEAR, colorsRect, alphas, ratios, matr, SpreadMethod.PAD);
	    	inputButton.graphics.beginGradientFill(GradientType.LINEAR, colorsFill, alphas, ratios, matr, SpreadMethod.PAD);
			inputButton.graphics.drawRoundRect(0, 0, INPUTBUTTON_SX, INPUTBUTTON_SY, 7);
			inputButton.graphics.endFill();
				
			// Trouve la hauteur du texte
			var fi:CFontInfo=new CFontInfo();
			fi.init();
			var tf:TextFormat=fi.getTextFormat();
			tf.align=TextFormatAlign.CENTER;
			tf.bold=true;
			tf.color=0x000000;
			tf.align=TextFormatAlign.CENTER;
			tf.color=0x000000;
			inputButtonTextField.width=INPUTBUTTON_SX;
			inputButtonTextField.text="OK";
			inputButtonTextField.setTextFormat(tf);
			inputButtonTextField.x=0;
			inputButtonTextField.y=INPUTBUTTONTEXT_Y;
		}
		public override function displayRunObject():void
		{
            var rhPtr:CRun = ho.hoAdRunHeader;
			if (sprite==null)
			{
				sprite=new Sprite();
				plane.addChild(sprite);
			}
			sprite.x=xSave+pLayer.x;
			sprite.y=ySave+pLayer.y;
			
            var names:Array = new Array(20);
            var i:int;
            for (i = 0; i < 20; i++)
            {
                names[i] = Names[i];
                if (names[i].length > NameSize)
                {
                    names[i] = names[i].substring(0, NameSize);
                }
            }

			var tf:TextFormat;
			var embeddedName:String=Logfont.getEmbeddedName();
			var embeddedFont:int=ho.hoAdRunHeader.rhApp.getEmbeddedFont(embeddedName);
			var bEmbedFont:Boolean=false;
			if (embeddedFont>=0)
			{
				bEmbedFont=true;
				tf.font=embeddedName;
				tf.align=TextFormatAlign.LEFT;
				tf.size=Logfont.lfHeight;
			}
			else
			{
				tf=Logfont.getTextFormat();
			}
			tf.align=TextFormatAlign.LEFT;
			tf.color=Colorref;
			
            if (textFieldNames==null)
            {
            	textFieldNames=new Array(20);
            	textFieldScores=new Array(20);
            }            
            if ((Flags & SCR_DONTDISPLAYSCORES) != 0)
            {
	            for (i=0; i<NbScores; i++)
	            {
	            	if (textFieldNames[i]==null)
	            	{
	            		textFieldNames[i]=new TextField();
	            		sprite.addChild(textFieldNames[i]);
	            	}
            		textFieldNames[i].x=0;
            		textFieldNames[i].y=(ho.hoImgHeight/NbScores)*i;
            		textFieldNames[i].width=ho.hoImgWidth;
					textFieldNames[i].mouseEnabled=false;
					textFieldNames[i].selectable=false;
					textFieldNames[i].text=Names[i];
					textFieldNames[i].embedFonts=bEmbedFont;
					textFieldNames[i].setTextFormat(tf);					
	            }
	       	}
	       	else
	       	{
                if ((Flags & SCR_NAMEFIRST)!=0)
                {
		            for (i=0; i<NbScores; i++)
		            {
		            	if (textFieldNames[i]==null)
		            	{
		            		textFieldNames[i]=new TextField();
		            		sprite.addChild(textFieldNames[i]);
		            	}
	            		textFieldNames[i].x=0;
	            		textFieldNames[i].y=(ho.hoImgHeight/NbScores)*i;
	            		textFieldNames[i].width=((ho.hoImgWidth / 4) * 3)
						textFieldNames[i].mouseEnabled=false;
						textFieldNames[i].selectable=false;
						textFieldNames[i].text=Names[i];
						textFieldNames[i].embedFonts=bEmbedFont;
						textFieldNames[i].setTextFormat(tf);
						
						if (textFieldScores[i]==null)
						{
							textFieldScores[i]=new TextField();
		            		sprite.addChild(textFieldScores[i]);
						}
	            		textFieldScores[i].x=((ho.hoImgWidth / 4) * 3);
	            		textFieldScores[i].y=(ho.hoImgHeight/NbScores)*i;
	            		textFieldScores[i].width=(ho.hoImgWidth / 4)
						textFieldScores[i].mouseEnabled=false;
						textFieldScores[i].selectable=false;
						textFieldScores[i].text=Scores[i].toString();
						textFieldScores[i].embedFonts=bEmbedFont;
						textFieldScores[i].setTextFormat(tf);
		            }
                }
                else
                {
		            for (i=0; i<NbScores; i++)
		            {
						if (textFieldScores[i]==null)
						{
							textFieldScores[i]=new TextField();
							sprite.addChild(textFieldScores[i]);
						}
	            		textFieldScores[i].x=0;
	            		textFieldScores[i].y=(ho.hoImgHeight/NbScores)*i;
	            		textFieldScores[i].width=(ho.hoImgWidth / 4)
						textFieldScores[i].mouseEnabled=false;
						textFieldScores[i].selectable=false;
						textFieldScores[i].text=Scores[i].toString();
						textFieldScores[i].embedFonts=bEmbedFont;
						textFieldScores[i].setTextFormat(tf);

		            	if (textFieldNames[i]==null)
		            	{
		            		textFieldNames[i]=new TextField();
							sprite.addChild(textFieldNames[i]);
		            	}
	            		textFieldNames[i].x=(ho.hoImgWidth / 4);
	            		textFieldNames[i].y=(ho.hoImgHeight/NbScores)*i;
	            		textFieldNames[i].width=((ho.hoImgWidth / 4) * 3)
						textFieldNames[i].mouseEnabled=false;
						textFieldNames[i].selectable=false;
						textFieldNames[i].text=Names[i];
						textFieldNames[i].embedFonts=bEmbedFont;
						textFieldNames[i].setTextFormat(tf);						
		            }
                }
	       	}
		}
	    
	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case CND_ISPLAYER:
	                return IsPlayerHiScore(cnd.getParamPlayer(rh, 0));
	            case CND_VISIBLE:
	                return IsVisible();	        
	        }
	    	return false;
	    }
	    private function IsPlayerHiScore(player:int):Boolean
	    {
	        var rhPtr:CRun = ho.hoAdRunHeader;
	        var score:int = rhPtr.rhApp.scores[player];
	        if ((score > Scores[NbScores - 1]) && (score != scrPlayer[player]))
	        {
	            scrPlayer[player] = score;
	            return true;
	        }
	        return false;
	    }
	
	    private function IsVisible():Boolean
	    {
	        return (sVisible);
	    }
	    
	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_ASKNAME:
	                CheckScore(act.getParamPlayer(rh, 0));
	                break;
	            case ACT_HIDE:
	                Hide();
	                break;
	            case ACT_SHOW:
	                Show();
	                break;
	            case ACT_RESET:
	                Reset();
	                break;
	            case ACT_CHANGENAME:
	                ChangeName(act.getParamExpression(rh, 0), act.getParamExpString(rh, 1));
	                break;
	            case ACT_CHANGESCORE:
	                ChangeScore(act.getParamExpression(rh, 0), act.getParamExpression(rh, 1));
	                break;
	            case ACT_SETPOSITION:
	                SetPosition(act);
	                break;
	            case ACT_SETXPOSITION:
	                SetXPosition(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETYPOSITION:
	                SetYPosition(act.getParamExpression(rh, 0));
	                break;
	            case ACT_INSERTNEWSCORE:
	                InsertNewScore(act.getParamExpression(rh, 0), act.getParamExpString(rh, 1));
	                break;
	            case ACT_SETCURRENTFILE:
	                SetCurrentFile(act.getParamExpString(rh, 0));
	                break;            
	        }
    	}
    	
	    public function CheckScore(player:int):Boolean //needed public and returns true when popup is shown
	    {
	        var rhPtr:CRun = ho.hoAdRunHeader;
	        if (player < rhPtr.rhNPlayers)
	        {
	            newScore = rhPtr.rhApp.scores[player];
	            if (newScore > Scores[NbScores - 1])
	            {
	            	askForScore.add(player);
	                return true;
	            }
	        }
	        return false;
	    }
	
	    private function Hide():void
	    {
	        sVisible = false;
	        sprite.visible=false;
	    }
	
	    private function Show():void
	    {
	        sVisible = true;
	        sprite.visible=true;
	    }
	
	    private function Reset():void
	    {
	    	var a:int;
	        for (a = 0; a < 20; a++)
	        {
	            Names[a] = originalNames[a];
	            Scores[a] = originalScores[a];
	        }
	        ho.redraw();
	    }
	
	    private function ChangeName(i:int, name:String):void //1based
	    {
	        if ((i > 0) && (i <= NbScores))
	        {
	            Names[i - 1] = name;
	            ho.redraw();
	        }
	    }
	
	    private function ChangeScore(i:int, score:int):void//1based
	    {
	        if ((i > 0) && (i <= NbScores))
	        {
	            Scores[i - 1] = score;
	            ho.redraw();
	        }
	    }
	
	    private function SetPosition(act:CActExtension):void
	    {
	    	var p:CPositionInfo=act.getParamPosition(rh, 0)
	    	sprite.x=p.x-ho.hoAdRunHeader.rhWindowX;
	    	sprite.y=p.y-ho.hoAdRunHeader.rhWindowY;
	    }
	
	    private function SetXPosition(x:int):void
	    {
	    	sprite.x=x-ho.hoAdRunHeader.rhWindowX;
	    }
	
	    private function SetYPosition(y:int):void
	    {
	    	sprite.y=y-ho.hoAdRunHeader.rhWindowY;
	    }
	
	    private function InsertNewScore(pScore:int, pName:String):void
	    {
	        if (pScore > Scores[NbScores - 1])
	        {
	            Scores[19] = pScore;
	            Names[19] = pName;
	            var b:int;
	            var TriOk:Boolean;
	            var score:int;
	            var name:String;
	            // Sort the hi-score table ws_visible
	            do
	            {
	                TriOk = true;
	                for (b = 1; b < 20; b++)
	                {
	                    if (Scores[b] > Scores[b - 1])
	                    {
	                        score = Scores[b - 1];
	                        name = Names[b - 1];
	                        Scores[b - 1] = Scores[b];
	                        Names[b - 1] = Names[b];
	                        Scores[b] = score;
	                        Names[b] = name;
	                        TriOk = false;
	                    }
	                }
	            } while (false == TriOk);
	
                ho.redraw();
	        }
	    }
	
	    private function SetCurrentFile(fileName:String):void
	    {
	        IniName = fileName;
	        loadScores(IniName);
	        ho.redraw();
	    }
	    
	    private function loadScores(fileName:String):void
	    {
	        var a:int;
			try
			{
	        	sharedObject=SharedObject.getLocal(fileName);
	        	if (sharedObject.data.names!=null)
	        	{
	        		var loadedNames:Array=sharedObject.data.names;
			        for (a = 0; a < loadedNames.length; a++)
			        {
			            Names[a] = loadedNames[a];
			        }
	        	}
	        	if (sharedObject.data.scores!=null)
	        	{
	        		var loadedScores:Array=sharedObject.data.scores;
			        for (a = 0; a < loadedNames.length; a++)
			        {
			            Scores[a] = loadedScores[a];
			            originalScores[a] = loadedScores[a];
			        }
	        	}
			}
			catch(error:Error)
			{
			}
	    }
	    private function saveScores(fileName:String):void
	    {
			try
			{
				sharedObject=SharedObject.getLocal(fileName);
	    		sharedObject.data.names=Names;
	    		sharedObject.data.scores=Scores;
               	sharedObject.flush();
            }
            catch(error:Error)
            {	                	
            }
	    }
	    
		// EXPRESSIONS
		// -------------------------------------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_VALUE:               
	                return GetValue(ho.getExpParam().getInt());
	            case EXP_NAME:
	                return GetName(ho.getExpParam().getInt());
	            case EXP_GETXPOSITION:
	                return GetXPosition();
	            case EXP_GETYPOSITION:
	                return GetYPosition();            
	        }
	        return new CValue(0);
	    }

	    private function GetValue(i:int):CValue
	    {
	        if ((i > 0) && (i <= NbScores))
	        {
	            return new CValue(Scores[i - 1]);
	        }
	        return new CValue(0);
	    }
	    private function GetName(i:int):CValue
	    {
	    	var ret:CValue=new CValue(0);
	    	ret.forceString("");
	        if ((i > 0) && (i <= NbScores))
	        {
	            ret.forceString(Names[i - 1]);
	        }
	        return ret;
	    }
	    private function GetXPosition():CValue
	    {
	        return new CValue(ho.hoX);
	    }
	    private function GetYPosition():CValue
	    {
	        return new CValue(ho.hoY);
	    }
	}
}