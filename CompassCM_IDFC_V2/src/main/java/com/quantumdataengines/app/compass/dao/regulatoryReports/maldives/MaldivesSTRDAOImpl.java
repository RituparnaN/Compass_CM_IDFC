package com.quantumdataengines.app.compass.dao.regulatoryReports.maldives;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.LinkedHashMap;
import java.util.Map;

import oracle.jdbc.internal.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class MaldivesSTRDAOImpl implements MaldivesSTRDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> fetchMaldivesSTRData(String caseNo, String userCode, String ipAddress, String CURRENTROLE){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETMALDIVESSTRDATA(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, CURRENTROLE);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
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
	public String saveMALDIVES_STR(Map<String,String> paramMap, String caseNo, String userCode){
		String response1 = "" ;
		String response2 = "" ;
		String response3 = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql1 = "UPDATE "+schemaName+"TB_MALDIVES_STR SET MALSTRDATE = ?, MALSTRREFNO = ?, MALSTRREPORTTYPE = ?, MALSTRNOOFDOC = ?, "+
						  "		  MALSTRDOCLIST = ?, MALSTRPREVSTRREFNO = ?, MALSTRAMENDMENTDATE = ?, MALSTRAMENDMENTRSN = ?, "+
						  "		  MALSTRNOOFINDVSUSPECTED = ?, MALSTRNOOFLEGENTSUSPECTED = ?, MALSTRREPORTINGENTNAME = ?, "+
						  "		  MALSTRREPORTINGBRANCHNAME = ?, MALSTRENTITYTYPE = ?, MALSTRENTTYPEINSCOMPNAME = ?, "+
						  "		  MALSTRENTTYPEINSOTHERSNAME = ?, MALSTRREPORTINGENTDATE = ?, MALSTRWIRETRANSFERINTL = ?, "+
						  "		  MALSTRWIRETRANSFERDOMESTIC = ?, MALSTRLETTEROFCREDIT = ?, MALSTRDEPOSITS = ?, MALSTRCASHWITHDRAWAL = ?, "+
						  "		  MALSTRINSTNX = ?, MALSTRREALESTATEPURCHASE = ?, MALSTROTHERASSETPURCHASE = ?, MALSTRDEBITCARD = ?, "+
						  "		  MALSTRCREDITCARD = ?, MALSTRNEGOINSTRUMENTS = ?, MALSTROVERDRAFT = ?, MALSTROTHERTNXTYPE = ?, "+
						  "		  MALSTROTHERTNXTYPENAME = ?, MALSTRMVR = ?, MALSTRAMTUNKNOWN = ?, MALSTRSRCTNX1NAME = ?, MALSTRSRCTNX1BANK = ?, "+
						  "		  MALSTRSRCTNX1ACCNO = ?, MALSTRSRCTNX1CURRENCY = ?, MALSTRSRCTNX1AMT = ?, MALSTRSRCTNX1COUNTRY = ?, "+
						  "		  MALSTRSRCTNX1DATE = ?, MALSTRDESTTNX1NAME = ?, MALSTRDESTTNX1BANK = ?, MALSTRDESTTNX1ACCNO = ?, "+
						  "		  MALSTRDESTTNX1CURRENCY = ?, MALSTRDESTTNX1AMT = ?, MALSTRDESTTNX1COUNTRY = ?, MALSTRDESTTNX1DATE = ?, "+
						  "		  MALSTRSUSPICIONRSN = ?, MALSTRNO = ?, MALSTRDTNXDETAILSDATE = ?, MALSTRRECEIVEDBY = ?, "+
						  "       UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+ 
						  " WHERE CASENO = ? " ;
					preparedStatement = connection.prepareStatement(sql1);
					preparedStatement.setString(1, paramMap.get("MALSTRDATE"));
					preparedStatement.setString(2, paramMap.get("MALSTRREFNO"));
					preparedStatement.setString(3, paramMap.get("MALSTRREPORTTYPE"));
					preparedStatement.setString(4, paramMap.get("MALSTRNOOFDOC"));
					preparedStatement.setString(5, paramMap.get("MALSTRDOCLIST"));
					preparedStatement.setString(6, paramMap.get("MALSTRPREVSTRREFNO"));
					preparedStatement.setString(7, paramMap.get("MALSTRAMENDMENTDATE"));
					preparedStatement.setString(8, paramMap.get("MALSTRAMENDMENTRSN"));
					preparedStatement.setString(9, paramMap.get("MALSTRNOOFINDVSUSPECTED"));
					preparedStatement.setString(10, paramMap.get("MALSTRNOOFLEGENTSUSPECTED"));
					
					preparedStatement.setString(11, paramMap.get("MALSTRREPORTINGENTNAME"));
					preparedStatement.setString(12, paramMap.get("MALSTRREPORTINGBRANCHNAME"));
					preparedStatement.setString(13, paramMap.get("MALSTRENTITYTYPE"));
					preparedStatement.setString(14, paramMap.get("MALSTRENTTYPEINSCOMPNAME"));
					preparedStatement.setString(15, paramMap.get("MALSTRENTTYPEINSOTHERSNAME"));
					preparedStatement.setString(16, paramMap.get("MALSTRREPORTINGENTDATE"));
					preparedStatement.setString(17, paramMap.get("MALSTRWIRETRANSFERINTL"));
					preparedStatement.setString(18, paramMap.get("MALSTRWIRETRANSFERDOMESTIC"));
					preparedStatement.setString(19, paramMap.get("MALSTRLETTEROFCREDIT"));
					preparedStatement.setString(20, paramMap.get("MALSTRDEPOSITS"));
					
					preparedStatement.setString(21, paramMap.get("MALSTRCASHWITHDRAWAL"));
					preparedStatement.setString(22, paramMap.get("MALSTRINSTNX"));
					preparedStatement.setString(23, paramMap.get("MALSTRREALESTATEPURCHASE"));
					preparedStatement.setString(24, paramMap.get("MALSTROTHERASSETPURCHASE"));
					preparedStatement.setString(25, paramMap.get("MALSTRDEBITCARD"));
					preparedStatement.setString(26, paramMap.get("MALSTRCREDITCARD"));
					preparedStatement.setString(27, paramMap.get("MALSTRNEGOINSTRUMENTS"));
					preparedStatement.setString(28, paramMap.get("MALSTROVERDRAFT"));
					preparedStatement.setString(29, paramMap.get("MALSTROTHERTNXTYPE"));
					preparedStatement.setString(30, paramMap.get("MALSTROTHERTNXTYPENAME"));
					
					preparedStatement.setString(31, paramMap.get("MALSTRMVR"));
					preparedStatement.setString(32, paramMap.get("MALSTRAMTUNKNOWN"));
					preparedStatement.setString(33, paramMap.get("MALSTRSRCTNX1NAME"));
					preparedStatement.setString(34, paramMap.get("MALSTRSRCTNX1BANK"));
					preparedStatement.setString(35, paramMap.get("MALSTRSRCTNX1ACCNO"));
					preparedStatement.setString(36, paramMap.get("MALSTRSRCTNX1CURRENCY"));
					preparedStatement.setString(37, paramMap.get("MALSTRSRCTNX1AMT"));
					preparedStatement.setString(38, paramMap.get("MALSTRSRCTNX1COUNTRY"));
					preparedStatement.setString(39, paramMap.get("MALSTRSRCTNX1DATE"));
					preparedStatement.setString(40, paramMap.get("MALSTRDESTTNX1NAME"));
					
					preparedStatement.setString(41, paramMap.get("MALSTRDESTTNX1BANK"));
					preparedStatement.setString(42, paramMap.get("MALSTRDESTTNX1ACCNO"));
					preparedStatement.setString(43, paramMap.get("MALSTRDESTTNX1CURRENCY"));
					preparedStatement.setString(44, paramMap.get("MALSTRDESTTNX1AMT"));
					preparedStatement.setString(45, paramMap.get("MALSTRDESTTNX1COUNTRY"));
					preparedStatement.setString(46, paramMap.get("MALSTRDESTTNX1DATE"));
					preparedStatement.setString(47, paramMap.get("MALSTRSUSPICIONRSN"));
					preparedStatement.setString(48, paramMap.get("MALSTRNO"));
					preparedStatement.setString(49, paramMap.get("MALSTRDTNXDETAILSDATE"));
					
					preparedStatement.setString(50, paramMap.get("MALSTRRECEIVEDBY"));
					preparedStatement.setString(51, userCode);
					preparedStatement.setString(52, caseNo);
					preparedStatement.executeUpdate();
					response1="Successfully updated.";
					
		String sql2 = "UPDATE "+schemaName+"TB_MALDIVES_STR_INDV SET INDVSTRDATE = ?, INDVSTRREFNO = ?, INDVSTRREMTNAME = ?, "+
					  "		  INDVSTRREMTIDNO = ?, INDVSTRREMTIDTYPE = ?, INDVSTRREMTIDTYPEOTHERDETAIL = ?, INDVSTRREMTADDR = ?, "+
					  "		  INDVSTRREMTISSUER = ?, INDVSTRREMTISSDATE = ?, INDVSTRREMTEXPDATE = ?, INDVSTRREMTTNXCAPACITY = ?, "+
					  "		  INDVSTRREMTTNXCAPACITYDETAIL = ?, INDVSTRTNXRCPTYPE = ?, INDVSTRTNXRCPTYPEOTHERDETAIL = ?, "+
					  "		  INDVSTRTXNRCPNAME = ?, INDVSTRTXNRCPIDNO = ?, INDVSTRTNXRCPIDTYPE = ?, INDVSTRTNXRCPOTHERDETAILS = ?, "+
					  "		  INDVSTRTNXRCPADDR = ?, INDVSTRTNXRCPISSUER = ?, INDVSTRTNXRCPISSDATE = ?, INDVSTRTNXRCPEXPDATE = ?, "+
					  "		  INDVSTRTNXRCPNATIONALITY = ?, INDVBSNSAFFILIATION = ?, INDVBSNSAFFIRELATIONSHIP = ?, INDVBSNSAFFIRELSTATUS = ?, "+
					  "		  INDVBSNSAFFIREMARKS = ?, INDVACCINFO1BANKNAME = ?, INDVACCINFO1BRANCHNAME = ?, INDVACCINFO1ACCNAME = ?, "+
					  "		  INDVACCINFO1ACCNO = ?, INDVACCINFO1ACCOPENDATE = ?, INDVACCINFO1ACCBAL = ?, INDVACCINFO1BENEFICIARY = ?, "+
					  "		  UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+ 
					  " WHERE CASENO = ? " ;
				preparedStatement = connection.prepareStatement(sql2);
				preparedStatement.setString(1, paramMap.get("INDVSTRDATE"));
				preparedStatement.setString(2, paramMap.get("INDVSTRREFNO"));
				preparedStatement.setString(3, paramMap.get("INDVSTRREMTNAME"));
				preparedStatement.setString(4, paramMap.get("INDVSTRREMTIDNO"));
				preparedStatement.setString(5, paramMap.get("INDVSTRREMTIDTYPE"));
				preparedStatement.setString(6, paramMap.get("INDVSTRREMTIDTYPEOTHERDETAIL"));
				preparedStatement.setString(7, paramMap.get("INDVSTRREMTADDR"));
				preparedStatement.setString(8, paramMap.get("INDVSTRREMTISSUER"));
				preparedStatement.setString(9, paramMap.get("INDVSTRREMTISSDATE"));
				preparedStatement.setString(10, paramMap.get("INDVSTRREMTEXPDATE"));
				preparedStatement.setString(11, paramMap.get("INDVSTRREMTTNXCAPACITY"));
				preparedStatement.setString(12, paramMap.get("INDVSTRREMTTNXCAPACITYDETAIL"));
				preparedStatement.setString(13, paramMap.get("INDVSTRTNXRCPTYPE"));
				preparedStatement.setString(14, paramMap.get("INDVSTRTNXRCPTYPEOTHERDETAIL"));
				preparedStatement.setString(15, paramMap.get("INDVSTRTXNRCPNAME"));
				preparedStatement.setString(16, paramMap.get("INDVSTRTXNRCPIDNO"));
				preparedStatement.setString(17, paramMap.get("INDVSTRTNXRCPIDTYPE"));
				preparedStatement.setString(18, paramMap.get("INDVSTRTNXRCPOTHERDETAILS"));
				preparedStatement.setString(19, paramMap.get("INDVSTRTNXRCPADDR"));
				preparedStatement.setString(20, paramMap.get("INDVSTRTNXRCPISSUER"));
				preparedStatement.setString(21, paramMap.get("INDVSTRTNXRCPISSDATE"));
				preparedStatement.setString(22, paramMap.get("INDVSTRTNXRCPEXPDATE"));
				preparedStatement.setString(23, paramMap.get("INDVSTRTNXRCPNATIONALITY"));
				preparedStatement.setString(24, paramMap.get("INDVBSNSAFFILIATION"));
				preparedStatement.setString(25, paramMap.get("INDVBSNSAFFIRELATIONSHIP"));
				preparedStatement.setString(26, paramMap.get("INDVBSNSAFFIRELSTATUS"));
				preparedStatement.setString(27, paramMap.get("INDVBSNSAFFIREMARKS"));
				preparedStatement.setString(28, paramMap.get("INDVACCINFO1BANKNAME"));
				preparedStatement.setString(29, paramMap.get("INDVACCINFO1BRANCHNAME"));
				preparedStatement.setString(30, paramMap.get("INDVACCINFO1ACCNAME"));
				preparedStatement.setString(31, paramMap.get("INDVACCINFO1ACCNO"));
				preparedStatement.setString(32, paramMap.get("INDVACCINFO1ACCOPENDATE"));
				preparedStatement.setString(33, paramMap.get("INDVACCINFO1ACCBAL"));
				preparedStatement.setString(34, paramMap.get("INDVACCINFO1BENEFICIARY"));
				preparedStatement.setString(35, userCode);
				preparedStatement.setString(36, caseNo);
				preparedStatement.executeUpdate();
				response2="Successfully updated MALDIVES STR (INDIVIDUAL).";
				
		String sql3 = "UPDATE "+schemaName+"TB_MALDIVES_STR_LEG_ENT SET LEGENTSTRDATE = ?, LEGENTSTRREFNO = ?, LEGENTSTRREMTNAME = ?, "+
					  "		  LEGENTSTRREMTIDNO = ?, LEGENTSTRREMTIDTYPE = ?, LEGENTSTRREMTADDR = ?, LEGENTSTRREMTISSUER = ?, "+
					  "		  LEGENTSTRREMTISSDATE = ?, LEGENTSTRREMTEXPDATE = ?, LEGENTSTRREMTCAPACITY = ?, "+
					  "		  LEGENTSTRREMTOTHERDETAIL = ?, LEGENTSTRORGNAME = ?, LEGENTSTRACCOPENDATE = ?, LEGENTSTRCOUNTRYOFREG = ?, "+
					  "		  LEGENTSTRREGNO = ?, LEGENTSTRREGULATINGBODY = ?, LEGENTSTRREGADDR = ?, LEGENTSTRBSNSADDR = ?, "+
					  "		  LEGENTSTRCONTACTNO = ?, LEGENTSTRTNXRCPTYPE = ?, LEGENTSTRTNXRCPOTHERDETAIL = ?, LEGENTSTRTNXRCPNAME = ?, "+
					  "		  LEGENTSTRTNXRCPIDNO = ?, LEGENTSTRTNXRCPIDTYPE = ?, LEGENTSTRTNXRCPIDTYPEOTHERDET = ?, "+
					  "		  LEGENTSTRTNXRCPADDR = ?, LEGENTSTRTNXRCPISSUER = ?, LEGENTSTRTNXRCPISSDATE = ?, LEGENTSTRTNXRCPEXPDATE = ?, "+
					  "		  LEGENTSTRTNXRCPNATIONALITY = ?, LEGENTBSNSAFFILIATION = ?, LEGENTBSNSAFFIRELATIONSHIP = ?, "+
					  "		  LEGENTBSNSAFFIRELSTATUS = ?, LEGENTBSNSAFFIRELREMARKS = ?, LEGENTACCINFO1BANKNAME = ?, "+
					  "		  LEGENTACCINFO1BRANCHNAME = ?, LEGENTACCINFO1ACCNAME = ?, LEGENTACCINFO1ACCNO = ?, LEGENTACCINFO1ACCOPENDATE = ?, "+
					  "		  LEGENTACCINFO1ACCBAL = ?, LEGENTACCINFO1BENEFICIARY = ?, UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+ 
					  " WHERE CASENO = ? " ;
				preparedStatement = connection.prepareStatement(sql3);
				preparedStatement.setString(1, paramMap.get("LEGENTSTRDATE"));
				preparedStatement.setString(2, paramMap.get("LEGENTSTRREFNO"));
				preparedStatement.setString(3, paramMap.get("LEGENTSTRREMTNAME"));
				preparedStatement.setString(4, paramMap.get("LEGENTSTRREMTIDNO"));
				preparedStatement.setString(5, paramMap.get("LEGENTSTRREMTIDTYPE"));
				preparedStatement.setString(6, paramMap.get("LEGENTSTRREMTADDR"));
				preparedStatement.setString(7, paramMap.get("LEGENTSTRREMTISSUER"));
				preparedStatement.setString(8, paramMap.get("LEGENTSTRREMTISSDATE"));
				preparedStatement.setString(9, paramMap.get("LEGENTSTRREMTEXPDATE"));
				preparedStatement.setString(10, paramMap.get("LEGENTSTRREMTCAPACITY"));
				preparedStatement.setString(11, paramMap.get("LEGENTSTRREMTOTHERDETAIL"));
				preparedStatement.setString(12, paramMap.get("LEGENTSTRORGNAME"));
				preparedStatement.setString(13, paramMap.get("LEGENTSTRACCOPENDATE"));
				preparedStatement.setString(14, paramMap.get("LEGENTSTRCOUNTRYOFREG"));
				preparedStatement.setString(15, paramMap.get("LEGENTSTRREGNO"));
				preparedStatement.setString(16, paramMap.get("LEGENTSTRREGULATINGBODY"));
				preparedStatement.setString(17, paramMap.get("LEGENTSTRREGADDR"));
				preparedStatement.setString(18, paramMap.get("LEGENTSTRBSNSADDR"));
				preparedStatement.setString(19, paramMap.get("LEGENTSTRCONTACTNO"));
				preparedStatement.setString(20, paramMap.get("LEGENTSTRTNXRCPTYPE"));
				preparedStatement.setString(21, paramMap.get("LEGENTSTRTNXRCPOTHERDETAIL"));
				preparedStatement.setString(22, paramMap.get("LEGENTSTRTNXRCPNAME"));
				preparedStatement.setString(23, paramMap.get("LEGENTSTRTNXRCPIDNO"));
				preparedStatement.setString(24, paramMap.get("LEGENTSTRTNXRCPIDTYPE"));
				preparedStatement.setString(25, paramMap.get("LEGENTSTRTNXRCPIDTYPEOTHERDET"));
				preparedStatement.setString(26, paramMap.get("LEGENTSTRTNXRCPADDR"));
				preparedStatement.setString(27, paramMap.get("LEGENTSTRTNXRCPISSUER"));
				preparedStatement.setString(28, paramMap.get("LEGENTSTRTNXRCPISSDATE"));
				preparedStatement.setString(29, paramMap.get("LEGENTSTRTNXRCPEXPDATE"));
				preparedStatement.setString(30, paramMap.get("LEGENTSTRTNXRCPNATIONALITY"));
				preparedStatement.setString(31, paramMap.get("LEGENTBSNSAFFILIATION"));
				preparedStatement.setString(32, paramMap.get("LEGENTBSNSAFFIRELATIONSHIP"));
				preparedStatement.setString(33, paramMap.get("LEGENTBSNSAFFIRELSTATUS"));
				preparedStatement.setString(34, paramMap.get("LEGENTBSNSAFFIRELREMARKS"));
				preparedStatement.setString(35, paramMap.get("LEGENTACCINFO1BANKNAME"));
				preparedStatement.setString(36, paramMap.get("LEGENTACCINFO1BRANCHNAME"));
				preparedStatement.setString(37, paramMap.get("LEGENTACCINFO1ACCNAME"));
				preparedStatement.setString(38, paramMap.get("LEGENTACCINFO1ACCNO"));
				preparedStatement.setString(39, paramMap.get("LEGENTACCINFO1ACCOPENDATE"));
				preparedStatement.setString(40, paramMap.get("LEGENTACCINFO1ACCBAL"));
				preparedStatement.setString(41, paramMap.get("LEGENTACCINFO1BENEFICIARY"));
				preparedStatement.setString(42, userCode);
				preparedStatement.setString(43, caseNo);
				preparedStatement.executeUpdate();
				response3="Successfully updated MALDIVES STR (LEGAL ENTITY).";
		}catch(Exception e){
			response1="Error while saving/updating MALDIVES STR.";
			response2="Error while saving/updating MALDIVES STR (INDIVIDUAL).";
			response3="Error while saving/updating MALDIVES STR (LEGAL ENTITY).";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return "response1 = "+response1+", response2 = "+response2+", response3 = "+response3;
	}

}
