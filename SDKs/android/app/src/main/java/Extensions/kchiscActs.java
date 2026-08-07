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

/**
 * by Greyhill
 * @author Admin
 */

package Extensions;

import Actions.CActExtension;
import RunLoop.CRun;
import Services.CINI;

public class kchiscActs
{
	static final int ACT_ASKNAME = 0;
	static final int ACT_HIDE = 1;
	static final int ACT_SHOW = 2;
	static final int ACT_RESET = 3;
	static final int ACT_CHANGENAME = 4;
	static final int ACT_CHANGESCORE = 5;
	static final int ACT_SETPOSITION = 6;
	static final int ACT_SETXPOSITION = 7;
	static final int ACT_SETYPOSITION = 8;
	static final int ACT_INSERTNEWSCORE = 9;
	static final int ACT_SETCURRENTFILE = 10;
	CRunkchisc thisObject;

	public kchiscActs(CRunkchisc object)
	{
		thisObject = object;
	}

	public void action(int num, CActExtension act)
	{
		switch (num)
		{
		case ACT_ASKNAME:
			CheckScore(act.getParamPlayer(thisObject.rh, 0), null);
			break;
		case ACT_HIDE:
			Hide();
			break;
		case ACT_SHOW:
			Show();
			break;
		case ACT_RESET:
			Reset();
			break;
		case ACT_CHANGENAME:
			ChangeName(act.getParamExpression(thisObject.rh, 0), act.getParamExpString(thisObject.rh, 1));
			break;
		case ACT_CHANGESCORE:
			ChangeScore(act.getParamExpression(thisObject.rh, 0), act.getParamExpression(thisObject.rh, 1));
			break;
		case ACT_SETPOSITION:
			SetPosition(act.getParamPosition(thisObject.rh, 0));
			break;
		case ACT_SETXPOSITION:
			SetXPosition(act.getParamExpression(thisObject.rh, 0));
			break;
		case ACT_SETYPOSITION:
			SetYPosition(act.getParamExpression(thisObject.rh, 0));
			break;
		case ACT_INSERTNEWSCORE:
			InsertNewScore(act.getParamExpression(thisObject.rh, 0), act.getParamExpString(thisObject.rh, 1), true);
			break;
		case ACT_SETCURRENTFILE:
			SetCurrentFile(act.getParamExpString(thisObject.rh, 0));
			break;
		}
	}

	public void CheckScore(int player, final Runnable r)
	{
		CRun rhPtr = thisObject.ho.hoAdRunHeader;

		final int score = rhPtr.rhApp.scores[player];

		if (score > thisObject.Scores[thisObject.NbScores - 1])
		{
			thisObject.getInput ("Hi-Score!", "Name", new CRunkchisc.InputDoneCallback ()
			{
				@Override
				public void run (String name)
				{
					InsertNewScore(score, name, false);

					if (r != null)
						r.run();
				}
			});
		}
	}

	private void Hide()
	{
		thisObject.sVisible = false;
		thisObject.ho.redraw();
	}

	private void Show()
	{
		thisObject.sVisible = true;
		thisObject.ho.redraw();
	}

	private void Reset()
	{
		for (int a = 0; a < 20; a++)
		{
			this.thisObject.Names[a] = this.thisObject.originalNames[a];
			this.thisObject.Scores[a] = this.thisObject.originalScores[a];
		}

		thisObject.saveScores ();

		// hi-score was reset, need to render again
		thisObject.render();
		
		if (this.thisObject.sVisible)
		{
			thisObject.ho.roc.rcChanged = true;
			thisObject.ho.redraw();
		}
	}

	private void ChangeName(int i, String name) //1based
	{
		if ((i > 0) && (i <= this.thisObject.NbScores))
		{
			this.thisObject.Names[i - 1] = name;

			thisObject.realIni.setItemString ("N" + i, name);

			thisObject.saveScores();

			// If hi-score render again
			thisObject.render();
			if (this.thisObject.sVisible)
			{
				thisObject.ho.roc.rcChanged = true;
				thisObject.ho.redraw();
			}
		}
	}

	private void ChangeScore(int i, int score)//1based
	{
		if ((i > 0) && (i <= this.thisObject.NbScores))
		{
			this.thisObject.Scores[i - 1] = score;

			thisObject.realIni.setItemValue ("S" + i, score);

			thisObject.saveScores();

			// If hi-score render again
			thisObject.render();
			if (this.thisObject.sVisible)
			{
				thisObject.ho.roc.rcChanged = true;
				thisObject.ho.redraw();
			}
		}
	}

	private void SetPosition(Params.CPositionInfo p)
	{
		this.thisObject.ho.setPosition(p.x, p.y);
		if (this.thisObject.sVisible)
		{
			thisObject.ho.roc.rcChanged = true;
			thisObject.ho.redraw();
		}
	}

	private void SetXPosition(int x)
	{
		this.thisObject.ho.setX(x);
		if (this.thisObject.sVisible)
		{
			thisObject.ho.roc.rcChanged = true;
			thisObject.ho.redraw();
		}
	}

	private void SetYPosition(int y)
	{
		this.thisObject.ho.setY(y);
		if (this.thisObject.sVisible)
		{
			thisObject.ho.roc.rcChanged = true;
			thisObject.ho.redraw();
		}
	}

	private void InsertNewScore(int pScore, String pName, boolean bRender)
	{
		if (pScore > thisObject.Scores[thisObject.NbScores - 1])
		{
			thisObject.Scores[19] = pScore;
			thisObject.Names[19] = pName;
			short b;
			boolean TriOk;
			int score;
			String name;
			// Sort the hi-score table ws_visible
			do
			{
				TriOk = true;
				for (b = 1; b < 20; b++)
				{
					if (thisObject.Scores[b] > thisObject.Scores[b - 1])
					{
						score = thisObject.Scores[b - 1];
						name = thisObject.Names[b - 1];
						thisObject.Scores[b - 1] = thisObject.Scores[b];
						thisObject.Names[b - 1] = thisObject.Names[b];
						thisObject.Scores[b] = score;
						thisObject.Names[b] = name;
						TriOk = false;
					}
				}
			} while (false == TriOk);

			thisObject.saveScores ();

			if(bRender)
				thisObject.render();
			
			// If hi-score table visible, set redraw
			if (thisObject.sVisible)
			{
				thisObject.ho.roc.rcChanged = true;
				thisObject.ho.redraw();
			}
		}
	}

	private void SetCurrentFile(String fileName)
	{
		this.thisObject.IniName = fileName;
		
		if(fileName.contains("\\") || fileName.contains("/"))
			this.thisObject.iniFlags &= ~0x0004;
		else
			this.thisObject.Flags |= 0x0004;
		
		this.thisObject.realIni.close();
		this.thisObject.realIni = new CINI (thisObject.ho, fileName, this.thisObject.iniFlags);
	}
}
