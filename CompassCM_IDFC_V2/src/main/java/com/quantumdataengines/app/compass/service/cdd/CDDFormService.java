package com.quantumdataengines.app.compass.service.cdd;

import java.util.List;
import java.util.Map;

public interface CDDFormService {
	public String finalizeCompassRefNo(String branchCode, String formType);
	public List<Map<String, String>> searchCDD(String compassRefNo, String formType, String ccifNo, String status, String branchCode, String customerName);
	public String startNewCDD(String formType, String compassRefNo, String userBranchCode, String startedBy);
	public String startReCDD(String FORMTYPE, String COMPASSREFERENCENO, String userBranchCode, String LASTREVIEWDATE, String previousRiskRating, String userCode);
	public void createCDDCheckList(String formType, String compassRefNo, String lineNo);
	public void cddAuditLog(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message);
	public String saveJointHolder(String compassRefNo, String lineNo, String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode);
	public String updateJointHolder(String compassRefNo, String lineNo, String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode);
	public String saveNomineeDetail(String compassRefNo, String lineNo, String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode);
	public String updateNomineeDetail(String compassRefNo, String lineNo, String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode);
	public String updateScreeningResult(String compassRefNo, String lineNo, String type, String screeningMatch, String sanctionList, String userCode);
	public String removeEntity(String type, String compassRefNo, String lineNo);
	public List<Map<String, String>> getAllJointHolderDetails(String compassRefNo, String lineNo);
	public List<Map<String, String>> getAllNomineeDetails(String compassRefNo, String lineNo);
	public String saveIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode);
	public String updateIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode);
	public List<Map<String, String>> getAllIntermediariesDetails(String compassRefNo, String lineNo);
	public String savePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode);
	public String updatePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode);
	public List<Map<String, String>> getAllPEPDetails(String compassRefNo, String lineNo);
	public String saveBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode);
	public String updateBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode);
	public List<Map<String, String>> getAllBeneficialOwnerDetails(String compassRefNo, String lineNo);
	public String saveDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode);
	public String updateDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo,String userCode);
	public List<Map<String, String>> getAllDirectorDetails(String compassRefNo, String lineNo);
	public String saveAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo, String userCode);
	public String updateAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo,String userCode);
	public List<Map<String, String>> getAllAuthorizeSignatoryDetails(String compassRefNo, String lineNo);
	public String getCDDFormFieldData(String field, String compassRefNo, String lineNo);
	public Map<String, Object> getCDDAuditLog(String compassRefNo, String linoNo);
	public String setCDDFormStatus(String status, String compassRefNo, String lineNo, String userCode, String userRole);
	public void setReCDDStatus(String status, String compassRefNo, String lineNo);
	public void setCDDNextReviewDate(String reviewDate, String compassRefNo, String lineNo, String userCode);
	public Map<String, Object> getFormData(String formType, String compassRefNo, String lineNo);
	public Map<String, String> saveCDDFormData(String userCode, String userRole, Map<String, String> formData, String status, 
			String compassRefNo, String lineNo);
	public String saveCDDCheckList(Map<String, String> formData, String compassRefNo, String lineNo, String status, String userCode, String userRole);
	public String updateAuthSignIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode);
	public String updateCustomerIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode);
	public List<Map<String, String>> getCDDCountryMaster();
	public List<Map<String, String>> getCDDStockExchangeMaster();
	public List<Map<String, String>> getCDDIndustryOccupationType();
	public List<Map<String, String>> getCDDAttributeType();
	public List<Map<String, String>> getCDDSourceOfFund();
	public List<Map<String, String>> getCDDCurrencyMaster();
	public Map<String, String> calculateCorpRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING, String ATTRIBUTETYPERISKRATING);
	public Map<String, String> calculateIndvRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING);
	public int checkAccountOpeningKyogi(String compassRefNo, String type);
	public void createAFA(String compassRefNo, String kyogiType, String userCode);
	public Map<String, String> getAFAData(String compassRefNo, String lineNo, String kyogiType);
	public String saveAFA(Map<String, String> dataMap, String userCode);
	public String checkPAN(String panNo);
	public String saveScreeningMapping(String compassRefNo, String uniqueNumber, String fileName, String cddFormType, String cddNameType, String cddNameLineNo, String userCode, String userRole, String ipAddress);
	public Map<String, String> getCDDEmailDetails(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message);
	public String validateCustomerPANNo(String compassRefNo, String lineNo, String userCode, String userRole, String ipAddress, String panNo);
}
