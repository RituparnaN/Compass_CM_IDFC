<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	if($("#multiTabDisplayInput").val() == 0){
		$("#multiTabDisplay").prop('checked', true);
	}
	if($("#closeRefreshTabInput").val() == 0){
		$("#closeRefreshTab").prop('checked', true);
	}
	if($("#autoCollapseInput").val() == 0){
		$("#autoCollapse").prop('checked', true);
	}
	
	$("#multiTabDisplay").change(function(){
    	if($(this).is(":checked")){
    		$("#multiTabDisplayInput").val(0);
    	}else{
    		$("#multiTabDisplayInput").val(1);
    	}
    });
    
    $("#closeRefreshTab").change(function(){
    	if($(this).is(":checked")){
    		$("#closeRefreshTabInput").val(0);
    	}else{
    		$("#closeRefreshTabInput").val(1);
    	}
    });
    
    $("#autoCollapse").change(function(){
    	if($(this).is(":checked")){
    		$("#autoCollapseInput").val(0);
    	}else{
    		$("#autoCollapseInput").val(1);
    	}
    })
    
    
    $("#updateProfilePriority").click(function(){
    	var profile = $("input:radio[name=profilePriority]:checked").val();
    	var button = $(this);
    	button.html("Updating...");
    	button.attr("disabled","disabled");
    	$.ajax({
    		url : '${pageContext.request.contextPath}/changeProfilePriority',
    		data : 'profile='+profile,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			alert(resData);
    			button.html("Update");
    	    	button.removeAttr("disabled");
    		}
    	});
    });
	
	$("#updateLanguage").click(function(){
		var selectedLanguage = $("#userlanguage").val();
		$.ajax({
    		url : '${pageContext.request.contextPath}/updateLanguage?lang='+selectedLanguage,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			alert(resData);
    		}
    	});
	});
	
	$("#updateLabelDirection").click(function(){
		var selectedLabelDirection = $("#userLabelDirection").val();
		$.ajax({
    		url : '${pageContext.request.contextPath}/updateLabelDirection?labelDirection='+selectedLabelDirection,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			alert(resData);
    		}
    	});
	});
	
	$("#updateLabelProperties").click(function(){		
		$.ajax({
    		url : '${pageContext.request.contextPath}/updateLabelProperties',
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			alert(resData);
    		}
    	});
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-default">
	    	<div class="card-body">
	    		<table class="table table-bordered table-striped">
	    			<tbody>
	    				<tr>
	    					<td width="30%">Tab Display</td>
	    					<td width="70%">
	    						<label class="btn btn-outline btn-primary btn-sm" for="multiTabDisplay">
								  <input type="checkbox" id="multiTabDisplay" />
								  Disable multiple tab displaying
								</label>
								<br/>
								<label class="btn btn-outline btn-primary btn-sm" for="closeRefreshTab" style="margin-top: 5px;">
									<input type="checkbox" id="closeRefreshTab">
								  	Don't ask for confirmation when closing or refreshing tab
								</label>
								<br/>
								<label class="btn btn-outline btn-primary btn-sm" for="autoCollapse" style="margin-top: 5px;">
									<input type="checkbox" id="autoCollapse">
								  	Disable auto-collapse on menu select
								</label>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>Profile Highest Priority</td>
	    					<td>
	    						<c:forEach items="${ALLAUTH}" var="auth">
	    						<label class="btn btn-outline btn-primary btn-sm" for="profilePriority${auth}" style="margin-right: 3px;">
	    							<input type="radio" name="profilePriority" id="profilePriority${auth}"
	    								value="${f:replace(auth,'ROLE_','')}" <c:if test="${auth eq CURRENTPRIORITY}"> checked </c:if>/>
	    						
	    							${f:replace(auth,'ROLE_','')}
	    						</label>
	    						</c:forEach>
	    						<c:if test="${f:length(ALLAUTH) gt 1}">
		    						<div class="pull-${dirR}">
							            <button type="button" class="btn btn-primary btn-sm" id="updateProfilePriority">Update</button>
							        </div>
						        </c:if>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td width="30%">Change Password
		    					<c:if test="${CHANGEPASSWORD == 'DATABASE'}">
		    						<br/><em style="font-size: 12px">&#x200E;(Last Password changed on ${CHANGEPASSWORDLOG['PASSWORDCHANGEDATE']}, ${CHANGEPASSWORDLOG['CHANGEDAYS']} days ago)&#x200E;</em>
		    					</c:if>
	    					</td>
	    					<td width="70%">
	    						<c:choose>
	    							<c:when test="${CHANGEPASSWORD == 'DATABASE'}">
	    							<div class="form-group">
	    								<label for="oldPassword">Old Password</label>
	    								<input type="password" class="form-control input-sm" id="oldPassword" name="oldPassword" placeholder="Old Password"/>
	    							</div>
	    							<div class="form-group">
	    								<label for="newPassword">New Password</label>
	    								<input type="password" id="newPassword" class="form-control input-sm" name="newPassword" placeholder="New Password"/>
	    							</div>
	    							<div class="form-group">
	    								<label for="confirmPassword">Confirm Password</label>
	    								<input type="password" id="confirmPassword" class="form-control input-sm" name="confirmPassword" placeholder="Confirm Password"/>
	    							</div>
	    							<div class="pull-${dirR}">
							            <button type="button" class="btn btn-primary btn-sm" onclick="changepassword(this)">Update</button>
							        </div>
	    							</c:when>
	    							<c:otherwise>
	    								Compass CM is connected with the Active Directory so you can't change password for here.
	    							</c:otherwise>
	    						</c:choose>
	    						
	    					</td>
	    				</tr>
	    				<tr>
	    					<td width="30%">Select language</td>
	    					<td width="70%">
	    						<div class="input-group" style="padding-${dirR}: 50%">
	    							<select class="form-control input-sm" style="width:100%;" id="userlanguage">
		    							<c:forEach var="lang" items="${ALLLANGCODE}">
		    							<option value="${lang}"
		    							<c:if test="${sessionScope.LANGCODE == lang}">selected="selected"</c:if>
		    							>${lang}</option>
		    							</c:forEach>
		    						</select>
		    						<span class="input-group-btn"  style="padding: 0 5px;">
		    							<button type="button" class="btn btn-primary btn-sm" id="updateLanguage">Update</button>
		    						</span>
	    						</div>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td width="30%">Label Direction</td>
	    					<td width="70%">
	    						<div class="input-group" style="padding-${dirR}: 50%">
	    							<select class="form-control input-sm" id="userLabelDirection">
		    							<option value="ltr" <c:if test="${sessionScope.LABELDIR == 'ltr'}">selected="selected"</c:if>>Left to right</option>
		    							<option value="rtl" <c:if test="${sessionScope.LABELDIR == 'rtl'}">selected="selected"</c:if>>Right to left</option>
	    							</select>
		    						<span class="input-group-btn" style="padding: 0 5px;">
		    							<button type="button" class="btn btn-primary btn-sm" id="updateLabelDirection">Update</button>
		    						</span>
	    						</div>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td width="30%">Update page label properties</td>
	    					<td width="70%">
		    					<button type="button" class="btn btn-primary btn-sm" id="updateLabelProperties">Update</button>
	    					</td>
	    				</tr>
	    			</tbody>
				</table>
	    	</div>
		</div>
	</div>
</div>