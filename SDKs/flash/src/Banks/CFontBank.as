//----------------------------------------------------------------------------------
//
// CFONTBANK :banque de fontes
//
//----------------------------------------------------------------------------------
package Banks
{
	import Banks.IEnum;	
	import Services.*;
	
	public class CFontBank implements IEnum
	{
	    public var file:CFile;
	    public var fonts:Array;
	    private var offsetsToFonts:Array;
	    private var nFonts:int;
	    private var handleToIndex:Array;
	    private var maxHandlesReel:int;
	    private var maxHandlesTotal:int;
	    private var useCount:Array;
	    private var nullFont:CFont;
	    
		public function CFontBank()
		{
		}
	    public function preLoad(file:CFile):void
	    {
			// Nombre d'elements
			var number:int=file.readAInt();
			var n:int;
			
			// Explore les handles
			maxHandlesReel=0;
			var debut:int=file.getFilePointer();
			var temp:CFont=new CFont();
			for (n=0; n<number; n++)
			{
			    temp.loadHandle(file);
			    maxHandlesReel=Math.max(maxHandlesReel, temp.handle+1);
			}
			file.seek(debut);
			offsetsToFonts=new Array(maxHandlesReel);
			for (n=0; n<number; n++)
			{
			    debut=file.getFilePointer();
			    temp.loadHandle(file);
			    offsetsToFonts[temp.handle]=debut;
			}	    
			useCount=new Array(maxHandlesReel);
			resetToLoad();
			handleToIndex=null;
			maxHandlesTotal=maxHandlesReel;
			nFonts=0;
			fonts=null;
	    }
	    public function load(file:CFile):void
	    {
			var n:int;
			nFonts=0;
			for (n=0; n<maxHandlesReel; n++)
			{
			    if (useCount[n]!=0)
			    {
					nFonts++;
			    }
			}
		
			var newFonts:Array=new Array(nFonts);
			var count:int=0;
			var h:int;
			for (h=0; h<maxHandlesReel; h++)
			{
			    if (useCount[h]!=0)
			    {
					if (fonts!=null && handleToIndex[h]!=-1 && fonts[handleToIndex[h]]!=null)
					{
					    newFonts[count]=fonts[handleToIndex[h]];
					    newFonts[count].useCount=useCount[h];
					}
					else
					{
					    newFonts[count]=new CFont();
					    file.seek(offsetsToFonts[h]);
					    newFonts[count].load(file);
					    newFonts[count].useCount=useCount[h];
					}
					count++;
			    }
			}
			fonts=newFonts;
	
			// Cree la table d'indirection
			handleToIndex=new Array(maxHandlesReel);
			for (n=0; n<maxHandlesReel; n++)
			{
			    handleToIndex[n]=-1;
			}
			for (n=0; n<nFonts; n++)
			{
			    handleToIndex[fonts[n].handle]=n;
			}
			maxHandlesTotal=maxHandlesReel;
		
			// Plus rien a charger
			resetToLoad();	
	    }

	    public function getFontFromHandle(handle:int):CFont
	    {
			// Protection jeux niques
			if (handle==-1)
			{
			    return nullFont;
			}
			// Retourne la fonte
			if (handle>=0 && handle<maxHandlesTotal)
			    if (handleToIndex[handle]!=-1)
					return fonts[handleToIndex[handle]];
			return null;
	    }
	    public function getFontFromIndex(index:int):CFont
	    {
			if (index>=0 && index<nFonts)
			    return fonts[index];
			return null;
	    }
	    public function getFontInfoFromHandle(handle:int):CFontInfo
	    {
			var font:CFont=getFontFromHandle(handle);
			return font.getFontInfo();
	    }
	    public function resetToLoad():void
	    {
			var n:int;
			for (n=0; n<maxHandlesReel; n++)
			{
			    useCount[n]=0;
			}
	    }    
	    public function setToLoad(handle:int):void
	    {
			// Protection jeux niques
			if (handle==-1)
			{
			    if (nullFont==null)
			    {
					nullFont=new CFont();
					nullFont.createDefaultFont();		
			    }
			    return;
			}
			useCount[handle]++;
	    }
    
	    // Entree enumeration
	    public function enumerate(num:int):int
	    {
			setToLoad(num);
			return -1;
	    }
	    public function addFont(info:CFontInfo):int
	    {
			var h:int;
		
			// Cherche une fonte identique
			var n:int;
			for (n=0; n<nFonts; n++)
			{
			    if (fonts[n]==null) continue;
			    if (fonts[n].lfHeight!=info.lfHeight) continue;
			    if (fonts[n].lfWeight!=info.lfWeight) continue; 
			    if (fonts[n].lfItalic!=info.lfItalic) continue; 
			    if (fonts[n].lfUnderline!=info.lfUnderline) continue;
			    if (fonts[n].lfStrikeOut!=info.lfStrikeOut) continue; 
			    if (CServices.compareStringsIgnoreCase(fonts[n].lfFaceName, info.lfFaceName)==false) continue;
			    break;
			}
			if (n<nFonts)
			{
			    return fonts[n].handle;
			}
		
			// Cherche un handle libre
			var hFound:int=-1;
			for (h=maxHandlesReel; h<maxHandlesTotal; h++)
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
			    var newHToI:Array=new Array(maxHandlesTotal+10);
			    for (h=0; h<maxHandlesTotal; h++)
			    {
					newHToI[h]=handleToIndex[h];
			    }
			    for (; h<maxHandlesTotal+10; h++)
			    {
					newHToI[h]=-1;
			    }
			    hFound=maxHandlesTotal;
			    maxHandlesTotal+=10;
			    handleToIndex=newHToI;
			}
		
			// Cherche une fonte libre
			var f:int;
			var fFound:int=-1;
			for (f=0; f<nFonts; f++)
			{
			    if (fonts[f]==null)
			    {
					fFound=f;
					break;
			    }
			}		
		
			// Rajouter une image?
			if (fFound==-1)
			{
			    var newFonts:Array=new Array(nFonts+10);
			    for (f=0; f<nFonts; f++)
			    {
					newFonts[f]=fonts[f];
			    }
			    for (; f<nFonts+10; f++)
			    {
					newFonts[f]=null;
			    }
			    fFound=nFonts;
			    nFonts+=10;
			    fonts=newFonts;
			}
		
			// Ajoute la nouvelle image
			handleToIndex[hFound]=fFound;
			fonts[fFound]=new CFont();
			fonts[fFound].handle=hFound;
			fonts[fFound].lfHeight=info.lfHeight; 
			fonts[fFound].lfWeight=info.lfWeight; 
			fonts[fFound].lfItalic=info.lfItalic; 
			fonts[fFound].lfUnderline=info.lfUnderline; 
			fonts[fFound].lfStrikeOut=info.lfStrikeOut; 
			fonts[fFound].lfFaceName=new String(info.lfFaceName);
				
			return hFound;
	    }    
	}
}