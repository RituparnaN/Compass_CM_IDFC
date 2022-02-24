package com.quantumdataengines.app.compass.util.fatca;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.net.URI;
/* COMMENTED BY GOVIND STARTS HERE */
/*
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
*/
/* COMMENTED BY GOVIND ENSS HERE */
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.util.fatca.senderschema.FATCAEntCommunicationTypeCdType;
import com.quantumdataengines.app.compass.util.fatca.senderschema.FATCAIDESSenderFileMetadataType;
import com.quantumdataengines.app.compass.util.fatca.senderschema.ObjectFactory;

@Component
public class FATCAPackager {
	private static final Logger logger = LoggerFactory.getLogger(FATCAPackager.class);
	//public static String AES_TRANSFORMATION = "AES/ECB/PKCS5Padding";
	public static String AES_TRANSFORMATION = "AES/CBC/PKCS5Padding";
	public static String RSA_TRANSFORMATION = "RSA";
	public static String SECRET_KEY_ALGO = "AES";
	public static int SECRET_KEY_SIZE = 256;
	public static int bufSize = 64 * 1024;
	
	int maxAttempts = 10;

	public static boolean isCanonicalization = true;
	
	protected Long fileId = 0L;
	protected ObjectFactory objFMetadata = new ObjectFactory();
	protected SimpleDateFormat sdfFileName = new SimpleDateFormat("yyyyMMdd'T'HHmmssSSS'Z'");
	protected SimpleDateFormat sdfFileCreateTs = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
	
	public String createPkg(String caseNo, String signedXmlFile, String senderGiin, String receiverGiin,  
			X509Certificate receiverPublicCert, String senderEmailId, int taxyear) throws Exception {
		fileId = 0L;
		return createPkgWithApprover(caseNo, signedXmlFile, senderGiin, receiverGiin, receiverPublicCert, null, null, senderEmailId, taxyear);
	}
	
