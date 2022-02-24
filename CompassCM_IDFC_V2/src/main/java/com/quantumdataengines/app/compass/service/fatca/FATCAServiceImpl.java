package com.quantumdataengines.app.compass.service.fatca;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.quantumdataengines.app.compass.dao.fatca.FATCADAO;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.util.fatca.FATCAFileGeneration;
import com.quantumdataengines.app.compass.util.fatca.FATCAKeyUtil;
import com.quantumdataengines.app.compass.util.fatca.FATCAMessage;
import com.quantumdataengines.app.compass.util.fatca.FATCAPackager;
import com.quantumdataengines.app.compass.util.fatca.FATCAReportingStatus;
import com.quantumdataengines.app.compass.util.fatca.FATCAXmlSigner;
import com.quantumdataengines.app.compass.util.fatca.IRSNotificationPDF;
import com.quantumdataengines.app.compass.util.fatca.errorfile.FATCAFileErrorNotificationType;
import com.quantumdataengines.app.compass.util.fatca.validfile.FATCAValidFileNotificationType;

@Service
public class FATCAServiceImpl implements FATCAService{

	@Autowired
	private FATCADAO fatcaDAO;
	@Autowired
	private FATCAKeyUtil fatcaKeyUtil;
	@Autowired
	private FATCAPackager packager;
	@Autowired
	private IRSNotificationPDF irsNotificationPDF; 
	@Autowired
	private CommonService commonService;
	@Autowired
	private FATCAXmlSigner signer;
	@Value("${compass.aml.paths.fatcaXSD}")
	private String fatcaXSD;
	
	public Map<String, String> getFATCAFormData(String caseNo, String userCode){
		
		Map<String, String> formData = fatcaDAO.getFATCAFormData(caseNo, userCode);
		try{
			String reportingPeriod = formData.get("REPORTING_PERIOD");
			String reportingYear = reportingPeriod.substring(0, reportingPeriod.indexOf("-"));
			formData.put("REPORTING_YEAR", reportingYear);
		}catch(Exception e){}
		
		try{
			String reportingTimestamp = formData.get("REPORTING_TIMESTAMP");
			String reportingTimestampDate = reportingTimestamp.substring(0, reportingTimestamp.indexOf("T"));
			formData.put("REPORTING_TIMESTAMP_DATE", reportingTimestampDate);
			
			String reportingTimestampTime = reportingTimestamp.substring(reportingTimestamp.indexOf("T")+1, reportingTimestamp.length() - 1);
			formData.put("REPORTING_TIMESTAMP_TIME", reportingTimestampTime);
		}catch(Exception e){}
		
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
			formData.put("CURRENTYEAR", sdf.format(new Date()));
		}catch(Exception e){}
		
