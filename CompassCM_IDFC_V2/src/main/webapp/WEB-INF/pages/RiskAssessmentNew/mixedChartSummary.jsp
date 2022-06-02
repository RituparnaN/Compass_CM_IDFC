<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/chart.js"></script>

<script>
	
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS}">
		//console.log("DATAPOINTS: ","${dataPointLabel}")
	</c:forEach>
		
	//DESIGN CALCULATION
	//Treasury
	//E
	var e_Design_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Design_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Design_T = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Design_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Design_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Design_T = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Design_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Design_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Design_T = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Design_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Design_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Design_T = ${score};
	</c:forEach>
	</c:forEach>
	
	var t_Design = 0.0;
	var t_Design1 = 0.0;
	var t_Design2 = 0.0;
	t_Design1 = ((e_Design_T * 0) + (ni_Design_T * 5) + (nc_Design_T * 10));
	t_Design2 = ((e_Design_T + ni_Design_T + na_Design_T + nc_Design_T) - (na_Design_T));
	if(t_Design2 == 0)
	{
		t_Design = 0.0;
	}
	else
	{
		t_Design = t_Design1 / t_Design2;
	}

	//RL
	//E
	var e_Design_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Design_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Design_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Design_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Design_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Design_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Design_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Design_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Design_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Design_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Design_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Design_RL = ${score};
	</c:forEach>
	</c:forEach>
	
	var rl_Design = 0.0;
	var rl_Design1 = 0.0;
	var rl_Design2 = 0.0;
	rl_Design1 = ((e_Design_RL * 0) + (ni_Design_RL * 5) + (nc_Design_RL * 10));
	rl_Design2 = ((e_Design_RL + ni_Design_RL + na_Design_RL + nc_Design_RL) - (na_Design_RL));
	if(rl_Design2 == 0)
	{
		rl_Design = 0.0;
	}
	else
	{
		rl_Design = rl_Design1 / rl_Design2;
	}

	//RA
	//E
	var e_Design_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Design_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Design_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Design_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Design_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Design_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Design_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Design_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Design_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Design_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Design_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Design_RA = ${score};
	</c:forEach>
	</c:forEach>
	
	var ra_Design = 0.0;
	var ra_Design1 = 0.0;
	var ra_Design2 = 0.0;
	ra_Design1 = ((e_Design_RA * 0) + (ni_Design_RA * 5) + (nc_Design_RA * 10));
	ra_Design2 = ((e_Design_RA + ni_Design_RA + na_Design_RA + nc_Design_RA) - (na_Design_RA));
	if(ra_Design2 == 0)
	{
		ra_Design = 0.0;
	}
	else
	{
		ra_Design = ra_Design1 / ra_Design2;
	}
	
	//WB
	//E
	var e_Design_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Design_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Design_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Design_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Design_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Design_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Design_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Design_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Design_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Design_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Design_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Design_WB = ${score};
	</c:forEach>
	</c:forEach>
	
	var wb_Design = 0.0;
	var wb_Design1 = 0.0;
	var wb_Design2 = 0.0;
	wb_Design1 = ((e_Design_WB * 0) + (ni_Design_WB * 5) + (nc_Design_WB * 10));
	wb_Design2 = ((e_Design_WB + ni_Design_WB + na_Design_WB + nc_Design_WB) - (na_Design_WB));
	if(wb_Design2 == 0)
	{
		wb_Design = 0.0;
	}
	else
	{
		wb_Design = wb_Design1 / wb_Design2;
	}

	var avg_Design = 0.0;
	avg_Design = (t_Design + rl_Design + ra_Design + wb_Design) / 4;
	
	
	// IMPACT AND LIKLIHOOD CALCULATION
	//TREASURY
	//Customer
	var customer_T_Impact = 0.0
	var customer_T_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.T_CUSTOMER}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	customer_T_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	customer_T_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_T_Impact+" "+customer_T_LIKELYHOOD)
	//Geography
	var geo_T_Impact = 0.0
	var geo_T_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.T_GEO}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	geo_T_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	geo_T_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_T_Impact+" "+customer_T_LIKELYHOOD)
	//Product and services
	var ps_T_Impact = 0.0
	var ps_T_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.T_PROD_SERV}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	ps_T_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	ps_T_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_T_Impact+" "+customer_T_LIKELYHOOD)
	//Transcation
	var trans_T_Impact = 0.0
	var trans_T_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.T_TRANS}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	trans_T_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	trans_T_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_T_Impact+" "+customer_T_LIKELYHOOD)
	//Delivery Channel
	var dc_T_Impact = 0.0
	var dc_T_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.T_DC}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	dc_T_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	dc_T_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_T_Impact+" "+customer_T_LIKELYHOOD)
	
	//RETAIL LIABLITIES
	//Customer
	var customer_RL_Impact = 0.0
	var customer_RL_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RL_CUSTOMER}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	customer_RL_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	customer_RL_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RL_Impact+" "+customer_RL_LIKELYHOOD)
	//Geography
	var geo_RL_Impact = 0.0
	var geo_RL_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RL_GEO}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	geo_RL_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	geo_RL_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RL_Impact+" "+customer_RL_LIKELYHOOD)
	//Product and services
	var ps_RL_Impact = 0.0
	var ps_RL_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RL_PROD_SERV}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	ps_RL_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	ps_RL_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RL_Impact+" "+customer_RL_LIKELYHOOD)
	//Transcation
	var trans_RL_Impact = 0.0
	var trans_RL_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RL_TRANS}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	trans_RL_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	trans_RL_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RL_Impact+" "+customer_RL_LIKELYHOOD)
	//Delivery Channel
	var dc_RL_Impact = 0.0
	var dc_RL_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RL_DC}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	dc_RL_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	dc_RL_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RL_Impact+" "+customer_RL_LIKELYHOOD)
	
	//RETAIL ASSETS
	//Customer
	var customer_RA_Impact = 0.0
	var customer_RA_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RA_CUSTOMER}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	customer_RA_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	customer_RA_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RA_Impact+" "+customer_RA_LIKELYHOOD)
	//Geography
	var geo_RA_Impact = 0.0
	var geo_RA_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RA_GEO}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	geo_RA_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	geo_RA_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RA_Impact+" "+customer_RA_LIKELYHOOD)
	//Product and services
	var ps_RA_Impact = 0.0
	var ps_RA_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RA_PROD_SERV}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	ps_RA_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	ps_RA_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RA_Impact+" "+customer_RA_LIKELYHOOD)
	//Transcation
	var trans_RA_Impact = 0.0
	var trans_RA_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RA_TRANS}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	trans_RA_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	trans_RA_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RA_Impact+" "+customer_RA_LIKELYHOOD)
	//Delivery Channel
	var dc_RA_Impact = 0.0
	var dc_RA_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RA_DC}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	dc_RA_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	dc_RA_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_RA_Impact+" "+customer_RA_LIKELYHOOD)
	
	//WHOLESALE BANKING
	//Customer
	var customer_WB_Impact = 0.0
	var customer_WB_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WB_CUSTOMER}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	customer_WB_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	customer_WB_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_WB_Impact+" "+customer_WB_LIKELYHOOD)
	//Geography
	var geo_WB_Impact = 0.0
	var geo_WB_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WB_GEO}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	geo_WB_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	geo_WB_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_WB_Impact+" "+customer_WB_LIKELYHOOD)
	//Product and services
	var ps_WB_Impact = 0.0
	var ps_WB_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WB_PROD_SERV}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	ps_WB_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	ps_WB_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_WB_Impact+" "+customer_WB_LIKELYHOOD)
	//Transcation
	var trans_WB_Impact = 0.0
	var trans_WB_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WB_TRANS}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	trans_WB_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	trans_WB_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_WB_Impact+" "+customer_WB_LIKELYHOOD)
	//Delivery Channel
	var dc_WB_Impact = 0.0
	var dc_WB_LIKELYHOOD = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WB_DC}">
	<c:forEach var = "score" items = "${dataPointLabel.IMPACT}">
	dc_WB_Impact = ${score};
	</c:forEach>
	<c:forEach var = "score" items = "${dataPointLabel.LIKELYHOOD}">
	dc_WB_LIKELYHOOD = ${score};
	</c:forEach>
	</c:forEach>
	//alert(customer_WB_Impact+" "+customer_WB_LIKELYHOOD)
	
	
	var total_Impact = 0.0
	var total_Likelyhood = 0.0
	total_Impact = customer_T_Impact + geo_T_Impact + ps_T_Impact + trans_T_Impact + dc_T_Impact + 
					customer_RL_Impact + geo_RL_Impact + ps_RL_Impact + trans_RL_Impact + dc_RL_Impact + 
					customer_RA_Impact + geo_RA_Impact + ps_RA_Impact + trans_RA_Impact + dc_RA_Impact +
					customer_WB_Impact + geo_WB_Impact + ps_WB_Impact + trans_WB_Impact + dc_WB_Impact;
	
	total_Likelyhood = customer_T_LIKELYHOOD + geo_T_LIKELYHOOD + ps_T_LIKELYHOOD + trans_T_LIKELYHOOD + dc_T_LIKELYHOOD + 
						customer_RL_LIKELYHOOD + geo_RL_LIKELYHOOD + ps_RL_LIKELYHOOD + trans_RL_LIKELYHOOD + dc_RL_LIKELYHOOD + 
						customer_RA_LIKELYHOOD + geo_RA_LIKELYHOOD + ps_RA_LIKELYHOOD + trans_RA_LIKELYHOOD + dc_RA_LIKELYHOOD +
						customer_WB_LIKELYHOOD + geo_WB_LIKELYHOOD + ps_WB_LIKELYHOOD + trans_WB_LIKELYHOOD + dc_WB_LIKELYHOOD;
	

	var avg_Impact = 0.0
	avg_Impact = total_Impact/20;
	
	var avg_Likelyhood = 0.0
	avg_Likelyhood = total_Likelyhood/20;
	

	
