package com.quantumdataengines.app.compass.model.regulatoryReports.india;

import java.io.Serializable;

public class ISTRCompleteDetailsVO implements Serializable
{

    public ISTRCompleteDetailsVO()
    {
        BankName = "";
        BranchName = "";
        BranchAddress = "";
        Telephone = "";
        ReportingOfficer = "";
        Designation = "";
        ReportReference = "";
        ContactOfficer = "";
        CODesignation = "";
        SuspiciousReason = new String[11];
        OtherInformation = new String[11];
        CustomerName = "";
        PassPortNo = "";
        DataOfBirth = "";
        Nationality = "";
        CustomerAddress = "";
        CustomerPhoneNo = "";
        Occupation = "";
        CeoName = "";
        LastUpdatedDate = "";
        EmployerName = "";
        EmployerAddress = "";
        EmployerPhoneNo = "";
        CustomerId = "";
        AccountNo = "";
        AccountType = "";
        AccountOpenedDate = "";
        AccountBalance = "";
        AsAtDate = "";
        OtherRelation = "";
        SignatoryName = "";
        SignatoryBirthDate = "";
        SignatoryNationality = "";
        SignatoryPassPortNo = "";
        SignatoryAddress = "";
        TotalTrans = 0;
        TransactionDateTime = new String[50];
        DepositOrWithDrawal = new String[50];
        Amount = new String[50];
        Narration = new String[50];
        TypeFlag = "";
        SARDate = "";
        ProductName = "";
        Gender = "";
        Currency = "";
        TransactionNo = "";
        DisclosedAccName = "";
        AccountName = "";
        F1Name = "";
        SortCode = "";
        Opened = "";
        Closed = "";
        BalancedDate = "";
        TurnOverCredit = "";
        TurnOverDebit = "";
        TurnOverPeriod = "";
        ThirdPartyName = "";
        ThirdPartyAccNo = "";
        ThirdPartyF1Name = "";
        ThirdPartySortCode = "";
        InfoType = new String[25];
        InfoID = new String[25];
        ExtraInfo = new String[25];
        EntityName = new String[25];
        EntityNo = new String[25];
        VatNo = new String[25];
        BusinessType = new String[25];
        Registered = new String[25];
        AssociatedReason = new String[25];
        RefSource = "";
        DisclosureType = "";
        Consent = "";
        SourceOutlet = "";
        DisclosureID = "";
        TransactionDate = "";
        CreditOrDebit = "";
        PermanentAddress = "";
        AddressType = "";
        TransactionAmount = "";
        EntityAddressType = new String[50];
        EntityCurrAddress = new String[50];
        EntityPermanentAddress = new String[50];
        Notes = "";
        AccountClosedDate = "";
        SignatoryAccountNo = "";
        Infocount = 0;
        Entitycount = 0;
        subjectStatus = "";
        subjectDetailMain = "";
        additionalDetailMain = "";
        subjectDetailAsso = "";
        additionalDetailAsso = "";
        transactionDetails = "";
        disclosureSheet = "";
        totalSheet = "";
        subjectType = "";
        subjectFromNo = "";
        subjectToNo = "";
        reasonForAsso = "";
        addSubjectType = "";
        additionlaNum = "";
        eternalDetailNID = "";
        externalDetailDLN = "";
        externalDetailPPN = "";
        activityAsoosiates = "";
        pocaRefNo = "";
        BankType = "";
    }

    public String getBankName()
    {
        return BankName;
    }

    public void setBankName(String BankName)
    {
        this.BankName = BankName;
    }

    public void setBranchName(String BranchName)
    {
        this.BranchName = BranchName;
    }

    public String getBranchName()
    {
        return BranchName;
    }

    public void setBranchAddress(String BranchAddress)
    {
        this.BranchAddress = BranchAddress;
    }

    public String getBranchAddress()
    {
        return BranchAddress;
    }

    public void setTelephone(String Telephone)
    {
        this.Telephone = Telephone;
    }

    public String getTelephone()
    {
        return Telephone;
    }

    public void setReportingOfficer(String ReportingOfficer)
    {
        this.ReportingOfficer = ReportingOfficer;
    }

    public String getReportingOfficer()
    {
        return ReportingOfficer;
    }

    public void setContactOfficer(String ContactOfficer)
    {
        this.ContactOfficer = ContactOfficer;
    }

    public String getContactOfficer()
    {
        return ContactOfficer;
    }

    public String getDesignation()
    {
        return Designation;
    }

