// -----------------------------------------------------------------------------
//
// REPLACE COLOR, routines
//
// -----------------------------------------------------------------------------
package Actions
{
	import Banks.*;
	
	import OI.*;
	
	import Objects.*;
	
	import Params.*;
	
	import RunLoop.*;
	
	import Services.*;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class CActReplaceColor implements IEnum
	{
	    public var mode:int;
	    public var dwMax:int;
	    public var pImages:Array;
	    public var pRh:CRun;
	    
	    public function execute(rhPtr:CRun, pHo:CObject, newColor:int, oldColor:int):void
	    {
			// Changement des couleurs
			// ----------------------------------------------------------------------------
			pRh=rhPtr;
			var oi:int = pHo.hoOi;
			var poi:COI = rhPtr.rhApp.OIList.getOIFromHandle(oi);
			if (poi==null)
			    return;
		
			// Get image max
			dwMax = -1;
			mode=0;
			poi.enumElements(this, null);
		
			// Rechercher le premier
			var pHoFirst:CObject=pHo;
			while ((pHoFirst.hoNumPrev & 0x80000000) == 0)
			    pHoFirst = rhPtr.rhObjectList[pHoFirst.hoNumPrev & 0x7FFFFFFF];
	
			// Parcourir la liste
			do 
			{
			    if ( pHoFirst.roc.rcImage!=-1 && pHoFirst.roc.rcImage>dwMax )
					dwMax = pHoFirst.roc.rcImage;
			    if ( pHoFirst.roc.rcOldImage!=-1 && pHoFirst.roc.rcOldImage>dwMax )
					dwMax = pHoFirst.roc.rcOldImage;
		
			    // Le dernier?
			    if ( (pHoFirst.hoNumNext & 0x80000000) != 0 )
					break;
		
			    // Next OI
			    pHoFirst=rhPtr.rhObjectList[pHoFirst.hoNumNext];
		
			} while (true);
	
			// Allocate memory
			pImages=new Array(dwMax+1);
			var n:int;
			for (n=0; n<dwMax+1; n++)
			{
			    pImages[n]=-1;
			}
	
			// List all images
			mode=1;
			poi.enumElements(this, null);
		
			// Replace color in all images and create new images
			var i:int;
			var newImg:int;
			for (i=0; i<=dwMax; i++)
			{
			    if ( pImages[i] == -1 )
					continue;
		
			    var sourceImg:CImage=rhPtr.rhApp.imageBank.getImageFromHandle(i);
				var destImg:BitmapData=CServices.replaceColor(rhPtr.rhApp, sourceImg.img, oldColor, newColor);
			    if (destImg!=null)
			    {
					// Create new image in the bank
					newImg = rhPtr.rhApp.imageBank.addImage(destImg, sourceImg.xSpot, sourceImg.ySpot, sourceImg.xAP, sourceImg.yAP, 0);
					pImages[i] = newImg;
			    }
			}
	
			// Remplacer images dans les objets de m�me OI
			pHoFirst=pHo;
			while ((pHoFirst.hoNumPrev & 0x80000000) == 0)
			    pHoFirst = rhPtr.rhObjectList[pHoFirst.hoNumPrev & 0x7FFFFFFF];
	
			// Parcourir la liste
			do 
			{
			    if ( pHoFirst.roc.rcImage!=-1 && pImages[pHoFirst.roc.rcImage]!=-1 )
			    {
					pHoFirst.roc.rcImage = pImages[pHoFirst.roc.rcImage];
			    }
			    if ( pHoFirst.roc.rcOldImage!=-1 && pImages[pHoFirst.roc.rcOldImage]!=-1 )
			    {
					pHoFirst.roc.rcOldImage = pImages[pHoFirst.roc.rcOldImage];
			    }
			    pHoFirst.modif();
		
			    // Le dernier?
			    if ( (pHoFirst.hoNumNext & 0x80000000) != 0 )
					break;
			    // Next OI
			    pHoFirst=rhPtr.rhObjectList[pHoFirst.hoNumNext];
			    
			} while (true);
	
			mode=2;
			poi.enumElements(this, null);
		
			// Replace old images by new ones
			mode=3;		
			poi.enumElements(this, null);
		
			// Mark OI to reload
			poi.oiLoadFlags |= COI.OILF_TORELOAD;
		
			// Force le redraw
			pHo.roc.rcChanged = true;
	    }
	    
	    public function enumerate(num:int):int
	    {
			switch (mode)
			{
			    // Comptage des images
			    case 0:
					if (num>dwMax)
					    dwMax=num;
					return -1;
			    // Enumeration des images
			    case 1:
					pImages[num]=1;
					return -1;
			    // Destruction des images
			    case 2:
					pRh.rhApp.imageBank.delImage(num);
					return -1;
			    // Incrementation des usecount, remplacement des images
			    case 3:
					var image:CImage=pRh.rhApp.imageBank.getImageFromHandle(pImages[num]);
					image.useCount++;
					return pImages[num];		
			}
			return -1;
	    }
	
	}
}