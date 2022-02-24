<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../../tags/tags.jsp"%>
<style>
	 .modulesPrioritized{
		/*  background: aliceblue; */ 
		cursor: pointer;
	}
	
	.dropdown-modules{
		display: none;
	}
		
	.header-module-list a {
		display: block;
		padding:20px 4px;
	}
	
	.header-module-list{
	 padding:5px 0;
	 border-bottom: 1px solid #eee;
	 font-size: 14px !important;
	}		
			
	
	.visitedModuleList .dropdown-menu {
		margin: 0;
	} 
		
	.visitedModuleList:hover .dropdown-modules{
		display: block;
	}
	
	.visitedModuleList .hideModules{
		display: none;
	}
	.visitedModuleList a {
		width:46px; 
	}
		
	.visitedModuleList a img {
		width: 100%;
	} 

	.tourbackdrop{
		opacity: 0.6 !important;
	}
	
	.recodingGoingOn {
  		color:red;
  		animation: blinker 1.5s cubic-bezier(.5, 0, 1, 1) infinite alternate;  
	}
	@keyframes blinker {  
  		from { opacity: 1; }
  		to { opacity: 0; }
	}
	
	.text-dark {
    color: #343a40 !important;
	}
	
	.noBackground {
    background: transparent !important;
	}	
	
	.vistModuleImage{
	height: 14px;
	width: 14px !important;
	}
	
	.aboutUserdrpDwn{
	min-width: 17.35rem;
	width: 320px;
	font-size: 14px;
	padding: 8px 0;
	}
	
	
	
</style>

<script type="text/javascript">

$(document).ready(function() {
	var id = "${UNQID}";
	
	var wholeData = [];
	<c:forEach var="WHOLEDATA" items="${NOTESDATA}">
		var eachData = {};
		<c:forEach var="EACHDATA" items="${WHOLEDATA}">
			eachData["${EACHDATA.key}"] = "${EACHDATA.value}";
		</c:forEach>
		wholeData.push(eachData);
	</c:forEach>

	/* Passing the data, unqid and interval of 60 seconds */
	compassUserNotes.userNotesInterval(wholeData, id, 60000, "Start");
	
	//navigate("M","mostVisitedModules","common/mostVisitedModules",1);

 	var wholeData = [];
	<c:forEach var="WHOLEDATA" items="${COUNTWISEMODULES}">
		var eachData = {};
		<c:forEach var="EACHDATA" items="${WHOLEDATA}">
			eachData["${EACHDATA.key}"] = "${EACHDATA.value}";
		</c:forEach>
		wholeData.push(eachData);
	</c:forEach>
	
	
	$.each(wholeData, function(index, eachRecord){
		$.each(eachRecord, function(key, value){
//			console.log(key+" "+value);
			$(".dropdown-modules").append(
				"<li class='header-module-list'><a class='nav-link modulesPrioritized' style='width:100%;' id="+key+">"+
				value+"</a></li>"
			);
		});
	});
	
	var moduleLength=wholeData.length;
	$('.module-list').css("width",100/moduleLength + '%');
	
	$(".modulesPrioritized").on("click", function(){
		var moduleName = $(this).text();
		let selectedModuleName = moduleNameObj[moduleName]['MODULENAME'];
   		let selectedModuleCode = moduleNameObj[moduleName]['MODULECODE'];
   		let selectedModuleURL = moduleNameObj[moduleName]['MODULEURL'];
    	let selectedModuleIsMultiple = moduleNameObj[moduleName]['ISMULTIPLE']; 
    	navigate(selectedModuleName,selectedModuleCode,selectedModuleURL,selectedModuleIsMultiple);
    	$("#moduleDetails").addClass("hideModules"); 
	}); 
	
	//$(document).find(".litabdashboard").find("a").text("D");
	var dashboardTabWidth = $(document).find(".litabdashboard").width()
	//console.log(dashboardTabWidth);
	//$(document).find(".litabdashboard , .litabmostVisitedModules").children().css({"width":"50px"});
	$(document).find(".litabdashboard").children().css("margin-right","0");
});