    public void setDesignation(String Designation)
    {
        this.Designation = Designation;
    }

    public String getReportReference()
    {
        return ReportReference;
    }

    public void setReportReference(String ReportReference)
    {
        this.ReportReference = ReportReference;
    }

    public void setCODesignation(String CODesignation)
    {
        this.CODesignation = CODesignation;
    }

    public String getCODesignation()
    {
        return CODesignation;
    }

    public String getCustomerName()
    {
        return CustomerName;
    }

    public void setCustomerName(String CustomerName)
    {
        this.CustomerName = CustomerName;
    }

    public String getPassPortNo()
    {
        return PassPortNo;
    }

    public void setPassPortNo(String PassPortNo)
    {
        this.PassPortNo = PassPortNo;
    }

    public String getDataOfBirth()
    {
        return DataOfBirth;
    }

    public void setDataOfBirth(String DataOfBirth)
    {
        this.DataOfBirth = DataOfBirth;
    }

    public String getNationality()
    {
        return Nationality;
    }

    public void setNationality(String Nationality)
    {
        this.Nationality = Nationality;
    }

    public String getCustomerAddress()
    {
        return CustomerAddress;
    }

    public void setCustomerAddress(String CustomerAddress)
    {
        this.CustomerAddress = CustomerAddress;
    }

    public String getCustomerPhoneNo()
    {
        return CustomerPhoneNo;
    }

    public void setCustomerPhoneNo(String CustomerPhoneNo)
    {
        this.CustomerPhoneNo = CustomerPhoneNo;
    }

    public String getOccupation()
    {
        return Occupation;
    }

    public void setOccupation(String Occupation)
    {
        this.Occupation = Occupation;
    }

    public String getCeoName()
    {
        return CeoName;
    }

    public void setCeoName(String CeoName)
    {
        this.CeoName = CeoName;
    }

    public String getLastUpdatedDate()
    {
        return LastUpdatedDate;
    }

    public void setLastUpdatedDate(String LastUpdatedDate)
    {
        this.LastUpdatedDate = LastUpdatedDate;
    }

    public String getEmployerName()
    {
        return EmployerName;
    }

    public void setEmployerName(String EmployerName)
    {
        this.EmployerName = EmployerName;
    }

    public void setEmployerAddress(String EmployerAddress)
    {
        this.EmployerAddress = EmployerAddress;
    }

    public String getEmployerAddress()
    {
        return EmployerAddress;
    }

    public void setEmployerPhoneNo(String EmployerPhoneNo)
    {
        this.EmployerPhoneNo = EmployerPhoneNo;
    }

    public String getEmployerPhoneNo()
    {
        return EmployerPhoneNo;
    }

    public void setCustomerId(String CustomerId)
    {
        this.CustomerId = CustomerId;
    }

    public String getCustomerId()
    {
        return CustomerId;
    }

    public void setAccountNo(String AccountNo)
    {
        this.AccountNo = AccountNo;
    }

    public String getAccountNo()
    {
        return AccountNo;
    }

    public String getAccountType()
    {
        return AccountType;
    }

    public void setAccountType(String AccountType)
    {
        this.AccountType = AccountType;
    }

    public void setAccountOpenedDate(String AccountOpenedDate)
    {
        this.AccountOpenedDate = AccountOpenedDate;
    }

    public String getAccountOpenedDate()
    {
        return AccountOpenedDate;
    }

    public void setAccountBalance(String AccountBalance)
    {
        this.AccountBalance = AccountBalance;
    }

    public String getAccountBalance()
    {
        return AccountBalance;
    }

    public void setAsAtDate(String AsAtDate)
    {
        this.AsAtDate = AsAtDate;
    }

    public String getAsAtDate()
    {
        return AsAtDate;
    }

    public void setOtherRelation(String OtherRelation)
    {
        this.OtherRelation = OtherRelation;
    }

    public String getOtherRelation()
    {
        return OtherRelation;
    }

    public void setSignatoryName(String SignatoryName)
    {
        this.SignatoryName = SignatoryName;
    }

    public String getSignatoryName()
    {
        return SignatoryName;
    }

    public void setSignatoryBirthDate(String SignatoryBirthDate)
    {
        this.SignatoryBirthDate = SignatoryBirthDate;
    }

    public String getSignatoryBirthDate()
    {
        return SignatoryBirthDate;
    }

    public void setSignatoryNationality(String SignatoryNationality)
    {
        this.SignatoryNationality = SignatoryNationality;
    }

