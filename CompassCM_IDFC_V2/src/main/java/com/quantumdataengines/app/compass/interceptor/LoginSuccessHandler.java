package com.quantumdataengines.app.compass.interceptor;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.listner.ChatClientListner;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConfigurationsDetails;
import com.quantumdataengines.app.compass.util.LanguageContextHolder;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler{

	private static final Logger log = LoggerFactory.getLogger(LoginSuccessHandler.class);
	@Autowired
	private LoginService loginService;
	@Autowired
	private ConfigurationsDetails configurationsDetails;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		String sessionId = "";
		String domain = request.getParameter("domain");
		HttpSession session = request.getSession(false);
		if (StringUtils.isNotBlank(domain) && StringUtils.isNotEmpty(domain)) {				
			session.setAttribute("instituteName", domain);
			log.info("Domain[" + domain	+ "] has been set to the user session..");
			sessionId = session.getId();
		}else{
			session.invalidate();
		}
		
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String roleName = loginService.getUserRoleByPriority(domainUser.getUsername());
		String ipAddress = request.getRemoteAddr();
		String browserInfo = CommonUtil.getBrowserFingerPrint(request);
		loginService.setSystemLoginLog(domainUser.getUsername(), roleName, ipAddress, "Y", "Successful login", sessionId, browserInfo);
		log.info("Authenticated User["+domainUser.getFirstName()+" "+domainUser.getLastName()+" ("+domainUser.getLanguageCode()+")] : "+domainUser);
		request.getSession(false).setAttribute("USERCODE", domainUser.getUsername());
		request.getSession(false).setAttribute("TERMINAL", request.getRemoteAddr());
		request.getSession(false).setAttribute("LABELDIR", domainUser.getLabelDirection());
		request.getSession(false).setAttribute("LANGCODE", domainUser.getLanguageCode());
		request.getSession(false).setAttribute("LANG", LanguageContextHolder.getLanguage(domainUser.getLanguageCode()));
		session.setAttribute("USERCODE", domainUser.getUsername());
		
		if(domainUser.isChatEnabled()){
			session.setAttribute("CHATSTATUS", "A");
			try {
				new ChatClientListner(configurationsDetails.getConfigurationForInstitution(domain), domainUser.getUsername(), domainUser.getFirstName()+" "+domainUser.getLastName());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		response.setHeader("Location", request.getContextPath());
        response.setHeader("Server", "");
		response.sendRedirect("index");
	}
}
