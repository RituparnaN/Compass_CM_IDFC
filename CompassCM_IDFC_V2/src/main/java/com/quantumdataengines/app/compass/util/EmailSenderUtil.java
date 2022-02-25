package com.quantumdataengines.app.compass.util;

import java.util.Arrays;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.schema.Configuration;

@Component
public class EmailSenderUtil {
	private static final Logger log = LoggerFactory.getLogger(EmailSenderUtil.class);
	@Autowired
	private CompassEncryptorDecryptor encryptorDecryptor; 
	private String userName;
	private String password;
	private Properties props = null;
	
	public void sendEmail(Configuration configuration, String password, boolean isTest, boolean isETLEmail, 
			String[] recpTO, String[] recpCC, String[] recpBCC, String[] attachFile, String subject, String content) throws Exception {
		String decPassword = encryptorDecryptor.decrypt(password);
		String smtpHost = configuration.getEmail().getSmtpHost().getValue();
		int smtpPort = configuration.getEmail().getSmtpPort().getValue();
		String authId = "";
		String fromId = "";
		
		String isStaffEmail = "N"; 
		//System.out.println("BCC = "+Arrays.toString(recpBCC));
		//System.out.println("recpBCC.length = "+recpBCC.length);
		
		if(recpBCC != null && recpBCC.length > 0){	
			//System.out.println("BCC present");
			for(int i = 0; i < recpBCC.length; i++) {
				if(recpBCC[i].contains("_STAFF")) {
					authId = configuration.getEmail().getAmlEmail().getAmlEmailId().getValue();
					fromId = recpBCC[i].substring(0, recpBCC[i].indexOf("_")); 
					isStaffEmail = "Y";
				}
			}
		}else if(isETLEmail){
			authId = configuration.getEmail().getEtlEmail().getEtlAuthId().getValue();
			fromId = configuration.getEmail().getEtlEmail().getEtlEmailId().getValue();
		}else{
			authId = configuration.getEmail().getAmlEmail().getAmlAuthId().getValue();
			fromId = configuration.getEmail().getAmlEmail().getAmlEmailId().getValue();
		}
		/*JavaMailSenderImpl emailSender = getJavaEmailSender(smtpHost, smtpPort, authId, decPassword);
		MimeMessage mimeMessage = emailSender.createMimeMessage();*/
		Session m_mailSession = authenticateEMailUser(smtpHost, smtpPort, authId, decPassword);
		MimeMessage mimeMessage = new MimeMessage(m_mailSession);
		try {
			MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);
			mimeMessageHelper.setFrom(fromId);
			log.info("Email will be sent from "+fromId);
			
			if(isTest){
				InternetAddress[] inetAddrTO = new InternetAddress[1];
				inetAddrTO[0] = new InternetAddress(fromId);
				mimeMessageHelper.setTo(inetAddrTO);
			}else{
				if(recpTO == null || recpTO.length == 0){
					throw new NullPointerException("To address should be mentioed");
				}else{
					InternetAddress[] inetAddrTO = new InternetAddress[recpTO.length];
					for(int i = 0; i < recpTO.length; i++)
						inetAddrTO[i] = new InternetAddress(recpTO[i]);
					mimeMessageHelper.setTo(inetAddrTO);
				}
			}
			
			
			if(recpCC != null && recpCC.length > 0){
				InternetAddress[] inetAddrCC = new InternetAddress[recpCC.length];
				for(int i = 0; i < recpCC.length; i++)
					inetAddrCC[i] = new InternetAddress(recpCC[i]);
				mimeMessageHelper.setCc(inetAddrCC);
			}
			
			if(isStaffEmail == "N") {
				if(recpBCC != null && recpBCC.length > 0){
					InternetAddress[] inetAddrBCC = new InternetAddress[recpBCC.length];
					for(int i = 0; i < recpBCC.length; i++) 
							inetAddrBCC[i] = new InternetAddress(recpBCC[i]);
					
					mimeMessageHelper.setBcc(inetAddrBCC);
				}
			}
			
			mimeMessageHelper.setSubject(subject);
			mimeMessageHelper.setText(content, true);
			
			if(attachFile != null && attachFile.length > 0){
				for(String file : attachFile){
					log.info("Attaching file["+file+"] with email...");
					FileSystemResource fileSystemResource = new FileSystemResource(file);
					mimeMessageHelper.addAttachment(fileSystemResource.getFilename(), fileSystemResource);
				}
			}
			log.debug("Email is about to send...");
			//emailSender.send(mimeMessage);
			//System.out.println("Email is about to send...");
			Transport.send(mimeMessage);
			log.info("Email Sent successfully.");
		} catch (MessagingException e) {
			log.error("Error while sending email : "+e.getMessage());
			throw e;
		}
	}

	private JavaMailSenderImpl getJavaEmailSender(String smtpHost, int smtpPort, String authId, String password) throws Exception {
		log.info("Creating mailer[HOST : "+smtpHost+", PORT : "+smtpPort+", AuthID : "+authId+"]");
		JavaMailSenderImpl javaEmailSender = new JavaMailSenderImpl();
		javaEmailSender.setHost(smtpHost);
		javaEmailSender.setPort(smtpPort);
		javaEmailSender.setUsername(authId);
		javaEmailSender.setPassword(password);
		Properties props = new Properties();
		//25/08/2020    props.put("mail.smtp.auth", false);
		//props.put("mail.smtp.starttls.enable", true);
		props.put("mail.smtp.auth", false);
		props.put("mail.smtp.debug", "true");
		//props.put("mail.mime.multipart.allowempty", true);
	/*	props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.mime.multipart.allowempty", "true");*/
		javaEmailSender.setJavaMailProperties(props);
		return javaEmailSender;
	}
	
	private Session authenticateEMailUser(String smtpHost, int smtpPort, String authId, String password) throws Exception{
		Session m_mailSession = null;
		try{
			this.userName = authId;
			this.password = password;
			//System.out.println("1: In authenticateEMailUser : Auth Id " +authId+" , userName = "+ userName + " , And Password Is: " + password);
			props = System.getProperties();
			//System.out.println("2: " + props);
	        props.put("mail.smtp.host", smtpHost);
	        //System.out.println("3: " + smtpHost);
			props.put("mail.smtp.port", smtpPort);
			//System.out.println("3: " + smtpPort);
			props.put("mail.smtp.auth", "false");
			//System.out.println("4: " + smtpPort);
			props.put("mail.smtp.debug", "true");
			
		//props.put("mail.smtp.starttls.enable", "true");
		//props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
			
			Authenticator auth = new SMTPAuthenticator();
			//System.out.println("5: Authenticator auth Is: " + auth);
			//System.out.println("6. props "+props);
			m_mailSession = Session.getInstance(props, auth);
		}catch(Exception e){
			//System.out.println("Exception In authenticateEMailUser Is :"+e.toString());
			throw e;
		}		
		return m_mailSession;
	}
	
	private class SMTPAuthenticator extends javax.mail.Authenticator {
        public PasswordAuthentication getPasswordAuthentication() {
           //System.out.println("In SMTPAuthenticator : " + userName + " , And Password Is: " + password);
           return new PasswordAuthentication(userName, password);
        }
    }
}
