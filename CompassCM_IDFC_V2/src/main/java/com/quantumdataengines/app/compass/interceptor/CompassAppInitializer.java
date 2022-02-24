package com.quantumdataengines.app.compass.interceptor;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.util.HtmlUtils;

public class CompassAppInitializer implements Filter{

class FilteredRequest extends HttpServletRequestWrapper {

    public FilteredRequest(ServletRequest request) {
        super((HttpServletRequest)request);
    }

    public String sanitize(String input) {
        return HtmlUtils.htmlEscape(input);
    	//return input;
    }

    @Override
    public String getParameter(String paramName) {
        String value = sanitize(super.getParameter(paramName));
		if(!paramName.equalsIgnoreCase("content")){
			value = stripXSS(paramName, value);  
        }
        return value;
    }

    @Override
    public String[] getParameterValues(String paramName) {
        // System.out.println("In getParameterValues paramName:  "+paramName);
        String values[] = super.getParameterValues(paramName);
        for (int index = 0; index < values.length; index++) {
            values[index] = sanitize(values[index]);
        }
        return values;
    }
}	
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	private static Pattern[] patterns = new Pattern[]{
    	//Pattern.compile("(\\()*(\\))*(')*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        //Pattern.compile("\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        //Pattern.compile("(/)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		/*
        Pattern.compile("(=)*(!)*(<)*(>)*(@)*(\\{)*(\\})*(:)*(;)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	// Commented from here
    	Pattern.compile("(<)*(>)*(%)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	*/
    	//Pattern.compile("(alert)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	// Commented till here
        /*
    	Pattern.compile("(\\*)*(\\^)*(%)*(\\+)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("(\\*)(\\')*(%)*(\\+)*", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        */
        // Script fragments
        Pattern.compile("<script>*</script>", Pattern.CASE_INSENSITIVE),
        
        // Avoid anything in a src='...' type of expression 11022021
        
        Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        
    	// lonely script tags
        //Pattern.compile("</script>", Pattern.CASE_INSENSITIVE),
        /* Changed By Govind On  24th Sep, 2017, Starts Here */
    	//Pattern.compile("(var)*", Pattern.CASE_INSENSITIVE),
    	Pattern.compile("(document)*(body)*(window)*(href)*", Pattern.CASE_INSENSITIVE),
    	//Pattern.compile("(var)*", Pattern.CASE_INSENSITIVE),
    	Pattern.compile("(window)*(href)*", Pattern.CASE_INSENSITIVE),
        /* Changed By Govind On  24th Sep, 2017, Ends Here */
        //Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	Pattern.compile("<sc(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
    	Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("</script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        Pattern.compile("</sc(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // eval(...)
        Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // expression(...)
        Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
        // javascript:...
        Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
        // vbscript:...
        Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE),
        // onload(...)=...
        Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
                
    };
	
	private String stripXSS(String parameter, String value) {
    	// System.out.println("Came In XSSRequestWrapper -> stripXSS, Parameter is: "+parameter+"  And Value Is: "+value);
        if (value != null) {
            // NOTE: It's highly recommended to use the ESAPI library and uncomment the following line to
            // avoid encoded attacks.
           //  value = ESAPI.encoder().canonicalize(value);
 
        	// System.out.println("Original Value For parameter: "+parameter+" Is: "+value);
            // Avoid null characters
            value = value.replaceAll("\0", "");
 
            // Remove all sections that match a pattern
            for (Pattern scriptPattern : patterns){
                value = scriptPattern.matcher(value).replaceAll("");
            }
        }
        // System.out.println("Changed Value For parameter: "+parameter+" Is: "+value);
        return value;
    }
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        Cookie[] allCookies = req.getCookies();
        String sessionid = req.getSession().getId();
        String contextPath = req.getContextPath();
        String requestedURL = req.getRequestURL().toString();
        //System.out.println("requestedURL:  "+requestedURL);
        String hostHeaderValue = req.getHeader("Host");
        //System.out.println("hostHeaderValue:  "+hostHeaderValue);
        
        //System.out.println("contextPath:  "+contextPath);
        res.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid
                + "; Path=/" + "; HttpOnly; Secure;");
        //res.setHeader("Location", contextPath);
        res.setHeader("Location", null);
        res.setHeader("Server", "");
        //System.out.println("res object is : "+res);
        /*
        HttpResponse httpResponse1 =  (HttpResponse) res;
        Header[] headers = httpResponse1.getAllHeaders();
    	for (Header header : headers) {
    		System.out.println("Key : " + header.getName() 
    		      + " ,Value : " + header.getValue());
    	}
    	*/
        /*
        try{
			UriUtils.decode(req.getRequestURI(), "UTF-8");
			chain.doFilter(new FilteredRequest(req), res);
        } catch(Exception e){
			System.out.println("request.getRequestURI().toUpperCase() : "+req.getRequestURI().toUpperCase());
			System.out.println("Invalid access initiated by user. Redirecting to actual path..");
			res.setStatus(404);
			res.getWriter().println("Not Found");
        }
        */
        String localHostName = InetAddress.getLocalHost().getHostName();
        String localPort = (request.getLocalPort()+"");
        /*
        System.out.println("localHostName:  "+localHostName);
        System.out.println("localPort:  "+localPort);
        */
        List<String> systemIpAddresses = new ArrayList<>();
        Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
        while(networkInterfaces.hasMoreElements()) {
         NetworkInterface networkInterface = networkInterfaces.nextElement();
         List<InterfaceAddress> interfaceAddresses = networkInterface.getInterfaceAddresses();
         for(InterfaceAddress interfaceAddresse: interfaceAddresses) {
         systemIpAddresses.add(interfaceAddresse.getAddress().getHostAddress());
         }
        }
        // System.out.println(systemIpAddresses);
        // System.out.println("hostHeaderValue:  "+hostHeaderValue+" , localHostName:  "+localHostName+" , localPort:  "+localPort+" , systemIpAddresses.contains 10.226.204.253:  "+systemIpAddresses.contains("10.226.204.253"));
        /*
        System.out.println("localHostName:  "+localHostName);
        System.out.println("localPort:  "+localPort);
        System.out.println("systemIpAddresses.contains 10.226.204.253:  "+systemIpAddresses.contains("10.226.204.253"));
        */
        if(hostHeaderValue != null && !hostHeaderValue.equalsIgnoreCase("")){
        	//if(localHostName.equalsIgnoreCase("hbcompocap") || systemIpAddresses.contains("10.226.204.253")){
        	if(localHostName.equalsIgnoreCase("QDE-PC") || systemIpAddresses.contains("127.0.0.1")){	
    	        chain.doFilter(new FilteredRequest(req), res);
        	}
        	else {
        		System.out.println("With Condition percentage request.getRequestURI().toUpperCase() : "+req.getRequestURI().toUpperCase());
    			System.out.println("Invalid access initiated by user. Redirecting to actual path..");
    			res.setStatus(404);
    			res.getWriter().println("Not Found");
        	}
			// UriUtils.decode(req.getRequestURI(), "UTF-8");
		} else if(req.getRequestURI().toUpperCase().contains("%")){
			// System.out.println("In request.getRequestURI().contains  "+request.getRequestURI().contains("securityTesting"));
			System.out.println("With Condition percentage request.getRequestURI().toUpperCase() : "+req.getRequestURI().toUpperCase());
			System.out.println("Invalid access initiated by user. Redirecting to actual path..");
			res.setStatus(404);
			res.getWriter().println("Not Found");
			// UriUtils.decode(req.getRequestURI(), "UTF-8");
		} else if(req.getRequestURI().contains("securityTesting") || req.getRequestURI().contains("raiseSuspicionFromPortal") || req.getRequestURI().contains("commonFromPortal")){
			System.out.println("filter : "+req.getRequestURI());
			// res.setHeader("X-CSRF-TOKEN", UUID.randomUUID().toString());
			chain.doFilter(req, res);
		}
        else {
	        chain.doFilter(new FilteredRequest(req), res);
			
		}
        //chain.doFilter(new FilteredRequest(req), res);
        // chain.doFilter(new FilteredRequest(req), res);
    }		
	

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	

}
