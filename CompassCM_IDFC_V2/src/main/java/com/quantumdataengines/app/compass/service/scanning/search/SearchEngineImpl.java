package com.quantumdataengines.app.compass.service.scanning.search;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.dao.scanning.RTScanningDAO;
import com.quantumdataengines.app.compass.model.scanning.SearchListVO;
import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;
import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;
import com.quantumdataengines.app.listScanning.dao.DatabaseConnectionFactory;
import com.quantumdataengines.app.listScanning.dataInfoReaders.database.DataBaseReader;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;

public class SearchEngineImpl {
	private static final Logger log = LoggerFactory.getLogger(SearchEngineImpl.class);
	
	private static final String l_strUniqueKeyValue = "UniqueKey";
	public static final int l_intDB_SOURCE   = 1;
	public static final int l_intFILE_SOURCE = 2;
	private String l_strSourceType = null;
	private int l_intImportTypeId  = -99999;
	private RTScanningDAO l_objRTScanningDAO = null;
	private ListSearcher[] l_objSearcherArray = null;
	private String l_stringFileName = "";
	private String l_strUserCodeValue = "";
	private String l_strBlackListId = "";
	private String l_strTemplateId = "";
	
	public SearchEngineImpl(){}
	
	public SearchEngineImpl(RTScanningDAO a_CRTScanningDAO,String usercode){
	l_objRTScanningDAO = a_CRTScanningDAO;
	l_strUserCodeValue = usercode;
	}
	
	public SearchEngineImpl(int a_intImportId, String a_strSourceName ){
	l_strSourceType   = a_strSourceName;
	l_intImportTypeId = a_intImportId;
	}
	
	public SearchEngineImpl(String a_strSourceName ,int a_intImportId,int a_intSourceType,RTScanningDAO a_CRTScanningDAO,String a_FileName, String usercode,String a_blacklistid){
	l_strSourceType   = a_strSourceName;
	l_intImportTypeId = a_intImportId;
	l_objRTScanningDAO = a_CRTScanningDAO;
	l_stringFileName = a_FileName;
	l_strUserCodeValue = usercode;
	l_strBlackListId = a_blacklistid;
	}
	
    private IndexFieldVO[] getIndexFieldArray(Vector tempVector){
	IndexFieldVO[] objIndexFieldArray = new IndexFieldVO[tempVector.size()];
	for(int i=0;i < tempVector.size();i++){
		objIndexFieldArray[i] = (IndexFieldVO)tempVector.get(i);
	}  
	return objIndexFieldArray;
	}
	
    public void initializeListSearch(int intImportTypeId,String strTemplateId,String strIsFileImportFlag, HashMap hashMapSearchData) throws FileNotFoundError{
	l_intImportTypeId = intImportTypeId;
	l_strTemplateId = strTemplateId;
	// System.out.println("l_intImportTypeId  inQdesearch initializeSearch:  "+l_intImportTypeId);
	if(l_intImportTypeId != -1)
	{
	Collection collectionSearchList = l_objRTScanningDAO.getSelectedSearchSettings(l_intImportTypeId,hashMapSearchData);
	l_objSearcherArray = new ListSearcher[collectionSearchList.size()];
	Iterator iterator = collectionSearchList.iterator();
	int intCount = 0;
	while(iterator.hasNext()){
	SearchListVO objSearchListVO = (SearchListVO)iterator.next();
	String strSelectedListCode = objSearchListVO.getListCode();
	Collection     objMappingFieldList = l_objRTScanningDAO.getSelectedFieldMappingInfo(l_intImportTypeId,strSelectedListCode,l_strUserCodeValue,strTemplateId,strIsFileImportFlag);
	HashMap        hashMapIndexedFieldInfo = l_objRTScanningDAO.getSelectedIndexingInfo(strSelectedListCode);			
	l_objSearcherArray[intCount++] = new ListSearcher(objSearchListVO,objMappingFieldList,hashMapIndexedFieldInfo);
	}
	}
    }

