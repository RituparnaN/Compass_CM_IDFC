<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
    
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
Map<String, Object> dashBoardMap = (Map<String, Object>) request.getAttribute("DashBoardData");
String fromDate = request.getAttribute("FromDate") != null ? (String) request.getAttribute("FromDate") : "";
String toDate = request.getAttribute("ToDate") != null ? (String) request.getAttribute("ToDate") : "";
String messageFlowType = request.getAttribute("MessageFlowType") == null ? "ALL" : (String) request.getAttribute("MessageFlowType");
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<!--[if lt IE 9]>
	<script src="<%=contextPath%>/scripts/html5shiv.js"></script>
	<script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
	<script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="<%=contextPath%>/scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/FromDateToDateScript.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/dataTables.bootstrap.css" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>
<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css"/>
<script type="text/javascript">
 var js_fromDate = '<%=fromDate%>';
 var js_toDate = '<%=toDate%>';
 if(js_fromDate == ''){
    js_fromDate = setFromDate();
 }
 if(js_toDate == ''){
    js_toDate = setToDate();
 }
	$(document).ready(function(){
		$("#dashBoardTable1").dataTable();
		$("#dashBoardTable2").dataTable();
		$("#dashBoardTable3").dataTable();
		$("#dashBoardTable4").dataTable();
		$("#dashBoardTable5").dataTable();
		$("#dashBoardTable6").dataTable();

		$( "#fromDate, #toDate" ).datepicker({
			 //dateFormat : "mm/dd/yy",
			 dateFormat : "dd/mm/yy",
			 changeMonth : true,
			 changeYear : true
		 });
		$( "#fromDate" ).val(js_fromDate);
		$( "#toDate" ).val(js_toDate);
		$("#dashBoardTab").tab();
		$("#downloadXLS").click(function(){
			var formDate = $("#fromDate").val();
			var toDate = $("#toDate").val();
			var messageFlowType = $("#messageFlowType").val();
			window.open("<%=contextPath%>/getSwiftDashBoardExcelView?FromDate="+formDate+"&ToDate="+toDate+"&MessageFlowType="+messageFlowType);
		});
	});	
</script>
<style type="text/css">
	body{
		font-size:11px;
	}
	#fromDate, #toDate{
		background-image:url("/aml/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	thead tr th{
		border:1px solid #FFF;
	}
	thead tr{
		background-color:#BBB;
		color : #B31D1D;
	}
	.nav-tabs >li >a{
		color:#B31D1D;
		background-color:#BBB;
		font-weight:bold;
	}

	.nav-tabs >li.active >a{
		color:#000000;
		background-color:#FFFFFF;
		font-weight:bold;
	}