var username = '${userDetails["username"]}';

function openNotesModal(){
	compassUserNotes.userNotesInterval("", "", "", "Stop");
	
	$.ajax({
		url: "${pageContext.request.contextPath}/common/openModalForNotes",
		cache: false,
		type: "GET",
		success: function(res){
			$("#compassSearchModuleModal").modal("show");
			$("#compassSearchModuleModal-title").html("Notes for "+username);
			$("#compassSearchModuleModal-body").html(res);
		},
		error: function(a,b,c){
			alert(a+b+c);
		}
	});
}


function investigationStat(){
	$.ajax({
		url: "${pageContext.request.contextPath}/common/openModalToViewInvestigationStatistics",
		cache: false,
		type: "POST",
		success: function(res){
			$("#compassGenericModal").modal("show");
			$("#compassGenericModal-title").html("Investigation Statistics");
			$("#compassGenericModal-body").html(res);
		},
		error: function(a,b,c){
			alert(a+b+c);
		}
	});
}
</script>

<ul class="nav navbar-top-links navbar-${dirR} ml-auto" dir="${sessionScope.LABELDIR}">

	<!-- SEARCH FUNCTIONALITY CHANGES STARTED -->
	<li class="dropdown search noBackground" id="topBarSearchBox" style="margin-right: -15px; margin-top: 15px; display:none ;">
   		<div class="navSearchBar">
			<input type="text" class="form-control input-sm" style="border-radius: 20px;  height: 20px; width: 150px;" placeholder="Search" id="topHeaderSearchBoxItem" list="compassUserModuleList" spellcheck = "false"/>
			<datalist style="width: 5px; word-wrap: break-word;" id="compassUserModuleList"></datalist>
		</div>
	</li>
	
	<li class="dropdown noBackground" style="margin-top:15px;" title="Search">
		<i class="fa fa-search " id="topBarSearchIcon" style="color: #cccccc; font-weight: normal; margin-right: 15px; margin-bottom: -4px;"></i>
	</li>
	<!-- SEARCH FUNCTIONALITY CHANGES ENDED -->
	<!-- speech recording start -->
	<li title="Maya" class="noBackground"><input type = "text" class="form-control input-sm" style="border-radius: 20px; height: 20px; margin-top: 15px; width: 150px;" id = "convertedTextFromSpeech" /> </li>
	<li title="Maya" class="noBackground" style="margin-top: 15px;">
		<i class="fa fa-microphone" id = "startSphinixSpeechRecognition" style="color: #cccccc; font-weight: normal; margin-right: 15px; margin-left: 5px; margin-bottom: -4px;">
		<!-- style="font-size:20px;color:white;"> -->
		</i>
	</li>
	<!-- speech recording end -->
	 <li class="visitedModuleList" title="Most Visited Modules">
		<a class="nav-link modules mvmPin" id="moduleIcon" data-toggle="dropdown" >
			<img class=" vistModuleImage" src='${pageContext.request.contextPath}/includes/images/pin-white.png' />
		</a>
		<ul class="dropdown-menu dropdown-modules" id="moduleDetails">
		</ul>
	</li> 
	<li class="notes">
		<a class="nav-link" id="notesIcon" data-toggle="dropdown" onclick="openNotesModal()" title="Notes">
			<i class="fa fa-book fa-fw" aria-hidden="true"></i>
		</a>
	</li>
	<c:if test="${currentAuthority['roleName'] ne 'ADMIN'}">
		<li class="dropdown dashboardNotification">
		<a class="nav-link" href="javascript:void(0)" id="compassGraph" onclick="return investigationStat()" title="Investigation Statistics">
			<i class="fa fa-bar-chart"></i>
			<i class="fa fa-caret-down"></i>
		</a>
		</li> 
	</c:if>
	<li class="dropdown emailNotification" title="Email" style="margin-right: 1px;">
		<a class="nav-link" data-toggle="dropdown" href="javascript:void(0)">
			<i class="fa fa-envelope fa-fw" id="iconSpin"></i>
			<span class="badge" id="emailCount"></span>
			<i class="fa fa-caret-down" id="emailCountCaret"></i>
		</a>
		<ul class="dropdown-menu dropdown-messages" id="emailDetails" style="left: -252px;">
		</ul>
	</li>
	<!-- /.dropdown -->
	<li class="dropdown taskNotification" title="Task Manager" style="margin-right: 1px;">
	<a class="nav-link" data-toggle="dropdown" href="#"> 
			<i class="fa fa-tasks fa-fw"></i>
			<i class="fa fa-caret-down"></i>
	</a>
		<ul class="dropdown-menu dropdown-tasks" style="left: -255px;">						
			<li>
				<a class="nav-link" href="javascript:void(0)">
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
	<a class="nav-link"
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
		<a class="nav-link" data-toggle="dropdown" href="javascript:void(0)">
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
	<li class="dropdown" title="About User" style="">
		<a class="nav-link" data-toggle="dropdown" href="javascript:void(0)">
			<i class="fa fa-user fa-fw"></i>
			<i class="fa fa-caret-down"></i>
		</a>
		<ul class="aboutUserdrpDwn dropdown-menu dropdown-menu-${dirL} dropdown-user">
			<!-- Current user profile -->
			<li>
				<a class="nav-link text-dark" href="javascript:void(0)">
					<i class="fa fa-user fa-fw"></i>
					<c:set var="currentProfileName"><spring:message code='app.common.label.currentProfile'/></c:set>
					<c:set var="userName" value="${userDetails.firstName} ${userDetails.lastName }"></c:set>
					<c:set var="currentProfileInfo" value="${f:replace(currentProfileName,'[0]',currentAuthority['roleName'])}"/>
					${f:replace(currentProfileInfo,'[1]',userName)}
				</a>
				<br>
				<li>
					<div class="bg-info">
						<font style="color: black; margin-left: 15px;">${Domain} As Domain</font>
					</div>
				</li>
				<br>
				
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
						<a class="nav-link text-dark" href="${changeProfileUrl}"> 
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
				<a class="nav-link text-dark" href="javascript:void(0)" onclick="navigate('Settings','userSettings','userSettings','1')">
					<i class="fa fa-gear fa-fw"></i>
					<%-- ${label['app.common.label.settings']} --%>
					<label for="userSettings"><spring:message code="app.common.label.settings"/></label>
				</a>
			</li>			
			<li>
				<a class="nav-link text-dark" href="javascript:void(0)" id="logout">
					<i class="fa fa-sign-out fa-fw"></i>
					<%-- ${label['app.common.label.logout']} --%>
					<label for="logout"><spring:message code="app.common.label.logout"/></label>
				</a>
			</li>
		</ul>
	</li>
	<%-- <li>
		<img src="${pageContext.request.contextPath}/includes/images/${Domain}.png" title="${Domain}" id="domainImage">
		</img>
	</li> --%>
</ul>
<c:url value="/logout" var="logoutUrl" />
<form action="${logoutUrl}" method="post" id="logoutForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>

<script>

/*SEARCH FUNCTIONALITY CHANGES STARTED*/
var listItem = "";
var moduleNameArr = [];
var moduleNameObj = {};
//for constructing data for module search
<c:forEach items="${MODULES}" var="MODULES" varStatus="status1" >
 <c:forEach items ="${MODULES.value.MAINMODULE}" var="subModuleElements">
	 <c:if test="${f:length(MODULES.value.SUBMODULE) eq 0}">
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
var sphinixRecordingRecognitionUrl = "${pageContext.request.contextPath}/common/sphinixRecordingRecognition";

</script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/moduleSearch.js" defer></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/sphinixSpeechRecordingOperations.js" defer></script>
