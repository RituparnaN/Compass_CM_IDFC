//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2016.12.23 at 02:06:26 PM IST 
//


package com.quantumdataengines.app.compass.util.fatca.validfile;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * 				
 * <pre>
 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;Component xmlns="urn:fatca:fatcavalidfilenotification" xmlns:fnb="urn:fatca:fatcanotificationbase" xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsd="http://www.w3.org/2001/XMLSchema"&gt;
 * 					&lt;DictionaryEntryNm&gt;Type for Record Error Group&lt;/DictionaryEntryNm&gt;
 * 					&lt;MajorVersionNum&gt;1&lt;/MajorVersionNum&gt;
 * 					&lt;MinorVersionNum&gt;0&lt;/MinorVersionNum&gt;
 * 					&lt;VersionEffectiveBeginDt&gt;2014-12-19&lt;/VersionEffectiveBeginDt&gt;
 * 					&lt;VersionDescriptionTxt&gt;Initial Version&lt;/VersionDescriptionTxt&gt;
 * 					&lt;Description&gt;Contains the type details of Record Error Group&lt;/Description&gt;
 * 				&lt;/Component&gt;
 * </pre>
 * 
 * 			
 * 
 * <p>Java class for FATCARecordErrorGrpType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="FATCARecordErrorGrpType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{urn:fatca:fatcanotificationbase}RecordErrorInfoHeaderTxt"/>
 *         &lt;element ref="{urn:fatca:fatcavalidfilenotification}FATCARecordErrorFIGrp" maxOccurs="unbounded"/>
 *         &lt;element ref="{urn:fatca:fatcanotificationbase}PotentialEffectTxt"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "FATCARecordErrorGrpType", namespace = "urn:fatca:fatcavalidfilenotification", propOrder = {
    "recordErrorInfoHeaderTxt",
    "fatcaRecordErrorFIGrp",
    "potentialEffectTxt"
})
public class FATCARecordErrorGrpType {

    @XmlElement(name = "RecordErrorInfoHeaderTxt", namespace = "urn:fatca:fatcanotificationbase", required = true)
    protected String recordErrorInfoHeaderTxt;
    @XmlElement(name = "FATCARecordErrorFIGrp", required = true)
    protected List<FATCARecordErrorFIGrpType> fatcaRecordErrorFIGrp;
    @XmlElement(name = "PotentialEffectTxt", namespace = "urn:fatca:fatcanotificationbase", required = true)
    protected String potentialEffectTxt;

    /**
     * Gets the value of the recordErrorInfoHeaderTxt property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecordErrorInfoHeaderTxt() {
        return recordErrorInfoHeaderTxt;
    }

    /**
     * Sets the value of the recordErrorInfoHeaderTxt property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecordErrorInfoHeaderTxt(String value) {
        this.recordErrorInfoHeaderTxt = value;
    }

    /**
     * Gets the value of the fatcaRecordErrorFIGrp property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the fatcaRecordErrorFIGrp property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getFATCARecordErrorFIGrp().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link FATCARecordErrorFIGrpType }
     * 
     * 
     */
    public List<FATCARecordErrorFIGrpType> getFATCARecordErrorFIGrp() {
        if (fatcaRecordErrorFIGrp == null) {
            fatcaRecordErrorFIGrp = new ArrayList<FATCARecordErrorFIGrpType>();
        }
        return this.fatcaRecordErrorFIGrp;
    }

    /**
     * Gets the value of the potentialEffectTxt property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPotentialEffectTxt() {
        return potentialEffectTxt;
    }

    /**
     * Sets the value of the potentialEffectTxt property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPotentialEffectTxt(String value) {
        this.potentialEffectTxt = value;
    }

}
