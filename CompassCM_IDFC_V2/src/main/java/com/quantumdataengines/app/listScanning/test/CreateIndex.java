package com.quantumdataengines.app.listScanning.test;

import java.sql.Connection;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.listScanning.dao.DataBaseInfoDAO;
import com.quantumdataengines.app.listScanning.dao.DatabaseConnectionFactory;
import com.quantumdataengines.app.listScanning.dataInfoReaders.database.DataBaseReader;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;
import com.quantumdataengines.app.listScanning.listIndexing.GenerateIndexes;
// import com.quantumdataengines.utilities.ApplicationProperties;

public class CreateIndex {

	private static final Logger log = LoggerFactory.getLogger(CreateIndex.class);
    public static final int l_intDB_SOURCE = 1;
    public static final int l_intFILE_SOURCE = 2;
    private String l_strSourceName;
    private int l_intImportFileId;
    private DataBaseInfoDAO l_objDataBaseInfoDAO;
    private GenerateIndexes l_objGenerateIndexes;
    
    public CreateIndex(String strSourceFileName, int intImportFileId, String strDBSourceName)
    {
    l_objGenerateIndexes = null;
    l_strSourceName = strSourceFileName;
    l_intImportFileId = intImportFileId;
    l_objDataBaseInfoDAO = DataBaseInfoDAO.getInstance(strDBSourceName);
    try
    {
        l_objGenerateIndexes = (GenerateIndexes)Class.forName("com.quantumdataengines.app.listScanning.listIndexing.GenerateIndexesImpl").newInstance();
    }
    catch(Exception e)
    {
    	log.error("Error occured : "+e.getMessage());
        e.printStackTrace();
    }
    }

	private ListReader getListReader() throws Exception
	{
	ListReader listReader = null;
	Connection connection = null;
	try
	{
	    connection = getConnection("COMPAML");
	    listReader = new DataBaseReader(connection, l_strSourceName);
	}
	catch(Exception e)
	{
		log.error("Error occured : "+e.getMessage());
	    throw e;
	}
	return listReader;
	}

	private Connection getConnection(String strDBSourceName)
    {
    return DatabaseConnectionFactory.getConnection(strDBSourceName);
    }

	public void generateIndexes() throws Exception
	{
	ListReader listReader = getListReader();
	HashMap hmIndexingInfo = l_objDataBaseInfoDAO.getIndexingInfo(l_intImportFileId);
	for(Iterator iterator = hmIndexingInfo.keySet().iterator(); iterator.hasNext();)
	{
    String strFieldType = (String)iterator.next();
    IndexFieldVO objIndexFieldArray[] = getListIndexFieldArray((Vector)hmIndexingInfo.get(strFieldType));
    if(strFieldType.equals("UniqueKey"))
    	listReader.setListUniqueIdField(objIndexFieldArray[0]);
    else
    	listReader.setListFields(strFieldType, objIndexFieldArray);
	}
	try
	{
	/* 21st Oct 2016 */
	// String strListIndexDirectoryPath = ApplicationProperties.getInstance().getProperty("ListIndexDirectoryPath").trim();
    // String strIndexPath = (new StringBuilder("D:\\IndexFolder\\")).append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString();
		String indexFolder = CommonUtil.loadProperties().getProperty("compass.aml.paths.indexFolder");
		String strIndexPath = (new StringBuilder(indexFolder)).append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString();		
	// String strIndexPath = (new StringBuilder(strListIndexDirectoryPath)).append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString();
	/* 21st Oct 2016 */
    //l_objGenerateIndexes.createSeperatePathIndexes(l_CListReader, (new StringBuilder("/")).append(l_strClientID).append("/").append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString(),strIndexPath,null);
    l_objGenerateIndexes.createIndexingWithFolder(listReader, (new StringBuilder("")).append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString(),strIndexPath,null);
    //l_objGenerateIndexes.createIndexes(l_CListReader, (new StringBuilder(strIndexPath)).append("/").append(l_objDataBaseInfoDAO.getListCode(l_intImportFileId)).toString());
	}
	catch(Exception e)
	{
		log.error("Error occured : "+e.getMessage());
    e.printStackTrace();
    throw e;
	}
	}

	private IndexFieldVO[] getListIndexFieldArray(Vector tempVector)
	{
    IndexFieldVO objIndexFieldArray[] = new IndexFieldVO[tempVector.size()];
    for(int i = 0; i < tempVector.size(); i++)
    	objIndexFieldArray[i] = (IndexFieldVO)tempVector.get(i);
    return objIndexFieldArray;
	}
	
	public static void main(String[] args)
	{
	//String l_strDest = "Tb_OnlineScanningData";	
	//CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 199, 1, "COMPAML");
	//String l_strDest = "Tb_CustomerMaster";
	//CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 6, 1, "COMPAML");
	//String l_strDest = "tb_EmployeeMaster";
	//CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 7, 1, "COMPAML");
	//String l_strDest = "TB_OFACSDNLIST";
	//CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 121, 1, "COMPAML");
	//String l_strDest = "TB_UNSANCTIONLIST";
	//CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 122, "COMPAML");
	String l_strDest = "TB_OFACSDNLIST";
	CreateIndex l_Indexer = new CreateIndex((new StringBuilder()).append(l_strDest).toString(), 121, "COMPAML");
	try{
    Calendar l_cal = Calendar.getInstance();
    long l_start = l_cal.getTimeInMillis();
   	l_Indexer.generateIndexes();
   	System.out.println((new StringBuilder("Total Time Taken for indexing in millisecs:")).append(Calendar.getInstance().getTimeInMillis() - l_start).toString());
    } catch(Exception e)
    {
    	log.error("Error occured : "+e.getMessage());
	System.out.println("Exception in main  "+e.toString());
	e.printStackTrace();
    }
	}
}
