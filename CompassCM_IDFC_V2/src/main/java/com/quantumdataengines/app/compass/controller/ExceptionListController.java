package com.quantumdataengines.app.compass.controller;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.exceptionList.LEAlistService;
import com.quantumdataengines.app.compass.service.exceptionList.ListDetailsService;
import com.quantumdataengines.app.compass.service.exceptionList.WatchlistService;

import com.sun.org.apache.regexp.internal.recompile;

@Controller
@RequestMapping(value="/common")
public class ExceptionListController {
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private WatchlistService watchlistService;
	@Autowired
	private ListDetailsService listDetailsService;
	@Autowired
	private LEAlistService lealistService;
	
	@RequestMapping(value="/manageWatchlist", method=RequestMethod.GET)
	public String manageWatchlist(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "ExceptionList/ManageWatchlist/index";
	}
	
	@RequestMapping(value = "/searchManageWatchlist", method=RequestMethod.POST) 
	public String searchManageWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String listCode = request.getParameter("listCode");
		String listName = request.getParameter("listName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		
		Map<String, Object> resultMap = watchlistService.searchManageWatchlist(listCode, listName, description, riskRating);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "SEARCH", "Module Accessed");
		return "ExceptionList/ManageWatchlist/SearchBottomFrame";
	}
	
	@RequestMapping(value = "/deleteWatchlist", method=RequestMethod.POST) 
	public @ResponseBody String deleteWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String listCodeToDelete = request.getParameter("listCodeToDelete");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "DELETE", "Watchlist Deleted"+listCodeToDelete);
		return watchlistService.deleteWatchlist(listCodeToDelete);
	}
	
	@RequestMapping(value={"/createWatchlist"}, method=RequestMethod.POST)
	public String createWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		String listName = request.getParameter("listName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		Map<String, Object> resultMap = watchlistService.createWatchlist(listCode, listName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "INSERT", "Watchlist Saved");
		return "ExceptionList/ManageWatchlist/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/fetchWatchlistForUpdate"}, method=RequestMethod.POST)
	public String fetchWatchlistForUpdate(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCodeToUpdate = request.getParameter("listCodeToUpdate");
		String searchButton = request.getParameter("searchButton");
		request.setAttribute("DATAMAP", watchlistService.fetchWatchlistForUpdate(listCodeToUpdate));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton", searchButton);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "READ", "Module Accessed");
		return "ExceptionList/ManageWatchlist/UpdateWatchlistModal";
	}
	
	@RequestMapping(value={"/updateWatchlist"}, method=RequestMethod.POST)
	public @ResponseBody String updateWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		String listName = request.getParameter("listName");
		String description = request.getParameter("description");
		String riskRating = request.getParameter("riskRating");
		String userCode = authentication.getPrincipal().toString();
		
		String resultMap = watchlistService.updateWatchlist(listCode, listName, description, riskRating, userCode);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "UPDATE", "Watchlist Updated");
		return "Successfully Updated";
	}
	
	@RequestMapping(value={"/watchlistDetails"}, method=RequestMethod.GET)
	public String watchlistDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		request.setAttribute("listCode", listCode);
		request.setAttribute("DATAMAP", watchlistService.fetchWatchlistForUpdate(listCode));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RECORDDETAILS", watchlistService.fetchWatchlistDetails(listCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "SEARCH", "Module Accessed");
		return "ExceptionList/ManageWatchlist/WatchlistDetails";
	}
	
	@RequestMapping(value={"/enterNonCustomerDetailsToWatchlist"}, method=RequestMethod.POST)
	public String enterNonCustomerDetailsToWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		
		request.setAttribute("listCode", listCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "ExceptionList/ManageWatchlist/AddNonCustomerToWatchlist";
	}
	
	@RequestMapping(value={"/addNonCustomerToWatchlist"}, method=RequestMethod.POST)
	public @ResponseBody String addNonCustomerToWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		String nonCustomerName = request.getParameter("nonCustomerName");
		String unqid = otherCommonService.getElementId();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "INSERT", "NonCustomer Details Saved to Watchlist "+listCode);
		return watchlistService.addNonCustomerToWatchlist(listCode, unqid, nonCustomerName, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value={"/deleteWatchlistRecord"}, method=RequestMethod.POST)
	public @ResponseBody String deleteWatchlistRecord (HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String unqIdToDelete = request.getParameter("unqIdToDelete");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "DELETE", "Watchlist Deleted "+unqIdToDelete);
		return watchlistService.deleteWatchlistRecord(unqIdToDelete);
	}
	
	@RequestMapping(value={"/selectCustomerToAdd"}, method=RequestMethod.POST)
	public String selectCustomerToAdd(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("listCode", listCode);
		request.setAttribute("searchButton", searchButton);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "ExceptionList/ManageWatchlist/AddCustomerToWatchlist";
	}
	
	@RequestMapping(value={"/searchCustomerToAdd"}, method=RequestMethod.POST)
	public String searchCustomerToAdd(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String customerId = request.getParameter("customerId");
		String customerName = request.getParameter("customerName");
		String riskRating = request.getParameter("riskRating");
		String branchCode = request.getParameter("branchCode");
		
		request.setAttribute("RESULTDATA", watchlistService.searchCustomerToAdd(customerId, customerName, riskRating, branchCode));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "SEARCH", "Module Accessed");
		return "ExceptionList/ManageWatchlist/AddCustomerToWatchlistBottomFrame";
	}
	
	@RequestMapping(value={"/addCustomerToWatchlist"}, method=RequestMethod.POST)
	public @ResponseBody String addCustomerToWatchlist(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("listCode");
		String selectedCustomerIds = request.getParameter("selectedCustomerIds");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "INSERT", "Customer "+selectedCustomerIds+" Added To Watchlist Having ListCode: "+listCode);
		return watchlistService.addCustomerIdsToWatchlist(listCode, selectedCustomerIds, userCode);
	}
	
	//ListDetails
	@RequestMapping(value={"/listDetails"}, method=RequestMethod.GET)
	public String listDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		request.setAttribute("RESULT", listDetailsService.showListDetails());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "ExceptionList/ListDetails/index";
	}
	
	@RequestMapping(value={"/getExceptionListRecords"}, method=RequestMethod.POST)
	public String getExceptionListRecords(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String listCode = request.getParameter("listCode");
		String listCode_Id = request.getParameter("listCode_Id");
		String listCode_Name = request.getParameter("listCode_Name");
		request.setAttribute("listCode", listCode);
		request.setAttribute("isFileUploadEnabled", request.getParameter("isFileUploadEnabled") == null ? "N":request.getParameter("isFileUploadEnabled"));
		request.setAttribute("resultData", listDetailsService.getExceptionListRecords(listCode, listCode_Id, listCode_Name));
		request.setAttribute("UNQID", id);
		request.setAttribute("listCode_Id", listCode_Id);
		request.setAttribute("listCode_Name", listCode_Name);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "SEARCH", "Module Accessed");
		return "ExceptionList/ListDetails/SearchBottomFrame";
	}
	
	@RequestMapping(value={"/exceptionListIdDetails"}, method=RequestMethod.POST)
	public String exceptionListIdDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication){
		String listCode = request.getParameter("listCode");
		String listId = request.getParameter("listId");
		String viewType = request.getParameter("viewType");
		System.out.println("listCode="+listCode+"listId="+listId+"viewType="+viewType);
		request.setAttribute("listCode", listCode);
		request.setAttribute("listId", listId);
		request.setAttribute("viewType", viewType);
		request.setAttribute("resultData", listDetailsService.getExceptionListIdDetails(listCode, listId, viewType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "ExceptionList/ListDetails/ExceptionListIdDetailsModal";		
	}

	@RequestMapping(value={"/realTimeScanningListIdDetails"}, method=RequestMethod.GET)
	public String realTimeScanningListIdDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication){
		String listCode = request.getParameter("listCode");
		String listId = request.getParameter("listId");
		String viewType = request.getParameter("viewType");

		request.setAttribute("listCode", listCode);
		request.setAttribute("listId", listId);
		request.setAttribute("viewType", viewType);
		request.setAttribute("resultData", listDetailsService.getExceptionListIdDetails(listCode, listId, viewType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return "RealTimeScanning/ExceptionListIdDetailsModal";		
	}
	
	@RequestMapping(value="/viewDowjonesRecord")
	public String viewDowjonesRecord(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "ExceptionList/ListDetails/DowjonesList";
		String recordId = request.getParameter("recordId");
		request.setAttribute("RECORDDETAILS", listDetailsService.getRecordDetails(recordId));
		request.setAttribute("RECORDID", recordId);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/dowjoneProfileNotes", method=RequestMethod.POST)
	public @ResponseBody String dowjoneProfileNotes(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String uploadId = request.getParameter("uploadId");
		String recordId = request.getParameter("recordId");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EXCEPTIONLIST", "OPEN", "Module Accessed");
		return listDetailsService.getRecordProfileNote(uploadId, recordId);
	}

	@RequestMapping(value="/leaList", method=RequestMethod.GET)
	public String leaList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("CURRENTROLE", (String)request.getSession().getAttribute("CURRENTROLE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "OPEN", "Module Accessed");
		return "LEAList/index";
	}
	
	@RequestMapping(value="/createLEAList", method=RequestMethod.POST)
	public String createLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton",searchButton);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "OPEN", "LEAList Modal Open");
		return "LEAList/CreateLEAListModal";
	}
	
	@RequestMapping(value="/saveLEAList", method=RequestMethod.POST)
	public @ResponseBody String saveLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String)request.getSession().getAttribute("CURRENTROLE");
		
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Map paramMap = request.getParameterMap();
		Iterator itr = paramMap.keySet().iterator();
		while(itr.hasNext()){
			Object paramNameObj = itr.next();
			String[] paramValueArr = (String[]) paramMap.get(paramNameObj);
			
			String paramName = (String) paramNameObj;
			String paramValue = "";
			
			for(int i = 0; i < paramValueArr.length; i++){
				paramValue = paramValue + paramValueArr[i];
				
				if(paramValueArr.length != (i+1))
					paramValue = paramValue+",";
			}
			dataMap.put(paramName, paramValue);
		}
		//System.out.println(lealistService.saveLEAList(dataMap, userCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "INSERT", "Module Accessed");
		return lealistService.saveLEAList(dataMap, userCode, userRole);
	}
	
	@RequestMapping(value="/searchLEAList", method=RequestMethod.POST)
	public String searchLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String listCode = request.getParameter("listCode");
		String serialNo = request.getParameter("serialNo");
		String listStatus = request.getParameter("listStatus");
		String userRole = (String)request.getSession().getAttribute("CURRENTROLE");
		
		Map<String, Object> resultMap = lealistService.searchLEAList(listCode, serialNo, listStatus, userRole);
		
		request.setAttribute("LISTSTATUS", listStatus);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		//System.out.println("resultData"+resultMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "SEARCH", "Module Accessed");
		return "LEAList/SearchBottomFrame";
	}
	
	@RequestMapping(value="/showLEAListDetails", method=RequestMethod.GET)
	public String showLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String listCode = request.getParameter("listCode");
		String userRole = (String)request.getSession().getAttribute("CURRENTROLE");
		String actionType = "showLEAList";
		
		request.setAttribute("actionType", actionType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATAMAP", lealistService.showLEAListDetails(listCode, actionType, userRole));
		//System.out.println("DATAMAP="+lealistService.showLEAListDetails(listCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "SEARCH", "Module Accessed");
		return "LEAList/LEAListDetails";
	}
	
	@RequestMapping(value="/fetchLEAListForUpdate", method=RequestMethod.POST)
	public String fetchLEAListForUpdate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String listCode = request.getParameter("listCodeToUpdate");
		String userRole = (String)request.getSession().getAttribute("CURRENTROLE");
		String actionType = "fetchLEAListForUpdate";
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("actionType", actionType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton",searchButton);
		request.setAttribute("listCode", listCode);
		request.setAttribute("DATAMAP", lealistService.showLEAListDetails(listCode, actionType, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "SEARCH", "Module Accessed");
		return "LEAList/CreateLEAListModal";
	}
	
	@RequestMapping(value="/updateLEAList", method=RequestMethod.POST)
	public @ResponseBody String updateLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String)request.getSession().getAttribute("CURRENTROLE");
		String listCode = request.getParameter("listCode");
		
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Map paramMap = request.getParameterMap();
		Iterator itr = paramMap.keySet().iterator();
		while(itr.hasNext()){
			Object paramNameObj = itr.next();
			String[] paramValueArr = (String[]) paramMap.get(paramNameObj);
			
			String paramName = (String) paramNameObj;
			String paramValue = "";
			
			for(int i = 0; i < paramValueArr.length; i++){
				paramValue = paramValue + paramValueArr[i];
				
				if(paramValueArr.length != (i+1))
					paramValue = paramValue+",";
			}
			dataMap.put(paramName, paramValue);
		}
		//System.out.println(lealistService.saveLEAList(dataMap, userCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "UPDATE", "Module Accessed");
		return lealistService.updateLEAList(dataMap, listCode, userCode, userRole);
	}
	
	@RequestMapping(value="/approveOrRejectLEAList", method=RequestMethod.POST)
	public @ResponseBody String approveOrRejectLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String listCode = request.getParameter("listCodeToUpdate");
		String status = request.getParameter("status");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "APPROVE", "LIST APPROVED");
		return lealistService.approveOrRejectLEAList(listCode, status, userCode);
	}
	
	/*@RequestMapping(value = "/deleteLEAList", method=RequestMethod.POST) 
	public @ResponseBody String deleteLEAList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String listCode = request.getParameter("listCodeToDelete");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LEALIST", "DELETE", "LEA List Record Deleted"+listCode);
		return lealistService.deleteLEAList(listCode);
	}*/

}
