package com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF;

import java.util.HashMap;

public class ISTRTRFManualDetailsVO
{

    public ISTRTRFManualDetailsVO()
    {
        
    	NoOfTransactionRec = 0;
    	NoOfBranchRec = 0;
    	setNoOfIndividualRec(0);
        setNoOfLegalRec(0);
        
    	//actionTakenDetails
        susGroundsP8 = new String[5];
        lawEnforcementInformed = null;
        LawEnforcementAgencyDetails = new String[5];
        signatureName = null;
        
        //suspicionDetails
        reportFlag = null;
        mainPersonName = null;
        sourceOfAlert = null;
        alertIndicators = new String[3];
        suspicionDueTo = null;
        attemptedTransactions = null;
        priorityRating = null;
        reportCoverage = null;
        additionalDocuments = null;
        susGroundsP7 = new String[30];
        
        //reportingEntityDetails
        reportingEntityName = null;
        reportingEntityCategory = null;
        reportingEntityCode = null;
        reportingEntityFIUREID = null;
        reportingBatchNo = null;
        reportingBatchDate = null;
        reportingBatchPertainingToMonth = null;
        reportingBatchPertainingToYear = null;
        reportingBatchType = null;
        reportingOriginalBatchId = null;
       
        //principalOfficerDetails
        principalOfficersName = null;
        principalOfficersDesignation = null;
        principalOfficersAddress1 = null;
        principalOfficersAddress2 = null;
        principalOfficersAddress3 = null;
        principalOfficersCity = null;
        principalOfficersState = null;
        principalOfficersCountry = null;
        principalOfficersAddressPinCode = null;
        principalOfficersTelephoneNo = null;
        principalOfficersMobileNo = null;
        principalOfficersFaxNo = null;
        principalOfficersEmailId = null;
    }

    public void setSusGroundsP8(String susGroundsP8[])
    {
        this.susGroundsP8 = susGroundsP8;
    }

    public String[] getSusGroundsP8()
    {
        return susGroundsP8;
    }

    public String[] getSusGroundsP7()
    {
        return susGroundsP7;
    }

    public void setSusGroundsP7(String susGroundsP7[])
    {
        this.susGroundsP7 = susGroundsP7;
    }

    public String getMainPersonName() {
		return mainPersonName;
	}

	public void setMainPersonName(String mainPersonName) {
		this.mainPersonName = mainPersonName;
	}

	public String getSourceOfAlert() {
		return sourceOfAlert;
	}

	public void setSourceOfAlert(String sourceOfAlert) {
		this.sourceOfAlert = sourceOfAlert;
	}

	public String[] getAlertIndicators() {
		return alertIndicators;
	}

	public void setAlertIndicators(String[] alertIndicators) {
		this.alertIndicators = alertIndicators;
	}

	public String getSuspicionDueTo() {
		return suspicionDueTo;
	}

	public void setSuspicionDueTo(String suspicionDueTo) {
		this.suspicionDueTo = suspicionDueTo;
	}

	public String getAttemptedTransactions() {
		return attemptedTransactions;
	}

	public void setAttemptedTransactions(String attemptedTransactions) {
		this.attemptedTransactions = attemptedTransactions;
	}

	public String getPriorityRating() {
		return priorityRating;
	}

	public void setPriorityRating(String priorityRating) {
		this.priorityRating = priorityRating;
	}

	public String getReportCoverage() {
		return reportCoverage;
	}

	public void setReportCoverage(String reportCoverage) {
		this.reportCoverage = reportCoverage;
	}

	public String getAdditionalDocuments() {
		return additionalDocuments;
	}

	public void setAdditionalDocuments(String additionalDocuments) {
		this.additionalDocuments = additionalDocuments;
	}

	public String getLawEnforcementInformed() {
		return lawEnforcementInformed;
	}

	public void setLawEnforcementInformed(String lawEnforcementInformed) {
		this.lawEnforcementInformed = lawEnforcementInformed;
	}

	public String[] getLawEnforcementAgencyDetails() {
		return LawEnforcementAgencyDetails;
	}

	public void setLawEnforcementAgencyDetails(String[] lawEnforcementAgencyDetails) {
		LawEnforcementAgencyDetails = lawEnforcementAgencyDetails;
	}

	public String getSignatureName() {
		return signatureName;
	}

	public void setSignatureName(String signatureName) {
		this.signatureName = signatureName;
	}

	public String getReportingEntityName() {
		return reportingEntityName;
	}

