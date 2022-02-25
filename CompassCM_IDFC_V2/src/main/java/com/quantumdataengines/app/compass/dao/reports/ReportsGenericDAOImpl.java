package com.quantumdataengines.app.compass.dao.reports;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ReportsGenericDAOImpl implements ReportsGenericDAO {
	private static final Logger log = LoggerFactory.getLogger(ReportsGenericDAOImpl.class);

	private Connection connection = null;
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Collection getListOfReports(String groupId, String userCode, String userRole)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String sql = "";
        List<Map<String, String>> mainList = new Vector<Map<String, String>>();
		try
        {
            sql = "SELECT ROWNUM AS SERIALNO, A.* FROM ( "+
            	  "SELECT DISTINCT A.REPORTID, A.REPORTNAME, "+
                  "       A.REPORTSUBGROUP, A.REPORTSUBGROUPORDER, A.SEQNO "+
                  "  FROM "+schemaName+"TB_REPORTDETAILS A "+
                  " WHERE UPPER(TRIM(A.REPORTTYPE)) = ? "+
                  "   AND ISENABLED = 'Y' "+
                  " ORDER BY A.SEQNO "+
                  " ) A ";
            if(groupId != null && groupId.equalsIgnoreCase("BUILTREPORTS")){
            sql = "SELECT ROWNUM AS SERIALNO, A.* FROM ( "+
              	  "SELECT A.REPORTID, A.REPORTNAME,  "+
                  "       A.GROUPID REPORTSUBGROUP, A.GROUPID REPORTSUBGROUPORDER, ROWNUM SEQNO "+
            	  "	 FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
                  " WHERE UPPER(GROUPID) = 'REPORT' "+
                  "   AND A.ISENABLED = 'true' ";
            sql = sql + " ORDER BY UPDATETIMESTAMP DESC, REPORTID ) A "; 
            
            }else  if(groupId != null && groupId.equalsIgnoreCase("STAFF")){
            	sql = "SELECT ROWNUM AS SERIALNO, A.* FROM ( "+
				      "SELECT DISTINCT A.REPORTID, A.REPORTNAME, " + 
            		  "       A.REPORTSUBGROUP, A.REPORTSUBGROUPORDER, A.SEQNO "+
              	      "	 FROM "+schemaName+"TB_REPORTDETAILS A "+
                      " WHERE UPPER(A.REPORTNAME) LIKE ('"+groupId+"%') "+
                      "   AND A.ISENABLED = 'Y' "+
                      " ORDER BY A.SEQNO "+
					  " ) A ";
              }
            connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            if(groupId != null && !(groupId.equalsIgnoreCase("BUILTREPORTS") || groupId.equalsIgnoreCase("STAFF"))){
                preparedStatement.setString(1, groupId.trim().toUpperCase());
            }
            resultSet = preparedStatement.executeQuery();
            
            while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("REPORTID", resultSet.getString("REPORTID"));
				dataMap.put("REPORTNAME", resultSet.getString("REPORTNAME"));
				dataMap.put("REPORTSUBGROUP", resultSet.getString("REPORTSUBGROUP"));
				dataMap.put("REPORTSUBGROUPORDER", resultSet.getString("REPORTSUBGROUPORDER"));
				dataMap.put("SEQNO", resultSet.getString("SEQNO"));
				dataMap.put("SERIALNO", resultSet.getString("SERIALNO"));
				
				mainList.add(dataMap);
			}

        }
        catch(Exception e)
        {
        	log.error("Error in getListOfReports() - " + e.toString());
            System.out.println("Error in getListOfReports() - " + e.toString());
            e.printStackTrace();
        }
        finally {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return mainList;
    }
	
	public String getReportName(String groupId, String reportId, String userCode, String userRole)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String sql = "";
        String reportName = reportId;
        try
        {
            sql = "SELECT A.REPORTNAME "+
                  "  FROM "+schemaName+"TB_REPORTDETAILS A "+
                  " WHERE A.REPORTID = ? ";
			
            if(groupId != null && groupId.equalsIgnoreCase("BUILTREPORTS")){
                sql = "SELECT A.REPORTNAME  "+
                      "	 FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
                      " WHERE A.REPORTID = ? "; 
            }
            
            connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, reportId.trim());
            resultSet = preparedStatement.executeQuery();
            
            while(resultSet.next()){
            	reportName = resultSet.getString("REPORTNAME");			
            }
        }
        catch(Exception e)
        {
        	log.error("Error in getReportName() - " + e.toString());
            System.out.println("Error in getReportName() - " + e.toString());
            e.printStackTrace();
        }
        finally {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return reportName;
    }

	public Map<String, Object> getListOfReportBenchMarks(String groupId, String reportId, String userCode, String userRole, String viewType)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String sql = "";
        
        Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
        
		try
        {
			resultSet = null;
			sql = "	SELECT A.REPORTPARAMNAME "+
				  "   FROM "+schemaName+"TB_REPORTPARAMS A"+
				  "  WHERE A.REPORTID = ? "+
			      "  ORDER BY TO_NUMBER(A.PARAMFIELDINDEX) ASC ";
			if(groupId != null && groupId.equalsIgnoreCase("BUILTREPORTS")){
                sql = "SELECT A.PARAMALIASNAME REPORTPARAMNAME "+
                      "	 FROM "+schemaName+"TB_REPORTBUILDERPARAMS A "+
                      " WHERE A.REPORTID = ? "+
                      " ORDER BY A.PARAMINDEX "; 
            }
            
			connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, reportId.trim());
            
            resultSet = preparedStatement.executeQuery();
            header.add("REPORTSERIALID");
            header.add("CONFIGURATIONCOMMENTS");
            header.add("UPDATEDBY");
            header.add("UPDATETIMESTAMP");
            while(resultSet.next())
			{
            	// Commented to remove display of benchmarks from the screen
            	// header.add(resultSet.getString("REPORTPARAMNAME"));
			}
			
			sql = "	SELECT B.USERID, NVL(B.UPDATEDBY,'DEFAULT') UPDATEDBY, NVL(FUN_DATETOCHAR(B.UPDATETIMESTAMP),'N.A.') UPDATETIMESTAMP, A.REPORTPARAMINDEX, A.REPORTPARAMNAME, "+
	              "        A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE, CONFIGURATIONCOMMENTS "+
			      "   FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
			      "  WHERE A.REPORTID = B.REPORTID "+
		          "    AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+
                  "    AND A.REPORTID = ? "+
		          "    AND (UPPER(B.USERID) IN ('DEFAULT') OR UPPER(B.UPDATEDBY) = ? ) "+
                  "  ORDER BY B.USERID, A.PARAMFIELDINDEX ";
			if(groupId != null && groupId.equalsIgnoreCase("BUILTREPORTS")){
			sql = "	SELECT 'Default' USERID, 'DEFAULT' UPDATEDBY, 'N.A.' UPDATETIMESTAMP, A.PARAMINDEX REPORTPARAMINDEX, A.PARAMALIASNAME REPORTPARAMNAME, "+
	              "        A.PARAMINDEX PARAMFIELDINDEX, A.DEFAULTVALUE PARAMDEFAULTVALUE, 'N.A.' CONFIGURATIONCOMMENTS "+
			      "   FROM "+schemaName+"TB_REPORTBUILDERPARAMS A "+
			      "  WHERE A.REPORTID = ? "+
                  "  ORDER BY A.PARAMINDEX ";
            }
			
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, reportId.trim());
            if(groupId != null && !groupId.equalsIgnoreCase("BUILTREPORTS")){
            	preparedStatement.setString(2, userCode.trim().toUpperCase());
            }
            resultSet = preparedStatement.executeQuery();
            
            String userId = "";
            List<String> record = new Vector<String>();
			while(resultSet.next()){
            	if(!userId.equals("") && resultSet.getString("USERID").equals(userId))
            	{
            		// Commented to remove display of benchmarks from the screen
                	// record.add(resultSet.getString("PARAMDEFAULTVALUE"));
            	}
            	else
            	{
            	if(record != null) 
            	  data.add(record);
            	record = new Vector<String>();
            	userId = resultSet.getString("USERID");
            	record.add(userId);
            	record.add(resultSet.getString("CONFIGURATIONCOMMENTS"));
            	record.add(resultSet.getString("UPDATEDBY"));
            	record.add(resultSet.getString("UPDATETIMESTAMP"));
            	// Commented to remove display of benchmarks from the screen
            	// record.add(resultSet.getString("PARAMDEFAULTVALUE"));
            	
            	// userId = resultSet.getString("USERID");
            	// record.add(userId);
            	}
            	}

				if(record != null){ 
					data.add(record);
				}
				resultData.put("HEADER", header);
				resultData.put("DATA", data);	
        }
        catch(Exception e)
        {
        	log.error("Error in getListOfReportBenchMarks() - " + e.toString());
            System.out.println("Error in getListOfReportBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return resultData;
    }
	
	public List<Map<String, Object>> getReportBenchMarkDetails(String groupId, String reportId, String reportSerialNo, String userCode, String userRole, String viewType)
    {
        List<Map<String, Object>> labelsList = new Vector<Map<String, Object>>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
        String sql = "";
        try
        {
        	connection = getConnection();
            
        	sql = " SELECT A.REPORTPARAMINDEX, A.REPORTPARAMNAME, A.REPORTPARAMALIASNAME, "+
                  "        A.REPORTPARAMDATATYPE, A.PARAMSTATICVALUES, A.PARAMFIELDINDEX, "+
                  "        A.PARAMVALIDATINGFIELD, A.PARAMVALIDATIONTYPE, "+
                  "        B.PARAMDEFAULTVALUE, A.PARAMVIEWNAME "+
                  "   FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
                  "  WHERE A.REPORTID = ?  "+
                  "    AND A.REPORTID = B.REPORTID "+
                  "    AND B.USERID = ? "+
                  "    AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+
                  "   ORDER BY A.PARAMFIELDINDEX ";
            if(groupId != null && groupId.equalsIgnoreCase("BUILTREPORTS")){
            
            sql = " SELECT A.PARAMINDEX REPORTPARAMINDEX, A.PARAMNAME REPORTPARAMNAME, A.PARAMALIASNAME REPORTPARAMALIASNAME, "+
                  // "        A.PARAMTYPE REPORTPARAMDATATYPE, "+
                  "        CASE WHEN A.PARAMTYPE = 'Date' THEN 'date' " +
                  "             WHEN A.PARAMTYPE = 'Number' THEN 'numeric' " +
                  "             WHEN A.PARAMTYPE = 'Text' THEN 'string' " +
                  "         END AS REPORTPARAMDATATYPE, "+
                  "        A.DEFAULTVALUE PARAMSTATICVALUES, A.PARAMINDEX PARAMFIELDINDEX, "+
                  "        '' PARAMVALIDATINGFIELD, '' PARAMVALIDATIONTYPE, "+
                  "        A.DEFAULTVALUE PARAMDEFAULTVALUE, '' PARAMVIEWNAME "+
                  "   FROM "+schemaName+"TB_REPORTBUILDERPARAMS A "+
                  "  WHERE A.REPORTID = ?  "+
                  "   ORDER BY A.PARAMINDEX ";
            }
    			
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, reportId.trim());
            if(groupId != null && !groupId.equalsIgnoreCase("BUILTREPORTS")){
                preparedStatement.setString(2, reportSerialNo.trim());
            }
            resultSet = preparedStatement.executeQuery();
            
        	while(resultSet.next()){
				Map<String, Object> label = new HashMap<String, Object>();
				label.put("MODULECODE", "REPORTSGENERIC");
				label.put("MODULENAME", "REPORTSGENERIC");
				label.put("MODULEPARAMNAME", resultSet.getString("REPORTPARAMNAME"));
				label.put("MODULEPARAMALIASNAME", resultSet.getString("REPORTPARAMALIASNAME"));
				label.put("MODULEPARAMIDNAME", resultSet.getString("REPORTPARAMNAME"));
				label.put("MODULEPARAMINDEX", resultSet.getInt("PARAMFIELDINDEX"));
				label.put("MODULEPARAMDATATYPE", resultSet.getString("REPORTPARAMDATATYPE"));
				label.put("MODULEPARAMVIEWNAME", resultSet.getString("PARAMVIEWNAME"));
				label.put("MODULEPARAMSTATICVALUES", resultSet.getString("PARAMSTATICVALUES"));
				label.put("MODULEPARAMDEFAULTVALUE", resultSet.getString("PARAMDEFAULTVALUE"));
				label.put("MODULEPARAMVALIDATIONFIELD", resultSet.getString("PARAMVALIDATINGFIELD"));
				label.put("MODULEPARAMVALIDATIONTYPE", resultSet.getString("PARAMVALIDATIONTYPE"));
				
				if("select".equalsIgnoreCase(resultSet.getString("REPORTPARAMDATATYPE").trim()) || "multiSelect".equalsIgnoreCase(resultSet.getString("REPORTPARAMDATATYPE").trim()) ){	
					Map<String, String> selectList = new LinkedHashMap<String, String>();
					if((resultSet.getString("PARAMVIEWNAME").trim() != null && !resultSet.getString("PARAMVIEWNAME").trim().equals("") && !resultSet.getString("PARAMVIEWNAME").trim().equalsIgnoreCase("NA"))){
						selectList.putAll(getOptionNameValueFromView(resultSet.getString("PARAMVIEWNAME")));
					}else{
						String paramStaticValues = resultSet.getString("PARAMSTATICVALUES").trim();
						String[] optionNameValueArr = paramStaticValues.split("\\~");
						for(String optionNameValue : optionNameValueArr){
							String [] optionArr = optionNameValue.split("\\|");
							//selectList.put(optionArr[0], optionArr[1]);
							selectList.put(optionArr[1], optionArr[0]);
						}
					}
					label.put("MODULEPARAMSELECTNAMEVALUES", selectList);
				}
				labelsList.add(label);
			}
        }
        catch(Exception e)
        {
        	log.error("Error in getReportBenchMarkDetails() - " + e.toString());
            System.out.println("Error in getReportBenchMarkDetails() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return labelsList;
    }
	
	// public boolean saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap,
	
    @SuppressWarnings("resource")
	public String saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap, 
    		String userCode, String userRole, String ipAdress, String benchmarkParameters, String configurationComments)
	{
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        ResultSet resultSet2 = null;
        boolean boolFlag = false;
        String queryString = null;
        String queryString2 = null;
        Iterator<String> itr = paramMap.keySet().iterator();
		String resultString = "";
		
		try
        {
        	connection = getConnection();
        	queryString = " SELECT A.USERID "+
        	              "   FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
            		      "  WHERE UPPER(TRIM(A.REPORTID)) = ? "+
            		      "    AND UPPER(TRIM(A.USERID)) = ? "+
            		      "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
            preparedStatement1 = connection.prepareStatement(queryString);
            preparedStatement1.setString(1, reportId.trim().toUpperCase());
            preparedStatement1.setString(2, reportSerialNo.trim().toUpperCase());
            resultSet = preparedStatement1.executeQuery();
            if(resultSet.next())
            {
            	queryString = " UPDATE "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
            	              "    SET A.PARAMDEFAULTVALUE = ?, "+
            	              "        A.UPDATETIMESTAMP = SYSTIMESTAMP, "+
            	              "        A.UPDATEDBY = ? "+
            	              "  WHERE A.REPORTID = ?  "+
            	              "    AND A.REPORTPARAMNAME = ? "+
            	              "    AND A.USERID = ? "+
            	              "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
            	preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
    				String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
    	            preparedStatement.setString(1, paramValue);
                    preparedStatement.setString(2, userCode);
                    preparedStatement.setString(3, reportId);
                    preparedStatement.setString(4, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(5, reportSerialNo);
                    
                    preparedStatement.addBatch();
        		}
                preparedStatement.executeBatch();
                
                queryString = " UPDATE "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
		      	              "    SET A.CONFIGURATIONCOMMENTS = ? "+
		      	              "  WHERE A.REPORTID = ?  "+
		      	              "    AND A.USERID = ? "+
		      	              "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
                preparedStatement = connection.prepareStatement(queryString);
	            preparedStatement.setString(1, configurationComments);
                preparedStatement.setString(2, reportId);
                preparedStatement.setString(3, reportSerialNo);
                preparedStatement.execute();
                
                boolFlag = true;
                resultString = "Configuration has been updated for the existing serialId: "+reportSerialNo;

            } else{
            	String reportUserId = "";
            	boolean isStringMatch = false;
            	queryString2 = " SELECT DISTINCT A.USERID "+
		      	               "   FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
		          		       "  WHERE UPPER(TRIM(A.REPORTID)) = ? "+
		          		       "    AND UPPER(NVL(A.UPDATEDBY,'N.A.')) = ? "+
		          		       "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') "+
		          		       "  ORDER BY USERID ";
            	preparedStatement2 = connection.prepareStatement(queryString2);
                preparedStatement2.setString(1, reportId.trim().toUpperCase());
	            preparedStatement2.setString(2, userCode.toUpperCase());
                resultSet2 = preparedStatement2.executeQuery();
                // if(!isStringMatch && resultSet2.next())
                while(!isStringMatch && resultSet2.next())	
                {
                	reportUserId = resultSet2.getString("USERID");

	            	queryString = " SELECT A.REPORTPARAMINDEX, A.REPORTPARAMNAME, A.REPORTPARAMALIASNAME, "+
	                        "        A.REPORTPARAMDATATYPE, A.PARAMSTATICVALUES, A.PARAMFIELDINDEX, "+
	                        "        A.PARAMVALIDATINGFIELD, A.PARAMVALIDATIONTYPE, "+
	                        "        B.PARAMDEFAULTVALUE, A.PARAMVIEWNAME, B.USERID  "+
	                        "   FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
	                        "  WHERE A.REPORTID = ?  "+
	                        "    AND A.REPORTID = B.REPORTID "+
	    			        "    AND UPPER(TRIM(B.USERID)) NOT IN ('DEFAULT') "+
	    			        "    AND UPPER(TRIM(A.REPORTPARAMNAME)) NOT IN ('FROMDATE', 'TODATE')"+
	                        "    AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+
	    			        "    AND UPPER(NVL(B.UPDATEDBY,'N.A.')) = ? "+
	    			        "    AND UPPER(NVL(B.USERID,'N.A.')) = ? "+
	                        "  ORDER BY B.USERID, A.PARAMFIELDINDEX ";
                  
	            	preparedStatement = connection.prepareStatement(queryString);
	            	preparedStatement.setString(1, reportId);
		            preparedStatement.setString(2, userCode.toUpperCase());
		            preparedStatement.setString(3, reportUserId);
		            resultSet = preparedStatement.executeQuery();
	            
		            String listString = "";
			        while(resultSet.next()){
		            		listString =  listString +resultSet.getString("REPORTPARAMNAME")+":"+resultSet.getString("PARAMDEFAULTVALUE")+"!^! ";
		            }
			        // System.out.println("listString: "+listString);
			        // System.out.println("benchmarkParameters: "+benchmarkParameters);
			        if(listString.equalsIgnoreCase(benchmarkParameters)){
			        	isStringMatch = true;
			        	resultString = "This configuration is already available with ReportSerialId : "+reportUserId;
			        }
	           }
 
	           if(!isStringMatch){
	        	
	        	int l_strSerialNo = 0;
                queryString = "SELECT MAX(TO_NUMBER(USERID)) MAX_USERID "+
            	              "  FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
            	              " WHERE UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
                PreparedStatement tempPreStatement = connection.prepareStatement(queryString);
                ResultSet intResultValueSet = tempPreStatement.executeQuery();
                while(intResultValueSet.next()){
                	l_strSerialNo = intResultValueSet.getInt("MAX_USERID");
                }
                
                l_strSerialNo++;
                                
                queryString = "INSERT INTO "+schemaName+"TB_REPORTPARAMDEFAULTVALUES ( "+
                              "       REPORTID, REPORTPARAMNAME, PARAMDEFAULTVALUE, "+
                              "       USERID, UPDATETIMESTAMP, UPDATEDBY, CONFIGURATIONCOMMENTS) "+
                              " VALUES(?,?,?,?,SYSTIMESTAMP,?,?) ";
                
                preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
    				String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
                    preparedStatement.setString(1, reportId);
                    preparedStatement.setString(2, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(3, paramValue);
                    preparedStatement.setString(4, ""+l_strSerialNo);
                    preparedStatement.setString(5, userCode);
                    preparedStatement.setString(6, configurationComments);
                    preparedStatement.addBatch();
        		}
                preparedStatement.executeBatch();                
                boolFlag = true;
                resultString = "New configuration has been created with ReportSerialId : "+l_strSerialNo;
            }
            }
        }    
        catch(Exception e)
        {
            resultString = "Error while creating the configuration : ";
        	log.error("Error in saveReportBenchMarkParameters() - " + e.toString());
            System.out.println("Error in saveReportBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
            connectionUtil.closeResources(null, preparedStatement, null, null);
            connectionUtil.closeResources(null, preparedStatement2, resultSet2, null);
        }
        // return boolFlag;
        return resultString;
	}

    public boolean deleteReportBenchMarkParameters(String reportId, String reportSerialNo, String requestType, 
    		String userCode, String userRole, String ipAdress)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        int count = -1;
        String queryString = "";
        try
        {
            connection = getConnection();
            
            queryString = " DELETE FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
                          "  WHERE A.REPORTID = ? "+
                          "    AND A.USERID = ? "+
                          "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";	
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, reportId);
            preparedStatement.setString(2, reportSerialNo);
            count = preparedStatement.executeUpdate();
        }
        catch(Exception e)
        {
        	log.error("Error in deleteReportBenchMarkParameters() - " + e.toString());
            System.out.println("Error in deleteReportBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
        connectionUtil.closeResources(connection, preparedStatement, null, null);
        }
        return count >= 0;
    }

    public Map<String,Object> generateReportWithBenchMarks(String groupId, String reportId, String reportSerialNo, Map<String, String> paramMap, 
    		String generationType, String userCode, String userRole, String ipAdress) 
	{
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
        Map<String, Object> reportData = new HashMap<String, Object>();
        String reportName = getReportName(groupId,reportId, userCode, userRole);
        Iterator<String> itr = paramMap.keySet().iterator();
        String procedureName = getStoredProcedureName(reportId);
		// String sql = prepareProcedureName(procedureName, paramMap);
        String sql = procedureName;
		Connection connection = null;
        CallableStatement callableStatement = null;
        PreparedStatement pstatement = null;
    	ResultSet resultSet = null;
    	Boolean success = false;
    	
    	String reportHeader = "";
        String reportFooter = "";
        String reportExecuteQuery = "";
        String queryString = "";
        String paramType = "";
        
        String columnHeaderName = "";
        
        try
        {
    		reportData.put("reportName", reportName);
            connection = getConnection();
        	int columnIndex = 0;
        	
        	if(groupId.equalsIgnoreCase("BUILTREPORTS")){
        		queryString = " SELECT REPORTNAME, REPORTHEADER, REPORTFOOTER "+
  			    			  "   FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
  			    			  //"  WHERE REPORTID = '"+reportId+"' " ;
  			    			  "  WHERE REPORTID = ? " ;
        		pstatement = connection.prepareStatement(queryString);
        		pstatement.setString(1, reportId);
        		resultSet = pstatement.executeQuery();
			    while(resultSet.next())
			    {
				  reportName = resultSet.getString("REPORTNAME");
				  reportHeader = resultSet.getString("REPORTHEADER");
				  reportFooter = resultSet.getString("REPORTFOOTER");
			    }
			    Map<String, String> paramTypeMap = new HashMap<String, String>();
				queryString = "SELECT A.PARAMNAME, A.PARAMTYPE "+
                			  "  FROM "+schemaName+"TB_REPORTBUILDERPARAMS A "+
                			  //" WHERE A.REPORTID = '"+reportId+"'  "+
                			  " WHERE A.REPORTID = ? "+
                			  " ORDER BY A.PARAMINDEX ";
			    pstatement = connection.prepareStatement(queryString);
        		pstatement.setString(1, reportId);
			    resultSet = pstatement.executeQuery();
			    while(resultSet.next())
			    {
			    	paramTypeMap.put(resultSet.getString("PARAMNAME"), resultSet.getString("PARAMTYPE")); 
			    }
			    
			    queryString = " SELECT REPORTEXECUTEQUERY "+
  							  "   FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
  							//"  WHERE REPORTID = '"+reportId+"'  " ;
  							  "  WHERE REPORTID = ? " ;
			    pstatement = connection.prepareStatement(queryString);
        		pstatement.setString(1, reportId);
			    resultSet = pstatement.executeQuery();
			    while(resultSet.next())
			    {
			    	reportExecuteQuery = resultSet.getString("REPORTEXECUTEQUERY") ;
			    }
  
            	while(itr.hasNext()){
            		columnIndex ++;
    				String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
    				paramName = paramName.substring(paramName.indexOf("_")+1);
    				paramType = paramTypeMap.get(paramName);
    				if(paramType != null){
    					if(paramType.equalsIgnoreCase("DATE")){
    						paramValue = " TO_TIMESTAMP('"+paramValue+"' , 'DD/MM/YYYY')";
    					}
    					else if(paramType.equalsIgnoreCase("NUMBER")){
    						paramValue = paramValue;
    					}
    					else {
    						paramValue = " '"+paramValue+"' ";
    					}
    					
    				}
    				reportExecuteQuery = reportExecuteQuery.replaceAll(paramName, paramValue);
    			}
              queryString = reportExecuteQuery;
              pstatement = connection.prepareStatement(queryString);
      		  resultSet = pstatement.executeQuery();
               
      		  ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
      	      String[] l_Headers=new String[resultSetMetaData.getColumnCount()];
      		  for(int i=l_Headers.length;i>=1;i--)
      		    l_Headers[i-1]=resultSetMetaData.getColumnName(i);
      				  						 	 	
      		  while(resultSet.next())
      		  {	
      			HashMap<String, String> l_DTO=new HashMap<String, String>();
      			for(int i=l_Headers.length;i>=1;i--)
      			  l_DTO.put(l_Headers[i-1],resultSet.getString(i));
      			arrayList.add(l_DTO);
      		  }
      		  reportData.put("reportName", reportName);
      		  reportData.put("reportHeader", reportHeader);
      		  reportData.put("reportFooter", reportFooter);
      		  
      		  reportData.put("Header", l_Headers);
      		  reportData.put("ReportData", arrayList);
            }
        	else {
        	callableStatement = connection.prepareCall(sql);
            	
        	while(itr.hasNext()){
        		columnIndex ++;
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				// callableStatement.setString(paramName, paramValue);
				callableStatement.setString(columnIndex, paramValue);
			}
        	columnIndex ++;
			// callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
        	callableStatement.registerOutParameter(columnIndex, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			resultSet = (ResultSet) callableStatement.getObject(columnIndex);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
  	        String[] strHeadersArray = new String[resultSetMetaData.getColumnCount()];
  		    for(int count = strHeadersArray.length; count >=1; count--)
  		    	strHeadersArray[count-1]=resultSetMetaData.getColumnName(count);
  			
  		    List<String> listExistingClumns = getExistingReportColumns(reportId, userCode, userRole, strHeadersArray);
  		    // String[] strUpdatedHeadersArray = getReportResetColumns(reportId, userCode, strHeadersArray, listExistingClumns);
  		    HashMap<String,Object> selectedColumnDetails = getReportResetColumns(reportId, userCode, userRole, strHeadersArray, listExistingClumns);
  		    
  		    String[] strUpdatedHeadersArray = (String[]) selectedColumnDetails.get("ColumnHeadersArray");
  		    HashMap<String,String> columnAliasMap = (HashMap<String,String>) selectedColumnDetails.get("ColumnAliasMap");
		    
  		    while(resultSet.next())
  		    {	
  			HashMap<String, String> hashMapData = new HashMap<String, String>();
  			for(int count = strUpdatedHeadersArray.length; count>=1; count--) {
  				columnHeaderName = strUpdatedHeadersArray[count-1];
  				// hashMapData.put(strUpdatedHeadersArray[count-1],resultSet.getString(strUpdatedHeadersArray[count-1]));
  				hashMapData.put(columnHeaderName,resultSet.getString(columnAliasMap.get(columnHeaderName)));
  				
  				//hashMapData.put(strUpdatedHeadersArray[count-1],resultSet.getString(count));
  			}
  			arrayList.add(hashMapData);
  		    }
  		    reportData.put("Header", strUpdatedHeadersArray);
  		    reportData.put("ReportData", arrayList);
        }
        	success = true;
        }
        catch(Exception e)
        {
        	success = false;
        	log.error("Error in generateReportWithBenchMarks() - " + e.toString());
            System.out.println("Error in generateReportWithBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally
        {
            connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        reportData.put("Success", success);
        return reportData;
	}

	public Map<String, String> getOptionNameValueFromView(String viewName){
		Map<String, String> selectList = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT A.* FROM "+schemaName+""+viewName+" A ";
			if(!viewName.equals("")){
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				selectList.put(resultSet.getString(1), resultSet.getString(2));
			}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return selectList;
	}
    
	public List<Map<String, String>> fetchDetailsToResetReportColumns(String reportId, String userCode, String userRole){
		List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT COLUMNNAME, ALIASNAME, COLUMNINDEX, ISENABLED FROM "+schemaName+"TB_REPORTCOLUMNS "+
						 " WHERE USERID = ? "+
						 "   AND REPORTID = ? "+
						 " ORDER BY ISENABLED DESC, COLUMNINDEX ASC ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, reportId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("COLUMNNAME", resultSet.getString("COLUMNNAME"));
				dataMap.put("ALIASNAME", resultSet.getString("ALIASNAME"));
				dataMap.put("COLUMNINDEX", resultSet.getString("COLUMNINDEX"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public String resetReportColumns(String reportId, String userCode, String userRole, String fullData){
		//allCheckbox = allCheckbox.replaceFirst(",", "");
		//allColName = allColName.replaceFirst(",", "");
		//allAliasName = allAliasName.replaceFirst(",", "");
		//allColIndex = allColIndex.replaceFirst(",", "");
		fullData = fullData.replaceFirst(";", "");
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		try{
			String sql = "UPDATE "+schemaName+"TB_REPORTCOLUMNS SET ALIASNAME = ?, COLUMNINDEX = ?, ISENABLED = ? "+
						 " WHERE USERID = ? "+
						 "   AND REPORTID = ? "+
						 "   AND COLUMNNAME = ? ";
			preparedStatement = connection.prepareStatement(sql);
		
			String[] arrFullData = CommonUtil.splitString(fullData, ";");
			for(String strFullData : arrFullData){
				String[] arrData = CommonUtil.splitString(strFullData, ",");
					if(arrData.length == 4){		
					preparedStatement.setString(1, arrData[2]);
					preparedStatement.setString(2, arrData[3]);
					preparedStatement.setString(3, arrData[0]);
					preparedStatement.setString(4, userCode);
					preparedStatement.setString(5, reportId);
					preparedStatement.setString(6, arrData[1]);
					preparedStatement.addBatch();
					}
			}		

			preparedStatement.executeBatch();
			message = "Report Columns reseted successfully";
		}catch(Exception e){
			e.printStackTrace();
			message = "Error while reseting report columns";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	private HashMap<String,Object> getReportResetColumns(String strReportId, String userCode, String userRole, String strHeadersArray[], List<String> listExistingClumns)
    {
        String queryString = "";
        String strColumnName = null;
        // int existingCount = 0;
        HashMap<String, Object> selectedColumnDetails = new HashMap<String, Object>();
        
        List<String> strSelectedHeadersList = new Vector<String>();
        Map<String, String> selectedHeadersAliasMap = new HashMap<String, String>();
        ResultSet resultSet = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String strEnabledColumnName = "";
        String strEnabledColumnAliasName = "";
        try{
        connection = getConnection();
        for(int colPosition = strHeadersArray.length; colPosition >= 1; colPosition--) {
        	strColumnName = strHeadersArray[colPosition-1];
        	if(!listExistingClumns.contains(strColumnName))
        	{
        		queryString = 
            		" INSERT INTO "+schemaName+"TB_REPORTCOLUMNS(USERID, REPORTID, COLUMNNAME, ALIASNAME, ISENABLED, COLUMNINDEX) "+
            		" VALUES(?, ?, ?, ?, ?, ?) ";
            	preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, userCode);
                preparedStatement.setString(2, strReportId);
                preparedStatement.setString(3, strColumnName);
                preparedStatement.setString(4, strColumnName);
                preparedStatement.setString(5, "Y");
                preparedStatement.setString(6, colPosition+"");
                preparedStatement.executeUpdate();	
        	/*	
        	queryString = "SELECT COUNT(1) COUNTVAL FROM "+schemaName+"TB_REPORTCOLUMNS WHERE UPPER(TRIM(REPORTID)) = ? AND USERID = ? AND COLUMNNAME = ?  ";
        	preparedStatement = connection.prepareStatement(queryString);
        	preparedStatement.setString(1, strReportId.toUpperCase());
            preparedStatement.setString(2, strUserId);
            preparedStatement.setString(3, strColumnName);
            resultSet = preparedStatement.executeQuery();
            resultSet.next();
            existingCount = resultSet.getInt("COUNTVAL");
            if(existingCount == 0){
            	queryString = 
            		" INSERT INTO "+schemaName+"TB_REPORTCOLUMNS(USERID, REPORTID, COLUMNNAME, ALIASNAME, ISENABLED, COLUMNINDEX) "+
            		" VALUES(?, ?, ?, ?, ?, ?) ";
            	preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, strUserId);
                preparedStatement.setString(2, strReportId);
                preparedStatement.setString(3, strColumnName);
                preparedStatement.setString(4, strColumnName);
                preparedStatement.setString(5, "Y");
                preparedStatement.setString(6, i+"");
                preparedStatement.executeUpdate();    	
            }
           */
           }
        }
        queryString = "SELECT A.COLUMNNAME, A.ALIASNAME "+
                      "  FROM "+schemaName+"TB_REPORTCOLUMNS A "+
                      " WHERE UPPER(TRIM(A.REPORTID)) = ? "+
                      "   AND A.USERID = ? "+
                      "   AND A.ISENABLED = ?  "+
                      " ORDER BY A.COLUMNINDEX ASC";
    	preparedStatement = connection.prepareStatement(queryString);
    	preparedStatement.setString(1, strReportId.toUpperCase());
        preparedStatement.setString(2, userCode);
        preparedStatement.setString(3, "Y");
        resultSet = preparedStatement.executeQuery();
        while(resultSet.next()){
        	strEnabledColumnName = resultSet.getString("COLUMNNAME");
        	//strEnabledColumnName = resultSet.getString("ALIASNAME");
        	strEnabledColumnAliasName = resultSet.getString("ALIASNAME");
			for(int innerCount = strHeadersArray.length; innerCount >=1; innerCount--){
	  		if(strHeadersArray[innerCount-1].equals(strEnabledColumnName)){
	  			//strSelectedHeadersList.add(strEnabledColumnName);
	  			strSelectedHeadersList.add(strEnabledColumnAliasName);
	  			selectedHeadersAliasMap.put(strEnabledColumnAliasName, strEnabledColumnName);
	  		    	}
				}
        	// strSelectedHeadersList.add(resultSet.getString("COLUMNNAME"));
        }
        // String[] strUpdatedHeadersArray = (String[]) strSelectedHeadersList.toArray();
        
        selectedColumnDetails.put("ColumnHeadersArray", strSelectedHeadersList.toArray(new String[strSelectedHeadersList.size()]));
        selectedColumnDetails.put("ColumnAliasMap", selectedHeadersAliasMap);
        
        }
        catch(Exception e)
        {
        	log.error("Error in getReportResetColumns() - " + e.toString());
            System.out.println("Error in getReportResetColumns() - " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        // return strSelectedHeadersList.toArray(new String[strSelectedHeadersList.size()]);
        return selectedColumnDetails;
     // return (String[]) strSelectedHeadersList.toArray();
    }

    private List<String> getExistingReportColumns(String strReportId, String userCode, String userRole, String strHeadersArray[])
    {
        String queryString = "";
        List<String> strSelectedHeadersList = new Vector<String>();
        ResultSet resultSet = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try{
        connection = getConnection();
        queryString = "SELECT COLUMNNAME FROM "+schemaName+"TB_REPORTCOLUMNS "+
                      " WHERE UPPER(TRIM(REPORTID)) = ? "+
                      "   AND USERID = ? "+
                      " ORDER BY COLUMNINDEX ASC";
    	preparedStatement = connection.prepareStatement(queryString);
    	preparedStatement.setString(1, strReportId.toUpperCase());
        preparedStatement.setString(2, userCode);
        resultSet = preparedStatement.executeQuery();
        while(resultSet.next()){
        	strSelectedHeadersList.add(resultSet.getString("COLUMNNAME"));
        }
        // String[] strUpdatedHeadersArray = (String[]) strSelectedHeadersList.toArray();
        }
        catch(Exception e)
        {
        	log.error("Error in resetReportColumns() - " + e.toString());
            System.out.println("Error in resetReportColumns() - " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return strSelectedHeadersList;
    }
    
    private String getStoredProcedureName(String reportId)
    {
        ResultSet resultSet = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String strStoredProcName = null;
        try{
        connection = getConnection();
        preparedStatement = connection.prepareStatement("SELECT A.REPORTPROCEDURENAME FROM "+schemaName+"TB_REPORTDETAILS A WHERE UPPER(TRIM(REPORTID)) = ? ");
        preparedStatement.setString(1, reportId.trim().toUpperCase());
        resultSet = preparedStatement.executeQuery();
        String l_strStoredProcName;
        for(l_strStoredProcName = null; resultSet.next(); l_strStoredProcName = resultSet.getString(1));
        strStoredProcName = l_strStoredProcName;
        }
        catch(Exception e)
        {
        	log.error("Error in getStoredProcedureName() - " + e.toString());
            System.out.println("Error in getStoredProcedureName() - " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return strStoredProcName;
    }

    private String prepareProcedureName(String procedureName, Map<String, String> paramMap, String userCode, String userRole){
		Iterator<String> itr = paramMap.keySet().iterator();
		String finalProcedureName = "{CALL "+schemaName+""+procedureName+"(";
		while(itr.hasNext()){
			finalProcedureName = finalProcedureName + ":"+itr.next()+",";
		}
		finalProcedureName = finalProcedureName + ":RESULTSET)}";
		return finalProcedureName;
	}

    public String generateReportXML(String a_strReportType, String l_strReportMonth, String l_strReportYear, 
    		String l_strReportFile, String l_strBatchType, String l_strOriginalBatchID, String l_strReasonOfRevision, 
    		String l_strNoOfLine, String userCode, String userRole){
    	Connection connection = null;
        CallableStatement callableStatement = null;
        String l_strMessage = ""; 
        /*System.out.println(a_strReportType);
        System.out.println(l_strReportMonth);
        System.out.println(l_strReportYear);
        System.out.println(l_strReportFile);
        System.out.println(l_strBatchType);
        System.out.println(l_strOriginalBatchID);
        System.out.println(l_strReasonOfRevision);
        System.out.println(l_strNoOfLine);
        System.out.println(userId);*/
        try {
            connection = getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATEREPORTXML(?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, a_strReportType);
            callableStatement.setString(2, l_strReportMonth);
            callableStatement.setString(3, l_strReportYear);
            callableStatement.setString(4, l_strReportFile);
            callableStatement.setString(5, l_strBatchType);
            callableStatement.setString(6, l_strOriginalBatchID);
            callableStatement.setString(7, l_strReasonOfRevision);
            callableStatement.setString(8, l_strNoOfLine);
            callableStatement.setString(9, userCode);
            callableStatement.execute();
            l_strMessage = "XML for "+a_strReportType+" has been generated in the Server.";
        } catch(Exception e) {
        	l_strMessage = "Error occured during XML generation for "+a_strReportType;
        	log.error("Error in generating generic report xml for "+a_strReportType+" : "+e.getMessage());
        	e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
    	return l_strMessage;
    }
    
    public String generateRegReportData(String a_strReportType, String l_strReportMonth, String l_strReportYear, String userCode, String userRole) {
	Connection connection = null;
    CallableStatement callableStatement = null;
    String l_strMessage = ""; 
    try {
        connection = getConnection();
        callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATEREGREPORTDATA(?,?,?,?)}");
        callableStatement.setString(1, a_strReportType);
        callableStatement.setString(2, l_strReportMonth);
        callableStatement.setString(3, l_strReportYear);
        callableStatement.setString(4, userCode);
        callableStatement.execute();
        l_strMessage = "Data for "+a_strReportType+" has been generated.";
    } catch(Exception e) {
    	l_strMessage = "Error occured during data generation for "+a_strReportType;
    	log.error("Error in generating generic data for "+a_strReportType+" : "+e.getMessage());
    	e.printStackTrace();
    }finally{
    	connectionUtil.closeResources(connection, callableStatement, null, null);
    }
	return l_strMessage;
   
    }

    public List<Map<String, String>> chooseReportFile(String reportType, String reportMonth, String reportYear, String userCode, String userRole){
    	List<Map<String, String>> listReportFile = new Vector<Map<String, String>>();
    	Connection connection = null;
    	CallableStatement callableStatement = null;
    	ResultSet resultSet = null;
    	try{
    		connection = getConnection();
    		callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETREPORTINGFILE(?,?,?,?)}");
    		callableStatement.setString(1, reportType);
    		callableStatement.setString(2, reportMonth);
    		callableStatement.setString(3, reportYear);
    		callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
    		callableStatement.execute();
    		resultSet = (ResultSet) callableStatement.getObject(4);
    		while (resultSet.next()) {
				Map<String, String> reportFilenamesMap = new LinkedHashMap<String, String>();
				reportFilenamesMap.put("FILENAME", resultSet.getString("FILENAME"));
				reportFilenamesMap.put("UPLOADTIMESTMP", resultSet.getString("UPLOADTIMESTMP"));
				listReportFile.add(reportFilenamesMap);
			}
    	}catch(Exception e){
    		log.error("Error while getting the Report file list : "+e.getMessage());
    		e.printStackTrace();
    	}finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
    	System.out.println(listReportFile);
    	return listReportFile;
    }

    public HashMap<String,Object> RegMISReportData(String reportType, String reportingMonth, String reportingYear, String batchType, String reportedDate, String recordsCount, String originalBatchID, String reasonOfRevision, String actionType, String userCode, String userRole){
    	HashMap<String,Object> reportdata = new HashMap<String,Object>();
    	Connection connection = null;
    	CallableStatement callableStatement = null;
    	ResultSet resultSet = null;
    	try{
    		connection = getConnection();
    		callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETSETREGREPORTMISDATA(?,?,?,?,?,?,?,?,?,?,?)}");
    		callableStatement.setString(1, reportType);
    		callableStatement.setString(2, reportingMonth);
    		callableStatement.setString(3, reportingYear);
    		callableStatement.setString(4, batchType);
    		callableStatement.setString(5, reportedDate);
    		callableStatement.setString(6, recordsCount);
    		callableStatement.setString(7, originalBatchID);
    		callableStatement.setString(8, reasonOfRevision);
    		callableStatement.setString(9, actionType);
    		callableStatement.setString(10, userCode);
    		callableStatement.registerOutParameter(11, OracleTypes.CURSOR);
    		callableStatement.execute();
    		resultSet = (ResultSet) callableStatement.getObject(11);
    		while (resultSet.next()) {
    			reportdata = new HashMap<String,Object>();
				reportdata.put("REPORTTYPE", resultSet.getString("REPORTTYPE"));
				reportdata.put("REPORTINGMONTH", resultSet.getString("REPORTINGMONTH"));
				reportdata.put("REPORTINGYEAR", resultSet.getString("REPORTINGYEAR"));
				reportdata.put("BATCHTYPE", resultSet.getString("BATCHTYPE"));
				reportdata.put("REPORTEDDATE", resultSet.getString("REPORTEDDATE"));
				reportdata.put("RECORDSCOUNT", resultSet.getString("RECORDSCOUNT"));
				reportdata.put("ORIGINALBATCHID", resultSet.getString("ORIGINALBATCHID"));
				reportdata.put("REASONOFREVISION", resultSet.getString("REASONOFREVISION"));
				reportdata.put("ACTIONTYPE", resultSet.getString("ACTIONTYPE"));
				reportdata.put("USERID", resultSet.getString("UPDATEDBY"));
			}
    	}catch(Exception e){
    		log.error("Error while getting the Report file list : "+e.getMessage());
    		e.printStackTrace();
    	}finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
    	return reportdata;
    }
    
    private Connection getConnection() throws SQLException, Exception
    {
    	// connection = DatabaseConnectionFactory.getConnection("COMPAML");
    	connection = connectionUtil.getConnection();
 	    return connection;
    }
    
    public List<String> getReportFileData(String tableName, String userCode, String userRole){
    	List<String> filedata = new Vector<String>();
    	Connection connection = null;
    	PreparedStatement preparedStatement = null;
    	ResultSet resultSet = null;
    	try{
    		connection = getConnection();
    		preparedStatement = connection.prepareStatement("SELECT CHARACTERSET FROM "+schemaName+""+tableName+" ORDER BY SEQNO");
    		resultSet = preparedStatement.executeQuery();
    		while (resultSet.next()) {
    			filedata.add(resultSet.getString("CHARACTERSET"));
			}
    	}catch(Exception e){
    		log.error("Error while getting the Report file list : "+e.getMessage());
    		e.printStackTrace();
    	}finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
    	return filedata;
    }
    
    public Map<String, Object> getConsolidatedReportTabView(String fromDate, String toDate, String userCode, String userRole, String reportFrequency){
    	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETMISREPORTDATA_NEW(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, reportFrequency);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(15, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(16, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(17, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(18, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(19, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(20, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(21, oracle.jdbc.OracleTypes.CURSOR);

            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(6);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+7;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(resultSetMetaData.getColumnName(i));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    }
		    	
	    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
	    	innerMap.put("listResultHeader", headerList);
	    	innerMap.put("listResultData", resultList);
	    	mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		return mainMap;
    }
    
    public String logReportGenerationRequest(String userCode, String userRole, String ipAddress, String viewType, String reportId, String reportParameter){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
    	ResultSet resultSet = null;
    	String logReportGenerationRequest = "";
    	try{
    		connection = connectionUtil.getConnection();
    		callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_LOGREPORTGENERATIONREQUEST(?,?,?,?,?,?,?)}");
    		callableStatement.setString(1, userCode);
    		callableStatement.setString(2, userRole);
    		callableStatement.setString(3, ipAddress);
    		callableStatement.setString(4, viewType);
    		callableStatement.setString(5, reportId);
    		callableStatement.setString(6, reportParameter);
    		callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
    		callableStatement.execute();
    		resultSet = (ResultSet) callableStatement.getObject(7);
    		while (resultSet.next()) {
    			logReportGenerationRequest = resultSet.getString("RESULTMESSAGE");
			}
    	}catch(Exception e){
    		log.error("Error while getting the Report file list : "+e.getMessage());
    		e.printStackTrace();
    	}finally{
    		connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
    	return logReportGenerationRequest;
	}
	
	public List<Map<String, Object>> getStaffReportParams(String reportId, String userCode, String userRole, String ipAddress){
    	List<Map<String, Object>> labelsList = new Vector<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETSTAFFREPORTPARAMETERS(?,?,?,?,?)}");
			callableStatement.setString(1, reportId);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(5);
			while(resultSet.next()){
				
				Map<String, Object> label = new HashMap<String, Object>();
				label.put("MODULECODE", resultSet.getString("REPORTID"));
				label.put("MODULENAME", resultSet.getString("REPORTNAME"));
				label.put("MODULEPARAMNAME", resultSet.getString("REPORTPARAMNAME"));
				label.put("MODULEPARAMALIASNAME", resultSet.getString("REPORTPARAMALIASNAME"));
				label.put("MODULEPARAMIDNAME", resultSet.getString("REPORTPARAMNAME"));
				label.put("MODULEPARAMINDEX", resultSet.getInt("PARAMFIELDINDEX"));
				label.put("MODULEPARAMDATATYPE", resultSet.getString("REPORTPARAMDATATYPE"));
				label.put("MODULEPARAMVIEWNAME", resultSet.getString("PARAMVIEWNAME"));
				label.put("MODULEPARAMSTATICVALUES", resultSet.getString("PARAMSTATICVALUES"));
				label.put("MODULEPARAMDEFAULTVALUE", resultSet.getString("PARAMDEFAULTVALUE"));
				label.put("MODULEPARAMVALIDATIONFIELD", resultSet.getString("PARAMVALIDATINGFIELD"));
				label.put("MODULEPARAMVALIDATIONTYPE", resultSet.getString("PARAMVALIDATIONTYPE"));				
				
				if("select".equalsIgnoreCase(resultSet.getString("REPORTPARAMDATATYPE").trim())){
					Map<String, String> selectList = new LinkedHashMap<String, String>();
					if((resultSet.getString("PARAMVIEWNAME").trim() != null && !resultSet.getString("PARAMVIEWNAME").trim().equals("") && !resultSet.getString("PARAMVIEWNAME").trim().equalsIgnoreCase("NA"))){
						selectList.putAll(getOptionNameValueFromView(resultSet.getString("PARAMVIEWNAME")));
					}else{
						String paramStaticValues = resultSet.getString("PARAMSTATICVALUES").trim();
						String[] optionNameValueArr = paramStaticValues.split("\\~");
						for(String optionNameValue : optionNameValueArr){
							String [] optionArr = optionNameValue.split("\\|");
							selectList.put(optionArr[1], optionArr[0]);
						}
					}
					label.put("MODULEPARAMSELECTNAMEVALUES", selectList);
				}
				labelsList.add(label);

			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return labelsList;
    }
  
    public Map<String, Object> getStaffMonitoringReportsData(String reportId, Map<String, String> paramDataMap, String userCode, String userRole, String ipAddress){
//		String reportId = paramDataMap.get("reportId");
//		paramDataMap.remove("reportId");
    	String procedureName = getStoredProcedureName(reportId);
		//System.out.println("repId = "+reportId+" "+procedureName+" "+paramDataMap);
		
		Iterator<String> itr = paramDataMap.keySet().iterator();
		String sql = prepareProcedureName(procedureName, paramDataMap, userCode, userRole);
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		//System.out.println(paramDataMap);
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		int columnIndex = 0;
		try{
			callableStatement = connection.prepareCall(procedureName);
			
			while(itr.hasNext()){
				columnIndex ++;
				String paramName = itr.next();
				String paramValue = paramDataMap.get(paramName);
				callableStatement.setString(columnIndex, paramValue);
				//System.out.println("paramsDao = "+paramName+"|[]|"+paramValue);
			}
			columnIndex++;
			/*callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);*/
			callableStatement.registerOutParameter(columnIndex, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(columnIndex);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}
			
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		//System.out.println(resultData);
		return resultData;
	}
    
    public Map<String, Object> getReportData(String groupId, String reportId, String reportSerialNo, Map<String, String> paramMap, 
    		String generationType, String userCode, String userRole, String ipAddress){
		String procedureName = getStoredProcedureName(reportId);
		System.out.println(reportId+" "+procedureName);
		
		Iterator<String> itr = paramMap.keySet().iterator();
	    String sql = procedureName;
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> columnList = new ArrayList<String>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Map<String,String> columnDetails = new LinkedHashMap<String,String>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		int columnIndex = 0;
		try{
			callableStatement = connection.prepareCall(sql);
			while(itr.hasNext()){
        		columnIndex ++;
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);

				callableStatement.setString(columnIndex, paramValue);
			}
        	columnIndex ++;
        	callableStatement.setString(columnIndex, userCode);
        	columnIndex ++;
        	callableStatement.setString(columnIndex, userRole);
        	columnIndex ++;
        	callableStatement.setString(columnIndex, ipAddress);
        	columnIndex ++;
        	

        	callableStatement.registerOutParameter(columnIndex, OracleTypes.CURSOR);
			callableStatement.execute();
			
			
			
			resultSet = (ResultSet) callableStatement.getObject(columnIndex);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}
		
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}

 }
