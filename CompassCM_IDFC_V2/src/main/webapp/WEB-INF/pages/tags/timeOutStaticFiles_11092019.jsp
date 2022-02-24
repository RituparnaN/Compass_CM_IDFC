<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="tags.jsp"%>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.idletimer.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.idletimeout.js"></script>
<script type="text/javascript">
$(function () {
	$("#dialog").dialog({
		autoOpen: false,
		modal: true,
		width: 400,
		height: 200,
		closeOnEscape: false,
		dialogClass: "alert",
		draggable: false,
		resizable: false,
		open : function(event, ui){
			$(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
		},
		buttons: {
			'Yes, Keep Working': function(){
				$(this).dialog('close');
			},
			'No, Logoff': function(){
				$.idleTimeout.options.onTimeout.call(this);
			}
		}
	});
		
	var $countdown = $("#dialog-countdown");
	
	var idleTime = ${SESSIONTIMEOUT};
	var docTitle = document.title;
	
	setInterval(function(){
		$.ajax({
			url : '${pageContext.request.contextPath}/getIdleTimeout',
			cache : false,
			type : 'POST',
			data : 'role=${CURRENTROLE}',
			success : function(res){
				if(res.ROLE == 0){
					window.location.reload();
				}
			}
		});
	}, 10000);

	// start the idle timer plugin
	$.idleTimeout('#dialog', 'div.ui-dialog-buttonpane button:first', {
		idleAfter: idleTime,
		pollingInterval: 2,
		keepAliveURL: '${pageContext.request.contextPath}/keepAlive',
		serverResponseEquals: 'OK',
		onTimeout: function(){
			document.title = "Logging out...";
			$.ajax({
				url : '${pageContext.request.contextPath}/forceLogout',
				cache : false,
				type : 'POST',
				success : function(res){
					window.location = "${pageContext.request.contextPath}/index";
				}
			});
		},
		onIdle: function(){
			$(this).dialog("open");
		},
		onCountdown: function(counter){
			$countdown.html(counter); // update the counter
			document.title = "You will be logged off in "+counter+" seconds";
		},
		onResume : function(){
			document.title = docTitle;
		}
	});
});
</script>