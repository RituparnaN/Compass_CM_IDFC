package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.logout.CookieClearingLogoutHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.AbstractRememberMeServices;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.service.userNotes.UserNotesService;
import com.quantumdataengines.app.compass.util.CompassEncryptorDecryptor;
import com.quantumdataengines.app.compass.util.CompassLanguageLoaderUtil;
import com.quantumdataengines.app.compass.util.LanguageContextHolder;

import eu.bitwalker.useragentutils.UserAgent;

@Controller
public class IndexController {
	
	private static final Logger log = LoggerFactory.getLogger(IndexController.class);
		
	@Autowired
	private LoginService loginService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private CompassEncryptorDecryptor compassEncryptorDecryptor;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ReloadableResourceBundleMessageSource messageSource;
	
	@Autowired
	private UserNotesService userNotesService;
	
	@RequestMapping(value="/keepAlive", method=RequestMethod.GET)
	public @ResponseBody String keepAlive(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication){
		
		return "OK";
	}
	
	@RequestMapping(value="/getIdleTimeout", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getIdleTimeout(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String previousRole = request.getParameter("role");
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String, String> returnMap = new HashMap<String, String>();
		String sessionId = "";
		try{
			sessionId = request.getSession(false).getId();
			loginService.updateLogoutTime(sessionId, "ROLE_"+CURRENTROLE);
		}catch(Exception e){}
		// loginService.updateLogoutTime(sessionId, "ROLE_"+CURRENTROLE);
		
		if(previousRole.equalsIgnoreCase(CURRENTROLE)){
			returnMap.put("ROLE", "1");
		}else{
			returnMap.put("ROLE", "0");
		}
		return returnMap;
	}
	
	@RequestMapping(value="/otherStatic", method=RequestMethod.GET)
	public String otherStatic(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication){
		Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("SESSIONTIMEOUT", systemParameters.get("SESSIONTIMEOUT"));
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		
		return "tags/timeOutStaticFiles";
	}
	
	@RequestMapping(value="/forceLogout", method=RequestMethod.POST)
	public @ResponseBody String forceLogout(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		CookieClearingLogoutHandler clearingLogoutHandler = 
				new CookieClearingLogoutHandler(AbstractRememberMeServices.SPRING_SECURITY_REMEMBER_ME_COOKIE_KEY);
		SecurityContextLogoutHandler contextLogoutHandler = new SecurityContextLogoutHandler();
		clearingLogoutHandler.logout(request, response, authentication);
		contextLogoutHandler.logout(request, response, authentication);
		
		return "done";
	}
	
	@RequestMapping(value="/changeProfilePriority", method=RequestMethod.POST)
	public @ResponseBody String changeProfilePriority(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String profile = request.getParameter("profile");		
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "UPDATE", "Profile "+profile+" Priority Updated");
		return commonService.changeProfilePriprity(userCode, profile);
	}
	
