package com.quantumdataengines.app.compass.controller.graphicalMasterModule;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
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
import com.quantumdataengines.app.compass.service.graphicalMasterModule.GraphicalMasterService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;

@Controller
@RequestMapping(value="/common")
public class GraphicalMasterController {
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GraphicalMasterService graphicalMasterService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	
	//for graphical account master
	@RequestMapping(value="/accountGraphicalMaster", method=RequestMethod.GET)
	public String accountGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData( 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA", chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println("in controller"+chartData.get("chartData") );
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/AccountMaster/index";
	}
	
	//for account master view 1
	@RequestMapping(value="/accountGraphicalMasterView1", method=RequestMethod.GET)
	public String accountGraphicalMasterView1(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getAccountMasterDataView1(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/AccountMaster/view1";
	}
	
	
	//for a/c master view 2   grouped Pie
	@RequestMapping(value="/accountGraphicalMasterView2", method=RequestMethod.GET)
	public String accountGraphicalMasterView2(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println(chartData.get("chartData"));
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/AccountMaster/view2";
	}
	
	
	// for A.C master Bar cluster.
	
	@RequestMapping(value="/accountGraphicalMasterView4", method=RequestMethod.GET)
	public String accountGraphicalMasterView4(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println(chartData.get("chartData"));
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/AccountMaster/view4";
	}
	
	//for customer master module
	@RequestMapping(value="/customerGraphicalMaster", method=RequestMethod.GET)
	public String customerGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Customer Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/CustomerMaster/index";
	}
	
	
	
	//ALERT ENGINE
	@RequestMapping(value="/graphicalAlertEngine", method=RequestMethod.GET)
	public String graphicalAlertEngine(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		/*if we need data like 
		 * columnName:columnValue
		 */
		
		Map<String, Object> chartData = graphicalMasterService.getKeyValueData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("columnName",chartData.get("ColumnName"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Alert Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/AlertEngine/index";
	}
	
	// for statistics  
	@RequestMapping(value="/investigationstatistics", method=RequestMethod.GET)
	public String investigationStatistics(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getUserStatsData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("COLUMNNAME",chartData.get("ColumnName"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Investigation Statistic", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/InvestigationStatistics/index";
	}
	
	// for employee details  
	@RequestMapping(value="/employeeGraphicalMaster", method=RequestMethod.GET)
	public String employeeGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		/*if we need data like 
		 * columnName:columnValue
		 */
		
		Map<String, Object> chartData = graphicalMasterService.getKeyValueData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("columnName",chartData.get("ColumnName"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Employee Graphical Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/EmployeeMaster/index";
	}	
	
	
	//FOR TRANSACTION MASTER
	@RequestMapping(value="/transactionGraphicalMaster", method=RequestMethod.GET)
	public String transactionGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		/*if we need data like 
		 * columnName:columnValue
		 */
		
		Map<String, Object> chartData = graphicalMasterService.getKeyValueData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("columnName",chartData.get("ColumnName"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Transaction Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/TransactionMaster/index";
	}
	
	
	//for time series
	
	@RequestMapping(value="/timeSeriesGraph", method=RequestMethod.GET)
	public String timeSeriesGraph(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Time Series", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/TimeSeriesChart/index";
	}
	
		
		
		@RequestMapping(value="/getRandomTimeData", method=RequestMethod.POST)
		public @ResponseBody long[] getRandomTimeData(HttpServletRequest request, HttpServletResponse response,
				Authentication authentication)throws Exception{
			System.out.println("time in ms");
			System.out.println(System.currentTimeMillis());
			long [] arr = {System.currentTimeMillis(),5 + (int)(Math.random() * ((100 - 5) + 1))};
			System.out.println(arr);
			
			/*Map<String, Object> chartData = new HashMap<String,Object>();
			int randomNum1 =  5 + (int)(Math.random() * ((100 - 5) + 1));
			int randomNum2 =  0 + (int)(Math.random() * ((110 - 1) + 1));
			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			Date date = new Date();
			String currentDateTime  =  dateFormat.format(date);
			System.out.println("random numeber is = "+randomNum);
			System.out.println("date and time is  = "+currentDateTime);
			chartData.put("time",currentDateTime);
			chartData.put("number1",randomNum1);
			chartData.put("number2",randomNum2);*/
			return arr;
		}
		
		
		@RequestMapping(value="/getRandomPersonData", method=RequestMethod.GET)
		public @ResponseBody int[] getRandomPersonData(HttpServletRequest request, HttpServletResponse response,
				Authentication authentication)throws Exception{
			int [] arr = new int[10];
			for(int i= 0; i< arr.length;i++){
				arr[i] = 5 + (int)(Math.random() * ((100 - 5) + 1));
			}
			
			for(int i=0;i<arr.length;i++){

				System.out.println(arr[i]);
			}
			return arr;
		}
	
		@RequestMapping(value="/generateGraphForPendingCases", method=RequestMethod.POST)
		public String searchPendingCases(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			Map<String, String> paramMap = new LinkedHashMap<String, String>();
			Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
			String moduleType = request.getParameter("moduleType");
			String generateGraphPageUrl = request.getParameter("generateGraphPageUrl");

			Map<String, String[]> formData =  request.getParameterMap();
			Iterator<String> itr = formData.keySet().iterator();
			while (itr.hasNext()) {
				String tempParamName = itr.next();
				String tempParamValue = formData.get(tempParamName)[0];
				if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName) && !"generateGraphPageUrl".equals(tempParamName)){
					paramTempMap.put(tempParamName, tempParamValue);
				}
			}
			
			
			List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
			
			Collections.sort(paramKeyList, new Comparator<String>(){
				@Override
				public int compare(String str1, String str2) {
					return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
				}
			});
			
			for(String paramName : paramKeyList) {
				String paramValue = formData.get(paramName)[0];
				paramMap.put(paramName, paramValue);
			}
			
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAdress = request.getRemoteAddr();
			
			request.setAttribute("moduleType", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			Map<String,Object> pendingCasesData = graphicalMasterService.searchPendingCases(paramMap, moduleType, userCode, userRole, ipAdress);
			request.setAttribute("DATA",pendingCasesData.get("chartData"));
			request.setAttribute("columnName",pendingCasesData.get("columnName"));
			request.setAttribute("charTitle", pendingCasesData.get("charTitle"));
			return generateGraphPageUrl;
		}
	
	
	//for getting dummy saving data 
	@RequestMapping(value="/savingAccGraphicalMaster", method=RequestMethod.GET)
	public String savingAccGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		//System.out.println("module type= "+moduleType);
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("DATA", graphicalMasterService.savingAccGraphicalMaster( 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		String[] columnName = new String[] {"BRANCHCODE", "TOTALNUMBEROFFD", "INTERESTRATEOFFD", "TERMDURATIONOFFD"};
		request.setAttribute("COLUMNNAME", columnName);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Saving Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/index";
	}
	// for getting current account data currentAccGraphicalMaster
	
	@RequestMapping(value="/currentAccGraphicalMaster", method=RequestMethod.GET)
	public String currentAccGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Current Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/currentAccounts";
	}
	
	//fixedDepositGraphicalMaster
	@RequestMapping(value="/fixedDepositGraphicalMaster", method=RequestMethod.GET)
	public String fixedDepositGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Fixed Deposit", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/fixedDepositAccounts";
	}
	
	//loanGraphicalMaster
	@RequestMapping(value="/loanGraphicalMaster", method=RequestMethod.GET)
	public String loanGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Loan Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/loanAccounts";
	}
	
	//creditCardGraphicalMaster
	@RequestMapping(value="/creditCardGraphicalMaster", method=RequestMethod.GET)
	public String creditCardGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Credit Card", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/creditCardAccounts";
	}
	
	//DebitCardGraphicalMaster
	@RequestMapping(value="/debitCardGraphicalMaster", method=RequestMethod.GET)
	public String DebitCardGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Debit Card", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/debitCardAccounts";
	}
	
	//currencyExcGraphicalMaster
	@RequestMapping(value="/currencyExcGraphicalMaster", method=RequestMethod.GET)
	public String currencyExcGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Currency Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/currencyExcAccounts";
	}
	
