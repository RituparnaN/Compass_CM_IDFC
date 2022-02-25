package com.quantumdataengines.app.compass.model.regulatoryReports.india;

public class ISTRAccountDetailsVO
{

    public ISTRAccountDetailsVO()
    {
        nameOfBank = null;
        bSRcode = null;
        annexEnclosed = null;
        accountNo = null;
        accountType = null;
        accountHoldertype = null;
        accountOpenDate = null;
        listofAccountHoldersName = new String[25];
        listofAccountHoldersID = new String[25];
        listofAccountHoldersAnnexAB = new String[25];
        listofAccountHoldersAnnexNumber = new String[25];
        listofAccountHoldersAnnexFlag = new boolean[25];
        listofRelatedPersonsName = new String[25];
        listofRelatedPersonsID = new String[25];
        listofRelatedPersonsRelation = new String[25];
        listofRelatedPersonsAnnexAB = new String[25];
        listofRelatedPersonsAnnexNumber = new String[25];
        listofRelatedPersonsAnnexFlag = new boolean[25];
        transacdetailsNo = new String[25];
        transacdetailsdate = new String[25];
        transacdetailsmode = new String[25];
        transacdetailsDebit = new String[25];
        transacdetailsAmount = new String[25];
        transacdetailsRemarks = new String[25];
        transacdetailsDataType = new String[25];
        cummulativetotalsDebit = null;
        cummulativetotalsCredit = null;
        strRiskFlag = null;
        strCustName = null;
        transactiondetailsdate = null;
        transactiondetailsmode = null;
        transactiondetailsDebit = null;
        transactiondetailsAmount = null;
        transactiondetailsRemarks = null;
        transactionNo = null;
        NoOfTransactions = 0;
        writeUpTxns = new String[8];
        bankName = null;
        bankBsrCode = null;
        bankFIUId = null;
        branchName = null;
        branchReferenceNumberType = null;
        branchBsrCode = null;
        branchFIUId = null;
        branchAddressLine1 = null;
        branchAddressLine2 = null;
        branchAddressLine3 = null;
        branchCity = null;
        branchState = null;
        branchCountry = null;
        branchPinCode = null;
        branchTelephoneNo = null;
        branchFaxNo = null;
        branchMobileNo = null;
        branchEmailId = null;
        accountHolderName = null;
        accountStatus = null;
        accountTotalCredit = null;
        accountTotalDebit = null;
        accountTotalCashCredit = null;
        accountTotalCashDebit = null;
        accountRiskCategory = null;
    }

    public String getAccountHoldertype()
    {
        return accountHoldertype;
    }

    public void setAccountHoldertype(String accountHoldertype)
    {
        this.accountHoldertype = accountHoldertype;
    }

    public String getAccountNo()
    {
        return accountNo;
    }

    public void setAccountNo(String accountNo)
    {
        this.accountNo = accountNo;
    }

    public String getAccountOpenDate()
    {
        return accountOpenDate;
    }

    public void setAccountOpenDate(String accountOpenDate)
    {
        this.accountOpenDate = accountOpenDate;
    }

    public String getAccountType()
    {
        return accountType;
    }

    public void setAccountType(String accountType)
    {
        this.accountType = accountType;
    }

    public String getAnnexEnclosed()
    {
        return annexEnclosed;
    }

    public void setAnnexEnclosed(String annexEnclosed)
    {
        this.annexEnclosed = annexEnclosed;
    }

    public String getBSRcode()
    {
        return bSRcode;
    }

    public void setBSRcode(String bSRcode)
    {
        this.bSRcode = bSRcode;
    }

    public String getCummulativetotalsCredit()
    {
        return cummulativetotalsCredit;
    }

    public void setCummulativetotalsCredit(String cummulativetotalsCredit)
    {
        this.cummulativetotalsCredit = cummulativetotalsCredit;
    }

    public String getCummulativetotalsDebit()
    {
        return cummulativetotalsDebit;
    }

    public void setCummulativetotalsDebit(String cummulativetotalsDebit)
    {
        this.cummulativetotalsDebit = cummulativetotalsDebit;
    }

    public String[] getListofAccountHoldersAnnexAB()
    {
        return listofAccountHoldersAnnexAB;
    }

    public void setListofAccountHoldersAnnexAB(String listofAccountHoldersAnnexAB[])
    {
        this.listofAccountHoldersAnnexAB = listofAccountHoldersAnnexAB;
    }

    public boolean[] getListofAccountHoldersAnnexFlag()
    {
        return listofAccountHoldersAnnexFlag;
    }

