package Expressions {
import RunLoop.CRun;

public class EXP_RANGE extends CExp
{
    public override function evaluate(rhPtr:CRun):void {
        
		var vValue:CValue;
		var aValue:CValue;
		var bValue:CValue;
		
		rhPtr.rh4CurToken++;
        vValue = new CValue(rhPtr.getExpression().intValue);
        
		rhPtr.rh4CurToken++;		
        aValue = new CValue(rhPtr.getExpression().intValue);
        
		rhPtr.rh4CurToken++;		
        bValue = new CValue(rhPtr.getExpression().intValue);
		
        if (vValue.getType()==CValue.TYPE_INT)
        {
            var irvalue:int=vValue.getInt();
            var irminimum:int=aValue.getInt();
            var irmaximum:int=bValue.getInt();
            irvalue=Math.max(irvalue, irminimum);
            irvalue=Math.min(irvalue, irmaximum);
			rhPtr.getCurrentResult().forceInt(irvalue);
        }
        else
        {
            var nrvalue:Number=vValue.getDouble();
            var nrminimum:Number=aValue.getDouble();
            var nrmaximum:Number=bValue.getDouble();
            nrvalue=Math.max(nrvalue, nrminimum);
            nrvalue=Math.min(nrvalue, nrmaximum);
			rhPtr.getCurrentResult().forceDouble(nrvalue);
        }
    }
}
}