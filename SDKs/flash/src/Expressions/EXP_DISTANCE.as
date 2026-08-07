package Expressions {
import RunLoop.CRun;

public class EXP_DISTANCE extends CExp
{
    public override function evaluate(rhPtr:CRun):void {
        rhPtr.rh4CurToken++;
        var x1:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var y1:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var x2:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var y2:int= rhPtr.getExpression().getInt();
        var deltaX:int=x2-x1;
        var deltaY:int=y2-y1;
        var result:CValue= new CValue(0);
		rhPtr.getCurrentResult().forceInt(int(Math.floor(Math.sqrt(deltaX*deltaX+deltaY*deltaY))));
    }
}
}