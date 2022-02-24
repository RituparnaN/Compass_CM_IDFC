package com.quantumdataengines.app.compass.util;
import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.xml.soap.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

@Component
public class DocumentFromWSDL {

	@Value("${compass.aml.config.documentReceipts.soapEndpointUrl}")
	private String soapEndpointUrl;

	@Value("${compass.aml.config.documentReceipts.soapAction}")
	private String soapAction;

	@Value("${compass.aml.config.documentReceipts.myNamespace}")
	private String myNamespace;

	@Value("${compass.aml.config.documentReceipts.myNamespaceURI}")
	private String myNamespaceURI;

	public Map<String, Object>  getDocument(String customerId, String documentCode) {
        return callSoapWebService(soapEndpointUrl, soapAction, customerId, documentCode);
    }
	
    private Map<String, Object> callSoapWebService(String soapEndpointUrl, String soapAction, String customnerId, String documentCode) {

    	Map<String, Object> documentDetails = new HashMap<String, Object>();
    	//System.out.println("callSoapWebService:   ");
    	//System.out.println("soapEndpointUrl:   "+soapEndpointUrl);
    	//System.out.println("soapAction:   "+soapAction);
    	//System.out.println("myNamespace:   "+myNamespace);
    	//System.out.println("myNamespaceURI:   "+myNamespaceURI);
    	//System.out.println("customnerId:   "+customnerId);
    	//System.out.println("documentCode:   "+documentCode);
    	//System.out.println("callSoapWebService:   ");
		
    	try {
            // Create SOAP Connection
			
            SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
            SOAPConnection soapConnection = soapConnectionFactory.createConnection();

            // Send SOAP Message to SOAP Server
            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(soapAction, customnerId, documentCode), soapEndpointUrl);
		    SOAPBody soapResponsebody = soapResponse.getSOAPBody();
		    //System.out.println(soapResponsebody.getTextContent());
            NodeList nodeList = soapResponsebody.getElementsByTagName("return");
            //System.out.println(" nodeList Length is : "+nodeList.getLength());
			
            NodeList innerResultList = nodeList.item(0).getChildNodes();
            //System.out.println(" innerResultList Length is : "+innerResultList.getLength());

        	System.out.println(" Length is : "+innerResultList.getLength());
        	for (int l = 0; l < innerResultList.getLength(); l++) {
        		Element element = (Element)innerResultList.item(l);
        		//System.out.println("NodeName : "+element.getNodeName()+" And value is : "+element.getTextContent());
				//documentDetails.put(element.getNodeName(), element.getTextContent());
        	}
			
			soapConnection.close();
			
			/*
			byte[] btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(documentDetails.get("imagebinary"));
	        System.out.println("btDataFile:  "+btDataFile);
			File of = new File("D://SOAPFiles//"+"filename."+documentDetails.get("imageExt")); // extension to be passed
			FileOutputStream osf = new FileOutputStream(of);
			osf.write(btDataFile);
			osf.flush();
			*/
			
        } catch (Exception e) {
            System.err.println("\nError occurred while sending SOAP Request to Server!\nMake sure you have the correct endpoint URL and SOAPAction!\n");
            e.printStackTrace();
        }
        return documentDetails;
    }

    private SOAPMessage createSOAPRequest(String soapAction, String customnerId, String documentCode) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        createSoapEnvelope(soapMessage, customnerId, documentCode);
        
        MimeHeaders headers = soapMessage.getMimeHeaders();
        headers.addHeader("SOAPAction", soapAction);

        soapMessage.saveChanges();

        //System.out.println("Request SOAP Message:");
        soapMessage.writeTo(System.out);
        //System.out.println("\n");

        return soapMessage;
    }

    private void createSoapEnvelope(SOAPMessage soapMessage, String customnerId, String documentCode) throws SOAPException {
        SOAPPart soapPart = soapMessage.getSOAPPart();

        SOAPEnvelope envelope = soapPart.getEnvelope();
        envelope.addNamespaceDeclaration(myNamespace, myNamespaceURI);
        
        // SOAP Body
        SOAPBody soapBody = envelope.getBody();
        SOAPElement soapBodyElem = soapBody.addChildElement("OmnidocsImageDownload", myNamespace);
        SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("OmnidocsImageDownload");
        SOAPElement soapBodyElem2 = soapBodyElem1.addChildElement("DOCUMENT_TYPE");
        soapBodyElem2.addTextNode(documentCode);
        SOAPElement soapBodyElem3 = soapBodyElem1.addChildElement("UCIC");
        soapBodyElem3.addTextNode(customnerId);
    }

}