    public String getSignatoryNationality()
    {
        return SignatoryNationality;
    }

    public String getSignatoryPassPortNo()
    {
        return SignatoryPassPortNo;
    }

    public void setSignatoryPassPortNo(String SignatoryPassPortNo)
    {
        this.SignatoryPassPortNo = SignatoryPassPortNo;
    }

    public String getSignatoryAddress()
    {
        return SignatoryAddress;
    }

    public void setSignatoryAddress(String SignatoryAddress)
    {
        this.SignatoryAddress = SignatoryAddress;
    }

    public void setTotalTrans(int TotalTrans)
    {
        this.TotalTrans = TotalTrans;
    }

    public int getTotalTrans()
    {
        return TotalTrans;
    }

    public void setTransactionDateTime(String TransactionDateTime[])
    {
        this.TransactionDateTime = TransactionDateTime;
    }

    public String[] getTransactionDateTime()
    {
        return TransactionDateTime;
    }

    public void setDepositOrWithDrawal(String DepositOrWithDrawal[])
    {
        this.DepositOrWithDrawal = DepositOrWithDrawal;
    }

    public String[] getDepositOrWithDrawal()
    {
        return DepositOrWithDrawal;
    }

    public void setAmount(String Amount[])
    {
        this.Amount = Amount;
    }

    public String[] getAmount()
    {
        return Amount;
    }

    public void setNarration(String Narration[])
    {
        this.Narration = Narration;
    }

    public String[] getNarration()
    {
        return Narration;
    }

    public void setSuspiciousReason(String SuspiciousReason[])
    {
        this.SuspiciousReason = SuspiciousReason;
    }

    public String[] getSuspiciousReason()
    {
        return SuspiciousReason;
    }

    public void setOtherInformation(String OtherInformation[])
    {
        this.OtherInformation = OtherInformation;
    }

    public String[] getOtherInformation()
    {
        return OtherInformation;
    }

    public boolean getIsSaved()
    {
        return IsSaved;
    }

    public void setIsSaved(boolean IsSaved)
    {
        this.IsSaved = IsSaved;
    }

    public void setSARDate(String SARDate)
    {
        this.SARDate = SARDate;
    }

    public String getSARDate()
    {
        return SARDate;
    }

    public String getCreditOrDebit()
    {
        return CreditOrDebit;
    }

    public void setCreditOrDebit(String CreditOrDebit)
    {
        this.CreditOrDebit = CreditOrDebit;
    }

    public String getNotes()
    {
        return Notes;
    }

    public void setNotes(String Notes)
    {
        this.Notes = Notes;
    }

    public String getTransactionDate()
    {
        return TransactionDate;
    }

    public void setTransactionAmount(String TransactionAmount)
    {
        this.TransactionAmount = TransactionAmount;
    }

    public void setTransactionDate(String TransactionDate)
    {
        this.TransactionDate = TransactionDate;
    }

    public String getTransactionAmount()
    {
        return TransactionAmount;
    }

    public void setTrnasactionAmount(String TransactionAmount)
    {
        this.TransactionAmount = TransactionAmount;
    }

    public void setTypeFlag(String TypeFlag)
    {
        this.TypeFlag = TypeFlag;
    }

    public String getTypeFlag()
    {
        return TypeFlag;
    }

    public void setSourceOutlet(String SourceOutlet)
    {
        this.SourceOutlet = SourceOutlet;
    }

    public String getSourceOutlet()
    {
        return SourceOutlet;
    }

    public String[] getAssociatedReason()
    {
        return AssociatedReason;
    }

    public void setAssociatedReason(String AssociatedReason[])
    {
        this.AssociatedReason = AssociatedReason;
    }

    public String[] getBusinessType()
    {
        return BusinessType;
    }

    public void setBusinessType(String BusinessType[])
    {
        this.BusinessType = BusinessType;
    }

    public String[] getEntityName()
    {
        return EntityName;
    }

    public void setEntityName(String EntityName[])
    {
        this.EntityName = EntityName;
    }

    public String[] getEntityNo()
    {
        return EntityNo;
    }

    public void setEntityNo(String EntityNo[])
    {
        this.EntityNo = EntityNo;
    }

    public String[] getExtraInfo()
    {
        return ExtraInfo;
    }

    public void setExtraInfo(String ExtraInfo[])
    {
        this.ExtraInfo = ExtraInfo;
    }

    public String[] getInfoID()
    {
        return InfoID;
    }

