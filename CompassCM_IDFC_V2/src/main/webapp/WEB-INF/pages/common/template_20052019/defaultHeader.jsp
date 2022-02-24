<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../../tags/tags.jsp"%>

<ul class="nav navbar-top-links navbar-${dirR}" dir="${sessionScope.LABELDIR}">

	<!-- SEARCH FUNCTIONALITY CHANGES STARTED -->
	<li class="dropdown search" id="topBarSearchBox" style="margin-right: -26px; display:none ;">
   		<div class="navSearchBar">
			<input type="text" class="form-control" style="border-radius: 20px;" placeholder="Search" id="topHeaderSearchBoxItem" list="compassUserModuleList" spellcheck = "false"/>
			<datalist id="compassUserModuleList"></datalist>
		</div>
	</li>
	
	<li class="dropdown" style="margin-top:10px;" title="Search">
		<i class="fa fa-search " id="topBarSearchIcon" style="color: #cccccc; font-weight: normal; margin-right: 15px; margin-bottom: -4px;"></i>
	</li>
	<!-- SEARCH FUNCTIONALITY CHANGES ENDED -->
	
	<li class="dropdown emailNotification">
		<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
			<i class="fa fa-envelope fa-fw" id="iconSpin"></i>
			<span class="badge" id="emailCount"></span>
			<i class="fa fa-caret-down" id="emailCountCaret"></i>
		</a>
		<ul class="dropdown-menu dropdown-messages" id="emailDetails">
		</ul>
	</li>
	<!-- /.dropdown -->
	<li class="dropdown taskNotification">
	<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 
			<i class="fa fa-tasks fa-fw"></i>
			<i class="fa fa-caret-down"></i>
	</a>
		<ul class="dropdown-menu dropdown-tasks">						
			<li>
				<a href="javascript:void(0)">
					<div>
						<p>
							<strong>Email Sync</strong> <span class="pull-${dirR} text-muted" id="emailPercentage">Loading...</span>
						</p>
						<div id="emailProcess">
							<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>
						</div>
					</div>
				</a>
			</li>
			
