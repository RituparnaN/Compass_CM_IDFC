package com.quantumdataengines.app.listScanning.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.listSearch.ScreeningResultVO;
import com.quantumdataengines.app.listScanning.model.FieldMappingVO;
import com.quantumdataengines.app.listScanning.model.ListVO;

@Repository
public class DataBaseInfoOracleDAO extends DataBaseInfoDAO
{
	private static final Logger log = LoggerFactory.getLogger(DataBaseInfoOracleDAO.class);
	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
    public DataBaseInfoOracleDAO(String strDBSourceName)
    {
        l_strDBSourceName = null;
        l_strDBSourceName = strDBSourceName;
    }

    public HashMap getIndexingInfo(int intReportFileID)
    {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    HashMap hashMapIndexInfo = new HashMap();;
    try
    {
	//connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
   	connection = connectionUtil.getConnection();	
    preparedStatement = connection.prepareStatement(" SELECT FieldName,Type AS FieldType,DataFields,IsRepeated,Delimiter FROM  "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO A ,"+schemaName+"TB_EXCEPTIONLISTMASTER B  WHERE B.FILEIMPORTID = TRIM(?) AND TRIM(UPPER(B.ListCode)) = TRIM(UPPER(A.ListCode)) ");
    preparedStatement.setInt(1, intReportFileID);
    resultSet = preparedStatement.executeQuery();
    Vector objVectorTemp = new Vector();
    IndexFieldVO objIndexFieldVO;
    for(; resultSet.next(); objVectorTemp.add(objIndexFieldVO))
    {
    String strFieldType = resultSet.getString("FieldType");
    String strFieldName = resultSet.getString("FieldName");
    String strDataFields = resultSet.getString("DataFields");
    StringTokenizer stringTokenizer = new StringTokenizer(strDataFields, ",");
    String strDataFieldArray[] = new String[stringTokenizer.countTokens()];
    int intIndexValue = 0;
    while(stringTokenizer.hasMoreTokens()) 
    	strDataFieldArray[intIndexValue++] = stringTokenizer.nextToken();
    if(!hashMapIndexInfo.containsKey(strFieldType))
    {
    objVectorTemp = new Vector();
    hashMapIndexInfo.put(strFieldType, objVectorTemp);
    } else
    {
    objVectorTemp = (Vector)hashMapIndexInfo.get(strFieldType);
    }
    objIndexFieldVO = new IndexFieldVO();
    objIndexFieldVO.setDataFields(strDataFieldArray);
    objIndexFieldVO.setFieldName(strFieldName);
    objIndexFieldVO.setIsRepeated(resultSet.getInt("IsRepeated") == 1);
    objIndexFieldVO.setDelimiter(resultSet.getString("Delimiter"));
    }
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoOracleDAO->getIndexingInfo(int reportId) : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->getIndexingInfo(int reportId) : "+e.toString());
    e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, preparedStatement, resultSet);
    connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    }
    return hashMapIndexInfo;
    }