	public String createPkgWithApprover(String caseNo, String signedXmlFile, String senderGiin, String receiverGiin,  
			X509Certificate receiverPublicCert, String approverGiin, 
			X509Certificate approvercert, String senderEmailId, int taxyear) throws Exception {
		logger.debug("--> createPkgWithApprover(). signedXmlFile= " + signedXmlFile + ", senderGiin=" + senderGiin + 
				", receiverGiin=" + receiverGiin + ", approverGiin=" + approverGiin);
		
		String idesOutFile = null;
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		String fatcaPackageFolder = fatcaFileGeneration.getFatcaPackageFolder();
		
		try {
			Date date = new Date();
			String metadatafile = getFileName(fatcaPackageFolder, senderGiin, "_Metadata.xml");			
			JAXBContext jaxbCtxMetadata = JAXBContext.newInstance(FATCAIDESSenderFileMetadataType.class);            
			Marshaller mrshler = jaxbCtxMetadata.createMarshaller();
			mrshler.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
			
			FATCAIDESSenderFileMetadataType metadata = objFMetadata.createFATCAIDESSenderFileMetadataType();
			JAXBElement<FATCAIDESSenderFileMetadataType> jaxbElemMetadata = objFMetadata.createFATCAIDESSenderFileMetadata(metadata);
			
			metadata.setFATCAEntCommunicationTypeCd(FATCAEntCommunicationTypeCdType.RPT);
			metadata.setFATCAEntitySenderId(senderGiin);
			metadata.setFileRevisionInd(false);
			String senderFileId = getIDESFileName(fatcaPackageFolder, senderGiin);
			File file = new File(senderFileId);
			metadata.setSenderFileId(file.getName());
			metadata.setTaxYear(genTaxYear1(taxyear));
			metadata.setFATCAEntityReceiverId(receiverGiin);
			metadata.setFileCreateTs(sdfFileCreateTs.format(date));
			metadata.setSenderContactEmailAddressTxt(senderEmailId);
			FileWriter fw = new FileWriter(metadatafile);
			mrshler.marshal(jaxbElemMetadata, fw);
			fw.close();
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Metadata file created"));
			
			String xmlzipFilename;
			boolean success = false;
			xmlzipFilename = getFileName(fatcaPackageFolder, senderGiin, "_Payload.zip");
			success = createZipFile(new String[]{signedXmlFile}, xmlzipFilename);
			if (success)
				success = renameZipEntry(xmlzipFilename, getFileName(signedXmlFile), senderGiin + "_Payload.xml");
			if (!success)
				throw new Exception("uanble to create " + xmlzipFilename);
			idesOutFile = senderFileId;
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Payload file created"));
			
			Certificate[] certs = null;
			String[] encryptedAESKeyOutFiles = null;
			
			if (approvercert != null && approverGiin != null) {
				certs = new X509Certificate[] {receiverPublicCert, approvercert};
				encryptedAESKeyOutFiles = new String[]{getFileName(fatcaPackageFolder, receiverGiin, "_Key"), getFileName(fatcaPackageFolder, approverGiin, "_Key")};
			} else if (receiverPublicCert != null){
				certs = new X509Certificate[] {receiverPublicCert};
				encryptedAESKeyOutFiles = new String[]{getFileName(fatcaPackageFolder, receiverGiin, "_Key")};
			} else
				throw new Exception ("both approvingEntityCert and receivingEntityCert is null");
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Key file created"));
						
			String xmlZippedEncryptedFile = getFileName(fatcaPackageFolder, senderGiin, "_Payload");
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Encrypting and Compressing Payload file, Metadata file and Key file..."));
			
			success = encrypt(xmlzipFilename, xmlZippedEncryptedFile, certs, encryptedAESKeyOutFiles);
			if (! success)
				throw new Exception("encryption failed. xmlzipFilename=" + xmlzipFilename);
			int count = 0;
			String[] infiles = new String[encryptedAESKeyOutFiles.length + 2];
			for (count = 0; count < encryptedAESKeyOutFiles.length; count++)
				infiles[count] = encryptedAESKeyOutFiles[count];
			infiles[count++] =  xmlZippedEncryptedFile;
			infiles[count] = metadatafile;
			
			success = createZipFile(infiles, idesOutFile);
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Compressing all files and Generating final File"));
			
			if (success) {
				if (encryptedAESKeyOutFiles.length == 2)
					success = renameZipEntries(idesOutFile, new String[]{getFileName(xmlZippedEncryptedFile), getFileName(metadatafile), 
							getFileName(encryptedAESKeyOutFiles[0]), getFileName(encryptedAESKeyOutFiles[1])},
							new String[]{senderGiin + "_Payload", senderGiin + "_Metadata.xml", 
							receiverGiin + "_Key", approverGiin + "_Key"});
				else
					success = renameZipEntries(idesOutFile, new String[]{getFileName(xmlZippedEncryptedFile), getFileName(metadatafile), 
						getFileName(encryptedAESKeyOutFiles[0])},
						new String[]{senderGiin + "_Payload", senderGiin + "_Metadata.xml", 
						receiverGiin + "_Key"});
			}
			if (!success)
				throw new Exception("unable to create zip file " + idesOutFile);
			for (int i = 0; i < infiles.length; i++)
				deleteFile(infiles[i]);
			deleteFile(xmlzipFilename);
			//deleteFile(signedXmlFile);
			fatcaFileGeneration.setGeneratedZipFile(new File(idesOutFile));
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Final file generated and ready for download and transmission"));
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		logger.debug("<-- createPkgWithApprover()");
		return idesOutFile;
	}
	
	protected String getFileName(String filename) {
		File f = new File(filename);
		return f.getName();
	}
	
	protected String getFileName(String fatcaPackageFolder, String senderGiin, String filename) throws Exception {
		synchronized (fileId) {
			logger.debug("--> getFileName(). senderGiin=" + senderGiin + ", filename=" + filename);
			if (fileId == Long.MAX_VALUE) fileId = 0L;
			String xmlfilename = fatcaPackageFolder + File.separator + senderGiin + "_" + fileId++ + filename;
			File file = new File(xmlfilename);
			int attempts = maxAttempts;
			while(!file.createNewFile() && attempts-- > 0) {
				xmlfilename = fatcaPackageFolder + File.separator + senderGiin + "_" + fileId++ + filename;
				file = new File(xmlfilename);
			}
			if (attempts <= 0)
				throw new Exception ("Unable to getFileName() - file=" + file.getAbsolutePath());
			logger.debug("<-- getFileName()");
			return xmlfilename;
		}
	}
	
	protected String getIDESFileName(String fatcaPackageFolder, String senderGiin) throws Exception {
		synchronized (fileId) {
			logger.debug("--> getIDESFileName(). senderGiin=" + senderGiin);
			Date date = new Date();
			String outfile = fatcaPackageFolder + File.separator + sdfFileName.format(date) + "_" + senderGiin + ".zip";
			File file = new File(outfile);
			int attempts = maxAttempts;
			while (!file.createNewFile() && attempts-- > 0) {
				outfile = fatcaPackageFolder + File.separator + sdfFileName.format(new Date()) + "_" + senderGiin + ".zip";
				file = new File(outfile);
			}
			if (attempts <= 0)
				throw new Exception ("Unable to getFileName() - file=" + file.getAbsolutePath());
			logger.debug("<-- getIDESFileName()");
			return outfile;
		}
	}
	/*
	protected XMLGregorianCalendar genTaxYear(int year) {
		XMLGregorianCalendar taxyear = new XMLGregorianCalendarImpl(new GregorianCalendar());
		taxyear.setTimezone(DatatypeConstants.FIELD_UNDEFINED);
		taxyear.setTime(DatatypeConstants.FIELD_UNDEFINED, DatatypeConstants.FIELD_UNDEFINED, DatatypeConstants.FIELD_UNDEFINED);
		taxyear.setDay(DatatypeConstants.FIELD_UNDEFINED);
		taxyear.setMonth(DatatypeConstants.FIELD_UNDEFINED);
		taxyear.setYear(year);
		return taxyear;
	}
	*/
	public XMLGregorianCalendar genTaxYear1(int year) {
		XMLGregorianCalendar xmlDate = null;
		try {
			xmlDate = DatatypeFactory.newInstance().newXMLGregorianCalendar(new Integer(year).toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return xmlDate;
	}
	
	protected boolean createZipFile(String[] inFiles, String outFile) throws Exception {
		if (logger.isDebugEnabled()) {
			StringBuilder sb = new StringBuilder("--> createZipFile()");
			sb.append(", inFiles=[");
			for (int i = 0; i < inFiles.length; i++) {
				if (i > 0) sb.append(",");
				sb.append(inFiles[i]);
			}
			sb.append("], outFile=");
			sb.append(outFile);
			logger.debug(sb.toString());
		}
		BufferedInputStream bis = null;
		ZipOutputStream zos = null;
		ZipEntry zipEntry;
		int len;
		boolean ret = false;
		String infile;
		byte[] buf = new byte[bufSize];
		try {
			zos = new ZipOutputStream(new FileOutputStream(outFile));
			zos.setLevel(Deflater.BEST_COMPRESSION);
			for (int i = 0; i < inFiles.length; i++) {
				// drop folder names
				infile = inFiles[i];
				len = infile.lastIndexOf("/");
				if (len == -1)
					len = infile.lastIndexOf("\\");
				if (len != -1)
					infile = infile.substring(len+1);
				zipEntry = new ZipEntry(infile);
				zos.putNextEntry(zipEntry);
				bis = new BufferedInputStream(new FileInputStream(inFiles[i]));
				while((len = bis.read(buf)) != -1)
					zos.write(buf, 0, len);
				bis.close(); bis = null;
				zos.closeEntry();
			}
			zos.close(); zos = null;
			ret = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bis != null) try{bis.close();}catch(Exception e) {}
			if (zos != null) try{zos.close();}catch(Exception e) {}
		}
		logger.debug("<-- createZipFile()");
    	return ret;
	}
	
	protected boolean renameZipEntry(String zipFile, String entryName, String newEntryName) throws Exception {
		logger.debug("--> renameZipEntry(). zipFile=" + zipFile + ", entryName=" + entryName + ", newEntryName=" + newEntryName);
		boolean ret = false;
        Map<String, String> props = new HashMap<String, String>(); 
        props.put("create", "false"); 
        try {
            URI zipDisk = URI.create("jar:" + new File(zipFile).toURI());
            /* COMMENTED BY GOVIND STARTS HERE */
            /*
            FileSystem zipfs = FileSystems.newFileSystem(zipDisk, props);
            Path pathInZipfile = zipfs.getPath(entryName);
            Path renamedZipEntry = zipfs.getPath(newEntryName);
            Files.move(pathInZipfile,renamedZipEntry, StandardCopyOption.ATOMIC_MOVE);

            zipfs.close();
            */
            /* COMMENTED BY GOVIND ENDS HERE */

            ret = true;
        } catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
        }
		logger.debug("<-- renameZipEntry()");
		return ret;
	}
	
	protected boolean renameZipEntries(String zipFile, String[] entryNames, String[] newEntryNames) throws Exception {
		if (logger.isDebugEnabled()) {
			StringBuilder sb = new StringBuilder("--> renameZipEntries()");
			sb.append(", zipFile=");
			sb.append(zipFile);
			sb.append(", entryNames=[");
			for (int i = 0; i < entryNames.length; i++) {
				if (i > 0) sb.append(",");
				sb.append(entryNames[i]);
			}
			sb.append("], newEntryNames=[");
			for (int i = 0; i < newEntryNames.length; i++) {
				if (i > 0) sb.append(",");
				sb.append(newEntryNames[i]);
			}
			sb.append("]");
			logger.debug(sb.toString());
		}
		boolean ret = false;
		if (entryNames.length != newEntryNames.length)
			throw new Exception("renameZipEntries entryNames and newEntryNames length should be same");
        Map<String, String> props = new HashMap<String, String>(); 
        props.put("create", "false"); 
        try {
            URI zipDisk = URI.create("jar:" + new File(zipFile).toURI());
            /* COMMENTED BY GOVIND STARTS HERE */
            /*
        	FileSystem zipfs = FileSystems.newFileSystem(zipDisk, props);
        	Path pathInZipfile, renamedZipEntry;
            */
            /* COMMENTED BY GOVIND ENDS HERE */

        	for (int i = 0; i < entryNames.length; i++) {
        		/* COMMENTED BY GOVIND STARTS HERE */
                /*
            	pathInZipfile = zipfs.getPath(entryNames[i]);
                renamedZipEntry = zipfs.getPath(newEntryNames[i]);
                Files.move(pathInZipfile,renamedZipEntry, StandardCopyOption.ATOMIC_MOVE);
            */
            /* COMMENTED BY GOVIND ENDS HERE */
                
        	}
        	
    		/* COMMENTED BY GOVIND STARTS HERE */
            /*
            zipfs.close();
            */
            /* COMMENTED BY GOVIND ENDS HERE */
            ret = true;
        } catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
        }
		logger.debug("<-- renameZipEntries()");
		return ret;
	}
	