<!-- 	
		<li class="divider"></li>		
		<li>
				<a href="javascript:void(0)">
					<div>
						<p>
							<strong>Extraction</strong> <span class="pull-${dirR} text-muted" id="extractionPercentage">Loading...</span>
						</p>
						<div id="extractionProcess">
							<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>
						</div>
					</div>
				</a>
			</li>
			
			
		<li class="divider"></li>
			
 		<li>
				<a href="javascript:void(0)">
					<div>
						<p>
							<strong>Indexing</strong> <span class="pull-${dirR} text-muted">Loading...</span>
						</p>
						<div id="indexingProcess">
							<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>
						</div>
					</div>
				</a>
			</li>
			
			<li class="divider"></li>
			
			<li>
				<a href="javascript:void(0)">
					<div>
						<p>
							<strong>Screening</strong> <span class="pull-${dirR} text-muted">Loading...</span>
						</p>
						<div id="screeningProcess">
							<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>
						</div>
					</div>
				</a>
			</li> -->	

		</ul> <!-- /.dropdown-tasks --></li>
	<!-- /.dropdown 
	<li class="dropdown pushNotification">
	<a class="dropdown-toggle"
		data-toggle="dropdown" href="#"> <i class="fa fa-bell fa-fw"></i>
			<i class="fa fa-caret-down"></i>
	</a>
		<ul class="dropdown-menu dropdown-alerts">
			<li><a href="#">
					<div>
						<i class="fa fa-comment fa-fw"></i> New Comment <span
							class="pull-${dirR} text-muted small">4 minutes ago</span>
					</div>
			</a></li>
			<li class="divider"></li>
			<li><a href="#">
					<div>
						<i class="fa fa-twitter fa-fw"></i> 3 New Followers <span
							class="pull-${dirR} text-muted small">12 minutes ago</span>
					</div>
			</a></li>
			<li class="divider"></li>
			<li><a href="#">
					<div>
						<i class="fa fa-envelope fa-fw"></i> Message Sent <span
							class="pull-${dirR} text-muted small">4 minutes ago</span>
					</div>
			</a></li>
			<li class="divider"></li>
			<li><a href="#">
					<div>
						<i class="fa fa-tasks fa-fw"></i> New Task <span
							class="pull-${dirR} text-muted small">4 minutes ago</span>
					</div>
			</a></li>
			<li class="divider"></li>
			<li><a href="#">
					<div>
						<i class="fa fa-upload fa-fw"></i> Server Rebooted <span
							class="pull-${dirR} text-muted small">4 minutes ago</span>
					</div>
			</a></li>
			<li class="divider"></li>
			<li><a class="text-center" href="#"> <strong>See
						All Alerts</strong> <i class="fa fa-angle-right"></i>
			</a></li>
		</ul>
	</li>
	-->
	<!-- 
	<c:if test="${CHATENABLE eq true}">
	<li class="dropdown">
		<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
			<i class="fa fa-comment fa-fw" id="userChatStatus"></i>
			<i class="fa fa-caret-down"></i>
		</a>
		<ul class="dropdown-menu dropdown-chat dropdown-alerts stop-dropdown-hide">
			<li class="chatLoadingli">
				<br/>
				<center> 
					<img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...' width="48px;" height="48px"/>
				</center>
				<br/>
			</li>
		</ul>
	</li>
	</c:if>
	 -->	
	<li class="dropdown">
		<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
			<i class="fa fa-user fa-fw"></i>
			<i class="fa fa-caret-down"></i>
		</a>
		<ul class="dropdown-menu dropdown-menu-${dirL} dropdown-user">
			<!-- Current user profile -->
			<li>
				<a href="javascript:void(0)">
					<i class="fa fa-user fa-fw"></i>
					<c:set var="currentProfileName"><spring:message code='app.common.label.currentProfile'/></c:set>
					<c:set var="userName" value="${userDetails.firstName} ${userDetails.lastName }"></c:set>
					<c:set var="currentProfileInfo" value="${f:replace(currentProfileName,'[0]',currentAuthority['roleName'])}"/>
					${f:replace(currentProfileInfo,'[1]',userName)}
				</a>
				
					<div class="alert alert-success" role="alert">
						&#x200E;${LASTLOGIN['SUCCESSFULLOGINTIME']}&#x200E;<br/>
						&#x200E;${LASTLOGIN['SUCCESSFULLOGINTIMEDIFF']}&#x200E; &#x200E;${LASTLOGIN['SUCCESSFROMSYSTEM']}&#x200E;
					</div>
					<div class="alert alert-danger" role="alert">
						&#x200E;${LASTLOGIN['FAILEDLOGINTIME']}&#x200E;<br/>
						&#x200E;${LASTLOGIN['FAILEDLOGINTIMEDIFF']}&#x200E; &#x200E;${LASTLOGIN['FAILEDFROMSYSTEM']}&#x200E;
					</div>
			</li>
			<c:choose>
			<c:when test="${f:length(allAuthorities) gt 0}">
			<!-- Other user profile  -->
			<li class="divider"></li>
				<c:forEach var="authority" items="${allAuthorities}">
					<c:url value="/changeProfile/${authority['roleName']}" var="changeProfileUrl" />
					<li>
						<a href="${changeProfileUrl}"> 
						<i class="fa fa-exchange fa-fw"></i>
						<c:set var="switchProfileName"><spring:message code='app.common.label.switchProfile'/></c:set>
						${f:replace(switchProfileName, '[0]', authority['roleName'])}
						</a>
					</li>
				</c:forEach>	
			</c:when>
			</c:choose>
			<!-- Settings and logout -->
			<li class="divider"></li>
			<li>
				<a href="javascript:void(0)" onclick="navigate('Settings','userSettings','userSettings','1')">
					<i class="fa fa-gear fa-fw"></i>
					<%-- ${label['app.common.label.settings']} --%>
					<label for="userSettings"><spring:message code="app.common.label.settings"/></label>
				</a>
			</li>			
			<li>
				<a href="javascript:void(0)" id="logout">
					<i class="fa fa-sign-out fa-fw"></i>
					<%-- ${label['app.common.label.logout']} --%>
					<label for="logout"><spring:message code="app.common.label.logout"/></label>
				</a>
			</li>
		</ul>
	</li>
