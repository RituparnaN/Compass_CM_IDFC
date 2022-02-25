<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var LISTCODE = $("#RPTLISTCODE"+id).val();
		var mainRow = $("#searchRPTWatchListDetails"+id).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		
		$.ajax({
			url: "${pageContext.request.contextPath}/rptcommon/getRPTWatchListCustomerDetails",
			cache: false,
			type: "POST",
			data : "LISTCODE="+LISTCODE,
			success: function(res){
				$("#panelSlidingRPTWatchListDetails"+id).css("display","block");
				$("#RPTWatchListDetailsSerachResult"+id).html(res);
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
		
		$('.panelSlidingRPTWatchListCustomer'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelSlidingRPTWatchListCustomer');
	    });
		
		$("#searchMasterForm"+id).submit(function(e){
			var LISTCODE = $("#RPTLISTCODE"+id).val();
			var ENTITYNAME = $("#ENTITYNAME"+id).val();
			var IDNO = $("#IDNO"+id).val();
			var CUSTSTATUS = $("#CUSTSTATUS"+id).val();
			
			$.ajax({
				url: "${pageContext.request.contextPath}/rptcommon/getRPTWatchListCustomerDetails",
				cache: false,
				type: "POST",
				data : "LISTCODE="+LISTCODE+"&ENTITYNAME="+ENTITYNAME+"&IDNO="+IDNO+"&CUSTSTATUS="+CUSTSTATUS,
				success: function(res){
					$("#panelSlidingRPTWatchListDetails"+id).css("display","block");
					$("#RPTWatchListDetailsSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
			e.preventDefault();
		});
		
		$("#addEntity"+id).click(function(){
			var ENTITYID = "NEW";
			var LISTNAME = $("#LISTNAME"+id).val();
			$.ajax({
				url: "${pageContext.request.contextPath}/rptmaker/addRPTEntity",
				cache: false,
				type: "POST",
				data : "LISTCODE="+LISTCODE+"&ENTITYID="+ENTITYID+"&LISTNAME="+LISTNAME,
				success: function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#UPDATERPTLIST"+id).click(function(){
			var LISTCODE = $("#RPTLISTCODE"+id).val();
			var LISTNAME= $("#LISTNAME"+id).val();
			var DESCRIPTION = $("#DESCRIPTION"+id).val();
			var LISTTYPE = $("#LISTTYPE"+id).val();
			
			$.ajax({
				url: "${pageContext.request.contextPath}/rptmaker/updateRPTWatchList",
				cache: false,
				type: "POST",
				data : "LISTCODE="+LISTCODE+"&LISTNAME="+LISTNAME+"&DESCRIPTION="+DESCRIPTION+"&LISTTYPE="+LISTTYPE,
				success: function(res){
					alert(res);
					backToRPTWatchList();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
	});
	
	function backToRPTWatchList(){
		var id = '${UNQID}';
		var LISTCODE = $("#RPTLISTCODE"+id).val();
		$.ajax({
			url: "${pageContext.request.contextPath}/rptmaker/openRPTWatchListDetails",
			cache: false,
			type: "POST",
			data : "listCode="+LISTCODE,
			success: function(res){
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	function viewUpdateRPTEntity(elm){
		$(elm).tooltip('hide');
		var id = '${UNQID}';
		var entityId = $(elm).html();
		var LISTNAME = $("#LISTNAME"+id).val();
		var LISTCODE = $("#RPTLISTCODE"+id).val();
		$.ajax({
			url: "${pageContext.request.contextPath}/rptcommon/viewUpdateRPTEntity",
			cache: false,
			type: "POST",
			data : "LISTCODE="+LISTCODE+"&LISTNAME="+LISTNAME+"&ENTITYID="+entityId,
			success: function(res){
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_RPTWatchList">
			<div class="card-header panelSlidingRPTWatchListCustomer${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.rptWatchListHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable rptWatchListDetailsTable${UNQID}" style="margin-bottom: 0px;">
							<tbody>
								<tr>
									<td width="15%">
										<spring:message code="app.common.RPTLISTCODE"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="RPTLISTCODE" id="RPTLISTCODE${UNQID}" value="${RPTDETAILS['app.common.RPTLISTCODE']}" readonly="readonly"/>
									</td>
									<td width="10%">
										
									</td>
									<td width="15%">
										<spring:message code="app.common.LISTNAME"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="LISTNAME" id="LISTNAME${UNQID}" value="${RPTDETAILS['app.common.LISTNAME']}"/>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.DESCRIPTION"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="DESCRIPTION" id="DESCRIPTION${UNQID}" value="${RPTDETAILS['app.common.DESCRIPTION']}"/>
									</td>
									<td width="10%">
										
									</td>
									<td width="15%">
										<spring:message code="app.common.LISTTYPE"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name="LISTTYPE" id="LISTTYPE${UNQID}">
											<option value="NON-INSTITUTIONAL" <c:if test="${RPTDETAILS['app.common.LISTTYPE'] eq 'NON-INSTITUTIONAL'}">selected</c:if>>NON-INSTITUTIONAL</option>
											<option value="INSTITUTIONAL" <c:if test="${RPTDETAILS['app.common.LISTTYPE'] eq 'INSTITUTIONAL'}">selected</c:if>>INSTITUTIONAL</option>
										</select>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.STATUS"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" value="${RPTDETAILS['app.common.STATUS']}" readonly="readonly"/>
									</td>
									<td width="10%">
										
									</td>
									<td width="15%">
										<spring:message code="app.common.ADDEDBY"/> | <spring:message code="app.common.ADDEDON"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" value="${RPTDETAILS['app.common.ADDEDBY']} | ${RPTDETAILS['app.common.ADDEDON']}" readonly="readonly"/>
									</td>
								</tr>
								<security:authorize access="hasRole('ROLE_RPTMAKER')">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" name="UPDATE" id="UPDATERPTLIST${UNQID}" class="btn btn-primary btn-sm">Update</button>
										</td>
									</tr>
								</security:authorize>
								<tr>
									<td width="15%">
										<spring:message code="app.common.ENTITYNAME"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" id="ENTITYNAME${UNQID}" name="ENTITYNAME"/>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.IDNO"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" id="IDNO${UNQID}" name="IDNO"/>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.CUSTSTATUS"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="CUSTSTATUS${UNQID}" name="CUSTSTATUS">
											<option value="ALL">ALL</option>
											<option value="Y-P">Enable : Pending</option>
											<option value="Y-A">Enable : Approved</option>
											<option value="Y-R">Enable : Rejected</option>
											<option value="N-P">Disabled : Pending</option>
											<option value="N-A">Disabled : Approved</option>
											<option value="N-R">Disabled : Rejected</option>
										</select>
									</td>
									<td width="55%" colspan="3">
										&nbsp;
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<button  type="submit" id="searchRPTWatchListDetails${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="card card-primary" id="panelSlidingRPTWatchListDetails${UNQID}" style="display: none;">
			<div class="card-header panelSlidingRPTWatchListCustomer${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.rptWatchListResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="RPTWatchListDetailsSerachResult${UNQID}"></div>
			<security:authorize access="hasRole('ROLE_RPTMAKER')">
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button  type="button" id="addEntity${UNQID}" class="btn btn-success btn-sm">Add Entity</button>
					</div>
				</div>
			</security:authorize>
		</div>
	</div>
</div>
