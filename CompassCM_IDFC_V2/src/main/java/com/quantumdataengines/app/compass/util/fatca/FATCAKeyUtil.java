package com.quantumdataengines.app.compass.util.fatca;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Date;
import java.util.Enumeration;

import org.springframework.stereotype.Component;

@Component
public class FATCAKeyUtil {
	
	public X509Certificate getCert(String caseNo, String keystoretype, String keystorefile, String keystorepwd, String alias, String owner) throws Exception {
		X509Certificate cert = null;
		File keystoreFile = new File(keystorefile);
		if(!keystoreFile.exists()){
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Sender Certificate not available in specified path"));
			return cert;
		}
		
		try {
			if(keystoretype.equals("X.509")){
				alias = owner;
				FileInputStream fis = new FileInputStream(keystoreFile);
				BufferedInputStream bis = new BufferedInputStream(fis);
				 CertificateFactory cf = CertificateFactory.getInstance("X.509");
				 
				 cert = (X509Certificate) cf.generateCertificate(bis);
			}else{
				KeyStore keystore = KeyStore.getInstance(keystoretype);
				FileInputStream fis = new FileInputStream(keystoreFile);
				keystore.load(fis, keystorepwd.toCharArray());
				fis.close();
				
				if (alias == null) {
					Enumeration<String> e = keystore.aliases();
					if (e.hasMoreElements())
						alias = e.nextElement();
				}
				if (alias != null) {
					cert = (X509Certificate)keystore.getCertificate(alias);
				}
			}
			if(cert != null){
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), alias+" PublicKey : "+cert.getIssuerX500Principal()));
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), alias+" PublicKey Expiry: "+cert.getNotAfter()));
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), alias+" PublicKey signature algorithm: "+cert.getSigAlgName()));
			}else{
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), alias+" PublicKey not found in the specified Keystore"));
			}
		} catch (Exception e) {
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Could't fetch PrivateKey"));
			throw e;
		}
		return cert;
	}
	
	public PrivateKey getPrivateKey(String caseNo, String keystoretype, String keystorefile, String keystorepwd, String keypwd, String alias) throws Exception {
		if(keystoretype.equals("pkcs12")){
			alias = null;
			keypwd = keystorepwd;
		}
		
		PrivateKey privateKey = null;
		try{
			KeyStore keystore = KeyStore.getInstance(keystoretype);
			File keystoreFile = new File(keystorefile);
			if(!keystoreFile.exists()){
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Sender Keystore not available in specified path"));
				return null;
			}
			FileInputStream fis = new FileInputStream(keystoreFile);
			keystore.load(fis, keystorepwd.toCharArray());
			fis.close();
			if (alias == null) {
				Enumeration<String> e = keystore.aliases();
				if (e.hasMoreElements())
					alias = e.nextElement();
			}
			if (alias != null) {
				privateKey = (PrivateKey)keystore.getKey(alias, keypwd.toCharArray());
				if (privateKey == null)
					privateKey = (PrivateKey)keystore.getKey(alias.toLowerCase(), keypwd.toCharArray());
			}
			if(privateKey != null){
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Sender PrivateKey algorithm : "+privateKey.getAlgorithm()));
			}else{
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Sender PrivateKey not found in the specified Keystore"));
			}
		}catch(Exception e){
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Could't fetch PrivateKey"));
			throw e;
		}
		return privateKey;
	}
}