	//travelCardGraphicalMaster
	@RequestMapping(value="/travelCardGraphicalMaster", method=RequestMethod.GET)
	public String travelCardGraphicalMaster(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		Map<String, Object> chartData = graphicalMasterService.getGraphicalMasterData(authentication.getPrincipal().toString(), userRole, request.getRemoteAddr(),moduleType);
		request.setAttribute("DATA",chartData.get("chartData"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Travel Card", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/SavingAccounts/travelCardAccounts";
	}
	
	/*@RequestMapping(value="/getGraphDetails", method=RequestMethod.GET)
	public String getGraphDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String columnName = request.getParameter("columnName");
		String columnValue = request.getParameter("columnValue");
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("SEARCHRESULT", graphicalMasterService.getGraphDetails(columnName,columnValue,moduleType,authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/Details";
	}*/
	
	
	
	@RequestMapping(value="/customerPeerGroup", method=RequestMethod.GET)
	public String customerPeerGroup(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		//
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Customer Peer Group", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/CutomerPeerGroup/index";
	}
	
	@RequestMapping(value="/compairCustomerPeerGroup", method=RequestMethod.POST)
	public String compairCustomerPeerGroup(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		String buttomPageUrl = request.getParameter("bottomPageUrl");

		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
			request.setAttribute(paramName.substring(paramName.indexOf("_")+1), paramValue);
		}
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String, Object> chartData = graphicalMasterService.customerPeerGroup(paramMap, moduleType,userCode, userRole, ipAdress);
		request.setAttribute("DATA", chartData.get("chartData"));//dcChartData
		//request.setAttribute("dcChartData", chartData.get("dcChartData"));
		request.setAttribute("columnName",chartData.get("columnName"));
		request.setAttribute("chartTitle",chartData.get("chartTitle"));
		request.setAttribute("x_axis",chartData.get("x_axis"));
		request.setAttribute("y_axis",chartData.get("y_axis"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("paramMap",paramMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Graphical Account Master", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/CutomerPeerGroup/compareResult";
	}
	
	@RequestMapping(value="/getCustomerPeerGroupDetail", method=RequestMethod.POST)
	public String getCustomerPeerGroupDetail(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
				paramMap.put(tempParamName, tempParamValue);
			}
		}
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		request.setAttribute("SEARCHRESULT", graphicalMasterService.getCustomerPeerGroupDetail(paramMap, moduleType,userCode, userRole, ipAdress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Customer Peer Group", "OPEN", "Module Accessed");
		return "GraphicalMasterModule/CutomerPeerGroup/Details";
	}
	
	
	
	
	
	
	
	

}

