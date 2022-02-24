package com.quantumdataengines.app.compass.interceptor;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.dao.login.LoginDAO;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.util.CommonUtil;

public class AbstractCheckPointFilter implements HandlerInterceptor{

	private static final Logger log = LoggerFactory.getLogger(AbstractCheckPointFilter.class);
	
	@Autowired
	private SessionRegistry sessionRegistry;
	
	@Autowired
	private LoginService loginService;
	
	
	
	public void setSessionRegistry(SessionRegistry sessionRegistry) {
		this.sessionRegistry = sessionRegistry;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler) throws Exception {
		boolean isValid = true;
		if(!request.getRequestURI().contains("includes") && !request.getRequestURI().contains("securityTesting") && !request.getRequestURI().contains("raiseSuspicionFromPortal")){
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			if(authentication != null && !(authentication.getPrincipal().toString()).equals("anonymousUser") && authentication.getDetails() instanceof DomainUser){
				DomainUser domainUser = (DomainUser) authentication.getDetails();				
				
				if(!request.getRequestURI().contains("resetPassword") &&
						!request.getRequestURI().contains("resetAccountPassword"))
				if(!domainUser.isCredentialsNonExpired()){
					log.info("User ["+domainUser.getFirstName()+" "+domainUser.getLastName()+"] password has been expired");
					isValid = false;
					response.sendRedirect("resetPassword");
				}
			}
			
			if(authentication != null && !(authentication.getPrincipal().toString()).equals("anonymousUser") && authentication.getDetails() instanceof DomainUser)
			if(!loginService.checkBrowserInfo(request.getRemoteAddr(), authentication.getPrincipal().toString(), 
					request.getSession(false).getId(), CommonUtil.getBrowserFingerPrint(request))){
				/*System.out.println(CommonUtil.getBrowserFingerPrint(request));
				System.out.println(loginService);*/
				isValid = false;
				request.getSession(false).invalidate();
				response.sendRedirect("index");
			}
			
			List<Object> listPrinc = sessionRegistry.getAllPrincipals();
			if(request.getSession(false) != null && listPrinc.size() == 0 && 
					authentication != null && !request.getRequestURI().contains("logoutSuccess") &&
					!(authentication.getPrincipal().toString()).equals("anonymousUser")){
					isValid = false;
					request.getSession(false).invalidate();
					response.sendRedirect("index");
			}			
		}
		return isValid;
	}
	
	@Override
	public void afterCompletion(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception exception)
			throws Exception {
	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1,
			Object arg2, ModelAndView arg3) throws Exception {
	}
	
	public static Date getFormatedDate(String timeString){
		Calendar cal = Calendar.getInstance();
		Date date = null;
		int hour;
		int minute;
		int second;
		int firstColon;
		int secondColon;
		
		if (timeString == null) throw new java.lang.IllegalArgumentException();

		firstColon = timeString.indexOf(':');
		secondColon = timeString.indexOf(':', firstColon+1);
		if ((firstColon > 0) & (secondColon > 0) & 
		    (secondColon < timeString.length()-1)) {
		    hour = Integer.parseInt(timeString.substring(0, firstColon));
		    minute = Integer.parseInt(timeString.substring(firstColon+1, secondColon));
		    second = Integer.parseInt(timeString.substring(secondColon+1));	 
		    
		    cal.set(Calendar.HOUR_OF_DAY, hour);
		    cal.set(Calendar.MINUTE, minute);
		    cal.set(Calendar.SECOND, second);
		    date = cal.getTime();
		} else {
		    throw new java.lang.IllegalArgumentException();
		}
		return date;
	}
}