	@RequestMapping(value="/changeProfile/{roleId}", method=RequestMethod.GET)
	public ModelAndView changeProfile(@PathVariable("roleId") String roleId, HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, String> otherProfileDetails = loginService.getRoleNameUrl("ROLE_"+roleId);
		String roleName = otherProfileDetails.get("roleId");
		String previousRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
		String browser = "Browser : "+userAgent.getBrowser().getName() +", Version : "+ userAgent.getBrowserVersion().getVersion();
		if(roleName != null){
			request.getSession(false).setAttribute("CURRENTROLE", roleName);
			loginService.setSystemLoginLog((String) authentication.getPrincipal(), roleName, request.getRemoteAddr(), 
					"Y", "Successful switch from "+previousRole+" to "+roleName, request.getSession(false).getId(), browser);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "UPDATE", "Profile/ Role Id Changed From Role Id: "+previousRole+" to "+roleName);
		return new ModelAndView("redirect:/index");
	}
	
	
	@RequestMapping(value="/loadErrorPage", method=RequestMethod.GET)
	public String loadErrorPage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String errorCode = request.getParameter("errorCode");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDEX", "OPEN", "Error "+errorCode+" Occurred ");
		return "common/errors/"+errorCode;
	}
	
	@RequestMapping(value="/resetPassword", method=RequestMethod.GET)
	public String resetPassword(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "OPEN", "Module Accessed");
		return "common/resetPassword";
	}
	
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public ModelAndView getIndexPage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		Collection<GrantedAuthority> authorities = domainUser.getAuthorities();
		String roleName = (String) request.getSession(false).getAttribute("CURRENTROLE");
		if(roleName == null){
			roleName = loginService.getUserRoleByPriority(domainUser.getUsername());
			request.getSession(false).setAttribute("CURRENTROLE", roleName);
		}
		
		String page = "";
		if(roleName != null){
			if(roleName.equals("ROLE_ADMIN")){
				page = "redirect:/admin";
			}else if(roleName.equals("ROLE_MLRO")){
				page = "redirect:/mlro";
			}else if(roleName.equals("ROLE_MLROL1")){
				page = "redirect:/mlroL1";
			}else if(roleName.equals("ROLE_MLROL2")){
				page = "redirect:/mlroL2";
			}else if(roleName.equals("ROLE_AMLO")){
				page = "redirect:/amlo";
			}else if(roleName.equals("ROLE_AMLUSER")){
				page = "redirect:/amluser";
			}else if(roleName.equals("ROLE_AMLUSERL1")){
				page = "redirect:/amluserL1";
			}else if(roleName.equals("ROLE_AMLUSERL2")){
				page = "redirect:/amluserL2";
			}else if(roleName.equals("ROLE_AMLUSERL3")){
				page = "redirect:/amluserL3";
			}else if(roleName.equals("ROLE_AMLREP")){
				page = "redirect:/amlrep";
			}else if(roleName.equals("ROLE_USER")){
				page = "redirect:/user";
			}else if(roleName.equals("ROLE_BRANCHUSER")){
				page = "redirect:/branchuser";
			}else if(roleName.equals("ROLE_FATCAMANAGER")){
				page = "redirect:/fatcamanager";
			}else if(roleName.equals("ROLE_FATCAOFFICER")){
				page = "redirect:/fatcaofficer";
			}else if(roleName.equals("ROLE_FATCAUSER")){
				page = "redirect:/fatcauser";
			}else if(roleName.equals("ROLE_FATCARMUSER")){
				page = "redirect:/fatcarmuser";
			}else if(roleName.equals("ROLE_ETL")){
				page = "redirect:/etl";
			}else if(roleName.equals("ROLE_MAKER")){
				page = "redirect:/maker";
			}else if(roleName.equals("ROLE_CHECKER")){
				page = "redirect:/checker";
			}else if(roleName.equals("ROLE_CHECKER")){
				page = "redirect:/checker";
			}else if(roleName.equals("ROLE_CPUADMIN")){
				page = "redirect:/cpuadmin";
			}else if(roleName.equals("ROLE_CPUCHECKER")){
				page = "redirect:/cpuchecker";
			}else if(roleName.equals("ROLE_CPUMAKER")){
				page = "redirect:/cpumaker";
			}else if(roleName.equals("ROLE_UAMREPORTSREVIEW")){
				page = "redirect:/uamReportsReview";
			}else if(roleName.equals("ROLE_AUDITUSER")){
				page = "redirect:/audituser";
			}else if(roleName.equals("ROLE_BTGUSER")){
				page = "redirect:/btguser";
			}else if(roleName.equals("ROLE_ITUSER")){
				page = "redirect:/ituser";
			}else if(roleName.equals("ROLE_BPDMAKER")){
				page = "redirect:/cddFormMaker";
			}else if(roleName.equals("ROLE_BPDCHECKER") || roleName.equals("ROLE_BPAMAKER")
					|| roleName.equals("ROLE_BPACHECKER") || roleName.equals("ROLE_COMPLIANCEMAKER") 
					|| roleName.equals("ROLE_COMPLIANCECHECKER") || roleName.equals("ROLE_JGM") || roleName.equals("ROLE_GM")){
				page = "redirect:/cddFormChecker";
			}else if(roleName.equals("ROLE_LEAMAKER")){
				page = "redirect:/leamaker";
			}else if(roleName.equals("ROLE_LEACHECKER")){
				page = "redirect:/leachecker";
			}else if(roleName.equals("ROLE_SCREENINGMAKER")){
				page = "redirect:/screeningMaker";
			}else if(roleName.equals("ROLE_SCREENINGCHECKER")){
				page = "redirect:/screeningChecker";
			}else if(roleName.equals("ROLE_CM_OFFICER")){
				page = "redirect:/cmOfficer";
			}else if(roleName.equals("ROLE_CM_MANAGER")){
				page = "redirect:/cmManager";
			}else if(roleName.equals("ROLE_CM_MAKER")){
				page = "redirect:/cmMaker";
			}else if(roleName.equals("ROLE_CM_CHECKER")){
				page = "redirect:/cmChecker";
			}else if(roleName.equals("ROLE_CM_UAMMAKER")){
				page = "redirect:/cmUAMMaker";
			}else if(roleName.equals("ROLE_CM_UAMCHECKER")){
				page = "redirect:/cmUAMChecker";
			}else if(roleName.equals("ROLE_CM_ADMINMAKER")){
				page = "redirect:/cmAdminMaker";
			}else if(roleName.equals("ROLE_CM_ADMINCHECKER")){
				page = "redirect:/cmAdminChecker";
			}else{
				throw new AccessDeniedException("No default page has been set for the User :"+
						domainUser.getFirstName()+" "+domainUser.getLastName()+"["+domainUser.getUsername()+"]");
			}
		}else{
			throw new AccessDeniedException("No authorities has been set for the User :"+
					domainUser.getFirstName()+" "+domainUser.getLastName()+"["+domainUser.getUsername()+"]");
		}
		log.info("User["+domainUser.getFirstName()+" "+domainUser.getLastName()+"] has "+
				authorities.size()+" role(s). Current Role : "+roleName+", Page : "+page);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "OPEN", "Module Accessed"+page);
		return new ModelAndView(page);
	}
	
	@RequestMapping(value={"/displayHeader"}, method=RequestMethod.GET)
	public String adminHeader(Authentication authentication, SecurityContextHolderAwareRequestWrapper request){
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String DOMAIN = (String) request.getSession(false).getAttribute("instituteName");
		Map<String, String> currentAuthority = new HashMap<String, String>();
		List<Map<String, String>> allAuthorities = new ArrayList<Map<String, String>>();		
		
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		
		for(GrantedAuthority authority : authorities){
			String strAuthority = authority.getAuthority();
			if(strAuthority.equals(CURRENTROLE)){
				currentAuthority = loginService.getRoleNameUrl(strAuthority);
			}else{
				Map<String, String> otherProfileDetails = loginService.getRoleNameUrl(strAuthority);
				allAuthorities.add(otherProfileDetails);
			}
		}
		
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		Map<String, String> lastLogin = loginService.getLastLogins(domainUser.getUsername(), CURRENTROLE, request.getRemoteAddr());
		
		if(lastLogin.get("SUCCESSFULLOGINTIME") != null && !"".equals(lastLogin.get("SUCCESSFULLOGINTIME"))){
			lastLogin.put("SUCCESSFULLOGINTIMEDIFF", otherCommonService.changeToDayTimeMin(lastLogin.get("SUCCESSFULLOGINTIMEDIFF"))+" back,");
			
			/*SEARCH FUNCTIONALITY CHANGES STARTED*/
			
			CURRENTROLE = CURRENTROLE.replace("ROLE_", "");
			String userCode = authentication.getPrincipal().toString();
			Map<String, Map<String, Map<String, Map<String, String>>>> modulesForUser = 
					commonService.userModule(userCode, CURRENTROLE);
			request.setAttribute("MODULES", modulesForUser);
			/*SEARCH FUNCTIONALITY CHANGES ENDED*/
			request.setAttribute("COUNTWISEMODULES", commonService.getCountWiseModules(domainUser.getUsername(), request.getRemoteAddr()));			
		
		}else
			lastLogin.put("SUCCESSFULLOGINTIMEDIFF", "Logged in for the first time");
		if(lastLogin.get("FAILEDLOGINTIME") != null && !"".equals(lastLogin.get("FAILEDLOGINTIME")) && lastLogin.get("FAILEDLOGINTIMEDIFF") != null){
			lastLogin.put("FAILEDLOGINTIMEDIFF", otherCommonService.changeToDayTimeMin(lastLogin.get("FAILEDLOGINTIMEDIFF"))+" back,");
		}else
			lastLogin.put("FAILEDLOGINTIMEDIFF", "Never had a failed login attempt");
		request.setAttribute("LASTLOGIN", lastLogin);
		request.setAttribute("userDetails", domainUser);
		request.setAttribute("allAuthorities", allAuthorities);
		request.setAttribute("currentAuthority", currentAuthority);
		request.setAttribute("CHATENABLE", domainUser.isChatEnabled());
		request.setAttribute("Domain", DOMAIN);
		
		request.setAttribute("NOTESDATA", userNotesService.getNotesData(domainUser.getUsername(), CURRENTROLE, request.getRemoteAddr()));
		
		return "common/template/defaultHeader";
	}
	
	@RequestMapping(value={"/defaultSidebar"}, method=RequestMethod.GET)
	public String defaultSidebar(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		CURRENTROLE = CURRENTROLE.replace("ROLE_", "");
		String userCode = authentication.getPrincipal().toString();
		Map<String, Map<String, Map<String, Map<String, String>>>> modulesForUser = 
				commonService.userModule(userCode, CURRENTROLE);
		request.setAttribute("MODULES", modulesForUser);
		return "common/template/defaultSideBar";
	}
	
	@RequestMapping(value={"/userSettings"}, method=RequestMethod.GET)
	public String userSettings(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		Collection<GrantedAuthority> authorities = domainUser.getAuthorities();
		List<String> allAuthorities = new ArrayList<String>();
		String roleName = (String) request.getSession(false).getAttribute("CURRENTROLE");
		if(roleName == null){
			roleName = loginService.getUserRoleByPriority(domainUser.getUsername());
		}		
		for(GrantedAuthority grantedAuthority : authorities){
			allAuthorities.add(grantedAuthority.getAuthority());
		}
		request.setAttribute("CURRENTPRIORITY", roleName);
		request.setAttribute("ALLAUTH", allAuthorities);
		
		Configuration config = commonService.getUserConfiguration();
		config.getAuthentication().getProvider();
		if(config.getAuthentication().getProvider().equals(Provider.DATABASE)){			
			request.setAttribute("CHANGEPASSWORD", "DATABASE");
		}else{
			request.setAttribute("CHANGEPASSWORD", "LDAP");
		}
		
		request.setAttribute("ALLLANGCODE", LanguageContextHolder.getAllLanguageCodeInstalled());
		request.setAttribute("CHANGEPASSWORDLOG", loginService.changePasswordLog(domainUser.getUsername()));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDEX", "OPEN", "Module Accessed");
		return "common/userSettings";
	}
	
	@RequestMapping(value={"/updateLanguage"}, method=RequestMethod.POST)
	public @ResponseBody String updateLanguage (HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String langCode = request.getParameter("lang");
		String currentLangCode = request.getSession(false).getAttribute("LANGCODE") != null ? (String) request.getSession(false).getAttribute("LANGCODE") : "";
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDEX", "UPDATE", "Language Updated To "+langCode);
		if(currentLangCode.equals(langCode)){
			return "Your current language is "+langCode+". Please change and apply";
		}else{
			if(commonService.updateLanguage(authentication.getPrincipal().toString(), langCode)){
				request.getSession(false).setAttribute("LANGCODE", langCode);
				request.getSession(false).setAttribute("LANG", LanguageContextHolder.getLanguage(langCode));
				return "Language has been updated for you. Please refresh the page to get effect";
			}else{
				return "Language can not be updated";
			}
		}
	}
	
	@RequestMapping(value={"/updateLabelDirection"}, method=RequestMethod.POST)
	public @ResponseBody String updateLabelDirection (HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String labelDirection = request.getParameter("labelDirection");
		String currentLabelDirection = request.getSession(false).getAttribute("LABELDIR") != null ? (String) request.getSession(false).getAttribute("LABELDIR") : "";
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDEX", "UPDATE", "Label Direction Updated To "+labelDirection);
		if(currentLabelDirection.equals(labelDirection)){
			return "Your current label direction is "+labelDirection+". Please change and apply";
		}else{
			if(commonService.updateLabelDirection(authentication.getPrincipal().toString(), labelDirection)){
				request.getSession(false).setAttribute("LABELDIR", labelDirection);
				return "Label direction has been updated for you. Please refresh the page to get effect";
			}else{
				return "Label direction can not be updated";
			}
		}
	}
	
	@RequestMapping(value={"/updateLabelProperties"}, method=RequestMethod.POST)
	public @ResponseBody String updateLabelProperties (HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String message = "";
		CompassLanguageLoaderUtil loaderUtil = new CompassLanguageLoaderUtil();
		try {
			messageSource.clearCache();
			loaderUtil.loadLanguagesInstalled();
			try{
				String currentLangCode = request.getSession(false).getAttribute("LANGCODE") != null ? (String) request.getSession(false).getAttribute("LANGCODE") : "";
				if(currentLangCode != null){
					request.getSession(false).setAttribute("LANG", LanguageContextHolder.getLanguage(currentLangCode));
					message = "Language properties updated";
				}else{
					message = "Failed to update language properties";
				}
			}catch(Exception e){
				message = e.getMessage();
			}
		} catch (Exception e) {
			message = e.getMessage();
			e.printStackTrace();
		}
		return message;
	}
	
	@RequestMapping(value={"/403"}, method=RequestMethod.GET)
	public String get403(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDEX", "OPEN", "Access Violated");
		return "common/errors/403";
	}
	
	@RequestMapping(value={"/admin"}, method=RequestMethod.GET)
	public String getAdminContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/admin/";
	}
	
	@RequestMapping(value={"/mlro"}, method=RequestMethod.GET)
	public String getMLROContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/mlro/";
	}
	
	@RequestMapping(value={"/mlroL1"}, method=RequestMethod.GET)
	public String getMLROL1Context(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/mlroL1/";
	}
	
	@RequestMapping(value={"/mlroL2"}, method=RequestMethod.GET)
	public String getMLROL2Context(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/mlroL2/";
	}
	
	@RequestMapping(value={"/amlo"}, method=RequestMethod.GET)
	public String getAMLOContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/amlo/";
	}
	
	@RequestMapping(value={"/amluser"}, method=RequestMethod.GET)
	public String getAMLUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/amluser/";
	}
	
	@RequestMapping(value={"/amluserL1"}, method=RequestMethod.GET)
	public String getAMLUserL1Context(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/amluserL1/";
	}
	
	@RequestMapping(value={"/amluserL2"}, method=RequestMethod.GET)
	public String getAMLUserL2Context(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/amluserL2/";
	}
	
	@RequestMapping(value={"/amluserL3"}, method=RequestMethod.GET)
	public String getAMLUserL3Context(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/amluserL3/";
	}
	
	@RequestMapping(value={"/amlrep"}, method=RequestMethod.GET)
	public String getAMLRepContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/amlrep/";
	}
	
	@RequestMapping(value={"/user"}, method=RequestMethod.GET)
	public String getUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/user/";
	}
	
	@RequestMapping(value={"/branchuser"}, method=RequestMethod.GET)
	public String geBranchtUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/branchuser/";
	}
	
	@RequestMapping(value={"/fatcamanager"}, method=RequestMethod.GET)
	public String getFATCAManagerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/fatcamanager/";
	}
	
	@RequestMapping(value={"/fatcaofficer"}, method=RequestMethod.GET)
	public String getFATCAOfficerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/fatcaofficer/";
	}
	
	@RequestMapping(value={"/fatcauser"}, method=RequestMethod.GET)
	public String getFATCAUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/fatcauser/";
	}
	
	@RequestMapping(value={"/fatcarmuser"}, method=RequestMethod.GET)
	public String getFATCARMUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/fatcarmuser/";
	}
	
	@RequestMapping(value={"/etl"}, method=RequestMethod.GET)
	public String getETLContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/etl/";
	}
	
	@RequestMapping(value={"/maker"}, method=RequestMethod.GET)
	public String getMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/maker/";
	}
	
	@RequestMapping(value={"/checker"}, method=RequestMethod.GET)
	public String getCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/checker/";
	}
	
	@RequestMapping(value={"/uamReportsReview"}, method=RequestMethod.GET)
	public String getUAMReportsReviewContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/uamReportsReview/";
	}
	
	@RequestMapping(value={"/cpuadmin"}, method=RequestMethod.GET)
	public String getCpuAdminContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cpuadmin/";
	}
	
	@RequestMapping(value={"/cpuchecker"}, method=RequestMethod.GET)
	public String getCpuCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{	
		
		return "redirect:/cpuchecker/";
	}
	
	@RequestMapping(value={"/cpumaker"}, method=RequestMethod.GET)
	public String getCpuMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cpumaker/";
	}
	
	@RequestMapping(value={"/audituser"}, method=RequestMethod.GET)
	public String getAuditUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/audituser/";
	}
	
	@RequestMapping(value={"/btguser"}, method=RequestMethod.GET)
	public String getBTGUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/btguser/";
	}
	
	@RequestMapping(value={"/ituser"}, method=RequestMethod.GET)
	public String getITUserContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/ituser/";
	}
	
	@RequestMapping(value={"/cddFormMaker"}, method=RequestMethod.GET)
	public String getCddFormMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cddFormMaker/";
	}
	
	@RequestMapping(value={"/cddFormChecker"}, method=RequestMethod.GET)
	public String getCddFormCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cddFormChecker/";
	}
	
	@RequestMapping(value={"/leamaker"}, method=RequestMethod.GET)
	public String getLEAMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/leamaker/";
	}
	
	@RequestMapping(value={"/leachecker"}, method=RequestMethod.GET)
	public String getLEACheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/leachecker/";
	}
	
	@RequestMapping(value={"/screeningMaker"}, method=RequestMethod.GET)
	public String getScreeningMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/screeningMaker/";
	}
	
	@RequestMapping(value={"/screeningChecker"}, method=RequestMethod.GET)
	public String getScreeningCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/screeningChecker/";
	}
	
	@RequestMapping(value={"/cmOfficer"}, method=RequestMethod.GET)
	public String getCMOfficerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmOfficer/";
	}
	
	@RequestMapping(value={"/cmManager"}, method=RequestMethod.GET)
	public String getCMManagerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmManager/";
	}
	
	@RequestMapping(value={"/cmMaker"}, method=RequestMethod.GET)
	public String getCMMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmMaker/";
	}
	
	@RequestMapping(value={"/cmChecker"}, method=RequestMethod.GET)
	public String getCMCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmChecker/";
	}
	
	@RequestMapping(value={"/cmUAMMaker"}, method=RequestMethod.GET)
	public String getCMUAMMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmUAMMaker/";
	}
	
	@RequestMapping(value={"/cmUAMChecker"}, method=RequestMethod.GET)
	public String getCMUAMCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmUAMChecker/";
	}
	
	@RequestMapping(value={"/cmAdminMaker"}, method=RequestMethod.GET)
	public String getCMAdminMakerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmAdminMaker/";
	}
	
	@RequestMapping(value={"/cmAdminChecker"}, method=RequestMethod.GET)
	public String getCMAdminCheckerContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return "redirect:/cmAdminChecker/";
	}
}
