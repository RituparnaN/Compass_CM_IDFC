package com.quantumdataengines.app.listScanning.test;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

// import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.ParseException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;
import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;
import com.quantumdataengines.app.listScanning.dao.DataBaseInfoDAO;
import com.quantumdataengines.app.listScanning.dao.DatabaseConnectionFactory;
import com.quantumdataengines.app.listScanning.dataInfoReaders.database.DataBaseReader;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;
import com.quantumdataengines.app.listScanning.listSearch.ScreeningResultVO;
import com.quantumdataengines.app.listScanning.model.ListVO;

public class ListSearcherImpl
{
	private static final Logger log = LoggerFactory.getLogger(ListSearcherImpl.class);
	public ListSearcherImpl(int intImportId, String strDBSource)
	{
     l_strSourceString = null;
     l_intImportOrderId = 0xfffe7961;
     l_objDataBaseInfoDAO = null;
     l_objSearcherArray = null;
     l_strDBConnectionID = null;
     l_intImportOrderId = intImportId;
     l_objDataBaseInfoDAO = DataBaseInfoDAO.getInstance(strDBSource);
	}	
	public ListSearcherImpl(String a_strSourceName, int intImportId, String a_strDBSrc)
	{
     l_strSourceString = null;
     l_intImportOrderId = 0xfffe7961;
     l_objDataBaseInfoDAO = null;
     l_objSearcherArray = null;
     l_strDBConnectionID = null;
     l_strSourceString = a_strSourceName;
     l_intImportOrderId = intImportId;
     l_objDataBaseInfoDAO = DataBaseInfoDAO.getInstance(a_strDBSrc);
	}

	protected ListReader getListReader()
	{
     ListReader objListReader = null;
     Connection connection = null;
     try
     {
	 connection = DatabaseConnectionFactory.getConnection("COMPAML");
	 objListReader = new DataBaseReader(connection, l_strSourceString);
     }
     catch(IllegalArgumentException e)
     {
    	 log.error("Error occured :"+e.getMessage());
     e.printStackTrace();
     }
     HashMap hashMapIndexingInfo = l_objDataBaseInfoDAO.getIndexingInfo(l_intImportOrderId);
     for(Iterator iterator = hashMapIndexingInfo.keySet().iterator(); iterator.hasNext();)
     {
     String strTempType = (String)iterator.next();
     IndexFieldVO objIndexFieldVOArray[] = getListIndexFieldArray((Vector)hashMapIndexingInfo.get(strTempType));
     if(strTempType.equals("UniqueKey"))
    	 objListReader.setListUniqueIdField(objIndexFieldVOArray[0]);
     }
     return objListReader;
	}

	private IndexFieldVO[] getListIndexFieldArray(Vector vectorTempSet)
	{
     IndexFieldVO objIndexFieldVOArray[] = new IndexFieldVO[vectorTempSet.size()];
     for(int i = 0; i < vectorTempSet.size(); i++)
    	 objIndexFieldVOArray[i] = (IndexFieldVO)vectorTempSet.get(i);
     return objIndexFieldVOArray;
	}

	public void initializeListSearch() throws FileNotFoundError
	{
     Collection collectionSearchListColums = l_objDataBaseInfoDAO.getSearchSettings(l_intImportOrderId);
     l_objSearcherArray = new ListSearcher[collectionSearchListColums.size()];
     Iterator iterator = collectionSearchListColums.iterator();
     int intIndexValue = 0;
     while(iterator.hasNext()) 
     {
     ListVO objListVO = (ListVO)iterator.next();
     String strListCode = objListVO.getListCode();
     Collection collectionMappingFields = l_objDataBaseInfoDAO.getFieldMappingInfo(l_intImportOrderId, strListCode);
     HashMap hashMapIndexedField = l_objDataBaseInfoDAO.getIndexingInfo(strListCode);
     l_objSearcherArray[intIndexValue++] = new ListSearcher(objListVO, collectionMappingFields, hashMapIndexedField);
     }
	}

