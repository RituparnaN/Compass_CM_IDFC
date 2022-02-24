<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../tags/tags.jsp"%>
<c:set var="user" value="${USERDETAILS}"/>
<script type="text/javascript">
	$(document).ready(function(){
		var processing = 0;
		$("#checkerUserActionButtons > button").click(function(){
			var action = $(this).attr("id");
			var button = $(this);
			var makerId = $("#userMakerCodeToApprove").val();
			var remarks = escape($("#checkerUserRemarks").val());
			var userCode = escape($("#userCodeToApprove").val());
			var userMaker = userCode+","+makerId;
			
			if(remarks.trim() == ""){
				alert("Enter remakrs");
				$("#checkerUserRemarks").focus();
			}else if(processing == 1){
				alert("Processing previous request...");
			}else {
				var buttonText = $(button).html();
				var updateText = "";
				var fulldata = "makercode="+makerId+"&remakrs="+remarks+"&userCode="+userCode;
				var url = "";
				if(action == "approveUser"){
					url = "${pageContext.request.contextPath}/cmUAMChecker/checkUserApprove";
					updateText = "Approving...";
				}else if(action == "rejectUser"){
					url = "${pageContext.request.contextPath}/cmUAMChecker/checkUserReject";
					updateText = "Rejecting...";
				}
				
				if(confirm("Do you really want to "+buttonText)){
					processing = 1;
					$(button).attr("disabled","disabled");
					$(button).html(updateText);					
					$.ajax({
			    		url : url,
			    		cache : false,
			    		data : fulldata,
			    		type : 'POST',
			    		success : function(resData){
			    			alert(resData);
			    			$(button).parents(".resultRow").html("");
			    			$("#approveUserSearchResult option[value='"+userMaker+"']").remove();
			    			$(button).removeAttr("disabled");
							$(button).html(buttonText);	
							reloadTabContent();
			    		},
			    		error : function(){
			    			alert("Something went wrong");
			    		}
			    	});	
				}	
			}
		});
	});
</script>
<style type="text/css">
	ul.roleul li{
		display: table-row;
	}
	label.btn-main {
		margin-bottom: 5px;
	}
	label.btn-sub {
		margin-bottom: 3px;
	}
	
	.role-card{
		max-height: 200px;
		overflow: auto;
	}
	p{
		color: #33a5b7
	}
