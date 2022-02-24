<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#assignIPAddressUser").click(function(){
			var ipAddressSelected = $("#IPAddressForIPAddressModuleMapping").val();
			var button = $(this);
			var buttonMessage = $(button).html();
			var userSelected = "";
			var selected = "";
			var userSelectCount = 0;
			var userUnSelected = "";
			var unSelected = "";
			var userUnSelectCount = 0;
			var message = "Are you sure";
			$(".userIPAddressMapping").find(".userUnassigned").each(function(i, obj){
				if($(obj).is(":checked")){
					userSelected = userSelected+$(obj).attr("compsssId")+",";
					selected = selected+$(obj).attr("id")+",";
					userSelectCount++;
				}
			});
			
			$(".userIPAddressMapping").find(".userAssigned").each(function(i, obj){
				if(!$(obj).is(":checked")){
					userUnSelected = userUnSelected+$(obj).attr("compsssId")+",";					
					unSelected = unSelected+$(obj).attr("id")+",";
					userUnSelectCount++;
				}
			});
			
			if(userSelectCount > 0){
				message = message+" you want to assign "+userSelected+" in "+ipAddressSelected;
			}
			
			if(userUnSelectCount > 0){
				if(userSelectCount > 0){
					message = message+" and remove "+userUnSelected+" from "+ipAddressSelected;
				}else{
					message = message+" you want to remove "+userUnSelected+" from "+ipAddressSelected;
				}
			}
			if(userSelectCount > 0 || userUnSelectCount > 0){
				if(confirm(message)){
					$(button).html("Assigning...");
					$(button).attr("disabled","disabled");
					var fullData = "ipAddress="+escape(ipAddressSelected)+"&userSelected="+escape(selected)+"&userUnselected="+escape(unSelected);
					$.ajax({
			    		url : "${pageContext.request.contextPath}/adminMaker/assignUserIPAddress",
			    		cache : false,
			    		type : 'POST',
			    		data : fullData,
			    		success : function(resData){
			    			alert(resData.MESSAGE);
			    			$(button).removeAttr("disabled");
			    			$(button).html(buttonMessage);
			    			if(resData.STATUS == "1"){
			    				$(".userIPAddressMapping").find(".userUnassigned").each(function(i, obj){
				    				if(selected.indexOf($(obj).attr("id")) > -1){
				    					var id = $(obj).attr("id");
				    					$(obj).removeClass("userUnassigned").addClass("userAssigned");
				    					$(obj).parent(".btn").removeClass("btn-success").addClass("btn-info");
				    					$("#newlyAdded").parent(".card-body").find(".message").html("");
				    					$("#newlyAdded").append("<div class='btn-group-html'>"+$(obj).parents(".btn-group-html").html()+"</div>");
				    					$("#newlyAdded").find(".userAssigned").prop("checked",true);
				    					$("#newlyAdded").find(".currentRoles").html("Other role(s)");
				    					$(obj).parents(".btn-group-html").remove();
				    				}
				    			});
				    			
			    				$(".userIPAddressMapping").find(".userAssigned").each(function(i, obj){
				    				if(unSelected.indexOf($(obj).attr("id")) > -1){
				    					$(obj).removeClass("userAssigned").addClass("userUnassigned");
				    					$(obj).parent(".btn").removeClass("btn-info").addClass("btn-success");
				    					$("#newlyRemoved").parent(".card-body").find(".message").html("");
				    					$("#newlyRemoved").append("<div class='btn-group-html'>"+$(obj).parents(".btn-group-html").html()+"</div>");
				    					$("#newlyRemoved").find(".userUnassigned").prop("checked",false);
				    					$("#newlyRemoved").find(".currentRoles").html("Current role(s)");
				    					$(obj).parents(".btn-group-html").remove();
				    				}
				    			});
			    			}
			    		},
			    		error : function(){
			    			alert("Something went wrong");
			    		}
			    	});
				}
			}else{
				alert("Please make some changes and try to assign");
			}
		});
	});
