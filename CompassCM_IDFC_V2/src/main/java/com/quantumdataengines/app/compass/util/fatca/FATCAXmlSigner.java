package com.quantumdataengines.app.compass.util.fatca;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.StringReader;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.crypto.XMLStructure;
import javax.xml.crypto.dom.DOMStructure;
import javax.xml.crypto.dsig.CanonicalizationMethod;
import javax.xml.crypto.dsig.DigestMethod;
import javax.xml.crypto.dsig.Reference;
import javax.xml.crypto.dsig.SignedInfo;
import javax.xml.crypto.dsig.XMLObject;
import javax.xml.crypto.dsig.XMLSignature;
import javax.xml.crypto.dsig.XMLSignatureFactory;
import javax.xml.crypto.dsig.dom.DOMSignContext;
import javax.xml.crypto.dsig.keyinfo.KeyInfo;
import javax.xml.crypto.dsig.keyinfo.KeyInfoFactory;
import javax.xml.crypto.dsig.keyinfo.X509Data;
import javax.xml.crypto.dsig.spec.C14NMethodParameterSpec;
import javax.xml.crypto.dsig.spec.TransformParameterSpec;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;

import com.sun.org.apache.xml.internal.security.Init;
import com.sun.org.apache.xml.internal.security.c14n.Canonicalizer;
import com.sun.org.apache.xml.internal.security.utils.Base64;
import com.sun.org.apache.xml.internal.security.utils.IgnoreAllErrorHandler;

@Component
public class FATCAXmlSigner {
	private static final Logger logger = LoggerFactory.getLogger(FATCAXmlSigner.class);
	
	public static String SIGNATURE_OBJECT_ID = "FATCA";
	public static String SIGNATUER_ALGO = "SHA256withRSA";
	public static String MESSAGE_DIGEST_ALGO = "SHA-256";
	public static String SIGNATURE_DIGEST_METHOD = DigestMethod.SHA256;
	public static String SIGNATURE_METHOD = "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256";
	public static String CANONICALIZATION_METHOD = CanonicalizationMethod.INCLUSIVE;
	
	public static int bufSize = 64 * 1024;

	protected static String rootElm = "Object";
	protected static String digprefix = "<"+rootElm+" xmlns=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"" + SIGNATURE_OBJECT_ID + "\">";
	protected static String digsuffix = "</"+rootElm+">";
	protected static final int STARTTAG = 0;
	protected static final int ENDTAG = 1;
	protected static final int CHUNK = 2;
	
	public boolean useStrmXmlDigestCalcOption1OptionA = true;
	protected ArrayList<String> xmlChunkToCalcDigest = new ArrayList<String>(Arrays.asList(
			"MessageSpec", "ReportingFI", "Sponsor", "Intermediary", "AccountReport", "PoolReport"));
	
	public StringBuilder digestBuf  = null;

	protected XMLSignatureFactory xmlSigFactory = null;
	protected KeyInfoFactory keyInfoFactory = null;
	protected TransformerFactory transformerFactory = null;
	protected SAXParserFactory saxFactory = null;  
	protected Canonicalizer canonicalizer =  null;
	protected DocumentBuilder docBuilder = null;
        
	protected String digestValue = null, signatureValue = null;
	protected MessageDigest messageDigest = null;
	protected ArrayList<String> nsStartTagList = new ArrayList<String>();
	protected ArrayList<String> nsEndTagList = new ArrayList<String>();
	
	public FATCAXmlSigner() {
    	try {
    		
    		
    		Init.init();
    		transformerFactory = TransformerFactory.newInstance();
    		saxFactory = SAXParserFactory.newInstance();  
    		xmlSigFactory = XMLSignatureFactory.getInstance();
            keyInfoFactory = xmlSigFactory.getKeyInfoFactory();
            saxFactory.setNamespaceAware(false);
            canonicalizer = Canonicalizer.getInstance(CANONICALIZATION_METHOD);
            DocumentBuilderFactory dfactory = DocumentBuilderFactory.newInstance();
            dfactory.setNamespaceAware(true);
            //dfactory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, Boolean.TRUE);
            dfactory.setNamespaceAware(true);
            dfactory.setValidating(true);
            docBuilder = dfactory.newDocumentBuilder();
            docBuilder.setErrorHandler(new IgnoreAllErrorHandler());
    	} catch(Exception e) {
    		throw new RuntimeException(e);
    	}
    }
	