    public HashMap getIndexingInfo(String strListTypeCode)
    {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    HashMap hashMapIndexInfo = null;
    try
    {
	//connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
   	connection = connectionUtil.getConnection();	
    preparedStatement = connection.prepareStatement(" SELECT FieldName,Type AS FieldType,DataFields,IsRepeated,Delimiter FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO A WHERE A.ListCode = ? ");
    preparedStatement.setString(1, strListTypeCode);
    resultSet = preparedStatement.executeQuery();
    hashMapIndexInfo = new HashMap();
    IndexFieldVO objIndexFieldVO;
    for(; resultSet.next(); hashMapIndexInfo.put(objIndexFieldVO.getFieldName(), objIndexFieldVO))
    {
    String strFieldName = resultSet.getString("FieldName");
    String strDataFields = resultSet.getString("DataFields");
    StringTokenizer stringTokenizer = new StringTokenizer(strDataFields, ",");
    String strDataFieldArray[] = new String[stringTokenizer.countTokens()];
    int intIndexValue = 0;
    while(stringTokenizer.hasMoreTokens()) 
    	strDataFieldArray[intIndexValue++] = stringTokenizer.nextToken();
    objIndexFieldVO = new IndexFieldVO();
    objIndexFieldVO.setDataFields(strDataFieldArray);
    objIndexFieldVO.setFieldName(strFieldName);
    objIndexFieldVO.setIsRepeated(resultSet.getInt("IsRepeated") == 1);
    objIndexFieldVO.setDelimiter(resultSet.getString("Delimiter"));
    }
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoOracleDAO->getIndexingInfo(String listCode) : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->getIndexingInfo(String listCode) : "+e.toString());
	e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, preparedStatement, resultSet);
    connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    }
    return hashMapIndexInfo;
    }

    public String getListCode(int intReportFileID)
    {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    String strListCode = null;
    try
    {
	// connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
	connection = connectionUtil.getConnection();	
    preparedStatement = connection.prepareStatement("SELECT ListCode FROM "+schemaName+"TB_EXCEPTIONLISTMASTER WHERE TRIM(FILEIMPORTID) = TRIM(?)");
    preparedStatement.setInt(1, intReportFileID);
    for(resultSet = preparedStatement.executeQuery(); resultSet.next();)
        strListCode = resultSet.getString("ListCode");
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoOracleDAO->getIndexingInfo(int ReportID) : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->getIndexingInfo(int ReportID) : "+e.toString());
    e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, preparedStatement, resultSet);
    connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    }
    return strListCode;
    }

    public Collection getSearchSettings(int intReportFileID)
    {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    ArrayList arrayListSearch = new ArrayList();
    try
    {
	//System.out.println("intReportFileID   "+intReportFileID);
	//connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
    connection = connectionUtil.getConnection();	
    preparedStatement = connection.prepareStatement(" SELECT SearchListCode,SearchLevel FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING A, "+schemaName+"TB_EXCEPTIONLISTMASTER B WHERE A.SourceListCode = B.ListCode AND B.FILEIMPORTID = ?  AND ISEnable = 1 ");
    preparedStatement.setInt(1, intReportFileID);
    resultSet = preparedStatement.executeQuery();
    ListVO objListVO;
    for(; resultSet.next(); arrayListSearch.add(objListVO))
    {
	objListVO = new ListVO();
	objListVO.setListCode(resultSet.getString("SearchListCode"));
	objListVO.setSearchLevel(resultSet.getString("SearchLevel"));
    }
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoOracleDAO->getSearchString : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->getSearchString : "+e.toString());
    e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, preparedStatement, resultSet);
    connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    }
    return arrayListSearch;
    }
    
    public Collection getFieldMappingInfo(int intReportFileID, String strListTypeCode)
    {
    Connection connection = null;
    CallableStatement callableStatement = null;
    ResultSet resultSet = null;
    ArrayList arrayListMappingField = new ArrayList();
    try
    {
	//System.out.println("l_strDBSourceName hereeeeeeeeeeeeeee  "+l_strDBSourceName+"  :  "+intReportFileID+"  :  "+strListTypeCode);
	//connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
    connection = connectionUtil.getConnection();	
    //System.out.println("connection:   "+connection);
	callableStatement = connection.prepareCall("{call "+schemaName+"STP_FETCHSEARCHMAPPINGFIELDS(?,?,?,?,?,?)}");
    //System.out.println("callableStatement:   "+callableStatement);
	callableStatement.setInt(1, intReportFileID);
	callableStatement.setString(2, strListTypeCode);
	callableStatement.setString(3, strListTypeCode);
	callableStatement.setString(4, strListTypeCode);
	callableStatement.setString(5, strListTypeCode);
	callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
	callableStatement.execute();
	resultSet = (ResultSet)callableStatement.getObject(6);
    FieldMappingVO objFieldMappingVO;
    for(; resultSet.next(); arrayListMappingField.add(objFieldMappingVO))
    {
	objFieldMappingVO = new FieldMappingVO();
	objFieldMappingVO.setFieldType(resultSet.getString("FieldType"));
	objFieldMappingVO.setFieldCategory(resultSet.getString("FieldCategory"));
	objFieldMappingVO.setMatchField(resultSet.getString("SearchField"));
	objFieldMappingVO.setScoreLimit(resultSet.getInt("Score"));
	objFieldMappingVO.setSourceField(resultSet.getString("SourceField"));
    String strDataFields = resultSet.getString("DataFields");
    StringTokenizer stringTokenizer = new StringTokenizer(strDataFields, ",");
    String strDataFieldArray[] = new String[stringTokenizer.countTokens()];
    int intIndexValue = 0;
    while(stringTokenizer.hasMoreTokens()) 
    	strDataFieldArray[intIndexValue++] = stringTokenizer.nextToken();
    objFieldMappingVO.setDataFields(strDataFieldArray);
    objFieldMappingVO.setIsRepeated(resultSet.getInt("isRepeated") == 1);
    objFieldMappingVO.setDelimiter(resultSet.getString("Delimiter"));
    }
    }
    catch(Exception e)
    {
    	log.error("Exception in persistlistmatches_nms call   "+e.toString());
	System.out.println("Exception in persistlistmatches_nms call   "+e.toString());
	e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, callableStatement, resultSet);
    connectionUtil.closeResources(connection, callableStatement, resultSet, null);
    }
    return arrayListMappingField;
    }
    
    public void saveSearchResults(Collection collectionResults, int intImportFileId, String strUniqueIdValue)
    {
    Connection connection = null;
    CallableStatement callableStatement = null;
    try
    {
	// connection = DatabaseConnectionFactory.getConnection(l_strDBSourceName);
    connection = connectionUtil.getConnection();	
	callableStatement = connection.prepareCall("{call "+schemaName+"SCREENEDRESULTMATCHES(?,?,?,?,?,?,?,?)} ");
    for(Iterator iterator = collectionResults.iterator(); iterator.hasNext(); callableStatement.addBatch())
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)iterator.next();
	callableStatement.setInt(1, intImportFileId);
	callableStatement.setString(2, strUniqueIdValue);
	callableStatement.setString(3, objScreeningResultVO.getSourceField());
	callableStatement.setString(4, objScreeningResultVO.getListName());
	callableStatement.setString(5, objScreeningResultVO.getId());
	callableStatement.setString(6, objScreeningResultVO.getMatchField());
	callableStatement.setString(7, objScreeningResultVO.getMatchData());
	callableStatement.setInt(8, objScreeningResultVO.getScore());
    }
    callableStatement.executeBatch();
    }
    catch(Exception e)
    {
    	log.error("Error In DataBaseInfoOracleDAO->saveSearchResults : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->saveSearchResults : "+e.toString());
    e.printStackTrace();
    }
    finally
    {
    // closeResources(connection, callableStatement, null);
    connectionUtil.closeResources(connection, callableStatement, null, null);
    }
    }
    
    public static void closeResources(Connection objConnection,Statement objStatement,ResultSet objResultSet){
	try{
	try {
	if(objStatement != null)
		objStatement.close();
	if(	objResultSet!=null)
		objResultSet.close();
	}
	catch(Exception e) {
		log.error("Error In DataBaseInfoOracleDAO->closeResources for statement and resultSet : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->closeResources for statement and resultSet : "+e.toString());
	e.printStackTrace();
	}
	if(objConnection!=null)
		objConnection.close();
	}
	catch(Exception e){
		log.error("Error In DataBaseInfoOracleDAO->closeResources for connection : "+e.toString());
    System.out.println("Error In DataBaseInfoOracleDAO->closeResources for connection : "+e.toString());
	e.printStackTrace();
	}
	}

    private String l_strDBSourceName;
 }