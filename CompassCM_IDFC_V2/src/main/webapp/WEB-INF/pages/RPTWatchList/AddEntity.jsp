<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="DATA" value="${RPTENTITYDETAILS['DATA'][0]}"/>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var LISTCODE = '${LISTCODE}';
		var ENTITYID = '${ENTITYID}';
		
		$("#backToRPTWatchList"+id).click(function(){
			backToRPTWatchList();
		});
		
		$("#searchMasterForm"+id).submit(function(){
			var formObj = $("#searchMasterForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url: "${pageContext.request.contextPath}/rptmaker/addEntity",
				cache: false,
				type: "POST",
				data : formData,
				success: function(res){
					alert(res);
					backToRPTWatchList();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#removeRPTEntity"+id).click(function(){
			var ENTITYID = $("#ENTITYID"+id).val();
			if(confirm("Are you sure you want to remove the Entity : "+ENTITYID+"?")){
				$.ajax({
					url: "${pageContext.request.contextPath}/rptmaker/removeEntity",
					cache: false,
					type: "POST",
					data : "ENTITYID="+ENTITYID,
					success: function(res){
						alert(res);
						backToRPTWatchList();
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		});
		
		$("#disableRPTEntity"+id).click(function(){
			var ENTITYID = $("#ENTITYID"+id).val();
			if(confirm("Are you sure you want to disable the Entity : "+ENTITYID+"?")){
				$.ajax({
					url: "${pageContext.request.contextPath}/rptmaker/disableEntity",
					cache: false,
					type: "POST",
					data : "ENTITYID="+ENTITYID,
					success: function(res){
						alert(res);
						backToRPTWatchList();
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		});
		
		$("#approveRPTEntity"+id).click(function(){
			var ENTITYID = $("#ENTITYID"+id).val();
			var REMARKS = $("#REMARKS"+id).val();
			if(REMARKS.trim().length > 0){
				if(confirm("Are you sure you want to approve?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/rptadmin/approveEntity",
						cache: false,
						type: "POST",
						data : "ENTITYID="+ENTITYID+"&REMARKS="+REMARKS,
						success: function(res){
							alert(res);
							$("#compassMediumGenericModal").modal("hide");
							navigate('Check List','rptWatchListCheckList','rptadmin/checkList','1');
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			}else{
				alert("Please enter your remarks before you approve");
			}
		});
		
		$("#rejectRPTEntity"+id).click(function(){
			var ENTITYID = $("#ENTITYID"+id).val();
			var REMARKS = $("#REMARKS"+id).val();
			if(REMARKS.trim().length > 0){
				if(confirm("Are you sure you want to reject?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/rptadmin/rejectEntity",
						cache: false,
						type: "POST",
						data : "ENTITYID="+ENTITYID+"&REMARKS="+REMARKS,
						success: function(res){
							if(res.ACTIONSTATUS == '0'){
								alert(res.ACTIONMSG);
								$("#compassMediumGenericModal").modal("hide");
								navigate('Check List','rptWatchListCheckList','rptadmin/checkList','1');
							}else{
								if(confirm(res.ACTIONMSG)){
									toggleStatusUponRejection(res.MOD, ENTITYID);
								}else{
									$("#compassMediumGenericModal").modal("hide");
									navigate('Check List','rptWatchListCheckList','rptadmin/checkList','1');
								}
							}
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			}else{
				alert("Please enter your remarks before you approve");
			}
		});
	});
	
	function toggleStatusUponRejection(status, entityId){
		$.ajax({
			url: "${pageContext.request.contextPath}/rptadmin/toggleStatusUponRejection",
			cache: false,
			type: "POST",
			data : "ENTITYID="+entityId+"&STATUS="+status,
			success: function(res){
				alert(res);
				$("#compassMediumGenericModal").modal("hide");
				navigate('Check List','rptWatchListCheckList','rptadmin/checkList','1');
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	function backToRPTWatchList(){
		var LISTCODE = '${LISTCODE}';
		$.ajax({
			url: "${pageContext.request.contextPath}/rptcommon/openRPTWatchListDetails",
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
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_RPTWatchList">
			<div class="card-header panelSlidingRPTWatchListAddEntity${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.rptWatchListAddEntityHeader"/></h6>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
					<input type="hidden" name="ENTITYID" value="${ENTITYID}" id="ENTITYID${UNQID}"/>
					<input type="hidden" name="LISTNAME" value="${LISTNAME}" id="LISTNAME${UNQID}"/>
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable rptWatchListDetailsTable${UNQID}" style="margin-bottom: 0px;">
							<tbody>
								<tr>
									<td width="15%">
										<spring:message code="app.common.RPTLISTCODE"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="LISTCODE" id="LISTCODE${UNQID}" value="${LISTCODE}" readonly="readonly"/>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.ENTITYNAME"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="ENTITYNAME" id="ENTITYNAME${UNQID}" value="${DATA[3]}" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>/>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.IDTYPE"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name="IDTYPE" id="IDTYPE${UNQID}" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<option value="NIC" <c:if test="${DATA[4] eq 'NIC'}">selected="selected"</c:if>>National ID card</option>
											<option value="PASSPORT" <c:if test="${DATA[4] eq 'PASSPORT'}">selected="selected"</c:if>>Passport</option>
											<option value="DRIVINGLICENCE" <c:if test="${DATA[4] eq 'DRIVINGLICENCE'}">selected="selected"</c:if>>Driving License</option>
											<option value="BUSINESSREGNO" <c:if test="${DATA[4] eq 'BUSINESSREGNO'}">selected="selected"</c:if>>Business Registration</option>
											<option value="BIRTHCERTIFICATE" <c:if test="${DATA[4] eq 'BIRTHCERTIFICATE'}">selected="selected"</c:if>>Birth Certificate</option>
										</select>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.IDNO"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="IDNO" id="IDNO${UNQID}" value="${DATA[5]}" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>/>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.RELATEDTHROUGH"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="RELATEDTHROUGH${UNQID}" name="RELATEDTHROUGH" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<option value="">Select One</option>
											<c:forEach var="ENTITYNAMES" items="${RPTADDENTITYDETAILS['ENTITYNAMES']}">
												<option value="${ENTITYNAMES}"  <c:if test="${DATA[6] eq ENTITYNAMES}">selected="selected"</c:if>>${ENTITYNAMES}</option>
											</c:forEach>
										</select>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.SHAREHOLDING"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="SHAREHOLDING" id="SHAREHOLDING${UNQID}" value="${DATA[7]}" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>/>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.RELATION"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="RELATION${UNQID}" name="RELATION" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<option value="">Select One</option>
											<option value="DIRECTOR" <c:if test="${DATA[8] eq 'DIRECTOR'}">selected="selected"</c:if>>DIRECTOR</option>
											<option value="ALTERNATE DIRECTOR" <c:if test="${DATA[8] eq 'ALTERNATE DIRECTOR'}">selected="selected"</c:if>>ALTERNATE DIRECTOR</option>
											<option value="CHIEF EXECUTIVE OFFICER" <c:if test="${DATA[8] eq 'CHIEF EXECUTIVE OFFICER'}">selected="selected"</c:if>>CHIEF EXECUTIVE OFFICER</option>
											<option value="MCOM MEMBER" <c:if test="${DATA[8] eq 'MCOM MEMBER'}">selected="selected"</c:if>>MCOM MEMBER</option>
							
											<option value="ABOVE 10% SHAREHOLDING WITH DIRECTORSHIP" <c:if test="${DATA[8] eq 'ABOVE 10% SHAREHOLDING WITH DIRECTORSHIP'}">selected="selected"</c:if>>ABOVE 10% SHAREHOLDING WITH DIRECTORSHIP</option>
											<option value="ABOVE 10% SHAREHOLDING WITHOUT DIRECTORSHIP" <c:if test="${DATA[8] eq 'ABOVE 10% SHAREHOLDING WITHOUT DIRECTORSHIP'}">selected="selected"</c:if>>ABOVE 10% SHAREHOLDING WITHOUT DIRECTORSHIP</option>
											<option value="SUBSIDIARY COMPANY" <c:if test="${DATA[8] eq 'SUBSIDIARY COMPANY'}">selected="selected"</c:if>>SUBSIDIARY COMPANY</option>
											<option value="ASSOCIATE COMPANY" <c:if test="${DATA[8] eq 'ASSOCIATE COMPANY'}">selected="selected"</c:if>>ASSOCIATE COMPANY</option>
											<option value="JOINT VENTURE COMPANY" <c:if test="${DATA[8] eq 'JOINT VENTURE COMPANY'}">selected="selected"</c:if>>JOINT VENTURE COMPANY</option>
											<option value="MAJOR SHAREHOLDER" <c:if test="${DATA[8] eq 'MAJOR SHAREHOLDER'}">selected="selected"</c:if>>MAJOR SHAREHOLDER</option>
											<option value="OTHER" <c:if test="${DATA[8] eq 'OTHER'}">selected="selected"</c:if>>OTHER</option>
										</select>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.SUBRELATION"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="SUBRELATION${UNQID}" name="SUBRELATION" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<option value="">Select One</option>
											<option value="SELF" <c:if test="${DATA[9] eq 'SELF'}">selected="selected"</c:if>>SELF</option>
											<option value="CHILD" <c:if test="${DATA[9] eq 'CHILD'}">selected="selected"</c:if>>CHILD</option>
											<option value="SPOUSE" <c:if test="${DATA[9] eq 'SPOUSE'}">selected="selected"</c:if>>SPOUSE</option>
											<option value="OTHER DEPENDENT" <c:if test="${DATA[9] eq 'OTHER DEPENDENT'}">selected="selected"</c:if>>OTHER DEPENDENT</option>
											<option value="DOMESTIC PARTNER" <c:if test="${DATA[9] eq 'DOMESTIC PARTNER'}">selected="selected"</c:if>>DOMESTIC PARTNER</option>
											<option value="DIRECTOR ENTITY" <c:if test="${DATA[9] eq 'DIRECTOR ENTITY'}">selected="selected"</c:if>>DIRECTOR ENTITY</option>
											<option value="ALTERNATE DIRECTOR ENTITY" <c:if test="${DATA[9] eq 'ALTERNATE DIRECTOR ENTITY'}">selected="selected"</c:if>>ALTERNATE DIRECTOR ENTITY</option>
											<option value="CEO ENTITY" <c:if test="${DATA[9] eq 'CEO ENTITY'}">selected="selected"</c:if>>CEO ENTITY</option>
											<option value="MCOM MEMBER ENTITY" <c:if test="${DATA[9] eq 'MCOM MEMBER ENTITY'}">selected="selected"</c:if>>MCOM MEMBER ENTITY</option>
											<option value="CHILD ENTITY" <c:if test="${DATA[9] eq 'CHILD ENTITY'}">selected="selected"</c:if>>CHILD ENTITY</option>
											<option value="SPOUSE ENTITY" <c:if test="${DATA[9] eq 'SPOUSE ENTITY'}">selected="selected"</c:if>>SPOUSE ENTITY</option>
											<option value="OTHER DEPENDENT ENTITY" <c:if test="${DATA[9] eq 'OTHER DEPENDENT ENTITY'}">selected="selected"</c:if>>OTHER DEPENDENT ENTITY</option>
											<option value="DOMESTIC PARTNER ENTITY" <c:if test="${DATA[9] eq 'DOMESTIC PARTNER ENTITY'}">selected="selected"</c:if>>DOMESTIC PARTNER ENTITY</option>
											<option value="DOMESTIC PARTNER CHILD" <c:if test="${DATA[9] eq 'DOMESTIC PARTNER CHILD'}">selected="selected"</c:if>>DOMESTIC PARTNER CHILD</option>
											<option value="OTHER" <c:if test="${DATA[9] eq 'OTHER'}">selected="selected"</c:if>>OTHER</option>
										</select>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.DROPDOWN1"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="DROPDOWN1${UNQID}" name="DROPDOWN1" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<c:forEach var="DROPDOWN1" items="${RPTADDENTITYDETAILS['DROPDOWN1']}">
												<option value="${DROPDOWN1}" <c:if test="${DATA[10] eq DROPDOWN1}">selected="selected"</c:if>>${DROPDOWN1}</option>
											</c:forEach>
										</select>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.DROPDOWN2"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="DROPDOWN2${UNQID}" name="DROPDOWN2" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<c:forEach var="DROPDOWN2" items="${RPTADDENTITYDETAILS['DROPDOWN2']}">
												<option value="${DROPDOWN2}" <c:if test="${DATA[11] eq DROPDOWN2}">selected="selected"</c:if>>${DROPDOWN2}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.REMARK"/>
									</td>
									<td width="85%" colspan="4">
										<textarea rows="2" cols="2" class="form-control input-sm" id="REMARKS${UNQID}" name="REMARKS" <security:authorize access="hasRole('ROLE_RPTMAKER')"> readonly="readonly" </security:authorize> >${DATA[14]}</textarea>
									</td>
								</tr>
								<tr>
									<td width="15%">
										<spring:message code="app.common.STATUS"/>
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="STATUS" id="STATUS${UNQID}" readonly="readonly"  value="${DATA[13]}"/>
									</td>
									<td width="10%">
										&nbsp;
									</td>
									<td width="15%">
										<spring:message code="app.common.AUTHORIZER"/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" id="AUTHORIZER${UNQID}" name="AUTHORIZER" <security:authorize access="hasRole('ROLE_RPTADMIN')">disabled="disabled"</security:authorize>>
											<option value="">select one</option>
											<c:forEach var="RPTADMINS" items="${RPTADDENTITYDETAILS['RPTADMINS']}">
												<option value="${RPTADMINS.key}" <c:if test="${DATA[17] eq RPTADMINS.value}">selected="selected"</c:if>>${RPTADMINS.value}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<security:authorize access="hasRole('ROLE_RPTMAKER')">
								<c:choose>
									<c:when test="${f:length(RPTENTITYDETAILS) > 0}">
										<button type="submit" id="updateRPTEntity${UNQID}" class="btn btn-primary btn-sm">Update Entity</button>
										<button type="button" id="removeRPTEntity${UNQID}" class="btn btn-danger btn-sm">Remove Entity</button>
										<button type="button" id="disableRPTEntity${UNQID}" class="btn btn-danger btn-sm">Disable Entity</button>
									</c:when>
									<c:otherwise>
										<button type="submit" id="addRPTEntity${UNQID}" class="btn btn-success btn-sm">Add Entity</button>
									</c:otherwise>
								</c:choose>
							</security:authorize>
							<c:choose>
								<c:when test="${AUTHORIZE eq 'Y'}">
									<button type="button" id="approveRPTEntity${UNQID}" class="btn btn-success btn-sm">Approve</button>
									<button type="button" id="rejectRPTEntity${UNQID}" class="btn btn-danger btn-sm">Reject</button>
								</c:when>
								<c:otherwise>
									<button type="button" id="backToRPTWatchList${UNQID}" class="btn btn-warning btn-sm">Back</button>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>