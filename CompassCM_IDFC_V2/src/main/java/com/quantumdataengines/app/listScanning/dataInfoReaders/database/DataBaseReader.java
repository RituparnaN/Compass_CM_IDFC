package com.quantumdataengines.app.listScanning.dataInfoReaders.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;

 public class DataBaseReader extends ListReader
 {
	private static final Logger log = LoggerFactory.getLogger(DataBaseReader.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
 
	public DataBaseReader(Connection objConnection, String strTableName) throws IllegalArgumentException
    {
    l_strDBTableName = null;
    resultSet = null;
    preparedStatement = null;
    connection = null;
    if(strTableName == null) {
        throw new IllegalArgumentException("DB Table name value not set, found as null");
    } else {
    	l_strDBTableName = strTableName;
    	 connection = objConnection;
    	//connection = connectionUtil.getConnection();
    	System.out.println("connectionUtil : "+connection);
        return;
    }
    }

    public String getSourceName()
    {
    return l_strDBTableName;
    }

    public boolean open() throws IOAccessError, SourceNotFoundError
    {
    if(connection == null)
        throw new SourceNotFoundError("DB connection not set, found as null");
    try
    {
    StringBuffer stringBufferQuery = new StringBuffer("Select * FROM ");
    stringBufferQuery.append(l_strDBTableName).append(" WHERE 1 = 1 ");
    Iterator iterator;
    String strFilterQueryString;
    for(iterator = l_hashMapDataFilters.keySet().iterator(); iterator.hasNext(); stringBufferQuery.append(" AND ").append(strFilterQueryString).append(" = ?"))
    	strFilterQueryString = (String)iterator.next();
    
    System.out.println(stringBufferQuery);
    
    preparedStatement = connection.prepareStatement(stringBufferQuery.toString());
    iterator = l_hashMapDataFilters.keySet().iterator();
    int intIndexValue = 1;
    for(; iterator.hasNext(); preparedStatement.setObject(intIndexValue++, l_hashMapDataFilters.get(strFilterQueryString)))
    	strFilterQueryString = (String)iterator.next();

    iterator = l_hashMapDataFilters.keySet().iterator();
    resultSet = preparedStatement.executeQuery();
    l_strArrayFieldNames = getFieldNames();
    }
    catch(Exception e)
    {
    	log.error("Error occured in open : "+e.getMessage());
        throw new IOAccessError((new StringBuilder("DB Exception ")).append(e).toString());
    }
    return true;
    }

    public long getTotalCount() throws IOAccessError, SourceNotFoundError
    {
    long longRecordCount = 0L;
    if(connection == null)
        throw new SourceNotFoundError("DB connection not set, found as null");
    try
    {
    StringBuffer stringBufferQuery = new StringBuffer("Select Count(*) Total FROM ");
    stringBufferQuery.append(l_strDBTableName).append(" WHERE 1 = 1 ");
    Iterator iterator;
    String strFilterQueryString;
    for(iterator = l_hashMapDataFilters.keySet().iterator(); iterator.hasNext(); stringBufferQuery.append(" AND ").append(strFilterQueryString).append(" = ?"))
    	strFilterQueryString = (String)iterator.next();

    preparedStatement = connection.prepareStatement(stringBufferQuery.toString());
    iterator = l_hashMapDataFilters.keySet().iterator();
    int intIndexValue = 1;
    //String strFilterQueryString;
    for(; iterator.hasNext(); preparedStatement.setObject(intIndexValue++, l_hashMapDataFilters.get(strFilterQueryString)))
    	strFilterQueryString = (String)iterator.next();

    resultSet = preparedStatement.executeQuery();
    if(resultSet.next())
    	longRecordCount = resultSet.getLong("Total");
    }
    catch(Exception e)
    {
    	log.error("DB Exception "+e.getMessage());
    throw new IOAccessError((new StringBuilder("DB Exception ")).append(e).toString());
    }
    try
    {
    if(preparedStatement != null)
    	preparedStatement.close();
    if(resultSet != null)
    	resultSet.close();
    }
    catch(Exception e)
    {
    	log.error("Error occured : "+e.getMessage());
    e.printStackTrace();
    }
    try
    {
    if(preparedStatement != null)
    	preparedStatement.close();
    if(resultSet != null)
    	resultSet.close();
    }
    catch(Exception e)
    {
    	log.error("Error in DataBaseReader->getTotalCount:  "+e.toString());
    System.out.println("Error in DataBaseReader->getTotalCount:  "+e.toString());
	e.printStackTrace();
    }
    return longRecordCount;
    }

    public boolean opendb(long longStart, long longEnd)
    {
    if(connection == null)
        System.out.println("Data base connection not set, found as null");
    boolean boolStausFlag = true;
    try
    {
    StringBuffer stringBufferQuery = new StringBuffer("Select B.* from ( Select RowNum As SerialNumber , A.* FROM ");
    stringBufferQuery.append(l_strDBTableName).append(" A ) B WHERE 1 = 1 ");
    stringBufferQuery.append(" AND SerialNumber > ").append((new StringBuilder(String.valueOf(longStart))).append(" ").toString());
    stringBufferQuery.append(" AND SerialNumber <= ").append((new StringBuilder(String.valueOf(longEnd))).append(" ").toString());
    Iterator iterator;
    String strFilterQueryString;
    for(iterator = l_hashMapDataFilters.keySet().iterator(); iterator.hasNext(); stringBufferQuery.append(" AND ").append(strFilterQueryString).append(" = ?"))
    	strFilterQueryString = (String)iterator.next();

    preparedStatement = connection.prepareStatement(stringBufferQuery.toString());
    iterator = l_hashMapDataFilters.keySet().iterator();
    int intIndexValue = 1;
    //String strFilterQueryString;
    for(; iterator.hasNext(); preparedStatement.setObject(intIndexValue++, l_hashMapDataFilters.get(strFilterQueryString)))
    	strFilterQueryString = (String)iterator.next();

    iterator = l_hashMapDataFilters.keySet().iterator();
    resultSet = preparedStatement.executeQuery();
    l_strArrayFieldNames = getFieldNames();
    }
    catch(Exception e)
    {
    	log.error("Error in DataBaseReader->opendb:  "+e.toString());
    System.out.println("Error in DataBaseReader->opendb:  "+e.toString());
    e.printStackTrace();
    boolStausFlag = false;
    }
    return boolStausFlag;
    }

    public boolean next() throws IOAccessError
    {
    label0:
    {
    try
    {
    if(!resultSet.next())
        break label0;
    l_hashMapldValueCache = new HashMap();
    for(int i = 0; i < l_strArrayFieldNames.length; i++)
    {
    String l_strValue = resultSet.getString(l_strArrayFieldNames[i]);
    l_hashMapldValueCache.put(l_strArrayFieldNames[i], l_strValue == null ? "" : ((Object) (l_strValue)));
    }
    }
    catch(SQLException e)
    {
    	log.error("Error in DataBaseReader->next : "+e.toString());
	System.out.println("Error in DataBaseReader->next : "+e.toString());
	throw new IOAccessError(e);
    }
    return true;
    }
    return false;
    }

    public String[] getFieldNames() throws IOAccessError
    {
	String strFieldNamesArray[];
    try{
    ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
    strFieldNamesArray = new String[resultSetMetaData.getColumnCount()];
    for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++)
    	strFieldNamesArray[i - 1] = resultSetMetaData.getColumnName(i);
	}
    catch(Exception e)
    {
    	log.error("Error in DataBaseReader->getFieldNames : "+e.toString());
    	System.out.println("Error in DataBaseReader->getFieldNames : "+e.toString());
    	throw new IOAccessError(e);
    }
    return strFieldNamesArray;
    }

    public void close()
    {
    try
    {
    if(preparedStatement != null)
    	preparedStatement.close();
    if(resultSet != null)
    	resultSet.close();
    }
    catch(Exception exception) 
    { 
    	log.error("Error in DataBaseReader->close  Statementa and ResultSet: "+exception.toString());
    	System.out.println("Error in DataBaseReader->close  Statementa and ResultSet: "+exception.toString());
    	exception.printStackTrace();
    }
    try
    {
    if(connection != null)
    	connection.close();
    }
    catch(Exception exception1) { 
    	log.error("Error in DataBaseReader->close  Statementa and ResultSet: "+exception1.toString());
	System.out.println("Error in DataBaseReader->close  Statementa and ResultSet: "+exception1.toString());
	exception1.printStackTrace();
    }
    }

    private String l_strDBTableName;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;
    private Connection connection;
}