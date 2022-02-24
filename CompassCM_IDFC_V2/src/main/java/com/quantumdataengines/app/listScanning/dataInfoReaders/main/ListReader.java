package com.quantumdataengines.app.listScanning.dataInfoReaders.main;

import java.util.HashMap;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;

public abstract class ListReader
{
	private static final Logger log = LoggerFactory.getLogger(ListReader.class);
    public ListReader()
    {
    l_objUniqueFieldVO = null;
    l_strArrayFieldNames = null;
    l_hashMapFieldTypes = null;
    l_hashMapDataFilters = null;
    l_hashMapldValueCache = null;
    l_hashMapFieldIndex = null;
    l_hashMapFieldTypes = new HashMap();
    l_hashMapDataFilters = new HashMap();
    l_hashMapFieldIndex = new HashMap();
    }

    public void setListFields(String strFieldsType, IndexFieldVO objIndexFieldArray[])
    {
    l_hashMapFieldTypes.put(strFieldsType, objIndexFieldArray);
    for(int i = 0; i < objIndexFieldArray.length; i++)
        l_hashMapFieldIndex.put(objIndexFieldArray[i].getFieldName(), objIndexFieldArray[i]);
    }

    public String[] getListFields(String strFieldsType)
    {
    String a_strIndexArry[] = (String[])null;
    if(l_hashMapFieldTypes.containsKey(strFieldsType))
    {
    IndexFieldVO objIndexFieldArray[] = (IndexFieldVO[])l_hashMapFieldTypes.get(strFieldsType);
    a_strIndexArry = new String[objIndexFieldArray.length];
    for(int i = 0; i < objIndexFieldArray.length; i++)
        a_strIndexArry[i] = objIndexFieldArray[i].getFieldName();
    }
    return a_strIndexArry;
    }
    
    public String getFieldDelimiter(String strFieldDelimiter) throws IOAccessError
    {
    String strFieldValue = "";
    try
    {
    if(l_hashMapFieldIndex.containsKey(strFieldDelimiter))
    {
    strFieldValue = ((IndexFieldVO)l_hashMapFieldIndex.get(strFieldDelimiter)).getDelimiter();
    }
    }
    catch(Exception e)
    {
    	log.error("Exception in ListReader->getDelimiter : "+e.toString());
	System.out.println("Exception in ListReader->getDelimiter : "+e.toString());
	throw new IOAccessError(e);
    }
    return strFieldValue;
    }

    public Set getListFieldTypes()
    {
    return l_hashMapFieldTypes.keySet();
    }

    public String getListRecord() throws IOAccessError
    {
    StringBuffer stringBuffer = new StringBuffer();
    for(int i = 0; i < l_strArrayFieldNames.length; i++)
    	stringBuffer.append(l_strArrayFieldNames[i]).append(":").append(getListFieldValue(l_strArrayFieldNames[i])).append("\t");
    return stringBuffer.toString();
    }

    public void setListUniqueIdField(IndexFieldVO objIndexFieldVO)
    {
    l_objUniqueFieldVO = objIndexFieldVO;
    l_hashMapFieldIndex.put(objIndexFieldVO.getFieldName(), objIndexFieldVO);
    }

    public abstract boolean next() throws IOAccessError;
    public abstract boolean open() throws IOAccessError, SourceNotFoundError;

    public String getListFieldValue(String strFieldValue) throws IOAccessError
	{
    String strTempFieldValue = "";
    try
    {
    if(l_hashMapFieldIndex.containsKey(strFieldValue))
    {
    IndexFieldVO objIndexFieldVO = (IndexFieldVO)l_hashMapFieldIndex.get(strFieldValue);
    String strDataFieldArray[] = objIndexFieldVO.getDataFields();
    for(int i = 0; i < strDataFieldArray.length; i++)
    {
	if(l_hashMapldValueCache.get(strDataFieldArray[i]).toString().equals(""))
		continue;
	else
		strTempFieldValue = strTempFieldValue + "  " + (String)l_hashMapldValueCache.get(strDataFieldArray[i]);
    }
    } else
    {
        return (String)l_hashMapldValueCache.get(strFieldValue);
    }
    }
    catch(Exception e)
    {
    	log.error("Exception in ListReader - > getFieldValue : "+e.toString());
	System.out.println("Exception in ListReader - > getFieldValue : "+e.toString());
    throw new IOAccessError(e);
    }
    return strTempFieldValue;
	}
    
    public String getListUniqueId() throws IOAccessError
    {
    return getListFieldValue(l_objUniqueFieldVO.getFieldName());
    }

    public abstract String[] getFieldNames() throws IOAccessError;

    public abstract String getSourceName();
    public HashMap getListFieldValues()
    {
    return l_hashMapldValueCache;
    }

    public abstract boolean opendb(long l, long l1);

    public abstract long getTotalCount() throws IOAccessError, SourceNotFoundError;

    public abstract void close();

    protected IndexFieldVO l_objUniqueFieldVO;
    protected String l_strArrayFieldNames[];
    private HashMap l_hashMapFieldTypes;
    protected HashMap l_hashMapFieldIndex;
    protected HashMap l_hashMapldValueCache;
    protected HashMap l_hashMapDataFilters;
}