	protected boolean encrypt(String zippedSignedPlainTextFile, String cipherTextOutFile, Certificate[] receiversPublicCert,
			String[] encryptedAESKeyOutFiles) throws Exception {
		logger.debug("--> encrypt(). zippedSignedPlainTextFile=" + zippedSignedPlainTextFile + ", cipherTextOutFile=" + cipherTextOutFile);
		PublicKey[] pubkeys = new PublicKey[receiversPublicCert.length];
		for (int i = 0; i < receiversPublicCert.length; i++)
			pubkeys[i] = receiversPublicCert[i].getPublicKey();
		boolean flag = encrypt(zippedSignedPlainTextFile, cipherTextOutFile, pubkeys, encryptedAESKeyOutFiles);
		logger.debug("<-- encrypt()");
		return flag;
	}
	
	/*
	protected boolean encrypt(String zippedSignedPlainTextFile, String cipherTextOutFile, PublicKey[] receiversPublicKey,
			String[] encryptedAESKeyOutFiles) throws Exception {
		logger.debug("--> encrypt(). zippedSignedPlainTextFile=" + zippedSignedPlainTextFile + ", cipherTextOutFile" + cipherTextOutFile);
		boolean ret = false;
		SecretKey skey = null;
		KeyGenerator generator;
		byte[] encryptedAESKeyBuf;
		BufferedOutputStream bos = null;
		Cipher cipher = null;
		try {
			generator = KeyGenerator.getInstance(SECRET_KEY_ALGO);
			generator.init(SECRET_KEY_SIZE);
			skey = generator.generateKey();
			ret = aes(Cipher.ENCRYPT_MODE, zippedSignedPlainTextFile, cipherTextOutFile, skey);
			if (ret) {
				for (int i = 0; i < receiversPublicKey.length && i < encryptedAESKeyOutFiles.length; i++) {
					if (cipher == null)
						cipher = Cipher.getInstance(RSA_TRANSFORMATION);
					cipher.init(Cipher.WRAP_MODE, receiversPublicKey[i]);
					encryptedAESKeyBuf = cipher.wrap(skey);
					bos = new BufferedOutputStream(new FileOutputStream(encryptedAESKeyOutFiles[i]));
					bos.write(encryptedAESKeyBuf);
					bos.close(); bos = null;
				}
				ret = true;
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bos != null) try{bos.close();}catch(Exception e) {}
		}
		logger.debug("<-- encrypt)");
		return ret;
	}
	*/
	
