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
package Extensions {
	import Actions.CActExtension;
	import Banks.CImage;
	import Banks.CImageBank;
	import Objects.CObject;
	
	public class CRunHotspotChanger extends CRunExtension
	{
		
		override public function action(num:int, act:CActExtension):void {
			switch (num)
			{
				case 0:
				{
					var object:CObject= act.getParamObject (rh, 0);
					
					var x:int= act.getParamExpression (rh, 1);
					var y:int= act.getParamExpression (rh, 2);
					
					var imageBank:CImageBank= ho.hoAdRunHeader.rhApp.imageBank;
					
					if (object.roc.rcImage < 0 || object.roc.rcImage >= imageBank.images.size ())
						break;
					
						object.hoImgXSpot = x;
						object.hoImgYSpot = y;
					
					break;
				}
					
				case 1:
				{
					var object:CObject= act.getParamObject (rh, 0);
					
					var x:int= act.getParamExpression (rh, 1);
					var y:int= act.getParamExpression (rh, 2);
					
					var imageBank:CImageBank= ho.hoAdRunHeader.rhApp.imageBank;
					
					if (object.roc.rcImage < 0|| object.roc.rcImage >= imageBank.images.size ())
						break;
					
						object.hoImgXAP = x;
						object.hoImgYAP = y;
					
					break;
				}
			};
		}
	}
}