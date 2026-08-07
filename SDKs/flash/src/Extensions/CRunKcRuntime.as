
package Extensions
{
    import Conditions.*;
    import Expressions.*;

    public class CRunKcRuntime extends CRunExtension
    {
        public override function getNumberOfConditions():int
        {   return 10;
        }
        
        public override function expression(num:int):CValue
        {
            var ret:CValue = new CValue (0);
            ret.forceString ("SWF");
            return ret;
        }
        
        public override function condition(num:int, cnd:CCndExtension):Boolean
        {   return num == 8;
        }
    }
}

