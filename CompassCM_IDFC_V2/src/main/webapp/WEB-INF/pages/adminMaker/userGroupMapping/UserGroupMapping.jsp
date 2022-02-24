<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassUserGroupMappingScripts.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$(".subType").each(function(i, obj){
			var isChecked = $(obj).is(":checked");
			if(isChecked){
				var total = 0;
				var selected = 0;
				var compassId1 = $(obj).attr("compassId1");
				var compassId2 = $(obj).attr("compassId2");
				var compassId3 = $(obj).attr("compassId3");
				$(".subOf"+compassId1+compassId2).each(function(j, obj1){
					total++;
					if($(obj1).is(":checked"))
						selected++;
				});
				if(total != selected){
					$(".mainWith"+compassId1+compassId2).prop("indeterminate",true);
					$(".mainWith"+compassId1+compassId2).change();
				}
				if(total == selected && selected > 0){
					$(".mainWith"+compassId1+compassId2).prop("checked",true);
					$(".mainWith"+compassId1+compassId2).change();
				}
			}
		});
		
		$(".mainType").each(function(i, obj){
			var isChecked = $(obj).is(":checked");
			if(isChecked){
				var total = 0;
				var selected = 0;
				var compassId1 = $(obj).attr("compassId1");
				var compassId2 = $(obj).attr("compassId2");
				
				$(".subOf"+compassId1+compassId2).each(function(j, obj1){
					$(obj1).prop("checked",true);
				});
				$(".mainOf"+compassId1).each(function(j, obj1){
					total++;
					if($(obj1).is(":checked"))
						selected++;
				});
				if(total != selected){
					$(".roleWith"+compassId1).prop("indeterminate",true);
				}
				if(total == selected && selected > 0){
					$(".roleWith"+compassId1).prop("checked",true);
				}
			}
		});
		
		$(".roleType").each(function(i, obj){
			var isChecked = $(obj).is(":checked");
			if(isChecked){
				var compassId1 = $(obj).attr("compassId1");
				$(".mainOf"+compassId1).each(function(j, obj1){
					$(obj1).prop("checked",true);
					var compassId2 = $(obj1).attr("compassId2");
					$(".subOf"+compassId1+compassId2).each(function(k, obj2){
						$(obj2).prop("checked",true);
					});
				});
			}
		});
		
		$("#assignUserGroupModule").click(function(){
			var roleAssigned = "";
			var mainModuleAssigned = "";
			var subModuleAssigned = "";
			var button = $(this);
			var buttonMessage = $(button).html();
			var userCode = $("#userCodeForGroupModuleMapping").val();
			
			$(".roleType").each(function(i, obj){
				var isRoleIndeterminate = $(obj).is(":indeterminate");
				var isRoleChecked = $(obj).is(":checked");
				var roleValue = $(obj).attr("compassId1");
				if(isRoleChecked)
					roleAssigned = roleAssigned+roleValue+",";
				
				if(isRoleIndeterminate){
					$(".mainOf"+roleValue).each(function(j, obj1){
						var isMainIndeterminate = $(obj1).is(":indeterminate");
						var isMainChecked = $(obj1).is(":checked");
						var mainValue = $(obj1).attr("compassId2");
						if(isMainChecked)
							mainModuleAssigned = mainModuleAssigned+"["+roleValue+"^"+mainValue+"],";
						if(isMainIndeterminate){
							$(".subOf"+roleValue+mainValue).each(function(k, obj2){
								var subValue = $(obj2).attr("compassId3");
								if($(obj2).is(":checked"))
									subModuleAssigned = subModuleAssigned+"["+roleValue+"^"+subValue+"],";
							});
						}
					});
				}
			});
			
			if(confirm("Are you sure you want to assign selected roles and modules to "+userCode)){
				$(button).html("Assigning...");
				$(button).attr("disabled","disabled");
				
				var fullData = "userCode="+escape(userCode)+"&roleAssigned="+escape(roleAssigned)+"&mainModuleAssigned="+escape(mainModuleAssigned)+"&subModuleAssigned="+escape(subModuleAssigned);
				//alert(fullData);
				$.ajax({
		    		url : "${pageContext.request.contextPath}/cmUAMMaker/assignRoleModule",
		    		cache : false,
		    		type : 'POST',
		    		data : fullData,
		    		success : function(resData){
		    			alert(resData);
		    			$(button).removeAttr("disabled");
		    			$(button).html(buttonMessage);
		    		},
		    		error : function(){
		    			alert("Something went wrong");
		    		}
		    	});
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
	a{
    color: #3c763d;
    }
	a:hover {
    color: #3c763d;
    text-decoration: underline;
    }
    
}
</style>
<c:set var="MAINMODULES" value="${ALLMODULES['MAINMODULES']}"/>
<c:set var="SUBMODULES" value="${ALLMODULES['SUBMODULES']}"/>
<c:set var="ASSIGNEDROLES" value="${ASSIGNEDROLESMODULE['ROLESASSIGNED']}"/>
<c:set var="ASSIGNEDMODULES" value="${ASSIGNEDROLESMODULE['MODULESASSIGNED']}"/>

<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Manage Groups and Modules for : ${USERCODE}</h6>
				<input type="hidden" id="userCodeForGroupModuleMapping" value="${USERCODE}"/>
			</div>
			<div class="row" style="padding: 5px; height: 300px; margin-bottom: 20px;">
				<div class="col-sm-6" style="overflow: auto; height: inherit;">
					<div class="card-group" id="accordion" role="tablist"	aria-multiselectable="true">
						<c:forEach var="role" items="${ALLROLES}" begin="0" end="4">
							<div class="card card-success card-role">
								<div class="card-header" role="tab" id="heading${role}">
									<h4 class="card-title">
										<input type="checkbox" value="${role}" id="role${role}" class="roleType roleWith${role}" compassId1="${role}"
										<c:if test="${not empty ASSIGNEDROLES[role]}">checked="checked"</c:if>
										/>
										<a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapse${role}" aria-expanded="false" aria-controls="collapse${role}"> ${role} </a>
									</h4>
								</div>
								<div id="collapse${role}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading${role}">
									<div class="card-body">
										<c:choose>
											<c:when test="${f:length(MAINMODULES[role]) > 0 }">											
												<c:set var="right" value="${f:length(MAINMODULES[role]) / 2}"/>
												<c:set var="left" value="${f:length(MAINMODULES[role]) - right}"/>
												<div class="row">
													<div class="col-sm-6">
														<c:forEach var="mainModule" items="${MAINMODULES[role]}" begin="0" end="${left-1}">
															<c:set var="modulecode" value="${mainModule['MODULECODE']}"/>
															<c:set var="modulename" value="${mainModule['MODULENAME']}"/>
															<c:set var="moduleAssigned" value="${ASSIGNEDMODULES[role]}"/>
															
															<label class="btn btn-success btn-xs btn-main" for="mainmodule${role}${modulecode}">
																<input type="checkbox" id="mainmodule${role}${modulecode}" value="${modulecode}" class="mainType mainOf${role} mainWith${role}${modulecode}" 
																compassId1="${role}" compassId2="${modulecode}" <c:if test="${not empty moduleAssigned[modulecode]}">checked="checked"</c:if> />
																&nbsp;&nbsp;<strong>${modulename}</strong>
															</label><br/>
															<c:choose>
																<c:when test="${not empty SUBMODULES[modulecode]}">															
																	<ul class="roleul">
																	<c:forEach var="subModule" items="${SUBMODULES[modulecode]}">
																		<li>
																			<label class="btn btn-info btn-xs btn-sub" for="submodule${role}${modulecode}${subModule['MODULECODE']}">
																			<input type="checkbox" id="submodule${role}${modulecode}${subModule['MODULECODE']}" class="subType subOf${role}${modulecode} subWith${role}${modulecode}${subModule['MODULECODE']}" 
																			compassId1="${role}" compassId2="${modulecode}" compassId3="${subModule['MODULECODE']}" value="${subModule['MODULECODE']}" <c:if test="${not empty moduleAssigned[subModule['MODULECODE']]}">checked="checked"</c:if> />
																				&nbsp;&nbsp;${subModule['MODULENAME']}
																			</label>
																		</li>
																	</c:forEach>
																	</ul>
																</c:when>
															</c:choose>	
														</c:forEach>
													</div>
													<div class="col-sm-6">
														<c:forEach var="mainModule" items="${MAINMODULES[role]}" begin="${right}">
															<c:set var="modulecode" value="${mainModule['MODULECODE']}"/>
															<c:set var="modulename" value="${mainModule['MODULENAME']}"/>
															<c:set var="moduleAssigned" value="${ASSIGNEDMODULES[role]}"/>
																												
															<label class="btn btn-success btn-xs btn-main" for="mainmodule${role}${modulecode}">
																<input type="checkbox" id="mainmodule${role}${modulecode}" value="${modulecode}" class="mainType mainOf${role} mainWith${role}${modulecode}" 
																compassId1="${role}" compassId2="${modulecode}" <c:if test="${not empty moduleAssigned[modulecode]}">checked="checked"</c:if> />
																&nbsp;&nbsp;<strong>${modulename}</strong>
															</label><br/>
															<c:choose>
																<c:when test="${not empty SUBMODULES[modulecode]}">															
																	<ul class="roleul">
																	<c:forEach var="subModule" items="${SUBMODULES[modulecode]}">
																		<li>
																			<label class="btn btn-info btn-xs btn-sub" for="submodule${role}${modulecode}${subModule['MODULECODE']}">
																			<input type="checkbox" id="submodule${role}${modulecode}${subModule['MODULECODE']}" class="subType subOf${role}${modulecode} subWith${role}${modulecode}${subModule['MODULECODE']}" 
																			compassId1="${role}" compassId2="${modulecode}" compassId3="${subModule['MODULECODE']}" value="${subModule['MODULECODE']}" <c:if test="${not empty moduleAssigned[subModule['MODULECODE']]}">checked="checked"</c:if> />
																				&nbsp;&nbsp;${subModule['MODULENAME']}
																			</label>
																		</li>
																	</c:forEach>
																	</ul>
																</c:when>
															</c:choose>											
														</c:forEach>
													</div>
												</div>
												
											</c:when>
											<c:otherwise>
												No modules assigned in ${role}
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
				<div class="col-sm-6" style="overflow: auto; height: inherit;">
					<div class="card-group" id="accordion1" role="tablist" aria-multiselectable="true">
						<c:forEach var="role" items="${ALLROLES}" begin="5">
							<div class="card card-success card-role">
								<div class="card-header" role="tab" id="heading${role}">
									<h4 class="card-title">
										<input type="checkbox" value="${role}" id="role${role}" class="roleType roleWith${role}" compassId1="${role}"
										<c:if test="${not empty ASSIGNEDROLES[role]}">checked="checked"</c:if>
										/>
										<a class="collapsed" data-toggle="collapse" data-parent="#accordion1" href="#collapse${role}" aria-expanded="false" aria-controls="collapse${role}"> ${role} </a>
									</h4>
								</div>
								<div id="collapse${role}" class="card-collapse collapse" role="tabpanel" aria-labelledby="heading${role}">
									<div class="card-body">
										<c:choose>
											<c:when test="${f:length(MAINMODULES[role]) > 0 }">											
												<c:set var="right" value="${f:length(MAINMODULES[role]) / 2}"/>
												<c:set var="left" value="${f:length(MAINMODULES[role]) - right}"/>
												<div class="row">
													<div class="col-sm-6">
														<c:forEach var="mainModule" items="${MAINMODULES[role]}" begin="0" end="${left-1}">
															<c:set var="modulecode" value="${mainModule['MODULECODE']}"/>
															<c:set var="modulename" value="${mainModule['MODULENAME']}"/>
															<c:set var="moduleAssigned" value="${ASSIGNEDMODULES[role]}"/>
																												
															<label class="btn btn-success btn-xs btn-main" for="mainmodule${role}${modulecode}">
																<input type="checkbox" id="mainmodule${role}${modulecode}" value="${modulecode}" class="mainType mainOf${role} mainWith${role}${modulecode}" 
																compassId1="${role}" compassId2="${modulecode}" <c:if test="${not empty moduleAssigned[modulecode]}">checked="checked"</c:if> />
																&nbsp;&nbsp;<strong>${modulename}</strong>
															</label><br/>
															<c:choose>
																<c:when test="${not empty SUBMODULES[modulecode]}">															
																	<ul class="roleul">
																	<c:forEach var="subModule" items="${SUBMODULES[modulecode]}">
																		<li>
																			<label class="btn btn-info btn-xs btn-sub" for="submodule${role}${modulecode}${subModule['MODULECODE']}">
																			<input type="checkbox" id="submodule${role}${modulecode}${subModule['MODULECODE']}" class="subType subOf${role}${modulecode} subWith${role}${modulecode}${subModule['MODULECODE']}" 
																			compassId1="${role}" compassId2="${modulecode}" compassId3="${subModule['MODULECODE']}" value="${subModule['MODULECODE']}" <c:if test="${not empty moduleAssigned[subModule['MODULECODE']]}">checked="checked"</c:if> />
																				&nbsp;&nbsp;${subModule['MODULENAME']}
																			</label>
																		</li>
																	</c:forEach>
																	</ul>
																</c:when>
															</c:choose>													
														</c:forEach>
													</div>
													<div class="col-sm-6">
														<c:forEach var="mainModule" items="${MAINMODULES[role]}" begin="${right}">
															<c:set var="modulecode" value="${mainModule['MODULECODE']}"/>
															<c:set var="modulename" value="${mainModule['MODULENAME']}"/>
															<c:set var="moduleAssigned" value="${ASSIGNEDMODULES[role]}"/>
																												
															<label class="btn btn-success btn-xs btn-main" for="mainmodule${role}${modulecode}">
																<input type="checkbox" id="mainmodule${role}${modulecode}" value="${modulecode}" class="mainType mainOf${role} mainWith${role}${modulecode}" 
																compassId1="${role}" compassId2="${modulecode}" <c:if test="${not empty moduleAssigned[modulecode]}">checked="checked"</c:if> />
																&nbsp;&nbsp;<strong>${modulename}</strong>
															</label><br/>
															<c:choose>
																<c:when test="${not empty SUBMODULES[modulecode]}">															
																	<ul class="roleul">
																	<c:forEach var="subModule" items="${SUBMODULES[modulecode]}">
																		<li>
																			<label class="btn btn-info btn-xs btn-sub" for="submodule${role}${modulecode}${subModule['MODULECODE']}">
																			<input type="checkbox" id="submodule${role}${modulecode}${subModule['MODULECODE']}" class="subType subOf${role}${modulecode} subWith${role}${modulecode}${subModule['MODULECODE']}" 
																			compassId1="${role}" compassId2="${modulecode}" compassId3="${subModule['MODULECODE']}" value="${subModule['MODULECODE']}" <c:if test="${not empty moduleAssigned[subModule['MODULECODE']]}">checked="checked"</c:if> />
																				&nbsp;&nbsp;${subModule['MODULENAME']}
																			</label>
																		</li>
																	</c:forEach>
																	</ul>
																</c:when>
															</c:choose>											
														</c:forEach>
													</div>
												</div>
												
											</c:when>
											<c:otherwise>
												No modules assigned in ${role}
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-right">
					<button type="button" class="btn btn-primary btn-sm"
						id="assignUserGroupModule">Assign</button>
				</div>
			</div>
		</div>
	</div>
</div>