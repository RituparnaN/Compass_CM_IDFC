package com.quantumdataengines.app.compass.service.cdd;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.ConnectException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.Provider;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.CertStore;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CollectionCertStoreParameters;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSSignedDataGenerator;
import org.bouncycastle.util.encoders.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.cdd.CDDFormDAO;
import com.quantumdataengines.app.compass.util.APIBased.DummyHostnameVerifier;
import com.quantumdataengines.app.compass.util.APIBased.DummyTrustManager;
import com.quantumdataengines.app.compass.util.CommonUtil;

@Service
public class CDDFormServiceImpl implements CDDFormService{
	
	@Value("${compass.aml.config.nsdlUserCode}")
	private String nsdlUserCode;
	@Value("${compass.aml.config.nsdlConfigFilePath}")
	private String nsdlConfigFilePath;
	@Value("${compass.aml.config.nsdlConfigPfxFilePath}")
	private String nsdlConfigPfxFilePath;
	@Value("${compass.aml.config.nsdlConfigJksFilePath}")
	private String nsdlConfigJksFilePath;
	@Value("${compass.aml.config.nsdlUrl}")
	private String nsdlUrl;
	@Value("${compass.aml.config.certPassword}")
	private String certPassword;
	@Value("${compass.aml.config.pfxFilePassword}")
	private String pfxFilePassword;
	@Value("${compass.aml.config.nsdlConfigIsJksToBeCreated}")
	private String nsdlConfigIsJksToBeCreated;
	
	@Value("${compass.aml.config.nsdlConfigIsProxyRequired}")
	private String nsdlConfigIsProxyRequired;
	@Value("${compass.aml.config.nsdlConfigIsProxyIPAddress}")
	private String nsdlConfigIsProxyIPAddress;
	@Value("${compass.aml.config.nsdlConfigIsProxyPort}")
	private String nsdlConfigIsProxyPort;
	@Value("${compass.aml.config.nsdlConfigHttpProxyHost}")
	private String nsdlConfigHttpProxyHost;
	@Value("${compass.aml.config.nsdlConfigHttpProxyPort}")
	private String nsdlConfigHttpProxyPort;
	
	@Autowired
	private CDDFormDAO cddFormDAO;

	@Override
	public String finalizeCompassRefNo(String branchCode, String formType) {
		return cddFormDAO.finalizeCompassRefNo(branchCode, formType);
	}
	
	@Override
	public List<Map<String, String>> searchCDD(String compassRefNo, String formType, String ccifNo, String status, String branchCode, String customerName){
		return cddFormDAO.searchCDD(compassRefNo, formType, ccifNo, status, branchCode, customerName);
	}
	
	@Override
	public String startNewCDD(String formType, String compassRefNo, String userBranchCode, String startedBy){
		return cddFormDAO.startNewCDD(formType, compassRefNo, userBranchCode, startedBy);
	}
	
	@Override
	public String startReCDD(String FORMTYPE, String COMPASSREFERENCENO, String userBranchCode, String LASTREVIEWDATE, String previousRiskRating, String userCode){
		return cddFormDAO.startReCDD(FORMTYPE, COMPASSREFERENCENO, userBranchCode, LASTREVIEWDATE, previousRiskRating, userCode);
	}
	
	@Override
	public void createCDDCheckList(String formType, String compassRefNo, String lineNo){
		cddFormDAO.createCDDCheckList(formType, compassRefNo, lineNo);
	}
	
	@Override
	public void cddAuditLog(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message){
		cddFormDAO.cddAuditLog(compassRefNo, lineNo, userCode, userRole, currentStatus, newStatus, message);
	}

	@Override
	public String saveJointHolder(String compassRefNo, String lineNo,
			String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar,
			String relationWithPrimary, String otherRelationWithPrimaty,
			String userCode) {
		return cddFormDAO.saveJointHolder(compassRefNo, lineNo, jointHolderName, 
				jointHolderAddress, jointHolderPan, jointHolderAadhar, relationWithPrimary, otherRelationWithPrimaty, userCode);
	}

	@Override
	public String updateJointHolder(String compassRefNo, String lineNo,
			String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar,
			String relationWithPrimary, String otherRelationWithPrimaty,
			String userCode) {
		return cddFormDAO.updateJointHolder(compassRefNo, lineNo, jointHolderName, 
				jointHolderAddress, jointHolderPan, jointHolderAadhar, relationWithPrimary, otherRelationWithPrimaty, userCode);
	}