    public void setListofAccountHoldersAnnexFlag(boolean listofAccountHoldersAnnexFlag[])
    {
        this.listofAccountHoldersAnnexFlag = listofAccountHoldersAnnexFlag;
    }

    public String[] getListofAccountHoldersAnnexNumber()
    {
        return listofAccountHoldersAnnexNumber;
    }

    public void setListofAccountHoldersAnnexNumber(String listofAccountHoldersAnnexNumber[])
    {
        this.listofAccountHoldersAnnexNumber = listofAccountHoldersAnnexNumber;
    }

    public String[] getListofAccountHoldersID()
    {
        return listofAccountHoldersID;
    }

    public void setListofAccountHoldersID(String listofAccountHoldersID[])
    {
        this.listofAccountHoldersID = listofAccountHoldersID;
    }

    public String[] getListofAccountHoldersName()
    {
        return listofAccountHoldersName;
    }

    public void setListofAccountHoldersName(String listofAccountHoldersName[])
    {
        this.listofAccountHoldersName = listofAccountHoldersName;
    }

    public String[] getListofRelatedPersonsAnnexAB()
    {
        return listofRelatedPersonsAnnexAB;
    }

    public void setListofRelatedPersonsAnnexAB(String listofRelatedPersonsAnnexAB[])
    {
        this.listofRelatedPersonsAnnexAB = listofRelatedPersonsAnnexAB;
    }

    public boolean[] getListofRelatedPersonsAnnexFlag()
    {
        return listofRelatedPersonsAnnexFlag;
    }

    public void setListofRelatedPersonsAnnexFlag(boolean listofRelatedPersonsAnnexFlag[])
    {
        this.listofRelatedPersonsAnnexFlag = listofRelatedPersonsAnnexFlag;
    }

    public String[] getListofRelatedPersonsAnnexNumber()
    {
        return listofRelatedPersonsAnnexNumber;
    }

    public void setListofRelatedPersonsAnnexNumber(String listofRelatedPersonsAnnexNumber[])
    {
        this.listofRelatedPersonsAnnexNumber = listofRelatedPersonsAnnexNumber;
    }

    public String[] getListofRelatedPersonsID()
    {
        return listofRelatedPersonsID;
    }

    public void setListofRelatedPersonsID(String listofRelatedPersonsID[])
    {
        this.listofRelatedPersonsID = listofRelatedPersonsID;
    }

    public String[] getListofRelatedPersonsName()
    {
        return listofRelatedPersonsName;
    }

    public void setListofRelatedPersonsName(String listofRelatedPersonsName[])
    {
        this.listofRelatedPersonsName = listofRelatedPersonsName;
    }

    public String[] getListofRelatedPersonsRelation()
    {
        return listofRelatedPersonsRelation;
    }

    public void setListofRelatedPersonsRelation(String listofRelatedPersonsRelation[])
    {
        this.listofRelatedPersonsRelation = listofRelatedPersonsRelation;
    }

    public String getNameOfBank()
    {
        return nameOfBank;
    }

    public void setNameOfBank(String nameOfBank)
    {
        this.nameOfBank = nameOfBank;
    }

    public String[] getTransacdetailsAmount()
    {
        return transacdetailsAmount;
    }

    public void setTransacdetailsAmount(String transacdetailsAmount[])
    {
        this.transacdetailsAmount = transacdetailsAmount;
    }

    public String[] getTransacdetailsdate()
    {
        return transacdetailsdate;
    }

    public void setTransacdetailsdate(String transacdetailsdate[])
    {
        this.transacdetailsdate = transacdetailsdate;
    }

    public String[] getTransacdetailsDebit()
    {
        return transacdetailsDebit;
    }

    public void setTransacdetailsDebit(String transacdetailsDebit[])
    {
        this.transacdetailsDebit = transacdetailsDebit;
    }

    public String[] getTransacdetailsmode()
    {
        return transacdetailsmode;
    }

    public void setTransacdetailsmode(String transacdetailsmode[])
    {
        this.transacdetailsmode = transacdetailsmode;
    }

    public String[] getTransacdetailsRemarks()
    {
        return transacdetailsRemarks;
    }

    public void setTransacdetailsRemarks(String transacdetailsRemarks[])
    {
        this.transacdetailsRemarks = transacdetailsRemarks;
    }

    public String[] getTransacdetailsDataType()
    {
        return transacdetailsDataType;
    }

    public void setTransacdetailsDataType(String transacdetailsDataType[])
    {
        this.transacdetailsDataType = transacdetailsDataType;
    }

