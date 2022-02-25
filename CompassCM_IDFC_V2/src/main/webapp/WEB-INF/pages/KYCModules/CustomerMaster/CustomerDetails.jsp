<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
//System.out.println(userRole);
%>
<c:set var="MODULEDETAILS" value="${MODULEDETAILS}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>
<c:set var="STATUS" value="${status}"/>
<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	/* .datepicker{
		background-image:url("../../images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} */
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalDetailsTable'+id;
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			//dateFormat: _dateFormat
		});
		
		$("#searchModuleDetails"+id).click(function(){
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			var moduleValue = $("#moduleValue"+id).val();
			var detailPage = $("#detailPage"+id).val();
			if(childWindow == "1"){
				searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage);
			}else{
				if($("#compassGenericModal").hasClass("show")){
					openDetails($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}else{
					openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}
			}
			
		});
		
		$("#moduleValue"+id).keydown(function(event){
	        if(event.which=="13")
	        	$("#searchModuleDetails"+id).click();
		});
		
		$("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
		
		$("#updateCustomerEntityEnrichment"+id).click(function(){
			var customerId = '${moduleValue}';
			var fieldsData = "";
			var status = 'P';
			var commentsData = "";
			var domesticPepFlagData = "";
			
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				domesticPepFlagData = domesticPepFlagData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(npoFlagData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			
			fieldsData = domesticPepFlagData+fieldsData+commentsData;
			//alert(fieldsData);
			
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerEntityEnrichment",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		});
		
		$("#approveEntityEnrichmentDetails").click(function(){
			var customerId = '${moduleValue}';
			var fieldsData = "";
			var status = 'A';
			var commentsData = "";
			var npoFlagData = "";
			
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				npoFlagData = npoFlagData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(npoFlagData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});

			fieldsData = npoFlagData+fieldsData+commentsData;
			/* alert(fieldsData);
			alert(status);
			alert(customerId); */
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerEntityEnrichment",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		});
		
		$("#rejectEntityEnrichmentDetails").click(function(){
			var customerId = '${moduleValue}';
			var fieldsData = "";
			var status = 'R';
			var commentsData = "";
			var npoFlagData = "";
			
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				npoFlagData = npoFlagData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(npoFlagData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});

			fieldsData = npoFlagData+fieldsData+commentsData;
			/* alert(fieldsData);
			alert(status);
			alert(customerId); */
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerEntityEnrichment",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		});
		
		$("#updateCustomerOverRideRiskDetails").click(function(){
			var customerId = '${moduleValue}';
			var status = 'P';
			var fieldsData = "";
			var riskRatingAndSegmentData = "";
			var commentsData = "";
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				riskRatingAndSegmentData = riskRatingAndSegmentData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(riskRatingAndSegmentData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			
			fieldsData = fieldsData+riskRatingAndSegmentData+commentsData;
			
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerOverRideRiskDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		});
		
		$("#approveCustomerOverRideRiskDetails").click(function(){
			var customerId = '${moduleValue}';
			var status = 'A';
			var fieldsData = "";
			var riskRatingData = "";
			var commentsData = "";
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				riskRatingData = riskRatingData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(riskRatingData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});

			fieldsData = fieldsData+riskRatingData+commentsData;
			/* alert(fieldsData);
			alert(status);
			alert(customerId); */
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerOverRideRiskDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	}); 
		});
		
		$("#rejectCustomerOverRideRiskDetails").click(function(){
			var customerId = '${moduleValue}';
			var status = 'R';
			var fieldsData = "";
			var riskRatingData = "";
			var commentsData = "";
			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				riskRatingData = riskRatingData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(riskRatingData);
			});
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			fieldsData = fieldsData+riskRatingData+commentsData;
			
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateCustomerOverRideRiskDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&customerId="+customerId,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    			$('#compassGenericModal').modal('hide');
	    		},
	    		error : function(){
	    			$("#createUserSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		});

		if(${(CURRENTROLE eq 'ROLE_AMLO')}){
			if($("#overrideRiskratingSegment").val() == "STR"){
				$("#overrideRiskrating").val("3");
				$("#overrideRiskrating").attr("disabled",true);
			}else{
				$("#overrideRiskrating").attr("disabled",false);
			}
		}else{
			$("#overrideRiskrating").attr("disabled",true);
		}
		
		$("#overrideRiskratingSegment").on("change",function(){
			if($(this).val() == "STR"){
				$("#overrideRiskrating").val("3");
				$("#overrideRiskrating").attr("disabled",true);
			}else{
				$("#overrideRiskrating").attr("disabled",false);
			}
		});
	});
	
	function openDocDetails(elm){
		var docCode = $(elm).parent("tr").children("td:nth-child(3)").html();
		var customerId = '${moduleValue}';

		window.open("${pageContext.request.contextPath}/common/getDocumentFromWSDL?docCode="+docCode+"&customerId="+customerId);
		
		//alert(docCode);
		/*
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getDocumentFromWSDL",
			cache: false,
			type: "POST",
			data: "docCode="+docCode+"&customerId="+customerId,
			success: function(res){
				alert(res);
				//$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
		*/
	}
</script>
<style type="text/css">
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<div class="container" style="width: 100%;">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
				<div class="row">
					<div class="col-sm-3"></div>
					<div class="col-sm-6">
						<div class="card-body" style="text-align: center; padding: 5px 0px;">
							<input type="hidden" name="moduleCode" id="moduleCode${UNQID}" value="${moduleCode}"/>
							<input type="hidden" name="detailPage" id="detailPage${UNQID}" value="${detailPage}"/>
							<input type="hidden" name="moduleHeader" id="moduleHeader${UNQID}" value="${moduleHeader}"/>
							<table class="table compassModuleDetailsSearchTable" style="margin-bottom: 0px;">
								<tr>
									<td width="30%"><spring:message code="app.common.CUSTOMERID"/></td>
									<td width="40%"><input type="text" class="form-control input-sm" name="moduleValue" id="moduleValue${UNQID}" value="${moduleValue}"/></td>
									<td width="30%"><button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button></td>
								</tr>
							</table>
						</div>
					</div>
					<div class="col-sm-3"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
	<ul class="nav nav-pills modalNav" role="tablist">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<li role="presentation"
				<a class="subTab nav-link <c:if test='${tabIndex.index == 0}'>active</c:if>" href="#${moduleCode}${UNQID}${tabIndex.index}" aria-controls="tab" role="tab" data-toggle="tab">${tab}</a>
			</li>
		</c:forEach>
	</ul>
	<div class="tab-content">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<div role="tabpanel" class="tab-pane <c:if test="${tabIndex.index == 0}">active</c:if>" id="${moduleCode}${UNQID}${tabIndex.index}">
				<c:set var="tabIndex">${tabIndex.index}</c:set>
				<c:set var="tabDetail" value="${MODULEDETAILS[tabIndex]}"/>
				<c:set var="RECORDCOUNT" value="${f:length(tabDetail)}" scope="page"/>
				<c:choose>
					<c:when test="${TABDISPLAY[tabIndex] eq 'T'}">
						<c:choose>
							<c:when test="${RECORDCOUNT > 0}">
								<table class="table table-striped table-bordered searchResultGenericTable modalDetailsTable${UNQID}">
									<thead>
										<c:forEach var="recordDetails" items="${tabDetail}" begin="0" end="0">
											<tr>
												<c:forEach var="fieldDetails" items="${recordDetails}">
													<c:set var="colArray" value="${f:split(fieldDetails.key, '.')}" />
													<c:set var="colArrayCnt" value="${f:length(colArray)}" />
													<th id="${colArray[colArrayCnt-1]}"><spring:message code="${fieldDetails.key}"/></th>
												</c:forEach>
											</tr>
										</c:forEach>
									</thead>
									<tbody>
										<c:forEach var="recordDetails" items="${tabDetail}">
											<tr>
												<c:forEach var="fieldDetails" items="${recordDetails}">
													<td data-toggle="tooltip" data-placement="auto"  title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
												</c:forEach>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</c:when>
							<c:otherwise>
								<br/>
								<center>
								No ${tab} Record Found
								</center>
								<br/>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
							<c:choose>
								<c:when test="${tab eq 'Entity Enrichment'}">
									<c:forEach var="fieldDeatails" items="${tabDetail}">
										<table class="table table-striped" style="margin-bottom: 0px;">
											<tbody>
												<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
												<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
												<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
												<c:if test="${(CURRENTROLE eq 'ROLE_AMLO')}">
													<c:choose>
														<c:when test="${(LABELSITRCOUNT % 2 == 0)}">
															<tr>
																<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ISDOMESTICPEP') || (ALLLABELSMAP.key eq 'app.common.ISDOMESTICPEP_MAKER')}">
																	<td width="25%">
																		<select class="form-control input-sm" name="${ALLLABELSMAP.key}">
																			<option value="">Select</option>
																			<option value="Y" <c:if test="${ALLLABELSMAP.value eq 'Y'}">selected="selected"</c:if>>Yes</option>
																			<option value="N" <c:if test="${ALLLABELSMAP.value eq 'N'}">selected="selected"</c:if>>No</option>
																		</select>
																	</td>
																</c:if>
				
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERDATE') || (ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCODE') 
																	|| (ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCODE') || (ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERDATE')}">
																	<td width="25%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key ne 'app.common.ISDOMESTICPEP') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCOMMENTS') 
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCOMMENTS') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERDATE')
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCODE') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERDATE') 
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCODE')}">
																	<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}"/>
																		</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<c:if test="${ALLLABELSMAP.value eq 'P'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Pending" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'A'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Approved" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'R'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Rejected" disabled="disabled"/>
																			</c:if>
																		</td>
																	</c:if>
																</c:if>
																<td width="10%">&nbsp;</td>
														</c:when>
														<c:otherwise>
																<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ISDOMESTICPEP') || (ALLLABELSMAP.key eq 'app.common.ISDOMESTICPEP_MAKER')}">
																	<td width="25%">
																		<select class="form-control input-sm" name="${ALLLABELSMAP.key}">
																			<option value="">Select</option>
																			<option value="Y" <c:if test="${ALLLABELSMAP.value eq 'Y'}">selected="selected"</c:if>>Yes</option>
																			<option value="N" <c:if test="${ALLLABELSMAP.value eq 'N'}">selected="selected"</c:if>>No</option>
																		</select>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERDATE') || (ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCODE') 
																	|| (ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCODE') || (ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERDATE')}">
																	<td width="25%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key ne 'app.common.ISDOMESTICPEP') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCOMMENTS') 
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCOMMENTS') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERDATE')
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCODE') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERDATE') 
																	&& (ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCODE')}">
																	<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}"/>
																		</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<c:if test="${ALLLABELSMAP.value eq 'P'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Pending"  disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'A'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Approved"  disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'R'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Rejected"  disabled="disabled"/>
																			</c:if>
																		</td>
																	</c:if>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
															</tr>
														</c:otherwise>
													</c:choose>
													</c:if>
													<c:if test="${(CURRENTROLE eq 'ROLE_MLRO')}">
													<c:choose>
														<c:when test="${(LABELSITRCOUNT % 2 == 0)}">
															<tr>
																<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																
																<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCOMMENTS') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																		</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<c:if test="${ALLLABELSMAP.value eq 'P'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Pending" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'A'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Approved" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'R'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Rejected" disabled="disabled"/>
																			</c:if>
																		</td>
																	</c:if>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<td width="10%">&nbsp;</td>
														</c:when>
														<c:otherwise>
																<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																
																<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTMAKERCOMMENTS') && (ALLLABELSMAP.key ne 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<c:if test="${(ALLLABELSMAP.key ne 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																		</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTSTATUS')}">
																		<td width="25%">
																			<c:if test="${ALLLABELSMAP.value eq 'P'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Pending" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'A'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Approved" disabled="disabled"/>
																			</c:if>
																			<c:if test="${ALLLABELSMAP.value eq 'R'}">
																				<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="Rejected" disabled="disabled"/>
																			</c:if>
																		</td>
																	</c:if>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTCHECKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
																
																<c:if test="${(ALLLABELSMAP.key eq 'app.common.ENRICHMENTMAKERCOMMENTS')}">
																	<td width="25%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																</c:if>
															</tr>
														</c:otherwise>
													</c:choose>
													</c:if>
													<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
												</c:forEach>
												<c:if test="${LABELSITRCOUNT % 2 != 0}">
														<td width="15%">&nbsp;</td>
														<td width="30%">&nbsp;</td>
													</tr>
												</c:if>
											</tbody>
										</table>
										<c:if test="${(CURRENTROLE eq 'ROLE_AMLO')}">
											<div class="card-footer">
												<div style="margin-left: 95%">
													<button type="button" class="btn btn-primary btn-sm" id="updateCustomerEntityEnrichment${UNQID}">Update</button>
												</div>
											</div>
										</c:if>
										<c:if test="${(CURRENTROLE eq 'ROLE_MLRO')}">
											<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
												<c:set var="columnName" value="${ALLLABELSMAP.key}"></c:set>
												<c:set var="columnValue" value="${ALLLABELSMAP.value}"></c:set>
												<c:if test="${f:contains(columnName, 'app.common.ENRICHMENTSTATUS')}">
													<c:if test="${f:contains(columnValue, 'P')}">
														<div class="card-footer clearfix">
														<div class="pull-right">
															<button type="button" class="btn btn-success btn-sm" id="approveEntityEnrichmentDetails">Approve</button>
															<button type="button" class="btn btn-danger btn-sm" id="rejectEntityEnrichmentDetails">Reject</button>
														</div>
														</div>
													</c:if>
													<c:if test="${not f:contains(columnValue, 'P')}">
														<div class="card-footer clearfix">
														<div class="pull-right">
															<button type="button" class="btn btn-success btn-sm" id="approveEntityEnrichmentDetails" disabled="disabled">Approve</button>
															<button type="button" class="btn btn-danger btn-sm" id="rejectEntityEnrichmentDetails" disabled="disabled">Reject</button>
														</div>
														</div>
													</c:if>
												</c:if>
											</c:forEach>
										</c:if>
									</c:forEach>
								</c:when>							
								<c:when test="${tab eq 'OverRide RiskRating'}">
									<c:forEach var="fieldDeatails" items="${tabDetail}">
										<table class="table table-striped">
											<tbody>
												<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
												<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
												<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
													<%-- <c:if test="${(CURRENTROLE eq 'ROLE_AMLUSER')}"> --%>
													<c:if test="${f:containsIgnoreCase(CURRENTROLE,'ROLE_AMLUSER')}">
														<c:choose>
															<c:when test="${LABELSITRCOUNT % 2 == 0}">
																<tr>
																	<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGMAKERDATE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGCHECKERDATE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING_SEGMENT')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskratingSegment" name="${ALLLABELSMAP.key}" disabled="disabled">
																			<option value="STR" <c:if test="${ALLLABELSMAP.value eq 'STR'}">selected="selected"</c:if>>STR</option>
																			<option value="HNW" <c:if test="${ALLLABELSMAP.value eq 'HNW'}">selected="selected"</c:if>>HNW</option>
																			<option value="NRI" <c:if test="${ALLLABELSMAP.value eq 'NRI'}">selected="selected"</c:if>>NRI</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled" >${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<td width="10%">&nbsp;</td>
															</c:when>
															<c:otherwise>
																	<c:if test="${ALLLABELSMAP.key ne 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskrating" name="${ALLLABELSMAP.key}" disabled="disabled">
																			<option value="1" <c:if test="${ALLLABELSMAP.value eq '1'}">selected="selected"</c:if>>1-LOW</option>
																			<option value="2" <c:if test="${ALLLABELSMAP.value eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
																			<option value="3" <c:if test="${ALLLABELSMAP.value eq '3'}">selected="selected"</c:if>>3-HIGH</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%">&nbsp;</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																	<td width="30%">
																		&nbsp;
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCODE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCODE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																</tr>
															</c:otherwise>
														</c:choose>
													</c:if>
													<c:if test="${(CURRENTROLE eq 'ROLE_AMLO')}">
														<c:choose>
															<c:when test="${LABELSITRCOUNT % 2 == 0}">
																<tr>
																	<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGMAKERDATE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGCHECKERDATE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING_SEGMENT')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskratingSegment" name="${ALLLABELSMAP.key}">
																			<option value="STR" <c:if test="${ALLLABELSMAP.value eq 'STR'}">selected="selected"</c:if>>STR</option>
																			<option value="HNW" <c:if test="${ALLLABELSMAP.value eq 'HNW'}">selected="selected"</c:if>>HNW</option>
																			<option value="NRI" <c:if test="${ALLLABELSMAP.value eq 'NRI'}">selected="selected"</c:if>>NRI</option>
																			<option value="OTHERS" <c:if test="${ALLLABELSMAP.value eq 'OTHERS'}">selected="selected"</c:if>>OTHERS</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<td width="10%">&nbsp;</td>
															</c:when>
															<c:otherwise>
																	<c:if test="${ALLLABELSMAP.key ne 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskrating" name="${ALLLABELSMAP.key}">
																			<option value="1" <c:if test="${ALLLABELSMAP.value eq '1'}">selected="selected"</c:if>>1-LOW</option>
																			<option value="2" <c:if test="${ALLLABELSMAP.value eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
																			<option value="3" <c:if test="${ALLLABELSMAP.value eq '3'}">selected="selected"</c:if>>3-HIGH</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%">&nbsp;</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																	<td width="30%">
																		&nbsp;
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCODE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCODE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																</tr>
															</c:otherwise>
														</c:choose>
													</c:if>
													<%-- <c:if test="${(CURRENTROLE eq 'ROLE_MLRO')}"> --%>
													<c:if test="${f:containsIgnoreCase(CURRENTROLE,'ROLE_MLRO')}">
														<c:choose>
															<c:when test="${LABELSITRCOUNT % 2 == 0}">
																<tr>
																	<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGMAKERDATE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATINGCHECKERDATE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING_SEGMENT')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskratingSegment" name="${ALLLABELSMAP.key} "disabled="disabled">
																			<option value="STR" <c:if test="${ALLLABELSMAP.value eq 'STR'}">selected="selected"</c:if>>STR</option>
																			<option value="HNW" <c:if test="${ALLLABELSMAP.value eq 'HNW'}">selected="selected"</c:if>>HNW</option>
																			<option value="NRI" <c:if test="${ALLLABELSMAP.value eq 'NRI'}">selected="selected"</c:if>>NRI</option>
																			<option value="OTHERS" <c:if test="${ALLLABELSMAP.value eq 'OTHERS'}">selected="selected"</c:if>>OTHERS</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled" >${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCOMMENTS')}">
																	<td width="30%">
																		<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" >${ALLLABELSMAP.value}</textarea>
																	</td>
																	</c:if>
																	<td width="10%">&nbsp;</td>
															</c:when>
															<c:otherwise>
																	<c:if test="${ALLLABELSMAP.key ne 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDERISKRATING')}">
																	<td width="30%">
																		<select class="form-control input-sm" id="overrideRiskrating" name="${ALLLABELSMAP.key}" disabled="disabled">
																			<option value="1" <c:if test="${ALLLABELSMAP.value eq '1'}">selected="selected"</c:if>>1-LOW</option>
																			<option value="2" <c:if test="${ALLLABELSMAP.value eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
																			<option value="3" <c:if test="${ALLLABELSMAP.value eq '3'}">selected="selected"</c:if>>3-HIGH</option>
																		</select>
																	</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																		<td width="15%">&nbsp;</td>
																	</c:if>
																	<c:if test="${ALLLABELSMAP.key eq 'app.common.OVERRIDDINGSTATUS'}">
																	<td width="30%">
																		&nbsp;
																	</td>
																	</c:if>
																	<c:if test="${(ALLLABELSMAP.key eq 'app.common.OVERRIDDINGMAKERCODE') || (ALLLABELSMAP.key eq 'app.common.OVERRIDDINGCHECKERCODE')}">
																	<td width="30%">
																		<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" disabled="disabled"/>
																	</td>
																	</c:if>
																</tr>															
															</c:otherwise>
														</c:choose>
													</c:if>
													<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
												</c:forEach>
												<c:if test="${LABELSITRCOUNT % 2 != 0}">
														<td width="15%">&nbsp;</td>
														<td width="30%">&nbsp;</td>
													</tr>
												</c:if>
											</tbody>
										</table>
										<%-- <c:if test="${(CURRENTROLE eq 'ROLE_AMLUSER')}"> --%>
										<c:if test="${f:containsIgnoreCase(CURRENTROLE,'ROLE_AMLUSER')}">
										<div class="card-footer" style="display: none;">
											<div style="margin-left: 95%">
												<button type="button" class="btn btn-primary btn-sm" id="updateCustomerOverRideRiskDetails">Update</button>
											</div>
										</div>
										</c:if>
										<c:if test="${(CURRENTROLE eq 'ROLE_AMLO')}">
											<div class="card-footer">
											<div style="margin-left: 95%">
												<button type="button" class="btn btn-primary btn-sm" id="updateCustomerOverRideRiskDetails">Update</button>
											</div>
										</div>
										</c:if>
										<%-- <c:if test="${(CURRENTROLE eq 'ROLE_MLRO')}"> --%>
										<c:if test="${f:containsIgnoreCase(CURRENTROLE,'ROLE_MLRO')}">
											<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
												<c:set var="columnName" value="${ALLLABELSMAP.key}"></c:set>
												<c:set var="columnValue" value="${ALLLABELSMAP.value}"></c:set>
												<c:if test="${f:contains(columnName, 'app.common.OVERRIDDINGSTATUS')}">
													<c:if test="${f:contains(columnValue, 'P')}">
														<div class="card-footer clearfix">
														<div class="pull-right">
															<button type="button" class="btn btn-success btn-sm" id="approveCustomerOverRideRiskDetails">Approve</button>
															<button type="button" class="btn btn-danger btn-sm" id="rejectCustomerOverRideRiskDetails">Reject</button>
														</div>
														</div>
													</c:if>
													<c:if test="${not f:contains(columnValue, 'P')}">
														<div class="card-footer clearfix">
														<div class="pull-right">
															<button type="button" class="btn btn-success btn-sm" id="approveCustomerOverRideRiskDetails" disabled="disabled">Approve</button>
															<button type="button" class="btn btn-danger btn-sm" id="rejectCustomerOverRideRiskDetails" disabled="disabled">Reject</button>
														</div>
														</div>
													</c:if>
												</c:if>
											</c:forEach>
										</c:if>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="fieldDeatails" items="${tabDetail}">
										<table class="table table-striped">
											<tbody>
												<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
												<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
												<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
													<c:choose>
														<c:when test="${LABELSITRCOUNT % 2 == 0}">
															<tr>
																<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																<td width="30%">
																	<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
																</td>
																<td width="10%">&nbsp;</td>
														</c:when>
														<c:otherwise>
																<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
																<td width="30%">
																	<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
																</td>
															</tr>
														</c:otherwise>
													</c:choose>
													<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
												</c:forEach>
												<c:if test="${LABELSITRCOUNT % 2 != 0}">
														<td width="15%">&nbsp;</td>
														<td width="30%">&nbsp;</td>
													</tr>
												</c:if>
											</tbody>
										</table>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						
					</c:otherwise>
				</c:choose>				
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>

