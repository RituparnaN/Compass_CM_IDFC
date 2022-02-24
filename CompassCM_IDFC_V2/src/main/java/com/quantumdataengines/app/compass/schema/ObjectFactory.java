//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.04.27 at 05:46:50 PM IST 
//


package com.quantumdataengines.app.compass.schema;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.quantumdataengines.app.compass.schema package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _Paths_QNAME = new QName("", "paths");
    private final static QName _Configurations_QNAME = new QName("", "configurations");
    private final static QName _Configuration_QNAME = new QName("", "configuration");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.quantumdataengines.app.compass.schema
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Paths }
     * 
     */
    public Paths createPaths() {
        return new Paths();
    }

    /**
     * Create an instance of {@link Configurations }
     * 
     */
    public Configurations createConfigurations() {
        return new Configurations();
    }

    /**
     * Create an instance of {@link Configuration }
     * 
     */
    public Configuration createConfiguration() {
        return new Configuration();
    }

    /**
     * Create an instance of {@link SsoProvider }
     * 
     */
    public SsoProvider createSsoProvider() {
        return new SsoProvider();
    }

    /**
     * Create an instance of {@link ImapHost }
     * 
     */
    public ImapHost createImapHost() {
        return new ImapHost();
    }

    /**
     * Create an instance of {@link Manager }
     * 
     */
    public Manager createManager() {
        return new Manager();
    }

    /**
     * Create an instance of {@link BaseDN }
     * 
     */
    public BaseDN createBaseDN() {
        return new BaseDN();
    }

    /**
     * Create an instance of {@link LdapHostPort }
     * 
     */
    public LdapHostPort createLdapHostPort() {
        return new LdapHostPort();
    }

    /**
     * Create an instance of {@link LdapHostIP }
     * 
     */
    public LdapHostIP createLdapHostIP() {
        return new LdapHostIP();
    }

    /**
     * Create an instance of {@link EmailId }
     * 
     */
    public EmailId createEmailId() {
        return new EmailId();
    }

    /**
     * Create an instance of {@link AuthId }
     * 
     */
    public AuthId createAuthId() {
        return new AuthId();
    }

    /**
     * Create an instance of {@link Domain }
     * 
     */
    public Domain createDomain() {
        return new Domain();
    }

    /**
     * Create an instance of {@link LdapDetails }
     * 
     */
    public LdapDetails createLdapDetails() {
        return new LdapDetails();
    }

    /**
     * Create an instance of {@link ImapPort }
     * 
     */
    public ImapPort createImapPort() {
        return new ImapPort();
    }

    /**
     * Create an instance of {@link SmtpPort }
     * 
     */
    public SmtpPort createSmtpPort() {
        return new SmtpPort();
    }

    /**
     * Create an instance of {@link SsoDetails }
     * 
     */
    public SsoDetails createSsoDetails() {
        return new SsoDetails();
    }

    /**
     * Create an instance of {@link EmailPassword }
     * 
     */
    public EmailPassword createEmailPassword() {
        return new EmailPassword();
    }

    /**
     * Create an instance of {@link SmtpHost }
     * 
     */
    public SmtpHost createSmtpHost() {
        return new SmtpHost();
    }

    /**
     * Create an instance of {@link JndiDetails }
     * 
     */
    public JndiDetails createJndiDetails() {
        return new JndiDetails();
    }

    /**
     * Create an instance of {@link LdapUsername }
     * 
     */
    public LdapUsername createLdapUsername() {
        return new LdapUsername();
    }

    /**
     * Create an instance of {@link LdapPassword }
     * 
     */
    public LdapPassword createLdapPassword() {
        return new LdapPassword();
    }

    /**
     * Create an instance of {@link WebServiceProvider }
     * 
     */
    public WebServiceProvider createWebServiceProvider() {
        return new WebServiceProvider();
    }

    /**
     * Create an instance of {@link Email }
     * 
     */
    public Email createEmail() {
        return new Email();
    }

    /**
     * Create an instance of {@link Authentication }
     * 
     */
    public Authentication createAuthentication() {
        return new Authentication();
    }

    /**
     * Create an instance of {@link LdapProvider }
     * 
     */
    public LdapProvider createLdapProvider() {
        return new LdapProvider();
    }

    /**
     * Create an instance of {@link AmlEmail }
     * 
     */
    public AmlEmail createAmlEmail() {
        return new AmlEmail();
    }

    /**
     * Create an instance of {@link EtlEmail }
     * 
     */
    public EtlEmail createEtlEmail() {
        return new EtlEmail();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Paths }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "paths")
    public JAXBElement<Paths> createPaths(Paths value) {
        return new JAXBElement<Paths>(_Paths_QNAME, Paths.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Configurations }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "configurations")
    public JAXBElement<Configurations> createConfigurations(Configurations value) {
        return new JAXBElement<Configurations>(_Configurations_QNAME, Configurations.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Configuration }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "configuration")
    public JAXBElement<Configuration> createConfiguration(Configuration value) {
        return new JAXBElement<Configuration>(_Configuration_QNAME, Configuration.class, null, value);
    }

}
