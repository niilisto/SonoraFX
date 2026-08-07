//----------------------------------------------------------------------------------
//
// CANIMHEADER : header d'un ensemble d'animations
//
//----------------------------------------------------------------------------------

package Animations
{
	import Banks.IEnum;
	
	import Services.CFile;
	
	public class CAnimHeader
	{
	    // Table d'approximation des animations
	    // ------------------------------------
	    public static var tableApprox:Array=
	    [
		    CAnim.ANIMID_APPEAR,CAnim.ANIMID_WALK,CAnim.ANIMID_RUN,0,			// 0  ANIMID_STOP
		    CAnim.ANIMID_RUN,CAnim.ANIMID_STOP,0,0,                           	// 1  ANIMID_WALK
		    CAnim.ANIMID_WALK,CAnim.ANIMID_STOP,0,0,                         	// 2  ANIMID_RUN
		    CAnim.ANIMID_STOP,CAnim.ANIMID_WALK,CAnim.ANIMID_RUN,0,				// 3  ANIMID_APPEAR
		    CAnim.ANIMID_STOP,0,0,0,                                          	// 4  ANIMID_DISAPPEAR
		    CAnim.ANIMID_STOP,CAnim.ANIMID_WALK,CAnim.ANIMID_RUN,0,				// 5  ANIMID_BOUNCE
		    CAnim.ANIMID_STOP,CAnim.ANIMID_WALK, CAnim.ANIMID_RUN,0,			// 6  ANIMID_SHOOT
		    CAnim.ANIMID_WALK, CAnim.ANIMID_RUN, CAnim.ANIMID_STOP,0,			// 7  ANIMID_JUMP
		    CAnim.ANIMID_STOP, CAnim.ANIMID_WALK, CAnim.ANIMID_RUN,0,			// 8  ANIMID_FALL
		    CAnim.ANIMID_WALK, CAnim.ANIMID_RUN, CAnim.ANIMID_STOP,0,			// 9  ANIMID_CLIMB
		    CAnim.ANIMID_STOP,CAnim.ANIMID_WALK,CAnim.ANIMID_RUN,0,				// 10 ANIMID_CROUCH
		    CAnim.ANIMID_STOP,CAnim.ANIMID_WALK,CAnim.ANIMID_RUN,0,				// 11 ANIMID_UNCROUCH
		    0, 0, 0, 0,
		    0, 0, 0, 0,
		    0, 0, 0, 0,
		    0, 0, 0, 0
		];

	    public var ahAnimMax:int;
	    public var ahAnims:Array;
	    public var ahAnimExists:Array;

		public function CAnimHeader()
		{
		}
	    public function load(file:CFile):void
	    {
	        var debut:int=file.getFilePointer();
	        
	        file.skipBytes(2);          // ahSize
	        ahAnimMax=file.readAShort();
	        
	        var offsets:Array=new Array(ahAnimMax);
	        var n:int;
	        for (n=0; n<ahAnimMax; n++)
	        {
	            offsets[n]=file.readAShort();
	        }
        
	        ahAnims=new Array(ahAnimMax);
	        ahAnimExists=new Array(ahAnimMax);
	        for (n=0; n<ahAnimMax; n++)
	        {
	            ahAnims[n]=null;
	            ahAnimExists[n]=0;
	            if (offsets[n]!=0)
	            {
	                ahAnims[n]=new CAnim();
	                file.seek(debut+offsets[n]);
	                ahAnims[n].load(file);
	                ahAnimExists[n]=1;
	            }
	        }
        
	        // Approximation des animations
			var cptAnim:int;
			for (cptAnim=0; cptAnim<ahAnimMax; cptAnim++)
			{
	            if (ahAnimExists[cptAnim]==0)
	            {
	                // Animation non definie: recherche dans la table d'approximation
	                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					var bFlag:Boolean=false;
					if (cptAnim<12)                                     // Si une des nouvelles animations, on approxime pas!
					{
	                    for (n=0; n<4; n++)
	                    {
							var a:int=ahAnimExists[tableApprox[cptAnim*4+n]];
                        	if (a!=0)
							{
                            	ahAnims[cptAnim]=ahAnims[tableApprox[cptAnim*4+n]];
                            	bFlag=true;
                            	break;
							}		
                    	}
					}
					if (bFlag==false)
					{
	                    // Pas d'animation disponible: met la premiere trouvee!
	                    for (n=0; n<ahAnimMax; n++)
	                    {
	                    	if (ahAnimExists[n]!=0)
							{
                            	ahAnims[cptAnim]=ahAnims[n];
                            	break;
							}
                    	}
					}
            	}
	            else
	            {
	                ahAnims[cptAnim].approximate(cptAnim);
	            }
	        }     
	    }
	    
	    // Marque les images à charger
	    public function enumElements(enumImages:IEnum):void
	    {
	        var n:int;
	        for (n=0; n<ahAnimMax; n++)
	        {
	            if (ahAnimExists[n]!=0)
	            {		
	                ahAnims[n].enumElements(enumImages);
	            }
	        }
	    }
	}
}