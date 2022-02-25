package com.quantumdataengines.app.compass.model.regulatoryReports.india;

public class ISTRUpdatesVO
{

    public ISTRUpdatesVO()
    {
        bankName = null;
        bankEmp = null;
        suspectName = null;
        transactionno = null;
        accountno = null;
        status = null;
        date = null;
        verifiedDate = null;
        vcomments = null;
        approvedDate = null;
        acomments = null;
    }

    public void setApprovedDate(String approvedDate)
    {
        this.approvedDate = approvedDate;
    }

    public String getApprovedDate()
    {
        return approvedDate;
    }

    public void setAcomments(String acomments)
    {
        this.acomments = acomments;
    }

    public String getAcomments()
    {
        return acomments;
    }

    public String getVcomments()
    {
        return vcomments;
    }

    public void setVcomments(String vcomments)
    {
        this.vcomments = vcomments;
    }

    public String getVerifiedDate()
    {
        return verifiedDate;
    }

    public void setVerifiedDate(String verifiedDate)
    {
        this.verifiedDate = verifiedDate;
    }

    public String getAccountno()
    {
        return accountno;
    }

    public void setAccountno(String accountno)
    {
        this.accountno = accountno;
    }

    public String getBankEmp()
    {
        return bankEmp;
    }

    public void setBankEmp(String bankEmp)
    {
        this.bankEmp = bankEmp;
    }

    public String getBankName()
    {
        return bankName;
    }

    public void setBankName(String bankName)
    {
        this.bankName = bankName;
    }

    public String getDate()
    {
        return date;
    }

    public void setDate(String date)
    {
        this.date = date;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getSuspectName()
    {
        return suspectName;
    }

    public void setSuspectName(String suspectName)
    {
        this.suspectName = suspectName;
    }

    public String getTransactionno()
    {
        return transactionno;
    }

    public void setTransactionno(String transactionno)
    {
        this.transactionno = transactionno;
    }

    private String bankName;
    private String bankEmp;
    private String suspectName;
    private String transactionno;
    private String accountno;
    private String status;
    private String date;
    private String verifiedDate;
    private String vcomments;
    private String approvedDate;
    private String acomments;
}