	protected boolean signXML(String caseNo, String xmlInputFile, String signedXmlOutputFile, boolean transformXml, PrivateKey signatureKey, X509Certificate signaturePublicCert) throws Exception {
	
		logger.debug("--> signXML(). xmlInputFile=" + xmlInputFile + ", signedXmlOutputFile=" + signedXmlOutputFile + ", transformXml=" + transformXml);
    	boolean ret = false;
        ByteArrayOutputStream baos = null;
        BufferedOutputStream bos = null;
        BufferedInputStream bis = null;
    	try {
    		Node node;
    		Transformer trans;
    		NodeList nodeList;
    		
    		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Parsing FATCA XML File..."));
            logger.debug("parsing xml...." + new Date());
            calcMsgDigestByParsingDoc(xmlInputFile);
    		logger.debug("parsing xml....done. " + new Date());
    		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA XML File parsed"));
    		
    		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Generating signed document..."));
    		Document doc = createSignedDoc(transformXml, signatureKey, signaturePublicCert);
    		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA signed XML document generated. It will be validated and written to a physical file"));
    		
    		nodeList = doc.getElementsByTagName("DigestValue");
            if (nodeList.getLength() > 0) {
            	node = nodeList.item(0);
            	node = node.getFirstChild();
            	node.setNodeValue(digestValue);
            } else
            	throw new Exception("Invalid document structure. Missing <DigestValue> content");
            
            signatureValue = null;
            nodeList = doc.getElementsByTagName("SignedInfo");
            if (nodeList.getLength() > 0) {
            	node = nodeList.item(0); 
                baos = new ByteArrayOutputStream();
                trans = transformerFactory.newTransformer();
                trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
                trans.transform(new DOMSource(node), new StreamResult(baos));
                baos.close();
                if (!Init.isInitialized())
                	Init.init();
                Canonicalizer canon = Canonicalizer.getInstance(CANONICALIZATION_METHOD);
				Signature signature = Signature.getInstance(SIGNATUER_ALGO);
				signature.initSign(signatureKey);
				signature.update(canon.canonicalize(baos.toByteArray()));
				byte[] signatureBuf = signature.sign();
    			signatureValue = Base64.encode(signatureBuf);
    			baos = null;
            } else
            	throw new Exception("Invalid document structure. Missing <SignedInfo> content");
            
            nodeList = doc.getElementsByTagName("SignatureValue");
            if (nodeList.getLength() > 0)
            	nodeList.item(0).getFirstChild().setNodeValue(signatureValue);
            else
            	throw new Exception("Invalid document structure. Missing <SignatureValue> content");
            
            String textContent = null;
    		nodeList = doc.getElementsByTagName("Object");
            if (nodeList.getLength() > 0) {
            	node = nodeList.item(0);
            	node = node.getFirstChild();
            	// Changes For JDK 7 32 Bit
            	// textContent = node.getTextContent();
            } else
            	throw new Exception("Invalid document structure. Missing <Object> content");
            
    		baos = new ByteArrayOutputStream();
            trans = transformerFactory.newTransformer();
            trans.transform(new DOMSource(doc), new StreamResult(baos));
            baos.close();
            String tmp = baos.toString();
            baos = null;
            
            int pos = tmp.indexOf(textContent);
            if (pos == -1)
            	throw new Exception("Invalid document structure or invalid transformation");
            
            String prefix = tmp.substring(0, pos);
            String suffix = tmp.substring(pos + textContent.length());
            bos = new BufferedOutputStream(new FileOutputStream(signedXmlOutputFile));
            bos.write(prefix.getBytes());
            bis = new BufferedInputStream(new FileInputStream(xmlInputFile));
            int len;
            boolean flag = true;
            byte[] tmpBuf = new byte[bufSize];
            while((len = bis.read(tmpBuf)) != -1) {
				if (flag) {
					tmp = new String(tmpBuf, 0, len);
					flag = false;
					if (tmp.startsWith("<?xml")) {
						pos = tmp.indexOf(">");
						if (pos != -1) {
							tmp = tmp.substring(pos+1);
							if (tmp.startsWith("\r\n"))
								tmp = tmp.substring(2);
							if (tmp.startsWith("\n"))
								tmp = tmp.substring(1);
							if (tmp.startsWith("\r"))
								tmp = tmp.substring(1);
						}
					}
					bos.write(tmp.getBytes());
				} else 
					bos.write(tmpBuf, 0, len);
            }
        	bos.write(suffix.getBytes());
        	ret = true;
    	} catch(Exception e) {
    		logger.error(e.getMessage(), e);
    		throw e;
    	} finally {
    		if (bos != null) try{bos.close();}catch(Exception e){}
    		if (bis != null) try{bis.close();}catch(Exception e){}
    		if (baos != null) try{baos.close();}catch(Exception e){}
    	}
    	logger.debug("<--signXML()");
    	return ret;
    }
	
