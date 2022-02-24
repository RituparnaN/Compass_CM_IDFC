package com.quantumdataengines.app.compass.controller.scanning;

import java.util.HashMap;
import java.util.LinkedHashMap;
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

import com.quantumdataengines.app.compass.controller.CommonController;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.scanning.TemplateScreeningService;

@Controller
@RequestMapping(value="/common")
public class TemplateScreeningController {

	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private TemplateScreeningService templateScreeningService;
	
	
	
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@RequestMapping(value="/templateScreening", method=RequestMethod.GET)
	public String openTemplateScreening(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "OPEN", "Module Accessed");
		return "TemplateScreening/index";
	}
	
	
	//for checking duplicate template id 
	
	
	@RequestMapping(value="/checkTemplateId", method=RequestMethod.GET)
	public @ResponseBody Map checkTemplateId(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		String templateId 	= request.getParameter("templateId");
		Map output = new HashMap();
		output =  templateScreeningService.checkTemplateId(templateId);
		
		//System.out.println("output= "+output);
		
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "OPEN", "Module Accessed");
		return output;
	}
	
	//for getting Template Scanning Details 
	@RequestMapping(value="/getTemplateScreeningDetails", method=RequestMethod.GET)
	public @ResponseBody Map getTemplateScreeningDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String templateSeqNo = request.getParameter("templateSeqNo");
		Map<String,String> templateScreeningDetails = templateScreeningService.getTemplateScreeningDetails(templateSeqNo);
		
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "OPEN", "Get Template Screening Details");
		return templateScreeningDetails;
	}

	//for creating templates 
	@RequestMapping(value="/createTemplateScreening", method=RequestMethod.POST)
	public  String createTemplateScreening(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
	
			String templateId 	= request.getParameter("templateId");
			String templateName = request.getParameter("templateName");
			String templateType = request.getParameter("templateType");
			String searchButtonId = request.getParameter("searchButtonId");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAddress = request.getRemoteAddr();
			Map<String, Object> templateData = templateScreeningService.createTemplateScreening(templateId, templateName, templateType, userCode, userRole, ipAddress);
			//System.out.println("COntroller"+templateData);
			request.setAttribute("RESULTDATA", templateData);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("searchButtonId", searchButtonId);
			request.setAttribute("RESULTMESSAGE", templateData.get("RESULTMESSAGE"));
			request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
			
			
			String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
			request.setAttribute("subModuleCode", subModuleCode);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "INSERT", "Module Accessed");
			return "TemplateScreening/createBottomFrame";
	}
	
	@RequestMapping(value="/searchTemplateScreening", method=RequestMethod.POST)
	public String searchTemplateScreening(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String returnPage = "TemplateScreening/createBottomFrame";
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		if(!subModuleCode.equalsIgnoreCase("N.A.")){
			returnPage = "TemplateScreening/viewBottomFrame";
		}
		String searchButtonId = request.getParameter("searchButtonId");
		String templateId 	= request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String templateType = request.getParameter("templateType");
		String templateDate = request.getParameter("templateDate");
		Map<String, Object> templateData = templateScreeningService.searchTemplateScreening(templateId, templateName, templateType, templateDate, userCode, userRole, ipAddress, subModuleCode);
		
		request.setAttribute("RESULTDATA", templateData);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButtonId", searchButtonId);
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("subModuleCode", subModuleCode);
		//System.out.println("templatedata = "+templateData);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "SEARCH", "Module Accessed");
		// return "TemplateScreening/createBottomFrame";
		return returnPage;
	}
	
	@RequestMapping(value="/templateScreeningDetail", method=RequestMethod.GET)
	public String templateScreeningDetail(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
	
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		
		Map<String, Object> templateDetail = templateScreeningService.templateScreeningDetail(templateId, userCode, userRole, ipAddress, subModuleCode);
		request.setAttribute("TEMPLATEID", templateId);
		request.setAttribute("TEMPLATENAME",templateName);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ISFREEZED",templateDetail.get("ISFREEZED"));
		request.setAttribute("RESULTDATA", templateDetail);
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("subModuleCode", subModuleCode);
		//System.out.println("ISFREEZED = "+templateDetail.get("ISFREEZED"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "GETTINGDETAILS", "Module Accessed");
		return "TemplateScreening/templateScreeningDetail";
	}
		

		
	@RequestMapping(value="/insertDetailForTemplateScreening", method=RequestMethod.POST)
	public @ResponseBody String addCountryForTemplateScreening(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String nameValue = request.getParameter("nameValue");
		String countryValue = request.getParameter("countryValue");
		String idValue = request.getParameter("idValue");
		
		String message = templateScreeningService.insertDetailForTemplateScreening(templateId, templateName, nameValue, countryValue, idValue, userCode, userRole, ipAddress);
		
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "INSERT", "New Name/Country Added");
		return message;
	}
		
	@RequestMapping(value="/deleteTemplateDetails", method=RequestMethod.POST)
	public @ResponseBody String deleteTemplateDetails(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String seqNo = request.getParameter("seqNo");

		String message  = templateScreeningService.deleteTemplateDetails(templateId, templateName, seqNo, userCode, userRole, ipAddress);
		
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "DELETED", "Module Accessed");
		return message;
	}
	
	
	//createAndFreeze
	@RequestMapping(value="/createAndFreeze", method=RequestMethod.POST)
	public @ResponseBody Map createAndFreeze(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		String templateSeqNo = request.getParameter("templateSeqNo");
		String templateId = request.getParameter("templateId");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		
		Map<String,Object> data  = templateScreeningService.createAndFreeze(templateSeqNo, templateId, userCode, userRole, ipAddress);
		//System.out.println("status= "+data.get("FreezedStatus"));
		boolean freezedStatus = (Boolean) data.get("FreezedStatus");
		Map returnData = new HashMap();
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "CREATE", "Module Accessed");
		if(freezedStatus == true )
		{
			returnData.put("MESSAGE", "STATUS UPDATED SUCCESSFULLY FREEZED");
			returnData.put("STATUS", freezedStatus);
			return returnData;
		}
		else{
			returnData.put("MESSAGE", "STATUS NOT UPDATED ");
			returnData.put("STATUS", freezedStatus);
			return returnData;
		}
		
		
	}
	
	//createNewVersion
	
	@RequestMapping(value="/createNewVersion", method=RequestMethod.POST)
	public @ResponseBody String createNewVersion(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		String templateSeqNo = request.getParameter("templateSeqNo");
		String templateId = request.getParameter("templateId");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		

		Map<String,Object> data  = templateScreeningService.createNewVersion(templateSeqNo, templateId, userCode, userRole, ipAddress);
		
		request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
		request.setAttribute("subModuleCode", subModuleCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "CREATE", "Module Accessed");
		return "New Templated Has Been Added Successfully";
	}
	
	@RequestMapping(value="/addCommentsToUpdateTemplateScreeningStatus", method = RequestMethod.POST)
	public String addCommentsToUpdateTemplateScreeningStatus(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
	{
		request.setAttribute("moduleValue", request.getParameter("templateSeqNo"));
		request.setAttribute("templateSeqNo", request.getParameter("templateSeqNo"));
		request.setAttribute("templateScreeningStatus", request.getParameter("templateScreeningStatus"));
		request.setAttribute("moduleType", "addComments");
		request.setAttribute("searchButtonId", request.getParameter("searchButtonId"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "OPEN", "Module Accessed");
		return "TemplateScreening/TemplateScreeningCommentsLog";
	}
	
	//createAndFreeze
		@RequestMapping(value="/updateTemplateScreeningStatus", method=RequestMethod.POST)
		public @ResponseBody Map updateTemplateScreeningStatus(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception
		{
			String templateSeqNo = request.getParameter("templateSeqNo");
			String templateScreeningStatus = request.getParameter("templateScreeningStatus");
			String userComments = request.getParameter("userComments");
			
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAddress = request.getRemoteAddr();
			
			
			Map<String,Object> data  = templateScreeningService.updateTemplateScreeningStatus(templateSeqNo, templateScreeningStatus, userComments, userCode, userRole, ipAddress);
			//System.out.println("status= "+data.get("FreezedStatus"));
			boolean freezedStatus = (Boolean) data.get("TemplateScreeningStatus");
			Map returnData = new HashMap();
			request.setAttribute("userRole", (String) request.getSession(false).getAttribute("CURRENTROLE"));
			String subModuleCode = request.getParameter("subModuleCode") == null ? "N.A.":request.getParameter("subModuleCode");
			request.setAttribute("subModuleCode", subModuleCode);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "TEMPLATESCREENING", "Update TemplateScreeningStatus", "Module Accessed");
			if(freezedStatus == true )
			{
				returnData.put("MESSAGE", "STATUS UPDATED SUCCESSFULLY");
				returnData.put("STATUS", freezedStatus);
				return returnData;
			}
			else{
				returnData.put("MESSAGE", "STATUS NOT UPDATED ");
				returnData.put("STATUS", freezedStatus);
				return returnData;
			}
		}
	

}
