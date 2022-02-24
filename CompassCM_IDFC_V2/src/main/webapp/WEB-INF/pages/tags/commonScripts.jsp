<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="tags.jsp"%>
<script type="text/javascript">
var count = 1;
function getProcessStatus(){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/processTaskStatus',
		cache : false,
		type : 'POST',
		success : function(resData){
			if(resData.RELOAD.RELOAD == "1"){
				if(!$(".taskNotification").hasClass("open")){
					if(resData.EXTRACTIONDETAILS.percentage != ""){
						count++;
						if(count % 2 == 0)
							$(".taskNotification a i").css("color", "#6EC06E");
						else
							$(".taskNotification a i").css("color", "#CCCCCC");
					}else if(resData.EMAILREFRESH.percentage != ""){
						count++;
						if(count % 2 == 0)
							$(".taskNotification a i").css("color", "#4F93CE");
						else
							$(".taskNotification a i").css("color", "#CCCCCC");
					}else{
						count = 0;
						$(".taskNotification a i").css("color", "#CCCCCC");
					}
				}
				$("#emailPercentage").html(resData.EMAILREFRESH.percentage);
				$("#emailProcess").html(resData.EMAILREFRESH.process);
				$("#extractionPercentage").html(resData.EXTRACTIONDETAILS.percentage);
				$("#extractionProcess").html(resData.EXTRACTIONDETAILS.process);
				$("#emailDetails").html(resData.EMAILNOTIFICATION.emailString);
				$("#emailCount").html(resData.EMAILNOTIFICATION.emailCount);
				//alert(parseInt(resData.EMAILNOTIFICATION.emailCount)==0);
				if(parseInt(resData.EMAILNOTIFICATION.emailCount) > 0){
					$("#emailDetails").css("display", "block");
					$("#emailCountCaret").css("display", "block");
				}else{
					$("#emailDetails").css("display", "none");
					$("#emailCountCaret").css("display", "none");
				}
						
			}else{
				window.loaction.reload();
			}
		}
	});
}

function getNewProcessStatus(){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/processTaskStatusNew',
		//url : '${pageContext.request.contextPath}/common/processTaskStatus',
		cache : false,
		type : 'POST',
		success : function(resData){
			if(resData.RELOAD.RELOAD == "1"){
				if(!$(".taskNotification").hasClass("open")){
					if(resData.EXTRACTIONDETAILS.percentage != ""){
						count++;
						if(count % 2 == 0)
							$(".taskNotification a i").css("color", "#6EC06E");
						else
							$(".taskNotification a i").css("color", "#CCCCCC");
					}else if(resData.EMAILREFRESH.percentage != ""){
						count++;
						if(count % 2 == 0)
							$(".taskNotification a i").css("color", "#4F93CE");
						else
							$(".taskNotification a i").css("color", "#CCCCCC");
					}else{
						count = 0;
						$(".taskNotification a i").css("color", "#CCCCCC");
					}
				}
				$("#emailPercentage").html(resData.EMAILREFRESH.percentage);
				$("#emailProcess").html(resData.EMAILREFRESH.process);
				// $("#extractionPercentage").html(resData.EXTRACTIONDETAILS.percentage);
				// $("#extractionProcess").html(resData.EXTRACTIONDETAILS.process);
				$("#emailDetails").html(resData.EMAILNOTIFICATION.emailString);
				$("#emailCount").html(resData.EMAILNOTIFICATION.emailCount);
				if(parseInt(resData.EMAILNOTIFICATION.emailCount) == 0){
					$("#emailDetails").css("display", "none");
					$("#emailCountCaret").css("display", "none");
				}
				//alert(parseInt(resData.EMAILNOTIFICATION.emailCount));
				/*
				if(parseInt(resData.EMAILNOTIFICATION.emailCount) > 0){
					$("#emailDetails").css("display", "block");
					$("#emailCountCaret").css("display", "block");
				}else{
					$("#emailDetails").css("display", "none");
					$("#emailCountCaret").css("display", "none");
				}
				*/		
			}else{
				window.loaction.reload();
			}
		}
	});
}

function refreshEmail(elm){
	 $(elm).attr("disabled","disabled");
	 $(elm).html("Refreshing...");
	 $.ajax({
			url : '${pageContext.request.contextPath}/common/refreshEmail',
			cache : false,
			type : 'POST',
			success : function(resData){
			},
			error : function(jqXHR, textStatus , errorThrown){
				alert("Error while refreshing email");
			}
		});
}

