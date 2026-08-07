/* Copyright (c) 1996-2013 Clickteam
 *
 * This source code is part of the Android exporter for Clickteam Multimedia Fusion 2.
 * 
 * Permission is hereby granted to any person obtaining a legal copy 
 * of Clickteam Multimedia Fusion 2 to use or modify this source code for 
 * debugging, optimizing, or customizing applications created with 
 * Clickteam Multimedia Fusion 2.  Any other use of this source code is prohibited.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
//----------------------------------------------------------------------------------
//
// CMUSICBANK : Stockage des musiques
//
//----------------------------------------------------------------------------------
package Banks;

import android.content.res.AssetFileDescriptor;
import android.os.SystemClock;

import java.util.Locale;

import Application.CRunApp;
import Application.CSoundPlayer;
import Runtime.Log;
import Runtime.MMFRuntime;
import Services.CFile;

public class CSoundBank implements IEnum
{
	public CSound sounds[] = null;
	public int nHandlesReel;
	public int nHandlesTotal;
	public int nSounds;
	public int handleToLength [];
	public int handleToFrequency [];
	public int handleToSoundID [];
	public short handleToFlags [];
	public boolean handleIsReady [];
	public long handleTime[];
	short useCount[];
	public static CSoundPlayer sPlayer;
	
	public CSoundBank(CSoundPlayer p)
	{
		sPlayer=p;
	}

	public void preLoad(CFile f)
	{
		// Nombre de handles
		nHandlesReel = f.readAShort();

		Log.Log ("nHandlesReel: " + nHandlesReel);

		handleToLength = new int [nHandlesReel];
		handleToFrequency = new int [nHandlesReel];
		handleToFlags = new short [nHandlesReel];
		handleToSoundID = new int [nHandlesReel];
		handleIsReady = new boolean [nHandlesReel];
		handleTime = new long [nHandlesReel];

		int numberOfSounds = f.readAShort ();

		Log.Log ("numberOfSounds: " + numberOfSounds);

		for (int i = 0; i < numberOfSounds; ++ i)
		{
			int handle = f.readAShort ();

			handleToFlags[handle] = f.readAShort ();
			handleToLength [handle] = f.readAInt ();
			handleToFrequency [handle] = f.readAInt ();

			handleToSoundID [handle] = -1;
			handleIsReady [handle] = false;
		}

		useCount = new short[nHandlesReel];
		resetToLoad();
		nSounds = 0;
		sounds = null;
	}

	public CSound newSoundFromHandle(short handle)
	{
		if (sounds != null)
		{
			if (handle >= 0 && handle < nHandlesReel)
			{
				if (sounds[handle] != null)
				{	
					CSound sound = sounds[handle];
					return new CSound (sound);
				}
				
			}
		}
		return null;
	}

	public void resetToLoad()
	{
		int n;
		for (n = 0; n < nHandlesReel; n++)
		{
			useCount[n] = 0;
		}
	}

	public void setToLoad(short handle)
	{
		useCount[handle]++;
	}

	// Entree enumeration
	@Override
	public short enumerate(short num)
	{
		setToLoad(num);
		return -1;
	}

	public void load(CRunApp app)
	{
		int h;

		// Combien de musiques?
		nSounds = 0;
		for (h = 0; h < nHandlesReel; h++)
		{
			if (useCount[h] != 0)
			{
				nSounds++;
			}
			else
			{
				if (handleToSoundID[h] != -1)
				{
					sPlayer.soundPool.unload (handleToSoundID[h]);
					handleToSoundID[h] = -1;
				}

				if (sounds != null && sounds[h]!=null)
					sounds[h].release();
			}
		}

		// Charge les images
		CSound newSounds[] = new CSound[nHandlesReel];

		for (h = 0; h < nHandlesReel; h++)
		{
			if (useCount[h] != 0)
			{
				if (sounds != null && sounds[h] != null)
				{
					newSounds[h] = sounds[h];
				}
				else
				{
					if (handleToSoundID[h] == -1 && (handleToFlags[h] & 0x20) == 0) /* play from disk not set? */
					{
						AssetFileDescriptor fd=null;
						int resID = 0;

						if(MMFRuntime.inst.obbAvailable)
							fd = MMFRuntime.inst.getSoundFromAPK(String.format (Locale.US,"res/raw/s%04d", h));

						if(fd == null)
							fd = MMFRuntime.inst.getResources().openRawResourceFd(MMFRuntime.inst.getResourceID(String.format (Locale.US,"raw/s%04d", h)));

						try
						{
							handleToSoundID[h] = sPlayer.soundPool.load(fd, 1);
							fd.close();
							
							handleIsReady[h] = false;
							handleTime[h] = SystemClock.currentThreadTimeMillis();
							Log.Log("SoundPool load ...");
						}
						catch (Throwable t)
						{
							Log.Log("Error during load ...");
						}
					}

					newSounds[h] = new CSound
							(sPlayer, String.format (Locale.US, "s%04d", h), (short) h, handleToSoundID[h], handleToFrequency[h], handleToLength[h], handleToFlags[h] );
										
					if (handleToSoundID[h] == -1)
						newSounds[h].load((short)h, app);
				}
			}
		}
		sounds = newSounds;

		nHandlesTotal = nHandlesReel;

		// Plus rien a charger
		resetToLoad();
		
	}
	
}
