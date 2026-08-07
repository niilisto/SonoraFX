//----------------------------------------------------------------------------------
//
// CRunkcclock: date & time object
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Application.*;
	
	import Banks.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.*;
	
	import mx.formatters.DateFormatter;
	
	public class CRunkcclock extends CRunExtension
	{
	    public static var CND_CMPCHRONO:int = 0;
	    public static var CND_NEWSECOND:int = 1;
	    public static var CND_NEWMINUTE:int = 2;
	    public static var CND_NEWHOUR:int = 3;
	    public static var CND_NEWDAY:int= 4;
	    public static var CND_NEWMONTH:int = 5;
	    public static var CND_NEWYEAR:int = 6;
	    public static var CND_CMPCOUNTDOWN:int = 7;
	    public static var CND_VISIBLE:int = 8;
	    public static var ACT_SETCENTIEMES:int = 0;
	    public static var ACT_SETSECONDES:int = 1;
	    public static var ACT_SETMINUTES:int = 2;
	    public static var ACT_SETHOURS:int = 3;
	    public static var ACT_SETDAYOFWEEK:int = 4;
	    public static var ACT_SETDAYOFMONTH:int = 5;
	    public static var ACT_SETMONTH:int = 6;
	    public static var ACT_SETYEAR:int = 7;
	    public static var ACT_RESETCHRONO:int = 8;
	    public static var ACT_STARTCHRONO:int = 9;
	    public static var ACT_STOPCHRONO:int = 10;
	    public static var ACT_SHOW:int = 11;
	    public static var ACT_HIDE:int = 12;
	    public static var ACT_SETPOSITION:int = 13;
	    public static var ACT_SETCOUNTDOWN:int = 14;
	    public static var ACT_STARTCOUNTDOWN:int = 15;
	    public static var ACT_STOPCOUNTDOWN:int = 16;
	    public static var ACT_SETXPOSITION:int = 17;
	    public static var ACT_SETYPOSITION:int = 18;
	    public static var ACT_SETXSIZE:int = 19;
	    public static var ACT_SETYSIZE:int = 20;
	    public static var EXP_GETCENTIEMES:int = 0;
	    public static var EXP_GETSECONDES:int = 1;
	    public static var EXP_GETMINUTES:int = 2;
	    public static var EXP_GETHOURS:int = 3;
	    public static var EXP_GETDAYOFWEEK:int = 4;
	    public static var EXP_GETDAYOFMONTH:int = 5;
	    public static var EXP_GETMONTH:int = 6;
	    public static var EXP_GETYEAR:int = 7;
	    public static var EXP_GETCHRONO:int = 8;
	    public static var EXP_GETCENTERX:int = 9;
	    public static var EXP_GETCENTERY:int = 10;
	    public static var EXP_GETHOURX:int = 11;
	    public static var EXP_GETHOURY:int = 12;
	    public static var EXP_GETMINUTEX:int = 13;
	    public static var EXP_GETMINUTEY:int = 14;
	    public static var EXP_GETSECONDX:int = 15;
	    public static var EXP_GETSECONDY:int = 16;
	    public static var EXP_GETCOUNTDOWN:int = 17;
	    public static var EXP_GETXPOSITION:int = 18;
	    public static var EXP_GETYPOSITION:int = 19;
	    public static var EXP_GETXSIZE:int = 20;
	    public static var EXP_GETYSIZE:int = 21;

	    public static var ANALOG_CLOCK:int = 0;
	    public static var DIGITAL_CLOCK:int = 1;
	    public static var INVISIBLE:int = 2;
	    public static var CALENDAR:int = 3;
	    public static var CLOCK:int = 0;
	    public static var STOPWATCH:int = 1;
	    public static var COUNTDOWN:int = 2;
	    public static var SHORTDATE:int = 0;
	    public static var LONGDATE:int = 1;
	    public static var FIXEDDATE:int = 2;

	    public var months:Array =
	    [
	        0,
	        267840000,
	        509760000,
	        777600000,
	        1123200000,
	        1304640000,
	        1563840000,
	        1831680000,
	        2099520000,
	        2358720000,
	        2626560000,
	        2885760000,
	    ];
	    public var szRoman:Array=
	    [
	        "I",
	        "II",
	        "III",
	        "IV",
	        "V",
	        "VI",
	        "VII",
	        "VIII",
	        "IX",
	        "X",
	        "XI",
	        "XII"
	    ];
	    public var ADJ:int = 3;
	    public var sType:int;
	    public var sClockMode:int;
	    public var sClockBorder:Boolean;
	    public var sAnalogClockLines:Boolean;
	    public var sAnalogClockMarkerType:int;
	    public var sFont:CFontInfo;
	    public var crFont:int;
	    public var sAnalogClockSeconds:Boolean;
	    public var crAnalogClockSeconds:int;
	    public var sAnalogClockMinutes:Boolean;
	    public var crAnalogClockMinutes:int;
	    public var sAnalogClockHours:Boolean;
	    public var crAnalogClockHours:int;
	    public var sDigitalClockType:int;
	    public var sCalendarType:int;
	    public var sCalendarFormat:int;
	    public var lCountdownStart:int;
	    public var sMinWidth:int;
	    public var sMinHeight:int;
	    public var sVisible:Boolean;
	    public var lastRecordedTime:Date;
	    public var sDisplay:Boolean;
	    public var sUpdateCounter:int;
	    public var dChronoCounter:Number;
	    public var dChronoStart:Number;
	    public var lChrono:int;
	    public var sEventCount:int;
	    public var sCenterX:int;
	    public var sCenterY:int;
	    public var sHourX:int;
	    public var sHourY:int;
	    public var sMinuteX:int;
	    public var sMinuteY:int;
	    public var sSecondX:int;
	    public var sSecondY:int;
		public var plane:Sprite;
		public var sprite:Sprite;
		public var textFields:Array;
		public var pLayer:CLayer;
	    public var initialTime:Date;
	    public var startTimer:Date;
		public var textField:TextField;
		
		public function CRunkcclock()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 9;
	    }
	
	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        ho.setX(cob.cobX);
	        ho.setY(cob.cobY);
	        ho.hoImgXSpot = 0;
	        ho.hoImgYSpot = 0;
	        ho.setWidth(file.readShort());
	        ho.setHeight(file.readShort());
	        file.skipBytes(4 * 16);
	        this.sType = file.readShort();
	        this.sClockMode = file.readShort();
	        this.sClockBorder = (file.readShort() == 0) ? false : true;
	        this.sAnalogClockLines = (file.readShort() == 0) ? false : true;
	        this.sAnalogClockMarkerType = file.readShort();
	        var font:CFontInfo = file.readLogFont();
	        if ((font.lfHeight == 8) && (font.lfFaceName.toUpperCase()=="SYSTEM"))
	        {
	            font.lfHeight = 13; //c++ bug i think
	            font.lfWeight = 700;//bold
	        }
	        this.crFont = file.readColor();
	        file.readStringSize(40);
	        this.sAnalogClockSeconds = (file.readShort() == 0) ? false : true;
	        this.crAnalogClockSeconds = file.readColor();
	        this.sAnalogClockMinutes = (file.readShort() == 0) ? false : true;
	        this.crAnalogClockMinutes = file.readColor();
	        this.sAnalogClockHours = (file.readShort() == 0) ? false : true;
	        this.crAnalogClockHours = file.readColor();
	        this.sDigitalClockType = file.readShort();
	        this.sCalendarType = file.readShort();
	        this.sCalendarFormat = file.readShort();
	        file.readStringSize(40);
	        var sCountDownHours:int = file.readShort();
	        var sCountDownMinutes:int = file.readShort();
	        var sCountDownSeconds:int = file.readShort();
	        this.lCountdownStart = (sCountDownHours * 360000) + (sCountDownMinutes * 6000) + (sCountDownSeconds * 100);
	        this.sMinWidth = file.readShort();
	        this.sMinHeight = file.readShort();
	        switch (this.sType)
	        {
	            case ANALOG_CLOCK:
	            case CALENDAR:
	            case DIGITAL_CLOCK:
	                {
	                    this.sFont = font;
	                }
	                break;
	            case INVISIBLE:
	                break;
	        }
	        this.sDisplay = true;
        	initialTime = new Date();
        	startTimer = new Date();
        	lastRecordedTime = new Date();
			        
	        // Cree le sprite
	        sprite=new Sprite();
	      	pLayer=ho.hoAdRunHeader.rhFrame.layers[ho.ros.rsLayer];
			var bQuickDisplay:Boolean=(ho.hoOEFlags&CObjectCommon.OEFLAG_QUICKDISPLAY)!=0;	        
			if (bQuickDisplay)
			{
				plane=pLayer.planeQuickDisplay;
			}
			else
			{
				plane=pLayer.planeSprites;				
			}
		    plane.addChild(sprite);
	    	dChronoCounter=0;
	    	dChronoStart=0;

			if ((ho.ros.rsFlags&CRSpr.RSFLAG_HIDDEN)!=0)
				Hide();
			else
				Show();
			
	        return true;
	    }

	    public override function destroyRunObject(bFast:Boolean):void
	    {
	    	plane.removeChild(sprite);
	    }
	    
	    public override function handleRunObject():int
	    {
	        var ret:int = 0;
	        if (this.sDisplay)
	        {
	            this.sDisplay = false;
	            ret = REFLAG_DISPLAY;
	        }
	        var dCurrentChronoCounter:Number;
	
	        this.sUpdateCounter = 0;
	
	        var cTime:Date=getCurrentTime();
	        
	        // If system time change
	        dCurrentChronoCounter = (Number(months[cTime.getMonth()])) + (Number((cTime.getDate()-1)*8640000)) + (Number(cTime.getHours()*360000)) + (Number(cTime.getMinutes()*6000)) + (Number(cTime.getSeconds()*100)) + (Number(cTime.getMilliseconds()/10.0));
	        if ((dCurrentChronoCounter < this.dChronoCounter) || ((dCurrentChronoCounter > (this.dChronoCounter + 200)) && (this.dChronoCounter != 0)))
	        {
	            // Chrono: stop at old time, restart at new time
	            if (this.dChronoStart != 0)
	            {
	                // Correction de bug quand on iconifie un objet Clock qui est mis en Stop
	                this.lChrono += Math.abs((int) (this.dChronoCounter - this.dChronoStart));
	                this.dChronoStart = dCurrentChronoCounter;
	            }
	        }
	        this.dChronoCounter = dCurrentChronoCounter;
	        switch (this.sType)
	        {
	            case ANALOG_CLOCK:
	            case DIGITAL_CLOCK:
	            case INVISIBLE:
	                if (this.lastRecordedTime.getSeconds() != cTime.getSeconds())
	                {
	                    this.sEventCount = rh.rh4EventCount;
	                    this.lastRecordedTime.setSeconds(cTime.getSeconds());
	                    ho.pushEvent(CND_NEWSECOND, ho.getEventParam());
	                    ret = REFLAG_DISPLAY;
	                    if (this.lastRecordedTime.getMinutes() != cTime.getMinutes())
	                    {
	                        this.sEventCount = rh.rh4EventCount;
	                        this.lastRecordedTime.setMinutes(cTime.getMinutes());
	                        ho.pushEvent(CND_NEWMINUTE, ho.getEventParam());
	                        if (this.lastRecordedTime.getHours() != cTime.getHours())
	                        {
	                            this.sEventCount = rh.rh4EventCount;
	                            this.lastRecordedTime.setHours(cTime.getHours());
	                            ho.pushEvent(CND_NEWHOUR, ho.getEventParam());
	                        }
	                    }
	                }
	                break;
	            case CALENDAR:
	                if (this.lastRecordedTime.getHours() != cTime.getHours())
	                {
	                    this.lastRecordedTime.setHours(cTime.getHours());
	                    if (this.lastRecordedTime.getDate() != cTime.getDate())
	                    {
	                        this.sEventCount = rh.rh4EventCount;
	                        this.lastRecordedTime.setDate(cTime.getDate());
	                        ho.pushEvent(CND_NEWDAY, ho.getEventParam());
	                        ret = REFLAG_DISPLAY;
	                        if (this.lastRecordedTime.getMonth() != cTime.getMonth())
	                        {
	                            this.sEventCount = rh.rh4EventCount;
	                            this.lastRecordedTime.setMonth(cTime.getMonth());
	                            ho.pushEvent(CND_NEWMONTH, ho.getEventParam());
	                            if (this.lastRecordedTime.fullYear != cTime.fullYear)
	                            {
	                                this.sEventCount = rh.rh4EventCount;
	                                this.lastRecordedTime.fullYear=cTime.fullYear;
	                                ho.pushEvent(CND_NEWYEAR, ho.getEventParam());
	                            }
	                        }
	                    }
	                }
	                break;
	            default:
	                break;
	        }
	        this.lastRecordedTime.setTime(cTime.getTime());
	        return ret;
	    }
	    
		public override function setHandCursor(bOn:Boolean):void
		{
			sprite.buttonMode=bOn;
			sprite.useHandCursor=bOn;
		}

	    public override function displayRunObject():void
	    {
			// Fixe la position
			sprite.x=ho.hoX+pLayer.x;
			sprite.y=ho.hoY+pLayer.y;
			
	        var rhPtr:CRun = ho.hoAdRunHeader;
	        var rc:CRect = new CRect();
	        var rcNewRect:CRect;
	        if (this.sVisible)
	        {
	            // Compute coordinates
	            rc.left = 0;
	            rc.right = this.ho.hoImgWidth;
	            rc.top = 0;
	            rc.bottom = this.ho.hoImgHeight;
	            var hour:int = this.lastRecordedTime.getHours();
	            var hsecond:int = (this.lastRecordedTime.getMilliseconds() / 10);
	            var minute:int = this.lastRecordedTime.getMinutes();
	            var second:int = this.lastRecordedTime.getSeconds();
	            var day:int = this.lastRecordedTime.getDate();
	            var year:int = this.lastRecordedTime.getFullYear();
	            var month:int = (this.lastRecordedTime.getMonth() + 1);
	            var dayofweek:int = (this.lastRecordedTime.getDay());
                var lCurrentChrono:Number;
                var usHour:int, usMinute:int, usSecond:int;
				var dChronoStop:Number;
				
				sprite.graphics.clear();
				
	            switch (this.sType)
	            {
	                case ANALOG_CLOCK: // Analogue clock
	                    if (CLOCK == this.sClockMode)
	                    {
	                        if (hour > 11)
	                        {
	                            hour -= 12;
	                        }
	                        if (this.sAnalogClockMarkerType != 2)
	                        {
	                            rcNewRect = new CRect();
	                            rcNewRect.left = rc.left + (this.sMinWidth / 2);
	                            rcNewRect.right = rc.right - (this.sMinWidth / 2);
	                            rcNewRect.top = rc.top + (this.sMinHeight / 2);
	                            rcNewRect.bottom = rc.bottom - (this.sMinHeight / 2);
	                            RunDisplayAnalogTime(hour, minute, second, rcNewRect);
	                        }
	                        else
	                        {
	                            RunDisplayAnalogTime(hour, minute, second, rc);
	                        }
	                    }
	                    else
	                    {	
	                        // 	Get current chrono
	                        if (this.dChronoStart != 0)
	                        {
	                            dChronoStop = this.months[month - 1] + ((day-1) * 8640000) + (hour * 360000) + (minute * 6000) + (second * 100) + hsecond;
	                            lCurrentChrono = this.lChrono + (dChronoStop - this.dChronoStart);
	                        }
	                        else
	                        {
	                            lCurrentChrono = this.lChrono;
	                        }
	
	                        // Countdown
	                        if (COUNTDOWN == this.sClockMode)
	                        {
	                            lCurrentChrono = this.lCountdownStart - lCurrentChrono;
	                            if (lCurrentChrono < 0)
	                            {
	                                lCurrentChrono = 0;
	                            }
	                        }
	
	                        // Compute hours, minutes & seconds
	                        usHour = (lCurrentChrono / 360000);
	                        if (usHour > 11)
	                        {
	                            usHour -= 12;
	                        }
	                        usMinute = ((lCurrentChrono - (usHour * 360000)) / 6000);
	                        usSecond = ((lCurrentChrono - (usHour * 360000) - (usMinute * 6000)) / 100);
	
	                        // Display
	                        if (this.sAnalogClockMarkerType != 2)
	                        {
	                            rcNewRect = new CRect();
	                            rcNewRect.left = rc.left + (this.sMinWidth / 2);
	                            rcNewRect.right = rc.right - (this.sMinWidth / 2);
	                            rcNewRect.top = rc.top + (this.sMinHeight / 2);
	                            rcNewRect.bottom = rc.bottom - (this.sMinHeight / 2);
	                            RunDisplayAnalogTime(usHour, usMinute, usSecond, rcNewRect);
	                        }
	                        else
	                        {
	                            RunDisplayAnalogTime(usHour, usMinute, usSecond, rc);
	                        }
	                    }
	                    break;
	
	                case DIGITAL_CLOCK: // Digital clock
	                {
	                    var szTime:String;
	                    var szTrailing:String;
	                    var sHours:String;
	                    var sMinutes:String;
	                    var sSeconds:String;
	                    switch (this.sDigitalClockType)
	                    {
	                        case 0:
	                            if (CLOCK == this.sClockMode)
                            	{
			                        if (hour > 11)
			                        {
			                            hour -= 12;
			                        }
	                            	sHours=hour.toString();
	                            	sHours=checkNumberOfDigits(sHours);
									sMinutes=minute.toString();
									sMinutes=checkNumberOfDigits(sMinutes);
									szTime=sHours+":"+sMinutes;	                            	 
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            else
	                            {
	                                // Get current chrono
	                                if (this.dChronoStart != 0)
	                                {
	                                    dChronoStop = this.months[month - 1] + ((day-1) * 8640000) + (hour * 360000) + (minute * 6000) + (second * 100) + hsecond;
	                                    lCurrentChrono = this.lChrono + (dChronoStop - this.dChronoStart);
	                                }
	                                else
	                                {
	                                    lCurrentChrono = this.lChrono;
	                                }
	                                // Countdown
	                                if (COUNTDOWN == this.sClockMode)
	                                {
	                                    lCurrentChrono = this.lCountdownStart - lCurrentChrono;
	                                    if (lCurrentChrono < 0)
	                                    {
	                                        lCurrentChrono = 0;
	                                    }
	                                }
	                                // Compute hours, minutes & seconds
	                                usHour = (lCurrentChrono / 360000);
	                                if (usHour > 11)
	                                {
	                                    usHour -= 12;
	                                }
	                                usMinute = ((lCurrentChrono - (usHour * 360000)) / 6000);
	                                sHours=usHour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=usMinute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                szTime=sHours+":"+sMinutes;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            break;
	
	                        case 1:
	                            if (CLOCK == this.sClockMode)
	                            {
	                                // Display
	                                if (hour > 12) // avant, c'etait 11, donc on affichait 00 PM pour midi
	                                {
	                                    hour -= 12;
	                                }
	                                sHours=hour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=minute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                sSeconds=second.toString();
	                                sSeconds=checkNumberOfDigits(sSeconds);
	                                szTime=sHours+":"+sMinutes+":"+sSeconds;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            else
	                            {
	                                // Get current chrono
	                                if (this.dChronoStart != 0)
	                                {
	                                    dChronoStop = this.months[month - 1] + ((day-1) * 8640000) + (hour * 360000) + (minute * 6000) + (second * 100) + hsecond;
	                                    lCurrentChrono = this.lChrono + (dChronoStop - this.dChronoStart);
	                                }
	                                else
	                                {
	                                    lCurrentChrono = this.lChrono;
	                                }
	                                // Countdown
	                                if (COUNTDOWN == this.sClockMode)
	                                {
	                                    lCurrentChrono = this.lCountdownStart - lCurrentChrono;
	                                    if (lCurrentChrono < 0)
	                                    {
	                                        lCurrentChrono = 0;
	                                    }
	                                }
	                                // Compute hours, minutes & seconds
	                                usHour = (lCurrentChrono / 360000);
	                                if (usHour > 11)
	                                {
	                                    usHour -= 12;
	                                }
	                                usMinute = ((lCurrentChrono - (usHour * 360000)) / 6000);
	                                usSecond = ((lCurrentChrono - (usHour * 360000) - (usMinute * 6000)) / 100);
	
	                                // Display
	                                if (usHour > 11)
	                                {
	                                    usHour -= 12;
	                                }
	                                sHours=usHour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=usMinute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                sSeconds=usSecond.toString();
	                                sSeconds=checkNumberOfDigits(sSeconds);
	                                szTime=sHours+":"+sMinutes+":"+sSeconds;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            break;
	
	                        case 2:
	                            if (CLOCK == this.sClockMode)
	                            {
	                            	sHours=hour.toString();
	                            	sHours=checkNumberOfDigits(sHours);
									sMinutes=minute.toString();
									sMinutes=checkNumberOfDigits(sMinutes);
									szTime=sHours+":"+sMinutes;	                            	 
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            else
	                            {
	                                // Get current chrono
	                                if (this.dChronoStart != 0)
	                                {
	                                    dChronoStop = this.months[month - 1] + ((day-1) * 8640000) + (hour * 360000) + (minute * 6000) + (second * 100) + hsecond;
	                                    lCurrentChrono = this.lChrono + (dChronoStop - this.dChronoStart);
	                                }
	                                else
	                                {
	                                    lCurrentChrono = this.lChrono;
	                                }
	
	                                // Countdown
	                                if (COUNTDOWN == this.sClockMode)
	                                {
	                                    lCurrentChrono = this.lCountdownStart - lCurrentChrono;
	                                    if (lCurrentChrono < 0)
	                                    {
	                                        lCurrentChrono = 0;
	                                    }
	                                }
	
	                                // Compute hours, minutes & seconds
	                                usHour = (lCurrentChrono / 360000);
	                                usMinute = ((lCurrentChrono - (usHour * 360000)) / 6000);
	
	                                // Display
	                                sHours=usHour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=usMinute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                szTime=sHours+":"+sMinutes;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            break;
	
	                        case 3:
	                            if (CLOCK == this.sClockMode)
	                            {
	                                sHours=hour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=minute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                sSeconds=second.toString();
	                                sSeconds=checkNumberOfDigits(sSeconds);
	                                szTime=sHours+":"+sMinutes+":"+sSeconds;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            else
	                            {
									
	                                // Get current chrono
	                                if (this.dChronoStart != 0)
	                                {
	                                    dChronoStop = this.months[month - 1] + ((day-1) * 8640000) + (hour * 360000) + (minute * 6000) + (second * 100) + hsecond;
	                                    lCurrentChrono = this.lChrono + (dChronoStop - this.dChronoStart);
	                                }
	                                else
	                                {
	                                    lCurrentChrono = this.lChrono;
	                                }
	
	                                // Countdown
	                                if (COUNTDOWN == this.sClockMode)
	                                {
	                                    lCurrentChrono = this.lCountdownStart - lCurrentChrono;
	                                    if (lCurrentChrono < 0)
	                                    {
	                                        lCurrentChrono = 0;
	                                    }
	                                }
	
	                                // Compute hours, minutes & seconds
	                                usHour = (lCurrentChrono / 360000);
	                                usMinute = ((lCurrentChrono - (usHour * 360000)) / 6000);
	                                usSecond = ((lCurrentChrono - (usHour * 360000) - (usMinute * 6000)) / 100);
	
	                                // Display
	                                sHours=usHour.toString();
	                                sHours=checkNumberOfDigits(sHours);
	                                sMinutes=usMinute.toString();
	                                sMinutes=checkNumberOfDigits(sMinutes);
	                                sSeconds=usSecond.toString();
	                                sSeconds=checkNumberOfDigits(sSeconds);
	                                szTime=sHours+":"+sMinutes+":"+sSeconds;
	                                RunDisplayDigitalTime(szTime, rc);
	                            }
	                            break;
	
	                        default:
	                            break;
	                    }
	                    break;
	                }
	
	                case CALENDAR: // Calendar
	                    var szDate:String
	                    var df:DateFormatter=new DateFormatter();	                    
	                    switch (this.sCalendarType)
	                    {
	                        case SHORTDATE:
	                        	df.formatString="DD.MM.YYYY";
	                        	szDate=df.format(lastRecordedTime);
	                            RunDisplayCalendar(szDate, rc);
	                            break;
	
	                        case LONGDATE:
	                        	df.formatString="EE.DD.MMMM.YYYY";
	                        	szDate=df.format(lastRecordedTime);
	                            RunDisplayCalendar(szDate, rc);
	                            break;
	
	                        case FIXEDDATE:
	                        	switch (sCalendarFormat)
	                        	{
	                        		case 0:
	                        			df.formatString="DD.MM.YYYY";
	                        			break;
	                        		case 1:
	                        			df.formatString="DD MMMM YYYY";
	                        			break;
	                        		case 2:
	                        			df.formatString="DD MMMM, YYYY";
	                        			break;
	                        		case 3:
	                        			df.formatString="MMMM DD, YYYY";
	                        			break;
	                        		case 4:
	                        			df.formatString="DD-MMM-YYYY";
	                        			break;
	                        		case 5:
	                        			df.formatString="MMMM, YYYY";
	                        			break;
	                        		case 6:
	                        			df.formatString="MMM-YY";
	                        			break;
	                        	}
	                        	szDate=df.format(lastRecordedTime);
	                            RunDisplayCalendar(szDate, rc);
	                            break;
	
	                        default:
	                            break;
	                    }
	                    break;
	
	                default:
	                    break;
	            }
	        }
	    }

		public function checkNumberOfDigits(s:String):String
		{
			if (s.length<2)
			{
				s="0"+s;
			}
			return s;
		}
		
	    public function RunDisplayAnalogTime(sHour:int, sMinutes:int, sSeconds:int, rc:CRect):void
	    {
	        var pntPoints:Array=new Array(3);
	        var n:int;
	        pntPoints[0]=new CPoint();
	        pntPoints[1]=new CPoint();
	        pntPoints[2]=new CPoint();
	        var sRayon:int;
            var a:int;
	        
	        // Set center
	        pntPoints[0].y = rc.top + ((rc.bottom - rc.top) / 2);
	        pntPoints[0].x = rc.left + ((rc.right - rc.left) / 2);
	        this.sCenterY = pntPoints[0].x;
	        this.sCenterX = pntPoints[0].y;
	
	        // Set radius
	        if ((rc.right - rc.left) > (rc.bottom - rc.top))
	        {
	            sRayon = ((rc.bottom - rc.top) / 2);
	        }
	        else
	        {
	            sRayon = ((rc.right - rc.left) / 2);
	        }
	        sRayon--;
	
	        // Display hours
	        if (true == this.sAnalogClockHours)
	        {
	            pntPoints[1].x = pntPoints[0].x + (Math.cos(( (Number(sHour)+Number(sMinutes)/60.0) * 0.523) - 1.570) * (sRayon / 1.5));
	            pntPoints[1].y = pntPoints[0].y + (Math.sin(( (Number(sHour)+Number(sMinutes)/60.0) * 0.523) - 1.570) * (sRayon / 1.5));
	            this.sHourX = pntPoints[1].x;
	            this.sHourY = pntPoints[1].y;
	            sprite.graphics.lineStyle(2, crAnalogClockHours); 
	            sprite.graphics.moveTo(pntPoints[0].x, pntPoints[0].y);
	            sprite.graphics.lineTo(pntPoints[1].x, pntPoints[1].y);
	        }
	        // Display minutes
	        if (true == this.sAnalogClockMinutes)
	        {
	            pntPoints[1].x = pntPoints[0].x + (Math.cos((Number(sMinutes) * 0.104) - 1.570) * sRayon);
	            pntPoints[1].y = pntPoints[0].y + (Math.sin((Number(sMinutes) * 0.104) - 1.570) * sRayon);
	            this.sMinuteX = pntPoints[1].x;
	            this.sMinuteY = pntPoints[1].y;
	            sprite.graphics.lineStyle(2, crAnalogClockMinutes); 
	            sprite.graphics.moveTo(pntPoints[0].x, pntPoints[0].y);
	            sprite.graphics.lineTo(pntPoints[1].x, pntPoints[1].y);
	        }
	        // Display seconds
	        if (true == this.sAnalogClockSeconds)
	        {
	            pntPoints[1].x = pntPoints[0].x + (Math.cos((Number(sSeconds) * 0.104) - 1.570) * sRayon);
	            pntPoints[1].y = pntPoints[0].y + (Math.sin((Number(sSeconds) * 0.104) - 1.570) * sRayon);
	            this.sSecondX = pntPoints[1].x;
	            this.sSecondY = pntPoints[1].y;
	            sprite.graphics.lineStyle(1, crAnalogClockSeconds); 
	            sprite.graphics.moveTo(pntPoints[0].x, pntPoints[0].y);
	            sprite.graphics.lineTo(pntPoints[1].x, pntPoints[1].y);
	        }
	
	        // Draw lines
	        if (true == this.sAnalogClockLines)
	        {
	            sprite.graphics.lineStyle(2, crFont);
	            for (a = 1; a < 13; a++)
	            {
	                pntPoints[1].x = pntPoints[0].x + (Math.cos((a * 0.523) - 1.570) * (sRayon * 0.9));
	                pntPoints[1].y = pntPoints[0].y + (Math.sin((a * 0.523) - 1.570) * (sRayon * 0.9));
	                pntPoints[2].x = pntPoints[0].x + (Math.cos((a * 0.523) - 1.570) * sRayon);
	                pntPoints[2].y = pntPoints[0].y + (Math.sin((a * 0.523) - 1.570) * sRayon);
	                sprite.graphics.moveTo(pntPoints[1].x, pntPoints[1].y);
	                sprite.graphics.lineTo(pntPoints[2].x, pntPoints[2].y);
	            }
	        }
	
	        // Draw markers
	        if (this.sAnalogClockMarkerType != 2)
	        {
	            var szString:String;
	            var textWidth:int;
	            var textHeight:int;
	            var rcFont:CRect = new CRect();
	
	            // Create font
	            if (null == this.sFont)
	            {
	                return;
	            }

	            // Display
	            if (textFields==null)
	            {
	            	textFields=new Array(12);
	            	for (a=0; a<12; a++)
	            	{
	            		textFields[a]=new TextField();
	            		sprite.addChild(textFields[a]);
						textFields[a].mouseEnabled=false;
						textFields[a].selectable=false;
	            	}
	            }
                var tf:TextFormat=sFont.getTextFormat();
                tf.color=crFont;
	            for (a = 1; a < 13; a++)
	            {
	                var x:int, y:int;
	                if (0 == this.sAnalogClockMarkerType)
	                {
	                    szString = a.toString();
	                }
	                else
	                {
	                    szString = szRoman[a - 1];
	                }
	                textFields[a-1].text=szString;
	                textFields[a-1].setTextFormat(tf);
	                textWidth = textFields[a-1].textWidth+4;
	                textHeight = textFields[a-1].textHeight+4;
					textFields[a-1].width=textWidth;
					textFields[a-1].height=textHeight;
					
	                x = pntPoints[0].x + (Math.cos((a * 0.523) - 1.570) * sRayon);
	                y = pntPoints[0].y + (Math.sin((a * 0.523) - 1.570) * sRayon);
	                switch (a)
	                {
	                    case 1:
	                    case 2:
	                        rcFont.left = x;
	                        rcFont.bottom = y;
	                        rcFont.right = rcFont.left + textWidth;
	                        rcFont.top = rcFont.bottom - textHeight;
	                        break;
	
	                    case 3:
	                        rcFont.left = x + 2;
	                        rcFont.top = y - (textHeight / 2);
	                        rcFont.right = rcFont.left + textWidth;
	                        rcFont.bottom = rcFont.top + textHeight;
	                        break;
	
	                    case 4:
	                    case 5:
	                        rcFont.left = x;
	                        rcFont.top = y;
	                        rcFont.right = rcFont.left + textWidth;
	                        rcFont.bottom = rcFont.top + textHeight;
	                        break;
	
	                    case 6:
	                        rcFont.left = x - (textWidth / 2);
	                        rcFont.top = y + 1;
	                        rcFont.right = rcFont.left + textWidth;
	                        rcFont.bottom = rcFont.top + textHeight;
	                        break;
	
	                    case 7:
	                    case 8:
	                        rcFont.right = x;
	                        rcFont.top = y;
	                        rcFont.left = rcFont.right - textWidth;
	                        rcFont.bottom = rcFont.top + textHeight;
	                        break;
	
	                    case 9:
	                        rcFont.right = x - 2;
	                        rcFont.top = y - (textHeight / 2);
	                        rcFont.left = rcFont.right - textWidth;
	                        rcFont.bottom = rcFont.top + textHeight;
	                        break;
	
	                    case 10:
	                    case 11:
	                        rcFont.right = x;
	                        rcFont.bottom = y;
	                        rcFont.left = rcFont.right - textWidth;
	                        rcFont.top = rcFont.bottom - textHeight;
	                        break;
	
	                    case 12:
	                        rcFont.left = x - (textWidth / 2);
	                        rcFont.bottom = y;
	                        rcFont.right = rcFont.left + textWidth;
	                        rcFont.top = rcFont.bottom - textHeight;
	                        break;
	                }
	                var xs:int = rcFont.left + (rcFont.right - rcFont.left) / 2 - textWidth / 2;
	                var ys:int = rcFont.top + (rcFont.bottom - rcFont.top) / 2 + textHeight / 2 - ADJ;
	                textFields[a-1].x=xs;
	                textFields[a-1].y=ys-textHeight/2-7;
	            }
	        }
	
	        // Draw border if needed
	        if (true == this.sClockBorder)
	        {
	        	sprite.graphics.lineStyle(2, crFont);
	        	sprite.graphics.drawCircle(pntPoints[0].x, pntPoints[0].y, sRayon);
	        }
	    }

	    public function RunDisplayDigitalTime(szTime:String, rc:CRect):void
	    {
	    	if (textField==null)
	    	{
	    		textField=new TextField();
	    		sprite.addChild(textField);
				textField.mouseEnabled=false;
				textField.selectable=false;
	    	}
	    	
	        // Display text
	        var tf:TextFormat=sFont.getTextFormat();
	        tf.color=crFont;
	        textField.text=szTime;
	        textField.setTextFormat(tf);
	        var sxText:int=textField.textWidth;
	        var syText:int=textField.textHeight+4;
	        var x:int = rc.left + (rc.right - rc.left) / 2 - sxText / 2;
	        var y:int = rc.top + (rc.bottom - rc.top) / 2 - syText / 2 - ADJ;
	        textField.x=x;
	        textField.y=y;
			textField.width=sxText+8;
			textField.height=syText;

	        // Draw border if needed
	        if (true == this.sClockBorder)
	        {
	        	sprite.graphics.lineStyle(2, crFont);
	            sprite.graphics.drawRect(rc.left + 1, rc.top + 1, rc.right - rc.left, rc.bottom - rc.top);
	        }
	    }

	    public function RunDisplayCalendar(szDate:String, rc:CRect):void
	    {
	    	if (textField==null)
	    	{
	    		textField=new TextField();
	    		sprite.addChild(textField);
				textField.mouseEnabled=false;
				textField.selectable=false;
	    	}
	    	
	        // Display text
	        var tf:TextFormat=sFont.getTextFormat();
	        tf.color=crFont;
	        textField.text=szDate;
	        textField.setTextFormat(tf);
	        var sxText:int=textField.textWidth;
	        var syText:int=textField.textHeight+4;
	        var x:int = rc.left + (rc.right - rc.left) / 2 - sxText / 2;
	        var y:int = rc.top + (rc.bottom - rc.top) / 2 - syText / 2 - ADJ;
	        textField.x=x;
	        textField.y=y;
			textField.width=sxText+8;
			textField.height=syText;
	    }

	    public function getCurrentTime():Date
	    {
	        //output = initialTime + (currentTime - startTimer)
	        var output:Date = new Date();
	        output.setTime(initialTime.getTime() + (output.getTime() - startTimer.getTime()));
	        return output;
	    }
	
	    public function changeTime(date:Date):void
	    {
	        this.initialTime.setTime(date.getTime());
	        this.lastRecordedTime.setTime(date.getTime());
	        this.startTimer = new Date();
	    }
	
		// Hide and show
		// -------------
		public override function showSprite():void
		{
			sprite.visible=true;
		}
		
		public override function hideSprite():void
		{			
			sprite.visible=false;
		}

		// Priority
		// --------
		public override function getChildIndex():int
		{	
			return pLayer.planeSprites.getChildIndex(sprite);
		}
		public override function getChildMaxIndex():int
		{
			return pLayer.planeSprites.numChildren;
		}
		public override function setChildIndex(index:int):void
		{
			if (index>=pLayer.planeSprites.numChildren)
			{
				index=pLayer.planeSprites.numChildren-1;
				if (index<0)
				{
					index=0;
				}
			}
			pLayer.planeSprites.setChildIndex(sprite, index);
		}

		public override function condition(num:int, cnd:CCndExtension):Boolean
		{
	        switch (num)
	        {
	            case CND_CMPCHRONO:
	                return CmpChrono(cnd);
	            case CND_NEWSECOND:
	                return NewSecond();
	            case CND_NEWMINUTE:
	                return NewSecond();
	            case CND_NEWHOUR:
	                return NewSecond();
	            case CND_NEWDAY:
	                return NewSecond();
	            case CND_NEWMONTH:
	                return NewSecond();
	            case CND_NEWYEAR:
	                return NewSecond();
	            case CND_CMPCOUNTDOWN:
	                return CmpCountdown(cnd);
	            case CND_VISIBLE:
	                return IsVisible();
	        }
	        return false;//won't happen
		}
		
	    public function CmpChrono(cnd:CCndExtension):Boolean
	    {
	        if (this.dChronoStart != 0)
	        {
	            var c:Date = getCurrentTime();
	            var dChronoStop:Number = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            return compareTime(cnd, 0, ((lChrono + (dChronoStop - dChronoStart)) * 10));
	        }
	        else
	        {
	            return compareTime(cnd, 0, lChrono * 10);
	        }
	    }
	    public function compareTime(cnd:CCndExtension, num:Number, t:Number):Boolean
	    {
	        var p:PARAM_CMPTIME = PARAM_CMPTIME(cnd.evtParams[num]);
	        var value2:CValue = new CValue(0);
	        value2.forceDouble(p.timer);
	        var comp:int = p.comparaison;
	        var value1:CValue = new CValue(0);
	        value1.forceDouble(t);
	        switch (comp)
	        {
	            case 0:	// COMPARE_EQ:
	                return value1.equal(value2);
	            case 1:	// COMPARE_NE:
	                return value1.notEqual(value2);
	            case 2:	// COMPARE_LE:
	                return value1.lower(value2);
	            case 3:	// COMPARE_LT:
	                return value1.lowerThan(value2);
	            case 4:	// COMPARE_GE:
	                return value1.greater(value2);
	            case 5:	// COMPARE_GT:
	                return value1.greaterThan(value2);
	        }
	        return false;
	    }
	
	    public function NewSecond():Boolean
	    {
	        if ((ho.hoFlags & CObject.HOF_TRUEEVENT) != 0)
	        {
	            return true;
	        }
	        if (rh.rh4EventCount == sEventCount)
	        {
	            return true;
	        }
	        return false;
	    }
	
	    public function CmpCountdown(cnd:CCndExtension):Boolean
	    {
	        var lCurrentChrono:Number;
	        if (dChronoStart != 0)
	        {
	            var c:Date = getCurrentTime();
	            var dChronoStop:Number = months[c.getMonth()] +
	                    ((c.getDate()-1)*8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            lCurrentChrono = lCountdownStart - (lChrono + (dChronoStop - dChronoStart));
	        }
	        else
	        {
	            lCurrentChrono = lCountdownStart - lChrono;
	            return compareTime(cnd, 0, lChrono * 10);
	        }
	        if (lCurrentChrono < 0)
	        {
	            lCurrentChrono = 0;
	        }
	        return compareTime(cnd, 0, lCurrentChrono * 10);
	    }
	
	    public function IsVisible():Boolean
	    {
	        return sVisible;
	    }
	    
	    
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case ACT_SETCENTIEMES:
	                SetCentiemes(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETSECONDES:
	                SetSeconds(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETMINUTES:
	                SetMinutes(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETHOURS:
	                SetHours(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETDAYOFWEEK:
	                SetDayOfWeek(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETDAYOFMONTH:
	                SetDayOfMonth(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETMONTH:
	                SetMonth(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETYEAR:
	                SetYear(act.getParamExpression(rh, 0));
	                break;
	            case ACT_RESETCHRONO:
	                ResetChrono();
	                break;
	            case ACT_STARTCHRONO:
	                StartChrono();
	                break;
	            case ACT_STOPCHRONO:
	                StopChrono();
	                break;
	            case ACT_SHOW:
	                Show();
	                break;
	            case ACT_HIDE:
	                Hide();
	                break;
	            case ACT_SETPOSITION:
	                SetPosition(act.getParamPosition(rh, 0));
	                break;
	            case ACT_SETCOUNTDOWN:
	                SetCountdown(act.getParamTime(rh, 0));
	                break;
	            case ACT_STARTCOUNTDOWN:
	                StartCountdown();
	                break;
	            case ACT_STOPCOUNTDOWN:
	                StopCountdown();
	                break;
	            case ACT_SETXPOSITION:
	                SetXPosition(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETYPOSITION:
	                SetYPosition(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETXSIZE:
	                SetXSize(act.getParamExpression(rh, 0));
	                break;
	            case ACT_SETYSIZE:
	                SetYSize(act.getParamExpression(rh, 0));
	                break;
	        }
	    }

	    public function SetCentiemes(hundredths:int):void
	    {
	        if ((hundredths >= 0) && (hundredths < 100))
	        {
	            var c:Date = this.getCurrentTime();
	            c.setMilliseconds(hundredths * 10);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetSeconds(secs:int):void
	    {
	        if ((secs >= 0) && (secs < 60))
	        {
	            var c:Date = getCurrentTime();
	            c.setSeconds(secs);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetMinutes(mins:int):void
	    {
	        if ((mins >= 0) && (mins < 60))
	        {
	            var c:Date = this.getCurrentTime();
	            c.setMinutes(mins);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetHours(hours:int):void
	    {
	        if ((hours >= 0) && (hours < 24))
	        {
	            var c:Date = this.getCurrentTime();
	            c.setHours(hours);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetDayOfWeek(day:int):void
	    {
	    }
	
	    public function SetDayOfMonth(day:int):void
	    {
	        if ((day >= 1) && (day < 32)) //1 based from c++
	        {
	            var c:Date = this.getCurrentTime();
	            c.setDate(day);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetMonth(month:int):void
	    {
	        if ((month >= 1) && (month < 13)) //1 based from c++
	        {
	            var c:Date = this.getCurrentTime();
	            c.setMonth(month - 1);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function SetYear(year:int):void
	    {
	        if ((year > 1979) && (year < 2100)) //y2.1k
	        {
	            var c:Date = this.getCurrentTime();
	            c.setFullYear(year);
	            this.changeTime(c);
	            this.ho.redraw();
	        }
	    }
	
	    public function ResetChrono():void
	    {
	        this.dChronoStart = 0;
	        this.lChrono = 0;
	        this.ho.redraw();
	    }
	
	    public function StartChrono():void
	    {
	        if (this.dChronoStart == 0)
	        {
	            var c:Date = this.getCurrentTime();
	            var month:int=c.getMonth();
	            var day:int=c.getDate();
	            this.dChronoStart = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	        }
	    }
	
	    public function StopChrono():void
	    {
	        if (this.dChronoStart != 0)
	        {
	            var c:Date = this.getCurrentTime();
	            var dChronoStop:int = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            this.lChrono += (dChronoStop - this.dChronoStart);
	            this.dChronoStart = 0;
	        }
	    }
	
	    public function Show():void
	    {
	        if (!this.sVisible)
	        {
	            this.sVisible = true;
	            sprite.visible=true;
	        }
	    }
	
	    public function Hide():void
	    {
	        if (this.sVisible)
	        {
	            this.sVisible = false;
	            sprite.visible=false;
	        }
	    }
	
	    public function SetPosition(pos:CPositionInfo):void
	    {
	        this.ho.setPosition(pos.x, pos.y);
	        this.ho.redraw();
	    }
	
	    public function SetCountdown(time:int):void
	    {
	        this.lCountdownStart = time / 10;
	        this.dChronoStart = 0;
	        this.lChrono = 0;
	        this.ho.redraw();
	    }
	
	    public function StartCountdown():void
	    {
	        if (this.dChronoStart == 0)
	        {
	            var c:Date = this.getCurrentTime();
	            this.dChronoStart = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	        }
	    }
	
	    public function StopCountdown():void
	    {
	        if (this.dChronoStart != 0)
	        {
	            var c:Date = this.getCurrentTime();
	            var dChronoStop:int = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            this.lChrono += (dChronoStop - this.dChronoStart);
	            this.dChronoStart = 0;
	        }
	    }
	
	    public function SetXPosition(x:int):void
	    {
	        this.ho.setX(x);
	        this.ho.redraw();
	    }
	
	    public function SetYPosition(y:int):void
	    {
	        this.ho.setY(y);
	        this.ho.redraw();
	    }
	
	    public function SetXSize(w:int):void
	    {
	        this.ho.setWidth(w);
	        this.ho.redraw();
	    }
	
	    public function SetYSize(h:int):void
	    {
	        this.ho.setHeight(h);
	        this.ho.redraw();
	    }


	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case EXP_GETCENTIEMES:
	                return GetCentiemes();
	            case EXP_GETSECONDES:
	                return GetSeconds();
	            case EXP_GETMINUTES:
	                return GetMinutes();
	            case EXP_GETHOURS:
	                return GetHours();
	            case EXP_GETDAYOFWEEK:
	                return GetDayOfWeek();
	            case EXP_GETDAYOFMONTH:
	                return GetDayOfMonth();
	            case EXP_GETMONTH:
	                return GetMonth();
	            case EXP_GETYEAR:
	                return GetYear();
	            case EXP_GETCHRONO:
	                return GetChrono();
	            case EXP_GETCENTERX:
	                return GetCentreX();
	            case EXP_GETCENTERY:
	                return GetCentreY();
	            case EXP_GETHOURX:
	                return GetHourX();
	            case EXP_GETHOURY:
	                return GetHourY();
	            case EXP_GETMINUTEX:
	                return GetMinuteX();
	            case EXP_GETMINUTEY:
	                return GetMinuteY();
	            case EXP_GETSECONDX:
	                return GetSecondX();
	            case EXP_GETSECONDY:
	                return GetSecondY();
	            case EXP_GETCOUNTDOWN:
	                return GetCountdown();
	            case EXP_GETXPOSITION:
	                return GetXPosition();
	            case EXP_GETYPOSITION:
	                return GetYPosition();
	            case EXP_GETXSIZE:
	                return GetXSize();
	            case EXP_GETYSIZE:
	                return GetYSize();
	        }
	        return new CValue(0);//won't happen
	    }
	
	    public function GetCentiemes():CValue
	    {
	        return new CValue(this.getCurrentTime().getMilliseconds() / 10);
	    }
	
	    public function GetSeconds():CValue
	    {
	        return new CValue(this.getCurrentTime().getSeconds());
	    }
	
	    public function GetMinutes():CValue
	    {
	        return new CValue(this.getCurrentTime().getMinutes());
	    }
	
	    public function GetHours():CValue
	    {
	        return new CValue(this.getCurrentTime().getHours());
	    }
	
	    public function GetDayOfWeek():CValue
	    {
	        return new CValue(this.getCurrentTime().getDay());
	    }
	
	    public function GetDayOfMonth():CValue
	    {
	        return new CValue(this.getCurrentTime().getDate());
	    }
	
	    public function GetMonth():CValue
	    {
	        return new CValue(this.getCurrentTime().getMonth() + 1);
	    }
	
	    public function GetYear():CValue
	    {
	        return new CValue(this.getCurrentTime().getFullYear());
	    }
	
	    public function GetChrono():CValue
	    {
	        if (this.dChronoStart != 0)
	        {
	            var c:Date = this.getCurrentTime();
	            var dChronoStop:int = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            return new CValue(this.lChrono + (dChronoStop - this.dChronoStart));
	        }
	        else
	        {
	            return new CValue(this.lChrono);
	        }
	    }
	
	    public function GetCentreX():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sCenterX + this.rh.rhWindowX);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetCentreY():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sCenterY + this.rh.rhWindowY);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetHourX():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sHourX + this.rh.rhWindowX);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetHourY():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sHourY + this.rh.rhWindowY);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetMinuteX():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sMinuteX + this.rh.rhWindowX);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetMinuteY():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sMinuteY + this.rh.rhWindowY);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetSecondX():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sSecondX + this.rh.rhWindowX);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetSecondY():CValue
	    {
	        if (ANALOG_CLOCK == this.sType)
	        {
	            return new CValue(this.sSecondY + this.rh.rhWindowY);
	        }
	        else
	        {
	            return new CValue(0);
	        }
	    }
	
	    public function GetCountdown():CValue
	    {
	        var lCurrentChrono:int;
	        if (this.dChronoStart != 0)
	        {
	            var c:Date = this.getCurrentTime();
	            var dChronoStop:int = months[c.getMonth()] +
	                    ((c.getDate()-1) * 8640000) + (c.getHours() * 360000) +
	                    (c.getMinutes() * 6000) + (c.getSeconds() * 100) + (c.getMilliseconds() / 10);
	            lCurrentChrono = this.lCountdownStart - (this.lChrono + (dChronoStop - this.dChronoStart));
	            if (lCurrentChrono < 0)
	            {
	                lCurrentChrono = 0;
	            }
	            return new CValue(lCurrentChrono);
	        }
	        else
	        {
	            lCurrentChrono = this.lCountdownStart - this.lChrono;
	            if (lCurrentChrono < 0)
	            {
	                lCurrentChrono = 0;
	            }
	            return new CValue(lCurrentChrono);
	        }
	    }
	
	    public function GetXPosition():CValue
	    {
	        return new CValue(this.ho.getX());
	    }
	
	    public function GetYPosition():CValue
	    {
	        return new CValue(this.ho.getY());
	    }
	
	    public function GetXSize():CValue
	    {
	        return new CValue(this.ho.getWidth());
	    }
	
	    public function GetYSize():CValue
	    {
	        return new CValue(this.ho.getHeight());
	    }
	    	    
	}	
}