    public void setInfoID(String InfoID[])
    {
        this.InfoID = InfoID;
    }

    public String[] getInfoType()
    {
        return InfoType;
    }

    public void setInfoType(String InfoType[])
    {
        this.InfoType = InfoType;
    }

    public String[] getRegistered()
    {
        return Registered;
    }

    public void setRegistered(String Registered[])
    {
        this.Registered = Registered;
    }

    public String[] getVatNo()
    {
        return VatNo;
    }

    public void setVatNo(String VatNo[])
    {
        this.VatNo = VatNo;
    }

    public void setRefSource(String RefSource)
    {
        this.RefSource = RefSource;
    }

    public String getRefSource()
    {
        return RefSource;
    }

    public void setDisclosureType(String DisclosureType)
    {
        this.DisclosureType = DisclosureType;
    }

    public String getDisclosureType()
    {
        return DisclosureType;
    }

    public void setDisclosureID(String DisclosureID)
    {
        this.DisclosureID = DisclosureID;
    }

    public String getDisclosureID()
    {
        return DisclosureID;
    }

    public void setConsent(String Consent)
    {
        this.Consent = Consent;
    }

    public String getConsent()
    {
        return Consent;
    }

    public String getAccountName()
    {
        return AccountName;
    }

    public String getBalancedDate()
    {
        return BalancedDate;
    }

    public String getClosed()
    {
        return Closed;
    }

    public String getDisclosedAccName()
    {
        return DisclosedAccName;
    }

    public String getF1Name()
    {
        return F1Name;
    }

    public String getOpened()
    {
        return Opened;
    }

    public String getSortCode()
    {
        return SortCode;
    }

    public String getThirdPartyAccNo()
    {
        return ThirdPartyAccNo;
    }

    public String getThirdPartyF1Name()
    {
        return ThirdPartyF1Name;
    }

    public String getThirdPartyName()
    {
        return ThirdPartyName;
    }

    public String getThirdPartySortCode()
    {
        return ThirdPartySortCode;
    }

    public String getTurnOverCredit()
    {
        return TurnOverCredit;
    }

    public String getTurnOverDebit()
    {
        return TurnOverDebit;
    }

    public String getTurnOverPeriod()
    {
        return TurnOverPeriod;
    }

    public void setAccountName(String AccountName)
    {
        this.AccountName = AccountName;
    }

    public void setBalancedDate(String BalancedDate)
    {
        this.BalancedDate = BalancedDate;
    }

    public void setClosed(String Closed)
    {
        this.Closed = Closed;
    }

    public void setDisclosedAccName(String DisclosedAccName)
    {
        this.DisclosedAccName = DisclosedAccName;
    }

    public void setF1Name(String F1Name)
    {
        this.F1Name = F1Name;
    }

    public void setOpened(String Opened)
    {
        this.Opened = Opened;
    }

    public void setSortCode(String SortCode)
    {
        this.SortCode = SortCode;
    }

    public void setThirdPartyAccNo(String ThirdPartyAccNo)
    {
        this.ThirdPartyAccNo = ThirdPartyAccNo;
    }

    public void setThirdPartyF1Name(String ThirdPartyF1Name)
    {
        this.ThirdPartyF1Name = ThirdPartyF1Name;
    }

    public void setThirdPartyName(String ThirdPartyName)
    {
        this.ThirdPartyName = ThirdPartyName;
    }

    public void setThirdPartySortCode(String ThirdPartySortCode)
    {
        this.ThirdPartySortCode = ThirdPartySortCode;
    }

    public void setTurnOverCredit(String TurnOverCredit)
    {
        this.TurnOverCredit = TurnOverCredit;
    }

    public void setTurnOverDebit(String TurnOverDebit)
    {
        this.TurnOverDebit = TurnOverDebit;
    }

    public void setTurnOverPeriod(String TurnOverPeriod)
    {
        this.TurnOverPeriod = TurnOverPeriod;
    }

    public void setTransactionNo(String TransactionNo)
    {
        this.TransactionNo = TransactionNo;
    }

    public String getTransactionNo()
    {
        return TransactionNo;
    }

    public void setCurrency(String Currency)
    {
        this.Currency = Currency;
    }

    public String getCurrency()
    {
        return Currency;
    }

    public void setGender(String Gender)
    {
        this.Gender = Gender;
    }

    public String getGender()
    {
        return Gender;
    }

    public void setAccountClosedDate(String AccountClosedDate)
    {
        this.AccountClosedDate = AccountClosedDate;
    }