function keepAlive(){
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
}

function getAllChatUser(){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/getAllChatUser',
		cache : false,
		type : 'POST',
		success : function(resData){
			$(".dropdown-chat").html(resData);
		}
	});
}

Array.remove = function(array, from, to){
	var rest = array.slice((to || from)+1 || array.length);
	array.length = from < 0 ? array.length+from : from;
	return array.push.apply(array, rest);
};

var total_popups = 0;

var popups = [];
var userCodes = [];

function refreshStatus(){
	if(userCodes.length > 0){
		var userCode = userCodes;
		$.ajax({
			url : '${pageContext.request.contextPath}/common/getUserOnlineStatus?userCode='+userCode,
			cache : false,
			type : 'POST',
			success : function(resData){
				$.each(resData, function(key, value) {
					$("."+key).find(".fa-comments").css({"color": value});
				});
			}
		});
	}
}

function getChatMessageForUser(){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/getChatMessageForUser',
		cache : false,
		type : 'POST',
		success : function(resData){
			$.each(resData, function(chatWindowId, allChatMessages) {
				if(($('body').find("."+chatWindowId).length > 0) && ($('body').find("."+chatWindowId).css("display") == "block")){
					$.each(allChatMessages, function(messageId, chatMessage) {
						var popupInnerObj = $("."+chatWindowId).find(".popup-messages");
						var scrollBarPosition = popupInnerObj.scrollTop() + popupInnerObj.innerHeight();
						var scrollTotalHeight = popupInnerObj.prop("scrollHeight");
						var shouldScroll = false;
						var maximised = false;				
						if(scrollBarPosition == scrollTotalHeight)
							shouldScroll = true;
						if($("."+chatWindowId).css("height") == "350px")
							maximised = true;
						
						var element = '<li class="clearfix"><div class="chat-body clearfix"><div class="header">';
						element = element + '<strong class="pull-'+chatMessage.directionLeft+'  primary-font">'+chatMessage.showFrom+'</strong><small class="pull-'+chatMessage.directionRight+' text-muted">';
						element = element + '<i class="fa fa-clock-o fa-fw"></i>'+chatMessage.showTime+'</small></div><br/><p class="pull-'+chatMessage.directionLeft+'">'+chatMessage.messageContent+'</p></div></li>';
						$("."+chatWindowId).find("ul.chat > li:last-child").after(element);
						
						if(shouldScroll && maximised){
							popupInnerObj.scrollTop(popupInnerObj.prop("scrollHeight"));
							$("."+chatWindowId).find(".messageStatus").html(chatMessage.status);
						}else{
							if(chatMessage.status == "Seen")
								$("."+chatWindowId).find(".messageStatus").html(chatMessage.status);
							else{
								if(maximised)
									$("."+chatWindowId).find(".messageStatus").html("New message received. Scroll down to see it.");
								else
									$("."+chatWindowId).find(".messageStatus").html("New message received. Restore to see it.");
							}
						}
					});
				}else{
					$.each(allChatMessages, function(messageId, chatMessage) {
						$.ajax({
							url : '${pageContext.request.contextPath}/common/getMessageMaxNo?chatWindowId='+chatWindowId,
							cache : false,
							type : 'POST',
							success : function(maxNo){
								register_popup(chatWindowId, chatMessage.toUserName, chatMessage.fromUser, maxNo, false);
								var element = '<li class="clearfix"><div class="chat-body clearfix"><div class="header">';
								element = element + '<strong class="pull-'+chatMessage.directionLeft+'  primary-font">'+chatMessage.showFrom+'</strong><small class="pull-'+chatMessage.directionRight+' text-muted">';
								element = element + '<i class="fa fa-clock-o fa-fw"></i>'+chatMessage.showTime+'</small></div><br/><p class="pull-'+chatMessage.directionLeft+'">'+chatMessage.messageContent+'</p></div></li>';
								$("."+chatWindowId).find("ul.chat > li:last-child").after(element);
							}
						});
					});
				}
			});
		}
	});
}

function close_popup(id, userCode){
	for(var index = 0; index < userCodes.length; index++){
		if(userCode == userCodes[index]){
			Array.remove(userCodes, index);
		}
	}
	
	for(var index = 0; index < popups.length; index++){
		if(id == popups[index]){
			Array.remove(popups, index);
			$("#"+id).css("display","none");
			calculate_popups();
			return;
		}
	}
}

