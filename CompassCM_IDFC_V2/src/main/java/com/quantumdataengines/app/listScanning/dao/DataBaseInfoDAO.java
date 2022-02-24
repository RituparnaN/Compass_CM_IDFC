package com.quantumdataengines.app.listScanning.dao;

import java.lang.reflect.Constructor;
import java.util.Collection;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class DataBaseInfoDAO
{

	private static final Logger log = LoggerFactory.getLogger(DataBaseInfoDAO.class);
    protected DataBaseInfoDAO() { 
    }
    public abstract HashMap getIndexingInfo(int i);
    public abstract HashMap getIndexingInfo(String s);
    public abstract String getListCode(int i);
    public abstract Collection getSearchSettings(int i);
    public abstract Collection getFieldMappingInfo(int i, String s);
    public abstract void saveSearchResults(Collection collection, int i, String s);
    public static DataBaseInfoDAO getInstance(String a_strDBSource) {
    try
    {
    Class l_ClasObj = Class.forName("com.quantumdataengines.app.listScanning.dao.DataBaseInfoOracleDAO");
    Class l_CParamArry[] = new Class[1];
    l_CParamArry[0] = java.lang.String.class;
    Constructor l_Constructor = l_ClasObj.getConstructor(l_CParamArry);
    Object l_ObjParamArry[] = new Object[1];
    l_ObjParamArry[0] = a_strDBSource;
    return (DataBaseInfoDAO)l_Constructor.newInstance(l_ObjParamArry);
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoDAO->getInstance : "+e.toString());
    	System.out.println("Error In DataBaseInfoDAO->getInstance : "+e.toString());
    	e.printStackTrace();
    }
    return null;
    }
}