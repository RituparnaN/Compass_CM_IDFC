package com.quantumdataengines.app.compass.dao.offlineAlerts;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class OfflineAlertsDAOImpl implements OfflineAlertsDAO {

	private Connection connection = null;
	private static final Logger log = LoggerFactory.getLogger(OfflineAlertsDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
    public Collection getListOfAlerts(String groupId, String userRole, String viewType)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String sql = "";
        List<Map<String, String>> mainList = new Vector<Map<String, String>>();
        //System.out.println("groupId = "+groupId);
		try
        {
            sql = "SELECT DISTINCT A.ALERTID, A.ALERTNAME, A.ALERTFREQUENCY, A.SOURCESYSTEM, "+
                  "       A.ALERTSUBGROUP, A.ALERTSUBGROUPORDER, A.SEQNO "+
                  "  FROM "+schemaName+"TB_OFLALERTSDETAILS A "+
                  " WHERE UPPER(TRIM(A.GROUPID)) = ? "+
                  "   AND ISENABLED = 'Y' "+ 
                  "   AND UPPER(TRIM(A.GROUPID)) = ? "+
                  " ORDER BY A.ALERTSUBGROUPORDER, A.SEQNO ";
            // if((userRole.equalsIgnoreCase("ROLE_MLRO") || userRole.equalsIgnoreCase("MLRO")) && viewType.equalsIgnoreCase("PENDING")) {
            if(userRole.contains("MLRO") && viewType.equalsIgnoreCase("PENDING")) {
                sql = "SELECT DISTINCT A.ALERTID, A.ALERTNAME, A.ALERTFREQUENCY, A.SOURCESYSTEM, "+
		              "       A.ALERTSUBGROUP, A.ALERTSUBGROUPORDER, A.SEQNO "+
		              "  FROM "+schemaName+"TB_OFLALERTSDETAILS A, (SELECT DISTINCT ALERTID FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING B WHERE STATUS = 'P') B, "+
		              "       (SELECT DISTINCT ALERTID FROM "+schemaName+"TB_OFLALERTSDETAILS_PENDING B WHERE STATUS = 'P') C "+
		              " WHERE 1 = 1 "+
		            //"   AND A.STATUS = 'P' "+
		              "   AND ( "+
		              "   ( UPPER(TRIM(A.GROUPID)) = ? "+
		              "   AND A.ALERTID = B.ALERTID "+
					 // "   AND ISENABLED = 'Y' "+
					  "   ) "+
					  "   OR "+
					  "   ( UPPER(TRIM(A.GROUPID)) = ? "+
		              "   AND A.ALERTID = C.ALERTID "+
					 // "   AND ISENABLED = 'Y' "+
					  "   ) "+
					  "      ) "+
		              " ORDER BY A.ALERTSUBGROUPORDER, A.SEQNO ";
                
                sql = "SELECT DISTINCT A.ALERTID, A.ALERTNAME, A.ALERTFREQUENCY, A.SOURCESYSTEM, "+
  		              "       A.ALERTSUBGROUP, A.ALERTSUBGROUPORDER, A.SEQNO "+
  		              "  FROM "+schemaName+"TB_OFLALERTSDETAILS A "+
  		              " WHERE UPPER(TRIM(A.GROUPID)) = ? "+
  	                  "   AND UPPER(TRIM(A.GROUPID)) = ? "+
  		              "   AND A.ALERTID IN ( "+
  	                  "       SELECT DISTINCT ALERTID FROM ( "+
  	                  "         SELECT DISTINCT ALERTID FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING B WHERE STATUS = 'P' "+
  		              "          UNION "+
  	                  "         SELECT DISTINCT ALERTID FROM "+schemaName+"TB_OFLALERTSDETAILS_PENDING B WHERE STATUS = 'P' "+
  		              "         ) "+
  		              "       ) "+
  		              " ORDER BY A.ALERTSUBGROUPORDER, A.SEQNO ";
			}
            connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, groupId.trim().toUpperCase());
            preparedStatement.setString(2, groupId.trim().toUpperCase());
            resultSet = preparedStatement.executeQuery();
            
            while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("ALERTID", resultSet.getString("ALERTID"));
				dataMap.put("ALERTNAME", resultSet.getString("ALERTNAME"));
				dataMap.put("ALERTFREQUENCY", resultSet.getString("ALERTFREQUENCY"));
				dataMap.put("SOURCESYSTEM", resultSet.getString("SOURCESYSTEM"));
				dataMap.put("ALERTSUBGROUP", resultSet.getString("ALERTSUBGROUP"));
				dataMap.put("ALERTSUBGROUPORDER", resultSet.getString("ALERTSUBGROUPORDER"));
				dataMap.put("SEQNO", resultSet.getString("SEQNO"));
				
				mainList.add(dataMap);
			}

        }
        catch(Exception e)
        {
        	log.error("Error in getListOfAlerts() - " + e.toString());
            System.out.println("Error in getListOfAlerts() - " + e.toString());
            e.printStackTrace();
        }
        finally {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return mainList;
    }

    public String getAlertName(String alertId)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String sql = "";
        String alertName = alertId;
        try
        {
            sql = "SELECT A.ALERTNAME "+
                  "  FROM "+schemaName+"TB_OFLALERTSDETAILS A "+
                  " WHERE A.ALERTID = ? ";
			
            connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, alertId.trim());
            resultSet = preparedStatement.executeQuery();
            
            while(resultSet.next()){
            	alertName = resultSet.getString("ALERTNAME");			
            }
        }
        catch(Exception e)
        {
        	log.error("Error in getAlertName() - " + e.toString());
            System.out.println("Error in getAlertName() - " + e.toString());
            e.printStackTrace();
        }
        finally {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return alertName;
    }

    @SuppressWarnings("resource")
	public Map<String, Object> getListOfAlertBenchMarks(String alertId, String userRole, String viewType)
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
			sql = "	SELECT A.ALERTPARAMNAME "+
				  "   FROM "+schemaName+"TB_OFLALERTSPARAMS A"+
				  "  WHERE A.ALERTID = ? "+
			      "  ORDER BY TO_NUMBER(A.PARAMFIELDINDEX) ASC ";
			connection = getConnection();
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, alertId.trim());
            
            resultSet = preparedStatement.executeQuery();
            header.add("ALERTSERIALID");
            header.add("ALERTAPPROVALSTATUS");
            header.add("PARAMETERTYPE");
            while(resultSet.next())
			{
				header.add(resultSet.getString("ALERTPARAMNAME"));
			}
			
			sql = "	SELECT B.USERID, A.ALERTPARAMINDEX, A.ALERTPARAMNAME, "+
	              "        A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE "+
			      "   FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES B "+
			      "  WHERE A.ALERTID = B.ALERTID "+
		          "    AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+
                  "    AND A.ALERTID = ? "+
                  "  ORDER BY B.USERID, TO_NUMBER(A.PARAMFIELDINDEX) ";
			
			sql = " SELECT X.* "+
			      "   FROM ( "+
				  "	SELECT B.USERID, A.ALERTPARAMINDEX, A.ALERTPARAMNAME, 'CONFIGURATION' PARAMETERTYPE, "+
            	  "        A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE, 'EXISTING' ALERTAPPROVALSTATUS "+
		          "   FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES B "+
		          "  WHERE A.ALERTID = B.ALERTID "+
	              "    AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+
                  "    AND A.ALERTID = ? "+
                  " UNION ALL "+
                  "	SELECT B.USERID, A.ALERTPARAMINDEX, A.ALERTPARAMNAME, 'CONFIGURATION' PARAMETERTYPE, "+
				  "        A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE, 'PENDING FOR APPROVAL' ALERTAPPROVALSTATUS "+
				  "   FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING B "+
				  "  WHERE A.ALERTID = B.ALERTID "+
				  "    AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+
			      "    AND A.ALERTID = ? "+
				  "    AND B.STATUS = 'P' "+
				  " UNION ALL "+
		          "SELECT B.USERID, A.ALERTPARAMINDEX, A.ALERTPARAMNAME, 'SIMULATION' PARAMETERTYPE, "+
		          "       A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE, 'EXISTING' ALERTAPPROVALSTATUS "+
				  "  FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+schemaName+"TB_OFLALERTSPARAMDEFVAL_SIMUL B "+ 
				  " WHERE A.ALERTID = B.ALERTID "+
			      "   AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+ 
		          "   AND A.ALERTID = ? "+
				  " ) X "+
                  "  ORDER BY X.USERID, PARAMETERTYPE, ALERTAPPROVALSTATUS, TO_NUMBER(X.PARAMFIELDINDEX) ";


			// if((userRole.equalsIgnoreCase("ROLE_MLRO") || userRole.equalsIgnoreCase("MLRO")) && viewType.equalsIgnoreCase("PENDING")) {
			// if(userRole.contains("ROLE_MLRO") && viewType.equalsIgnoreCase("PENDING")) {
			if(userRole.contains("MLRO") && viewType.equalsIgnoreCase("PENDING")) {
				sql = "	SELECT B.USERID, A.ALERTPARAMINDEX, A.ALERTPARAMNAME, "+
					  "        'CONFIGURATION' PARAMETERTYPE, A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE, 'PENDING FOR APPROVAL' ALERTAPPROVALSTATUS "+
					  "   FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING B "+
					  "  WHERE A.ALERTID = B.ALERTID "+
					  "    AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+
				      "    AND A.ALERTID = ? "+
				      "    AND A.ALERTID = ? "+
				      "    AND B.ALERTID = ? "+
					  "    AND B.STATUS = 'P' "+
				      "  ORDER BY B.USERID, ALERTAPPROVALSTATUS, TO_NUMBER(A.PARAMFIELDINDEX) ";
			}

            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, alertId.trim());
            preparedStatement.setString(2, alertId.trim());
            preparedStatement.setString(3, alertId.trim());
            resultSet = preparedStatement.executeQuery();
            
            String userId = "";
            String status = "";
            String parameterType = "";
            List<String> record = new Vector<String>();
			while(resultSet.next()){
				if(!userId.equals("") && !status.equals("") && !parameterType.equals("") && (resultSet.getString("USERID")+resultSet.getString("ALERTAPPROVALSTATUS")+resultSet.getString("PARAMETERTYPE")).equals(userId+status+parameterType))
            	{
            		record.add(resultSet.getString("PARAMDEFAULTVALUE"));
            	}
            	else
            	{
	            	if(record != null) 
	            	  data.add(record);
	            	record = new Vector<String>();
	            	userId = resultSet.getString("USERID");
	            	status = resultSet.getString("ALERTAPPROVALSTATUS");
	            	parameterType = resultSet.getString("PARAMETERTYPE");
	            	record.add(userId);
	            	record.add(status);
	            	record.add(parameterType);
	            	record.add(resultSet.getString("PARAMDEFAULTVALUE"));
	            	
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
        	log.error("Error in getListOfAlertBenchMarks() - " + e.toString());
            System.out.println("Error in getListOfAlertBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return resultData;
    }
    
    public Map<String, Object> getAlertDetails(String alertId, String userRole){
    	Map<String, Object> dataMap =  new LinkedHashMap<String, Object>();
    	Connection connection = null;
    	PreparedStatement preparedStatement = null;
    	ResultSet resultSet = null;
    	try{
    		String sql = "SELECT ALERTID, ALERTNAME, ALERTSUBGROUP, ALERTSUBGROUPORDER, "+
    					 "		 ALERTFREQUENCY, SEQNO, ISENABLED, FUN_DATETOCHAR(LASTALERTEDTRANSACTIONDATE) LASTALERTEDTRANSACTIONDATE, "+
    					 "		 SOURCESYSTEM, VERSIONNO, STATUS, MAKERCODE, MAKERCOMMENTS, "+
    					 "		 FUN_DATETOCHAR(MAKERTIMESTAMP) MAKERTIMESTAMP, MAKERIPADDRESS, CHECKERCODE, CHECKERCOMMENTS, "+
    					 "		 CHECKERIPADDRESS, FUN_DATETOCHAR(CHECKERTIMESTAMP) CHECKERTIMESTAMP "+
    					 "  FROM "+schemaName+"TB_OFLALERTSDETAILS "+
    					 " WHERE ALERTID = ? ";
    		connection = connectionUtil.getConnection();
    		preparedStatement = connection.prepareStatement(sql);
    		preparedStatement.setString(1, alertId);
    		resultSet = preparedStatement.executeQuery();
    		
    		while(resultSet.next()){
    			dataMap.put("ALERTNAME", resultSet.getString("ALERTNAME"));
    			dataMap.put("ALERTSUBGROUP", resultSet.getString("ALERTSUBGROUP"));
    			dataMap.put("ALERTSUBGROUPORDER", resultSet.getString("ALERTSUBGROUPORDER"));
    			dataMap.put("ALERTFREQUENCY", resultSet.getString("ALERTFREQUENCY"));
    			dataMap.put("SEQNO", resultSet.getString("SEQNO"));
    			dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
    			dataMap.put("LASTALERTEDTRANSACTIONDATE", resultSet.getString("LASTALERTEDTRANSACTIONDATE"));
    			dataMap.put("SOURCESYSTEM", resultSet.getString("SOURCESYSTEM"));
    			dataMap.put("VERSIONNO", resultSet.getString("VERSIONNO"));
    			dataMap.put("STATUS", resultSet.getString("STATUS"));
    			dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
    			dataMap.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
    			dataMap.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
    			dataMap.put("MAKERIPADDRESS", resultSet.getString("MAKERIPADDRESS"));
    			dataMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
    			dataMap.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
    			dataMap.put("CHECKERIPADDRESS", resultSet.getString("CHECKERIPADDRESS"));
    			dataMap.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
    		}
    		

    		if(userRole.contains("MLRO")) {
    			sql ="SELECT ALERTID, ALERTNAME, ALERTSUBGROUP, ALERTSUBGROUPORDER, "+
   					 "		 ALERTFREQUENCY, SEQNO, ISENABLED, FUN_DATETOCHAR(LASTALERTEDTRANSACTIONDATE) LASTALERTEDTRANSACTIONDATE, "+
   					 "		 SOURCESYSTEM, VERSIONNO, STATUS, MAKERCODE, MAKERCOMMENTS, "+
   					 "		 FUN_DATETOCHAR(MAKERTIMESTAMP) MAKERTIMESTAMP, MAKERIPADDRESS, CHECKERCODE, CHECKERCOMMENTS, "+
   					 "		 CHECKERIPADDRESS, FUN_DATETOCHAR(CHECKERTIMESTAMP) CHECKERTIMESTAMP "+
   					 "  FROM "+schemaName+"TB_OFLALERTSDETAILS_PENDING "+
   					 " WHERE ALERTID = ? ";
    			connection = connectionUtil.getConnection();
		   		preparedStatement = connection.prepareStatement(sql);
		   		preparedStatement.setString(1, alertId);
		   		resultSet = preparedStatement.executeQuery();
		   		
		   		while(resultSet.next()){
		   			dataMap =  new LinkedHashMap<String, Object>();
		   			dataMap.put("ALERTNAME", resultSet.getString("ALERTNAME"));
		   			dataMap.put("ALERTSUBGROUP", resultSet.getString("ALERTSUBGROUP"));
		   			dataMap.put("ALERTSUBGROUPORDER", resultSet.getString("ALERTSUBGROUPORDER"));
		   			dataMap.put("ALERTFREQUENCY", resultSet.getString("ALERTFREQUENCY"));
		   			dataMap.put("SEQNO", resultSet.getString("SEQNO"));
		   			dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
		   			dataMap.put("LASTALERTEDTRANSACTIONDATE", resultSet.getString("LASTALERTEDTRANSACTIONDATE"));
		   			dataMap.put("SOURCESYSTEM", resultSet.getString("SOURCESYSTEM"));
		   			dataMap.put("VERSIONNO", resultSet.getString("VERSIONNO"));
		   			dataMap.put("STATUS", resultSet.getString("STATUS"));
		   			dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
		   			dataMap.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
		   			dataMap.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
		   			dataMap.put("MAKERIPADDRESS", resultSet.getString("MAKERIPADDRESS"));
		   			dataMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
		   			dataMap.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
		   			dataMap.put("CHECKERIPADDRESS", resultSet.getString("CHECKERIPADDRESS"));
		   			dataMap.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
		   		}
   			}
    		
    	}catch(Exception e){
    		e.printStackTrace();
    	}finally{
    		connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    	}
    	return dataMap;
    }
    
    public String updateAlertDetailsandComments(String alertId, String alertName, String alertSubGroup, String alertSubGroupOrder, String alertFrequency, String seqNo, 
    	   String isEnabled, String lastAlertedTxnDate, String sourceSystem, String makerCode, String makerComments, String checkerCode, String checkerComments, 
    	   String status, String userCode, String userRole, String ipAddress){
    	Connection connection = null;
        CallableStatement callableStatement = null;
        ResultSet resultSet = null;
    	String result = "";
        String queryString = null;
    	try{
    		queryString = "{CALL "+schemaName+"STP_UPDATEALERTDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
    		
    		connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall(queryString);
            callableStatement.setString(1, alertId);
            callableStatement.setString(2, alertName);
            callableStatement.setString(3, alertSubGroup);
            callableStatement.setString(4, alertSubGroupOrder);
            callableStatement.setString(5, alertFrequency);
            callableStatement.setString(6, seqNo);
            callableStatement.setString(7, isEnabled);            
            callableStatement.setString(8, lastAlertedTxnDate);
            callableStatement.setString(9, sourceSystem);
            callableStatement.setString(10, makerCode);
            callableStatement.setString(11, makerComments);
            callableStatement.setString(12, checkerCode);
            callableStatement.setString(13, checkerComments);
            callableStatement.setString(14, status);
            callableStatement.setString(15, userCode);
            callableStatement.setString(16, userRole);
            callableStatement.setString(17, ipAddress);
            callableStatement.registerOutParameter(18, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(18);
            while(resultSet.next()){
            	result = resultSet.getString("RESULTMESSAGE");
            }
    	}catch(Exception e){
    		e.printStackTrace();
    		System.out.println("Error in updateAlertDetailsandComments "+e.toString());
    		result = "Error while updating details.";
    	}finally{
    		connectionUtil.closeResources(connection, callableStatement, resultSet, null);
    	}
    	return result;
    }
    
    public List<Map<String, Object>> getAlertBenchMarkDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String groupCode, String viewType)
    {
        List<Map<String, Object>> labelsList = new Vector<Map<String, Object>>();
		String tableName = ""+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES";
        String statusCondition = " AND 1 = 1 ";
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String queryString = "";
        try
        {
        	// if(( groupCode.equalsIgnoreCase("ROLE_MLRO") || groupCode.equalsIgnoreCase("MLRO")) && viewType.equalsIgnoreCase("PENDING") && !alertSerialNo.equalsIgnoreCase("DEFAULT")
        	if(groupCode.contains("MLRO") && viewType.equalsIgnoreCase("PENDING") && !alertSerialNo.equalsIgnoreCase("DEFAULT")
        	  || alertApprovalStatus.startsWith("PENDING")){
        		tableName = ""+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING";
        		statusCondition = " AND B.STATUS = 'P' ";
        	}
            connection = getConnection();
            
            queryString = " SELECT A.ALERTPARAMINDEX, A.ALERTPARAMNAME, A.ALERTPARAMALIASNAME, "+
                          "        A.ALERTPARAMDATATYPE, A.PARAMSTATICVALUES, A.PARAMFIELDINDEX, "+
                          "        CASE WHEN NVL(UPPER(TRIM(A.PARAMVALIDATINGFIELD)),'N') IN ('MULTIPLE') THEN 'Y' ELSE NVL(UPPER(TRIM(A.PARAMVALIDATINGFIELD)),'N') END AS PARAMVALIDATINGFIELD, "+
                          "        A.PARAMVALIDATIONTYPE, "+
                          "        B.PARAMDEFAULTVALUE, A.PARAMVIEWNAME "+
                          "   FROM "+schemaName+"TB_OFLALERTSPARAMS A, "+tableName+" B "+
                          "  WHERE A.ALERTID = ?  "+
                          "    AND A.ALERTID = B.ALERTID "+
                          "    AND B.USERID = ? "+
                          "    AND A.ALERTPARAMNAME = B.ALERTPARAMNAME "+
                          "    "+statusCondition +" "+
                          "   ORDER BY TO_NUMBER(A.PARAMFIELDINDEX) ";
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, alertId.trim());
            preparedStatement.setString(2, alertSerialNo.trim());
            resultSet = preparedStatement.executeQuery();
            
        	int resultCount = 0;
        	while(resultSet.next()){
        		resultCount++;
				Map<String, Object> label = new HashMap<String, Object>();
				label.put("MODULECODE", "IBAALERTS");
				label.put("MODULENAME", "IBAALERTS");
				label.put("MODULEPARAMNAME", resultSet.getString("ALERTPARAMNAME"));
				label.put("MODULEPARAMALIASNAME", resultSet.getString("ALERTPARAMALIASNAME"));
				label.put("MODULEPARAMIDNAME", resultSet.getString("ALERTPARAMNAME"));
				label.put("MODULEPARAMINDEX", resultSet.getInt("PARAMFIELDINDEX"));
				label.put("MODULEPARAMDATATYPE", resultSet.getString("ALERTPARAMDATATYPE"));
				label.put("MODULEPARAMVIEWNAME", resultSet.getString("PARAMVIEWNAME"));
				label.put("MODULEPARAMSTATICVALUES", resultSet.getString("PARAMSTATICVALUES"));
				label.put("MODULEPARAMDEFAULTVALUE", resultSet.getString("PARAMDEFAULTVALUE"));
				label.put("MODULEPARAMVALIDATIONFIELD", resultSet.getString("PARAMVALIDATINGFIELD"));
				label.put("MODULEPARAMVALIDATIONTYPE", resultSet.getString("PARAMVALIDATIONTYPE"));
				
				if("select".equalsIgnoreCase(resultSet.getString("ALERTPARAMDATATYPE").trim())){
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
        	resultCount++;
        	Map<String, Object> label = new HashMap<String, Object>();
			label.put("MODULECODE", "IBAALERTS");
			label.put("MODULENAME", "IBAALERTS");
			label.put("MODULEPARAMNAME", "AlertSerialId");
			label.put("MODULEPARAMALIASNAME", "AlertSerialId");
			label.put("MODULEPARAMIDNAME", "AlertSerialId");
			label.put("MODULEPARAMINDEX", resultCount);
			label.put("MODULEPARAMDATATYPE", "string");
			label.put("MODULEPARAMVIEWNAME", "");
			label.put("MODULEPARAMSTATICVALUES", "");
			label.put("MODULEPARAMDEFAULTVALUE", alertSerialNo.trim());
			label.put("MODULEPARAMVALIDATIONFIELD", "");
			label.put("MODULEPARAMVALIDATIONTYPE", "");
			labelsList.add(label);
        }
        catch(Exception e)
        {
        	log.error("Error in getAlertBenchMarkDetails() - " + e.toString());
            System.out.println("Error in getAlertBenchMarkDetails() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return labelsList;
    }
    
    public boolean saveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, 
    		String userCode, String userRole, String ipAddress, String userLogcomments)
	{
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        boolean boolFlag = false;
        String queryString = null;
        Iterator<String> itr = paramMap.keySet().iterator();
        int versionNo = 1000;
        
        try
        {
        	connection = getConnection();
        	queryString = " SELECT A.USERID "+
        	              "   FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
            		      "  WHERE UPPER(TRIM(A.ALERTID)) = ? "+
            		      "    AND UPPER(TRIM(A.USERID)) = ? "+
            		      "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
            preparedStatement1 = connection.prepareStatement(queryString);
            preparedStatement1.setString(1, alertId);
            preparedStatement1.setString(2, alertSerialNo);
            resultSet = preparedStatement1.executeQuery();
            if(resultSet.next())
            {
            	/*
            	queryString = " UPDATE "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
            	              "    SET A.PARAMDEFAULTVALUE = ?, "+
            	              "        A.UPDATETIMESTAMP = SYSTIMESTAMP, "+
            	              "        A.UPDATEDBY = ? "+
            	              "  WHERE A.ALERTID = ?  "+
            	              "    AND A.ALERTPARAMNAME = ? "+
            	              "    AND A.USERID = ? "+
            	              "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
            	preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
    				String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
    	            preparedStatement.setString(1, paramValue);
                    preparedStatement.setString(2, userCode);
                    preparedStatement.setString(3, alertId);
                    preparedStatement.setString(4, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(5, alertSerialNo);
                    
                    preparedStatement.addBatch();
        		}
        		*/
            	queryString = "DELETE FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING WHERE ALERTID = ? AND USERID = ? AND UPPER(USERID) NOT IN ('DEFAULT') ";
                preparedStatement2 = connection.prepareStatement(queryString);
                preparedStatement2.setString(1, alertId);
                preparedStatement2.setString(2, alertSerialNo);
                preparedStatement2.executeUpdate();

            	
            	queryString = " SELECT "+schemaName+"SEQ_OFLALERTS_BENCHMARKSETTING.NEXTVAL AS VERSIONNO FROM DUAL ";
            	preparedStatement = connection.prepareStatement(queryString);
            	resultSet = preparedStatement.executeQuery();
            	while(resultSet.next())
            		versionNo = resultSet.getInt("VERSIONNO"); 			
            	
                queryString = "INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING ( "+
                              "       ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
                              "       USERID, UPDATETIMESTAMP, UPDATEDBY, "+
                              "       REQUESTTYPE, STATUS, "+
                              "       MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS, VERSIONNO) "+
                              "VALUES(?,?,?,?,SYSTIMESTAMP,?,?,?,?,?,SYSTIMESTAMP,?,?) ";
                preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
        			String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
    	            preparedStatement.setString(1, alertId);
                    preparedStatement.setString(2, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(3, paramValue);
                    preparedStatement.setString(4, alertSerialNo);
                    preparedStatement.setString(5, userCode);
                    preparedStatement.setString(6, "UPDATE");
                    preparedStatement.setString(7, "P");
                    preparedStatement.setString(8, userCode);
                    preparedStatement.setString(9, userLogcomments);
                    preparedStatement.setString(10, ipAddress);
                    preparedStatement.setInt(11, versionNo);
                    if(!(paramName.substring(paramName.indexOf("_")+1)).equalsIgnoreCase("AlertSerialId"))
                    	preparedStatement.addBatch();
                }
                preparedStatement.executeBatch();
                boolFlag = true;
                
                /*
                queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFVALS_LOG ( "+
                              "        ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
                              "        USERID, UPDATETIMESTAMP, UPDATEDBY ) "+     
                			  " SELECT A.ALERTID, A.ALERTPARAMNAME, A.PARAMDEFAULTVALUE, "+
                              "        A.USERID, A.UPDATETIMESTAMP, A.UPDATEDBY "+
                              "   FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
                			  "  WHERE A.ALERTID = ? "+
                			  "    AND A.USERID = ? ";
                preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, alertId);
                preparedStatement.setString(2, alertSerialNo);
                preparedStatement.executeUpdate();
                */
                queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDLOG "+
                			  " SELECT * FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING "+
   				              "  WHERE ALERTID = ? "+
   				              "    AND USERID = ? ";
			    preparedStatement = connection.prepareStatement(queryString);
			    preparedStatement.setString(1, alertId);
			    preparedStatement.setString(2, alertSerialNo);
			    preparedStatement.executeUpdate();
			  
                // deleteAlertBenchMarkParameters(alertId, alertSerialNo, "UPDATE", userCode, userRole, ipAdress);
            } else
            {
            	int l_strSerialNo = 0;
                queryString = "SELECT MAX(TO_NUMBER(USERID)) MAX_USERID "+
            	              "  FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
            	              " WHERE UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
                PreparedStatement tempPreStatement = connection.prepareStatement(queryString);
                ResultSet intResultValueSet = tempPreStatement.executeQuery();
                while(intResultValueSet.next()){
                	l_strSerialNo = intResultValueSet.getInt("MAX_USERID");
                }
                
                intResultValueSet = null;
                queryString = "SELECT MAX(TO_NUMBER(USERID)) MAX_USERID "+
	              			  "  FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING A "+
	                          " WHERE UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";
                tempPreStatement = connection.prepareStatement(queryString);
                intResultValueSet = tempPreStatement.executeQuery();
                int l_strPendingSerialNo = 0;
                while(intResultValueSet.next()){
                	l_strPendingSerialNo = intResultValueSet.getInt("MAX_USERID");
                }

                if(l_strPendingSerialNo > l_strSerialNo){
                	l_strSerialNo = l_strPendingSerialNo; 
                }
                
                l_strSerialNo++;
                
                /*
                queryString = "INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES ( "+
                              "       ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
                              "       USERID, UPDATETIMESTAMP, UPDATEDBY) "+
                              " VALUES(?,?,?,?,SYSTIMESTAMP,?) ";
                
                preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
    				String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
                    preparedStatement.setString(1, alertId);
                    preparedStatement.setString(2, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(3, paramValue);
                    preparedStatement.setString(4, ""+l_strSerialNo);
                    preparedStatement.setString(5, userCode);
                    preparedStatement.addBatch();
        		}
        		*/
                
                queryString = "DELETE FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING WHERE ALERTID = ? AND USERID = ? AND UPPER(USERID) NOT IN ('DEFAULT') ";
                preparedStatement2 = connection.prepareStatement(queryString);
                preparedStatement2.setString(1, alertId);
                preparedStatement2.setString(2, ""+l_strSerialNo);
                preparedStatement2.executeUpdate();

            	
            	queryString = " SELECT "+schemaName+"SEQ_OFLALERTS_BENCHMARKSETTING.NEXTVAL AS VERSIONNO FROM DUAL ";
            	preparedStatement = connection.prepareStatement(queryString);
            	resultSet = preparedStatement.executeQuery();
            	while(resultSet.next())
            		versionNo = resultSet.getInt("VERSIONNO"); 			
            	

                queryString = "INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING ( "+
			                  "       ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
			                  "       USERID, UPDATETIMESTAMP, UPDATEDBY, "+
			                  "       REQUESTTYPE, STATUS, "+
                              "       MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS, VERSIONNO) "+
			                  "VALUES(?,?,?,?,SYSTIMESTAMP,?,?,?,?,?,SYSTIMESTAMP,?,?) ";
                preparedStatement = connection.prepareStatement(queryString);
                while(itr.hasNext()){
        			String paramName = itr.next();
    				String paramValue = paramMap.get(paramName);
    	            preparedStatement.setString(1, alertId);
                    preparedStatement.setString(2, paramName.substring(paramName.indexOf("_")+1));
                    preparedStatement.setString(3, paramValue);
                    preparedStatement.setString(4, ""+l_strSerialNo);
                    preparedStatement.setString(5, userCode);
                    preparedStatement.setString(6, "CREATE");
                    preparedStatement.setString(7, "P");
                    preparedStatement.setString(8, userCode);
                    preparedStatement.setString(9, userLogcomments);
                    preparedStatement.setString(10, ipAddress);
                    preparedStatement.setInt(11, versionNo);
                    if(!(paramName.substring(paramName.indexOf("_")+1)).equalsIgnoreCase("AlertSerialId"))
                    	preparedStatement.addBatch();
                }
                
                preparedStatement.executeBatch();                
                boolFlag = true;
                /*
                queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFVALS_LOG ( "+
                			  "        ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
                			  "        USERID, UPDATETIMESTAMP, UPDATEDBY ) "+     
                			  " SELECT A.ALERTID, A.ALERTPARAMNAME, A.PARAMDEFAULTVALUE, "+
                			  "        A.USERID, A.UPDATETIMESTAMP, A.UPDATEDBY "+
                			  "   FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
                			  "  WHERE A.ALERTID = ? "+
                			  "    AND A.USERID = ? ";

                preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, alertId);
                preparedStatement.setString(2, ""+l_strSerialNo);
                preparedStatement.executeUpdate();
                */
                queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDLOG "+
  			  				  " SELECT * FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING "+
		                      "  WHERE ALERTID = ? "+
		                      "    AND USERID = ? ";
			    preparedStatement = connection.prepareStatement(queryString);
			    preparedStatement.setString(1, alertId);
			    preparedStatement.setString(2, ""+l_strSerialNo);
			    preparedStatement.executeUpdate();

			 // deleteAlertBenchMarkParameters(alertId, ""+l_strSerialNo, "CREATE", userCode, userRole, ipAdress);
            }
        }
        catch(Exception e)
        {
        	log.error("Error in saveAlertBenchMarkParameters() - " + e.toString());
            System.out.println("Error in saveAlertBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
            connectionUtil.closeResources(null, preparedStatement, null, null);
        }
        return boolFlag;
	}

    public boolean deleteAlertBenchMarkParameters(String alertId, String alertSerialNo, String requestType, 
    		String userCode, String userRole, String ipAddress, String userLogcomments)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        int count = -1;
        String queryString = "";
        int versionNo = 1000;
        try
        {
            connection = getConnection();
        	
        	queryString = " SELECT "+schemaName+"SEQ_OFLALERTS_BENCHMARKSETTING.NEXTVAL AS VERSIONNO FROM DUAL ";
        	preparedStatement = connection.prepareStatement(queryString);
        	resultSet = preparedStatement.executeQuery();
        	while(resultSet.next())
        		versionNo = resultSet.getInt("VERSIONNO"); 			
        	
            
            queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING ( "+
            			  "        ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, USERID, "+
            			  "        UPDATETIMESTAMP, UPDATEDBY, REQUESTTYPE, STATUS, "+
                          "        MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS, VERSIONNO) "+
            			  " SELECT A.ALERTID, A.ALERTPARAMNAME, A.PARAMDEFAULTVALUE, A.USERID, "+
            			  "        A.UPDATETIMESTAMP, A.UPDATEDBY, ?, 'P', "+
            			  "        ?, ?, SYSTIMESTAMP, ?, ? "+
            			  "   FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
            			  "  WHERE A.ALERTID = ? "+
            			  "    AND A.USERID = ? ";
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, requestType);
            preparedStatement.setString(2, userCode);
            preparedStatement.setString(3, userLogcomments);
            preparedStatement.setString(4, ipAddress);
            preparedStatement.setInt(5, versionNo);
            preparedStatement.setString(6, alertId);
            preparedStatement.setString(7, alertSerialNo);
            preparedStatement.executeUpdate();
            
            queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDLOG "+
						  " SELECT * FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING "+
				          "  WHERE ALERTID = ? "+
				          "    AND USERID = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, alertId);
			preparedStatement.setString(2, alertSerialNo);
			preparedStatement.executeUpdate();

            // Commented the first temporarily to ignore maker checker role, should be uncommented if to consider maker checker
            if(!requestType.equalsIgnoreCase("DELETE"))
            //if(requestType.equalsIgnoreCase("DELETE"))
            {
            queryString = " DELETE FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
                          "  WHERE A.ALERTID = ? "+
                          "    AND A.USERID = ? "+
                          "    AND UPPER(TRIM(A.USERID)) NOT IN ('DEFAULT') ";	
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, alertId);
            preparedStatement.setString(2, alertSerialNo);
            count = preparedStatement.executeUpdate();
            }
        }
        catch(Exception e)
        {
        	log.error("Error in deleteAlertBenchMarkParameters() - " + e.toString());
            System.out.println("Error in deleteAlertBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
        connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return count >= 0;
    }

    public String generateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, 
    		String generationType, String userCode, String userRole, String ipAdress) 
	{
        Connection connection = null;
        CallableStatement callableStatement = null;
    	ResultSet resultSet = null;
        int resultCount = 0;
        String queryString = null;
        Iterator<String> itr = paramMap.keySet().iterator();
        String fromDate = null;
        String toDate = null;
		String alertSerialId = null;
		String resultMessage = "No. Of Alerts Generated : ";
		try
        {
        	connection = getConnection();
        	
            while(itr.hasNext()){
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				paramName = paramName.substring(paramName.indexOf("_")+1);
				if(paramName.equalsIgnoreCase("FROMDATE")){
					fromDate = paramValue; 
				}
				else if(paramName.equalsIgnoreCase("TODATE")){
					toDate = paramValue; 
				}
				else if(paramName.equalsIgnoreCase("ALERTSERIALID")){
					alertSerialId = paramValue; 
				}
        	}
        
        	queryString = "{CALL "+schemaName+""+getAlterStoredPrcedureName(alertId)+"(?,?,?,?,?,?,?,?)}";
        	
            callableStatement = connection.prepareCall(queryString);
            callableStatement.setString(1, fromDate);
            callableStatement.setString(2, toDate);
            callableStatement.setString(3, alertId);
            callableStatement.setString(4, alertSerialId);
            callableStatement.setString(5, userCode);
            callableStatement.setString(6, "Generation");
            callableStatement.setString(7, "");
            callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(8);
            resultSet.next();
            resultCount = resultSet.getInt(1);
            resultMessage = resultMessage + resultCount;
        }
        catch(Exception e)
        {
        	resultMessage = "Error while generating alerts for: "+alertId;
        	log.error("Error in generateAlertWithBenchMarks() - " + e.toString());
            System.out.println("Error in generateAlertWithBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally
        {
            connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return resultMessage;
	}

    public String simulateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, 
    		String generationType, String userCode, String userRole, String ipAdress) 
	{
        Connection connection = null;
        CallableStatement callableStatement = null;
    	ResultSet resultSet = null;
        int resultCount = 0;
        String queryString = null;
        Iterator<String> itr = paramMap.keySet().iterator();
        String fromDate = null;
        String toDate = null;
		String alertSerialId = null;
		String resultMessage = "No. Of Alerts Would Have Been Generated With The Defined Parameteres Are : ";
		try
        {
        	connection = getConnection();
        	
            while(itr.hasNext()){
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				paramName = paramName.substring(paramName.indexOf("_")+1);
				if(paramName.equalsIgnoreCase("FROMDATE")){
					fromDate = paramValue; 
				}
				else if(paramName.equalsIgnoreCase("TODATE")){
					toDate = paramValue; 
				}
				else if(paramName.equalsIgnoreCase("ALERTSERIALID")){
					alertSerialId = paramValue; 
				}
        	}
        
        	queryString = "{CALL "+schemaName+""+getAlterStoredPrcedureName(alertId)+"(?,?,?,?,?,?,?,?)}";
        	
            callableStatement = connection.prepareCall(queryString);
            callableStatement.setString(1, fromDate);
            callableStatement.setString(2, toDate);
            callableStatement.setString(3, alertId);
            callableStatement.setString(4, alertSerialId);
            callableStatement.setString(5, userCode);
            callableStatement.setString(6, "Simulation");
            callableStatement.setString(7, "");
            callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(8);
            resultSet.next();
            resultCount = resultSet.getInt(1);
            resultMessage = resultMessage + resultCount;
        }
        catch(Exception e)
        {
        	resultMessage = "Error while generating alerts for: "+alertId;
        	log.error("Error in generateAlertWithBenchMarks() - " + e.toString());
            System.out.println("Error in generateAlertWithBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally
        {
            connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return resultMessage;
	}
    
    public boolean approveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, 
    		String userCode, String userRole, String ipAddress, String userLogcomments)
	{
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        boolean boolFlag = false;
        String queryString = null;
        // Iterator<String> itr = paramMap.keySet().iterator();
        try
        {
        	connection = getConnection();

        	queryString = " UPDATE "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING A " +
			              "    SET A.STATUS = 'A', "+
			              "        A.STATUSUPDATEDBY = ?, "+
			              "    	   A.STATUSUPDATETIMESTAMP = SYSTIMESTAMP, "+
			              "        A.CHECKERCODE = ?, "+
			              "        A.CHECKERCOMMENTS = ?, "+
			              "        A.CHECKERTIMESTAMP = SYSTIMESTAMP, "+
			              "        A.CHECKERIPADDRESS = ? "+
			              "  WHERE A.ALERTID = ? "+
			              "    AND A.USERID = ? "+
			              "    AND A.REQUESTTYPE = ? "+ 
			              "    AND A.STATUS = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, userLogcomments);
			preparedStatement.setString(4, ipAddress);
			preparedStatement.setString(5, alertId);
			preparedStatement.setString(6, alertSerialNo);
			preparedStatement.setString(7, requestType);
			preparedStatement.setString(8, benchMarkStatus);
			preparedStatement.executeUpdate();

			queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFVALS_LOG "+
				          " SELECT A.* FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
				          "  WHERE A.ALERTID = ? "+
				          "    AND A.USERID = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, alertId);
			preparedStatement.setString(2, alertSerialNo);
			preparedStatement.executeUpdate();
			
			queryString = " DELETE FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES A "+
				          "  WHERE A.ALERTID = ? "+
				          "    AND A.USERID = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, alertId);
			preparedStatement.setString(2, alertSerialNo);
			preparedStatement.executeUpdate();

        	if(requestType.equalsIgnoreCase("CREATE") || requestType.equalsIgnoreCase("UPDATE")) {
	        	queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES( "+
	        		          "   	   ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
	        		          "        USERID, UPDATETIMESTAMP, UPDATEDBY, VERSIONNO," +
	        		          "        MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS," +
	        		          "        CHECKERCODE, CHECKERCOMMENTS, CHECKERTIMESTAMP, CHECKERIPADDRESS) "+
	        		          " SELECT ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
	        		          "        USERID, UPDATETIMESTAMP, UPDATEDBY, VERSIONNO," +
	        		          "        MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS," +
	        		          "        CHECKERCODE, CHECKERCOMMENTS, CHECKERTIMESTAMP, CHECKERIPADDRESS "+
	        		          "   FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING A "+
	        		          "  WHERE A.ALERTID = ? "+
	        		          "    AND A.USERID = ? "+
	        		          "    AND A.REQUESTTYPE = ? "+ 
	        		          "    AND A.STATUS = ? ";
	        	preparedStatement = connection.prepareStatement(queryString);
	        	preparedStatement.setString(1, alertId);
	            preparedStatement.setString(2, alertSerialNo);
	            preparedStatement.setString(3, requestType);
	            // preparedStatement.setString(4, benchMarkStatus);
	            preparedStatement.setString(4, "A");
	        	preparedStatement.executeUpdate();
        	}

        }
        catch(Exception e)
        {
        	log.error("Error in approveAlertBenchMarkParameters() - " + e.toString());
            System.out.println("Error in approveAlertBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return boolFlag;
	}

    public boolean rejectAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, 
    		String userCode, String userRole, String ipAddress, String userLogcomments)
	{
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        ResultSet resultSet = null;
        boolean boolFlag = false;
        String queryString = null;
        // Iterator<String> itr = paramMap.keySet().iterator();
        try
        {
        	connection = getConnection();
        	queryString = " UPDATE "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING A " +
                          "    SET A.STATUS = 'R', "+
                          "        A.STATUSUPDATEDBY = ?, "+
                          "        A.STATUSUPDATETIMESTAMP = SYSTIMESTAMP, "+
                          "        A.CHECKERCODE = ?, "+
                          "        A.CHECKERCOMMENTS = ?, "+
                          "        A.CHECKERTIMESTAMP = SYSTIMESTAMP, "+
                          "        A.CHECKERIPADDRESS = ? "+
              			  "  WHERE A.ALERTID = ? "+
               			  "    AND A.USERID = ? "+
            		      "    AND A.REQUESTTYPE = ? "+ 
             			  "    AND A.STATUS = ? ";
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, userCode);
            preparedStatement.setString(2, userCode);
            preparedStatement.setString(3, userLogcomments);
            preparedStatement.setString(4, ipAddress);
            preparedStatement.setString(5, alertId);
            preparedStatement.setString(6, alertSerialNo);
            preparedStatement.setString(7, requestType);
            preparedStatement.setString(8, benchMarkStatus);
            preparedStatement.executeUpdate();
            
        }
        catch(Exception e)
        {
        	log.error("Error in rejectAlertBenchMarkParameters() - " + e.toString());
            System.out.println("Error in rejectAlertBenchMarkParameters() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
            connectionUtil.closeResources(null, preparedStatement, null, null);
        }
        return boolFlag;
	}

    public List<String> getAlertSubGroup(String groupId){
		 Connection connection = null;
	     PreparedStatement preparedStatement = null;
	     ResultSet resultSet = null;
	     String sql = "";
		 List<String> dataList = new Vector<String>();
	     try{
	    	 if(groupId != null){
		    	 sql = "SELECT DISTINCT ALERTSUBGROUPORDER, ALERTSUBGROUP "+
		    		   "  FROM "+schemaName+"TB_OFLALERTSDETAILS "+
		    		   " WHERE GROUPID = '"+groupId+"'"+ 
		    		   " ORDER BY ALERTSUBGROUPORDER ";
	    	 }
	    	 connection = connectionUtil.getConnection();
	    	 preparedStatement = connection.prepareStatement(sql);
	    	 //preparedStatement.setString(1, groupId.trim().toUpperCase());
	    	 resultSet = preparedStatement.executeQuery();
	    	 while(resultSet.next()){
	    		 dataList.add(resultSet.getString("ALERTSUBGROUP"));
	    	 }
	     }catch(Exception e){
	    	 e.printStackTrace();
	     }finally{
	    	 connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
	     }
	    // System.out.println("dataList="+dataList);
	     return dataList;
	}
	
	public String getAlertGroupName(String groupId)
   {
       Connection connection = null;
       PreparedStatement preparedStatement = null;
       ResultSet resultSet = null;
       String sql = "";
       String alertGroupName = groupId;
       try
       {
           sql = "SELECT A.GROUPNAME "+
                 "  FROM "+schemaName+"TB_OFLALERTSGROUPIDMAPPING A "+
                 " WHERE A.GROUPID = ? ";

           connection = getConnection();
           preparedStatement = connection.prepareStatement(sql);
           preparedStatement.setString(1, groupId.trim());
           resultSet = preparedStatement.executeQuery();
           
           while(resultSet.next()){
        	   alertGroupName = resultSet.getString("GROUPNAME");			
           }
       }
       catch(Exception e)
       {
    	   log.error("Error in getAlertGroupName() - " + e.toString());
           System.out.println("Error in getAlertGroupName() - " + e.toString());
           e.printStackTrace();
       }
       finally {
           connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
       }
       return alertGroupName;
    }
	
	public Map<String, Object> getAlertBenchMarkStatusDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String groupCode, String viewType)
    {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String queryString = "";

        Map<String, Object> pendingStatus = new HashMap<String, Object>();
        try
        {
            pendingStatus.put("STATUS", "N.A.");
            pendingStatus.put("REQUESTTYPE", "N.A.");
            pendingStatus.put("MAKERCODE", "N.A.");
            pendingStatus.put("MAKERCOMMENTS", "N.A.");
            pendingStatus.put("MAKERTIMESTAMP", "N.A.");
            pendingStatus.put("MAKERIPADDRESS", "N.A.");
            pendingStatus.put("CHECKERCODE", "N.A.");
            pendingStatus.put("CHECKERCOMMENTS", "N.A.");
            pendingStatus.put("CHECKERTIMESTAMP", "N.A.");
            pendingStatus.put("CHECKERIPADDRESS", "N.A.");

        	queryString = "	SELECT DISTINCT STATUS, REQUESTTYPE, "+
        	              "        MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS, "+
        	              "        CHECKERCODE, CHECKERCOMMENTS, CHECKERTIMESTAMP, CHECKERIPADDRESS "+
						  "   FROM "+schemaName+"TB_OFLALERTSPARAMVALUE_PENDING A"+
						  "  WHERE A.ALERTID = ? "+
			              "    AND A.USERID = ? "+
				          "    AND A.STATUS = 'P' ";
	        connection = getConnection();
	        preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, alertId.trim());
			preparedStatement.setString(2, alertSerialNo.trim());
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				pendingStatus.put("STATUS", resultSet.getString("STATUS"));
		        pendingStatus.put("REQUESTTYPE", resultSet.getString("REQUESTTYPE"));
	            pendingStatus.put("MAKERCODE", resultSet.getString("MAKERCODE"));
	            pendingStatus.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
	            pendingStatus.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
	            pendingStatus.put("MAKERIPADDRESS", resultSet.getString("MAKERIPADDRESS"));
	            pendingStatus.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
	            pendingStatus.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
	            pendingStatus.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
	            pendingStatus.put("CHECKERIPADDRESS", resultSet.getString("CHECKERIPADDRESS"));
			}
        }
        catch(Exception e)
        {
        	log.error("Error in getAlertBenchMarkDetails() - " + e.toString());
            System.out.println("Error in getAlertBenchMarkDetails() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return pendingStatus;
    }


    private String getAlterStoredPrcedureName(String strAlertId)
    {
        ResultSet resultSet = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        String storedProcName = null;
        try{
        String sql = " SELECT A.AUTOGENERATIONPROCEDURENAME "+
                     "   FROM "+schemaName+"TB_OFLALERTSDETAILS A "+
                     "  WHERE UPPER(TRIM(A.ALERTID)) = ? ";
        
        connection = getConnection();
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, strAlertId);
        resultSet = preparedStatement.executeQuery();
        while(resultSet.next()){
        	storedProcName = resultSet.getString("AUTOGENERATIONPROCEDURENAME");
        }
        }
        catch(Exception e)
        {
        	log.error("Error in getAlterStoredPrcedureName() - " + e.toString());
            System.out.println("Error in getAlterStoredPrcedureName() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
        connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        return storedProcName;
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

    private Connection getConnection()
        throws SQLException, Exception
    {
    	// connection = DatabaseConnectionFactory.getConnection("COMPAML");
    	connection = connectionUtil.getConnection();
 	    return connection;
    }

    @SuppressWarnings("resource")
	public boolean saveAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, Map<String, String> paramMap, 
    		String userCode, String userRole, String ipAddress)
	{
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        ResultSet resultSet = null;
        boolean boolFlag = false;
        String queryString = null;
        Iterator<String> itr = paramMap.keySet().iterator();
        int versionNo = 1000;
        
        try{
        	queryString = " DELETE FROM "+schemaName+"TB_OFLALERTSPARAMDEFVAL_SIMUL A "+
				          "  WHERE A.ALERTID = ? "+
				          "    AND A.USERID = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, alertId);
			preparedStatement.setString(2, alertSerialNo);
			preparedStatement.executeUpdate();

			queryString = " SELECT "+schemaName+"SEQ_OFLALERTS_BENCHMARKSETTING.NEXTVAL AS VERSIONNO FROM DUAL ";
        	preparedStatement = connection.prepareStatement(queryString);
        	resultSet = preparedStatement.executeQuery();
        	while(resultSet.next())
        		versionNo = resultSet.getInt("VERSIONNO"); 	
        	
	      	queryString = " INSERT INTO "+schemaName+"TB_OFLALERTSPARAMDEFVAL_SIMUL( "+
	      		          "   	   ALERTID, ALERTPARAMNAME, PARAMDEFAULTVALUE, "+
	      		          "        USERID, UPDATETIMESTAMP, UPDATEDBY, VERSIONNO," +
	      		          "        MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, MAKERIPADDRESS," +
	      		          "        CHECKERCODE, CHECKERCOMMENTS, CHECKERTIMESTAMP, CHECKERIPADDRESS) "+
	      		          " VALUES (?, ?, ?, "+
	      		          "        ?, SYSTIMESTAMP, ?, ?," +
	      		          "        '','','',''," +
	      		          "        '','','','') ";
	      	preparedStatement = connection.prepareStatement(queryString);
	      	while(itr.hasNext()){
    			String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
	            preparedStatement.setString(1, alertId);
                preparedStatement.setString(2, paramName.substring(paramName.indexOf("_")+1));
                preparedStatement.setString(3, paramValue);
                preparedStatement.setString(4, alertSerialNo);
                preparedStatement.setString(5, userCode);
                preparedStatement.setInt(6, versionNo);
                if(!(paramName.substring(paramName.indexOf("_")+1)).equalsIgnoreCase("AlertSerialId"))
                	preparedStatement.addBatch();
            }
	      	preparedStatement.executeBatch();  
	      	boolFlag = true;
        }
        catch(Exception e)
        {
        	log.error("Error in saveAlertBenchMarkParamsForSimulation() - " + e.toString());
            System.out.println("Error in saveAlertBenchMarkParamsForSimulation() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
            connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
            connectionUtil.closeResources(null, preparedStatement, null, null);
        }
        return boolFlag;
	}
    
    public boolean deleteAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, String requestType, 
    		String userCode, String userRole, String ipAddress, String userLogcomments)
    {
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String queryString = "";
        boolean isDeleted = false;
        try{        	
        	queryString = "DELETE FROM "+schemaName+"TB_OFLALERTSPARAMDEFVAL_SIMUL WHERE ALERTID = ? AND USERID = ? AND UPPER(TRIM(USERID)) NOT IN ('DEFAULT') ";
            preparedStatement = connection.prepareStatement(queryString);
            preparedStatement.setString(1, alertId);
            preparedStatement.setString(2, alertSerialNo);
            int count = preparedStatement.executeUpdate();
            if(count != 0)
				isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Error in deleteAlertBenchMarkParamsForSimulation() - " + e.toString());
            e.printStackTrace();
        }
        finally 
        {
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
        System.out.println(isDeleted);
        return isDeleted;
    }
    
    
    
}