	public void initializeListSearch(int intImportTypeId,String strTemplateId,String strIsFileImportFlag) throws FileNotFoundError{
	l_intImportTypeId = intImportTypeId;
	l_strTemplateId = strTemplateId;
	//System.out.println("l_intImportTypeId  inQdesearch initializeSearch:  "+l_intImportTypeId);
	if(l_intImportTypeId != -1)
	{
	Collection colSearchSettings = l_objRTScanningDAO.getSelectedSearchSettings(l_intImportTypeId);
	l_objSearcherArray = new ListSearcher[colSearchSettings.size()];
	Iterator iterator = colSearchSettings.iterator();
	int intCount = 0;
	while(iterator.hasNext()){
	SearchListVO objSearchListVO = (SearchListVO)iterator.next();
	String strSelectedListCode = objSearchListVO.getListCode();
	Collection     objMappingFieldList = l_objRTScanningDAO.getSelectedFieldMappingInfo(l_intImportTypeId,strSelectedListCode,l_strUserCodeValue,strTemplateId,strIsFileImportFlag);
	HashMap        hashMapIndexedFieldInfo = l_objRTScanningDAO.getSelectedIndexingInfo(strSelectedListCode);			
	l_objSearcherArray[intCount++] = new ListSearcher(objSearchListVO,objMappingFieldList,hashMapIndexedFieldInfo);
	}
	}
    }

	public LinkedHashMap listSearch(HashMap hashMapSearchData) throws IOAccessError {
	Vector vectorScanReport = new Vector();
	LinkedHashMap linkedHashMap = null;
	String strTimeInMillis= System.currentTimeMillis()+"";
	String strRandomNumber = (Math.random()+"").substring(2,9);
	String strAssignedFileName = strTimeInMillis + strRandomNumber;
	try{		
	for(int i=0;i<l_objSearcherArray.length;i++ ){
		Vector objresultVector = l_objSearcherArray[i].listSearch(hashMapSearchData);
		// System.out.println(" Size of l_ResVector is:  "+objresultVector.size());
		String strUniqueColumnId = hashMapSearchData.get("SNO")==null?"":hashMapSearchData.get("SNO").toString().trim(); 
		if(objresultVector != null && objresultVector.size() >0  ){
		l_objRTScanningDAO.saveRealtimeSearchResults(objresultVector,l_intImportTypeId,strUniqueColumnId,strAssignedFileName,"N",l_strUserCodeValue,"",l_strTemplateId); 
		vectorScanReport.addAll(objresultVector);
		}
	}
	linkedHashMap = (LinkedHashMap)l_objRTScanningDAO.getSavedFileMatches(strAssignedFileName+"|","N",0);
	linkedHashMap.put("FileName",strAssignedFileName);
	//Govind/Temprarily
	//l_Map = new LinkedHashMap<String, String>();
	//l_Map.put("FileName",strAssignedFileName);
	//Govind/Temprarily/ Till Here
	}	
	//catch(org.apache.lucene.queryParser.ParseException pe){
	catch(org.apache.lucene.queryparser.classic.ParseException pe){
		log.error("Error occured : "+pe.getMessage());
		pe.printStackTrace();
	}
	catch(IOException pe){
		log.error("Error occured : "+pe.getMessage());
		pe.printStackTrace();
	}
	catch(Exception pe)
	{
		log.error("Error occured : "+pe.getMessage());
		pe.printStackTrace();
	}
	finally
	{
		return linkedHashMap;
	}
	}
	
