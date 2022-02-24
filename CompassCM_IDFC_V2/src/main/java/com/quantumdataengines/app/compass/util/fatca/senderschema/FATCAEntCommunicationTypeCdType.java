//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2016.12.23 at 02:08:36 PM IST 
//


package com.quantumdataengines.app.compass.util.fatca.senderschema;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for FATCAEntCommunicationTypeCdType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="FATCAEntCommunicationTypeCdType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="NTF"/>
 *     &lt;enumeration value="RPT"/>
 *     &lt;enumeration value="CAR"/>
 *     &lt;enumeration value="REG"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "FATCAEntCommunicationTypeCdType")
@XmlEnum
public enum FATCAEntCommunicationTypeCdType {


    /**
     * FATCA_NOTIFICATION - FATCA Notification communication
     * 
     */
    NTF,

    /**
     * FATCA_REPORT - FATCA Report communication
     * 
     */
    RPT,

    /**
     * FATCA_COMPETENT_AUTHORITY_REQUEST - FATCA Competent Authority Request communication
     * 
     */
    CAR,

    /**
     * FATCA_REGISTRATION_DATA - FATCA Registration Data communication
     * 
     */
    REG;

    public String value() {
        return name();
    }

    public static FATCAEntCommunicationTypeCdType fromValue(String v) {
        return valueOf(v);
    }

}
