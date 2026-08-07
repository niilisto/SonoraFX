//----------------------------------------------------------------------------------
//
// CQuestion : Objet question
//
//----------------------------------------------------------------------------------
package Objects
{
	import Frame.CLayer;
	
	import OI.*;
	
	import Services.*;
	import Banks.*;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CQuestion extends CObject
	{
		public var textFields:Array;
		public var answers:Array;
		public var rcA:Array;
		public var backSprite:Sprite;
		public var numQuestions:int;
		public var currentDown:int;
		
		public function CQuestion()
		{
		}

	    public override function handle():void
	    {
	        var r:int;
	
	        hoAdRunHeader.pause();
	        askQuestion();
			hoCallRoutine=false;
	    }
	    
	    public function askQuestion():void
	    {
   	        // Pointer sur le oc
	        var defTexts:CDefTexts= CDefTexts(hoCommon.ocObject);
	        var ptta:CDefText=defTexts.otTexts[1];
	        var colorA:int = ptta.tsColor;
	        var flagRelief:Boolean = (ptta.tsFlags & CDefText.TSF_RELIEF) != 0;
	        var fontAnswers:CFont = hoAdRunHeader.rhApp.fontBank.getFontFromHandle(ptta.tsFont);

	        var xa_margin:int = 12;							// Marge = "XX"
	        var hta:int = 4;
	        var lgBox:int = 64;
	        var i:int;

			numQuestions=defTexts.otTexts.length;
			textFields=new Array(numQuestions);
		
			// Creation textes reponses / Calcul taille rectangle	
	        for (i = 1; i < defTexts.otTexts.length; i++)
        	{
            	ptta = defTexts.otTexts[i];
            	textFields[i]=new TextField();
				textFields[i].mouseEnabled=false;
				textFields[i].selectable=false;
            	
				var tf:TextFormat=new TextFormat();
				tf.align=TextFormatAlign.LEFT;
				tf.color=colorA;
				tf.font=fontAnswers.lfFaceName;
				tf.size=fontAnswers.lfHeight;
				if (fontAnswers.lfWeight>600)
					tf.bold=true;
				if (fontAnswers.lfItalic!=0)
					tf.italic=true;
				if (fontAnswers.lfUnderline!=0)
					tf.underline=true;
				if (flagRelief)
					tf.bold=true;
					
				textFields[i].text=ptta.tsText;
				textFields[i].setTextFormat(tf);           	
            	lgBox=Math.max(lgBox, textFields[i].textWidth+xa_margin*2+4);
            	hta=Math.max(hta, textFields[i].textHeight*3/2);
            	textFields[i].width=lgBox;
            	textFields[i].height=hta;
            }
	        var hte:int = Math.max(hta / 4, 2);
	        lgBox += xa_margin * 2 + 4;								// Ajouter marge en dehors boutons
            
            // Creation texte question / calcul taille rectangle
        	var ptts:CDefText = defTexts.otTexts[0];
        	var fontQuestion:CFont = hoAdRunHeader.rhApp.fontBank.getFontFromHandle(ptts.tsFont);
	        var xq_margin:int = 12;								// Marge = "XX"
        	
        	textFields[0]=new TextField();        	
			textFields[0].mouseEnabled=false;
			textFields[0].selectable=false;
			tf=new TextFormat();
			tf.align=TextFormatAlign.LEFT;
			tf.color=ptts.tsColor;
			tf.font=fontQuestion.lfFaceName;
			tf.size=fontQuestion.lfHeight;
			if (fontQuestion.lfWeight>600)
				tf.bold=true;
			if (fontQuestion.lfItalic!=0)
				tf.italic=true;
			if (fontQuestion.lfUnderline!=0)
				tf.underline=true;
	        if ((ptts.tsFlags & CDefText.TSF_RELIEF) != 0)
				tf.bold=true;
				
        	ptta = defTexts.otTexts[0];
			textFields[0].text=ptta.tsText;
			textFields[0].setTextFormat(tf);           	
        	lgBox=Math.max(lgBox, textFields[0].textWidth+xa_margin*2+4);
        	var htq:int=Math.max(hta, textFields[0].textHeight*3/2);
        	textFields[0].width=lgBox;
        	textFields[0].height=htq;

			// Cree le sprite de fond
			backSprite=new Sprite();
			var layer:CLayer=hoAdRunHeader.rhFrame.layers[hoAdRunHeader.rhFrame.nLayers-1];
			layer.planeSprites.addChild(backSprite);
			backSprite.x=hoX-hoAdRunHeader.rhWindowX;
			backSprite.y=hoY-hoAdRunHeader.rhWindowY;
			
			// Affiche le fond de la question
			var rcQ:CRect=new CRect();
        	rcQ.left=0;
        	rcQ.top=0;
        	rcQ.right=lgBox;
        	rcQ.bottom=htq + 1 + (hta + hte) * (defTexts.otTexts.length - 1) + hte + 4;		
			backSprite.graphics.beginFill(CServices.RGBFlash(192, 192, 192));
			backSprite.graphics.drawRect(0, 0, rcQ.right, rcQ.bottom);
			backSprite.graphics.endFill();
			border3D(backSprite.graphics, rcQ, false);
			
	        // Afficher la question elle-meme
	        rcQ.left += 2;
	        rcQ.top += 2;
	        rcQ.right -= 2;
	        rcQ.bottom = rcQ.top + htq;
	        backSprite.addChild(textFields[0]);
	        textFields[0].x=rcQ.left+(rcQ.right-rcQ.left)/2-textFields[0].textWidth/2;
	        textFields[0].y=rcQ.top+(rcQ.bottom-rcQ.top)/2-textFields[0].textHeight/2;
	        rcQ.top = rcQ.bottom;
        	backSprite.graphics.lineStyle(1, CServices.RGBFlash(128, 128, 128));
        	backSprite.graphics.moveTo(rcQ.left, rcQ.top);
        	backSprite.graphics.lineTo(rcQ.right, rcQ.bottom);
	        rcQ.top += 1;
	        rcQ.bottom += 1;
        	backSprite.graphics.moveTo(rcQ.left, rcQ.top);
        	backSprite.graphics.lineTo(rcQ.right, rcQ.bottom);
			
	        // Afficher les reponses
	        answers=new Array(defTexts.otTexts.length);	        
	        rcA=new Array(defTexts.otTexts.length);
	        for (i = 1; i < defTexts.otTexts.length; i++)
	        {
	            ptts = defTexts.otTexts[i];
	
	        	rcA[i]=new CRect();
	        	rcA[i].left=2 + xa_margin;	        	
	        	rcA[i].top=2 + htq + 1 + hte + (hta + hte) * (i - 1);
	        	rcA[i].right=lgBox - 2 - xa_margin;
	        	rcA[i].bottom=rcA[i].top + hta;
	        	
	        	answers[i]=new Sprite();
	        	answers[i].x=rcA[i].left;
	        	answers[i].y=rcA[i].top;
	        	backSprite.addChild(answers[i]);
	        	answers[i].addChild(textFields[i]);
	        	
	            redraw_Answer(answers[i].graphics, textFields[i], rcA[i], false);
	        }			
	        hoAdRunHeader.questionObjectOn=this;
	    }
	    public function destroyObject():void
	    {
			var layer:CLayer=hoAdRunHeader.rhFrame.layers[hoAdRunHeader.rhFrame.nLayers-1];
			layer.planeSprites.removeChild(backSprite);
			
	    }
	    public function handleQuestion():Boolean
	    {
	    	var current:int;
	    	if (currentDown==0)
	    	{
	    		if (hoAdRunHeader.rhApp.keyBuffer[260]!=0)
	    		{
	    			current=getQuestion();
	    			if (current!=0)
	    			{
	    				currentDown=current;
	    				answers[currentDown].graphics.clear();
	    				redraw_Answer(answers[currentDown].graphics, textFields[currentDown], rcA[currentDown], true);
	    			}
	    		}
	    	}
	    	else
	    	{
	    		if (hoAdRunHeader.rhApp.keyBuffer[260]==0)
	    		{
    				answers[currentDown].graphics.clear();
    				redraw_Answer(answers[currentDown].graphics, textFields[currentDown], rcA[currentDown], false);
    				if (getQuestion()==currentDown)
    				{
				        var defTexts:CDefTexts= CDefTexts(hoCommon.ocObject);
		        		var ptts:CDefText = defTexts.otTexts[currentDown];
						var bCorrect:Boolean=(ptts.tsFlags & CDefText.TSF_CORRECT) != 0;
			            hoAdRunHeader.rhEvtProg.push_Event(1, (((-80 - 3) << 16) | 4), currentDown, this, 0);	    // CNDL_QEQUAL
			            if (bCorrect)
			            {
			                hoAdRunHeader.rhEvtProg.push_Event(1, (((-80 - 1) << 16) | 4), 0, this, 0);	    // CNDL_QEXACT
			            }
			            else
			            {
			                hoAdRunHeader.rhEvtProg.push_Event(1, (((-80 - 2) << 16) | 4), 0, this, 0);	    // CNDL_QFALSE
			            }
						destroyObject();
				        hoAdRunHeader.questionObjectOn=null;
				        hoAdRunHeader.resume();
				        hoAdRunHeader.destroy_Add(hoNumber);
						hoCallRoutine=false;
				        return true;
    				}
	    			currentDown=0;
	    		}
	    	}
	    	return false;
	    }
	    public function getQuestion():int
	    {
	    	var i:int;
	    	var rc:CRect=new CRect();
	    	for (i=1; i<numQuestions; i++)
	    	{
	    		rc.left=hoX-hoAdRunHeader.rhWindowX+rcA[i].left;
	    		rc.top=hoY-hoAdRunHeader.rhWindowY+rcA[i].top;
	    		rc.right=hoX-hoAdRunHeader.rhWindowX+rcA[i].right;
	    		rc.bottom=hoY-hoAdRunHeader.rhWindowY+rcA[i].bottom;
	    		
	    		var xMouse:int=hoAdRunHeader.rhApp.mouseX;
	    		var yMouse:int=hoAdRunHeader.rhApp.mouseY;
	    		if (xMouse>=rc.left && xMouse<rc.right)
	    		{
	    			if (yMouse>rc.top && yMouse<rc.bottom)
	    			{
	    				return i;
	    			}
	    		}
	    	}
	    	return 0;
	    }
		public function redraw_Answer(g:Graphics, textField:TextField, rc:CRect, state:Boolean):void
		{
			var rcBox:CRect=new CRect();
			rcBox.left=0;
			rcBox.top=0;		
			rcBox.right=rc.right-rc.left;
			rcBox.bottom=rc.bottom-rc.top;
			
			g.beginFill(CServices.RGBFlash(192,192,192));
			g.drawRect(0, 0, rcBox.right, rcBox.bottom);
			g.endFill();
	
	        border3D(g, rcBox, state);			// Cadre 3D
	
	        rcBox.left += 2;
	        rcBox.top += 2;
	        rcBox.right -= 4;
	        rcBox.bottom -= 4;
	        if (state)
	        {
	            rcBox.left += 2;
	            rcBox.top += 2;
	        }
			textField.x=rcBox.left+(rcBox.right-rcBox.left)/2-textField.textWidth/2;
			textField.y=rcBox.top+(rcBox.bottom-rcBox.top)/2-textField.textHeight/2;
		}
		public function border3D(g:Graphics, rc:CRect, state:Boolean):void
		{
	        var color1:int, color2:int;
	
	        if (state)
	        {
	            color1 = CServices.RGBFlash(128, 128, 128);
	            color2 = CServices.RGBFlash(255, 255, 255);
	        }
	        else
	        {
	            color2 = CServices.RGBFlash(128, 128, 128);
	            color1 = CServices.RGBFlash(255, 255, 255);
	        }
	
	        // Cadre noir
			g.lineStyle(1, CServices.RGBFlash(0,0,0));				
	        g.drawRect(rc.left, rc.top, rc.right - rc.left, rc.bottom - rc.top);
	
	        // Reflet blanc (ou gris si enfonce)
	        var pt:Array = new Array(3);
	        var n:int;
	        for (n = 0; n < 3; n++)
	        {
	            pt[n] = new CPoint();
	        }
	        pt[0].x = rc.right - 1;
	        if (state == false)
	        {
	            pt[0].x -= 1;
	        }
	        pt[0].y = rc.top + 1;
	        pt[1].y = rc.top + 1;
	        pt[1].x = rc.left + 1;
	        pt[2].x = rc.left + 1;
	        pt[2].y = rc.bottom;
	        if (state == false)
	        {
	            pt[2].y -= 1;
	        }
			g.lineStyle(1, color1);
			g.moveTo(pt[0].x, pt[0].y);
			g.lineTo(pt[1].x, pt[1].y);
			g.lineTo(pt[2].x, pt[2].y);				
	
	        if (state == false)
	        {
	            pt[0].x -= 1;
	        }
	        pt[0].y += 1;
	        pt[1].x += 1;
	        pt[1].y += 1;
	        pt[2].x += 1;
	        if (state == false)
	        {
	            pt[2].y -= 1;
	        }
	        g.moveTo(pt[0].x, pt[0].y);
	        g.lineTo(pt[1].x, pt[1].y);
	        g.lineTo(pt[2].x, pt[2].y);
	
	        // Reflet gris fonce
	        if (state == false)
	        {
	            pt[0].x += 2;
	            pt[1].x = rc.right - 1;
	            pt[1].y = rc.bottom - 1;
	            pt[2].y = rc.bottom - 1;
	            pt[2].x -= 1;
	            g.lineStyle(1, color2);
	            g.moveTo(pt[0].x, pt[0].y);
	            g.lineTo(pt[1].x, pt[1].y);
	            g.lineTo(pt[2].x, pt[2].y);
	
	            pt[0].x -= 1;
	            pt[0].y += 1;
	            pt[1].x -= 1;
	            pt[1].y -= 1;
	            pt[2].x += 1;
	            pt[2].y -= 1;
	            
	            g.moveTo(pt[0].x, pt[0].y);
	            g.lineTo(pt[1].x, pt[1].y);
	            g.lineTo(pt[2].x, pt[2].y);
	        }
		}
	}
}