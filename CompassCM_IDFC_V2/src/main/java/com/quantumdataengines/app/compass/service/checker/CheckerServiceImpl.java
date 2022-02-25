package com.quantumdataengines.app.compass.service.checker;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.checker.CheckerDAO;

@Service
public class CheckerServiceImpl implements CheckerService{

	@Autowired
	private CheckerDAO checkerDAO;
	
	@Override
	public List<Map<String, String>> getAllIPAddressForCheck() {
		return checkerDAO.getAllIPAddressForCheck();
	}

	@Override
	public Map<String, String> getIPDetailsForChecker(String ipAddress,	String makerCode) {
		return checkerDAO.getIPDetailsForChecker(ipAddress, makerCode);
	}

	@Override
	public String approveIPAddress(String ipAddress, String makerCode, String remarks,
			String createdBy) {
		return checkerDAO.approveIPAddress(ipAddress, makerCode, remarks, createdBy);
	}

	@Override
	public String rejectIPAddress(String makerCode, String remarks,
			String createdBy) {
		return checkerDAO.rejectIPAddress(makerCode, remarks, createdBy);
	}

	/*@Override
	public List<Map<String, String>> getAllUserForCheck(String lo) {
		return checkerDAO.getAllUserForCheck();
	}*/

	public List<Map<String, String>> getAllUserForCheck(String loggedInUsercode){
		return checkerDAO.getAllUserForCheck(loggedInUsercode);
	}
	
	@Override
	public Map<String, Object> getUserDetailsForCheck(String userCode,
			String makerCode) {
		return checkerDAO.getUserDetailsForCheck(userCode, makerCode);
	}

	@Override
	public String checkUserReject(String userCode, String makerCode,
			String remarks, String createdBy) {
		return checkerDAO.checkUserReject(userCode, makerCode, remarks, createdBy);
	}

	@Override
	public String checkUserApprove(String userCode, String makerCode,
			String remarks, String createdBy) {
		return checkerDAO.checkUserApprove(userCode, makerCode, remarks, createdBy);
	}

}
