package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.adminMaker.AdminMakerService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CompassEncryptorDecryptor;

@Controller
@RequestMapping(value="/cmUAMMaker")
public class AdminMakerController {
	
	private static final Logger log = LoggerFactory.getLogger(AdminMakerController.class);
	@Autowired
	private AdminMakerService adminMakerService;
	@Autowired
	private CompassEncryptorDecryptor encryptorDecryptor;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	
	@RequestMapping(value={"/createUser"}, method=RequestMethod.GET)
	public String createUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Configuration configuration = commonService.getUserConfiguration();
		if(configuration.getAuthentication().getProvider() == Provider.LDAP){
			request.setAttribute("LDAPSYSTEM", "Y");
		}else
			request.setAttribute("LDAPSYSTEM", "N");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("BRANCHCODES", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		request.setAttribute("DEPARTMENTCODES", genericMasterService.getOptionNameValueFromView("VW_DEPARTMENTCODE"));
		request.setAttribute("DESIGNATIONCODES", genericMasterService.getOptionNameValueFromView("VW_DESIGNATIONCODE"));
		request.setAttribute("ALLROLES", adminMakerService.getAllRolesAvailable());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "User Created");
		return "adminMaker/createUser/index";
	}
	
	@RequestMapping(value={"/searchUserForm"}, method=RequestMethod.POST)
	public String searchUserForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("userCode");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String emailId = request.getParameter("emailId");
		String mobileNo = request.getParameter("mobileNo");
		request.setAttribute("SEARCHEDUSER", adminMakerService.searchUser(userCode, firstName, lastName, emailId, mobileNo));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/createUser/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/createUserForm"}, method=RequestMethod.POST)
	public String createUserForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("userCode");
		String userPass = request.getParameter("userPass");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String emailId = request.getParameter("emailId");
		String mobileNo = request.getParameter("mobileNo");
		String designation = request.getParameter("designation");
		String accessStartTime = request.getParameter("accessStartTime");
		String accessEndTime = request.getParameter("accessEndTime");
		String accountExpiryDate = request.getParameter("accountExpiryDate");
		String passwordReset = "N";
		String chatEnabled = "N";
		String BRANCHCODE = request.getParameter("BRANCHCODE");
		String ISETLUSER = request.getParameter("ISETLUSER");
		if(request.getParameter("passwordReset") != null && !"".equals(request.getParameter("passwordReset")))
			passwordReset = request.getParameter("passwordReset").equals("true") ? "Y" : "N";
		
		if(request.getParameter("chatEnabled") != null && !"".equals(request.getParameter("chatEnabled")))
			chatEnabled = request.getParameter("chatEnabled").equals("true") ? "Y" : "N";
		
		userPass = encryptorDecryptor.encrypt(userPass);
		
		List<Map<String, String>> resultMap = adminMakerService.createUser(userCode, userPass,
				firstName, lastName, emailId, mobileNo, designation, accessStartTime, accessEndTime, 
				passwordReset, accountExpiryDate, chatEnabled, BRANCHCODE, ISETLUSER, authentication.getPrincipal().toString());
		if(resultMap.size() > 0){
			request.setAttribute("USERCREATED", "0");
		}
		request.setAttribute("SEARCHEDUSER", resultMap);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return "adminMaker/createUser/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/editUser"}, method=RequestMethod.GET)
	public String editUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Configuration configuration = commonService.getUserConfiguration();
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String loggedInUsercode = domainUser.getUsername();

		if(configuration.getAuthentication().getProvider() == Provider.LDAP){
			request.setAttribute("LDAPSYSTEM", "Y");
		}else
			request.setAttribute("LDAPSYSTEM", "N");
		request.setAttribute("SELECTEDUSER", request.getParameter("usercode"));
		request.setAttribute("ALLUSER", adminMakerService.getAllUserFromEdit(loggedInUsercode));
		request.setAttribute("ALLEMPCODES", adminMakerService.getAllEmpCodes());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/editUser/index";
	}
	
	
	@RequestMapping(value={"/editIPAddress"}, method=RequestMethod.GET)
	public String editIPAddress(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("SELECTEDIPADDRESS", request.getParameter("ipAddress"));
		request.setAttribute("ALLIPADDRESS", adminMakerService.getAllIPAddressFromEdit());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/editIPAddress/index";
	}
	
	@RequestMapping(value={"/searchUserFormForEdit"}, method=RequestMethod.POST)
	public String searchUserFormForEdit(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		try{
			String userCode = request.getParameter("userCode");
			String table = "";
			String makerCode = "";
			String employeeCode = request.getParameter("employeeCode");
			
		if(!"ALL".equalsIgnoreCase(request.getParameter("userCode"))){
			userCode = userCode.split(",")[0];
			table = request.getParameter("userCode").split(",")[1];
			makerCode = request.getParameter("userCode").split(",")[2];
		}
		
		if(!"ALL".equalsIgnoreCase(request.getParameter("employeeCode"))){
			employeeCode = employeeCode.split(",")[0];
			table = request.getParameter("employeeCode").split(",")[1];
			makerCode = request.getParameter("employeeCode").split(",")[2];
		}
		
		String employeeName = "";
		
		//System.out.println("search MakerCode="+makerCode+"&userCode = "+userCode+"&table = "+table+"&employeeCode = "+employeeCode);
		
		Map<String,String> inputData = new HashMap<String,String>();
		inputData.put("USERCODE", userCode);
		inputData.put("TABLENAME", table);
		inputData.put("MAKERCODE", makerCode);
		inputData.put("EMPLOYEECODE", employeeCode);
		Map<String,String> allStatusOfUser = adminMakerService.getAllStatusOfUser(inputData);
		request.setAttribute("ALLSTATUSOFUSER", allStatusOfUser);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		request.setAttribute("USERFOREDIT", adminMakerService.getUserForEdit(userCode, table, makerCode, employeeCode, employeeName));
		request.setAttribute("BRANCHCODES", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		request.setAttribute("DEPARTMENTCODES", genericMasterService.getOptionNameValueFromView("VW_DEPARTMENTCODE"));
		request.setAttribute("ALLROLES", adminMakerService.getAllRolesAvailable());
		request.setAttribute("DESIGNATIONCODES", genericMasterService.getOptionNameValueFromView("VW_DESIGNATIONCODE"));
		
		}catch(Exception e){}
		Configuration configuration = commonService.getUserConfiguration();
		if(configuration.getAuthentication().getProvider() == Provider.LDAP){
			request.setAttribute("LDAPSYSTEM", "Y");
		}else
			request.setAttribute("LDAPSYSTEM", "N");
		request.setAttribute("ELMID",  request.getParameter("elmId"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/editUser/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/updateUser"}, method=RequestMethod.POST)
	public @ResponseBody String updateUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("usercode");
		String userPass = "";
		if(request.getParameter("userPass") != null && request.getParameter("userPass").trim().length() > 0)
			userPass = encryptorDecryptor.encrypt(request.getParameter("userPass"));
		 
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String emailId = request.getParameter("emailId");
		String mobileNo = request.getParameter("mobileNo");
		String designation = request.getParameter("designation");
		String accountEnabled = request.getParameter("accountenable");
		String passwordExpired = request.getParameter("passwordExired");
		String accessStartTime = request.getParameter("accessstarttime");
		String accessEndTime = request.getParameter("accessendtime");
		String accountExpiryDate = request.getParameter("accountexpirydate");
		String chatEnable = request.getParameter("chatEnabled");
		String branchCode = request.getParameter("branchCode");
		String isETLUser = request.getParameter("isETLUser");
		String accountExpired = request.getParameter("accountExpired");
		String accountLocked = request.getParameter("accountLocked");
		String accountDeleted = request.getParameter("accountDeleted");
		String groupCode = request.getParameter("groupCode");
		String departmentCode = request.getParameter("departmentCode");
		String employeeCode = request.getParameter("employeeCode");
		String actionFlag = request.getParameter("actionFlag");
		String accountDormant = request.getParameter("accountDormant");
		String updatedBy = authentication.getPrincipal().toString();
		/*System.out.println(emailId);
		System.out.println(employeeCode);
		System.out.println(departmentCode);
		System.out.println(branchCode);*/
		Map<String, String> userDetails = new HashMap<String, String>();
		userDetails.put("USERCODE", userCode);
		userDetails.put("USERPASS", userPass);
		userDetails.put("FIRSTNAME", firstname);
		userDetails.put("LASTNAME", lastname);
		userDetails.put("EMAILID", emailId);
		userDetails.put("MOBILENO", mobileNo);
		userDetails.put("DESIGNATION", designation);
		userDetails.put("ACCOUNTENABLE", accountEnabled);
		userDetails.put("CREDENTIALEXPIRED", passwordExpired);
		userDetails.put("ACCESSSTARTTIME", accessStartTime);
		userDetails.put("ACCESSENDTIME", accessEndTime);
		userDetails.put("ACCOUNTEXIPYDATE", accountExpiryDate);
		userDetails.put("CHATENABLE", chatEnable);
		userDetails.put("BRANCHCODE", branchCode);
		userDetails.put("ISETLUSER", isETLUser);
		userDetails.put("ACCOUNTEXPIRED", accountExpired);
		userDetails.put("ACCOUNTLOCKED", accountLocked);
		userDetails.put("ACCOUNTDELETED", accountDeleted);
		userDetails.put("GROUPCODE", groupCode);
		userDetails.put("DEPARTMENTCODE", departmentCode);
		userDetails.put("EMPLOYEECODE", employeeCode);
		userDetails.put("ACCOUNTDORMANT", accountDormant);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "UPDATE", "Data Updated");
		return adminMakerService.updateUserDetails(userDetails, actionFlag, updatedBy);
	}
	
	@RequestMapping(value={"/createIPAddress"}, method=RequestMethod.GET)
	public String createIPAddress(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/createIPAddress/index";
	}
	
	@RequestMapping(value={"/searchIPAddressForm"}, method=RequestMethod.POST)
	public String searchIPAddressForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipAddress = request.getParameter("ipAddress");
		String systemName = request.getParameter("systemName");
		request.setAttribute("SEARCHEDIP", adminMakerService.searchIPAddress(ipAddress, systemName));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/createIPAddress/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/createIPAddressForm"}, method=RequestMethod.POST)
	public String createIPAddressForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipAddress = request.getParameter("ipAddress");
		String systemName = request.getParameter("systemName");
		List<Map<String, String>> resultMap = adminMakerService.createIPAddress(ipAddress, systemName, authentication.getPrincipal().toString());
		if(resultMap.size() > 0){
			request.setAttribute("IPCREATED", "0");
		}
		request.setAttribute("SEARCHEDIP", resultMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return "adminMaker/createIPAddress/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/searchIPAddressFormForEdit"}, method=RequestMethod.POST)
	public String searchIPAddressFormForEdit(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		try{
			String ipAddress = request.getParameter("ipAddress").split(",")[0];
			String table = request.getParameter("ipAddress").split(",")[1];
			String makerCode = request.getParameter("ipAddress").split(",")[2];
			
			request.setAttribute("IPADDRESSFOREDIT", adminMakerService.getIPAddressForEdit(ipAddress, table, makerCode));
		}catch(Exception e){}
		request.setAttribute("ELMID",  request.getParameter("elmId"));
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "READ", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/editIPAddress/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/updateIPAddress"}, method=RequestMethod.POST)
	public @ResponseBody String updateIPAddress(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipAddress = request.getParameter("ipAddress");
		String systemName = request.getParameter("systemName");
		String isEnabled = request.getParameter("enabled");
		
		Map<String, String> ipDetails = new HashMap<String, String>();
		ipDetails.put("IPADDRESS", ipAddress);
		ipDetails.put("SYSTEMNAME", systemName);
		ipDetails.put("ENABLED", isEnabled);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "UPDATE", "Data Updated");
		return adminMakerService.updateIPAddress(ipDetails, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value={"/userGroupMapping"}, method=RequestMethod.GET)
	public String userGroupMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String loggedInUsercode = domainUser.getUsername();
		
		request.setAttribute("ALLUSER", adminMakerService.getAllUserForGroupMapping(loggedInUsercode));
		request.setAttribute("ALLROLES", adminMakerService.getAllRolesAvailable());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/userGroupMapping/index";
	}
	
	@RequestMapping(value={"/searchUserForGroupMapping"}, method=RequestMethod.POST)
	public String searchUserForGroupMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCodetable = request.getParameter("usercode");
		List<String> allRoles = adminMakerService.getAllRolesAvailable();
		String userCode = userCodetable.split(",")[0];
		String table = userCodetable.split(",")[1];
		
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("ALLROLES", allRoles);
		request.setAttribute("ALLMODULES", adminMakerService.getAllModulesForRoles(allRoles));
		request.setAttribute("ASSIGNEDROLESMODULE", adminMakerService.getUserAssingedAllRolesModules(userCode, table));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/userGroupMapping/UserGroupMapping";
	}
	
	@RequestMapping(value={"/searchGroupForUserMapping"}, method=RequestMethod.POST)
	public String searchGroupForUserMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String roleId = request.getParameter("roleId");
		request.setAttribute("ROLEID", roleId);
		request.setAttribute("ALLUSER", adminMakerService.getAllUserForRoleMapping(roleId));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/userGroupMapping/GroupUserMapping";
	}
	
	@RequestMapping(value={"/assignRoleModule"}, method=RequestMethod.POST)
	public @ResponseBody String assignRoleModule(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String message = "";
		String userCode = request.getParameter("userCode");
		String roleAssigned = request.getParameter("roleAssigned");
		String mainModuleAssigned = request.getParameter("mainModuleAssigned");
		String subModuleAssigned = request.getParameter("subModuleAssigned");
		List<String> rolesAssigned = new ArrayList<String>();
		List<String> fullAssignedRoles = new ArrayList<String>();
		Map<String, List<String>> moduleAssigned = new HashMap<String, List<String>>();
		try{
			String[] roles = roleAssigned.split(",");
			for(String role : roles){
				if(!"".equals(role)){
					rolesAssigned.add(role);
					fullAssignedRoles.add(role);
				}	
			}
		}catch(Exception e){e.printStackTrace();}
		
		try{
			String[] mainModules = mainModuleAssigned.split(",");
			for(String mainModule : mainModules){
				if(!"".equals(mainModule)){
					String roleModuleStr = mainModule.substring(1, mainModule.length()-1);
					String[] roleModuleArr = roleModuleStr.split("\\^");
					if(!rolesAssigned.contains(roleModuleArr[0]))
						rolesAssigned.add(roleModuleArr[0]);
					if(moduleAssigned.containsKey(roleModuleArr[0])){
						moduleAssigned.get(roleModuleArr[0]).add(roleModuleArr[1]);
					}else{
						List<String> moduleList = new ArrayList<String>();
						moduleList.add(roleModuleArr[1]);
						moduleAssigned.put(roleModuleArr[0], moduleList);
					}
				}
			}
			
			String[] subModules = subModuleAssigned.split(",");
			for(String subModule : subModules){
				if(!"".equals(subModule)){
					String roleModuleStr = subModule.substring(1, subModule.length()-1);
					String[] roleModuleArr = roleModuleStr.split("\\^");
					if(!rolesAssigned.contains(roleModuleArr[0]))
						rolesAssigned.add(roleModuleArr[0]);
					if(moduleAssigned.containsKey(roleModuleArr[0])){
						moduleAssigned.get(roleModuleArr[0]).add(roleModuleArr[1]);
					}else{
						List<String> moduleList = new ArrayList<String>();
						moduleList.add(roleModuleArr[1]);
						moduleAssigned.put(roleModuleArr[0], moduleList);
					}					
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		Map<String, Object> resultMap = adminMakerService.rolesNotAllowed(rolesAssigned);
		Boolean isValid = (Boolean) resultMap.get("VALID");
		if(isValid){
			if(adminMakerService.checkRolesModulesAlreadyAssigned(userCode, rolesAssigned, moduleAssigned)){
				message = adminMakerService.assignRoleModules(userCode, rolesAssigned, moduleAssigned, authentication.getPrincipal().toString());
			}else{
				message = "All selected groups and modules are already assigned. Select some new with existing and try to assign";
			}
		}else{
			message = (String) resultMap.get("MESSAGE");
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return message;
	}
	
	@RequestMapping(value={"/assignUserRole"}, method=RequestMethod.POST)
	public @ResponseBody Map<String, String> assignUserRole(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String selectedUser = request.getParameter("userSelected") != null ? request.getParameter("userSelected") : "";
		String unSelectedUser = request.getParameter("userUnselected") != null ? request.getParameter("userUnselected") : "";
		String roleSelected = request.getParameter("role");
		String[] arrSelected = selectedUser.split(",");
		String[] arrUnselected = unSelectedUser.split(",");
		List<String> listUserSelected = new ArrayList<String>();
		List<String> listUserUnselected = new ArrayList<String>();
		for(String selected : arrSelected){
			if(!"".equals(selected))
				listUserSelected.add(selected);
		}
		for(String unSelected : arrUnselected){
			if(!"".equals(unSelected))
				listUserUnselected.add(unSelected);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return adminMakerService.assingRoleToUserByRole(roleSelected, listUserSelected, listUserUnselected, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value={"/userIPMapping"}, method=RequestMethod.GET)
	public String userIPMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("ALLUSER", adminMakerService.getAllUserForIPAddressMapping());
		request.setAttribute("ALLIPADDRESS", adminMakerService.getAllIPAddress());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/userIPAddressMapping/index";
	}
	
	@RequestMapping(value={"/searchIPAddressForUserMapping"}, method=RequestMethod.POST)
	public String searchIPAddressForUserMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String[] arrUserCode = request.getParameter("usercode").split(",");
		String userCode = arrUserCode[0];
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("ALLIPADDRESS", adminMakerService.getAllIPAddressForMapping(userCode));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/userIPAddressMapping/UserIPAddressMapping";
	}
	
	@RequestMapping(value={"/assignIPAddressToUser"}, method=RequestMethod.POST)
	public @ResponseBody String assignIPAddressToUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		List<String> ipAddressList = new ArrayList<String>();
		String userCode = request.getParameter("userCode");
		String ipAddresses = request.getParameter("selectedIPs");
		String[] ipAddressArr = ipAddresses.split(",");
		for(String ipAddress : ipAddressArr){
			ipAddressList.add(ipAddress);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return adminMakerService.assignIPAddressToUser(userCode, ipAddressList, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value={"/searchUserForIPAddressMapping"}, method=RequestMethod.POST)
	public String searchUserForIPAddressMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipAddress = request.getParameter("ipAddress");
		request.setAttribute("IPADDRESS", ipAddress);
		request.setAttribute("ALLIPADDRESS", adminMakerService.getAllUserForIPAddressMapping(ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "READ", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/userIPAddressMapping/IPAddressUserMapping";
	}
	
	@RequestMapping(value={"/assignUserIPAddress"}, method=RequestMethod.POST)
	public @ResponseBody Map<String,String> assignUserIPAddress(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipAddress = request.getParameter("ipAddress");
		String selectedUser = request.getParameter("userSelected") != null ? request.getParameter("userSelected") : "";
		String unSelectedUser = request.getParameter("userUnselected") != null ? request.getParameter("userUnselected") : "";
		String[] arrSelected = selectedUser.split(",");
		String[] arrUnselected = unSelectedUser.split(",");
		List<String> listUserSelected = new ArrayList<String>();
		List<String> listUserUnselected = new ArrayList<String>();
		for(String selected : arrSelected){
			if(!"".equals(selected))
				listUserSelected.add(selected);
		}
		for(String unSelected : arrUnselected){
			if(!"".equals(unSelected))
				listUserUnselected.add(unSelected);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		return adminMakerService.assignUserIPAddress(ipAddress, listUserSelected, listUserUnselected, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value={"/moduleMapping"}, method=RequestMethod.GET)
	public String moduleMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("ALLGROUP", adminMakerService.getAllGroupForModuleMapping());
		request.setAttribute("ALLUSERS", adminMakerService.getAllUserForModuleMapping());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MODULE GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/moduleMapping/index";
	}
	
	@RequestMapping(value="/getGroupCode", method=RequestMethod.POST)
	public @ResponseBody List<Map<String, String>> getGroupCode(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String userCode = request.getParameter("userCode");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MODULE GROUPING", "READ", "Module Accessed");
		return adminMakerService.getGroupCode(userCode);
	}
	@RequestMapping(value={"/searchGroupForModuleMapping"}, method=RequestMethod.POST)
	public String searchGroupForModuleMapping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String groupCode = request.getParameter("groupCode");
		request.setAttribute("GROUPCODE", groupCode.replaceFirst("ROLE_", ""));
		request.setAttribute("ALLMODULES", adminMakerService.getAllModulesForMapping(groupCode));
		//request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MODULE GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/moduleMapping/GroupModuleMapping";
	}
	
	@RequestMapping(value={"/createUserWithRole"}, method=RequestMethod.POST)
	public @ResponseBody String createUserWithRole(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("userCode");
		String userPass = request.getParameter("userPass");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String emailId = request.getParameter("emailId");
		String mobileNo = request.getParameter("mobileNo");
		String designation = request.getParameter("designation");
		String employeeCode = request.getParameter("employeeCode");
		String departmentCode = request.getParameter("departmentCode");
		String BRANCHCODE = request.getParameter("branchCode");
		String groupCode = request.getParameter("groupCode");
		/*System.out.println("Controller ---- userCode="+userCode+"&userPass="+userPass+"&firstName="+firstName+"&lastName="+lastName+
							   "&emailId="+emailId+"&mobileNo="+mobileNo+"&designation="+designation+
							   "&employeeCode="+employeeCode+"&branchCode="+BRANCHCODE+"&departmentCode="+departmentCode+
							   "&groupCode="+groupCode);*/
		String accessStartTime = request.getParameter("accessStartTime");
		String accessEndTime = request.getParameter("accessEndTime");
		String accountExpiryDate = request.getParameter("accountExpiryDate");
		String passwordExpiry = "N";
		String chatEnabled = "N";
		String ISETLUSER = request.getParameter("ISETLUSER");
		if(request.getParameter("passwordReset") != null && !"".equals(request.getParameter("passwordReset")))
			passwordExpiry = request.getParameter("passwordReset").equals("true") ? "Y" : "N";
		
		if(request.getParameter("chatEnabled") != null && !"".equals(request.getParameter("chatEnabled")))
			chatEnabled = request.getParameter("chatEnabled").equals("true") ? "Y" : "N";
		
		userPass = encryptorDecryptor.encrypt(userPass);
		
		String result = adminMakerService.createUserWithRole(userCode, userPass, firstName, lastName, emailId,
				mobileNo, designation, employeeCode, departmentCode, accessStartTime, accessEndTime, 
				passwordExpiry, accountExpiryDate, chatEnabled, BRANCHCODE, ISETLUSER, groupCode, 
				authentication.getPrincipal().toString());
		/*if(resultMap.size() > 0){
			request.setAttribute("USERCREATED", "0");
		}
		request.setAttribute("SEARCHEDUSER", resultMap);*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "INSERT", "Data Saved");
		System.out.println(result);
		return result;
	}
	
	/*@RequestMapping(value={"/editUserStatus"}, method=RequestMethod.GET)
	public String editUserStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Configuration configuration = commonService.getUserConfiguration();
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String loggedInUsercode = domainUser.getUsername();
		
		if(configuration.getAuthentication().getProvider() == Provider.LDAP){
			request.setAttribute("LDAPSYSTEM", "Y");
		}else
			request.setAttribute("LDAPSYSTEM", "N");
		//request.setAttribute("ALLUSER", adminMakerService.getAllUserFromEditForStatusUpdate(loggedInUsercode));
		request.setAttribute("ALLUSER", adminMakerService.getAllUserFromEdit(loggedInUsercode));
		request.setAttribute("ALLEMPCODES", adminMakerService.getAllEmpCodes());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "OPEN", "Module Accessed");
		return "adminMaker/editUserStatus/index";
	}*/
	
	/*@RequestMapping(value={"/getAllStatusOfUser"}, method=RequestMethod.POST)
	public String getAllStatusOfUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		try{
			String userCode = request.getParameter("userCode");
			String table = "";
			String makerCode = "";
			String employeeCode = request.getParameter("employeeCode");
			
			if(!"ALL".equalsIgnoreCase(request.getParameter("userCode"))){
				userCode = userCode.split(",")[0];
				table = request.getParameter("userCode").split(",")[1];
				makerCode = request.getParameter("userCode").split(",")[2];
			}
			
			if(!"ALL".equalsIgnoreCase(request.getParameter("employeeCode"))){
				employeeCode = employeeCode.split(",")[0];
				table = request.getParameter("employeeCode").split(",")[1];
				makerCode = request.getParameter("employeeCode").split(",")[2];
			}
			
			String employeeName = "";
			Map<String,String> inputData = new HashMap<String,String>();
			inputData.put("USERCODE", userCode);
			inputData.put("TABLENAME", table);
			inputData.put("MAKERCODE", makerCode);
			inputData.put("EMPLOYEECODE", employeeCode);
			Map<String,String> allStatusOfUser = adminMakerService.getAllStatusOfUser(inputData);
			
			request.setAttribute("ALLSTATUSOFUSER", allStatusOfUser);
			request.setAttribute("UNQID", otherCommonService.getElementId());
		}catch(Exception e){}
		Configuration configuration = commonService.getUserConfiguration();
		if(configuration.getAuthentication().getProvider() == Provider.LDAP){
			request.setAttribute("LDAPSYSTEM", "Y");
		}else
			request.setAttribute("LDAPSYSTEM", "N");
		request.setAttribute("ELMID",  request.getParameter("elmId"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER GROUPING", "SEARCH", "Module Accessed");
		return "adminMaker/editUserStatus/SearchBottomPage";
	}*/
	
	/*@RequestMapping(value={"/updateUserStatus"}, method=RequestMethod.POST)
	public @ResponseBody String updateUserStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("userCode");
		String userPass = "";
		if(request.getParameter("userPass") != null && request.getParameter("userPass").trim().length() > 0)
			userPass = encryptorDecryptor.encrypt(request.getParameter("userPass"));
		String userStatus = request.getParameter("userStatus");
		String accountEnabled = request.getParameter("accountenable");
		String accountExpired = request.getParameter("accountExpired");
		String accountLocked = request.getParameter("accountLocked");
		String accountDeleted = request.getParameter("accountDeleted");
		String accountDormant = request.getParameter("accountDormant");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String emailId = request.getParameter("emailId");
		String mobileNo = request.getParameter("mobileNo");
		String designation = request.getParameter("designation");
		String passwordExpired = request.getParameter("passwordExired");
		String accessStartTime = request.getParameter("accessstarttime");
		String accessEndTime = request.getParameter("accessendtime");
		String accountExpiryDate = request.getParameter("accountexpirydate");
		String chatEnable = request.getParameter("chatEnabled");
		String branchCode = request.getParameter("branchCode");
		String isETLUser = request.getParameter("isETLUser");
		String groupCode = request.getParameter("groupCode");
		String departmentCode = request.getParameter("departmentCode");
		String employeeCode = request.getParameter("employeeCode");
		String actionFlag = request.getParameter("actionFlag");
		String updatedBy = authentication.getPrincipal().toString();
		
		Map<String, String> userDetails = new HashMap<String, String>();
		userDetails.put("USERCODE", userCode);
		userDetails.put("USERPASS", userPass);
		userDetails.put("FIRSTNAME", firstname);
		userDetails.put("LASTNAME", lastname);
		userDetails.put("EMAILID", emailId);
		userDetails.put("MOBILENO", mobileNo);
		userDetails.put("DESIGNATION", designation);
		userDetails.put("ACCOUNTENABLE", accountEnabled);
		userDetails.put("CREDENTIALEXPIRED", passwordExpired);
		userDetails.put("ACCESSSTARTTIME", accessStartTime);
		userDetails.put("ACCESSENDTIME", accessEndTime);
		userDetails.put("ACCOUNTEXIPYDATE", accountExpiryDate);
		userDetails.put("CHATENABLE", chatEnable);
		userDetails.put("BRANCHCODE", branchCode);
		userDetails.put("ISETLUSER", isETLUser);
		userDetails.put("ACCOUNTEXPIRED", accountExpired);
		userDetails.put("ACCOUNTLOCKED", accountLocked);
		userDetails.put("ACCOUNTDELETED", accountDeleted);
		userDetails.put("GROUPCODE", groupCode);
		userDetails.put("DEPARTMENTCODE", departmentCode);
		userDetails.put("EMPLOYEECODE", employeeCode);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER CREATION", "UPDATE", "Data Updated");
		
		return adminMakerService.updateUserDetails(userDetails, actionFlag, updatedBy);
	}*/
}