	protected void calcMsgDigestByParsingDoc(String infile) throws Exception {
		logger.debug("--> calcMsgDigestByParsingDoc(). infile=" + infile);
		boolean isStartTag = false, 
				isXmlTagClosed = true;
		StringBuilder parseBuf = new StringBuilder();
		QName qname = null;
		String prefix, tag, qnameS, lastStartTag = null;
		XMLStreamReader reader = null;
		boolean isXmlChunkToCalcDigest = false;
		DocumentBuilder docBuilderNSTrue = null, docBuilderNSFalse = null;
		
		try {
			DocumentBuilderFactory dbfNSTrue = DocumentBuilderFactory.newInstance();
	        dbfNSTrue.setNamespaceAware(true);
	        DocumentBuilderFactory dbfNSFalse = DocumentBuilderFactory.newInstance();
	        dbfNSFalse.setNamespaceAware(false);

            Canonicalizer canonicalizer = Canonicalizer.getInstance(CANONICALIZATION_METHOD);
    		docBuilderNSTrue = dbfNSTrue.newDocumentBuilder();
			docBuilderNSTrue.setErrorHandler(new IgnoreAllErrorHandler());
			docBuilderNSFalse = dbfNSFalse.newDocumentBuilder();
			docBuilderNSFalse.setErrorHandler(new IgnoreAllErrorHandler());
			
			initMessageDigest();
			// Changes For JDK 7 32 Bit
			XMLInputFactory xmlInputFactory = null; // XMLInputFactory.newFactory();
			reader = xmlInputFactory.createXMLStreamReader(new BufferedReader(new FileReader(infile)));
			while(reader.hasNext()) {
				switch(reader.getEventType()) {
				case XMLStreamConstants.START_ELEMENT:
					qname = reader.getName();
					prefix = qname.getPrefix();
					tag = qname.getLocalPart();
					qnameS = (prefix==""?"":prefix+":") + tag;
					if (isStartTag) {
			        	if (!isXmlTagClosed)
			        		parseBuf.append('>');
			       		isXmlTagClosed = true;
			       		if (!isXmlChunkToCalcDigest) {
				       		processXmlFrag(STARTTAG, lastStartTag==null?qnameS:lastStartTag, parseBuf.toString(), messageDigest, 
				       				canonicalizer, docBuilderNSTrue, docBuilderNSFalse);
				       		parseBuf.setLength(0);
			       		}
				    }
			    	if (!isXmlChunkToCalcDigest && xmlChunkToCalcDigest.contains(tag))
			       			isXmlChunkToCalcDigest = true;
				    if (!isXmlTagClosed)
			        	parseBuf.append('>');
				    parseBuf.append('<');
					prefix = qname.getPrefix();
					parseBuf.append(qnameS);
					for (int i = 0; i < reader.getNamespaceCount(); i++) {
						prefix = reader.getNamespacePrefix(i);
						parseBuf.append(" " + (prefix==null?"xmlns":"xmlns:" + prefix) + "=\"" + reader.getNamespaceURI(i) + "\"");
					}
					for (int i = 0; i < reader.getAttributeCount(); i++) {
						prefix = reader.getAttributePrefix(i);
						parseBuf.append(" " + (prefix==""?"":prefix+":") + reader.getAttributeLocalName(i) + "=" + "\""  + reader.getAttributeValue(i) + "\"");
					}
					isXmlTagClosed = false;
					isStartTag = true;
			    	lastStartTag = qnameS;
			    	break;
				case XMLStreamConstants.CHARACTERS:
				case XMLStreamConstants.COMMENT:
					if (!isXmlTagClosed) {
						parseBuf.append(">");
						isXmlTagClosed = true;
					}
					parseBuf.append(reader.getText());
					break;
				case XMLStreamConstants.END_ELEMENT:
					qname = reader.getName();
					prefix = qname.getPrefix();
					tag = qname.getLocalPart();
					qnameS = (prefix==""?"":prefix+":") + tag;
				   	isStartTag = false;
					if (isXmlTagClosed) {
						parseBuf.append("</");
						parseBuf.append(qnameS);
					} else {
						parseBuf.append('/');
					}
					parseBuf.append('>');
			    	isXmlTagClosed = true;
			    	if (isXmlChunkToCalcDigest && xmlChunkToCalcDigest.contains(tag)) {
		       			isXmlChunkToCalcDigest = false;
	       				processXmlFrag(CHUNK, qnameS, parseBuf.toString(), messageDigest, canonicalizer, docBuilderNSTrue, docBuilderNSFalse);
			    		parseBuf.setLength(0);
			    	} else if (!isXmlChunkToCalcDigest) {
			    		if (qnameS.equals(lastStartTag)) {
		       				processXmlFrag(CHUNK, qnameS, parseBuf.toString(), messageDigest, canonicalizer, docBuilderNSTrue, docBuilderNSFalse);
			    		}
			    		else {
		       				processXmlFrag(ENDTAG, qnameS, parseBuf.toString(), messageDigest, canonicalizer, docBuilderNSTrue, docBuilderNSFalse);
			    		}
			    		parseBuf.setLength(0);
			    	}
			    	lastStartTag = null;
			    	break;
				}
				reader.next();
			}
			reader.close();
			reader = null;
			finalizeMessageDigest();
		} finally {
			if (reader != null) try{reader.close();}catch(Exception e){}
		}
		logger.debug("<-- calcMsgDigestByParsingDoc()");
	}
	