    public String getAccountClosedDate()
    {
        return AccountClosedDate;
    }

    public void setProductName(String ProductName)
    {
        this.ProductName = ProductName;
    }

    public String getProductName()
    {
        return ProductName;
    }

    public void setSignatoryAccountNo(String SignatoryAccountNo)
    {
        this.SignatoryAccountNo = SignatoryAccountNo;
    }

    public String getSignatoryAccountNo()
    {
        return SignatoryAccountNo;
    }

    public void setAddressType(String AddressType)
    {
        this.AddressType = AddressType;
    }

    public String getAddressType()
    {
        return AddressType;
    }

    public void setPermanentAddress(String PermanentAddress)
    {
        this.PermanentAddress = PermanentAddress;
    }

    public String getPermanentAddress()
    {
        return PermanentAddress;
    }

    public void setEntityPermanentAddress(String EntityPermanentAddress[])
    {
        this.EntityPermanentAddress = EntityPermanentAddress;
    }

    public String[] getEntityPermanentAddress()
    {
        return EntityPermanentAddress;
    }

    public void setEntityCurrAddress(String EntityCurrAddress[])
    {
        this.EntityCurrAddress = EntityCurrAddress;
    }

    public String[] getEntityCurrAddress()
    {
        return EntityCurrAddress;
    }

    public void setEntityAddressType(String EntityAddressType[])
    {
        this.EntityAddressType = EntityAddressType;
    }

    public String[] getEntityAddressType()
    {
        return EntityAddressType;
    }

    public void setInfocount(int Infocount)
    {
        this.Infocount = Infocount;
    }

    public int getInfocount()
    {
        return Infocount;
    }

    public void setEntitycount(int Entitycount)
    {
        this.Entitycount = Entitycount;
    }

    public int getEntitycount()
    {
        return Entitycount;
    }

    public String getBankType()
    {
        return BankType;
    }

    public void setBankType(String bankType)
    {
        BankType = bankType;
    }

    public String getSubjectStatus()
    {
        return subjectStatus;
    }

    public void setSubjectStatus(String subjectStatus)
    {
        this.subjectStatus = subjectStatus;
    }

    public String getActivityAsoosiates()
    {
        return activityAsoosiates;
    }

    public void setActivityAsoosiates(String activityAsoosiates)
    {
        this.activityAsoosiates = activityAsoosiates;
    }

    public String getAdditionalDetailAsso()
    {
        return additionalDetailAsso;
    }

    public void setAdditionalDetailAsso(String additionalDetailAsso)
    {
        this.additionalDetailAsso = additionalDetailAsso;
    }

    public String getAdditionalDetailMain()
    {
        return additionalDetailMain;
    }

    public void setAdditionalDetailMain(String additionalDetailMain)
    {
        this.additionalDetailMain = additionalDetailMain;
    }

    public String getAdditionlaNum()
    {
        return additionlaNum;
    }

    public void setAdditionlaNum(String additionlaNum)
    {
        this.additionlaNum = additionlaNum;
    }

    public String getAddSubjectType()
    {
        return addSubjectType;
    }

    public void setAddSubjectType(String addSubjectType)
    {
        this.addSubjectType = addSubjectType;
    }

    public String getDisclosureSheet()
    {
        return disclosureSheet;
    }

    public void setDisclosureSheet(String disclosureSheet)
    {
        this.disclosureSheet = disclosureSheet;
    }

    public String getEternalDetailNID()
    {
        return eternalDetailNID;
    }

    public void setEternalDetailNID(String eternalDetailNID)
    {
        this.eternalDetailNID = eternalDetailNID;
    }

    public String getExternalDetailDLN()
    {
        return externalDetailDLN;
    }

    public void setExternalDetailDLN(String externalDetailDLN)
    {
        this.externalDetailDLN = externalDetailDLN;
    }

    public String getExternalDetailPPN()
    {
        return externalDetailPPN;
    }

    public void setExternalDetailPPN(String externalDetailPPN)
    {
        this.externalDetailPPN = externalDetailPPN;
    }

    public String getReasonForAsso()
    {
        return reasonForAsso;
    }

    public void setReasonForAsso(String reasonForAsso)
    {
        this.reasonForAsso = reasonForAsso;
    }

    public String getSubjectDetailAsso()
    {
        return subjectDetailAsso;
    }

    public void setSubjectDetailAsso(String subjectDetailAsso)
    {
        this.subjectDetailAsso = subjectDetailAsso;
    }