</style>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
		      <h6 class="card-title pull-${dirL}">Check User </h6>
		      </div>
		      	<c:choose>
		      		<c:when test="${f:length(user) > 0}">
					<table class="table table-striped">	
					<%-- <tr><td colspan="5">Current - ${user['USERSTATUSCURRINFO']}</td></tr>
					<tr><td colspan="5">New - ${user['USERSTATUSNEWINFO']}</td></tr> --%>
													
						<c:choose>
							<c:when test="${user['ISNEWUSER'] == 'Yes'}">
								<tr>
									<td width="15%">UserCode</td>
									<td width="30%">${user['USERCODE']}</td>
									<td width="10%">&nbsp;</td>
									<td width="15%">Newly Created</td>
									<td width="30%">
										${user['ISNEWUSER']}
										<input type="hidden" id="userMakerCodeToApprove" value="${MAKERCODE}"/>
									</td>
								</tr>
								<c:if test="${user['USERDETAILSUPDATEED'] == 'Y'}">
									<c:set var="userInfo" value="${user['USERNEWINFO']}"></c:set>
									<tr>
										<td width="100%" colspan="5" class="success">User Details</td>
									</tr>
									<tr>
										<td width="15%">Name</td>
										<td width="30%">${userInfo['NAME']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Employee Code</td>
										<td width="30%">${userInfo['EMPLOYEECODE']}</td>
									</tr>
									<tr>	
										<%-- <td width="15%">Designation Code</td>
										<td width="30%">${userInfo['DESIGNATIONCODE']} - ${userInfo['DESIGNATIONNAME']}</td> --%>
										<td width="15%">Department Code</td>
										<td width="30%">${userInfo['DEPARTMENTCODE']} - ${userInfo['DEPARTMENTNAME']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Branch Code</td>
										<td width="30%">${userInfo['BRANCHCODE']} - ${userInfo['BRANCHNAME']}</td>
									</tr>
									<tr>
										<td width="15%">Email Id</td>
										<td width="30%">${userInfo['EMAILID']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Maker Id</td>
										<td width="30%">${userInfo['MAKERID']}</td>
									</tr>
									<tr>
										<td width="15%">Maker Timestamp</td>
										<td width="30%">${userInfo['CREATIONTIME']}</td>
										<td colspan="3">&nbsp;</td>
									</tr>	
								</c:if>
								
								<c:if test="${user['USERSTATUSDETAILSUPDATED'] == 'Y'}">
									<c:set var="userStatusInfo" value="${user['USERSTATUSNEWINFO']}"></c:set>
									<tr>
										<td width="100%" colspan="5" class="success">User Status Details</td>
									</tr>
									<tr>
										<%-- <td width="15%">Account Expired</td>
										<td width="30%">${userStatusInfo['ACCOUNTEXPIRED']}</td> --%>
										<td width="15%">Account Dormant</td>
										<td width="30%">${userStatusInfo['ACCOUNTDORMANT']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Account Deleted</td>
										<td width="30%">${userStatusInfo['ACCOUNTDELETED']}</td>
									</tr>										
									<tr>
										<td width="15%">Account Locked</td>
										<td width="30%">${userStatusInfo['ACCOUNTLOCKED']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Account Enabled</td>
										<td width="30%">${userStatusInfo['ACCOUNTENABLE']}</td>
									</tr>
									<tr>
										<td width="15%">Maker Id</td>
										<td width="30%">${userStatusInfo['MAKERID']}</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Maker Timestamp</td>
										<td width="30%">${userStatusInfo['CREATIONTIME']}</td>
									</tr>	
								</c:if>
								
								<c:if test="${user['ROLEDETAILSUPDATED'] == 'Y'}">
									<tr>
										<td width="100%" colspan="5" class="success">Role Details</td>
									</tr>
									<tr>
										<td width="100%" colspan="5">
											<c:choose>
											<c:when test="${f:length(user['ROLENEWINFO']) > 0 }">
												<fmt:formatNumber var="right" value="${user['ROLENEWINFOSIZE'] - user['ROLENEWINFOHALFSIZE']}"/>
											<div class="row">												
												<div class="col-sm-6">
													<c:forEach var="role" items="${user['ROLENEWINFO']}" begin="0" end="${right-1}">
														<div class="card-group" id="accordion1" role="tablist" aria-multiselectable="true">
															<div class="card card-warning card-role">
																<div class="card-header" role="tab" id="heading${role['NAME']}">
																	<h4 class="card-title">
																		<a class="collapsed" data-toggle="collapse" data-parent="#accordion1" href="#collapse${role['NAME']}" aria-expanded="false" aria-controls="collapse${role['NAME']}"> ${role['NAME']} (${role['STATUS']})</a>
																	</h4>
																</div>
																<div id="collapse${role['NAME']}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading${role['NAME']}">
																	<div class="card-body role-card">
																		<c:forEach var="ALLMODULES" items="${role['ROLE']}">
																			<c:forEach var="MODULES"  items="${ALLMODULES.value}" >
																				<c:if test="${MODULES.key eq 'MAINMODULE'}">
																					<c:set var="MAINMODULES" value="${MODULES.value}"/>
																				</c:if>
																				<c:if test="${MODULES.key eq 'SUBMODULE'}">
																					<c:set var="SUBMODULES" value="${MODULES.value}"/>
																				</c:if>
																			</c:forEach>
																			<c:forEach var="MAIN" items="${MAINMODULES}">
																				<c:set var="MAINMODULE" value="${MAIN.value}"/>
																			</c:forEach>
																			<label class="btn btn-success btn-sm btn-main">
																				<strong> ${MAINMODULE['MODULENAME']}</strong>
																			</label>
																			<c:choose>
																				<c:when test="${f:length(SUBMODULES) > 0 }">
																					<ul class="roleul">
																						<c:forEach var="SUB" items="${SUBMODULES}">
																						<c:set var="SUBMODULE" value="${SUB.value}"/>
																							<li><label class="btn btn-info btn-xs btn-sub">${SUBMODULE['MODULENAME']}</label></li>
																						</c:forEach>
																					</ul>
																				</c:when>
																				<c:otherwise><br/></c:otherwise>
																			</c:choose>
																			<c:set var="MAINMODULES" value=""/>
																			<c:set var="SUBMODULES" value=""/>
																			<c:set var="MAINITEMS" value=""/>
																			<c:set var="SUBMITEMS" value=""/>
																		</c:forEach>
																	</div>
																</div>
															</div>
														</div>
													</c:forEach>
												</div>
												<div class="col-sm-6">
													<c:forEach var="role" items="${user['ROLENEWINFO']}" begin="${right}">
														<div class="card-group" id="accordion1" role="tablist" aria-multiselectable="true">
															<div class="card card-warning card-role">
																<div class="card-header" role="tab" id="heading${role['NAME']}">
																	<h4 class="card-title">
																		<a class="collapsed" data-toggle="collapse" data-parent="#accordion1" href="#collapse${role['NAME']}" aria-expanded="false" aria-controls="collapse${role['NAME']}"> ${role['NAME']} (${role['STATUS']})</a>
																	</h4>
																</div>
																<div id="collapse${role['NAME']}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading${role['NAME']}">
																	<div class="card-body role-card">
																		<c:forEach var="ALLMODULES" items="${role['ROLE']}">
																			<c:forEach var="MODULES"  items="${ALLMODULES.value}" >
																				<c:if test="${MODULES.key eq 'MAINMODULE'}">
																					<c:set var="MAINMODULES" value="${MODULES.value}"/>
																				</c:if>
																				<c:if test="${MODULES.key eq 'SUBMODULE'}">
																					<c:set var="SUBMODULES" value="${MODULES.value}"/>
																				</c:if>
																			</c:forEach>
																			<c:forEach var="MAIN" items="${MAINMODULES}">
																				<c:set var="MAINMODULE" value="${MAIN.value}"/>
																			</c:forEach>
																			<label class="btn btn-success btn-sm btn-main">
																				<strong> ${MAINMODULE['MODULENAME']}</strong>
																			</label>
																			<c:choose>
																				<c:when test="${f:length(SUBMODULES) > 0 }">
																					<ul class="roleul">
																						<c:forEach var="SUB" items="${SUBMODULES}">
																						<c:set var="SUBMODULE" value="${SUB.value}"/>
																							<li><label class="btn btn-info btn-xs btn-sub">${SUBMODULE['MODULENAME']}</label></li>
																						</c:forEach>
																					</ul>
																				</c:when>
																				<c:otherwise><br/></c:otherwise>
																			</c:choose>
																			<c:set var="MAINMODULES" value=""/>
																			<c:set var="SUBMODULES" value=""/>
																			<c:set var="MAINITEMS" value=""/>
																			<c:set var="SUBMITEMS" value=""/>
																		</c:forEach>
																	</div>
																</div>
															</div>
														</div>
													</c:forEach>
												</div>
											</div>
											</c:when>
											<c:otherwise>
												No Role selected
											</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:if>
								
								<c:if test="${user['IPDETAILSUPDATEED'] == 'Y'}">
									<tr>
										<td width="100%" colspan="2" class="success">IPAddress Details</td>
									</tr>
									<tr>
										<td width="100%" colspan="2">
											<c:forEach var="ipAddress" items="${user['IPNEWINFO']}">
												<span class="btn btn-sm btn-info">${ipAddress}</span>
											</c:forEach>
										</td>
									</tr>
								</c:if>
								<tr>
									<td width="18%">Remarks</td>
									<td width="82%" colspan="5">
										<textarea rows="2" class="form-control" id="checkerUserRemarks"></textarea>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td width="20%">UserCode</td>
									<td colspan="2">
										<table width="100%">
											<tr>
												
												<td width="20%">${user['USERCODE']}</td>
												<td width="30%">&nbsp;</td>
												<td width="20%">Newly Created</td>
												<td width="30%" >
													${user['ISNEWUSER']} ${user['MAKERCODE']}
													<input type="hidden" id="userMakerCodeToApprove" value="${MAKERCODE}"/>
												</td>
											</tr>
									</table>
								</tr>
								<tr>
									<td colspan="3">
										<c:if test="${user['USERDETAILSUPDATEED'] == 'Y'}">
											<p>User's Detail(s) have been updated.</p>
										</c:if>
										<c:if test="${user['ROLEDETAILSUPDATED'] == 'Y'}">
											<p>User's Role Detail(s) have been updated.</p>
										</c:if>
										<c:if test="${user['USERSTATUSDETAILSUPDATED'] == 'Y'}">
											<c:set var="userStatusNewInfo" value="${user['USERSTATUSNEWINFO']}"/>
											<c:set var="userStatusCurrInfo" value="${user['USERSTATUSCURRINFO']}"/>
												<c:if test="${userStatusCurrInfo['ACCOUNTENABLE'] ne userStatusNewInfo['ACCOUNTENABLE']}">
													<p>User's Account Enabling Status has been updated.</p>
												</c:if>
												<%-- <c:if test="${userStatusCurrInfo['ACCOUNTEXPIRED'] ne userStatusNewInfo['ACCOUNTEXPIRED']}">
													<p>User's Account Expiration Status has been updated.</p>
												</c:if> --%>
												<c:if test="${userStatusCurrInfo['ACCOUNTDORMANT'] ne userStatusNewInfo['ACCOUNTDORMANT']}">
													<p>User's Account Dormancy Status has been updated.</p>
												</c:if>
												<c:if test="${userStatusCurrInfo['ACCOUNTDELETED'] ne userStatusNewInfo['ACCOUNTDELETED']}">
													<p>User's Account Deletion Status has been updated.</p>
												</c:if>
												<c:if test="${userStatusCurrInfo['ACCOUNTLOCKED'] ne userStatusNewInfo['ACCOUNTLOCKED']}">
													<p>User's Account Locking Status has been updated.</p>
												</c:if>
										</c:if>
									</td>
								</tr>
								<tr>
									<th width="20%" class="primary">Fields</th>
									<th width="40%" class="primary">Current</th>
									<th width="40%" class="primary">Update</th>
								</tr>
								<c:if test="${user['USERDETAILSUPDATEED'] == 'Y'}">
									<c:set var="userNewInfo" value="${user['USERNEWINFO']}"/>
									<c:set var="userCurrInfo" value="${user['USERCURRINFO']}"/>
									<tr>
										<td width="100%" colspan="3" class="success">User Details</td>
									</tr>
									<tr>
										<td width="20%">Name</td>
										<td width="40%">${userCurrInfo['NAME']}</td>
										<td width="40%">${userNewInfo['NAME']}</td>
									</tr>
									<%-- <tr>
										<td width="20%">Account Enable</td>
										<td width="40%">${userCurrInfo['ACCOUNTENABLE']}</td>
										<td width="40%">${userNewInfo['ACCOUNTENABLE']}</td>
									</tr>
									<tr>
										<td width="20%">Account Expired</td>
										<td width="40%">${userCurrInfo['ACCOUNTEXPIRED']}</td>
										<td width="40%">${userNewInfo['ACCOUNTEXPIRED']}</td>
									</tr>
									<tr>
										<td width="20%">Account Deleted</td>
										<td width="40%">${userCurrInfo['ACCOUNTDELETED']}</td>
										<td width="40%">${userNewInfo['ACCOUNTDELETED']}</td>
									</tr>
									<tr>
										<td width="20%">Account Locked</td>
										<td width="40%">${userCurrInfo['ACCOUNTLOCKED']}</td>
										<td width="40%">${userNewInfo['ACCOUNTLOCKED']}</td>
									</tr>
									 --%>
									<tr>
										<td width="20%">Employee Code</td>
										<td width="40%">${userCurrInfo['EMPLOYEECODE']}</td>
										<td width="40%">${userNewInfo['EMPLOYEECODE']}</td>
									</tr>
									<tr>
										<td width="20%">Email Id</td>
										<td width="40%">${userCurrInfo['EMAILID']}</td>
										<td width="40%">${userNewInfo['EMAILID']}</td>
									</tr>
									<tr>
										<td width="20%">Department Code</td>
										<td width="40%">${userCurrInfo['DEPARTMENTCODE']} - ${userCurrInfo['DEPARTMENTNAME']}</td>
										<td width="40%">${userNewInfo['DEPARTMENTCODE']} - ${userNewInfo['DEPARTMENTNAME']}</td>
									</tr>
									<tr>
										<td width="20%">Branch Code</td>
										<td width="40%">${userCurrInfo['BRANCHCODE']} - ${userCurrInfo['BRANCHNAME']}</td>
										<td width="40%">${userNewInfo['BRANCHCODE']} - ${userNewInfo['BRANCHNAME']}</td>
									</tr>
									<tr>
										<td width="20%">User Role</td>
										<td width="40%">${userCurrInfo['ROLECODE']}</td>
										<td width="40%">${userNewInfo['ROLECODE']}</td>
									</tr>
									<tr>
										<td width="20%">Maker Id</td>
										<td width="40%">${userCurrInfo['MAKERID']}</td>
										<td width="40%">${userNewInfo['MAKERID']}</td>
									</tr>
									<tr>
										<td width="20%">Maker Timestamp</td>
										<td width="40%">${userCurrInfo['CREATIONTIME']}</td>
										<td width="40%">${userNewInfo['CREATIONTIME']}</td>
									</tr>
								</c:if>
								
								<c:if test="${user['USERSTATUSDETAILSUPDATED'] == 'Y'}">
									<c:set var="userStatusNewInfo" value="${user['USERSTATUSNEWINFO']}"/>
									<c:set var="userStatusCurrInfo" value="${user['USERSTATUSCURRINFO']}"/>
									<tr>
										<td width="100%" colspan="3" class="success">User Status Details</td>
									</tr>
									<tr>
										<td width="20%">Account Enable</td>
										<td width="40%">${userStatusCurrInfo['ACCOUNTENABLE']}</td>
										<td width="40%">${userStatusNewInfo['ACCOUNTENABLE']}</td>
									</tr>
									<%-- <tr>
										<td width="20%">Account Expired</td>
										<td width="40%">${userStatusCurrInfo['ACCOUNTEXPIRED']}</td>
										<td width="40%">${userStatusNewInfo['ACCOUNTEXPIRED']}</td>
									</tr> --%>
									<tr>
										<td width="20%">Account Dormant</td>
										<td width="40%">${userStatusCurrInfo['ACCOUNTDORMANT']}</td>
										<td width="40%">${userStatusNewInfo['ACCOUNTDORMANT']}</td>
									</tr>
									<tr>
										<td width="20%">Account Deleted</td>
										<td width="40%">${userStatusCurrInfo['ACCOUNTDELETED']}</td>
										<td width="40%">${userStatusNewInfo['ACCOUNTDELETED']}</td>
									</tr>
									<tr>
										<td width="20%">Account Locked</td>
										<td width="40%">${userStatusCurrInfo['ACCOUNTLOCKED']}</td>
										<td width="40%">${userStatusNewInfo['ACCOUNTLOCKED']}</td>
									</tr>
									<tr>
										<td width="20%">Maker Id</td>
										<td width="40%">${userStatusCurrInfo['MAKERID']}</td>
										<td width="40%">${userStatusNewInfo['MAKERID']}</td>
									</tr>
									<tr>
										<td width="20%">Maker Timestamp</td>
										<td width="40%">${userStatusCurrInfo['STATUSUPDATETIMESTAMP']}</td>
										<td width="40%">${userStatusNewInfo['CREATIONTIME']}</td>
									</tr>
								</c:if>
								
								<c:if test="${user['ROLEDETAILSUPDATED'] == 'Y'}">
									<tr>
										<td width="100%" colspan="3" class="success">Role Details</td>
									</tr>
									<tr>
										<td width="20%">&nbsp;</td>
										<td width="40%">
											<c:choose>
											<c:when test="${f:length(user['ROLECURRINFO']) > 0 }">
														<div class="card-group" id="accordion1" role="tablist" aria-multiselectable="true">
													<c:forEach var="role" items="${user['ROLECURRINFO']}">
															<div class="card card-warning card-role">
																<div class="card-header" role="tab" id="heading1${role['NAME']}">
																	<h4 class="card-title">
																		<a class="collapsed" data-toggle="collapse" data-parent="#accordion1" href="#collapse1${role['NAME']}" aria-expanded="false" aria-controls="collapse1${role['NAME']}"> ${role['NAME']} (${role['STATUS']})</a>
																	</h4>
																</div>
																<div id="collapse1${role['NAME']}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading1${role['NAME']}">
																	<div class="card-body role-card">
																		<c:forEach var="ALLMODULES" items="${role['ROLE']}">
																			<c:forEach var="MODULES"  items="${ALLMODULES.value}" >
																				<c:if test="${MODULES.key eq 'MAINMODULE'}">
																					<c:set var="MAINMODULES" value="${MODULES.value}"/>
																				</c:if>
																				<c:if test="${MODULES.key eq 'SUBMODULE'}">
																					<c:set var="SUBMODULES" value="${MODULES.value}"/>
																				</c:if>
																			</c:forEach>
																			<c:forEach var="MAIN" items="${MAINMODULES}">
																				<c:set var="MAINMODULE" value="${MAIN.value}"/>
																			</c:forEach>
																			<label class="btn btn-success btn-sm btn-main">
																				<strong> ${MAINMODULE['MODULENAME']}</strong>
																			</label>
																			<c:choose>
																				<c:when test="${f:length(SUBMODULES) > 0 }">
																					<ul class="roleul">
																						<c:forEach var="SUB" items="${SUBMODULES}">
																						<c:set var="SUBMODULE" value="${SUB.value}"/>
																							<li><label class="btn btn-info btn-xs btn-sub">${SUBMODULE['MODULENAME']}</label></li>
																						</c:forEach>
																					</ul>
																				</c:when>
																				<c:otherwise><br/></c:otherwise>
																			</c:choose>
																			<c:set var="MAINMODULES" value=""/>
																			<c:set var="SUBMODULES" value=""/>
																			<c:set var="MAINITEMS" value=""/>
																			<c:set var="SUBMITEMS" value=""/>
																		</c:forEach>
																	</div>
																</div>
															</div>
													</c:forEach>
														</div>
											</c:when>
											<c:otherwise>
												No Role selected
											</c:otherwise>
											</c:choose>
										</td>
										<td width="40%">
											<c:choose>
											<c:when test="${f:length(user['ROLENEWINFO']) > 0 }">
													<div class="card-group" id="accordion2" role="tablist" aria-multiselectable="true">
													<c:forEach var="role" items="${user['ROLENEWINFO']}">														
															<div class="card card-warning card-role">
																<div class="card-header" role="tab" id="heading3${role['NAME']}">
																	<h4 class="card-title">
																		<a class="collapsed" data-toggle="collapse" data-parent="#accordion2" href="#collapse3${role['NAME']}" aria-expanded="false" aria-controls="collapse3${role['NAME']}"> ${role['NAME']} (${role['STATUS']})</a>
																	</h4>
																</div>
																<div id="collapse3${role['NAME']}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading3${role['NAME']}">
																	<div class="card-body role-card">
																		<c:forEach var="ALLMODULES" items="${role['ROLE']}">
																			<c:forEach var="MODULES"  items="${ALLMODULES.value}" >
																				<c:if test="${MODULES.key eq 'MAINMODULE'}">
																					<c:set var="MAINMODULES" value="${MODULES.value}"/>
																				</c:if>
																				<c:if test="${MODULES.key eq 'SUBMODULE'}">
																					<c:set var="SUBMODULES" value="${MODULES.value}"/>
																				</c:if>
																			</c:forEach>
																			<c:forEach var="MAIN" items="${MAINMODULES}">
																				<c:set var="MAINMODULE" value="${MAIN.value}"/>
																			</c:forEach>
																			<label class="btn btn-success btn-sm btn-main">
																				<strong> ${MAINMODULE['MODULENAME']}</strong>
																			</label>
																			<c:choose>
																				<c:when test="${f:length(SUBMODULES) > 0 }">
																					<ul class="roleul">
																						<c:forEach var="SUB" items="${SUBMODULES}">
																						<c:set var="SUBMODULE" value="${SUB.value}"/>
																							<li><label class="btn btn-info btn-xs btn-sub">${SUBMODULE['MODULENAME']}</label></li>
																						</c:forEach>
																					</ul>
																				</c:when>
																				<c:otherwise><br/></c:otherwise>
																			</c:choose>
																			<c:set var="MAINMODULES" value=""/>
																			<c:set var="SUBMODULES" value=""/>
																			<c:set var="MAINITEMS" value=""/>
																			<c:set var="SUBMITEMS" value=""/>
																		</c:forEach>
																	</div>
																</div>
															</div>
													</c:forEach>
														</div>
												</c:when>
											<c:otherwise>
												No Role selected
											</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:if>
								<c:if test="${user['IPDETAILSUPDATEED'] == 'Y'}">
									<tr>
										<td width="100%" colspan="3" class="success">IPAddress Details</td>
									</tr>
									<tr>
										<td width="20%">&nbsp;</td>
										<td width="40%">
											<c:forEach var="ipAddress" items="${user['IPCURRINFO']}">
												<span class="btn btn-sm btn-info" style="margin: 2px">${ipAddress}</span>
											</c:forEach>
										</td>
										<td width="40%">
											<c:forEach var="ipAddress" items="${user['IPNEWINFO']}">
												<span class="btn btn-sm btn-info" style="margin: 2px">${ipAddress}</span>
											</c:forEach>
										</td>
									</tr>
								</c:if>
								<tr>
									<td width="20%">Remarks</td>
									<td width="80%" colspan="2">
										<textarea rows="2" class="form-control input-sm" id="checkerUserRemarks"></textarea>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
						
					</table>
					<input type="hidden" id="userCodeToApprove" value="${user['USERCODE']}"/>
					<div class="card-footer clearfix">
				        <div class="pull-${dirR}" id="checkerUserActionButtons">
				            <button type="button" class="btn btn-success btn-sm" id="approveUser">Approve</button>
				            <button type="button" class="btn btn-danger btn-sm" id="rejectUser">Reject</button>
				        </div>
			    	</div>
			    	</c:when>
			    	<c:otherwise>
			    		No Pending details found
			    	</c:otherwise>
		      	</c:choose>
			</div>
	</div>
</div>