//////////////////////////////////////////////////////////////////////////
	if(avg_Impact <= 5){
		if(avg_Impact == 0){
			avg_Impact = 0.8;
		}
		else if(avg_Impact > 0 && avg_Impact < 5){
			avg_Impact = avg_Impact * 2;
		}
		else if(avg_Impact == 5){
			avg_Impact = 10;
		}
	}
	
	else if(avg_Impact > 5  && avg_Impact <= 15){
		
		if(avg_Impact > 5 && avg_Impact <= 7.5){
			avg_Impact = avg_Impact * 2.1;
		}
		
		else if(avg_Impact > 7.5 && avg_Impact <= 12){
			avg_Impact = avg_Impact * 1.5;
		}
		
		else if(avg_Impact > 12 && avg_Impact < 15){
			avg_Impact = avg_Impact * 1.3;
		}
		
		else if(avg_Impact == 15){
			avg_Impact = 20;
		}
			
	}
	
	else if(avg_Impact > 15 && avg_Impact < 20){
		avg_Impact = avg_Impact * 1.4;		
	}
	
	else if(avg_Impact > 20){
		avg_Impact = 29.5;
	}
	
///////////////
	
	
	if(avg_Likelyhood <= 3){
		if(avg_Likelyhood == 0){
			avg_Likelyhood = 0.8;
		}
		else if(avg_Likelyhood > 0 && avg_Likelyhood < 3){
			avg_Likelyhood = avg_Likelyhood * 3;
		}
		else if(avg_Likelyhood == 3){
			avg_Likelyhood = 10;
		}
	}
	
	else if(avg_Likelyhood > 3  && avg_Likelyhood <= 7){
		
		if(avg_Likelyhood > 3 && avg_Likelyhood <= 3.5){
			avg_Likelyhood = avg_Likelyhood * 4;
		}
		
		else if(avg_Likelyhood > 3.5 && avg_Likelyhood <= 4.5){
			avg_Likelyhood = avg_Likelyhood * 3.5;
		}
		
		else if(avg_Likelyhood > 4.5 && avg_Likelyhood < 5.5){
			avg_Likelyhood = avg_Likelyhood * 3.5;
		}
		
		else if(avg_Likelyhood > 5.5 && avg_Likelyhood < 6.5){
			avg_Likelyhood = avg_Likelyhood * 3;
		}
		
		else if(avg_Likelyhood > 6.5 && avg_Likelyhood < 7){
			avg_Likelyhood = avg_Likelyhood * 2.5;
		}
		else if(avg_Likelyhood == 7){
			avg_Likelyhood = 20;
		}
			
	}
	
	else if(avg_Likelyhood > 7 && avg_Likelyhood < 8){
		avg_Likelyhood = avg_Likelyhood * 3;		
	}
	
	else if(avg_Likelyhood > 8){
		avg_Likelyhood = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////	
	
	
	//OPERATING CALCULATION
	//Treasury
	//E
	var e_Operating_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Operating_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Operating_T = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Operating_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Operating_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Operating_T = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Operating_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Operating_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Operating_T = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Operating_T = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Operating_T}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Operating_T = ${score};
	</c:forEach>
	</c:forEach>
	////console.log("T: "+e_Operating_T+" "+na_Operating_T+" "+ni_Operating_T+" "+nc_Operating_T);
	
	var t_Operating = 0.0;
	var t_Operating1 = 0.0;
	var t_Operating2 = 0.0;
	t_Operating1 = ((e_Operating_T * 0) + (ni_Operating_T * 5) + (nc_Operating_T * 10));
	t_Operating2 = ((e_Operating_T + ni_Operating_T + na_Operating_T + nc_Operating_T) - (na_Operating_T));
	if(t_Operating2 == 0)
	{
		t_Operating = 0.0;
	}
	else
	{
		t_Operating = t_Operating1 / t_Operating2;
	}

	
	//RL
	//E
	var e_Operating_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Operating_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Operating_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Operating_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Operating_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Operating_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Operating_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Operating_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Operating_RL = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Operating_RL = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Operating_RL}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Operating_RL = ${score};
	</c:forEach>
	</c:forEach>
	
	var rl_Operating = 0.0;
	var rl_Operating1 = 0.0;
	var rl_Operating2 = 0.0;
	rl_Operating1 = ((e_Operating_RL * 0) + (ni_Operating_RL * 5) + (nc_Operating_RL * 10));
	rl_Operating2 = ((e_Operating_RL + ni_Operating_RL + na_Operating_RL + nc_Operating_RL) - (na_Operating_RL));
	if(rl_Operating2 == 0)
	{
		rl_Operating = 0.0;
	}
	else
	{
		rl_Operating = rl_Operating1 / rl_Operating2;
	}

	//RA
	//E
	var e_Operating_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Operating_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Operating_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Operating_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Operating_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Operating_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Operating_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Operating_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Operating_RA = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Operating_RA = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Operating_RA}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Operating_RA = ${score};
	</c:forEach>
	</c:forEach>
	
	var ra_Operating = 0.0;
	var ra_Operating1 = 0.0;
	var ra_Operating2 = 0.0;
	ra_Operating1 = ((e_Operating_RA * 0) + (ni_Operating_RA * 5) + (nc_Operating_RA * 10));
	ra_Operating2 = ((e_Operating_RA + ni_Operating_RA + na_Operating_RA + nc_Operating_RA) - (na_Operating_RA));
	if(ra_Operating2 == 0)
	{
		ra_Operating = 0.0;
	}
	else
	{
		ra_Operating = ra_Operating1 / ra_Operating2;
	}

	//WB
	//E
	var e_Operating_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.E_Operating_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 e_Operating_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NA
	var na_Operating_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NA_Operating_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 na_Operating_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NI
	var ni_Operating_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NI_Operating_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 ni_Operating_WB = ${score};
	</c:forEach>
	</c:forEach>
	//NC
	var nc_Operating_WB = 0.0
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.NC_Operating_WB}">
	<c:forEach var = "score" items = "${dataPointLabel.TOTAL}">
	 nc_Operating_WB = ${score};
	</c:forEach>
	</c:forEach>
	
	var wb_Operating = 0.0;
	var wb_Operating1 = 0.0;
	var wb_Operating2 = 0.0;
	wb_Operating1 = ((e_Operating_WB * 0) + (ni_Operating_WB * 5) + (nc_Operating_WB * 10));
	wb_Operating2 = ((e_Operating_WB + ni_Operating_WB + na_Operating_WB + nc_Operating_WB) - (na_Operating_WB));
	if(wb_Operating2 == 0)
	{
		wb_Operating = 0.0;
	}
	else
	{
		wb_Operating = wb_Operating1 / wb_Operating2;
	}

	var avg_Operating = 0.0;
	avg_Operating = (t_Operating + rl_Operating + ra_Operating + wb_Operating) / 4;

		
