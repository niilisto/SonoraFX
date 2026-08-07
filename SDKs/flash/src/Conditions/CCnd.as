//----------------------------------------------------------------------------------
//
// CCND: une condition
//
//----------------------------------------------------------------------------------
package Conditions
{
	import Application.*;
	
	import Events.*;
	
	import Expressions.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.CArrayList;
	
	public class CCnd extends CEvent
	{
		public static const NUM_ONEVENT:int = 6;
		
	    public var evtIdentifier:int;	  		
	    
	    public static function create(app:CRunApp):CCnd
	    {
	        var debut:int=app.file.getFilePointer();
	
	        var size:int=app.file.readAShort();          // evtSize
	        var cnd:CCnd=null;      
	        var c:int=app.file.readAInt();       
	        switch (c)
	        {
	            case ((-26<<16)|0xFFFF):	// #define CND_CHANCE	
	                cnd=new CND_CHANCE();
	                break;
	            case ((-25<<16)|0xFFFF):	// #define CND_ORLOGICAL		((-25<<16)|0xFFFF)
	                cnd=new CND_ORLOGICAL();
	                break;
	            case ((-24<<16)|0xFFFF):	// #define CND_OR				
	                cnd=new CND_OR();
	                break;
	            case ((-23<<16)|0xFFFF):	// #define CND_GROUPSTART		
	                cnd=new CND_GROUPSTART();
	                break;
	            case ((-20<<16)|0xFFFF):	// CND_COMPAREGSTRING	
	                cnd=new CND_COMPAREGSTRING();
	                break;
	            case ((-16<<16)|0xFFFF):	// CND_ONLOOP			
	                cnd=new CND_ONLOOP();
	                break;
	            case ((-12<<16)|0xFFFF):	// CND_GROUPACTIVATED	
	                cnd=new CND_GROUPACTIVATED();
	                break;
	            case ((-11<<16)|0xFFFF):	// CND_ENDGROUP		
	                cnd=new CND_ENDGROUP();
	                break;
	            case ((-10<<16)|0xFFFF):	// CND_GROUP			
	                cnd=new CND_GROUP();
	                break;
	            case ((-9<<16)|0xFFFF):	// CND_REMARK			
	                cnd=new CND_REMARK();
	                break;
	            case ((-8<<16)|0xFFFF):	// CND_COMPAREG		
	                cnd=new CND_COMPAREG();
	                break;
	            case ((-7<<16)|0xFFFF):	// CND_NOTALWAYS		
	                cnd=new CND_NOTALWAYS();
	                break;
	            case ((-6<<16)|0xFFFF):	// CND_ONCE			
	                cnd=new CND_ONCE();
	                break;
	            case ((-5<<16)|0xFFFF):	// CND_REPEAT			
	                cnd=new CND_REPEAT();
	                break;
	            case ((-4<<16)|0xFFFF):	// CND_NOMORE			
	                cnd=new CND_NOMORE();
	                break;
	            case ((-3<<16)|0xFFFF):	// CND_COMPARE			
	                cnd=new CND_COMPARE();
	                break;
	            case ((-2<<16)|0xFFFF):	// CND_NEVER			
	                cnd=new CND_NEVER();
	                break;
	            case ((-1<<16)|0xFFFF):	// CND_ALWAYS			
	                cnd=new CND_ALWAYS();
	                break;
	            case ((-9<<16)|0xFFFE):	// CND_SPCHANNELPAUSED 
	                cnd=new CND_SPCHANNELPAUSED();
	                break;
	            case ((-8<<16)|0xFFFE):	// CND_NOSPCHANNELPLAYING 
	                cnd=new CND_NOSPCHANNELPLAYING();
	                break;
	            case ((-6<<16)|0xFFFE):	// CND_SPSAMPAUSED		
	                cnd=new CND_SPSAMPAUSED();
	                break;
	            case ((-3 << 16) | 0xFFFE):	// CND_NOSAMPLAYING	
	                cnd=new CND_NOSAMPLAYING;
	                break;
	            case ((-1<<16)|0xFFFE):	// CND_NOSPSAMPLAYING	
	                cnd=new CND_NOSPSAMPLAYING();
	                break;
	            case ((-8<<16)|0xFFFD):	// CND_ENDOFPAUSE		
	                cnd=new CND_ENDOFPAUSE();
	                break;
	            case ((-6<<16)|0xFFFD):	// CND_ISLADDER		
	                cnd=new CND_ISLADDER();
	                break;
	            case ((-5<<16)|0xFFFD):	// CND_ISOBSTACLE		
	                cnd=new CND_ISOBSTACLE();
	                break;
	            case ((-4<<16)|0xFFFD):	// CND_QUITAPPLICATION	
	                cnd=new CND_QUITAPPLICATION();
	                break;
	            case ((-3<<16)|0xFFFD):	// CND_LEVEL			
	                cnd=new CND_LEVEL();
	                break;
	            case ((-2<<16)|0xFFFD):	// CND_END				
	                cnd=new CND_END();
	                break;
	            case ((-1<<16)|0xFFFD):	// CND_START			
	                cnd=new CND_START();
	                break;
				case ((-8<< 16) | 0xFFFC):	// CND_EVERY2
					cnd = new CND_EVERY2();
					break;
				case ((-7<< 16) | 0xFFFC):	// CND_TIMEREQUALS
					cnd = new CND_TIMEREQUALS();
					break;
				case ((-6<< 16) | 0xFFFC):	// CND_ONEVENT
					cnd = new CND_ONEVENT();
					break;
				case ((-5<<16)|0xFFFC):	// CND_TIMEOUT       	
	                cnd=new CND_TIMEOUT();
	                break;
	            case ((-4<<16)|0xFFFC):	// CND_EVERY       	
	                cnd=new CND_EVERY();
	                break;
	            case ((-3<<16)|0xFFFC):	// CND_TIMER       	
	                cnd=new CND_TIMER();
	                break;
	            case ((-2<<16)|0xFFFC):	// CND_TIMERINF       	
	                cnd=new CND_TIMERINF();
	                break;
	            case ((-1<<16)|0xFFFC):	// CND_TIMERSUP       	
	                cnd=new CND_TIMERSUP();
	                break;
	            case ((-12<<16)|0xFFFA):	// CND_MOUSEWHEELDOWN		   	
	                cnd=new CND_MOUSEWHEELDOWN();
	                break;
	            case ((-11<<16)|0xFFFA):	// CND_MOUSEWHEELUP		   	
	                cnd=new CND_MOUSEWHEELUP();
	                break;
	            case ((-10<<16)|0xFFFA):	// CND_MOUSEON		   	
	                cnd=new CND_MOUSEON();
	                break;
	            case ((-9<<16)|0xFFFA):	// CND_ANYKEY			
	                cnd=new CND_ANYKEY();
	                break;
	            case ((-8<<16)|0xFFFA):	// CND_MKEYDEPRESSED	
	                cnd=new CND_MKEYDEPRESSED();
	                break;
	            case ((-7<<16)|0xFFFA):	// CND_MCLICKONOBJECT	
	                cnd=new CND_MCLICKONOBJECT();
	                break;
	            case ((-6<<16)|0xFFFA):	// CND_MCLICKINZONE 	
	                cnd=new CND_MCLICKINZONE();
	                break;
	            case ((-5<<16)|0xFFFA):	// CND_MCLICK	 		
	                cnd=new CND_MCLICK();
	                break;
	            case ((-4<<16)|0xFFFA):	// CND_MONOBJECT		
	                cnd=new CND_MONOBJECT();
	                break;
	            case ((-3<<16)|0xFFFA):	// CND_MINZONE			
	                cnd=new CND_MINZONE();
	                break;
	            case ((-2<<16)|0xFFFA):	// CND_KBKEYDEPRESSED 	
	                cnd=new CND_KBKEYDEPRESSED();
	                break;
	            case ((-1<<16)|0xFFFA):	// CND_KBPRESSKEY   	
	                cnd=new CND_KBPRESSKEY();
	                break;
	            case ((-6<<16)|0xFFF9):	// CND_JOYPUSHED		
	                cnd=new CND_JOYPUSHED();
	                break;
	            case ((-5<<16)|0xFFF9):	// CND_NOMORELIVE		
	                cnd=new CND_NOMORELIVE();
	                break;
	            case ((-4<<16)|0xFFF9):	// CND_JOYPRESSED		
	                cnd=new CND_JOYPRESSED();
	                break;
	            case ((-3<<16)|0xFFF9):	// CND_LIVE	        
	                cnd=new CND_LIVE();
	                break;
	            case ((-2<<16)|0xFFF9):	// CND_SCORE		    
	                cnd=new CND_SCORE();
	                break;
	            case ((-1<<16)|0xFFF9):	// CND_PLAYERPLAYING   
	                cnd=new CND_PLAYERPLAYING();
	                break;
	            case ((-23<<16)|0xFFFB):	// CND_CHOOSEALLINLINE	
	                cnd=new CND_CHOOSEALLINLINE();
	                break;
	            case ((-22<<16)|0xFFFB):	// CND_CHOOSEFLAGRESET	
	                cnd=new CND_CHOOSEFLAGRESET();
	                break;
	            case ((-21<<16)|0xFFFB):	// CND_CHOOSEFLAGSET 	
	                cnd=new CND_CHOOSEFLAGSET();
	                break;
	            case ((-20<<16)|0xFFFB):	// CND_CHOOSEVALUE 	
	                cnd=new CND_CHOOSEVALUE();
	                break;
	            case ((-19<<16)|0xFFFB):	// CND_PICKFROMID		
	                cnd=new CND_PICKFROMID();
	                break;
	            case ((-18<<16)|0xFFFB):	// CND_CHOOSEALLINZONE 
	                cnd=new CND_CHOOSEALLINZONE();
	                break;
	            case ((-17<<16)|0xFFFB):	// CND_CHOOSEALL       
	                cnd=new CND_CHOOSEALL();
	                break;
	            case ((-16<<16)|0xFFFB):	// CND_CHOOSEZONE      
	                cnd=new CND_CHOOSEZONE();
	                break;
	            case ((-15<<16)|0xFFFB):	// CND_NUMOFALLOBJECT  
	                cnd=new CND_NUMOFALLOBJECT();
	                break;
	            case ((-14<<16)|0xFFFB):	// CND_NUMOFALLZONE    
	                cnd=new CND_NUMOFALLZONE();
	                break;
	            case ((-13<<16)|0xFFFB):	// CND_NOMOREALLZONE   
	                cnd=new CND_NOMOREALLZONE();
	                break;
	            case ((-12<<16)|0xFFFB):	// CND_CHOOSEFLAGRESET_OLD	
	                cnd=new CND_CHOOSEFLAGRESET_OLD();
	                break;
	            case ((-11<<16)|0xFFFB):	// CND_CHOOSEFLAGSET_OLD 	
	                cnd=new CND_CHOOSEFLAGSET_OLD();
	                break;
	            case ((-8<<16)|0xFFFB):	// CND_CHOOSEVALUE_OLD 	
	                cnd=new CND_CHOOSEVALUE_OLD();
	                break;
	            case ((-7<<16)|0xFFFB):	// CND_PICKFROMID_OLD		
	                cnd=new CND_PICKFROMID_OLD();
	                break;
	            case ((-6<<16)|0xFFFB):	// CND_CHOOSEALLINZONE_OLD 
	                cnd=new CND_CHOOSEALLINZONE_OLD ();
	                break;
	            case ((-5<<16)|0xFFFB):	// CND_CHOOSEALL_OLD       
	                cnd=new CND_CHOOSEALL_OLD();
	                break;
	            case ((-4<<16)|0xFFFB):	// CND_CHOOSEZONE_OLD      
	                cnd=new CND_CHOOSEZONE_OLD();
	                break;
	            case ((-3<<16)|0xFFFB):	// CND_NUMOFALLOBJECT_OLD  
	                cnd=new CND_NUMOFALLOBJECT_OLD();
	                break;
	            case ((-2<<16)|0xFFFB):	// CND_NUMOFALLZONE_OLD    
	                cnd=new CND_NUMOFALLZONE_OLD();
	                break;
	            case ((-1<<16)|0xFFFB):		// CND_NOMOREALLZONE_OLD   
	                cnd=new CND_NOMOREALLZONE_OLD();
	                break;
				case (((-80- 1) << 16) | 2):		// CND_SPRCLICK	   			
					cnd = new CND_SPRCLICK();
					break;
	            case (((-80-1)<<16)|7):		// CND_CCOUNTER				
	                cnd=new CND_CCOUNTER();
	                break;
	            case (((-80-3)<<16)|4):		// CND_QEQUAL					
	                cnd=new CND_QEQUAL();
	                break;
	            case (((-80-2)<<16)|4):		// CND_QFALSE					
	                cnd=new CND_QFALSE();
	                break;
	            case (((-80-1)<<16)|4):		// CND_QEXACT					
	                cnd=new CND_QEXACT();
	                break;
	            case (((-80-4)<<16)|(9&0x00FF)):		// CND_CCAISPAUSED
	                cnd=new CND_CCAISPAUSED();
	                break;
	            case (((-80-3)<<16)|(9&0x00FF)):		// CND_CCAISVISIBLE
	                cnd=new CND_CCAISVISIBLE();
	                break;
	            case (((-80-2)<<16)|(9&0x00FF)):		// CND_CCAAPPFINISHED
	                cnd=new CND_CCAAPPFINISHED();
	                break;
	            case (((-80-1)<<16)|(9&0x00FF)):		// CND_CCAFRAMECHANGED
	                cnd=new CND_CCAFRAMECHANGED();
	                break;
	            default:
	                switch (c&0xFFFF0000)
	                {
						case (-41<< 16):				// CND_EXTONLOOP
							cnd = new CND_EXTONLOOP();
							break;
	                    case (-40<<16):				// CND_EXTISSTRIKEOUT			
	                        cnd=new CND_EXTISSTRIKEOUT();
	                        break;
	                    case (-39<<16):				// CND_EXTISUNDERLINE			
	                        cnd=new CND_EXTISUNDERLINE();
	                        break;
	                    case (-38<<16):				// CND_EXTISITALIC				
	                        cnd=new CND_EXTISITALIC();
	                        break;
	                    case (-37<<16):				// CND_EXTISBOLD				
	                        cnd=new CND_EXTISBOLD();
	                        break;
	                    case (-36<<16):				// CND_EXTCMPVARSTRING			
	                        cnd=new CND_EXTCMPVARSTRING();
	                        break;
	                    case (-35<<16):				// CND_EXTPATHNODENAME			
	                        cnd=new CND_EXTPATHNODENAME();
	                        break;
	                    case (-34<<16):				// CND_EXTCHOOSE				
	                        cnd=new CND_EXTCHOOSE();
	                        break;
	                    case (-33<<16):				// CND_EXTNOMOREOBJECT			
	                        cnd=new CND_EXTNOMOREOBJECT();
	                        break;
	                    case (-32<<16):				// CND_EXTNUMOFOBJECT			
	                        cnd=new CND_EXTNUMOFOBJECT();
	                        break;
	                    case (-31<<16):				// CND_EXTNOMOREZONE			
	                        cnd=new CND_EXTNOMOREZONE();
	                        break;
	                    case (-30<<16):				// CND_EXTNUMBERZONE			
	                        cnd=new CND_EXTNUMBERZONE();
	                        break;
	                    case (-29<<16):				// CND_EXTSHOWN				
	                        cnd=new CND_EXTSHOWN();
	                        break;
	                    case (-28<<16):				// CND_EXTHIDDEN				
	                        cnd=new CND_EXTHIDDEN();
	                        break;
	                    case (-27<<16):				// CND_EXTCMPVAR				
	                        cnd=new CND_EXTCMPVAR();
	                        break;
	                    case (-26<<16):				// CND_EXTCMPVARFIXED			
	                        cnd=new CND_EXTCMPVARFIXED();
	                        break;
	                    case (-25<<16):				// CND_EXTFLAGSET				
	                        cnd=new CND_EXTFLAGSET();
	                        break;
	                    case (-24<<16):				// CND_EXTFLAGRESET			
	                        cnd=new CND_EXTFLAGRESET();
	                        break;
	                    case (-23<<16):				// CND_EXTISCOLBACK	        
	                        cnd=new CND_EXTISCOLBACK();
	                        break;
	                    case (-22<<16):				// CND_EXTNEARBORDERS	        
	                        cnd=new CND_EXTNEARBORDERS();
	                        break;
	                    case (-21<<16):				// CND_EXTENDPATH	  	        
	                        cnd=new CND_EXTENDPATH();
	                        break;
	                    case (-20<<16):				// CND_EXTPATHNODE    	        
	                        cnd=new CND_EXTPATHNODE();
	                        break;
	                    case (-19<<16):				// CND_EXTCMPACC	            
	                        cnd=new CND_EXTCMPACC();
	                        break;
	                    case (-18<<16):				// CND_EXTCMPDEC	 	        
	                        cnd=new CND_EXTCMPDEC();
	                        break;
	                    case (-17<<16):				// CND_EXTCMPX	 	  	        
	                        cnd=new CND_EXTCMPX();
	                        break;
	                    case (-16<<16):				// CND_EXTCMPY   		        
	                        cnd=new CND_EXTCMPY();
	                        break;
	                    case (-15<<16):				// CND_EXTCMPSPEED             
	                        cnd=new CND_EXTCMPSPEED();
	                        break;
	                    case (-14<<16):				// CND_EXTCOLLISION   	        
	                        cnd=new CND_EXTCOLLISION();
	                        break;
	                    case (-13<<16):				// CND_EXTCOLBACK              
	                        cnd=new CND_EXTCOLBACK();
	                        break;
	                    case (-12<<16):				// CND_EXTOUTPLAYFIELD         
	                        cnd=new CND_EXTOUTPLAYFIELD();
	                        break;
	                    case (-11<<16):				// CND_EXTINPLAYFIELD          
	                        cnd=new CND_EXTINPLAYFIELD();
	                        break;
	                    case (-10<<16):				// CND_EXTISOUT	            
	                        cnd=new CND_EXTISOUT();
	                        break;
	                    case (-9 <<16):				// CND_EXTISIN                 
	                        cnd=new CND_EXTISIN();
	                        break;
	                    case (-8 <<16):				// CND_EXTFACING               
	                        cnd=new CND_EXTFACING();
	                        break;
	                    case (-7 <<16):				// CND_EXTSTOPPED              
	                        cnd=new CND_EXTSTOPPED();
	                        break;
	                    case (-6 <<16):				// CND_EXTBOUNCING	            
	                        cnd=new CND_EXTBOUNCING();
	                        break;
	                    case (-5 <<16):				// CND_EXTREVERSED             
	                        cnd=new CND_EXTREVERSED();
	                        break;
	                    case (-4 <<16):				// CND_EXTISCOLLIDING          
	                        cnd=new CND_EXTISCOLLIDING();
	                        break;
	                    case (-3 <<16):				// CND_EXTANIMPLAYING          
	                        cnd=new CND_EXTANIMPLAYING();
	                        break;
	                    case (-2 <<16):				// CND_EXTANIMENDOF        	
	                        cnd=new CND_EXTANIMENDOF();
	                        break;
	                    case (-1 <<16):				// CND_EXTCMPFRAME     		
	                        cnd=new CND_EXTCMPFRAME();
	                        break;
	                    default:                                    // EXTENSION
							cnd=new CCndExtension();
	                        break;
	                }
	        }
	        if (cnd!=null)
	        {
	            cnd.evtCode=c;
	            cnd.evtOi=app.file.readShort(); 
	            cnd.evtOiList=app.file.readShort(); 
	            cnd.evtFlags=app.file.readAByte(); 
	            cnd.evtFlags2=app.file.readAByte(); 
	            cnd.evtNParams=app.file.readAByte(); 
	            cnd.evtDefType=app.file.readAByte(); 
	            cnd.evtIdentifier=app.file.readAShort(); 
				//cnd.evtIdentifier=app.file.readShort(); 
	
	            // Lis les parametres
	            if (cnd.evtNParams>0)
	            {
	                cnd.evtParams=new Array(cnd.evtNParams);
	                var n:int;
	                for (n=0; n<cnd.evtNParams; n++)
	                {
	                    cnd.evtParams[n]=CParam.create(app);
	                }
	            }
				
				if (Object(cnd).valueOf().toString() == "[object CND_ONLOOP]")
				{
					var pExp:CParamExpression= CParamExpression(cnd.evtParams[0]);
					
					if (pExp.tokens.length == 2&&
						pExp.tokens[0].code == ((3<< 16) | 65535)
						&& pExp.tokens[1].code==0)
					{
						var newCnd:CND_ONLOOPFAST= new CND_ONLOOPFAST ();
						
						newCnd.name = (EXP_STRING(pExp.tokens [0])).string.toLowerCase ();
						
						newCnd.evtCode = cnd.evtCode;
						newCnd.evtOi = cnd.evtOi;
						newCnd.evtOiList = cnd.evtOiList;
						newCnd.evtFlags = cnd.evtFlags;
						newCnd.evtFlags2 = cnd.evtFlags2;
						newCnd.evtNParams = cnd.evtNParams;
						newCnd.evtDefType =  cnd.evtDefType;
						newCnd.evtIdentifier = cnd.evtIdentifier;
						newCnd.evtParams = cnd.evtParams;
						
						cnd = newCnd;
					}
				}
			}
	        else
	        {
	            trace("*** Missing condition!");
	        }
	        
	        // Positionne a la fin de la condition
	        app.file.seek(debut+size);
	        
	        return cnd;
	    }
	    
	    public function negaTRUE():Boolean
	    {
	        if ((evtFlags2&EVFLAG2_NOT)!=0)
	            return false;
	        return true;
	    }
	    
	    public function negaFALSE():Boolean
	    {
	        if ((evtFlags2&EVFLAG2_NOT)!=0)
	            return true;
	        return false;
	    }
	    
	    // Empeche les evenements one-shot GLOBAUX de se reproduire
	    public function compute_GlobalNoRepeat(rhPtr:CRun):Boolean
	    {
			var evgPtr:CEventGroup=rhPtr.rhEvtProg.rhEventGroup;
			var inhibit:int=evgPtr.evgInhibit;
			evgPtr.evgInhibit=rhPtr.rhLoopCount;
			var loopCount:int=rhPtr.rhLoopCount;
			if (loopCount==inhibit) 
		    	return false;
			loopCount--;
			if (loopCount==inhibit) 
		        return false;
			return true;
	    }
	    
	    // ------------------------------------------------
	    // Empeche les evenements one-shot de se reproduire
	    // ------------------------------------------------
	    public function compute_NoRepeatCol(identifier:int, pHo:CObject):Boolean
	    {
			// Stocke dans la table actuelle
	        var id:int;
	        var n:int;
	
	        var pArray:CArrayList=pHo.hoBaseNoRepeat;
			if (pArray==null)
			{
	            pArray=new CArrayList();
	            pHo.hoBaseNoRepeat=pArray;
			}
			else
			{
	            // Evenement deja appele dans cette boucle?
	            for (n=0; n<pArray.size(); n++)
	            {
	                id=int(pArray.get(n));
	                if (id==identifier)
	                    return false;
	            }
			}
	        id=new int(identifier);
	        pArray.add(id);
	
	        // Regarde au cycle precedent
			pArray=pHo.hoPrevNoRepeat;					// Au cycle precedent
			if (pArray==null) 
	            return true;
	        for (n=0; n<pArray.size(); n++)
	        {
	            id=int(pArray.get(n));
	            if (id==identifier)
	                return false;
	        }
			return true;
	    }
	    
	    public function compute_NoRepeat(pHo:CObject):Boolean
	    {
			return compute_NoRepeatCol(evtIdentifier, pHo);			//; L'identificateur
	    }    
	    
	    // ------------------------------------------------------------
	    // CONDITION: Selection des objets actifs ayant une value donne
	    // ------------------------------------------------------------
	    public function evaChooseValueOld(rhPtr:CRun, pRoutine:IChooseValue):Boolean
	    {
			var cpt:int=0;
		
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObjectFromType(COI.OBJ_SPR);
			while(pHo!=null)
			{
			    cpt++;
			    var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			    if (pRoutine.evaluate(pHo, value)==false)
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObjectFromType();
			}
			// Vrai / Faux?
			if (cpt!=0) 
			    return true;
			return false;
	    }
	    
	    public function evaChooseValue(rhPtr:CRun, pRoutine:IChooseValue):Boolean
	    {
			var cpt:int=0;
		
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObjectFromType(-1);
			while(pHo!=null)
			{
			    cpt++;
			    var value:int=rhPtr.get_EventExpressionInt(CParamExpression(evtParams[0]));
			    if (pRoutine.evaluate(pHo, value)==false)
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObjectFromType();
			}
			// Vrai / Faux?
			if (cpt!=0) 
			    return true;
			return false;
	    }
	    
	    public function evaExpObject(rhPtr:CRun, pRoutine:IEvaExpObject):Boolean
	    {
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
			var cpt:int=rhPtr.rhEvtProg.evtNSelectedObjects;
			var p:CParamExpression=CParamExpression(evtParams[0]);
			var value:int;
			while(pHo!=null)
			{
			    value=rhPtr.get_EventExpressionInt(p);
			    if (pRoutine.evaExpRoutine(pHo, value, p.comparaison)==false)
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			}
			// Vrai / Faux?
			if (cpt!=0) 
			    return true;
			return false;
	    }
	    
	    public function evaObject(rhPtr:CRun, pRoutine:IEvaObject):Boolean
	    {
			// Boucle d'exploration
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
			var cpt:int=rhPtr.rhEvtProg.evtNSelectedObjects;
			while(pHo!=null)
			{
			    if (pRoutine.evaObjectRoutine(pHo)==false)
			    {
					cpt--;
					rhPtr.rhEvtProg.evt_DeleteCurrentObject();			// On le vire!
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			}
			// Vrai / Faux?
			if (cpt!=0) 
			    return true;
			return false;
	    }
	    
	    public function compareCondition(rhPtr:CRun, param:int, v:int):Boolean
	    {
			// Le parametre
			var value2:CValue=rhPtr.get_EventExpressionAny(CParamExpression(evtParams[param]));
			var comp:int=(CParamExpression(evtParams[param])).comparaison;
			var value:CValue=new CValue(v);
			return CRun.compareTo(value, value2, comp);	
	    }
	    
	    // Verifie une checkmark
	    public function checkMark(rhPtr:CRun, mark:int):Boolean
	    {
			if (mark==0) return false;				// Pas la premiere boucle
			if (mark==rhPtr.rhLoopCount) return true;
			if (mark==rhPtr.rhLoopCount-1) return true;
			return false;
	    }
	
	    // IS COLLIDING
	    public function isColliding(rhPtr:CRun):Boolean
	    {
			// Cas particulier lors de conditions OU, selectionne les deux listes d'objet
			if (rhPtr.rhEvtProg.rh4ConditionsFalse)
			{
			    rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
			    rhPtr.rhEvtProg.evt_FirstObject((PARAM_OBJECT(evtParams[0])).oiList);
			    return false;
			}
		
			// Positionne le flag negate
			var negate:Boolean=false;
			if ((evtFlags2&EVFLAG2_NOT)!=0)
			    negate=true;
		
			// Un objet a voir?
			var pHo:CObject=rhPtr.rhEvtProg.evt_FirstObject(evtOiList);
			if (pHo==null) 
			    return negaFALSE();
			var cpt:int=rhPtr.rhEvtProg.evtNSelectedObjects;
			
			var oi:int=(PARAM_OBJECT(evtParams[0])).oi;
			var oi2List:Array;
			if (oi>=0)					//; Le deuxieme objet
			{
				rhPtr.isColArray[0]=oi;
				rhPtr.isColArray[1]=(PARAM_OBJECT(evtParams[0])).oiList;
				oi2List=rhPtr.isColArray;
			}
			else
			{
				// Qualifier
				var qoil:CQualToOiList=rhPtr.rhEvtProg.qualToOiList[(PARAM_OBJECT(evtParams[0])).oiList&0x7FFF];
				oi2List=qoil.qoiList;
			}
						
			// Boucle d'exploration
			var bFlag:Boolean=false;
			var list:CArrayList;
			var list2:CArrayList=new CArrayList();
			var index:int, n:int;
			var pHo2:CObject;
			do
			{
			    list=rhPtr.objectAllCol_IXY(pHo, pHo.roc.rcImage, pHo.roc.rcAngle, pHo.roc.rcScaleX, pHo.roc.rcScaleY, pHo.hoX, pHo.hoY, oi2List);	
			    if (list==null)
			    {
					if (negate==false)
					{
					    cpt--;
					    rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					}
			    }
			    else
			    {		    
					// Explore la liste des sprites en collision a la recherche du deuxieme objet
					bFlag=false;								// Raz du flag
					var limit:int = list.size();
					for (index=0; index<limit; index++)
					{
					    pHo2=CObject(list.get(index));
					    if ((pHo2.hoFlags&CObject.HOF_DESTROYED)==0)	// Detruit au cycle precedent?
					    {
							list2.add(pHo2);
							bFlag=true;				
					    }
					}
		
					// Vire le sprite?
					if (negate==true)
					{
					    if (bFlag==true) 
					    {
							cpt--;
							rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					    }
					}
					else
					{
					    if (bFlag==false)
					    {
							cpt--;
							rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					    }
					}
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			} while(pHo!=null);	
		
			if (cpt==0) 
			    return false;
		
			// Fabrique la liste du sprite II
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			pHo=rhPtr.rhEvtProg.evt_FirstObject((PARAM_OBJECT(evtParams[0])).oiList);
			if (pHo==null) return false;
			cpt=rhPtr.rhEvtProg.evtNSelectedObjects;
			var list2_size:int = -1;
			if (negate==false)
			{
			    do
			    {
					list2_size = list2.size();
					for (index=0; index<list2_size; index++)
					{
					    pHo2=CObject(list2.get(index));
					    if (pHo==pHo2)
					    {
							break;
					    }
					}
					if (index==list2_size)
					{
					    cpt--;
					    rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					}
					pHo=rhPtr.rhEvtProg.evt_NextObject();
			    }while(pHo!=null);
			    if (cpt!=0) return true;
			    return false;
			}
		
			// Exploration avec negation
			do
			{
				list2_size = list2.size();
			    for (index=0; index<list2_size; index++)
			    {
					pHo2=CObject(list2.get(index));
					if (pHo==pHo2)
					{
					    cpt--;
					    rhPtr.rhEvtProg.evt_DeleteCurrentObject();
					    break;
					}
			    }
			    pHo=rhPtr.rhEvtProg.evt_NextObject();
			}while(pHo!=null);
			if (cpt!=0) return true;
			return false;
	    }
	    
	    public function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
	    	return false;
	    }
	    public function eva2(rhPtr:CRun):Boolean
	    {
	    	return false;
	    }
	}    
}
