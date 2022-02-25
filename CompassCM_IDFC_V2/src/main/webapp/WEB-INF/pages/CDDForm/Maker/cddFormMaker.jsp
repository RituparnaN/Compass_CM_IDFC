<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		$("#createNewCDDForm"+id).attr("disabled","disabled");
		
		$("#invdExisting"+id+",#corpExisting"+id).click(function(){
			$("#createNewCDDForm"+id).removeAttr("disabled");
		});
		
		$("#invdNew"+id+",#corpNew"+id).click(function(){
			$("#createNewCDDForm"+id).removeAttr("disabled");
		});
		
		$("#allPending"+id).click(function(){
			$("#createNewCDDForm"+id).attr("disabled","disabled");
		});
		
		$("#createNewCDDForm"+id).click(function(){
			if(confirm("Are you sure you want to Create New CDD Form?\nIf yes, Compass will generate a new reference number and that cannot be deleted.")){
				$(this).html("Creating...");
				$(this).attr("disabled","disabled");
				var formObj = $("#searchMasterForm"+id);
				var formData = $(formObj).serialize();
				$.ajax({
					url : "${pageContext.request.contextPath}/cddFormCommon/openNewCDDForm",
					type : "POST",
					cache : false,
					data : formData,
					success : function(res){
						$(".compassrow"+id).html(res);
					},
					error : function(){
						alert("Error while opening form");
					}
				});
			}
		});
		
		$("#createExistingCDDForm"+id).click(function(){
			$(this).html("Creating...");
			$(this).attr("disabled","disabled");
			var formObj = $("#searchMasterForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/openExistingCDDForm",
				type : "POST",
				cache : false,
				data : formData,
				success : function(res){
					$(".compassrow"+id).html(res);
				},
				error : function(){
					alert("Error while opening form");
				}
			});
		});
		
		$("#searchCDDForm"+id).click(function(){
			var formObj = $("#searchMasterForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/searchCDDForm",
				type : "POST",
				cache : false,
				data : formData,
				success : function(res){
					$("#panelCDDForm"+id).css("display", "block");
					$("#CDDRiskRatingSerachResult"+id).html(res);
				},
				error : function(){
					alert("Error while opening form");
				}
			});
		});
	});
	
	function continueCDD(elm){
		var id = '${UNQID}';
		var compassRefNo = $(elm).attr("compassRefNo");
		var formType = $(elm).attr("formType");
		var lineNo = $(elm).attr("lineNo");
		var FULLDATA = "COMPASSREFERENCENO="+compassRefNo+"&FORMTYPE="+formType+"&LINENO="+lineNo+"&UNQID="+id;
		
		$(elm).html("Starting...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/openNewCDDForm",
			type : "POST",
			cache : false,
			data : FULLDATA,
			success : function(res){
				$(".compassrow"+id).html(res);
			},
			error : function(){
				alert("Error while opening form");
			}
		});
	}
		
	function reCDD(elm){
		var id = '${UNQID}';
		var compassRefNo = $(elm).attr("compassRefNo");
		var formType = $(elm).attr("formType");
		var lineNo = $(elm).attr("lineNo");
		
		if(formType == "INVDNEW")
			formType = "INVDEXISTING";
		if(formType == "CORPNEW")
			formType = "CORPEXISTING";
		
		var FULLDATA = "COMPASSREFERENCENO="+compassRefNo+"&FORMTYPE="+formType+"&LINENO="+lineNo+"&UNQID="+id+"&RECDD=Y";
		
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/checkReCDDStatus",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo,
			success : function(res){
				if(res == "Y"){
					alert("This Re-CDD is already initiated. Please search again")
				}else{
					if(confirm("Are you sure you want to start Re-CDD on this Compass Reference Number?")){
						$(elm).html("Starting...");
						$.ajax({
							url : "${pageContext.request.contextPath}/cddFormCommon/openNewCDDForm",
							type : "POST",
							cache : false,
							data : FULLDATA,
							success : function(res){
								$(".compassrow"+id).html(res);
							},
							error : function(){
								alert("Error while opening form");
							}
						});
					}
				}
			},
			error : function(){
				alert("Error while opening form");
			}
		});
		
		
		
		
	}
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_CDDForm">
			<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">CDD & Risk Rating</h6>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable cddForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
								<tr>
									<td style="width: 30%">Form Type</td>
									<td style="width: 70%">
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="allPending${UNQID}">
										  <input type="radio" id="allPending${UNQID}" name="FORMTYPE" checked="checked" value="PENDING"/>
										  	All Pending
										</label>
										
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="invdNew${UNQID}">
										  <input type="radio" id="invdNew${UNQID}" name="FORMTYPE" value="INVDNEW"/>
										  	New Individual
										</label>
										
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="invdExisting${UNQID}">
										  <input type="radio" id="invdExisting${UNQID}"  name="FORMTYPE" value="INVDEXISTING"/>
										  	Existing Individual
										</label>
										
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="corpNew${UNQID}">
										  <input type="radio" id="corpNew${UNQID}"  name="FORMTYPE" value="CORPNEW"/>
										  	New Corporate
										</label>
										
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="corpExisting${UNQID}">
										  <input type="radio" id="corpExisting${UNQID}"  name="FORMTYPE" value="CORPEXISTING"/>
										  	Existing Corporate
										</label>
										
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="approvedCDD${UNQID}">
										  <input type="radio" id="approvedCDD${UNQID}"  name="FORMTYPE" value="APPROVED"/>
										  	Approved CDD
										</label>
									</td>
								</tr>
								<tr>
									<td width="30%">Compass Reference No</td>
									<td width="70%">
										<input class="form-control input-sm" id="COMPASSREFERENCENO${UNQID}" name="COMPASSREFERENCENO"/>
									</td>
								</tr>
								<tr>
									<td width="30%">Customer Id (GBASE Cust Abbr)</td>
									<td width="70%">
										<input class="form-control input-sm" id="CCIFNO${UNQID}" name="CCIFNO"/>
									</td>
								</tr>
								<tr>
									<td width="30%">Customer Name</td>
									<td width="70%">
										<input class="form-control input-sm" id="CUSTOMERNAME${UNQID}" name="CUSTOMERNAME"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<input type="hidden" name="UNQID" value="${UNQID}"/>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button  type="button" id="searchCDDForm${UNQID}" class="btn btn-success btn-sm">Search</button>
					<c:if test="${CURRENTROLE eq 'ROLE_BPAMAKER'}">
						<button  type="button" id="createNewCDDForm${UNQID}" class="btn btn-primary btn-sm">Create New</button>
					</c:if>
				</div>
			</div>
		</div>
		<div class="card card-primary" id="panelCDDForm${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">CDD & Risk Rating Search Result</h6>
			</div>
			<div id="CDDRiskRatingSerachResult${UNQID}"></div>
		</div>
	</div>
</div>