	protected void initMessageDigest() throws NoSuchAlgorithmException {
		logger.debug("--> initMessageDigest()");
		digestValue = null;
    	messageDigest = MessageDigest.getInstance(MESSAGE_DIGEST_ALGO);
		messageDigest.update(digprefix.getBytes());
		
		logger.debug("<-- initMessageDigest()");
    }
    
    protected void finalizeMessageDigest() {
		logger.debug("--> finalizeMessageDigest()");
		messageDigest.update(digsuffix.getBytes());
		digestValue = Base64.encode(messageDigest.digest());
		logger.debug("<-- finalizeMessageDigest()");
    }
    
    protected void processXmlFrag(int type, String tag, String val, MessageDigest messageDigest, Canonicalizer canonicalizer, 
    		DocumentBuilder docBuilderNSTrue, DocumentBuilder docBuilderNSFalse) throws Exception {
		logger.trace("--> processXmlFragOption1(). type=" + type + ", tag=" + tag + ", val=" + val);
		
		Document doc;
		String addedStartTag = "", addedEndTag = "", modifiedval = val;
		if (type == STARTTAG) {
			addedEndTag = "</" + tag + ">";
		}
		else if (type == ENDTAG) {
			addedStartTag = "<" + tag + ">";
		}
		addedStartTag = "<elem>" + addedStartTag;
		addedEndTag = addedEndTag + "</elem>";
		modifiedval = addedStartTag + val + addedEndTag;
		
		String digestval = null;
		//both useOption1OptionA = true|false should work. If one fails, try the other
		if (useStrmXmlDigestCalcOption1OptionA) {
			try {
				doc = docBuilderNSTrue.parse(new InputSource(new StringReader(modifiedval)));
				digestval = new String(canonicalizer.canonicalizeSubtree(doc));
			} catch(SAXParseException e) {
				//logger.trace("SAXParseException=" + e.getMessage());
				doc = docBuilderNSFalse.parse(new InputSource(new StringReader(modifiedval)));
				digestval = new String(canonicalizer.canonicalizeSubtree(doc));
			}
		} else {
			if (type == STARTTAG && modifiedval.contains("xmlns")) {
				doc = docBuilderNSTrue.parse(new InputSource(new StringReader(modifiedval)));
			}
			else {
				doc = docBuilderNSFalse.parse(new InputSource(new StringReader(modifiedval)));
			}
			digestval = new String(canonicalizer.canonicalizeSubtree(doc));
		}
		digestval = new String(canonicalizer.canonicalizeSubtree(doc));
		digestval = digestval.replace(addedStartTag, "").replace(addedEndTag, "");
		
		messageDigest.update(digestval.getBytes());
		
		logger.trace("<-- processXmlFragOption1()");
    }
    
