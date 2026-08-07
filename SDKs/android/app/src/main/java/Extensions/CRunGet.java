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

import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashMap;
import Actions.CActExtension;
import Conditions.CCndExtension;
import Expressions.CValue;
import RunLoop.CCreateObjectInfo;
import Services.CBinaryFile;


public class CRunGet extends CRunExtension
{
	private Boolean usePost;

	private CRunGetThread thread;
	private String response="";
	private String sURL;
	private URL mURL;
	private String mHeader="";
	private String mUser="";
	private String mPassword="";
	private String mUserAgent="";
	private int Timeout;

	private int responseCode;
	private int flag;

	private HashMap<String, String> postData;
	private HashMap<String, String> postHeader;

	private CValue expRet;

	public CRunGet() {
		expRet = new CValue(0);
	}

	@Override 
	public int getNumberOfConditions()
	{
		return 3;
	}

	@Override
	public boolean createRunObject(CBinaryFile file, CCreateObjectInfo cob, int version)
	{
		usePost = false;
		postHeader = new HashMap<String, String>();
		postData = new HashMap <String,String>();
		try {
			flag = file.readInt();
		}
		catch (Exception e) {
			flag = 0;
		}

		Timeout = 45000;
		return true;
	}

	@Override
	public void destroyRunObject(boolean bFast)
	{
		if(thread != null)
			thread = null;
	}

	@Override
	public int handleRunObject()
	{
		if(thread != null)
		{
			responseCode = thread.responseCode;

			// Response is equal 408
			if(thread.timeout)
				ho.generateEvent(2, 0);

			if(thread.finished)
			{
				response = thread.text;
				if(!thread.timeout)
					ho.generateEvent(0, 0);
				thread = null;
			}

		}

		return 0;
	}

	@Override
	public boolean condition(int num, CCndExtension cnd)
	{
		switch (num)
		{
		case 0:
			return true;

		case 1:
			return (thread != null);

		case 2:
			return true;
		}

		return false;
	}

	@Override
	public void action(int num, CActExtension act)
	{
		switch (num)
		{
		case 0:

			if(thread != null)
				return;

			try
			{
				thread = new CRunGetThread();

				thread.Flags = flag;
				thread.CodePage = ho.hoAdRunHeader.rhApp.codePage;

				sURL = act.getParamExpString(rh, 0);
				mURL = new URL(sURL);

				thread.Hosts = mURL.getHost();
				thread.Ports = mURL.getPort();

				if(mURL.getUserInfo() != null){
					String UserInfo = mURL.getUserInfo();
					String Login[] = UserInfo.split(":");
					thread.Username = Login[0];
					thread.Password = Login[1];
					mURL = new URL (mURL.getProtocol(), mURL.getHost(), mURL.getPort(), mURL.getFile());
				}
				else if(mUser.length()>0){
					thread.Username = mUser;
					if(mPassword.length()>0)
						thread.Password = mPassword;
					else
						thread.Password = null;
				}
				else {
					thread.Username = null;
					thread.Password = null;
				}

				// Verify for what type of protocol it is
				if(mURL.getProtocol().toLowerCase().equals("https"))
					thread.isHttps = true;
				else
					thread.isHttps = false;

				thread.Timeout = Timeout;

				if(mUserAgent.length()!=0)
					postHeader.put("user-agent",  mUserAgent);
				else
					postHeader.put("user-agent",  "Fusion");

				if(usePost)
				{
					postHeader.put("Content-Type", "application/x-www-form-urlencoded");


					if(mHeader.length() > 0) {
						String lines[] = mHeader.split("[\\r\\n]+");
						for (int i=0; i < lines.length; i++) {
							String fields[] = lines[i].split(":");
							postHeader.put(fields[0].trim(), fields[1].trim());
						}
					}

					thread.postHeader = (HashMap<String, String>) postHeader.clone();
					thread.postData = (HashMap<String, String>) postData.clone();
					thread.url = mURL;
					thread.start();

					usePost = false;
					postData.clear();
					postHeader.clear();
				}
				else
				{
					if(mHeader.length() > 0) {
						String lines[] = mHeader.split("[\\r\\n]+");
						for (int i=0; i < lines.length; i++) {
							String fields[] = lines[i].split(":");
							postHeader.put(fields[0].trim(), fields[1].trim());
						}
					}
					postData.clear();
					thread.postHeader = (HashMap<String, String>) postHeader.clone();
					thread.url = mURL;
					thread.start();
					postHeader.clear();
				}
			}
			catch(RuntimeException e)
			{
				response = "";
				responseCode=-1;
				thread.finished = true;
				return;

			} catch (MalformedURLException e1) {
				response = "";
				responseCode=-1;
				thread.finished = true;
			}

			break;

		case 1:

			usePost = true;

			final String name = act.getParamExpString(rh, 0);
			final String value = act.getParamExpString(rh, 1);

			postData.put(name, value);

			break;

		case 2:					// Custom Header
			mHeader = act.getParamExpString(rh, 0); 
			break;
		case 3:					// Set User
			mUser = act.getParamExpString(rh, 0); 
			break;
		case 4:					// Set password
			mPassword = act.getParamExpString(rh, 0); 
			break;
		case 5:					// Set Timeout
			Timeout = act.getParamExpression(rh, 0); 
			break;
		case 6:					// Set User-Agent
			mUserAgent = act.getParamExpString(rh, 0); 
			break;

		}
	}

	@SuppressWarnings("deprecation")
	@Override
	public CValue expression(int num)
	{
		switch (num)
		{
		case 0:
		{
			expRet.forceString(response);
			return expRet;
		}
		case 1:
		{
			expRet.forceString("");
			try {
				expRet.forceString(URLEncoder.encode(ho.getExpParam().getString(),"UTF-8"));
			} catch (UnsupportedEncodingException e) {
			}
			return expRet;
		}
		case 2:
		{
			expRet.forceInt(responseCode);
			return expRet;
		}
		}

		return new CValue(0);
	}

	/*
	 * 
	 * 
	 * 
	 */
	public class InterruptThread implements Runnable {
		Thread parent;
		URLConnection con;
		int timeout;
		public InterruptThread(Thread parent, URLConnection con, int timeout) {
			this.parent = parent;
			this.con = con;
			this.timeout = timeout;
		}

		@Override
		public void run() {
			try {
				Thread.sleep(this.timeout);
			} catch (InterruptedException e) {

			}
			System.out.println("Timer thread forcing parent to quit connection");
			((HttpURLConnection)con).disconnect();
			System.out.println("Timer thread closed connection held by parent, exiting");
		}
	}

}
