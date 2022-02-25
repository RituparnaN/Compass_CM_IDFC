package com.quantumdataengines.app.compass.interceptor;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.CompassPasswordDecryptor;

@Component
public class LoginFailedHandler implements AuthenticationFailureHandler{

	private static final Logger log = LoggerFactory.getLogger(LoginFailedHandler.class);
	@Autowired
	private LoginService loginService;
	@Autowired
	private CompassPasswordDecryptor desPasswordDec;
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException authException)
			throws IOException, ServletException {
		log.error("Authentication error : "+authException.getMessage());
		String ipAddress = request.getRemoteAddr();
		String hashToken = getCSRFToken(request);
		String userName = desPasswordDec.decrypt(request.getParameter("username"), hashToken);
		//System.out.println("userName:  "+userName);
		//loginService.setSystemLoginLog(request.getParameter("username"), "NA", ipAddress, "N", authException.getMessage(),"", CommonUtil.getBrowserFingerPrint(request));
		loginService.setSystemLoginLog(userName, "NA", ipAddress, "N", authException.getMessage(),"", CommonUtil.getBrowserFingerPrint(request));
		request.setAttribute("error", authException.getMessage());
		request.getRequestDispatcher("loginFailure").forward(request, response);
	}
	
	private String getCSRFToken(HttpServletRequest request){
		CsrfToken token = (CsrfToken) request.getAttribute("_csrf");
		char first = token.getToken().charAt(4);
		char second = token.getToken().charAt(5);
		
		char third = token.getToken().charAt(10);
		char fourth = token.getToken().charAt(17);
		char fifth = token.getToken().charAt(22);
		
		char sixth = token.getToken().charAt(28);
		char seventh = token.getToken().charAt(30);
		char eight = token.getToken().charAt(32);
		
		String firstPhase = ""+second+first;
		String secondPhase = ""+fourth+fifth+third;
		String thirdPhase = ""+eight+seventh+sixth;
		String fullPhase = firstPhase+thirdPhase+secondPhase;
		return fullPhase.toUpperCase();
	}

}