function close_all_popup(id){
	for(var index = 0; index < userCodes.length; index++){
		Array.remove(userCodes, index);
	}
	
	for(var index = 0; index < popups.length; index++){
		Array.remove(popups, index);
		$("#"+id).css("display","none");
		calculate_popups();
		return;
	}
}


function display_popups(){
	var right = 10;
	var index = 0;
	for(index; index < total_popups; index++){
		if(popups[index] != undefined){
			var element = document.getElementById(popups[index]);
			element.style.right = right+"px";
			right = right+320;
			element.style.display = "block";
		}
	}
	
	for(var index1 = index; index1 < popups.length; index1++){
		var element = document.getElementById(popups[index1]);
		element.style.display = "none";
	}
}

function minimise_popup(chatWindowId){
	if($("."+chatWindowId).css("height") == "35px"){
		$("."+chatWindowId).css("height","350px");
		var d = $("."+chatWindowId).find(".popup-messages");
		d.scrollTop(d.prop("scrollHeight"));
	}else{
		$("."+chatWindowId).find(".messageStatus").html("");
		$("."+chatWindowId).css("height","35px");
	}
	
}

function register_popup(chatWindowId, userName, userCode, messagemaxno, scrollUp){
	var dirL = '${dirL}';
	var dirR = '${dirR}';
	var element = '';
	var previosLoad = false;
	if($('body').find("."+chatWindowId).length == 0){
		element = '<div class="card card-primary chat-popup-box chat-popup '+chatWindowId+'" id="'+chatWindowId+'" compassId1="'+userCode+'" compassId2="'+userName+'">';
		element = element + '<div class="card-header popup-head clearfix">';
		element = element + '<div class="pull-'+dirL+'"><i class="fa fa-comments fa-fw"></i>&nbsp;&nbsp;'+userName+'</div>';
		element = element + '<div class="pull-'+dirR+'"><span class="minimizeChat"><a href="javascript:minimise_popup(\''+chatWindowId+'\')"><i class="fa fa-minus"></i></a></span><span class="close"><a href="javascript:close_popup(\''+chatWindowId+'\',\''+userCode+'\');"><i class="fa fa-times"></i></a></span></div>';
		element = element + '<div style="clear:both"></div></div><div class="popup-messages"><div class="userChatMessage">';
		element = element + '<ul class="chat"><li></li></ul></div></div><span class="messageStatus"></span>';
		element = element + '<div class="input-group"><input onkeypress="checkEnterSendMessage(event, this)" id="btn-input" type="text" class="form-control input-sm chatTypingBox" placeholder="Type your message here..." />';
		element = element + '<span class="input-group-btn"><button class="btn btn-warning btn-sm" id="btn-chat" onclick="sendChatMessage(this)">Send</button></span></div></div></div>';
		previosLoad = true;
	}
	for(var index = 0; index < popups.length; index++){
		if(chatWindowId == popups[index]){
			Array.remove(popups, index);
			popups.unshift(chatWindowId);
			calculate_popups();
			return;
		}
	}
	
	
	$("body").append(element);
	popups.unshift(chatWindowId);
	userCodes.unshift(userCode);
	calculate_popups();
	
	loadUnseenMessages(chatWindowId);
	if(previosLoad){
		loadPreviosMessages(chatWindowId, messagemaxno, scrollUp);
	}
}

function checkEnterSendMessage(evt, elm){
	var charCode = (evt.which) ? evt.which : event.keyCode;
	if(charCode == 13){
		sendChatMessage($(elm).parents(".input-group").find("#btn-chat"));
	}
}

function loadPreviosMessages(chatWindowId, messagemaxno, scrollUp){
	$("."+chatWindowId).find("ul.chat > li:first-child").html("<center><em>loading previous messages...</em></center>");
	$.ajax({
		url : '${pageContext.request.contextPath}/common/loadPreviosMessage?chatWindowId='+chatWindowId+'&messagemaxno='+messagemaxno,
		cache : false,
		type : 'POST',
		success : function(resData){
			$("."+chatWindowId).find(".userChatMessage").find("ul.chat > li:first-child").after(resData);
			$("."+chatWindowId).find(".userChatMessage").find("ul.chat > li:first-child").remove();
			var d = $("."+chatWindowId).find(".popup-messages");
			if(scrollUp){
				d.scrollTop(0);
			}else{
				d.scrollTop(d.prop("scrollHeight"));
			}
		}
	});
}

