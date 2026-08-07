// ------------------------------------------------------------------------------
// 
// INTERFACE CNDEVAL pour l'exploration des objets d'une condition
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import RunLoop.*;
	import Objects.*;
	
	public interface ICndEval
	{
	    public function eval(rhPtr:CRun, hoPtr:CObject):Boolean
	}
}