	@Override
	public String saveNomineeDetail(String compassRefNo, String lineNo,
			String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar,
			String relationWithPrimary, String otherRelationWithPrimaty,
			String userCode) {
		return cddFormDAO.saveNomineeDetail(compassRefNo, lineNo, nomineeName, 
				nomineeAddress, nomineeDob, nomineeAadhar, relationWithPrimary, otherRelationWithPrimaty, userCode);
	}

	@Override
	public String updateNomineeDetail(String compassRefNo, String lineNo,
			String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar,
			String relationWithPrimary, String otherRelationWithPrimaty,
			String userCode) {
		return cddFormDAO.updateNomineeDetail(compassRefNo, lineNo, nomineeName, 
				nomineeAddress, nomineeDob, nomineeAadhar, relationWithPrimary, otherRelationWithPrimaty, userCode);
	}

	@Override
	public String updateScreeningResult(String compassRefNo, String lineNo, String type, String screeningMatch, String sanctionList, String userCode){
		return cddFormDAO.updateScreeningResult(compassRefNo, lineNo, type, screeningMatch, sanctionList, userCode);
	}
	
	@Override
	public String removeEntity(String type, String compassRefNo, String lineNo){
		return cddFormDAO.removeEntity(type, compassRefNo, lineNo);
	}

	@Override
	public List<Map<String, String>> getAllJointHolderDetails(
			String compassRefNo, String lineNo) {
		return cddFormDAO.getAllJointHolderDetails(compassRefNo, lineNo);
	}
	
	@Override
	public List<Map<String, String>> getAllNomineeDetails(
			String compassRefNo, String lineNo) {
		return cddFormDAO.getAllNomineeDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String saveIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode){
		return cddFormDAO.saveIntermediary(compassRefNo, lineNo, intermediaryName, intermediaryNationality, userCode);
	}
	
