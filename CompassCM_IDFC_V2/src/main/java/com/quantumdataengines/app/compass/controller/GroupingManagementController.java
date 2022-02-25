package com.quantumdataengines.app.compass.controller;

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

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.groupingManagement.AccountGroupingService;
import com.quantumdataengines.app.compass.service.groupingManagement.BranchGroupingService;

@Controller
@RequestMapping(value="/common")
public class GroupingManagementController {
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private BranchGroupingService branchGroupingService;
	@Autowired
	private AccountGroupingService accountGroupingService;
	
	//Branch Grouping
	@RequestMapping(value="/branchGrouping", method=RequestMethod.GET)
	public String branchGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "OPEN", "Module Accessed");
		return "GroupingManagement/BranchGrouping/index"; 
	}
	
	@RequestMapping(value="/searchBranchGrouping", method=RequestMethod.POST)
	public String searchBranchGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		
		Map<String, Object> resultMap = branchGroupingService.searchBranchGrouping(groupCode, groupName, description, riskRating);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "SEARCH", "Module Accessed");
		return "GroupingManagement/BranchGrouping/SearchBottomFrame"; 
	}
	
	@RequestMapping(value="/createBranchGrouping", method=RequestMethod.POST)
	public String createBranchGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		Map<String, Object> resultMap = branchGroupingService.createBranchGrouping(groupCode, groupName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "INSERT", "Branch Group Created For Group Code: "+groupCode);
		return "GroupingManagement/BranchGrouping/SearchBottomFrame"; 
	}
	
	@RequestMapping(value="/deleteBranchGrouping", method=RequestMethod.POST)
	public @ResponseBody String deleteBranchGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCodeToDelete = request.getParameter("groupCodeToDelete");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "DELETE", "Branch Group Deleted For Group Code: "+groupCodeToDelete);
	return branchGroupingService.deleteBranchGrouping(groupCodeToDelete);
	}
	
	@RequestMapping(value={"/fetchBranchGroupingDetailsForUpdate"}, method=RequestMethod.POST)
	public String fetchBranchGroupingDetailsForUpdate(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String groupCodeToUpdate = request.getParameter("groupCodeToUpdate");
		
		request.setAttribute("DATAMAP", branchGroupingService.fetchBranchGroupingDetailsForUpdate(groupCodeToUpdate));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "READ", "Module Accessed");
		return "GroupingManagement/BranchGrouping/BranchGroupingDetails";
	}
	
	@RequestMapping(value={"/updateBranchGroupingDetails"}, method=RequestMethod.POST)
	public @ResponseBody String updateBranchGroupingDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		String resultMap = branchGroupingService.updateBranchGroupingDetails(groupCode, groupName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "UPDATE", "Branch Grouping Details Updated For Group Code: "+groupCode);
		return "Successfully Updated";
	}	
	
	@RequestMapping(value="/BranchGroupingDetails", method=RequestMethod.GET)
	public String branchGroupingDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		request.setAttribute("DATAMAP", branchGroupingService.fetchBranchGroupingDetailsForUpdate(groupCode));
		request.setAttribute("RECORDDETAILS", branchGroupingService.branchGroupingRecordDetails(groupCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "READ", "Module Accessed");
		return "GroupingManagement/BranchGrouping/BranchGroupingDetails"; 
	}
	
	@RequestMapping(value="/deleteBranchRecord", method=RequestMethod.POST)
	public @ResponseBody String deleteBranchRecord(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCodeToDelete = request.getParameter("groupCodeToDelete");
		String branchCodeToDelete = request.getParameter("branchCodeToDelete");
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "DELETE", "Branch "+branchCodeToDelete+" Record Deleted For Group Code: "+groupCodeToDelete);
	return branchGroupingService.deleteBranchRecord(branchCodeToDelete, groupCodeToDelete);
	}
	
	@RequestMapping(value="/selectBranchToAdd", method=RequestMethod.POST)
	public String selectBranchToAdd(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("groupCode", groupCode);
		request.setAttribute("searchButton", searchButton);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "OPEN", "Module Accessed");
		return "GroupingManagement/BranchGrouping/AddBranchGroup";
	}
	
	@RequestMapping(value={"/searchBranchForGrouping"}, method=RequestMethod.POST)
	public String searchBranchForGrouping(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String branchCode = request.getParameter("branchCode");
		String branchName = request.getParameter("branchName");
		
		request.setAttribute("RESULTDATA", branchGroupingService.searchBranchForGrouping(branchCode, branchName));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "SEARCH", "Module Accessed");
		return "GroupingManagement/BranchGrouping/AddBranchGroupBottomFrame";
	}
	
	@RequestMapping(value={"/addBranchToGroup"}, method=RequestMethod.POST)
	public @ResponseBody String addBranchToGroup(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String selectedBranchCodes = request.getParameter("selectedBranchCodes");
		String groupCode = request.getParameter("groupCode");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH GROUPING", "INSERT", "Branches Added To Group "+groupCode);
		return branchGroupingService.addBranchToGroup(selectedBranchCodes, userCode, groupCode);
	}
	
	
	//Account Grouping
	@RequestMapping(value="/accountGrouping", method=RequestMethod.GET)
	public String accountGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "OPEN", "Module Accessed");
		return "GroupingManagement/AccountGrouping/index"; 
	}
	
	@RequestMapping(value="/searchAccountGrouping", method=RequestMethod.POST)
	public String searchAccountGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		
		Map<String, Object> resultMap = accountGroupingService.searchAccountGrouping(groupCode, groupName, description, riskRating);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "SEARCH", "Module Accessed");
		return "GroupingManagement/AccountGrouping/SearchBottomFrame"; 
	}
	
	@RequestMapping(value="/createAccountGrouping", method=RequestMethod.POST)
	public String createAccountGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		Map<String, Object> resultMap = accountGroupingService.createAccountGrouping(groupCode, groupName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "INSERT", "Account Grouping Saved For Group Code: "+groupCode);
		return "GroupingManagement/AccountGrouping/SearchBottomFrame"; 
	}
	
	@RequestMapping(value="/deleteAccountGrouping", method=RequestMethod.POST)
	public @ResponseBody String deleteAccountGrouping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCodeToDelete = request.getParameter("groupCodeToDelete");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "DELETE", "Account Grouping Deleted For Group Code: "+groupCodeToDelete);
	return accountGroupingService.deleteAccountGrouping(groupCodeToDelete);
	}
	
	@RequestMapping(value={"/fetchAccountGroupingDetailsForUpdate"}, method=RequestMethod.POST)
	public String fetchAccountGroupingDetailsForUpdate(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String groupCodeToUpdate = request.getParameter("groupCodeToUpdate");
		
		request.setAttribute("DATAMAP", accountGroupingService.fetchAccountGroupingDetailsForUpdate(groupCodeToUpdate));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "READ", "Module Accessed");
		return "GroupingManagement/AccountGrouping/AccountGroupingDetails";
	}
	
	@RequestMapping(value={"/updateAccountGroupingDetails"}, method=RequestMethod.POST)
	public @ResponseBody String updateAccountGroupingDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String groupCode = request.getParameter("groupCode");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		String resultMap = accountGroupingService.updateAccountGroupingDetails(groupCode, groupName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "UPDATE", "Account Grouping Details Updated For Group Code: "+groupCode);
		return "Successfully Updated";
	}	
	
	@RequestMapping(value="/AccountGroupingDetails", method=RequestMethod.GET)
	public String accountGroupingDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATAMAP", accountGroupingService.fetchAccountGroupingDetailsForUpdate(groupCode));
		request.setAttribute("RECORDDETAILS", accountGroupingService.accountGroupingRecordDetails(groupCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "READ", "Module Accessed");
		return "GroupingManagement/AccountGrouping/AccountGroupingDetails"; 
	}

	@RequestMapping(value="/deleteAccountRecord", method=RequestMethod.POST)
	public @ResponseBody String deleteAccountRecord(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCodeToDelete = request.getParameter("groupCodeToDelete");
		String accNoToDelete = request.getParameter("accNoToDelete");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "DELETE", "Account Grouping Details Deleted For Group Code: "+groupCodeToDelete);
		return accountGroupingService.deleteAccountRecord(accNoToDelete, groupCodeToDelete);
	}
	
	@RequestMapping(value="/selectAccountToAdd", method=RequestMethod.POST)
	public String selectAccountToAdd(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String groupCode = request.getParameter("groupCode");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("groupCode", groupCode);
		request.setAttribute("searchButton", searchButton);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "SEARCH", "Module Accessed");
		return "GroupingManagement/AccountGrouping/AddAccountGroup";
	}
	
	@RequestMapping(value={"/searchAccountForGrouping"}, method=RequestMethod.POST)
	public String searchAccountForGrouping(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String accountNo = request.getParameter("accountNo");
		String accountName = request.getParameter("accountName");
		
		request.setAttribute("RESULTDATA", accountGroupingService.searchAccountForGrouping(accountNo, accountName));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "READ", "Module Accessed");
		return "GroupingManagement/AccountGrouping/AddAccountGroupBottomFrame";
	}
	
	@RequestMapping(value={"/addAccountToGroup"}, method=RequestMethod.POST)
	public @ResponseBody String addAccountToGroup(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String selectedAccountNos = request.getParameter("selectedAccountNos");
		String groupCode = request.getParameter("groupCode");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT GROUPING", "INSERT", "Account "+selectedAccountNos+" Added To Group "+groupCode);
		return accountGroupingService.addAccountToGroup(selectedAccountNos, userCode, groupCode);
	}
	
	
}