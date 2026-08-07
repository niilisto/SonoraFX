
//----------------------------------------------------------------------------------
//
// PARAM_EXPRESSION : une expression
//
//----------------------------------------------------------------------------------
package Params
{
	import Application.*;
	
	public class PARAM_EXPRESSION extends CParamExpression
	{
		public function PARAM_EXPRESSION()
		{
		}
	    public override function load(app:CRunApp):void
	    {
	        comparaison=app.file.readAShort();
	        loadExpression(app, app.file);
	    }    
	}
}