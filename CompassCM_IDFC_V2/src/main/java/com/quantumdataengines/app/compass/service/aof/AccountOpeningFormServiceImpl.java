package com.quantumdataengines.app.compass.service.aof;

import java.awt.image.BufferedImage;
import java.awt.image.renderable.ParameterBlock;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.aof.AccountOpeningFormDAO;
import com.quantumdataengines.app.compass.model.AOFMandateFetchStatus;
import com.sun.media.jai.codec.FileSeekableStream;
import com.sun.media.jai.codec.TIFFDecodeParam;

@Service
public class AccountOpeningFormServiceImpl implements AccountOpeningFormService{
	
	@Autowired
	private AccountOpeningFormDAO accountOpeningFormDAO;
	
	public Map<String, String> getAllCountry() {
		return accountOpeningFormDAO.getAllCountry();
	}
	
	public String getCIFNoByAccountNo(String accountNo){
		return accountOpeningFormDAO.getCIFNoByAccountNo(accountNo);
	}
	
	public List<String> getAccountNosByCIFNo(String cifNo){
		return accountOpeningFormDAO.getAccountNosByCIFNo(cifNo);
	}
	public boolean checkCIFNoAccountNo(String cifNo, String accountNo){
		return accountOpeningFormDAO.checkCIFNoAccountNo(cifNo, accountNo);
	}
	public boolean checkCIF(String cifNo){
		return accountOpeningFormDAO.checkCIF(cifNo);
	}
	public boolean checkAccountNo(String accountNo){
		return accountOpeningFormDAO.checkAccountNo(accountNo);
	}
	public Map<String, Object> getAccountOpeningFormData(String cifNumber, String accountNumber, String caseNo, String userCode, String userType){
		return accountOpeningFormDAO.getAccountOpeningFormData(cifNumber, accountNumber, caseNo, userCode, userType);
	}
	public Map<String, Object> getAccountHolderDetails(String accountHolderType, String cifNumber, String accountNumber, String lineNo){
		return accountOpeningFormDAO.getAccountHolderDetails(accountHolderType, cifNumber, accountNumber, lineNo);
	}
	public Map<String, Object> getAccountDetails(String cifNo, String accountNo, String caseNo){
		return accountOpeningFormDAO.getAccountDetails(cifNo, accountNo, caseNo);
	}
	public Map<String, String> getValueAddedServiceDetails(String cifNumber, String accountNumber, String lineNo){
		return accountOpeningFormDAO.getValueAddedServiceDetails(cifNumber, accountNumber, lineNo);
	}
	public Map<String, Object> saveFormData(Map<String, String> formData, String caseNo, String UPDATEDBY, String status){
		return accountOpeningFormDAO.saveFormData(formData, caseNo, UPDATEDBY, status);
	}
	public Map<String, Object> downloadFormUploadFile(String uploadRefNo){
		return accountOpeningFormDAO.downloadFormUploadFile(uploadRefNo);
	}
	public List<Map<String, String>> getFormStatus(String userId, String fromDate, String toDate, String status, boolean isChecker){
		return accountOpeningFormDAO.getFormStatus(userId, fromDate, toDate, status, isChecker);
	}
	public Map<String, String> getFormStatus(String cifNumber, String accNumber){
		return accountOpeningFormDAO.getFormStatus(cifNumber, accNumber);
	}
	public List<Map<String, String>> getFormAuditLog(String cifNumber){
		return accountOpeningFormDAO.getFormAuditLog(cifNumber);
	}
	public String getServerFilePath(String serverFileRefNo){
		return accountOpeningFormDAO.getServerFilePath(serverFileRefNo);
	}
	
	public void truncateServerFilesTable(){
		accountOpeningFormDAO.truncateServerFilesTable();
	}
	