	public void listSearch() throws IOAccessError {
	boolean boolResultFlag = false;
	try{
	ListReader objListReader =  getListReader();
	objListReader.open();
	while(objListReader.next()){
	HashMap hashMapFieldValue = objListReader.getListFieldValues();
	if(hashMapFieldValue.get("SNO")==null)
		hashMapFieldValue.put("SNO",System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9));
	String strAssignedUniqueId = hashMapFieldValue.get("SNO").toString().trim();
	strAssignedUniqueId = hashMapFieldValue.get("SERIALNO").toString().trim();
	for(int i=0;i<l_objSearcherArray.length;i++ ){
	Vector objResultVector = l_objSearcherArray[i].listSearch(hashMapFieldValue);
	if(objResultVector != null && objResultVector.size() >0  ){
		boolResultFlag = true;
		l_objRTScanningDAO.saveRealtimeSearchResults(objResultVector,l_intImportTypeId,strAssignedUniqueId,l_stringFileName==null?"":l_stringFileName.substring(0,l_stringFileName.indexOf(".")),"Y",l_strUserCodeValue,l_strBlackListId,l_strTemplateId);
	}
	}
	}
	}
	catch(SQLException sqlexp){
		log.error("Error occured : "+sqlexp.getMessage());
		sqlexp.printStackTrace();
	}
	catch(SourceNotFoundError snfe){
		log.error("Error occured : "+snfe.getMessage());
		snfe.printStackTrace();
	}
	catch(org.apache.lucene.queryparser.classic.ParseException pe){
		log.error("Error occured : "+pe.getMessage());
	pe.printStackTrace();
	}
	catch(IOException ioex){
		log.error("Error occured : "+ioex.getMessage());
		ioex.printStackTrace();
	}
	catch(Exception e){
		log.error("Error occured : "+e.getMessage());
		e.printStackTrace();
	}
	}
	
	public void listSearch(Connection connection) throws IOAccessError {
		boolean boolResultFlag = false;
		try{
		ListReader objListReader =  getListReader(connection);
		objListReader.open();
		while(objListReader.next()){
		HashMap hashMapFieldValue = objListReader.getListFieldValues();
		if(hashMapFieldValue.get("SNO")==null)
			hashMapFieldValue.put("SNO",System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9));
		String strAssignedUniqueId = hashMapFieldValue.get("SNO").toString().trim();
		strAssignedUniqueId = hashMapFieldValue.get("SERIALNO").toString().trim();
		for(int i=0;i<l_objSearcherArray.length;i++ ){
		Vector objResultVector = l_objSearcherArray[i].listSearch(hashMapFieldValue);
		if(objResultVector != null && objResultVector.size() >0  ){
			boolResultFlag = true;
			l_objRTScanningDAO.saveRealtimeSearchResults(objResultVector,l_intImportTypeId,strAssignedUniqueId,l_stringFileName==null?"":l_stringFileName.substring(0,l_stringFileName.indexOf(".")),"Y",l_strUserCodeValue,l_strBlackListId,l_strTemplateId);
		}
		}
		}
		}
		catch(SQLException sqlexp){
			log.error("Error occured : "+sqlexp.getMessage());
			sqlexp.printStackTrace();
		}
		catch(SourceNotFoundError snfe){
			log.error("Error occured : "+snfe.getMessage());
			snfe.printStackTrace();
		}
		catch(org.apache.lucene.queryparser.classic.ParseException pe){
			log.error("Error occured : "+pe.getMessage());
		pe.printStackTrace();
		}
		catch(IOException ioex){
			log.error("Error occured : "+ioex.getMessage());
			ioex.printStackTrace();
		}
		catch(Exception e){
			log.error("Error occured : "+e.getMessage());
			e.printStackTrace();
		}
		}

	protected ListReader getListReader() throws SQLException {
	ListReader objListReader = null;
	Connection connection = null;
	try{
		//Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
		//l_Connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "COMPAML","ORACLE");
		//connection = DatabaseConnectionFactory.getConnection("COMPAML");
		//connection = DatabaseConnectionFactory.getConnection();
		objListReader = new DataBaseReader(connection,l_strSourceType); 
	}
	catch(Exception e){
		log.error("Error occure din : "+e.getMessage());
		e.printStackTrace(); 
	}
	HashMap hashMapIndexingInfo =  l_objRTScanningDAO.getSelectedIndexingInfo(l_intImportTypeId);
	Iterator iterator = hashMapIndexingInfo.keySet().iterator();
	while(iterator.hasNext()){
	String strKeyTypeValue = (String)iterator.next();
	IndexFieldVO[] objIndexFieldVOArray = getIndexFieldArray((Vector)hashMapIndexingInfo.get(strKeyTypeValue));
	if(strKeyTypeValue.equals(l_strUniqueKeyValue)){
		objListReader.setListUniqueIdField(objIndexFieldVOArray[0]);
	}
	}
	return objListReader;
	}
	
	protected ListReader getListReader(Connection connection) throws SQLException {
		ListReader objListReader = null;
		try{
			//Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
			//l_Connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "COMPAML","ORACLE");
			//connection = DatabaseConnectionFactory.getConnection("COMPAML");
			//connection = DatabaseConnectionFactory.getConnection();
			objListReader = new DataBaseReader(connection,l_strSourceType); 
		}
		catch(Exception e){
			log.error("Error occure din : "+e.getMessage());
			e.printStackTrace(); 
		}
		HashMap hashMapIndexingInfo =  l_objRTScanningDAO.getSelectedIndexingInfo(l_intImportTypeId);
		Iterator iterator = hashMapIndexingInfo.keySet().iterator();
		while(iterator.hasNext()){
		String strKeyTypeValue = (String)iterator.next();
		IndexFieldVO[] objIndexFieldVOArray = getIndexFieldArray((Vector)hashMapIndexingInfo.get(strKeyTypeValue));
		if(strKeyTypeValue.equals(l_strUniqueKeyValue)){
			objListReader.setListUniqueIdField(objIndexFieldVOArray[0]);
		}
		}
		return objListReader;
		}
}
