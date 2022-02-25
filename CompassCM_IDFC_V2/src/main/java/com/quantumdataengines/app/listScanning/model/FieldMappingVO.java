package com.quantumdataengines.app.listScanning.model;

public class FieldMappingVO {
    public FieldMappingVO()
    {
    }

    public void setDataFields(String dataFields[])
    {
        this.dataFields = dataFields;
    }

    public String[] getDataFields()
    {
        return dataFields;
    }

    public String getDelimiter()
    {
        return delimiter;
    }

    public void setDelimiter(String delimiter)
    {
        this.delimiter = delimiter;
    }

    public String getFieldCategory()
    {
        return fieldCategory;
    }

    public void setFieldCategory(String fieldCategory)
    {
        this.fieldCategory = fieldCategory;
    }

    public String getFieldType()
    {
        return fieldType;
    }

    public void setFieldType(String fieldType)
    {
        this.fieldType = fieldType;
    }

    public boolean isRepeated()
    {
        return isRepeated;
    }

    public void setIsRepeated(boolean isRepeated)
    {
        this.isRepeated = isRepeated;
    }

    public String getMatchField()
    {
        return matchField;
    }

    public void setMatchField(String matchField)
    {
        this.matchField = matchField;
    }

    public int getScoreLimit()
    {
        return scoreLimit;
    }

    public void setScoreLimit(int scoreLimit)
    {
        this.scoreLimit = scoreLimit;
    }

    public String getSourceField()
    {
        return sourceField;
    }

    public void setSourceField(String sourceField)
    {
        this.sourceField = sourceField;
    }

    private String fieldType;
    private String fieldCategory;
    private String sourceField;
    private String matchField;
    private int scoreLimit;
    private boolean isRepeated;
    private String delimiter;
    private String dataFields[];
}