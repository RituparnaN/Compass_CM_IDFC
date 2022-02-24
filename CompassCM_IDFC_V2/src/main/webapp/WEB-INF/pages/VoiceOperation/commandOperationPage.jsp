<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<style>
/* .recodingGoingOn{
	color:white;
	background-color: red;
	animation-name: pulse;
	animation-duration: 1.5s;
	animation-iteration-count: infinite;
	animation-timing-function: linear;
}
@keyframes pulse{
	0%{
		box-shadow: 0px 0px 5px 0px rgba(173,0,0,.3);
	}
	65%{
		box-shadow: 0px 0px 5px 13px rgba(173,0,0,.3);
	}
	90%{
		box-shadow: 0px 0px 5px 13px rgba(173,0,0,0);
	}
} */

.recodingGoingOn {
  color:red;
  animation: blinker 1.5s cubic-bezier(.5, 0, 1, 1) infinite alternate;  
}
@keyframes blinker {  
  from { opacity: 1; }
  to { opacity: 0; }
}

#questionDiv${UNQID}{
  padding: 10px;
  box-shadow: 5px 10px #888888;
}
	

</style>
<div class="row" style=";margin:25px;">
		<%-- <button class="btn btn-sm" id="showQuestions${UNQID}" style="float:left;margin-right:55px;">Show Questions</button>
		<div class="col-sm-8 questionDiv" style="float:left;display:none" id="questionDiv${UNQID}">
			<ul>
				<li>WHAT IS THE TIME</li>
				<li>HOW MANY ALERTS ARE THERE FOR THE DAY</li>
				<li>HOW MANY SUSPICIONS HAVE BEEN FILED IN THE DAY</li>
				<li>WHO HAS CLOSED MAXIMUM NUMBER OF ALERTS</li>
				<li>HOW MANY REPORTS ARE PENDING TO BE FILED</li>
				<li>CLOSE IT</li>
			</ul>
		</div> --%>
		
	 <div class="col-sm-offset-1 col-sm-10" id="text-box${UNQID}" style="min-height:40px;margin-top:20px">
	 	<input type="text" class="form-control" id="speechIntoText${UNQID}" style=""
	 	 placeholder="Press Mic TO Start Listening"></input>
	 	<div class="col-sm-offset-4 col-sm-3" style="margin-top:25px;align-content:center">
	 		<i class="fa fa-microphone" id = "startreconizationSpeech${UNQID}" style="font-size:200px"></i>
	 	</div>
	 </div> 
	 <div class="col-sm-offset-2 col-sm-10">
	 	<p class="lead" id="outputFromCommand${UNQID}"></p>
	 </div>
	<!--  <audio class="sound" src="chime.mp3"></audio> -->
	 
</div>

<script>
$(document).ready(function(){
	var id = "${UNQID}";
	
	
	$("#startreconizationSpeech"+id).on('click', () => {
		var julius = new Julius({
			log: true
		});
		
		julius.onrecognition = function(sentence) {
      		console.log('Sentence: ', sentence);
      		$("#outputFromCommand"+id).html(sentence);
    	}
    	julius.onfirstpass = function(sentence) {
      		console.log('First pass: ', sentence);
    	}
    	
    	julius.onfail = function() {
      		// This will throw its own Error
    		  // console.error('fail');
    	}
    	// This will only log if you pass `log: true` in the options object
    	julius.onlog = function(log) {
      		console.log(log);
    	}
	});

	
	
	function MainOperations(command){
		var output;
		$.ajax({
			url:"${pageContext.request.contextPath}/common/mainVoiceOperations",
			data:{command:command},
			success:function(result){
				//console.log(result);
				$("#outputFromCommand"+id).html(result);
				utterThis = new SpeechSynthesisUtterance(result);
			    synth.speak(utterThis);
			}
		});
	}
	
	$("#showQuestions"+id).click(function(){
		$("#questionDiv"+id).toggle("slow");
	})
	
});
	
</script>