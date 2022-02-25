<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="MODULEDETAILS" value="${MODULEDETAILS}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>

<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalDetailsTable'+id;
		compassDatatable.construct(tableClass, "TransactionTypeDetails", false);
		
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
		
		$("#updateSubGroupingCodeDetails"+id).click(function(){
			var transactionType = '${moduleValue}';
			var status = 'P';
			var fieldsData = "";
			var subGroupingData = "";
			var commentsData = "";

			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				subGroupingData = subGroupingData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(subGroupingData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			
			fieldsData = fieldsData+subGroupingData+commentsData;
			
			// alert(fieldsData);
			// alert("&status="+status+"&transactionType="+transactionType);
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateSubGroupingCodeDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&transactionType="+transactionType,
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
		
		$("#approveSubGroupingCodeDetails").click(function(){
			var transactionType = '${moduleValue}';
			var status = 'A';
			var fieldsData = "";
			var subGroupingData = "";
			var commentsData = "";

			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				subGroupingData = subGroupingData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(subGroupingData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			
			fieldsData = fieldsData+subGroupingData+commentsData;
			
			//alert(fieldsData);
			//alert("&status="+status+"&transactionType="+transactionType);
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateSubGroupingCodeDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&transactionType="+transactionType,
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
		
		$("#rejectSubGroupingCodeDetails").click(function(){
			var transactionType = '${moduleValue}';
			var status = 'R';
			var fieldsData = "";
			var subGroupingData = "";
			var commentsData = "";

			$(this).parents("div.card-footer").siblings("table").find("input").each(function(){
				fieldsData = fieldsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(fieldsData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("select").each(function(){
				subGroupingData = subGroupingData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(subGroupingData);
			});
			
			$(this).parents("div.card-footer").siblings("table").find("textarea").each(function(){
				commentsData = commentsData + $(this).attr("name") +"="+ $(this).val() + ",";
				//alert(commentsData);
			});
			
			fieldsData = fieldsData+subGroupingData+commentsData;
			
			//alert(fieldsData);
			//alert("&status="+status+"&transactionType="+transactionType);
			$.ajax({
	    		url : "${pageContext.request.contextPath}/common/updateSubGroupingCodeDetails",
	    		data : "fieldsData="+fieldsData+"&status="+status+"&transactionType="+transactionType,
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
		
	});
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
									<td width="30%"><spring:message code="app.common.TRANSACTIONTYPE"/></td>
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
			<li role="presentation">
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
													<c:choose>
														<c:when test="${fieldDetails.value ne ' ' and fieldDetails.value ne ''}">
															<td data-toggle="tooltip" data-placement="auto"  title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
														</c:when>
														<c:otherwise>
															<td>${fieldDetails.value}</td>
														</c:otherwise>
													</c:choose>
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
						<c:forEach var="fieldDeatails" items="${tabDetail}">
							<table class="table table-striped">
								<tbody>
									<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
									<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
									<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
										<c:if test="${f:contains(CURRENTROLE,'ROLE_AMLUSER')}">
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
										</c:if>
										<c:if test="${f:contains(CURRENTROLE,'ROLE_AMLO')}">
										<c:choose>
											<c:when test="${LABELSITRCOUNT % 2 == 0}">
												<tr>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" readonly="readonly"/>
													</td>
													<td width="10%">&nbsp;</td>
											</c:when>
											<c:otherwise>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<c:if test="${ALLLABELSMAP.key eq 'app.common.DESCRIPTION'}">
															<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</c:if>
														<c:if test="${ALLLABELSMAP.key eq 'app.common.SUBGROUPINGCODE'}">
															<select class="form-control input-sm" name="${ALLLABELSMAP.key}">
																<option value="MISC_TXN" <c:if test="${ALLLABELSMAP.value eq 'MISC_TXN'}">selected="selected"</c:if>>MISC_TXN</option>
																<option value="FCY_TXN" <c:if test="${ALLLABELSMAP.value eq 'FCY_TXN'}">selected="selected"</c:if>>FCY_TXN</option>
																<option value="ALTERNATIVE_OTH_TXN" <c:if test="${ALLLABELSMAP.value eq 'ALTERNATIVE_OTH_TXN'}">selected="selected"</c:if>>ALTERNATIVE_OTH_TXN</option>
																<option value="CHQ_CLEARING" <c:if test="${ALLLABELSMAP.value eq 'CHQ_CLEARING'}">selected="selected"</c:if>>CHQ_CLEARING</option>
																<option value="EFT_HIGHVALUE" <c:if test="${ALLLABELSMAP.value eq 'EFT_HIGHVALUE'}">selected="selected"</c:if>>EFT_HIGHVALUE</option>
																<option value="TD_RD_TXNS" <c:if test="${ALLLABELSMAP.value eq 'TD_RD_TXNS'}">selected="selected"</c:if>>TD_RD_TXNS</option>
																<option value="CASH_THIRDPARTY" <c:if test="${ALLLABELSMAP.value eq 'CASH_THIRDPARTY'}">selected="selected"</c:if>>CASH_THIRDPARTY</option>
																<option value="MISC_CHARGES" <c:if test="${ALLLABELSMAP.value eq 'MISC_CHARGES'}">selected="selected"</c:if>>MISC_CHARGES</option>
																<option value="TAX_RELATED_TXN" <c:if test="${ALLLABELSMAP.value eq 'TAX_RELATED_TXN'}">selected="selected"</c:if>>TAX_RELATED_TXN</option>
																<option value="SALARY" <c:if test="${ALLLABELSMAP.value eq 'SALARY'}">selected="selected"</c:if>>SALARY</option>
																<option value="IFT_ATM_NET_MOB" <c:if test="${ALLLABELSMAP.value eq 'IFT_ATM_NET_MOB'}">selected="selected"</c:if>>IFT_ATM_NET_MOB</option>
																<option value="FCY_TXN_RETURNS" <c:if test="${ALLLABELSMAP.value eq 'FCY_TXN_RETURNS'}">selected="selected"</c:if>>FCY_TXN_RETURNS</option>
																<option value="LOAN_RTL_ASSETS" <c:if test="${ALLLABELSMAP.value eq 'LOAN_RTL_ASSETS'}">selected="selected"</c:if>>LOAN_RTL_ASSETS</option>
																<option value="EFT_LOWVALUE" <c:if test="${ALLLABELSMAP.value eq 'EFT_LOWVALUE'}">selected="selected"</c:if>>EFT_LOWVALUE</option>
																<option value="CHQ_RETURNCLEARING" <c:if test="${ALLLABELSMAP.value eq 'CHQ_RETURNCLEARING'}">selected="selected"</c:if>>CHQ_RETURNCLEARING</option>
																<option value="NON_FINANCIAL_TXN" <c:if test="${ALLLABELSMAP.value eq 'NON_FINANCIAL_TXN'}">selected="selected"</c:if>>NON_FINANCIAL_TXN</option>
																<option value="DD_MC" <c:if test="${ALLLABELSMAP.value eq 'DD_MC'}">selected="selected"</c:if>>DD_MC</option>
																<option value="NOT_IN_USE" <c:if test="${ALLLABELSMAP.value eq 'NOT_IN_USE'}">selected="selected"</c:if>>NOT_IN_USE</option>
																<option value="CASH_ATM" <c:if test="${ALLLABELSMAP.value eq 'CASH_ATM'}">selected="selected"</c:if>>CASH_ATM</option>
																<option value="CASH_SUBGROUP" <c:if test="${ALLLABELSMAP.value eq 'CASH_SUBGROUP'}">selected="selected"</c:if>>CASH_SUBGROUP</option>
																<option value="IFT_SUBGROUP" <c:if test="${ALLLABELSMAP.value eq 'IFT_SUBGROUP'}">selected="selected"</c:if>>IFT_SUBGROUP</option>
																<option value="ALTERNATIVE_POS_TXN" <c:if test="${ALLLABELSMAP.value eq 'ALTERNATIVE_POS_TXN'}">selected="selected"</c:if>>ALTERNATIVE_POS_TXN</option>
															</select>
														</c:if>
														<c:if test="${ALLLABELSMAP.key eq 'app.common.MAKERCOMMENTS'}">
															<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}">${ALLLABELSMAP.value}</textarea>
														</c:if>
														<c:if test="${ALLLABELSMAP.key eq 'app.common.CHECKERCOMMENTS'}">
															<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}" disabled="disabled">${ALLLABELSMAP.value}</textarea>
														</c:if>
														<c:if test="${ALLLABELSMAP.key eq 'app.common.STATUS'}">
															<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</c:if>
													</td>
												</tr>
											</c:otherwise>
										</c:choose>
										</c:if>
										<c:if test="${f:contains(CURRENTROLE,'ROLE_MLRO')}">
										<c:choose>
											<c:when test="${LABELSITRCOUNT % 2 == 0}">
												<tr>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" readonly="readonly"/>
													</td>
													<td width="10%">&nbsp;</td>
											</c:when>
											<c:otherwise>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<c:if test="${ALLLABELSMAP.key ne 'app.common.CHECKERCOMMENTS'}">
															<input type="text" class="form-control input-sm" name="${ALLLABELSMAP.key}" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</c:if>
														<c:if test="${ALLLABELSMAP.key eq 'app.common.CHECKERCOMMENTS'}">
															<textarea class="form-control input-sm" name="${ALLLABELSMAP.key}">${ALLLABELSMAP.value}</textarea>
														</c:if>
													</td>
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
							<!--
							<c:if test="${(CURRENTROLE eq 'ROLE_AMLO')}">
								<div class="card-footer">
								<div style="margin-left: 95%">
									<button type="button" class="btn btn-primary btn-sm" id="updateSubGroupingCodeDetails${UNQID}">Update</button>
								</div>
							</div>
							</c:if>
							-->
							<c:if test="${(CURRENTROLE eq 'ROLE_MLRO' || CURRENTROLE eq 'ROLE_MLROL1' || CURRENTROLE eq 'ROLE_MLROL2')}">
								<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
									<c:set var="columnName" value="${ALLLABELSMAP.key}"></c:set>
									<c:set var="columnValue" value="${ALLLABELSMAP.value}"></c:set>
									<!--
									<c:if test="${f:contains(columnName, 'app.common.STATUS')}">
										<c:if test="${f:contains(columnValue, 'P')}">
											<div class="card-footer clearfix">
											<div class="pull-right">
												<button type="button" class="btn btn-success btn-sm" id="approveSubGroupingCodeDetails">Approve</button>
												<button type="button" class="btn btn-danger btn-sm" id="rejectSubGroupingCodeDetails">Reject</button>
											</div>
											</div>
										</c:if>
										<c:if test="${not f:contains(columnValue, 'P')}">
											<div class="card-footer clearfix">
											<div class="pull-right">
												<button type="button" class="btn btn-success btn-sm" id="approveSubGroupingCodeDetails" disabled="disabled">Approve</button>
												<button type="button" class="btn btn-danger btn-sm" id="rejectSubGroupingCodeDetails" disabled="disabled">Reject</button>
											</div>
											</div>
										</c:if>
									</c:if>
									-->
								</c:forEach>
							</c:if>
						</c:forEach>
					</c:otherwise>
				</c:choose>				
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>