	public void setReportingEntityName(String reportingEntityName) {
		this.reportingEntityName = reportingEntityName;
	}

	public String getReportingEntityCategory() {
		return reportingEntityCategory;
	}

	public void setReportingEntityCategory(String reportingEntityCategory) {
		this.reportingEntityCategory = reportingEntityCategory;
	}

	public String getReportingEntityCode() {
		return reportingEntityCode;
	}

	public void setReportingEntityCode(String reportingEntityCode) {
		this.reportingEntityCode = reportingEntityCode;
	}

	public String getReportingEntityFIUREID() {
		return reportingEntityFIUREID;
	}

	public void setReportingEntityFIUREID(String reportingEntityFIUREID) {
		this.reportingEntityFIUREID = reportingEntityFIUREID;
	}

	public String getReportingBatchNo() {
		return reportingBatchNo;
	}

	public void setReportingBatchNo(String reportingBatchNo) {
		this.reportingBatchNo = reportingBatchNo;
	}

	public String getReportingBatchDate() {
		return reportingBatchDate;
	}

	public void setReportingBatchDate(String reportingBatchDate) {
		this.reportingBatchDate = reportingBatchDate;
	}

	public String getReportingBatchPertainingToMonth() {
		return reportingBatchPertainingToMonth;
	}

	public void setReportingBatchPertainingToMonth(String reportingBatchPertainingToMonth) {
		this.reportingBatchPertainingToMonth = reportingBatchPertainingToMonth;
	}

	public String getReportingBatchPertainingToYear() {
		return reportingBatchPertainingToYear;
	}

	public void setReportingBatchPertainingToYear(String reportingBatchPertainingToYear) {
		this.reportingBatchPertainingToYear = reportingBatchPertainingToYear;
	}

	public String getReportingBatchType() {
		return reportingBatchType;
	}

	public void setReportingBatchType(String reportingBatchType) {
		this.reportingBatchType = reportingBatchType;
	}

	public String getReportingOriginalBatchId() {
		return reportingOriginalBatchId;
	}

	public void setReportingOriginalBatchId(String reportingOriginalBatchId) {
		this.reportingOriginalBatchId = reportingOriginalBatchId;
	}

    public String getPrincNameOfBank() {
		return princNameOfBank;
	}

	public void setPrincNameOfBank(String princNameOfBank) {
		this.princNameOfBank = princNameOfBank;
	}

	public String getPrincBSRCode() {
		return princBSRCode;
	}

	public void setPrincBSRCode(String princBSRCode) {
		this.princBSRCode = princBSRCode;
	}

	public String getPrincIDFIUIND() {
		return princIDFIUIND;
	}

	public void setPrincIDFIUIND(String princIDFIUIND) {
		this.princIDFIUIND = princIDFIUIND;
	}

	public String getPrincBankCategory() {
		return princBankCategory;
	}

	public void setPrincBankCategory(String princBankCategory) {
		this.princBankCategory = princBankCategory;
	}

/*	public String getPrincOfficerName() {
		return princOfficerName;
	}

	public void setPrincOfficerName(String princOfficerName) {
		this.princOfficerName = princOfficerName;
	}

	public String getPrincDesignation() {
		return princDesignation;
	}

	public void setPrincDesignation(String princDesignation) {
		this.princDesignation = princDesignation;
	}

	public String getPrincBuildingNo() {
		return princBuildingNo;
	}

	public void setPrincBuildingNo(String princBuildingNo) {
		this.princBuildingNo = princBuildingNo;
	}

	public String getPrincStreet() {
		return princStreet;
	}

	public void setPrincStreet(String princStreet) {
		this.princStreet = princStreet;
	}

	public String getPrincLocality() {
		return princLocality;
	}

	public void setPrincLocality(String princLocality) {
		this.princLocality = princLocality;
	}

	public String getPrincCity() {
		return princCity;
	}

	public void setPrincCity(String princCity) {
		this.princCity = princCity;
	}

	public String getPrincState() {
		return princState;
	}

	public void setPrincState(String princState) {
		this.princState = princState;
	}

	public String getPrincPinCode() {
		return princPinCode;
	}

	public void setPrincPinCode(String princPinCode) {
		this.princPinCode = princPinCode;
	}

	public String getPrincTelNo() {
		return princTelNo;
	}

	public void setPrincTelNo(String princTelNo) {
		this.princTelNo = princTelNo;
	}

	public String getPrincMobileNo() {
		return princMobileNo;
	}

	public void setPrincMobileNo(String princMobileNo) {
		this.princMobileNo = princMobileNo;
	}

	public String getPrincFax() {
		return princFax;
	}

	public void setPrincFax(String princFax) {
		this.princFax = princFax;
	}

	public String getPrincEmail() {
		return princEmail;
	}

	public void setPrincEmail(String princEmail) {
		this.princEmail = princEmail;
	}
*/
	public String getPrincipalOfficersName() {
		return principalOfficersName;
	}

