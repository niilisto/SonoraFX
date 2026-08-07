package Extensions;

import java.util.ArrayList;

import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import Objects.CObject;
import RunLoop.CCreateObjectInfo;
import RunLoop.CRunBaseParent;
import RunLoop.CRunMBase;
import Services.CBinaryFile;
import Services.CFontInfo;
import Services.CRect;
import Sprites.CMask;

import com.badlogic.gdx.physics.box2d.Body;

public class CRunBox2DBaseParent extends CRunBaseParent
{
    public CRunBox2DBase base;
    public CRunBox2DBaseParent parent;
    public CRunBox2DBaseElementParent currentParticule1;
    public CRunBox2DBaseElementParent currentParticule2;
    public CRunBox2DBaseElementParent currentElement;
    public CObject collidingHO;
    //public CRunMBase currentObject;
    public boolean stopped;
    public ArrayList<CRunBox2DBaseElementParent> particules;
    public ArrayList<CRunBox2DBaseElementParent> toDestroy;
    public short gObstacle = 0;
    public short gDirection = 0;
    public float gFriction = 0;
    public float gRestitution = 0;


    @Override
    public int getNumberOfConditions()
    {
        return 0;
    }

    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        return false;
    }

    @Override
    public int handleRunObject()
    {
        return REFLAG_ONESHOT;
    }

    @Override
    public void displayRunObject()
    {
    }

    @Override
    public void reinitDisplay ()
    {
    }

    @Override
    public void destroyRunObject(boolean bFast)
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

    @Override
    public void getZoneInfos()
    {
    }

    @Override
    public boolean condition(int num, CCndExtension cnd)
    {
        return false;
    }

    @Override
    public void action(int num, CActExtension act)
    {
    }

    @Override
    public CValue expression(int num)
    {
        return new CValue(0);
    }

    @Override
    public CMask getRunObjectCollisionMask(int flags)
    {
        return null;
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
	public boolean rStartObject()
    {
        return false;
    }

    @Override
	public void rAddNormalObject(CObject pHo)
    {
    }

    @Override
	public void rAddObject(CRunMBase mBase)
    {
    }

    @Override
	public void rRemoveObject(CRunMBase mBase)
    {
    }

    @Override
	public Body rCreateBullet(float angle, float speed, CRunMBase pMBase)
    {
        return null;
    }
    @Override
	public void rDestroyBody(Body body)
    {
    }
}