//////////////////////////////////////////////////////////////////////////
	if(avg_Design <= 5){
		if(avg_Design == 0){
			avg_Design = 0.8;
		}
		else if(avg_Design > 0 && avg_Design < 5){
			avg_Design = avg_Design * 2;
		}
		else if(avg_Design == 5){
			avg_Design = 10;
		}
	}
	
	else if(avg_Design > 5  && avg_Design <= 15){
		
		if(avg_Design > 5 && avg_Design <= 7.5){
			avg_Design = avg_Design * 2.1;
		}
		
		else if(avg_Design > 7.5 && avg_Design <= 12){
			avg_Design = avg_Design * 1.5;
		}
		
		else if(avg_Design > 12 && avg_Design < 15){
			avg_Design = avg_Design * 1.3;
		}
		
		else if(avg_Design == 15){
			avg_Design = 20;
		}
			
	}
	
	else if(avg_Design > 15 && avg_Design < 20){
		avg_Design = avg_Design * 1.4;		
	}
	
	else if(avg_Design > 20){
		avg_Design = 29.5;
	}
	
///////////////
	
	
	if(avg_Operating <= 3){
		if(avg_Operating == 0){
			avg_Operating = 0.8;
		}
		else if(avg_Operating > 0 && avg_Operating < 3){
			avg_Operating = avg_Operating * 3;
		}
		else if(avg_Operating == 3){
			avg_Operating = 10;
		}
	}
	
	else if(avg_Operating > 3  && avg_Operating <= 7){
		
		if(avg_Operating > 3 && avg_Operating <= 3.5){
			avg_Operating = avg_Operating * 4;
		}
		
		else if(avg_Operating > 3.5 && avg_Operating <= 4.5){
			avg_Operating = avg_Operating * 3.5;
		}
		
		else if(avg_Operating > 4.5 && avg_Operating < 5.5){
			avg_Operating = avg_Operating * 3.5;
		}
		
		else if(avg_Operating > 5.5 && avg_Operating < 6.5){
			avg_Operating = avg_Operating * 3;
		}
		
		else if(avg_Operating > 6.5 && avg_Operating < 7){
			avg_Operating = avg_Operating * 2.5;
		}
		else if(avg_Operating == 7){
			avg_Operating = 20;
		}
			
	}
	
	else if(avg_Operating > 7 && avg_Operating < 8){
		avg_Operating = avg_Operating * 3;		
	}
	
	else if(avg_Operating > 8){
		avg_Operating = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////
	
	//TRESURY CHART CALCULATION
	var residualRiskDataPoints = []	
	var totalTresuryIR = 0.0
	<c:set var="totalIR_T" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.TreasuryInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_T" value="${totalIR_T + score}" />
	 ////console.log("${totalIR_T}")
	</c:forEach>
	</c:forEach>
	totalTresuryIR = ${totalIR_T};

	
	var totalTresuryIC = 0.0
	<c:set var="totalIC_T" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.TreasuryInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_T" value="${totalIC_T + score}" />
	// //console.log("${totalIC_T}")
	</c:forEach>
	</c:forEach>
	totalTresuryIC = ${totalIC_T};
	
	//RL chart Calculation
	var totalRetailLiabiltiesIR = 0.0
	<c:set var="totalIR_RL" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailLiabilitiesInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_RL" value="${totalIR_RL + score}" />
	// //console.log("${totalIR_RL}")
	</c:forEach>
	</c:forEach>
	totalRetailLiabiltiesIR = ${totalIR_RL};
	
	var totalRetailLiabiltiesIC = 0.0
	<c:set var="totalIC_RL" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailLiabilitiesInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_RL" value="${totalIC_RL + score}" />
	// //console.log("${totalIC_RL}")
	</c:forEach>
	</c:forEach>
	totalRetailLiabiltiesIC = ${totalIC_RL};
	
	// RA Chart calculation
	var totalRetailAssetsIR = 0.0
	<c:set var="totalIR_RA" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailAssetsInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_RA" value="${totalIR_RA + score}" />
	 ////console.log("${totalIR_RA}")
	</c:forEach>
	</c:forEach>
	totalRetailAssetsIR = ${totalIR_RA};
	
	var totalRetailAssetsIC = 0.0
	<c:set var="totalIC_RA" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailAssetsInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_RA" value="${totalIC_RA + score}" />
	 ////console.log("${totalIC_RA}")
	</c:forEach>
	</c:forEach>
	totalRetailAssetsIC = ${totalIC_RA};

	//WB chart calculation
	var totalWholesaleIR = 0.0
	<c:set var="totalIR_WB" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WholesaleBankingInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_WB" value="${totalIR_WB + score}" />
	 ////console.log("${totalIR_WB}")
	</c:forEach>
	</c:forEach>
	totalWholesaleIR = ${totalIR_WB};

	var totalWholesaleIC = 0.0
	<c:set var="totalIC_WB" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WholesaleBankingInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_WB" value="${totalIC_WB + score}" />
	 ////console.log("${totalIC_WB}")
	</c:forEach>
	</c:forEach>
	totalWholesaleIC = ${totalIC_WB};

	total_of_IR = (totalTresuryIR + totalRetailLiabiltiesIR + totalRetailAssetsIR + totalWholesaleIR)/4;
	total_of_IC = (totalTresuryIC + totalRetailLiabiltiesIC + totalRetailAssetsIC + totalWholesaleIC)/4;
	
//////////////////////////////////////////////////////////////////////////
	if(total_of_IR <= 5){
		if(total_of_IR == 0){
			total_of_IR = 0.8;
		}
		else if(total_of_IR > 0 && total_of_IR < 5){
			total_of_IR = total_of_IR * 2;
		}
		else if(total_of_IR == 5){
			total_of_IR = 10;
		}
	}
	
	else if(total_of_IR > 5  && total_of_IR <= 15){
		
		if(total_of_IR > 5 && total_of_IR <= 7.5){
			total_of_IR = total_of_IR * 2.1;
		}
		
		else if(total_of_IR > 7.5 && total_of_IR <= 12){
			total_of_IR = total_of_IR * 1.5;
		}
		
		else if(total_of_IR > 12 && total_of_IR < 15){
			total_of_IR = total_of_IR * 1.3;
		}
		
		else if(total_of_IR == 15){
			total_of_IR = 20;
		}
			
	}
	
	else if(total_of_IR > 15 && total_of_IR < 20){
		total_of_IR = total_of_IR * 1.4;		
	}
	
	else if(total_of_IR > 20){
		total_of_IR = 29.5;
	}
	
///////////////
	
	
	if(total_of_IC <= 3){
		if(total_of_IC == 0){
			total_of_IC = 0.8;
		}
		else if(total_of_IC > 0 && total_of_IC < 3){
			total_of_IC = total_of_IC * 3;
		}
		else if(total_of_IC == 3){
			total_of_IC = 10;
		}
	}
	
	else if(total_of_IC > 3  && total_of_IC <= 7){
		
		if(total_of_IC > 3 && total_of_IC <= 3.5){
			total_of_IC = total_of_IC * 4;
		}
		
		else if(total_of_IC > 3.5 && total_of_IC <= 4.5){
			total_of_IC = total_of_IC * 3.5;
		}
		
		else if(total_of_IC > 4.5 && total_of_IC < 5.5){
			total_of_IC = total_of_IC * 3.5;
		}
		
		else if(total_of_IC > 5.5 && total_of_IC < 6.5){
			total_of_IC = total_of_IC * 3;
		}
		
		else if(total_of_IC > 6.5 && total_of_IC < 7){
			total_of_IC = total_of_IC * 2.5;
		}
		else if(total_of_IC == 7){
			total_of_IC = 20;
		}
			
	}
	
	else if(total_of_IC > 7 && total_of_IC < 8){
		total_of_IC = total_of_IC * 3;		
	}
	
	else if(total_of_IC > 8){
		total_of_IC = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////

	var totalTresuryIR_x = 0.0;
	var totalTresuryIC_y = 0.0;

	if(totalTresuryIR <= 5){
		if(totalTresuryIR == 0){
			totalTresuryIR_x = 0.8;
		}
		else if(totalTresuryIR > 0 && totalTresuryIR < 5){
			totalTresuryIR_x = totalTresuryIR * 2;
		}
		else if(totalTresuryIR == 5){
			totalTresuryIR_x = 10;
		}
	}
	
	else if(totalTresuryIR > 5  && totalTresuryIR <= 15){
		
		if(totalTresuryIR > 5 && totalTresuryIR <= 7.5){
			totalTresuryIR_x = totalTresuryIR * 2.1;
		}
		
		else if(totalTresuryIR > 7.5 && totalTresuryIR <= 12){
			totalTresuryIR = totalTresuryIR * 1.5;
		}
		
		else if(totalTresuryIR > 12 && totalTresuryIR < 15){
			totalTresuryIR_x = totalTresuryIR * 1.3;
		}
		
		else if(totalTresuryIR == 15){
			totalTresuryIR_x = 20;
		}
			
	}
	
	else if(totalTresuryIR > 15 && totalTresuryIR < 20){
		totalTresuryIR_x = totalTresuryIR * 1.4;		
	}
	
	else if(totalTresuryIR > 20){
		totalTresuryIR_x = 29.5;
	}
	
///////////////
	
	
	if(totalTresuryIC <= 3){
		if(totalTresuryIC == 0){
			totalTresuryIC_y = 0.8;
		}
		else if(totalTresuryIC > 0 && totalTresuryIC < 3){
			totalTresuryIC_y = totalTresuryIC * 3;
		}
		else if(totalTresuryIC == 3){
			totalTresuryIC_y = 10;
		}
	}
	
	else if(totalTresuryIC > 3  && totalTresuryIC <= 7){
		
		if(totalTresuryIC > 3 && totalTresuryIC <= 3.5){
			totalTresuryIC_y = totalTresuryIC * 4;
		}
		
		else if(totalTresuryIC > 3.5 && totalTresuryIC <= 4.5){
			totalTresuryIC_y = totalTresuryIC * 3.5;
		}
		
		else if(totalTresuryIC > 4.5 && totalTresuryIC < 5.5){
			totalTresuryIC_y = totalTresuryIC * 3.5;
		}
		
		else if(totalTresuryIC > 5.5 && totalTresuryIC < 6.5){
			totalTresuryIC_y = totalTresuryIC * 3;
		}
		
		else if(totalTresuryIC > 6.5 && totalTresuryIC < 7){
			totalTresuryIC_y = totalTresuryIC * 2.5;
		}
		else if(totalTresuryIC == 7){
			totalTresuryIC_y = 20;
		}
			
	}
	
	else if(totalTresuryIC > 7 && totalTresuryIC < 8){
		totalTresuryIC_y = totalTresuryIC * 3;		
	}
	
	else if(totalTresuryIC > 8){
		totalTresuryIC_y = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////

	var totalRetailLiabiltiesIR_x = 0.0;
	var totalRetailLiabiltiesIC_y = 0.0;

	if(totalRetailLiabiltiesIR <= 5){
		if(totalRetailLiabiltiesIR == 0){
			totalRetailLiabiltiesIR_x = 0.8;
		}
		else if(totalRetailLiabiltiesIR > 0 && totalRetailLiabiltiesIR < 5){
			totalRetailLiabiltiesIR_x = totalRetailLiabiltiesIR * 2;
		}
		else if(totalRetailLiabiltiesIR == 5){
			totalRetailLiabiltiesIR_x = 10;
		}
	}
	
	else if(totalRetailLiabiltiesIR > 5  && totalRetailLiabiltiesIR <= 15){
		
		if(totalRetailLiabiltiesIR > 5 && totalRetailLiabiltiesIR <= 7.5){
			totalRetailLiabiltiesIR_x = totalRetailLiabiltiesIR * 2.1;
		}
		
		else if(totalRetailLiabiltiesIR > 7.5 && totalRetailLiabiltiesIR <= 12){
			totalRetailLiabiltiesIR = totalRetailLiabiltiesIR * 1.5;
		}
		
		else if(totalRetailLiabiltiesIR > 12 && totalRetailLiabiltiesIR < 15){
			totalRetailLiabiltiesIR_x = totalRetailLiabiltiesIR * 1.3;
		}
		
		else if(totalRetailLiabiltiesIR == 15){
			totalRetailLiabiltiesIR_x = 20;
		}
			
	}
	
	else if(totalRetailLiabiltiesIR > 15 && totalRetailLiabiltiesIR < 20){
		totalRetailLiabiltiesIR_x = totalRetailLiabiltiesIR * 1.4;		
	}
	
	else if(totalRetailLiabiltiesIR > 20){
		totalRetailLiabiltiesIR_x = 29.5;
	}
	
///////////////
	
	
	if(totalRetailLiabiltiesIC <= 3){
		if(totalRetailLiabiltiesIC == 0){
			totalRetailLiabiltiesIC_y = 0.8;
		}
		else if(totalRetailLiabiltiesIC > 0 && totalRetailLiabiltiesIC < 3){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 3;
		}
		else if(totalRetailLiabiltiesIC == 3){
			totalRetailLiabiltiesIC_y = 10;
		}
	}
	
	else if(totalRetailLiabiltiesIC > 3  && totalRetailLiabiltiesIC <= 7){
		
		if(totalRetailLiabiltiesIC > 3 && totalRetailLiabiltiesIC <= 3.5){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 4;
		}
		
		else if(totalRetailLiabiltiesIC > 3.5 && totalRetailLiabiltiesIC <= 4.5){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 3.5;
		}
		
		else if(totalRetailLiabiltiesIC > 4.5 && totalRetailLiabiltiesIC < 5.5){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 3.5;
		}
		
		else if(totalRetailLiabiltiesIC > 5.5 && totalRetailLiabiltiesIC < 6.5){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 3;
		}
		
		else if(totalRetailLiabiltiesIC > 6.5 && totalRetailLiabiltiesIC < 7){
			totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 2.5;
		}
		else if(totalRetailLiabiltiesIC == 7){
			totalRetailLiabiltiesIC_y = 20;
		}
			
	}
	
	else if(totalRetailLiabiltiesIC > 7 && totalRetailLiabiltiesIC < 8){
		totalRetailLiabiltiesIC_y = totalRetailLiabiltiesIC * 3;		
	}
	
	else if(totalRetailLiabiltiesIC > 8){
		totalRetailLiabiltiesIC_y = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////	
	
	var totalRetailAssetsIR_x = 0.0;
	var totalRetailAssetsIC_y = 0.0;

	if(totalRetailAssetsIR <= 5){
		if(totalRetailAssetsIR == 0){
			totalRetailAssetsIR_x = 0.8;
		}
		else if(totalRetailAssetsIR > 0 && totalRetailAssetsIR < 5){
			totalRetailAssetsIR_x = totalRetailAssetsIR * 2;
		}
		else if(totalRetailAssetsIR == 5){
			totalRetailAssetsIR_x = 10;
		}
	}
	
	else if(totalRetailAssetsIR > 5  && totalRetailAssetsIR <= 15){
		
		if(totalRetailAssetsIR > 5 && totalRetailAssetsIR <= 7.5){
			totalRetailAssetsIR_x = totalRetailAssetsIR * 2.1;
		}
		
		else if(totalRetailAssetsIR > 7.5 && totalRetailAssetsIR <= 12){
			totalRetailAssetsIR = totalRetailAssetsIR * 1.5;
		}
		
		else if(totalRetailAssetsIR > 12 && totalRetailAssetsIR < 15){
			totalRetailAssetsIR_x = totalRetailAssetsIR * 1.3;
		}
		
		else if(totalRetailAssetsIR == 15){
			totalRetailAssetsIR_x = 20;
		}
			
	}
	
	else if(totalRetailAssetsIR > 15 && totalRetailAssetsIR < 20){
		totalRetailAssetsIR_x = totalRetailAssetsIR * 1.4;		
	}
	
	else if(totalRetailAssetsIR > 20){
		totalRetailAssetsIR_x = 29.5;
	}
	
///////////////
	
	
	if(totalRetailAssetsIC <= 3){
		if(totalRetailAssetsIC == 0){
			totalRetailAssetsIC_y = 0.8;
		}
		else if(totalRetailAssetsIC > 0 && totalRetailAssetsIC < 3){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 3;
		}
		else if(totalRetailAssetsIC == 3){
			totalRetailAssetsIC_y = 10;
		}
	}
	
	else if(totalRetailAssetsIC > 3  && totalRetailAssetsIC <= 7){
		
		if(totalRetailAssetsIC > 3 && totalRetailAssetsIC <= 3.5){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 4;
		}
		
		else if(totalRetailAssetsIC > 3.5 && totalRetailAssetsIC <= 4.5){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 3.5;
		}
		
		else if(totalRetailAssetsIC > 4.5 && totalRetailAssetsIC < 5.5){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 3.5;
		}
		
		else if(totalRetailAssetsIC > 5.5 && totalRetailAssetsIC < 6.5){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 3;
		}
		
		else if(totalRetailAssetsIC > 6.5 && totalRetailAssetsIC < 7){
			totalRetailAssetsIC_y = totalRetailAssetsIC * 2.5;
		}
		else if(totalRetailAssetsIC == 7){
			totalRetailAssetsIC_y = 20;
		}
			
	}
	
	else if(totalRetailAssetsIC > 7 && totalRetailAssetsIC < 8){
		totalRetailAssetsIC_y = totalRetailAssetsIC * 3;		
	}
	
	else if(totalRetailAssetsIC > 8){
		totalRetailAssetsIC_y = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////
	
	var totalWholesaleIR_x = 0.0;
	var totalWholesaleIC_y = 0.0;
	
	if(totalWholesaleIR <= 5){
		if(totalWholesaleIR == 0){
			totalWholesaleIR_x = 0.8;
		}
		else if(totalWholesaleIR > 0 && totalWholesaleIR < 5){
			totalWholesaleIR_x = totalWholesaleIR * 2;
		}
		else if(totalWholesaleIR == 5){
			totalWholesaleIR_x = 10;
		}
	}
	
	else if(totalWholesaleIR > 5  && totalWholesaleIR <= 15){
		
		if(totalWholesaleIR > 5 && totalWholesaleIR <= 7.5){
			totalWholesaleIR_x = totalWholesaleIR * 2.1;
		}
		
		else if(totalWholesaleIR > 7.5 && totalWholesaleIR <= 12){
			totalWholesaleIR = totalWholesaleIR * 1.5;
		}
		
		else if(totalWholesaleIR > 12 && totalWholesaleIR < 15){
			totalWholesaleIR_x = totalWholesaleIR * 1.3;
		}
		
		else if(totalWholesaleIR == 15){
			totalWholesaleIR_x = 20;
		}
			
	}
	
	else if(totalWholesaleIR > 15 && totalWholesaleIR < 20){
		totalWholesaleIR_x = totalWholesaleIR * 1.4;		
	}
	
	else if(totalWholesaleIR > 20){
		totalWholesaleIR_x = 29.5;
	}
	
///////////////
	
	
	if(totalWholesaleIC <= 3){
		if(totalWholesaleIC == 0){
			totalWholesaleIC_y = 0.8;
		}
		else if(totalWholesaleIC > 0 && totalWholesaleIC < 3){
			totalWholesaleIC_y = totalWholesaleIC * 3;
		}
		else if(totalWholesaleIC == 3){
			totalWholesaleIC_y = 10;
		}
	}
	
	else if(totalWholesaleIC > 3  && totalWholesaleIC <= 7){
		
		if(totalWholesaleIC > 3 && totalWholesaleIC <= 3.5){
			totalWholesaleIC_y = totalWholesaleIC * 4;
		}
		
		else if(totalWholesaleIC > 3.5 && totalWholesaleIC <= 4.5){
			totalWholesaleIC_y = totalWholesaleIC * 3.5;
		}
		
		else if(totalWholesaleIC > 4.5 && totalWholesaleIC < 5.5){
			totalWholesaleIC_y = totalWholesaleIC * 3.5;
		}
		
		else if(totalWholesaleIC > 5.5 && totalWholesaleIC < 6.5){
			totalWholesaleIC_y = totalWholesaleIC * 3;
		}
		
		else if(totalWholesaleIC > 6.5 && totalWholesaleIC < 7){
			totalWholesaleIC_y = totalWholesaleIC * 2.5;
		}
		else if(totalWholesaleIC == 7){
			totalWholesaleIC_y = 20;
		}
			
	}
	
	else if(totalWholesaleIC > 7 && totalWholesaleIC < 8){
		totalWholesaleIC_y = totalWholesaleIC * 3;		
	}
	
	else if(totalWholesaleIC > 8){
		totalWholesaleIC_y = 29.5;
	}
//////////////////////////////////////////////////////////////////////////////////////////////
	
	var bankLevelResidualRisk = [];
	bankLevelResidualRisk.push({x: total_of_IR, y: total_of_IC, r: 20});
	
	residualRiskDataPoints.push({x: totalTresuryIR, y: totalTresuryIC, r: 20})
	residualRiskDataPoints.push({x: totalRetailLiabiltiesIR, y: totalRetailLiabiltiesIC, r: 20})
	residualRiskDataPoints.push({x: totalRetailAssetsIR, y: totalRetailAssetsIC, r: 20})
	residualRiskDataPoints.push({x: totalWholesaleIR, y: totalWholesaleIC, r: 20})
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//DEFAULT VALUE CHART CREATION STARTED
	const defalutValueCTX=document.getElementById('defalutValueCanvas').getContext('2d');
	const defalutValueDATA = {
			  datasets: [{
			    label: 'DEFAULT VALUE RISK',
			    data: [{
			      x: 0.8,
			      y: 0.8,
			      r: 20
			    },],
			    pointStyle: 'crossRot',
			    borderWidth: 6,
			    backgroundColor: 'rgba(0, 0, 0, 1)',
			    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const defalutValueCONFIG = {
		  type: 'bubble',
		  data: defalutValueDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const defalutValueChart = new Chart(defalutValueCTX, defalutValueCONFIG);
	var defalutValueIMAGE = defalutValueChart.toBase64Image();
	document.getElementById("defalutValueURL").value = defalutValueIMAGE;
	defalutValueChart.destroy();
	//DEFALUT VALUE CHART CREATION ENDED
	
	
	//TREASURY RESIDUAL RISK CHART CREATION STARTED
	const tResidualRiskCTX=document.getElementById('tResidualRiskCanvas').getContext('2d');
	const tResidualRiskDATA = {
			  datasets: [{
			    label: 'TREASURY RESIDUAL RISK',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: totalTresuryIR_x,
				      y: totalTresuryIC_y,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const tResidualRiskCONFIG = {
		  type: 'bubble',
		  data: tResidualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const tResidualRiskChart = new Chart(tResidualRiskCTX, tResidualRiskCONFIG);
	var tResidualRiskIMAGE = tResidualRiskChart.toBase64Image();
	document.getElementById("tResidualRiskURL").value = tResidualRiskIMAGE;
	////console.log(tResidualRiskIMAGE);
	tResidualRiskChart.destroy();
	//TREASURY RESIDUAL RISK CHART CREATION ENDED
	
	
	//RL RESIDUAL RISK CHART CREATION STARTED
	const rlResidualRiskCTX=document.getElementById('rlResidualRiskCanvas').getContext('2d');
	const rlResidualRiskDATA = {
			  datasets: [{
			    label: 'RL RESIDUAL RISK',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: totalRetailLiabiltiesIR_x,
				      y: totalRetailLiabiltiesIC_y,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const rlResidualRiskCONFIG = {
		  type: 'bubble',
		  data: rlResidualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const rlResidualRiskChart = new Chart(rlResidualRiskCTX, rlResidualRiskCONFIG);
	var rlResidualRiskIMAGE = rlResidualRiskChart.toBase64Image();
	document.getElementById("rlResidualRiskURL").value = rlResidualRiskIMAGE;
	////console.log(rlResidualRiskIMAGE);
	rlResidualRiskChart.destroy();
	//RL RESIDUAL RISK CHART CREATION ENDED
	
	
	//RA RESIDUAL RISK CHART CREATION STARTED
	const raResidualRiskCTX=document.getElementById('raResidualRiskCanvas').getContext('2d');
	const raResidualRiskDATA = {
			  datasets: [{
			    label: 'RA RESIDUAL RISK',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: totalRetailAssetsIR_x,
				      y: totalRetailAssetsIC_y,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const raResidualRiskCONFIG = {
		  type: 'bubble',
		  data: raResidualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const raResidualRiskChart = new Chart(raResidualRiskCTX, raResidualRiskCONFIG);
	var raResidualRiskIMAGE = raResidualRiskChart.toBase64Image();
	document.getElementById("raResidualRiskURL").value = raResidualRiskIMAGE;
	////console.log(raResidualRiskIMAGE);
	raResidualRiskChart.destroy();
	//RA RESIDUAL RISK CHART CREATION ENDED
	
	
	//WB RESIDUAL RISK CHART CREATION STARTED
	const wbResidualRiskCTX=document.getElementById('wbResidualRiskCanvas').getContext('2d');
	const wbResidualRiskDATA = {
			  datasets: [{
			    label: 'WB RESIDUAL RISK',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: totalWholesaleIR_x,
				      y: totalWholesaleIC_y,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const wbResidualRiskCONFIG = {
		  type: 'bubble',
		  data: wbResidualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const wbResidualRiskChart = new Chart(wbResidualRiskCTX, wbResidualRiskCONFIG);
	var wbResidualRiskIMAGE = wbResidualRiskChart.toBase64Image();
	document.getElementById("wbResidualRiskURL").value = wbResidualRiskIMAGE;
	////console.log(wbResidualRiskIMAGE);
	wbResidualRiskChart.destroy();
	//WB RESIDUAL RISK CHART CREATION ENDED
	
	
	//RESIDUAL RISK CHART CREATION STARTED
	const residualRiskCTX=document.getElementById('residualRiskCanvas').getContext('2d');
	const residualRiskDATA = {
			  datasets: [{
			    label: 'RESIDUAL RISK',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: total_of_IR,
				      y: total_of_IC,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const residualRiskCONFIG = {
		  type: 'bubble',
		  data: residualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const residualRiskChart = new Chart(residualRiskCTX,residualRiskCONFIG);
	var residualRiskIMAGE = residualRiskChart.toBase64Image();
	document.getElementById("residualRiskURL").value = residualRiskIMAGE;
	residualRiskChart.destroy();
	//RESIDUAL RISK CHART CREATION ENDED
	
	
	//BL IR CHART CREATION STARTED
	const bl_IR_CTX=document.getElementById('bl_IR_Canvas').getContext('2d');
	const bl_IR_DATA = {
			  datasets: [{
			    label: 'BANK LEVEL IR',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: avg_Impact,
				      y: avg_Likelyhood,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const bl_IR_CONFIG = {
		  type: 'bubble',
		  data: bl_IR_DATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const bl_IR_Chart = new Chart(bl_IR_CTX,bl_IR_CONFIG);
	var bl_IR_IMAGE = bl_IR_Chart.toBase64Image();
	document.getElementById("bl_IR_URL").value = bl_IR_IMAGE;
	bl_IR_Chart.destroy();
	//BL IR CHART CREATION ENDED
		
	//BL IC CHART CREATION STARTED
	const bl_IC_CTX=document.getElementById('bl_IC_Canvas').getContext('2d');
	const bl_IC_DATA = {
			  datasets: [{
			    label: 'BANK LEVEL IC',
			    //data: bankLevelResidualRisk,
			    data: [{
				      x: avg_Design,
				      y: avg_Operating,
				      r: 20
				    },],
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const bl_IC_CONFIG = {
		  type: 'bubble',
		  data: bl_IC_DATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const bl_IC_Chart = new Chart(bl_IC_CTX,bl_IC_CONFIG);
	var bl_IC_IMAGE = bl_IC_Chart.toBase64Image();
	document.getElementById("bl_IC_URL").value = bl_IC_IMAGE;
	bl_IC_Chart.destroy();
	//BL IC CHART CREATION ENDED
	
	
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION STARTED
	const assessmentCatCTX=document.getElementById('assessmentCatCanvas').getContext('2d');
	const assessmentCatDATA = {
			  datasets: [{
			    label: 'ASSESSMENT UNIT LEVEL RESIDUAL RISK',
			    //data: residualRiskDataPoints,
			     data: [{
			      x: totalTresuryIR_x,
			      y: totalTresuryIC_y,
			      r: 20
			    }, {
			      x: totalRetailLiabiltiesIR_x,
			      y: totalRetailLiabiltiesIC_y,
			      r: 20
			    }, {
				   x: totalRetailAssetsIR_x,
				   y: totalRetailAssetsIC_y, 
			       r: 20
				}, {
				   x: totalWholesaleIR_x,
			       y: totalWholesaleIC_y,
			       r: 20
				 },], 
				//pointStyle: ['crossRot', 'rect', 'triangle', 'circle'],
				pointStyle: ['rect', 'circle', 'triangle', 'crossRot'],
				borderWidth: [1, 2, 1, 3],
			    backgroundColor: ['rgb(255, 255, 255)', 'rgb(144, 153, 254)', 'rgb(127, 0, 100)', 'rgb(0, 0, 0)'],
			    borderColor: ['rgb(0, 0, 0)', 'rgb(144, 153, 254)', 'rgb(127, 0, 100)', 'rgba(0, 0, 0)'],
			  }]
			};		

	const assessmentCatCONFIG = {
		  type: 'bubble',
		  data: assessmentCatDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 30,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const assessmentCatChart = new Chart(assessmentCatCTX,assessmentCatCONFIG);
	var assessmentCatIMAGE = assessmentCatChart.toBase64Image();
	var img = document.getElementById('assessmentCatCanvas').toDataURL("image/png");
	////console.log("assessmentCatChart:",img)
	document.getElementById("assessmentCatURL").value = assessmentCatIMAGE;
	assessmentCatChart.destroy();
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION ENDED
	
	

	//SET VALUE ON INPUT TYPE
	document.getElementById("totalTresuryIR").value = totalTresuryIR;
	document.getElementById("totalTresuryIC").value = totalTresuryIC;
	
	document.getElementById("totalRetailLiabiltiesIR").value = totalRetailLiabiltiesIR;
	document.getElementById("totalRetailLiabiltiesIC").value = totalRetailLiabiltiesIC;
	
	document.getElementById("totalRetailAssetsIR").value = totalRetailAssetsIR;
	document.getElementById("totalRetailAssetsIC").value = totalRetailAssetsIC;
	
	document.getElementById("totalWholesaleIR").value = totalWholesaleIR;
	document.getElementById("totalWholesaleIC").value = totalWholesaleIC;

		
</script>

<div>	
	<form action="imagedata" method="post" id = "chartForm">
		<div>
			<canvas id="defalutValueCanvas"></canvas>
			<canvas id="residualRiskCanvas"></canvas>
			<canvas id="bl_IR_Canvas"></canvas>
			<canvas id="bl_IC_Canvas"></canvas>
			<canvas id="tResidualRiskCanvas"></canvas>
			<canvas id="rlResidualRiskCanvas"></canvas>
			<canvas id="raResidualRiskCanvas"></canvas>
			<canvas id="wbResidualRiskCanvas"></canvas>
			<canvas id="assessmentCatCanvas"></canvas>			
			<input type="text" id="defalutValueURL" name="defalutValueURL"/>				
			<input type="text" id="residualRiskURL" name="residualRiskURL"/>
			<input type="text" id="bl_IR_URL" name="bl_IC_URL"/>
			<input type="text" id="bl_IC_URL" name="bl_IC_URL"/>
			<input type="text" id="tResidualRiskURL" name="tResidualRiskURL"/>
			<input type="text" id="rlResidualRiskURL" name="rlResidualRiskURL"/>
			<input type="text" id="raResidualRiskURL" name="raResidualRiskURL"/>
			<input type="text" id="wbResidualRiskURL" name="wbResidualRiskURL"/>
			<input type="text" id="assessmentCatURL" name="assessmentCatURL"/>
			
			<input type="text" id="totalTresuryIR" name="totalTresuryIR"/>
			<input type="text" id="totalTresuryIC" name="totalTresuryIC"/>
			
			<input type="text" id="totalRetailLiabiltiesIR" name="totalRetailLiabiltiesIR"/>
			<input type="text" id="totalRetailLiabiltiesIC" name="totalRetailLiabiltiesIC"/>
			
			<input type="text" id="totalRetailAssetsIR" name="totalRetailAssetsIR"/>
			<input type="text" id="totalRetailAssetsIC" name="totalRetailAssetsIC"/>
			
			<input type="text" id="totalWholesaleIR" name="totalWholesaleIR"/>
			<input type="text" id="totalWholesaleIC" name="totalWholesaleIC"/>
		</div>
	</form>
</div>
