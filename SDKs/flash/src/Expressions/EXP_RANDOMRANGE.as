package Expressions {
import RunLoop.CRun;

public class EXP_RANDOMRANGE extends CExp
{
    public override function evaluate(rhPtr:CRun):void {
        rhPtr.rh4CurToken++;
        var minimum:int= rhPtr.getExpression().getInt();
        rhPtr.rh4CurToken++;
        var maximum:int= rhPtr.getExpression().getInt();
		rhPtr.getCurrentResult().forceInt(minimum+rhPtr.random(int((maximum-minimum+1))));
    }
}
}