	protected boolean encrypt(String zippedSignedPlainTextFile, String cipherTextOutFile, PublicKey[] receiversPublicKey,
			String[] encryptedAESKeyOutFiles) throws Exception {
		logger.debug("--> encrypt(). zippedSignedPlainTextFile=" + zippedSignedPlainTextFile + ", cipherTextOutFile" + cipherTextOutFile);
		boolean ret = false;
		SecretKey skey = null;
		KeyGenerator generator;
		byte[] encryptedAESKeyBuf;
		BufferedOutputStream bos = null;
		Cipher cipher = null;
		byte[] ivBuf = null;
		try {
			generator = KeyGenerator.getInstance(SECRET_KEY_ALGO);
			generator.init(SECRET_KEY_SIZE);
			skey = generator.generateKey();
			byte[] skeyBuf = skey.getEncoded();
			
			Cipher aesCipher = aes(Cipher.ENCRYPT_MODE, zippedSignedPlainTextFile, cipherTextOutFile, skey);
			if (aesCipher != null) {
				ivBuf = aesCipher.getIV();
				for (int i = 0; i < receiversPublicKey.length && i < encryptedAESKeyOutFiles.length; i++) {
					cipher = Cipher.getInstance(RSA_TRANSFORMATION);
					cipher.init(Cipher.WRAP_MODE, receiversPublicKey[i]);
					if (ivBuf != null) {
						//append 16 bytes IV to 32 bytes aes SecretKey buffer and create 48 bytes SecretKey
						byte[] skeyPlusIvBuf = new byte[skeyBuf.length + ivBuf.length];
						
						System.out.println(skeyPlusIvBuf+"  "+skeyBuf.length +"   "+ ivBuf.length);
						
						System.arraycopy(skeyBuf, 0, skeyPlusIvBuf, 0, skeyBuf.length);
						System.arraycopy(ivBuf, 0, skeyPlusIvBuf, skeyBuf.length, ivBuf.length);
						logger.debug("key buf size=" + skeyPlusIvBuf.length);
						skey = new SecretKeySpec(skeyPlusIvBuf, SECRET_KEY_ALGO);;
					}
					encryptedAESKeyBuf = cipher.wrap(skey);
					bos = new BufferedOutputStream(new FileOutputStream(new File(encryptedAESKeyOutFiles[i])));
					bos.write(encryptedAESKeyBuf);
					bos.close(); bos = null;
				}
				ret = true;
			}
			/*
			if (ret) {
				for (int i = 0; i < receiversPublicKey.length && i < encryptedAESKeyOutFiles.length; i++) {
					if (cipher == null)
						cipher = Cipher.getInstance(RSA_TRANSFORMATION);
					cipher.init(Cipher.WRAP_MODE, receiversPublicKey[i]);
					encryptedAESKeyBuf = cipher.wrap(skey);
					System.out.println("encryptedAESKeyOutFiles : "+encryptedAESKeyOutFiles[i]);
					bos = new BufferedOutputStream(new FileOutputStream(encryptedAESKeyOutFiles[i]));
					bos.write(encryptedAESKeyBuf);
					bos.close(); bos = null;
				}
				ret = true;
			}
			*/
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bos != null) try{bos.close();}catch(Exception e) {}
		}
		logger.debug("<-- encrypt)");
		return ret;
	}
	
	protected Cipher aes(int opmode, String inputFile, String outputFile, SecretKey secretKey) throws Exception {
		logger.debug("--> aes(). opmode=" + (opmode==Cipher.ENCRYPT_MODE?"ENCRYPT":"DECRYPT") + ", inputFile=" + inputFile + ", outputFile=" + outputFile);
		if (opmode != Cipher.ENCRYPT_MODE && opmode != Cipher.DECRYPT_MODE)
			throw new Exception("Invalid opmode " + opmode + ". Allowed opmodes are Cipher.ENCRYPT_MODE or Cipher.DECRYPT_MODE");
		Cipher ret = null;
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		int len;
		byte[] output = null;
		byte[] buf = new byte[8 * 1024];
		Cipher cipher;
		IvParameterSpec iv = null;
		try {
			String transformation = "AES/CBC/PKCS5Padding";
			byte[] ivBuf = null;
			if (opmode == Cipher.DECRYPT_MODE) {
				byte[] skeyBuf = null, skeyIvBuf = secretKey.getEncoded();
				int expectedSKeySizeInBytes = 256/8; 
				if (skeyIvBuf.length > expectedSKeySizeInBytes) {
					//IV is appended to aes key, separate them
					skeyBuf = new byte[expectedSKeySizeInBytes];
					ivBuf = new byte[skeyIvBuf.length - skeyBuf.length];
					System.arraycopy(skeyIvBuf, 0, skeyBuf, 0, skeyBuf.length);
					System.arraycopy(skeyIvBuf, skeyBuf.length, ivBuf, 0, ivBuf.length);
					if (ivBuf.length != 16)
						throw new Exception("incorrect IV size - " + ivBuf.length + " bytes");
					if (skeyBuf.length != expectedSKeySizeInBytes)
						throw new Exception("incorrect KEY size - " + skeyBuf.length + " bytes");
					secretKey = new SecretKeySpec(skeyBuf, SECRET_KEY_ALGO);
					iv = new IvParameterSpec(ivBuf);
				}
			} /*else if (cipherOpMode == AesCipherOpMode.CBC) {
				//CBC encryption. This block is not required as JDK creates IV and uses automatically for CBC for encryption
				ivBuf = new byte[16];
				new SecureRandom().nextBytes(ivBuf);
				iv = new IvParameterSpec(ivBuf);
			}*/
			cipher = Cipher.getInstance(transformation);
			cipher.init(opmode, secretKey, iv);
			bis = new BufferedInputStream(new FileInputStream(new File(inputFile)));
			bos = new BufferedOutputStream(new FileOutputStream(new File(outputFile)));
			while((len = bis.read(buf)) != -1) {
				output = cipher.update(buf, 0, len);
				if (output.length > 0)
					bos.write(output);
			}
			output = cipher.doFinal();
			if (output.length > 0)
				bos.write(output);
			bos.close(); bos = null;
			bis.close(); bis = null; 
			ret = cipher;
		} finally {
			if (bis != null) try{bis.close();}catch(Exception e) {}
			if (bos != null) try{bos.close();}catch(Exception e) {}
		}
		logger.debug("<-- aes()");
		return ret;
	}
	
	/*
	protected boolean aes(int opmode, String inputFile, String outputFile, SecretKey secretKey) throws Exception {
		logger.debug("--> aes(). opmode=" + (opmode==Cipher.ENCRYPT_MODE?"ENCRYPT":"DECRYPT") + 
			", inputFile=" + inputFile + ", outputFile=" + outputFile);
		if (opmode != Cipher.ENCRYPT_MODE && opmode != Cipher.DECRYPT_MODE)
			throw new Exception("Invalid opmode " + opmode + ". Allowed opmodes are Cipher.ENCRYPT_MODE or Cipher.DECRYPT_MODE");
		boolean ret = false;
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		int len;
		byte[] output = null;
		byte[] buf = new byte[bufSize];
		Cipher cipher;
		try {
			cipher = Cipher.getInstance(AES_TRANSFORMATION);
			cipher.init(opmode, secretKey);
			bis = new BufferedInputStream(new FileInputStream(inputFile));
			bos = new BufferedOutputStream(new FileOutputStream(outputFile));
			while((len = bis.read(buf)) != -1) {
				//output = cipher.update(Arrays.copyOf(buf, len));
				output = cipher.update(buf, 0, len);
				if (output.length > 0)
					bos.write(output);
			}
			output = cipher.doFinal();
			if (output.length > 0)
				bos.write(output);
			bos.close(); bos = null;
			bis.close(); bis = null; 
			ret = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bis != null) try{bis.close();}catch(Exception e) {}
			if (bos != null) try{bos.close();}catch(Exception e) {}
		}
		logger.debug("<-- aes()");
		return ret;
	}
	*/
	
	protected void deleteFile(String filename) {
		File file = new File(filename);
		int attempts = maxAttempts;
		while (file.exists() && !file.delete() && attempts-->0)
			Thread.yield();
	}
	
	public boolean unpack(String caseNo, PrivateKey privateKey, boolean isApprover) throws Exception {
		boolean ret = false;
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		String irsNotificationFolder = fatcaFileGeneration.getIRSNotificationFolder();
		
		String idesPkgFile = fatcaFileGeneration.getIRSNotificationFile().getAbsolutePath();
		
		logger.debug("--> unpack(). idesPkg=" + idesPkgFile + ", isApprover=" + isApprover);
				
		try {
			ArrayList<String> entryList = unzipFile(idesPkgFile, irsNotificationFolder);
			String approverKeyFile = null, receiverKeyFile = null, payloadFile = null, metadataFile = null,  receiverGiin = null, filename;
			// get metadata file
			for (int i = 0; i < entryList.size(); i++) {
				filename = entryList.get(i);
				if (filename.contains("Metadata"))
					metadataFile = filename;
				else if (filename.contains("Payload"))
					payloadFile = filename;
				else if (filename.contains("Key")) {
					if (receiverKeyFile == null)
						receiverKeyFile = filename;
					else
						approverKeyFile = filename;
				}
			}
			
			if (metadataFile == null)
				throw new Exception("Invalid package - no metadata file");
			if (payloadFile == null)
				throw new Exception("Invalid package - no payload file");

			if (approverKeyFile != null) {
				JAXBContext jaxbCtxMetadata = JAXBContext.newInstance("com.quantumdataengines.app.fatca.util.metadata");
				Unmarshaller unmrshlr = jaxbCtxMetadata.createUnmarshaller();
				Object obj = unmrshlr.unmarshal(new File(metadataFile));;
				if (obj instanceof JAXBElement<?>) {
					@SuppressWarnings("unchecked")
					JAXBElement<FATCAIDESSenderFileMetadataType> jaxbElem = 
						(JAXBElement<FATCAIDESSenderFileMetadataType>)obj;
					FATCAIDESSenderFileMetadataType metadataObj = jaxbElem.getValue();
					receiverGiin = metadataObj.getFATCAEntityReceiverId();
					if (!receiverKeyFile.contains(receiverGiin)) {
						filename = approverKeyFile;
						approverKeyFile = receiverKeyFile;
						receiverKeyFile = filename;
					}
				}
			} else if (receiverKeyFile != null){
				String onliKeyFileName = new File(receiverKeyFile).getName();
				receiverGiin = onliKeyFileName.substring(0, onliKeyFileName.length() - "_Key".length());
			}
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "All files unpacked"));
			
			if (receiverGiin == null)
				throw new Exception("Invalid metadata file - missing receiver giin or corrupt zip file - no reveiverKeyFile");
			if (isApprover && approverKeyFile == null)
				throw new Exception("Invalid package - no approverKeyFile");
			
			String zippedSignedPlainTextFile = getFileName(irsNotificationFolder, receiverGiin, "_Payload.zip");
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Decrypting file..."));
			
			if (approverKeyFile != null && isApprover)
				ret = decrypt(payloadFile, approverKeyFile, zippedSignedPlainTextFile, privateKey);
			else
				ret = decrypt(payloadFile, receiverKeyFile, zippedSignedPlainTextFile, privateKey);

			if (ret) {
				if (unzipFile(zippedSignedPlainTextFile, irsNotificationFolder) == null)
					ret = false;
				else{
					deleteFile(zippedSignedPlainTextFile);					
				}
			}
			
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "File Decrypted"));
			
			deleteFile(payloadFile);
			//deleteFile(metadataFile);
			deleteFile(receiverKeyFile);
			if (approverKeyFile != null)
				deleteFile(approverKeyFile);
			if (receiverKeyFile != null)
				deleteFile(receiverKeyFile);
			
			File folder = new File(irsNotificationFolder);
			File[] listFile = folder.listFiles();
			for(File f : listFile){
				if(f.getName().contains("_Metadata.xml")){
					fatcaFileGeneration.setIRSMetadataFile(f);
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Stored IRS Metadata file"));
				}
				if(f.getName().contains("_Payload.xml")){
					fatcaFileGeneration.setIRSPayloadFile(f);
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Stored IRS Payload file"));
				}
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		logger.debug("<-- unpack()");
		return ret;
	}
	
	protected ArrayList<String> unzipFile(String inFile, String extractFolder) throws Exception {
		logger.debug("--> unzipFile(). inFile=" + inFile + ", extractFolder=" + extractFolder);
    	BufferedInputStream bis = null;
    	BufferedOutputStream bos = null;
    	int len;
    	ZipFile zipFile = null;
    	Enumeration<? extends ZipEntry> entries;
    	ZipEntry entry;
    	ArrayList<String> entryList = null;
    	byte[] buf = new byte[bufSize];
    	String outFile;
		try {
			if (extractFolder == null)
				extractFolder = ".";
			if (!extractFolder.endsWith("/") && !extractFolder.endsWith("\\"))
				extractFolder += "\\";
			zipFile = new ZipFile(inFile);
	    	entries = zipFile.entries();
	    	while (entries.hasMoreElements()) {
	    		if (entryList == null)
		    		entryList = new ArrayList<String>();
	    		entry = entries.nextElement();
	    		outFile = extractFolder + entry.getName();
	    		entryList.add(outFile);
	    		bis = new BufferedInputStream(zipFile.getInputStream(entry));
	    		bos = new BufferedOutputStream(new FileOutputStream(outFile));
	    		while((len = bis.read(buf)) != -1)
	    			bos.write(buf, 0, len);
	    		bos.close(); bos = null;
	    		bis.close(); bis = null;
	    	}
	    	zipFile.close(); zipFile = null;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bis != null) try{bis.close();}catch(Exception e) {}
			if (bos != null) try{bos.close();}catch(Exception e) {}
			if (zipFile != null) try{zipFile.close();}catch(Exception e) {}
		}
		logger.debug("<-- unzipFile()");
		return entryList;
	}
	
	protected boolean decrypt(String cipherTextFile, String encryptedAESKeyFile, String zippedSignedPlainTextFile, PrivateKey privkey) throws Exception {
		logger.debug("--> decrypt(). cipherTextFile= " + cipherTextFile + ", encryptedAESKeyFile=" + encryptedAESKeyFile + ", zippedSignedPlainTextFile=" + zippedSignedPlainTextFile);
		SecretKey skey;
		boolean ret = false;
		BufferedInputStream bis = null;
		byte[] buf, skeyBuf = null;
		int len, count;
		try {
			buf = new byte[bufSize];			
			bis = new BufferedInputStream(new FileInputStream(encryptedAESKeyFile));
			while((len = bis.read(buf)) != -1) {
				if (skeyBuf == null) {
					skeyBuf = new byte[len];
					System.arraycopy(buf, 0, skeyBuf, 0, len);
				} else {
					count = skeyBuf.length;
					skeyBuf = Arrays.copyOf(skeyBuf, skeyBuf.length + len);
					System.arraycopy(buf, 0, skeyBuf, count, len);
				}
			}
			bis.close(); bis = null;
			Cipher cipher = Cipher.getInstance(RSA_TRANSFORMATION);
			cipher.init(Cipher.UNWRAP_MODE, privkey);
			
			skey = (SecretKey)cipher.unwrap(skeyBuf, SECRET_KEY_ALGO, Cipher.SECRET_KEY);
			//ret = aes(Cipher.DECRYPT_MODE, cipherTextFile, zippedSignedPlainTextFile, skey);
			ret = aes(Cipher.DECRYPT_MODE, cipherTextFile, zippedSignedPlainTextFile, skey) != null ? true : false;;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (bis != null) try{bis.close();}catch(Exception e) {}
		}
		logger.debug("<-- createPkgWithApprover()");
		return ret;
	}
}
