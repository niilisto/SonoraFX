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

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.HttpCookie;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManagerFactory;

import Runtime.Log;
import Runtime.MMFRuntime;
import Util.Base64;
import android.annotation.SuppressLint;

public class CRunGetThread extends Thread
{
	String text;
	volatile Boolean finished;
	volatile Boolean timeout;

	URL url;
	String Password;
	String Username;
	String Hosts;
	int	   Ports;

	int	   Timeout;
	static String CNHost;

	HashMap<String, String> postHeader;
	HashMap<String, String> postData;

	boolean isHttps = false;
	static final int GETCP_FROMWEBPAGE = 0;
	static final int GETCP_FROMAPP = 1;
	static final int GETCP_UTF8 = 2;			
	static final int GETFLAG_CPMASK = 0x0003;
	

	String charset;
	int Flags = 0;
	int CodePage;
	int responseCode;
	int statusCode;
	boolean times = true;
	boolean firstTime = true;
	boolean fastTrack;

	public CRunGetThread()
	{
		text = "";
		finished = false;
		timeout = false;
		postHeader = new HashMap<String, String>();
		postData   = new HashMap<String, String>();
		firstTime = true;
		charset = "UTF-8";
		responseCode = 0;
		fastTrack = false;

	}
	/*****************************
	 * Convert from an list of values a string in UTF-8 to send in a POST
	 * request
	 * @param params 
	 * @return a String of utf-8 containing the POST information
	 * @throws UnsupportedEncodingException
	 *****************************/
	private String makePostDataString(HashMap<String, String> params) throws UnsupportedEncodingException{
		StringBuilder result = new StringBuilder();
		boolean first = true;
		for(Map.Entry<String, String> entry : params.entrySet()){
			if (first)
				first = false;
			else
				result.append('&');

			result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
			result.append('=');
			result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
		}

		return result.toString();
	}    
	/*********************************************
	 * extract from content-type the charset value if any
	 * @param connection
	 * @return
	 *********************************************/
	private String getContentTypeString(HttpURLConnection connection) {
		String contentType = connection.getContentType();
		String charset = "iso-8859-1";
		
		if(contentType == null)
			return Charset.defaultCharset().name();
		
		String[] values = contentType.split(";"); //The values.length must be equal to 2...

		for (String value : values) {
			value = value.trim();

			if (value.toLowerCase().startsWith("charset=")) {
				charset = value.substring("charset=".length());
			}
		}

		if ("".equals(charset)) {
			charset = "UTF-8"; //is not include in page content then use UTF-8
		}		
		return charset;
	}
	
	private String getContentAccordingCodePage(InputStream stream, String contentType)
	{
		byte[] recvBytes;

		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		boolean start_read = true;
		//boolean forceUtf8 = false;


		try {
			byte[] chunk = new byte[4096];
			int bytesRead;
			int nPos = 0;

			while ((bytesRead = stream.read(chunk)) > 0) {
				outputStream.write(chunk, 0, bytesRead);

				// Skip UTF-8 BOM
				if (start_read)
				{
					start_read = false;
					if (chunk[0] == (char)0xEF && chunk[1] == (char)0xBB && chunk[2] == (char)0xBF)
					{
						nPos = 3;
						//forceUtf8 = true;
						charset="UTF-8";
					}
				}
			}

			recvBytes =  outputStream.toByteArray();
			outputStream.close();
			if(charset != null)
				text = new String(recvBytes, nPos, recvBytes.length-nPos, charset);
			else
			{
				text = new String(recvBytes, nPos, recvBytes.length-nPos, "LATIN-1");
				if(text.contains("charset")) 
				{
					String textTmp = text;
					String charsetName;
					int start = textTmp.indexOf("charset=",1);
					int end, end1, end2, end3, end4;
					end1 = textTmp.indexOf(">",start);
					end2 = textTmp.indexOf(" ",start);
					end3 = textTmp.indexOf(";",start);
					end4 = textTmp.indexOf("/",start);
					end = Math.min(end1, Math.min(end2, Math.min(end3, end4)));
					start = textTmp.indexOf("=", start);
					charsetName = textTmp.substring(start,end).replace("\"","");
					charset = charsetName.replace("=", "");
					text = new String(recvBytes, nPos, recvBytes.length-nPos, charset);
				}
				else
				{
					if(contentType != null)
						text = new String(recvBytes, nPos, recvBytes.length-nPos, contentType);
					else
						text = new String(recvBytes, nPos, recvBytes.length-nPos, "UTF-8");
						
				}
			}
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
			recvBytes = null;
		}
		return text;
	}	
	
