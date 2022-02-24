package com.quantumdataengines.app.compass.util;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

public class ActiveDirectoryLdapUtil
{
	
	public static void main(String args[]) {
		//ActiveDirectoryLdapUtil ad = new ActiveDirectoryLdapUtil();
		ActiveDirectoryLdapUtil.getAllAttributes("ApacheDS", "QDE");
	}

	
	public static Map<String, String> getAllAttributes(String ldapType, String userLogon){
		System.out.println("in util  = "+ldapType+" "+userLogon);
		Map<String, String> attributesMap =  new HashMap<String, String>();
		if("ApacheDS".equalsIgnoreCase(ldapType)) {
		try {
	            //char a =0; 
	            //char b =32; 

	            /*String DOMAIN_NAME = "qdepvtltd";
	            String DOMAIN_CONTROLER = "domaincontroller";
			 	String host = "localhost";
			 	String port = "10389";*/
	            
	            Hashtable<Object, Object> env = new Hashtable<Object, Object>();

	            String DOMAIN_NAME = CommonUtil.loadProperties().getProperty("compass.aml.config.domainName");
	            String DOMAIN_CONTROLER = CommonUtil.loadProperties().getProperty("compass.aml.config.domainController");
	            String host = CommonUtil.loadProperties().getProperty("compass.aml.config.host");
	            String port = CommonUtil.loadProperties().getProperty("compass.aml.config.port");
	            
				/*System.out.println("DOMAIN_NAME = "+DOMAIN_NAME);
				System.out.println("DOMAIN_CONTROLER = "+DOMAIN_CONTROLER);
				System.out.println("host = "+host);
				System.out.println("port = "+port);*/
	            		
	           /* String url = new String("ldap://localhost:10389");
	            String initialContextFactory = "com.sun.jndi.ldap.LdapCtxFactory";
	            String securityAuth = "simple";
	            String referral = "follow";*/
				
	            String url = CommonUtil.loadProperties().getProperty("compass.aml.config.ldapProviderUrl");
	            String initialContextFactory = CommonUtil.loadProperties().getProperty("compass.aml.config.initialContextFactory");
	            String securityAuth = CommonUtil.loadProperties().getProperty("compass.aml.config.securityAuth");
	            String referral = CommonUtil.loadProperties().getProperty("compass.aml.config.referral");
	            
	            /*System.out.println("url = "+url);
	            System.out.println("initialContextFactory = "+initialContextFactory);
	            System.out.println("securityAuth = "+securityAuth);
	            System.out.println("referral = "+referral);*/
	            
	            env.put(Context.INITIAL_CONTEXT_FACTORY, initialContextFactory);
	            env.put(Context.PROVIDER_URL, new String(url));
	            env.put(Context.SECURITY_AUTHENTICATION, securityAuth);
	            env.put(Context.REFERRAL, referral);
	            
	            DirContext dirContext;
	            dirContext = new InitialDirContext(env);
	            
	            //String as[] = {"mailNickName", "distinguishedName", "mail", "name", "lname", "sAMAccountName"};
	            //String as[] = {"mail", "name"};
	            SearchControls ctls = new SearchControls();
	            ctls.setSearchScope(2);
	            ctls.setReturningAttributes(null);
	            //ctls.setReturningAttributes(as);
	            ctls.setReturningObjFlag(true);
	            
	            /*String filter = "(%A(sAMAccountName=%U)( distinguishedName=*))";
	            filter = "(&(objectClass=inetOrgPerson)(uid={0}))";
	            filter = "(&(&(objectClass=person)(objectCategory=user))(sAMAccountName=" + userLogon + "))";
	            filter = "(&(objectClass=inetOrgPerson)(uid="+userLogon+"))";
	            System.out.println("filter  = "+filter);
	            */
	            String filter = CommonUtil.loadProperties().getProperty("compass.aml.config.filter").replace("@userLogon", userLogon);
	            
	            String baseDN = CommonUtil.loadProperties().getProperty("compass.aml.config.baseDN");
	            
	            //System.out.println("config = "+baseDN+"~~"+filter+"~~"+ctls);
	            
	            NamingEnumeration namingEnumeration = dirContext.search(baseDN, filter, ctls);
	            
	          	//n = ctx.search("dc=example,dc=com", filter, ctls);
	          	String domainName = null;
	          	
	          	while(namingEnumeration.hasMore()) {
	              SearchResult result = (SearchResult) namingEnumeration.next();
	              domainName = result.getNameInNamespace();
	              Attributes attributes = result.getAttributes();
	              NamingEnumeration namingEnumeration1 = attributes.getAll();
	              while(namingEnumeration1.hasMore()) {
	            	  Attribute attribute = (Attribute)namingEnumeration1.next();
	            	  attributesMap.put(attribute.getID(), attributes.get(attribute.getID()).get().toString());
	            	 // allAttributes = allAttributes + attribute.getID()+" ,: "+attributes.get(attribute.getID()).get().toString()+"\n";
	              }
	          	}

	          	if (domainName == null || namingEnumeration.hasMore()) {
	              throw new NamingException("Authentication failed");
	          	}
	          
	          	namingEnumeration.close();
	        } catch (Exception e) {
	           System.out.println("Exception2 = "+ e);
	           e.printStackTrace();
	        }
		}else {
			System.out.println("Unknown DS");
		}
		//System.out.println(attributesMap);
		return attributesMap;
	}
	
	 
}