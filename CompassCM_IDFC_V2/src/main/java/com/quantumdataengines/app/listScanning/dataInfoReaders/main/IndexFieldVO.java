package com.quantumdataengines.app.listScanning.dataInfoReaders.main;

public class IndexFieldVO
{

    public IndexFieldVO()
    {
    }

    public void setIsRepeated(boolean isRepeated)
    {
        this.isRepeated = isRepeated;
    }

    public boolean IsRepeated()
    {
        return isRepeated;
    }

    public void setDelimiter(String delimiter)
    {
        this.delimiter = delimiter;
    }

    public String getDelimiter()
    {
        return delimiter;
    }

    public void setFieldName(String fieldName)
    {
        this.fieldName = fieldName;
    }

    public String getFieldName()
    {
        return fieldName;
    }

    public void setDataFields(String dataFields[])
    {
        this.dataFields = dataFields;
    }

    public String[] getDataFields()
    {
        return dataFields;
    }

    private String fieldName;
    private String dataFields[];
    private boolean isRepeated;
    private String delimiter;
}