	/**
	* The host name verifier to be use if there is not default host verifier.
	*/
	static class LocalHostnameVerifier implements HostnameVerifier {

		boolean verified=false;

		@Override
		public boolean verify(String hostname,SSLSession session){
			if(true)
				Log.Log("verification: "+hostname+" "+session.getPeerHost());

			verified=true;
			return true;
		}
	}
	

	
	/*****************************
	 * Make a http url request and get response from it.
	 * @throws Exception
	 *****************************/
	@SuppressLint("NewApi")
	private void DoHttpURL() throws Exception {

		final HttpURLConnection conn = (HttpURLConnection) url.openConnection();

		if(Timeout > 0) {
			conn.setReadTimeout(Timeout);
			conn.setConnectTimeout(Timeout);
		}
		conn.setDoInput(true);
		if(charset != null)
			conn.setRequestProperty("Accept-Charset", charset);

		HttpCookie cookie = new HttpCookie("lang", "us");
		cookie.setDomain(url.toString());
		cookie.setPath("/");
		cookie.setVersion(0);

		CookieManager cookieManager = new CookieManager();
		CookieHandler.setDefault(cookieManager);
		cookieManager.getCookieStore().add(new URI(url.toString()), cookie);

		//Base64 base64 = new Base64();

		if (url.getUserInfo() != null) {
			String basicAuth = "Basic " + new String(Base64.encode(url.getUserInfo().getBytes()));
			conn.setRequestProperty("Authorization", basicAuth);
		}
		else if(Username != null && Password != null && Username.length()> 0 && Password.length() > 0) {
			String userPassword = Username + ":" + Password;
			String encoding = Base64.encode(userPassword.getBytes());
			conn.setRequestProperty("Authorization", "Basic " + encoding);
		}


		// Making the header information and request it
		if(postHeader != null && !postHeader.isEmpty()) {
			for (String field : postHeader.keySet()) {
				String newValue = postHeader.get(field);
				conn.addRequestProperty(field, newValue);
			}	            
		}

		if(postData != null && !postData.values().isEmpty()) {

			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			OutputStream os = conn.getOutputStream();
			BufferedWriter writer = new BufferedWriter(
					new OutputStreamWriter(os, "UTF-8"));

			writer.write(makePostDataString(postData));

			writer.flush();
			writer.close();
			os.close();
		}
		else {
			conn.setRequestMethod("GET");
		}

		statusCode=conn.getResponseCode();

		text = getContentAccordingCodePage(conn.getInputStream(), getContentTypeString(conn));
		
		responseCode = statusCode;

		if (statusCode == HttpURLConnection.HTTP_OK)
			times = false;

		if(conn != null) {
			conn.disconnect();
			//conn = null;
		}
		finished = true;
		return;
	}
	
