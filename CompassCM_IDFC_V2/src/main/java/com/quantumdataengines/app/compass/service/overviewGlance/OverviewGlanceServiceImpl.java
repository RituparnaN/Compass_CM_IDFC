package com.quantumdataengines.app.compass.service.overviewGlance;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.overviewGlance.OverviewGlanceDAO;

@Service
public class OverviewGlanceServiceImpl implements OverviewGlanceService {
	
	@Autowired
	private OverviewGlanceDAO overviewGlanceDAO;

	@Override
	public LinkedHashMap<String,Object> getETLSummary(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.getETLSummary(userCode, userRole, ipAddr);
	}

	@Override
	public Map<String, Object> mastersOverview(String userCode, String userRole, String ipAddr) {
		String customerProcName = "";
		String accountProcName = "STP_SEARCHACCOUNTGRAPH";
		Map<String,Object> res = new HashMap<String,Object>();
		res.put("ACCOUNT", overviewGlanceDAO.accountGlance(userCode,userRole,ipAddr));
		res.put("CUSTOMER", overviewGlanceDAO.customerGlance(userCode,userRole,ipAddr));
		return res;
	}

	@Override
	public Map<String, Object> etlWorkflowData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlWorkflowData(userCode, userRole, ipAddr);
	}

	@Override
	public Map<String, Object> etlAlertData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlAlertData(userCode, userRole, ipAddr);
	}
	
	@Override
	public Map<String, Object> etlRegReportData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlRegReportData(userCode, userRole, ipAddr);
	}
	
	@Override
	public Map<String, Object> etlUserRoleData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlUserRoleData(userCode, userRole, ipAddr);
	}
	
	@Override
	public Map<String, Object> etlAccountTypeStatusData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlAccountTypeStatusData(userCode, userRole, ipAddr);
	}
	
	@Override
	public Map<String, Object> etlCustomerTypeData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlCustomerTypeData(userCode, userRole, ipAddr);
	}

	@Override
	public Map<String, Object> etlCaseProductivityData(String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.etlCaseProductivityData(userCode, userRole, ipAddr);
	}
	
	@Override
	public Map<String, Object> getETLAlertData(String fromDate, String toDate, String reportType, String reportValue,
			String moduleType, String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.getETLAlertData(fromDate, toDate, 
				reportType, reportValue, moduleType, userCode, userRole, ipAddr);
	}

	@Override
	public Map<String, Object> getETLRegulatoryReportData(String fromDate, String toDate, String reportType,
			String reportValue, String moduleType, String userCode, String userRole, String ipAddr) {
		return overviewGlanceDAO.getETLRegulatoryReportData(fromDate, toDate, 
				reportType, reportValue, moduleType, userCode, userRole, ipAddr);
	}
	

}