</script>
<c:set var="ALREADYASSIGNED" value="${ALLIPADDRESS['ALREADYASSIGNED']}"/>
<c:set var="AVAILABLETOASSIGN" value="${ALLIPADDRESS['AVAILABLETOASSIGN']}"/>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-default">
			<div class="card-header clearfix">
				<h6 class="card-title pull-left">Manage Users in : ${IPADDRESS}</h6>
				<input type="hidden" id="IPAddressForIPAddressModuleMapping" value="${IPADDRESS}"/>
			</div>
			<div class="row" style="padding: 5px; height: 300px;">
				<div class="col-sm-6" style="overflow: auto; height: inherit;">
					<div class="card card-warning">
						<div class="card-header clearfix">
							<h6 class="card-title pull-${dirL}">Available Users</h6>
						</div>
						<div class="card-body userIPAddressMapping">
							<c:choose>
							<c:when test="${f:length(AVAILABLETOASSIGN) > 0}">
								<c:forEach var="userDetails" items="${AVAILABLETOASSIGN}">
									<c:set var="user" value="${AVAILABLETOASSIGN[userDetails.key]}"/>
									<c:set var="OTHERROLES" value="${user['OTHERROLES']}"/>
									<div class="btn-group-html">
									<div class="btn-group" style="margin-bottom: 5px;">
									  <div class="btn btn-success btn-sm">
									  	<input type="checkbox" class="userUnassigned" compsssId="${user['FIRSTNAME']} ${user['LASTNAME']} (${user['USERCODE']})" id="${user['USERCODE']}" style="margin-top: 0px;"/>
									  	<label for="${user['USERCODE']}" style="margin-bottom: 0px;">${user['FIRSTNAME']} ${user['LASTNAME']} (${user['USERCODE']})&#x200E;</label>
									  </div>
									  <c:if test="${f:length(OTHERROLES) > 0}">
										  <label class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
										    &nbsp;<span class="caret"></span>
										  </label>
										  <ul class="dropdown-menu" role="menu">
										    <li><a class="nav-link" href="javascript:void(0)" class="currentRoles">Current IPAddress(es)&#x200E;</a></li>
										    <li class="divider"></li>
										    <c:forEach var="role" items="${OTHERROLES}">
										    	<li><a class="nav-link" href="javascript:void(0)">&#x200E;${role}&#x200E;</a></li>
										    </c:forEach>										    
										  </ul>
									  </c:if>
									</div><br/>
									</div>
								</c:forEach>								
							</c:when>
							<c:otherwise>
								<div class="message"><center>No user available to assign in ${ROLEID}</center></div>
							</c:otherwise>
						</c:choose>
						<div id="newlyRemoved"></div>
						</div>
					</div>
				</div>
				<div class="col-sm-6" style="overflow: auto; height: inherit;">				
					<div class="card card-warning">
						<div class="card-header clearfix">
							<h6 class="card-title pull-${dirL}">Assigned Users</h6>
						</div>
						<div class="card-body userIPAddressMapping">
							<c:choose>
							<c:when test="${f:length(ALREADYASSIGNED) > 0}">
								<c:forEach var="userDetails" items="${ALREADYASSIGNED}">
									<c:set var="user" value="${ALREADYASSIGNED[userDetails.key]}"/>
									<c:set var="OTHERROLES" value="${user['OTHERROLES']}"/>
									<div class="btn-group-html">
									<div class="btn-group" style="margin-bottom: 5px;">
									  <div class="btn btn-info btn-sm">
									  	<input type="checkbox" class="userAssigned" compsssId="${user['FIRSTNAME']} ${user['LASTNAME']} (${user['USERCODE']})" checked="checked" id="${user['USERCODE']}" style="margin-top: 0px;"/>
									  	<label for="${user['USERCODE']}" style="margin-bottom: 0px;">${user['FIRSTNAME']} ${user['LASTNAME']} (${user['USERCODE']})&#x200E;</label>
									  </div>
									  <c:if test="${f:length(OTHERROLES) > 0}">
										  <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
										    &nbsp;<span class="caret"></span>
										  </button>
										  <ul class="dropdown-menu" role="menu">
										    <li><a class="nav-link" href="javascript:void(0)" class="currentRoles">Other IPAddress(es)&#x200E;</a></li>
										    <li class="divider"></li>
										    <c:forEach var="role" items="${OTHERROLES}">
										    	<li><a class="nav-link" href="javascript:void(0)">&#x200E;${role}&#x200E;</a></li>
										    </c:forEach>										    
										  </ul>
									  </c:if>
									</div>&nbsp;&nbsp;&#x200E;${user['STATUS']}&#x200E;<br/>
									</div>
								</c:forEach>								
							</c:when>
							<c:otherwise>
								<div class="message"><center>No user found in this group</center></div>
							</c:otherwise>
						</c:choose>
						<div id="newlyAdded"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-primary btn-sm"
						id="assignIPAddressUser">Assign</button>
				</div>
			</div>
		</div>
	</div>
</div>