	/*************************
	 * Make a https url request and get response from it.
	 * @throws Exception
	 *************************/
	@SuppressLint("NewApi")
	private void DoHttpsURL() throws Exception {

		// convert null to the file you need
		final HttpsURLConnection conn = setUpHttpsConnection(url, null);
				
		if(Timeout > 0) {
			conn.setReadTimeout(Timeout);
			conn.setConnectTimeout(Timeout);
		}
		conn.setDoInput(true);
		if(charset != null)
			conn.setRequestProperty("Accept-Charset", charset);

		HttpCookie cookie = new HttpCookie("lang", "us");
		cookie.setDomain(url.toString());
		cookie.setPath("/");
		cookie.setVersion(0);

		CookieManager cookieManager = new CookieManager();
		CookieHandler.setDefault(cookieManager);
		cookieManager.getCookieStore().add(url.toURI(), cookie);

		//Base64 base64 = new Base64();

		if (url.getUserInfo() != null) {
			String basicAuth = "Basic " + new String(Base64.encode(url.getUserInfo().getBytes()));
			conn.setRequestProperty("Authorization", basicAuth);
		}
		else if(Username != null && Password != null && Username.length()> 0 && Password.length() > 0) {
			String userPassword = Username + ":" + Password;
			String encoding = Base64.encode(userPassword.getBytes());
			conn.setRequestProperty("Authorization", "Basic " + encoding);
		}

		if(CNHost.length() > 0)
		{
			HostnameVerifier defaultVerifier = new HostnameVerifier() {
	
		        public boolean verify(String hostname, SSLSession session) {
		            Log.Log("Host: "+hostname+" Session Host: "+session.getPeerHost()+" and CN Host: "+CNHost);
		            if(hostname.equalsIgnoreCase(CNHost))
		            	return true;
		            else
		            {
		            	HostnameVerifier hv = HttpsURLConnection.getDefaultHostnameVerifier();
		            	return hv.verify(hostname, session);
		            }
		        }
		    };
	
		    conn.setHostnameVerifier(defaultVerifier);
		}

		// Making the header information and request it
		if(postHeader != null && !postHeader.isEmpty()) {
			for (String field : postHeader.keySet()) {
				String newValue = postHeader.get(field);
				conn.addRequestProperty(field, newValue);
			}	            
		}

		if(postData != null && !postData.values().isEmpty()) {

			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			OutputStream os = conn.getOutputStream();
			BufferedWriter writer = new BufferedWriter(
					new OutputStreamWriter(os, "UTF-8"));

			writer.write(makePostDataString(postData));

			writer.flush();
			writer.close();
			os.close();
		}
		else {
			conn.setRequestMethod("GET");
		}

		statusCode=conn.getResponseCode();

		text = getContentAccordingCodePage(conn.getInputStream(), getContentTypeString(conn));
		
		responseCode = statusCode;

		if (statusCode != HttpURLConnection.HTTP_OK)
			times = false;

		if(conn != null)
			conn.disconnect();
	}