	public void setPrincipalOfficersName(String principalOfficersName) {
		this.principalOfficersName = principalOfficersName;
	}

	public String getPrincipalOfficersDesignation() {
		return principalOfficersDesignation;
	}

	public void setPrincipalOfficersDesignation(String principalOfficersDesignation) {
		this.principalOfficersDesignation = principalOfficersDesignation;
	}

	public String getPrincipalOfficersAddress1() {
		return principalOfficersAddress1;
	}

	public void setPrincipalOfficersAddress1(String principalOfficersAddress1) {
		this.principalOfficersAddress1 = principalOfficersAddress1;
	}

	public String getPrincipalOfficersAddress2() {
		return principalOfficersAddress2;
	}

	public void setPrincipalOfficersAddress2(String principalOfficersAddress2) {
		this.principalOfficersAddress2 = principalOfficersAddress2;
	}

	public String getPrincipalOfficersAddress3() {
		return principalOfficersAddress3;
	}

	public void setPrincipalOfficersAddress3(String principalOfficersAddress3) {
		this.principalOfficersAddress3 = principalOfficersAddress3;
	}

	public String getPrincipalOfficersCity() {
		return principalOfficersCity;
	}

	public void setPrincipalOfficersCity(String principalOfficersCity) {
		this.principalOfficersCity = principalOfficersCity;
	}

	public String getPrincipalOfficersState() {
		return principalOfficersState;
	}

	public void setPrincipalOfficersState(String principalOfficersState) {
		this.principalOfficersState = principalOfficersState;
	}

	public String getPrincipalOfficersCountry() {
		return principalOfficersCountry;
	}

	public void setPrincipalOfficersCountry(String principalOfficersCountry) {
		this.principalOfficersCountry = principalOfficersCountry;
	}

	public String getPrincipalOfficersAddressPinCode() {
		return principalOfficersAddressPinCode;
	}

	public void setPrincipalOfficersAddressPinCode(String principalOfficersAddressPinCode) {
		this.principalOfficersAddressPinCode = principalOfficersAddressPinCode;
	}

	public String getPrincipalOfficersTelephoneNo() {
		return principalOfficersTelephoneNo;
	}

	public void setPrincipalOfficersTelephoneNo(String principalOfficersTelephoneNo) {
		this.principalOfficersTelephoneNo = principalOfficersTelephoneNo;
	}

	public String getPrincipalOfficersMobileNo() {
		return principalOfficersMobileNo;
	}

	public void setPrincipalOfficersMobileNo(String principalOfficersMobileNo) {
		this.principalOfficersMobileNo = principalOfficersMobileNo;
	}

	public String getPrincipalOfficersFaxNo() {
		return principalOfficersFaxNo;
	}

	public void setPrincipalOfficersFaxNo(String principalOfficersFaxNo) {
		this.principalOfficersFaxNo = principalOfficersFaxNo;
	}

	public String getPrincipalOfficersEmailId() {
		return principalOfficersEmailId;
	}

	public void setPrincipalOfficersEmailId(String principalOfficersEmailId) {
		this.principalOfficersEmailId = principalOfficersEmailId;
	}

	public int getNoOfBranchRec() {
		return NoOfBranchRec;
	}

	public void setNoOfBranchRec(int noOfBranchRec) {
		NoOfBranchRec = noOfBranchRec;
	}


	public String[] getBranchRefNo() {
		return branchRefNo;
	}

	public void setBranchRefNo(String branchRefNo[]) {
		this.branchRefNo = branchRefNo;
	}


	public String[] getBranchNameLinkedToTrans() {
		return branchName;
	}

	public void setBranchName(String branchName[]) {
		this.branchName = branchName;
	}


	public String[] getDataTypeForBranch() {
		return dataTypeForBranch;
	}

	public void setDataTypeForBranch(String dataTypeForBranch[]) {
		this.dataTypeForBranch = dataTypeForBranch;
	}