    public String getSubjectDetailMain()
    {
        return subjectDetailMain;
    }

    public void setSubjectDetailMain(String subjectDetailMain)
    {
        this.subjectDetailMain = subjectDetailMain;
    }

    public String getSubjectFromNo()
    {
        return subjectFromNo;
    }

    public void setSubjectFromNo(String subjectFromNo)
    {
        this.subjectFromNo = subjectFromNo;
    }

    public String getSubjectToNo()
    {
        return subjectToNo;
    }

    public void setSubjectToNo(String subjectToNo)
    {
        this.subjectToNo = subjectToNo;
    }

    public String getSubjectType()
    {
        return subjectType;
    }

    public void setSubjectType(String subjectType)
    {
        this.subjectType = subjectType;
    }

    public String getTotalSheet()
    {
        return totalSheet;
    }

    public void setTotalSheet(String totalSheet)
    {
        this.totalSheet = totalSheet;
    }

    public String getTransactionDetails()
    {
        return transactionDetails;
    }

    public void setTransactionDetails(String transactionDetails)
    {
        this.transactionDetails = transactionDetails;
    }

    public void setSaved(boolean isSaved)
    {
        IsSaved = isSaved;
    }

    public String getPocaRefNo()
    {
        return pocaRefNo;
    }

    public void setPocaRefNo(String pocaRefNo)
    {
        this.pocaRefNo = pocaRefNo;
    }

    private String BankName;
    private String BranchName;
    private String BranchAddress;
    private String Telephone;
    private String ReportingOfficer;
    private String Designation;
    private String ReportReference;
    private String ContactOfficer;
    private String CODesignation;
    private String SuspiciousReason[];
    private String OtherInformation[];
    private String CustomerName;
    private String PassPortNo;
    private String DataOfBirth;
    private String Nationality;
    private String CustomerAddress;
    private String CustomerPhoneNo;
    private String Occupation;
    private String CeoName;
    private String LastUpdatedDate;
    private String EmployerName;
    private String EmployerAddress;
    private String EmployerPhoneNo;
    private String CustomerId;
    private String AccountNo;
    private String AccountType;
    private String AccountOpenedDate;
    private String AccountBalance;
    private String AsAtDate;
    private String OtherRelation;
    private String SignatoryName;
    private String SignatoryBirthDate;
    private String SignatoryNationality;
    private String SignatoryPassPortNo;
    private String SignatoryAddress;
    private int TotalTrans;
    private String TransactionDateTime[];
    private String DepositOrWithDrawal[];
    private String Amount[];
    private String Narration[];
    private boolean IsSaved;
    private String TypeFlag;
    private String SARDate;
    private String ProductName;
    private String Gender;
    private String Currency;
    private String TransactionNo;
    private String DisclosedAccName;
    private String AccountName;
    private String F1Name;
    private String SortCode;
    private String Opened;
    private String Closed;
    private String BalancedDate;
    private String TurnOverCredit;
    private String TurnOverDebit;
    private String TurnOverPeriod;
    private String ThirdPartyName;
    private String ThirdPartyAccNo;
    private String ThirdPartyF1Name;
    private String ThirdPartySortCode;
    private String InfoType[];
    private String InfoID[];
    private String ExtraInfo[];
    private String EntityName[];
    private String EntityNo[];
    private String VatNo[];
    private String BusinessType[];
    private String Registered[];
    private String AssociatedReason[];
    private String RefSource;
    private String DisclosureType;
    private String Consent;
    private String SourceOutlet;
    private String DisclosureID;
    private String TransactionDate;
    private String CreditOrDebit;
    private String PermanentAddress;
    private String AddressType;
    private String TransactionAmount;
    private String EntityAddressType[];
    private String EntityCurrAddress[];
    private String EntityPermanentAddress[];
    private String Notes;
    private String AccountClosedDate;
    private String SignatoryAccountNo;
    int Infocount;
    int Entitycount;
    private String subjectStatus;
    private String subjectDetailMain;
    private String additionalDetailMain;
    private String subjectDetailAsso;
    private String additionalDetailAsso;
    private String transactionDetails;
    private String disclosureSheet;
    private String totalSheet;
    private String subjectType;
    private String subjectFromNo;
    private String subjectToNo;
    private String reasonForAsso;
    private String addSubjectType;
    private String additionlaNum;
    private String eternalDetailNID;
    private String externalDetailDLN;
    private String externalDetailPPN;
    private String activityAsoosiates;
    private String pocaRefNo;
    private String BankType;
}