	@Override
	public void run()
	{
		responseCode = 0;
		statusCode = 0;
		//long timer = SystemClock.currentThreadTimeMillis();
		
		try {
			
			switch (Flags & GETFLAG_CPMASK) {
			case GETCP_FROMWEBPAGE:
				charset = null;
				break;
			case GETCP_FROMAPP:
				charset = ReverseCharset(CodePage);
				break;
			case GETCP_UTF8:
				charset = "UTF-8";
				break;
			}

			if(isHttps)
				DoHttpsURL();
			else
				DoHttpURL();
		} 
		catch (Exception e) {
			Log.Log(""+e.getMessage());
			if(e instanceof java.net.UnknownHostException) {
				responseCode = 12007;
				timeout = true;
			}
			else if(e instanceof java.net.SocketTimeoutException) {
				responseCode = 408;
				timeout = true;
			}
			else if(e instanceof javax.net.ssl.SSLHandshakeException) {
				responseCode = 12044;
				timeout = true;
			}
			else if(e instanceof java.net.ConnectException) {
				responseCode = 522;
				timeout = true;
			}
			else if(e instanceof javax.net.ssl.SSLPeerUnverifiedException) {
				responseCode = 403;
				timeout = true;
			}
			else {
				responseCode = statusCode;
			}
		}
		finally {
			//Log.d("GET","elapse time: "+(SystemClock.currentThreadTimeMillis()-timer));
			finished = true;
		}
	}
	/******************
	 * Get charset string from int codepage from windows
	 * @param uCodePage
	 * @return
	 */
	private String ReverseCharset(int uCodePage)
	{
		String szCharset = "";

		if(uCodePage == 28591)
		{
			szCharset ="iso-8859-1";       // iso-8859-1 translation
		}
		else if(uCodePage == 28592)
		{
			szCharset = "iso-8859-2";       // iso-8859-2 translation
		}
		else if(uCodePage == 28593)
		{
			szCharset = "iso-8859-3";       // iso-8859-3 translation
		}
		else if(uCodePage == 28594)
		{
			szCharset = "iso-8859-4";       // iso-8859-4 translation
		}
		else if(uCodePage == 28595)
		{
			szCharset = "iso-8859-5";       // iso-8859-5 translation
		}
		else if(uCodePage == 28596)
		{
			szCharset = "iso-8859-6";       // iso-8859-6 translation
		}
		else if(uCodePage == 28597)
		{
			szCharset = "iso-8859-7";       // iso-8859-7 translation
		}
		else if(uCodePage == 28598)
		{
			szCharset = "iso-8859-8";       // iso-8859-8 translation
		}
		else if(uCodePage == 1251)
		{
			szCharset = "windows-1251";       // windows-1251 translation
		}
		else if(uCodePage == 1252)
		{
			szCharset = "windows-1252";       // windows-1252 translation
		}
		else if(uCodePage == 1253)
		{
			szCharset = "windows-1253";       // windows-1253 translation
		}
		else if(uCodePage == 1254)
		{
			szCharset = "windows-1254";       // windows-1254 translation
		}
		else if(uCodePage == 1255)
		{
			szCharset = "windows-1255";       // windows-1255 translation
		}
		else if(uCodePage == 20936)
		{
			szCharset = "gb2312";       // gbk2312 translation
		}
		else if(uCodePage == 936)
		{
			szCharset = "gbk";       // gbk translation
		}
		else if(uCodePage == 950)
		{
			szCharset = "big5";       // big5 translation
		}
		else if(uCodePage == 20866)
		{
			szCharset = "koi8-r";	// koi8-r translation
		}
		else if(uCodePage == 51932)
		{
			szCharset = "euc-jp";       // euc-jp translation
		}
		else if(uCodePage == 51949)
		{
			szCharset = "euc-kr";       // euc-kr translation
		}
		else if(uCodePage == 51936)
		{
			szCharset = "euc-cn";       // euc-cn translation
		}
		else if(uCodePage == 50222)
		{
			szCharset = "iso-2022-jp";       // iso-2022-jp translation
		}
		else if(uCodePage == 50225)
		{
			szCharset = "iso-2022-kr";       // iso-2022-kr translation
		}
		else if(uCodePage == 65001)
		{
			szCharset = "utf-8";       // UTF-8 translation
		}
		else if(uCodePage == 0)
		{
			szCharset = "utf-8";       // UTF-8 translation, language neutral
		}
		else {
			szCharset = null;       // No Page
		}
		return szCharset;
	}
	
	
	 @SuppressLint("SdCardPath")
	    public static HttpsURLConnection setUpHttpsConnection(URL url, String file_cert)
	    {
		 	CNHost = "";
	        try
	        {
	        	// Tell the URLConnection to use a SocketFactory from our SSLContext
	            HttpsURLConnection urlConnection = (HttpsURLConnection)url.openConnection();
	            
	        	// Create an SSLContext
	        	SSLContext context;
        		context = SSLContext.getInstance("TLS");

	        	if(file_cert != null)
	        	{	
		        	File certFile = new File(new URI(("file:///android_assets/"+file_cert)));
		            if (certFile.exists())
		        	    throw new IOException("file not found");
	
		            CertificateFactory cf = CertificateFactory.getInstance("X.509");
	
		            InputStream caInput = new BufferedInputStream(MMFRuntime.inst.getAssets().open(file_cert));
		            Certificate ca = cf.generateCertificate(caInput);
		            System.out.println("ca=" + ((X509Certificate) ca).getSubjectDN());
		            
		            // Create a KeyStore containing our trusted CAs
		            String keyStoreType = KeyStore.getDefaultType();
		            KeyStore keyStore = KeyStore.getInstance(keyStoreType);
		            keyStore.load(null, null);
		            keyStore.setCertificateEntry( ((X509Certificate) ca).getSubjectDN().getName(), ca);
		            
		            // Create a TrustManager that trusts the CAs in our KeyStore
		            String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
		            TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
		            tmf.init(keyStore);
		            
		            // make context to uses our TrustManager
		            context.init(null, tmf.getTrustManagers(), null);
	        	}
	        	else
	        	{
	        		if(MMFRuntime.deviceApi > 20)
	        		{
		        		Certificate ca = null;
		        		if((ca = GetIfCertExist(url.getHost())) != null) {
		        	        // init a default key store
		        	        String keyStoreType = KeyStore.getDefaultType();
		        	        KeyStore keyStore = KeyStore.getInstance(keyStoreType);
		        	        keyStore.load(null, null);
		        	        keyStore.setCertificateEntry(((X509Certificate) ca).getSubjectDN().getName(), ca);
		        	        
				            // Create a TrustManager that trusts the CAs in our KeyStore
				            String tmfAlgorithm = TrustManagerFactory.getDefaultAlgorithm();
				            TrustManagerFactory tmf = TrustManagerFactory.getInstance(tmfAlgorithm);
				            tmf.init(keyStore);
	
				            // make context to uses our TrustManager
				            context.init(null, tmf.getTrustManagers(), new java.security.SecureRandom());
		        			CNHost = GetCNEasyWay(((X509Certificate) ca).getSubjectX500Principal().getName());;
		        		}
		        		else
		        		{
		        			context.init(null, null, new java.security.SecureRandom());
		        		}
		            	// Tell the URLConnection to use a SocketFactory from our SSLContext
			            urlConnection.setSSLSocketFactory(context.getSocketFactory());
			            
	        		}

	        	}

	            return urlConnection;
	        }
	        catch (Exception ex)
	        {
	            Log.Log("Failed to establish SSL connection to server: " + ex.toString());
	            return null;
	        }
	    }