    public String[] getBranchName() {
		return branchName;
	}

	public String[] getBranchAnnexAB() {
		return branchAnnexAB;
	}

	public void setBranchAnnexAB(String branchAnnexAB[]) {
		this.branchAnnexAB = branchAnnexAB;
	}

	public String[] getBranchAnnexNumber() {
		return branchAnnexNumber;
	}

	public void setBranchAnnexNumber(String branchAnnexNumber[]) {
		this.branchAnnexNumber = branchAnnexNumber;
	}

	public String[] getBranchFlag() {
		return branchFlag;
	}

	public void setBranchFlag(String branchFlag[]) {
		this.branchFlag = branchFlag;
	}

	public String[] getTxnAnnexAB() {
		return txnAnnexAB;
	}

	public void setTxnAnnexAB(String[] txnAnnexAB) {
		this.txnAnnexAB = txnAnnexAB;
	}

	public String[] getTxnAnnexNumber() {
		return txnAnnexNumber;
	}

	public void setTxnAnnexNumber(String[] txnAnnexNumber) {
		this.txnAnnexNumber = txnAnnexNumber;
	}

	public String[] getTxnFlag() {
		return txnFlag;
	}

	public void setTxnFlag(String[] txnFlag) {
		this.txnFlag = txnFlag;
	}

	public String[] getTransactionDate() {
		return transactionDate;
	}

	public void setTransactionDate(String[] transactionDate) {
		this.transactionDate = transactionDate;
	}

	public String[] getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(String[] transactionType) {
		this.transactionType = transactionType;
	}

	public String[] getTransactionInstrumentType() {
		return transactionInstrumentType;
	}

	public void setTransactionInstrumentType(String[] transactionInstrumentType) {
		this.transactionInstrumentType = transactionInstrumentType;
	}

	public String[] getTransactionCurrency() {
		return transactionCurrency;
	}

	public void setTransactionCurrency(String[] transactionCurrency) {
		this.transactionCurrency = transactionCurrency;
	}

	public String[] getTransactionAmtInRupees() {
		return transactionAmtInRupees;
	}

	public void setTransactionAmtInRupees(String[] transactionAmtInRupees) {
		this.transactionAmtInRupees = transactionAmtInRupees;
	}

	public String[] getDataTypeForTransaction() {
		return dataTypeForTransaction;
	}

	public void setDataTypeForTransaction(String[] dataTypeForTransaction) {
		this.dataTypeForTransaction = dataTypeForTransaction;
	}

	public int getNoOfTransactionRec() {
		return NoOfTransactionRec;
	}

	public void setNoOfTransactionRec(int noOfTransactionRec) {
		NoOfTransactionRec = noOfTransactionRec;
	}
	
	//branch details
    
    public String getSuspReason() {
		return suspReason;
	}

	public void setSuspReason(String suspReason) {
		this.suspReason = suspReason;
	}

	public String getSuspOtherReason() {
		return suspOtherReason;
	}

	public void setSuspOtherReason(String suspOtherReason) {
		this.suspOtherReason = suspOtherReason;
	}

	public String getReportFlag() {
		return reportFlag;
	}

	public void setReportFlag(String reportFlag) {
		this.reportFlag = reportFlag;
	}

	public String getReasonOfRevision() {
		return reasonOfRevision;
	}

	public void setReasonOfRevision(String reasonOfRevision) {
		this.reasonOfRevision = reasonOfRevision;
	}

	public String[] getBranchSeqNo() {
		return branchSeqNo;
	}

	public void setBranchSeqNo(String branchSeqNo[]) {
		this.branchSeqNo = branchSeqNo;
	}

	public String[] getTransactionSeqNo() {
		return transactionSeqNo;
	}

	public void setTransactionSeqNo(String transactionSeqNo[]) {
		this.transactionSeqNo = transactionSeqNo;
	}

	public int getNoOfIndividualRec() {
		return NoOfIndividualRec;
	}

	public void setNoOfIndividualRec(int noOfIndividualRec) {
		NoOfIndividualRec = noOfIndividualRec;
	}

	public int getNoOfLegalRec() {
		return NoOfLegalRec;
	}

	public void setNoOfLegalRec(int noOfLegalRec) {
		NoOfLegalRec = noOfLegalRec;
	}

	private String branchAnnexAB[];
    private String branchAnnexNumber[];
    private String branchFlag[];
    
    //transaction details
   
