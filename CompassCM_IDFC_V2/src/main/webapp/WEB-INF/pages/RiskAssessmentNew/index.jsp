<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/chart.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		$("#createNewRiskAssessment"+id).click(function(){
			var ASSESSMENTUNIT = $("#ASSESSMENTUNIT").val();
			if(ASSESSMENTUNIT != null && ASSESSMENTUNIT != ""){
				if(confirm("Are you sure you want to Create a New Risk Assessment?")){
					$(this).html("Creating...");
					$(this).attr("disabled","disabled");
					$.ajax({
						url : "${pageContext.request.contextPath}/common/openNewRiskAssessmentNew",
						type : "POST",
						cache : false,
						data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ISNEWFORM=Y",
						success : function(res){
							$(".compassrow"+id).html(res);
						},
						error : function(){
							alert("Error while opening form");
						}
					});
				}
			}else{
				alert("Please select an assessment unit to proceed.");
			}
		});
		$("#searchRiskAssessmentSummary").click(function(){
			var assessmentPeriod = $("#assessmentPeriod").val();
			if(assessmentPeriod != null && assessmentPeriod != ""){
				$(this).html("Collecting data...");
				$.ajax({
					url : "${pageContext.request.contextPath}/common/getRiskAssessmentSummary",
					type : "GET",
					cache : false,
					data : "assessmentPeriod="+assessmentPeriod,
					success : function(res){
						$(".compassrow"+id).html(res);
					},
					error : function(){
						alert("Error while collecting summary data");
						$("#searchRiskAssessmentSummary").html("Get Summary");
					}
				});
				
			}else{
				alert("Please provide assessment period to proceed. ex: 2022");
				
			}
		});
		
		$("#generateRiskAssessmentSummary").click(function(elm){
			var assessmentPeriod = $("#assessmentPeriod").val();
			//var compassRefNo= "CM020520221814";
			console.log("assessmentPeriod: ",assessmentPeriod)
			if(assessmentPeriod != null && assessmentPeriod != ""){
				 if(confirm("Are you sure you want to Generate Excel Report?")){
					  $.ajax({
							url : "${pageContext.request.contextPath}/common/mixedChartSummary?ASSESSMENTPERIOD="+assessmentPeriod,
							type : "POST",
							cache : false,
							success : function(res){defalutValueChartDiv
								document.getElementById("defalutValueChartDiv").style.display = "block";
								document.getElementById("residualRiskChartDiv").style.display = "block";
								document.getElementById("tResidualRiskChartDiv").style.display = "block";
								document.getElementById("rlResidualRiskChartDiv").style.display = "block";
								document.getElementById("raResidualRiskChartDiv").style.display = "block";
								document.getElementById("wbResidualRiskChartDiv").style.display = "block";
								document.getElementById("assessmentWiseCatChartDiv").style.display = "block";
								$("#defalutValueChartDiv").html(res);
								$("#residualRiskChartDiv").html(res);
								$("#tResidualRiskChartDiv").html(res);
								$("#rlResidualRiskChartDiv").html(res);
								$("#raResidualRiskChartDiv").html(res);
								$("#wbResidualRiskChartDiv").html(res);
								$("#assessmentWiseCatChartDiv").html(res);
								
								
								//MIXED CHART NEW DATA
								var defalutValueData = $("#defalutValueURL").val();
								var residualRiskData = $("#residualRiskURL").val();
								var t_ResidualRiskData = $("#tResidualRiskURL").val();
								var rl_ResidualRiskData = $("#rlResidualRiskURL").val();
								var ra_ResidualRiskData = $("#raResidualRiskURL").val();
								var wb_ResidualRiskData = $("#wbResidualRiskURL").val();
								var assessmentWiseCatData = $("#assessmentCatURL").val();
								
								var bl_IR = $("#residualRiskURL").val();
								var bl_IC = $("#assessmentCatURL").val();
								
								var A_TOTALWEIGHTEDSCOREIR = 0.0;
								var A_TOTALWEIGHTEDSCOREIC = 0.0;
								
								var totalTresuryIR = $("#totalTresuryIR").val();
								var totalTresuryIC = $("#totalTresuryIC").val();
								var totalRetailLiabiltiesIR = $("#totalRetailLiabiltiesIR").val();
								var totalRetailLiabiltiesIC = $("#totalRetailLiabiltiesIC").val();
								var totalRetailAssetsIR = $("#totalRetailAssetsIR").val();
								var totalRetailAssetsIC = $("#totalRetailAssetsIC").val();
								var totalWholesaleIR = $("#totalWholesaleIR").val();
								var totalWholesaleIC = $("#totalWholesaleIC").val();
								/* console.log("totalTresuryIR: "+totalTresuryIR+" "+"totalTresuryIC: "+totalTresuryIC+
										"totalRetailLiabiltiesIR: "+totalRetailLiabiltiesIR+" "+"totalRetailLiabiltiesIC: "+totalRetailLiabiltiesIC+
										"totalRetailAssetsIR: "+totalRetailAssetsIR+" "+"totalRetailAssetsIC: "+totalRetailAssetsIC+
										"totalWholesaleIR: "+totalWholesaleIR+" "+"totalWholesaleIC: "+totalWholesaleIC) */
								
								
								var data = defalutValueData+"@~@"+residualRiskData+"@~@"+t_ResidualRiskData+"@~@"+rl_ResidualRiskData
											+"@~@"+ra_ResidualRiskData+"@~@"+wb_ResidualRiskData+"@~@"+assessmentWiseCatData+"@~@"+bl_IR+"@~@"+bl_IC
											+"@~@"+A_TOTALWEIGHTEDSCOREIR+"@~@"+A_TOTALWEIGHTEDSCOREIC+"@~@"
											+totalTresuryIR+"@~@"+totalTresuryIC+"@~@"+totalRetailLiabiltiesIR+"@~@"+totalRetailLiabiltiesIC+"@~@"
											+totalRetailAssetsIR+"@~@"+totalRetailAssetsIC+"@~@"+totalWholesaleIR+"@~@"+totalWholesaleIC;
								
								document.getElementById("defalutValueChartDiv").style.display = "none";
								document.getElementById("residualRiskChartDiv").style.display = "none";
								document.getElementById("assessmentWiseCatChartDiv").style.display = "none";
								
								$.ajax({
										url : "${pageContext.request.contextPath}/common/saveChartImageNew",
										type : "POST",
										cache : false,
										data: JSON.stringify({"data":data}),
										success : function(res){
											//alert("DATA SAVED SUCCESSFULLY!!");
											$.fileDownload("${pageContext.request.contextPath}/common/generateCMReportSummary?ASSESSMENTPERIOD="+assessmentPeriod+"&imageId="+res , {
											    httpMethod : "GET",
											    successCallback: function (url) {	
													alert("done")
											    	$(elm).html("Downloaded");
													btn.prop('disabled', false);
											    },
											    failCallback: function (html, url) {
											    	btn.prop('disabled', false);
											    	alert('Failed to download file'+url+"\n"+html);
											    }
											});											
										},
										error : function(){
											alert("Error while opening form");
										}
									}); 
							},
							error : function(){
								alert("Error while opening form");
							}
						});  
					 
				 }	 	
				
			}else{
				alert("Please provide assessment period to proceed. ex: 2022");
				
			}
		});
		
		$("#searchRiskAssessment").click(function(){
			var ASSESSMENTUNIT = $("#ASSESSMENTUNIT").val();
			var COMPASSREFERENCENO = $("#COMPASSREFERENCENO"+id).val();
			if((ASSESSMENTUNIT != null && ASSESSMENTUNIT != "")||(COMPASSREFERENCENO != null && COMPASSREFERENCENO != "")){
				$.ajax({
					url : "${pageContext.request.contextPath}/common/searchRiskAssessmentNew",
					type : "POST",
					cache : false,
					data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&COMPASSREFERENCENO="+COMPASSREFERENCENO,
					success : function(res){
						$("#panelRAForm"+id).css("display", "block");
						$("#riskAssessmentNewSerachResult"+id).html(res);
					},
					error : function(){
						alert("Error while opening form");
					}
				});
			}else{
				alert("Please select an assessment unit or enter a compass reference number to proceed.");
			}
		});
	});
	
	function continueRA(elm){
		var id = '${UNQID}';
		var compassRefNo = $(elm).attr("compassRefNo");
		var  assessmentUnit = $(elm).attr("assessmentUnit");
		//alert(compassRefNo);
		$(elm).html("Starting...");
		$.ajax({
			url : "${pageContext.request.contextPath}/common/openNewRiskAssessmentNew",
			type : "POST",
			cache : false,
			data :  "ASSESSMENTUNIT="+assessmentUnit+"&CMREFNO="+compassRefNo+"&ISNEWFORM=N",
			success : function(res){
				//alert(res);
				//console.log(res);
				$(".compassrow"+id).html(res);
			},
			error : function(){
				alert("Error while opening form");
			}
		}); 
	}
	
	function generateRAReport(elm){
		var id = '${UNQID}';
		var compassRefNo = $(elm).attr("compassRefNo");
		var assessmentUnit = $(elm).attr("assessmentUnit");
		var fromDate = "01/01/2000";
		 
		 if(confirm("Are you sure you want to Generate Excel Report?")){
			  $.ajax({
					url : "${pageContext.request.contextPath}/common/mixedChartNew?CRMREFNO="+compassRefNo,
					type : "POST",
					cache : false,
					success : function(res){
						document.getElementById("residualRiskChartDiv").style.display = "block";
						document.getElementById("assessmentWiseCatChartDiv").style.display = "block";
						$("#residualRiskChartDiv").html(res);
						$("#assessmentWiseCatChartDiv").html(res);
						
						
						//MIXED CHART NEW DATA
						var residualRiskData = $("#residualRiskURL").val();
						var assessmentWiseCatData = $("#assessmentCatURL").val();
						
						var totalWeightedScoreIR = $("#totalWeightedScoreIR").val();
						var totalWeightedScoreIC = $("#totalWeightedScoreIC").val();
						
						var totalTresuryIR = 0.0;
						var totalTresuryIC = 0.0;
						var totalRetailLiabiltiesIR = 0.0;
						var totalRetailLiabiltiesIC = 0.0;
						var totalRetailAssetsIR = 0.0;
						var totalRetailAssetsIC = 0.0;
						var totalWholesaleIR = 0.0;
						var totalWholesaleIC = 0.0;
						//console.log("totalWeightedScoreIR: "+totalWeightedScoreIR+" "+"totalWeightedScoreIC: "+totalWeightedScoreIC)
						
						var defalutValueData = "NO DATA AVAILABLE";
						var bl_IR = $("#residualRiskURL").val();
						var bl_IC = $("#assessmentCatURL").val();
						
						//var data = defalutValueData+"@~@"+residualRiskData+"@~@"+assessmentWiseCatData+"@~@"+totalWeightedScoreIR+"@~@"+totalWeightedScoreIC;
						
						
						var data = defalutValueData+"@~@"+residualRiskData+"@~@"+assessmentWiseCatData+"@~@"+bl_IR+"@~@"+bl_IC
						+"@~@"+totalWeightedScoreIR+"@~@"+totalWeightedScoreIC+"@~@"
						+totalTresuryIR+"@~@"+totalTresuryIC+"@~@"+totalRetailLiabiltiesIR+"@~@"+totalRetailLiabiltiesIC+"@~@"
						+totalRetailAssetsIR+"@~@"+totalRetailAssetsIC+"@~@"+totalWholesaleIR+"@~@"+totalWholesaleIC;
						
						
						//var data = residualRiskData+"@~@"+assessmentWiseCatData+"@~@"+totalWeightedScoreIR+"@~@"+totalWeightedScoreIC;
						document.getElementById("residualRiskChartDiv").style.display = "none";
						document.getElementById("assessmentWiseCatChartDiv").style.display = "none";
						
						$.ajax({
								url : "${pageContext.request.contextPath}/common/saveChartImageNew",
								type : "POST",
								cache : false,
								data: JSON.stringify({"data":data}),
								success : function(res){
									//alert("DATA SAVED SUCCESSFULLY!!");
									$.fileDownload("${pageContext.request.contextPath}/common/generateCMReportNew?compassRefNo="+compassRefNo+"&imageId="+res+"&assessmentUnit="+assessmentUnit , {
									    httpMethod : "GET",
									    successCallback: function (url) {	
											alert("done")
									    	$(elm).html("Downloaded");
											btn.prop('disabled', false);
									    },
									    failCallback: function (html, url) {
									    	btn.prop('disabled', false);
									    	alert('Failed to download file'+url+"\n"+html);
									    }
										 });
									
									
								},
								error : function(){
									alert("Error while opening form");
								}
							}); 
					},
					error : function(){
						alert("Error while opening form");
					}
				});  
			 
		 }	 
	}
	
	
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_CDDForm">
			<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Assessment Summary</h6>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
					 <div class="card-search-card" >
						<table class="table table-striped formSearchTable cddForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
								<tr>
									
									<td width="20%">Assessment Period</td>
									<td width="25%">
										<input class="form-control input-sm" type = 'number' id="assessmentPeriod" name="assessmentPeriod"/>
									</td>
									<td style="width: 10%">&nbsp;</td>
									<td style="width: 20%">&nbsp;</td>
									<td style="width: 250%">&nbsp;</td>
								</tr>
							</tbody>
						</table>
					</div> 
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="generateRiskAssessmentSummary" class="btn btn-success btn-sm">Generate Summary</button>
					<button type="button" id="searchRiskAssessmentSummary" class="btn btn-primary btn-sm">Get Summary</button>
				</div>
			</div>
		</div>
		
		<div class="card card-primary panel_CDDForm">
			<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Assessment</h6>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
					 <div class="card-search-card" >
						<table class="table table-striped formSearchTable cddForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
								<tr>
									<td style="width: 20%">Assessment Unit</td>
									<td style="width: 25%">
										<select class="form-control input-sm" id="ASSESSMENTUNIT" name="ASSESSMENTUNIT">
											<option value="">Select Assessment Unit</option>
											<c:forEach var="assessmentUnit" items="${ASSESSMENTUNITS}">
												<option value="${assessmentUnit}">${assessmentUnit}</option>
											</c:forEach>
											<option value="Treasury">Treasury</option>
											<option value="RetailLiabilities">Retail Liabilities</option>
											<option value="RetailAssets">Retail Assets</option>
											<option value="WholesaleBanking">Wholesale Banking</option>
										</select>
									</td>
									<td style="width: 10%">&nbsp;</td>
									<td width="20%">Compass Reference No</td>
									<td width="25%">
										<input class="form-control input-sm" id="COMPASSREFERENCENO${UNQID}" name="COMPASSREFERENCENO"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div> 
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="searchRiskAssessment" class="btn btn-success btn-sm">Search</button>
					<c:if test = "${CURRENTROLE eq 'ROLE_CM_OFFICER'}">
						<button type="button" id="createNewRiskAssessment${UNQID}" class="btn btn-primary btn-sm">Create New</button>
					</c:if>
				</div>
			</div>
		</div>
		
		<div class="card card-primary" id="panelRAForm${UNQID}" style="display: none;">
			<div class="card-header panelSlidingRAForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Assessment Search Result</h6>
			</div>
			<div id="riskAssessmentNewSerachResult${UNQID}"></div>
		</div>
	</div>
</div>

<div id = "defalutValueChartDiv" style="display: block"></div>
<div id = "residualRiskChartDiv" style="display: block"></div>
<div id = "tResidualRiskChartDiv" style="display: block"></div>
<div id = "rlResidualRiskChartDiv" style="display: block"></div>
<div id = "raResidualRiskChartDiv" style="display: block"></div>
<div id = "wbResidualRiskChartDiv" style="display: block"></div>
<div id = "assessmentWiseCatChartDiv" style="display: block"></div>