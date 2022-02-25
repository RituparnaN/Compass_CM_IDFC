package com.quantumdataengines.app.compass.util;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;

import javax.xml.soap.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
//import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Properties;

public class SOAPClient {

    public static void main(String args[]) {
        String soapEndpointUrl = "http://10.5.4.122:7003/OmnidocsImageDownloadService/OmnidocsImageDownloadService";
        String soapAction = "http://10.5.4.122:7003/OmnidocsImageDownloadService/OmnidocsImageDownloadService?wsdl";

        	
        callSoapWebService(soapEndpointUrl, soapAction);
    }

    private static void createSoapEnvelope(SOAPMessage soapMessage) throws SOAPException {
        SOAPPart soapPart = soapMessage.getSOAPPart();

        String myNamespace = "ng";
        String myNamespaceURI = "http://ng.webservice.newgen.com/";

        SOAPEnvelope envelope = soapPart.getEnvelope();
        envelope.addNamespaceDeclaration(myNamespace, myNamespaceURI);
        
        // SOAP Body
        SOAPBody soapBody = envelope.getBody();
        SOAPElement soapBodyElem = soapBody.addChildElement("OmnidocsImageDownload", myNamespace);
        SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("OmnidocsImageDownload");
        SOAPElement soapBodyElem2 = soapBodyElem1.addChildElement("DOCUMENT_TYPE");
        soapBodyElem2.addTextNode("ID Proof");
        SOAPElement soapBodyElem3 = soapBodyElem1.addChildElement("UCIC");
        soapBodyElem3.addTextNode("1021384008");
    }

    private static void callSoapWebService(String soapEndpointUrl, String soapAction) {
        try {
            // Create SOAP Connection
			Map<String, String> documentDetails = new HashMap<String, String>();
		
            SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
            SOAPConnection soapConnection = soapConnectionFactory.createConnection();

            // Send SOAP Message to SOAP Server
            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(soapAction), soapEndpointUrl);

            // Print the SOAP Response
            System.out.println("Response SOAP Message:");
            // soapResponse.writeTo(System.out);
            //soapResponse.writeTo(new FileOutputStream(new File("D:\\SOAPFiles\\dmsout.txt")));
            System.out.println("Written To The File ");
           
		    SOAPBody soapResponsebody = soapResponse.getSOAPBody();
            //System.out.println(soapResponsebody.getTextContent());
            NodeList nodeList = soapResponsebody.getElementsByTagName("return");
			System.out.println(" nodeList Length is : "+nodeList.getLength());
			
            NodeList innerResultList = nodeList.item(0).getChildNodes();
			System.out.println(" innerResultList Length is : "+innerResultList.getLength());

        	System.out.println(" Length is : "+innerResultList.getLength());
        	for (int l = 0; l < innerResultList.getLength(); l++) {
        		Element element = (Element)innerResultList.item(l);
        		//System.out.println("NodeName : "+element.getNodeName());
        		//System.out.println("NodeName : "+element.getNodeName()+" And value is : "+element.getTextContent());
				//documentDetails.put(element.getNodeName(), element.getTextContent());
        	}
			
			soapConnection.close();
			byte[] btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(documentDetails.get("imagebinary"));
	        System.out.println("btDataFile:  "+btDataFile);
			File of = new File("D://SOAPFiles//"+"filename."+documentDetails.get("imageExt")); // extension to be passed
			FileOutputStream osf = new FileOutputStream(of);
			osf.write(btDataFile);
			osf.flush();

            /*
    		InputSource is = new InputSource();
    		is.setCharacterStream(new StringReader(soapResponsebody.getTextContent()));
    		
    		DocumentBuilder documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    		Document doc = documentBuilder.parse(is);
    		
    		doc.getDocumentElement().normalize();
    	    String rootELement = doc.getDocumentElement().getNodeName();
    	    NodeList nodeList = doc.getChildNodes();
    	    
    	    for (int i=0; i < nodeList.getLength(); i++) {
    	        Element element = (Element)nodeList.item(i);
    	        if(!element.getNodeName().equals(rootELement))
    	        	System.out.println("NodeName : "+element.getNodeName());
 	        	    System.out.println("NodeValue : "+element.getTextContent());
    	    }
			*/

        } catch (Exception e) {
            System.err.println("\nError occurred while sending SOAP Request to Server!\nMake sure you have the correct endpoint URL and SOAPAction!\n");
            e.printStackTrace();
        }
    }

    private static SOAPMessage createSOAPRequest(String soapAction) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        createSoapEnvelope(soapMessage);
        
        MimeHeaders headers = soapMessage.getMimeHeaders();
        headers.addHeader("SOAPAction", soapAction);

        soapMessage.saveChanges();

        /* Print the request message, just for debugging purposes */
        System.out.println("Request SOAP Message:");
        soapMessage.writeTo(System.out);
        System.out.println("\n");

        return soapMessage;
    }

	private static void parseResponse() throws Exception {
	File file = new File("D:\\SOAPFiles\\dmsout.txt");
	InputStream inputStream= new FileInputStream(file);
	Reader reader = new InputStreamReader(inputStream,"UTF-8");
	InputSource is = new InputSource(reader);
	
	//is.setCharacterStream(new StringReader(soapResponse.getSOAPPart().getTextContent()));
	
	DocumentBuilder documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
	Document doc = documentBuilder.parse(is);
	
	//doc.getDocumentElement().normalize();
	String rootELement = doc.getDocumentElement().getNodeName();
	NodeList nodeList = doc.getElementsByTagName("return");
	//System.out.println(" Length is : "+nodeList.getLength());
	//for (int i=0; i < nodeList.getLength(); i++) {
	NodeList innerResultList = nodeList.item(0).getChildNodes();
	System.out.println(" Length is : "+innerResultList.getLength());
	for (int l = 0; l < innerResultList.getLength(); l++) {
		Element element = (Element)innerResultList.item(l);
		//System.out.println("NodeName : "+element.getNodeName());
		//System.out.println("NodeName : "+element.getNodeName()+" And value is : "+element.getTextContent());
	}
	   /*     
		Element element = (Element)nodeList.item(i);
		 if(!element.getNodeName().equals(rootELement))
			System.out.println("NodeName : "+element.getNodeName()+" And value is : "+element.getTextContent());
			//System.out.println("NodeValue : "+element.getTextContent());
	}
	
	        */
    }


}
