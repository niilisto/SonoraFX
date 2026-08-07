//----------------------------------------------------------------------------------
//
// CMASK : un masque
//
//----------------------------------------------------------------------------------
package Sprites
{
	import Application.*;
	
	import Banks.*;
	
	import Services.CPoint;
	import Services.CRect;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public class CMask
	{
	    public var mask:ByteArray;
	    public var lineWidth:int;
	    public var height:int;
	    public var width:int;
	    public var xSpot:int;
	    public var ySpot:int;
	    public static var SCMF_FULL:int=0x0000;
	    public static var SCMF_PLATFORM:int = 0x0001;
	    public static var GCMF_OBSTACLE:int = 0x0000;
	    public static var GCMF_PLATFORM:int = 0x0001;

	    public static var lMask:Array=
	    [
			0xFF,	// 11111111B			
			0x7F,	// 01111111B			
			0x3F,	// 00111111B
			0x1F,	// 00011111B
			0x0F,	// 00001111B
			0x07,	// 00000111B
			0x03,	// 00000011B
			0x01,	// 00000001B
			0x00,	// 00000000B
	    ];
	    public static var rMask:Array=
	    [
	    	0x00,	// 00000000B0
	    	0x80,	// 10000000B1
			0xC0,	// 11000000B2
			0xE0,	// 11100000B3
			0xF0,	// 11110000B4
			0xF8,	// 11111000B5
			0xFC,	// 11111100B6
			0xFE,	// 11111110B7
			0xFF,	// 11111111B8
	    ];

		public function CMask()
		{
		}
		
		// ------------------------------------------------------------
		// Cree le masque
		// ------------------------------------------------------------
		public function createMask(flags:int, image:CImage):void
		{
			width=image.width;
			height=image.height;
			xSpot=image.xSpot;
			ySpot=image.ySpot;			
        	lineWidth=((width+7)&0xFFFFFFF8)/8;

			mask=new ByteArray();				
			var data:BitmapData=image.img;
			var x:int, y:int;
	        if ((flags & GCMF_PLATFORM) == 0)
	        {
	            for (y = 0; y < height; y++)
	            {
	                for (x=0; x<width; x++)
	                {
                    	if ((x&0x07)==0)
                    	{
                    		mask.writeByte(0);
                    	}
	                    if ((data.getPixel32(x, y)&0xFF000000)!=0)
	                    {
	                        mask[mask.position-1]|=(0x80>>(x%8));
	                    }
	                }
	            }
	        }
	        else
	        {
	        	for (x=0; x<height*width; x++)
	        	{
	        		mask.writeByte(0);
	        	}
	            var endY:int;
	            var bm:int;
	            var s:int;
	            for (x = 0; x < width; x++)
	            {
	                for (y = 0; y < height; y++)
	                {
	                    if ((data.getPixel32(x, y)&0xFF000000) != 0)
	                    {
	                        break;
	                    }
	                }
	                if (y < height)
	                {
	                    endY = Math.min(height, y + CRunFrame.HEIGHT_PLATFORM);
	                    bm = (0x80>>(x&7));
	                    for (; y < endY; y++)
	                    {
	                        if ((data.getPixel32(x, y)&0xFF000000)!= 0)
	                        {
	                            s = (y*lineWidth) + x/8;
	                            mask[s] |= bm;
	                        }
	                    }
	                }
	            }
	        }
		}
		// Routine that rotates a rectangle
		public static function rotateRect(prc:CRect, pHotSpot:CPoint, fAngle:Number):void
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
			var topLeft:CPoint=new CPoint();
		
			// Ditto, optimized
			var nhxcos:Number;
			var nhxsin:Number;
			var nhycos:Number;
			var nhysin:Number;
			if ( pHotSpot == null )
			{
				nhxcos = nhxsin = nhycos = nhysin = 0.0;
				topLeft.x = topLeft.y = 0;
			}
			else
			{
				nhxcos = -pHotSpot.x * cosa;
				nhxsin = -pHotSpot.x * sina;
				nhycos = -pHotSpot.y * cosa;
				nhysin = -pHotSpot.y * sina;
				topLeft.x = int(nhxcos + nhysin);
				topLeft.y = int(nhycos - nhxsin);
			}
		
			// Rotate top-right point
			var topRight:CPoint=new CPoint();
		
			// Ditto, optimized
			if ( pHotSpot == null )
				x = Number(prc.right);
			else
				x = Number(prc.right - pHotSpot.x);
			nhxcos = x * cosa;
			nhxsin = x * sina;
			topRight.x = int(nhxcos + nhysin);
			topRight.y = int(nhycos - nhxsin);
		
			// Rotate bottom-right point
			var bottomRight:CPoint=new CPoint();
		
			// Ditto, optimized
			if ( pHotSpot == null )
				y = Number(prc.bottom);
			else
				y = Number(prc.bottom - pHotSpot.y);
			nhycos = y * cosa;
			nhysin = y * sina;
			bottomRight.x = int(nhxcos + nhysin);
			bottomRight.y = int(nhycos - nhxsin);
		
			// Bottom-left
			var bottomLeft:CPoint=new CPoint();
			bottomLeft.x = topLeft.x + bottomRight.x - topRight.x;
			bottomLeft.y = topLeft.y + bottomRight.y - topRight.y;
		
			// Get limits
			var xmin:int = Math.min(topLeft.x, Math.min(topRight.x, Math.min(bottomRight.x, bottomLeft.x)));
			var ymin:int = Math.min(topLeft.y, Math.min(topRight.y, Math.min(bottomRight.y, bottomLeft.y)));
			var xmax:int = Math.max(topLeft.x, Math.max(topRight.x, Math.max(bottomRight.x, bottomLeft.x)));
			var ymax:int = Math.max(topLeft.y, Math.max(topRight.y, Math.max(bottomRight.y, bottomLeft.y)));
		
			// Update hotspot position
			if ( pHotSpot != null)
			{
				pHotSpot.x = -xmin;
				pHotSpot.y = -ymin;
			}
		
			// Update rectangle
			prc.right = xmax - xmin;
			prc.bottom = ymax - ymin;
		}
		public function createRotatedMask(pMask:CMask, fAngle:Number, fScaleX:Number, fScaleY:Number):Boolean
		{
			var x:int, y:int;
			
			// Calculate new mask bounding box
			var cx:int = pMask.width;
			var cy:int = pMask.height;
			
			var rc:CRect=new CRect();
			rc.left = rc.top = 0;
			rc.right = pMask.width * fScaleX;
			rc.bottom = pMask.height * fScaleY;
			
			var hotSpot:CPoint=new CPoint();
			hotSpot.x = pMask.xSpot * fScaleX;
			hotSpot.y = pMask.ySpot * fScaleY;
			rotateRect(rc, hotSpot, fAngle);
			var newCx:int = (rc.right - rc.left);
			var newCy:int = (rc.bottom - rc.top);
			if ( newCx <= 0 || newCy <= 0 )
				return false;
			
			// Allocate memory for new mask
			var sMaskWidthBytes:int = pMask.lineWidth;
			var dMaskWidthBytes:int = ((newCx + 7) & ~7) / 8;
			var dwNewMaskSize:int = dMaskWidthBytes * newCy;
			mask=new ByteArray();		
			var n:int;		
			for (n=0; n<dwNewMaskSize; n++)
			{
				mask.writeByte(0);
			}
			lineWidth=dMaskWidthBytes;
			width = newCx;
			height = newCy;
			xSpot = hotSpot.x;
			ySpot = hotSpot.y;
			
			var alpha:Number = Number(fAngle * Math.PI / 180);
			var cosa:Number = Math.cos(alpha);
			var sina:Number = Math.sin(alpha);
			
			var fxs:Number = Number(cx/2) - (Number(newCx/2) * cosa - Number(newCy/2) * sina) / fScaleX;
			var fys:Number = Number(cy/2) - (Number(newCx/2) * sina + Number(newCy/2) * cosa) / fScaleY;
			
			var pbs0:int = 0;
			var pbd0:int = 0;		
			var pbd1:int = pbd0;
			
			var nxs:int = int(fxs * 65536);
			var nys:int = int(fys * 65536);
			var ncosa:int = int((cosa * 65536) / fScaleX);
			var nsina:int = int((sina * 65536) / fScaleY);
			
			var newCxMul8:int = newCx/8;
			var newCxMod8:int = newCx%8;
			
			var ncosa2:int = int((cosa * 65536) / fScaleY);
			var nsina2:int = int((sina * 65536) / fScaleX);
			
			var cxs:int = cx * 65536;
			var cys:int = cy * 65536;
			
			var bMask:int;
			var b:int;
			for (y=0; y<newCy; y++)
			{
				var txs:int = nxs;
				var tys:int = nys;
				var pbd2:int = pbd1;
				
				for (x=0; x<newCxMul8; x++)
				{
					var xs:int, ys:int;
					var bd:int = 0;
					
					// 1
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x80;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 2
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x40;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 3
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x20;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 4
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x10;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 5
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x08;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 6
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x04;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 7
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x02;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					// 8
					if ( txs >= 0 && txs < cxs )
					{
						if ( tys >= 0 && tys < cys )
						{
							xs = txs / 65536;
							ys = tys / 65536;
							bMask = 0x80>>(xs%8);
							b = pMask.mask[int(pbs0 + ys * sMaskWidthBytes + xs/8)];
							if ( b & bMask )
								bd |= 0x01;
						}
					}
					txs += ncosa;
					tys += nsina;
					
					mask[pbd2++] = bd;
				}
				
				if ( newCxMod8 )
				{
					var bdMask:int = 0x80;
					var bdbd:int = 0;
					for (x=0; x<newCxMod8; x++, bdMask >>= 1)
					{
						if ( txs >= 0 && txs < cxs && tys >= 0 && tys < cys )
						{
							var bdxs:int = txs / 65536;
							var bdys:int = tys / 65536;
							bMask = 0x80>>(bdxs%8);
							b = pMask.mask[int(pbs0 + bdys * sMaskWidthBytes + bdxs/8)];
							if ( b & bMask )
								bdbd |= bdMask;
						}
						txs += ncosa;
						tys += nsina;
					}
					mask[pbd2] = bdbd;
				}
				
				pbd1 += dMaskWidthBytes;
				
				nxs -= nsina2;
				nys += ncosa2;  				
			}
			return true;			
		}
		
		public function testMask(x1:int, y1:int, htFoot1:int, pMask2:CMask, x2:int, y2:int, htFoot2:int):Boolean
		{
	        var pLeft:CMask;
	        var pRight:CMask;
	        var x1Left:int, y1Left:int, x1Right:int, y1Right:int;
	        var syLeft:int, syRight:int, dyLeft:int, dyRight:int;
	        var htFootLeft:int, htFootRight:int;
	        var startYLeft:int, startYRight:int;
			
	        if (x1 <= x2)
	        {
	            pLeft = this;
	            pRight = pMask2;
	            htFootLeft = htFoot1;
	            htFootRight = htFoot2;
	            x1Left = x1;
	            y1Left = y1;
	            x1Right = x2;
	            y1Right = y2;
	        }
	        else
	        {
	            pLeft = pMask2;
	            pRight = this;
	            htFootLeft = htFoot2;
	            htFootRight = htFoot1;
	            x1Left = x2;
	            y1Left = y2;
	            x1Right = x1;
	            y1Right = y1;
	        }
	        syLeft=pLeft.height;
	        startYLeft=0;
	        if (htFootLeft!=0)
	        {
	        	syLeft=htFootLeft;
	        	y1Left+=pLeft.height-htFootLeft;
	        	startYLeft=pLeft.height-htFootLeft;
	        }
	        syRight=pRight.height;
	        startYRight=0;
	        if (htFootRight!=0)
	        {
	        	syRight=htFootRight;
	        	y1Right+=pRight.height-htFootRight;
	        	startYRight=pRight.height-htFootRight;
	        }
	
	        if (x1Left >= x1Right + pRight.width || x1Left + pLeft.width <= x1Right)
	        {
	            return false;
	        }
	        if (y1Left >= y1Right + syRight || y1Left + syLeft < y1Right)
	        {
	            return false;
	        }
	
	        var deltaX:int = x1Right - x1Left;
	        var offsetX:int = deltaX / 8;
	        var shiftX:int = deltaX % 8;
	        var countX:int = Math.min(x1Left + pLeft.width - x1Right, pRight.width);
	        countX = (countX + 7) / 8;
			var sxLeft:int=pLeft.lineWidth;
				
	        var deltaYLeft:int, deltaYRight:int, countY:int;
	        if (y1Left <= y1Right)
	        {
	            deltaYLeft = y1Right - y1Left + startYLeft;
	            deltaYRight = startYRight;
	            countY = Math.min(y1Left + syLeft, y1Right + syRight) - y1Right;
	        }
	        else
	        {
	            deltaYLeft = startYLeft;
	            deltaYRight = y1Left - y1Right + startYRight;
	            countY = Math.min(y1Left + syLeft, y1Right + syRight) - y1Left;
	        }
	        var x:int, y:int;
	
	        var offsetYLeft:int, offsetYRight:int;
	        var leftX:int, middleX:int;
	        var shortX:int;
	        if (shiftX != 0)
	        {
	            switch (countX)
	            {
	                case 1:
	                    for (y = 0; y < countY; y++)
	                    {
	                        offsetYLeft = (deltaYLeft + y) * pLeft.lineWidth;
	                        offsetYRight = (deltaYRight + y) * pRight.lineWidth;
	
	                        // Premier mot
	                        leftX = (pLeft.mask[offsetYLeft + offsetX]<<shiftX)&0xFF;
	                        if ((leftX&pRight.mask[offsetYRight])!=0)
	                        {
	                            return true;
	                        }
	
	                        if (offsetX+1<sxLeft)
	                        {
	                            middleX = (pLeft.mask[offsetYLeft + offsetX + 1]&0x000000FF) << shiftX;
	                            middleX >>= 8;
	                            if ((middleX & pRight.mask[offsetYRight]) != 0)
	                            {
	                                return true;
	                            }
	                        }
	                    }
	                    break;
	                case 2:
	                    for (y = 0; y < countY; y++)
	                    {
	                        offsetYLeft = (deltaYLeft + y) * pLeft.lineWidth;
	                        offsetYRight = (deltaYRight + y) * pRight.lineWidth;
	
	                        // Premier mot
	                        leftX = (pLeft.mask[offsetYLeft + offsetX]<<shiftX)&0xFF;
	                        if ((leftX & pRight.mask[offsetYRight]) != 0)
	                        {
	                            return true;
	                        }
	                        middleX = pLeft.mask[offsetYLeft + offsetX + 1] << shiftX;
	                        shortX = (middleX >>> 8);
	                        if ((shortX & pRight.mask[offsetYRight]) != 0)
	                        {
	                            return true;
	                        }
	
	                        // Milieu
	                        if ((middleX & pRight.mask[offsetYRight + 1]) != 0)
	                        {
	                            return true;
	                        }

							// Dernier mot
//	                        if (offsetYLeft + offsetX + 2<pLeft.mask.length)
							if (offsetX + 2<sxLeft)
	                        {
	                            middleX = pLeft.mask[offsetYLeft + offsetX + 2] << shiftX;
	                            shortX=(middleX>>>8);
	                            if ((shortX & pRight.mask[offsetYRight+1]) != 0)
	                            {
	                                return true;
	                            }
	                        }
	                    }
	                    break;
	                default:
	                    for (y = 0; y < countY; y++)
	                    {
	                        offsetYLeft = (deltaYLeft + y) * pLeft.lineWidth;
	                        offsetYRight = (deltaYRight + y) * pRight.lineWidth;
	
	                        // Premier mot
	                        leftX = (pLeft.mask[offsetYLeft + offsetX]<<shiftX)&0xFF;
	                        if ((leftX & pRight.mask[offsetYRight]) != 0)
	                        {
	                            return true;
	                        }
	
	                        for (x = 0; x < countX - 1; x++)
	                        {
	                            middleX = pLeft.mask[offsetYLeft + offsetX + x + 1] << shiftX;
	                            shortX = (middleX >>> 8);
	                            if ((shortX & pRight.mask[offsetYRight+x]) != 0)
	                            {
	                                return true;
	                            }
	
	                            // Milieu
	                            if ((middleX & pRight.mask[offsetYRight + x + 1]) != 0)
	                            {
	                                return true;
	                            }
	                        }
	                        if (offsetX + x + 1<sxLeft)
	                        {
	                            middleX = pLeft.mask[offsetYLeft + offsetX + x + 1] << shiftX;
	                            shortX=(middleX>>>8);
	                            if ((shortX & pRight.mask[offsetYRight+x]) != 0)
	                            {
	                                return true;
	                            }
	                        }
	                    }
	                    break;
	            }
	        }
	        else
	        {
	            for (y = 0; y < countY; y++)
	            {
	                offsetYLeft = (deltaYLeft + y) * pLeft.lineWidth;
	                offsetYRight = (deltaYRight + y) * pRight.lineWidth;
	
	                for (x = 0; x < countX; x++)
	                {
	                    leftX = pLeft.mask[offsetYLeft + offsetX + x]&0xFF;
	                    if ((pRight.mask[offsetYRight + x] & leftX) != 0)
	                    {
	                        return true;
	                    }
	                }
	            }
	        }
	        return false;
		}
		public function testRect(x1Mask:int, y1Mask:int, htFoot1:int, x1Rect:int, y1Rect:int, rWidth:int, rHeight:int, htFoot2:int):Boolean
		{
			var startYMask:int=0;
			var syMask:int=height;
			if (htFoot1>0)
			{
				startYMask=height-htFoot1;
				y1Mask+=startYMask;
				syMask=htFoot1;
			}
			var startYRect:int=0;
			var syRect:int=rHeight;
			if (htFoot2>0)
			{
				startYRect=rHeight-htFoot2;
				y1Rect+=startYRect;
				syRect=htFoot2;
			}
	        if (x1Mask >= x1Rect + rWidth || x1Mask + width <= x1Rect)
	        {
	            return false;
	        }
	        if (y1Mask >= y1Rect + syRect|| y1Mask + syMask < y1Rect)
	        {
	            return false;
	        }

			var startX:int, countX:int;
			var startY:int, countY:int;	        
	        if (x1Mask <= x1Rect)
	        {
	        	startX=x1Rect-x1Mask;
	        	countX=Math.min(width-startX, rWidth);
	        }
	        else
	        {
	        	startX=0;
	        	countX=Math.min(x1Rect+rWidth-x1Mask, width);
	        }
	        if (y1Mask <= y1Rect)
	        {
	            startY = y1Rect - y1Mask + startYMask;
	            countY = Math.min(y1Mask + syMask, y1Rect + syRect) - y1Rect;
	        }
	        else
	        {
	            startY = startYMask;
	            countY = Math.min(y1Mask + syMask, y1Rect+ syRect) - y1Mask;
	        }
	
	        var xOffset:int = startX/8;
	        var nBytes:int=int((startX+countX+7)/8)-int(startX/8);
	
	        var m:int;
        	var yOffset:int;
        	var y:int, x:int;
        	for (y = 0; y < countY; y++)
        	{
            	yOffset = (y+startY)*lineWidth;

            	switch (nBytes)
            	{
                	case 1:
                    	m = (lMask[startX&7] & rMask[((startX+countX-1)&7)+1]);
                    	if ((mask[yOffset + xOffset] & m) != 0)
                    	{
                        	return true;
                    	}
                    	break;
	                case 2:
	                    m = lMask[startX&7];
	                    if ((mask[yOffset + xOffset] & m) != 0)
	                    {
	                        return true;
	                    }
	                    m = rMask[((startX+countX-1)&7)+1];
	                    if ((mask[yOffset + xOffset + 1] & m) != 0)
	                    {
	                        return true;
	                    }
	                    break;
	                default:
	                    m = lMask[startX&7];
	                    if ((mask[yOffset + xOffset] & m) != 0)
	                    {
	                        return true;
	                    }
	                    for (x = 1; x < nBytes - 1; x++)
	                    {
	                        if (mask[yOffset + xOffset + x] != 0)
	                        {
	                            return true;
	                        }
	                    }
	                    m = rMask[((startX+countX-1) & 7)+1];
	                    if ((mask[yOffset + xOffset + x] & m) != 0)
	                    {
	                        return true;
	                    }
	                    break;
	            }
            }
	        return false;
		}
	    public function testPoint(x1Mask:int, y1Mask:int, x1:int, y1:int):Boolean
	    {
	    	var xx:int=x1-x1Mask;
	    	var yy:int=y1-y1Mask;
	        if (xx < 0 || xx >= width || yy < 0 || yy >= height)
	        {
	            return false;
	        }
	
	        var offset:int = (yy * lineWidth) + int(xx / 8);
	        var m:int = (0x80 >>> (xx & 7));
	        if ((mask[offset] & m) != 0)
	        {
				return true;
	        }
	        return false;
	    }
		
	}
}