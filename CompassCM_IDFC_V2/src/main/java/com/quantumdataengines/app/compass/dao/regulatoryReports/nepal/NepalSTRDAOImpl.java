package com.quantumdataengines.app.compass.dao.regulatoryReports.nepal;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import oracle.jdbc.internal.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class NepalSTRDAOImpl implements NepalSTRDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> fetchNepalSTRData(String caseNo, String userCode, String ipAddress, String CURRENTROLE){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETNEPALSTRDATA(?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, CURRENTROLE);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			
			callableStatement.execute();
			ResultSet resultSet = (ResultSet) callableStatement.getObject(5);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return dataMap;
	}
	
	@SuppressWarnings("resource")
	public String saveNEPAL_STR(Map<String,String> paramMap, String caseNo, String userCode){
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql = "UPDATE "+schemaName+"TB_NEPAL_STR SET NEPSTRREPINSTNAME = ?, NEPSTRCUSTNAME = ?, NEPSTRCUSTADDRESS = ?, NEPSTRCUSTPROFESSION = ?, "+
						  "		  NEPSTRCUSTNATIONALITY = ?, NEPSTRCUSTOTHERACCNO = ?, NEPSTRCUSTOTHERBSNS = ?, NEPSTRCUSTGUARDIANNAME = ?, "+
						  "		  NEPSTRCUSTDOB = ?, NEPSTRACCORTXNNO = ?, NEPSTRACCORTXNNATURE= ?, "+
						  "		  NEPSTROWNERSHIPNATURE = ?, NEPSTRTXNDATE = ?, NEPSTROTHERACCTXNNO = ?, "+
						  "		  NEPSTRAMOUNT = ?, NEPSTROTHERACCTXNDETAIL = ?, NEPSTRREASONFORSUSPICION = ?, "+
						  "		  NEPSTROTHERSUSRSNDETAIL = ?, NEPSTRRSNSUMMARY = ?, NEPSTRSUSACTINFO = ?, NEPSTRIMPACTONBANK = ?, "+
						  "		  NEPSTRCOMPLOFFISIGN = ?, NEPSTRNEPSTRCOMPLOFFINAME = ?, NEPSTRACTIONDATE = ?, NEPSTRCOMPLOFFIPHNO = ?, "+
						  "		  NEPSTRCOMPLOFFIEMAIL = ?, NEPSTRCOMPLOFFIFAX = ?, UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+ 
						  " WHERE CASENO = ? " ;
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, paramMap.get("NEPSTRREPINSTNAME"));
					preparedStatement.setString(2, paramMap.get("NEPSTRCUSTNAME"));
					preparedStatement.setString(3, paramMap.get("NEPSTRCUSTADDRESS"));
					preparedStatement.setString(4, paramMap.get("NEPSTRCUSTPROFESSION"));
					preparedStatement.setString(5, paramMap.get("NEPSTRCUSTNATIONALITY"));
					preparedStatement.setString(6, paramMap.get("NEPSTRCUSTOTHERACCNO"));
					preparedStatement.setString(7, paramMap.get("NEPSTRCUSTOTHERBSNS"));
					preparedStatement.setString(8, paramMap.get("NEPSTRCUSTGUARDIANNAME"));
					preparedStatement.setString(9, paramMap.get("NEPSTRCUSTDOB"));
					preparedStatement.setString(10, paramMap.get("NEPSTRACCORTXNNO"));
					
					preparedStatement.setString(11, paramMap.get("NEPSTRACCORTXNNATURE"));
					preparedStatement.setString(12, paramMap.get("NEPSTROWNERSHIPNATURE"));
					preparedStatement.setString(13, paramMap.get("NEPSTRTXNDATE"));
					preparedStatement.setString(14, paramMap.get("NEPSTROTHERACCTXNNO"));
					preparedStatement.setString(15, paramMap.get("NEPSTRAMOUNT"));
					preparedStatement.setString(16, paramMap.get("NEPSTROTHERACCTXNDETAIL"));
					preparedStatement.setString(17, paramMap.get("NEPSTRREASONFORSUSPICION"));
					preparedStatement.setString(18, paramMap.get("NEPSTROTHERSUSRSNDETAIL"));
					preparedStatement.setString(19, paramMap.get("NEPSTRRSNSUMMARY"));
					preparedStatement.setString(20, paramMap.get("NEPSTRSUSACTINFO"));
					
					preparedStatement.setString(21, paramMap.get("NEPSTRIMPACTONBANK"));
					preparedStatement.setString(22, paramMap.get("NEPSTRCOMPLOFFISIGN"));
					preparedStatement.setString(23, paramMap.get("NEPSTRNEPSTRCOMPLOFFINAME"));
					preparedStatement.setString(24, paramMap.get("NEPSTRACTIONDATE"));
					preparedStatement.setString(25, paramMap.get("NEPSTRCOMPLOFFIPHNO"));
					preparedStatement.setString(26, paramMap.get("NEPSTRCOMPLOFFIEMAIL"));
					preparedStatement.setString(27, paramMap.get("NEPSTRCOMPLOFFIFAX"));
					preparedStatement.setString(28, userCode);
					preparedStatement.setString(29, caseNo);
					preparedStatement.executeUpdate();
					response ="Successfully updated.";
					
		
		}catch(Exception e){
			response="Error while saving/updating NEPAL STR.";
			
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return response;
	}
	
	public Map<String, Object> getNepalSTRXMLFileContent(String caseNo, String userCode, String ipAddress, String CURRENTROLE){
		HashMap l_HMSTRXMLFileDetails = new HashMap();
		LinkedHashMap l_HMSTRXMLFileContent = new LinkedHashMap();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null;
		ResultSet resultSet2 = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_EXPORTNEPALSTRXMLFILE(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet1 = (ResultSet)callableStatement.getObject(3);
            resultSet2 = (ResultSet)callableStatement.getObject(4);
            if(resultSet1.next()){
            	l_HMSTRXMLFileDetails.put("FILENAME", resultSet1.getString(1));
            }
            while(resultSet2.next()){
            	l_HMSTRXMLFileContent.put(resultSet2.getString(1), resultSet2.getString(2));
            }
            l_HMSTRXMLFileDetails.put("FILECONTENT", l_HMSTRXMLFileContent);
		}catch(Exception e){
			System.out.println("Exception in NepalSTRDAOImpl -> getNepalSTRXMLFileContent, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		return l_HMSTRXMLFileDetails;
	}

}
