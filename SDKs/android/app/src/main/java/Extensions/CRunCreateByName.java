package Extensions;

import java.util.Arrays;

import Actions.CActExtension;
import Application.CRunFrame;
import Banks.CImage;
import Expressions.CValue;
import Frame.CLO;
import Frame.CLayer;
import OI.COCBackground;
import OI.COI;
import Objects.CObject;
import RunLoop.CBkd2;
import RunLoop.CCreateObjectInfo;
import RunLoop.CObjInfo;
import Services.CBinaryFile;
import Sprites.CColMask;
import Sprites.CMask;
import Sprites.CSprite;
import Sprites.CSpriteGen;
import Params.CPositionInfo;

public class CRunCreateByName extends CRunExtension {

	final static int ACT_CREATEOBJ_AT_POS = 0;
	final static int ACT_CREATEOBJ_AT_XY = 1;
	final static int ACT_CREATEBKD_AT_POS = 2;
	final static int ACT_CREATEBKD_AT_XY = 3;
	final static int EXP_GETNAMEFROMFIXED = 0;

	private CValue ret;


	public CRunCreateByName() 
	{
		ret = new CValue(0);
	}

	@Override 
	public int getNumberOfConditions()
	{
		return 0;
	}

	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		return true;
	}

	@Override
	public void action(int num, CActExtension act)
	{
		String name;
		int x, y, layer, type;
		CPositionInfo position;

		switch (num)
		{
		case ACT_CREATEOBJ_AT_POS:
		{
			name = act.getParamExpString(rh, 0);
			position = act.getParamPosition(rh, 1);
			layer = act.getParamExpression(rh, 2);
			createObject(name, position.x, position.y, layer);
			break;
		}
		case ACT_CREATEOBJ_AT_XY:
		{
			name = act.getParamExpString(rh, 0);
			x = act.getParamExpression(rh, 1);
			y = act.getParamExpression(rh, 2);
			layer = act.getParamExpression(rh, 3);
			createObject(name, x, y, layer);
			break;
		}
		case ACT_CREATEBKD_AT_POS:
		{
			name = act.getParamExpString(rh, 0);
			position = act.getParamPosition(rh, 1);
			type = act.getParamExpression(rh, 2);
			layer = act.getParamExpression(rh, 3);
			createBackdrop(name, position.x, position.y, type, layer);
			break;
		}
		case ACT_CREATEBKD_AT_XY:
		{
			name = act.getParamExpString(rh, 0);
			x = act.getParamExpression(rh, 1);
			y = act.getParamExpression(rh, 2);
			type = act.getParamExpression(rh, 3);
			layer = act.getParamExpression(rh, 4);
			createBackdrop(name, x, y, type, layer);
			break;
		}
		}
	}

	// Expressions
	// -------------------------------------------------
	@Override
	public CValue expression(int num)
	{
		if(num == EXP_GETNAMEFROMFIXED)
		{
			int fixed = ho.getExpParam().getInt();
			CObject obj = ho.getObjectFromFixed(fixed);
			if (obj != null)
			{
				ret.forceString(obj.hoOiList.oilName);
				return ret;
			}
		}
		ret.forceString("");
		return ret;
	}

	public void createObject(String objName, int x, int y, int layer)
	{
		int creationOi = -1;
		for(int i=0; i<rh.rhMaxOI; ++i)
		{
			CObjInfo info = rh.rhOiList[i];
			if(info.oilName.contentEquals(objName))
			{
				creationOi = info.oilOi;
				break;
			}
		}
		if(creationOi == -1)
			return;

		if(layer >= rh.rhFrame.nLayers)
			layer = rh.rhFrame.nLayers-1;
		if(layer < -1)
			layer = -1;

		int number=rh.f_CreateObject((short)rh.rhMaxOI, (short)creationOi, x, y, 0, (short)0, layer, -1);
		if (number>=0)
		{
			CObject pHo=rh.rhObjectList[number];
			rh.rhEvtProg.evt_AddCurrentObject(pHo);
		}
	}

	public void createBackdrop(String objName, int x, int y, int type, int layer)
	{
		CRunFrame frame = rh.rhFrame;

		// Find backdrop
		for(int i=0; i<frame.nLayers; ++i)
		{
			CLayer clayer = frame.layers[i];
			for(int j=0; j<clayer.nBkdLOs; ++j)
			{
				CLO plo =  frame.LOList.getLOFromIndex((short)(clayer.nFirstLOIndex + j));
				COI info = rh.rhApp.OIList.getOIFromHandle(plo.loOiHandle);
				if(info.oiName.contentEquals(objName))
				{
					COCBackground backdrop = (COCBackground)info.oiOC;
					short imageHandle = backdrop.ocImage;
					CBkd2 toadd = new CBkd2();
					toadd.img = imageHandle;
					CImage ifo = rh.rhApp.imageBank.getImageFromHandle(toadd.img);
					toadd.loHnd = 0;
					toadd.oiHnd = 0;
					toadd.x = x;
					toadd.y = y;
					toadd.width = 1;
					toadd.height = 1;

					if(ifo != null) {
						toadd.width = ifo.getWidth();
						toadd.height = ifo.getHeight();
					}
					else {
						toadd.width = backdrop.ocCx;
						toadd.height = backdrop.ocCy;
					}

					toadd.spriteFlag = CSprite.SF_NOHOTSPOT;
					toadd.nLayer = (short) layer;
					toadd.body = null;

					toadd.obstacleType = (short) type;	// a voir
					toadd.colMode = backdrop.ocColMode;

					Arrays.fill(toadd.pSpr, null);

					toadd.inkEffect = 0;
					toadd.inkEffectParam = 0;

					rh.addBackdrop2(toadd);

					// Build 284.11: if "not an obstacle" and layer 0, paste collision mask
					if ( type == 0 && toadd.nLayer == 0 && rh.rhFrame.colMask != null && ifo != null )
					{
						if (toadd.colMode==CSpriteGen.CM_BOX)
						{
							rh.rhFrame.colMask.fillRectangle(toadd.x, toadd.y, toadd.x+toadd.width, toadd.y+toadd.height, type);
						}
						else
						{
							CMask mask;
							mask = ifo.getMask(CMask.GCMF_OBSTACLE, 0, 1.0, 1.0);
							if ( mask != null )
								rh.rhFrame.colMask.orMask(mask, toadd.x, toadd.y, CColMask.CM_OBSTACLE | CColMask.CM_PLATFORM, type);
						}
					}
				}
			}
		}
	}

}
