package com.quantumdataengines.app.compass.util;

import java.io.*;
import java.net.*;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Properties;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.util.*;


public class APIBased {

	public static class DummyTrustManager implements X509TrustManager {

		public DummyTrustManager() {
		}

		public boolean isClientTrusted(X509Certificate cert[]) {
			return true;
		}

		public boolean isServerTrusted(X509Certificate cert[]) {
			return true;
		}

		public X509Certificate[] getAcceptedIssuers() {
			return new X509Certificate[0];
		}

		public void checkClientTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {

		}

		public void checkServerTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {

		}
	}
	public static class DummyHostnameVerifier implements HostnameVerifier {

		public boolean verify( String urlHostname, String certHostname ) {
			return true;
		}

		public boolean verify(String arg0, SSLSession arg1) {
			return true;
		}
	}
	public static void main(String[] args) throws Exception{

		Date startTime=null;
		Calendar c1=Calendar.getInstance();
		startTime=c1.getTime();

		Date connectionStartTime=null;
		String logMsg="\n-";
		BufferedWriter out=null;
		BufferedWriter out1=null;
		FileWriter fstream=null;
		FileWriter fstream1=null;
		Calendar c=Calendar.getInstance();
		long nonce=c.getTimeInMillis();

		String urlOfNsdl="https://59.163.46.2/TIN/PanInquiryBackEnd";
		String data="V0165401^ASSPK7910R";
		String signature="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";

		/*
		Properties prop = new Properties();
	    try {
	        prop.load(new FileInputStream("params.properties"));

	        data=prop.getProperty("data");
	        signature=prop.getProperty("signature");
	        
	        data=prop.getProperty("data");
	        signature=prop.getProperty("signature");
	        

	    } catch (Exception e) {
	    	logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
	    }
		*/
		try{
			fstream= new FileWriter("API_PAN_verification.logs",true);
			out = new BufferedWriter(fstream);
		}
		catch(Exception e){
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			out.write(logMsg);
			out.close();
		}


		SSLContext sslcontext = null;
		try {
			sslcontext = SSLContext.getInstance("SSL");

			sslcontext.init(new KeyManager[0],
					new TrustManager[] { new DummyTrustManager() },
					new SecureRandom());
		} catch (NoSuchAlgorithmException e) {
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			e.printStackTrace(System.err);
			out.write(logMsg);
			out.close();
		} catch (KeyManagementException e) {
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			e.printStackTrace(System.err);
			out.write(logMsg);
			out.close();
		}

		SSLSocketFactory factory = sslcontext.getSocketFactory();


		String urlParameters="data=";
		try{
			urlParameters =urlParameters + URLEncoder.encode(data, "UTF-8") +"&signature=" + URLEncoder.encode(signature, "UTF-8");
		}catch(Exception e){
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			e.printStackTrace();
			out.write(logMsg);
			out.close();
		}

		try{
			URL url;
			HttpsURLConnection connection;
			InputStream is = null;


			String ip=urlOfNsdl;
			url = new URL(ip);
			System.out.println("URL "+ip);
			connection = (HttpsURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
			connection.setRequestProperty("Content-Length", "" + Integer.toString(urlParameters.getBytes().length));
			connection.setRequestProperty("Content-Language", "en-US");
			connection.setUseCaches (false);
			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setSSLSocketFactory(factory);
			connection.setHostnameVerifier(new DummyHostnameVerifier());
			OutputStream os = connection.getOutputStream();
			OutputStreamWriter osw = new OutputStreamWriter(os);
			osw.write(urlParameters);
			osw.flush();
			connectionStartTime=new Date();
			logMsg+="::Request Sent At: " + connectionStartTime;
			logMsg+="::Request Data: "+ data;
			osw.close();
			is =connection.getInputStream();
			BufferedReader in = new BufferedReader(new InputStreamReader(is));
			String line =null;
			line = in.readLine();

			System.out.println("Output: "+line);
			is.close();
			in.close();
		}
		catch(ConnectException e){
			logMsg+="::Exception: "+e.getMessage() + "::Program Start Time:"+startTime+"::nonce= "+nonce;
			out.write(logMsg);
			out.close();
		}
		catch(Exception e){
			logMsg+="::Exception: "+e.getMessage()+ "::Program Start Time:"+startTime+"::nonce= "+nonce;
			out.write(logMsg);
			out.close();
			e.printStackTrace();
		}

		out.write(logMsg);
		out.close();
	}
}
