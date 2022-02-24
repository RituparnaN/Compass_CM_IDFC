package com.quantumdataengines.app.compass.service.adminMaker;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.adminmaker.AdminMakerDAO;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;

@Service
public class AdminMakerServiceImpl implements AdminMakerService{

	@Autowired
	private AdminMakerDAO adminMakerDAO;
	@Autowired
	private OtherCommonService commonService;
	
	@Override
	public List<Map<String, String>> searchUser(String userCode, String firstName, String lastName, String emailId, String mobileNo) {
		return adminMakerDAO.searchUser(userCode, firstName, lastName, emailId, mobileNo);
	}
	
	@Override
	public List<Map<String, String>> createUser(String userCode, String userPass, String firstName, String lastName,
			String emailId, String mobileNo, String designation,
			String accessStartTime, String accessEndTime, String passwordExpiry, String accountExpiryDate, 
			String chatEnabled, String BRANCHCODE, String ISETLUSER, String createdBy){
		String makerId = commonService.getElementId();
		return adminMakerDAO.createUser(userCode, userPass, firstName, lastName, emailId, mobileNo, designation,
				accessStartTime, accessEndTime, passwordExpiry, accountExpiryDate, chatEnabled, BRANCHCODE, ISETLUSER, createdBy, makerId);
	}
	
	@Override
	public List<Map<String, String>> getAllUserFromEdit(String loggedInUsercode){
		return adminMakerDAO.getAllUserFromEdit(loggedInUsercode);
	}
	
	@Override
	public Map<String, String> getUserForEdit(String useCode, String tableName, String makerCode, String employeeCode, String employeeName){
		return adminMakerDAO.getUserForEdit(useCode, tableName, makerCode, employeeCode, employeeName);
	}
	
	@Override
	public String updateUserDetails(Map<String, String> userDetails, String actionFlag, String updatedBy){
		String makerId = commonService.getElementId();
		return adminMakerDAO.updateUserDetails(userDetails, actionFlag, makerId, updatedBy);
	}

	@Override
	public List<Map<String, String>> searchIPAddress(String ipAddress,
			String systemName) {
		return adminMakerDAO.searchIPAddress(ipAddress, systemName);
	}

	@Override
	public List<Map<String, String>> createIPAddress(String ipAddress,
			String systemName, String createdBy) {
		String makerId = commonService.getElementId();
		return adminMakerDAO.createIPAddress(ipAddress, systemName, createdBy, makerId);
	}

	@Override
	public List<Map<String, String>> getAllIPAddressFromEdit() {
		return adminMakerDAO.getAllIPAddressFromEdit();
	}

	@Override
	public Map<String, String> getIPAddressForEdit(String ipAddress,
			String tableName, String makerCode) {
		return adminMakerDAO.getIPAddressForEdit(ipAddress, tableName, makerCode);
	}

	@Override
	public String updateIPAddress(Map<String, String> ipDetails, String createdBy) {
		String makerId = commonService.getElementId();
		return adminMakerDAO.updateIPAddress(ipDetails, makerId, createdBy);
	}

	@Override
	public List<Map<String, String>> getAllUserForGroupMapping(String loggedInUsercode) {
		return adminMakerDAO.getAllUserForGroupMapping(loggedInUsercode);
	}

	@Override
	public List<String> getAllRolesAvailable() {
		return adminMakerDAO.getAllRolesAvailable();
	}

	@Override
	public Map<String, Map<String, List<Map<String, String>>>> getAllModulesForRoles(
			List<String> allRoles) {
		return adminMakerDAO.getAllModulesForRoles(allRoles);
	}

	@Override
	public Map<String, Object> getUserAssingedAllRolesModules(String userCode, String table) {
		return adminMakerDAO.getUserAssingedAllRolesModules(userCode, table);
	}

	@Override
	public Map<String, Object> rolesNotAllowed(List<String> roles) {
		return adminMakerDAO.rolesNotAllowed(roles);
	}

	@Override
	public boolean checkRolesModulesAlreadyAssigned(String userCode,
			List<String> roles, Map<String, List<String>> modulesMap) {
		return adminMakerDAO.checkRolesModulesAlreadyAssigned(userCode, roles, modulesMap);
	}

	@Override
	public String assignRoleModules(String userCode, List<String> roles,
			Map<String, List<String>> modules, String createdBy) {
		String makerId = commonService.getElementId();
		return adminMakerDAO.assignRoleModules(userCode, roles, modules, makerId, createdBy);
	}

	@Override
	public Map<String, Map<String, Map<String, Object>>> getAllUserForRoleMapping(
			String roleId) {
		return adminMakerDAO.getAllUserForRoleMapping(roleId);
	}

