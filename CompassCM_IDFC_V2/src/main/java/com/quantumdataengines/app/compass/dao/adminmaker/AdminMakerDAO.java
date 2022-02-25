package com.quantumdataengines.app.compass.dao.adminmaker;

import java.util.List;
import java.util.Map;


public interface AdminMakerDAO {
	public List<Map<String, String>> searchUser(String userCode, String firstName, String lastName, String emailId, String mobileNo);
	public List<Map<String, String>> createUser(String userCode, String userPass, String firstName, String lastName,
			String emailId, String mobileNo, String designation,
			String accessStartTime, String accessEndTime, String passwordExpiry, String accountExpiryDate, 
			String chatEnabled, String BRANCHCODE, String ISETLUSER, String createdBy, String makerCode);
	public List<Map<String, String>> getAllUserFromEdit(String loggedInUsercode);
	public Map<String, String> getUserForEdit(String useCode, String tableName, String makerCode, String employeeCode, String employeeName);
	public String updateUserDetails(Map<String, String> userDetails, String actionFlag, String makerId, String updatedBy);
	
	public List<Map<String, String>> searchIPAddress(String ipAddress, String systemName);
	public List<Map<String, String>> createIPAddress(String ipAddress, String systemName, String createdBy, String makerCode);
	public List<Map<String, String>> getAllIPAddressFromEdit();
	public Map<String, String> getIPAddressForEdit(String ipAddress, String tableName, String makerCode);
	public String updateIPAddress(Map<String, String> ipDetails, String makerId, String createdBy);
	
	public List<Map<String, String>> getAllUserForGroupMapping(String loggedInUsercode);
	public List<String> getAllRolesAvailable();
	public Map<String, Map<String, List<Map<String, String>>>> getAllModulesForRoles(List<String> allRoles);
	public Map<String, Object> getUserAssingedAllRolesModules(String userCode, String table);
	public Map<String, Object> rolesNotAllowed(List<String> roles);
	public boolean checkRolesModulesAlreadyAssigned(String userCode, List<String> roles, Map<String, List<String>> modulesMap);
	public String assignRoleModules(String userCode, List<String> roles, Map<String, List<String>> modules, String makerCode, String createdBy);
	
	public Map<String, Map<String, Map<String, Object>>> getAllUserForRoleMapping(String roleId);
	public Map<String, String> assingRoleToUserByRole(String roleId, List<String> selectedUser, List<String> unSelectedUser, String createdBy, List<String> makerCodeList);
	
	public List<Map<String, String>> getAllUserForIPAddressMapping();
	public List<Map<String, String>> getAllIPAddress();
	public List<Map<String, Object>> getAllIPAddressForMapping(String userCode);
	public String assignIPAddressToUser(String userCode, List<String> ipAddressList, String makerCode, String createdBy);
	public Map<String, Map<String, Map<String, Object>>> getAllUserForIPAddressMapping(String ipAddress);
	public Map<String, String> assignUserIPAddress(String ipAddress, List<String> selectedUser, List<String> unSelectedUser, List<String> makerCodeList, String createdBy);
	
	public List<Map<String, String>> getAllGroupForModuleMapping();
	public List<Map<String, String>> getAllUserForModuleMapping();
	public List<Map<String, String>> getGroupCode(String userCode);
	public List<Map<String, String>> getAllModulesForMapping(String groupCode);
	public List<Map<String, String>> getAllEmpCodes();
	public String createUserWithRole(String userCode, String userPass, String firstName, String lastName,
			String emailId, String mobileNo, String designation, String employeeCode, String departmentCode,
			String accessStartTime, String accessEndTime, String passwordExpiry, String accountExpiryDate, 
			String chatEnabled, String BRANCHCODE, String ISETLUSER, String groupCode, String createdBy, String makerCode);
	//public List<Map<String, String>> getAllUserFromEditForStatusUpdate(String loggedInUsercode);
	public Map<String, String> getAllStatusOfUser(Map<String, String> inputData);
	/*public String updateUserStatus(String userCode, String userStatus, String accountEnabled, String accountExpired,
			String accountDormant, String accountLocked, String accountDeleted, String makerCode, String updatedBy);*/
}
