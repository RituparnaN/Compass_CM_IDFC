<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="tags.jsp"%>
<!-- 
This page is for all the static contents like StyleSheet and JavaScript files.
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<!-- Popper.js  -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/popper.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
 
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/metisMenu.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTables.bootstrap.js"></script>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTables.bootstrap4.js"></script>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTables.tableTools.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/flot/jquery.flot.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.slimscroll.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/dataTables.buttons.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.flash.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/jszip.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/pdfmake.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/vfs_fonts.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.html5.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.print.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap-select.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.fileDownload.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/master-module-hyperlinks.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassDatatable.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassTopFrame.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassTopFrameFromPortal.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassFileUpload.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassFileUploadFromPortal.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CaseWorkFlowActions.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/RFICaseWorkFlowActions.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/RFICaseWorkFlowActionsNew.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/riskAssessmentMaster.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassEmailExchange.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/select2.min2.js"></script>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassStaffEmailExchange.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/ckeditor/ckeditor.js"></script>

<!--Pie chart Pizza -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/pizza.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/snap.svg-min.js"></script>

<!--Horizontal Bar Graph Bars -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/bars.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/d3.v3.min.js"></script>
<!--<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Base64.js"></script>-->
<!-- for recording audio -->
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/browserSpeechRecognition/recorder/recorder.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/CompassUserNotes.js"></script>

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/includes/scripts/html5shiv.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/respond.min.js"></script>
<![endif]-->

<!--for chart js, Starts Here -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/datetime-moment.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/Chart.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/chartjs-chart-treemap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/ChartJsPlugin/chartjs-plugin-datalabels.min.js"></script>
<!--for chart js, Ends Here -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/ChartJs/customChartJsFunction.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/ChartJsPlugin/ChartJSPieceLabel.js"></script>
<!-- JS to convert HTML element to canvas -->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/DashboardGraph/dom-to-image.js"></script>
<script type="text/javascript" src = "${pageContext.request.contextPath}/includes/scripts/JuliusVoice/julius.js"></script>
<script src="${pageContext.request.contextPath}/includes/scripts/slider/jQAllRangeSliders-withRuler-min.js"></script>

