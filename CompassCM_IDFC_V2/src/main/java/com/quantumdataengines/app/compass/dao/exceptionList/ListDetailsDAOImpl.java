
package com.quantumdataengines.app.compass.dao.exceptionList;

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
import oracle.net.aso.r;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ListDetailsDAOImpl implements ListDetailsDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> showListDetails(){
		List<Map<String, String>> mainList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT ROWNUM ROWPOSITION, A.* FROM ( "+
					 "SELECT LISTCODE, LISTNAME, LISTDESCRIPTION, LISTTYPE, "+
					 "		 FUN_DATETOCHAR(UPDATETIMESTAMP) ADDEDON, "+
					 "       UPDATEDBY ADDEDBY, ISFILEUPLOADENABLED "+
					 "  FROM "+schemaName+"TB_EXCEPTIONLISTMASTER A "+
					 " WHERE UPPER(LISTTYPE) IN ('BLACKLIST','REJECTEDLIST','SELECTEDBLACKLIST') "+
					 "   AND ISENABLED = 'Y' "+ //to be updated
					 " ) A ORDER BY LISTTYPE, LISTCODE ";
		
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("ROWPOSITION", resultSet.getString("ROWPOSITION"));
				dataMap.put("LISTCODE", resultSet.getString("LISTCODE"));
				dataMap.put("LISTNAME", resultSet.getString("LISTNAME"));
				dataMap.put("LISTDESCRIPTION", resultSet.getString("LISTDESCRIPTION"));
				dataMap.put("LISTTYPE", resultSet.getString("LISTTYPE"));
				dataMap.put("ADDEDON", resultSet.getString("ADDEDON"));
				dataMap.put("ADDEDBY", resultSet.getString("ADDEDBY"));
				dataMap.put("ISFILEUPLOADENABLED", resultSet.getString("ISFILEUPLOADENABLED"));
				
				mainList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}

	public Map<String, Object> getExceptionListRecords(String listCode, String listCode_Id, String listCode_Name){
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_FETCHEXCEPTIONLISTRECORDS(?,?,?,?)}");
			callableStatement.setString(1, listCode);
			callableStatement.setString(2, listCode_Id);
			callableStatement.setString(3, listCode_Name);		
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(resultSetMetaData.getColumnName(colIndex));
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
	
	public Map<String, Object> getExceptionListIdDetails(String listCode, String listId, String viewType){
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GETEXCEPTIONLISTIDDETAILS(?,?,?,?)}");
			callableStatement.setString(1, listCode);
			callableStatement.setString(2, listId);
			callableStatement.setString(3, viewType);		
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(resultSetMetaData.getColumnName(colIndex));
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

	public Map<String, Object> getRecordDetails(String recordId) {
		Map<String, Object> recordDetails = new HashMap<String, Object>();
		recordDetails.put("CHANGELOG", getRecordChangeLog(recordId));
		recordDetails.put("NAMEDETAILS", getRecordNameDetails(recordId));
		recordDetails.put("DESCRIPTIONS", getRecordDescriptions(recordId));
		recordDetails.put("ROLEDETAILS", getRecordRoleDetails(recordId));
		recordDetails.put("DATEDETAILS", getRecordDateDetails(recordId));
		recordDetails.put("BIRTHPLACE", getBirthplaceDetails(recordId));
		recordDetails.put("SANCREF", getSancRefrence(recordId));
		recordDetails.put("ADDRESSDETAILS", getRecordAddressDetails(recordId));
		recordDetails.put("COUNTRYDETAILS", getCountryDetails(recordId));
		recordDetails.put("IDDETAILS", getIDDetails(recordId));
		recordDetails.put("SOURCEDESC", getRecordSourceDesc(recordId));
		recordDetails.put("IMAGE", getPersonImage(recordId));
		recordDetails.put("ENTITYCOMPANYDETAILS", getEntityCompany(recordId));
		recordDetails.put("ENTITYVESSELDETAILS", getEntityVesselDetails(recordId));
		return recordDetails;
	}
	
	private List<Map<String, String>> getRecordChangeLog(String recordId){
		List<Map<String, String>> changeLogList = new ArrayList<Map<String, String>>();
		Connection connection = null ;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT A.UPLOADID UPLOADID, CASE A.RECORDTYPE WHEN 'P' THEN 'Person' ELSE 'Entity' END AS RECORDTYPE, "+
															"		A.ACTION ACTION, A.ACTIVESTATUS ACTIVESTATUS, A.DATEVALUE DATEVALUE, "+
															"		NVL(A.RECORDPROFILENOTES ,'N.A.') RECORDPROFILENOTES, "+
															"		A.RECORDID RECORDID, NVL(A.GENDER,'N.A.') GENDER, NVL(A.DECEASED,'N.A.') DECEASED"+
															"  FROM TB_DOWJONE_RECORD A "+
															" WHERE A.RECORDID = ? "+
															" ORDER BY TO_DATE(A.DATEVALUE, 'DD-MON-YYYY') DESC");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> changeLog = new LinkedHashMap<String, String>();
				changeLog.put("UPLOADID", resultSet.getString("UPLOADID"));
				changeLog.put("RECORDTYPE", resultSet.getString("RECORDTYPE"));
				changeLog.put("ACTION", resultSet.getString("ACTION"));
				changeLog.put("ACTIVESTATUS", resultSet.getString("ACTIVESTATUS"));
				changeLog.put("DATEVALUE", resultSet.getString("DATEVALUE"));
				changeLog.put("RECORDPROFILENOTES", resultSet.getString("RECORDPROFILENOTES"));
				changeLog.put("RECORDID", resultSet.getString("RECORDID"));
				changeLog.put("GENDER", resultSet.getString("GENDER"));
				changeLog.put("DECEASED", resultSet.getString("DECEASED"));
				changeLogList.add(changeLog);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while getting Dowjones record change log : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return changeLogList;
	}
	
	public String getRecordProfileNote(String uploadId, String recordId){
		String profileNote = "";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT RECORDPROFILENOTES FROM TB_DOWJONE_RECORD WHERE UPLOADID = ? AND RECORDID = ?");
			preparedStatement.setString(1, uploadId);
			preparedStatement.setString(2, recordId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				profileNote = resultSet.getString("RECORDPROFILENOTES");
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record profile note : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return profileNote;
	}
	
	private List<Map<String, String>> getRecordDescriptions(String recordId){
		List<Map<String, String>> descriptions = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT A.RECORDID, NVL(B.DESCRIPTION, '-') DESC1, NVL(C.DESCRIPTION, '-') DESC2, NVL(D.DESCRIPTION, '-') DESC3 "+
															"  FROM TB_DOWJONE_RECORDDESCRIPTIONS A "+
															"  LEFT OUTER JOIN TB_DOWJONE_DESCRIPTION1 B "+
															"    ON A.DESC1ID = B.DESC1ID "+
															"  LEFT OUTER JOIN TB_DOWJONE_DESCRIPTION2 C "+
															"    ON A.DESC1ID = C.DESC1ID "+
															"   AND A.DESC2ID = C.DESC2ID "+
															"  LEFT OUTER JOIN TB_DOWJONE_DESCRIPTION3 D "+
															"    ON A.DESC2ID = D.DESC2ID "+
															"   AND A.DESC3ID = D.DESC3ID "+
															" WHERE A.RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> desc = new HashMap<String, String>();
				desc.put("DESC1", resultSet.getString("DESC1"));
				desc.put("DESC2", resultSet.getString("DESC2"));
				desc.put("DESC3", resultSet.getString("DESC3"));
				
				descriptions.add(desc);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record name details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return descriptions;
	}
	
	
	
	private List<Map<String, String>> getRecordNameDetails(String recordId){
		List<Map<String, String>> nameDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT A.NAMETYPE, CASE B.RECORDTYPE WHEN 'P' THEN "+
															"		NVL(A.TITLEHONORIFIC, '') || NVL(A.FIRSTNAME, '') || NVL(A.MIDDLENAME, '') || NVL(A.SURNAME, '') || NVL(A.SUFFIX, '') ELSE "+
															"		NVL(A.ENTITYNAME, '-') END AS RECORDNAME, NVL(A.MAIDENNAME, '-') MAIDENNAME, NVL(A.SINGLESTRINGNAME, '-') SINGLESTRINGNAME "+
															"  FROM TB_DOWJONE_RECORDNAMEDETAILS A "+
															"  LEFT OUTER JOIN TB_DOWJONE_RECORD B "+
															"    ON A.RECORDID = B.RECORDID "+
															"   AND A.UPLOADID = B.UPLOADID "+
															" WHERE A.RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> nameDetail = new HashMap<String, String>();
				if(resultSet.getString("NAMETYPE").equals("Primary Name")){
					nameDetail.put("ISPRIMARY", "Y");
				}else
					nameDetail.put("ISPRIMARY", "N");
				nameDetail.put("NAMETYPE", resultSet.getString("NAMETYPE"));
				nameDetail.put("FULLNAME", resultSet.getString("RECORDNAME"));
				nameDetail.put("MAIDENNAME", resultSet.getString("MAIDENNAME"));
				nameDetail.put("SINGLESTRINGNAME", resultSet.getString("SINGLESTRINGNAME"));
				
				nameDetails.add(nameDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record name details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return nameDetails;
	}
	
	public List<Map<String, String>> getRecordRoleDetails(String recordId){
		List<Map<String, String>> roleDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT A.ROLETYPE, A.ROLE, NVL(B.OCCUPATIONNAME, A.OCCUPATIONCAT) OCCUPATIONNAME, A.ROLESINCEDD, "+
															"		A.ROLESINCEMM, A.ROLESINCEYY, A.ROLETODD, A.ROLETOMM, A.ROLETOYY "+
															"  FROM TB_DOWJONE_PERSONROLEDETAILS A, TB_DOWJONE_OCCUPATION B "+
															" WHERE A.OCCUPATIONCAT = B.OCCUPATIONCODE "+
															"   AND A.RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> roleDetail = new HashMap<String, String>();
				roleDetail.put("ROLETYPE", resultSet.getString("ROLETYPE"));
				roleDetail.put("ROLE", resultSet.getString("ROLE"));
				roleDetail.put("OCCUPATIONNAME", resultSet.getString("OCCUPATIONNAME"));
				roleDetail.put("ROLESINCEDD", resultSet.getString("ROLESINCEDD"));
				roleDetail.put("ROLESINCEMM", resultSet.getString("ROLESINCEMM"));
				roleDetail.put("ROLESINCEYY", resultSet.getString("ROLESINCEYY"));
				roleDetail.put("ROLETODD", resultSet.getString("ROLETODD"));
				roleDetail.put("ROLETOMM", resultSet.getString("ROLETOMM"));
				roleDetail.put("ROLETOYY", resultSet.getString("ROLETOYY"));
				
				roleDetails.add(roleDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record role details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return roleDetails;
	}
	
	public List<Map<String, String>> getRecordDateDetails(String recordId){
		List<Map<String, String>> dateDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT A.DATETYPE, A.DATEVALUE "+
															"  FROM TB_DOWJONE_RECORDDATEDETAILS A "+
															" WHERE A.RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dateDetail = new HashMap<String, String>();
				dateDetail.put("DATETYPE", resultSet.getString("DATETYPE"));
				dateDetail.put("DATEVALUE", resultSet.getString("DATEVALUE"));
				
				dateDetails.add(dateDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dateDetails;
	}
	
	public List<Map<String, String>> getBirthplaceDetails(String recordId){
		List<Map<String, String>> birthplaceDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT BIRTHPLACE "+
															"  FROM TB_DOWJONE_PERSONBIRTHPLACE "+
															" WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> birthplaceDetail = new HashMap<String, String>();
				birthplaceDetail.put("BIRTHPLACE", resultSet.getString("BIRTHPLACE"));
				
				birthplaceDetails.add(birthplaceDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return birthplaceDetails;
	}
	
	public List<Map<String, String>> getSancRefrence(String recordId){
		List<Map<String, String>> sancRefDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT NVL(B.REFERENCENAME, A.REFERENCE) REFERENCE, A.SINCEDD, "+
															"		A.SINCEMM, A.SINCEYY, A.TODD, A.TOMM, A.TOYY "+
															"  FROM TB_DOWJONE_RECORDSANCREF A "+
															"  LEFT OUTER JOIN TB_DOWJONE_SANCTIONSREFERENCES B "+
															"    ON A.REFERENCE = B.REFERENCECODE "+
															" WHERE A.RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> sancRefDetail = new HashMap<String, String>();
				sancRefDetail.put("REFERENCE", resultSet.getString("REFERENCE"));
				sancRefDetail.put("SINCEDD", resultSet.getString("SINCEDD"));
				sancRefDetail.put("SINCEMM", resultSet.getString("SINCEMM"));
				sancRefDetail.put("SINCEYY", resultSet.getString("SINCEYY"));
				sancRefDetail.put("TODD", resultSet.getString("TODD"));
				sancRefDetail.put("TOMM", resultSet.getString("TOMM"));
				sancRefDetail.put("TOYY", resultSet.getString("TOYY"));
				
				sancRefDetails.add(sancRefDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return sancRefDetails;
	}
	
	public List<Map<String, String>> getRecordAddressDetails(String recordId){
		List<Map<String, String>> addressDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT LINE, CITY, COUNTRY, URL FROM TB_DOWJONE_PERSONADDRESS WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> addressDetail = new HashMap<String, String>();
				addressDetail.put("LINE", resultSet.getString("LINE"));
				addressDetail.put("CITY", resultSet.getString("CITY"));
				addressDetail.put("COUNTRY", resultSet.getString("COUNTRY"));
				addressDetail.put("URL", resultSet.getString("URL"));
				
				addressDetails.add(addressDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return addressDetails;
	}
	
	public List<Map<String, String>> getCountryDetails(String recordId){
		List<Map<String, String>> countryDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT COUNTRYTYPE, COUNTRYNAME FROM TB_DOWJONE_RECORDCOUNTRYDETAIL WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> countryDetail = new HashMap<String, String>();
				countryDetail.put("COUNTRYTYPE", resultSet.getString("COUNTRYTYPE"));
				countryDetail.put("COUNTRYNAME", resultSet.getString("COUNTRYNAME"));
				
				countryDetails.add(countryDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return countryDetails;
	}
	
	public List<Map<String, String>> getIDDetails(String recordId){
		List<Map<String, String>> idDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT IDTYPE, IDVALUE FROM TB_DOWJONE_RECORDIDDETAILS WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> idDetail = new HashMap<String, String>();
				idDetail.put("IDTYPE", resultSet.getString("IDTYPE"));
				idDetail.put("IDVALUE", resultSet.getString("IDVALUE"));
				
				idDetails.add(idDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return idDetails;
	}
	
	public List<Map<String, String>> getRecordSourceDesc(String recordId){
		List<Map<String, String>> sourceDescriptions = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT SOURCE FROM TB_DOWJONE_RECORDSRCDESC WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> sourceDesc = new HashMap<String, String>();
				sourceDesc.put("SOURCE", resultSet.getString("SOURCE"));
				
				sourceDescriptions.add(sourceDesc);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return sourceDescriptions;
	}
	
	public List<Map<String, String>> getPersonImage(String recordId){
		List<Map<String, String>> imageDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT IMAGEURL FROM TB_DOWJONE_PERSONIMAGE WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> imageDetail = new HashMap<String, String>();
				imageDetail.put("IMAGEURL", resultSet.getString("IMAGEURL"));
				
				imageDetails.add(imageDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return imageDetails;
	}
	
	public List<Map<String, String>> getEntityCompany(String recordId){
		List<Map<String, String>> entityCompanyAddress = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT LINE, CITY, COUNTRY, URL FROM TB_DOWJONE_ENTITYCOMPANY WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> entityCompany = new HashMap<String, String>();
				entityCompany.put("LINE", resultSet.getString("LINE"));
				entityCompany.put("CITY", resultSet.getString("CITY"));
				entityCompany.put("COUNTRY", resultSet.getString("COUNTRY"));
				entityCompany.put("URL", resultSet.getString("URL"));
				
				entityCompanyAddress.add(entityCompany);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return entityCompanyAddress;
	}
	
	public List<Map<String, String>> getEntityVesselDetails(String recordId){
		List<Map<String, String>> entityVesselDetails = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT VESSELCALLSIGN, VESSELTYPE, VESSELTONNAGE, "+
															"		VESSELGRT, VESSELOWNER, VESSELFLAG "+
															"  FROM TB_DOWJONE_ENTITYVESSELDETAILS "+
															" WHERE RECORDID = ?");
			preparedStatement.setString(1, recordId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> entityVessel = new HashMap<String, String>();
				entityVessel.put("VESSELCALLSIGN", resultSet.getString("VESSELCALLSIGN"));
				entityVessel.put("VESSELTYPE", resultSet.getString("VESSELTYPE"));
				entityVessel.put("VESSELTONNAGE", resultSet.getString("VESSELTONNAGE"));
				entityVessel.put("VESSELGRT", resultSet.getString("VESSELGRT"));
				entityVessel.put("VESSELOWNER", resultSet.getString("VESSELOWNER"));
				entityVessel.put("VESSELFLAG", resultSet.getString("VESSELFLAG"));
				
				entityVesselDetails.add(entityVessel);
			}
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Error while fetching Dowjones record date details : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return entityVesselDetails;
	}
	
}