	@Override
	public String updateIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode){
		return cddFormDAO.updateIntermediary(compassRefNo, lineNo, intermediaryName, intermediaryNationality, userCode);
	}
	
	@Override
	public List<Map<String, String>> getAllIntermediariesDetails(String compassRefNo, String lineNo){
		return cddFormDAO.getAllIntermediariesDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String savePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode){
		return cddFormDAO.savePEP(compassRefNo, lineNo, pepName, pepNationality, pepPositionInGovt, pepPositionInCompany, userCode);
	}
	
	@Override
	public String updatePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode){
		return cddFormDAO.updatePEP(compassRefNo, lineNo, pepName, pepNationality, pepPositionInGovt, pepPositionInCompany, userCode);
	}
	
	@Override
	public List<Map<String, String>> getAllPEPDetails(String compassRefNo, String lineNo){
		return cddFormDAO.getAllPEPDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String saveBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode){
		return cddFormDAO.saveBeneficialOwner(compassRefNo, lineNo, name, effectiveShareholding, nationality, dateOfBirth, panNo, aadharNo, userCode);
	}
	
	@Override
	public String updateBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode){
		return cddFormDAO.updateBeneficialOwner(compassRefNo, lineNo, name, effectiveShareholding, nationality, dateOfBirth, panNo, aadharNo, userCode);
	}
	
	@Override
	public List<Map<String, String>> getAllBeneficialOwnerDetails(String compassRefNo, String lineNo){
		return cddFormDAO.getAllBeneficialOwnerDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String saveDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode){
		return cddFormDAO.saveDirector(compassRefNo, lineNo, name, address, nationality, dateOfBirth, panNo, aadharNo, userCode);
	}
	
	@Override
	public String updateDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo,String userCode){
		return cddFormDAO.updateDirector(compassRefNo, lineNo, name, address, nationality, dateOfBirth, panNo, aadharNo, userCode);
	}
	
	@Override
	public List<Map<String, String>> getAllDirectorDetails(String compassRefNo, String lineNo){
		return cddFormDAO.getAllDirectorDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String saveAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo, String userCode){
		return cddFormDAO.saveAuthorizedSignatory(compassRefNo, lineNo, name, address, nationality, dateOfBirth, panNo, panNSDLResponse, aadharNo, userCode);
	}
	
	@Override
	public String updateAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo,String userCode){
		return cddFormDAO.updateAuthorizedSignatory(compassRefNo, lineNo, name, address, nationality, dateOfBirth, panNo, panNSDLResponse, aadharNo, userCode);
	}
	
	@Override
	public List<Map<String, String>> getAllAuthorizeSignatoryDetails(String compassRefNo, String lineNo){
		return cddFormDAO.getAllAuthorizeSignatoryDetails(compassRefNo, lineNo);
	}
	
	@Override
	public String getCDDFormFieldData(String field, String compassRefNo, String lineNo){
		return cddFormDAO.getCDDFormFieldData(field, compassRefNo, lineNo);
	}
	
	@Override
	public Map<String, Object> getCDDAuditLog(String compassRefNo, String linoNo){
		return cddFormDAO.getCDDAuditLog(compassRefNo, linoNo);
	}
	
	@Override
	public Map<String, Object> getFormData(String formType, String compassRefNo, String lineNo){
		return cddFormDAO.getFormData(formType, compassRefNo, lineNo);
	}
	
	@Override
	public String setCDDFormStatus(String status, String compassRefNo, String lineNo, String userCode, String userRole){
		return cddFormDAO.setCDDFormStatus(status, compassRefNo, lineNo, userCode, userRole);
	}
	
	@Override
	public void setReCDDStatus(String status, String compassRefNo, String lineNo){
		cddFormDAO.setReCDDStatus(status, compassRefNo, lineNo);
	}
	
	@Override
	public void setCDDNextReviewDate(String reviewDate, String compassRefNo, String lineNo, String userCode){
		cddFormDAO.setCDDNextReviewDate(reviewDate, compassRefNo, lineNo, userCode);
	}
	
	@Override
	public Map<String, String> saveCDDFormData(String userCode, String userRole, Map<String, String> formData, String status, String compassRefNo, String lineNo){
		return cddFormDAO.saveCDDFormData(userCode, userRole, formData, status, compassRefNo, lineNo);
	}
	
	@Override
	public String saveCDDCheckList(Map<String, String> formData, String compassRefNo, String lineNo, String status, String userCode, String userRole){
		setCDDFormStatus(status, compassRefNo, lineNo, userCode, userRole);
		return cddFormDAO.saveCDDCheckList(formData, compassRefNo, lineNo, status, userRole);
	}
	
	@Override
	public String updateAuthSignIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode){
		return cddFormDAO.updateAuthSignIdentificationForm(formData, compassRefNo, lineNo, userCode);
	}
		
	@Override
	public String updateCustomerIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode){
		return cddFormDAO.updateCustomerIdentificationForm(formData, compassRefNo, lineNo, userCode);
	}
	
	@Override
	public List<Map<String, String>> getCDDCountryMaster(){
		return cddFormDAO.getCDDCountryMaster();
	}
	
	@Override
	public List<Map<String, String>> getCDDStockExchangeMaster(){
		return cddFormDAO.getCDDStockExchangeMaster();
	}
	
	@Override
	public List<Map<String, String>> getCDDIndustryOccupationType(){
		return cddFormDAO.getCDDIndustryOccupationType();
	}
	
	@Override
	public List<Map<String, String>> getCDDAttributeType(){
		return cddFormDAO.getCDDAttributeType();
	}
	
	@Override
	public List<Map<String, String>> getCDDSourceOfFund(){
		return cddFormDAO.getCDDSourceOfFund();
	}
	
	@Override
	public List<Map<String, String>> getCDDCurrencyMaster(){
		return cddFormDAO.getCDDCurrencyMaster();
	}
	
	@Override
	public Map<String, String> calculateCorpRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING, String ATTRIBUTETYPERISKRATING){
		return cddFormDAO.calculateCorpRiskRating(CHANNELRISKRATING, PRODUCTRISKRATING, GEOGRAPHICRISKRATING, 
				INDUSTRYTYPERISKRATING, ATTRIBUTETYPERISKRATING);
	}
	
	@Override
	public Map<String, String> calculateIndvRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING){
		return cddFormDAO.calculateIndvRiskRating(CHANNELRISKRATING, PRODUCTRISKRATING, 
				GEOGRAPHICRISKRATING, INDUSTRYTYPERISKRATING);
	}
	
	@Override
	public int checkAccountOpeningKyogi(String compassRefNo, String type){
		return cddFormDAO.checkAccountOpeningKyogi(compassRefNo, type);
	}
	
	@Override
	public void createAFA(String compassRefNo, String kyogiType, String userCode){
		cddFormDAO.createAFA(compassRefNo, kyogiType, userCode);
	}
	
	@Override
	public Map<String, String> getAFAData(String compassRefNo, String lineNo, String kyogiType){
		return cddFormDAO.getAFAData(compassRefNo, lineNo, kyogiType);
	}
	
	@Override
	public String saveAFA(Map<String, String> dataMap, String userCode){
		return cddFormDAO.saveAFA(dataMap, userCode);
	}
	
	@Override
	public String saveScreeningMapping(String compassRefNo, String uniqueNumber, String fileName, String cddFormType, String cddNameType, String cddNameLineNo, String userCode, String userRole, String ipAddress){
		return cddFormDAO.saveScreeningMapping(compassRefNo, uniqueNumber, fileName, cddFormType, cddNameType, cddNameLineNo, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, String> getCDDEmailDetails(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message){
		return cddFormDAO.getCDDEmailDetails(compassRefNo, lineNo, userCode, userRole, currentStatus, newStatus, message);
	}

	// Provider UserProvider = new sun.security.pkcs11.SunPKCS11(nsdlConfigFilePath);
	Provider UserProvider = null ;
	
	@Override
	public String checkPAN(String panNo){
		/*
		X509Certificate myPubCert = null;
		KeyStore ks = null;
		X509Certificate UserCert = null; 
		PrivateKey UserCertPrivKey = null; 
		PublicKey UserCertPubKey = null;
		String alias = null;
		char password[] = certPassword.toCharArray();
		String dataString = nsdlUserCode+"^"+panNo;
		byte[] dataToSign = dataString.getBytes();
		Provider[] provider = Security.getProviders();
		SSLContext sslcontext = null;
		SSLSocketFactory factory = sslcontext.getSocketFactory();
		String signature = "";
		String urlParameters="data=";
		URL url = null;
		HttpsURLConnection connection;
		InputStream is = null;
		String output = "";
		
		try {
			url = new URL(nsdlUrl);
			ks = KeyStore.getInstance("PKCS11", UserProvider); //logging into token
			ks.load(null, password); //Loading Keystore
			Enumeration<String> e = ks.aliases();
			
			while (e.hasMoreElements()) {
				alias = (String) e.nextElement();
				UserCert = (X509Certificate) ks.getCertificate(alias); //Populating UserCert
				UserCertPubKey = (PublicKey) ks.getCertificate(alias).getPublicKey(); //Populating PublicKey
				UserCertPrivKey = (PrivateKey) ks.getKey(alias, password); //Populating PrivateKey reference
			}
			signature = makeSignature(ks, alias, password, dataToSign);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
        try {
        	sslcontext = SSLContext.getInstance("SSL");
        	sslcontext.init(new KeyManager[0], new TrustManager[] { new TrustManager() }, new SecureRandom());
        } catch (NoSuchAlgorithmException e) {
        	e.printStackTrace(System.err);
        } catch (KeyManagementException e) {
        	e.printStackTrace(System.err);
        }
        
        try{
        	urlParameters = urlParameters + URLEncoder.encode(dataString, "UTF-8") +"&signature=" + URLEncoder.encode(signature, "UTF-8");
        }catch(Exception e){        	 
       	 e.printStackTrace();        	 
        }
        
        try{
        	connection = (HttpsURLConnection) url.openConnection();
        	connection.setRequestMethod("POST");
        	connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
        	connection.setRequestProperty("Content-Length", "" + Integer.toString(urlParameters.getBytes().length));
        	connection.setRequestProperty("Content-Language", "en-US");
        	connection.setUseCaches (false);
        	connection.setDoInput(true);
        	connection.setDoOutput(true);
        	connection.setSSLSocketFactory(factory);
        	connection.setHostnameVerifier(new NSDLHostnameVerifier());
        	OutputStream os = connection.getOutputStream();
        	OutputStreamWriter osw = new OutputStreamWriter(os);
        	osw.write(urlParameters);
        	osw.flush();
        	osw.close();
        	is = connection.getInputStream();
        	BufferedReader in = new BufferedReader(new InputStreamReader(is));
        	output = in.readLine();
	 		is.close();
	 		in.close(); 				
		} catch(Exception e){
			e.printStackTrace();
		}
        return output;
        */
		return "";
	}
	
	@Override
	public String validateCustomerPANNo(String compassRefNo, String lineNo, String userCode, String userRole, String ipAddress, String panNo){
		String output = "";
		String dataString = nsdlUserCode+"^"+panNo;
		String digitalSignature = "";
		String panValidationResult = "";
		String panValidationFormattedResult = "";
		if(nsdlConfigIsJksToBeCreated.equalsIgnoreCase("Y")){
		try {
			createJKSFile();
		} catch (Exception e) {
			e.printStackTrace();
		}
		}
		
		try {
			digitalSignature = getDigitalSignature(dataString);
			System.out.println("dataString in validateCustomerPANNo : "+dataString);
			// System.out.println("digitalSignature in validateCustomerPANNo : "+digitalSignature);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			panValidationResult = getPanValidationResult(dataString, digitalSignature);
			System.out.println("panValidationResult in validateCustomerPANNo : "+dataString);
			panValidationFormattedResult = getFormattedResult(panValidationResult);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return panValidationFormattedResult;
	}
	/*
	public String makeSignature(KeyStore ks, String alias, char[] password, byte[] dataToSign) { // PKCS7 Signature generation Starts
		String signature = "";
		try {
			ArrayList<X509Certificate> certList = new ArrayList<X509Certificate>();
			CertStore certs = null;
			PrivateKey privateKey=(PrivateKey) ks.getKey(alias,password.toString().toCharArray());
			X509Certificate myPubCert=(X509Certificate) ks.getCertificate(alias);
			CMSSignedDataGenerator sgen = new CMSSignedDataGenerator();
			Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider ());
			sgen.addSigner(privateKey, myPubCert,CMSSignedDataGenerator.DIGEST_SHA256);
			certList.add(myPubCert);
			certs = (CertStore.getInstance("Collection", new CollectionCertStoreParameters(certList), "BC"));
			sgen.addCertificatesAndCRLs(certs);
			CMSSignedData csd = sgen.generate(new CMSProcessableByteArray(dataToSign),true,null);
			byte[] signedData = csd.getEncoded();
			byte[] signedData64 = Base64.encode(signedData);
			signature = new String(signedData64);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		return signature;
	}
	
	public static class TrustManager implements X509TrustManager {
	       public TrustManager() { }

	       public boolean isClientTrusted(X509Certificate cert[]) {
	    	   return true;
	       }
	       
	       public boolean isServerTrusted(X509Certificate cert[]) {
	       	return true;
	       }

	       public X509Certificate[] getAcceptedIssuers() {
	    	   return new X509Certificate[0];
	       }

	       public void checkClientTrusted(X509Certificate[] arg0, String arg1) throws CertificateException { }

	       public void checkServerTrusted(X509Certificate[] arg0, String arg1) throws CertificateException { }
	}
	
	public static class NSDLHostnameVerifier implements HostnameVerifier {

	    public boolean verify( String urlHostname, String certHostname ) {
	    	return true;
	    }

	    public boolean verify(String arg0, SSLSession arg1) {
	    	return true;
	    }
	}
	*/
	public void createJKSFile(){
        File fileIn = new File(nsdlConfigPfxFilePath);
        File fileOut= new File(nsdlConfigJksFilePath);

        if(!fileIn.canRead())
        {
            System.out.println("Unable to access input keystore: " + fileIn.getPath());
            System.exit(2);
        }
        if(fileOut.exists() && !fileOut.canWrite())
        {
            System.out.println("Output file is not writable: " + fileOut.getPath());
            System.exit(2);
        }
        try{
        KeyStore kspkcs12 = KeyStore.getInstance("pkcs12");
        KeyStore ksjks = KeyStore.getInstance("jks");

        char inphrase[] = pfxFilePassword.toCharArray();
        char outphrase[] = pfxFilePassword.toCharArray();
        
        
        kspkcs12.load(new FileInputStream(fileIn), inphrase);
        ksjks.load(fileOut.exists() ? ((java.io.InputStream) (new FileInputStream(fileOut))) : null, outphrase);
        Enumeration eAliases = kspkcs12.aliases();
        int n = 0;
        do
        {
            if(!eAliases.hasMoreElements())
                break;
            String strAlias = (String)eAliases.nextElement();
            if(kspkcs12.isKeyEntry(strAlias))
            {
                java.security.Key key = kspkcs12.getKey(strAlias, inphrase);
                Certificate chain[] = kspkcs12.getCertificateChain(strAlias);
                ksjks.setKeyEntry(strAlias, key, outphrase, chain);
            }
        } while(true);
        OutputStream out = new FileOutputStream(fileOut);
        ksjks.store(out, outphrase);
        out.close();
        System.out.println("Java Key Store created successfully");
        }
        catch (Throwable e) {
			e.printStackTrace();
			System.out.println("Error While Creating Key Store : "+e.toString());
		}
    }
	
	public String getDigitalSignature(String dataString){
		String digitalSignature = "";
		try{
		KeyStore keystore = KeyStore.getInstance("jks");
		InputStream input = new FileInputStream(nsdlConfigJksFilePath);
		try {
			char[] password=pfxFilePassword.toCharArray();
			keystore.load(input, password);
		} catch (IOException e) {
		} finally {

		}
		
		Enumeration e = keystore.aliases();
		String alias = "";

		if(e!=null)
		{
			while (e.hasMoreElements())
			{
				String  n = (String)e.nextElement();
				if (keystore.isKeyEntry(n))
				{
					alias = n;
				}
			}
		}
		PrivateKey privateKey=(PrivateKey) keystore.getKey(alias, pfxFilePassword.toCharArray());
		X509Certificate myPubCert=(X509Certificate) keystore.getCertificate(alias);
		byte[] dataToSign = dataString.getBytes();
		CMSSignedDataGenerator sgen = new CMSSignedDataGenerator();
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider ());
		sgen.addSigner(privateKey, myPubCert,CMSSignedDataGenerator.DIGEST_SHA1);
		Certificate[] certChain =keystore.getCertificateChain(alias);
		ArrayList certList = new ArrayList();
		CertStore certs = null;
		for (int i=0; i < certChain.length; i++)
			certList.add(certChain[i]); 
		sgen.addCertificatesAndCRLs(CertStore.getInstance("Collection", new CollectionCertStoreParameters(certList), "BC"));
		CMSSignedData csd = sgen.generate(new CMSProcessableByteArray(dataToSign),true, "BC");
		byte[] signedData = csd.getEncoded();
		byte[] signedData64 = Base64.encode(signedData); 
		
		digitalSignature = new String(signedData64);
		// System.out.println("The Value Of Digital Signature For "+dataString+" , is : "+digitalSignature);
		}
        catch (Throwable e) {
			e.printStackTrace();
			System.out.println("Error While Creating Digital Signature is : "+e.toString());
		}
		return digitalSignature;
	}
	
	public String getPanValidationResult(String dataString, String digitalSignature){
		String panValidationResult = "";
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

		String urlOfNsdl = nsdlUrl;
		String data = dataString;
		String signature = digitalSignature;

		SSLContext sslcontext = null;
		try {
			sslcontext = SSLContext.getInstance("SSL");

			sslcontext.init(new KeyManager[0],
					new TrustManager[] { new DummyTrustManager() },
					new SecureRandom());
		} catch (NoSuchAlgorithmException e) {
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			System.out.println("::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce);
			e.printStackTrace(System.err);
		} catch (KeyManagementException e) {
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			System.out.println("::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce);
			e.printStackTrace(System.err);
		}

		SSLSocketFactory factory = sslcontext.getSocketFactory();


		String urlParameters="data=";
		try{
			urlParameters =urlParameters + URLEncoder.encode(data, "UTF-8") +"&signature=" + URLEncoder.encode(signature, "UTF-8");
		}catch(Exception e){
			logMsg+="::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce;
			System.out.println("::Exception: "+e.getMessage()+" ::Program Start Time:"+startTime+"::nonce= "+nonce);
			e.printStackTrace();
		}

		try{
			URL url;
			HttpsURLConnection connection;
			InputStream is = null;


			String ip=urlOfNsdl;
			url = new URL(ip);
			/*
			System.out.println("URL "+ip);
			System.out.println("nsdlConfigIsProxyRequired:  "+nsdlConfigIsProxyRequired);
			System.out.println("nsdlConfigIsProxyIPAddress:  "+nsdlConfigIsProxyIPAddress);
			System.out.println("nsdlConfigIsProxyPort:  "+nsdlConfigIsProxyPort);
			System.out.println("nsdlConfigHttpProxyHost:  "+nsdlConfigHttpProxyHost);
			System.out.println("nsdlConfigHttpProxyPort:  "+nsdlConfigHttpProxyPort);
			*/
			if(nsdlConfigIsProxyRequired != null && nsdlConfigIsProxyRequired.equalsIgnoreCase("Y"))
			{
			Properties systemProperties = System.getProperties();
			systemProperties.setProperty(nsdlConfigHttpProxyHost, nsdlConfigIsProxyIPAddress);
			systemProperties.setProperty(nsdlConfigHttpProxyPort, nsdlConfigIsProxyPort);
			}
			connection = (HttpsURLConnection) url.openConnection();
			// System.out.println("Proxy ?  "+connection.usingProxy());
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
			System.out.println(":Request Sent At: " + connectionStartTime);
			System.out.println("::Request Data: "+ data);
			osw.close();
			is =connection.getInputStream();
			BufferedReader in = new BufferedReader(new InputStreamReader(is));
			String line =null;
			line = in.readLine();

			System.out.println("Output Result is : "+line);
			panValidationResult = line;
			is.close();
			in.close();
		}
		catch(ConnectException e){
			logMsg+="::Exception: "+e.getMessage() + "::Program Start Time:"+startTime+"::nonce= "+nonce;
			e.printStackTrace();
		}
		catch(Exception e){
			logMsg+="::Exception: "+e.getMessage()+ "::Program Start Time:"+startTime+"::nonce= "+nonce;
			e.printStackTrace();
		}

		return panValidationResult;
	}
	
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
	
	private String getFormattedResult(String panValidationResult){
		String panValidationFormattedResult = "";
		
		if(panValidationResult.equals("2"))
			panValidationFormattedResult = "System Error";
		else if(panValidationResult.equals("3"))
			panValidationFormattedResult = "Authentication Failure";
		else if(panValidationResult.equals("4"))
			panValidationFormattedResult = "User not authorized";
		else if(panValidationResult.equals("5"))
			panValidationFormattedResult = "No PANs Entered";
		else if(panValidationResult.equals("6"))
			panValidationFormattedResult = "User validity has expired";
		else if(panValidationResult.equals("7"))
			panValidationFormattedResult = "Number of PANs exceeds the limit (5)";
		else if(panValidationResult.equals("8"))
			panValidationFormattedResult = "Not enough balance";
		else if(panValidationResult.equals("9"))
			panValidationFormattedResult = "Not an HTTPs request";
		else if(panValidationResult.equals("10"))
			panValidationFormattedResult = "POST method not used";
		else if(panValidationResult.startsWith("1^")){
			String[] valuesArr = CommonUtil.splitString(panValidationResult,"^");
			//1^ASSPK7910R^E^KATHAIT^SANJEEV SINGH^^Shri^24/07/2016^^^
			String returnCode = "Success"; 
			String panNo = valuesArr[1]; 
			String panStatusCode = valuesArr[2];
			String panStatus = panStatusCode;
			if(panStatusCode.equalsIgnoreCase("E"))
				panStatus = "Existing and Valid PAN";
			else if(panStatusCode.equalsIgnoreCase("F")){
				panStatus = "Fake PAN";
				panValidationFormattedResult = "Search Status is : "+returnCode+" And PanStatus Is : "+panStatus; 
			}
			else if(panStatusCode.equalsIgnoreCase("N"))
				panStatus = "Record (PAN) Not Found in ITD Database/Invalid PAN";
			
			String panHolderName = "";
			String panLastUpdatedDate = "";
			if(panStatusCode.equalsIgnoreCase("E")){
				panHolderName = valuesArr[6]+" "+valuesArr[4]+" "+valuesArr[5]+" "+valuesArr[3];
				panLastUpdatedDate = valuesArr[7];
				panValidationFormattedResult = "Search Status is : "+returnCode+" And PanStatus Is : "+panStatus +" In The Name Of : "+panHolderName+ ", Last Pan Updated On : "+panLastUpdatedDate;
			}
			else if(panStatusCode.equalsIgnoreCase("N")){
				panValidationFormattedResult = "Search Status is : "+returnCode+" And PanStatus Is : "+panStatus;
			}
		}
		return panValidationFormattedResult;
	}
	
}
