// ------------------------------------------------------------------------------
// 
// SCORE
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	import RunLoop.*;
	
	public class CND_SCORE extends CCnd
	{
	    public override function eva1(rhPtr:CRun, hoPtr:CObject):Boolean
	    {
			return eva2(rhPtr);
	    }
	    public override function eva2(rhPtr:CRun):Boolean
	    {
			var scores:Array=rhPtr.rhApp.getScores();
			return compareCondition(rhPtr, 0, scores[evtOi]);
	    }
	}
}