   	private String txnAnnexAB[];
    private String txnAnnexNumber[];
    private String txnFlag[];
    
    //suspicion details
    private String reportFlag;
    private String mainPersonName;
    private String sourceOfAlert;
    private String alertIndicators[];
    private String suspicionDueTo;   
    private String attemptedTransactions;
    private String priorityRating;
    private String reportCoverage;
    private String additionalDocuments;
    private String susGroundsP7[];
    private String suspReason;
    private String suspOtherReason;
    
    //details of action taken
    private String susGroundsP8[];
    private String lawEnforcementInformed;
    private String LawEnforcementAgencyDetails[];
    private String signatureName;
    
    //reporting entity details
    private String reportingEntityName;
    private String reportingEntityCategory;
    private String reportingEntityCode;
    private String reportingEntityFIUREID;
    
    //batch details
    private String reportingBatchNo;
    private String reportingBatchDate;
    private String reportingBatchPertainingToMonth;
    private String reportingBatchPertainingToYear;
    private String reportingBatchType;
    private String reportingOriginalBatchId;
    private String reasonOfRevision;
    
    //principal officer details
    private String princNameOfBank;
	private String princBSRCode;
    private String princIDFIUIND;
    private String princBankCategory;
    /*private String princOfficerName;
    private String princDesignation;
    private String princBuildingNo;
    private String princStreet;
    private String princLocality;
    private String princCity;
    private String princState;
    private String princPinCode;
    private String princTelNo;
    private String princMobileNo;
    private String princFax;
    private String princEmail;*/
    private String principalOfficersName;
    private String principalOfficersDesignation;
    private String principalOfficersAddress1;
    private String principalOfficersAddress2;
    private String principalOfficersAddress3;
    private String principalOfficersCity;
    private String principalOfficersState;
    private String principalOfficersCountry;
    private String principalOfficersAddressPinCode;
    private String principalOfficersTelephoneNo;
    private String principalOfficersMobileNo;
    private String principalOfficersFaxNo;
    private String principalOfficersEmailId;
    
    //related transactions list
    private String transactionSeqNo[];
    private String transactionDate[];
    private String transactionType[];
    private String transactionInstrumentType[];
    private String transactionCurrency[];
    private String transactionAmtInRupees[];
    private String dataTypeForTransaction[];
    private int NoOfTransactionRec;

	//related branches list
    private String branchSeqNo[];
    private String branchName[];
    private String branchRefNo[];
    private String dataTypeForBranch[];
    private int NoOfBranchRec;
    
    //related individuals list
    private int NoOfIndividualRec = 0;
    private String counterId[];
    private String counterName[];
    private String counterAcc[];
    private String counterType[];
    private String dataTypeForIndiv[];
    
    //related legal entities list
    private int NoOfLegalRec = 0;
    private String dataTypeForLegal[];
    private String legalName[];
    private String legalId[];
    private String legalAccountNo[];
	
    public String[] getCounterId() {
		return counterId;
	}

	public void setCounterId(String[] counterId) {
		this.counterId = counterId;
	}

	public String[] getCounterName() {
		return counterName;
	}

	public void setCounterName(String[] counterName) {
		this.counterName = counterName;
	}

	public String[] getCounterAcc() {
		return counterAcc;
	}

	public void setCounterAcc(String[] counterAcc) {
		this.counterAcc = counterAcc;
	}

	public String[] getCounterType() {
		return counterType;
	}

	public void setCounterType(String[] counterType) {
		this.counterType = counterType;
	}

	public String[] getDataTypeForIndiv() {
		return dataTypeForIndiv;
	}

	public void setDataTypeForIndiv(String[] dataTypeForIndiv) {
		this.dataTypeForIndiv = dataTypeForIndiv;
	}

	public String[] getDataTypeForLegal() {
		return dataTypeForLegal;
	}

	public void setDataTypeForLegal(String[] dataTypeForLegal) {
		this.dataTypeForLegal = dataTypeForLegal;
	}

	public String[] getLegalName() {
		return legalName;
	}

	public void setLegalName(String[] legalName) {
		this.legalName = legalName;
	}

	public String[] getLegalId() {
		return legalId;
	}

	public void setLegalId(String[] legalId) {
		this.legalId = legalId;
	}

	public String[] getLegalAccountNo() {
		return legalAccountNo;
	}

	public void setLegalAccountNo(String[] legalAccountNo) {
		this.legalAccountNo = legalAccountNo;
	}
    
    
}