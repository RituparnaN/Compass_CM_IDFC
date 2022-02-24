<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
%>
<style type="text/css">
.datepicker{
	background-image:url("<%=contextPath%>/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
}
input[type=text].input-ovr {
	text-align: justify;
	padding:2px 5px;
	height: 28px;
	font-size:14px;
	font-weight: normal;
	line-height:1.42857143;
	color:#555;
	border:1px solid #ccc;
	border-radius:4px;
	-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
	box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
	-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
	-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#CPUMakerViewCaseForm").submit(function(e){
			var formObj = $("#CPUMakerViewCaseForm");
			var formData = $(formObj).serialize();
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/cpuMaker/viewAOFStatus",
				data : formData,
				cache : false,
				success : function(res){
					$("#makerViewStatus").html(res);
				},
				error : function(){
					alert("error");
				}
			});
			
		});
	});
</script>
</head>
<body>
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">Search Forms Status</div>
				<form id="CPUMakerViewCaseForm" action="javascript:void(0)" method="POST">
					<table class="table table-bordered" style="margin-bottom: 0px;">
						<tr>
							<td width="45%">
								<div class="input-group">
									<label class="input-group-addon btn-info" for="fromData" id="basic-addon1">From Date</label> 
									<input id="fromData" name="fromDate" type="text" class="form-control input-sm datepicker" placeholder="From Date"
										aria-describedby="basic-addon1" autocomplete="off"/>
										
									<label class="input-group-addon btn-info" for="toDate" id="basic-addon1">To Date</label> 
									<input id="toDate" name="toDate" type="text" class="form-control input-sm datepicker" placeholder="To Date"
										aria-describedby="basic-addon1" autocomplete="off" />
								</div>
							</td>
							<td width="45%">
								<div class="input-group">
									<label class="input-group-addon btn-info" for="status" id="basic-addon1">Status</label> 
									<select class="form-control input-sm" aria-describedby="basic-addon1" id="status" name="status">
										<option value="U">Pending</option>
										<option value="P">Submitted</option>
										<option value="A">Approved</option>
										<option value="R">Rejected</option>
									</select>
								</div>
							</td>
							<td width="10%"><input type="submit" class="btn btn-primary" value="Search"></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12" id="makerViewStatus">
		</div>
	</div>