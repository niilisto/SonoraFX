// -----------------------------------------------------------------------------
//
// CACTEXTENSION : actions extension
//
// -----------------------------------------------------------------------------
package Actions
{
	import Events.*;
	
	import Expressions.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	import Params.*;
	
	public class CActExtension extends CAct
	{
	    public override function execute(rhPtr:CRun):void
	    {
	        var pHo:CObject = rhPtr.rhEvtProg.get_ActionObjects(this);
	        if (pHo == null)
	        {
	            return;
	        }
	
	        var act:int = (evtCode >>> 16) - CEventProgram.EVENTS_EXTBASE;				// Vire le type
	        var pExt:CExtension = CExtension(pHo);
	        pExt.action(act, this);
	    }

	    // Recolte des parametres
	    // ----------------------
	    public function getParamObject(rhPtr:CRun, num:int):CObject
	    {
	        return rhPtr.rhEvtProg.get_ParamActionObjects((PARAM_OBJECT(evtParams[num])).oiList, this);
	    }
	
	    public function getParamBorder(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamShort(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamAltValue(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamDirection(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
		public function getParamEffect(rhPtr:CRun, num:int):String
		{
			return ( PARAM_STRING(evtParams[num])).string;
		}

		public function getParamCreate(rhPtr:CRun, num:int):PARAM_CREATE
	    {
	        return PARAM_CREATE(evtParams[num]);
	    }
	
	    public function getParamAnimation(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 10)	    // PARAM_TIME
	        {
	            return ( PARAM_SHORT(evtParams[num]) ).value;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamPlayer(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamEvery(rhPtr:CRun, num:int):PARAM_EVERY 
	    {
	        return PARAM_EVERY(evtParams[num]);
	    }
	
	    public function getParamKey(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_KEY(evtParams[num]) ).key;
	    }
	
	    public function getParamSpeed(rhPtr:CRun, num:int):int
	    {
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamPosition(rhPtr:CRun, num:int):CPositionInfo 
	    {
	        var position:CPosition = CPosition(evtParams[num]);
	        var pInfo:CPositionInfo = new CPositionInfo();
	        position.read_Position(rhPtr, 0, pInfo);
	        return pInfo;
	    }
	
	    public function getParamJoyDirection(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamShoot(rhPtr:CRun, num:int):PARAM_SHOOT 
	    {
	        return PARAM_SHOOT(evtParams[num]);
	    }
	
	    public function getParamZone(rhPtr:CRun, num:int):PARAM_ZONE 
	    {
	        return PARAM_ZONE(evtParams[num]);
	    }
	
	    public function getParamExpression(rhPtr:CRun, num:int):int
	    {
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamColour(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 24)	    // PARAM_COLOUR
	        {
	            return ( PARAM_COLOUR(evtParams[num]) ).color;
	        }
	        return CServices.swapRGB(rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num])));
	    }
	
	    public function getParamFrame(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamNewDirection(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 29)	    // PARAM_NEWDIRECTION
	        {
	            return ( PARAM_SHORT(evtParams[num]) ).value;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamClick(rhPtr:CRun, num:int):int
	    {
	        return ( PARAM_SHORT(evtParams[num]) ).value;
	    }
	
	    public function getParamExpString(rhPtr:CRun, num:int):String 
	    {
	        return rhPtr.get_EventExpressionString( CParamExpression(evtParams[num]) );
	    }

	    public function getParamFilename(rhPtr:CRun, num:int):String
	    {
	        if (evtParams[num].code == 40)	    // PARAM_FILENAME
	        {
	            return ( PARAM_STRING(evtParams[num]) ).string;
	        }
	        return rhPtr.get_EventExpressionString( CParamExpression(evtParams[num]) );
	    }

	
	    public function getParamExpDouble(rhPtr:CRun, num:int):Number
	    {
	        var value:CValue = rhPtr.get_EventExpressionAny( CParamExpression(evtParams[num]) );
	        return value.getDouble();
	    }
	
	    public function getParamFilename2(rhPtr:CRun, num:int):String
	    {
	        if (evtParams[num].code == 63)	    // PARAM_FILENAME2
	        {
	            return ( PARAM_STRING(evtParams[num]) ).string;
	        }
	        return rhPtr.get_EventExpressionString( CParamExpression(evtParams[num]) );
	    }
	
	    public function getParamExtension(rhPtr:CRun, num:int):CBinaryFile 
	    {
	        var p:PARAM_EXTENSION = PARAM_EXTENSION(evtParams[num]);
	        if (p.data != null)
	        {
	            return new CBinaryFile(p.data, rhPtr.rhApp.bUnicode);
	        }
	        return null;
	    }
	    
	    public function getParamTime(rhPtr:CRun, num:int):int
	    {
	        if (evtParams[num].code == 2)	    // PARAM_TIME
	        {
	            return ( PARAM_TIME(evtParams[num])).timer;
	        }
	        return rhPtr.get_EventExpressionInt( CParamExpression(evtParams[num]) );
	    }
	

	}
}