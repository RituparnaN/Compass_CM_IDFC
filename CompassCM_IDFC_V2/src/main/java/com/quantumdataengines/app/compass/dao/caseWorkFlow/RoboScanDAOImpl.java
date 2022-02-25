package com.quantumdataengines.app.compass.dao.caseWorkFlow;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RoboScanDAOImpl implements RoboScanDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<String> getRoboscanConfigDetails(String roleId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<String> dataList = new ArrayList<String>();
		String queryString = "";
		try{
			queryString = " SELECT UPPER(SELECTEDPARTS) SELECTEDPARTS "+
			              "   FROM "+schemaName+"TB_ROBOSCANCONFIG "+
			              "  WHERE ROLEID = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, roleId.replaceAll("ROLE_", ""));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				String allSelectedParts = resultSet.getString("SELECTEDPARTS") != null ? resultSet.getString("SELECTEDPARTS") : "";
				String[] partsArr = allSelectedParts.split(",");
				if(partsArr.length > 0)
					for(String selectedParts : partsArr){
						if(!"".equals(selectedParts)){
							dataList.add(selectedParts);
						}
					}
				}
			//System.out.println(dataList);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	@Override
	public Map<String, Object> fetchRoboscanData(String caseNos, String userCode, String ipAddress, String CURRENTROLE) {
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETROBOSCANDATA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNos);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, CURRENTROLE);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(11, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(12, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(13, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(14, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(15, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(16, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(17, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(18, OracleTypes.CURSOR);

			callableStatement.execute();
			
			//FOR FETCHING DATA OF HEADER 
			ResultSet resultSetHeader = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData headerMetaData = resultSetHeader.getMetaData();
			Map<String, String> roboscanHeader = new LinkedHashMap<String, String>();
			while(resultSetHeader.next()){
				for(int colIndex = 1; colIndex <= headerMetaData.getColumnCount(); colIndex++){
					String columnName = headerMetaData.getColumnName(colIndex);
					roboscanHeader.put(columnName, resultSetHeader.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-1 ALERT DETAILS 
			ResultSet resultSetSection1 = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData section1MetaData = resultSetSection1.getMetaData();
			Map<String, Object> roboscanSection1 = new LinkedHashMap<String, Object>();
			List<String> alertHeaders = new Vector<String>();
			List<List<String>> alertData = new Vector<List<String>>();
			for(int colIndex = 1; colIndex <= section1MetaData.getColumnCount(); colIndex++){
				alertHeaders.add(section1MetaData.getColumnName(colIndex));
			}
			while(resultSetSection1.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= section1MetaData.getColumnCount(); colIndex++){
					String columnName = section1MetaData.getColumnName(colIndex);
					record.add(resultSetSection1.getString(columnName));
				}
				alertData.add(record);
			}
			roboscanSection1.put("HEADER", alertHeaders);
			roboscanSection1.put("DATA", alertData);
			
			//FOR FETCHING DATA OF SECTION-2 KYC
			ResultSet resultSetSection2 = (ResultSet) callableStatement.getObject(7);
			ResultSetMetaData section2MetaData = resultSetSection2.getMetaData();
			Map<String, String> roboscanSection2 = new LinkedHashMap<String, String>();
			while(resultSetSection2.next()){
				for(int colIndex = 1; colIndex <= section2MetaData.getColumnCount(); colIndex++){
					String columnName = section2MetaData.getColumnName(colIndex);
					roboscanSection2.put(columnName, resultSetSection2.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-3 REAL TIME SCANNING
			ResultSet resultSetSection3 = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData section3MetaData = resultSetSection3.getMetaData();
			Map<String, String> roboscanSection3 = new LinkedHashMap<String, String>();
			while(resultSetSection3.next()){
				for(int colIndex = 1; colIndex <= section3MetaData.getColumnCount(); colIndex++){
					String columnName = section3MetaData.getColumnName(colIndex);
					roboscanSection3.put(columnName, resultSetSection3.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-4 TRANSACTION DETAILS
			ResultSet resultSetSection4 = (ResultSet) callableStatement.getObject(9);
			ResultSetMetaData section4MetaData = resultSetSection4.getMetaData();
			Map<String, Object> roboscanSection4 = new LinkedHashMap<String, Object>();
			List<String> txnHeaders = new Vector<String>();
			List<List<String>> txnData = new Vector<List<String>>();
			for(int colIndex = 1; colIndex <= section4MetaData.getColumnCount(); colIndex++){
				txnHeaders.add(section4MetaData.getColumnName(colIndex));
			}
			while(resultSetSection4.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= section4MetaData.getColumnCount(); colIndex++){
					String columnName = section4MetaData.getColumnName(colIndex);
					record.add(resultSetSection4.getString(columnName));
				}
				txnData.add(record);
			}
			roboscanSection4.put("HEADER", txnHeaders);
			roboscanSection4.put("DATA", txnData);
			
			/*ResultSet sectionThree = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData section4MetaData = sectionThree.getMetaData();
			Map<String, String> roboscanSection4 = new LinkedHashMap<String, String>();
			while(sectionThree.next()){
				for(int colIndex = 1; colIndex <= section4MetaData.getColumnCount(); colIndex++){
					String columnName = section4MetaData.getColumnName(colIndex);
					roboscanSection4.put(columnName, sectionThree.getString(columnName));
				}
			}*/
			
			
			//FOR FETCHING DATA OF SECTION-5 ACCOUNT PROFILING
			ResultSet resultSetSection5 = (ResultSet) callableStatement.getObject(10);
			ResultSetMetaData section5MetaData = resultSetSection5.getMetaData();
			Map<String, String> roboscanSection5 = new LinkedHashMap<String, String>();
			while(resultSetSection5.next()){
				for(int colIndex = 1; colIndex <= section5MetaData.getColumnCount(); colIndex++){
					String columnName = section5MetaData.getColumnName(colIndex);
					roboscanSection5.put(columnName, resultSetSection5.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-6 ENTITY LINK
			ResultSet resultSetSection6 = (ResultSet) callableStatement.getObject(11);
			ResultSetMetaData section6MetaData = resultSetSection6.getMetaData();
			Map<String, String> roboscanSection6 = new LinkedHashMap<String, String>();
			while(resultSetSection6.next()){
				for(int colIndex = 1; colIndex <= section6MetaData.getColumnCount(); colIndex++){
					String columnName = section6MetaData.getColumnName(colIndex);
					roboscanSection6.put(columnName, resultSetSection6.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-7 PAST HISTORY
			ResultSet resultSetSection7 = (ResultSet) callableStatement.getObject(12);
			ResultSetMetaData sectionSixMetaData = resultSetSection7.getMetaData();
			Map<String, String> roboscanSection7 = new LinkedHashMap<String, String>();
			while(resultSetSection7.next()){
				for(int colIndex = 1; colIndex <= sectionSixMetaData.getColumnCount(); colIndex++){
					String columnName = sectionSixMetaData.getColumnName(colIndex);
					roboscanSection7.put(columnName, resultSetSection7.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-8 RELATED PARTIES
			ResultSet resultSetSection8 = (ResultSet) callableStatement.getObject(13);
			ResultSetMetaData section8MetaData = resultSetSection8.getMetaData();
			Map<String, String> roboscanSection8 = new LinkedHashMap<String, String>();
			while(resultSetSection8.next()){
				for(int colIndex = 1; colIndex <= section8MetaData.getColumnCount(); colIndex++){
					String columnName = section8MetaData.getColumnName(colIndex);
					roboscanSection8.put(columnName, resultSetSection8.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-9 RING SIDE VIEW
			ResultSet resultSetSection9 = (ResultSet) callableStatement.getObject(14);
			ResultSetMetaData section9MetaData = resultSetSection9.getMetaData();
			Map<String, String> roboscanSection9 = new LinkedHashMap<String, String>();
			while(resultSetSection9.next()){
				for(int colIndex = 1; colIndex <= section9MetaData.getColumnCount(); colIndex++){
					String columnName = section9MetaData.getColumnName(colIndex);
					roboscanSection9.put(columnName, resultSetSection9.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF SECTION-10 CUSTOMER CASE HISTORY DETAILS
			ResultSet resultSetSection10 = (ResultSet) callableStatement.getObject(15);
			ResultSetMetaData section10MetaData = resultSetSection10.getMetaData();
			Map<String, Object> roboscanSection10 = new LinkedHashMap<String, Object>();
			List<String> custCaseHistoryHeaders = new Vector<String>();
			List<List<String>> custCaseHistoryData = new Vector<List<String>>();
			for(int colIndex = 1; colIndex <= section10MetaData.getColumnCount(); colIndex++){
				custCaseHistoryHeaders.add(section10MetaData.getColumnName(colIndex));
			}
			while(resultSetSection10.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= section10MetaData.getColumnCount(); colIndex++){
					String columnName = section10MetaData.getColumnName(colIndex);
					record.add(resultSetSection10.getString(columnName));
				}
				custCaseHistoryData.add(record);
			}
			roboscanSection10.put("HEADER", custCaseHistoryHeaders);
			roboscanSection10.put("DATA", custCaseHistoryData);
			
			//FOR FETCHING DATA OF SECTION-11 USER COMMENTS
			ResultSet resultSetSection11 = (ResultSet) callableStatement.getObject(16);
			ResultSetMetaData section11MetaData = resultSetSection11.getMetaData();
			Map<String, String> roboscanSection11 = new LinkedHashMap<String, String>();
			while(resultSetSection11.next()){
				for(int colIndex = 1; colIndex <= section11MetaData.getColumnCount(); colIndex++){
					String columnName = section11MetaData.getColumnName(colIndex);
					roboscanSection11.put(columnName, resultSetSection11.getString(columnName));
				}
			}
			
			// FOR FETCHING DATA OF SECTION-12 ACTIONS
			ResultSet resultSetSection12 = (ResultSet) callableStatement.getObject(17);
			ResultSetMetaData section12MetaData = resultSetSection12.getMetaData();
			Map<String, String> roboscanSection12 = new LinkedHashMap<String, String>();
			while(resultSetSection12.next()){
				for(int colIndex = 1; colIndex <= section12MetaData.getColumnCount(); colIndex++){
					String columnName = section12MetaData.getColumnName(colIndex);
					roboscanSection12.put(columnName, resultSetSection12.getString(columnName));
				}
			}
			
			//FOR FETCHING DATA OF OPTIONS
			ResultSet resultSetSectionOption = (ResultSet) callableStatement.getObject(18);
			ResultSetMetaData sectionOptionMetaData = resultSetSectionOption.getMetaData();
			Map<String, String> roboscanOption = new LinkedHashMap<String, String>();
			while(resultSetSectionOption.next()){
				for(int colIndex = 1; colIndex <= sectionOptionMetaData.getColumnCount(); colIndex++){
					String columnName = sectionOptionMetaData.getColumnName(colIndex);
					roboscanOption.put(columnName, resultSetSectionOption.getString(columnName));
				}
			}
			
			/*System.out.println("HEADER DATA = "+roboscanHeader);
			System.out.println("SECTION1 DATA = "+roboscanSection1);
			System.out.println("SECTION2 DATA = "+roboscanSection2);
			System.out.println("SECTION3 DATA = "+roboscanSection4);
			System.out.println("SECTION4 DATA = "+roboscanSection4);
			System.out.println("SECTION5 DATA = "+roboscanSection5);
			System.out.println("SECTION6 DATA = "+roboscanSection6);
			System.out.println("SECTION7 DATA = "+roboscanSection7);
			System.out.println("SECTION8 DATA = "+roboscanSection8);
			System.out.println("SECTION9 DATA = "+roboscanSection9);
			System.out.println("SECTION10 DATA = "+roboscanSection10);
			System.out.println("SECTION11 DATA = "+roboscanSection11);
			System.out.println("SECTION12 DATA = "+roboscanSection12);
			System.out.println("OPTION DATA = "+roboscanOption);*/
			
			mainMap.put("HEADER", roboscanHeader);
			mainMap.put("SECTION1ALERTDETAILS", roboscanSection1);
			mainMap.put("SECTION2KYC", roboscanSection2);
			mainMap.put("SECTION3RTSCAN", roboscanSection3);
			mainMap.put("SECTION4TXNDETAILS", roboscanSection4);
			mainMap.put("SECTION5ACCPROFILE", roboscanSection5);
			mainMap.put("SECTION6LINK", roboscanSection6);
			mainMap.put("SECTION7PASTHISTORY", roboscanSection7);
			mainMap.put("SECTION8RLTDPARTY", roboscanSection8);
			mainMap.put("SECTION9RINGSIDEVIEW", roboscanSection9);
			mainMap.put("SECTION10CUSTCASEHISTORY", roboscanSection10);
			mainMap.put("SECTION11USERCOMMENTS", roboscanSection11);
			mainMap.put("SECTION12ACTIONS", roboscanSection12);
			mainMap.put("OPTION", roboscanOption);
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return mainMap;
	}
	
	public String saveRoboscanScreeningMapping(String roboscanCaseNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		//System.out.println(roboscanCaseNo);
		try{
			/*preparedStatement = connection.prepareStatement("INSERT INTO TB_CDD_SCREENINGMAPPING(COMPASSREFNO, UNIQUENUMBER, FILENAME, CDDFORMTYPE, CDDNAMETYPE, CDDNAMELINENO, USERCODE, USERROLE, IPADDRESS, UPDATEDBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, uniqueNumber);
			preparedStatement.setString(3, fileName);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, userRole);
			preparedStatement.setString(6, ipAddress);
			preparedStatement.setString(7, userRole);
			preparedStatement.executeUpdate();*/
			
			String query = "UPDATE TB_ROBOSCAN A "+
			               "   SET A.RTSCAN_SCREENINGREFERENCENO = ? "+
			               " WHERE CASENO = ? ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, fileName);
			preparedStatement.setString(2, roboscanCaseNo); 
			preparedStatement.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}	
		return "";
	}
	
	@Override
	public Map<String, String> getRoboscanScreeningDetails(String roboscanCaseNo) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		HashMap<String, String> screeningDetails = new HashMap<String, String>();
		try{
			connection = connectionUtil.getConnection();
			queryString = " SELECT RTSCAN_SCREENINGREFERENCENO "+
						  "   FROM TB_ROBOSCAN A "+
                          "  WHERE CASENO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, roboscanCaseNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				screeningDetails.put("RTSCAN_SCREENINGREFERENCENO", resultSet.getString("RTSCAN_SCREENINGREFERENCENO"));
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return screeningDetails;
	}

}
