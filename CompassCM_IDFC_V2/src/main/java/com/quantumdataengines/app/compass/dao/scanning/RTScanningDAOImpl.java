package com.quantumdataengines.app.compass.dao.scanning;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.scanning.MappedFieldVO;
import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.compass.model.scanning.RTMatchResultVO;
import com.quantumdataengines.app.compass.model.scanning.SearchListVO;
import com.quantumdataengines.app.compass.service.scanning.NameMatcher;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.listSearch.ScreeningResultVO;
import com.quantumdataengines.app.listScanning.model.FieldVO;
import com.quantumdataengines.app.listScanning.model.RecordVO;

@Repository
public class RTScanningDAOImpl implements RTScanningDAO {
    //Connection connection = null;
    //private NameMatcher nameMatcher= null;
	private String l_strResultStatusMessage = null;
	private static final Logger log = LoggerFactory.getLogger(RTScanningDAOImpl.class);
   
	@Autowired
	private DataSource dataSource;
	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			// connection = dataSource.getConnection();
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : INDSTRDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}

    public ArrayList<HashMap<String,String>> getRealtimeScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params)
    {
    	Connection connection = getConnection();
        String queryString = "";
        double finalPerMatch = 0.0;
        ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
        String targetName = "";
        ArrayList<HashMap<String,String>> alMatchResult = new ArrayList<HashMap<String,String>>();
        HashMap<String,String> hmMatchResult = null;
        try
        {
        	queryString = " SELECT ROWNUM AS ROWPOSITION, DOCSERIALNO, NAMEOFBANK, PARTY, ADDRESS, NAMEOFDIRS, "+
        	              "        PARTNERS, PROPRIETER, BALOUTSTANDING, BRANCHNAME, STATE "+
        	              "   FROM "+schemaName+"TB_RBIDEFAULTERSLIST ";

        	preparedStatement = connection.prepareStatement(queryString);
        	resultSet = preparedStatement.executeQuery();
        	String srcName = nameEnglish.toUpperCase().trim();
    		while(resultSet.next())
        	{	
        		targetName = resultSet.getString("NAMEOFBANK").toUpperCase().trim();
        		NameMatcher nmMtch = new NameMatcher();
        		hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
        		//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
        		//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				hmMatchResult.put("ListName", "RBIDEFAULTERSLIST");
				hmMatchResult.put("ListId", resultSet.getString("DOCSERIALNO"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);	
             }
        	resultSet = null;
        	queryString = " SELECT ROWNUM AS ROWPOSITION, UID_, NAME "+
            			  "   FROM "+schemaName+"TB_OFACSDNLIST ";

			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next())
			{	
				targetName = resultSet.getString("NAME").toUpperCase().trim();
				NameMatcher nmMtch = new NameMatcher();
				hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
				//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
				//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				hmMatchResult.put("ListName", "OFACSDNLIST");
				hmMatchResult.put("ListId", resultSet.getString("UID_"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);	
			}
			resultSet = null;
        	queryString = " SELECT ROWNUM AS ROWPOSITION, SERIALNO, NAME "+
            			  "   FROM "+schemaName+"TB_UNCONSOLIDATEDLIST ";

			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next())
			{	
				targetName = resultSet.getString("NAME").toUpperCase().trim();
				NameMatcher nmMtch = new NameMatcher();
				hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
				//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
				//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				hmMatchResult.put("ListName", "UNCONSOLIDATEDLIST");
				hmMatchResult.put("ListId", resultSet.getString("SERIALNO"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);	
			}

        }
        catch(Exception e)
        {
        	log.error("Error occured in getRealtimeScanningResults : "+e.getMessage());
            e.printStackTrace();
        }
        finally	{
        	closeResources(connection, preparedStatement, resultSet);        	
     	}
     	
        return alMatchResult;
    }
    
    public ArrayList<HashMap<String,String>> getRealtimeEntityScanning(String userCode, String entityName, String listName, String matchScore)
    {
    	Connection connection = getConnection();
        String queryString = "";
        double finalPerMatch = 0.0;
        ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
        String targetName = "";
        ArrayList<HashMap<String,String>> alMatchResult = new ArrayList<HashMap<String,String>>();
        HashMap<String,String> hmMatchResult = null;
        try
        {
        	/*
        	String srcName = entityName.toUpperCase().trim();
    		if(listName.equalsIgnoreCase("ALL") || listName.equalsIgnoreCase("RBIDEFAULTERSLIST"))
        	{
        	queryString = " SELECT ROWNUM AS ROWPOSITION, DOCSERIALNO, NAMEOFBANK, PARTY, ADDRESS, NAMEOFDIRS, "+
        	              "        PARTNERS, PROPRIETER, BALOUTSTANDING, BRANCHNAME, STATE "+
        	              "   FROM TB_RBIDEFAULTERSLIST ";

        	preparedStatement = connection.prepareStatement(queryString);
        	resultSet = preparedStatement.executeQuery();
        	while(resultSet.next())
        	{	
        		targetName = resultSet.getString("NAMEOFBANK").toUpperCase().trim();
        		NameMatcher nmMtch = new NameMatcher();
        		hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
        		//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
        		//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				if(finalPerMatch >= Double.parseDouble(matchScore))
				{
				hmMatchResult.put("ListName", "RBIDEFAULTERSLIST");
        		hmMatchResult.put("ListId", resultSet.getString("DOCSERIALNO"));
        		hmMatchResult.put("SourceName", srcName);
        		hmMatchResult.put("targetName", targetName);
        		hmMatchResult.put("matchScore", finalPerMatch+"");
        		alMatchResult.add(hmMatchResult);
				}
             }
        		
        	}
        	if(listName.equalsIgnoreCase("ALL") || listName.equalsIgnoreCase("OFACSDNLIST"))
        	{
        	resultSet = null;
        	queryString = " SELECT ROWNUM AS ROWPOSITION, UID_, NAME "+
            			  "   FROM TB_OFACSDNLIST ";

			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
            while(resultSet.next())
			{	
				targetName = resultSet.getString("NAME").toUpperCase().trim();
				NameMatcher nmMtch = new NameMatcher();
				hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
				//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
				//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				if(finalPerMatch >= Double.parseDouble(matchScore))
				{
				hmMatchResult.put("ListName", "OFACSDNLIST");
				hmMatchResult.put("ListId", resultSet.getString("UID_"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);
				}
			}
            }
        	if(listName.equalsIgnoreCase("ALL") || listName.equalsIgnoreCase("UNCONSOLIDATEDLIST"))
        	{
        	resultSet = null;
        	queryString = " SELECT ROWNUM AS ROWPOSITION, REFERENCE_NUMBER SERIALNO, FIRST_NAME||' '||SECOND_NAME NAME "+
            			  "   FROM TB_UNC ";

			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next())
			{	
				targetName = resultSet.getString("NAME").toUpperCase().trim();
				NameMatcher nmMtch = new NameMatcher();
				hmMatchResult = new HashMap<String,String>();
				finalPerMatch = nmMtch.matchNames(srcName,targetName);
				//finalPerMatch = nameMatcher.matchNames(nameEnglish.toUpperCase().trim(),targetName.toUpperCase().trim());
				//double finalPerMatch2 = nmMtch.CIPS(srcName,targetName);
				if(finalPerMatch >= Double.parseDouble(matchScore))
				{
				hmMatchResult.put("ListName", "UNCONSOLIDATEDLIST");
				hmMatchResult.put("ListId", resultSet.getString("SERIALNO"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);
				}
			}
			}
			*/
        //connection = DatabaseConnectionFactory.getConnection("COMPAML");	
           	
  		queryString = " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET A.MATCHEDINFO = UPPER(A.MATCHEDINFO) "+
		      " WHERE A.FILENAME = '"+userCode+"'  ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();

        queryString = " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.CUSTOMERID FROM "+schemaName+"TB_CUSTOMERMASTER B "+
	          " WHERE UPPER(A.MATCHEDINFO) = UPPER(B.CUSTOMERNAME)) "+
	          " WHERE A.FILENAME = '"+userCode+"'  "+
	          "   AND A.LISTNAME='OnLine' "+
	          "  AND UPPER(A.MATCHEDINFO) IN (SELECT B.CUSTOMERNAME FROM "+schemaName+"TB_CUSTOMERMASTER B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.CUSTOMERNAME)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		
		queryString = " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.SERIALNO FROM "+schemaName+"TB_UNCONSOLIDATEDLIST B "+
			 " WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) "+
		" WHERE A.FILENAME = '"+userCode+"' "+
		"  AND A.LISTNAME='UNCONSOLIDATEDLIST' "+
		"  AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAME) FROM "+schemaName+"TB_UNCONSOLIDATEDLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		queryString = " UPDATE "+schemaName+"TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.DOCSERIALNO FROM TB_RBIDEFAULTERSLIST B "+
			" WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAMEOFBANK)) "+
		" WHERE A.FILENAME = '"+userCode+"'  "+
		"  AND A.LISTNAME='RBIDEFAULTERSLIST' "+
		"  AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAMEOFBANK) FROM TB_RBIDEFAULTERSLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAMEOFBANK)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		queryString = " UPDATE "+schemaName+"TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.UID_ FROM TB_OFACSDNLIST B WHERE "+
			 " UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) "+
		" WHERE A.FILENAME = '"+userCode+"'  "+
		" AND A.LISTNAME='OFACSDNLIST' "+
		"  AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAME) FROM TB_OFACSDNLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME))  ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();

        }
        catch(Exception e)
        {
        	log.error("Exception in finally exception block is "+e.toString());
            e.printStackTrace();
        }
        finally {
        	closeResources(connection, preparedStatement, resultSet);
     	}
        return alMatchResult;
    }
    
   public FieldVO[] getSelectedFieldProperties(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement      = null;
       ResultSet         resultSet      = null;
       FieldVO[]         objFieldVOArray    = null;
       try {
    	   String l_strQueryFieldInfo = " SELECT A.COLUMNFIELDPOSITION, A.COLUMNNAME, A.COLUMNDATATYPE, A.COLUMNDATASIZE, "+
    	   								"        A.ALLOWNULL, A.DEFAULTVALUE, B.FILEFIELDSDELIMITER "+
    	   								"   FROM "+schemaName+"TB_FILEIMPORTDETAIL A, "+schemaName+"TB_FILEIMPORTMASTER B "+
    	   								"  WHERE A.FILEIMPORTID = ? "+
    	   								"    AND B.FILEIMPORTID = A.FILEIMPORTID "+
    	   								"  ORDER BY A.COLUMNFIELDPOSITION  ";

    	   preparedStatement = connection.prepareStatement(l_strQueryFieldInfo);            
           preparedStatement.setInt(1,a_intReportID);
           resultSet = preparedStatement.executeQuery();
 		   Vector<FieldVO> vectorFieldVO = new Vector<FieldVO>(); 	
           while (resultSet.next()) {
               FieldVO objFieldVO = new FieldVO();
               objFieldVO.setFieldName(resultSet.getString("COLUMNNAME"));
               objFieldVO.setFieldPos(resultSet.getInt("COLUMNFIELDPOSITION"));
               objFieldVO.setDataType(resultSet.getString("COLUMNDATATYPE"));
               objFieldVO.setSize(resultSet.getInt("COLUMNDATASIZE"));
               String l_strTemp = resultSet.getString("ALLOWNULL");
				
               if (l_strTemp != null && l_strTemp.equalsIgnoreCase("y"))
                   objFieldVO.setNullAllowed(true); 
               else
                   objFieldVO.setNullAllowed(false);
				
               objFieldVO.setDefaultValue(resultSet.getString("DEFAULTVALUE"));
			   String l_StrDelimiter = resultSet.getString("FILEFIELDSDELIMITER");
               objFieldVO.setFieldDelimiter(getFormattedDelimiterString(l_StrDelimiter));					
               vectorFieldVO.add(objFieldVO);
           }
			objFieldVOArray = new FieldVO[vectorFieldVO.size()];
			for(int i=0;i<objFieldVOArray.length;i++){
				objFieldVOArray[i] = (FieldVO)vectorFieldVO.get(i);
			}
			
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedFieldProperties "+e.toString());
       	e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedFieldProperties "+e.toString());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
        return objFieldVOArray;
   }



   public RecordVO getSelectedRecordProperties(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement = null;
       ResultSet resultSet = null;
       RecordVO  objRecordVO = null;
       try {			
    	   String l_strQueryRecordInfo = " SELECT A.COLUMNFIELDPOSITION, B.FILEFIELDSDELIMITER "+
           								 "   FROM "+schemaName+"TB_FILEIMPORTDETAIL A, "+schemaName+"TB_FILEIMPORTMASTER B "+
           								 "  WHERE A.FILEIMPORTID = ? "+
           								 "    AND A.FILEIMPORTID = B.FILEIMPORTID "+
           								 "  ORDER BY A.COLUMNFIELDPOSITION ASC  ";

           preparedStatement = connection.prepareStatement(l_strQueryRecordInfo);
			
           preparedStatement.setInt(1,a_intReportID);
           resultSet = preparedStatement.executeQuery();
			
           int recordCount = 0;
           ArrayList<String> fieldDelimiters = new ArrayList<String>();
           while (resultSet.next()) {
               recordCount++;
			   String l_StrDelimiter = resultSet.getString("FILEFIELDSDELIMITER");
               fieldDelimiters.add(getFormattedDelimiterString(l_StrDelimiter));
           }
			
           int intDelimitersCount = fieldDelimiters.size();
           String[] strDelimterArray = new String[intDelimitersCount]; 
           for (int i=0; i < fieldDelimiters.size(); i++) {
               strDelimterArray[i] = (String) fieldDelimiters.get(i);
           }
           objRecordVO = new RecordVO();
           objRecordVO.setRecordDelimiter(strDelimterArray[intDelimitersCount - 1]);
           objRecordVO.setNoOfFields(recordCount);
           objRecordVO.setDelimiters(strDelimterArray);            
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedRecordProperties : "+e.getMessage());
       		e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedRecordProperties : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return objRecordVO;		
   }
   public HashMap<String,Vector<IndexFieldVO>> getSelectedIndexingInfo(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement        = null;
       ResultSet         resultSet        = null;
	   HashMap<String,Vector<IndexFieldVO>> hashMapIndexFieldVO = null;  
       try {			
    	   String l_strQueryReportIndexInfo = 
    		    " SELECT FieldName, Type AS FieldType, DataFields, IsRepeated, Delimiter "+
                "   FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO A, "+schemaName+"TB_EXCEPTIONLISTMASTER B "+
				"  WHERE B.FILEIMPORTID = ? "+
				"    AND B.ListCode = A.ListCode  "; 
           preparedStatement = connection.prepareStatement(l_strQueryReportIndexInfo);
           preparedStatement.setInt(1,a_intReportID);
		   resultSet = preparedStatement.executeQuery();
		   hashMapIndexFieldVO = new HashMap<String,Vector<IndexFieldVO>>();
           Vector<IndexFieldVO> vectorIndexFieldVO = new Vector<IndexFieldVO>(); 
           while (resultSet.next()) {
				String l_strFieldType = resultSet.getString("FieldType");
				String l_strFieldName = resultSet.getString("FieldName");
				String l_strDataFields = resultSet.getString("DataFields");
				StringTokenizer l_StrTokens = new StringTokenizer(l_strDataFields,",");
				String[] l_strDataFieldArry = new String[l_StrTokens.countTokens()];
				int intPositionIndex  = 0;
				while(l_StrTokens.hasMoreTokens()){
					l_strDataFieldArry[intPositionIndex++] = l_StrTokens.nextToken(); 
				}
				  
				if(! hashMapIndexFieldVO.containsKey( l_strFieldType )){
					vectorIndexFieldVO = new Vector<IndexFieldVO>();
					hashMapIndexFieldVO.put(l_strFieldType,vectorIndexFieldVO); 
				}
				else{
					vectorIndexFieldVO = (Vector<IndexFieldVO>)hashMapIndexFieldVO.get(l_strFieldType);
				}
				IndexFieldVO objIndexFieldVO = new IndexFieldVO();
				objIndexFieldVO.setDataFields( l_strDataFieldArry ); 
				objIndexFieldVO.setFieldName( l_strFieldName );
				objIndexFieldVO.setIsRepeated(resultSet.getInt("IsRepeated")==1?true:false );
				objIndexFieldVO.setDelimiter(resultSet.getString("Delimiter") );
				vectorIndexFieldVO.add( objIndexFieldVO );
           }
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedIndexingInfo : "+e.getMessage());
       		e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedIndexingInfo : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return hashMapIndexFieldVO;		
   }
	

   public HashMap<String,IndexFieldVO> getSelectedIndexingInfo(String a_strListCode) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement        = null;
       ResultSet         resultSet        = null;
	   HashMap<String,IndexFieldVO> hashMapIndexFieldVO       = null;  
       try {			
    	   String l_strQueryListCodeIndex = 
    		   " SELECT FieldName, Type AS FieldType, DataFields, IsRepeated, Delimiter "+ 
               "   FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO A "+
			   "  WHERE UPPER(TRIM(A.ListCode)) = UPPER(TRIM(?)) "; 
            preparedStatement = connection.prepareStatement(l_strQueryListCodeIndex);
            preparedStatement.setString(1,a_strListCode);
			resultSet = preparedStatement.executeQuery();
			hashMapIndexFieldVO = new HashMap<String,IndexFieldVO>();
            while (resultSet.next()) {
				String l_strFieldName = resultSet.getString("FieldName");
				String l_strDataFields = resultSet.getString("DataFields");
				
				StringTokenizer l_StrTokens = new StringTokenizer(l_strDataFields,",");
				String[] l_strDataFieldArry = new String[l_StrTokens.countTokens()];
				int intPositionIndex  = 0;
				
				while(l_StrTokens.hasMoreTokens()){
					l_strDataFieldArry[intPositionIndex++] = l_StrTokens.nextToken(); 
				}
				  
				IndexFieldVO objIndexFieldVO = new IndexFieldVO();
				objIndexFieldVO.setDataFields( l_strDataFieldArry ); 
				objIndexFieldVO.setFieldName( l_strFieldName );
				objIndexFieldVO.setIsRepeated(resultSet.getInt("IsRepeated")==1?true:false );
				objIndexFieldVO.setDelimiter(resultSet.getString("Delimiter") );
				hashMapIndexFieldVO.put(objIndexFieldVO.getFieldName(),objIndexFieldVO); 
            }
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedIndexingInfo : "+e.getMessage());
       	e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedIndexingInfo : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return hashMapIndexFieldVO;		
   }
	
	public String getSelectedListCode(int a_intReportID){
		Connection connection = getConnection();
	    PreparedStatement preparedStatement        = null;
        ResultSet         resultSet        = null;
		String            l_strListCode       = null;  
       try {			
    	   String l_strQueryListCode = " SELECT ListCode FROM "+schemaName+"TB_EXCEPTIONLISTMASTER WHERE FILEIMPORTID = ? ";
           preparedStatement = connection.prepareStatement(l_strQueryListCode);
           preparedStatement.setInt(1,a_intReportID);
           resultSet = preparedStatement.executeQuery();
           while (resultSet.next()) {
				l_strListCode = resultSet.getString("ListCode"); 
           }
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedListCode : "+e.getMessage());
       		e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedListCode : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return l_strListCode;
	} 	

	public Collection getSelectedSearchSettings(int a_intReportID, HashMap a_hmSearchData){
		Connection connection = getConnection();
        PreparedStatement preparedStatement        = null;
        ResultSet         resultSet        = null;
		ArrayList         alSearchArrayList      = null;  
        try {			
        	String l_strSearchListQry = " SELECT SearchListCode, SearchLevel FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING A ,"
					+ " "+schemaName+"TB_EXCEPTIONLISTMASTER B WHERE A.SourceListCode = B.ListCode AND B.FILEIMPORTID = ? ";
        	l_strSearchListQry = l_strSearchListQry +" AND SearchListCode IN ( SELECT LISTCODE FROM "+schemaName+"TB_EXCEPTIONLISTMASTER WHERE UPPER(LISTTYPE) IN ('' ";
        	
        	if(a_hmSearchData.get("BlackListCheck").equals("Y"))
        		l_strSearchListQry = l_strSearchListQry +" ,'BLACKLIST' "; 
        	if(a_hmSearchData.get("CustomerDataBaseCheck").equals("Y"))
        		l_strSearchListQry = l_strSearchListQry +" ,'INTERNALLIST' "; 
        	if(a_hmSearchData.get("RejectedListCheck").equals("Y"))
        		l_strSearchListQry = l_strSearchListQry +" ,'REJECTEDLIST' "; 
        	if(a_hmSearchData.get("EmployeeDataBaseCheck").equals("Y"))
        		l_strSearchListQry = l_strSearchListQry +" ,'EMPLOYEELIST' ";
        	if(a_hmSearchData.get("SelectedBlackListCheck").equals("Y"))
        		l_strSearchListQry = l_strSearchListQry +" ,'SELECTEDBLACKLIST' ";
    		l_strSearchListQry = l_strSearchListQry +" )) "; 
    		
           	preparedStatement = connection.prepareStatement(l_strSearchListQry);
            preparedStatement.setInt(1,a_intReportID);
            resultSet = preparedStatement.executeQuery();
			
			alSearchArrayList = new ArrayList();
			
            while (resultSet.next()) {
				SearchListVO objSearchListVO = new SearchListVO();
				objSearchListVO.setListCode(resultSet.getString("SearchListCode")); 
				objSearchListVO.setSearchLevel(resultSet.getString("SearchLevel"));
				alSearchArrayList.add(objSearchListVO);
            }
        }catch(SQLException e){
        	log.error("SQLException in getSelectedSearchSettings: "+e.toString());
        	System.out.println("SQLException in getSelectedSearchSettings: "+e.toString());
			e.printStackTrace();
		}catch(Exception e){
			log.error("SQLException in getSelectedSearchSettings: "+e.toString());
			System.out.println("Exception in getSelectedSearchSettings: "+e.toString());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
        return alSearchArrayList;
	} 

	public Collection getSelectedSearchSettings(int a_intReportID){
		Connection connection = getConnection();
        PreparedStatement preparedStatement        = null;
        ResultSet         resultSet        = null;
		ArrayList         alSearchArrayList      = null;  
        try {			
        	String l_strQuerySearchList = 
        		" SELECT SearchListCode, SearchLevel "+
				"   FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING A ,"+schemaName+"TB_EXCEPTIONLISTMASTER B "+
				"  WHERE A.SourceListCode = B.ListCode AND B.FILEIMPORTID = ? ";
           	preparedStatement = connection.prepareStatement(l_strQuerySearchList);
            preparedStatement.setInt(1,a_intReportID);
            resultSet = preparedStatement.executeQuery();
			alSearchArrayList = new ArrayList();
            while (resultSet.next()) {
				SearchListVO objSearchListVO = new SearchListVO();
				objSearchListVO.setListCode(resultSet.getString("SearchListCode")); 
				objSearchListVO.setSearchLevel(resultSet.getString("SearchLevel"));
				alSearchArrayList.add(objSearchListVO);
            }
        }catch(SQLException e){
        	log.error("SQLException in getSelectedSearchSettings: "+e.toString());
        	System.out.println("SQLException in getSelectedSearchSettings: "+e.toString());
			e.printStackTrace();
		}catch(Exception e){
			log.error("SQLException in getSelectedSearchSettings: "+e.toString());
			System.out.println("Exception in getSelectedSearchSettings: "+e.toString());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
        return alSearchArrayList;
	} 

	 public Collection getSelectedFieldMappingInfo(int a_intReportID,String a_strListCode,String a_strUser,String a_strTemplateId,String a_isFileImport){
		 Connection connection = getConnection();
		 CallableStatement callableStatement        = null;
	        ResultSet         resultSet        = null;
			ArrayList         l_alMappingFieldList= null;
			try {			
	            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_FETCHSEARCHMAPPINGFIELDS(?,?,?,?,?,?)}");
				
	            callableStatement.setInt(1,a_intReportID);
				callableStatement.setString(2,a_strListCode);
				callableStatement.setString(3,a_strUser);
				callableStatement.setString(4,a_strTemplateId);
				callableStatement.setString(5,a_isFileImport);
				callableStatement.registerOutParameter(6, -10);
				callableStatement.execute();
	            resultSet = (ResultSet)callableStatement.getObject(6);
				
				l_alMappingFieldList = new ArrayList();
				
	            while (resultSet.next()) {
					MappedFieldVO objMappedFieldVO = new MappedFieldVO();
					objMappedFieldVO.setFieldType(resultSet.getString("FieldType"));
					objMappedFieldVO.setFieldCategory(resultSet.getString("FieldCategory")); 
					objMappedFieldVO.setMatchField(resultSet.getString("SearchField")); 
					objMappedFieldVO.setScoreLimit(resultSet.getInt("Score")); 
					objMappedFieldVO.setSourceField(resultSet.getString("SourceField"));
					String l_strDataFields = resultSet.getString("DataFields");
					
					StringTokenizer l_strTokens = new StringTokenizer(l_strDataFields,",");
					String[] l_strDataFieldArry = new String[l_strTokens.countTokens()];
					int intPositionIndex  = 0;  
					while(l_strTokens.hasMoreTokens()){
						l_strDataFieldArry[intPositionIndex++] = l_strTokens.nextToken();
					}
					objMappedFieldVO.setDataFields(l_strDataFieldArry);

					objMappedFieldVO.setIsRepeated(resultSet.getInt("isRepeated")==1?true:false);
					objMappedFieldVO.setDelimiter(resultSet.getString("Delimiter"));
					l_alMappingFieldList.add(objMappedFieldVO);
	            }
	        }catch(SQLException e){
	        	log.error("Error occured in getSelectedFieldMappingInfo : "+e.getMessage());
	        	e.printStackTrace();
			}catch(Exception e){
				log.error("Error occured in getSelectedFieldMappingInfo : "+e.getMessage());
				e.printStackTrace();
			}finally{	
				closeResources(connection, callableStatement, resultSet);
			}
	        return l_alMappingFieldList;
	    } 
	public void saveRealtimeSearchResults(Collection a_alResults,int a_intImportId,String a_strUniqueId, String a_fileName ,String isFileImport , String a_UserCode , String a_blacklistid,String a_strTemplateId)
	{
		Connection connection = getConnection();
		CallableStatement callableStatement        = null;
        try {			
            String l_strProcPersistResult = "{CALL "+schemaName+"PERSISTNONCUSTOMERMATCHES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)} ";									 
           	callableStatement = connection.prepareCall(l_strProcPersistResult);	
			Iterator l_ResultItr = a_alResults.iterator();
			while(l_ResultItr.hasNext()){
				ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)l_ResultItr.next();
				String matchdata = objScreeningResultVO.getMatchData().replaceAll("'","''");
				String sourcedata = objScreeningResultVO.getSourceData().replaceAll("'","''");
				callableStatement.setInt(1,a_intImportId);
				callableStatement.setString(2,a_strUniqueId);
				callableStatement.setString(3,objScreeningResultVO.getSourceField()); 
				callableStatement.setString(4,objScreeningResultVO.getListName());
				callableStatement.setString(5,objScreeningResultVO.getId());
				callableStatement.setString(6,objScreeningResultVO.getMatchField());
				callableStatement.setString(7,matchdata.trim());
				callableStatement.setString(8,sourcedata.trim());
				callableStatement.setInt(9,objScreeningResultVO.getScore());
				callableStatement.setString(10,a_fileName);
				callableStatement.setString(11,isFileImport);
				callableStatement.setString(12,a_UserCode);
				callableStatement.setString(13,a_blacklistid);
				callableStatement.setString(14," ");
				callableStatement.setString(15," ");
				callableStatement.setString(16," ");
				callableStatement.setString(17," ");
				callableStatement.setString(18," ");
				callableStatement.setString(19,a_strTemplateId);
				callableStatement.addBatch();
			}	 	
            callableStatement.executeBatch();
        } 
        catch (Exception e) {
        	log.error("Error occured in saveRealtimeSearchResults : "+e.getMessage());
        	e.printStackTrace();
        }
		finally {
            closeResources(connection, callableStatement, null);
        }		
	} 
	public Map getSavedFileMatches(String a_FileName,String isFileImport,int a_counter)
	{
		MatchResultVO objMatchResultVO = new MatchResultVO();
		objMatchResultVO.setFileName(a_FileName.substring(0,a_FileName.indexOf("|")));
		objMatchResultVO.setFileImport(isFileImport);
		objMatchResultVO.setCounter(String.valueOf(a_counter));
		return getSavedFileMatches(objMatchResultVO);
	}
    public Map getSavedFileMatches(MatchResultVO objMatchResultVO)
	{
    	Connection connection = getConnection();
		CallableStatement  callableStatement   = null;
		ResultSet resultSet   = null; 
	    LinkedHashMap linkedHashMap = null;
		ArrayList arrayList = new ArrayList();
		RTMatchResultVO objRTMatchResultVO = null;
		try {   
			String filename = objMatchResultVO.getFileName();
			String usercode = objMatchResultVO.getLoggedUser();
           	callableStatement  = connection.prepareCall("{CALL "+schemaName+"STP_GETSCANMATCHES(?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1,objMatchResultVO.getFileImport());
			callableStatement.setString(2,objMatchResultVO.getFileName());
			callableStatement.setInt(3,Integer.parseInt(objMatchResultVO.getCounter()));
			callableStatement.setString(4,objMatchResultVO.getLoggedUser());
			callableStatement.setString(5,objMatchResultVO.getUserCode());
			callableStatement.setString(6,objMatchResultVO.getRecordStatus());
			callableStatement.setString(7,objMatchResultVO.getScanningFromDate());
			callableStatement.setString(8,objMatchResultVO.getScanningToDate());
			callableStatement.setString(9,objMatchResultVO.getProcessingFromDate());
			callableStatement.setString(10,objMatchResultVO.getProcessingToDate());
			//callableStatement.registerOutParameter(11,oracle.jdbc.OracleTypes.INTEGER);
			//callableStatement.registerOutParameter(12,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(11, 12);
			callableStatement.registerOutParameter(12,-10);
			callableStatement.execute();
			int totalRecords = callableStatement.getInt(11);
			resultSet=(ResultSet)callableStatement.getObject(12); 
			while(resultSet.next()) 
			{
			objRTMatchResultVO = new RTMatchResultVO();
			objRTMatchResultVO.setSourceInfo(resultSet.getString("SOURCEINFO"));
			objRTMatchResultVO.setUniqueNumber(resultSet.getString("UNIQUENUMBER"));
			objRTMatchResultVO.setListName(resultSet.getString("LISTNAME"));
			objRTMatchResultVO.setListId(resultSet.getString("LISTID"));
			objRTMatchResultVO.setRank(resultSet.getString("RANK"));
			objRTMatchResultVO.setMatchedInfo(resultSet.getString("MATCHEDINFO"));
			objRTMatchResultVO.setMatchDate(resultSet.getString("MATCHDATE"));
			objRTMatchResultVO.setStatus(resultSet.getString("STATUS"));
			objRTMatchResultVO.setComments(resultSet.getString("COMMENTS"));
			objRTMatchResultVO.setSerialNo1(resultSet.getString("SERIALNO1"));
			objRTMatchResultVO.setCustomerName(resultSet.getString("CUSTOMERNAME"));
			arrayList.add(objRTMatchResultVO);
			}
			linkedHashMap = new LinkedHashMap();
			linkedHashMap.put("TotalRecords",new Integer(totalRecords));
			linkedHashMap.put("ResultedRecords",arrayList);
			linkedHashMap.put("FileName",filename);
			linkedHashMap.put("FileImport",objMatchResultVO.getFileImport());
		}
		catch(SQLException e){
			log.error("SQLException in getSavedFileMatches : "+e.toString());
			System.out.println("SQLException in getSavedFileMatches : "+e.toString());
			e.printStackTrace();
		}
		catch(Exception e){
			log.error("SQLException in getSavedFileMatches : "+e.toString());
			System.out.println("SQLException in getSavedFileMatches : "+e.toString());
			e.printStackTrace();
		}
		finally{
			closeResources(connection, callableStatement, resultSet);
		}
		return linkedHashMap;
	}

    public String saveSelectedImportFile(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,
			 String a_delimiter,String a_blacklistid,String a_whitelistid)
	{
    Connection connection = getConnection();
	CallableStatement callableStatement  = null;
    String strResultMessage = new String();
    String strFileUpdatedName = new String();
	try
	{
	boolean boolStatusFlag = checkReImport(a_user,a_fileactualname.substring(0,a_fileactualname.indexOf(".")));
	if(!(boolStatusFlag))
	{
	strResultMessage = "File Already Imported";
	return strResultMessage;
	}
	strFileUpdatedName = checkFileMappingConfiguration(a_reportid,a_filedir,a_fileactualname,a_templateid,a_data,a_delimiter);
	if(strFileUpdatedName.equalsIgnoreCase("Error ~ Occured"))
	{
	strResultMessage = "Error In Creating File";
	return strResultMessage;
	}
	String procName = retrievestprName(a_reportid);
	if(procName == null)
	{
	strResultMessage = "Procedure Is Not Defined For Import Routine";
	return strResultMessage;
	}
	else
	{
    callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_FILEDATABULKINSERT(?,?,?,?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_reportid));
	callableStatement.setString(2,a_filedir);
	callableStatement.setString(3,strFileUpdatedName);
	callableStatement.setString(4,a_user);
	callableStatement.setString(5,a_delimiter);
	callableStatement.setString(6,a_templateid);
	callableStatement.execute();
	callableStatement.close();
	callableStatement = connection.prepareCall("{CALL "+schemaName+"PROC_UPDATE_TEMPTABLE(?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_reportid));
	callableStatement.setString(2,a_templateid);
	callableStatement.setString(3,a_user);
	callableStatement.execute();
	callableStatement.close();
	strResultMessage = callImportProcedure(callableStatement,procName,a_user,a_fileactualname,a_reportid,a_templateid);
	}
	}
	catch(Exception e)
	{
		log.error("Error occured in saveSelectedImportFile : "+e.getMessage());
	strResultMessage = "Data In File Is Not Proper";
	e.printStackTrace();
	}finally{
		closeResources(connection, callableStatement, null);
	}
	return strResultMessage;
	}
    
    public String saveSelectedImportFileNew(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,
			 String a_delimiter,String tableName){
    	Connection connection = getConnection();
    	CallableStatement callableStatement  = null;
    	PreparedStatement preparedStatement = null;
    	ResultSet resultSet = null;
    	String strResultMessage = "File Succesfully Imported";
    	String currentLine = "";
    	int noOfLine = 0;
    	String sqlQuery = "";
    	String strTableName = tableName; // "TT_IMPORT"+"_"+a_user.replace(".", "_");
    	int tableCount = 0;
    	long time = new Date().getTime();
    	try {
    		boolean boolStatusFlag = checkReImport(a_user,a_fileactualname.substring(0,a_fileactualname.indexOf(".")));
    		if(!(boolStatusFlag))
    		{
    		strResultMessage = "File Already Imported";
    		return strResultMessage;
    		}
    		
    		preparedStatement = connection.prepareStatement("SELECT COUNT(1) TABLECOUNT FROM USER_TABLES WHERE TABLE_NAME = UPPER('"+strTableName+"') ");
    		resultSet = preparedStatement.executeQuery();
    		while(resultSet.next()){
    			tableCount = resultSet.getInt("TABLECOUNT");
    		}
    		if(tableCount > 0 ){
    			preparedStatement = connection.prepareStatement("TRUNCATE TABLE "+strTableName+" ");
    			preparedStatement.execute();
    		}
    		else {
    		sqlQuery = " CREATE TABLE "+strTableName+" ( "+
    		           "   SERIALNO VARCHAR(100), NAME1 VARCHAR(400), NAME2 VARCHAR(400), NAME3 VARCHAR(400), NAME4 VARCHAR(400), NAME5 VARCHAR(400), "+
    		           "   DATEOFBIRTH VARCHAR(400), PASSPORTNO VARCHAR(400), PANNO VARCHAR(400), ACCOUNTNO VARCHAR(400), CUSTOMERID VARCHAR(400), COMPLETEDETAILS VARCHAR2(4000) "+
    		           " ) ";       
			preparedStatement = connection.prepareStatement(sqlQuery);
			preparedStatement.execute();
    		}
			/*
    		preparedStatement = connection.prepareStatement("DELETE FROM TT_IMPORT199 WHERE USERCODE = ? AND FILENAME = ?");
    		preparedStatement.setString(1, a_user);
    		preparedStatement.setString(2, a_fileactualname);
    		preparedStatement.executeUpdate();
    		*/
    		sqlQuery = "INSERT INTO "+strTableName+"(NAME1, NAME2, NAME3, NAME4, NAME5, DATEOFBIRTH, PASSPORTNO, PANNO, ACCOUNTNO, CUSTOMERID, SERIALNO, COMPLETEDETAILS) "+
			           "  VALUES (?,?,?,?,?,?,?,?,?,?,?,?) ";
    		
    		try{
				File uploadedFile = new File(a_filedir);
	    		BufferedReader bufferedReader = new BufferedReader(new FileReader(uploadedFile));
				preparedStatement = connection.prepareStatement(sqlQuery);
				
	    		while((currentLine = bufferedReader.readLine()) != null){
	    			time ++;
	    			noOfLine++;
	    			List<String> list = Arrays.asList(currentLine.split(a_delimiter));    				
	    			
	    			if(list.size() != 10) {
	    				strResultMessage = "Data In File Is Not Proper in Line : "+noOfLine;
	    				return strResultMessage;
	    			}
	    			
	    			preparedStatement.setString(1, list.get(0));
	    			preparedStatement.setString(2, list.get(1));
	    			preparedStatement.setString(3, list.get(2));
	    			preparedStatement.setString(4, list.get(3));
	    			preparedStatement.setString(5, list.get(4));
	    			preparedStatement.setString(6, list.get(5));
	    			preparedStatement.setString(7, list.get(6));
	    			preparedStatement.setString(8, list.get(7));
	    			preparedStatement.setString(9, list.get(8));
	    			preparedStatement.setString(10, list.get(9));
	    			preparedStatement.setString(11, new Long(time).toString());
	    			preparedStatement.setString(12, list.get(0)+"^~^"+list.get(1)+"^~^"+list.get(2)+"^~^"+list.get(3)+"^~^"+list.get(4)+"^~^"+list.get(5)+"^~^"+list.get(6)+"^~^"+list.get(7)+"^~^"+list.get(8)+"^~^"+list.get(9));
	    			preparedStatement.addBatch();
	    		}
	    		preparedStatement.executeBatch();
	    		
	    		sqlQuery = "INSERT INTO "+schemaName+"TB_ONLINESCANNINGDATA ( "+
	    		           "       SERIALNO, NAME1, NAME2, NAME3, NAME4, NAME5, DATEOFBIRTH, PASSPORTNO, PANNO, ACCOUNTNO, CUSTOMERID, USERCODE, "+
	    		           "       UPDATETIMESTAMP, UPDATEDBY, FILENAME, SNOVAL, COMPLETEDETAILS) "+
	    		           "SELECT A.SERIALNO, A.NAME1, A.NAME2, A.NAME3, A.NAME4, A.NAME5, A.DATEOFBIRTH, A.PASSPORTNO, A.PANNO, A.ACCOUNTNO, A.CUSTOMERID, '"+a_user+"', "+
	    		           "       SYSTIMESTAMP, '"+a_user+"', '"+a_fileactualname+"', ROWNUM, A.COMPLETEDETAILS "+
	    		           "  FROM "+strTableName+" A " ;
	    		preparedStatement = connection.prepareStatement(sqlQuery);
				preparedStatement.executeUpdate();
				
				sqlQuery = "INSERT INTO "+schemaName+"FILEIMPORTLOG ( "+
		                   "       FILENAME, USERCODE, REPORTID, TEMPLATEID, RECORDSPROCESSED, RECORDSINSERTED, RECORDSUPDATED, UPDATETIMESTAMP ) "+
	    		           "SELECT '"+a_fileactualname+"', '"+a_user+"', '"+a_reportid+"', '"+a_templateid+"', COUNT(1), COUNT(1), 0, SYSTIMESTAMP "+
	    		           "  FROM "+strTableName+" A " ;
	    		preparedStatement = connection.prepareStatement(sqlQuery);
				preparedStatement.executeUpdate();
				
				callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_UPDATE_RTSCREENINGTEMP(?,?,?)}");
				callableStatement.setString(1,a_fileactualname);
				callableStatement.setString(2,a_user);
				callableStatement.setString(3,strTableName);
				callableStatement.execute();
				// callableStatement.close();
			}catch(Exception e){
				log.error("Error occured in file parsing and saving : "+e.getMessage());
				e.printStackTrace();
			}
		} catch(Exception e) {
			log.error("Error occured in saveSelectedImportFileNew : "+e.getMessage());
			strResultMessage = "Data In File Is Not Proper";
			e.printStackTrace();
		}finally{
			closeResources(connection, callableStatement, null);
		}
		return strResultMessage;
	}

    public Map<String, Object> getFileImportDetailss(File fileName, String entityName){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		Connection connection = getConnection();
		Statement statement  = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		BufferedReader burreredReader = null;
		String currentLine = "";
		String l_strWholeFileText = "";
		String message = "";
		try{
			burreredReader = new BufferedReader(new FileReader(fileName));
			while((currentLine = burreredReader.readLine()) != null){
				l_strWholeFileText = l_strWholeFileText+currentLine+"\n";
			}
			statement = connection.createStatement();
			statement.execute(l_strWholeFileText);
		}catch(Exception e){
			message = message+e.getMessage()+". \n";
		}
		try{
			preparedStatement = connection.prepareStatement("SELECT DISTINCT OBJECT_NAME||' AND STATUS IS: '||STATUS AS PROCESSSTATUS FROM USER_OBJECTS WHERE OBJECT_NAME = ? ");
			preparedStatement.setString(1, entityName);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				mainMap.put("PROCESSSTATUS", true);
				message = "File successfully executed. ";
				message = resultSet.getString("PROCESSSTATUS");
			}else{
				mainMap.put("PROCESSSTATUS", false);
				message = "file execution failed. ";
			}
		}catch(Exception e){
			message = message+e.getMessage();
		}finally{
			mainMap.put("MESSAGE",message);
			connectionUtil.closeResources(connection, statement, resultSet, null);

			try{burreredReader.close();	}catch(Exception e){}
		}
		return mainMap;
	}
	private boolean checkReImport(String a_usercode,String a_FileName)
	{ 
		Connection connection = getConnection();
    Statement statement = null;
    ResultSet resultSet = null;
    boolean boolStatusFlag = true;
    try {			
	//String l_Query = " SELECT COUNT(*) AS COUNT FROM FILEIMPORTLOG WHERE USERCODE  = '"+a_usercode+"' AND FILENAME LIKE '"+a_FileName+"%'" ;
   	String l_Query = " SELECT COUNT(*) AS COUNT FROM "+schemaName+"FILEIMPORTLOG WHERE FILENAME LIKE '"+a_FileName+"%'" ;	
    statement = connection.createStatement();
    resultSet = statement.executeQuery(l_Query);
	while(resultSet.next()) 
	{
		if(resultSet.getInt(1) > 0)	
			boolStatusFlag = false;
	}
	} 
    catch(SQLException e){
    	log.error("Error occured in checkReImport : "+e.getMessage());
    	boolStatusFlag = false;
    	e.printStackTrace();
	}catch(Exception e){
		log.error("Error occured in checkReImport : "+e.getMessage());
		boolStatusFlag = false;
		e.printStackTrace();
	}finally{
		closeResources(connection, statement, resultSet);
	}
	return boolStatusFlag;
	}
	
	private String checkFileMappingConfiguration(String a_ReportId,String a_FilePath,String a_FileName,String a_TemplateID, String data , String a_delimiter)
	{
		Connection connection = getConnection();
    CallableStatement callableStatement = null;
	ResultSet resultset = null;
    BufferedReader bufferedReader  = null;
	BufferedWriter bufferedWriter  = null;
	String strInputFile = null;
	String strOutputFile = null;
	String strEachLine = null;
	int intTotalCountOfRecords = 0;
	int intCount =0;
    try {			
	callableStatement = connection.prepareCall("{CALL "+schemaName+"PROC_GETCONFIGURATION(?,?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_ReportId));
	callableStatement.setString(2,a_TemplateID);
	//callableStatement.registerOutParameter(3,oracle.jdbc.OracleTypes.CURSOR);
    //callableStatement.registerOutParameter(4,oracle.jdbc.OracleTypes.INTEGER);
	callableStatement.registerOutParameter(3, -10);
    callableStatement.registerOutParameter(4, 12);
	callableStatement.execute();
	resultset=(ResultSet)callableStatement.getObject(3);
	intTotalCountOfRecords = callableStatement.getInt(4);
	HashMap hashMapTemp =new HashMap();
	while(resultset.next())
	{
		String compassNo = resultset.getString("ACTUALFIELDPOSITION");
		String clientNo = resultset.getString("FILEFIELDPOSITION"); 
		hashMapTemp.put(compassNo,clientNo);
	}
	String strFilePath = a_FilePath.replaceFirst("","");
	String strIpAddress = "localhost";
	String strDoUseIP = "No";
	String strAdditionSerialNo = "AddSerialNo".trim();
	strAdditionSerialNo = "No";
	if(strDoUseIP.equalsIgnoreCase("yes"))
		strOutputFile = new String(File.separator+File.separator+strIpAddress+File.separator+strFilePath+File.separator+a_FileName);
	else
		strOutputFile = new String(strFilePath+File.separator+a_FileName);
	bufferedReader = new BufferedReader(new StringReader(new String(data)));
	bufferedWriter = new BufferedWriter(new FileWriter(new File(strOutputFile)));
	while((strEachLine = bufferedReader.readLine()) != null)
	{
	StringBuffer stringBuffer = new StringBuffer();
	Vector vectorTemp = new Vector();
	intCount = 0;
    while(true)
	{
	  int intCountIndex = strEachLine.indexOf(a_delimiter,intCount);
	  String strTempValue = strEachLine.substring(intCount,intCountIndex);
	  vectorTemp.add(strTempValue);
	  intCount = intCountIndex+1;
	  if(strEachLine.indexOf(a_delimiter,intCount) == -1)
	  {
		vectorTemp.add(strEachLine.substring(intCount,strEachLine.length()));
		break;
	  }
	 }
	if(strAdditionSerialNo.equalsIgnoreCase("yes"))
	{
		stringBuffer.append(System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9));
		stringBuffer.append(a_delimiter);
	}
	if(a_ReportId.equals("199"))
	{
		stringBuffer.append(System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9));
		stringBuffer.append(a_delimiter);
	}
	intCount = 1;
	while(intCount < (intTotalCountOfRecords+1))
	{
		if(hashMapTemp.get(String.valueOf(intCount)) == null)
			stringBuffer.append("");
		else
		{
			int intValue = Integer.parseInt(hashMapTemp.get(String.valueOf(intCount)).toString());
			stringBuffer.append(vectorTemp.get(intValue-1).toString());
		}
		stringBuffer.append(a_delimiter);
		intCount++;
	}
	bufferedWriter.write(stringBuffer.toString());
	bufferedWriter.newLine();
	}
	bufferedWriter.flush();
	bufferedWriter.close();
	bufferedReader.close();
    }catch(IOException io)
    {
    	log.error("Error occured in checkFileMappingConfiguration : "+io.getMessage());
		a_FileName = "Error ~ Occured";
		io.printStackTrace();
	}catch(SQLException e)
    {
		log.error("Error occured in checkFileMappingConfiguration : "+e.getMessage());
		a_FileName = "Error ~ Occured";
		e.printStackTrace();
	}catch(Exception e)
	{
		log.error("Error occured in checkFileMappingConfiguration : "+e.getMessage());
		a_FileName = "Error ~ Occured";
		e.printStackTrace();
	}finally{
		closeResources(connection, callableStatement, resultset);
	}
	return a_FileName;
	}	

	
	private String retrievestprName(String a_reportid) throws SQLException 
	{
		Connection connection = getConnection();
	String     strStoredProcName = null;
	PreparedStatement  preparedStatement   = null;
	ResultSet  resultSet   = null; 
    try {   
       	preparedStatement  = connection.prepareStatement(" SELECT IMPORTPROCEDURENAME FROM "+schemaName+"TB_FILEIMPORTMASTER WHERE FILEIMPORTID = ?");
		preparedStatement.setInt(1,Integer.parseInt(a_reportid));
		resultSet  = preparedStatement.executeQuery(); 
		if(resultSet.next()) {
			strStoredProcName = resultSet.getString("IMPORTPROCEDURENAME");
		}	
		if( strStoredProcName == null || strStoredProcName.trim().equals(""))
			l_strResultStatusMessage = "Procedure Not Found";
	}
	catch(SQLException e){
		log.error("Error occured in retrievestprName : "+e.getMessage());
		e.printStackTrace();
	}finally{
		closeResources(connection, preparedStatement, resultSet);
	}
    return strStoredProcName;
    }

	private String callImportProcedure(CallableStatement a_CStatement, String procName , String usercode , String fileName , String a_reportid , String a_TemplateID)
	{
		Connection connection = getConnection();
		int intUpdatedCounts     =  0;
        int intInsertedCounts    =  0;
        int intProcessedCount       =  0;
        String strResultString = null;
		try
		{
        a_CStatement = connection.prepareCall("{CALL "+schemaName+""+ procName +"(?,?,?,?,?)}");
		a_CStatement.setString(1,usercode);
		a_CStatement.setString(2,fileName);
		a_CStatement.setString(3,a_reportid);
		a_CStatement.setString(4,a_TemplateID);
		a_CStatement.registerOutParameter(5, -10);
		a_CStatement.execute();
		ResultSet resultSet = (ResultSet)a_CStatement.getObject(5);
		while (resultSet.next()) 
		{
			intInsertedCounts = resultSet.getInt(1);
			intUpdatedCounts  = resultSet.getInt(2);
			intProcessedCount    = resultSet.getInt(3); 
            strResultString = "File Succesfully Imported";
        }
		}catch(Exception e)
		{ 
			log.error("Error occured in callImportProcedure : "+e.getMessage());
				e.printStackTrace();
				strResultString = "Error In Call Of Import Procedure";
		}finally{
			closeResources(connection, a_CStatement, null);
		}
		return strResultString;
	}
	private String[] getStringArray(String a_strText,String a_StrDelimiter){
		StringTokenizer stTokenArrays = new StringTokenizer(a_strText,a_StrDelimiter);
		String[] strArrayString = new String[stTokenArrays.countTokens()];
		
		int intPositionIndex = 0;
		while(stTokenArrays.hasMoreTokens()){
			strArrayString[intPositionIndex++] = stTokenArrays.nextToken(); 
		}  
		return strArrayString;
	}
	private String getFormattedDelimiterString(String a_strDelimiter)
	{
	int intPositionIndex = -1;
	while((intPositionIndex = a_strDelimiter.indexOf('\\',intPositionIndex + 1)) > -1){
		switch(a_strDelimiter.charAt( intPositionIndex + 1 )){
			case 't' : a_strDelimiter = a_strDelimiter.substring(0, intPositionIndex)+
								   "\t"+a_strDelimiter.substring(intPositionIndex + 2);
						break;		   
			case 'r' : a_strDelimiter = a_strDelimiter.substring(0, intPositionIndex)+
								   "\r"+a_strDelimiter.substring(intPositionIndex + 2);
						break;		   					   
			case 'n' : a_strDelimiter = a_strDelimiter.substring(0, intPositionIndex)+
								   "\n"+a_strDelimiter.substring(intPositionIndex + 2);
						break;		   					   
		}						    
	}
	return a_strDelimiter;
   }
   public HashMap<String,Object> getSavedFileImportLog(String reportId, String templateId, String userId)
   {
	   Connection connection = getConnection();
	   ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
	   ResultSet resultSet = null;
	   PreparedStatement preparedStatement = null;
       HashMap<String,Object> reportData = new HashMap<String,Object>();
	   String queryString = "SELECT FILENAME, USERCODE UPLOADEDBY, TO_CHAR(UPDATETIMESTAMP,'DD-MON-YYYY') UPLOADEDDATE, "+
	                        "       RECORDSPROCESSED, RECORDSINSERTED, RECORDSUPDATED"+
	                        "  FROM "+schemaName+"FILEIMPORTLOG "+
	                        " WHERE REPORTID = '"+reportId+"' "+
	                        "   AND TEMPLATEID = '"+templateId+"' "+
	                        " ORDER BY UPDATETIMESTAMP DESC "; 
	   try
	   {
	   preparedStatement = connection.prepareStatement(queryString);
	   resultSet = preparedStatement.executeQuery();
	   ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
       String[] l_Headers=new String[resultSetMetaData.getColumnCount()];
       String[] l_Headers1=new String[resultSetMetaData.getColumnCount()];
       
	   for(int i=l_Headers.length;i>=1;i--){
	     l_Headers[i-1]=resultSetMetaData.getColumnName(i);
	     l_Headers1[i-1]=CommonUtil.changeColumnName(resultSetMetaData.getColumnName(i));
	   }
	   while(resultSet.next())
		  {	
			HashMap<String, String> l_DTO=new HashMap<String, String>();
			for(int i=l_Headers.length;i>=1;i--)
			  l_DTO.put(l_Headers[i-1],resultSet.getString(i));
			arrayList.add(l_DTO);
		  }
	reportData.put("Header", l_Headers1);
	reportData.put("ReportData", arrayList);
 	}
 	catch(Exception e)
 	{
 		log.error("The exception in ReportData is "+e.toString());
 		System.out.println("The exception in ReportData is "+e.toString());	
 	}
 	finally{	
		closeResources(connection, preparedStatement, resultSet);
	}
 	return reportData;
   }
   public String getSavedSwiftFileImportLog(String fileName, String userCode)
   {
	   Connection connection = getConnection();
	   String status = "File Imported Successfully";
	   ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
	   HashMap<String, String> hashMap = new HashMap<String, String>();
	   ResultSet resultSet = null;
	   PreparedStatement preparedStatement = null;
       String queryString = " UPDATE "+schemaName+"TB_OFACMESSAGES SET USERCODE = '"+userCode+"' "+
       						"  WHERE FILENAME = '"+fileName+"' ";
	   try
	   {
       preparedStatement = connection.prepareStatement(queryString);
	   preparedStatement.executeUpdate();
	   }
	   catch(Exception e)
	   {
		   log.error("Exception while executing update query "+queryString);
		   System.out.println("Exception while executing update query "+queryString);
	   }finally{
		   closeResources(connection, preparedStatement, resultSet);
	   }
	   queryString = " Select FileName, MessageType, UserCode, Count(*) CountVal "+
	   				 "   From "+schemaName+"TB_OFACMESSAGES "+
                     "  Where FILENAME = '"+fileName+"' "+
                     "  Group By  FileName, MessageType, UserCode "; 
	   try
	   {
	   connection = getConnection();
	   preparedStatement = connection.prepareStatement(queryString);
	   resultSet = preparedStatement.executeQuery();
	   int totalCount = 0;	
	   int mt103Count = 0;
	   int mt202Count = 0;
	   while(resultSet.next())
	   {	
		   if((resultSet.getString("MessageType").trim()).equals("MT103"))
		   {
			   mt103Count = resultSet.getInt("CountVal");
			   totalCount = totalCount + mt103Count;
		   }
		   if((resultSet.getString("MessageType").trim()).equals("MT202"))
		   {
			   mt202Count = resultSet.getInt("CountVal");
			   totalCount = totalCount + mt202Count;
		   }
	   }
	   status = status +"^~^"+totalCount+"^~^"+mt103Count+"^~^"+mt202Count;
	   hashMap = new HashMap<String, String>();
	   hashMap.put("MessageType","TotalCount");
	   arrayList.add(hashMap);
	   hashMap.put("CountVal", totalCount+"");
	   arrayList.add(hashMap);
 	  }
 	catch(Exception e)
 	{
 		log.error("The exception in ReportData is "+e.toString());
 		System.out.println("The exception in ReportData is "+e.toString());	
 	}
 	finally{	
		closeResources(connection, preparedStatement, resultSet);
	}
 	return status;
   }
   
   
   public void closeResources(Connection a_connection, Statement a_statement, ResultSet a_resultSet){
       try{
           if(a_resultSet != null)
               a_resultSet.close();
           
           if(a_statement != null)
               a_statement.close();
           
           if(a_connection != null)
               a_connection.close();
       }catch(Exception e){
    	   log.error("Error in closing resources: "+e.toString());
          	System.out.println("Error in closing connection: "+e.toString());
       }
   }
}
