package com.quantumdataengines.app.compass.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.util.CommonUtil;

public class UrlAuthorizationFilter implements HandlerInterceptor{

	private static final Logger log = LoggerFactory.getLogger(UrlAuthorizationFilter.class);

	@Autowired
	private LoginService loginService;
	
	@Override
	public void afterCompletion(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1,
			Object arg2, ModelAndView arg3) throws Exception {
		// arg1.setHeader("Server", "Compass");
		arg1.setHeader("Server", "");
		
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {
		boolean isValid = true;
		String currentRole = "";

		// System.out.println("In UrlAuthorization -> PreHandle ");
		
		// System.out.println("Out request.getRequestURI().contains  "+request.getRequestURI().contains("securityTesting"));
		// System.out.println("Out request.getRequestURI() "+request.getRequestURI());
		if(request.getRequestURI().contains("securityTesting") || request.getRequestURI().contains("raiseSuspicionFromPortal")){
			// System.out.println("In request.getRequestURI().contains  "+request.getRequestURI().contains("securityTesting"));
			isValid =  true;
		}	
		else {
		if(request.getSession(false) != null)
			currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		}
		// System.out.println(currentRole);
		if(currentRole != null && !currentRole.equalsIgnoreCase("")){
			// System.out.println("In UrlAuthorization ");
			/*System.out.println(CommonUtil.getBrowserFingerPrint(request));
			System.out.println(loginService);*/
			currentRole = currentRole.replace("ROLE_", "").toLowerCase();
			if(request.getRequestURI().contains("/admin/")){
				if(currentRole.equalsIgnoreCase("ADMIN") || currentRole.equalsIgnoreCase("MAKER") || currentRole.equalsIgnoreCase("CHECKER") || currentRole.toUpperCase().contains("MLRO") || currentRole.toUpperCase().contains("AMLO")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/mlro/")){
				if(currentRole.equalsIgnoreCase("MLRO")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/amlo/")){
				if(currentRole.equalsIgnoreCase("AMLO") || currentRole.toUpperCase().contains("AMLUSER")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/amluser/")){
				if(currentRole.equalsIgnoreCase("AMLUSER") || currentRole.toUpperCase().contains("AMLO")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/user/")){
				if(currentRole.equalsIgnoreCase("USER")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/etl/")){
				if(currentRole.equalsIgnoreCase("ETL")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/maker/")){
				if(currentRole.equalsIgnoreCase("MAKER")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
			
			if(request.getRequestURI().contains("/checker/")){
				if(currentRole.equalsIgnoreCase("CHECKER")){
					isValid =  true;
				}else{
					isValid =  false;
					log.warn("Invalid access initiated by user. Redirecting to actual path..");
					response.sendRedirect("../");
				}
			}
		}
		
		return isValid;
	}

}
