//----------------------------------------------------------------------------------
//
// CCOLMASK : masque de collision
//
//----------------------------------------------------------------------------------
package Sprites
{
	public class CColMask
	{
	    public static var CM_TEST_OBSTACLE:int=0;
	    public static var CM_TEST_PLATFORM:int=1;
	    public static var CM_OBSTACLE:int=0x0001;
	    public static var CM_PLATFORM:int=0x0002;
	    // Collision mask margins
	    public static var COLMASK_XMARGIN:int=64;
	    public static var COLMASK_YMARGIN:int=16;
	    public static var HEIGHT_PLATFORM:int=6;

		public function CColMask()
		{
		}

	}
}