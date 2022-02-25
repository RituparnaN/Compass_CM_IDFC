package com.quantumdataengines.app.compass.controller;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.ldap.LdapContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.ActiveDirectoryLdapService;

@Controller
// @RequestMapping(value="/amluser")
public class SecurityTestingController {

	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;

	@RequestMapping(value={"/securityTesting"}, method=RequestMethod.GET)
	public String securityTesting(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//DomainUser domainUser = (DomainUser) authentication.getDetails();
		//log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		System.out.println("SecurityTesting:  ");
		String userName = new com.sun.security.auth.module.NTSystem().getName();
		System.out.println("userName in Controller:  "+userName);
		String moduleType = "raiseSuspicion";
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("BRANCHCODES", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		request.setAttribute("SUSPICIONSCENARIOS", genericMasterService.getSuspicionScenarios("TB_SUSPICIONSCENARIOS"));
		request.setAttribute("TYPEOFSUSPICION", genericMasterService.getReasonForSuspicion("TB_TYPEOFSUSPICIONLIST"));
		//commonService.auditLog(userName, request, moduleType, "READ", "Module Accessed");
		/*
		LdapContext ldapContext = new LdapContext();
		ActiveDirectoryLdapService activeDirectoryLdapService = new ActiveDirectoryLdapService();
		activeDirectoryLdapService.getUserMailByDomainWithUser(ldapContext, "DC=icicibankltd,DC=com", userName);
		*/
		/*
		
		String username = null;
		System.out.println("asdausername:  ");
		//String l_strusername      = (String)request.getSession().getAttribute("username"); 
		//String l_strusernameValue = (String)request.getSession().getAttribute("usernamevalue"); 
		//String l_struserMail      = (String)request.getSession().getAttribute("usermail"); 


		if(request.getSession().getAttribute("username") == null)
		{  
		String auth = request.getHeader("Authorization");
		System.out.println("auth:  "+auth);
		try
		 { 

		   if (auth == null) 
		    { 
		    response.setStatus(response.SC_UNAUTHORIZED); 
		    response.setHeader("WWW-Authenticate", "NTLM"); 
		    response.flushBuffer(); 
		    } 
		   if (auth.startsWith("NTLM ")) 
		   { 
		     byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth.substring(5)); 
		     int off = 0, length, offset; 
		     if (msg[8] == 1) 
		     { 
		       byte z = 0; 
		       byte[] msg1 = {(byte)'N', (byte)'T', (byte)'L', (byte)'M', (byte)'S', (byte)'S', (byte)'P', z,(byte)2, z, z, z, z, z, z, z,(byte)40, z, z, z, (byte)1, (byte)130, z, z,z, (byte)2, (byte)2, (byte)2, z, z, z, z, z, z, z, z, z, z, z, z}; 
		       response.setHeader("WWW-Authenticate", "NTLM " + new sun.misc.BASE64Encoder().encodeBuffer(msg1)); 
		       response.sendError(response.SC_UNAUTHORIZED);
		     } 
		    else if (msg[8] == 3) 
		    {
		       off = 30; 
		       length = msg[off+17]*256 + msg[off+16]; 
		       offset = msg[off+19]*256 + msg[off+18]; 
		       String remoteHost = new String(msg, offset, length); 
		       length = msg[off+1]*256 + msg[off]; 
		       offset = msg[off+3]*256 + msg[off+2]; 
		       String domain = new String(msg, offset, length); 
		       length = msg[off+9]*256 + msg[off+8];
		       offset = msg[off+11]*256 + msg[off+10]; 
		       //String username = new String(msg, offset, length); 
		       username = new String(msg, offset, length); 
		       char a =0; 
		       char b =32; 
		       System.out.println("Username:"+username.trim().replace(a,b).replaceAll(" ","")); 
		       System.out.println("RemoteHost:"+remoteHost.trim().replace(a,b).replaceAll(" ","")); 
		       System.out.println("Domain:"+domain.trim().replace(a,b).replaceAll(" ","")); 
		       request.getSession().setAttribute("username",username.trim().replace(a,b).replaceAll(" ","")); 
		       request.getSession().setAttribute("domain",domain.trim().replace(a,b).replaceAll(" ","")); 
		       response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
		    } 
		  } 
		  }catch(Exception e)
		  { 
		    //System.out.println(e.getMessage()); 
		  }
		}

		if(request.getSession().getAttribute("usernamevalue") == null && request.getSession().getAttribute("usermail") == null)
		{  

		try {
		            char a =0; 
		            char b =32; 

		            String userName = username.trim().replace(a,b).replaceAll(" ","");

		            String DOMAIN_NAME = "icicibankltd";
		            String DOMAIN_CONTROLER = "domaincontroller";
		            
		            Hashtable env = new Hashtable();

		            env.put(Context.SECURITY_AUTHENTICATION,"simple");

		            //String activeDirUser = DOMAIN_NAME + "\\37766";
		            String activeDirUser = DOMAIN_NAME + "\\"+userName;

		            env.put(Context.SECURITY_PRINCIPAL, activeDirUser);
		            String host = "10.16.1.117";
		            String port = "3268";

		            String url = new String("ldap://"+host+":"+port);
		            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		            env.put(Context.PROVIDER_URL,url);

		            DirContext ctx;
		            ctx = new InitialDirContext(env);
		            //String as[] = {"mailNickName", "distinguishedName", "mail", "name", "lname", "sAMAccountName"};
		            String as[] = {"mail", "name"};
		            SearchControls ctls = new SearchControls();
		            ctls.setReturningAttributes(as);
		            ctls.setCountLimit(1);
		            ctls.setReturningObjFlag(true);
		            ctls.setSearchScope(2);

		            //String userLogon = "37766";
		            String filter = "(%A(sAMAccountName=%U)( distinguishedName=*))";

		            StringBuffer sb = new StringBuffer();
		            int i = filter.length();
		            boolean flag = false;
		            for(int j = 0; j < i; j++)
		            {
		            char ch = filter.charAt(j);
		            if(flag)
		            {
		                if(ch == 'U')
		                    sb.append(userName);
		                else
		                if(ch == 'A')
		                {
		                    sb.append("&");
		                } else
		                {
		                    sb.append('%');
		                    sb.append(ch);
		                }
		                flag = false;
		            } else
		            {
		                switch(ch)
		                {
		                case 37: // '%'
		                    flag = true;
		                    break;

		                default:
		                    sb.append(ch);
		                    break;
		                }
		            }
		          }
		          String filter1 = sb.toString(); 

		          NamingEnumeration n= ctx.search("DC=icicibankltd,DC=com",filter1,ctls);

		          String l_strKey = n.next().toString();
		          String l_strUserMail=l_strKey.substring(l_strKey.indexOf("mail:")+5,l_strKey.indexOf("name")-1);
		          String l_strRestValue =  l_strKey.substring(l_strKey.indexOf("mail:")+5,l_strKey.length());
		          String l_strUserName  =l_strRestValue.substring(l_strRestValue.indexOf("name:")+5,l_strRestValue.indexOf("/")-1);

		          request.getSession().setAttribute("usermail",l_strUserMail.trim().replace(",","")); 
		          request.getSession().setAttribute("usernamevalue",l_strUserName.trim()); 

		          //out.println("l_strUserMail    "+l_strUserMail+"<BR>");
		          //out.println("l_strUserName    "+l_strUserName+"<BR>");

		          while (n.hasMoreElements()) {

		          System.out.println(n.next());
		          }
		          ctx.close();
		        } catch (Exception e) {
		           System.out.println("Exception = "+ e);
		        }
		}
		 String l_SerialNo=System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9);
		 String l_strCustomerType = request.getParameter("CustomerType");
		 if(l_strCustomerType == null) l_strCustomerType="C";
		 String l_strMesage = (String)request.getAttribute("Message");
		 
		
		*/
		return "SecurityTesting";
	}
}