	public void listSearch() throws ParseException, IOAccessError, Exception
	{
     boolean boolResult = false;
     try
     {
     ListReader objListReader = getListReader();
     objListReader.open();
     while(objListReader.next()) 
     {
     HashMap hashMapFieldValue = objListReader.getListFieldValues();
     String strUniqueIdValue = objListReader.getListUniqueId();
     for(int i = 0; i < l_objSearcherArray.length; i++)
     {
     Vector vectorResultSet = l_objSearcherArray[i].listSearch(hashMapFieldValue);
     if(vectorResultSet != null && vectorResultSet.size() > 0)
     {
     Iterator iterator = vectorResultSet.iterator();
     //int intStartPosition = 0;
     //int counter = 0;
     Vector vectorToRemoveSet = new Vector();
     while(iterator.hasNext()) 
     {
	 ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)iterator.next();
     if(objScreeningResultVO.getId().equalsIgnoreCase(strUniqueIdValue.trim()))
    	 vectorToRemoveSet.add(objScreeningResultVO);
     }
     vectorResultSet.removeAll(vectorToRemoveSet);
     boolResult = true;
     l_objDataBaseInfoDAO.saveSearchResults(vectorResultSet, l_intImportOrderId, strUniqueIdValue.trim());
     }
     }
     }
     }
     catch(SourceNotFoundError ine)
     {
    	 log.error("Error occured :"+ine.getMessage());
     ine.printStackTrace();
     }
     catch(ParseException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     pe.printStackTrace();
     }
     catch(IOException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     pe.printStackTrace();
     }
	}

	public Vector getListMatches(HashMap hashMapFieldValue) throws ParseException, IOException, Exception
	{
     Vector vectorMatchSet = new Vector();
     try
     {
     for(int i = 0; i < l_objSearcherArray.length; i++)
     {
     Vector vectorResultSet = l_objSearcherArray[i].listSearch(hashMapFieldValue);
     if(vectorResultSet != null && vectorResultSet.size() > 0)
    	 vectorMatchSet.addAll(vectorResultSet);
     }
     }
     catch(ParseException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     throw pe;
     }
     catch(IOException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     throw pe;
     }
     catch(Exception e)
     {
    	 log.error("Error occured :"+e.getMessage());
     throw e;
     }
     return vectorMatchSet;
	}

	public Vector getListMatches(HashMap hashMapFieldValue, String strMessageType) throws ParseException, IOException, Exception
	{
     Vector vectorMatchSet = new Vector();
     try
     {
     for(int i = 0; i < l_objSearcherArray.length; i++)
     {
     l_objSearcherArray[i].l_strMessageType = new String(strMessageType);
     Vector vectorResultSet = l_objSearcherArray[i].listSearch(hashMapFieldValue);
     if(vectorResultSet != null && vectorResultSet.size() > 0)
    	 vectorMatchSet.addAll(vectorResultSet);
     }
     }
     catch(ParseException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     throw pe;
     }
     catch(IOException pe)
     {
    	 log.error("Error occured :"+pe.getMessage());
     throw pe;
     }
     return vectorMatchSet;
 }

	public static void main(String[] args)
	{
	String strDestinationTableName = "TB_CUSTOMERMASTER";	
    ListSearcherImpl l_ListSearcherImpl = null;
    try{
	System.out.println("Started  ");
	Calendar calendar = Calendar.getInstance();
    long l_start = calendar.getTimeInMillis();
	l_ListSearcherImpl = new ListSearcherImpl(strDestinationTableName, 6, "COMPAML");
	l_ListSearcherImpl.initializeListSearch();
	l_ListSearcherImpl.listSearch();
	System.out.println((new StringBuilder("Total Time Taken for searching in millisecs:")).append(calendar.getTimeInMillis() - l_start).toString());
    } catch(Exception e)
    {

    	System.out.println("Exception in main  "+e.toString());
    	e.printStackTrace();
    }
	}

	 public static final int l_intDB_SOURCE = 1;
	 public static final int l_intFILE_SOURCE = 2;
	 private String l_strSourceString;
	 private int l_intImportOrderId;
	 private DataBaseInfoDAO l_objDataBaseInfoDAO;
	 private ListSearcher l_objSearcherArray[];
	 public String l_strDBConnectionID;
}