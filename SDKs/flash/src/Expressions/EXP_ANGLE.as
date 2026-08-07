package Expressions {
import RunLoop.CRun;

public class EXP_ANGLE extends CExp
{
    public override function evaluate(rhPtr:CRun):void {
        rhPtr.rh4CurToken++;
        var x1:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var y1:int= rhPtr.getExpression().getInt();
        var angle:Number= Math.atan2(-y1, x1)*180.0/Math.PI;
        if (angle<0)
            angle=360+angle;
		rhPtr.getCurrentResult().forceInt(int((angle)));
    }
}
}