    public String[] getTransacdetailsNo()
    {
        return transacdetailsNo;
    }

    public void setTransacdetailsNo(String transacdetailsNo[])
    {
        this.transacdetailsNo = transacdetailsNo;
    }

    public void setTransactionNo(String transactionNo)
    {
        this.transactionNo = transactionNo;
    }

    public String getTransactionNo()
    {
        return transactionNo;
    }

    public void setTransactiondetailsRemarks(String transactiondetailsRemarks)
    {
        this.transactiondetailsRemarks = transactiondetailsRemarks;
    }

    public String getTransactiondetailsRemarks()
    {
        return transactiondetailsRemarks;
    }

    public void setTransactiondetailsmode(String transactiondetailsmode)
    {
        this.transactiondetailsmode = transactiondetailsmode;
    }

    public String getTransactiondetailsmode()
    {
        return transactiondetailsmode;
    }

    public void setTransactiondetailsDebit(String transactiondetailsDebit)
    {
        this.transactiondetailsDebit = transactiondetailsDebit;
    }

    public String getTransactiondetailsDebit()
    {
        return transactiondetailsDebit;
    }

    public void setTransactiondetailsdate(String transactiondetailsdate)
    {
        this.transactiondetailsdate = transactiondetailsdate;
    }

    public String getTransactiondetailsdate()
    {
        return transactiondetailsdate;
    }

    public void setTransactiondetailsAmount(String transactiondetailsAmount)
    {
        this.transactiondetailsAmount = transactiondetailsAmount;
    }

    public String getTransactiondetailsAmount()
    {
        return transactiondetailsAmount;
    }

    public void setStrRiskFlag(String strRiskFlag)
    {
        this.strRiskFlag = strRiskFlag;
    }

    public String getStrRiskFlag()
    {
        return strRiskFlag;
    }

    public void setStrCustName(String strCustName)
    {
        this.strCustName = strCustName;
    }

    public String getStrCustName()
    {
        return strCustName;
    }

    public void setNoOfTransactions(int NoOfTransactions)
    {
        this.NoOfTransactions = NoOfTransactions;
    }

    public int getNoOfTransactions()
    {
        return NoOfTransactions;
    }

    public String[] getWriteUpTxns()
    {
        return writeUpTxns;
    }

    public void setWriteUpTxns(String writeUpTxns[])
    {
        this.writeUpTxns = writeUpTxns;
    }
    
    public String getbSRcode() {
		return bSRcode;
	}

