package com.quantumdataengines.app.compass.model.regulatoryReports.india;

import java.util.HashMap;

public class ISTRManualDetailsVO
{

    public ISTRManualDetailsVO()
    {
        reportSendingDate = null;
        reportFlag = null;
        reportSendingDateReplac = null;
        princNameOfBank = null;
        princBSRCode = null;
        princIDFIUIND = null;
        princBankCategory = null;
        princOfficerName = null;
        princDesignation = null;
        princBuildingNo = null;
        princStreet = null;
        princLocality = null;
        princCity = null;
        princState = null;
        princPinCode = null;
        princTelNo = null;
        princMobileNo = null;
        princFax = null;
        princEmail = null;
        repBranchName = null;
        repBSRCode = null;
        repIDFIUIND = null;
        repBuildingNo = null;
        repStreet = null;
        repLocality = null;
        repCity = null;
        repState = null;
        repPinCode = null;
        repTelNo = null;
        repFaxNo = null;
        repEmail = null;
        indivName = new String[50];
        indivId = new String[50];
        indivAnnexAB = new String[50];
        indivAnnexNumber = new String[50];
        indivFlag = new String[50];
        legalName = new String[50];
        legalId = new String[50];
        legalAccountNo = new String[50];
        legalAnnexAB = new String[50];
        legalAnnexNumber = new String[50];
        legalFlag = new String[50];
        accNo = new String[50];
        accName = new String[50];
        accAnnexAB = new String[50];
        accAnnexNumber = new String[50];
        accFlag = new String[50];
        suspReason = null;
        ackNo = null;
        finalDate = null;
        dataTypeForIndiv = new String[50];
        dataTypeForLegal = new String[50];
        dataTypeForAccount = new String[50];
        counterId = new String[50];
        counterName = new String[50];
        counterAcc = new String[50];
        counterType = new String[50];
        susGroundsP7 = new String[30];
        susGroundsP8 = new String[5];
        acctNameLinkedToTrans = null;
        acctNoLinkedToTrans = null;
        suspOtherReason = null;
        NoOfIndividualRec = 0;
        NoOfLegalRec = 0;
        NoOfAcctRec = 0;
        writeUpTxns = null;
        
        mainPersonName = null;
        sourceOfAlert = null;
        alertIndicators = new String[3];
        suspicionDueTo = null;
        attemptedTransactions = null;
        priorityRating = null;
        reportCoverage = null;
        additionalDocuments = null;
        lawEnforcementInformed = null;
        LawEnforcementAgencyDetails = new String[5];
        signatureName = null;
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
        reasonOfRevision = null;
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

    public String[] getAcctNameLinkedToTrans()
    {
        return acctNameLinkedToTrans;
    }

    public void setAcctNameLinkedToTrans(String acctNameLinkedToTrans[])
    {
        this.acctNameLinkedToTrans = acctNameLinkedToTrans;
    }

    public String[] getAcctNoLinkedToTrans()
    {
        return acctNoLinkedToTrans;
    }

    public void setAcctNoLinkedToTrans(String acctNoLinkedToTrans[])
    {
        this.acctNoLinkedToTrans = acctNoLinkedToTrans;
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

    public String[] getAccAnnexAB()
    {
        return accAnnexAB;
    }

    public void setAccAnnexAB(String accAnnexAB[])
    {
        this.accAnnexAB = accAnnexAB;
    }

    public String[] getAccAnnexNumber()
    {
        return accAnnexNumber;
    }

    public void setAccAnnexNumber(String accAnnexNumber[])
    {
        this.accAnnexNumber = accAnnexNumber;
    }

    public String[] getAccFlag()
    {
        return accFlag;
    }

    public void setAccFlag(String accFlag[])
    {
        this.accFlag = accFlag;
    }

    public String[] getAccName()
    {
        return accName;
    }

    public void setAccName(String accName[])
    {
        this.accName = accName;
    }

    public String[] getAccNo()
    {
        return accNo;
    }

    public void setAccNo(String accNo[])
    {
        this.accNo = accNo;
    }

    public String getAckNo()
    {
        return ackNo;
    }

    public void setAckNo(String ackNo)
    {
        this.ackNo = ackNo;
    }

    public String[] getCounterAcc()
    {
        return counterAcc;
    }

    public void setCounterAcc(String counterAcc[])
    {
        this.counterAcc = counterAcc;
    }

    public String[] getCounterType()
    {
        return counterType;
    }

    public void setCounterType(String counterType[])
    {
        this.counterType = counterType;
    }

    public String[] getCounterId()
    {
        return counterId;
    }

    public void setCounterId(String counterId[])
    {
        this.counterId = counterId;
    }

    public String[] getCounterName()
    {
        return counterName;
    }

    public void setCounterName(String counterName[])
    {
        this.counterName = counterName;
    }

    public String getFinalDate()
    {
        return finalDate;
    }

    public void setFinalDate(String finalDate)
    {
        this.finalDate = finalDate;
    }

    public String[] getIndivAnnexAB()
    {
        return indivAnnexAB;
    }

    public void setIndivAnnexAB(String indivAnnexAB[])
    {
        this.indivAnnexAB = indivAnnexAB;
    }

    public String[] getIndivAnnexNumber()
    {
        return indivAnnexNumber;
    }

    public void setIndivAnnexNumber(String indivAnnexNumber[])
    {
        this.indivAnnexNumber = indivAnnexNumber;
    }

    public String[] getIndivFlag()
    {
        return indivFlag;
    }

    public void setIndivFlag(String indivFlag[])
    {
        this.indivFlag = indivFlag;
    }

    public String[] getIndivId()
    {
        return indivId;
    }

    public void setIndivId(String indivId[])
    {
        this.indivId = indivId;
    }

    public String[] getIndivName()
    {
        return indivName;
    }

    public void setIndivName(String indivName[])
    {
        this.indivName = indivName;
    }

    public String[] getLegalAnnexAB()
    {
        return legalAnnexAB;
    }

    public void setLegalAnnexAB(String legalAnnexAB[])
    {
        this.legalAnnexAB = legalAnnexAB;
    }

    public String[] getLegalAnnexNumber()
    {
        return legalAnnexNumber;
    }

    public void setLegalAnnexNumber(String legalAnnexNumber[])
    {
        this.legalAnnexNumber = legalAnnexNumber;
    }

    public String[] getLegalFlag()
    {
        return legalFlag;
    }

    public void setLegalFlag(String legalFlag[])
    {
        this.legalFlag = legalFlag;
    }

    public String[] getLegalId()
    {
        return legalId;
    }

    public void setLegalId(String legalId[])
    {
        this.legalId = legalId;
    }

    public String[] getLegalName()
    {
        return legalName;
    }

    public void setLegalName(String legalName[])
    {
        this.legalName = legalName;
    }
    
    public String[] getLegalAccountNo()
    {
        return legalAccountNo;
    }

    public void setLegalAccountNo(String legalAccountNo[])
    {
        this.legalAccountNo = legalAccountNo;
    }

    public String getPrincBankCategory()
    {
        return princBankCategory;
    }

    public void setPrincBankCategory(String princBankCategory)
    {
        this.princBankCategory = princBankCategory;
    }

    public String getPrincBSRCode()
    {
        return princBSRCode;
    }

    public void setPrincBSRCode(String princBSRCode)
    {
        this.princBSRCode = princBSRCode;
    }

    public String getPrincBuildingNo()
    {
        return princBuildingNo;
    }

    public void setPrincBuildingNo(String princBuildingNo)
    {
        this.princBuildingNo = princBuildingNo;
    }

    public String getPrincCity()
    {
        return princCity;
    }

    public void setPrincCity(String princCity)
    {
        this.princCity = princCity;
    }

    public String getPrincDesignation()
    {
        return princDesignation;
    }

    public void setPrincDesignation(String princDesignation)
    {
        this.princDesignation = princDesignation;
    }

    public String getPrincEmail()
    {
        return princEmail;
    }

    public void setPrincEmail(String princEmail)
    {
        this.princEmail = princEmail;
    }

    public String getPrincFax()
    {
        return princFax;
    }

    public void setPrincFax(String princFax)
    {
        this.princFax = princFax;
    }

    public String getPrincIDFIUIND()
    {
        return princIDFIUIND;
    }

    public void setPrincIDFIUIND(String princIDFIUIND)
    {
        this.princIDFIUIND = princIDFIUIND;
    }

    public String getPrincLocality()
    {
        return princLocality;
    }

    public void setPrincLocality(String princLocality)
    {
        this.princLocality = princLocality;
    }

    public String getPrincNameOfBank()
    {
        return princNameOfBank;
    }

    public void setPrincNameOfBank(String princNameOfBank)
    {
        this.princNameOfBank = princNameOfBank;
    }

    public String getPrincOfficerName()
    {
        return princOfficerName;
    }

    public void setPrincOfficerName(String princOfficerName)
    {
        this.princOfficerName = princOfficerName;
    }

    public String getPrincPinCode()
    {
        return princPinCode;
    }

    public void setPrincPinCode(String princPinCode)
    {
        this.princPinCode = princPinCode;
    }

    public String getPrincState()
    {
        return princState;
    }

    public void setPrincState(String princState)
    {
        this.princState = princState;
    }

    public String getPrincStreet()
    {
        return princStreet;
    }

    public void setPrincStreet(String princStreet)
    {
        this.princStreet = princStreet;
    }

    public String getPrincTelNo()
    {
        return princTelNo;
    }

    public void setPrincTelNo(String princTelNo)
    {
        this.princTelNo = princTelNo;
    }

    public String getPrincMobileNo() {
		return princMobileNo;
	}

	public void setPrincMobileNo(String princMobileNo) {
		this.princMobileNo = princMobileNo;
	}

	public String getRepBranchName()
    {
        return repBranchName;
    }

    public void setRepBranchName(String repBranchName)
    {
        this.repBranchName = repBranchName;
    }

    public String getRepBSRCode()
    {
        return repBSRCode;
    }

    public void setRepBSRCode(String repBSRCode)
    {
        this.repBSRCode = repBSRCode;
    }

    public String getRepBuildingNo()
    {
        return repBuildingNo;
    }

    public void setRepBuildingNo(String repBuildingNo)
    {
        this.repBuildingNo = repBuildingNo;
    }

    public String getRepCity()
    {
        return repCity;
    }

    public void setRepCity(String repCity)
    {
        this.repCity = repCity;
    }

    public String getRepEmail()
    {
        return repEmail;
    }

    public void setRepEmail(String repEmail)
    {
        this.repEmail = repEmail;
    }

    public String getRepFaxNo()
    {
        return repFaxNo;
    }

    public void setRepFaxNo(String repFaxNo)
    {
        this.repFaxNo = repFaxNo;
    }

    public String getRepIDFIUIND()
    {
        return repIDFIUIND;
    }

    public void setRepIDFIUIND(String repIDFIUIND)
    {
        this.repIDFIUIND = repIDFIUIND;
    }

    public String getRepLocality()
    {
        return repLocality;
    }

    public void setRepLocality(String repLocality)
    {
        this.repLocality = repLocality;
    }

    public String getReportFlag()
    {
        return reportFlag;
    }

    public void setReportFlag(String reportFlag)
    {
        this.reportFlag = reportFlag;
    }

    public String getReportSendingDate()
    {
        return reportSendingDate;
    }

    public void setReportSendingDate(String reportSendingDate)
    {
        this.reportSendingDate = reportSendingDate;
    }

    public String getReportSendingDateReplac()
    {
        return reportSendingDateReplac;
    }

    public void setReportSendingDateReplac(String reportSendingDateReplac)
    {
        this.reportSendingDateReplac = reportSendingDateReplac;
    }

    public String getRepPinCode()
    {
        return repPinCode;
    }

    public void setRepPinCode(String repPinCode)
    {
        this.repPinCode = repPinCode;
    }

    public String getRepState()
    {
        return repState;
    }

    public void setRepState(String repState)
    {
        this.repState = repState;
    }

    public String getRepStreet()
    {
        return repStreet;
    }

    public void setRepStreet(String repStreet)
    {
        this.repStreet = repStreet;
    }

    public String getRepTelNo()
    {
        return repTelNo;
    }

    public void setRepTelNo(String repTelNo)
    {
        this.repTelNo = repTelNo;
    }

    public String getSuspReason()
    {
        return suspReason;
    }

    public void setSuspReason(String suspReason)
    {
        this.suspReason = suspReason;
    }

    public String[] getDataTypeForAccount()
    {
        return dataTypeForAccount;
    }

    public void setDataTypeForAccount(String dataTypeForAccount[])
    {
        this.dataTypeForAccount = dataTypeForAccount;
    }

    public String[] getDataTypeForLegal()
    {
        return dataTypeForLegal;
    }

    public void setDataTypeForLegal(String dataTypeForLegal[])
    {
        this.dataTypeForLegal = dataTypeForLegal;
    }

    public void setDataTypeForIndiv(String dataTypeForIndiv[])
    {
        this.dataTypeForIndiv = dataTypeForIndiv;
    }

    public String[] getDataTypeForIndiv()
    {
        return dataTypeForIndiv;
    }

    public void setSuspOtherReason(String suspOtherReason)
    {
        this.suspOtherReason = suspOtherReason;
    }

    public String getSuspOtherReason()
    {
        return suspOtherReason;
    }

    public void setNoOfIndividualRec(int NoOfIndividualRec)
    {
        this.NoOfIndividualRec = NoOfIndividualRec;
    }

    public int getNoOfIndividualRec()
    {
        return NoOfIndividualRec;
    }

    public void setNoOfLegalRec(int NoOfLegalRec)
    {
        this.NoOfLegalRec = NoOfLegalRec;
    }

    public int getNoOfLegalRec()
    {
        return NoOfLegalRec;
    }

    public void setNoOfAcctRec(int NoOfAcctRec)
    {
        this.NoOfAcctRec = NoOfAcctRec;
    }

    public int getNoOfAcctRec()
    {
        return NoOfAcctRec;
    }

    public HashMap getWriteUpTxns()
    {
        return writeUpTxns;
    }

    public void setWriteUpTxns(HashMap writeUpTxns)
    {
        this.writeUpTxns = writeUpTxns;
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

	public String getReasonOfRevision() {
		return reasonOfRevision;
	}

	public void setReasonOfRevision(String reasonOfRevision) {
		this.reasonOfRevision = reasonOfRevision;
	}

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


	private String reportSendingDate;
    private String reportFlag;
    private String reportSendingDateReplac;
    private String princNameOfBank;
    private String princBSRCode;
    private String princIDFIUIND;
    private String princBankCategory;
    private String princOfficerName;
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
    private String princEmail;
    private String repBranchName;
    private String repBSRCode;
    private String repIDFIUIND;
    private String repBuildingNo;
    private String repStreet;
    private String repLocality;
    private String repCity;
    private String repState;
    private String repPinCode;
    private String repTelNo;
    private String repFaxNo;
    private String repEmail;
    private String indivName[];
    private String indivId[];
    private String indivAnnexAB[];
    private String indivAnnexNumber[];
    private String indivFlag[];
    private String legalName[];
    private String legalId[];
    private String legalAccountNo[];
    private String legalAnnexAB[];
    private String legalAnnexNumber[];
    private String legalFlag[];
    private String accNo[];
    private String accName[];
    private String accAnnexAB[];
    private String accAnnexNumber[];
    private String accFlag[];
    private String suspReason;
    private String ackNo;
    private String finalDate;
    private String dataTypeForIndiv[];
    private String dataTypeForLegal[];
    private String dataTypeForAccount[];
    private String counterId[];
    private String counterName[];
    private String counterAcc[];
    private String counterType[];
    private String susGroundsP7[];
    private String susGroundsP8[];
    private String acctNameLinkedToTrans[];
    private String acctNoLinkedToTrans[];
    private String suspOtherReason;
    private int NoOfIndividualRec;
    private int NoOfLegalRec;
    private int NoOfAcctRec;
    private HashMap writeUpTxns;
    private String mainPersonName;
    private String sourceOfAlert;
    private String alertIndicators[];
    private String suspicionDueTo;   
    private String attemptedTransactions;
    private String priorityRating;
    private String reportCoverage;
    private String additionalDocuments;
    private String lawEnforcementInformed;
    private String LawEnforcementAgencyDetails[];
    private String signatureName;
    
    private String reportingEntityName;
    private String reportingEntityCategory;
    private String reportingEntityCode;
    private String reportingEntityFIUREID;
    private String reportingBatchNo;
    private String reportingBatchDate;
    private String reportingBatchPertainingToMonth;
    private String reportingBatchPertainingToYear;
    private String reportingBatchType;
    private String reportingOriginalBatchId;
    private String reasonOfRevision;
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
}