    protected Document createSignedDoc(boolean isTransformed, PrivateKey signatureKey, X509Certificate signaturePublicCert) throws Exception {
    	return createSignedDoc(null, isTransformed, signatureKey, signaturePublicCert);
    }

   protected Document createSignedDoc(String xmlInputFile, boolean isTransformed, PrivateKey signatureKey, X509Certificate signaturePublicCert) throws Exception {
		logger.debug("--> createSignedDoc(). xmlInputFile=" + xmlInputFile);
    	BufferedInputStream bis = null;
        Document doc = null;
    	try {
            String uri = "";
            Reference sigref;
            Node node;
        	if (xmlInputFile != null) {
            	bis = new BufferedInputStream(new FileInputStream(xmlInputFile));
    	        doc = docBuilder.parse(bis);
    	        node = doc.getDocumentElement();
        	}
        	else {
        		doc = docBuilder.newDocument();
            	node = doc.createTextNode("text");
        	}
        	XMLStructure content = new DOMStructure(node);
            XMLObject xmlobj = xmlSigFactory.newXMLObject
            	(Collections.singletonList(content), SIGNATURE_OBJECT_ID, null, null);
        	List<XMLObject> xmlObjs = Collections.singletonList(xmlobj);
        	if (!"".equals(SIGNATURE_OBJECT_ID))
        		uri = "#" + SIGNATURE_OBJECT_ID;
	        if (isTransformed)
	        	sigref = xmlSigFactory.newReference(uri, xmlSigFactory.newDigestMethod(SIGNATURE_DIGEST_METHOD, null), 
	        			Collections.singletonList(xmlSigFactory.newTransform(CANONICALIZATION_METHOD, 
	        					(TransformParameterSpec) null)), null, null);
	        else
	        	sigref = xmlSigFactory.newReference(uri, xmlSigFactory.newDigestMethod(SIGNATURE_DIGEST_METHOD, null), null, null, null);
            SignedInfo signedInfo = xmlSigFactory.newSignedInfo(
            		xmlSigFactory.newCanonicalizationMethod(CANONICALIZATION_METHOD, (C14NMethodParameterSpec) null),
            		xmlSigFactory.newSignatureMethod(SIGNATURE_METHOD, null),
            		Collections.singletonList(sigref));
            KeyInfo keyInfo = null;
            if (signaturePublicCert != null) {
	            List<X509Certificate> list = new ArrayList<X509Certificate>();
	            list.add(signaturePublicCert);
	            X509Data kv = keyInfoFactory.newX509Data(list);
	            keyInfo = keyInfoFactory.newKeyInfo(Collections.singletonList(kv));
            }
            XMLSignature signature = xmlSigFactory.newXMLSignature(signedInfo, keyInfo, xmlObjs, null, null);
            DOMSignContext dsc = new DOMSignContext(signatureKey, doc);
            signature.sign(dsc);
    	} catch(Exception e) {
    		logger.error(e.getMessage(), e);
    		throw e;
    	} finally {
    		if (bis != null) try{bis.close();}catch(Exception e){}
    	}
		logger.debug("<-- createSignedDoc()");
    	return doc;
    }
   
