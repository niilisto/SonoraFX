/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
//----------------------------------------------------------------------------------
//
// CRUNLAYER : Objet layer
//
//----------------------------------------------------------------------------------
package Extensions;

import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Frame.CLayer;
import Objects.CObject;
import Params.PARAM_OBJECT;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import RunLoop.CRun;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;
import Sprites.CSprite;
import Sprites.CSpriteGen;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;

public class CRunLayer extends CRunExtension
{
    static final int X_UP = 0;
    static final int X_DOWN = 1;
    static final int Y_UP = 2;
    static final int Y_DOWN = 3;
    static final int ALT_UP = 4;
    static final int ALT_DOWN = 5;
    int holdFValue;
    int wCurrentLayer;

    CValue expRet;
    
    public CRunLayer()
    {
    	expRet = new CValue(0);
    }

    @Override
	public int getNumberOfConditions()
    {
        return 12;
    }

    @Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        wCurrentLayer = ho.hoLayer;
        return false;
    }

    @Override
	public void destroyRunObject(boolean bFast)
    {
    }

    @Override
	public int handleRunObject()
    {
        return REFLAG_ONESHOT;
    }

    public void displayRunObject(Canvas c, Paint p)
    {
    }

    @Override
	public void pauseRunObject()
    {
    }

    @Override
	public void continueRunObject()
    {
    }


    public void saveBackground(Bitmap img)
    {
    }

    public void restoreBackground(Canvas c, Paint p)
    {
    }

    public void killBackground()
    {
    }

    @Override
	public CFontInfo getRunObjectFont()
    {
        return null;
    }

    @Override
	public void setRunObjectFont(CFontInfo fi, CRect rc)
    {
    }

    @Override
	public int getRunObjectTextColor()
    {
        return 0;
    }

    @Override
	public void setRunObjectTextColor(int rgb)
    {
    }

    @Override
	public CMask getRunObjectCollisionMask(int flags)
    {
        return null;
    }

    public Bitmap getRunObjectSurface()
    {
        return null;
    }

    @Override
	public void getZoneInfos()
    {
    }

    // Conditions
    // --------------------------------------------------
    @Override
	public boolean condition(int num, CCndExtension cnd)
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

    boolean cndAtBack(CCndExtension cnd)
    {
        int param1 = cnd.getParamExpression(rh, 0);
        return cndAtBackRout(param1);
    }

    boolean cndAtBackRout(int param1)
    {
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;

        CSprite sprPtr = objAddr.firstSprite;
        while (sprPtr != null && (sprPtr.sprFlags & CSprite.SF_TOKILL) != 0 && sprPtr.sprLayer < nLayer)
        {
            sprPtr = sprPtr.objNext;
        }

        if (sprPtr != null && sprPtr.sprLayer == nLayer)
        {
            CObject roPtr = sprPtr.sprExtraInfo;

            int FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);

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

    boolean cndAtFront(CCndExtension cnd)
    {
        int param1 = cnd.getParamExpression(rh, 0);
        return cndAtFrontRout(param1);
    }

    boolean cndAtFrontRout(int param1)
    {
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;

        CSprite sprPtr = objAddr.lastSprite;
        while (sprPtr != null && (sprPtr.sprFlags & CSprite.SF_TOKILL) != 0 && sprPtr.sprLayer > nLayer)
        {
            sprPtr = sprPtr.objPrev;
        }

        if (sprPtr != null && sprPtr.sprLayer == nLayer)
        {
            CObject roPtr = sprPtr.sprExtraInfo;

            int FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);

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

    boolean cndAbove(CCndExtension cnd)
    {
        int param1 = cnd.getParamExpression(rh, 0);
        int param2 = cnd.getParamExpression(rh, 1);
        return cndAboveRout(param1, param2);
    }

    boolean cndAboveRout(int param1, int param2)
    {

        CSprite sprPtr1 = null;
        CSprite sprPtr2 = null;

        int FValue1;
        int FValue2;

        if (param1 == 0)
        {
            param1 = holdFValue;
        }

        if (param2 == 0)
        {
            param2 = holdFValue;
        }
        /*
        CObject roPtr1 = null;
        CObject roPtr2 = null;
        int count1 = 0;
        int o1;
        for (o1 = 0; o1 < ho.hoAdRunHeader.rhNObjects; o1++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count1] == null)
            {
                count1++;
            }
            roPtr1 = ho.hoAdRunHeader.rhObjectList[count1];
            count1++;

            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
            if (param1 == FValue1)
            {
                int count2 = 0;
                int o2;
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (o2 = 0; o2 < ho.hoAdRunHeader.rhNObjects; o2++)
                {
                    while (ho.hoAdRunHeader.rhObjectList[count2] == null)
                    {
                        count2++;
                    }
                    roPtr2 = ho.hoAdRunHeader.rhObjectList[count2];
                    count2++;

                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);

                    if (param2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null))
                {
                    // MMF 2
                    if (sprPtr1.sprLayer != sprPtr2.sprLayer)			// Different layer?
                    {
                        return (sprPtr1.sprLayer > sprPtr2.sprLayer);
                    }

                    if (sprPtr1.sprZOrder > sprPtr2.sprZOrder)
                    {
                        return true;
                    }
                }
                break;
            }
        }
        */
        for(CObject roPtr1 : ho.hoAdRunHeader.rhObjectList)
        {
        	if(roPtr1 == null)
        		continue;
            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
            if (param1 == FValue1)
            {
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (CObject roPtr2 : ho.hoAdRunHeader.rhObjectList)
                {
                	if(roPtr2 == null)
                		continue;
                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
                    
                    if(FValue1 == FValue2)
                    	continue;
                    
                    if (param2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null))
                {
                    // MMF 2
                    if (sprPtr1.sprLayer != sprPtr2.sprLayer)			// Different layer?
                    {
                        return (sprPtr1.sprLayer > sprPtr2.sprLayer);
                    }

                    if (sprPtr1.sprZOrder > sprPtr2.sprZOrder)
                    {
                        return true;
                    }
                }
                break;
            }
        }
		
        return false;
    }

    boolean cndBelow(CCndExtension cnd)
    {
        int param1 = cnd.getParamExpression(rh, 0);
        int param2 = cnd.getParamExpression(rh, 1);
        return cndBelowRout(param1, param2);
    }

    boolean cndBelowRout(int param1, int param2)
    {
        //CObject roPtr1 = null;
        //CObject roPtr2 = null;

        CSprite sprPtr1 = null;
        CSprite sprPtr2 = null;

        int FValue1;
        int FValue2;

        if (param1 == 0)
        {
            param1 = holdFValue;
        }

        if (param2 == 0)
        {
            param2 = holdFValue;
        }
        /*
        int count1 = 0;
        int o1;
        for (o1 = 0; o1 < ho.hoAdRunHeader.rhNObjects; o1++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count1] == null)
            {
                count1++;
            }
            roPtr1 = ho.hoAdRunHeader.rhObjectList[count1];
            count1++;

            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
            if (param1 == FValue1)
            {
                int count2 = 0;
                int o2;
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (o2 = 0; o2 < ho.hoAdRunHeader.rhNObjects; o2++)
                {
                    while (ho.hoAdRunHeader.rhObjectList[count2] == null)
                    {
                        count2++;
                    }
                    roPtr2 = ho.hoAdRunHeader.rhObjectList[count2];
                    count2++;

                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);

                    if (param2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null))
                {
                    // MMF 2
                    if (sprPtr1.sprLayer != sprPtr2.sprLayer)			// Different layer?
                    {
                        return (sprPtr1.sprLayer < sprPtr2.sprLayer);
                    }

                    if (sprPtr1.sprZOrder < sprPtr2.sprZOrder)
                    {
                        return true;
                    }
                }
                break;
            }
        }
        */
        for(CObject roPtr1 : ho.hoAdRunHeader.rhObjectList)
        {
        	if(roPtr1 == null)
        		continue;
            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
            if (param1 == FValue1)
            {
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (CObject roPtr2 : ho.hoAdRunHeader.rhObjectList)
                {
                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
                    
                    if(FValue1 == FValue2)
                    	continue;
                    
                    if (param2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null))
                {
                    // MMF 2
                    if (sprPtr1.sprLayer != sprPtr2.sprLayer)			// Different layer?
                    {
                        return (sprPtr1.sprLayer < sprPtr2.sprLayer);
                    }

                    if (sprPtr1.sprZOrder < sprPtr2.sprZOrder)
                    {
                        return true;
                    }
                }
                break;
            }
        }
        return false;
    }

    boolean cndBetween(CCndExtension cnd)
    {
        int p1 = cnd.getParamExpression(rh, 0);
        int p2 = cnd.getParamExpression(rh, 1);
        int p3 = cnd.getParamExpression(rh, 2);

        //CObject roPtr1 = null;
        //CObject roPtr2 = null;

        CSprite sprPtr1 = null;
        CSprite sprPtr2 = null;
        CSprite sprPtr3 = null;

        int FValue1;
        int FValue2;

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


        boolean bFound2 = false;
        boolean bFound3 = false;
        /*
        int count1 = 0;
        int o1;
        for (o1 = 0; o1 < ho.hoAdRunHeader.rhNObjects; o1++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count1] == null)
            {
                count1++;
            }
            roPtr1 = ho.hoAdRunHeader.rhObjectList[count1];
            count1++;

            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);

            if (p1 == FValue1)
            {
                int count2 = 0;
                int o2;
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (o2 = 0; o2 < ho.hoAdRunHeader.rhNObjects; o2++)
                {
                    while (ho.hoAdRunHeader.rhObjectList[count2] == null)
                    {
                        count2++;
                    }
                    roPtr2 = ho.hoAdRunHeader.rhObjectList[count2];
                    count2++;

                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);

                    if (p2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        bFound2 = true;
                    }

                    if (p3 == FValue2)
                    {
                        sprPtr3 = roPtr2.roc.rcSprite;
                        bFound3 = true;
                    }

                    if (bFound2 && bFound3)
                    {
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null) && (sprPtr3 != null))
                {
                    // MMF2
                    int n1, n2, n3;
                    n1 = n2 = n3 = -1;

                    CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;
                    int i = 0;
                    CSprite pSpr = objAddr.firstSprite;
                    while (pSpr != null)
                    {
                        if (pSpr == sprPtr1)
                        {
                            n1 = i;
                            if (n2 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr2)
                        {
                            n2 = i;
                            if (n1 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr3)
                        {
                            n3 = i;
                            if (n1 != -1 && n2 != -1)
                            {
                                break;
                            }
                        }
                        pSpr = pSpr.objNext;
                        i++;
                    }
                    if ((n3 > n1 && n1 > n2) || (n2 > n1 && n1 > n3))
                    {
                        return true;
                    }
                }
                break;
            }
        }
        */
        for(CObject roPtr1 : ho.hoAdRunHeader.rhObjectList)
        {
        	if(roPtr1 == null)
        		continue;
            FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
            if (p1 == FValue1)
            {
                sprPtr1 = roPtr1.roc.rcSprite;

                //We have a match, get the second object
                for (CObject roPtr2 : ho.hoAdRunHeader.rhObjectList)
                {
                    FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);

                   if (p2 == FValue2)
                    {
                        sprPtr2 = roPtr2.roc.rcSprite;
                        bFound2 = true;
                    }

                    if (p3 == FValue2)
                    {
                        sprPtr3 = roPtr2.roc.rcSprite;
                        bFound3 = true;
                    }

                    if (bFound2 && bFound3)
                    {
                        break;
                    }
                }

                if ((sprPtr1 != null) && (sprPtr2 != null) && (sprPtr3 != null))
                {
                    // MMF2
                    int n1, n2, n3;
                    n1 = n2 = n3 = -1;

                    CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;
                    /*
                    int i = 0;
                    /*
                    CSprite pSpr = objAddr.firstSprite;
                    while (pSpr != null)
                    {
                        if (pSpr == sprPtr1)
                        {
                            n1 = i;
                            if (n2 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr2)
                        {
                            n2 = i;
                            if (n1 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr3)
                        {
                            n3 = i;
                            if (n1 != -1 && n2 != -1)
                            {
                                break;
                            }
                        }
                        pSpr = pSpr.objNext;
                        i++;
                    }
                    */
                    CSprite pSpr;
                    int i;
                    for(pSpr = objAddr.firstSprite, i = 0; pSpr != null; pSpr = pSpr.objNext)
                    {
                        if (pSpr == sprPtr1)
                        {
                            n1 = i;
                            if (n2 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr2)
                        {
                            n2 = i;
                            if (n1 != -1 && n3 != -1)
                            {
                                break;
                            }
                        }
                        else if (pSpr == sprPtr3)
                        {
                            n3 = i;
                            if (n1 != -1 && n2 != -1)
                            {
                                break;
                            }
                        }
                        i++;
                    }
                    if ((n3 > n1 && n1 > n2) || (n2 > n1 && n1 > n3))
                    {
                        return true;
                    }
                }
                break;
            }
        }
        return false;
    }

    boolean cndAtBackObj(CCndExtension cnd)
    {
        PARAM_OBJECT param1 = cnd.getParamObject(rh, 0);
        return lyrProcessCondition(param1, null, 0);
    }

    boolean cndAtFrontObj(CCndExtension cnd)
    {
        PARAM_OBJECT param1 = cnd.getParamObject(rh, 0);
        return lyrProcessCondition(param1, null, 1);
    }

    boolean cndAboveObj(CCndExtension cnd)
    {
        PARAM_OBJECT param1 = cnd.getParamObject(rh, 0);
        PARAM_OBJECT param2 = cnd.getParamObject(rh, 1);
        return lyrProcessCondition(param1, param2, 2);
    }

    boolean cndBelowObj(CCndExtension cnd)
    {
        PARAM_OBJECT param1 = cnd.getParamObject(rh, 0);
        PARAM_OBJECT param2 = cnd.getParamObject(rh, 1);
        return lyrProcessCondition(param1, param2, 3);
    }

    boolean cndBetweenObj(CCndExtension cnd)
    {
        PARAM_OBJECT ObjectA = cnd.getParamObject(rh, 0);
        PARAM_OBJECT ObjectB = cnd.getParamObject(rh, 1);
        PARAM_OBJECT ObjectC = cnd.getParamObject(rh, 2);

        boolean IsBetween = false;

        // Is Object A between Object B and Object C?
        if (lyrProcessCondition(ObjectA, ObjectB, 2))
        {
            if (lyrProcessCondition(ObjectA, ObjectC, 3))
            {
                IsBetween = true;
            }
        }

        if (!IsBetween)
        {
            lyrResetEventList(lyrGetOILfromEVP(ObjectA));
            if (lyrProcessCondition(ObjectA, ObjectB, 3))
            {
                if (lyrProcessCondition(ObjectA, ObjectC, 2))
                {
                    IsBetween = true;
                }
            }
        }
        return IsBetween;
    }

    boolean cndIsLayerVisible(CCndExtension cnd)
    {
        int param1 = cnd.getParamExpression(rh, 0);
        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            return (((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) != 0 && (pLayer.dwOptions & CLayer.FLOPT_TOHIDE) == 0) || (pLayer.dwOptions & CLayer.FLOPT_TOSHOW) != 0);
        }
        return false;
    }

    // Returns index of layer (1-based) or 0 if layer not found
    int FindLayerByName(String pName)
    {
        if (pName != null)
        {
            int nLayer;
            for (nLayer = 0; nLayer < ho.hoAdRunHeader.rhFrame.nLayers; nLayer++)
            {
                CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer];
                if (pLayer.pName != null && pName.compareToIgnoreCase(pLayer.pName) == 0)
                {
                    return (nLayer + 1);
                }
            }
        }
        return 0;
    }

    boolean cndIsLayerVisibleByName(CCndExtension cnd)
    {
        String param1 = cnd.getParamExpString(rh, 0);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            return (((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) != 0 && (pLayer.dwOptions & CLayer.FLOPT_TOHIDE) == 0) || (pLayer.dwOptions & CLayer.FLOPT_TOSHOW) != 0);
        }
        return false;
    }

    // Actions
    // -------------------------------------------------
    @Override
	public void action(int num, CActExtension act)
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
            case 44:                // ACT_SETLAYEREFFECT_BYNAME
            case 46:                // ACT_SETLAYEREFFECTPARAM_BYNAME
            case 47:                // ACT_SETLAYERALPHA_BYNAME
            case 48:                // ACT_SETLAYERRGB_BYNAME
            case 50:                // ACT_SETLAYEREFFECTTEXTUREPARAM
            case 51:                // ACT_SETLAYEREFFECTTEXTUREPARAM_BYNAME
                break;
        }
    }

    void actBackOne(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        actBackOneRout(param1);
    }

    void actBackOneRout(int param1)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;
        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            if ((sprPtr2 = sprPtr1.objPrev) != null)
            {
                if (sprPtr1.sprLayer == sprPtr2.sprLayer)
                {
                    lyrSwapThem(sprPtr1, sprPtr2, true);
                }
            }
        }
    }

    void actForwardOne(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        actForwardOneRout(param1);
    }

    void actForwardOneRout(int param1)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            if ((sprPtr2 = sprPtr1.objNext) != null)
            {
                if (sprPtr1.sprLayer == sprPtr2.sprLayer)
                {
                    lyrSwapThem(sprPtr1, sprPtr2, true);
                }
            }
        }
    }

    void actSwap(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actSwapRout(param1, param2);
    }

    void actSwapRout(int param1, int param2)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            if ((sprPtr2 = lyrGetSprite(param2)) != null)
            {
                if (sprPtr1.sprLayer == sprPtr2.sprLayer)
                {
                    lyrSwapThem(sprPtr1, sprPtr2, true);
                }
            }
        }
    }

    void actSetObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        if(roPtr == null)
        	return;
        holdFValue = lyrGetFVfromOIL(roPtr.hoOiList);
    }

    void actBringFront(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        actBringFront(param1);
    }

    void actBringFront(int param1)
    {
        CSpriteGen ObjAddr = ho.hoAdRunHeader.spriteGen;

        if (ObjAddr.lastSprite != null)
        {
            CSprite pSpr = lyrGetSprite(param1);		// (npSpr)roPtr->roc.rcSprite;
            if (pSpr != null)
            {
                // Exchange the sprite with the next one until the end of the list
                while (pSpr != ObjAddr.lastSprite)
                {
                    CSprite pSprNext = pSpr.objNext;
                    if (pSprNext == null)
                    {
                        break;
                    }

                    if (pSpr.sprLayer != pSprNext.sprLayer)
                    {
                        break;
                    }

                    lyrSwapSpr(pSpr, pSprNext);
                }

                // Force redraw
                if ((pSpr.sprFlags & CSprite.SF_HIDDEN) == 0)
                {
                    ObjAddr.activeSprite(pSpr, CSpriteGen.AS_REDRAW, null);
                }
            }
        }
    }

    void actSendBack(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        actSendBackRout(param1);
    }

    void actSendBackRout(int param1)
    {
        CSpriteGen ObjAddr = ho.hoAdRunHeader.spriteGen;

        if (ObjAddr.firstSprite != null)
        {
            CSprite pSpr = lyrGetSprite(param1);		// (npSpr)roPtr->roc.rcSprite;
            if (pSpr != null)
            {
                // Exchange the sprite with the next one until the end of the list
                while (pSpr != ObjAddr.firstSprite)
                {
                    CSprite pSprPrev = pSpr.objPrev;
                    if (pSprPrev == null)
                    {
                        break;
                    }
                    if (pSpr.sprLayer != pSprPrev.sprLayer)
                    {
                        break;
                    }

                    lyrSwapSpr(pSprPrev, pSpr);
                }

                // Force redraw
                if ((pSpr.sprFlags & CSprite.SF_HIDDEN) == 0)
                {
                    ObjAddr.activeSprite(pSpr, CSpriteGen.AS_REDRAW, null);
                }
            }
        }

    }

    void actBackN(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actBackNRout(param1, param2);
    }

    void actBackNRout(int param1, int param2)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            for (int n = 0; n < param2; n++)
            {
                if ((sprPtr2 = sprPtr1.objPrev) == null)
                {
                    break;
                }

                if (sprPtr1.sprLayer != sprPtr2.sprLayer)
                {
                    break;
                }

                lyrSwapThem(sprPtr1, sprPtr2, true);
            }
        }
    }

    void actForwardN(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actForwardNRout(param1, param2);
    }

    void actForwardNRout(int param1, int param2)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            for (int n = 0; n < param2; n++)
            {
                if ((sprPtr2 = sprPtr1.objNext) == null)
                {
                    break;
                }

                if (sprPtr1.sprLayer != sprPtr2.sprLayer)
                {
                    break;
                }

                lyrSwapThem(sprPtr1, sprPtr2, true);
            }
        }
    }

    void actReverse(CActExtension act)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        CSprite lastPrev;
        CSprite lastNext;

        //Runheader for this object
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSpriteGen ObjAddr = ho.hoAdRunHeader.spriteGen;

        // Get first layer sprite
        lastNext = ObjAddr.firstSprite;
        while (lastNext != null && (lastNext.sprFlags & CSprite.SF_TOKILL) != 0 && lastNext.sprLayer < nLayer)
        {
            lastNext = lastNext.objNext;
        }
        if (lastNext == null || lastNext.sprLayer != nLayer)
        {
            return;
        }

        // Get last layer sprite
        lastPrev = ObjAddr.lastSprite;
        while (lastPrev != null && (lastPrev.sprFlags & CSprite.SF_TOKILL) != 0 && lastPrev.sprLayer > nLayer)
        {
            lastPrev = lastPrev.objNext;
        }
        if (lastPrev == null || lastPrev.sprLayer != nLayer)
        {
            return;
        }

        if (lastPrev == lastNext)
        {
            return;
        }

        do
        {
            sprPtr1 = lastNext;
            sprPtr2 = lastPrev;

            lastNext = sprPtr1.objNext;
            lastPrev = sprPtr2.objPrev;

            lyrSwapThem(sprPtr1, sprPtr2, true);
        } while ((lastNext != lastPrev) && (lastNext != sprPtr1) && (lastNext != sprPtr2));
    }

    void actMoveAbove(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actMoveAboveRout(param1, param2);
    }

    void actMoveAboveRout(int param1, int param2)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            if ((sprPtr2 = lyrGetSprite(param2)) != null)
            {
                if (sprPtr1.sprLayer == sprPtr2.sprLayer)
                {
                    CSprite pSpr = sprPtr1.objNext;
                    while (pSpr != null && pSpr != sprPtr2)
                    {
                        pSpr = pSpr.objNext;
                    }
                    if (pSpr != null)
                    {
                        // Exchange the sprite with the next one until the second one is reached
                        CSprite pNextSpr;
                        do
                        {
                            pNextSpr = sprPtr1.objNext;
                            if (pNextSpr == null)
                            {
                                break;
                            }
                            lyrSwapSpr(sprPtr1, pNextSpr);
                        } while (pNextSpr != sprPtr2);

                        // Force redraw
                        if ((sprPtr1.sprFlags & CSprite.SF_HIDDEN) == 0)
                        {
                            ho.hoAdRunHeader.spriteGen.activeSprite(sprPtr1, CSpriteGen.AS_REDRAW, null);
                        }
                    }
                }
            }
        }
    }

    void actMoveBelow(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actMoveBelowRout(param1, param2);
    }

    void actMoveBelowRout(int param1, int param2)
    {
        CSprite sprPtr1;
        CSprite sprPtr2;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            if ((sprPtr2 = lyrGetSprite(param2)) != null)
            {
                if (sprPtr1.sprLayer == sprPtr2.sprLayer)
                {
                    CSprite pSpr = sprPtr1.objPrev;
                    while (pSpr != null && pSpr != sprPtr2)
                    {
                        pSpr = pSpr.objPrev;
                    }
                    if (pSpr != null)
                    {
                        // Exchange the sprite with the previous one until the second one is reached
                        CSprite pPrevSpr = sprPtr1;
                        do
                        {
                            pPrevSpr = sprPtr1.objPrev;
                            if (pPrevSpr == null)
                            {
                                break;
                            }
                            lyrSwapSpr(sprPtr1, pPrevSpr);
                        } while (pPrevSpr != sprPtr2);

                        // Force redraw
                        if ((sprPtr1.sprFlags & CSprite.SF_HIDDEN) == 0)
                        {
                            ho.hoAdRunHeader.spriteGen.activeSprite(sprPtr1, CSpriteGen.AS_REDRAW, null);
                        }
                    }
                }
            }
        }

    }

    void actMoveToN(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        actMoveToNRout(param1, param2);
    }

    void actMoveToNRout(int param1, int param2)
    {
        CSpriteGen ObjAddr = ho.hoAdRunHeader.spriteGen;

        CSprite sprPtr1;
        CSprite sprPtr2;

        int lvlCount = 0;

        if ((sprPtr1 = lyrGetSprite(param1)) != null)
        {
            sprPtr2 = ObjAddr.firstSprite;

            // Look for 1st object in the same layer
            while (sprPtr2 != null && sprPtr1.sprLayer != sprPtr2.sprLayer)
            {
                sprPtr2 = sprPtr2.objNext;
            }
            if (sprPtr2 == null || sprPtr1.sprLayer != sprPtr2.sprLayer)
            {
                return;
            }

            // Look for position N in the same layer
            while (sprPtr2 != null && (++lvlCount != param2))
            {
                sprPtr2 = sprPtr2.objNext;
                if (sprPtr2 != null && sprPtr1.sprLayer != sprPtr2.sprLayer)
                {
                    sprPtr2 = null;
                    break;
                }
            }

            // Position found, swap sprites
            if ((sprPtr2 != null) && (sprPtr1 != sprPtr2))		// MMF 1.5: sprPtr2 != NULL && (sprPtr1->sprLayer != sprPtr2->sprLayer))
            {
                // MMF 2
                CSprite pSpr = sprPtr1.objPrev;
                while (pSpr != null && pSpr != sprPtr2)
                {
                    pSpr = pSpr.objPrev;
                }
                if (pSpr != null)
                {
                    // Exchange the sprite with the previous one until the second one is reached
                    CSprite pPrevSpr = sprPtr1;
                    do
                    {
                        pPrevSpr = sprPtr1.objPrev;
                        if (pPrevSpr == null)
                        {
                            break;
                        }
                        lyrSwapSpr(sprPtr1, pPrevSpr);
                    } while (pPrevSpr != sprPtr2);

                    // Force redraw
                    if ((sprPtr1.sprFlags & CSprite.SF_HIDDEN) == 0)
                    {
                        ObjAddr.activeSprite(sprPtr1, CSpriteGen.AS_REDRAW, null);
                    }
                }
                else
                {
                    // Exchange the sprite with the next one until the second one is reached
                    CSprite pNextSpr;
                    do
                    {
                        pNextSpr = sprPtr1.objNext;
                        if (pNextSpr == null)
                        {
                            break;
                        }
                        lyrSwapSpr(sprPtr1, pNextSpr);
                    } while (pNextSpr != sprPtr2);

                    // Force redraw
                    if ((sprPtr1.sprFlags & CSprite.SF_HIDDEN) == 0)
                    {
                        ObjAddr.activeSprite(sprPtr1, CSpriteGen.AS_REDRAW, null);
                    }
                }
            }
        }
    }

    void actSortByXUP(CActExtension act)
    {
        lyrSortBy(X_UP, 0, 0);
    }

    void actSortByYUP(CActExtension act)
    {
        lyrSortBy(Y_UP, 0, 0);
    }

    void actSortByXDOWN(CActExtension act)
    {
        lyrSortBy(X_DOWN, 0, 0);
    }

    void actSortByYDOWN(CActExtension act)
    {
        lyrSortBy(Y_DOWN, 0, 0);
    }

    void actBackOneObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        if(roPtr == null)
        	return;
        CObjInfo oilPtr = roPtr.hoOiList;
        actBackOneRout(lyrGetFVfromOIL(oilPtr));
    }

    void actForwardOneObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        if(roPtr == null)
        	return;
       actForwardOneRout(lyrGetFVfromOIL(roPtr.hoOiList));
    }

    void actSwapObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        CObject roPtr2 = act.getParamObject(rh, 1);

        if(roPtr == null || roPtr2 == null)
        	return;
       actSwapRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
    }

    void actBringFrontObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        if(roPtr == null)
        	return;
        actBringFront(lyrGetFVfromOIL(roPtr.hoOiList));
    }

    void actSendBackObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        if(roPtr == null)
        	return;
        actSendBackRout(lyrGetFVfromOIL(roPtr.hoOiList));
    }

    void actBackNObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        if(roPtr == null)
        	return;
        actBackNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
    }

    void actForwardNObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        if(roPtr == null)
        	return;
        actForwardNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
    }

    void actMoveAboveObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        CObject roPtr2 = act.getParamObject(rh, 1);
        if(roPtr == null || roPtr2 == null)
        	return;
        actMoveAboveRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
    }

    void actMoveBelowObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        CObject roPtr2 = act.getParamObject(rh, 1);
        if(roPtr == null || roPtr2 == null)
        	return;
       actMoveBelowRout(lyrGetFVfromOIL(roPtr.hoOiList), lyrGetFVfromOIL(roPtr2.hoOiList));
    }

    void actMoveToNObj(CActExtension act)
    {
        CObject roPtr = act.getParamObject(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        if(roPtr == null)
        	return;
        actMoveToNRout(lyrGetFVfromOIL(roPtr.hoOiList), param2);
    }

    void actSortByALTUP(CActExtension act)
    {
        int param1 = act.getParamAltValue(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        lyrSortBy(ALT_UP, param2, param1);
    }

    void actSortByALTDOWN(CActExtension act)
    {
        int param1 = act.getParamAltValue(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        lyrSortBy(ALT_DOWN, param2, param1);
    }

    void actSetLayerX(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            int newX = -param2;
            if (pLayer.x != newX || pLayer.dx != 0)
            {
                pLayer.dx = (newX - pLayer.x);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetLayerY(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        int param2 = act.getParamExpression(rh, 1);
        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            int newY = -param2;
            if (pLayer.y != newY || pLayer.dy != 0)
            {
                pLayer.dy = (newY - pLayer.y);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetLayerXY(CActExtension act)
    {
        int nLayer = act.getParamExpression(rh, 0);
        int newX = -1 * act.getParamExpression(rh, 1);
        int newY = -1 * act.getParamExpression(rh, 2);

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if (pLayer.x != newX || pLayer.dx != 0 || pLayer.y != newY || pLayer.dy != 0)
            {
                pLayer.dx = (newX - pLayer.x);
                pLayer.dy = (newY - pLayer.y);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actShowLayer(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            if ((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) == 0)
            {
                pLayer.dwOptions |= (CLayer.FLOPT_TOSHOW | CLayer.FLOPT_REDRAW);
                pLayer.dwOptions &= ~CLayer.FLOPT_TOHIDE;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actHideLayer(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            if ((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) != 0)
            {
                pLayer.dwOptions |= (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_REDRAW);
                pLayer.dwOptions &= ~CLayer.FLOPT_TOSHOW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetLayerXByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);
        int param2 = act.getParamExpression(rh, 1);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            int newX = -param2;
            if (pLayer.x != newX || pLayer.dx != 0)
            {
                pLayer.dx = (newX - pLayer.x);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetLayerYByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);
        int param2 = act.getParamExpression(rh, 1);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            int newY = -param2;
            if (pLayer.y != newY || pLayer.dy != 0)
            {
                pLayer.dy = (newY - pLayer.y);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetLayerXYByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);
        int newX = -1 * act.getParamExpression(rh, 1);
        int newY = -1 * act.getParamExpression(rh, 2);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if (pLayer.x != newX || pLayer.dx != 0 || pLayer.y != newY || pLayer.dy != 0)
            {
                pLayer.dx = (newX - pLayer.x);
                pLayer.dy = (newY - pLayer.y);
                pLayer.dwOptions |= CLayer.FLOPT_REDRAW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actShowLayerByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if ((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) == 0)
            {
                pLayer.dwOptions |= (CLayer.FLOPT_TOSHOW | CLayer.FLOPT_REDRAW);
                pLayer.dwOptions &= ~CLayer.FLOPT_TOHIDE;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actHideLayerByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if ((pLayer.dwOptions & CLayer.FLOPT_VISIBLE) != 0)
            {
                pLayer.dwOptions |= (CLayer.FLOPT_TOHIDE | CLayer.FLOPT_REDRAW);
                pLayer.dwOptions &= ~CLayer.FLOPT_TOSHOW;
                ho.hoAdRunHeader.rh3Scrolling |= CRun.RH3SCROLLING_REDRAWLAYERS;
            }
        }
    }

    void actSetCurrentLayer(CActExtension act)
    {
        int nLayer = act.getParamExpression(rh, 0);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            wCurrentLayer = (nLayer - 1);
        }
    }

    void actSetCurrentLayerByName(CActExtension act)
    {
        String name = act.getParamExpString(rh, 0);
        int nLayer = FindLayerByName(name);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            wCurrentLayer = (nLayer - 1);
        }
    }

    void actSetLayerCoefX(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        float newCoef = (float) act.getParamExpDouble(rh, 1);

        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            if (pLayer.xCoef != newCoef)
            {
                pLayer.xCoef = newCoef;
                pLayer.dwOptions &= ~CLayer.FLOPT_XCOEF;
                if (newCoef != 1.0f)
                {
                    pLayer.dwOptions |= CLayer.FLOPT_XCOEF;
                }
            }
        }
    }

    void actSetLayerCoefY(CActExtension act)
    {
        int param1 = act.getParamExpression(rh, 0);
        float newCoef = (float) act.getParamExpDouble(rh, 1);

        if (param1 > 0 && param1 <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[param1 - 1];
            if (pLayer.yCoef != newCoef)
            {
                pLayer.yCoef = newCoef;
                pLayer.dwOptions &= ~CLayer.FLOPT_YCOEF;
                if (newCoef != 1.0f)
                {
                    pLayer.dwOptions |= CLayer.FLOPT_YCOEF;
                }
            }
        }
    }

    void actSetLayerCoefXByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);
        float newCoef = (float) act.getParamExpDouble(rh, 1);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if (pLayer.xCoef != newCoef)
            {
                pLayer.xCoef = newCoef;
                pLayer.dwOptions &= ~CLayer.FLOPT_XCOEF;
                if (newCoef != 1.0f)
                {
                    pLayer.dwOptions |= CLayer.FLOPT_XCOEF;
                }
            }
        }
    }

    void actSetLayerCoefYByName(CActExtension act)
    {
        String param1 = act.getParamExpString(rh, 0);
        float newCoef = (float) act.getParamExpDouble(rh, 1);

        int nLayer = FindLayerByName(param1);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
            if (pLayer.yCoef != newCoef)
            {
                pLayer.yCoef = newCoef;
                pLayer.dwOptions &= ~CLayer.FLOPT_YCOEF;
                if (newCoef != 1.0f)
                {
                    pLayer.dwOptions |= CLayer.FLOPT_YCOEF;
                }
            }
        }
    }

    // Expressions
    // --------------------------------------------
    @Override
	public CValue expression(int num)
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
            case 20:  // EXP_GETLAYEREFFECTPARAM
            case 21: // EXP_GETLAYERALPHA
            case 22: // EXP_GETLAYERRGB
            case 23:  // EXP_GETLAYEREFFECTPARAM_BYNAME
            case 24: // EXP_GETLAYERALPHA_BYNAME
            case 25: // EXP_GETLAYERRGB_BYNAME
                return expZeroOneParam();
        }
        return null;
    }

    CValue expZeroOneParam()
    {
        ho.getExpParam();
        return new CValue(0);
    }

    CValue expGetFV()
    {
        //CObject roPtr;
        CObjInfo oilPtr;

        CSprite sprPtr;

        int FValue = 0;
        String objName = ho.getExpParam().getString();

        if (objName.length() == 0)
        {
        	expRet.forceInt(holdFValue);
            return expRet;
        }
        /*
        int count = 0;
        int no;
        for (no = 0; no < ho.hoAdRunHeader.rhNObjects; no++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count] == null)
            {
                count++;
            }
            roPtr = ho.hoAdRunHeader.rhObjectList[count];
            count++;

            oilPtr = roPtr.hoOiList;

            if (objName.compareToIgnoreCase(oilPtr.oilName) == 0)
            {
                FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);
                sprPtr = lyrGetSprite(FValue);

                if ((sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
                {
                    break;
                }
                else
                // Reset it for the next iteration.
                {
                    FValue = 0;
                }
            }
        }
        */
        for (CObject roPtr : ho.hoAdRunHeader.rhObjectList)
        {
             oilPtr = roPtr.hoOiList;

            if (objName.compareToIgnoreCase(oilPtr.oilName) == 0)
            {
                FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);
                sprPtr = lyrGetSprite(FValue);

                if ((sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
                {
                    break;
                }
                else
                // Reset it for the next iteration.
                {
                    FValue = 0;
                }
            }
        }
    	expRet.forceInt(FValue);
        return expRet;
    }

    CValue expGetTopFV()
    {
        //Runheader for this object
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSprite sprPtr;
        CObject roPtr;

        sprPtr = ho.hoAdRunHeader.spriteGen.lastSprite;
        while (sprPtr != null)
        {
            if (sprPtr.sprLayer < nLayer)
            {
                break;
            }
            if (sprPtr.sprLayer == nLayer && (sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
            {
                roPtr = sprPtr.sprExtraInfo;
            	expRet.forceInt((roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF));
                return expRet;
            }
            sprPtr = sprPtr.objPrev;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetBottomFV()
    {
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSprite sprPtr;
        CObject roPtr;

        sprPtr = ho.hoAdRunHeader.spriteGen.firstSprite;

        while (sprPtr != null)
        {
            if (sprPtr.sprLayer > nLayer)
            {
                break;
            }
            if (sprPtr.sprLayer == nLayer && (sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
            {
                roPtr = sprPtr.sprExtraInfo;
            	expRet.forceInt((roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF));
                return expRet;
            }
            sprPtr = sprPtr.objNext;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetDesc()
    {
        int lvlN = ho.getExpParam().getInt();
        String ps = lyrGetList(lvlN, 1);
    	expRet.forceString(ps);
        return expRet;
    }

    CValue expGetDesc10()
    {
        int lvlN = ho.getExpParam().getInt();
        String ps = lyrGetList(lvlN, 10);
    	expRet.forceString(ps);
        return expRet;
    }

    CValue expGetNumLevels()
    {
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSprite sprPtr;
        int lvlCount = 0;

        sprPtr = ho.hoAdRunHeader.spriteGen.firstSprite;

        while (sprPtr != null)
        {
            if (sprPtr.sprLayer > nLayer)
            {
                break;
            }
            if (sprPtr.sprLayer == nLayer && (sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
            {
                lvlCount++;
            }
            sprPtr = sprPtr.objNext;
        }
    	expRet.forceInt(lvlCount);
        return expRet;
    }

    CValue expGetLevel()
    {
        int nLayer = -1;	// rdPtr->wCurrentLayer * 2 + 1;

        CSprite sprPtr;
        CObject roPtr;

        int lvlCount = 1;
        int FValue = 0;
        int FindFixed = ho.getExpParam().getInt();

        if (FindFixed == 0)
        {
            FindFixed = holdFValue;
        }

        sprPtr = ho.hoAdRunHeader.spriteGen.firstSprite;

        while (sprPtr != null)
        {
            // Ignore background layers
            if ((sprPtr.sprLayer & 1) != 0)		// sprPtr->sprLayer == nLayer
            {
                // New version: look for object in all the layers
                if (nLayer != sprPtr.sprLayer)
                {
                    nLayer = sprPtr.sprLayer;
                    lvlCount = 1;
                }

                if ((sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
                {
                    roPtr = sprPtr.sprExtraInfo;
                    FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);

                    if (FindFixed == FValue)
                    {
                    	expRet.forceInt(lvlCount);
                        return expRet;
                    }

                    lvlCount++;
                }
            }
            sprPtr = sprPtr.objNext;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetLevelFV()
    {
        int nLayer = wCurrentLayer * 2 + 1;

        CSprite sprPtr;
        CObject roPtr;

        int lvlCount = 1;
        int FValue = 0;
        int FindLevel = ho.getExpParam().getInt();

        sprPtr = ho.hoAdRunHeader.spriteGen.firstSprite;

        while (sprPtr != null)
        {
            if (sprPtr.sprLayer > nLayer)
            {
                break;
            }
            if (sprPtr.sprLayer == nLayer)
            {
                if (FindLevel == lvlCount++)
                {
                    if ((sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
                    {
                        roPtr = sprPtr.sprExtraInfo;
                        FValue = (roPtr.hoCreationId << 16) + ((roPtr.hoNumber) & 0xFFFF);
                        break;
                    }
                    else
                    {
                        lvlCount--;
                    }
                }
            }
            sprPtr = sprPtr.objNext;
        }
    	expRet.forceInt(FValue);
        return expRet;
    }

    CValue expGetLayerX()
    {
        int nLayer = ho.getExpParam().getInt();

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceInt(-(pLayer.x + pLayer.dx));
            return expRet;
       }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetLayerY()
    {
        int nLayer = ho.getExpParam().getInt();

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceInt(-(pLayer.y + pLayer.dy));
            return expRet;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetLayerXByName()
    {
        String pName = ho.getExpParam().getString();

        int nLayer = FindLayerByName(pName);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceInt(-(pLayer.x + pLayer.dx));
            return expRet;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetLayerYByName()
    {
        String pName = ho.getExpParam().getString();

        int nLayer = FindLayerByName(pName);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceInt(-(pLayer.y + pLayer.dy));
            return expRet;
        }
    	expRet.forceInt(0);
        return expRet;
    }

    CValue expGetLayerCount()
    {
    	expRet.forceInt(ho.hoAdRunHeader.rhFrame.nLayers);
        return expRet;
    }

    CValue expGetLayerName()
    {
        int nLayer = ho.getExpParam().getInt();

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceString(pLayer.pName);
            return expRet;
        }
    	expRet.forceString("");
        return expRet;
    }

    CValue expGetLayerIndex()
    {
        String pName = ho.getExpParam().getString();
    	expRet.forceInt(FindLayerByName(pName));
        return expRet;
    }

    CValue expGetCurrentLayer()
    {
        return new CValue(wCurrentLayer + 1);
    }

    CValue expGetLayerCoefX()
    {
        int nLayer = ho.getExpParam().getInt();

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceDouble(pLayer.xCoef);
            return expRet;
        }
    	expRet.forceDouble(0);
        return expRet;
    }

    CValue expGetLayerCoefY()
    {
        int nLayer = ho.getExpParam().getInt();

        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceDouble(pLayer.yCoef);
            return expRet;
        }
    	expRet.forceDouble(0);
        return expRet;
    }

    CValue expGetLayerCoefXByName()
    {
        String pName = ho.getExpParam().getString();

        int nLayer = FindLayerByName(pName);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
        	expRet.forceDouble(pLayer.xCoef);
            return expRet;
        }
    	expRet.forceDouble(0);
        return expRet;
    }

    CValue expGetLayerCoefYByName()
    {
        String pName = ho.getExpParam().getString();

        int nLayer = FindLayerByName(pName);
        if (nLayer > 0 && nLayer <= ho.hoAdRunHeader.rhFrame.nLayers)
        {
            CLayer pLayer = ho.hoAdRunHeader.rhFrame.layers[nLayer - 1];
         	expRet.forceDouble(pLayer.yCoef);
            return expRet;
        }
    	expRet.forceDouble(0);
        return expRet;
    }

    // SORT ROUTINES
    // --------------------------------------------------------
    // Exchange 2 sprites in the linked list
    void lyrSwapSpr(CSprite sp1, CSprite sp2)
    {
        // Security
        if (sp1 == sp2)
        {
            return;
        }

        // Cannot swap sprites from different layers
        if (sp1.sprLayer != sp2.sprLayer)
        {
            return;
        }

        CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;

        CSprite pPrev1 = sp1.objPrev;
        CSprite pNext1 = sp1.objNext;

        CSprite pPrev2 = sp2.objPrev;
        CSprite pNext2 = sp2.objNext;

        // Exchange z-order values
        int nZOrder = sp1.sprZOrder;
        sp1.sprZOrder = sp2.sprZOrder;
        sp2.sprZOrder = nZOrder;

        // Exchange sprites

        // Several cases
        //
        // 1. pPrev1, sp1, sp2, pNext2
        //
        //    pPrev1.next = sp2
        //	  sp2.prev = pPrev1;
        //	  sp2.next = sp1;
        //	  sp1.prev = sp2;
        //	  sp1.next = pNext2
        //	  pNext2.prev = sp1
        //
        if (pNext1 == sp2)
        {
            if (pPrev1 != null)
            {
                pPrev1.objNext = sp2;
            }
            sp2.objPrev = pPrev1;
            sp2.objNext = sp1;
            sp1.objPrev = sp2;
            sp1.objNext = pNext2;
            if (pNext2 != null)
            {
                pNext2.objPrev = sp1;
            }

            // Update first & last sprites
            if (pPrev1 == null)
            {
                objAddr.firstSprite = sp2;
            }
            if (pNext2 == null)
            {
                objAddr.lastSprite = sp1;
            }
        }

        // 2. pPrev2, sp2, sp1, pNext1
        //
        //    pPrev2.next = sp1
        //	  sp1.prev = pPrev2;
        //	  sp1.next = sp2;
        //	  sp2.prev = sp1;
        //	  sp2.next = pNext1
        //	  pNext1.prev = sp2
        //
        else if (pNext2 == sp1)
        {
            if (pPrev2 != null)
            {
                pPrev2.objNext = sp1;
            }
            sp1.objPrev = pPrev2;
            sp1.objNext = sp2;
            sp2.objPrev = sp1;
            sp2.objNext = pNext1;
            if (pNext1 != null)
            {
                pNext1.objPrev = sp2;
            }

            // Update first & last sprites
            if (pPrev2 == null)
            {
                objAddr.firstSprite = sp1;	//	*ptPtsObj = (UINT)sp1;
            }
            if (pNext1 == null)
            {
                objAddr.lastSprite = sp2;	//	*(ptPtsObj+1) = (UINT)sp2;
            }
        }

        // 3. pPrev1, sp1, pNext1 ... pPrev2, sp2, pNext2
        // or pPrev2, sp2, pNext2 ... pPrev1, sp1, pNext1
        //
        //	  pPrev1.next = sp2;
        //	  pNext1.prev = sp2
        //	  sp1.prev = pPrev2;
        //	  sp1.next = pNext2;
        //	  pPrev2.next = sp1;
        //	  pNext2.prev = sp1
        //	  sp2.prev = pPrev1;
        //	  sp2.next = pNext1;
        //
        else
        {
            if (pPrev1 != null)
            {
                pPrev1.objNext = sp2;
            }
            if (pNext1 != null)
            {
                pNext1.objPrev = sp2;
            }
            sp1.objPrev = pPrev2;
            sp1.objNext = pNext2;
            if (pPrev2 != null)
            {
                pPrev2.objNext = sp1;
            }
            if (pNext2 != null)
            {
                pNext2.objPrev = sp1;
            }
            sp2.objPrev = pPrev1;
            sp2.objNext = pNext1;

            // Update first & last sprites
            if (pPrev1 == null)
            {
                objAddr.firstSprite = sp2;
            }
            if (pPrev2 == null)
            {
                objAddr.firstSprite = sp1;
            }
            if (pNext1 == null)
            {
                objAddr.lastSprite = sp2;
            }
            if (pNext2 == null)
            {
                objAddr.lastSprite = sp1;
            }
        }
    }

    boolean lyrSwapThem(CSprite sprPtr1, CSprite sprPtr2, boolean bRedraw)
    {
        // Exchange sprites
        lyrSwapSpr(sprPtr1, sprPtr2);

        if (bRedraw)
        {
            // Force redraw
            if ((sprPtr1.sprFlags & CSprite.SF_HIDDEN) == 0)
            {
                ho.hoAdRunHeader.spriteGen.activeSprite(sprPtr1, CSpriteGen.AS_REDRAW, null);
            }
            if ((sprPtr2.sprFlags & CSprite.SF_HIDDEN) == 0)
            {
                ho.hoAdRunHeader.spriteGen.activeSprite(sprPtr2, CSpriteGen.AS_REDRAW, null);
            }
        }
        return true;
    }

    CSprite lyrGetSprite(int fixedValue)
    {
        if (fixedValue == 0)
        {
            fixedValue = holdFValue;
        }

        //int count = 0;
        //int no;
        int fValue;
        /*
        for (no = 0; no < ho.hoAdRunHeader.rhNObjects; no++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count] == null)
            {
                count++;
            }
            CObject hoPtr = ho.hoAdRunHeader.rhObjectList[count];
            count++;
            fValue = (hoPtr.hoCreationId << 16) + hoPtr.hoNumber;
            if (fixedValue == fValue)
            {
                return hoPtr.roc.rcSprite;
            }
        }
        */
        for(CObject hoPtr : ho.hoAdRunHeader.rhObjectList) {
        	if(hoPtr == null)
        		continue;
            fValue = (hoPtr.hoCreationId << 16) + hoPtr.hoNumber;
            if (fixedValue == fValue)
            {
                return hoPtr.roc.rcSprite;
            }       	
        }
        return null;
    }

    CObject lyrGetROfromFV(long fixedValue)
    {
        if (fixedValue == 0)
        {
            fixedValue = holdFValue;
        }

        //int count = 0;
        //int no;
        int fValue;
        /*
        for (no = 0; no < ho.hoAdRunHeader.rhNObjects; no++)
        {
            while (ho.hoAdRunHeader.rhObjectList[count] == null)
            {
                count++;
            }
            CObject hoPtr = ho.hoAdRunHeader.rhObjectList[count];
            count++;
            fValue = (hoPtr.hoCreationId << 16) + ((hoPtr.hoNumber) & 0xFFFF);
            if (fixedValue == fValue)
            {
                return hoPtr;
            }
        }
        */
        for(CObject hoPtr : ho.hoAdRunHeader.rhObjectList) {
        	if(hoPtr == null)
        		continue;
            fValue = (hoPtr.hoCreationId << 16) + ((hoPtr.hoNumber) & 0xFFFF);
            if (fixedValue == fValue)
            {
                return hoPtr;
            }
       	
        }
        return null;
    }

    boolean lyrSortBy(int flag, int altDefaultVal, int altValue)
    {
        int nLayer = (short) wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;

        // Get first layer sprite
        CSprite sprFirst = objAddr.firstSprite;
        while (sprFirst != null && ((sprFirst.sprFlags & CSprite.SF_TOKILL) != 0 || sprFirst.sprLayer < nLayer))
        {
            sprFirst = sprFirst.objNext;
        }
        if (sprFirst == null || sprFirst.sprLayer != nLayer)
        {
            return false;
        }

        // Get last layer sprite
        CSprite sprLast = objAddr.lastSprite;
        while (sprLast != null && ((sprLast.sprFlags & CSprite.SF_TOKILL) != 0 || sprLast.sprLayer > nLayer))
        {
            sprLast = sprLast.objPrev;
        }
        if (sprLast == null || sprLast.sprLayer != nLayer)
        {
            return false;
        }

        if (sprFirst == sprLast)
        {
            return false;
        }

        CSprite pSprite = sprFirst;

        ArrayList<CSortData> spriteList = new ArrayList<CSortData>();
        int i = 0;
        CSortData tmp;
        while (pSprite != null)
        {
            tmp = new CSortData();
            tmp.indexSprite = pSprite;
            tmp.cmpFlag = flag;

            // MMF2: ajoute protection sur SF_TOKILL car eu un crash
            if ((pSprite.sprFlags & CSprite.SF_TOKILL) == 0)
            {
                CObject hoPtr = pSprite.sprExtraInfo;
                tmp.sprX = hoPtr.hoX;
                tmp.sprY = hoPtr.hoY;

                tmp.sprAlt = altDefaultVal;
                if (hoPtr.rov != null)
                {
                    if (hoPtr.rov.rvValues[altValue]!=null)
                    {
                        if (hoPtr.rov.rvValues[altValue].type == CValue.TYPE_INT)
                        {
                            tmp.sprAlt = hoPtr.rov.rvValues[altValue].intValue;
                        }
                        else
                        {
                            tmp.sprAlt = (int) hoPtr.rov.rvValues[altValue].doubleValue;
                        }
                    }
                }
            }
            else
            {
                tmp.sprX = pSprite.sprX;
                tmp.sprY = pSprite.sprY;
                tmp.sprAlt = altDefaultVal;
            }
            spriteList.add(tmp);

            // Force redraw (moved here - B249)
            if ( (pSprite.sprFlags & (CSprite.SF_HIDDEN|CSprite.SF_TOHIDE)) == 0 )
                objAddr.activeSprite(pSprite, CSpriteGen.AS_REDRAW, null);

            if (pSprite == sprLast)
            {
                break;
            }
            pSprite = pSprite.objNext;
            i++;
        }

        // TRI (a bulle en attendant mieux)
        int count = 0;
        int n;
        do
        {
            count = 0;
            int spriteList_size = spriteList.size();
            for (n = 0; n < spriteList_size - 1; n++)
            {
                if (isGreater(spriteList.get(n), spriteList.get(n + 1)))
                {
                    tmp = spriteList.get(n + 1);
                    spriteList.set(n + 1, spriteList.get(n));
                    spriteList.set(n, tmp);
                    count++;
                }
            }
        } while (count != 0);

        CSprite sprPrevFirst = null;
        if (sprFirst != objAddr.firstSprite)
        {
            sprPrevFirst = sprFirst.objPrev;
        }

        CSprite sprNextLast = null;
        if (sprLast != objAddr.lastSprite)
        {
            sprNextLast = sprLast.objNext;
        }

        CSprite sprTemp=null;
        int spriteList_size = spriteList.size();
        for (n = 0; n < spriteList_size; n++)
        {
            sprTemp = (spriteList.get(n)).indexSprite;

            if (n == 0)
            {
                if (sprPrevFirst == null)
                {
                    //This is the first of the list
                    objAddr.firstSprite = sprTemp;
                    sprTemp.objPrev = null;
                    sprTemp.objNext = (spriteList.get(n + 1)).indexSprite;
                }
                else
                {
                    sprTemp.objPrev = sprPrevFirst;
                    sprPrevFirst.objNext = sprTemp;
                    sprTemp.objNext = (spriteList.get(n + 1)).indexSprite;
                }
            }
            else
            {
                sprTemp.objPrev = (spriteList.get(n - 1)).indexSprite;
                if (n + 1 == spriteList.size())
                {
                    if (sprNextLast == null)
                    {
                        sprTemp.objNext = null;
                        objAddr.lastSprite = (spriteList.get(n)).indexSprite;
                    }
                    else
                    {
                        sprTemp.objNext = sprNextLast;
                        sprNextLast.objPrev = sprTemp;
                    }
                }
                else
                {
                    sprTemp.objNext = (spriteList.get(n + 1)).indexSprite;
                }
            }
        }

        return false;
    }

    boolean isGreater(CSortData item1, CSortData item2)
    {
        // MMF2
        CSprite p1 = item1.indexSprite;
        CSprite p2 = item2.indexSprite;
        if (p1.sprLayer != p2.sprLayer)
        {
            return (p1.sprLayer > p2.sprLayer);
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

    String lyrGetList(int lvlStart, int iteration)
    {
        //String szList = new String("Lvl\tName\tFV\n\n");
        String szList = "Lvl\tName\tFV\n\n";
        int nLayer = wCurrentLayer;

        // Dynamic objects layer
        nLayer = nLayer * 2 + 1;

        //Runheader for this object
        CSpriteGen objAddr = ho.hoAdRunHeader.spriteGen;

        CSprite sprPtr;
        CObject hoPtr;
        CObjInfo oilPtr;

        int fValue = 0;
        int lvlCount = 0;

        sprPtr = objAddr.firstSprite;

        // Get first layer sprite
        while (sprPtr != null && (sprPtr.sprFlags & CSprite.SF_TOKILL) != 0 && sprPtr.sprLayer < nLayer)
        {
            sprPtr = sprPtr.objNext;
        }
        if (sprPtr != null && sprPtr.sprLayer == nLayer)
        {
            while ((sprPtr != null) && (sprPtr.sprLayer == nLayer) && (++lvlCount < (lvlStart + iteration)))
            {
                if (lvlCount >= lvlStart)
                {
                    if ((sprPtr.sprFlags & CSprite.SF_TOKILL) == 0)
                    {
                        hoPtr = sprPtr.sprExtraInfo;
                        oilPtr = hoPtr.hoOiList;
                        fValue = (hoPtr.hoCreationId << 16) + ((hoPtr.hoNumber) & 0xFFFF);
                        StringBuffer buffer = new StringBuffer(Integer.toString(lvlCount));
                        buffer.append('\t');
                        buffer.append(oilPtr.oilName);
                        buffer.append('\t');
                        buffer.append(Integer.toString(fValue));
                        buffer.append('\n');
                        szList += buffer;
                    }
                    else
                    {
                        lvlCount--;
                    }
                }
                sprPtr = sprPtr.objNext;
            }
        }
        return szList;
    }

    int lyrGetFVfromEVP(PARAM_OBJECT evp)
    {
        CObjInfo oilPtr = ho.hoAdRunHeader.rhOiList[evp.oiList];

        CObject hoPtr;
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
        return ((hoPtr.hoCreationId << 16) + ((hoPtr.hoNumber) & 0xFFFF));
    }

    CObject lyrGetROfromEVP(PARAM_OBJECT evp)
    {
        CObjInfo oilPtr = ho.hoAdRunHeader.rhOiList[evp.oiList];

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

    CObjInfo lyrGetOILfromEVP(PARAM_OBJECT evp)
    {
        if (evp.oiList < 0)
        {
            return null;
        }
        return ho.hoAdRunHeader.rhOiList[evp.oiList];
    }

    int lyrGetFVfromOIL(CObjInfo oilPtr)
    {
        CObject hoPtr;

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
        return ((hoPtr.hoCreationId << 16) + ((hoPtr.hoNumber) & 0xFFFF));
    }

    void lyrResetEventList(CObjInfo oilPtr)
    {
        if (oilPtr.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
        {
            oilPtr.oilEventCount = -1;
        }
        return;
    }

    boolean lyrProcessCondition(PARAM_OBJECT param1, PARAM_OBJECT param2, int cond)
    {
        boolean lReturn;

        CObjInfo oilPtr1 = lyrGetOILfromEVP(param1);
        if (oilPtr1 == null)
        {
            return false;
        }
        CObject roPtr1;
        if ((roPtr1 = lyrGetROfromEVP(param1)) == null)
        {
            return false;
        }

        CObjInfo oilPtr2 = null;
        CObject roPtr2 = null;

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
        short RootObj = -1;
        short NumCount = 0;
        boolean bMatch;

        int FValue1 = -1;
        int FValue2 = -1;

        boolean bPassed = false;

        CObject roTempPtr;
        short roTempNumber = 0;
        short i, j;
        int Loop2;
        if (oilPtr1.oilEventCount == ho.hoAdRunHeader.rhEvtProg.rh2EventCount)
        {
            if (param2 != null)
            {
                FValue1 = lyrGetFVfromOIL(lyrGetOILfromEVP(param1));
                for (i = 1; i <= oilPtr1.oilNumOfSelected; i++)
                {
                    bMatch = false;

                    FValue2 = lyrGetFVfromOIL(lyrGetOILfromEVP(param2));

                    boolean DoLevel2;

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
                                FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
                            }
                        }
                        else
                        {
                            if (roPtr2.hoNumNext > -1)
                            {
                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNumNext];
                                FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
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
                        FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
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
                        FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
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

                    boolean DoLevel2;

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
                                FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
                            }
                        }
                        else
                        {
                            if (roPtr2.hoNumNext > -1)
                            {
                                roPtr2 = ho.hoAdRunHeader.rhObjectList[roPtr2.hoNumNext];
                                FValue2 = (roPtr2.hoCreationId << 16) + ((roPtr2.hoNumber) & 0xFFFF);
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
                        FValue1 = (roPtr1.hoCreationId << 16) + ((roPtr1.hoNumber) & 0xFFFF);
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
            roTempPtr.hoNextSelected = -32768;
        }
        return bPassed;
    }

    boolean doCondition(int cond, int param1, int param2)
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

class CSortData
{
    CSprite indexSprite;
    int sprX;
    int sprY;
    int sprAlt;
    int cmpFlag;
}