	public void setbSRcode(String bSRcode) {
		this.bSRcode = bSRcode;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public String getBankBsrCode() {
		return bankBsrCode;
	}

	public void setBankBsrCode(String bankBsrCode) {
		this.bankBsrCode = bankBsrCode;
	}

	public String getBankFIUId() {
		return bankFIUId;
	}

	public void setBankFIUId(String bankFIUId) {
		this.bankFIUId = bankFIUId;
	}

	public String getBranchName() {
		return branchName;
	}

	public void setBranchName(String branchName) {
		this.branchName = branchName;
	}

	public String getBranchReferenceNumberType() {
		return branchReferenceNumberType;
	}

	public void setBranchReferenceNumberType(String branchReferenceNumberType) {
		this.branchReferenceNumberType = branchReferenceNumberType;
	}

	public String getBranchBsrCode() {
		return branchBsrCode;
	}

	public void setBranchBsrCode(String branchBsrCode) {
		this.branchBsrCode = branchBsrCode;
	}

	public String getBranchFIUId() {
		return branchFIUId;
	}

	public void setBranchFIUId(String branchFIUId) {
		this.branchFIUId = branchFIUId;
	}

	public String getBranchAddressLine1() {
		return branchAddressLine1;
	}

	public void setBranchAddressLine1(String branchAddressLine1) {
		this.branchAddressLine1 = branchAddressLine1;
	}

	public String getBranchAddressLine2() {
		return branchAddressLine2;
	}

	public void setBranchAddressLine2(String branchAddressLine2) {
		this.branchAddressLine2 = branchAddressLine2;
	}

	public String getBranchAddressLine3() {
		return branchAddressLine3;
	}

	public void setBranchAddressLine3(String branchAddressLine3) {
		this.branchAddressLine3 = branchAddressLine3;
	}

	public String getBranchCity() {
		return branchCity;
	}

	public void setBranchCity(String branchCity) {
		this.branchCity = branchCity;
	}

	public String getBranchState() {
		return branchState;
	}

	public void setBranchState(String branchState) {
		this.branchState = branchState;
	}

	public String getBranchCountry() {
		return branchCountry;
	}

	public void setBranchCountry(String branchCountry) {
		this.branchCountry = branchCountry;
	}

	public String getBranchPinCode() {
		return branchPinCode;
	}

	public void setBranchPinCode(String branchPinCode) {
		this.branchPinCode = branchPinCode;
	}

	public String getBranchTelephoneNo() {
		return branchTelephoneNo;
	}

	public void setBranchTelephoneNo(String branchTelephoneNo) {
		this.branchTelephoneNo = branchTelephoneNo;
	}

	public String getBranchFaxNo() {
		return branchFaxNo;
	}

	public void setBranchFaxNo(String branchFaxNo) {
		this.branchFaxNo = branchFaxNo;
	}

	public String getBranchMobileNo() {
		return branchMobileNo;
	}

	public void setBranchMobileNo(String branchMobileNo) {
		this.branchMobileNo = branchMobileNo;
	}

	public String getBranchEmailId() {
		return branchEmailId;
	}

	public void setBranchEmailId(String branchEmailId) {
		this.branchEmailId = branchEmailId;
	}

	public String getAccountHolderName() {
		return accountHolderName;
	}

	public void setAccountHolderName(String accountHolderName) {
		this.accountHolderName = accountHolderName;
	}

	public String getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(String accountStatus) {
		this.accountStatus = accountStatus;
	}

	public String getAccountTotalCredit() {
		return accountTotalCredit;
	}

	public void setAccountTotalCredit(String accountTotalCredit) {
		this.accountTotalCredit = accountTotalCredit;
	}

	public String getAccountTotalDebit() {
		return accountTotalDebit;
	}

	public void setAccountTotalDebit(String accountTotalDebit) {
		this.accountTotalDebit = accountTotalDebit;
	}

	public String getAccountTotalCashCredit() {
		return accountTotalCashCredit;
	}

	public void setAccountTotalCashCredit(String accountTotalCashCredit) {
		this.accountTotalCashCredit = accountTotalCashCredit;
	}

	public String getAccountTotalCashDebit() {
		return accountTotalCashDebit;
	}

	public void setAccountTotalCashDebit(String accountTotalCashDebit) {
		this.accountTotalCashDebit = accountTotalCashDebit;
	}

	public String getAccountRiskCategory() {
		return accountRiskCategory;
	}

	public void setAccountRiskCategory(String accountRiskCategory) {
		this.accountRiskCategory = accountRiskCategory;
	}

	private String nameOfBank;
    private String bSRcode;
    private String annexEnclosed;
    private String accountNo;
    private String accountType;
    private String accountHoldertype;
    private String accountOpenDate;
    private String listofAccountHoldersName[];
    private String listofAccountHoldersID[];
    private String listofAccountHoldersAnnexAB[];
    private String listofAccountHoldersAnnexNumber[];
    private boolean listofAccountHoldersAnnexFlag[];
    private String listofRelatedPersonsName[];
    private String listofRelatedPersonsID[];
    private String listofRelatedPersonsRelation[];
    private String listofRelatedPersonsAnnexAB[];
    private String listofRelatedPersonsAnnexNumber[];
    private boolean listofRelatedPersonsAnnexFlag[];
    private String transacdetailsNo[];
    private String transacdetailsdate[];
    private String transacdetailsmode[];
    private String transacdetailsDebit[];
    private String transacdetailsAmount[];
    private String transacdetailsRemarks[];
    private String transacdetailsDataType[];
    private String cummulativetotalsDebit;
    private String cummulativetotalsCredit;
    private String strRiskFlag;
    private String strCustName;
    private String transactiondetailsdate;
    private String transactiondetailsmode;
    private String transactiondetailsDebit;
    private String transactiondetailsAmount;
    private String transactiondetailsRemarks;
    private String transactionNo;
    private int NoOfTransactions;
    private String writeUpTxns[];
    private String bankName ;
    private String bankBsrCode;
    private String bankFIUId;
    private String branchName;
    private String branchReferenceNumberType;
    private String branchBsrCode;
    private String branchFIUId;
    private String branchAddressLine1;
    private String branchAddressLine2;
    private String branchAddressLine3;
    private String branchCity;
    private String branchState;
    private String branchCountry;
    private String branchPinCode;
    private String branchTelephoneNo;
    private String branchFaxNo;
    private String branchMobileNo;
    private String branchEmailId;
    private String accountHolderName;
    private String accountStatus;
    private String accountTotalCredit;
    private String accountTotalDebit;
    private String accountTotalCashCredit;
    private String accountTotalCashDebit;
    private String accountRiskCategory;
}