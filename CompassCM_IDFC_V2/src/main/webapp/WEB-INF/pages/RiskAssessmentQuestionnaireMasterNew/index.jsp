<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script>history.scrollRestoration = "manual"</script>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';

		$("#configQuestions"+id).click(function(){
			var ASSESSMENTUNIT = $("#ASSESSMENTUNIT"+id).val();
			if((ASSESSMENTUNIT != null && ASSESSMENTUNIT != "")){
				$.ajax({
					url : "${pageContext.request.contextPath}/common/questionConfigurationForm",
					type : "POST",
					cache : false,
					data : "ASSESSMENTUNIT="+ASSESSMENTUNIT,
					success : function(res){
						
						$("#questionsConfigFormSection"+id).html(res);
						$(".selectpicker").selectpicker();
					},
					error : function(){
						alert("Error while opening form");
					}
				});
			}else{
				alert("Please select an assessment unit to proceed.");
			}
		});
	});
	

</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
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
									<td style="width: 20%">Business Unit</td>
									<td style="width: 25%">
										<select class="form-control input-sm" id="ASSESSMENTUNIT${UNQID}" name="ASSESSMENTUNIT">
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
									<td width="20%"></td>
									<td width="25%"></td>
								</tr>
							</tbody>
						</table>
					</div> 
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="configQuestions${UNQID}" class="btn btn-success btn-sm">Configure Questions</button>
					
				</div>
			</div>
		</div>
		
	</div>
</div>
<div id="questionsConfigFormSection${UNQID}"></div>