function loadUnseenMessages(chatWindowId){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/loadUnseenMessage?chatWindowId='+chatWindowId,
		cache : false,
		type : 'POST',
		success : function(resData){
			$("."+chatWindowId).find(".userChatMessage").find("ul.chat > li:last-child").after(resData);
			var d = $("."+chatWindowId).find(".popup-messages");
			d.scrollTop(d.prop("scrollHeight"));
		}
	});
}

function calculate_popups(){
	var width = window.innerWidth;
	if(width < 540){
		total_popups = 0;
	}else{
		total_popups = parseInt(width/320);
	}
	display_popups();
}

function sendChatMessage(elm){
	var chatWindowID = $(elm).parents(".chat-popup-box").attr("id");
	var toID = $(elm).parents(".chat-popup-box").attr("compassId1");
	var toName = $(elm).parents(".chat-popup-box").attr("compassId2");
	var chatMessage = $(elm).parents(".chat-popup-box").find(".chatTypingBox");
	var chatMessageValue = $(chatMessage).val().trim();
	var chatMessageStatus = $(elm).parents(".chat-popup-box").find(".messageStatus");
	
	if(chatMessageValue.length > 0){
		$(chatMessageStatus).html("Sending...");
		$.ajax({
			url : '${pageContext.request.contextPath}/common/sendChatMessage',
			cache : false,
			type : 'POST',
			data : "USERTONAME="+toName+"&USERTO="+toID+"&MESSAGEID=21212&CHATWINDOWID="+chatWindowID+"&CHATMESSAGE="+escape(chatMessageValue),
			success : function(resData){
				$(chatMessageStatus).html("Sent");
				$(chatMessage).val("");
			}
		});
	}
}

function getChatStatus(){
	$.ajax({
		url : '${pageContext.request.contextPath}/common/getUserChatStatus',
		cache : false,
		type : 'POST',
		success : function(chatStatus){
			if(chatStatus == 'A'){
				$("#userChatStatus").css("color","#6EC06E");
		    	getChatMessageForUser();
			}else if(chatStatus == 'B'){
				$("#userChatStatus").css("color","red");
		    	getChatMessageForUser();
			}else{
				$("#userChatStatus").css("color","#808080");
			}
			getAllChatUser();
	    	refreshStatus();
		}
	});
}

function changeChatStatus(status){
	 $.ajax({
		url : '${pageContext.request.contextPath}/common/changeChatStatus?STATUS='+status,
		cache : false,
		type : 'POST',
		success : function(resData){
		},
		error : function(jqXHR, textStatus , errorThrown){
			alert("Error while changing chat status");
		}
	});
	if(status == "O"){
		$("#userChatStatus").css("color","#808080");
		for(var index = 0; index < popups.length; index++){
			var chatWindowId = popups[index];
			close_all_popup(chatWindowId);
		}
	}else{
		if(status == "A"){
			$("#userChatStatus").css("color","#6EC06E");
		}else{
			$("#userChatStatus").css("color","red");
		}
		for(var index = 0; index < popups.length; index++){
			var chatWindowId = popups[index];
			$("."+chatWindowId).find(".input-group").show();
			$("."+chatWindowId).find(".messageStatus").html("Status changed")
		}
	}
}


// 28.05.2019
function genericClear(unqId){
	var fieldsMap = {};
	$(document).find(".card-search-card").find(".input-sm").each(function(i, v){
		fieldsMap[$(this).attr("id")] = $(this).val();
	});
	
	$(document).find(".panelSearchForm").find(".input-sm").each(function(i, v){
		fieldsMap[$(this).attr("id")] = $(this).val();
	});
	
	//console.log(fieldsMap);

	$("#clear"+unqId).click(function(){
		$.each(fieldsMap,function(id,value){
			//$("#"+id).val(value);
			$("#clear"+unqId).closest(".card-search-card").find("#"+id).val(value);
			$("#clear"+unqId).closest(".panelSearchForm").find("#"+id).val(value);
			if($("#"+id).is("select")){
				$("#"+id).trigger('change.select2');
			}
		});
	});
}



</script>