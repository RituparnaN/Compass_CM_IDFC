/* Sphinix Speach recognition using recordings..  */
	
	var audio_context;
	var AudioContext = window.AudioContext || window.webkitAudioContext;
	

	var recorder;
	var synth;
	var gumStream;
	/*function startUserMedia(stream) {
	    var input = audio_context.createMediaStreamSource(stream);
		recorder = new Recorder(input);
		gumStream = stream;
		startVoiceRecording();
	 }*/
	
	$("#startSphinixSpeechRecognition").on('click', () => {
		$("#convertedTextFromSpeech").val("Recording...");
		/*try {
		      window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
		      synth = window.speechSynthesis;
		      window.AudioContext = window.AudioContext || window.webkitAudioContext;
		      
		      navigator.mediaDevices.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
		      
		      window.URL = window.URL || window.webkitURL;
		      
		      audio_context = new AudioContext;
		    } catch (e) {
		      alert('No web audio support in this browser!');
		    }
		    
		     navigator.mediaDevices.getUserMedia({audio: true}, startUserMedia, function(e) {
		      alert('No live audio input: ' + e);
		    });*/
		 var constraints = { audio: true, video:false }
		 navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
				console.log("getUserMedia() success, stream created, initializing Recorder.js ...");
				audioContext = new AudioContext();
				gumStream = stream;
				input = audioContext.createMediaStreamSource(stream);
				recorder = new Recorder(input,{numChannels:1})
				startVoiceRecording();
				console.log("Recording started");
				
				//for voice
				 window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
			     synth = window.speechSynthesis;

			}).catch(function(err) {
			  	alert("got error");
			});
		
	});
	

	function startVoiceRecording(){
		changeRecordingStatus();
		recorder && recorder.record();
		setTimeout(stopVoiceRecording,3000);
		//speakText("He is good");
	}
	
	function stopVoiceRecording(){
		console.log("stopeed");
		recorder && recorder.stop();
		changeRecordingStatus();
		createDownloadLink();
		recorder && recorder.clear();
		gumStream.getAudioTracks()[0].stop();
		$("#convertedTextFromSpeech").val("Processing...");
	}
	
	function createDownloadLink() {
	    recorder && recorder.exportWAV(function(blob) {
	      var url = URL.createObjectURL(blob);
	      var li = document.createElement('li');
	      var au = document.createElement('audio');
	      var hf = document.createElement('a');
	      mainOperations(blob);
	      /* au.controls = true;
	      au.src = url;
	      hf.href = url;
	      hf.download = new Date().toISOString() + '.wav';
	      hf.innerHTML = hf.download;
	      li.appendChild(au);
	      li.appendChild(hf);
	      recordingslist.appendChild(li); */ 
	    });
	  }
	
	
	
	//for speaking multipart/form-data
	function speakText(text){
		utterThis = new SpeechSynthesisUtterance(text);
		synth.speak(utterThis);
	};
	
		
	
	
	
	
	function mainOperations(audioBlob){
	var file = 	new File([audioBlob], "uploaded_file.wav", { type: "audio/wav", lastModified: Date.now() })
		var output;
		var form = new FormData();
		form.append("uploaded_file",file);
		console.log(form);
		 $.ajax({
			url:sphinixRecordingRecognitionUrl,
			data:form,
			cache: false,
		    processData: false,
		    method: 'POST',
		    contentType:false,
			success:function(result){
				processSpeechOperation(result);
				
			   
			}
		}); 
	}
	
	
	
	
	function changeRecordingStatus(){
		$("#startSphinixSpeechRecognition").toggleClass("recodingGoingOn");
	}
	
	
	
	
	//init action when user hit enter 
	/* $("#convertedTextFromSpeech").keydown(function (e){
	    if(e.keyCode == 13){
	        let speechToText = $("#convertedTextFromSpeech").val();
	        var speechToTextInUpperCase = speechToText.toUpperCase();
			console.log(speechToTextInUpperCase,speechToText);
			performActionInit(speechToTextInUpperCase,speechToText);
	    }
	}) */
	     //performModuleSearchOperations("customer master");
	function processSpeechOperation(result){
		$("#convertedTextFromSpeech").val(result["InputText"]);
		$("#convertedTextFromSpeech").attr('title', result["InputText"]);
		
		if(result['isCommand'] == 'Y'){
			let command = $.trim(result["InputText"]);
			command = $.trim(command.substring(4));
			//bellow function is defined in scripts\pages\common\template\moduleSearch.js file
			performModuleSearchOperations(command);
		}else{
			utterThis = new SpeechSynthesisUtterance(result["outputText"]);
		    synth.speak(utterThis);
		}
	}