	@Override
	public Map<String, String> assingRoleToUserByRole(String roleId, List<String> selectedUser, List<String> unSelectedUser,
			String createdBy) {
		List<String> makerCodeList = new ArrayList<String>();
		int totalNo = selectedUser.size()+unSelectedUser.size();
		for(int i = 0; i < totalNo; i++){
			String makerId = commonService.getElementId();
			if(!makerCodeList.contains(makerId))
				makerCodeList.add(makerId);
		}
		return adminMakerDAO.assingRoleToUserByRole(roleId, selectedUser, unSelectedUser, createdBy, makerCodeList);
	}

	@Override
	public List<Map<String, String>> getAllUserForIPAddressMapping() {
		return adminMakerDAO.getAllUserForIPAddressMapping();
	}

	@Override
	public List<Map<String, String>> getAllIPAddress() {
		return adminMakerDAO.getAllIPAddress();
	}

	@Override
	public List<Map<String, Object>> getAllIPAddressForMapping(String userCode) {
		return adminMakerDAO.getAllIPAddressForMapping(userCode);
	}

	@Override
	public String assignIPAddressToUser(String userCode, List<String> ipAddressList, String createdBy) {
		String makerId = commonService.getElementId();
		return adminMakerDAO.assignIPAddressToUser(userCode, ipAddressList, makerId, createdBy);
	}

	@Override
	public Map<String, Map<String, Map<String, Object>>> getAllUserForIPAddressMapping(
			String ipAddress) {
		return adminMakerDAO.getAllUserForIPAddressMapping(ipAddress);
	}

	@Override
	public Map<String, String> assignUserIPAddress(String ipAddress, List<String> selectedUser, List<String> unSelectedUser, String createdBy) {
		List<String> makerCodeList = new ArrayList<String>();
		int totalNo = selectedUser.size()+unSelectedUser.size();
		for(int i = 0; i < totalNo; i++){
			String makerId = commonService.getElementId();
			if(!makerCodeList.contains(makerId))
				makerCodeList.add(makerId);
		}
		return adminMakerDAO.assignUserIPAddress(ipAddress, selectedUser, unSelectedUser, makerCodeList, createdBy);
	}

	@Override
	public List<Map<String, String>> getAllGroupForModuleMapping() {
		return adminMakerDAO.getAllGroupForModuleMapping();
	}

	@Override
	public List<Map<String, String>> getAllUserForModuleMapping() {
		return adminMakerDAO.getAllUserForModuleMapping();
	}

	@Override
	public List<Map<String, String>> getGroupCode(String userCode) {
		return adminMakerDAO.getGroupCode(userCode);
	}

	@Override
	public List<Map<String, String>> getAllModulesForMapping(String groupCode) {
		return adminMakerDAO.getAllModulesForMapping(groupCode);
	}

	@Override
	public List<Map<String, String>> getAllEmpCodes() {
		return adminMakerDAO.getAllEmpCodes();
	}

	@Override
	public String createUserWithRole(String userCode, String userPass, String firstName, String lastName, 
			String emailId, String mobileNo, String designation, String employeeCode, String departmentCode, String accessStartTime,
			String accessEndTime, String passwordExpiry, String accountExpiryDate, String chatEnabled, String BRANCHCODE,
			String ISETLUSER, String groupCode, String createdBy) {
		String makerId = commonService.getElementId();
		return adminMakerDAO.createUserWithRole(userCode, userPass, firstName, lastName, emailId, mobileNo, designation, employeeCode, 
				departmentCode, accessStartTime, accessEndTime, passwordExpiry, accountExpiryDate, chatEnabled, BRANCHCODE, 
				ISETLUSER, groupCode, createdBy, makerId);
	}
	
	/*@Override
	public List<Map<String, String>> getAllUserFromEditForStatusUpdate(String loggedInUsercode){
		return adminMakerDAO.getAllUserFromEditForStatusUpdate(loggedInUsercode);
	}*/
	
	@Override
	public Map<String, String> getAllStatusOfUser(Map<String, String> inputData) {
		return adminMakerDAO.getAllStatusOfUser(inputData);
	}
	
	/*@Override
	public String updateUserStatus(String userCode, String userStatus, String accountEnabled, String accountExpired,
			String accountDormant, String accountLocked, String accountDeleted, String updatedBy){
		String makerCode = commonService.getElementId();
		return adminMakerDAO.updateUserStatus(userCode, userStatus, accountEnabled, accountExpired, accountDormant,
				accountLocked, accountDeleted, makerCode, updatedBy);
	}*/

}
