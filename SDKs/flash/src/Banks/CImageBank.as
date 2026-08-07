//----------------------------------------------------------------------------------
//
// CIMAGEBANK : Stockage des images
//
//----------------------------------------------------------------------------------
package Banks
{
	import Application.CRunApp;
	
	import Services.*;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class CImageBank implements IEnum
	{
	    public var app:CRunApp;
	    public var file:CFile;
	    public var images:Array;
	    public var nHandlesReel:int;
	    public var nHandlesTotal:int;
	    public var nImages:int;
	    private var offsetsToImage:Array;
	    private var handleToIndex:Array;
	    private var useCount:Array;
		private var rcInfo:CRect=null;
		private var hsInfo:CPoint=null;
		private var apInfo:CPoint=null;
		
		public function CImageBank(a:CRunApp)
		{
			app=a;
		}
	    public function preLoad(f:CFile):void
	    {
			file=f;
		
			// Nombre de handles
			nHandlesReel=file.readAShort();
			offsetsToImage=new Array(nHandlesReel);
			
			// Repere les positions des images
			var nImg:int=file.readAShort();
			var n:int;
			var offset:int;
			var image:CImage=new CImage();
			for (n=0; n<nImg; n++)
			{
			    offset=file.getFilePointer();
			    image.loadHandle(file);
			    offsetsToImage[image.handle]=offset;
			}
			
			// Reservation des tables
			useCount=new Array(nHandlesReel);
			resetToLoad();
			handleToIndex=null;
			nHandlesTotal=nHandlesReel;
			nImages=0;
			images=null;
	    }
	    public function getImageFromHandle(handle:int):CImage
	    {
			if (handle>=0 && handle<nHandlesTotal)
			    if (handleToIndex[handle]!=-1)
				return images[handleToIndex[handle]];
			return null;
	    }
	    public function getImageFromIndex(index:int):CImage
	    {
			if (index>=0 && index<nImages)
			    return images[index];
			return null;
	    }
	    public function resetToLoad():void
	    {
			var n:int;
			for (n=0; n<nHandlesReel; n++)
			{
			    useCount[n]=0;
			}
	    }
	    
	    public function setToLoad(handle:int):void
	    {
			useCount[handle]++;
	    }
	    
	    // Entree enumeration
	    public function enumerate(num:int):int
	    {
			setToLoad(num);
			return -1;
	    }

	    public function load(file:CFile):void
	    {
			var n:int;
			
			// Combien d'images?
			nImages=0;
			for (n=0; n<nHandlesReel; n++)
			{
			    if (useCount[n]!=0)
					nImages++;
			}
		
			// Charge les images
			var newImages:Array=new Array(nImages);
			var count:int=0;
			var h:int;
			for (h=0; h<nHandlesReel; h++)
			{
			    if (useCount[h]!=0)
			    {
					if (images!=null && handleToIndex[h]!=-1 && images[handleToIndex[h]]!=null)
					{
					    newImages[count]=images[handleToIndex[h]];
					    newImages[count].useCount=useCount[h];
					}
					else
					{
						if (offsetsToImage[h]!=0)
						{
							newImages[count]=new CImage();
							file.seek(offsetsToImage[h]);
							newImages[count].load(file);
							newImages[count].useCount=useCount[h];
						}
					}
					count++;
			    }
			}
			images=newImages;
		
			// Cree la table d'indirection
			handleToIndex=new Array(nHandlesReel);
			for (n=0; n<nHandlesReel; n++)
			{
			    handleToIndex[n]=-1;
			}
			for (n=0; n<nImages; n++)
			{
				if (images[n]!=null)
				{
					handleToIndex[images[n].handle]=n;
				}
			}
			nHandlesTotal=nHandlesReel;
			
			// Plus rien a charger
			resetToLoad();
	    }
	    // Detruit une image si plus d'utilisation
	    public function delImage(handle:int):void
	    {
			var img:CImage=getImageFromHandle(handle);
			if (img!=null)
			{
			    img.useCount--;
			    if (img.useCount<=0)
			    {
					var n:int;
					for (n=0; n<nImages; n++)
					{
					    if (images[n]==img)
					    {
							images[n]=null;
							handleToIndex[handle]=-1;
							break;
					    }
					}
			    }
			}
	    }
	    public function addImageCompare(newImage:BitmapData, xSpot:int, ySpot:int, xAP:int, yAP:int):int
	    {
			var i:int;
			var newPixels:ByteArray;
            var width:int=newImage.width;
            var height:int=newImage.height;
			for (i=0; i<nImages; i++)
			{
	            if (images[i]!=null)
	            {
	                if (images[i].xSpot==xSpot && images[i].ySpot==ySpot && images[i].xAP==xAP && images[i].yAP==yAP)
	                {
	                    if (width==images[i].img.width && height==images[i].img.height)
	                    {
	                        // Prend les pixels de la nouvelle image
	                        if (newPixels==null)
	                        {
	                        	var newRect:Rectangle=new Rectangle(0, 0, width, height);
	                        	newPixels=newImage.getPixels(newRect);
	                        }
	
	                        // Prend les pixels de l'image de la banque
	                        var oldRect:Rectangle=new Rectangle(0, 0, width, height);
	                        var oldPixels:ByteArray=images[i].img.getPixels(oldRect);
	
	                        // Comparaison
	                        var bEqual:Boolean=true;
	                        var x:int, y:int;
	                        for (y=0; y<height; y++)
	                        {
	                            for (x=0; x<width; x++)
	                            {
	                                if (newPixels[y*width+x]!=oldPixels[y*width+x])
	                                {
	                                    bEqual=false;
	                                    break;
	                                }
	                            }
	                            if (bEqual==false)
	                            {
	                            	break;
	                            }
	                        }
	
	                        // Image trouvee
	                        if (bEqual)
	                        {
	                            images[i].useCount++;
	                            return images[i].handle;
	                        }
	                    }
	                }
	            }
			}
			return addImage(newImage, xSpot, ySpot, xAP, yAP, 1);
	    }
	    public function addImage(img:BitmapData, xSpot:int, ySpot:int, xAP:int, yAP:int, count:int):int
	    {
			var h:int;
			
			// Cherche un handle libre
			var hFound:int=-1;
			for (h=nHandlesReel; h<nHandlesTotal; h++)
			{
			    if (handleToIndex[h]==-1)
			    {
					hFound=h;
					break;
			    }		
			}
		
			// Rajouter un handle
			if (hFound==-1)
			{
			    var newHToI:Array=new Array(nHandlesTotal+10);
			    for (h=0; h<nHandlesTotal; h++)
			    {
					newHToI[h]=handleToIndex[h];
			    }
			    for (; h<nHandlesTotal+10; h++)
			    {
					newHToI[h]=-1;
			    }
			    hFound=nHandlesTotal;
			    nHandlesTotal+=10;
			    handleToIndex=newHToI;
			}
			
			// Cherche une image libre
			var i:int;
			var iFound:int=-1;
			for (i=0; i<nImages; i++)
			{
			    if (images[i]==null)
			    {
					iFound=i;
					break;
			    }
			}		
			
			// Rajouter une image?
			if (iFound==-1)
			{
			    var newImages:Array=new Array(nImages+10);
			    for (i=0; i<nImages; i++)
			    {
					newImages[i]=images[i];
			    }
			    for (; i<nImages+10; i++)
			    {
					newImages[i]=null;
			    }
			    iFound=nImages;
			    nImages+=10;
			    images=newImages;
			}
			
			// Ajoute la nouvelle image
			handleToIndex[hFound]=iFound;
			images[iFound]=new CImage();
			images[iFound].handle=hFound;
			images[iFound].img=img;
			images[iFound].xSpot=xSpot;
			images[iFound].ySpot=ySpot;
			images[iFound].xAP=xAP;
			images[iFound].yAP=yAP;
			images[iFound].useCount=count;
			images[iFound].width=img.width;
			images[iFound].height=img.height;
			
			return hFound;
	    }
	    public function loadImageList(handles:Array):void 
	    {
			var h:int;
		
			for (h=0; h<handles.length; h++)
			{
	            if (handles[h]>=0 && handles[h]<nHandlesTotal)
	            {
	                if (offsetsToImage[handles[h]]!=0)
	                {
		        	    if (getImageFromHandle(handles[h])==null)
	                    {	
	                        // Cherche une image libre
	                        var i:int;
	                        var iFound:int=-1;
	                        for (i=0; i<nImages; i++)
	                        {
	                            if (images[i]==null)
	                            {
	                                iFound=i;
	                                break;
	                            }
	                        }		
	                        // Rajouter une image?
	                        if (iFound==-1)
	                        {
	                            var newImages:Array=new Array(nImages+10);
	                            for (i=0; i<nImages; i++)
	                            {
	                                newImages[i]=images[i];
	                            }
	                            for (; i<nImages+10; i++)
	                            {
	                                newImages[i]=null;
	                            }
	                            iFound=nImages;
	                            nImages+=10;
	                            images=newImages;
	                        }
	                        // Ajoute la nouvelle image
	                        handleToIndex[handles[h]]=iFound;
	                        images[iFound]=new CImage();
	                        images[iFound].useCount=1;
                            file.seek(offsetsToImage[handles[h]]);
                            images[iFound].load(file);
	                    }
	                }
	            }
			}                
	    }
	    
	    public function getImageInfoEx ( nImage:int, nAngle:int, fScaleX:Number, fScaleY:Number ):CImage
	    {
			var ptei:CImage;
	        var pIfo:CImage=new CImage();
	            
	        ptei = getImageFromHandle(nImage);
			if ( ptei != null )
			{
				var cx:int = ptei.width;
				var cy:int = ptei.height;
				var hsx:int = ptei.xSpot;
				var hsy:int = ptei.ySpot;
				var asx:int = ptei.xAP;
				var asy:int = ptei.yAP;
		
				// No rotation
				if ( nAngle == 0 )
				{
					// Stretch en X
					if ( fScaleX != 1.0 )
					{
						hsx = int(hsx * fScaleX);
						asx = int(asx * fScaleX);
						cx = int(cx * fScaleX);
					}
		
					// Stretch en Y
					if ( fScaleY != 1.0 )
					{
						hsy = int(hsy * fScaleY);
						asy = int(asy * fScaleY);
						cy = int(cy * fScaleY);
					}
				}
				// Rotation
				else
				{
					// Calculate dimensions
					if ( fScaleX != 1.0 )
					{
						hsx = int(hsx * fScaleX);
						asx = int(asx * fScaleX);
						cx = int(cx * fScaleX);
					}
		
					if ( fScaleY != 1.0 )
					{
						hsy = int(hsy * fScaleY);
						asy = int(asy * fScaleY);
						cy = int(cy * fScaleY);
					}
		
					if (rcInfo==null)
					{
						rcInfo=new CRect();
					}
					if (hsInfo==null)
					{
						hsInfo=new CPoint();
					}
					if (apInfo==null)
					{
						apInfo=new CPoint();
					}
					hsInfo.x = hsx;
					hsInfo.y = hsy;
					apInfo.x = asx;
					apInfo.y = asy;
					rcInfo.left = rcInfo.top = 0;
					rcInfo.right = cx;
					rcInfo.bottom = cy;
					doRotateRect(rcInfo, hsInfo, apInfo, nAngle);
					cx = rcInfo.right;
					cy = rcInfo.bottom;
					hsx = hsInfo.x;
					hsy = hsInfo.y;
					asx = apInfo.x;
					asy = apInfo.y;
				}		
				pIfo.width = cx;
				pIfo.height = cy;
				pIfo.xSpot = hsx;
				pIfo.ySpot = hsy;
				pIfo.xAP = asx;
				pIfo.yAP = asy;
		
	            return pIfo;
			}
			return null;
    	}

		public static function doRotateRect(prc:CRect, pHotSpot:CPoint, pActionPoint:CPoint, fAngle:Number):void
		{
			var x:Number, y:Number;	// , xo, yo;
			var cosa:Number, sina:Number;
		
			if ( fAngle == 90.0 )
			{
				cosa = 0.0;
				sina = 1.0;
			}
			else if ( fAngle == 180.0 )
			{
				cosa = -1.0;
				sina = 0.0;
			}
			else if ( fAngle == 270.0 )
			{
				cosa = 0.0;
				sina = -1.0;
			}
			else
			{
				var arad:Number = Number(fAngle * Math.PI / 180.0);
				cosa = Math.cos(arad);
				sina = Math.sin(arad);
			}
		
			// Rotate top-left point
			var topLeftX:Number;
			var topLeftY:Number;
		
			// Ditto, optimized
			var nhxcos:Number;
			var nhxsin:Number;
			var nhycos:Number;
			var nhysin:Number;
			if ( pHotSpot == null )
			{
				nhxcos = nhxsin = nhycos = nhysin = 0.0;
				topLeftX = topLeftY = 0;
			}
			else
			{
				nhxcos = -pHotSpot.x * cosa;
				nhxsin = -pHotSpot.x * sina;
				nhycos = -pHotSpot.y * cosa;
				nhysin = -pHotSpot.y * sina;
				topLeftX = nhxcos + nhysin;
				topLeftY = nhycos - nhxsin;
			}
		
			// Rotate top-right point
			var topRightX:Number;
			var topRightY:Number;
		
			// Ditto, optimized
			if ( pHotSpot == null )
				x = Number(prc.right);
			else
				x = Number(prc.right - pHotSpot.x);
			nhxcos = x * cosa;
			nhxsin = x * sina;
			topRightX = nhxcos + nhysin;
			topRightY = nhycos - nhxsin;
		
			// Rotate bottom-right point
			var bottomRightX:Number;
			var bottomRightY:Number;
		
			// Ditto, optimized
			if ( pHotSpot == null )
				y = Number(prc.bottom);
			else
				y = Number(prc.bottom - pHotSpot.y);
			nhycos = y * cosa;
			nhysin = y * sina;
			bottomRightX = nhxcos + nhysin;
			bottomRightY = nhycos - nhxsin;
		
			// Bottom-left
			var bottomLeftX:Number;
			var bottomLeftY:Number;
			bottomLeftX = topLeftX + bottomRightX - topRightX;
			bottomLeftY = topLeftY + bottomRightY - topRightY;
		
			// Get limits
			var xmin:Number = Math.min(topLeftX, Math.min(topRightX, Math.min(bottomRightX, bottomLeftX)));
			var ymin:Number = Math.min(topLeftY, Math.min(topRightY, Math.min(bottomRightY, bottomLeftY)));
			var xmax:Number = Math.max(topLeftX, Math.max(topRightX, Math.max(bottomRightX, bottomLeftX)));
			var ymax:Number = Math.max(topLeftY, Math.max(topRightY, Math.max(bottomRightY, bottomLeftY)));
		
			// Update action point position
			if ( pActionPoint != null )
			{
				if ( pHotSpot == null )
				{
					x = Number(pActionPoint.x);
					y = Number(pActionPoint.y);
				}
				else
				{
					x = Number(pActionPoint.x - pHotSpot.x);			// coordinates relative to hot spot
					y = Number(pActionPoint.y - pHotSpot.y);
				}
				pActionPoint.x = int((x * cosa + y * sina) - xmin);
				pActionPoint.y = int((y * cosa - x * sina) - ymin);
			}
		
			// Update hotspot position
			if ( pHotSpot != null )
			{
				pHotSpot.x = -xmin;
				pHotSpot.y = -ymin;
			}
		
			// Update rectangle
			prc.right = xmax - xmin;
			prc.bottom = ymax - ymin;
		}
	}
}