</ul>
<c:url value="/logout" var="logoutUrl" />
<form action="${logoutUrl}" method="post" id="logoutForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>

<script>

/*SEARCH FUNCTIONALITY CHANGES STARTED*/

$(document).ready(function(){
	$("#topBarSearchIcon").click(function(){
		$('#topBarSearchBox').fadeToggle(1000,function(){
			$("#topHeaderSearchBoxItem").focus();
		});
	});
	var listItem = "",
	moduleNameArr = [],
	moduleNameObj = {};

	<c:forEach items="${MODULES}" var="MODULES" varStatus="status1" >
	 <c:forEach items ="${MODULES.value.MAINMODULE}" var="subModuleElements">
		 <c:if test="${not empty subModuleElements.value.MODULEURL}">
			 var obj = {};
			obj["MODULECODE"] = "${subModuleElements.value.MODULECODE}";
			obj["MODULEURL"]  = "${subModuleElements.value.MODULEURL}";
			obj["MODULENAME"] = "${subModuleElements.value.MODULENAME}";
			obj["ISMULTIPLE"] = "${subModuleElements.value.ISMULTIPLE}";
			moduleNameObj["${subModuleElements.value.MODULENAME}"] = obj;
		 </c:if>
	 </c:forEach>
	 <c:forEach items="${MODULES.value.SUBMODULE}" var="subModuleElements">
	 	var obj = {};
		obj["MODULECODE"] = "${subModuleElements.value.MODULECODE}";
		obj["MODULEURL"]  = "${subModuleElements.value.MODULEURL}";
		obj["MODULENAME"] = "${subModuleElements.value.MODULENAME}";
		obj["ISMULTIPLE"] = "${subModuleElements.value.ISMULTIPLE}";
		moduleNameObj["${subModuleElements.value.MODULENAME}"] = obj;
	 </c:forEach>
	</c:forEach> 
	
	moduleNameArr = Object.keys(moduleNameObj);
	//console.log(" modules = "+moduleNameArr);
	
	//for searching
	$("#topHeaderSearchBoxItem").on('input', function(e){
	    let inputItem = $(this).val().trim();
	    $('#compassUserModuleList').empty()
	    var matchedModuleName = moduleNameArr.filter(function(moduleName) {
	    	  return  moduleName.toUpperCase().includes(inputItem.toUpperCase());
	    });
	    if(inputItem !== ""){
		    for (var moduleName in matchedModuleName) {
			    let optionElement = document.createElement("option");
			    optionElement.value = matchedModuleName[moduleName];
			    $("#compassUserModuleList").append(optionElement);
			  }
	    }
	    if($('#compassUserModuleList option').filter(function(){
	        listItem = this.value;
	    	return this.value.toUpperCase() === inputItem.toUpperCase();        
	    }).length) {
	    	let searchedModuleName = moduleNameObj[listItem]['MODULENAME'];
	   		let searchedModuleCode = moduleNameObj[listItem]['MODULECODE'];
	   		let searchedModuleURL = moduleNameObj[listItem]['MODULEURL'];
	    	let searchedModuleIsMultiple = moduleNameObj[listItem]['ISMULTIPLE'];
	    	navigate(searchedModuleName,searchedModuleCode,searchedModuleURL,searchedModuleIsMultiple);
	    	$('#compassUserModuleList').empty()
	    }
	});

});

/*SEARCH FUNCTIONALITY CHANGES ENDED*/

</script>