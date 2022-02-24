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
					url = "${pageContext.request.contextPath}/checker/checkUserApprove";
					updateText = "Approving...";
				}else if(action == "rejectUser"){
					url = "${pageContext.request.contextPath}/checker/checkUserReject";
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
</style>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-default">
			<div class="card-header clearfix">
		      <h6 class="card-title pull-${dirL}">Check User </h6>
		      </div>
		      	<c:choose>
		      		<c:when test="${f:length(user) > 0}">
					<table class="table table-striped">						
						<c:choose>
							<c:when test="${user['ISNEWUSER'] == 'Yes'}">
								<tr>
									<td width="18%">UserCode</td>
									<td width="82%">${user['USERCODE']}</td>
								</tr>
								<tr>
									<td width="18%">Newly Created</td>
									<td width="82%">
										${user['ISNEWUSER']}
										<input type="hidden" id="userMakerCodeToApprove" value="${MAKERCODE}"/>
									</td>
								</tr>
								<c:if test="${user['USERDETAILSUPDATEED'] == 'Y'}">
									<c:set var="userInfo" value="${user['USERNEWINFO']}"></c:set>
									<tr>
										<td width="100%" colspan="2" class="success">User Details</td>
									</tr>
									<tr>
										<td width="18%">Name</td>
										<td width="82%">${userInfo['NAME']}</td>
									</tr>
									<tr>
										<td width="18%">Account Enable</td>
										<td width="82%">${userInfo['ACCOUNTENABLE']}</td>
									</tr>
									<tr>
										<td width="18%">Password Expired</td>
										<td width="82%">${userInfo['CREDENTIALEXPIRED']}</td>
									</tr>
									<tr>
										<td width="18%">Account Expired</td>
										<td width="82%">${userInfo['ACCOUNTEXPIRED']}</td>
									</tr>
									<tr>
										<td width="18%">Chat Enabled</td>
										<td width="82%">${userInfo['CHATENABLE']}</td>
									</tr>
									<tr>
										<td width="18%">Access Start Time</td>
										<td width="82%">${userInfo['ACCESSSTARTTIME']}</td>
									</tr>
									<tr>
										<td width="18%">Access End Time</td>
										<td width="82%">${userInfo['ACCESSENDTIME']}</td>
									</tr>
									<tr>
										<td width="18%">Account Expiry Date</td>
										<td width="82%">${userInfo['ACCOUNTEXIPYDATE']}</td>
									</tr>
								</c:if>
								
								<c:if test="${user['ROLEDETAILSUPDATED'] == 'Y'}">
									<tr>
										<td width="100%" colspan="2" class="success">Role Details</td>
									</tr>
									<tr>
										<td width="100%" colspan="2">
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
									<td width="82%" colspan="2">
										<textarea rows="2" class="form-control" id="checkerUserRemarks"></textarea>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td width="20%">UserCode</td>
									<td width="80%" colspan="2">${user['USERCODE']}</td>
								</tr>
								<tr>
									<td width="20%">Newly Created</td>
									<td width="80%" colspan="2">
										${user['ISNEWUSER']} ${user['MAKERCODE']}
										<input type="hidden" id="userMakerCodeToApprove" value="${MAKERCODE}"/>
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
									<tr>
										<td width="20%">Account Enable</td>
										<td width="40%">${userCurrInfo['ACCOUNTENABLE']}</td>
										<td width="40%">${userNewInfo['ACCOUNTENABLE']}</td>
									</tr>
									<tr>
										<td width="20%">Password Expired</td>
										<td width="40%">${userCurrInfo['CREDENTIALEXPIRED']}</td>
										<td width="40%">${userNewInfo['CREDENTIALEXPIRED']}</td>
									</tr>
									<tr>
										<td width="20%">Account Expired</td>
										<td width="40%">${userCurrInfo['ACCOUNTEXPIRED']}</td>
										<td width="40%">${userNewInfo['ACCOUNTEXPIRED']}</td>
									</tr>
									<tr>
										<td width="20%">Chat Enabled</td>
										<td width="40%">${userCurrInfo['CHATENABLE']}</td>
										<td width="40%">${userNewInfo['CHATENABLE']}</td>
									</tr>
									<tr>
										<td width="20%">Access Start Time</td>
										<td width="40%">${userCurrInfo['ACCESSSTARTTIME']}</td>
										<td width="40%">${userNewInfo['ACCESSSTARTTIME']}</td>
									</tr>
									<tr>
										<td width="20%">Access End Time</td>
										<td width="40%">${userCurrInfo['ACCESSENDTIME']}</td>
										<td width="40%">${userNewInfo['ACCESSENDTIME']}</td>
									</tr>
									<tr>
										<td width="20%">Account Expiry Date</td>
										<td width="40%">${userCurrInfo['ACCOUNTEXIPYDATE']}</td>
										<td width="40%">${userNewInfo['ACCOUNTEXIPYDATE']}</td>
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
				            <button type="button" class="btn btn-primary btn-sm" id="approveUser">Approve</button>
				            <button type="button" class="btn btn-primary btn-sm" id="rejectUser">Reject</button>
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