	public Thread fetchAccountOpeningMandate(final String parentPath, final String updateBy){
		Thread fetchingThread = new Thread(new Runnable() {
			AOFMandateFetchStatus aofMandateFetchStatus = AOFMandateFetchStatus.getInstance();
			public void run() {
				boolean shouldRun = true;
				while(shouldRun){
					String filePath = aofMandateFetchStatus.getNextPath();
					if(filePath != null){
						File file = new File(filePath);
						File[] fileList = file.listFiles();
						System.out.println("Currently fetching : "+filePath+". Total Item : "+fileList.length);
						List<Map<String, String>> fileInfoList = new ArrayList<Map<String, String>>();
						for(File subFile : fileList){
							if(subFile.isDirectory()){
								aofMandateFetchStatus.setNewPath(subFile.getAbsolutePath());
								System.out.println(subFile.getAbsolutePath()+" added in the list");
							}else if(subFile.isFile()){
								Map<String, String> fileInfo = new HashMap<String, String>();
								fileInfo.put("FILE_NAME", subFile.getName());
								fileInfo.put("ACCOUNT_NO", subFile.getName().substring(0, subFile.getName().indexOf(".")));
								fileInfo.put("FILE_PATH", subFile.getAbsolutePath());
								fileInfoList.add(fileInfo);
							}else{
								System.out.println(subFile.getAbsolutePath()+" can not be fetched");
							}
						}
						if(fileInfoList.size() > 0){
							int count = accountOpeningFormDAO.saveFetchedAccountOpeningMandateInfo(fileInfoList);
							aofMandateFetchStatus.setCount(count);
						}
						aofMandateFetchStatus.removePath(filePath);
					}else{
						shouldRun = false;
					}
				}
				aofMandateFetchStatus.setStatusCompleted();
				aofMandateFetchStatus.setEndDate(new Date());
				accountOpeningFormDAO.saveMandateFetchStatus(aofMandateFetchStatus.getStartDate().toString(), aofMandateFetchStatus.getEndDate().toString(), 
						parentPath, aofMandateFetchStatus.getCount()+"", updateBy);
			}
		});
		return fetchingThread;
	}
	
	public List<Map<String, String>> getAOFFetchLog(){
		return accountOpeningFormDAO.getAOFFetchLog();
	}

	public String saveValueAddedService(String caseNo,
			Map<String, String> formData, String UPDATEDBY, String status) {
		return accountOpeningFormDAO.saveValueAddedService(caseNo, formData, UPDATEDBY, status);
	}

	public String saveAccountHolderDetails(String caseNo,
			Map<String, String> formData, String accountHolderType,
			String UPDATEDBY, String status, String lineNumber) {
		return accountOpeningFormDAO.saveAccountHolderDetails(caseNo, formData, accountHolderType, UPDATEDBY, status, lineNumber);
	}

	public String saveCheckerResponse(String caseNo, String cifNumber, String accountNo, String remark, String status, String checkedBy, String rejectedFileds, String reasonOfRejection){
		return accountOpeningFormDAO.saveCheckerResponse(caseNo, cifNumber, accountNo, remark, status, checkedBy, rejectedFileds, reasonOfRejection);
	}

	public String deleteDocument(String caseNo, String cifNo, String accountNo,
			String docRefNo, String userCode) {
		return accountOpeningFormDAO.deleteDocument(caseNo, cifNo, accountNo, docRefNo, userCode);
	}

	public String uploadFormDocument(String caseNo, String cifNo,
			String accountNo, String docName, String fileName, File file,
			String status, String uploadBy) {
		return accountOpeningFormDAO.uploadFormDocument(caseNo, cifNo, accountNo, docName, fileName, file, status, uploadBy);
	}
	
	public Map<String, Object> saveAccountData(Map<String, String> formData, String caseNo, String cifNumber, String accNumber, String USERCODE, String status){
		return accountOpeningFormDAO.saveAccountData(formData, caseNo, cifNumber, accNumber, USERCODE, status);
	}
	
	public Map<String, Object> getImageInfo(String serverFileRefNo, int page) throws Exception{
		BufferedImage bufferedImage = null;
		String totalPages = "";
		String currentPages = "";
		String message = "";
		String status = "0";
		
		Map<String, Object> imageDetails = new HashMap<String, Object>();
		
		System.out.println(accountOpeningFormDAO.getServerFilePath(serverFileRefNo));
		
		ImageInputStream is = ImageIO.createImageInputStream(new File(accountOpeningFormDAO.getServerFilePath(serverFileRefNo)));
		if (is == null || is.length() == 0){
			message = "Unable to read file";
		}else{
			Iterator<ImageReader> iterator = ImageIO.getImageReaders(is);
			System.out.println("iterator : "+iterator.hasNext());
			if (iterator == null || !iterator.hasNext()) {
				message = "Unable to parse file format";
			}else{
				ImageReader reader = (ImageReader) iterator.next();
				iterator = null;
				reader.setInput(is);				
				int nbPages = reader.getNumImages(true);
				bufferedImage = reader.read(page-1);
				totalPages = Integer.toString(nbPages);
				currentPages = Integer.toString(page);
				status = "1";
			}
		}
		imageDetails.put("TOTALPAGE", totalPages);
		imageDetails.put("CURRENTPAGE", currentPages);
		imageDetails.put("IMAGE", bufferedImage);
		imageDetails.put("MESSAGE", message);
		imageDetails.put("STATUS", status);
		return imageDetails;
	}
	
