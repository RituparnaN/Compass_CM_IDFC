package com.quantumdataengines.app.compass.interceptor;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class ContextSettingFilter extends OncePerRequestFilter {

	private static final Logger log = LoggerFactory.getLogger(ContextSettingFilter.class);

	@Override
	protected void doFilterInternal(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		boolean idValid = true;
		HttpSession session = request.getSession(false);
		String uri = request.getRequestURI();
		if (uri.contains("loginAction")) {
			String domain = request.getParameter("domain");
			if (StringUtils.isNotBlank(domain) && StringUtils.isNotEmpty(domain)) {				
				session.setAttribute("instituteName", domain);
				log.info("Domain[" + domain	+ "] has been set to the user session..");
			}else{
				idValid = false;
				request.setAttribute("error", "Select the domain you belong to");
				request.getRequestDispatcher("loginFailure").forward(request, response);
			}
		}
		if(idValid)
			filterChain.doFilter(request, response);
	}

}
