package com.quantumdataengines.app.compass.dao.reports;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ReportDAOImpl implements ReportDAO {
	private static final Logger log = LoggerFactory.getLogger(ReportDAOImpl.class);
	
	private Connection connection = null;
	@Autowired
	private ConnectionUtil connectionUtil;
	
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : INDSTRDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}

    //@Override
    public HashMap<String,Object> reportData(String userName, String reportId, String startDate, String endDate, String amount, String filter1, String filter2, String filter3)
    {
        Connection connection = getConnection();
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		PreparedStatement pstatement = null;
        HashMap<String,Object> reportData = new HashMap<String,Object>();
		//startDate = startDate.equals("")?"":startDate.substring(6,10)+"-"+startDate.substring(3,5)+"-"+startDate.substring(0,2);
		//endDate = endDate.equals("")?"":endDate.substring(6,10)+"-"+endDate.substring(3,5)+"-"+endDate.substring(0,2);
        //String storedProcName = "";
        String queryString = "" ;
        String sql = "Select REPORTPROCEDURENAME AS StoredProcName From Tb_ReportDetails Where ReportId = ? ";
    	//String storedProcName = simpleJdbcTemplate.queryForObject(sql, String.class, reportId);
    	sql = "Select ReportName From Tb_ReportDetails Where ReportId = ? ";
    	String reportName = "Sample";
    	//String reportName = simpleJdbcTemplate.queryForObject(sql, String.class, reportId);
    	reportData.put("reportName", reportName);
    	try
    	{  
		  //callableStatement = connection.prepareCall(storedProcName);
		  //callableStatement.setString(1, startDate);
		  //callableStatement.setString(2, endDate);
		  //callableStatement.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
			
		  //resultSet = callableStatement.executeQuery();
		
    	  sql = "Select ReportName From Tb_ReportDetails Where ReportId = '"+reportId.trim()+"' ";
    	  pstatement = connection.prepareStatement(sql);
          resultSet = pstatement.executeQuery();
          while(resultSet.next())
        	  reportName = resultSet.getString("ReportName");
          if(reportId.equals("SLCTR"))
          {
        	 if(filter1.equals("Incoming") || filter1.equals("IEFT") || filter1.equals("IFT")) 
        		 reportName = "Incoming Electronic Fund Transfers Report"; 
        	 else if(filter1.equals("Outcoming") || filter1.equals("OEFT") || filter1.equals("OFT")) 
        		 reportName = "Outgoing Electronic Fund Transfers Report";
          }
          reportData.put("reportName", reportName);
          
          if(reportId.equals("AGEINGREPORT"))
          {
        	 reportName = reportName+" For "+endDate;
          }
          reportData.put("reportName", reportName);
          	  
      	  resultSet = null;		
		  queryString = "SELECT ROWNUM AS ROWPOSITION, TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANID, "+
			            "       A.CUSTOMERID CUSTID , ACCOUNTNO AS ACCTNO, A.BRANCHCODE BRANCHCODE, AMOUNT, TRANSACTIONTYPE AS TRANTYPE,  "+ 
					    "       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEBITCREDIT, "+
			            "       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANDATE, B.PANNO PANNO, "+  
					  //"       ACCTCURRENCYCODE, CURRENCYCODE, "+ 
					  //"       INSTRUMENTCODE, INSTRUMENTNO, TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') INSTRUMENTDATE,  "+
					    "       CONVERSIONRATE, NARRATION, "+ 
					    "       B.CUSTOMERNAME CUSTNAME, ACCOUNTTYPE AS ACCTTYPE, PRODUCTCODE, COUNTERPARTYID, COUNTERPARTYNAME, COUNTERACCOUNTNO AS COUNTERACCTNO "+
					    "  FROM TB_TRANSACTIONS A, TB_CUSTOMERMASTER B "+
					    " WHERE A.CUSTOMERID = B.CUSTOMERID "+
			            "   AND TRIM(B.PANNO) IS NULL ";

		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
			  queryString = queryString + " AND A.AMOUNT >= "+amount+" ";
		  if(reportId.equals("r2"))
          {
       	  queryString = "SELECT ROWNUM AS ROWPOSITION, TRANSACTIONNO, TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
              			"       A.CUSTOMERID CUSTOMERID, ACCOUNTNO, A.BRANCHCODE BRANCHCODE, AMOUNT, TRANSACTIONTYPE,  "+ 
              			"       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
              			"       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANSACTIONDATE, B.LISTCODE WATCHLISTCODE , "+  
              			"       ACCTCURRENCYCODE, CURRENCYCODE, "+ 
              			"       INSTRUMENTCODE, INSTRUMENTNO, TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') INSTRUMENTDATE,  "+
              			"       CONVERSIONRATE, NARRATION, "+ 
              			"       A.CUSTOMERNAME CUSTOMERNAME, ACCOUNTTYPE, PRODUCTCODE, COUNTERPARTYID, COUNTERPARTYNAME, COUNTERACCOUNTNO "+
              			"  FROM TB_TRANSACTIONS A, TB_CUSTOMERWATCHLISTMAPPING B "+
              			" WHERE A.CUSTOMERID = B.CUSTOMERID "+
              			"   AND LISTCODE = '"+filter1+"' ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
          }
          else if(reportId.equals("r3"))
          {
       	  queryString = "SELECT ROWNUM AS ROWPOSITION, TRANSACTIONNO, TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
              			"       A.CUSTOMERID CUSTOMERID, A.ACCOUNTNO ACCOUNTNO, A.BRANCHCODE BRANCHCODE, AMOUNT, TRANSACTIONTYPE,  "+ 
              			"       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
              			"       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANSACTIONDATE, "+
              			"       CASE WHEN B.RISKRATING = '2' THEN 'MEDIUM' WHEN B.RISKRATING = '3' THEN 'HIGH' ELSE 'LOW' END RISKRATING, "+  
              			"       A.ACCTCURRENCYCODE ACCTCURRENCYCODE, A.CURRENCYCODE CURRENCYCODE, "+ 
              			"       INSTRUMENTCODE, INSTRUMENTNO, TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') INSTRUMENTDATE,  "+
              			"       CONVERSIONRATE, NARRATION, "+ 
              			"       A.CUSTOMERNAME CUSTOMERNAME, A.ACCOUNTTYPE ACCOUNTTYPE, A.PRODUCTCODE PRODUCTCODE, COUNTERPARTYID, COUNTERPARTYNAME, COUNTERACCOUNTNO "+
              			"  FROM TB_TRANSACTIONS A, TB_ACCOUNTSMASTER B "+
              			" WHERE A.ACCOUNTNO = B.ACCOUNTNO "+
              			"   AND B.RISKRATING = '"+filter1+"' ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
          }
          else if(reportId.equals("r4"))
          {
       	  queryString = "SELECT ROWNUM AS ROWPOSITION, TRANSACTIONNO, TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
              			"       A.CUSTOMERID CUSTOMERID, A.ACCOUNTNO ACCOUNTNO, A.BRANCHCODE BRANCHCODE, AMOUNT, TRANSACTIONTYPE,  "+ 
              			"       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
              			"       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANSACTIONDATE, "+
              			"       A.COUNTERCOUNTRYCODE COUNTERCOUNTRYCODE, CASE WHEN B.RISKRATING = '2' THEN 'MEDIUM' WHEN B.RISKRATING = '3' THEN 'HIGH' ELSE 'LOW' END RISKRATING, "+  
              			"       A.ACCTCURRENCYCODE ACCTCURRENCYCODE, A.CURRENCYCODE CURRENCYCODE, "+ 
              			"       INSTRUMENTCODE, INSTRUMENTNO, TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') INSTRUMENTDATE,  "+
              			"       CONVERSIONRATE, NARRATION, "+ 
              			"       A.CUSTOMERNAME CUSTOMERNAME, A.ACCOUNTTYPE ACCOUNTTYPE, A.PRODUCTCODE PRODUCTCODE, COUNTERPARTYID, COUNTERPARTYNAME, COUNTERACCOUNTNO "+
              			"  FROM TB_TRANSACTIONS A, TB_COUNTRYMASTER B "+
              			" WHERE A.COUNTERCOUNTRYCODE = B.COUNTRYCODE "+
              			"   AND B.RISKRATING = '"+filter1+"' ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
          }
          else if(reportId.equals("r5"))
          {
       	  queryString = "SELECT ROWNUM AS ROWPOSITION, A.* FROM ( "+
       	                "       SELECT ACCOUNTNO, CUSTOMERID, CUSTOMERNAME, BRANCHCODE,  PRODUCTCODE, " +
       	                "              ACCOUNTTYPE, SUM(AMOUNT) TOTALAMOUNT, COUNT(1) FREQUENCY "+
              			"         FROM TB_TRANSACTIONS A WHERE 1 = 1 ";
       	  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
 			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
 		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
 			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
 		  
 		  queryString = queryString + " GROUP BY ACCOUNTNO, CUSTOMERID, CUSTOMERNAME, BRANCHCODE,  PRODUCTCODE, ACCOUNTTYPE ) A WHERE 1 = 1 ";

   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.TOTALAMOUNT >= "+amount+" "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null")) 
   			  queryString = queryString + " AND A.FREQUENCY >= "+filter1+" "; 
          }
          else if(reportId.equals("r7"))
		  {
			  queryString = queryString + " AND SUBSTR(A.TRANSACTIONTYPE,1,1) = 'C' ";
		  }
          else if(reportId.equals("r8"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\", TRANSACTIONNO \"TransactionNo\", TRANSACTIONBATCHID||'/'||TRANSACTIONID \"TransactionId\", "+
              			"       A.CUSTOMERID \"CustomerId\", A.ACCOUNTNO \"AccountNo\", A.BRANCHCODE \"BranchCode\", AMOUNT \"Amount\", TRANSACTIONTYPE \"TransactionType\",  "+ 
              			"       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END \"\", "+
              			"       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') \"TransactionDate\", "+
              			"       CASE WHEN B.ACCOUNTSTATUS = 'C' THEN 'CLOSED' WHEN B.ACCOUNTSTATUS = 'D' THEN 'DORMANT' WHEN B.ACCOUNTSTATUS = 'I' THEN 'INACTIVE' ELSE 'ACTIVE' END \"Account Status\", "+  
              			"       CASE WHEN B.RISKRATING = '2' THEN 'MEDIUM' WHEN B.RISKRATING = '3' THEN 'HIGH' ELSE 'LOW' END \"RiskRating\", "+  
              			"       A.ACCTCURRENCYCODE \"Account CurrencyCode\", A.CURRENCYCODE \"CurrencyCode\", "+ 
              			"       INSTRUMENTCODE \"InstrumentCode\", INSTRUMENTNO \"InstrumentNo\", TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') \"InstrumentDate\",  "+
              			"       CONVERSIONRATE \"ConversionRate\", NARRATION \"Narration\", "+ 
              			"       A.CUSTOMERNAME \"CustomerName\", A.ACCOUNTTYPE \"ProductType\", A.PRODUCTCODE \"ProductCode\", COUNTERPARTYID \"Counter PartyId\", COUNTERPARTYNAME \"Counter PartyName\", COUNTERACCOUNTNO \"Counter AccountNo\" "+
              			"  FROM TB_TRANSACTIONS A, TB_ACCOUNTSMASTER B "+
              			" WHERE A.ACCOUNTNO = B.ACCOUNTNO "+
              			"   AND B.ACCOUNTSTATUS = '"+filter1+"' ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
          }
          else if(reportId.equals("mr1"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\",  ALERTNO \"AlertNo\", ALERTCODE \"AlertCode\", ALERTMESSAGE \"AlertMessage\", TO_CHAR(ALERTDATE,'DD-MON-YYYY') \"AlertDate\", "+
       	                "       CASE WHEN A.ALERTSTATUS = '1' THEN 'OPENED' WHEN A.ALERTSTATUS = '2' THEN 'PENDING' WHEN A.ALERTSTATUS = '3' THEN 'CLOSED' ELSE 'OPENED' END  \"AlertStatus\", "+
       	                "       AMOUNT \"Amount\", BENCHMARKVALUE \"BanchMark Amount\", ALERTPRIORITY \"AlertPriority\", "+
       	  				"       ACCOUNTNO \"ACcountNo\", CUSTOMERID \"CustomerId\", CUSTOMERNAME \"CustomerName\", BRANCHCODE \"BranchCode\", BRANCHNAME \"BranchName\", TRANSACTIONNO \"TransactionNo\", TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') \"TransactionDate\", "+
       	  				"       DEPOSITORWITHDRAWAL \"DebitCredit\", PRODUCTCODE \"ProductCode\", PRODUCTNAME \"ProductName\""+
              			"  FROM TB_ALERTSGENERATED A "+
              			" WHERE 1 = 1 ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && !filter1.equals("A")) 
   			  queryString = queryString + " AND A.ALERTSTATUS = '"+filter1+"' "; 
   		  if(filter2 != null && !filter2.equals("") && !filter2.equals("null")) 
   			  queryString = queryString + " AND A.ACCOUNTNO = '"+filter2+"' "; 
   		  if(filter3 != null && !filter3.equals("") && !filter3.equals("null")) 
   			  queryString = queryString + " AND A.CUSTOMERID = '"+filter3+"' "; 
          }
          else if(reportId.equals("mr2"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\", A.ALERTNO \"AlertNo\", A.ALERTCODE \"AlertCode\", "+
       	                "       A.ALERTMESSAGE \"Alert Message\", TO_CHAR(A.ALERTDATE,'DD-MON-YYYY') \"Alertdate\", TO_CHAR(B.STARTDATE,'DD-MON-YYYY') \"CaseDate\", "+
       	                "       A.AMOUNT \"Amount\", A.ACCOUNTNO \"AccountNo\", A.CUSTOMERID \"SerialNo\", A.CUSTOMERNAME \"SerialNo\", A.BRANCHCODE \"BranchCode\", "+
       	  				"       CASE WHEN B.CASESTATUS = '1' THEN 'AMLUser' WHEN B.CASESTATUS = '3' THEN 'AMLO' WHEN B.CASESTATUS = '5' THEN 'MLRO' END  \"Pending With\", "+
       	  				"       AMLUSERCODE \"AMLUser Code\", AMLCOMMENTS \"AMLUser Comments\", TO_CHAR(AMLTIMESTAMP,'DD-MON-YYYY') \"AMLUser Date\", "+
       	  				"       AMLOUSERCODE \"AMLO Code\", AMLOCOMMENTS \"AMLO Comments\", TO_CHAR(AMLOTIMESTAMP,'DD-MON-YYYY') \"AMLO Date\", "+
       	  				"       MLROUSERCODE \"MLRO Code\", MLROCOMMENTS \"MLRO Comments\", TO_CHAR(MLROTIMESTAMP,'DD-MON-YYYY') \"MLRO Date\" "+
              			"  FROM TB_ALERTSGENERATED A, TB_CASEWORKFLOWDETAILS B "+
              			" WHERE A.ALERTNO = B.ALERTNO ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("AMLUser")) 
   			  queryString = queryString + " AND B.CASESTATUS = '1' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("AMLO")) 
   			  queryString = queryString + " AND B.CASESTATUS = '3' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("MLRO")) 
   			  queryString = queryString + " AND B.CASESTATUS = '5' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("A") && filter1.equals("ALL")) 
   			  queryString = queryString + " AND B.CASESTATUS IN ('1','3','5') "; 
   		  if(filter2 != null && !filter2.equals("") && !filter2.equals("null")) 
   			  queryString = queryString + " AND A.ACCOUNTNO = '"+filter2+"' "; 
   		  if(filter3 != null && !filter3.equals("") && !filter3.equals("null")) 
   			  queryString = queryString + " AND A.CUSTOMERID = '"+filter3+"' "; 

          }
          else if(reportId.equals("mr3"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\", A.ALERTNO \"AlertNo\", A.ALERTCODE \"AlertCode\", A.ALERTMESSAGE \"AlertMessage\", "+
       	                "       TO_CHAR(A.ALERTDATE,'DD-MON-YYYY') \"AlertDate\", TO_CHAR(B.STARTDATE,'DD-MON-YYYY') \"CaseDate\", "+
       	                "       A.AMOUNT \"Amount\", A.ACCOUNTNO \"AccountNo\", A.CUSTOMERID \"CustomerId\", A.CUSTOMERNAME \"CustomerName\", A.BRANCHCODE \"BranchCode\", "+
       	  				"       CASE WHEN B.CASESTATUS IN ('2','3') THEN 'AMLUser' WHEN B.CASESTATUS IN ('4','5') THEN 'AMLO' WHEN B.CASESTATUS IN ('6','7') THEN 'MLRO' END \"CompletedWith\", "+
       	  				"       AMLUSERCODE \"AMLUser Code\", AMLCOMMENTS  \"AMLUser Comments\", TO_CHAR(AMLTIMESTAMP,'DD-MON-YYYY') \"AMLUserDate\", "+
       	  				"       AMLOUSERCODE \"AMLO Code\", AMLOCOMMENTS  \"AMLO Comments\", TO_CHAR(AMLOTIMESTAMP,'DD-MON-YYYY') \"AMLODate\", "+
       	  				"       MLROUSERCODE \"MLRO Code\", MLROCOMMENTS  \"MLROComments\", TO_CHAR(MLROTIMESTAMP,'DD-MON-YYYY')  \"MLRODate\" "+
              			"  FROM TB_ALERTSGENERATED A, TB_CASEWORKFLOWDETAILS B "+
              			" WHERE A.ALERTNO = B.ALERTNO ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.ALERTDATE < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("") && !amount.equals("null")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+amount+" "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("AMLUser")) 
   			  queryString = queryString + " AND B.CASESTATUS > '1' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("AMLO")) 
   			  queryString = queryString + " AND B.CASESTATUS > '3' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("MLRO")) 
   			  queryString = queryString + " AND B.CASESTATUS > '5' "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && filter1.equals("A") && filter1.equals("ALL")) 
   			  queryString = queryString + " AND B.CASESTATUS NOT IN ('1') "; 
   		  if(filter2 != null && !filter2.equals("") && !filter2.equals("null")) 
   			  queryString = queryString + " AND A.ACCOUNTNO = '"+filter2+"' "; 
   		  if(filter3 != null && !filter3.equals("") && !filter3.equals("null")) 
   			  queryString = queryString + " AND A.CUSTOMERID = '"+filter3+"' "; 
          }
          else if(reportId.equals("mr4"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\", CUSTOMERID \"CustomerId\", CUSTOMERNAME \"CustomerName\", CUSTOMERTYPE \"CustomerType\", BRANCHCODE \"BranchCode\", "+
       	                "       TO_CHAR(CREATEDDATETIME,'DD-MON-YYYY') \"CreatedDate\", INTRODUCERCUSTOMERID \"Introducer CustomerId\", INTRODUCERNAME \"Introducer CustomerName\", "+
       	                "       TO_CHAR(DATEOFBIRTH,'DD-MON-YYYY') \"DateOfBirth\", RISKRATING \"Riskrating\""+
              			"  FROM TB_CUSTOMERMASTER A "+
              			" WHERE A.INTRODUCERCUSTOMERID IN (SELECT CUSTOMERID FROM TB_CUSTOMERMASTER WHERE ADD_MONTHS(CREATEDDATETIME,"+filter1+") >= SYSDATE ) ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND CREATEDDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND CREATEDDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
          }
          else if(reportId.equals("mr5"))
          {
          queryString = "SELECT ROWNUM AS \"SerialNo\", CUSTOMERID \"CustomerId\", CUSTOMERNAME \"CustomerName\", LISTNAME \"ListName\", "+
       	                "       MATCHEDINFO \"MatchedInfo\", RANK  \"MatchScore\", CUSTOMERTYPE \"CustomerType\", " +
       	  		        "       TO_CHAR(CUSTOMERCREATEDDATE,'DD-MON-YYYY') \"CreatedDate\", BRANCHCODE \"BranchCode\", "+
       	  		        "       TO_CHAR(MATCHDATE,'DD-MON-YYYY')  \"MatchedDate\", LISTID \"ListId\", MATCHFIELD \"Matched Field\", SOURCEFIELD  \"Source Field\"" +
              		//  "  FROM TB_EXCEPTIONLISTSCANNINGRESULT A "+
              		    "  FROM TB_EXCEPTIONLISTSCANNINGRESLT1 A "+
       	  		        " WHERE RANK >= "+filter1+" ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND MATCHDATE >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND MATCHDATE < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
          }
          else if(reportId.equals("mr6"))
          {
       	  queryString = "SELECT ROWNUM AS \"SerialNo\", A.CUSTOMERID \"CustomerId\", A.CUSTOMERNAME \"CustomerName\", A.CUSTOMERTYPE \"CustomerType\", A.BRANCHCODE \"BranchCode\", "+
       	  				"       CASE WHEN A.RISKRATING ='1' THEN 'LOW' WHEN A.RISKRATING ='2' THEN 'MEDIUM' WHEN A.RISKRATING ='3' THEN 'HIGH' ELSE 'LOW' END  \"Customer RiskRating\" , "+
       	  				"       CASE WHEN B.RISKRATING ='1' THEN 'LOW' WHEN B.RISKRATING ='2' THEN 'MEDIUM' WHEN B.RISKRATING ='3' THEN 'HIGH' ELSE 'LOW' END  \"Account RiskRating\" , "+
       	                "       TO_CHAR(A.CREATEDDATETIME,'DD-MON-YYYY') \"CreatedDate\", A.INTRODUCERCUSTOMERID \"Introducer CustomerId\", A.INTRODUCERNAME \"IntroducerName\", "+
       	                "       TO_CHAR(A.DATEOFBIRTH,'DD-MON-YYYY') \"DateOfBirth\", B.PRODUCTCODE \"ProductCode\""+
       	                "  FROM TB_CUSTOMERMASTER A , TB_ACCOUNTSMASTER B "+
              			" WHERE A.CUSTOMERID = B.CUSTOMERID ";

   		  if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.CREATEDDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.CREATEDDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && !filter1.equals("A")) 
   			  queryString = queryString + " AND A.RISKRATING = '"+filter1+"' "; 
          }
          else if(reportId.equals("mr9"))
          {
       	  queryString = " SELECT CUSTOMERID \"CustomerId\", CUSTOMERNAME \"CustomerName\", DEDUPCOLUMNNAME \"Duplicate Column\", DEDUPCOLUMNVALUE \"Duplicate Value\", "+
       	                "        COUNTERCUSTOMERID \"Counter CustomerId\", COUNTERCUSTOMERNAME  \"Counter CustomerName\" "+
       	                "   FROM TB_DEDUPCUSTOMER "+
       	                "  WHERE 1 = 1 ";
       	  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && !filter1.equals("A")) 
 			  queryString = queryString + " AND DEDUPCOLUMNNAME = '"+filter1+"' ";
       	  queryString = queryString + "  ORDER BY CUSTOMERID, DEDUPCOLUMNNAME";
          }
          else if(reportId.equals("mr12"))
          {
       	  queryString = " SELECT A.PARTYID \"PartyId\", A.CUSTOMERID \"CustomerId\", B.CUSTOMERNAME \"CustomerName\", "+
       	                "        A.COUNTERCUSTOMERID \"Counter CustomerId\", C.CUSTOMERNAME \"Counter CustomerName\", "+
       	                "        A.COMMENTS \"Comments\", A.UPDATEDBY \"UpdatedBy\", TO_CHAR(A.UPDATETIMESTAMP,'DD MON YYYY HH24:MI') \"UpdatedDate\" "+
       	                "   FROM TB_PARTYLISTIDS A "+
       	                "   LEFT OUTER JOIN TB_CUSTOMERMASTER B ON A.CUSTOMERID = B.CUSTOMERID "+
       	                "   LEFT OUTER JOIN TB_CUSTOMERMASTER C ON A.COUNTERCUSTOMERID = C.CUSTOMERID "+
       	                "  WHERE 1 = 1 ";
       	  if(filter1 != null && !filter1.equals("") && !filter1.equals("null")) 
 			  queryString = queryString + " AND (A.CUSTOMERID = '"+filter1+"' OR A.COUNTERCUSTOMERID = '"+filter1+"')";
       	  queryString = queryString + "  ORDER BY A.PARTYID ";
       	  }
          else if(reportId.equals("mr10"))
          {
          queryString = " SELECT ACCOUNTNO \"AccountNo\", CUSTOMERID \"CustomerId\", CUSTOMERNAME \"CustomerName\", "+
	       				"        COUNTERACCOUNTNO \"Counter AccountNo\", COUNTERPARTYID \"Counter PartyId\", COUNTERPARTYNAME \"Counter PartyName\", "+
	    				"        SUM(AMOUNT) \"Total Amount\", "+
	    				"        COUNT(*) \"Total Count\", "+
	    				"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT ELSE 0 END) \"Credit Amount\", "+
	    				"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 1 ELSE 0 END) \"Credit Count\", "+
	    				"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT ELSE 0 END) \"Debit Amount\", "+
	    				"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN 1 ELSE 0 END) \"Debit Count\", "+
	    				"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' THEN AMOUNT ELSE 0 END) \"Cash Amount\", "+
	    				"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' THEN 1 ELSE 0 END) \"Cash Count\", "+
	    				"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' THEN AMOUNT ELSE 0 END) \"NonCash Amount\", "+
	    				"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' THEN 1 ELSE 0 END) \"NonCash Count\" "+
	    				"   FROM TB_TRANSACTIONS A WHERE 1 = 1 ";
          if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND A.TRANSACTIONDATETIME < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(filter1 != null && !filter1.equals("") && !filter1.equals("null") && !filter1.equals("A")) 
   			  queryString = queryString + " AND A.AMOUNT >= "+filter1+" ";
   		  queryString = 	queryString+ " AND TRIM(COUNTERACCOUNTNO) IS NOT NULL ";
          queryString = 	queryString+ " GROUP BY  ACCOUNTNO, CUSTOMERID, CUSTOMERNAME, "+
										 " COUNTERACCOUNTNO, COUNTERPARTYID, COUNTERPARTYNAME ";
          }
          else if(reportId.equals("mr11"))
          {
          queryString = " SELECT A.ACCOUNTNO \"AccountNo\", CUSTOMERID \"CustomerId\", CUSTOMERNAME \"Customer Name\", "+
                        "        BRANCHCODE \"BranchCode\", PRODUCTCODE \"ProductCode\", "+
                        "        TO_CHAR(ACCOUNTOPENEDDATE,'DD-MON-YYYY') \"Account OpenedDate\", "+
		                "        NOOFALERTSGENERATED \"Alert Count\", TOTALTRANSACTEDAMOUNT \"Total Amount\", TOTALTRANSACTEDCOUNT \"Total Count\", "+
		                "        TOTALDEBITAMOUNT \"Debit Amount\", TOTALDEBITCOUNT \"Debit Count\", TOTALCREDITAMOUNT \"Credit Amount\", TOTALCREDITCOUNT \"Credit Count\", "+ 
                        "        TOTALCASHDEBITAMOUNT \"Debit Cash Amount\", TOTALCASHDEBITCOUNT \"Debit Cash Count\", "+
                        "        TOTALNONCASHDEBITAMOUNT \"Debit NonCash Amount\", TOTALNONCASHDEBITCOUNT \"Debit NonCash Count\",  "+
		       			" 		 TOTALCASHCREDITAMOUNT \"Credit Cash Amount\", TOTALCASHCREDITCOUNT \"Credit Cash Count\", "+
		       			"        TOTALNONCASHCREDITAMOUNT \"Credit NonCash Amount\", TOTALNONCASHCREDITCOUNT \"Credit NonCash Count\" "+
        	  			" 	FROM TB_ACCOUNTSMASTER A "+
        	  			"   LEFT OUTER JOIN (SELECT ACCOUNTNO, COUNT(*) NOOFALERTSGENERATED FROM TB_ALERTSGENERATED GROUP BY ACCOUNTNO) B ON A.ACCOUNTNO = B.ACCOUNTNO "+
        	  			"   LEFT OUTER JOIN ( "+
        	  			" SELECT ACCOUNTNO, SUM(AMOUNT) TOTALTRANSACTEDAMOUNT, COUNT(*) TOTALTRANSACTEDCOUNT, "+ 
		       			"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT ELSE 0 END) TOTALDEBITAMOUNT, "+
  						"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN 1 ELSE 0 END) TOTALDEBITCOUNT, "+
  						"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT ELSE 0 END) TOTALCREDITAMOUNT, "+
  						"        SUM(CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 1 ELSE 0 END) TOTALCREDITCOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT ELSE 0 END) TOTALCASHDEBITAMOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'W' THEN 1 ELSE 0 END) TOTALCASHDEBITCOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT ELSE 0 END) TOTALNONCASHDEBITAMOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'W' THEN 1 ELSE 0 END) TOTALNONCASHDEBITCOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT ELSE 0 END) TOTALCASHCREDITAMOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'D' THEN 1 ELSE 0 END) TOTALCASHCREDITCOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT ELSE 0 END) TOTALNONCASHCREDITAMOUNT, "+
  						"        SUM(CASE WHEN TRANSACTIONTYPE NOT LIKE 'C%' AND DEPOSITORWITHDRAWAL = 'D' THEN 1 ELSE 0 END) TOTALNONCASHCREDITCOUNT "+
  						"   FROM TB_TRANSACTIONS GROUP BY  ACCOUNTNO ) C ON A.ACCOUNTNO = C.ACCOUNTNO ";
          queryString = queryString + " WHERE 1 = 1 ";
          if(startDate != null && !startDate.equals("") && !startDate.equals("null")) 
   			  queryString = queryString + " AND ACCOUNTOPENEDDATE >= TO_TIMESTAMP('"+startDate+"','MM/DD/YYYY') "; 
   		  if(endDate != null && !endDate .equals("") && !endDate .equals("null")) 
   			  queryString = queryString + " AND ACCOUNTOPENEDDATE < TO_TIMESTAMP('"+endDate+"','MM/DD/YYYY') + 1 "; 
   		  if(amount != null && !amount.equals("")) 
 			  queryString = queryString + " AND C.TOTALTRANSACTEDAMOUNT >= "+amount+" ";
		  }
          else if(reportId.equals("KYCMissingReport"))
          {
    	  queryString = " SELECT ROWPOSITION, CASE ROWPOS WHEN 1 THEN CUSTOMERID ELSE ' ' END AS CUSTOMERID , "+
    	  				"        CASE ROWPOS WHEN 1 THEN CUSTOMERNAME ELSE ' ' END AS CUSTOMERNAME, MISSINGMANDATORYFIELD, "+
    	  				"        CASE ROWPOS WHEN 1 THEN ACCOUNTNO  ELSE ' ' END AS ACCOUNTNO, COMPLIANCESCORE, "+
    	  				"        CASE ROWPOS WHEN 1 THEN BRANCHCODE ELSE ' ' END AS BRANCHCODE, "+
    	  				"        CASE ROWPOS WHEN 1 THEN TOTALSCORE ELSE ' ' END AS TOTALSCORE "+
    	  				"   FROM ( "+
    	  				"SELECT ROWNUM AS ROWPOSITION, A.* FROM (SELECT CUSTOMERID, CUSTOMERNAME, MISSINGMANDATORYFIELD, "+
    	  				"       ACCOUNTNO, COMPLIANCESCORE, BRANCHCODE, "+
    	  				"       ''||SUM(COMPLIANCESCORE) OVER(PARTITION BY CUSTOMERID,ACCOUNTNO) TOTALSCORE, "+
    	  				"       ROW_NUMBER() OVER(PARTITION BY CUSTOMERID,ACCOUNTNO ORDER BY ACCOUNTNO,MISSINGMANDATORYFIELD ) ROWPOS "+ 
    	  				"  FROM TB_MISSINGMANDATORYFIELDS A ";
    	  queryString = queryString + " ORDER BY CUSTOMERID, ACCOUNTNO ASC ) A ) A "; 
   		  }
          else if(reportId.equals("AGEINGREPORT"))
          {
        	  int alertResolutionDays = Integer.parseInt(filter1);
        	  int caseResolutionDays = Integer.parseInt(filter2);
        	  if(amount.equals("4"))
        	  {
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT "+ 
        	  	          "       A.CASENO, A.CUSTOMERID, A.CUSTOMERNAME, A.ACCOUNTNO, A.BRANCHCODE, A.CASEPRIORITY, "+
        	  		      "       TO_CHAR(A.STARTDATE,'DD/MM/YYYY') ASSIGNEDDATE, "+
        	  	          "       TO_CHAR(A.STARTDATE+"+alertResolutionDays+",'DD/MM/YYYY') DUEDATE , "+
        	  	          "       (TRUNC(SYSDATE) - TRUNC(A.STARTDATE)) AGEDFOR "+
        	  			  "	 FROM TB_CASEWORKFLOWDETAILS A "+
        	                "	WHERE USERCODE = '"+endDate+"' "+
        	                "   AND CASESTATUS = '1' "+
        	  			  "   AND (TRUNC(SYSDATE) - TRUNC(A.STARTDATE)) >= "+startDate+" ";
        	  queryString = queryString + " ) A ORDER BY AGEDFOR DESC) A ";
        	  }
        	  else         	  
        	  if(amount.equals("3"))
        	  {
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT A.ALERTNO, A.ALERTMESSAGE ALERTMESSAGE, "+
        	                "       A.ACCOUNTNO, A.CUSTOMERID, A.CUSTOMERNAME, A.BRANCHCODE, A.BRANCHNAME, A.AMOUNT, "+ 
        	  	            "       TO_CHAR(A.ALERTDATE,'MM/DD/YYYY') ASSIGNEDDATE , "+
        	  	            "       TO_CHAR(A.ALERTDATE+"+alertResolutionDays+",'MM/DD/YYYY') DUEDATE , "+
        	  	            "       (TRUNC(SYSDATE) - TRUNC(A.ALERTDATE)) AGEDFOR , "+
        	  	            "       A.ALERTCODE ALERTCODE "+
        	  			    "  FROM TB_ALERTSGENERATED A "+
        	                "  LEFT OUTER JOIN TB_CASEWORKFLOWDETAILS B ON B.ALERTNO = A.ALERTNO "+
        	  			    " WHERE (B.CASESTATUS = '1' OR TRIM(B.ALERTNO) IS NULL) " +
        	  			    "   AND (TRUNC(SYSDATE) - TRUNC(A.ALERTDATE)) >= "+startDate+"	  ";
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT "+ 
				            "       A.CASENO, A.CUSTOMERID, A.CUSTOMERNAME, A.ACCOUNTNO, A.BRANCHCODE, A.CASEPRIORITY, "+
					        "       TO_CHAR(A.USERTIMESTAMP,'DD/MM/YYYY') ASSIGNEDDATE, "+
				            "       TO_CHAR(A.USERTIMESTAMP+"+caseResolutionDays+",'DD/MM/YYYY') DUEDATE , "+
				            "       (TRUNC(SYSDATE) - TRUNC(A.USERTIMESTAMP)) AGEDFOR "+
						    "	 FROM TB_CASEWORKFLOWDETAILS A "+
			                "	WHERE 1 = 1 "+
				            //"   AND USERCODE = '"+endDate+"' "+
			                "   AND CASESTATUS = '3' "+
						    "   AND (TRUNC(SYSDATE) - TRUNC(A.USERTIMESTAMP)) >= "+startDate+"	  ";
        	  queryString = queryString + " ) A ORDER BY AGEDFOR DESC) A ";
        	  }
        	  else if(amount.equals("2"))
        	  {
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT A.ALERTNO, A.ALERTMESSAGE ALERTMESSAGE, "+
        	                "       A.ACCOUNTNO, A.CUSTOMERID, A.CUSTOMERNAME, A.BRANCHCODE, A.BRANCHNAME, A.AMOUNT, "+ 
        	  	            "       TO_CHAR(B.AMLTIMESTAMP,'MM/DD/YYYY') ASSIGNEDDATE , "+
        	  	            "       TO_CHAR(B.AMLTIMESTAMP+"+caseResolutionDays+",'MM/DD/YYYY') DUEDATE , "+
        	  	            "       (TRUNC(SYSDATE) - TRUNC(B.AMLTIMESTAMP)) AGEDFOR , "+
        	  	            "       A.ALERTCODE ALERTCODE "+
        	  			    "  FROM TB_ALERTSGENERATED A "+
        	                " INNER JOIN TB_CASEWORKFLOWDETAILS B ON B.ALERTNO = A.ALERTNO "+
        	  			    " WHERE B.CASESTATUS = '3' " +
        	  			    "   AND (TRUNC(SYSDATE) - TRUNC(B.AMLTIMESTAMP)) >= "+startDate+"	  ";
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT "+ 
				            "       A.CASENO, A.CUSTOMERID, A.CUSTOMERNAME, A.ACCOUNTNO, A.BRANCHCODE, A.CASEPRIORITY, "+
					        "       TO_CHAR(A.AMLUSERTIMESTAMP,'DD/MM/YYYY') ASSIGNEDDATE, "+
				            "       TO_CHAR(A.AMLUSERTIMESTAMP+"+caseResolutionDays+",'DD/MM/YYYY') DUEDATE , "+
				            "       (TRUNC(SYSDATE) - TRUNC(A.AMLUSERTIMESTAMP)) AGEDFOR "+
						    "	 FROM TB_CASEWORKFLOWDETAILS A "+
			                "	WHERE 1 = 1 "+
				            //"   AND USERCODE = '"+endDate+"' "+
			                "   AND CASESTATUS = '5' "+
						    "   AND (TRUNC(SYSDATE) - TRUNC(B.AMLTIMESTAMP)) >= "+startDate+"	  ";

        	  queryString = queryString + " ) A ORDER BY AGEDFOR DESC) A ";
        	  }
        	  else if(amount.equals("1"))
        	  {
        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT A.ALERTNO, A.ALERTMESSAGE ALERTMESSAGE, "+
        	                "       A.ACCOUNTNO, A.CUSTOMERID, A.CUSTOMERNAME, A.BRANCHCODE, A.BRANCHNAME, A.AMOUNT, "+ 
        	  	            "       TO_CHAR(B.AMLOTIMESTAMP,'MM/DD/YYYY') ASSIGNEDDATE , "+
        	  	            "       TO_CHAR(B.AMLOTIMESTAMP+"+caseResolutionDays+",'MM/DD/YYYY') DUEDATE , "+
        	  	            "       (TRUNC(SYSDATE) - TRUNC(B.AMLOTIMESTAMP)) AGEDFOR , "+
        	  	            "       A.ALERTCODE ALERTCODE  "+
        	  			    "  FROM TB_ALERTSGENERATED A "+
        	                " INNER JOIN TB_CASEWORKFLOWDETAILS B ON B.ALERTNO = A.ALERTNO "+
        	  			    " WHERE B.CASESTATUS = '5' " +
        	  			    "   AND (TRUNC(SYSDATE) - TRUNC(B.AMLOTIMESTAMP)) >= "+startDate+"	  ";

        	  queryString = "SELECT ROWNUM AS ROWPOSITION,A.* FROM (SELECT A.* FROM (SELECT "+ 
				            "       A.CASENO, A.CUSTOMERID, A.CUSTOMERNAME, A.ACCOUNTNO, A.BRANCHCODE, A.CASEPRIORITY, "+
					        "       TO_CHAR(A.AMLOTIMESTAMP,'DD/MM/YYYY') ASSIGNEDDATE, "+
				            "       TO_CHAR(A.AMLOTIMESTAMP+"+caseResolutionDays+",'DD/MM/YYYY') DUEDATE , "+
				            "       (TRUNC(SYSDATE) - TRUNC(A.AMLOTIMESTAMP)) AGEDFOR "+
						    "	 FROM TB_CASEWORKFLOWDETAILS A "+
			                "	WHERE 1 = 1 "+
				            //"   AND USERCODE = '"+endDate+"' "+
			                "   AND CASESTATUS = '7' "+
						    "   AND (TRUNC(SYSDATE) - TRUNC(B.AMLOTIMESTAMP)) >= "+startDate+"	  ";

        	  queryString = queryString + " ) A ORDER BY AGEDFOR DESC) A ";
        	  }
   		  }
          else if(reportId.equals("SLCTR"))
          {
    	  callableStatement = connection.prepareCall("{CALL STP_SLCTR_REPORT(?,?,?,?,?)}");	  
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  //callableStatement.setString(5, filter2);
    	  callableStatement.registerOutParameter(5, -10);
    	  callableStatement.execute();
          }
          else if(reportId.equals("PHPCTR"))
          {
    	  callableStatement = connection.prepareCall("{CALL STP_PHPCTR_REPORT(?,?,?,?,?)}");	  
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  //callableStatement.setString(5, filter2);
    	  callableStatement.registerOutParameter(5, -10);
    	  callableStatement.execute();
          }
          else if(reportId.equals("FATCA"))
          {
    	  callableStatement = connection.prepareCall("{CALL STP_FATCA_REPORT(?,?,?,?,?)}");	  
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  callableStatement.registerOutParameter(5, -10);
    	  callableStatement.execute();
          }
          else if(reportId.equals("MOSTACTIVE"))
          {
    	  callableStatement = connection.prepareCall("{CALL PROC_MOSTACTIVEACCOUNT(?,?,?,?,?,?,?,?)}");
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  callableStatement.setString(5, filter2);
    	  callableStatement.setString(6, filter3);
    	  callableStatement.setString(7, "AMLUser");
    	  callableStatement.registerOutParameter(8, -10);
    	  callableStatement.execute();
          }
          else if(reportId.equals("USERACCESSLOG"))
          {
    	  callableStatement = connection.prepareCall("{CALL PROC_USERACCESSLOG(?,?,?,?,?)}");
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  callableStatement.registerOutParameter(5, -10);
    	  callableStatement.execute();
          }
          else if(reportId.equals("AUDITLOG"))
          {
    	  callableStatement = connection.prepareCall("{CALL PROC_AUDITLOG(?,?,?,?,?)}");
    	  callableStatement.setString(1, startDate);
    	  callableStatement.setString(2, endDate);
    	  callableStatement.setString(3, amount);
    	  callableStatement.setString(4, filter1);
    	  callableStatement.registerOutParameter(5, -10);
    	  callableStatement.execute();
          }
          
		  pstatement = connection.prepareStatement(queryString);
          if(reportId.equals("SLCTR"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(5);
          }
          else if(reportId.equals("PHPCTR"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(5);
          }
          else if(reportId.equals("FATCA"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(5);
          }
          else if(reportId.equals("MOSTACTIVE"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(8);
          }
          else if(reportId.equals("USERACCESSLOG"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(5);
          }else if(reportId.equals("AUDITLOG"))
          {
        	  resultSet = (ResultSet)callableStatement.getObject(5);
          }else
          {
		  resultSet = pstatement.executeQuery();
          }

		  ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
	      String[] l_Headers=new String[resultSetMetaData.getColumnCount()];
		  for(int i=l_Headers.length;i>=1;i--)
		    l_Headers[i-1]=resultSetMetaData.getColumnName(i);
				  						 	 	
		  while(resultSet.next())
		  {	
			HashMap<String, String> l_DTO=new HashMap<String, String>();
			for(int i=l_Headers.length;i>=1;i--)
			  l_DTO.put(l_Headers[i-1],resultSet.getString(i));
			arrayList.add(l_DTO);
		  }
		  reportData.put("Header", l_Headers);
		  reportData.put("ReportData", arrayList);
    	}
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData is "+e.toString()+" for queryString : "+queryString);
    	System.out.println("The exception in ReportData is "+e.toString()+" for queryString : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, callableStatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block is "+e.toString());
		 System.out.println("Exception in finally exception block is "+e.toString());
		 e.printStackTrace();
		}
    	}
    	return reportData;
    }

    public HashMap<String,Object> reportData(String userName, String builtCondition, String l_strReportID, String l_strNoOfParameters)
    {
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		ResultSet resultSet = null;
		Connection connection = getConnection();
		//CallableStatement callableStatement = null;
		PreparedStatement pstatement = null;
        HashMap<String,Object> reportData = new HashMap<String,Object>();
        String queryString = "";
        String columnString = "";
        String reportName = "";
        String reportHeader = "";
        String reportFooter = "";
		try
    	{  
		  queryString = " SELECT REPORTNAME, REPORTHEADER, REPORTFOOTER "+
		  			    "   FROM TB_REPORTBUILDERDETAILS A "+
				        "  WHERE REPORTID = '"+l_strReportID+"' " ;
		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  reportName = resultSet.getString("REPORTNAME");
			  reportHeader = resultSet.getString("REPORTHEADER");
			  reportFooter = resultSet.getString("REPORTFOOTER");
		  }
		  
		  queryString = " SELECT COLUMNNAME, TABLE_NAME, TABLE_COLUMN_NAME, DEFAULTVALUE "+
          				"   FROM TB_REPORTBUILDERCOLUMNS A "+
          				"  WHERE REPORTID = '"+l_strReportID+"' ORDER BY COLUMNINDEX " ;
   		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  /*columnString = columnString+
			  " NVL("+resultSet.getString("TABLE_NAME")+"."+resultSet.getString("TABLE_COLUMN_NAME")+
			   ",'"+resultSet.getString("DEFAULTVALUE")+"') AS \"" +resultSet.getString("COLUMNNAME") + "\", " ;
			  */
			  columnString = columnString+
			  " "+resultSet.getString("TABLE_NAME")+"."+resultSet.getString("TABLE_COLUMN_NAME")+
			   " AS \"" +resultSet.getString("COLUMNNAME") + "\", " ;
		  }
		  columnString = columnString.substring(0, columnString.length()-2);
		  
	      queryString = "SELECT ROWNUM AS ROWPOSITION, TB_TRANSACTIONS.* "+
              			"  FROM TB_TRANSACTIONS, TB_ACCOUNTSMASTER, TB_CUSTOMERMASTER "+
              			" WHERE TB_TRANSACTIONS.ACCOUNTNO = TB_ACCOUNTSMASTER.ACCOUNTNO "+
              			"   AND TB_ACCOUNTSMASTER.CUSTOMERID = TB_CUSTOMERMASTER.CUSTOMERID "+
              			" "+builtCondition;
		  queryString = "SELECT ROWNUM AS ROWPOSITION, "+columnString+
						"  FROM TB_TRANSACTIONS, TB_ACCOUNTSMASTER, TB_CUSTOMERMASTER "+
						" WHERE TB_TRANSACTIONS.ACCOUNTNO = TB_ACCOUNTSMASTER.ACCOUNTNO "+
						"   AND TB_ACCOUNTSMASTER.CUSTOMERID = TB_CUSTOMERMASTER.CUSTOMERID "+
						" "+builtCondition;

		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
         
		  ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
	      String[] l_Headers=new String[resultSetMetaData.getColumnCount()];
		  for(int i=l_Headers.length;i>=1;i--)
		    l_Headers[i-1]=resultSetMetaData.getColumnName(i);
				  						 	 	
		  while(resultSet.next())
		  {	
			HashMap<String, String> l_DTO=new HashMap<String, String>();
			for(int i=l_Headers.length;i>=1;i--)
			  l_DTO.put(l_Headers[i-1],resultSet.getString(i));
			arrayList.add(l_DTO);
		  }
		  reportData.put("reportName", reportName);
		  reportData.put("reportHeader", reportHeader);
		  reportData.put("reportFooter", reportFooter);
		  
		  reportData.put("Header", l_Headers);
		  reportData.put("ReportData", arrayList);
    	}
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData for is "+e.toString()+" for builtCondition : "+queryString);
    	System.out.println("The exception in ReportData for is "+e.toString()+" for builtCondition : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, pstatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block is "+e.toString());
		 System.out.println("Exception in finally exception block is "+e.toString());
		 e.printStackTrace();
		}
    	}
    	return reportData;
    }

    public HashMap<String,Object> reportWidgetsMainData(String userName, String reportId)
    {
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		ResultSet resultSet = null;
		//CallableStatement callableStatement = null;
		Connection connection = getConnection();
		PreparedStatement pstatement = null;
        HashMap<String,Object> reportData = new HashMap<String,Object>();
        String reportName = "";
        String selectedTables = "";
        String joinConditions = "";
        String reportColumns = "";
        String params = "";
        String aggregateConditions = "";
        String reportHeader = "";
        String reportFooter = "";
        String queryString = "";
		try
    	{  
		  queryString = " SELECT REPORTNAME, REPORTHEADER, REPORTFOOTER "+
		  			    "   FROM TB_REPORTWIDGETDETAILS A "+
				        "  WHERE REPORTID = '"+reportId+"' " ;
		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  reportName = resultSet.getString("REPORTNAME");
			  reportHeader = resultSet.getString("REPORTHEADER");
			  reportFooter = resultSet.getString("REPORTFOOTER");
		  }
		  resultSet = null;
		  queryString = "SELECT REPORTNAME, SELECTEDTABLES, SETJOINS, REPORTCOLUMNS, PARAMS, AGGREGATECONDITIONS "+
  		  				"	 FROM TB_REPORTWIDGETDETAILS  A "+
  		  				" WHERE REPORTID = '"+reportId+"' "; 
		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while (resultSet.next()) 
		  {
		    reportName = resultSet.getString("REPORTNAME");
			selectedTables = resultSet.getString("SELECTEDTABLES");
			joinConditions = resultSet.getString("SETJOINS");
			reportColumns = resultSet.getString("REPORTCOLUMNS");
			params = resultSet.getString("PARAMS");
			aggregateConditions = resultSet.getString("AGGREGATECONDITIONS");
		   }
		  
		  aggregateConditions = (aggregateConditions == null ?"":aggregateConditions);
		  params = params.replace("PERCENTAGEVALUE","%");


		  ArrayList list = new ArrayList();
		  String[] l_TableColumnList = reportColumns.split(",");

		  String[] l_Headers = new String[l_TableColumnList.length];
		  int i,j;
		  for(i=0; i<l_TableColumnList.length; i++)
		  {
		  String strColumnName = l_TableColumnList[i];
		  strColumnName = strColumnName.substring(strColumnName.indexOf(".")+1,strColumnName.length()); 
		  if(strColumnName.indexOf("\"") > 0)
		  	strColumnName = strColumnName.substring(strColumnName.indexOf("\"")+1,strColumnName.length()-1); 
		  l_Headers[i]=strColumnName;
		  }

		  queryString = "SELECT "+reportColumns+" "+
  		  			    "  FROM "+selectedTables.substring(0, (selectedTables.length()-1))+"  "+
  		  			    " WHERE 1 = 1 "+
  		  			    " "+params+""+
  		  			    " "+aggregateConditions+"";

		  if(joinConditions != null && !joinConditions.equals("")){
		  queryString = "SELECT "+reportColumns+" "+
		  		  	    "  FROM "+joinConditions+"  "+
				        " WHERE 1 = 1 "+
		                " "+params+""+
		                " "+aggregateConditions+"";
		  }

   		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
         
		  while(resultSet.next())
		  {	
			HashMap<String, String> l_HMSearchResult=new HashMap<String, String>();
			String strColumnName = "";
			for(i=0; i<l_Headers.length; i++)
			{
			strColumnName = l_Headers[i];
			l_HMSearchResult.put(strColumnName,resultSet.getString(strColumnName));
			}
			arrayList.add(l_HMSearchResult);
		  }
		  reportData.put("reportName", reportName);
		  reportData.put("reportHeader", reportHeader);
		  reportData.put("reportFooter", reportFooter);
		  
		  reportData.put("Header", l_Headers);
		  reportData.put("ReportData", arrayList);
    	}
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData for is "+e.toString()+" for reportWidgets : "+queryString);
    	System.out.println("The exception in ReportData for is "+e.toString()+" for reportWidgets : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, pstatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block is "+e.toString());
		 System.out.println("Exception in finally exception block is "+e.toString());
		 e.printStackTrace();
		}
    	}
    	return reportData;
    }

    public HashMap<String,Object> reportWidgetsData(String userName, String selectedTables, String joinConditions, 
			String reportColumns, String params, String aggregateConditions)
    {
    	Connection connection = getConnection();
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		ResultSet resultSet = null;
		//CallableStatement callableStatement = null;
		PreparedStatement pstatement = null;
        HashMap<String,Object> reportData = new HashMap<String,Object>();
        String reportName = "New Report";
        //String reportHeader = "Quantum Data Engines Confidential";
        //String reportFooter = "Quantum Data Engines Confidential";
        String reportHeader = "THE SARASWAT CO-OP BANK LTD";
        String reportFooter = "THE SARASWAT CO-OP BANK LTD";
        //String reportHeader = "Polaris Financial Technology Limited";
        //String reportFooter = "Polaris Financial Technology Limited";
        String queryString = "";
		try
    	{  
		  /*	
		  queryString = " SELECT REPORTNAME, REPORTHEADER, REPORTFOOTER "+
		  			    "   FROM TB_REPORTWIDGETDETAILS A "+
				        "  WHERE REPORTID = '"+reportId+"' " ;
		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  reportName = resultSet.getString("REPORTNAME");
			  reportHeader = resultSet.getString("REPORTHEADER");
			  reportFooter = resultSet.getString("REPORTFOOTER");
		  }
		  resultSet = null;
		  
		  queryString = "SELECT REPORTNAME, SELECTEDTABLES, SETJOINS, REPORTCOLUMNS, PARAMS, AGGREGATECONDITIONS "+
  		  				"	 FROM TB_REPORTWIDGETDETAILS  A "+
  		  				" WHERE REPORTID = '"+reportId+"' "; 
		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
		  while (resultSet.next()) 
		  {
		    reportName = resultSet.getString("REPORTNAME");
			selectedTables = resultSet.getString("SELECTEDTABLES");
			joinConditions = resultSet.getString("SETJOINS");
			reportColumns = resultSet.getString("REPORTCOLUMNS");
			params = resultSet.getString("PARAMS");
			aggregateConditions = resultSet.getString("AGGREGATECONDITIONS");
		   }
		  */
		  aggregateConditions = (aggregateConditions == null ?"":aggregateConditions);
		  params = params.replace("PERCENTAGEVALUE","%");


		  ArrayList list = new ArrayList();
		  String[] l_TableColumnList = reportColumns.split(",");

		  String[] l_Headers = new String[l_TableColumnList.length];
		  int i,j;
		  for(i=0; i<l_TableColumnList.length; i++)
		  {
		  String strColumnName = l_TableColumnList[i];
		  strColumnName = strColumnName.substring(strColumnName.indexOf(".")+1,strColumnName.length()); 
		  if(strColumnName.indexOf("\"") > 0)
		  	strColumnName = strColumnName.substring(strColumnName.indexOf("\"")+1,strColumnName.length()-1); 
		  l_Headers[i]=strColumnName;
		  }

		  queryString = "SELECT "+reportColumns+" "+
  		  			    "  FROM "+selectedTables.substring(0, (selectedTables.length()-1))+"  "+
  		  			    " WHERE 1 = 1 "+
  		  			    " "+params+""+
  		  			    " "+aggregateConditions+"";

		  if(joinConditions != null && !joinConditions.equals("")){
		  queryString = "SELECT "+reportColumns+" "+
		  		  	    "  FROM "+joinConditions+"  "+
				        " WHERE 1 = 1 "+
		                " "+params+""+
		                " "+aggregateConditions+"";
		  }


   		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
         
		  while(resultSet.next())
		  {	
			HashMap<String, String> l_HMSearchResult=new HashMap<String, String>();
			String strColumnName = "";
			for(i=0; i<l_Headers.length; i++)
			{
			strColumnName = l_Headers[i];
			l_HMSearchResult.put(strColumnName,resultSet.getString(strColumnName));
			}
			arrayList.add(l_HMSearchResult);
		  }
		  reportData.put("reportName", reportName);
		  reportData.put("reportHeader", reportHeader);
		  reportData.put("reportFooter", reportFooter);
		  
		  reportData.put("Header", l_Headers);
		  reportData.put("ReportData", arrayList);
    	}
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData->reportWidgetsData for is "+e.toString()+" for reportWidgets : "+queryString);
    	System.out.println("The exception in ReportData->reportWidgetsData for is "+e.toString()+" for reportWidgets : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, pstatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block is "+e.toString());
		 System.out.println("Exception in finally exception block is "+e.toString());
		 e.printStackTrace();
		}
    	}
    	return reportData;
    }
    
    public String setReportRule(String username, String l_strReportID, String l_strReportCode,
			String l_strReportName, String l_strReportType, String l_strISEnabled, String builtCondition, String l_strAction, String l_strNoOfParameters, String l_strReportHeader, String l_strReportFooter) 
	{
    	Connection connection = getConnection();
		ResultSet resultSet = null;
		PreparedStatement pstatement = null;
        String queryString = "";
		try
    	{ 
		  if(l_strAction.equals("Create"))
		  {
		  queryString = "Select SEQ_REPORTID.NextVal AS ReportID From Dual ";
	      pstatement = connection.prepareStatement(queryString);
	      resultSet = pstatement.executeQuery();
	      while(resultSet.next())
	    	  l_strReportID = resultSet.getString("ReportID");
	          	  
	      queryString = "INSERT INTO TB_REPORTBUILDERDETAILS( "+
	                    " GROUPID, REPORTID, REPORTCODE, "+
	                    " REPORTNAME, ISENABLED, QUERY, NOOFPARAMETERS, REPORTHEADER, REPORTFOOTER, "+
	                    " CREATEDDATE, CREATEDBY, UPDATEDDATE, UPDATEDBY) " +
	                    " VALUES ( '"+l_strReportType.trim().toUpperCase()+"', '"+l_strReportID+"', '"+l_strReportCode+"', "+
	                    " '"+l_strReportName+"', '"+l_strISEnabled+"', '"+builtCondition+"', '"+l_strNoOfParameters+"', '"+l_strReportHeader+"', '"+l_strReportFooter+"', "+
              			" SYSTIMESTAMP, '"+username+"', SYSTIMESTAMP, '"+username+"' ) ";
		  }
		  else if(l_strAction.equals("Update"))
		  {
		  queryString = "UPDATE TB_REPORTBUILDERDETAILS SET "+
              " GROUPID = '"+l_strReportType.trim().toUpperCase()+"', REPORTCODE = '"+l_strReportCode+"', "+
              " REPORTNAME = '"+l_strReportName+"' , ISENABLED = '"+l_strISEnabled+"' , "+
              " QUERY = '"+builtCondition+"', NOOFPARAMETERS = '"+l_strNoOfParameters+"', "+
              " REPORTHEADER = '"+l_strReportHeader+"', REPORTFOOTER = '"+l_strReportFooter+"', "+
              " UPDATEDDATE = SYSTIMESTAMP, UPDATEDBY = '"+username+"' " +
              " WHERE REPORTID = '"+l_strReportID+"' ";
		  }
   		  pstatement = connection.prepareStatement(queryString);
		  pstatement.executeUpdate();
        }
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData for is "+e.toString()+" for setReportRule : "+queryString);
    	System.out.println("The exception in ReportData for is "+e.toString()+" for setReportRule : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    		closeResources(connection, pstatement, resultSet);
    	try
    	{
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block of setReportRule is "+e.toString());
		 System.out.println("Exception in finally exception block of setReportRule is "+e.toString());
		 e.printStackTrace();
		}
    	}
		return l_strReportID;
	}
	public HashMap<String,Object> fetchReportDetails(String username, String l_strReportID)
	{
		Connection connection = getConnection();
		ResultSet resultSet = null;
		PreparedStatement pstatement = null;
        String queryString = "";
        HashMap<String,Object> hashMap = new HashMap<String,Object>(); 
		try
    	{ 
		  queryString = "Select GROUPID, REPORTID, REPORTCODE, "+
	                    "       REPORTNAME, ISENABLED, QUERY, NOOFPARAMETERS, "+
	                    " 		CREATEDDATE, CREATEDBY, UPDATEDDATE, UPDATEDBY "+
	                    "  FROM TB_REPORTBUILDERDETAILS "+
	                    " WHERE REPORTID = '"+l_strReportID+"' ";
	      pstatement = connection.prepareStatement(queryString);
	      resultSet = pstatement.executeQuery();
	      while(resultSet.next())
	      {
	    	  hashMap.put("GROUPID", resultSet.getString("GROUPID"));
	    	  hashMap.put("REPORTID", resultSet.getString("REPORTID"));
	    	  hashMap.put("REPORTCODE", resultSet.getString("REPORTCODE"));
	    	  hashMap.put("REPORTNAME", resultSet.getString("REPORTNAME"));
	    	  hashMap.put("ISENABLED", resultSet.getString("ISENABLED"));
	    	  hashMap.put("QUERY", resultSet.getString("QUERY"));
	    	  hashMap.put("NOOFPARAMETERS", resultSet.getString("NOOFPARAMETERS"));
	      }   	  
        }
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData for is "+e.toString()+" for setReportRule : "+queryString);
    	System.out.println("The exception in ReportData for is "+e.toString()+" for setReportRule : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, pstatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block of setReportRule is "+e.toString());
		 System.out.println("Exception in finally exception block of setReportRule is "+e.toString());
		 e.printStackTrace();
		}
    	}
		return hashMap;
	}
	
	public String[][] getReportColumns(String username, String l_strReportID, String builtCondition) 
	{
		Connection connection = getConnection();
		ResultSet resultSet = null;
		PreparedStatement pstatement = null;
        String queryString = "";
        String l_info[][] = null;
        int size = 0;
        int size1 = 0;
        int size2 = 0;
        int size3 = 0;
        try
    	{ 
          if(builtCondition.indexOf("TB_TRANSACTIONS") > 0 )
          {
        	  queryString = "SELECT COUNT(*) COUNTVAL "+
        	  				"  FROM USER_TAB_COLUMNS "+
                            " WHERE TABLE_NAME = 'TB_TRANSACTIONS' ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  while(resultSet.next())
        		  size1 = resultSet.getInt("COUNTVAL");
    	       size = size+size1;
          }
          if(builtCondition.indexOf("TB_ACCOUNTSMASTER") > 0 )
          {
        	  queryString = "SELECT COUNT(*) COUNTVAL "+
        	  				"  FROM USER_TAB_COLUMNS "+
                            " WHERE TABLE_NAME = 'TB_ACCOUNTSMASTER' ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  while(resultSet.next())
        		  size2 = resultSet.getInt("COUNTVAL");
        	  size = size+size2;
          }
          if(builtCondition.indexOf("TB_CUSTOMERMASTER") > 0 )
          {
        	  queryString = "SELECT COUNT(*) COUNTVAL "+
        	  				"  FROM USER_TAB_COLUMNS "+
                            " WHERE TABLE_NAME = 'TB_CUSTOMERMASTER' ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  while(resultSet.next())
        		  size3 = resultSet.getInt("COUNTVAL");
        	  size = size+size3;
          }
          l_info = new String[4][size];
          if(builtCondition.indexOf("TB_TRANSACTIONS") > 0 )
          {
        	  queryString = "SELECT 'TB_TRANSACTIONS.'||COLUMN_NAME COLUMNNAME, COLUMN_ID "+
              				"  FROM USER_TAB_COLUMNS "+
            				" WHERE TABLE_NAME = 'TB_TRANSACTIONS' ORDER BY COLUMN_ID ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  for(int j = 0; resultSet.next(); j++)
              {
    	    	  l_info[0][j] = resultSet.getString("COLUMN_NAME");
                  l_info[1][j] = resultSet.getString("COLUMN_NAME");
                  l_info[2][j] = "Y";
                  l_info[3][j] = resultSet.getString("COLUMN_ID");
    	      } 
          }
          if(builtCondition.indexOf("TB_ACCOUNTSMASTER") > 0 )
          {
        	  queryString = "SELECT 'TB_ACCOUNTSMASTER.'||COLUMN_NAME COLUMNNAME, COLUMN_ID "+
              				"  FROM USER_TAB_COLUMNS "+
            				" WHERE TABLE_NAME = 'TB_ACCOUNTSMASTER' ORDER BY COLUMN_ID ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  for(int j = 0; resultSet.next(); j++)
              {
    	    	  l_info[0][j] = resultSet.getString("COLUMN_NAME");
                  l_info[1][j] = resultSet.getString("COLUMN_NAME");
                  l_info[2][j] = "Y";
                  l_info[3][j] = size1+resultSet.getString("COLUMN_ID");
    	      } 
          }
          if(builtCondition.indexOf("TB_CUSTOMERMASTER") > 0 )
          {
        	  queryString = "SELECT 'TB_CUSTOMERMASTER.'||COLUMN_NAME COLUMNNAME, COLUMN_ID "+
              				"  FROM USER_TAB_COLUMNS "+
            				" WHERE TABLE_NAME = 'TB_CUSTOMERMASTER' ORDER BY COLUMN_ID ";
        	  pstatement = connection.prepareStatement(queryString);
        	  resultSet = pstatement.executeQuery();
        	  for(int j = 0; resultSet.next(); j++)
              {
    	    	  l_info[0][j] = resultSet.getString("COLUMN_NAME");
                  l_info[1][j] = resultSet.getString("COLUMN_NAME");
                  l_info[2][j] = "Y";
                  l_info[3][j] = size1+size2+resultSet.getString("COLUMN_ID");
    	      } 
          }
        }
    	catch(Exception e)
    	{
    	log.error("The exception in ReportData for is "+e.toString()+" for getReportColumns : "+queryString);
    	System.out.println("The exception in ReportData for is "+e.toString()+" for getReportColumns : "+queryString);	
    	e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		closeResources(connection, pstatement, resultSet);
		  //callableStatement.close();
		  //resultSet.close();
 		}
    	catch(Exception e)
    	{
    	 log.error("Exception in finally exception block of getReportColumns is "+e.toString());
		 System.out.println("Exception in finally exception block of getReportColumns is "+e.toString());
		 e.printStackTrace();
		}
    	}
		return l_info;
	}
	
	public String getRCGraph(String userCode, String fromDate, String customerId, String amount)
	{
		Connection connection = getConnection();
        ResultSet resultset = null;
        ResultSet resultset1 = null;
        CallableStatement callableStatement = null;
        StringBuilder sb = new StringBuilder();
        try
        {
            callableStatement = connection.prepareCall("{CALL STP_RCGRAPHDATA(?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, userCode);
            callableStatement.setString(2, fromDate);
            callableStatement.setString(3, customerId);
            callableStatement.setString(4, amount);
            callableStatement.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.VARCHAR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.VARCHAR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultset = (ResultSet)callableStatement.getObject(5);
            sb.append("{\"Fields\":[");
            for(; resultset.next(); sb.append("\"},"))
            {
                sb.append("{\"AggregateAmount\":\"").append(resultset.getString("AggregateAmount"));
                sb.append("\",\"CustomerName\":\"").append(resultset.getString("CustomerName"));
                sb.append("\",\"InstrumentCode\":\"").append(resultset.getString("InstrumentCode"));
                sb.append("\",\"InstrumentName\":\"").append(resultset.getString("InstrumentName"));
            }
            sb.append("],");
            sb.append((new StringBuilder("\"DebitTurnover\":[{\"value\":\"")).append(callableStatement.getString(6)).append("\"}],").toString());
            sb.append((new StringBuilder("\"CreditTurnover\":[{\"value\":\"")).append(callableStatement.getString(7)).append("\"}],").toString());
            resultset1 = (ResultSet)callableStatement.getObject(8);
            sb.append("\"TableData\":[");
            for(; resultset1.next(); sb.append("\"},"))
            {
            	sb.append("{\"ROWPOSITION\":\"").append(resultset1.getString("ROWPOSITION"));
                sb.append("\",\"TRANSACTIONNO\":\"").append(resultset1.getString("TRANSACTIONNO"));
                sb.append("\",\"TRANSACTIONTYPE\":\"").append(resultset1.getString("TRANSACTIONTYPE"));
                sb.append("\",\"CUSTOMERID\":\"").append(resultset1.getString("CUSTOMERID"));
                sb.append("\",\"INSTRUMENTCODE\":\"").append(resultset1.getString("INSTRUMENTCODE"));
                sb.append("\",\"INSTRUMENTNO\":\"").append(resultset1.getString("INSTRUMENTNO"));
                sb.append("\",\"INSTRUMENTDATE\":\"").append(resultset1.getString("INSTRUMENTDATE"));
                sb.append("\",\"ACCOUNTNO\":\"").append(resultset1.getString("ACCOUNTNO"));
                sb.append("\",\"BRANCHCODE\":\"").append(resultset1.getString("BRANCHCODE"));
                sb.append("\",\"AMOUNT\":\"").append(resultset1.getString("AMOUNT"));
                sb.append("\",\"DEBITCREDIT\":\"").append(resultset1.getString("DEBITCREDIT"));
                sb.append("\",\"TRANSACTIONDATE\":\"").append(resultset1.getString("TRANSACTIONDATE"));
                sb.append("\",\"CURRENCYCODE\":\"").append(resultset1.getString("CURRENCYCODE"));
                sb.append("\",\"CUSTOMERNAME\":\"").append(resultset1.getString("CUSTOMERNAME"));
                sb.append("\",\"PRODUCTCODE\":\"").append(resultset1.getString("PRODUCTCODE"));
                sb.append("\",\"CUSTOMERTYPE\":\"").append(resultset1.getString("CUSTOMERTYPE"));
            }
            sb.append("]}");
        }
        catch(Exception e)
        {
        	log.error(" Error In ReportDAOImpl -> getRCGraph : "+e.toString());
            System.out.println(" Error In ReportDAOImpl -> getRCGraph : "+e.toString());
            e.printStackTrace();
        }finally{
        	closeResources(connection, callableStatement, resultset);
        }
        return sb.toString();
	}
	
	public String getABMGraph(String userCode, String fromDate, String accountNo) 
	{
        return "";
	}

	public String getCPRGraph(String userCode, String fromDate, String toDate, String accountNo1, String accountNo2, String instrumentCode, String action) 
	{
		Connection connection = getConnection();
        ResultSet resultset = null;
        CallableStatement callableStatement = null;
        StringBuilder sb = new StringBuilder();
        try
        {
            callableStatement = connection.prepareCall("{CALL STP_CPRGRAPH(?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, fromDate);
            callableStatement.setString(2, toDate);
            callableStatement.setString(3, accountNo1);
            callableStatement.setString(4, accountNo2);
            callableStatement.setString(5, instrumentCode);
            callableStatement.setString(6, action);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.VARCHAR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.VARCHAR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.VARCHAR);
            callableStatement.execute();
            resultset = (ResultSet)callableStatement.getObject(7);
            ResultSetMetaData m_metadata = resultset.getMetaData();
            int l_intColumnCount = m_metadata.getColumnCount();
            sb.append("{\"Fields\":[");
            for(; resultset.next(); sb.append("\"},"))
            {
                for(int i = 0; i < l_intColumnCount; i++)
                    if(i == 0)
                        sb.append((new StringBuilder("{\"")).append(m_metadata.getColumnName(i + 1)).append("\":\"").toString()).append(resultset.getString(m_metadata.getColumnName(i + 1)));
                    else
                        sb.append((new StringBuilder("\",\"")).append(m_metadata.getColumnName(i + 1)).append("\":\"").toString()).append(resultset.getString(m_metadata.getColumnName(i + 1)));

            }
            sb.append("],");
            sb.append((new StringBuilder("\"ReportHeading\":[{\"value\":\"")).append(callableStatement.getString(8)).append("\"}],").toString());
            sb.append((new StringBuilder("\"XAxis\":[{\"value\":\"")).append(callableStatement.getString(9)).append("\"}],").toString());
            sb.append((new StringBuilder("\"YAxis\":[{\"value\":\"")).append(callableStatement.getString(10)).append("\"}]}").toString());
        }
        catch(Exception e)
        {
        	log.error(" Error In ReportDAOImpl -> getCPRGraph : "+e.toString());
        	System.out.println(" Error In ReportDAOImpl -> getCPRGraph : "+e.toString());
        	e.printStackTrace();
        }finally{
        	closeResources(connection, callableStatement, resultset);
        }
        return sb.toString();
	}
	
	public void closeResources(Connection connection, Statement statement, ResultSet resultSet){
		try{
			if(connection != null){
				connection.close();
			}
			if(statement != null){
				statement.close();
			}
			if(resultSet != null){
				resultSet.close();
			}
		}catch(Exception e){
			log.error("Error in closing resources : "+e.getMessage());
			e.printStackTrace();
		}
	}
}
