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

package Extensions;

import Runtime.Log;

public class CRunMultipleTouchItem implements Cloneable

{
	public int id;
	public float x, y;
	public boolean free;

	public float startX, startY;
	public float dragX, dragY;

	public CRunMultipleTouchItem(int id, float x, float y)
	{
		this.id = id;

		this.startX = this.dragX = this.x = x;
		this.startY = this.dragY = this.y = y;

		this.free = false;
	}

	public Object clone()
	{
		try
		{
			return super.clone();
		}
		catch( CloneNotSupportedException e )
		{
			Log.Log("Not clonnable ...");
			return null;
		}
	} 

}
