package com.quantumdataengines.app.compass.dao.scanning;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
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
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.sql.DataSource;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.scanning.MappedFieldVO;
import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.compass.model.scanning.RTMatchResultVO;
import com.quantumdataengines.app.compass.model.scanning.SearchListVO;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.compass.service.scanning.NameMatcher;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;
import com.quantumdataengines.app.listScanning.listSearch.ScreeningResultVO;
import com.quantumdataengines.app.listScanning.model.FieldVO;
import com.quantumdataengines.app.listScanning.model.RecordVO;

@Repository
public class OnlineScanningDAOImpl implements OnlineScanningDAO {
	private String l_strResultStatusMessage =null;
	private static final Logger log = LoggerFactory.getLogger(OnlineScanningDAOImpl.class);
	
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
			connection = connectionUtil.getConnection();
			// connection = dataSource.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : INDSTRDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}

    public ArrayList<HashMap<String,String>> getOnlineScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params)
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
        	              "   FROM TB_RBIDEFAULTERSLIST ";
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
				hmMatchResult.put("ListName", "OFACSDNLIST");
				hmMatchResult.put("ListId", resultSet.getString("UID_"));
				hmMatchResult.put("SourceName", srcName);
				hmMatchResult.put("targetName", targetName);
				hmMatchResult.put("matchScore", finalPerMatch+"");
				alMatchResult.add(hmMatchResult);	
			}
			resultSet = null;
        	queryString = " SELECT ROWNUM AS ROWPOSITION, SERIALNO, NAME "+
            			  "   FROM TB_UNCONSOLIDATEDLIST ";

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
        	log.error("Error occured in getOnlineScanningResults : "+e.getMessage());
            e.printStackTrace();
        }finally{
        	closeResources(connection, preparedStatement, resultSet);
        }
        return alMatchResult;
    }
    
    public ArrayList<HashMap<String,String>> getOnlineEntityScanning(String userCode, String entityName, String listName, String matchScore)
    {
    	Connection connection = getConnection();
        //StringBuilder l_sb;
        String queryString = "";
        double finalPerMatch = 0.0;
        ResultSet resultSet = null;
		//CallableStatement callableStatement = null;
		PreparedStatement preparedStatement = null;
        String targetName = "";
        ArrayList<HashMap<String,String>> alMatchResult = new ArrayList<HashMap<String,String>>();
        HashMap<String,String> hmMatchResult = null;
        try
        {
        	//connection = DatabaseConnectionFactory.getConnection("COMPAML");	
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
  		queryString = " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET A.MATCHEDINFO = UPPER(A.MATCHEDINFO) "+
		      		  "  WHERE A.FILENAME = '"+userCode+"'  ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();

        queryString = 
        	  " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.CUSTOMERID FROM TB_CUSTOMERMASTER B "+
	          "  WHERE UPPER(A.MATCHEDINFO) = UPPER(B.CUSTOMERNAME)) "+
	          "  WHERE A.FILENAME = '"+userCode+"'  "+
	          "    AND A.LISTNAME='OnLine' "+
	          "    AND UPPER(A.MATCHEDINFO) IN (SELECT B.CUSTOMERNAME FROM TB_CUSTOMERMASTER B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.CUSTOMERNAME)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		
		queryString = 
			 " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.SERIALNO FROM TB_UNCONSOLIDATEDLIST B "+
			 "  WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) "+
		     "  WHERE A.FILENAME = '"+userCode+"' "+
		     "    AND A.LISTNAME='UNCONSOLIDATEDLIST' "+
		     "    AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAME) FROM TB_UNCONSOLIDATEDLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		queryString = 
			" UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.DOCSERIALNO FROM TB_RBIDEFAULTERSLIST B "+
			" WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAMEOFBANK)) "+
			" WHERE A.FILENAME = '"+userCode+"'  "+
			"   AND A.LISTNAME='RBIDEFAULTERSLIST' "+
			"   AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAMEOFBANK) FROM TB_RBIDEFAULTERSLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAMEOFBANK)) ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
		
		queryString = 
			 " UPDATE TBL_ONLINENONCUSTOMERMATCHES A SET LISTID = (SELECT B.UID_ FROM TB_OFACSDNLIST B WHERE "+
			 " UPPER(A.MATCHEDINFO) = UPPER(B.NAME)) "+
			 " WHERE A.FILENAME = '"+userCode+"'  "+
			 "  AND A.LISTNAME='OFACSDNLIST' "+
			 "  AND UPPER(A.MATCHEDINFO) IN (SELECT UPPER(B.NAME) FROM TB_OFACSDNLIST B WHERE UPPER(A.MATCHEDINFO) = UPPER(B.NAME))  ";
		preparedStatement = connection.prepareStatement(queryString);
		preparedStatement.executeUpdate();
        }
        catch(Exception e)
        {
        	log.error("Error occured in getOnlineEntityScanning : "+e.getMessage());
            e.printStackTrace();
        }finally{
        	closeResources(connection, preparedStatement, resultSet);
        }
        return alMatchResult;
    }
    
   public FieldVO[] getSelectedFieldProperties(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement      = null;
       ResultSet         resultSet      = null;
       FieldVO[]         l_CFieldVOArry    = null;
       try {
    	   String l_strQueryFieldInfo = " SELECT A.COLUMNFIELDPOSITION, A.COLUMNNAME, A.COLUMNDATATYPE, A.COLUMNDATASIZE, "+
    	                                "        A.ALLOWNULL, A.DEFAULTVALUE, B.FILEFIELDSDELIMITER "+
    	                                "   FROM TB_FILEIMPORTDETAIL A, TB_FILEIMPORTMASTER B "+
    	                                "  WHERE A.FILEIMPORTID = ? "+
    	                                "    AND B.FILEIMPORTID = A.FILEIMPORTID "+
    	                                "  ORDER BY A.COLUMNFIELDPOSITION  ";
    			   
           preparedStatement = connection.prepareStatement(l_strQueryFieldInfo);            
           preparedStatement.setInt(1,a_intReportID);
           resultSet = preparedStatement.executeQuery();
		   Vector<FieldVO> l_TempVector = new Vector<FieldVO>(); 	
           while (resultSet.next()) {
               FieldVO l_CFieldProperties = new FieldVO();
               l_CFieldProperties.setFieldName(resultSet.getString("COLUMNNAME"));
               l_CFieldProperties.setFieldPos(resultSet.getInt("COLUMNFIELDPOSITION"));
               l_CFieldProperties.setDataType(resultSet.getString("COLUMNDATATYPE"));
               l_CFieldProperties.setSize(resultSet.getInt("COLUMNDATASIZE"));
               String l_strTemp = resultSet.getString("ALLOWNULL");
				
               if (l_strTemp != null && l_strTemp.equalsIgnoreCase("y"))
                   l_CFieldProperties.setNullAllowed(true); 
               else
                   l_CFieldProperties.setNullAllowed(false);
				
               l_CFieldProperties.setDefaultValue(resultSet.getString("DEFAULTVALUE"));
				String l_StrDelimiter = resultSet.getString("FILEFIELDSDELIMITER");
               l_CFieldProperties.setFieldDelimiter(getFormattedDelimiterString(l_StrDelimiter));					
               l_TempVector.add(l_CFieldProperties);
           }
			
			l_CFieldVOArry = new FieldVO[l_TempVector.size()];
			for(int i=0;i<l_CFieldVOArry.length;i++){
				l_CFieldVOArry[i] = (FieldVO)l_TempVector.get(i);
			}
			
       }catch(SQLException e){
    	   log.error("Error occured in getSelectedFieldProperties : "+e.getMessage());
       		e.printStackTrace();
		}catch(Exception e){
			log.error("Error occured in getSelectedFieldProperties : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return l_CFieldVOArry;
   }
   
   public RecordVO getSelectedRecordProperties(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement        = null;
       ResultSet         resultSet        = null;
       RecordVO  l_CRecordProperties = null;
       try {			
    	   String l_strQueryRecordInfo = " SELECT A.COLUMNFIELDPOSITION, B.FILEFIELDSDELIMITER "+
    	                                 "   FROM TB_FILEIMPORTDETAIL A, TB_FILEIMPORTMASTER B "+
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
			
           int l_intNoOfDelimiters = fieldDelimiters.size();
           String[] l_strDelimterArry = new String[l_intNoOfDelimiters]; 
           for (int i=0; i < fieldDelimiters.size(); i++) {
               l_strDelimterArry[i] = (String) fieldDelimiters.get(i);
           }
           l_CRecordProperties = new RecordVO();
           l_CRecordProperties.setRecordDelimiter(l_strDelimterArry[l_intNoOfDelimiters - 1]);
           l_CRecordProperties.setNoOfFields(recordCount);
           l_CRecordProperties.setDelimiters(l_strDelimterArry);            
       }catch(SQLException e){
    	   log.error("Error ocuured in getSelectedRecordProperties : "+e.getMessage());
       		e.printStackTrace();
		}catch(Exception e){
			log.error("Error ocuured in getSelectedRecordProperties : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
       return l_CRecordProperties;		
   }
   
   public HashMap<String,Vector<IndexFieldVO>> getSelectedIndexingInfo(int a_intReportID) {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement        = null;
       ResultSet         resultSet        = null;
	   HashMap<String,Vector<IndexFieldVO>> hashMapIndexFieldVO       = null;  
       try {			
    	    String l_strQueryReportIndex = 
    	    	" SELECT FieldName, Type AS FieldType, DataFields, IsRepeated, Delimiter "+
                "   FROM TB_EXCEPTIONLISTFIELDSINFO A, TB_EXCEPTIONLISTMASTER B "+
                "  WHERE B.FILEIMPORTID = ? "+
                "    AND B.ListCode = A.ListCode  "; 
           preparedStatement = connection.prepareStatement(l_strQueryReportIndex);
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
	   HashMap<String,IndexFieldVO>           hashMapIndexFieldVO       = null;  
       try {			
    	    String l_strQueryListCodeIndexInfo = 
    	    	" SELECT FieldName, Type AS FieldType, DataFields, IsRepeated, Delimiter "+ 
                "   FROM TB_EXCEPTIONLISTFIELDSINFO A "+
				"  WHERE UPPER(TRIM(A.ListCode)) = UPPER(TRIM(?)) "; 
           preparedStatement = connection.prepareStatement(l_strQueryListCodeIndexInfo);
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
   
   public String getSelectedListCode(int a_intReportID)
   {
	   Connection connection = getConnection();
       PreparedStatement preparedStatement        = null;
       ResultSet         resultSet        = null;
	   String            l_strListCode       = null;  
       try {			
    	   String l_strQueryListCode = " SELECT ListCode FROM TB_EXCEPTIONLISTMASTER WHERE FILEIMPORTID = ? ";
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
   
   public Collection getSelectedSearchSettings(int a_intReportID)
   {
	   Connection connection = getConnection();
        PreparedStatement preparedStatement        = null;
        ResultSet         resultSet        = null;
		ArrayList         l_alSearchList      = null;  
        try {			
            String l_strQuerySearchList = 
            	" SELECT SearchListCode, SearchLevel "+
            	"   FROM TB_EXCEPTIONLISTCODEMAPPING A , TB_EXCEPTIONLISTMASTER B "+
            	"  WHERE A.SourceListCode = B.ListCode AND B.FILEIMPORTID = ? ";
            preparedStatement = connection.prepareStatement(l_strQuerySearchList);
            preparedStatement.setInt(1,a_intReportID);
            resultSet = preparedStatement.executeQuery();
			l_alSearchList = new ArrayList();
            while (resultSet.next()) {
				SearchListVO l_CSearchListVO = new SearchListVO();
				l_CSearchListVO.setListCode(resultSet.getString("SearchListCode")); 
				l_CSearchListVO.setSearchLevel(resultSet.getString("SearchLevel"));
				l_alSearchList.add(l_CSearchListVO);
            }
        }catch(SQLException e){
        	log.error("Error occured in getSelectedSearchSettings : "+e.getMessage());
			e.printStackTrace();
		}catch(Exception e){
        	log.error("Error occured in getSelectedSearchSettings : "+e.getMessage());
			e.printStackTrace();
		}finally{	
			closeResources(connection, preparedStatement, resultSet);
		}
        return l_alSearchList;
	} 
	
   public Collection getSelectedFieldMappingInfo(int a_intReportID,String a_strListCode,String a_strUser,String a_strTemplateId,String a_isFileImport)
   {
	   Connection connection = getConnection();
    CallableStatement callableStatement        = null;
    ResultSet         resultSet        = null;
	ArrayList         l_alMappingFieldList= null;
	try {			
        callableStatement = connection.prepareCall("{call "+schemaName+"STP_FETCHSEARCHMAPPINGFIELDS(?,?,?,?,?,?)}");
        callableStatement.setInt(1,a_intReportID);
		callableStatement.setString(2,a_strListCode);
		callableStatement.setString(3,a_strUser);
		callableStatement.setString(4,a_strTemplateId);
		callableStatement.setString(5,a_isFileImport);
		// callableStatement.registerOutParameter(6, -10);
		callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
		callableStatement.execute();
        resultSet = (ResultSet)callableStatement.getObject(6);
		
		l_alMappingFieldList = new ArrayList();
		
        while (resultSet.next()) {
			MappedFieldVO l_CMappedFieldVO = new MappedFieldVO();
			l_CMappedFieldVO.setFieldType(resultSet.getString("FieldType"));
			l_CMappedFieldVO.setFieldCategory(resultSet.getString("FieldCategory")); 
			l_CMappedFieldVO.setMatchField(resultSet.getString("SearchField")); 
			l_CMappedFieldVO.setScoreLimit(resultSet.getInt("Score")); 
			l_CMappedFieldVO.setSourceField(resultSet.getString("SourceField"));
			String l_strDataFields = resultSet.getString("DataFields");
			
			StringTokenizer l_strTokens = new StringTokenizer(l_strDataFields,",");
			String[] l_strDataFieldArry = new String[l_strTokens.countTokens()];
			int intPositionIndex  = 0;  
			while(l_strTokens.hasMoreTokens()){
				l_strDataFieldArry[intPositionIndex++] = l_strTokens.nextToken();
			}
			l_CMappedFieldVO.setDataFields(l_strDataFieldArry);

			l_CMappedFieldVO.setIsRepeated(resultSet.getInt("isRepeated")==1?true:false);
			l_CMappedFieldVO.setDelimiter(resultSet.getString("Delimiter"));
			l_alMappingFieldList.add(l_CMappedFieldVO);
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

   public void saveOnlineSearchResults(Collection a_alResults,int a_intImportId,String a_strUniqueId, String a_fileName ,String isFileImport , String a_UserCode , String a_blacklistid,String a_strTemplateId)
	{
	   Connection connection = getConnection();
        CallableStatement callableStatement = null;
        try {			
        	String l_strProcPersistResult = "{call "+schemaName+"PERSISTNONCUSTOMERMATCHES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)} ";									 
        	callableStatement = connection.prepareCall(l_strProcPersistResult);	
			Iterator iterator = a_alResults.iterator();
			while(iterator.hasNext()){
				ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)iterator.next();
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
        	log.error("Error occured in saveOnlineSearchResults : "+e.getMessage());
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
		ResultSet  resultSet   = null; 
	    LinkedHashMap linkedHashMap = null;
		ArrayList arrayListRecords = new ArrayList();
		RTMatchResultVO objRTMatchResultVO = null;
		try {   
			String filename = objMatchResultVO.getFileName();
			String usercode = objMatchResultVO.getLoggedUser();
        	callableStatement  = connection.prepareCall("{call "+schemaName+"STP_GETSCANMATCHES(?,?,?,?,?,?,?,?,?,?,?,?)}");
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
			// callableStatement.registerOutParameter(12,-10);
			callableStatement.registerOutParameter(12, OracleTypes.CURSOR);
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
			objRTMatchResultVO.setUserComments(resultSet.getString("USERCOMMENTS"));
			arrayListRecords.add(objRTMatchResultVO);
			}
			linkedHashMap = new LinkedHashMap();
			linkedHashMap.put("TotalRecords",new Integer(totalRecords));
			linkedHashMap.put("ResultedRecords",arrayListRecords);
			linkedHashMap.put("FileName",filename);
			linkedHashMap.put("FileImport",objMatchResultVO.getFileImport());
		}catch(SQLException e){
			log.error("QLException in getSavedFileMatches : "+e.getMessage());
			System.out.println("SQLException in getSavedFileMatches : "+e.toString());
			e.printStackTrace();
		}catch(Exception e){
			log.error("Exception in getSavedFileMatches : "+e.getMessage());
			System.out.println("Exception in getSavedFileMatches : "+e.toString());
			e.printStackTrace();
		}finally{
			closeResources(connection, callableStatement, resultSet);
		}
		return linkedHashMap;
	}
    
	public String getComments(String uniqueNumber){
	       Connection        connection = getConnection();
	       PreparedStatement preparedStatement        = null;
	       ResultSet         resultSet        = null;
		   String            comments       = null;  
	       try {			
	    	   String l_strQueryListCode = " SELECT COMMENTS FROM "+schemaName+"TB_ONLINENONCUSTOMERCOMMENTS WHERE UNIQUEID = ? ";
	           preparedStatement = connection.prepareStatement(l_strQueryListCode);
	           preparedStatement.setString(1,uniqueNumber);
	           resultSet = preparedStatement.executeQuery();
	           while (resultSet.next()) {
	        	   comments = resultSet.getString("COMMENTS"); 
	           }
	       }catch(SQLException e){
	    	   log.error("Error occured in getComments : "+e.getMessage());
	       		e.printStackTrace();
			}catch(Exception e){
				log.error("Error occured in getComments : "+e.getMessage());
				e.printStackTrace();
			}finally{	
				closeResources(connection, preparedStatement, resultSet);
			}
	       return comments;
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
    boolean status = checkReImport(a_user,a_fileactualname.substring(0,a_fileactualname.indexOf(".")));
	if(!(status))
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
	callableStatement = connection.prepareCall("{call "+schemaName+"STP_FILEDATABULKINSERT(?,?,?,?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_reportid));
	callableStatement.setString(2,a_filedir);
	callableStatement.setString(3,strFileUpdatedName);
	callableStatement.setString(4,a_user);
	callableStatement.setString(5,a_delimiter);
	callableStatement.setString(6,a_templateid);
	callableStatement.execute();
	callableStatement.close();
	callableStatement = connection.prepareCall("{call "+schemaName+"PROC_UPDATE_TEMPTABLE(?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_reportid));
	callableStatement.setString(2,a_templateid);
	callableStatement.setString(3,a_user);
	callableStatement.execute();
	callableStatement.close();
	strResultMessage = callImportProcedure(callableStatement,procName,a_user,a_fileactualname,a_reportid,a_templateid);
	}
	} catch(Exception e)
	{
		log.warn("Data In File Is Not Proper");
	strResultMessage = "Data In File Is Not Proper";
	e.printStackTrace();
	}finally{
		closeResources(connection, callableStatement, null);
	}
	return strResultMessage;
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
	callableStatement = connection.prepareCall("{call "+schemaName+"PROC_GETCONFIGURATION(?,?,?,?)}");
	callableStatement.setInt(1,Integer.parseInt(a_ReportId));
	callableStatement.setString(2,a_TemplateID);
	//callableStatement.registerOutParameter(3,oracle.jdbc.OracleTypes.CURSOR);
    //callableStatement.registerOutParameter(4,oracle.jdbc.OracleTypes.INTEGER);
	//callableStatement.registerOutParameter(3, -10);
	callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
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

	private boolean checkReImport(String a_usercode,String a_FileName)
	{ 
	Connection connection = getConnection();
    Statement statement = null;
	ResultSet resultSet = null;
    boolean boolStatusFlag = true;
    try 
    {			
    	String l_Query = " SELECT COUNT(*) AS COUNT FROM FILEIMPORTLOG WHERE USERCODE  = '"+a_usercode+"' AND FILENAME LIKE '"+a_FileName+"%'" ;
    	statement = connection.createStatement();
        resultSet=statement.executeQuery(l_Query);
		while(resultSet.next()) 
		{
			if(resultSet.getInt(1) > 0)	
				boolStatusFlag = false;
		}
	}catch(SQLException e){
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
	
	private String retrievestprName(String a_reportid) throws SQLException 
	{
	Connection connection = getConnection();
	String strStoredProcName = null;
	PreparedStatement  preparedStatement   = null;
	ResultSet  resultSet   = null; 
	try {   
    preparedStatement  = connection.prepareStatement(" SELECT IMPORTPROCEDURENAME FROM TB_FILEIMPORTMASTER WHERE FILEIMPORTID = ?");
	preparedStatement.setInt(1,Integer.parseInt(a_reportid));
	
	resultSet  = preparedStatement.executeQuery(); 
	
	if(resultSet.next()) {
		strStoredProcName = resultSet.getString("IMPORTPROCEDURENAME");
	}	
	if( strStoredProcName == null || strStoredProcName.trim().equals(""))
		l_strResultStatusMessage = "Procedure Not Found";
	} catch(SQLException e){
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
    int intProcessedCount    =  0;
	String strResultString = null;
	try
	{
    a_CStatement = connection.prepareCall("{call "+schemaName+""+ procName +"(?,?,?,?,?)}");
	a_CStatement.setString(1,usercode);
	a_CStatement.setString(2,fileName);
	a_CStatement.setString(3,a_reportid);
	a_CStatement.setString(4,a_TemplateID);
	a_CStatement.registerOutParameter(5, -10);
	a_CStatement.execute();
	ResultSet resultSet = (ResultSet)a_CStatement.getObject(5);
	while (resultSet.next()) {
		intInsertedCounts = resultSet.getInt(1);
        intUpdatedCounts  = resultSet.getInt(2);
        intProcessedCount    = resultSet.getInt(3); 
        strResultString = "File Succesfully Imported";
        strResultString = strResultString +"^~^"+intProcessedCount+"^~^"+intInsertedCounts+"^~^"+intUpdatedCounts;
    }
	}catch(Exception e)
	{ 
		log.error("Error In Call Of Import Procedure : "+e.getMessage());
		e.printStackTrace();
		strResultString = "Error In Call Of Import Procedure";
	}finally{
		closeResources(connection, a_CStatement, null);
	}
	return strResultString;
	}

	private String[] getStringArray(String a_strText,String a_StrDelimiter){
	StringTokenizer stTokenStrings = new StringTokenizer(a_strText,a_StrDelimiter);
	String[] strArrayString = new String[stTokenStrings.countTokens()];
	int intPositionIndex = 0;
	while(stTokenStrings.hasMoreTokens()){
		strArrayString[intPositionIndex++] = stTokenStrings.nextToken(); 
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
	                        "  FROM FILEIMPORTLOG "+
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
 	finally {
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
	   String queryString = " UPDATE TBL_SWIFTMESSAGES SET USERCODE = '"+userCode+"' "+
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
	   }
	   queryString = " Select FileName, MessageType, UserCode, Count(*) CountVal "+
	   				 "   From tbl_SwiftMessages "+
                     "  Where FILENAME = '"+fileName+"' "+
                     "  Group By  FileName, MessageType, UserCode "; 
	   try
	   {
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
 	finally {
 		closeResources(connection, preparedStatement, resultSet);
 	}
 	return status;
   }
   
   public HashMap getSavedSearchValues(String a_strColumnName,String a_strColumnValue)
   {
	   Connection connection = getConnection();
       CallableStatement  callableStatement   = null;
	   ResultSet resultSet = null;
       HashMap hashMapScanData=null;
       try {
           	callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETSCANDATA(?,?,?)}");
			callableStatement.setString(1,a_strColumnName);
			callableStatement.setString(2,a_strColumnValue);
			callableStatement.registerOutParameter(3,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet=(ResultSet)callableStatement.getObject(3);
			hashMapScanData = new HashMap();
			while(resultSet.next())
			{
				hashMapScanData.put(resultSet.getString(1),resultSet.getString(2));
			}
	   }catch(SQLException e){
		   log.error("Error occured in getSavedSearchValues : "+e.getMessage());
			e.printStackTrace();
	   }catch(Exception e){
		   log.error("Error occured in getSavedSearchValues : "+e.getMessage());
			e.printStackTrace();
	   }finally{	
		    closeResources(connection, callableStatement, resultSet);
		}
	   return hashMapScanData;
   }
   
   public boolean saveOnlineRecords(String a_strColumnName,String a_strColumnValue)
	{
       CallableStatement callableStatement = null;
       boolean boolStatusFlag = false;
       Connection obJconnection = null;
   	   try {	
   		    //obJconnection = DatabaseConnectionFactory.getConnection("COMPAML");
   		    obJconnection = connectionUtil.getConnection();
   			callableStatement = obJconnection.prepareCall("{CALL "+schemaName+"STP_INSERTNONCUSTOMERDATA(?,?)}");
			callableStatement.setString(1,a_strColumnName.toUpperCase());
			callableStatement.setString(2,a_strColumnValue);
			callableStatement.execute();
			boolStatusFlag = true;
	   }catch(SQLException e){
		   log.error("Error occured in saveOnlineRecords : "+e.getMessage());
    	    System.out.println("a_strColumnName   "+a_strColumnName);
   	    	System.out.println("a_strColumnValue   "+a_strColumnValue);
	   		e.printStackTrace();
	   		boolStatusFlag = false;
	   }catch(Exception e){
		   log.error("Error occured in saveOnlineRecords : "+e.getMessage());
			System.out.println("a_strColumnName   "+a_strColumnName);
    	    System.out.println("a_strColumnValue   "+a_strColumnValue);
	   		e.printStackTrace();
	   		boolStatusFlag = false;
	}finally{	
		connectionUtil.closeResources(obJconnection, callableStatement, null, null);
	}
	return boolStatusFlag;
	}
   
   public ArrayList getSelectedListDetails(String a_listname,String a_listid,String a_viewType)
	{
	    Connection connection = getConnection();
        CallableStatement callableStatement        = null;
		ResultSet         resultSet		  = null;
		ResultSetMetaData resultSetMetaData          = null;
		ArrayList 		  arrayList		      = null;;
		try 
		{			
      		callableStatement = connection.prepareCall("{CALL "+schemaName+"PROC_GETLISTDETAILS(?,?,?,?)} ");
			callableStatement.setString(1,a_listname);
			callableStatement.setString(2,a_listid);
            callableStatement.setString(3,a_viewType);
			callableStatement.registerOutParameter(4,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet=(ResultSet)callableStatement.getObject(4);
			resultSetMetaData=resultSet.getMetaData();
			arrayList = new ArrayList();
			String columnNameArray [] = getColumnArray(resultSetMetaData);
			arrayList.add(columnNameArray);
			while(resultSet.next())
			{
				for(int i=1;i <= columnNameArray.length;i++)
				{
					switch(resultSetMetaData.getColumnType(i)){
						case Types.VARCHAR  : arrayList.add(resultSet.getString(i));																												
						                  		 break;
						case Types.CLOB     : arrayList.add(CommonUtil.clobStringConversion(resultSet.getClob(i)));																												
												 break;
						case Types.INTEGER  	: arrayList.add(String.valueOf(resultSet.getInt(i)));																												
						                  		 break;
						case Types.DATE     : arrayList.add(resultSet.getDate(i));																												
						                  		 break;
						default				 : 	arrayList.add(resultSet.getString(i));
						                    	 break;
					}	   				 
				}
			}	
			return arrayList;
		}
		catch(Exception e)
		{
		   log.error("Error occured in getSelectedListDetails : "+e.getMessage());
           System.out.println("getBlacklistDetails "+e.toString());
           e.printStackTrace();
		   return null;
		}
		finally {
           closeResources(connection, callableStatement, resultSet);
       }	
	}

   public Vector exportSavedDataToFile(MatchResultVO objMatchResultVO)
	{
	    Connection connection = getConnection();
		CallableStatement callableStatement  = null;
		ResultSet         resultSet 	= null;
		ResultSetMetaData resultSetMetaData   = null;
		Vector			  vectorList		= null;	
		String            strColumnNameArray [] = null;
		try
		{
            callableStatement = connection.prepareCall("{call "+schemaName+"STP_GETFILEDATA(?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1,objMatchResultVO.getFileName());
			callableStatement.setString(2,objMatchResultVO.getAction());
			callableStatement.setString(3,objMatchResultVO.getLoggedUser());
			callableStatement.setString(4,objMatchResultVO.getUserCode());
			callableStatement.setString(5,objMatchResultVO.getRecordStatus());
			callableStatement.setString(6,objMatchResultVO.getScanningFromDate());
			callableStatement.setString(7,objMatchResultVO.getScanningToDate());
			callableStatement.setString(8,objMatchResultVO.getProcessingFromDate());
			callableStatement.setString(9,objMatchResultVO.getProcessingToDate());
			callableStatement.registerOutParameter(10,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet=(ResultSet)callableStatement.getObject(10);
			resultSetMetaData = resultSet.getMetaData();
		    strColumnNameArray  = getColumnArray(resultSetMetaData);
		    vectorList = new Vector();
			if("Y".equalsIgnoreCase("Y"))
			{
				for(int counter=0;counter < strColumnNameArray.length ; counter++)
					vectorList.add(strColumnNameArray[counter]);
			}
			while(resultSet.next())
			{
				for(int i=1;i <= strColumnNameArray.length;i++)
				{
					switch(resultSetMetaData.getColumnType(i)){
						case Types.VARCHAR  : vectorList.add(resultSet.getString(i));																												
						                  		 break;
						case Types.INTEGER  : vectorList.add(String.valueOf(resultSet.getInt(i)));																												
						                  		 break;
						case Types.DATE     : vectorList.add(resultSet.getDate(i));																												
						                  		 break;
						default				: vectorList.add(resultSet.getString(i));
						                    	 break;
					}	   				 
				}
			}
			vectorList.add(new Integer(strColumnNameArray.length)); 
		}
		catch(Exception e)
		{
			 log.error("Error occured in exportSavedDataToFile : "+e.getMessage());
			 System.out.println("exception in fetching records for exportSavedDataToFile "+e.toString());
			 e.printStackTrace();
		}
		finally	{
			closeResources(connection, callableStatement, resultSet);
		}
		return vectorList;
	}

	public  ArrayList getSavedRecords(MatchResultVO objMatchResultVO)
	{
		Connection connection = getConnection();
		ArrayList 			arrayList = new ArrayList();
		CallableStatement	callableStatement = null;
		ResultSet 			resultSet = null;
		ResultSetMetaData 	resultSetMetaData = null;
		String              strColumnNameArray [] = null;
		try
		{
            callableStatement = connection.prepareCall("{call "+schemaName+"STP_GETFILEDATA(?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1,objMatchResultVO.getFileName());
			callableStatement.setString(2,objMatchResultVO.getAction());
			callableStatement.setString(3,objMatchResultVO.getLoggedUser());
			callableStatement.setString(4,objMatchResultVO.getUserCode());
			callableStatement.setString(5,objMatchResultVO.getRecordStatus());
			callableStatement.setString(6,objMatchResultVO.getScanningFromDate());
			callableStatement.setString(7,objMatchResultVO.getScanningToDate());
			callableStatement.setString(8,objMatchResultVO.getProcessingFromDate());
			callableStatement.setString(9,objMatchResultVO.getProcessingToDate());
			callableStatement.registerOutParameter(10,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
            resultSet = (ResultSet) callableStatement.getObject(10);
			resultSetMetaData = resultSet.getMetaData();
			strColumnNameArray  = getColumnArray(resultSetMetaData);
			
			arrayList.add(strColumnNameArray);
			 while(resultSet.next()){	
				HashMap hashMap=new HashMap();
				for(int i=0;i<strColumnNameArray.length;i++)
					hashMap.put(strColumnNameArray[i],resultSet.getString(strColumnNameArray[i]));
					arrayList.add(hashMap);
			 }
			 return arrayList;
		}
		catch(Exception e)
		{
			log.error("Exception In NameScanningOracelDAO >> getSavedRecords "+e.toString());
			System.out.println("Exception In NameScanningOracelDAO >> getSavedRecords "+e.toString());
			e.printStackTrace();
			return null;
		}
		finally{
			closeResources(connection, callableStatement, resultSet);
		}
	}
	
	public void updateActionRecord(String a_action,String a_selected,String a_userCode, String a_strFileName, String a_comments)
	{
		Connection connection = getConnection();
        CallableStatement callableStatement        = null;
		try 
		{			
            callableStatement = connection.prepareCall("{CALL "+schemaName+"PROC_UPDATESEARCHRECORD(?,?,?,?,?)} ");
			StringTokenizer l_Tokenizer = new StringTokenizer(a_selected,",");
			while(l_Tokenizer.hasMoreTokens())
			{
				callableStatement.setString(1,a_action);
				callableStatement.setString(2,l_Tokenizer.nextToken());
				callableStatement.setString(3,a_userCode);
				callableStatement.setString(4,a_strFileName);
				callableStatement.setString(5,a_comments);
				callableStatement.addBatch();
			}
			callableStatement.executeBatch();
		}
		catch(Exception e)
		{
			log.error("Error occured in updateActionRecord : "+e.getMessage());
            System.out.println("updateActionRecord "+e.toString());
		}
		finally {
            closeResources(connection, callableStatement, null);
        }	
	}

	public Vector getImportedFileNames(String a_action)
	{
		Connection connection = getConnection();
        CallableStatement  callableStatement   = null;
		ResultSet resultSet = null;
        Vector vectorList = null;
        try {
			String action = a_action.substring(0,a_action.indexOf("|"));
			String usercode = a_action.substring(a_action.indexOf("|")+1,a_action.length());			
			callableStatement = connection.prepareCall("{call "+schemaName+"STP_GETIMPORTFILENAME(?,?,?)}");
			callableStatement.setString(1,usercode);
			callableStatement.setString(2,"FileNames");
			callableStatement.registerOutParameter(3,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet=(ResultSet)callableStatement.getObject(3);
			vectorList = new Vector();
				while(resultSet.next())
				{
					vectorList.add(resultSet.getString("FILENAME"));
				}
			} 
        catch(SQLException e){
        	log.error("SQLException in getImportedFileNames: "+e.toString());
			System.out.println("SQLException in getImportedFileNames: "+e.toString());
			e.printStackTrace();
		}catch(Exception e){
			log.error("SQLException in getImportedFileNames: "+e.toString());
			System.out.println("SQLException in getImportedFileNames: "+e.toString());
			e.printStackTrace();
		}finally{	
			closeResources(connection, callableStatement, resultSet);
		}
		return vectorList;
	}
  
	public HashMap<String,Object> getSavedAuditRecords(String a_fromdate,String a_todate,String a_filename,String a_fileimport,String a_counter)	
	{
		Connection connection = getConnection();
		CallableStatement callableStatement  = null;
		ResultSet         resultSet 	= null;
		int               totalRecords	= 0;
		ResultSetMetaData resultSetMetaData   = null;
		ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		HashMap<String,Object> reportData = new HashMap<String,Object>();
		try
		{
			String filename = a_filename.substring(0,a_filename.indexOf("|"));
			String usercode = a_filename.substring(a_filename.indexOf("|")+1,a_filename.length());
			callableStatement = connection.prepareCall("{call STP_GETALRECORDS(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1,a_fromdate);
			callableStatement.setString(2,a_todate);
			callableStatement.setString(3,filename);
			callableStatement.setString(4,a_fileimport);
			callableStatement.setInt(5,Integer.parseInt(a_counter));
			callableStatement.setString(6,usercode);
			callableStatement.registerOutParameter(7,oracle.jdbc.OracleTypes.INTEGER);
			callableStatement.registerOutParameter(8,oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			totalRecords = callableStatement.getInt(7);
			resultSet=(ResultSet)callableStatement.getObject(8);

			resultSetMetaData=resultSet.getMetaData();
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
			reportData.put("TotalRecords", totalRecords);
			reportData.put("Header", l_Headers1);
			reportData.put("ReportData", arrayList);
		}
		catch(Exception e)
		{
			log.error("SQLException in getImportedFileNames: "+e.toString());
			System.out.println("SQLException in getImportedFileNames: "+e.toString());
			e.printStackTrace();
		}
		finally	{
			closeResources(connection, callableStatement, resultSet);
		}
		return reportData;
	}

	public ArrayList<HashMap<String,String>> getFieldScanSummaryDetails(String uniqueNumber, String fileName, String sbNameValuePairs, String userCode, String userRole, String ipAddress){
		Connection connection = null; 
		CallableStatement  callableStatement   = null;
		ResultSet  resultSet   = null; 
	    LinkedHashMap linkedHashMap = null;
		ArrayList arrayListRecords = new ArrayList();
		RTMatchResultVO objRTMatchResultVO = null;
        ArrayList<HashMap<String,String>> arrayList = new ArrayList<HashMap<String,String>>();
        HashMap<String,String> hashMap = null;
        //System.out.println(uniqueNumber);
		try {   
			connection = getConnection();
			callableStatement  = connection.prepareCall("{call "+schemaName+"STP_GETFIELDSCANSUMMARYDETAILS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1,uniqueNumber);
			callableStatement.setString(2,fileName);
			callableStatement.setString(3,sbNameValuePairs);
			callableStatement.setString(4,userCode);
			callableStatement.setString(5,userRole);
			callableStatement.setString(6,ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet=(ResultSet)callableStatement.getObject(7); 
			while(resultSet.next()) 
			{
				hashMap = new HashMap<String,String>();
				hashMap.put("UNIQUENUMBER", resultSet.getString("UNIQUENUMBER"));
				hashMap.put("SEQUENCENUMBER", resultSet.getString("SEQUENCENUMBER"));
				hashMap.put("FIELDNAME", resultSet.getString("FIELDNAME"));
				hashMap.put("FIELDVALUE", resultSet.getString("FIELDVALUE"));
				hashMap.put("FILENAME", resultSet.getString("FILENAME"));
				hashMap.put("COUNTOFMATCHES", resultSet.getString("COUNTOFMATCHES"));
				hashMap.put("USERCODE", resultSet.getString("USERCODE"));
				hashMap.put("USERROLE", resultSet.getString("USERROLE"));
				hashMap.put("FIELDNAME", resultSet.getString("FIELDNAME"));
				hashMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));

				arrayList.add(hashMap);	
			}
		}catch(SQLException e){
			log.error("SQLException in getFieldScanSummaryDetails : "+e.getMessage());
			System.out.println("SQLException in getFieldScanSummaryDetails : "+e.toString());
			e.printStackTrace();
		}catch(Exception e){
			log.error("Exception in getFieldScanSummaryDetails : "+e.getMessage());
			System.out.println("Exception in getFieldScanSummaryDetails : "+e.toString());
			e.printStackTrace();
		}finally{
			closeResources(connection, callableStatement, resultSet);
		}
		//System.out.println("arrayList = "+arrayList);
		return arrayList;
	}
	
	public String getUniqueNumber(String filename, String templateSeqNo) {
		Connection connection = null; 
		PreparedStatement  preparedStatement   = null;
		ResultSet  resultSet   = null; 
		String uniqueNo = "";
		try {   
			connection = connectionUtil.getConnection();
			String sql = "SELECT UNIQUENUMBER FROM "+schemaName+"TB_TEMPLATE_SCREENINGMAPPING "+
						 " WHERE SEQNO = ? AND FILENAME = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, templateSeqNo);
			preparedStatement.setString(2, filename);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				uniqueNo = resultSet.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return uniqueNo;
	}
	
	private String [] getColumnArray(ResultSetMetaData a_metadata) throws Exception
	{
			String l_ColumnNameArray [] = new String[a_metadata.getColumnCount()];
			for(int counter=0;counter<a_metadata.getColumnCount();counter++)
				l_ColumnNameArray[counter]=a_metadata.getColumnName(counter+1);
			return l_ColumnNameArray;
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