   public void signDOM(String xmlInputFile, String signedXmlOutputFile, PrivateKey signatureKey, X509Certificate signaturePublicKey) throws Exception {
	   logger.debug("--> signDOM(). xmlInputFile=" + xmlInputFile + ", signedXmlOutputFile=" + signedXmlOutputFile);
		BufferedOutputStream bos = null;
   	try {
	    	Document doc = createSignedDoc(xmlInputFile, true, signatureKey, signaturePublicKey);
	    	NodeList nodeList = doc.getElementsByTagName("DigestValue");
	        if (nodeList.getLength() > 0)
	        	digestValue = nodeList.item(0).getFirstChild().getNodeValue();
	    	nodeList = doc.getElementsByTagName("SignatureValue");
	        if (nodeList.getLength() > 0)
	        	signatureValue = nodeList.item(0).getFirstChild().getNodeValue();
	    	bos = new BufferedOutputStream(new FileOutputStream(signedXmlOutputFile));
	    	Transformer transformer = transformerFactory.newTransformer();
	        transformer.transform(new DOMSource(doc), new StreamResult(bos));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bos != null) try{bos.close();}catch(Exception e) {}
		}
		logger.debug("<-- signDOM()");
   }
	
	public boolean signStreaming(String caseNo, String xmlInputFile, String signedXmlOutputFile, PrivateKey signatureKey, X509Certificate signaturePublicCert) throws Exception {
		boolean flag = signXML(caseNo, xmlInputFile, signedXmlOutputFile, false, signatureKey, signaturePublicCert);
    	return flag;
	}
	
	public Map<String, String> readIRSPayload(String xmlInputFile) throws Exception {
		Map<String, String> irsPlayloadResult = new HashMap<String, String>();
		String notificationType = "";
		String readFlag = "false";
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		Document doc = null;
		BufferedInputStream bis = null;
		Node node;
		Node searchNode;
		NodeList nodeList;
		try {
			bis = new BufferedInputStream(new FileInputStream(xmlInputFile));
			doc = docBuilder.parse(bis);
			org.w3c.dom.Element root = doc.getDocumentElement();
			for (searchNode = root.getFirstChild(); searchNode != null; searchNode = searchNode.getNextSibling()) {
				if (searchNode.getNodeName().contains(rootElm)) {
					nodeList = searchNode.getChildNodes();
					for (int i = 0; i < nodeList.getLength(); i++) {
						node = nodeList.item(i);
						if (node.getLocalName().contains("FATCAValidFileNotification") || 
								nodeList.item(i).getNodeName().contains("FATCAFileErrorNotification")) {
							readFlag = "true";

							if (node.getLocalName().contains("FATCAValidFileNotification")) {
								notificationType = "validfile";
							}
							if (nodeList.item(i).getNodeName().contains("FATCAFileErrorNotification")) {
								notificationType = "errorfile";
							}
							
							StreamResult result = new StreamResult(buffer);
							DOMSource source = new DOMSource(node);
							TransformerFactory.newInstance().newTransformer().transform(source, result);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		irsPlayloadResult.put("readFlag", readFlag);
		irsPlayloadResult.put("notificationType", notificationType);
		irsPlayloadResult.put("content", new String(buffer.toByteArray()));
		return irsPlayloadResult;
	}
}
