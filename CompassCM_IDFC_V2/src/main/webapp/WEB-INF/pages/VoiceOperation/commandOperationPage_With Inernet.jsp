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
		<button class="btn btn-sm" id="showQuestions${UNQID}" style="float:left;margin-right:55px;">Show Questions</button>
		<div class="col-sm-8 questionDiv" style="float:left;display:none" id="questionDiv${UNQID}">
			<ul>
				<li>WHAT IS THE TIME</li>
				<li>HOW MANY ALERTS ARE THERE FOR THE DAY</li>
				<li>HOW MANY SUSPICIONS HAVE BEEN FILED IN THE DAY</li>
				<li>WHO HAS CLOSED MAXIMUM NUMBER OF ALERTS</li>
				<li>HOW MANY REPORTS ARE PENDING TO BE FILED</li>
				<li>CLOSE IT</li>
			</ul>
		</div>
		
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
	 <audio class="sound" src="chime.mp3"></audio>
	 
</div>

<script>
$(document).ready(function(){
	var id = "${UNQID}";
	if (!('webkitSpeechRecognition' in window)) {
		alert("Speech not supporting");
	}
	
	window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
	const synth = window.speechSynthesis;
	const recognition = new SpeechRecognition();
	
	
	const sound = document.querySelector('.sound');//('#sound'+id);
	
	
	$("#startreconizationSpeech"+id).on('click', () => {
		//$('#sound'+id).play();
		  activateVoiceOperations();
	});
	const activateVoiceOperations = () => {
		  recognition.start();
		  recognition.onstart = (event) => {
			  $("#startreconizationSpeech"+id).addClass("recodingGoingOn");
			};
			
			
		  recognition.onresult = (event) => {
		    const speechToText = event.results[0][0].transcript;
		    $('#speechIntoText'+id).val(speechToText);
			if (event.results[0].isFinal) {
				var speechToTextInUpperCase = speechToText.toUpperCase();
		      if (speechToTextInUpperCase.includes('WHAT IS THE TIME')) {
		          speak(getTime);
		      }else if (speechToText.includes('WHAT IS DATE TODAY')) {
		          speak(getDate);
		      }else if(speechToTextInUpperCase.includes('HOW MANY ALERTS ARE THERE FOR THE DAY')){
		    	  console.log("command: "+speechToText);
		    	  MainOperations(speechToText);
		      }else if(speechToTextInUpperCase.includes('HOW MANY SUSPICIONS HAVE BEEN FILED IN THE DAY')){
		    	  console.log("command: "+speechToText);
		    	  MainOperations(speechToText);
		      }else if(speechToTextInUpperCase.includes('WHO HAS CLOSED MAXIMUM NUMBER OF ALERTS')){
		    	  console.log("command: "+speechToText);
		    	  MainOperations(speechToText);
		      }else if(speechToTextInUpperCase.includes('HOW MANY REPORTS ARE PENDING TO BE FILED')){
		    	  console.log("command: "+speechToText);
		    	  MainOperations(speechToText);
		      }else if(speechToTextInUpperCase.includes('CLOSE IT')){
		    	  $("#compassSearchModuleModal").modal("hide");
		      };
		      
		    }
		  }
		  
		  
		  recognition.onend = (event) => {
			  $("#startreconizationSpeech"+id).removeClass("recodingGoingOn"); 
		   };
		   recognition.onerror = (event) => {
			   console.log(event.error);
		   };
	};
	
	//for speaking
	const speak = (action) => {
		utterThis = new SpeechSynthesisUtterance(action());
		synth.speak(utterThis);
	};
	
	const getTime = () => {
		let today = new Date();	
		return today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
	}
	
	const getDate = () => {
		let today = new Date();
		let dd = today.getDate();
		let mm = today.getMonth() + 1; 
		let yyyy = today.getFullYear();

		if (dd < 10) {
		  dd = '0' + dd;
		}

		if (mm < 10) {
		  mm = '0' + mm;
		}

		today = mm + '/' + dd + '/' + yyyy;
		return today;
	};	
	
	
	
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