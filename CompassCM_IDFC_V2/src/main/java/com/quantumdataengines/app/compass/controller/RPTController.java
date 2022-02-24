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
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.rptWatchList.RPTWatchListService;

@Controller
public class RPTController {
	
	private static final Logger log = LoggerFactory.getLogger(RPTController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private RPTWatchListService rptWatchListService;
	
	@RequestMapping(value={"/rptmaker/","/rptmaker/index"}, method=RequestMethod.GET)
	public String getRPTMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		return "rptMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/rptadmin/","/rptadmin/index"}, method=RequestMethod.GET)
	public String getRPTAdminIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		return "rptAdminIndexTemplete";
	}
	
	@RequestMapping(value="/rptcommon/rptWatchListMaker", method=RequestMethod.GET)
	public String getRPTWatchListMaker(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String moduleType = "RPTWatchList";
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "Module Accessed");
		return "RPTWatchList/RPTWatchList";
	}
	
	@RequestMapping(value="/rptmaker/createNewRPTWatchList", method=RequestMethod.POST)
	public @ResponseBody String createNewRPTWatchList(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String LISTCODE = request.getParameter("LISTCODE");
		String LISTNAME = request.getParameter("LISTNAME");
		String LISTTYPE = request.getParameter("LISTTYPE");
		String DESCRIPTION = request.getParameter("DESCRIPTION");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "INSERT", "RPT WatchList Created");
		return rptWatchListService.createRPTList(LISTCODE, LISTNAME, DESCRIPTION, LISTTYPE, authentication.getPrincipal().toString());
	}

	@RequestMapping(value="/rptcommon/openRPTWatchListDetails", method=RequestMethod.POST)
	public String openRPTWatchListDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String listCode = request.getParameter("listCode");
		request.setAttribute("RPTDETAILS", rptWatchListService.openRPTWatchListDetails(listCode, authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "RPT WatchList Details Opened");
		return "RPTWatchList/RPTWatchListDetails";
	}
	
	@RequestMapping(value="/rptcommon/getRPTWatchListCustomerDetails", method=RequestMethod.POST)
	public String getRPTWatchListCustomerDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String listCode = request.getParameter("LISTCODE");
		String entityName = request.getParameter("ENTITYNAME");
		String entityId = request.getParameter("ENTITYID");
		String idNo = request.getParameter("IDNO");
		String entityStatus = request.getParameter("CUSTSTATUS");
		request.setAttribute("SEARCHRESULT", rptWatchListService.openRPTWatchListCustomerDetails(listCode, entityName, entityId, idNo, entityStatus));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MODULETYPE", "rptWatchListCustomerDetails");
		request.setAttribute("MODULENAME", "RPT WatchList");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "RPT WatchList Customer Details Opened");
		return "RPTWatchList/SearchBottomPage";
	}
	
	
	@RequestMapping(value="/rptmaker/addRPTEntity", method=RequestMethod.POST)
	public String addRPTEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String LISTCODE = request.getParameter("LISTCODE");
		String ENTITYID = request.getParameter("ENTITYID");
		String LISTNAME = request.getParameter("LISTNAME");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("LISTCODE", LISTCODE);
		request.setAttribute("LISTNAME", LISTNAME);
		request.setAttribute("ENTITYID", ENTITYID);
		request.setAttribute("RPTADDENTITYDETAILS", rptWatchListService.getRPTAddEntityDetails());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "RPT WatchList Add Entity Form Open");
		return "RPTWatchList/AddEntity";
	}
	
	
	@RequestMapping(value="/rptcommon/viewUpdateRPTEntity", method=RequestMethod.POST)
	public String viewUpdateRPTEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String LISTCODE = request.getParameter("LISTCODE");
		String ENTITYID = request.getParameter("ENTITYID");
		String LISTNAME = request.getParameter("LISTNAME");
		String AUTHORIZE = request.getParameter("AUTHORIZE");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("LISTCODE", LISTCODE);
		request.setAttribute("LISTNAME", LISTNAME);
		request.setAttribute("ENTITYID", ENTITYID);
		request.setAttribute("AUTHORIZE", AUTHORIZE);
		request.setAttribute("RPTADDENTITYDETAILS", rptWatchListService.getRPTAddEntityDetails());
		request.setAttribute("RPTENTITYDETAILS", rptWatchListService.openRPTWatchListCustomerDetails(LISTCODE, "", ENTITYID, "", ""));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "RPT WatchList Add Entity Form Open");
		return "RPTWatchList/AddEntity";
	}
	
	@RequestMapping(value="/rptmaker/updateRPTWatchList", method=RequestMethod.POST)
	public @ResponseBody String updateRPTWatchList(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String LISTCODE = request.getParameter("LISTCODE");
		String LISTNAME = request.getParameter("LISTNAME");
		String DESCRIPTION = request.getParameter("DESCRIPTION");
		String LISTTYPE = request.getParameter("LISTTYPE");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList Update Entity");
		return rptWatchListService.updateRPTWatchList(LISTCODE, LISTNAME, DESCRIPTION, LISTTYPE, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/rptmaker/addEntity", method=RequestMethod.POST)
	public @ResponseBody String addEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String LISTCODE = request.getParameter("LISTCODE");
		String LISTNAME = request.getParameter("LISTNAME");
		String ENTITYNAME = request.getParameter("ENTITYNAME");
		String ENTITYID = request.getParameter("ENTITYID");
		String IDTYPE = request.getParameter("IDTYPE");
		String IDNO = request.getParameter("IDNO");
		String RELATEDTHROUGH = request.getParameter("RELATEDTHROUGH");
		String SHAREHOLDING = request.getParameter("SHAREHOLDING");
		String RELATION = request.getParameter("RELATION");
		String SUBRELATION = request.getParameter("SUBRELATION");
		String DROPDOWN1 = request.getParameter("DROPDOWN1");
		String DROPDOWN2 = request.getParameter("DROPDOWN2");
		String REMARKS = request.getParameter("REMARKS");
		String STATUS = request.getParameter("STATUS");
		String AUTHORIZER = request.getParameter("AUTHORIZER");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "INSERT", "RPT Entity Added");
		return rptWatchListService.addUpdateEntity(LISTCODE, LISTNAME, ENTITYNAME, ENTITYID, IDTYPE, IDNO,
				RELATEDTHROUGH, SHAREHOLDING, RELATION, SUBRELATION, DROPDOWN1, DROPDOWN2, 
				REMARKS, STATUS, AUTHORIZER, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/rptmaker/removeEntity", method=RequestMethod.POST)
	public @ResponseBody String removeEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String ENTITYID = request.getParameter("ENTITYID");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList Remove Entity");
		return rptWatchListService.removeDisableRPTWatchList(ENTITYID, "PD", "N", authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/rptmaker/disableEntity", method=RequestMethod.POST)
	public @ResponseBody String disableEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String ENTITYID = request.getParameter("ENTITYID");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList Disable Entity");
		return rptWatchListService.removeDisableRPTWatchList(ENTITYID, "PA", "N", authentication.getPrincipal().toString());
	}
	
	
	@RequestMapping(value="/rptadmin/checkList", method=RequestMethod.GET)
	public String checkList(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		
		request.setAttribute("moduleType", "rptWatchList");
		request.setAttribute("moduleName", "RPT WatchList Penging Entity For Check");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("PENDINGRPTENTITIES", rptWatchListService.getPendingEntityForCheck(authentication.getPrincipal().toString()));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "OPEN", "Check RPT WatchList Opened");
		return "RPTWatchList/CheckRPTEntityList";
	}
	
	@RequestMapping(value="/rptadmin/approveEntity", method=RequestMethod.POST)
	public @ResponseBody String approveEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String ENTITYID = request.getParameter("ENTITYID");
		String REMARKS = request.getParameter("REMARKS");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList Approved");
		return rptWatchListService.approveEntity(ENTITYID, REMARKS);
	}
	
	@RequestMapping(value="/rptadmin/rejectEntity", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> rejectEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String ENTITYID = request.getParameter("ENTITYID");
		String REMARKS = request.getParameter("REMARKS");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList Rejected");
		return rptWatchListService.rejectEntity(ENTITYID, REMARKS);
	}
	
	
	@RequestMapping(value="/rptadmin/toggleStatusUponRejection", method=RequestMethod.POST)
	public @ResponseBody String toggleStatusUponRejection(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String ENTITYID = request.getParameter("ENTITYID");
		String STATUS = request.getParameter("STATUS");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RPT WatchList", "UPDATE", "RPT WatchList STATUS updated");
		return rptWatchListService.toggleStatusUponRejection(ENTITYID, STATUS);
	}
}
