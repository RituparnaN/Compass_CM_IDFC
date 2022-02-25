//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2016.12.23 at 02:06:26 PM IST 
//


package com.quantumdataengines.app.compass.util.fatca.validfile;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for FATCAReportTypeCdType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="FATCAReportTypeCdType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="ACCOUNT_REPORT"/>
 *     &lt;enumeration value="POOLED_REPORT"/>
 *     &lt;enumeration value="NIL_REPORT"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "FATCAReportTypeCdType")
@XmlEnum
public enum FATCAReportTypeCdType {


    /**
     * Account Report
     * 
     */
    ACCOUNT_REPORT,

    /**
     * Pooled Report
     * 
     */
    POOLED_REPORT,

    /**
     * Nil Report
     * 
     */
    NIL_REPORT;

    public String value() {
        return name();
    }

    public static FATCAReportTypeCdType fromValue(String v) {
        return valueOf(v);
    }

}
