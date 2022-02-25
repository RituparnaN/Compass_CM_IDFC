<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
	});
	
	
	}
	
	
	}
	
	
</script>
<style>
td{
text-align:center;
font-size:bold;
}
</style>
<div class="row compassrow${UNQID}" style = "width:98% !important;margin:auto">
	<div style="width:30%;margin:auto;display:flex;flex-direction:row;margin-top:1%;margin-bottom:1%">
			<div style="width:48%;"><Strong>Assessment Period</Strong></div>
			<div style="width:1%;"></div>
			<div style="width:48%;"><input class="form-control input-sm" value = "${assessmentPeriod }" disabled/></div>
	</div>
	<div class="col-sm-12" >
		<div class="card card-primary" >
			<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Assessment Summary</h6>
			</div>
			<div class="panelSearchForm">
				<div class="card card-primary panel_CDDForm">
					
					<div class="panelSearchForm">
						 <div class="card-search-card" >
							<table style = "width:100%;" class="table table-striped">
								<tbody>
									<tr style="background-color: #f66a6a">
										<td rowspan=2>Risk Factor/ Risk Component</td>
										<td colspan = 8>Assessment Unit</td>
									</tr>
									<tr >
										<c:forEach var = "assessmentUnit" items = "${SUMMARYDETAILS['auList'] }">
											<td colspan=2 style="background-color:#f8c059">${assessmentUnit }</td>
										</c:forEach>
									</tr>
									<tr>
										<td style="background-color:#f8c059"> Inherent Risk </td>
										<c:forEach var = "assessmentUnit" items = "${SUMMARYDETAILS['auList'] }">
											<td style="background-color:#93f8ef">score</td>
											<td style="background-color:#93f8ef">result</td>
										</c:forEach>
									</tr>
									<c:forEach var="category" items = "${SUMMARYDETAILS['inherentRiskCategories'] }">
										<tr>
											<td style = "text-align:left">${ category}</td>
											<c:forEach var = "assessmentUnit" items = "${SUMMARYDETAILS['auList'] }">
												<td>${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category] }</td>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category] >= 0 && SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category]  <=5  }">
													<td style = "color:green;background-color:#96f496">Low</td>
												</c:if>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category] > 5 && SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category]  <= 15  }">
													<td style = "color:yellow;background-color:#f2f47c">Medium</td>
												</c:if>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INHERENTRISKS'][category] > 15   }">
													<td style = "color:red; background-color:#f66a6a">High</td>
												</c:if>
											</c:forEach>
										</tr>
									</c:forEach>
									<tr>
										<td style="background-color:#f8c059"> Internal Control </td>
										<c:forEach var = "assessmentUnit" items = "${SUMMARYDETAILS['auList'] }">
											<td style="background-color:#93f8ef">score</td>
											<td style="background-color:#93f8ef">result</td>
										</c:forEach>
									</tr>
									<c:forEach var="category" items = "${SUMMARYDETAILS['internalControlRiskCategories'] }">
										<tr>
											<td style = "text-align:left">${ category}</td>
											
											<c:forEach var = "assessmentUnit" items = "${SUMMARYDETAILS['auList'] }">
												<td>${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category] }</td>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category] >= 0 && SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category]  <=3  }">
													<td style = "color:green;background-color:#96f496">Effictive</td>
												</c:if>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category] > 3 && SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category]  <= 7  }">
													<td style = "color:yellow;background-color:#f2f47c">Needs Improvement</td>
												</c:if>
												<c:if test = "${SUMMARYDETAILS['riskRatings'][assessmentUnit]['INTERNALCONTROLRISKS'][category] > 7   }">
													<td style = "color:red; background-color:#f66a6a">No control</td>
												</c:if>
											</c:forEach>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				
			</div>
		</div>
	</div>
</div>