		return formData;
	}
	
	public List<String[]> getAllTitles(){
		return fatcaDAO.getAllTitles();
	}
	
	public List<String[]> getAllCountry(){
		return fatcaDAO.getAllCountry();
	}
	
	public boolean saveFATCAReport(Map<String, String> paramMap, String caseNo,
			String userCode) {
		return fatcaDAO.saveFATCAReport(paramMap, caseNo, userCode);
	}
	
	public boolean saveIndividualDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode){
		return fatcaDAO.saveIndividualDetails(paramMap, caseNo, lineNo, userCode);
	}
	
	public boolean saveAccountHolderDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode){
		return fatcaDAO.saveAccountHolderDetails(paramMap, caseNo, lineNo, userCode);
	}
	
	public List<Map<String, String>> getIndividualDetails(String caseNo, String lineNo, String userCode){
		return fatcaDAO.getIndividualDetails(caseNo, lineNo, userCode);
	}
	
	public List<Map<String, String>> getAccountHolderDetails(String caseNo, String lineNo, String userCode){
		return fatcaDAO.getAccountHolderDetails(caseNo, lineNo, userCode);
	}
	
	public boolean deleteindividualDetails(String caseNo, String lineNo, String userCode){
		return fatcaDAO.deleteindividualDetails(caseNo, lineNo, userCode);
	}
	
	public boolean deleteAccountHolderDetails(String caseNo, String lineNo, String userCode){
		return fatcaDAO.deleteAccountHolderDetails(caseNo, lineNo, userCode);
	}
	
	public HashMap getForm8966XmlFileContent(String caseNo, String userCode){
		Configuration configurarion = commonService.getUserConfiguration();
		return fatcaDAO.getForm8966XmlFileContent(configurarion, caseNo, userCode);
	}
	
	public Map<String, String> fatcaSettings(){
		return fatcaDAO.fatcaSettings();
	}
	
	public boolean updateFATCASettings(Map<String, String> formData, String userCode){
		return fatcaDAO.updateFATCASettings(formData, userCode);
	}
	
	public Map<String, String> getFATCASettings(){
		return fatcaDAO.getFATCASettings(null);
	}
	
	public Thread fatcaFileGeneration(final String caseNo, final String contextPath){
		final Configuration configurarion = commonService.getUserConfiguration();
		final String fatcaFileRootPath = configurarion.getPaths().getIndexingPath()+File.separator+"FATCA"+File.separator;
		
		Thread thread = new Thread(new Runnable() {
			public void run() {
				FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
				// Generation Started
				fatcaFileGeneration.setProgressStatus(0);
				
				String caseFolderPath = fatcaFileRootPath+caseNo;
				fatcaFileGeneration.setCaseFolderPath(caseFolderPath);
				
				File caseFolder = new File(caseFolderPath);
				if(caseFolder.exists()){
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Case Folder already exist"));
				}else{
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Case Folder doesn't exist"));
					caseFolder.mkdirs();
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Case Folder created\n"+caseFolderPath));
				}
				
				fatcaFileGeneration.setProgressStatus(1);
				
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Generating FATCA XML file and storing in FATCA Case Folder"));
				String xmlFile = geterateXMLFile(configurarion, caseNo, caseFolderPath+File.separator+"ORIGINALXML", fatcaFileGeneration.getGeneratedBy());
				System.out.println("xmlFile : "+xmlFile);
				fatcaFileGeneration.setOriginalXMLFile(new File(xmlFile));
				
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "File Generated and Stored"));
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Validating XML file..."));
				boolean isValid = validateXMLFile(caseNo, xmlFile);
				if(isValid){
					fatcaFileGeneration.setMessage("Compass generated XML is valid. You can continue with this.");
					fatcaFileGeneration.setOriginalFileValid(true);
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='green'>Compass generated XML is validated.</font> XML File is ready to process."));
					fatcaFileGeneration.setStatus(4);
				}else{
					fatcaFileGeneration.setMessage("Compass generated XML is not a valid FATCA XML file. You can upload your valid XML.");
					fatcaFileGeneration.setOriginalFileValid(false);
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>Compass generated XML validation is completed with error(s).</font> Do you want to start over ? <a href='javascript:startOver()'>Yes</a>"));
					fatcaFileGeneration.setStatus(4);
				}
				fatcaFileGeneration.setProgressStatus(2);
				storeFATCAStatus(configurarion, caseNo);
			}
		});
		return thread;
	}
	
	public Thread fatcaFileProcessing(final String caseNo, final File xmlFile){
		final Configuration configuration = commonService.getUserConfiguration();
		final Map<String, String> fatcaSettings = fatcaDAO.getFATCASettings(configuration);
		Thread thread = new Thread(new Runnable() {
			public void run() {
				FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
				try{
					fatcaFileGeneration.setProgressStatus(4);
					
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Settings fetched."));
					String fatca_sender_privatekey_type = fatcaSettings.get("SENDER_PRIVATEKEY_TYPE");
					String fatca_sender_privatekey_path = fatcaSettings.get("SENDER_PRIVATEKEY_PATH");
					String fatca_sender_privatekey_alias = fatcaSettings.get("SENDER_PRIVATEKEY_ALIAS");
					String fatca_sender_privatekey_pass = fatcaSettings.get("SENDER_PRIVATEKEY_PASS");
					String fatca_sender_privatekey_storepass = fatcaSettings.get("SENDER_PRIVATEKEY_STOREPASS");
					
					String fatca_sender_publickey_type = fatcaSettings.get("SENDER_PUBLICKEY_TYPE");
					String fatca_sender_publickey_path = fatcaSettings.get("SENDER_PUBLICKEY_PATH");
					String fatca_sender_publickey_alias = fatcaSettings.get("SENDER_PUBLICKEY_ALIAS");
					String fatca_sender_publickey_pass = fatcaSettings.get("SENDER_PUBLICKEY_PASS");
					
					String fatca_sender_giin = fatcaSettings.get("SENDER_GIIN");
					String fatca_sender_email = fatcaSettings.get("SENDERE_EMAIL");
					String fatca_sender_model = fatcaSettings.get("SENDING_MODEL");
					
					String fatca_approver_publickey_type = fatcaSettings.get("APPROVER_PUBLICKEY_TYPE");
					String fatca_approver_publickey_path = fatcaSettings.get("APPROVER_PUBLICKEY_PATH");
					String fatca_approver_publickey_alias = fatcaSettings.get("APPROVER_PUBLICKEY_ALIAS");
					String fatca_approver_publickey_pass = fatcaSettings.get("APPROVER_PUBLICKEY_PASS");
					String fatca_approver_giin = fatcaSettings.get("APPROVER_GIIN");
					
					String fatca_irs_publickey_type = fatcaSettings.get("IRS_PUBLICKEY_TYPE");
					String fatca_irs_publickey_path = fatcaSettings.get("IRS_PUBLICKEY_PATH");
					String fatca_irs_publickey_alias = fatcaSettings.get("IRS_PUBLICKEY_ALIAS");
					String fatca_irs_publickey_pass = fatcaSettings.get("IRS_PUBLICKEY_PASS");
					String fatca_irs_giin = fatcaSettings.get("IRS_GIIN");
					
					int fatca_tax_year = Integer.parseInt(fatcaSettings.get("TAXYEAR"));
					
					PrivateKey senderPrivateKey = fatcaKeyUtil.getPrivateKey(caseNo, fatca_sender_privatekey_type, fatca_sender_privatekey_path, 
							fatca_sender_privatekey_storepass, fatca_sender_privatekey_pass, fatca_sender_privatekey_alias);
					X509Certificate senderPublicKey = fatcaKeyUtil.getCert(caseNo, fatca_sender_publickey_type, fatca_sender_publickey_path, 
							fatca_sender_publickey_pass, fatca_sender_publickey_alias, "Sender");
					X509Certificate irsPublicKey = fatcaKeyUtil.getCert(caseNo, fatca_irs_publickey_type, fatca_irs_publickey_path, 
							fatca_irs_publickey_pass, fatca_irs_publickey_alias, "IRS");
					X509Certificate approverPublicKey = null;
					if(!"2".equals(fatca_sender_model)){
						approverPublicKey = fatcaKeyUtil.getCert(caseNo, fatca_approver_publickey_type, fatca_approver_publickey_path, 
								fatca_approver_publickey_pass, fatca_approver_publickey_alias, "Approver");
					}

					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Communication Email : "+fatca_sender_email));
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Sender GIIN : "+fatca_sender_giin));
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "IRS GIIN : "+fatca_irs_giin));
					if("2".equals(fatca_sender_model)){
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Generating FATCA package using IGA Model 2 for Tax Year : "+fatca_tax_year));
						FATCAPackager.isCanonicalization = false;
			
						String fatcaPackageFolder = fatcaFileGeneration.getCaseFolderPath()+File.separator+"FATCAPACKAGE";
						File signedXMLFileDirectory = new File(fatcaPackageFolder);
						if(signedXMLFileDirectory.exists()){
							FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Deleting existing files from FATCA Final Package folder"));
							File[] fileList = signedXMLFileDirectory.listFiles();
							for(File file : fileList)
								file.delete();
						}else{
							signedXMLFileDirectory.mkdirs();
							FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Final Package folder created"));
						}
						fatcaFileGeneration.setFatcaPackageFolder(fatcaPackageFolder);
						
						InputStream inStream = null;
						OutputStream outStream = null;
						File bfile = null;
						try{
						    bfile = new File(fatcaPackageFolder+File.separator+fatca_sender_giin+".xml");
					
						    inStream = new FileInputStream(fatcaFileGeneration.getXmlFileToProcess());
						    outStream = new FileOutputStream(bfile);
						    
						    byte[] buffer = new byte[1024];
						    int length;
						    while ((length = inStream.read(buffer)) > 0){
						    	outStream.write(buffer, 0, length);
						    }
						    inStream.close();
						    outStream.close();
						}catch(Exception e){}
						
						fatcaFileGeneration.setXmlFileToProcess(bfile);
						String originalXMLFileName = fatcaFileGeneration.getXmlFileToProcess().getName();
						
						String signedXMLFileName = fatcaPackageFolder + File.separator + originalXMLFileName + ".signed";
						
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Digitally Signing FATCA XML File..."));
						boolean flag = signer.signStreaming(caseNo, fatcaFileGeneration.getXmlFileToProcess().getAbsolutePath(), signedXMLFileName, senderPrivateKey, senderPublicKey);
						if(flag){
							signer.signDOM(fatcaFileGeneration.getXmlFileToProcess().getAbsolutePath(), signedXMLFileName, senderPrivateKey, senderPublicKey);
							FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA XML Digital Signing Successful"));
							fatcaFileGeneration.setSignedXMLFile(new File(signedXMLFileName));
							
							fatcaFileGeneration.setMessage("FATCA XML Digital Signing Successful. Signed File created and ready for your download and verify");
							
							packager.createPkg(caseNo, signedXMLFileName, fatca_sender_giin, fatca_irs_giin, irsPublicKey, fatca_sender_email, fatca_tax_year);
							fatcaFileGeneration.setProgressStatus(6);
							
							fatcaFileGeneration.setMessage("FATCA final ZIP file created and ready for your download and transmission to IRDS. Please upload IRS Notification file.");
							fatcaFileGeneration.setStatus(4);
						}else{
							FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Failed to Sign FATCA XML"));
							fatcaFileGeneration.setMessage("Failed to Sign FATCA XML");
							fatcaFileGeneration.setProgressStatus(5);
							fatcaFileGeneration.setEndDate(new Date());
							fatcaFileGeneration.setStatus(3);
						}
					}else{
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Approver GIIN : "+fatca_approver_giin));
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Generating FATCA package using IGA Model 1 for Tax Year : "+fatca_tax_year));
						fatcaFileGeneration.setStatus(4);
					}
				}catch(Exception e){
					e.printStackTrace();
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>FATCA final package generation has been interrupted. "+e.getMessage()+"</font>"));
					fatcaFileGeneration.setProgressStatus(5);
					fatcaFileGeneration.setEndDate(new Date());
					fatcaFileGeneration.setStatus(3);
				}
				storeFATCAStatus(configuration, caseNo);
			}
		});
		return thread;
	}
	
	public Thread unpackIRSNotification(final String caseNo){
		final Configuration configuration = commonService.getUserConfiguration();
		final Map<String, String> fatcaSettings = fatcaDAO.getFATCASettings(configuration);
		Thread Thread = new Thread(new Runnable() {
			public void run() {
				FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
				fatcaFileGeneration.setStatus(1);
				try{
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Settings fetched."));
					String fatca_sender_privatekey_type = fatcaSettings.get("SENDER_PRIVATEKEY_TYPE");
					String fatca_sender_privatekey_path = fatcaSettings.get("SENDER_PRIVATEKEY_PATH");
					String fatca_sender_privatekey_alias = fatcaSettings.get("SENDER_PRIVATEKEY_ALIAS");
					String fatca_sender_privatekey_pass = fatcaSettings.get("SENDER_PRIVATEKEY_PASS");
					String fatca_sender_privatekey_storepass = fatcaSettings.get("SENDER_PRIVATEKEY_STOREPASS");
					String irs_giin = fatcaSettings.get("IRS_GIIN");
					
					fatcaFileGeneration.setMessage("Unwrapping IRS Notification...");
					
					PrivateKey senderPrivateKey = fatcaKeyUtil.getPrivateKey(caseNo, fatca_sender_privatekey_type, fatca_sender_privatekey_path, 
							fatca_sender_privatekey_storepass, fatca_sender_privatekey_pass, fatca_sender_privatekey_alias);
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Unwrapping package..."));
					packager.unpack(caseNo, senderPrivateKey, false);
					fatcaFileGeneration.setMessage("Payload is ready for download and view. You can download FATCA Case folder for this case ("+caseNo+") for future reference.");
					fatcaFileGeneration.setEndDate(new Date());
					fatcaFileGeneration.setStatus(2);
					
					Map<String, String> payloadRead = signer.readIRSPayload(fatcaFileGeneration.getIRSPayloadFile().getAbsolutePath());
					String readFlag = payloadRead.get("readFlag");
					String notificationType = payloadRead.get("notificationType");
					String content = payloadRead.get("content");
					
					if(readFlag.equals("true")){
						fatcaFileGeneration.setPlayloadRead(true);
						
						String iRSPayloadReadFilePath = fatcaFileGeneration.getIRSNotificationFolder() + File.separator + irs_giin+".xml";
						File iRSPayloadReadFile = new File(iRSPayloadReadFilePath);
						PrintWriter writer = new PrintWriter(iRSPayloadReadFile);
						writer.write(content);
						writer.close();
						fatcaFileGeneration.setIRSPayloadReadFile(iRSPayloadReadFile);
						
						if(notificationType.equals("validfile")){
							fatcaFileGeneration.setIRSNotificationType(FATCAValidFileNotificationType.class);
							irsNotificationPDF.generateNotificationPDF(caseNo);
						}else if(notificationType.equals("errorfile")){
							fatcaFileGeneration.setIRSNotificationType(FATCAFileErrorNotificationType.class);
							irsNotificationPDF.generateNotificationPDF(caseNo);
						}
					}else{
						fatcaFileGeneration.setPlayloadRead(false);
					}
					
				}catch(Exception e){
					e.printStackTrace();
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>Couldn't unpack the uploaded IRS notification file. "+e.getMessage()+"</font>"));
					fatcaFileGeneration.setProgressStatus(8);
					fatcaFileGeneration.setEndDate(new Date());
					fatcaFileGeneration.setStatus(3);
				}
				storeFATCAStatus(configuration, caseNo);
			}
		});
		return Thread;
	}
	
	private String geterateXMLFile(Configuration configurarion, String caseNo, String caseFolderPath, String userCode){
		File caseFolder = new File(caseFolderPath);
		if(!caseFolder.exists()){
			caseFolder.mkdirs();
		}
		HashMap xmlFileMap = fatcaDAO.getForm8966XmlFileContent(configurarion, caseNo, userCode);
		
		String xmlFileName = (String) xmlFileMap.get("FILENAME");
		HashMap xmlFileContent = (HashMap) xmlFileMap.get("FILECONTENT");
		
		String outputFile = caseFolderPath+File.separator+xmlFileName;
		try{
			File file = new File(outputFile);
			if (!file.exists()) {
				file.createNewFile();
			}
			
			FileWriter fileWriter = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
			Iterator<String> iterator = xmlFileContent.keySet().iterator();
			while (iterator.hasNext()) {
				String key = iterator.next().toString();
				String value = (String)xmlFileContent.get(key);
				bufferedWriter.write(value);
				bufferedWriter.newLine();
	
			}
			bufferedWriter.close();
		
	    }catch(IOException e){
	    	e.printStackTrace();
	    }
		return outputFile;
	}
	
	public boolean validateXMLFile(String caseNo, String sourceXMLFile){
		boolean isValid = false;
		try {
			InputStream inputStream = new FileInputStream(sourceXMLFile);
			StreamSource streamSource = new StreamSource(inputStream);
			SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			
			System.out.println(fatcaXSD+", File exist :"+new File(fatcaXSD).exists());
			
            Schema schema = factory.newSchema(new File(fatcaXSD));
            
            Validator validator = schema.newValidator();
            validator.setErrorHandler(new XMLErrorHandler(caseNo));
            
            validator.validate(streamSource);
			isValid = true;
			inputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return isValid;
	}
	
	class XMLErrorHandler implements ErrorHandler {
		String caseNo = "";
		public XMLErrorHandler(String caseNo){
			this.caseNo = caseNo;
		}		
		
		public void warning(SAXParseException exception) throws SAXException {
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "XML validation warning at Line : "+exception.getLineNumber()+", Column : "+exception.getColumnNumber()));
		}
		public void error(SAXParseException exception) throws SAXException {
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), exception.getLocalizedMessage()));
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>XML validation error at Line : "+exception.getLineNumber()+", Column : "+exception.getColumnNumber()+"</font>"));
			throw exception;
		}
		public void fatalError(SAXParseException exception) throws SAXException {
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), exception.getLocalizedMessage()));
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>XML validation fatal error at Line : "+exception.getLineNumber()+", Column : "+exception.getColumnNumber()+"</font>"));
			throw exception;
		}
	}
	
	public File generateCaseFolder(String caseFolder){
		String OUTPUT_ZIP_FILE = caseFolder + File.separator + new File(caseFolder).getName()+".zip";
		
		File caseZipFile = new File(OUTPUT_ZIP_FILE);
		if(caseZipFile.exists())
			caseZipFile.delete();
		
		
	    String SOURCE_FOLDER = caseFolder;
	    List<String> fileList = new ArrayList<String>();
	    generateFileList(new File(SOURCE_FOLDER), fileList, SOURCE_FOLDER);
	    zipIt(OUTPUT_ZIP_FILE, fileList, SOURCE_FOLDER);
	    caseZipFile = new File(OUTPUT_ZIP_FILE);
	    return caseZipFile;
	}
	
    private void generateFileList(File node, List<String> fileList, String sourceFolder){
    	if(node.isFile()){
    		fileList.add(generateZipEntry(node.getAbsoluteFile().toString(), sourceFolder));
    	}
    	
    	if(node.isDirectory()){
    		String[] subNote = node.list();
    		for(String filename : subNote){
    			generateFileList(new File(node, filename), fileList, sourceFolder);
    		}
    	}
    }

    private String generateZipEntry(String file, String sourceFolder){
    	return file.substring(sourceFolder.length()+1, file.length());
    }
    
    private void zipIt(String zipFile, List<String> fileList, String sourceFolder){
        byte[] buffer = new byte[1024];
       	
        try{
        	FileOutputStream fos = new FileOutputStream(zipFile);
        	ZipOutputStream zos = new ZipOutputStream(fos);
       		
        	for(String file : fileList){
        		ZipEntry ze= new ZipEntry(file);
        		zos.putNextEntry(ze);                  
        		FileInputStream in = new FileInputStream(sourceFolder + File.separator + file);
          	   
        		int len;
        		while ((len = in.read(buffer)) > 0) {
        			zos.write(buffer, 0, len);
        		}  
        		in.close();
        	}
       	zos.closeEntry();
       	zos.close();
       }catch(IOException ex){
          ex.printStackTrace();   
       }
      }
    

	public void storeFATCAStatus(Configuration configurarion, String caseNo){
		try{
			if(configurarion == null)
				configurarion = commonService.getUserConfiguration();
			FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
			List<FATCAMessage> fatcaMessageList = FATCAReportingStatus.getFATCAMessageList(caseNo);
			fatcaDAO.storeFATCAStatus(configurarion, caseNo, fatcaFileGeneration, fatcaMessageList);
		}catch(Exception e){}
	}
	
	public void removeFATCAStatus(String caseNo){
		fatcaDAO.removeFATCAStatus(caseNo);
	}
	
	public void loadFATCAStatusFromDB(Configuration configurarion, String caseNo){
		if(configurarion == null)
			configurarion = commonService.getUserConfiguration();
		fatcaDAO.loadFATCAStatusFromDB(configurarion, caseNo);
	}
	
	public Map<String, Object> checkIRSNotificationFile(File zipFile){
		String message = "";
		int count = 0;
		boolean isValid = false;
		boolean isMetadataFileAvailable = false;
		boolean isPayloadFileAvailable = false;
		boolean isKeyFileAvailable = false;
				
		FileInputStream fis = null; 
		ZipInputStream zipIs = null; 
		ZipEntry zEntry = null; 
		try { 
			fis = new FileInputStream(zipFile); 
			zipIs = new ZipInputStream(new BufferedInputStream(fis)); 
			
			while((zEntry = zipIs.getNextEntry()) != null){ 
				if(zEntry.getName().endsWith("_Metadata.xml")){
					count++;
					isMetadataFileAvailable = true;
				}else if(zEntry.getName().endsWith("_Payload")){
					count++;
					isPayloadFileAvailable = true;
				}else if(zEntry.getName().endsWith("_Key")){
					count++;
					isKeyFileAvailable = true;
				}
			} 
			zipIs.close(); 
			fis.close();
			
			if(count != 3){
				message = "ZIP file doesn't containt all three important file. ";
				if(!isMetadataFileAvailable)
					message = message + "Metadata file missing. ";
				if(!isPayloadFileAvailable)
					message = message + "Payload file missing. ";
				if(!isKeyFileAvailable)
					message = message + "Key file missing";
			}else{
				isValid = true;
			}
		} catch (FileNotFoundException e) {
			message = e.getMessage();
			e.printStackTrace();
		} catch (IOException e) {
			message = "Corrupt ZIP file. "+e.getMessage();
			e.printStackTrace(); 
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ISVALID", isValid);
		map.put("MESSAGE", message);
		
		return map;
	}
}
