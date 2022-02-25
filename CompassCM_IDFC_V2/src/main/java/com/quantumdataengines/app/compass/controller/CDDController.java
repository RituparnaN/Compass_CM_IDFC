package com.quantumdataengines.app.compass.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.cdd.CDDFormService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CommonUtil;


@Controller
public class CDDController {
	
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CDDFormService cddFormService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private GenericMasterService genericMasterService;
	

	@RequestMapping(value={"/cddFormMaker/","/cddFormMaker/index"}, method=RequestMethod.GET)
	public String getCddFormMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "cddFormMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/cddFormChecker/","/cddFormChecker/index"}, method=RequestMethod.GET)
	public String getCddFormCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "cddFormCheckerIndexTemplete";
	}
	
	
	@RequestMapping(value="/cddFormCommon/cddForm", method=RequestMethod.GET)
	public String cddFormMaker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/cddFormMaker";
	}
	
	@RequestMapping(value="/cddFormCommon/searchCDDForm", method=RequestMethod.POST)
	public String searchCDDForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String FORMTYPE = request.getParameter("FORMTYPE");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String CCIFNO = request.getParameter("CCIFNO");
		String CUSTOMERNAME = request.getParameter("CUSTOMERNAME");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userBranchCode = commonService.getUserBranchCode(authentication.getPrincipal().toString());
		String status = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			status = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			status = "BPD-P";
		else if(CURRENTROLE.equals("ROLE_BPDCHECKER"))
			status = "BPD-A";
		else if(CURRENTROLE.equals("ROLE_BPACHECKER"))
			status = "BPA-A";
		else if(CURRENTROLE.equals("ROLE_COMPLIANCEMAKER"))
			status = "COMP-P";
		else if(CURRENTROLE.equals("ROLE_COMPLIANCECHECKER"))
			status = "COMP-A";
		else if(CURRENTROLE.equals("ROLE_JGM"))
			status = "JGM";
		else if(CURRENTROLE.equals("ROLE_GM"))
			status = "GM";
		
		request.setAttribute("SEARCHCDD", cddFormService.searchCDD(COMPASSREFERENCENO, FORMTYPE, CCIFNO, status, userBranchCode, CUSTOMERNAME));
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "SEARCH", "Module Accessed");
		return "CDDForm/Maker/SearchBottomPage";
	}
	
	@RequestMapping(value="/cddFormCommon/checkReCDDStatus", method=RequestMethod.POST)
	public @ResponseBody String checkReCDDStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Module Accessed");
		return cddFormService.getCDDFormFieldData("RECDDDONE", COMPASSREFERENCENO, LINENO);
	}
	
	@RequestMapping(value="/cddFormCommon/openNewCDDForm", method=RequestMethod.POST)
	public String openNewCDDForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String FORMTYPE = request.getParameter("FORMTYPE");
		String formType = "";
		String UNQID = request.getParameter("UNQID");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String RECDD = request.getParameter("RECDD");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userBranchCode = commonService.getUserBranchCode(authentication.getPrincipal().toString());
		String formCode = "";
				
		if(FORMTYPE.equals("INVDNEW")){
			formType = "New Individual";
			formCode = "IN";
		}else if(FORMTYPE.equals("INVDEXISTING")){
			formType = "Existing Individual";
			formCode = "IE";
		}else if(FORMTYPE.equals("CORPNEW")){
			formType = "New Corporate";
			formCode = "CN";
		}else{
			formType = "Existing Corporate";
			formCode = "CE";
		}
		
		if((FORMTYPE.equals("INVDEXISTING") || FORMTYPE.equals("CORPEXISTING")) && "Y".equals(RECDD)){
			String LASTREVIEWDATE = cddFormService.getCDDFormFieldData("FUN_DATETOCHAR(STARTTIMESTAMP)", COMPASSREFERENCENO, LINENO);
			String previousRiskRating = cddFormService.getCDDFormFieldData("FINALRISKRATING", COMPASSREFERENCENO, LINENO);
			cddFormService.setReCDDStatus("Y", COMPASSREFERENCENO, LINENO);
			LINENO = cddFormService.startReCDD(FORMTYPE, COMPASSREFERENCENO, userBranchCode, LASTREVIEWDATE, previousRiskRating, authentication.getPrincipal().toString());
			cddFormService.createCDDCheckList(FORMTYPE, COMPASSREFERENCENO, LINENO);
			cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, "NEW", "BPA-P", formType+" Re-CDD Form created");
		}
		
		if(LINENO != null && !"".equals(LINENO)){
			
		}else{
			COMPASSREFERENCENO = cddFormService.finalizeCompassRefNo(userBranchCode, formCode);
			LINENO = cddFormService.startNewCDD(FORMTYPE, COMPASSREFERENCENO, userBranchCode, authentication.getPrincipal().toString());
			cddFormService.createCDDCheckList(FORMTYPE, COMPASSREFERENCENO, LINENO);
			cddFormService.setReCDDStatus("N", COMPASSREFERENCENO, LINENO);
			cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, "NEW", "BPA-P", formType+" new CDD Form created");
		}		
		
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		
		Map<String, Object> formData = cddFormService.getFormData(FORMTYPE, COMPASSREFERENCENO, LINENO);
		request.setAttribute("FORMDATA", formData.get("CDD_DATA"));
		request.setAttribute("CHECKLIST", formData.get("CHECKLIST_DATA"));
		
		request.setAttribute("JOINTHOLDERS", cddFormService.getAllJointHolderDetails(COMPASSREFERENCENO, null));
		request.setAttribute("NOMINEEDETAILS", cddFormService.getAllNomineeDetails(COMPASSREFERENCENO, null));
		request.setAttribute("INTERMEDIARIES", cddFormService.getAllIntermediariesDetails(COMPASSREFERENCENO, null));
		
		request.setAttribute("BENEFICIALOWNER", cddFormService.getAllBeneficialOwnerDetails(COMPASSREFERENCENO, null));
		request.setAttribute("PEPDETAILS", cddFormService.getAllPEPDetails(COMPASSREFERENCENO, null));
		request.setAttribute("DIRECTORS", cddFormService.getAllDirectorDetails(COMPASSREFERENCENO, null));
		request.setAttribute("AUTHORIZEDSIGNATORIES", cddFormService.getAllAuthorizeSignatoryDetails(COMPASSREFERENCENO, null));
		request.setAttribute("BRANCHCODE", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		
		request.setAttribute("COUNTRYMASTER", cddFormService.getCDDCountryMaster());
		request.setAttribute("STOCKEXCHANGEMASTER", cddFormService.getCDDStockExchangeMaster());
		request.setAttribute("INDUSTRYOCCUPATIONMASTER", cddFormService.getCDDIndustryOccupationType());
		request.setAttribute("ATTRIBUTETYPEMASTER", cddFormService.getCDDAttributeType());
		request.setAttribute("SOURCEOFFUND", cddFormService.getCDDSourceOfFund());
		request.setAttribute("CURRENCYMASTER", cddFormService.getCDDCurrencyMaster());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
				
		if(FORMTYPE.equals("INVDNEW"))
			return "CDDForm/Maker/indvNew";
		if(FORMTYPE.equals("INVDEXISTING"))
			return "CDDForm/Maker/indvExisting";
		if(FORMTYPE.equals("CORPNEW"))
			return "CDDForm/Maker/corpNew";
		else
			return "CDDForm/Maker/corpExisting";
	}
	
	@RequestMapping(value="/cddFormCommon/getStatusAndApproval", method=RequestMethod.POST)
	public String getStatusAndApproval(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String compassRefNo = request.getParameter("COMPASSREFERENCENO");
		String lineNo = request.getParameter("LINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String nextReviewDate = cddFormService.getCDDFormFieldData("FUN_DATETOCHAR(NEXTREVIEWDATE)", compassRefNo, lineNo);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("COMPASSREFERENCENO", compassRefNo);
		request.setAttribute("LINENO", lineNo);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		request.setAttribute("NEXTREVIEWDATE", nextReviewDate);
		request.setAttribute("STATUS", cddFormService.getCDDFormFieldData("STATUS", compassRefNo, lineNo));
		request.setAttribute("AUDITLOG", cddFormService.getCDDAuditLog(compassRefNo, lineNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Module Accessed");
		return "CDDForm/Maker/getStatusAndApproval";
	}
	
	
	@RequestMapping(value="/cddFormCommon/cddFormApproveRejectModal", method=RequestMethod.POST)
	public String cddFormApproveRejectModal(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String ACTION = request.getParameter("ACTION");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		String nextReviewDate = cddFormService.getCDDFormFieldData("FUN_DATETOCHAR(NEXTREVIEWDATE)", COMPASSREFERENCENO, LINENO);
		Map<String, String> rejectDept = new HashMap<String, String>();
		
		if(ACTION.equals("REJECT")){
			if(CURRENTROLE.equals("ROLE_BPDMAKER")){
				rejectDept.put("BPA-P", "BPA Maker");
			}else if(CURRENTROLE.equals("ROLE_BPDCHECKER")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}else if(CURRENTROLE.equals("ROLE_BPACHECKER")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}else if(CURRENTROLE.equals("ROLE_COMPLIANCEMAKER")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}else if(CURRENTROLE.equals("ROLE_COMPLIANCECHECKER")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}else if(CURRENTROLE.equals("ROLE_JGM")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}else if(CURRENTROLE.equals("ROLE_GM")){
				rejectDept.put("BPA-P", "BPA Maker");
				rejectDept.put("BPD-P", "BPD Maker");
			}
		}else{
			/*
			if(formStatus.equals("BPA-P")){
				rejectDept.put("BPD-P", "BPD Maker");
			} else if(formStatus.equals("BPD-P")){
				rejectDept.put("BPD-A", "BPD Checker");
			} else if(formStatus.equals("BPD-A")){
				rejectDept.put("BPA-A", "BPA Checker");
			} else if(formStatus.equals("BPA-A")){
				rejectDept.put("COMP-P", "Compliance Maker");
			} else if(formStatus.equals("COMP-P")){
				rejectDept.put("COMP-A", "Compliance Checker");
			} else if(formStatus.equals("COMP-A")){
				rejectDept.put("JGM", "JGM");
			} else if(formStatus.equals("JGM")){
				rejectDept.put("GM", "GM");
			} else if(formStatus.equals("GM")){
				rejectDept.put("A", "Approve : CDD Complete");
			}
			*/
			if(formStatus.equals("BPA-P")){
				rejectDept.put("BPD-P", "BPD Maker");
			} else if(formStatus.equals("BPD-P")){
				rejectDept.put("COMP-P", "Compliance Maker");
			} else if(formStatus.equals("COMP-P")){
				rejectDept.put("BPA-A", "BPA Checker");
			} else if(formStatus.equals("BPA-A")){
				rejectDept.put("BPD-A", "BPD Checker");
			} else if(formStatus.equals("BPD-A")){
				rejectDept.put("COMP-A", "Compliance Checker");
			} else if(formStatus.equals("COMP-A")){
				rejectDept.put("JGM", "JGM");
			} else if(formStatus.equals("JGM")){
				rejectDept.put("GM", "GM");
			} else if(formStatus.equals("GM")){
				rejectDept.put("A", "Approve : CDD Complete");
			}
		}
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("STATUS", formStatus);
		request.setAttribute("REJECTAPPROVEDEPT", rejectDept);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("ACTION", ACTION);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		request.setAttribute("NEXTREVIEWDATE", nextReviewDate);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/approveRejectCDDForm";
	}
	
	@RequestMapping(value="/cddFormCommon/confirmApproveReject", method=RequestMethod.POST)
	public @ResponseBody String confirmApproveReject(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String ACTION = request.getParameter("ACTION");
		String REJECTAPPROVEDEPT = request.getParameter("REJECTAPPROVEDEPT");
		String NEXTREVIEWDATE = request.getParameter("NEXTREVIEWDATE");
		String CDDCOMMENT = request.getParameter("CDDCOMMENT");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String returnMessage = "CDD Form successfully approved";
		
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		CDDCOMMENT = ACTION + " BY "+CURRENTROLE+" : " + CDDCOMMENT;
		if((CURRENTROLE.equals("ROLE_BPACHECKER") || CURRENTROLE.equals("ROLE_COMPLIANCEMAKER") ||
				CURRENTROLE.equals("ROLE_COMPLIANCECHECKER") || CURRENTROLE.equals("ROLE_JGM") || CURRENTROLE.equals("ROLE_GM"))
			&& ACTION.equals("APPROVE")){
			cddFormService.setCDDNextReviewDate(NEXTREVIEWDATE, COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString());
		}
		cddFormService.setCDDFormStatus(REJECTAPPROVEDEPT, COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE);
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, REJECTAPPROVEDEPT, CDDCOMMENT);
		/*
		if(ACTION.equals("REJECT"))
			return "CDD Form rejected and assigned to respective team";
		else
			return "CDD Form successfully approved";
		*/
		Map<String, String> cddEmailDetails = (HashMap<String, String>)cddFormService.getCDDEmailDetails(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, REJECTAPPROVEDEPT, CDDCOMMENT);
		
		String isEmailToSend = cddEmailDetails.get("ISEMAILTOSEND"); 
		String toAddress = cddEmailDetails.get("TOADDRESS"); 
		String ccAddress = cddEmailDetails.get("CCADDRESS"); 
		String subject = cddEmailDetails.get("EMAILSUBJECT");
		String content = cddEmailDetails.get("EMAILCONTENT");
		String attachmentFolder = cddEmailDetails.get("ATTACHMENTFOLDER");
				
		String toArr[] = CommonUtil.splitString(toAddress, ";");
		String ccArr[] = CommonUtil.splitString(ccAddress, ";");
		String bccArr[] = {};
		
		List<String> toList = new Vector<String>();
		
		for(String toStr : toArr){
			if(toStr.trim().length() > 0){
				toList.add(toStr.trim());
			}
		}
		
		List<String> ccList = new Vector<String>();
		
		for(String ccStr : ccArr){
			if(ccStr.trim().length() > 0){
				ccList.add(ccStr.trim());
			}
		}

		List<String> bccList = new Vector<String>();
		
		for(String bccStr : bccArr){
			if(bccStr.trim().length() > 0){
				bccList.add(bccStr.trim());
			}
		}
		
		try {
			if(isEmailToSend != null && isEmailToSend.equalsIgnoreCase("Y")){
				commonService.sendEMail(COMPASSREFERENCENO, toList, ccList, bccList, subject, content, attachmentFolder, authentication.getPrincipal().toString(), "N", "-1");
			}
		}
		catch(Exception excep){
			System.out.println("Error while sending email for Compass CDD reference No :"+COMPASSREFERENCENO+", And the error as :"+excep.toString());
		}
		if(ACTION.equals("REJECT")) {
			returnMessage = "CDD Form rejected and assigned to respective team";
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "UPDATE", "ACTION TAKEN");
		return returnMessage;
	}
	
	
	@RequestMapping(value="/cddFormCommon/loadIdentificationFormPage", method=RequestMethod.POST)
	public String loadIdentificationFormPage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMTYPE = request.getParameter("TYPE");
		
		Map<String, Object> formData = cddFormService.getFormData(FORMTYPE, COMPASSREFERENCENO, LINENO);
		request.setAttribute("FORMDATA", formData.get("CDD_DATA"));
		
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("TYPE", FORMTYPE);
		request.setAttribute("KYOGICA", cddFormService.checkAccountOpeningKyogi(COMPASSREFERENCENO, "CA"));
		request.setAttribute("KYOGISA", cddFormService.checkAccountOpeningKyogi(COMPASSREFERENCENO, "SA"));
		request.setAttribute("AUTHORIZEDSIGNATORIES", cddFormService.getAllAuthorizeSignatoryDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/IdentificationFormPage";
	}
	
	
	@RequestMapping(value="/cddFormCommon/loadIdentificationForm", method=RequestMethod.POST)
	public String loadIdentificationForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String FORMTYPE = request.getParameter("FORMTYPE");
		String IDFORMTYPE = request.getParameter("IDFORMTYPE");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = "";
		if(IDFORMTYPE.equals("MAINCUST")){
			formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		}else{
			formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		}
		
		Map<String, String> authSignatoriesMap = null;
		List<Map<String, String>> authSignatories = cddFormService.getAllAuthorizeSignatoryDetails(COMPASSREFERENCENO, LINENO);
		if(authSignatories != null && authSignatories.size() > 0)
			authSignatoriesMap = authSignatories.get(0);
		
		Map<String, Object> formData = cddFormService.getFormData(FORMTYPE, COMPASSREFERENCENO, LINENO);
		Map<String, String> CDD_DATA = (Map<String, String>) formData.get("CDD_DATA");
		
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		request.setAttribute("FORMTYPE", FORMTYPE);
		request.setAttribute("IDFORMTYPE", IDFORMTYPE);
		request.setAttribute("STATUS", formStatus);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		
		Map<String, String> identificationFormMap = new HashMap<String, String>();
		if(IDFORMTYPE.equals("MAINCUST")){
			
			String address = "";
			
			if(CDD_DATA.get("RESIDENTIALADDRESS") != null){
				address = address + CDD_DATA.get("RESIDENTIALADDRESS");
			}
			if(CDD_DATA.get("RESIDENTIALADDRESS2") != null){
				address = address +", "+ CDD_DATA.get("RESIDENTIALADDRESS2");
			}
			if(CDD_DATA.get("RESIDENTIALADDRESS3") != null){
				address = address +", "+ CDD_DATA.get("RESIDENTIALADDRESS3");
			}
			
			identificationFormMap.put("IDF_CUSTOMERNAME", CDD_DATA.get("CUSTOMERNAME"));
			identificationFormMap.put("IDF_ADDRESS", address);
			identificationFormMap.put("IDF_DATEOFBIRTH", CDD_DATA.get("DATEOFINCORPORATION"));
			identificationFormMap.put("IDF_RELATIONWITHCUST", CDD_DATA.get("IDF_RELATIONWITHCUST"));
			identificationFormMap.put("IDF_TXN_TYPE", CDD_DATA.get("IDF_TXN_TYPE"));
			identificationFormMap.put("IDF_TXN_TYPE_OTR_DET", CDD_DATA.get("IDF_TXN_TYPE_OTR_DET"));
			identificationFormMap.put("IDF_MOI", CDD_DATA.get("IDF_MOI"));
			identificationFormMap.put("IDF_CERT_TYPE", CDD_DATA.get("IDF_CERT_TYPE"));
			identificationFormMap.put("IDF_CERT_ISSUED_BY", CDD_DATA.get("IDF_CERT_ISSUED_BY"));
			identificationFormMap.put("IDF_CERT_NO", CDD_DATA.get("IDF_CERT_NO"));
			identificationFormMap.put("IDF_CERT_SHOWN", CDD_DATA.get("IDF_CERT_SHOWN"));
			identificationFormMap.put("IDF_DOCMAILEDDATE", CDD_DATA.get("IDF_DOCMAILEDDATE"));
			identificationFormMap.put("IDF_DOC_TITLE", CDD_DATA.get("IDF_DOC_TITLE"));
			identificationFormMap.put("IDF_DOC_TITLE_OTR_DETAILS", CDD_DATA.get("IDF_DOC_TITLE_OTR_DETAILS"));
			identificationFormMap.put("IDF_DLV_METHOD", CDD_DATA.get("IDF_DLV_METHOD"));
			identificationFormMap.put("IDF_DLV_MAIL_COURIER", CDD_DATA.get("IDF_DLV_MAIL_COURIER"));
			identificationFormMap.put("IDF_DIC_IDFIC", CDD_DATA.get("IDF_DIC_IDFIC"));
			identificationFormMap.put("IDF_TIME_IDFIC", CDD_DATA.get("IDF_TIME_IDFIC"));
			identificationFormMap.put("IDF_COFM_DATE", CDD_DATA.get("IDF_COFM_DATE"));
			identificationFormMap.put("IDF_TXN_DATE", CDD_DATA.get("IDF_TXN_DATE"));
			
			identificationFormMap.put("IDF_CHNG_INFO", CDD_DATA.get("IDF_CHNG_INFO"));
			identificationFormMap.put("IDF_CHNG_INFO_OTR", CDD_DATA.get("IDF_CHNG_INFO_OTR"));
			identificationFormMap.put("IDF_ENTITY_VERF", CDD_DATA.get("IDF_ENTITY_VERF"));
			identificationFormMap.put("IDF_ENTITY_CERT_Y", CDD_DATA.get("IDF_ENTITY_CERT_Y"));
			identificationFormMap.put("IDF_ENTITY_CERT_N", CDD_DATA.get("IDF_ENTITY_CERT_N"));
		}else{
			identificationFormMap.put("IDF_CUSTOMERNAME", authSignatoriesMap.get("NAME"));
			identificationFormMap.put("IDF_ADDRESS", authSignatoriesMap.get("ADDRESS"));
			identificationFormMap.put("IDF_DATEOFBIRTH", authSignatoriesMap.get("DATEOFBIRTH"));
			identificationFormMap.put("IDF_RELATIONWITHCUST", authSignatoriesMap.get("IDF_RELATIONWITHCUST"));
			identificationFormMap.put("IDF_TXN_TYPE", authSignatoriesMap.get("IDF_TXN_TYPE"));
			identificationFormMap.put("IDF_TXN_TYPE_OTR_DET", authSignatoriesMap.get("IDF_TXN_TYPE_OTR_DET"));
			identificationFormMap.put("IDF_MOI", authSignatoriesMap.get("IDF_MOI"));
			identificationFormMap.put("IDF_CERT_TYPE", authSignatoriesMap.get("IDF_CERT_TYPE"));
			identificationFormMap.put("IDF_CERT_ISSUED_BY", authSignatoriesMap.get("IDF_CERT_ISSUED_BY"));
			identificationFormMap.put("IDF_CERT_NO", authSignatoriesMap.get("IDF_CERT_NO"));
			identificationFormMap.put("IDF_CERT_SHOWN", authSignatoriesMap.get("IDF_CERT_SHOWN"));
			identificationFormMap.put("IDF_DOCMAILEDDATE", authSignatoriesMap.get("IDF_DOCMAILEDDATE"));
			identificationFormMap.put("IDF_DOC_TITLE", authSignatoriesMap.get("IDF_DOC_TITLE"));
			identificationFormMap.put("IDF_DOC_TITLE_OTR_DETAILS", authSignatoriesMap.get("IDF_DOC_TITLE_OTR_DETAILS"));
			identificationFormMap.put("IDF_DLV_METHOD", authSignatoriesMap.get("IDF_DLV_METHOD"));
			identificationFormMap.put("IDF_DLV_MAIL_COURIER", authSignatoriesMap.get("IDF_DLV_MAIL_COURIER"));
			identificationFormMap.put("IDF_DIC_IDFIC", authSignatoriesMap.get("IDF_DIC_IDFIC"));
			identificationFormMap.put("IDF_TIME_IDFIC", authSignatoriesMap.get("IDF_TIME_IDFIC"));
			identificationFormMap.put("IDF_COFM_DATE", authSignatoriesMap.get("IDF_COFM_DATE"));
			identificationFormMap.put("IDF_TXN_DATE", authSignatoriesMap.get("IDF_TXN_DATE"));
			
			identificationFormMap.put("IDF_CHNG_INFO", authSignatoriesMap.get("IDF_CHNG_INFO"));
			identificationFormMap.put("IDF_CHNG_INFO_OTR", authSignatoriesMap.get("IDF_CHNG_INFO_OTR"));
			identificationFormMap.put("IDF_ENTITY_VERF", authSignatoriesMap.get("IDF_ENTITY_VERF"));
			identificationFormMap.put("IDF_ENTITY_CERT_Y", authSignatoriesMap.get("IDF_ENTITY_CERT_Y"));
			identificationFormMap.put("IDF_ENTITY_CERT_N", authSignatoriesMap.get("IDF_ENTITY_CERT_N"));
		}
		request.setAttribute("IDF", identificationFormMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/IdentificationForm";
	}
	
	
	@RequestMapping(value="/cddFormCommon/saveIdentificationForm", method=RequestMethod.POST)
	public @ResponseBody String saveIdentificationForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String FORMTYPE = request.getParameter("FORMTYPE");
		String IDFORMTYPE = request.getParameter("IDFORMTYPE");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		
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
		
		if(IDFORMTYPE.equals("MAINCUST")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, formStatus, "Customer Identification Form updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "UPDATE", "Data Updated");
			return cddFormService.updateCustomerIdentificationForm(dataMap, COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, formStatus, "Customer's representative's Identification Form updated. Line No : "+LINENO);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "UPDATE", "Data Updated");
			return cddFormService.updateAuthSignIdentificationForm(dataMap, COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/createAFA", method=RequestMethod.POST)
	public @ResponseBody String createAFA(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String KYOGIFOR = request.getParameter("KYOGIFOR");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		String strKyogiFor = "";
		if(KYOGIFOR.equals("CA"))
			strKyogiFor = "CURRENT ACCOUNT";
		else
			strKyogiFor = "SAVING ACCOUNT";
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, formStatus, "Account Opening Kyogi - "+strKyogiFor+" created");
		cddFormService.createAFA(COMPASSREFERENCENO, KYOGIFOR, authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "AFA created";
	}
	
	@RequestMapping(value="/cddFormCommon/openAFA", method=RequestMethod.POST)
	public String openAFA(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String KYOGIFOR = request.getParameter("KYOGIFOR");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		String strKyogiFor = "";
		if(KYOGIFOR.equals("CA"))
			strKyogiFor = "CURRENT ACCOUNT";
		else
			strKyogiFor = "SAVING ACCOUNT";
		
		request.setAttribute("AFADATA", cddFormService.getAFAData(COMPASSREFERENCENO, LINENO, KYOGIFOR));
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("KYOGIFOR", KYOGIFOR);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		request.setAttribute("STATUS", formStatus);
		request.setAttribute("STRKYOGIFOR", strKyogiFor);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/AccountOpeningKyogi";
	}
	
	@RequestMapping(value="/cddFormCommon/saveAFA", method=RequestMethod.POST)
	public @ResponseBody String saveAFA(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String KYOGIFOR = request.getParameter("KYOGIFOR");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String formStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		String strKyogiFor = "";
		if(KYOGIFOR.equals("CA"))
			strKyogiFor = "CURRENT ACCOUNT";
		else
			strKyogiFor = "SAVING ACCOUNT";
		
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
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, formStatus, formStatus, "Account Opening Kyogi - "+strKyogiFor+" updated");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
		return cddFormService.saveAFA(dataMap, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/cddFormCommon/openExistingCDDForm", method=RequestMethod.POST)
	public String openExistingCDDForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String FORMTYPE = request.getParameter("FORMTYPE");
		String UNQID = request.getParameter("UNQID");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		if(COMPASSREFERENCENO != null && !"".equals(COMPASSREFERENCENO)){
			
		}
		
		request.setAttribute("JOINTHOLDERS", cddFormService.getAllJointHolderDetails(COMPASSREFERENCENO, null));
		request.setAttribute("NOMINEEDETAILS", cddFormService.getAllNomineeDetails(COMPASSREFERENCENO, null));
		request.setAttribute("INTERMEDIARIES", cddFormService.getAllIntermediariesDetails(COMPASSREFERENCENO, null));
		request.setAttribute("PEPDETAILS", cddFormService.getAllPEPDetails(COMPASSREFERENCENO, null));
		
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		if(FORMTYPE.equals("INVDEXISTING"))
			return "CDDForm/Maker/indvExisting";
		else
			return "CDDForm/Maker/corpExisting";
	}
	
	@RequestMapping(value="/cddFormCommon/addJointHolder", method=RequestMethod.POST)
	public String addJointHolder(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Module Accessed");
		return "CDDForm/Maker/addJointHolder";
	}
	
	@RequestMapping(value="/cddFormCommon/addNomineeDetail", method=RequestMethod.POST)
	public String addNomineeDetail(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Nominee Added");
		return "CDDForm/Maker/addNomineeDetail";
	}
	
	@RequestMapping(value="/cddFormCommon/saveJointHolder", method=RequestMethod.POST)
	public @ResponseBody String saveJointHolder(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String JOINTHOLDERNAME = request.getParameter("JOINTHOLDERNAME");
		String JOINTHOLDERADDRESS = request.getParameter("JOINTHOLDERADDRESS");
		String JOINTHOLDERPAN = request.getParameter("JOINTHOLDERPAN");
		String JOINTHOLDERAADHAR = request.getParameter("JOINTHOLDERAADHAR");
		String RELATIONWITHPRIMARY = request.getParameter("RELATIONWITHPRIMARY");
		String RELATIONWITHPRIMARYOTHER = request.getParameter("RELATIONWITHPRIMARYOTHER");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, JOINTHOLDERNAME+" (Joint Holder) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveJointHolder(COMPASSREFERENCENO, LINENO, JOINTHOLDERNAME, JOINTHOLDERADDRESS, 
				JOINTHOLDERPAN, JOINTHOLDERAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER, 
				authentication.getPrincipal().toString());
		} else {
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, JOINTHOLDERNAME+" (Joint Holder) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateJointHolder(COMPASSREFERENCENO, LINENO, JOINTHOLDERNAME, JOINTHOLDERADDRESS,
					JOINTHOLDERPAN, JOINTHOLDERAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER,
					authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/saveNomineeDetail", method=RequestMethod.POST)
	public @ResponseBody String saveNomineeDetail(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String NOMINEENAME = request.getParameter("NOMINEENAME");
		String NOMINEEADDRESS = request.getParameter("NOMINEEADDRESS");
		String NOMINEEDOB = request.getParameter("NOMINEEDOB");
		String NOMINEEAADHAR = request.getParameter("NOMINEEAADHAR");
		String RELATIONWITHPRIMARY = request.getParameter("RELATIONWITHPRIMARY");
		String RELATIONWITHPRIMARYOTHER = request.getParameter("RELATIONWITHPRIMARYOTHER");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NOMINEENAME+" (Nominee) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveNomineeDetail(COMPASSREFERENCENO, LINENO, NOMINEENAME, NOMINEEADDRESS, 
				NOMINEEDOB, NOMINEEAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER, 
				authentication.getPrincipal().toString());
		} else {
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NOMINEENAME+" (Nominee) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateNomineeDetail(COMPASSREFERENCENO, LINENO, NOMINEENAME, NOMINEEADDRESS,
					NOMINEEDOB, NOMINEEAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER,
					authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getJointHolder", method=RequestMethod.POST)
	public String getJointHolder(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("JOINTHOLDERS", cddFormService.getAllJointHolderDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Details Accessed");
		return "CDDForm/Maker/getAllJointHolder";
	}
	
	@RequestMapping(value="/cddFormCommon/getNomineeDetail", method=RequestMethod.POST)
	public String getNomineeDetail(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("NOMINEEDETAILS", cddFormService.getAllNomineeDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Details Accessed");
		return "CDDForm/Maker/getAllNomineeDetail";
	}
	
	@RequestMapping(value="/cddFormCommon/addIntermediaries", method=RequestMethod.POST)
	public String addIntermediaries(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Maker/addIntermediaries";
	}
	
	@RequestMapping(value="/cddFormCommon/saveIntermediaries", method=RequestMethod.POST)
	public @ResponseBody String saveIntermediaries(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String INTERMEDIARYNAME = request.getParameter("INTERMEDIARYNAME");
		String INTERMEDIARYNATIONALITY = request.getParameter("INTERMEDIARYNATIONALITY");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, INTERMEDIARYNAME+" (Intermediary) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveIntermediary(COMPASSREFERENCENO, LINENO, INTERMEDIARYNAME, INTERMEDIARYNATIONALITY,
				authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, INTERMEDIARYNAME+" (Intermediary) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateIntermediary(COMPASSREFERENCENO, LINENO, INTERMEDIARYNAME, INTERMEDIARYNATIONALITY,
					authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getIntermediaries", method=RequestMethod.POST)
	public String getIntermediaries(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("INTERMEDIARIES", cddFormService.getAllIntermediariesDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Module Accessed");
		return "CDDForm/Maker/getAllIntermediaries";
	}
	
	@RequestMapping(value="/cddFormCommon/addPEP", method=RequestMethod.POST)
	public String addPEP(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "PEP Added");
		return "CDDForm/Maker/addPEP";
	}
	
	@RequestMapping(value="/cddFormCommon/savePEP", method=RequestMethod.POST)
	public @ResponseBody String savePEP(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String PEPNAME = request.getParameter("PEPNAME");
		String PEPNATIONALITY = request.getParameter("PEPNATIONALITY");
		String PEPPOSITIONINGOVT = request.getParameter("PEPPOSITIONINGOVT");
		String PEPPOSITIONINCOMPANY = request.getParameter("PEPPOSITIONINCOMPANY");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, PEPNAME+" (PEP) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.savePEP(COMPASSREFERENCENO, LINENO, PEPNAME, PEPNATIONALITY,
					PEPPOSITIONINGOVT, PEPPOSITIONINCOMPANY, authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, PEPNAME+" (PEP) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updatePEP(COMPASSREFERENCENO, LINENO, PEPNAME, PEPNATIONALITY,
					PEPPOSITIONINGOVT, PEPPOSITIONINCOMPANY, authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getPEPs", method=RequestMethod.POST)
	public String getPEPs(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("PEPDETAILS", cddFormService.getAllPEPDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Data Read");
		return "CDDForm/Maker/getAllPEP";
	}
	
	@RequestMapping(value="/cddFormCommon/addBeneficialOwner", method=RequestMethod.POST)
	public String addBeneficialOwner(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Beneficial Owner Added");
		return "CDDForm/Maker/addBeneficialOwner";
	}
	
	@RequestMapping(value="/cddFormCommon/saveBeneficialOwner", method=RequestMethod.POST)
	public @ResponseBody String saveBeneficialOwner(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String NAME = request.getParameter("NAME");
		String EFFECTIVESHAREHOLDING = request.getParameter("EFFECTIVESHAREHOLDING");
		String NATIONALITY = request.getParameter("NATIONALITY");
		String DATEOFBIRTH = request.getParameter("DATEOFBIRTH");
		String PANNO = request.getParameter("PANNO");
		String AADHARNO = request.getParameter("AADHARNO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NAME+" (Beneficial Owner) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveBeneficialOwner(COMPASSREFERENCENO, LINENO, NAME, EFFECTIVESHAREHOLDING, NATIONALITY, DATEOFBIRTH,
					PANNO, AADHARNO, authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus,  NAME+" (Beneficial Owner) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateBeneficialOwner(COMPASSREFERENCENO, LINENO, NAME, EFFECTIVESHAREHOLDING, NATIONALITY, DATEOFBIRTH,
					PANNO, AADHARNO, authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getBeneficialOwners", method=RequestMethod.POST)
	public String getBeneficialOwners(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("BENEFICIALOWNERS", cddFormService.getAllBeneficialOwnerDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Data Accessed");
		return "CDDForm/Maker/getAllBeneficialOwners";
	}
	
	@RequestMapping(value="/cddFormCommon/addDirector", method=RequestMethod.POST)
	public String addDirector(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("FORMLINENO", FORMLINENO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Added");
		return "CDDForm/Maker/addDirector";
	}
	
	@RequestMapping(value="/cddFormCommon/saveDirector", method=RequestMethod.POST)
	public @ResponseBody String saveDirector(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String NAME = request.getParameter("NAME");
		String ADDRESS = request.getParameter("ADDRESS");
		String NATIONALITY = request.getParameter("NATIONALITY");
		String DATEOFBIRTH = request.getParameter("DATEOFBIRTH");
		String PANNO = request.getParameter("PANNO");
		String AADHARNO = request.getParameter("AADHARNO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NAME+" (Director) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveDirector(COMPASSREFERENCENO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH,
					PANNO, AADHARNO, authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NAME+" (Director) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateDirector(COMPASSREFERENCENO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH,
					PANNO, AADHARNO, authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getDirectors", method=RequestMethod.POST)
	public String getDirectors(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("DIRECTORS", cddFormService.getAllDirectorDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Data Accessed");
		return "CDDForm/Maker/getAllDirectors";
	}
	
	@RequestMapping(value="/cddFormCommon/addAuthorizedSignatory", method=RequestMethod.POST)
	public String addAuthorizedSignatory(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		request.setAttribute("STATUS", currentStatus);
		request.setAttribute("FORMLINENO", FORMLINENO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Added");
		return "CDDForm/Maker/addAuthorizedSignatory";
	}
	
	@RequestMapping(value="/cddFormCommon/saveAuthorizedSignatory", method=RequestMethod.POST)
	public @ResponseBody String saveAuthorizedSignatory(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
		String NAME = request.getParameter("NAME");
		String ADDRESS = request.getParameter("ADDRESS");
		String NATIONALITY = request.getParameter("NATIONALITY");
		String DATEOFBIRTH = request.getParameter("DATEOFBIRTH");
		String PANNO = request.getParameter("AUTH_PANNO");
		String PANNSDLRESPONSE = request.getParameter("AUTH_PANNSDLRESPONSE");
		String AADHARNO = request.getParameter("AADHARNO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		if(LINENO.equals("0")){
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NAME+" (Authorized Signatory) created");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.saveAuthorizedSignatory(COMPASSREFERENCENO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH,
					PANNO, PANNSDLRESPONSE, AADHARNO, authentication.getPrincipal().toString());
		}else{
			cddFormService.cddAuditLog(COMPASSREFERENCENO, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, NAME+" (Authorized Signatory) updated");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
			return cddFormService.updateAuthorizedSignatory(COMPASSREFERENCENO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH,
					PANNO, PANNSDLRESPONSE, AADHARNO, authentication.getPrincipal().toString());
		}
	}
	
	@RequestMapping(value="/cddFormCommon/getAuthorizedSignatories", method=RequestMethod.POST)
	public String getAuthorizedSignatories(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String UNQNO = request.getParameter("UNQNO");
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		request.setAttribute("UNQNO", UNQNO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("AUTHORIZEDSIGNATORIES", cddFormService.getAllAuthorizeSignatoryDetails(COMPASSREFERENCENO, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Data Accessed");
		return "CDDForm/Maker/getAllAuthorizedSignatories";
	}
	
	@RequestMapping(value="/cddFormCommon/updateScreeningMatch", method=RequestMethod.POST)
	public @ResponseBody String updateScreeningMatch(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String type = request.getParameter("TYPE");
		String compassRefNo = request.getParameter("COMPASSREFERENCENO");
		String lineNo = request.getParameter("LINENO");
		String match = request.getParameter("MATCH");
		String listNames = request.getParameter("LIST");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", compassRefNo, FORMLINENO);
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		cddFormService.cddAuditLog(compassRefNo, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, "Screening Result updated for "+type+" of LINE NO : "+lineNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "UPDATE", "Data Saved");
		return cddFormService.updateScreeningResult(compassRefNo, lineNo, type, match, listNames, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/cddFormCommon/viewEntity", method=RequestMethod.POST)
	public String viewEntity(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String UNQID = request.getParameter("UNQID");
		String LINENO = request.getParameter("LINENO");
		String TYPE = request.getParameter("TYPE");
		String FORMLINENO = request.getParameter("FORMLINENO");
		
		if(LINENO == null || "".equals(LINENO))
			LINENO = "0";
		
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("UNQID", UNQID);
		request.setAttribute("LINENO", LINENO);
		request.setAttribute("FORMLINENO", FORMLINENO);
		request.setAttribute("STATUS", cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, FORMLINENO));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		if(TYPE.equals("JOINTHOLDER")){
			request.setAttribute("JOINHOLDER", cddFormService.getAllJointHolderDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addJointHolder";
		} else if(TYPE.equals("NOMINEEDETAIL")){
			request.setAttribute("NOMINEEDETAIL", cddFormService.getAllNomineeDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addNomineeDetail";
		} else if(TYPE.equals("INTERMEDIARY")){
			request.setAttribute("INTERMEDIARIES", cddFormService.getAllIntermediariesDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addIntermediaries";
		} else if(TYPE.equals("PEP")){
			request.setAttribute("PEPDETAILS", cddFormService.getAllPEPDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addPEP";
		} else if(TYPE.equals("BENEFICIALOWNER")){
			request.setAttribute("BENEFICIALOWNER", cddFormService.getAllBeneficialOwnerDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addBeneficialOwner";
		} else if(TYPE.equals("DIRECTOR")){
			request.setAttribute("DIRECTOR", cddFormService.getAllDirectorDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addDirector";
		} else if(TYPE.equals("AUTHORIZEDSIGNATORY")){
			request.setAttribute("AUTHORIZEDSIGNATORY", cddFormService.getAllAuthorizeSignatoryDetails(COMPASSREFERENCENO, LINENO));
			return "CDDForm/Maker/addAuthorizedSignatory";
		} else {
			return "Failed to update";
		}
	}
	
	@RequestMapping(value="/cddFormCommon/removeEntity", method=RequestMethod.POST)
	public @ResponseBody String removeEntity(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String type = request.getParameter("TYPE");
		String compassRefNo = request.getParameter("COMPASSREFERENCENO");
		String lineNo = request.getParameter("LINENO");
		String FORMLINENO = request.getParameter("FORMLINENO");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", compassRefNo, lineNo);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		cddFormService.cddAuditLog(compassRefNo, FORMLINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, "Entity of type "+type+" of LINE NO : "+lineNo+" removed");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "DELETE", "Data Deleted");
		return cddFormService.removeEntity(type, compassRefNo, lineNo);
	}
	
	@RequestMapping(value="/cddFormCommon/saveCDDFormData", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> saveCDDFormData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
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
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, "CDD Form updated");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
		return cddFormService.saveCDDFormData(authentication.getPrincipal().toString(), CURRENTROLE, dataMap, newStatus, COMPASSREFERENCENO, LINENO);
	}
	
	
	@RequestMapping(value="/cddFormCommon/saveCloseCDDForm", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> saveCloseCDDForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
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
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, "BPD-A", "CDD Form updated and closed");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
		return cddFormService.saveCDDFormData(authentication.getPrincipal().toString(), CURRENTROLE, dataMap, "BPD-A", COMPASSREFERENCENO, LINENO);
	}
	
	@RequestMapping(value="/cddFormCommon/saveCDDCheckListForm", method=RequestMethod.POST)
	public @ResponseBody String saveCDDCheckListForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
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
			if(!paramName.equals("COMPASSREFERENCENO") && !paramName.equals("LINENO"))
				dataMap.put(paramName, paramValue);
		}
		
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		dataMap.put("BPAMAKER", authentication.getPrincipal().toString());
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPAMAKER"))
			newStatus = "BPA-P";
		else if(CURRENTROLE.equals("ROLE_BPDMAKER"))
			newStatus = "BPD-P";
		
		
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, "CDD Form Check List updated");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
		return cddFormService.saveCDDCheckList(dataMap, COMPASSREFERENCENO, LINENO, newStatus, authentication.getPrincipal().toString(), CURRENTROLE);
	}
		
	@RequestMapping(value="/cddFormCommon/saveCDDCheckListFormChecker", method=RequestMethod.POST)
	public @ResponseBody String saveCDDCheckListFormChecker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String LINENO = request.getParameter("LINENO");
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
			if(!paramName.equals("COMPASSREFERENCENO") && !paramName.equals("LINENO"))
				dataMap.put(paramName, paramValue);
		}
		dataMap.put("BPACHECKER", authentication.getPrincipal().toString());
		
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String currentStatus = cddFormService.getCDDFormFieldData("STATUS", COMPASSREFERENCENO, LINENO);
		
		String newStatus = "";
		
		if(CURRENTROLE.equals("ROLE_BPACHECKER"))
			newStatus = "BPA-A";
		else if(CURRENTROLE.equals("ROLE_BPDCHECKER"))
			newStatus = "BPD-A";
		
		cddFormService.cddAuditLog(COMPASSREFERENCENO, LINENO, authentication.getPrincipal().toString(), CURRENTROLE, currentStatus, newStatus, "CDD Form Check List updated");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "Data Saved");
		return cddFormService.saveCDDCheckList(dataMap, COMPASSREFERENCENO, LINENO, newStatus, authentication.getPrincipal().toString(), CURRENTROLE);
	}
		
	@RequestMapping(value="/cddFormChecker/cddFormChecker", method=RequestMethod.GET)
	public String cddFormChecker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "OPEN", "Module Accessed");
		return "CDDForm/Checker/cddFormChecker";
	}
	
	@RequestMapping(value="/cddFormCommon/calculateCDDRiskRating", method=RequestMethod.POST)
	public @ResponseBody Map<String,String> calculateCDDRiskRating(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CHANNELRISKRATING = request.getParameter("CHANNELRISKRATING");
		String PRODUCTRISKRATING = request.getParameter("PRODUCTRISKRATING");
		String GEOGRAPHICRISKRATING = request.getParameter("GEOGRAPHICRISKRATING");
		String INDUSTRYTYPERISKRATING = request.getParameter("INDUSTRYTYPERISKRATING");
		String ATTRIBUTETYPERISKRATING = request.getParameter("ATTRIBUTETYPERISKRATING");
		String TYPE = request.getParameter("TYPE");
				commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Calculate CDD Risk");
		if(TYPE.equals("INDV")){
			return cddFormService.calculateIndvRiskRating(CHANNELRISKRATING, PRODUCTRISKRATING, GEOGRAPHICRISKRATING, INDUSTRYTYPERISKRATING);
		}else{
			return cddFormService.calculateCorpRiskRating(CHANNELRISKRATING, PRODUCTRISKRATING, GEOGRAPHICRISKRATING, INDUSTRYTYPERISKRATING, ATTRIBUTETYPERISKRATING);
		}
	}
	
	@RequestMapping(value="/cddFormCommon/checkPAN", method=RequestMethod.POST)
	public @ResponseBody String checkPAN(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String PANNO = request.getParameter("PANNO");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "READ", "Check PAN");
		return cddFormService.checkPAN(PANNO);
	}
	
	@RequestMapping(value="/cddFormCommon/validateCustomerPANNo", method=RequestMethod.POST)
	public @ResponseBody String validateCustomerPANNo(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String compassRefNo = request.getParameter("COMPASSREFERENCENO");
		String lineNo = request.getParameter("LINENO");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getLocalAddr();
		String panNo = request.getParameter("PANNO");
		String panValidationResult = "N.A.";
		Map<String, String> validationResult = new HashMap<String, String>();
		
		panValidationResult = cddFormService.validateCustomerPANNo(compassRefNo, lineNo, userCode, userRole, ipAddress, panNo);
		validationResult.put("ResultString", panValidationResult);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CDD", "INSERT", "PAN Validated");
		return panValidationResult;
	}
}
