package com.quantumdataengines.app.compass.util;

import java.security.MessageDigest;
import java.security.spec.KeySpec;
import java.util.regex.Pattern;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.util.HtmlUtils;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

@Component
public class CompassEncryptorDecryptor {
	
	private static final Logger log = LoggerFactory.getLogger(CompassEncryptorDecryptor.class);
	private	 static final String UNICODE_FORMAT = "UTF8";
    private static final String DES_ENCRYPTION_SCHEME = "DES";
    private static KeySpec m_keySpec;
    private static SecretKeyFactory m_secretKeyFactory;
    private static Cipher m_cipher;
    private static byte[] m_keyAsBytes;
    private static String m_encryptionKey;
    private static String m_encryptionScheme;
    static SecretKey key;
    
    static{
    	m_encryptionKey = "QDECOMPASS";
        m_encryptionScheme = DES_ENCRYPTION_SCHEME;
        try {
			m_keyAsBytes = m_encryptionKey.getBytes(UNICODE_FORMAT);		
	        m_keySpec = new DESKeySpec(m_keyAsBytes);
	        m_secretKeyFactory = SecretKeyFactory.getInstance(m_encryptionScheme);
	        m_cipher = Cipher.getInstance(m_encryptionScheme);
	        key = m_secretKeyFactory.generateSecret(m_keySpec);
        } catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public String encrypt(String a_strUnencryptedString) {
        String l_strEncryptedString = null;
        try {
        	m_cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] plainText = a_strUnencryptedString.getBytes(UNICODE_FORMAT);
            byte[] encryptedText = m_cipher.doFinal(plainText);
            BASE64Encoder base64encoder = new BASE64Encoder();
            l_strEncryptedString = base64encoder.encode(encryptedText);
        } catch (Exception e) {
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }
        return l_strEncryptedString;
    }
    
    public String decrypt(String a_strEncryptedString) {
        String l_strEnecryptedText=null;
        try {
        	m_cipher.init(Cipher.DECRYPT_MODE, key);
            BASE64Decoder base64decoder = new BASE64Decoder();
            byte[] encryptedText = base64decoder.decodeBuffer(a_strEncryptedString);
            byte[] plainText = m_cipher.doFinal(encryptedText);
            l_strEnecryptedText= bytes2String(plainText);
        } catch (Exception e) {
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }
        return l_strEnecryptedText;
    }
    
    private static String bytes2String(byte[] bytes) {
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < bytes.length; i++) {
            stringBuffer.append((char) bytes[i]);
        }
        return stringBuffer.toString();
    }
    
    public String hashedPassword(String password, String algorithm){
		String hash = "";
		try{
        MessageDigest md = MessageDigest.getInstance(algorithm);
        md.update(password.getBytes());
        byte[] bytes = md.digest();
		BASE64Encoder base64encoder = new BASE64Encoder();
        hash = base64encoder.encode(bytes);
		}catch(Exception e){
			e.printStackTrace();
		}
		return '{'+algorithm+'}'+hash;
	}
    
    private static Pattern[] patterns = new Pattern[]{
    	//Pattern.compile("(\\()*(\\))*(')*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        //Pattern.compile("\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        //Pattern.compile("(/)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		/*
        Pattern.compile("(=)*(!)*(<)*(>)*(@)*(\\{)*(\\})*(:)*(;)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	// Commented from here
    	Pattern.compile("(<)*(>)*(%)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	*/
    	//Pattern.compile("(alert)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	// Commented till here
        /*
    	Pattern.compile("(\\*)*(\\^)*(%)*(\\+)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("(\\*)(\\')*(%)*(\\+)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        */
        // Script fragments
        Pattern.compile("<script>*</script>", Pattern.CASE_INSENSITIVE),
        // src='...'
        /*
        Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        */
    	// lonely script tags
        //Pattern.compile("</script>", Pattern.CASE_INSENSITIVE),
        /* Changed By Govind On  24th Sep, 2017, Starts Here */
    	Pattern.compile("(var)*", Pattern.CASE_INSENSITIVE),
    	Pattern.compile("(document)*(body)*(window)*(href)*", Pattern.CASE_INSENSITIVE),
    	Pattern.compile("(var)*", Pattern.CASE_INSENSITIVE),
    	Pattern.compile("(window)*(href)*", Pattern.CASE_INSENSITIVE),
        /* Changed By Govind On  24th Sep, 2017, Ends Here */
    	Pattern.compile("<sc(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("</script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("</sc(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // eval(...)
        Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // expression(...)
        Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // javascript:...
        Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
        // vbscript:...
        Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE),
        // onload(...)=...
        Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL)
    };
	
	private static String stripXSS(String parameter, String value) {
    	// System.out.println("Came In XSSRequestWrapper -> stripXSS, Parameter is: "+parameter+"  And Value Is: "+value);
        if (value != null) {
            // NOTE: It's highly recommended to use the ESAPI library and uncomment the following line to
            // avoid encoded attacks.
           //  value = ESAPI.encoder().canonicalize(value);
 
        	// System.out.println("Original Value For parameter: "+parameter+" Is: "+value);
            // Avoid null characters
            value = value.replaceAll("\0", "");
 
            // Remove all sections that match a pattern
            for (Pattern scriptPattern : patterns){
                value = scriptPattern.matcher(value).replaceAll("");
            }
        }
        // System.out.println("Changed Value For parameter: "+parameter+" Is: "+value);
        return value;
    }
	public static void main(String args[]){
    	
    	CompassEncryptorDecryptor decryptor = new CompassEncryptorDecryptor();
    	System.out.println(decryptor.encrypt("Bank_1234"));
    	System.out.println(decryptor.decrypt("pkaHJZZK8C0="));
    	
    	String abc = stripXSS("abc", "<<script>script>promt(1)</s</script>ript>");
    	//abc = stripXSS("abc", "<script>promt(1)</script>");
    	//abc = HtmlUtils.htmlEscape("<sc<script>ript>promt(1)</script>");
    	//System.out.println(decryptor.encrypt("amlcore#321"));
    	//System.out.println(decryptor.decrypt("j6ZTK2FPgYz8IU/3KlqPHQ=="));
    	//System.out.println("abc:  "+abc);
    	
    }
}