	 private static Certificate GetIfCertExist(String szHost)
	 {
		 boolean isCertExist = false;
		 Certificate ca = null;
		 try 
		 {
			 KeyStore ks = KeyStore.getInstance("AndroidCAStore");
			 if (ks != null) 
			 {
				 ks.load(null, null);
				 Enumeration aliases = ks.aliases();
				 while (aliases.hasMoreElements()) 
				 {
					 String alias = (String) aliases.nextElement();
					 java.security.cert.X509Certificate cert = (java.security.cert.X509Certificate) ks.getCertificate(alias);
					 Log.Log("Certificate: "+cert.getIssuerDN().getName());
					 if (cert.getIssuerDN().getName().contains(szHost)) {
						 isCertExist = true;
						 ca = ks.getCertificate(alias);
						 break;
					 }
				 }
			 }
		 } catch (IOException e) {
			 e.printStackTrace();
		 } catch (KeyStoreException e) {
			 e.printStackTrace();
		 } catch (NoSuchAlgorithmException e) {
			 e.printStackTrace();
		 } catch (java.security.cert.CertificateException e) {
			 e.printStackTrace();
		 }
		 return ca;
	 }
	 
	 private static String GetCNEasyWay(String subject)
	 {
		 String CN = "";
		 String[] fields = subject.split(",");
		 for(String field :fields)
		 {
			 String[] values = field.split("=");
			 if(values[0].contentEquals("CN"))
				 CN = values[1];
		 }
		 return CN;
	 }
}

