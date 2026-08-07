//----------------------------------------------------------------------------------
//
// CDEMOWARNING : ecran de debut de demo
//
//----------------------------------------------------------------------------------
package Application
{
	import Services.*;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.*;
	
	public class CDemoWarning
	{
		public var app:CRunApp;
		public var sprite:Sprite;
		public var textField:TextField;
		public var timerStart:int;
				
		public function CDemoWarning(a:CRunApp, langage:int)
		{
			app=a;
			sprite=new Sprite();
			app.mainSprite.addChild(sprite);
			
			sprite.x=0;
			sprite.y=0;
			sprite.graphics.clear();
			sprite.graphics.beginFill(0xFFFFFF);
			sprite.graphics.drawRect(0, 0, app.gaCxWin, app.gaCyWin);
			sprite.graphics.endFill();	
			
			var fi:CFontInfo=new CFontInfo();
			fi.init();
			fi.lfHeight=22;
			var tf:TextFormat=fi.getTextFormat();
			tf.align=TextFormatAlign.CENTER;
			tf.color=0x000000;		
			textField=new TextField();
			textField.width=320;
			textField.height=300;
			textField.x=app.gaCxWin/2-textField.width/2;
			textField.y=app.gaCyWin/2-100;
			textField.multiline=true;
			textField.wordWrap=true;
			textField.mouseEnabled=false;
			textField.selectable=false;
			textField.visible=true;
			if (langage==1)
			{
				textField.htmlText="This application has been created with a demo version of\nMultimedia Fusion 2\nor The Games Factory 2.\n\nIt cannot be distributed\nin any way.";
			}
			else if (langage==2)
			{
				textField.htmlText="Cette application a été créée avec une version démo de\nMultimedia Fusion 2\nou de The Games Factory 2.\n\nElle ne peut en aucun cas\nêtre distribuée.";
			}
			textField.setTextFormat(tf);				
			sprite.addChild(textField);
			
        	timerStart=getTimer();			
		}
		public function handle():Boolean
		{
			var timer:int=getTimer();
			if (timer-timerStart>1000*3)
			{
				app.mainSprite.removeChild(sprite);
				return true;
			}	
			return false;
		}
	}
}