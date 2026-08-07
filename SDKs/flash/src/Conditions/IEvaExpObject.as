// ------------------------------------------------------------------------------
// 
// INTERFACE IEVAEXPOBJECT pour l'exploration des objets d'une condition
// 
// ------------------------------------------------------------------------------
package Conditions
{
	import Objects.*;
	
	public interface IEvaExpObject	
	{
	    function evaExpRoutine(hoPtr:CObject, value:int, comp:int):Boolean    
	}
}