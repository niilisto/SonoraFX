//----------------------------------------------------------------------------------
//
// CSOUNDBANK : Stockage des sons
//
//----------------------------------------------------------------------------------
package Banks
{
	import Application.CRunApp;
	
	import Services.*;	

	public class CSoundBank implements IEnum
	{
	    public var app:CRunApp;
	    public var file:CFile;
	    public var sounds:Array;
	    public var nHandlesReel:int;
	    public var nHandlesTotal:int;
	    public var nSounds:int;
	    private var offsetsToSounds:Array;
	    private var fileOffsetsToSounds:Array;
	    private var handleToIndex:Array;
	    private var useCount:Array;

		public function CSoundBank(a:CRunApp)
		{
			app=a;
		}
	    public function preLoad(f:CFile):void
	    {
			file=f;
		
			// Nombre de handles
			nHandlesReel=file.readAShort();
			offsetsToSounds=new Array(nHandlesReel);
			fileOffsetsToSounds=new Array(nHandlesReel);
			
			// Repere les positions des images
			var nSons:int=file.readAShort();
			var n:int;
			var sound:CSound=new CSound(app);
			var offset:uint;
			for (n=0; n<nSons; n++)
			{
				offset=file.getFilePointer();
			    sound.loadHandle(file);
			    offsetsToSounds[sound.handle]=n;
			    fileOffsetsToSounds[sound.handle]=offset;
			}
			
			// Reservation des tables
			useCount=new Array(nHandlesReel);
			resetToLoad();
			handleToIndex=null;
			nHandlesTotal=nHandlesReel;
			nSounds=0;
			sounds=null;
	    }
	    public function getSoundFromHandle(handle:int):CSound
	    {
			if (handle>=0 && handle<nHandlesTotal)
			    if (handleToIndex[handle]!=-1)
				return sounds[handleToIndex[handle]];
			return null;
	    }
	    public function getSoundFromIndex(index:int):CSound
	    {
			if (index>=0 && index<nSounds)
			    return sounds[index];
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

	    public function enumerate(num:int):int
	    {
			setToLoad(num);
			return -1;
	    }

	    public function load():void
	    {
			var n:int;
			
			// Combien d'images?
			nSounds=0;
			for (n=0; n<nHandlesReel; n++)
			{
			    if (useCount[n]!=0)
					nSounds++;
			}
		
			// Charge les images
			var newSounds:Array=new Array(nSounds);
			var count:int=0;
			var h:int;
			for (h=0; h<nHandlesReel; h++)
			{
			    if (useCount[h]!=0)
			    {
					if (sounds!=null && handleToIndex[h]!=-1 && sounds[handleToIndex[h]]!=null)
					{
					    newSounds[count]=sounds[handleToIndex[h]];
					    newSounds[count].useCount=useCount[h];
					}
					else
					{
					    newSounds[count]=new CSound(app);
					    newSounds[count].load(offsetsToSounds[h], app.file, fileOffsetsToSounds[h]);
					    newSounds[count].useCount=useCount[h];
					}
					count++;
			    }
			}
			sounds=newSounds;
		
			// Cree la table d'indirection
			handleToIndex=new Array(nHandlesReel);
			for (n=0; n<nHandlesReel; n++)
			{
			    handleToIndex[n]=-1;
			}
			for (n=0; n<nSounds; n++)
			{
			    handleToIndex[sounds[n].handle]=n;
			}
			nHandlesTotal=nHandlesReel;
			
			// Plus rien a charger
			resetToLoad();
	    }
	}
}