package com.quantumdataengines.app.compass.dao.investigationStatistics;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class InvestigationStatisticsDAOImpl implements InvestigationStatisticsDAO{
	
private static final Logger log = LoggerFactory.getLogger(InvestigationStatisticsDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	@Autowired
	private OtherCommonService commonService;
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> getInvestigationStatistics(String userCode, String CURRENTROLE, String ipAddress) {
		List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result;
		try{
			
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_USERWISEALERTSTATS(?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, CURRENTROLE);
			callableStatement.setString(3, ipAddress);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);  
			callableStatement.execute();
			ResultSet resultSet = (ResultSet) callableStatement.getObject(4);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		//System.out.println(dataList);
		return dataList;
	}

}
