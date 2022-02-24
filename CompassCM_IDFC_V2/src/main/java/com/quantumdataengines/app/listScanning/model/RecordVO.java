package com.quantumdataengines.app.listScanning.model;

public class RecordVO
{

    public RecordVO()
    {
        noOfFields = 0;
        fieldDelimiters = null;
        recordDelimiter = null;
    }

    public void setRecordDelimiter(String recordDelimiter)
    {
        this.recordDelimiter = recordDelimiter;
    }

    public String getRecordDelimiter()
    {
        return recordDelimiter;
    }

    public void setNoOfFields(int noOfFields)
    {
        this.noOfFields = noOfFields;
    }

    public int getNoOfFields()
    {
        return noOfFields;
    }

    public void setDelimiters(String delimiters[])
    {
        fieldDelimiters = delimiters;
    }

    public String[] getDelimiters()
    {
        return fieldDelimiters;
    }

    public String getDelimiter(int fieldPos)
    {
        return fieldDelimiters[fieldPos];
    }

    private int noOfFields;
    private String fieldDelimiters[];
    private String recordDelimiter;
}