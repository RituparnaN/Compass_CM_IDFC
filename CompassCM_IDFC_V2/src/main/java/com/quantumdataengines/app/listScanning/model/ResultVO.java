package com.quantumdataengines.app.listScanning.model;

import java.io.Serializable;

public class ResultVO
 implements Serializable
{

 public ResultVO()
 {
     m_strCustomerId = null;
     m_strCustomerName = null;
     m_strListName = null;
     m_strEntityName = null;
     m_strCustomerType = null;
     m_strCustomerCreatedDate = null;
     m_strBranchCode = null;
     m_strMatchDate = null;
     m_strListID = null;
     m_strReasonForAddition = null;
     m_strCustomerId = "";
     m_strCustomerName = "";
     m_strListName = "";
     m_strEntityName = "";
     m_strCustomerType = "";
     m_strCustomerCreatedDate = "";
     m_strBranchCode = "";
     m_strRank = "";
     m_strMatchDate = "";
     m_strListID = "";
     m_strReasonForAddition = "";
 }

 public String getM_strRank()
 {
     return m_strRank;
 }

 public void setM_strRank(String m_strRank)
 {
     this.m_strRank = m_strRank;
 }

 public String getM_strBranchCode()
 {
     return m_strBranchCode;
 }

 public void setM_strBranchCode(String m_strBranchCode)
 {
     this.m_strBranchCode = m_strBranchCode;
 }

 public String getM_strCustomerCreatedDate()
 {
     return m_strCustomerCreatedDate;
 }

 public void setM_strCustomerCreatedDate(String m_strCustomerCreatedDate)
 {
     this.m_strCustomerCreatedDate = m_strCustomerCreatedDate;
 }

 public String getM_strCustomerId()
 {
     return m_strCustomerId;
 }

 public void setM_strCustomerId(String m_strCustomerId)
 {
     this.m_strCustomerId = m_strCustomerId;
 }

 public String getM_strCustomerName()
 {
     return m_strCustomerName;
 }

 public void setM_strCustomerName(String m_strCustomerName)
 {
     this.m_strCustomerName = m_strCustomerName;
 }

 public String getM_strCustomerType()
 {
     return m_strCustomerType;
 }

 public void setM_strCustomerType(String m_strCustomerType)
 {
     this.m_strCustomerType = m_strCustomerType;
 }

 public String getM_strEntityName()
 {
     return m_strEntityName;
 }

 public void setM_strEntityName(String m_strEntityName)
 {
     this.m_strEntityName = m_strEntityName;
 }

 public String getM_strListID()
 {
     return m_strListID;
 }

 public void setM_strListID(String m_strListID)
 {
     this.m_strListID = m_strListID;
 }

 public String getM_strListName()
 {
     return m_strListName;
 }

 public void setM_strListName(String m_strListName)
 {
     this.m_strListName = m_strListName;
 }

 public String getM_strMatchDate()
 {
     return m_strMatchDate;
 }

 public void setM_strMatchDate(String m_strMatchDate)
 {
     this.m_strMatchDate = m_strMatchDate;
 }

 public String getM_strReasonForAddition()
 {
     return m_strReasonForAddition;
 }

 public void setM_strReasonForAddition(String m_strReasonForAddition)
 {
     this.m_strReasonForAddition = m_strReasonForAddition;
 }

 private String m_strCustomerId;
 private String m_strCustomerName;
 private String m_strListName;
 private String m_strEntityName;
 private String m_strCustomerType;
 private String m_strCustomerCreatedDate;
 private String m_strBranchCode;
 private String m_strRank;
 private String m_strMatchDate;
 private String m_strListID;
 private String m_strReasonForAddition;
}