<script type="text/javascript">
$(function () {
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    var multiTabDisplay = 1;
    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(header, token);
    });
    //for sorting date in data table
    $.fn.dataTable.moment( 'DD/MM/YYYY' );
    
    $(document).on('shown.bs.tab', 'a[data-toggle="tab"]:not(.subTab)' ,function(e){
    	$('a[data-toggle="tab"]:not(.subTab)').each(function(){
    		$(this).css("background-color","white");
    		$(this).css("color","#337ab7");
    		$(this).css("font-weight","normal");
    	});
    	var prevId = $(e.relatedTarget);
    	var currId = $(e.target);
    	$(prevId).css("font-weight","700");
    	$(prevId).css("color","red");
    	$(prevId).css("background-color","#ffe6e6");
    	
    	$(currId).css("background-color","#EEEEEE");
    	$(currId).css("color","black");
    	$(currId).css("font-weight","900");
    });
    
    $("#logout").click(function() {
		$("#logoutForm").submit();
	});
        
    $(".modal-dialog").draggable({
    	handle : '.modal-header'
    });
        
    $(document).keydown(function(event){
        if(event.which=="9"){
        	if( $("#compassGenericModal").hasClass("in")){
        		var selectedTab = $("#compassGenericModal").find("div#compassGenericModal-body").find("ul.modalNav").children("li.active");
        		var selectedTabIndex = $(selectedTab).index();
        		var nextTab = selectedTabIndex + 2;
        		var nextTabObj = $("#compassGenericModal").find("div#compassGenericModal-body").find("ul.modalNav").children("li:nth-child("+nextTab+")");
        		var href;
        		
        		if($(nextTabObj).html() == undefined){
        			var href = $("#compassGenericModal").find("div#compassGenericModal-body").find("ul.modalNav").children("li:first-child").children("a").attr("href");
        		}else{
        			var href = $(nextTabObj).children("a").attr("href");        			
        		}
        		$(".modalNav a[href="+href+"]").tab('show');
        	}
        }
    });
        
    
    $("#toggleSidebar").click(function(e) {
    	toggleSidebar();
    });
    
    $("#compassSideBar").metisMenu();
    
    $("#compassSideBar").slimScroll({
    	height: $(this).outerHeight()- 75,
        color: '#000',
        size: '10px',
        opacity : .55,
        wheelStep : 10,
        touchScrollStep : 75,
        distance : '2px',
        railVisible: false,
        railOpacity: 1
    });
    
    $(".stop-dropdown-hide").click(function(event){
    	event.stopPropagation();
    });
    
    $(".nav-tabs").on("click", "span.close", function () {
    	var closeRefresh = $("#closeRefreshTabInput").val();
    	var selectedTab;
    	if($(this).parents("li").next().html() == undefined)
    		selectedTab = $(this).parents("li").prev();
    	else
    		selectedTab = $(this).parents("li").next();
    	
    	if(closeRefresh == 1){
    		if(confirm("Do you want to close this tab?")){
		        var anchor = $(this).siblings('a');
		        var finalId = $(this).parent().attr('id');
		        $('.tab-content').children("div."+finalId).detach();
		        $(anchor.attr('href')).detach();
		        $(this).parent().detach();
		    	$(selectedTab).children('a').first().click();
	    	}
    	}else{
    		var anchor = $(this).siblings('a');
	        $(anchor.attr('href')).detach();
	        $(this).parent().detach();
	        $(selectedTab).children('a').first().click();
    	}
	    	
    })
    .on("click", "span.refresh", function () {
    	var vals = $(this).attr('display');
    	$(this).parent().children('a').click();
    	var splitVal = vals.split(',');
    	var closeRefresh = $("#closeRefreshTabInput").val();
    	if(closeRefresh == 1){
    		if(confirm("Do you want to refresh this tab?")){
	        	displayPage(splitVal[0], splitVal[1], splitVal[2]);
	    	}
    	}else{
    		displayPage(splitVal[0], splitVal[1], splitVal[2]);
    	}	    	
    });
    
    var obj = $("#dragandrophandler");
	obj.on('dragenter', function (e) {
	    e.stopPropagation();
	    e.preventDefault();
	    $(this).css('border', '2px solid #0B85A1');
	});
	obj.on('dragover', function (e) {
	     e.stopPropagation();
	     e.preventDefault();
	});
	obj.on('drop', function (e) {
	     $(this).css('border', '2px dotted #0B85A1');
	     e.preventDefault();
	     var files = e.originalEvent.dataTransfer.files;
	     for(var i = 0; i < files.length; i++){
	    	 compassFileUpload.pushFile(files[i]);
	     }
	});
	
	$(document).on('dragenter', function (e){
		e.stopPropagation();
		e.preventDefault();
	});
	
	$(document).on('dragover', function (e) {
		e.stopPropagation();
		e.preventDefault();
		obj.css('border', '2px dotted #0B85A1');
	});
	
	$(document).on('drop', function (e){
		e.stopPropagation();
		e.preventDefault();
	});
	
	$("#compassGenericModal").on("hidden.bs.modal", function(){
		$("#compassGenericModal-body").html("");
		$("#compassGenericModal-title").html("");
	});
	
	$("#compassCaseWorkFlowGenericModal").on("hidden.bs.modal", function(){
		$("#compassCaseWorkFlowGenericModal-body").html("");
		$("#compassCaseWorkFlowGenericModal-title").html("");
		//alert($("#compassCaseWorkFlowGenericModal").html());
	});
	
	$("#compassMediumGenericModal").on("hidden.bs.modal", function(){
		$("#compassMediumGenericModal-body").html("");
		$("#compassMediumGenericModal-title").html("");
	});
	
	/*$("#compassFileUploadModal").on("hidden.bs.modal", function(){
		$("#compassFileUploadModal-body").html("");
		$("#compassFileUploadModal-title").html("");
	});*/
	
	$("#compassSearchModuleModal").on("hidden.bs.modal", function(){
		$("#compassSearchModuleModal-body").html("");
		$("#compassSearchModuleModal-title").html("");
	});
	
	$("#compassEmailQuestionModal").on("hidden.bs.modal", function(){
		$("#compassEmailQuestionModal-body").html("");
		$("#compassEmailQuestionModal-title").html("");
	});
	
	$("#composeEmailMessageModal").on("hidden.bs.modal", function(){
		$("#composeEmailMessageModal-body").html("");
		$("#composeEmailMessageModal-title").html("");
	});
	
	$("#tdCellCustomTooltipModel").on("hidden.bs.modal", function(){
		$("#tdCellCustomTooltipModel-body").html("");
		$("#tdCellCustomTooltipModel-title").html("");
	});
	
	$(document).on('show.bs.modal', '.modal', function (event) {
        var zIndex = 1040 + (10 * $('.modal:visible').length);
        $(this).css('z-index', zIndex);
        setTimeout(function() {
            $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
        }, 0);
    });

	
	$("#openRTModalInWindow").click(function(){
		
		var url_attr = $(this).attr("url-attr");
		//alert("url_attr"+url_attr);
		
		var url_attr_encoded = Base64.encode(url_attr);
		//alert("url_attr_encoded"+url_attr_encoded);
		
		var data_attr = $(this).attr("data-attr");
		//alert("data_attr"+data_attr);
		
		var data_attr_encoded = Base64.encode(data_attr);
		//alert("data_attr_encoded"+data_attr_encoded);
		
		var url = '${pageContext.request.contextPath}/common/RTScanningNewWindow?url-attr-encoded='+url_attr_encoded+'&data-attr-encoded='+data_attr_encoded;
		window.open(url, "RealTimeScreening", 'height=600px,width=1000px');
	});
});
</script>
<script type="text/javascript">
function toggleSidebar(){
	var toggleHandler = $("#toggleSidebar");
	if($(toggleHandler).attr("expand") == "1" || $(toggleHandler).attr("expand") == undefined){
		$(".sidebar").hide();
        $("#page-wrapper").css("margin-left", "0px");
        $(toggleHandler).attr("expand", "2");
        $(toggleHandler).find(".fa").removeClass("fa-expand").addClass("fa-compress");
	}else{
		$(".sidebar").show();
        $("#page-wrapper").css("margin-left", "250px");
        $(toggleHandler).attr("expand", "1");
        $(toggleHandler).find(".fa").removeClass("fa-compress").addClass("fa-expand");
	}
}
function checkAll(elm, tableId){
	if($(elm).is(":checked")){
		$("#"+tableId+" > tbody > tr").each(function(){
			$(this).find("td.checkbox").children().prop('checked', true);
		});
	}else{
		$("#"+tableId+" > tbody > tr").each(function(){
			$(this).find("td.checkbox").children().removeAttr("checked");
		});
	}
}

 function navigate(displayName, accid, Url, isMultiple){
	 if($("#autoCollapseInput").val() == 1){
	 	toggleSidebar();
	 }
	 	var openedTab = $(".compass-nav-tabs > li[class*='litab"+accid+"']").length;
		var lastTabIndex = $(".compass-nav-tabs").children().length;
		var multiTabDisplay = $("#multiTabDisplayInput").val();

//Restricting maximum number of opened tabs without counting Dashboard
	if(lastTabIndex <= 10){	
		if(isMultiple == 0){
			// only for dashboard
			$(".compass-nav-tabs > li.litab"+accid+" a").click();
		}else{
			if(isMultiple == 1){
				// if module supports only one tab
				var finalId = accid;
				if($(".compass-nav-tabs > li.litab"+accid).length > 0){
					// if the tab is alread opened
					$(".compass-nav-tabs > li.litab"+accid+" a").click();
					displayPage(finalId, accid, Url);
				}else{
					// else open the tab and fetch page
					$(".compass-nav-tabs > li:last").closest('li').after('<li class="cardForTabs litab'+finalId+'" id="litab'+finalId+'"><a class="nav-link" data-toggle="tab" href="#'+finalId+ '">'+displayName+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><span class="refresh" display="'+finalId+','+accid+','+Url+'"> <i class="fa fa-refresh"></i></span><span class="close"> <i class="fa fa-times"></i></span></li>');
					$('.compass-tab-content').append('<div class="tab-pane litab'+finalId+'" id="'+finalId+'"></div>');	
					lastTabIndex = $(".compass-nav-tabs").children().length;
					$('.compass-nav-tabs li:nth-child(' + lastTabIndex + ') a').click();
					displayPage(finalId, accid, Url);
				}
			}else{
				// else module supports multiple tab display
				if(multiTabDisplay == 1){
					// if user has enabled multiple tab display
					if(openedTab < isMultiple){
						// if user has opened less number of tab less than max allowed number of tabs
						var finalId = accid+lastTabIndex;
						$(".compass-nav-tabs > li:last").closest('li').after('<li class="cardForTabs litab'+finalId+'" id="litab'+finalId+'"><a class="nav-link" data-toggle="tab" href="#'+finalId+ '">'+displayName+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><span class="refresh" display="'+finalId+','+accid+','+Url+'"> <i class="fa fa-refresh"></i></span><span class="close"> <i class="fa fa-times"></i></span></li>');
						$('.compass-tab-content').append('<div class="tab-pane litab'+finalId+'" id="'+finalId+'"></div>');	
						lastTabIndex = $(".compass-nav-tabs").children().length;
						$('.compass-nav-tabs li:nth-child(' + lastTabIndex + ') a').click();
						displayPage(finalId, accid, Url);
					}else{
						// else prompt
						alert("Maximum of "+isMultiple+" tabs can be opened for "+displayName);
					}
				}else{
					var finalId = accid;
					// user has disbled multiple tab display
					if(openedTab > 0){
						// if the tab is alread opened
						$(".compass-nav-tabs > li[class*='litab"+accid+"']:first a").click();
						displayPage(finalId, accid, Url);
					}else{
						// else open the tab and fetch page
						$(".compass-nav-tabs > li:last").closest('li').after('<li class="cardForTabs litab'+finalId+'" id="litab'+finalId+'"><a class="nav-link" data-toggle="tab" href="#'+finalId+ '">'+displayName+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><span class="refresh" display="'+finalId+','+accid+','+Url+'"> <i class="fa fa-refresh"></i></span><span class="close"> <i class="fa fa-times"></i></span></li>');
						$('.compass-tab-content').append('<div class="tab-pane litab'+finalId+'" id="'+finalId+'"></div>');	
						lastTabIndex = $(".compass-nav-tabs").children().length;
						$('.compass-nav-tabs li:nth-child(' + lastTabIndex + ') a').click();
						displayPage(finalId, accid, Url);
					}
				}
			}
			}
		}else{
			//alert("Maximum number of open tabs exceeded!");
			if(confirm("Maximum number of open tabs exceeded! Click ok to auto-close the first opened tab.")){
				//alert($(".compass-nav-tabs > li:nth-child(2) > span.close").html());
				$(".compass-nav-tabs > li:nth-child(2) > span.close").click();
				$(".sidebar").show();
				$("#page-wrapper").css("margin-left", "250px");
		        $(toggleHandler).attr("expand", "1");
		        $(toggleHandler).find(".fa").removeClass("fa-compress").addClass("fa-expand");
			}else{
				alert("Close one tab to open more.");
				$(".sidebar").show();
				$("#page-wrapper").css("margin-left", "250px");
		        $(toggleHandler).attr("expand", "1");
		        $(toggleHandler).find(".fa").removeClass("fa-compress").addClass("fa-expand");
			}
		}
	}

 /*
function navigate(displayName, accid, Url, isMultiple){
	if($(".nav-tabs > li.litab"+accid).length > 0 && isMultiple == 0){
		$(".nav-tabs > li.litab"+accid+" a").click();
	}else{
		var id = $(".nav-tabs").children().length;
		if(isMultiple == 1){
			var finalId = accid+""+id;					
		}else{
			var finalId = accid;
		}
		$(".nav-tabs > li:last").closest('li').after('<li class="litab'+finalId+'"><a class="nav-link"  href="#'+finalId+ '">'+displayName+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a><span class="refresh" display="'+finalId+','+accid+','+Url+'"> <i class="fa fa-refresh"></i></span><span class="close"> <i class="fa fa-times"></i></span></li>');
		$('.tab-content').append('<div class="tab-pane" id="'+finalId+'"></div>');	
		id = $(".nav-tabs").children().length;
		$('.nav-tabs li:nth-child(' + id + ') a').click();
		displayPage(finalId, accid, Url);
	}
}
 */
function displayPage(finalId, accid, url){
	$("#"+finalId).html("<br/><br/><br/><br/><br/><br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
	var fullUrl = '${pageContext.request.contextPath}/'+url+'?moduleType='+accid;
	
	if(url.indexOf("?") > 0)
		fullUrl = '${pageContext.request.contextPath}/'+url+'&moduleType='+accid;
	
	$.ajax({
		url : fullUrl,
		cache : false,
		type : 'GET',
		success : function(resData){
			$("#"+finalId).html(resData);
		},
		error : function(jqXHR, textStatus , errorThrown){
			$("#"+finalId).html(errorThrown+"<br/><br/>Loading...");
			$.ajax({
				url : '${pageContext.request.contextPath}/loadErrorPage?errorCode='+jqXHR.status,
				cache : false,
				type : 'GET',
				success : function(errorData){
					$("#"+finalId).html(errorData);
				}
			});
		}
	});
}
 
function reloadTabContent(){
	/* var refreshBtn = "span.refresh";
	var vals = $(refreshBtn).parent().parent().find('li.active').find('span.refresh').attr('display'); */
	/* console.log($(refreshBtn).parent().parent().find('li.active').find('span.refresh').attr('display'));
	console.log($(refreshBtn).parent().parent().find('li.active').children('a').html());
	console.log($(refreshBtn).attr('display'));
	console.log($(refreshBtn).parent().children('a').html()); 
	$(refreshBtn).parent().children('a').click(); */
	/* $(refreshBtn).parent().parent().find('li.active').children('a').click();
	var splitVal = vals.split(',');
    displayPage(splitVal[0], splitVal[1], splitVal[2]);	  */
	var refreshBtn = "span.refresh";
	var vals = $(refreshBtn).parent().parent().find('a.active').parent().find('span.refresh').attr('display');
	$(refreshBtn).parent().children('a.active').click(); 
	$(refreshBtn).parent().find('a.active').click();
	var splitVal = vals.split(',');
    displayPage(splitVal[0], splitVal[1], splitVal[2]);	
}
		 
 
</script>
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/dataTables.bootstrap4.min.css" />

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/metisMenu.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/buttons.dataTables.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap-select.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/template/default.css" />
<link rel="stylesheet" media="screen, projector, print" type="text/css" href="${pageContext.request.contextPath}/includes/styles/Graphs/pizza.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/Graphs/bars.css" >
<link rel="shortcut icon" href="${pageContext.request.contextPath}/includes/images/favicon/favicon.ico" />
<link rel="stylesheet" media="screen, projector, print" type="text/css" href="${pageContext.request.contextPath}/includes/styles/Graphs/compassGraph.css">
<link rel="stylesheet" type="text/css"  href="${pageContext.request.contextPath}/includes/styles/slider/classic.css" >