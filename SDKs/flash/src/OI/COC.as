//----------------------------------------------------------------------------------
//
// COC: classe abstraite d'objectsCommon
//
//----------------------------------------------------------------------------------
package OI
{
	import Banks.IEnum;	
	import Services.CFile;
	
	public class COC
	{
    	public var ocObstacleType:int;		// Obstacle type
    	public var ocColMode:int;			// Collision mode (0 = fine, 1 = box)
    	public var ocCx:int;				// Size
    	public var ocCy:int;
		
    	public static var OBSTACLE_NONE:int=0;
    	public static var OBSTACLE_SOLID:int=1;
    	public static var OBSTACLE_PLATFORM:int=2;
    	public static var OBSTACLE_LADDER:int=3;
    	public static var OBSTACLE_TRANSPARENT:int=4;
		
		public function COC()
		{
		}
    	public function load(file:CFile, type:int):void
    	{
    	}
    	public function enumElements(enumImages:IEnum, enumFonts:IEnum):void
    	{    		
    	}
	}
}