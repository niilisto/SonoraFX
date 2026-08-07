//----------------------------------------------------------------------------------
//
// CANIM : definition d'une animation
//
//----------------------------------------------------------------------------------

package Animations
{
	import Banks.IEnum;
	
	import Services.CFile;
	
	public class CAnim
	{
	    // Definition of animation codes
	    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    public static var ANIMID_STOP:int=0;
	    public static var ANIMID_WALK:int=1;
	    public static var ANIMID_RUN:int=2;
	    public static var ANIMID_APPEAR:int=3;
	    public static var ANIMID_DISAPPEAR:int=4;
	    public static var ANIMID_BOUNCE:int=5;
	    public static var ANIMID_SHOOT:int=6;
	    public static var ANIMID_JUMP:int=7;
	    public static var ANIMID_FALL:int=8;
	    public static var ANIMID_CLIMB:int=9;
	    public static var ANIMID_CROUCH:int=10;
	    public static var ANIMID_UNCROUCH:int=11;
	    public static var ANIMID_USER1:int=12;

	    // Table des animations n'ayant qu'une seule vitesse
	    // -------------------------------------------------
	    public var tableAnimTwoSpeeds:Array=
		[
			0,     			                 // 0  ANIMID_STOP
			1,                                       // 1  ANIMID_WALK
			1,                                       // 2  ANIMID_RUN
			0,                                       // 3  ANIMID_APPEAR
			0,                                       // 4  ANIMID_DISAPPEAR
			1,                                       // 5  ANIMID_BOUNCE
			0,                                       // 6  ANIMID_SHOOT
			1,                                       // 7  ANIMID_JUMP
			1,                                       // 8  ANIMID_FALL
			1,                                       // 9  ANIMID_CLIMB
			1,                                       // 10 ANIMID_CROUCH
			1,                                       // 11 ANIMID_UNCROUCH
			1,                                       // 12
			1,                                       // 13
			1,                                       // 14
			1                                        // 15
		];

	    public var anDirs:Array;
	    public var anTrigo:Array;
	    public var anAntiTrigo:Array;

		public function CAnim()
		{
		}

	    public function load(file:CFile):void
	    {
	        var debut:int=file.getFilePointer();
	        
	        var offsets:Array=new Array(32);
	        var n:int;
	        for (n=0; n<32; n++)
	        {
	            offsets[n]=file.readAShort();
	        }
	        
	        anDirs=new Array(32);
	        anTrigo=new Array(32);
	        anAntiTrigo=new Array(32);
	        for (n=0; n<32; n++)
	        {
	            anDirs[n]=null;
	            anTrigo[n]=0;
	            anAntiTrigo[n]=0;
	            if (offsets[n]!=0)
	            {
	                anDirs[n]=new CAnimDir();
	                file.seek(debut+offsets[n]);
	                anDirs[n].load(file);
	            }
	        }
	    }
	    public function enumElements(enumImages:IEnum):void
	    {
	        var n:int;
	        for (n=0; n<32; n++)
	        {
	            if (anDirs[n]!=null)
	            {
	                anDirs[n].enumElements(enumImages);
	            }
	        }
	    }
	    public function approximate(nAnim:int):void
	    {      
			// Animation definie: travaille les directions non definies
			var d:int, d2:int, d3:int;
			var cpt1:int, cpt2:int;
			
	        // Boucle d'exploration des directions
			for (d=0; d<32; d++)
			{
	            if (anDirs[d]==null)
	            {
					// Boucle d'exploration sens trigonometrique
					for (d2=0, cpt1=d+1; d2<32; d2++, cpt1++)
					{
	                    cpt1=cpt1&0x1F;
	                    if (anDirs[cpt1]!=null)
	                    {
	                        anTrigo[d]=cpt1;
							break;
	                    }
	                }
					// Boucle d'exploration sens anti-trigonometrique
					for (d3=0, cpt2=d-1; d3<32; d3++, cpt2--)
					{
	                    cpt2=cpt2&0x1F;
	                    if (anDirs[cpt2]!=null)
	                    {
	                        anAntiTrigo[d]=cpt2;
							break;
			            }
					}
					if (cpt1==cpt2 || d2<d3)						//; Les deux pointent sur la meme
					{
	                    anTrigo[d]|=0x40;								//; Trigo plus proche
	                }
					else if (d3<d2)
					{
	                    anAntiTrigo[d]|=0x40;								//; Anti-trigo plus proche
					}
	            }
	            else
	            {
					// Egalise la vitesse maxi avec la vitesse mini si necessaire
					if (nAnim<16)
					{
	                    if (tableAnimTwoSpeeds[nAnim]==0)
	                    {
							anDirs[d].adMinSpeed=anDirs[d].adMaxSpeed;
	                    }
					}
	            }
			}
    	}
	}
}