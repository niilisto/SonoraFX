package Extensions;

import Actions.CActExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;

public class CRunStringBuilder extends CRunExtension
{
    StringBuilder builder;
    private CValue expRet;
    
    public CRunStringBuilder() {
    	expRet = new CValue(0);
    	
    }

    @Override
    public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
    {
        builder = new StringBuilder();

        return false;
    }

    @Override
    public void action(int num, CActExtension act)
    {
        switch(num)
        {
            case 0:
                builder.append(act.getParamExpString(rh, 0));
                break;

            case 1:
                builder = new StringBuilder();
                break;
        }
    }

    @Override
    public CValue expression(int num)
    {
        assert(num == 0);

        expRet.forceString(builder.toString());
        return expRet;
    }
}