</style>
</head>    	
<body>
    <div class="container-fluid">
		<div class="row row-xs-height">
			<div class="col-xs-12">
				<div class="card card-default">
					<div class="card-header">
						<h5 class="card-title">Dashboard</h5>
					</div>
					<div style="padding : 8px 0 8px 10px;">
						<form class="form-inline" method="GET" action="<%=contextPath%>/getSwiftDashboardTabView">
							<table width="100%">
								<tr>
									<td width="20%" style="padding:0 10px">
										<div class="form-group">
											<label for="fromDate">From Date <em>(DD/MM/YYYY)</em></label>
											<input type="text" class="form-control input-sm" id="fromDate" name="FromDate" value="<%=fromDate%>"/>
										</div>
									</td>
									<td width="20%" style="padding:0 10px">
										<div class="form-group">
											<label for="toDate">To Date <em>(DD/MM/YYYY)</em></label>
											<input type="text" class="form-control input-sm" id="toDate" name="ToDate" value="<%=toDate%>"/>
										</div>
									</td>
									<td width="20%" style="padding:0 10px">
										<div class="form-group">
											<label for="toDate">Message Flow Type</label>
											<select name="MessageFlowType" class="form-control input-sm" id="messageFlowType">
												<option value="ALL" <%=messageFlowType.equalsIgnoreCase("ALL") ? "selected" : ""%>>All</option>
												<option value="INWARD" <%=messageFlowType.equalsIgnoreCase("INWARD") ? "selected" : ""%>>INWARD</option>
												<option value="OUTWARD" <%=messageFlowType.equalsIgnoreCase("OUTWARD") ? "selected" : ""%>>OUTWARD</option>
											</select>
										</div>
									</td>
									<td width="40%" style="padding:0 10px"><br/><button type="submit" class="btn btn-default btn-sm">Search</button></td>
									<td width="40%" style="padding:0 10px"><br/><button type="button" id="downloadXLS" class="btn btn-default btn-sm">View Excel</button></td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>

		<%
			if(dashBoardMap != null && dashBoardMap.size() > 0){
				Iterator<String> tabNameItr = dashBoardMap.keySet().iterator();
		%>
		<div class="row">
			<div class="col-xs-12" style="width:100%;">
					<div role="tabpanel">
						<ul class="nav nav-tabs" role="tablist" id="dashBoardTab">
							<%
							int tabIndex = 1;
							while(tabNameItr.hasNext()){
							%>
								<li role="presentation" class='<%=tabIndex == 1 ? "active" : ""%>'>
									<a href="#dashBoardTab<%=tabIndex%>" aria-controls="dashBoardTab<%=tabIndex%>" role="tab" data-toggle="tab"><%=tabNameItr.next()%></a>
								</li>
							<%
								tabIndex++;
							}
							%>
						</ul>
					    <div class="tab-content">
							<%
							tabIndex = 1;
							tabNameItr = dashBoardMap.keySet().iterator();
							while(tabNameItr.hasNext()){
								String tabName = tabNameItr.next();
								HashMap<String, ArrayList<ArrayList<String>>> tabDetailsMap = (HashMap<String, ArrayList<ArrayList<String>>>) dashBoardMap.get(tabName);

								ArrayList<ArrayList<String>> headerList = tabDetailsMap.get("listResultHeader");
								ArrayList<ArrayList<String>> dataList = tabDetailsMap.get("listResultData");
							%>
								<div role="tabpanel" class="tab-pane <%=tabIndex == 1 ? "active" : ""%>" id="dashBoardTab<%=tabIndex%>">
									<% if(dataList.size() == 0){%>
										<br/><center>No Record Found</center><br/>
									<%}else{%>
										<table class="table table-striped table-bordered" id="dashBoardTable<%=tabIndex%>" >
											<thead>
												<tr>
												<%
													for(int headMainIndex = 0; headMainIndex < headerList.size(); headMainIndex++){
														ArrayList<String> headerListSub = headerList.get(headMainIndex);
														%>
															<th width='6px'>S.No.</th>
                                                        <%   
														for(int headSubIndex = 0; headSubIndex < headerListSub.size(); headSubIndex++){
															%>
															<th><%=headerListSub.get(headSubIndex)%></th>
												<%}		}%>
												</tr>
											<thead>

											<tbody>
												<%
													for(int rowIndex = 0; rowIndex < dataList.size(); rowIndex++){
													ArrayList<String> rowList = dataList.get(rowIndex);
												%>
														<tr>
														<td><%=rowIndex+1%></td>
															<%
																for(int colIndex = 0; colIndex < rowList.size(); colIndex++){
																 if(colIndex == 0) {
															%>
																<td style="font-weight:bold;font-size:12px;color:black"><%=rowList.get(colIndex)%></td>
                                                            <%} else { %>
																<td><%=rowList.get(colIndex)%></td>
	                                                        <%}%>
															<%}%>
														</tr>
												<%}%>
											</tbody>
										</table>
									<%}%>
								</div>
							<%
								tabIndex++;
							}
							%>
					    </div>
				</div>
			</div>
		</div>

		<%}%>
	</div>
</body>
</html>