<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ include file="../../tags/tags.jsp"%>
<head>
	<title>PPT Report</title>
</head>
<body>

 <c:set var = "ALERTDETAILS"  value = "${DATA['ALERTDETAILS']}"/>
 <c:set var = "CUSTOMERRISKDETAILS"  value = "${DATA['CUSTOMERRISKDETAILS']}"/>
 <c:set var = "REPORTSTATS"  value = "${DATA['REPORTSTATS']}"/>
 <c:set var = "BRANCHWISEALERTDETAILS"  value = "${DATA['BRANCHWISEALERTDETAILS']}"/>
 
	
<div class="pull-${dirR}" style="margin-top:10px;">
		<button class="btn btn-primary ">Create PPT Report</button>
</div>	
<div class="col-sm-12" style="margin-top:30px;">
	<div class="col-sm-offset-1">
	<div class="card card-primary">
   		<div class="card-header" style="padding-top: 0px;padding-bottom: 0px;">Reports</div>
    	<div class="card-body">
    		<div class="col-sm-offset-1">
			<table class="table" border="1">
				<thead>
					<tr>
						<th>Report Name</th>
						<th>Submit Count</th>
						<th>From Date</th>
						<th>To Date</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${REPORTSTATS}" var = "report">
					<tr>
						<td>${report['REPORTNAME']}</td><td>${report['TOTALSUBMITCOUNT']}</td>
						<td>${report['FROMDATE']}</td><td>${report['TODATE']}</td>
					
					</tr>
				</c:forEach>
				</tbody>
			</table>
			</div>
    	</div>
  	</div>
	<h3></h3>
		
	<div class="card card-primary">
   		<div class="card-header" style="padding-top: 0px;padding-bottom: 0px;">Alerts Details</div>
   		<h6>Monthly alert</h6>
    	<div class="card-body">
    		<div class="col-sm-offset-1">
			<table class="table" border="1">
				<tr>
					<td>Total Alerts</td>
					<td>${ALERTDETAILS['TOTALGENERATEDALERT'] }</td>
				</tr>
				<tr>
					<td>Pending Alerts</td>
					<td>${ALERTDETAILS['PENDINGALERTS'] }</td>
				</tr>
			</table>
			</div>
    	</div>
    	<h6>Top 5 Branch wise alert</h6>
    	<div class="card-body">
    		<div class="col-sm-offset-1">
			<table class="table" border="1">
				<thead>
					<tr>
						<th>Branch Code</th>
						<th>Count </th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${BRANCHWISEALERTDETAILS}" var ="branchAlert">
					<tr>
						<td>${branchAlert['ALERTS']}</td>
						<td>${branchAlert['BRANCHCODE']}</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
			</div>
    	</div>
    </div>	
    
    <div class="card card-primary">
   		<div class="card-header" style="padding-top: 0px;padding-bottom: 0px;">Customer Rating Count</div>
    	<div class="card-body">
    		<div class="col-sm-offset-1">
			<table class="table" border="1">
				<thead>
					<tr>
						<th>Customer Rating</th>
						<th>Count </th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${CUSTOMERRISKDETAILS }" var = "custRating">
					<tr>
						<td>${custRating.key }</td>
						<td>${custRating.value }</td>
					</tr>	
					</c:forEach>
				</tbody>
			</table>
			</div>	
    	
    	</div>
    </div>
	</div>
</div>

</body>
</html>