	/*
	 * public Map<String, Object> getImageInfo(String serverFileRefNo, int page) throws Exception{
		BufferedImage bufferedImage = null;
		String totalPages = "";
		String currentPages = "";
		String message = "";
		String status = "0";
		
		Map<String, Object> imageDetails = new HashMap<String, Object>();
		
		System.out.println(accountOpeningFormDAO.getServerFilePath(serverFileRefNo));
		
		ImageInputStream is = ImageIO.createImageInputStream(new File(accountOpeningFormDAO.getServerFilePath(serverFileRefNo)));
		if (is == null || is.length() == 0){
			message = "Unable to read file";
		}else{
			Iterator<ImageReader> iterator = ImageIO.getImageReaders(is);
			System.out.println("iterator : "+iterator.hasNext());
			if (iterator == null || !iterator.hasNext()) {
				message = "Unable to parse file format";
			}else{
				ImageReader reader = (ImageReader) iterator.next();
				iterator = null;
				reader.setInput(is);				
				int nbPages = reader.getNumImages(true);
				bufferedImage = reader.read(page-1);
				totalPages = Integer.toString(nbPages);
				currentPages = Integer.toString(page);
				status = "1";
			}
		}
		imageDetails.put("TOTALPAGE", totalPages);
		imageDetails.put("CURRENTPAGE", currentPages);
		imageDetails.put("IMAGE", bufferedImage);
		imageDetails.put("MESSAGE", message);
		imageDetails.put("STATUS", status);
		return imageDetails;
	}
	 */
	
	/*
	public BufferedImage getImageInfo(int page) throws Exception{
		FileSeekableStream stream = new FileSeekableStream("C:\\WAS\\IBM\\WebSphere\\AppServer\\profiles\\QDEServer\\installedApps\\node01Node01Cell\\Compass.ear\\Compass.war\\WEB-INF\\classes\\multipage_tif_example.tif");
		TIFFDecodeParam decodeParam = new TIFFDecodeParam();
		decodeParam.setDecodePaletteAsShorts(true);
		ParameterBlock params = new ParameterBlock();
		params.add(stream);
		RenderedOp image1 = JAI.create("tiff", params);
		BufferedImage img = image1.getAsBufferedImage();
		return img;
	}
	*/
	
	
	public int countCIFForAssign(String branchCode, String cifType, String cifNo, String accountNo, String excludeApproved){
		return accountOpeningFormDAO.countCIFForAssign(branchCode, cifType, cifNo, accountNo, excludeApproved);
	}
	
	public Map<String, List<Map<String, String>>> getBranchCifTypeForAssignCIF(){
		return accountOpeningFormDAO.getBranchCifTypeForAssignCIF();
	}
	
	public Map<String, List<Map<String, String>>> getCheckerMakerCode(){
		return accountOpeningFormDAO.getCheckerMakerCode();
	}
	
	public int assignCIF(String branchCode, String cifType, String cifNo, String accountNo, String noOfCase, String makerCode, String checkerCode, String excludeApproved){
		return accountOpeningFormDAO.assignCIF(branchCode, cifType, cifNo, accountNo, noOfCase, makerCode, checkerCode, excludeApproved);
	}
	
	public List<Map<String, String>> checkCasesForReAssign(String fromDate, String toDate, String branchCode, String cifType, String cifNumber, 
			String accountNo, String makerCode, String checkerCode){
		return accountOpeningFormDAO.checkCasesForReAssign(fromDate, toDate, branchCode, cifType, cifNumber, accountNo, makerCode, checkerCode);
	}
	
	public int reassignCases(String makerId, String checkerId, String caseList){
		return accountOpeningFormDAO.reassignCases(makerId, checkerId, caseList);
	}

	public int unassignCases(String caseList) {
		return accountOpeningFormDAO.unassignCases(caseList);
	}
}
