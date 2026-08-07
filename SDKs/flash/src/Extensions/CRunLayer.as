//----------------------------------------------------------------------------------
//
// CRUNLAYER : Objet layer
//
//----------------------------------------------------------------------------------
package Extensions
{
	import Actions.*;
	
	import Conditions.*;
	
	import Expressions.*;
	
	import Frame.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import Sprites.*;
	
	public class CRunLayer extends CRunExtension
	{
	    public static var X_UP:int=0;
	    public static var X_DOWN:int=1;
	    public static var Y_UP:int=2;
	    public static var Y_DOWN:int=3;
	    public static var ALT_UP:int=4;
	    public static var ALT_DOWN:int=5;    
	    
	    public var holdFValue:int;
	    public var wCurrentLayer:int;
		
		public function CRunLayer()
		{
		}

	    public override function getNumberOfConditions():int
	    {
	        return 12;
	    }

	    public override function createRunObject(file:CBinaryFile, cob:CCreateObjectInfo, version:int):Boolean
	    {
	        wCurrentLayer = ho.hoLayer;
	        return false;
	    }


	    // Conditions
	    // --------------------------------------------------
	    public override function condition(num:int, cnd:CCndExtension):Boolean
	    {
	        switch (num)
	        {
	            case 0:
	                return cndAtBack(cnd);
	            case 1:
	                return cndAtFront(cnd);
	            case 2:
	                return cndAbove(cnd);
	            case 3:
	                return cndBelow(cnd);
	            case 4:
	                return cndBetween(cnd);
	            case 5:
	                return cndAtBackObj(cnd);
	            case 6:
	                return cndAtFrontObj(cnd);
	            case 7:
	                return cndAboveObj(cnd);
	            case 8:
	                return cndBelowObj(cnd);
	            case 9:
	                return cndBetweenObj(cnd);
	            case 10:
	                return cndIsLayerVisible(cnd);
	            case 11:
	                return cndIsLayerVisibleByName(cnd);
	        }
	        return false;
	    }
	
	    public function cndAtBack(cnd:CCndExtension):Boolean
	    {
	        var param1:int = cnd.getParamExpression(rh, 0);
	        return cndAtBackRout(param1);
	    }
	
	    public function cndAtBackRout(param1:int):Boolean
	    {
	        var nLayer:int = wCurrentLayer;	
			var pObject:CObject;
			var oMini:CObject=null;
			var pMini:int=100000;
			var p:int;
			for (pObject=ho.getFirstObject(); pObject!=null; pObject=ho.getNextObject())
			{
				if (pObject.ros!=null && pObject.hoLayer==nLayer)
				{		
					p=pObject.getChildIndex();			
					if (p>=0 && p<pMini)
					{
						oMini=pObject;
						pMini=p;
					}
				}
			}
			
			if (oMini!=null)
			{
	            var FValue:int = (oMini.hoCreationId << 16) + (oMini.hoNumber&0xFFFF);
	
	            if (param1 == 0)
	            {
	                param1 = holdFValue;
	            }
	
	            // Returns TRUE if the object is the first sprite (= if it's fixed value is the same as the one of the first sprite)
	            if (param1 == FValue)
	            {
	                return true;
	            }
			}		
			return false;
	    }
	
	    public function cndAtFront(cnd:CCndExtension):Boolean
	    {
	        var param1:int = cnd.getParamExpression(rh, 0);
	        return cndAtFrontRout(param1);
	    }
	
	    public function cndAtFrontRout(param1:int):Boolean
	    {
	        var nLayer:int = wCurrentLayer;
	
			var pObject:CObject;
			var oMaxi:CObject=null;
			var pMaxi:int=-1;
			var p:int;
			for (pObject=ho.getFirstObject(); pObject!=null; pObject=ho.getNextObject())
			{
				if (pObject.ros!=null && pObject.hoLayer==nLayer)
				{		
					p=pObject.getChildIndex();			
					if (p>=0 && p>pMaxi)
					{
						oMaxi=pObject;
						pMaxi=p;
					}
				}
			}
			
			if (oMaxi!=null)
			{
	            var FValue:int = (oMaxi.hoCreationId << 16) + (oMaxi.hoNumber&0xFFFF);
	
	            if (param1 == 0)
	            {
	                param1 = holdFValue;
	            }
	
	            // Returns TRUE if the object is the last sprite (= if it's fixed value is the same as the one of the last sprite)
	            if (param1 == FValue)
	            {
	                return true;
	            }
	        }
	        return false;	
	    }
	
	    public function cndAbove(cnd:CCndExtension):Boolean
	    {
	        var param1:int = cnd.getParamExpression(rh, 0);
	        var param2:int = cnd.getParamExpression(rh, 1);
	        return cndAboveRout(param1, param2);
	    }
	
	    public function cndAboveRout(param1:int, param2:int):Boolean
	    {
	        var roPtr1:CObject = null;
	        var roPtr2:CObject = null;
	        var FValue1:int;
	        var FValue2:int;
	
	        if (param1 == 0)
	        {
	            param1 = holdFValue;
	        }
	
	        if (param2 == 0)
	        {
	            param2 = holdFValue;
	        }
	
	        for (roPtr1=ho.getFirstObject(); roPtr1!=null; roPtr1=ho.getNextObject())
	        {
	            FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	            if (roPtr1.ros!=null && param1 == FValue1)
	            {
	                //We have a match, get the second object
			        for (roPtr2=ho.getFirstObject(); roPtr2!=null; roPtr2=ho.getNextObject())
			        {
			            FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                    if (roPtr2.ros!=null && param2 == FValue2)
	                    {
		                    if (roPtr1.hoLayer != roPtr2.hoLayer)			// Different layer?
		                    {
		                        return (roPtr1.hoLayer>roPtr2.hoLayer);
		                    }
							var i1:int=roPtr1.getChildIndex();
							var i2:int=roPtr2.getChildIndex();
							if (i1>=0 && i2>=0)
							{
			                    if (i1>i2)
			                    {
			                        return true;
			                    }
							}
							return false;
	                    }
	                }
	            }
	        }
	        return false;
	    }
	
	    public function cndBelow(cnd:CCndExtension):Boolean
	    {
	        var param1:int = cnd.getParamExpression(rh, 0);
	        var param2:int = cnd.getParamExpression(rh, 1);
	        return cndBelowRout(param1, param2);
	    }
	
	    public function cndBelowRout(param1:int, param2:int):Boolean
	    {
	        var roPtr1:CObject = null;
	        var roPtr2:CObject = null;
	        var FValue1:int;
	        var FValue2:int;
	
	        if (param1 == 0)
	        {
	            param1 = holdFValue;
	        }
	
	        if (param2 == 0)
	        {
	            param2 = holdFValue;
	        }
	
	        for (roPtr1=ho.getFirstObject(); roPtr1!=null; roPtr1=ho.getNextObject())
	        {
	            FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	            if (roPtr1.ros!=null && param1 == FValue1)
	            {
	                //We have a match, get the second object
			        for (roPtr2=ho.getFirstObject(); roPtr2!=null; roPtr2=ho.getNextObject())
			        {
			            FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                    if (roPtr2.ros!=null && param2 == FValue2)
	                    {
		                    if (roPtr1.hoLayer != roPtr2.hoLayer)			// Different layer?
		                    {
		                        return (roPtr1.hoLayer<roPtr2.hoLayer);
		                    }
							var i1:int=roPtr1.getChildIndex();
							var i2:int=roPtr2.getChildIndex();
							if (i1>=0 && i2>=0)
							{
			                    if (i1<i2)
			                    {
			                        return true;
			                    }
							}
							return false;
	                    }
	                }
	            }
	        }
	        return false;
	    }
	
	    public function cndBetween(cnd:CCndExtension):Boolean
	    {
	        var p1:int = cnd.getParamExpression(rh, 0);
	        var p2:int = cnd.getParamExpression(rh, 1);
	        var p3:int = cnd.getParamExpression(rh, 2);
	
	        var roPtr1:CObject = null;
	        var roPtr2:CObject = null;
	        var sprPtr1:CObject = null;
	        var sprPtr2:CObject = null;
	        var sprPtr3:CObject = null;
	        var FValue1:int;
	        var FValue2:int;
	
	        if (p1 == 0)
	        {
	            p1 = holdFValue;
	        }	
	        if (p2 == 0)
	        {
	            p2 = holdFValue;
	        }	
	        if (p3 == 0)
	        {
	            p3 = holdFValue;
	        }
	
	        var bFound2:Boolean = false;
	        var bFound3:Boolean = false;
	        for (roPtr1=ho.getFirstObject(); roPtr1!=null; roPtr1=ho.getNextObject())
	        {
	            FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	            if (roPtr1.ros!=null && p1 == FValue1)
	            {
	            	sprPtr1=roPtr1;
	            	break;
	            }
	        }
			if (sprPtr1!=null)
			{	            	
	            //We have a match, get the second object
		        for (roPtr2=ho.getFirstObject(); roPtr2!=null; roPtr2=ho.getNextObject())
		        {
		            FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                if (roPtr2.ros!=null && p2 == FValue2)
	                {
	                    sprPtr2 = roPtr2;
	                }	
	                if (roPtr2.ros!=null && p3 == FValue2)
	                {
	                    sprPtr3 = roPtr2;
	                }
	                if (sprPtr2!=null && sprPtr3!=null)
	                {
	                	break;
	                }
	            }
	            if ((sprPtr1 != null) && (sprPtr2 != null) && (sprPtr3 != null))
	            {
	                // MMF2
	                var n1:int=sprPtr1.getChildIndex();
	                var n2:int=sprPtr2.getChildIndex();
	                var n3:int=sprPtr3.getChildIndex();
	                if (n1>=0 && n2>=0 && n3>=0)
	                {
		                if ((n3 > n1 && n1 > n2) || (n2 > n1 && n1 > n3))
		                {
		                    return true;
		                }
		            }
	            }
	        }
	        return false;
	    }
	
	    public function cndAtBackObj(cnd:CCndExtension):Boolean
	    {
	        var param1:PARAM_OBJECT = cnd.getParamObject(rh, 0);
	        return lyrProcessCondition(param1, null, 0);
	    }
	
	    public function cndAtFrontObj(cnd:CCndExtension):Boolean
	    {
	        var param1:PARAM_OBJECT = cnd.getParamObject(rh, 0);
	        return lyrProcessCondition(param1, null, 1);
	    }
	
	    public function cndAboveObj(cnd:CCndExtension):Boolean
	    {
	        var param1:PARAM_OBJECT = cnd.getParamObject(rh, 0);
	        var param2:PARAM_OBJECT = cnd.getParamObject(rh, 1);
	        return lyrProcessCondition(param1, param2, 2);
	    }
	
	    public function cndBelowObj(cnd:CCndExtension):Boolean
	    {
	        var param1:PARAM_OBJECT = cnd.getParamObject(rh, 0);
	        var param2:PARAM_OBJECT = cnd.getParamObject(rh, 1);
	        return lyrProcessCondition(param1, param2, 3);
	    }
	
	    public function cndBetweenObj(cnd:CCndExtension):Boolean
	    {
	        var IsAbove:Boolean = false;
	        var IsBelow:Boolean = false;
	
	        var ObjectA:PARAM_OBJECT = cnd.getParamObject(rh, 0);
	        var ObjectB:PARAM_OBJECT = cnd.getParamObject(rh, 1);
	        var ObjectC:PARAM_OBJECT = cnd.getParamObject(rh, 2);
	
	        var IsBetween:Boolean = false;
	
	        // Is Object A between Object B and Object C?
	        if (IsAbove = lyrProcessCondition(ObjectA, ObjectB, 2))
	        {
	            if (IsBelow = lyrProcessCondition(ObjectA, ObjectC, 3))
	            {
	                IsBetween = true;
	            }
	        }
	
	        if (!IsBetween)
	        {
	            IsAbove = false;
	
	            lyrResetEventList(lyrGetOILfromEVP(ObjectA));
	            if (IsBelow = lyrProcessCondition(ObjectA, ObjectB, 3))
	            {
	                if (IsAbove = lyrProcessCondition(ObjectA, ObjectC, 2))
	                {
	                    IsBetween = true;
	                }
	            }
	        }
	        return IsBetween;
	    }
	
	    public function cndIsLayerVisible(cnd:CCndExtension):Boolean
	    {
	        var param1:int = cnd.getParamExpression(rh, 0);
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
	            return pLayer.bVisible;
	        }
	        return false;
	    }
	
	    // Returns index of layer (1-based) or 0 if layer not found
	    public function FindLayerByName(pName:String):int
	    {
	        if (pName != null)
	        {
	            var nLayer:int;
	            for (nLayer = 0; nLayer < ho.hoAdRunHeader.rhFrame.nLayers; nLayer++)
	            {
	                var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer];
	                if (pLayer.pName!=null && CServices.compareStringsIgnoreCase(pName, pLayer.pName))
	                {
	                    return (nLayer + 1);
	                }
	            }
	        }
	        return 0;
	    }
	
	    public function cndIsLayerVisibleByName(cnd:CCndExtension):Boolean
	    {
	        var param1:String = cnd.getParamExpString(rh, 0);
	
	        var nLayer:int = FindLayerByName(param1);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            return pLayer.bVisible;
	        }
	        return false;
	    }

	    // Actions
	    // -------------------------------------------------
	    public override function action(num:int, act:CActExtension):void
	    {
	        switch (num)
	        {
	            case 0:
	                actBackOne(act);
	                break;
	            case 1:
	                actForwardOne(act);
	                break;
	            case 2:
	                actSwap(act);
	                break;
	            case 3:
	                actSetObj(act);
	                break;
	            case 4:
	                actBringFront(act);
	                break;
	            case 5:
	                actSendBack(act);
	                break;
	            case 6:
	                actBackN(act);
	                break;
	            case 7:
	                actForwardN(act);
	                break;
	            case 8:
	                actReverse(act);
	                break;
	            case 9:
	                actMoveAbove(act);
	                break;
	            case 10:
	                actMoveBelow(act);
	                break;
	            case 11:
	                actMoveToN(act);
	                break;
	            case 12:
	                actSortByXUP(act);
	                break;
	            case 13:
	                actSortByYUP(act);
	                break;
	            case 14:
	                actSortByXDOWN(act);
	                break;
	            case 15:
	                actSortByYDOWN(act);
	                break;
	            case 16:
	                actBackOneObj(act);
	                break;
	            case 17:
	                actForwardOneObj(act);
	                break;
	            case 18:
	                actSwapObj(act);
	                break;
	            case 19:
	                actBringFrontObj(act);
	                break;
	            case 20:
	                actSendBackObj(act);
	                break;
	            case 21:
	                actBackNObj(act);
	                break;
	            case 22:
	                actForwardNObj(act);
	                break;
	            case 23:
	                actMoveAboveObj(act);
	                break;
	            case 24:
	                actMoveBelowObj(act);
	                break;
	            case 25:
	                actMoveToNObj(act);
	                break;
	            case 26:
	                actSortByALTUP(act);
	                break;
	            case 27:
	                actSortByALTDOWN(act);
	                break;
	            case 28:
	                actSetLayerX(act);
	                break;
	            case 29:
	                actSetLayerY(act);
	                break;
	            case 30:
	                actSetLayerXY(act);
	                break;
	            case 31:
	                actShowLayer(act);
	                break;
	            case 32:
	                actHideLayer(act);
	                break;
	            case 33:
	                actSetLayerXByName(act);
	                break;
	            case 34:
	                actSetLayerYByName(act);
	                break;
	            case 35:
	                actSetLayerXYByName(act);
	                break;
	            case 36:
	                actShowLayerByName(act);
	                break;
	            case 37:
	                actHideLayerByName(act);
	                break;
	            case 38:
	                actSetCurrentLayer(act);
	                break;
	            case 39:
	                actSetCurrentLayerByName(act);
	                break;
	            case 40:
	                actSetLayerCoefX(act);
	                break;
	            case 41:
	                actSetLayerCoefY(act);
	                break;
	            case 42:
	                actSetLayerCoefXByName(act);
	                break;
	            case 43:
	                actSetLayerCoefYByName(act);
	                break;
				case 44:
					actSetLayerEffect(act);
					break;
				case 46:
					actSetLayerAlpha(act);
					break;
				case 47:
					actSetLayerRGB(act);
					break;
				case 48:
					actSetLayerEffectByName(act);
					break;
				case 50:
					actSetLayerAlphaByName(act);
					break;
				case 51:
					actSetLayerRGBByName(act);
					break;
	        }
	    }
	
	    public function actBackOne(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        actBackOneRout(param1);
	    }
	
	    public function actBackOneRout(param1:int):void
	    {
	        var sprPtr1:CObject;
	        var sprPtr2:CObject;
	        if ((sprPtr1 = lyrGetSprite(param1)) != null)
	        {
	        	var index:int=sprPtr1.getChildIndex();
	        	sprPtr1.setChildIndex(index-1);
	        }
	    }
	
	    public function actForwardOne(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        actForwardOneRout(param1);
	    }
	
	    public function actForwardOneRout(param1:int):void
	    {
	        var sprPtr1:CObject;
	
	        if ((sprPtr1 = lyrGetSprite(param1)) != null)
	        {
	        	var index:int=sprPtr1.getChildIndex();
	        	sprPtr1.setChildIndex(index+1);
	        }
	    }
	
	    public function actSwap(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actSwapRout(param1, param2);
	    }
	
	    public function actSwapRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        var sprPtr2:CObject;
	
	        if ((sprPtr1 = lyrGetSprite(param1)) != null)
	        {
	            if ((sprPtr2 = lyrGetSprite(param2)) != null)
	            {
	                if (sprPtr1.hoLayer==sprPtr2.hoLayer)
	                {
	                    lyrSwapThem(sprPtr1, sprPtr2, true);
	                }
	            }
	        }
	    }
	
	    public function actSetObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
			if(roPtr != null)
	        	holdFValue = lyrGetFVfromOIL(roPtr.hoOiList);
	    }
	
	    public function actBringFront(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        actBringFrontRout(param1);
	    }
	
	    public function actBringFrontRout(param1:int):void
	    {
            var pSpr:CObject = lyrGetSprite(param1);		// (npSpr)roPtr->roc.rcSprite;
            if (pSpr != null)
            {
            	pSpr.setChildIndex(100000);
	        }
	    }
	
	    public function actSendBack(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        actSendBackRout(param1);
	    }
	
	    public function actSendBackRout(param1:int):void
	    {
            var pSpr:CObject = lyrGetSprite(param1);		// (npSpr)roPtr->roc.rcSprite;
            if (pSpr != null)
            {
            	pSpr.setChildIndex(0);
	        }	
	    }
	
	    public function actBackN(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actBackNRout(param1, param2);
	    }
	
	    public function actBackNRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        sprPtr1 = lyrGetSprite(param1);
	        if (sprPtr1 != null)
	        {
	        	var index:int=sprPtr1.getChildIndex();
	        	index-=param2;
	        	if (index<0)
	        	{
	        		index=0;
	        	}
	        	sprPtr1.setChildIndex(index);
	        }
	    }
	
	    public function actForwardN(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actForwardNRout(param1, param2);
	    }
	
	    public function actForwardNRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        sprPtr1 = lyrGetSprite(param1);
	        
	        if (sprPtr1 != null)
	        {
	        	var index:int=sprPtr1.getChildIndex();
	        	index+=param2;
	        	sprPtr1.setChildIndex(index);
	        }
	    }
	
	    public function actReverse(act:CActExtension):void
	    {
	        var sprPtr1:CObject;	
	        var nLayer:int = wCurrentLayer;
			var objects:Array=new Array(ho.hoAdRunHeader.rhNObjects);
			var count:int=0;
			for (sprPtr1=ho.getFirstObject(); sprPtr1!=null; sprPtr1=ho.getNextObject())
			{
				if (sprPtr1.ros!=null && sprPtr1.hoLayer==nLayer)
				{
					objects[count++]=sprPtr1;
				}					
			}	

			var n:int;
			for (n=count-1; n>=0; n--)
			{
				objects[n].setChildIndex(100000);
			}
	    }
	
	    public function actMoveAbove(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actMoveAboveRout(param1, param2);
	    }
	
	    public function actMoveAboveRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        var sprPtr2:CObject;
	
			sprPtr1 = lyrGetSprite(param1);
	        if (sprPtr1 != null)
	        {
	        	sprPtr2 = lyrGetSprite(param2);
	            if (sprPtr2 != null)
	            {
	                if (sprPtr1.hoLayer == sprPtr2.hoLayer)
	                {
	                	var index:int=sprPtr2.getChildIndex();
	                	sprPtr1.setChildIndex(index+1);
	                }
	            }
	        }
	    }
	
	    public function actMoveBelow(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actMoveBelowRout(param1, param2);
	    }
	
	    public function actMoveBelowRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        var sprPtr2:CObject;
	
			sprPtr1 = lyrGetSprite(param1);
	        if (sprPtr1 != null)
	        {
	        	sprPtr2 = lyrGetSprite(param2);
	            if (sprPtr2 != null)
	            {
	                if (sprPtr1.hoLayer == sprPtr2.hoLayer)
	                {
	                	var index:int=sprPtr2.getChildIndex();
	                	sprPtr1.setChildIndex(index-1);
	                }
	            }
	        }
	    }
	
	    public function actMoveToN(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        actMoveToNRout(param1, param2);
	    }
	
	    public function actMoveToNRout(param1:int, param2:int):void
	    {
	        var sprPtr1:CObject;
	        sprPtr1 = lyrGetSprite(param1);
	        if (sprPtr1 != null)
	        {
	        	sprPtr1.setChildIndex(param2);
	        }
	    }
	
	    public function actSortByXUP(act:CActExtension):void
	    {
	        lyrSortBy(X_UP, 0, 0);
	    }
	
	    public function actSortByYUP(act:CActExtension):void
	    {
	        lyrSortBy(Y_UP, 0, 0);
	    }
	
	    public function actSortByXDOWN(act:CActExtension):void
	    {
	        lyrSortBy(X_DOWN, 0, 0);
	    }
	
	    public function actSortByYDOWN(act:CActExtension):void
	    {
	        lyrSortBy(Y_DOWN, 0, 0);
	    }
	
	    public function actBackOneObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var oilPtr:CObjInfo = roPtr.hoOiList;
	        if (roPtr!=null)
	        {
		        actBackOneRout(lyrGetFVfromOIL(oilPtr));
	        }
	    }
	
	    public function actForwardOneObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        if (roPtr!=null)
	        {
		        actForwardOneRout(lyrGetFVfromOIL(roPtr.hoOiList));
	        }
	    }
	
	    public function actSwapObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var roPtr2:CObject = act.getParamObject(rh, 1);
	        if (roPtr!=null && roPtr2!=null)
	        {		
	        	actSwapRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
	        }
	    }
	
	    public function actBringFrontObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        if (roPtr!=null)
	        {
		        actBringFrontRout(lyrGetFVfromOIL(roPtr.hoOiList));
	        }
	    }
	
	    public function actSendBackObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        if (roPtr!=null)
	        {
		        actSendBackRout(lyrGetFVfromOIL(roPtr.hoOiList));
	        }
	    }
	
	    public function actBackNObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        if (roPtr!=null)
	        {
		        actBackNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
	        }
	    }
	
	    public function actForwardNObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        if (roPtr!=null)
	        {
		        actForwardNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
	        }
	    }
	
	    public function actMoveAboveObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var roPtr2:CObject = act.getParamObject(rh, 1);
	        if (roPtr!=null && roPtr2!=null)
	        {
	        	actMoveAboveRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
	        }
	    }
	
	    public function actMoveBelowObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var roPtr2:CObject = act.getParamObject(rh, 1);
	        if (roPtr!=null && roPtr2!=null)
	        {
		        actMoveBelowRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
	        }
	    }
	
	    public function actMoveToNObj(act:CActExtension):void
	    {
	        var roPtr:CObject = act.getParamObject(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        if (roPtr!=null)
	        {
	        	actMoveToNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
	        }
	    }
	
	    public function actSortByALTUP(act:CActExtension):void
	    {
	        var param1:int = act.getParamAltValue(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        lyrSortBy(ALT_UP, param2, param1);
	    }
	
	    public function actSortByALTDOWN(act:CActExtension):void
	    {
	        var param1:int = act.getParamAltValue(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        lyrSortBy(ALT_DOWN, param2, param1);
	    }
	
	    public function actSetLayerX(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
	            var newX:int = -param2;
	            if (pLayer.x != newX || pLayer.dx != 0)
	            {
	                pLayer.dx = newX-pLayer.x;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerY(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
	            var newY:int = -param2;
	            if (pLayer.y != newY || pLayer.dy != 0)
	            {
	                pLayer.dy = newY-pLayer.y;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerXY(act:CActExtension):void
	    {
	        var nLayer:int = act.getParamExpression(rh, 0);
	        var newX:int = act.getParamExpression(rh, 1);
	        var newY:int = act.getParamExpression(rh, 2);
	
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            if (pLayer.x != newX || pLayer.dx != 0 || pLayer.y != newY || pLayer.dy != 0)
	            {
	                pLayer.dx = newX;
	                pLayer.dy = newY;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actShowLayer(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
				if ((pLayer.dwOptions & CLayer.FLOPT_TOHIDE) != 0)
				{
					pLayer.dwOptions |= (CLayer.FLOPT_TOSHOW | CLayer.FLOPT_REDRAW);
					pLayer.dwOptions &= ~CLayer.FLOPT_TOHIDE;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
				}
				ho.hoAdRunHeader.showLayer(param1-1);
			}
	    }
	
	    public function actHideLayer(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
				if ((pLayer.dwOptions & CLayer.FLOPT_TOHIDE) == 0)
				{
					pLayer.dwOptions |= (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_REDRAW);
					pLayer.dwOptions &= ~CLayer.FLOPT_TOSHOW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
				}
				ho.hoAdRunHeader.hideLayer(param1-1);
	        }
	    }
	
	    public function actSetLayerXByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	
	        var nLayer:int = FindLayerByName(param1);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            var newX:int = -param2;
	            if (pLayer.x != newX || pLayer.dx != 0)
	            {
	                pLayer.dx = newX;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerYByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	        var param2:int = act.getParamExpression(rh, 1);
	
	        var nLayer:int = FindLayerByName(param1);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            var newY:int = -param2;
	            if (pLayer.y != newY || pLayer.dy != 0)
	            {
	                pLayer.dy = newY;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerXYByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	        var newX:int = act.getParamExpression(rh, 1);
	        var newY:int = act.getParamExpression(rh, 2);
	
	        var nLayer:int = FindLayerByName(param1);
			var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            if (pLayer.x != newX || pLayer.dx != 0 || pLayer.y != newY || pLayer.dy != 0)
	            {
	                pLayer.dx = newX;
	                pLayer.dy = newY;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actShowLayerByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	
	        var nLayer:int = FindLayerByName(param1);
			var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
				if ((pLayer.dwOptions & CLayer.FLOPT_TOHIDE) != 0)
				{
					pLayer.dwOptions |= (CLayer.FLOPT_TOSHOW | CLayer.FLOPT_REDRAW);
					pLayer.dwOptions &= ~CLayer.FLOPT_TOHIDE;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
				}
	        	ho.hoAdRunHeader.showLayer(nLayer-1);
	        }
	    }
	
	    public function actHideLayerByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	
	        var nLayer:int = FindLayerByName(param1);
			var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
				if ((pLayer.dwOptions & CLayer.FLOPT_TOHIDE) == 0)
				{
					pLayer.dwOptions |= (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_REDRAW);
					pLayer.dwOptions &= ~CLayer.FLOPT_TOSHOW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
				}
	        	ho.hoAdRunHeader.hideLayer(nLayer-1);
	        }
	    }
	
	    public function actSetCurrentLayer(act:CActExtension):void
	    {
	        var nLayer:int = act.getParamExpression(rh, 0);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            wCurrentLayer = (nLayer - 1);
	        }
	    }
	
	    public function actSetCurrentLayerByName(act:CActExtension):void
	    {
	        var name:String = act.getParamExpString(rh, 0);
	        var nLayer:int = FindLayerByName(name);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            wCurrentLayer = (nLayer - 1);
	        }
	    }
	
	    public function actSetLayerCoefX(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var newCoef:Number = act.getParamExpDouble(rh, 1);
	
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
	            if (pLayer.xCoef != newCoef)
	            {
	                pLayer.xCoef = newCoef;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerCoefY(act:CActExtension):void
	    {
	        var param1:int = act.getParamExpression(rh, 0);
	        var newCoef:Number = act.getParamExpDouble(rh, 1);
	
	        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
	            if (pLayer.yCoef != newCoef)
	            {
	                pLayer.yCoef = newCoef;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerCoefXByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	        var newCoef:Number = act.getParamExpDouble(rh, 1);
	
	        var nLayer:int = FindLayerByName(param1);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            if (pLayer.xCoef != newCoef)
	            {
	                pLayer.xCoef = newCoef;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	                ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }
	
	    public function actSetLayerCoefYByName(act:CActExtension):void
	    {
	        var param1:String = act.getParamExpString(rh, 0);
	        var newCoef:Number = act.getParamExpDouble(rh, 1);
	
	        var nLayer:int = FindLayerByName(param1);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            if (pLayer.yCoef != newCoef)
	            {
	                pLayer.yCoef = newCoef;
					pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
					ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
	         		ho.hoAdRunHeader.scrollLayers();
	            }
	        }
	    }

		public function setEffect(layer:CLayer, effectName:String):void
		{
			var effect:int = CRSpr.BOP_COPY;
			if (effectName != null && effectName.length!= 0)
			{
				if (effectName == "Add")
					effect = CRSpr.BOP_ADD;
				else if (effectName == "Invert")
					effect = CRSpr.BOP_INVERT;
				else if (effectName == "Sub")
					effect = CRSpr.BOP_SUB;
				else if (effectName == "Mono")
					effect = CRSpr.BOP_MONO;
				else if (effectName == "Blend")
					effect = CRSpr.BOP_BLEND;
				else if (effectName == "XOR")
					effect = CRSpr.BOP_XOR;
				else if (effectName == "OR")
					effect = CRSpr.BOP_OR;
				else if (effectName == "AND")
					effect = CRSpr.BOP_AND;				
			}
			layer.effect &= ~CRSpr.BOP_MASK;
			layer.effect |= effect;
			layer.setEffect(layer.effect, layer.effectParam);
		}
		public function actSetLayerEffect(act:CActExtension):void
		{
			var nLayer:int = act.getParamExpression(rh, 0);
			var effectName:String= act.getParamEffect(rh, 1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				setEffect(ho.hoAdRunHeader.rhFrame.layers[nLayer - 1], effectName);
			}
		}
		public function actSetLayerEffectByName(act:CActExtension):void
		{
			var param1:String = act.getParamExpString(rh, 0);
			var effectName:String= act.getParamEffect(rh, 1);
			
			var nLayer:int = FindLayerByName(param1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				setEffect(pLayer, effectName);
			}
		}
		public function setAlpha(layer:CLayer, alphaCoef:int):void
		{
			var alpha:int = CServices.clamp(255-alphaCoef, 0, 255);
			var wasSemi:Boolean = ((layer.effect & CRSpr.BOP_RGBAFILTER) == 0);
			layer.effect = (layer.effect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = 0x00FFFFFF;
			
			if (!wasSemi)
				rgbaCoeff = layer.effectParam;
			
			var alphaPart:int = alpha << 24;
			var rgbPart:int = (rgbaCoeff & 0x00FFFFFF);
			layer.effectParam = alphaPart | rgbPart;			
			layer.setEffect(layer.effect, layer.effectParam);
		}
		public function actSetLayerAlpha(act:CActExtension):void
		{
			var nLayer:int = act.getParamExpression(rh, 0);
			var alpha:int = act.getParamExpression(rh, 1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				setAlpha(ho.hoAdRunHeader.rhFrame.layers[nLayer - 1], alpha);
			}
		}
		public function actSetLayerAlphaByName(act:CActExtension):void
		{
			var param1:String = act.getParamExpString(rh, 0);
			var alpha:int = act.getParamExpression(rh, 1);			
			var nLayer:int = FindLayerByName(param1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				setAlpha(pLayer, alpha);
			}
		}
		public function setRGB(layer:CLayer, argb:int):void
		{
			var wasSemi:Boolean = ((layer.effect & CRSpr.BOP_RGBAFILTER) == 0);
			layer.effect = (layer.effect & CRSpr.BOP_MASK) | CRSpr.BOP_RGBAFILTER;
			
			var rgbaCoeff:int = layer.effectParam;
			var alphaPart:int;
			if (wasSemi)
			{
				if (layer.effectParam == -1)
				{
					alphaPart = 0xFF000000;
				}
				else
				{
					alphaPart = (255 - (layer.effectParam*2))<<24;
				}
			}
			else
			{
				alphaPart = rgbaCoeff & 0xFF000000;
			}
			
			var rgbPart:int = CServices.swapRGB(argb & 0x00FFFFFF);
			var filter:int = alphaPart | rgbPart;
			layer.effectParam = filter;
			
			layer.setEffect(layer.effect, layer.effectParam);
		}
		public function actSetLayerRGB(act:CActExtension):void
		{
			var nLayer:int = act.getParamExpression(rh, 0);
			var rgb:int = act.getParamExpression(rh, 1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				setRGB(ho.hoAdRunHeader.rhFrame.layers[nLayer - 1], rgb);
			}
		}
		public function actSetLayerRGBByName(act:CActExtension):void
		{
			var param1:String = act.getParamExpString(rh, 0);
			var rgb:int = act.getParamExpression(rh, 1);			
			var nLayer:int = FindLayerByName(param1);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				setRGB(pLayer, rgb);
			}
		}
		
		
	    // Expressions
	    // --------------------------------------------
	    public override function expression(num:int):CValue
	    {
	        switch (num)
	        {
	            case 0:
	                return expGetFV();
	            case 1:
	                return expGetTopFV();
	            case 2:
	                return expGetBottomFV();
	            case 3:
	                return expGetDesc();
	            case 4:
	                return expGetDesc10();
	            case 5:
	                return expGetNumLevels();
	            case 6:
	                return expGetLevel();
	            case 7:
	                return expGetLevelFV();
	            case 8:
	                return expGetLayerX();
	            case 9:
	                return expGetLayerY();
	            case 10:
	                return expGetLayerXByName();
	            case 11:
	                return expGetLayerYByName();
	            case 12:
	                return expGetLayerCount();
	            case 13:
	                return expGetLayerName();
	            case 14:
	                return expGetLayerIndex();
	            case 15:
	                return expGetCurrentLayer();
	            case 16:
	                return expGetLayerCoefX();
	            case 17:
	                return expGetLayerCoefY();
	            case 18:
	                return expGetLayerCoefXByName();
	            case 19:
	                return expGetLayerCoefYByName();
				case 20:
					return expGetLayerEffectParam();
				case 21:
					return expGetLayerAlpha();
				case 22:
					return expGetLayerRGB();
				case 23:
					return expGetLayerEffectParamByName();
				case 24:
					return expGetLayerAlphaByName();
				case 25:
					return expGetLayerRGBByName();		
	        }
	        return null;
	    }
	
	    public function expGetFV():CValue
	    {
	        var roPtr:CObject;
	        var oilPtr:CObjInfo;
	
	        var FValue:int = 0;
	        var objName:String = ho.getExpParam().getString();
	
	        if (objName.length==0)
	        {
	            return new CValue(holdFValue);
	        }
	
			for (roPtr=ho.getFirstObject(); roPtr!=null; roPtr=ho.getNextObject())
			{
				if (roPtr.ros!=null)
				{
	            	oilPtr = roPtr.hoOiList;
	
	            	if (CServices.compareStringsIgnoreCase(objName, oilPtr.oilName))
	            	{
	                	FValue = (roPtr.hoCreationId << 16) + (roPtr.hoNumber&0xFFFF);
	                	return new CValue(FValue);
	             	}
				}	
	        }
	        return new CValue(0);
	    }
	
	    public function expGetTopFV():CValue
	    {
	        var nLayer:int = wCurrentLayer;
	
	        var roPtr:CObject;
			var oMaxi:CObject=null;
			var iMaxi:int=-1;
			var i:int;
			for (roPtr=ho.getFirstObject(); roPtr!=null; roPtr=ho.getNextObject())
			{
				if (roPtr.ros!=null && roPtr.hoLayer==nLayer)
				{
					i=roPtr.getChildIndex();
					if (i>iMaxi)
					{
						iMaxi=i;
						oMaxi=roPtr;
					}		
				}
			}	
			if (oMaxi!=null)
			{
                return new CValue((oMaxi.hoCreationId << 16) + (oMaxi.hoNumber&0xFFFF));
			}			
			return new CValue(0);
	    }
	
	    public function expGetBottomFV():CValue
	    {
	        var nLayer:int = wCurrentLayer;
	
	        var roPtr:CObject;
			var oMini:CObject=null;
			var iMini:int=1000000;
			var i:int;
			for (roPtr=ho.getFirstObject(); roPtr!=null; roPtr=ho.getNextObject())
			{
				if (roPtr.ros!=null && roPtr.hoLayer==nLayer)
				{
					i=roPtr.getChildIndex();
					if (i<iMini)
					{
						iMini=i;
						oMini=roPtr;
					}		
				}
			}	
			if (oMini!=null)
			{
                return new CValue((oMini.hoCreationId << 16) + (oMini.hoNumber&0xFFFF));
			}			
			return new CValue(0);
	    }
	
	    public function expGetDesc():CValue
	    {
	        var lvlN:int = ho.getExpParam().getInt();
	        var ps:String = lyrGetList(lvlN, 1);
	        var ret:CValue=new CValue(0);
	        ret.forceString(ps);
	        return ret;
	    }
	
	    public function expGetDesc10():CValue
	    {
	        var lvlN:int = ho.getExpParam().getInt();
	        var ps:String = lyrGetList(lvlN, 10);
	        var ret:CValue=new CValue(0);
	        ret.forceString(ps);
	        return ret;
	    }
	
	    public function expGetNumLevels():CValue
	    {
	        var nLayer:int = wCurrentLayer;	
			if (nLayer>=0 || nLayer<ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var layer:CLayer=ho.hoAdRunHeader.rhFrame.layers[nLayer];
				return new CValue(layer.planeSprites.numChildren);
			}
	        return new CValue(0);
	    }
	
	    public function expGetLevel():CValue
	    {
	        var roPtr:CObject;
	        var FindFixed:int = ho.getExpParam().getInt();	
	        if (FindFixed == 0)
	        {
	            FindFixed = holdFValue;
	        }	
			roPtr=lyrGetSprite(FindFixed);
			if (roPtr!=null)
			{
				return new CValue(roPtr.getChildIndex());
			}
			return new CValue(0);
	    }
	
	    public function expGetLevelFV():CValue
	    {
	        var nLayer:int = wCurrentLayer;
	
	        var roPtr:CObject;
	        var FValue:int = 0;
	        var FindLevel:int = ho.getExpParam().getInt();
	
			for (roPtr=ho.getFirstObject(); roPtr!=null; roPtr=ho.getNextObject())
			{
				if (roPtr.ros!=null && roPtr.hoLayer==nLayer)
				{
					var i:int=roPtr.getChildIndex();
					if (i==FindLevel)
					{
                        FValue = (roPtr.hoCreationId << 16) + (roPtr.hoNumber&0xFFFF);
                        break;
					}
				}
			}
			return new CValue(FValue);
	    }
	
	    public function expGetLayerX():CValue
	    {
	        var nLayer:int = ho.getExpParam().getInt();
	
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            return new CValue(-(pLayer.x + pLayer.dx));
	        }
	        return new CValue(0);
	    }
	
	    public function expGetLayerY():CValue
	    {
	        var nLayer:int = ho.getExpParam().getInt();
	
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            return new CValue(-(pLayer.y + pLayer.dy));
	        }
	        return new CValue(0);
	    }
	
	    public function expGetLayerXByName():CValue
	    {
	        var pName:String = ho.getExpParam().getString();
	
	        var nLayer:int = FindLayerByName(pName);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            return new CValue(-(pLayer.x + pLayer.dx));
	        }
	        return new CValue(0);
	    }
	
	    public function expGetLayerYByName():CValue
	    {
	        var pName:String = ho.getExpParam().getString();
	
	        var nLayer:int = FindLayerByName(pName);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            return new CValue(-(pLayer.y + pLayer.dy));
	        }
	        return new CValue(0);
	    }
	
	    public function expGetLayerCount():CValue
	    {
	        return new CValue(ho.hoAdRunHeader.rhFrame.nLayers);
	    }
	
	    public function expGetLayerName():CValue
	    {
	        var nLayer:int = ho.getExpParam().getInt();
			var ret:CValue=new CValue(0);
			ret.forceString("");
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            ret.forceString(pLayer.pName);
	        }
	        return ret;
	    }
	
	    public function expGetLayerIndex():CValue
	    {
	        var pName:String = ho.getExpParam().getString();
	        var ret:CValue=new CValue(FindLayerByName(pName));
	        return ret;
	    }
	
	    public function expGetCurrentLayer():CValue
	    {
	        return new CValue(wCurrentLayer + 1);
	    }
	
	    public function expGetLayerCoefX():CValue
	    {
	        var nLayer:int = ho.getExpParam().getInt();
			var ret:CValue=new CValue(0);
			ret.forceDouble(0.0);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            ret.forceDouble(pLayer.xCoef);
	        }
	        return ret;
	    }
	
	    public function expGetLayerCoefY():CValue
	    {
	        var nLayer:int = ho.getExpParam().getInt();
			var ret:CValue=new CValue(0);
			ret.forceDouble(0.0);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            ret.forceDouble(pLayer.yCoef);
	        }
	        return ret;
	    }
	
	    public function expGetLayerCoefXByName():CValue
	    {
	        var pName:String = ho.getExpParam().getString();
	
	        var nLayer:int = FindLayerByName(pName);
			var ret:CValue=new CValue(0);
			ret.forceDouble(0.0);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            ret.forceDouble(pLayer.xCoef);
	        }
	        return ret;
	    }
	
	    public function expGetLayerCoefYByName():CValue
	    {
	        var pName:String = ho.getExpParam().getString();
	
	        var nLayer:int = FindLayerByName(pName);
			var ret:CValue=new CValue(0);
			ret.forceDouble(0.0);
	        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
	        {
	            var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
	            ret.forceDouble(pLayer.yCoef);
	        }
	        return ret;
	    }

		public function expGetLayerEffectParam():CValue
		{
			ho.getExpParam();
			return new CValue(0);
		}
		public function expGetLayerEffectParamByName():CValue
		{
			ho.getExpParam();
			return new CValue(0);
		}
		public function getAlpha(layer:CLayer):int
		{
			var effect:int = layer.effect;
			var effectParam:int = layer.effectParam;
			var alpha:int = 0;
			var rgbaCoeff:int = effectParam;
			
			if ((effect & CRSpr.BOP_MASK) == CRSpr.BOP_EFFECTEX || (effect & CRSpr.BOP_RGBAFILTER) != 0)
			{
				alpha = 255 - ((rgbaCoeff >> 24)&0xFF);
			}
			else
			{
				if (effectParam == -1)
					alpha = 0;
				else
					alpha = effectParam * 2;
			}
			return alpha;
		}
		public function expGetLayerAlpha():CValue
		{
			var nLayer:int = ho.getExpParam().getInt();
			var ret:CValue=new CValue(0);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				ret.forceInt(getAlpha(pLayer));
			}
			return ret;
		}
		public function expGetLayerAlphaByName():CValue
		{
			var pName:String = ho.getExpParam().getString();
			
			var nLayer:int = FindLayerByName(pName);
			var ret:CValue=new CValue(0);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				ret.forceInt(getAlpha(pLayer));
			}
			return ret;
		}
		public function getRGB(layer:CLayer):int
		{
			var effect:int = layer.effect;
			var effectParam:int = layer.effectParam;
			var rgb:int = 0;
			var rgbaCoeff:int = effectParam;
			
			if ((effect & CRSpr.BOP_MASK) == CRSpr.BOP_EFFECTEX || (effect & CRSpr.BOP_RGBAFILTER) != 0)
				rgb = CServices.swapRGB((rgbaCoeff & 0x00FFFFFF));
			else
				rgb = 0x00FFFFFF;
			
			return rgb;
		}
		public function expGetLayerRGB():CValue
		{
			var nLayer:int = ho.getExpParam().getInt();
			var ret:CValue=new CValue(0);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				ret.forceInt(getRGB(pLayer));
			}
			return ret;
		}
		public function expGetLayerRGBByName():CValue
		{
			var pName:String = ho.getExpParam().getString();
			
			var nLayer:int = FindLayerByName(pName);
			var ret:CValue=new CValue(0);
			if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
			{
				var pLayer:CLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
				ret.forceInt(getRGB(pLayer));
			}
			return ret;
		}
		
	    // SORT ROUTINES
	    // --------------------------------------------------------
	    // Exchange 2 sprites in the linked list
	    public function lyrSwapSpr(sp1:CObject, sp2:CObject):void
	    {
	        // Security
	        if (sp1 == sp2)
	        {
	            return;
	        }
	
	        // Cannot swap sprites from different layers
	        if (sp1.hoLayer != sp2.hoLayer)
	        {
	            return;
	        }
	
			var i1:int=sp1.getChildIndex();
			var i2:int=sp2.getChildIndex();
			if (i1>=0 && i2>=0)
			{
				sp1.setChildIndex(i2);
				sp2.setChildIndex(i1);
	        }
	    }
	
	    public function lyrSwapThem(sprPtr1:CObject, sprPtr2:CObject, bRedraw:Boolean):Boolean
	    {
	        // Exchange sprites
	        lyrSwapSpr(sprPtr1, sprPtr2);	
	        return true;
	    }
	
	    public function lyrGetSprite(fixedValue:int):CObject
	    {
	        var roPtr:CObject;
	
	        if (fixedValue == 0)
	        {
	            fixedValue = holdFValue;
	        }
	
	        var fValue:int;
	        for (roPtr=ho.getFirstObject(); roPtr!=null; roPtr=ho.getNextObject())
	        {
	            fValue = (roPtr.hoCreationId << 16) + roPtr.hoNumber;
	            if (roPtr.ros!=null && fixedValue == fValue)
	            {
	                return roPtr;
	            }
	        }
	        return null;
	    }
	
	    public function lyrGetROfromFV(fixedValue:int):CObject
	    {
	    	return lyrGetSprite(fixedValue);
	    }
	
	    public function lyrSortBy(flag:int, altDefaultVal:int, altValue:int):Boolean
	    {
	    	// Cree la liste des sprites
	        var nLayer:int = wCurrentLayer;
	        var spriteList:CArrayList = new CArrayList();
	        var tmp:CRunLayerSortData;
	        var pSprite:CObject;
	        for (pSprite=ho.getFirstObject(); pSprite!=null; pSprite=ho.getNextObject())
	        {
	        	if (pSprite.ros!=null)
	        	{
		        	if (pSprite.hoLayer==nLayer)
		        	{	        		
		            	tmp = new CRunLayerSortData();
		            	if (pSprite.getChildIndex()>=0)
		            	{
		            		tmp.object=pSprite;
			            	tmp.cmpFlag = flag;	
			                tmp.sprX = pSprite.hoX;
		                	tmp.sprY = pSprite.hoY;	
							tmp.sprAlt = altDefaultVal;
			                if (pSprite.rov != null)
			                {
			                	if (pSprite.rov.rvValues!=null)
			                	{
			                		if (pSprite.rov.rvValues[altValue]!=null)
			                		{
					                    if (pSprite.rov.rvValues[altValue].type == CValue.TYPE_INT)
					                    {
					                        tmp.sprAlt = pSprite.rov.rvValues[altValue].intValue;
					                    }
					                    else
					                    {
					                        tmp.sprAlt = int(pSprite.rov.rvValues[altValue].doubleValue);
					                    }
			                		}
			                	}
			                }
			            	spriteList.add(tmp);
			            }
		            }
		        }
	        }
	
	        // TRI (a bulle en attendant mieux)
	        var count:int = 0;
	        var n:int;
	        do
	        {
	            count = 0;
	            for (n = 0; n < spriteList.size() - 1; n++)
	            {
	                if (isGreater(CRunLayerSortData(spriteList.get(n)), CRunLayerSortData(spriteList.get(n + 1))))
	                {
	                    tmp = CRunLayerSortData(spriteList.get(n + 1));
	                    spriteList.set(n + 1, CRunLayerSortData(spriteList.get(n)));
	                    spriteList.set(n, tmp);
	                    count++;
	                }
	            }
	        } while (count != 0);
	
			// Rearrange the sprites
			for (count=0; count<spriteList.size(); count++)
			{
				tmp=CRunLayerSortData(spriteList.get(count));
				pSprite=tmp.object;
				pSprite.setChildIndex(1000000);
			}
	        return false;
	    }
	
	    public function isGreater(item1:CRunLayerSortData, item2:CRunLayerSortData):Boolean
	    {
	        // MMF2
	        var p1:CObject = item1.object;
	        var p2:CObject = item2.object;
	        if (p1.hoLayer != p2.hoLayer)
	        {
	            return (p1.hoLayer < p2.hoLayer);
	        }
	        switch (item1.cmpFlag)
	        {
	            case 0:     // X_UP
	                return item1.sprX < item2.sprX;
	            case 1:     // X_DOWN
	                return item1.sprX > item2.sprX;
	            case 2:     // Y_UP:
	                return item1.sprY < item2.sprY;
	            case 3:     // Y_DOWN:
	                return item1.sprY > item2.sprY;
	            case 4:     // ALT_UP:
	                return item1.sprAlt < item2.sprAlt;
	            case 5:     // ALT_DOWN:
	                return item1.sprAlt > item2.sprAlt;
	        }
	        return false;
	    }
	
	    public function lyrGetList(lvlStart:int, iteration:int):String
	    {
	        var szList:String = new String("Lvl\tName\tFV\n\n");
	        var szReturn:int;
	        var nLayer:int = wCurrentLayer;
	
	        var hoPtr:CObject;
	        var oilPtr:CObjInfo;
	
	        var fValue:int = 0;
	        var lvlCount:int = 0;

			for (hoPtr=ho.getFirstObject(); hoPtr!=null; hoPtr=ho.getNextObject())
			{
				if (hoPtr.ros!=null && hoPtr.hoLayer==nLayer)
				{
		            while (hoPtr!= null && hoPtr.ros!=null && (ho.hoLayer==nLayer) && (++lvlCount < (lvlStart + iteration)))
	            	{
	                	if (lvlCount >= lvlStart)
	                	{
	                        oilPtr = hoPtr.hoOiList;
	                        fValue = (hoPtr.hoCreationId << 16) + (hoPtr.hoNumber&0xFFFF);
	                        var buffer:String = new String(lvlCount.toString());
	                        buffer+="\t";
	                        buffer+=oilPtr.oilName;
	                        buffer+="\t";
	                        buffer+=fValue.toString();
	                        buffer+="\n";
	                        szList+=buffer;
	                    }
	                    else
	                    {
	                        lvlCount--;
	                    }
	                }
	                hoPtr=ho.getNextObject();
	            }
	            break;
	        }
	        return szList;
	    }
	
	    public function lyrGetFVfromEVP(evp:PARAM_OBJECT):int
	    {
	        var oilPtr:CObjInfo=ho.hoAdRunHeader.rhOiList[evp.oiList];
	
	        var hoPtr:CObject;
	        if (oilPtr.oilCurrentOi != -1)
	        {
	            hoPtr = ho.hoAdRunHeader.rhObjectList[oilPtr.oilCurrentOi];
	        }
	        else
	        {
	            if (oilPtr.oilObject >= 0)
	            {
	                hoPtr = ho.hoAdRunHeader.rhObjectList[oilPtr.oilObject];
	            }
	            else
	            {
	                return 0;
	            }
	        }
	        return (hoPtr.hoCreationId << 16) + (hoPtr.hoNumber&0xFFFF);
	    }
	
	    public function lyrGetROfromEVP(evp:PARAM_OBJECT):CObject
	    {
	        var oilPtr:CObjInfo = ho.hoAdRunHeader.rhOiList[evp.oiList];
	
	        if (oilPtr.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	        {
	            return ho.hoAdRunHeader.rhObjectList[oilPtr.oilListSelected];
	        }
	        else
	        {
	            if (oilPtr.oilObject >= 0)
	            {
	                return ho.hoAdRunHeader.rhObjectList[oilPtr.oilObject];
	            }
	            else
	            {
	                return null;
	            }
	        }
	    }
	
	    public function lyrGetOILfromEVP(evp:PARAM_OBJECT):CObjInfo
	    {
	        if (evp.oiList < 0)
	        {
	            return null;
	        }
	        return ho.hoAdRunHeader.rhOiList[evp.oiList];
	    }
	
	    public function lyrGetFVfromOIL(oilPtr:CObjInfo):int
	    {
	        var hoPtr:CObject;
	
	        if (oilPtr.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	        {
	            hoPtr = ho.hoAdRunHeader.rhObjectList[oilPtr.oilListSelected];
	        }
	        else
	        {
	            if (oilPtr.oilObject >= 0)
	            {
	                hoPtr = ho.hoAdRunHeader.rhObjectList[oilPtr.oilObject];
	            }
	            else
	            {
	                return 0;
	            }
	        }
	        return (hoPtr.hoCreationId << 16) + (hoPtr.hoNumber&0xFFFF);
	    }
	
	    public function lyrResetEventList(oilPtr:CObjInfo):void
	    {
	        if (oilPtr.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	        {
	            oilPtr.oilEventCount = -1;
	        }
	        return;
	    }
	
	    public function lyrProcessCondition(param1:PARAM_OBJECT, param2:PARAM_OBJECT, cond:int):Boolean
	    {
	        var lReturn:Boolean;
	
	        var oilPtr1:CObjInfo = lyrGetOILfromEVP(param1);
	        if (oilPtr1 == null)
	        {
	            return false;
	        }
	        var roPtr1:CObject;
	        if ((roPtr1 = lyrGetROfromEVP(param1)) == null)
	        {
	            return false;
	        }
	
	        var oilPtr2:CObjInfo = null;
	        var roPtr2:CObject = null;	
	        if (param2 != null)
	        {
	            oilPtr2 = lyrGetOILfromEVP(param2);
	            if ((roPtr2 = lyrGetROfromEVP(param2)) == null)
	            {
	                return false;
	            }
	        }
	
	        //We only build a list for the primary parameter (param1)
	        //Save the first object
	        //Save the number selected
	        var RootObj:int = -1;
	        var NumCount:int = 0;
	        var bMatch:Boolean;
	
	        var FValue1:int = -1;
	        var FValue2:int = -1;
	
	        var bPassed:Boolean = false;
	
	        var roTempPtr:CObject;
	        var roTempNumber:int = 0;
	        var i:int, j:int;
	        var Loop2:int;
            var DoLevel2:Boolean;
	        if (oilPtr1.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	        {
	            if (param2 != null)
	            {
	                FValue1 = lyrGetFVfromOIL(lyrGetOILfromEVP(param1));
	                for (i = 1; i <= oilPtr1.oilNumOfSelected; i++)
	                {
	                    bMatch = false;
	
	                    FValue2 = lyrGetFVfromOIL(lyrGetOILfromEVP(param2));
		
	                    if (oilPtr2.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	                    {
	                        Loop2 = oilPtr2.oilNumOfSelected;
	                        DoLevel2 = true;
	                    }
	                    else
	                    {
	                        Loop2 = oilPtr2.oilNObjects;
	                        DoLevel2 = false;
	                    }
	
	                    for (j = 1; j <= Loop2; j++)
	                    {
	                        lReturn = doCondition(cond, FValue1, FValue2);
	                        if (lReturn)
	                        {
	                            bMatch = true;
	                        }
	
	                        if (DoLevel2)
	                        {
	                            if (roPtr2.hoNextSelected > -1)
	                            {
	                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNextSelected];
	                                FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                            }
	                        }
	                        else
	                        {
	                            if (roPtr2.hoNumNext > -1)
	                            {
	                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNumNext];
	                                FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                            }
	                        }
	                    }
	
	                    if (bMatch)
	                    {
	                        bPassed = true;
	                        NumCount++;
	
	                        if (RootObj == -1)
	                        {
	                            RootObj = roPtr1.hoNumber;
	                        }
	                        else
	                        {
	                            roTempPtr = ho.hoAdRunHeader.rhObjectList[roTempNumber];
	                            roTempPtr.hoNextSelected = roPtr1.hoNumber;
	                        }
	                        roTempNumber = roPtr1.hoNumber;
	                    }
	
	                    if (roPtr1.hoNextSelected > -1)
	                    {
	                        roPtr1 = ho.hoAdRunHeader.rhObjectList[roPtr1.hoNextSelected];
	                        FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	                    }
	                }
	            }
	            else
	            {
	                FValue1 = lyrGetFVfromOIL(lyrGetOILfromEVP(param1));
	                for (i = 1; i <= oilPtr1.oilNumOfSelected; i++)
	                {
	                    bMatch = false;
	
	                    lReturn = doCondition(cond, FValue1, FValue2);
	                    if (lReturn)
	                    {
	                        bPassed = true;
	                        NumCount++;
	                        if (RootObj == -1)
	                        {
	                            RootObj = roPtr1.hoNumber;
	                        }
	                        else
	                        {
	                            roTempPtr = ho.hoAdRunHeader.rhObjectList[roTempNumber];
	                            roTempPtr.hoNextSelected = roPtr1.hoNumber;
	                        }
	
	                        roTempNumber = roPtr1.hoNumber;
	                    }
	
	                    if (roPtr1.hoNextSelected > -1)
	                    {
	                        roPtr1 = ho.hoAdRunHeader.rhObjectList[roPtr1.hoNextSelected];
	                        FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	                    }
	                }
	            }
	        }
	        else
	        {
	            if (param2 != null)
	            {
	                FValue1 = lyrGetFVfromOIL(lyrGetOILfromEVP(param1));
	                for (i = 1; i <= oilPtr1.oilNObjects; i++)
	                {
	                    bMatch = false;
	
	                    FValue2 = lyrGetFVfromOIL(lyrGetOILfromEVP(param2));
	
	                    if (oilPtr2.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
	                    {
	                        Loop2 = oilPtr2.oilNumOfSelected;
	                        DoLevel2 = true;
	                    }
	                    else
	                    {
	                        Loop2 = oilPtr2.oilNObjects;
	                        DoLevel2 = false;
	                    }
	
	                    for (j = 1; j <= Loop2; j++)
	                    {
	                        lReturn = doCondition(cond, FValue1, FValue2);
	                        if (lReturn)
	                        {
	                            bMatch = true;
	                        }
	
	                        if (DoLevel2)
	                        {
	                            if (roPtr2.hoNextSelected > -1)
	                            {
	                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNextSelected];
	                                FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                            }
	                        }
	                        else
	                        {
	                            if (roPtr2.hoNumNext > -1)
	                            {
	                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNumNext];
	                                FValue2 = (roPtr2.hoCreationId << 16) + (roPtr2.hoNumber&0xFFFF);
	                            }
	                        }
	                    }
	
	                    if (bMatch)
	                    {
	                        bPassed = true;
	                        NumCount++;
	                        if (RootObj == -1)
	                        {
	                            RootObj = roPtr1.hoNumber;
	                        }
	                        else
	                        {
	                            roTempPtr = ho.hoAdRunHeader.rhObjectList[roTempNumber];
	                            roTempPtr.hoNextSelected = roPtr1.hoNumber;
	                        }
	                        roTempNumber = roPtr1.hoNumber;
	                    }
	
	                    if (roPtr1.hoNumNext > -1)
	                    {
	                        roPtr1 = ho.hoAdRunHeader.rhObjectList[roPtr1.hoNumNext];
	                        FValue1 = (roPtr1.hoCreationId << 16) + roPtr1.hoNumber;
	                    }
	                }
	            }
	            else
	            {
	                FValue1 = lyrGetFVfromOIL(lyrGetOILfromEVP(param1));
	                for (i = 1; i <= oilPtr1.oilNObjects; i++)
	                {
	                    bMatch = false;
	
	                    lReturn = doCondition(cond, FValue1, FValue2);
	                    if (lReturn)
	                    {
	                        bPassed = true;
	                        NumCount++;
	                        if (RootObj == -1)
	                        {
	                            RootObj = roPtr1.hoNumber;
	                        }
	                        else
	                        {
	                            roTempPtr = ho.hoAdRunHeader.rhObjectList[roTempNumber];
	                            roTempPtr.hoNextSelected = roPtr1.hoNumber;
	                        }
	                        roTempNumber = roPtr1.hoNumber;
	                    }
	
	                    if (roPtr1.hoNumNext > -1)
	                    {
	                        roPtr1 = ho.hoAdRunHeader.rhObjectList[roPtr1.hoNumNext];
	                        FValue1 = (roPtr1.hoCreationId << 16) + (roPtr1.hoNumber&0xFFFF);
	                    }
	                }
	            }
	        }
	
	        oilPtr1.oilListSelected = RootObj;
	        oilPtr1.oilNumOfSelected = NumCount;
	
	        if (bPassed)
	        {
	            oilPtr1.oilEventCount = ho.hoAdRunHeader.rhEvtProg.rh2EventCount;
	            roTempPtr = ho.hoAdRunHeader.rhObjectList[roTempNumber];
	            roTempPtr.hoNextSelected = -1;
	        }
	        return bPassed;
	    }
	
	    public function doCondition(cond:int, param1:int, param2:int):Boolean
	    {
	        switch (cond)
	        {
	            case 0:
	                return cndAtBackRout(param1);
	            case 1:
	                return cndAtFrontRout(param1);
	            case 2:
	                return cndAboveRout(param1, param2);
	            case 3:
	                return cndBelowRout(param1, param2);
	        }
	        return false;
	    }
	    
  	}
}