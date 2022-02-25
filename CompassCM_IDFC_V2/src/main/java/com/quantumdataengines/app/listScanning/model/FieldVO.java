package com.quantumdataengines.app.listScanning.model;

public final class FieldVO
{
    private String fieldName;
    private int fieldPos;
    private int size;
    private String fieldDelimiter;
    private String dataType;
    private boolean nullAllowed;
    private String defaultValue;
    
    public FieldVO()
    {
        fieldName = null;
        fieldPos = 0;
        size = 0;
        fieldDelimiter = null;
        dataType = null;
        nullAllowed = false;
        defaultValue = null;
    }

    public String getFieldName()
    {
        return fieldName;
    }
    public void setFieldName(String fieldName)
    {
        this.fieldName = fieldName;
    }

    public int getFieldPos()
    {
        return fieldPos;
    }
    public void setFieldPos(int fieldPos)
    {
        this.fieldPos = fieldPos;
    }

    public int getSize()
    {
        return size;
    }
    public void setSize(int size)
    {
        this.size = size;
    }


    public String getFieldDelimiter()
    {
        return fieldDelimiter;
    }
    public void setFieldDelimiter(String fieldDelimiter)
    {
        this.fieldDelimiter = fieldDelimiter;
    }

    public String getDataType()
    {
        return dataType;
    }
    public void setDataType(String dataType)
    {
        this.dataType = dataType;
    }
    
    public void setNullAllowed(boolean nullAllowed)
    {
        this.nullAllowed = nullAllowed;
    }
    public boolean isNullAllowed()
    {
        return nullAllowed;
    }

    public String getDefaultValue()
    {
        return defaultValue;
    }
    public void setDefaultValue(String defaultValue)
    {
        this.defaultValue = defaultValue;
    }
 }