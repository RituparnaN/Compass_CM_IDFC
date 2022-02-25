package com.quantumdataengines.app.compass.controller;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.service.fatca.INDFATCAService;

@Controller
@RequestMapping(value="/common")
public class INDFATCAController {
	
	@Autowired
	private INDFATCAService indfatcaService;
	
	@RequestMapping(value="/show61BForm", method=RequestMethod.GET)
	public String show61BForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("STATEMENTDETAILS", indfatcaService.getIndianFATCAStatementDetails(caseNo, usercode));
		request.setAttribute("REPORTDETAILS", indfatcaService.getReportAccountDetails(caseNo));
		return "/FATCAReport/IndianFATCA/61BForm";
	}
	
	@RequestMapping(value="/saveINDFATCAStatementDetails", method=RequestMethod.POST)
	public String saveINDFATCAStatementDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String CASENO = request.getParameter("CASENO");
		String REPORTINGENTITYNAME = request.getParameter("REPORTINGENTITYNAME");
		String itdrein1 = request.getParameter("ITDREIN1");
		String itdrein2 = request.getParameter("ITDREIN2");
		String itdrein3 = request.getParameter("ITDREIN3");
		String itdrein4 = request.getParameter("ITDREIN4");
		String itdrein5 = request.getParameter("ITDREIN5");
		String itdrein6 = request.getParameter("ITDREIN6");
		String itdrein7 = request.getParameter("ITDREIN7");
		String itdrein8 = request.getParameter("ITDREIN8");
		String itdrein9 = request.getParameter("ITDREIN9");
		String itdrein10 = request.getParameter("ITDREIN10");
		String itdrein11 = request.getParameter("ITDREIN11");
		String itdrein12 = request.getParameter("ITDREIN12");
		String itdrein13 = request.getParameter("ITDREIN13");
		String itdrein14 = request.getParameter("ITDREIN14");
		String itdrein15 = request.getParameter("ITDREIN15");
		String itdrein16 = request.getParameter("ITDREIN16");
		String ITDREIN = itdrein1+itdrein2+itdrein3+itdrein4+itdrein5+itdrein6+itdrein7+itdrein8+itdrein9+itdrein10+itdrein11+itdrein12+itdrein13+itdrein14+itdrein15+itdrein16;
		String GIIN = request.getParameter("GIIN");
		String REGNO = request.getParameter("REGNO");
		String REPORTINGENTITYCAT = request.getParameter("REPORTINGENTITYCAT1")+request.getParameter("REPORTINGENTITYCAT2");
		String STATEMENTTYPE = request.getParameter("STATEMENTTYPE1")+request.getParameter("STATEMENTTYPE2");
		String STATEMENTNO = request.getParameter("STATEMENTNO");
		String ORIGINALSTATEMENTID = request.getParameter("ORIGINALSTATEMENTID");
		String REASONOFCORRECTION = request.getParameter("REASONOFCORRECTION");
		String STATEMENTDATE = request.getParameter("STATEMENTDATE");
		String REPORTINGPERIOD = request.getParameter("REPORTINGPERIOD");
		String REPORTTYPE = request.getParameter("REPORTTYPE");
		String NOOFREPORTS = request.getParameter("NOOFREPORTS");
		String PRINCIPALOFFICERNAME = request.getParameter("PRINCIPALOFFICERNAME");
		String PRINCIPALOFFICERDESGN = request.getParameter("PRINCIPALOFFICERDESGN");
		String PRINCIPALOFFICERADDRESS = request.getParameter("PRINCIPALOFFICERADDRESS");
		String PRINCIPALOFFICERCITY = request.getParameter("PRINCIPALOFFICERCITY");
		String PRINCIPALOFFICERPOSTALCODE = request.getParameter("PRINCIPALOFFICERPOSTALCODE");
		String STATECODE = request.getParameter("STATECODE1")+request.getParameter("STATECODE2");
		String COUNTRYCODE = request.getParameter("COUNTRYCODE1")+request.getParameter("COUNTRYCODE2");
		String TELEPHONE = request.getParameter("TELEPHONE");
		String MOBILE = request.getParameter("MOBILE");
		String FAX = request.getParameter("FAX");
		String EMAIL = request.getParameter("EMAIL");
		
		Map<String, String> formData = new HashMap<String, String>();
		formData.put("REPORTINGENTITYNAME", REPORTINGENTITYNAME);
		formData.put("CASENO", CASENO);								formData.put("REPORTTYPE", REPORTTYPE);
		formData.put("ITDREIN", ITDREIN);							formData.put("NOOFREPORTS", NOOFREPORTS);
		formData.put("GIIN", GIIN);									formData.put("PRINCIPALOFFICERNAME", PRINCIPALOFFICERNAME);
		formData.put("REGNO", REGNO);								formData.put("PRINCIPALOFFICERDESGN", PRINCIPALOFFICERDESGN);
		formData.put("REPORTINGENTITYCAT", REPORTINGENTITYCAT);		formData.put("PRINCIPALOFFICERADDRESS", PRINCIPALOFFICERADDRESS);
		formData.put("STATEMENTTYPE", STATEMENTTYPE);				formData.put("PRINCIPALOFFICERCITY", PRINCIPALOFFICERCITY);
		formData.put("STATEMENTNO", STATEMENTNO);					formData.put("PRINCIPALOFFICERPOSTALCODE", PRINCIPALOFFICERPOSTALCODE);
		formData.put("ORIGINALSTATEMENTID", ORIGINALSTATEMENTID);	formData.put("STATECODE", STATECODE);
		formData.put("REASONOFCORRECTION", REASONOFCORRECTION);		formData.put("COUNTRYCODE", COUNTRYCODE);
		formData.put("STATEMENTDATE", STATEMENTDATE);				formData.put("TELEPHONE", TELEPHONE);
		formData.put("REPORTINGPERIOD", REPORTINGPERIOD);			formData.put("MOBILE", MOBILE);
		formData.put("FAX", FAX);									formData.put("EMAIL", EMAIL);
		
		indfatcaService.updateStatementDetails(formData, usercode);
		
		return "redirect:show61BForm?caseNo="+CASENO;
	}
	
	@RequestMapping(value="/addUpdateINDFATCAAccount", method=RequestMethod.POST)
	public String addUpdateINDFATCAAccount(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String action = request.getParameter("action");
		String accountNo = request.getParameter("accountNo");
		Map<String, String> accountToUpdate = new HashMap<String, String>();
		if("UPDATE".equals(action)){
			List<Map<String, Object>> accountsDetails = indfatcaService.getReportAccountDetails(caseNo);
			for(Map<String, Object> account : accountsDetails){
				String ACCOUNTNUMBER = (String) account.get("ACCOUNTNUMBER");
				if(ACCOUNTNUMBER.equals(accountNo)){
					accountToUpdate.put("REPORTSERIALNO", (String)account.get("REPORTSERIALNO"));
					accountToUpdate.put("ORIGINALREPORTSERIALNO", (String)account.get("ORIGINALREPORTSERIALNO"));
					accountToUpdate.put("ACCOUNTTYPE", (String)account.get("ACCOUNTTYPE"));
					accountToUpdate.put("ACCOUNTNUMBER", (String)account.get("ACCOUNTNUMBER"));
					accountToUpdate.put("ACCOUNTNUMBERTYPE", (String)account.get("ACCOUNTNUMBERTYPE"));
					accountToUpdate.put("ACCOUNTHOLDERNAME", (String)account.get("ACCOUNTHOLDERNAME"));
					accountToUpdate.put("ACCOUNTSTATUS", (String)account.get("ACCOUNTSTATUS"));
					accountToUpdate.put("ACCOUNTTREATMENT", (String)account.get("ACCOUNTTREATMENT"));
					accountToUpdate.put("SELFCERTIFICATION", (String)account.get("SELFCERTIFICATION"));
					accountToUpdate.put("DOCSTATUS", (String)account.get("DOCSTATUS"));
					accountToUpdate.put("ACCOUNTCLOSEDDATE", (String)account.get("ACCOUNTCLOSEDDATE"));
					accountToUpdate.put("BRANCHNUMBERTYPE", (String)account.get("BRANCHNUMBERTYPE"));
					accountToUpdate.put("BRANCHREFNO", (String)account.get("BRANCHREFNO"));
					accountToUpdate.put("BRANCHNAME", (String)account.get("BRANCHNAME"));
					accountToUpdate.put("BRANCHADDR", (String)account.get("BRANCHADDR"));
					accountToUpdate.put("BRANCHCITY", (String)account.get("BRANCHCITY"));
					accountToUpdate.put("BRANCHPOSTALCODE", (String)account.get("BRANCHPOSTALCODE"));
					accountToUpdate.put("BRANCHSTATECODE", (String)account.get("BRANCHSTATECODE"));
					accountToUpdate.put("BRANCHCOUNTRYCODE", (String)account.get("BRANCHCOUNTRYCODE"));
					accountToUpdate.put("BRANCHTELEPHONE", (String)account.get("BRANCHTELEPHONE"));
					accountToUpdate.put("BRANCHMOBILE", (String)account.get("BRANCHMOBILE"));
					accountToUpdate.put("BRANCHFAX", (String)account.get("BRANCHFAX"));
					accountToUpdate.put("BRANCHEMAIL", (String)account.get("BRANCHEMAIL"));
					accountToUpdate.put("ACCOUNTBALANCE", (String)account.get("ACCOUNTBALANCE"));
					accountToUpdate.put("AGGRGROSSINSTPAID", (String)account.get("AGGRGROSSINSTPAID"));
					accountToUpdate.put("AGGRGROSSDVDNTPAID", (String)account.get("AGGRGROSSDVDNTPAID"));
					accountToUpdate.put("GROSSPROCEEDFROMSALE", (String)account.get("GROSSPROCEEDFROMSALE"));
					accountToUpdate.put("AGGRGROSSAMNTALLOTHINCOME", (String)account.get("AGGRGROSSAMNTALLOTHINCOME"));
					accountToUpdate.put("AGGRGROSSAMNTCRDT", (String)account.get("AGGRGROSSAMNTCRDT"));
					accountToUpdate.put("AGGRGROSSAMNTDEBT",  (String)account.get("AGGRGROSSAMNTDEBT"));
				}
			}
		}
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("ACCOUNTNO", accountNo);
		request.setAttribute("ACTION", action);
		request.setAttribute("ACCOUNTDETAILS", accountToUpdate);
		return "/FATCAReport/IndianFATCA/61BForm_AccountDetails";
	}
	
	@RequestMapping(value="/saveUpdateINDFATCAAccount", method=RequestMethod.POST)
	public String saveUpdateINDFATCAAccount(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String action = request.getParameter("action");
		Map<String, String> formData = new HashMap<String, String>();
		formData.put("REPORTSERIALNO", request.getParameter("REPORTSERIALNO"));
		formData.put("ORIGINALREPORTSERIALNO", request.getParameter("ORIGINALREPORTSERIALNO"));
		formData.put("ACCOUNTTYPE", (request.getParameter("ACCOUNTTYPE1") != null ? request.getParameter("ACCOUNTTYPE1") : "") + (request.getParameter("ACCOUNTTYPE2") != null ? request.getParameter("ACCOUNTTYPE2") : ""));
		formData.put("ACCOUNTNUMBER", request.getParameter("ACCOUNTNUMBER"));
		formData.put("ACCOUNTNUMBERTYPE", request.getParameter("ACCOUNTNUMBERTYPE"));
		formData.put("ACCOUNTHOLDERNAME", request.getParameter("ACCOUNTHOLDERNAME"));
		formData.put("ACCOUNTSTATUS", request.getParameter("ACCOUNTSTATUS"));
		formData.put("ACCOUNTTREATMENT", request.getParameter("ACCOUNTTREATMENT"));
		formData.put("SELFCERTIFICATION", request.getParameter("SELFCERTIFICATION"));
		formData.put("DOCSTATUS", request.getParameter("DOCSTATUS"));
		formData.put("ACCOUNTCLOSEDDATE", request.getParameter("ACCOUNTCLOSEDDATE"));
		formData.put("BRANCHNUMBERTYPE", request.getParameter("BRANCHNUMBERTYPE"));
		formData.put("BRANCHREFNO", request.getParameter("BRANCHREFNO"));
		formData.put("BRANCHNAME", request.getParameter("BRANCHNAME"));
		formData.put("BRANCHADDR", request.getParameter("BRANCHADDR"));
		formData.put("BRANCHCITY", request.getParameter("BRANCHCITY"));
		formData.put("BRANCHPOSTALCODE", request.getParameter("BRANCHPOSTALCODE"));
		formData.put("BRANCHSTATECODE", (request.getParameter("BRANCHSTATECODE1") != null ? request.getParameter("BRANCHSTATECODE1") : "") + (request.getParameter("BRANCHSTATECODE2") != null ? request.getParameter("BRANCHSTATECODE2") : ""));
		formData.put("BRANCHCOUNTRYCODE", (request.getParameter("BRANCHCOUNTRYCODE1") != null ? request.getParameter("BRANCHCOUNTRYCODE1") : "") + (request.getParameter("BRANCHCOUNTRYCODE2") != null ? request.getParameter("BRANCHCOUNTRYCODE2") : ""));
		formData.put("BRANCHTELEPHONE", request.getParameter("BRANCHTELEPHONE"));
		formData.put("BRANCHMOBILE", request.getParameter("BRANCHMOBILE"));
		formData.put("BRANCHFAX", request.getParameter("BRANCHFAX"));
		formData.put("BRANCHEMAIL", request.getParameter("BRANCHEMAIL"));
		formData.put("ACCOUNTBALANCE", request.getParameter("ACCOUNTBALANCE"));
		formData.put("AGGRGROSSINSTPAID", request.getParameter("AGGRGROSSINSTPAID"));
		formData.put("AGGRGROSSDVDNTPAID", request.getParameter("AGGRGROSSDVDNTPAID"));
		formData.put("GROSSPROCEEDFROMSALE", request.getParameter("GROSSPROCEEDFROMSALE"));
		formData.put("AGGRGROSSAMNTALLOTHINCOME", request.getParameter("AGGRGROSSAMNTALLOTHINCOME"));
		formData.put("AGGRGROSSAMNTCRDT", request.getParameter("AGGRGROSSAMNTCRDT"));
		formData.put("AGGRGROSSAMNTDEBT", request.getParameter("AGGRGROSSAMNTDEBT"));
		
		indfatcaService.addUpdateINDFATCAAccount(caseNo, usercode, formData, action);
		
		return "redirect:show61BForm?caseNo="+caseNo;
	}
	
	@RequestMapping(value="/deleteINDFATCAAccount", method=RequestMethod.POST)
	public @ResponseBody String deleteINDFATCAAccount(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String accountNo = request.getParameter("accountNo");
		indfatcaService.deleteINDFATCAAccountDetails(caseNo, accountNo);
		return "";
	}
	
	@RequestMapping(value="/addUpdateIndividualEntityControllingPerson", method=RequestMethod.POST)
	public String addUpdateIndividualEntityControllingPerson(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String page = "";
		String action = "";
		String caseNo = request.getParameter("caseNo");
		String accountNo = request.getParameter("accountNo");
		String type = request.getParameter("type");
		String typeId = request.getParameter("typeId");
		Map<String, String> mainMap = new HashMap<String, String>();
		
		if(typeId != null && typeId.length() > 0)
			action = "UPDATE";
		else
			action = "ADD";
		
		if(type.equals("INDIVIDUAL")){
			if(action.equals("UPDATE")){
				List<Map<String, String>> individualDetails = indfatcaService.getAccountIndividualDetails(caseNo, accountNo);
				for(Map<String, String> individualDetail : individualDetails){
					if(typeId.equals(individualDetail.get("INDIVIDUALID")))
						mainMap.putAll(individualDetail);
				}
			}
			page = "/FATCAReport/IndianFATCA/61BForm_IndividualDetails";
		}else if(type.equals("ENTITY")){
			if(action.equals("UPDATE")){
				List<Map<String, String>> entityDetails = indfatcaService.getAccountEntityDetails(caseNo, accountNo);
				for(Map<String, String> entityDetail : entityDetails){
					if(typeId.equals(entityDetail.get("ENTITYID")))
						mainMap.putAll(entityDetail);
				}
			}
			page = "/FATCAReport/IndianFATCA/61BForm_EntityDetails";
		}else if(type.equals("CONTROLLINGPRSN")){
			if(action.equals("UPDATE")){
				List<Map<String, String>> controllingPersonDetails = indfatcaService.getAccountControllingPersonDetails(caseNo, accountNo);
				for(Map<String, String> controllingPersonDetail : controllingPersonDetails){
					if(typeId.equals(controllingPersonDetail.get("CONTROLLINGPERSONID")))
						mainMap.putAll(controllingPersonDetail);
				}
			}
			page = "/FATCAReport/IndianFATCA/61BForm_ControllingPersonDetails";
		}
		
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("ACTION", action);
		request.setAttribute("ACCOUNTNO", accountNo);
		request.setAttribute("TYPEID", typeId);
		request.setAttribute("TYPEDETAILS", mainMap);
		
		return page;
	}
	
	@RequestMapping(value="/saveUpdateINDFATCAIndividual", method=RequestMethod.POST)
	public String saveUpdateINDFATCAIndividual(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String action = request.getParameter("action");
		String accountNo = request.getParameter("accountNo");
		String individualId = request.getParameter("individualId");
		Map<String, String> formData = new HashMap<String, String>();
		
		String PAN = (request.getParameter("PAN1") != null ? request.getParameter("PAN1") : "")+
					 (request.getParameter("PAN2") != null ? request.getParameter("PAN2") : "")+
					 (request.getParameter("PAN3") != null ? request.getParameter("PAN3") : "")+
					 (request.getParameter("PAN4") != null ? request.getParameter("PAN4") : "")+
					 (request.getParameter("PAN5") != null ? request.getParameter("PAN5") : "")+
					 (request.getParameter("PAN6") != null ? request.getParameter("PAN6") : "")+
					 (request.getParameter("PAN7") != null ? request.getParameter("PAN7") : "")+
					 (request.getParameter("PAN8") != null ? request.getParameter("PAN8") : "")+
					 (request.getParameter("PAN9") != null ? request.getParameter("PAN9") : "")+
					 (request.getParameter("PAN10") != null ? request.getParameter("PAN10") : "");
					 
		String NATIONALITY = (request.getParameter("NATIONALITY1") != null ? request.getParameter("NATIONALITY1") : "")+
				 			 (request.getParameter("NATIONALITY2") != null ? request.getParameter("NATIONALITY2") : "");
		
		String COUNTRYOFRESIDENCE = (request.getParameter("COUNTRYOFRESIDENCE1") != null ? request.getParameter("COUNTRYOFRESIDENCE1") : "")+
	 			 (request.getParameter("COUNTRYOFRESIDENCE2") != null ? request.getParameter("COUNTRYOFRESIDENCE2") : "");
		
		String COUNTRYOFBIRTH = (request.getParameter("COUNTRYOFBIRTH1") != null ? request.getParameter("COUNTRYOFBIRTH1") : "")+
	 			 (request.getParameter("COUNTRYOFBIRTH2") != null ? request.getParameter("COUNTRYOFBIRTH2") : "");
		
		String TINISSUNINGCOUNTRY = (request.getParameter("TINISSUNINGCOUNTRY1") != null ? request.getParameter("TINISSUNINGCOUNTRY1") : "")+
	 			 (request.getParameter("TINISSUNINGCOUNTRY2") != null ? request.getParameter("TINISSUNINGCOUNTRY2") : "");
		
		String ADDRTYPE = (request.getParameter("ADDRTYPE1") != null ? request.getParameter("ADDRTYPE1") : "")+
	 			 (request.getParameter("ADDRTYPE2") != null ? request.getParameter("ADDRTYPE2") : "");
		
		String STATECODE = (request.getParameter("STATECODE1") != null ? request.getParameter("STATECODE1") : "")+
	 			 (request.getParameter("STATECODE2") != null ? request.getParameter("STATECODE2") : "");
		
		String COUNTRYCODE = (request.getParameter("COUNTRYCODE1") != null ? request.getParameter("COUNTRYCODE1") : "")+
	 			 (request.getParameter("COUNTRYCODE2") != null ? request.getParameter("COUNTRYCODE2") : "");
		
		formData.put("NAME", request.getParameter("NAME"));
		formData.put("CUSTOMERID", request.getParameter("CUSTOMERID"));
		formData.put("FATHERNAME", request.getParameter("FATHERNAME"));
		formData.put("SPOUSENAME", request.getParameter("SPOUSENAME"));
		formData.put("GENDER", request.getParameter("GENDER"));
		formData.put("PAN", PAN);
		formData.put("ADHAARNO", request.getParameter("ADHAARNO"));
		formData.put("IDTYPE", request.getParameter("IDTYPE"));
		formData.put("IDNO", request.getParameter("IDNO"));
		formData.put("OCCUPATIONTYPE", request.getParameter("OCCUPATIONTYPE"));
		formData.put("OCCUPATION", request.getParameter("OCCUPATION"));
		formData.put("DATEOFBIRTH", request.getParameter("DATEOFBIRTH"));
		formData.put("NATIONALITY", NATIONALITY);
		formData.put("COUNTRYOFRESIDENCE", COUNTRYOFRESIDENCE);
		formData.put("PLACEOFBIRTH", request.getParameter("PLACEOFBIRTH"));
		formData.put("COUNTRYOFBIRTH", COUNTRYOFBIRTH);
		formData.put("TIN", request.getParameter("TIN"));
		formData.put("TINISSUNINGCOUNTRY", TINISSUNINGCOUNTRY);
		formData.put("ADDRTYPE", ADDRTYPE);
		formData.put("ADDR", request.getParameter("ADDR"));
		formData.put("CITY", request.getParameter("CITY"));
		formData.put("POSTALCODE", request.getParameter("POSTALCODE"));
		formData.put("STATECODE", STATECODE);
		formData.put("COUNTRYCODE", COUNTRYCODE);
		formData.put("TELEPHONE", request.getParameter("TELEPHONE"));
		formData.put("OTHERCONTACTNO", request.getParameter("OTHERCONTACTNO"));
		formData.put("REMARKS", request.getParameter("REMARKS"));
		
		indfatcaService.saveUpdateINDFATCAIndividual(caseNo, accountNo, individualId, action, formData, usercode);
		
		return "redirect:show61BForm?caseNo="+caseNo;
	}
	
	@RequestMapping(value="/saveUpdateINDFATCAEntity", method=RequestMethod.POST)
	public String saveUpdateINDFATCAEntity(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String action = request.getParameter("action");
		String accountNo = request.getParameter("accountNo");
		String entityId = request.getParameter("entityId");
		Map<String, String> formData = new HashMap<String, String>();
		
		String PAN = (request.getParameter("PAN1") != null ? request.getParameter("PAN1") : "")+
					 (request.getParameter("PAN2") != null ? request.getParameter("PAN2") : "")+
					 (request.getParameter("PAN3") != null ? request.getParameter("PAN3") : "")+
					 (request.getParameter("PAN4") != null ? request.getParameter("PAN4") : "")+
					 (request.getParameter("PAN5") != null ? request.getParameter("PAN5") : "")+
					 (request.getParameter("PAN6") != null ? request.getParameter("PAN6") : "")+
					 (request.getParameter("PAN7") != null ? request.getParameter("PAN7") : "")+
					 (request.getParameter("PAN8") != null ? request.getParameter("PAN8") : "")+
					 (request.getParameter("PAN9") != null ? request.getParameter("PAN9") : "")+
					 (request.getParameter("PAN10") != null ? request.getParameter("PAN10") : "");
					 
		String USACCOUNTHOLDERTYPE = (request.getParameter("USACCOUNTHOLDERTYPE1") != null ? request.getParameter("USACCOUNTHOLDERTYPE1") : "")+
				 			 (request.getParameter("USACCOUNTHOLDERTYPE2") != null ? request.getParameter("USACCOUNTHOLDERTYPE2") : "");
		
		String OTHACCOUNTHOLDERTYPE = (request.getParameter("OTHACCOUNTHOLDERTYPE1") != null ? request.getParameter("OTHACCOUNTHOLDERTYPE1") : "")+
	 			 (request.getParameter("OTHACCOUNTHOLDERTYPE2") != null ? request.getParameter("OTHACCOUNTHOLDERTYPE2") : "");
		
		String COUNTRYOFINCORPORATION = (request.getParameter("COUNTRYOFINCORPORATION1") != null ? request.getParameter("COUNTRYOFINCORPORATION1") : "")+
	 			 (request.getParameter("COUNTRYOFINCORPORATION2") != null ? request.getParameter("COUNTRYOFINCORPORATION2") : "");
		
		String IDISSUINGCOUNTRY = (request.getParameter("IDISSUINGCOUNTRY1") != null ? request.getParameter("IDISSUINGCOUNTRY1") : "")+
	 			 (request.getParameter("IDISSUINGCOUNTRY2") != null ? request.getParameter("IDISSUINGCOUNTRY2") : "");
		
		String COUNTRYOFRESIDENCE = (request.getParameter("COUNTRYOFRESIDENCE1") != null ? request.getParameter("COUNTRYOFRESIDENCE1") : "")+
	 			 (request.getParameter("COUNTRYOFRESIDENCE2") != null ? request.getParameter("COUNTRYOFRESIDENCE2") : "");
		
		String TINISSUNINGCOUNTRY = (request.getParameter("TINISSUNINGCOUNTRY1") != null ? request.getParameter("TINISSUNINGCOUNTRY1") : "")+
	 			 (request.getParameter("TINISSUNINGCOUNTRY2") != null ? request.getParameter("TINISSUNINGCOUNTRY2") : "");
				
		String STATECODE = (request.getParameter("STATECODE1") != null ? request.getParameter("STATECODE1") : "")+
	 			 (request.getParameter("STATECODE2") != null ? request.getParameter("STATECODE2") : "");
		
		String COUNTRYCODE = (request.getParameter("COUNTRYCODE1") != null ? request.getParameter("COUNTRYCODE1") : "")+
	 			 (request.getParameter("COUNTRYCODE2") != null ? request.getParameter("COUNTRYCODE2") : "");
		
		formData.put("NAME", request.getParameter("NAME"));
		formData.put("CUSTOMERID", request.getParameter("CUSTOMERID"));
		formData.put("USACCOUNTHOLDERTYPE", USACCOUNTHOLDERTYPE);
		formData.put("OTHACCOUNTHOLDERTYPE", OTHACCOUNTHOLDERTYPE);
		formData.put("CONSTITUTIONTYPE", request.getParameter("CONSTITUTIONTYPE"));
		formData.put("DATEOFINCORPORATION", request.getParameter("DATEOFINCORPORATION"));
		formData.put("NATUREOFBUSINESS", request.getParameter("NATUREOFBUSINESS"));
		formData.put("PAN", PAN);
		formData.put("IDTYPE", request.getParameter("IDTYPE"));
		formData.put("IDNO", request.getParameter("IDNO"));
		formData.put("IDISSUINGCOUNTRY", IDISSUINGCOUNTRY);
		formData.put("PLACEOFINCORPORATION", request.getParameter("PLACEOFINCORPORATION"));
		formData.put("COUNTRYOFINCORPORATION", COUNTRYOFINCORPORATION);
		formData.put("COUNTRYOFRESIDENCE", COUNTRYOFRESIDENCE);
		formData.put("TIN", request.getParameter("TIN"));
		formData.put("TINISSUNINGCOUNTRY", TINISSUNINGCOUNTRY);
		formData.put("ADDRTYPE", request.getParameter("ADDRTYPE"));
		formData.put("ADDR", request.getParameter("ADDR"));
		formData.put("CITY", request.getParameter("CITY"));
		formData.put("POSTALCODE", request.getParameter("POSTALCODE"));
		formData.put("STATECODE", STATECODE);
		formData.put("COUNTRYCODE", COUNTRYCODE);
		formData.put("TELEPHONENO", request.getParameter("TELEPHONENO"));
		formData.put("OTHCONTACTNO", request.getParameter("OTHCONTACTNO"));
		formData.put("REMARKS", request.getParameter("REMARKS"));
		
		indfatcaService.saveUpdateINDFATCAEntity(caseNo, accountNo, entityId, action, formData, usercode);
		
		return "redirect:show61BForm?caseNo="+caseNo;
	}
	
	@RequestMapping(value="/saveUpdateINDFATCAControllingPerson", method=RequestMethod.POST)
	public String saveUpdateINDFATCAControllingPerson(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String action = request.getParameter("action");
		String accountNo = request.getParameter("accountNo");
		String controllingPersonId = request.getParameter("controllingPersonId");
		Map<String, String> formData = new HashMap<String, String>();
		
		String PERSONTYPE = (request.getParameter("PERSONTYPE1") != null ? request.getParameter("PERSONTYPE1") : "")+
				 			(request.getParameter("PERSONTYPE2") != null ? request.getParameter("PERSONTYPE2") : "")+
				 			(request.getParameter("PERSONTYPE3") != null ? request.getParameter("PERSONTYPE3") : "");
		
		String PAN = (request.getParameter("PAN1") != null ? request.getParameter("PAN1") : "")+
					 (request.getParameter("PAN2") != null ? request.getParameter("PAN2") : "")+
					 (request.getParameter("PAN3") != null ? request.getParameter("PAN3") : "")+
					 (request.getParameter("PAN4") != null ? request.getParameter("PAN4") : "")+
					 (request.getParameter("PAN5") != null ? request.getParameter("PAN5") : "")+
					 (request.getParameter("PAN6") != null ? request.getParameter("PAN6") : "")+
					 (request.getParameter("PAN7") != null ? request.getParameter("PAN7") : "")+
					 (request.getParameter("PAN8") != null ? request.getParameter("PAN8") : "")+
					 (request.getParameter("PAN9") != null ? request.getParameter("PAN9") : "")+
					 (request.getParameter("PAN10") != null ? request.getParameter("PAN10") : "");
					 
		String NATIONALITY = (request.getParameter("NATIONALITY1") != null ? request.getParameter("NATIONALITY1") : "")+
				 			 (request.getParameter("NATIONALITY2") != null ? request.getParameter("NATIONALITY2") : "");
		
		String COUNTRYOFRESIDENCE = (request.getParameter("COUNTRYOFRESIDENCE1") != null ? request.getParameter("COUNTRYOFRESIDENCE1") : "")+
	 			 (request.getParameter("COUNTRYOFRESIDENCE2") != null ? request.getParameter("COUNTRYOFRESIDENCE2") : "");
		
		String COUNTRYOFBIRTH = (request.getParameter("COUNTRYOFBIRTH1") != null ? request.getParameter("COUNTRYOFBIRTH1") : "")+
	 			 (request.getParameter("COUNTRYOFBIRTH2") != null ? request.getParameter("COUNTRYOFBIRTH2") : "");
		
		String TINISSUNINGCOUNTRY = (request.getParameter("TINISSUNINGCOUNTRY1") != null ? request.getParameter("TINISSUNINGCOUNTRY1") : "")+
	 			 (request.getParameter("TINISSUNINGCOUNTRY2") != null ? request.getParameter("TINISSUNINGCOUNTRY2") : "");
		
		String ADDRTYPE = (request.getParameter("ADDRTYPE1") != null ? request.getParameter("ADDRTYPE1") : "")+
	 			 (request.getParameter("ADDRTYPE2") != null ? request.getParameter("ADDRTYPE2") : "");
		
		String STATECODE = (request.getParameter("STATECODE1") != null ? request.getParameter("STATECODE1") : "")+
	 			 (request.getParameter("STATECODE2") != null ? request.getParameter("STATECODE2") : "");
		
		String COUNTRYCODE = (request.getParameter("COUNTRYCODE1") != null ? request.getParameter("COUNTRYCODE1") : "")+
	 			 (request.getParameter("COUNTRYCODE2") != null ? request.getParameter("COUNTRYCODE2") : "");
		
		formData.put("PERSONTYPE", PERSONTYPE);
		formData.put("NAME", request.getParameter("NAME"));
		formData.put("CUSTOMERID", request.getParameter("CUSTOMERID"));
		formData.put("FATHERNAME", request.getParameter("FATHERNAME"));
		formData.put("SPOUSENAME", request.getParameter("SPOUSENAME"));
		formData.put("GENDER", request.getParameter("GENDER"));
		formData.put("PAN", PAN);
		formData.put("ADHAARNO", request.getParameter("ADHAARNO"));
		formData.put("IDTYPE", request.getParameter("IDTYPE"));
		formData.put("IDNO", request.getParameter("IDNO"));
		formData.put("OCCUPATIONTYPE", request.getParameter("OCCUPATIONTYPE"));
		formData.put("OCCUPATION", request.getParameter("OCCUPATION"));
		formData.put("DATEOFBIRTH", request.getParameter("DATEOFBIRTH"));
		formData.put("NATIONALITY", NATIONALITY);
		formData.put("COUNTRYOFRESIDENCE", COUNTRYOFRESIDENCE);
		formData.put("PLACEOFBIRTH", request.getParameter("PLACEOFBIRTH"));
		formData.put("COUNTRYOFBIRTH", COUNTRYOFBIRTH);
		formData.put("TIN", request.getParameter("TIN"));
		formData.put("TINISSUNINGCOUNTRY", TINISSUNINGCOUNTRY);
		formData.put("ADDRTYPE", ADDRTYPE);
		formData.put("ADDR", request.getParameter("ADDR"));
		formData.put("CITY", request.getParameter("CITY"));
		formData.put("POSTALCODE", request.getParameter("POSTALCODE"));
		formData.put("STATECODE", STATECODE);
		formData.put("COUNTRYCODE", COUNTRYCODE);
		formData.put("TELEPHONE", request.getParameter("TELEPHONE"));
		formData.put("OTHERCONTACTNO", request.getParameter("OTHERCONTACTNO"));
		formData.put("REMARKS", request.getParameter("REMARKS"));
		
		indfatcaService.saveUpdateINDFATCAControllingPerson(caseNo, accountNo, controllingPersonId, action, formData, usercode);
		
		return "redirect:show61BForm?caseNo="+caseNo;
	}
	
	@RequestMapping(value="/deleteIndividualEntityControllingPerson", method=RequestMethod.POST)
	public @ResponseBody String deleteIndividualEntityControllingPerson(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String accountNo = request.getParameter("accountNo");
		String type = request.getParameter("type");
		String typeId = request.getParameter("typeId");
		indfatcaService.deleteIndividualEntityControllingPerson(caseNo, accountNo, type, typeId);
		return "";
	}
	
	@RequestMapping(value = "/generateAndDownloadINDFATCAXML")
	public void generateAndDownLoadXML(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String caseNo = request.getParameter("caseNo");
		String userId = authentication.getPrincipal().toString();

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("ddMMyyyyHHmm");
		String dateString = simpleDateFormat.format(new Date());
		String fileName = "FATCA_"+caseNo+"_"+dateString+".xml";

		List<String> fileData = indfatcaService.getReportFileData(caseNo, userId);
		BufferedWriter bufferedWriter = null;
		StringWriter stringWriter = null;
		try{
			stringWriter = new StringWriter();
			bufferedWriter = new BufferedWriter(stringWriter);
			
			for (String lineString : fileData) {
				bufferedWriter.write(lineString);
				bufferedWriter.newLine();
			}
			
			bufferedWriter.flush();
	        String fileStringData = stringWriter.toString();
	        
	        response.setContentType("APPLICATION/OCTET-STREAM");
	        String disHeader = "Attachment;Filename=\""+fileName+"\"";
	        
	        response.setHeader("Content-disposition", disHeader);
	        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	        byteArrayOutputStream.write(fileStringData.getBytes());
	        response.setContentLength(fileStringData.length());
	        byteArrayOutputStream.writeTo(response.getOutputStream());
	        byteArrayOutputStream.flush();
	        byteArrayOutputStream.close();
	        bufferedWriter.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
