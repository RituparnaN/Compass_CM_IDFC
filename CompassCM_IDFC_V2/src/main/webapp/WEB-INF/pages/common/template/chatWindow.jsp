<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ChatWindow</title>
</head>
<style>
 	.display_toggle{
            display:none;
    }
    .chatwindow{
        position:fixed;
        bottom:6%;
        right:1%;
        border:1px solid #337AB7;
        height:400px;
        width:250px;
         border-radius:5px; 
        /* border-top-left-radius: 10px;
        border-top-right-radius: 10px; */
        background-color: #337AB7;
        display: flex;
        flex-direction: column;
        max-height: 400px;
    }
    .chatwindowHeader{
        
        padding: 10%;
        padding-bottom: 5%;
        display: flex;
        flex-direction: row;
    }
    .chatwindowHeaderClose{
        width: 50%;
        /* padding-left: 75%; */
        margin-left:80%;
    }
    .closeButton{

        outline:none;
        border:none;
        background-color:blue;
        opacity: 0.5;
        color:white;
        height:20px;
        border-radius: 50%;
    }
    .closeButton:hover{
        color:red;
    }
    .chatwindowChatSection{
        padding-left: 5%;
        padding-top: 5%;
        border:0px solid black;
        background-color: white;
        height:303px;
        /* border-radius: 10px; */
        border-top-left-radius: 30px;
        border-top-right-radius: 30px;
        overflow-y: scroll;
       
    }
    ::-webkit-scrollbar {
        width: 0px;
        background: transparent;
    }

    .botMsg{
        float:left;
        display: flex;
        flex-direction: row;
        /* place-content: center; */
        width:85%;
        margin-bottom: 3%;
    }
    .botLogo{
        
        /* background-color: #337AB7; */
        border-radius: 50%;
       /*  height: 30px;
        width: 30px; */
        /* justify-content: center; */
        text-align: center;
        min-width: 30px;
        /* margin-top: 25%; */
        align-self: flex-end;
        padding: 1%;
    }
    .botLogoImage{
    	height:30px;
    	
    	
   	}
    .botResponse{
    	
        color: #337AB7;
        width:100%;
        padding:3%;
        margin-left: 3%;
        background-color:  rgb(235, 230, 230);
        border-radius: 20px;
        border-bottom-left-radius: 0;
        
        
    }
    .userMsg{
        
        float:right;
        margin-right: 7%;
        margin-bottom: 3%;
        width:70%;
        padding:3%;
        background-color:  rgb(235, 230, 230);
        border-radius: 20px;
        border-bottom-right-radius: 0;
    }
    
    .inputSectionContainer{
        /* margin-top: 2%; */
        /*  padding-bottom: 2%;  */
        background-color: white;
        border-bottom-left-radius:5px;
        border-bottom-right-radius:5px;
        padding-bottom:4px;
        /* max-width: 100%; */
        
    }

    .chatwindowInputSection{
        
        width:95%;
        margin-left: 3%;
        /* margin:auto; */
        display: flex;
        flex-direction: row;
        height:30px;
        background-color: rgb(235, 230, 230);
        border-radius: 20px;
    }
    
    .inputArea{
        border:0px solid black;
        
        /* width:155px; */
            width: 75%;
        border:none; 
        padding-top: 2%;
        padding-left: 2%;
        
    }
    .inputArea input{
        background-color: rgb(235, 230, 230);
        border:none; 
        padding-left: 5%;
        padding-top: 2%;
    }
    .inputArea input:focus{
    
        border:none; 
        outline:none;
    }
    .submitArea{
        /* border:0px solid black; */
        display: flex;
        flex-direction: row;
        padding-top: 1%;
        
    }
    .submitButton{
        /* background-color: rgb(235, 230, 230); */
        background-color: #337AB7;
        border:none;
        /* height:100%; */
        border-radius: 50%;
        width:25px;
        height:25px;
        
        
    }
    .submitButton:focus,#chat_window_toggler:focus{
        outline:none;
        
    }
    .submitButton:hover{
        background-color: #337AB7;
        cursor:pointer;
    }
    .feedback{
        margin-top: 2%;
        border-top: 1px solid grey;
    }
    .feedbackOption{
    	margin-left:15%;
        
        display:flex;
        flex-direction: row;
        /* min-width:50%; */
    }
    .feedbackOption div{
    	margin:2%;
    }
    .yesFeedbackButton{
        color:white;
        outline:none;
        border:none;
        /* margin-left: 40%; */
        background-color:  #337AB7 ;
        border-radius: 20px;
        min-width:50px;
        /* margin-left: 95%; */
    }
    .noFeedbackButton{
        color:white;
        outline:none;
        border:none;
        /* margin-left: 40%; */
        background-color:  grey ;
        border-radius: 20px;
        min-width:50px;
        /* margin-left: 200%; */
    }
    .openPendingCases{
        margin-top: 2%;
        border-top: 1px solid grey;
    }
    .showCasesOptions{
        
        display:flex;
        flex-direction: row;
    }
    .showPendingCasesButton{
        color:white;
        outline:none;
        border:none;
        width:100%;
        background-color:  #337AB7 ;
        border-radius: 20px;
        margin-left: 65%;
    }
    .performListScreenButton{
        color:white;
        outline:none;
        border:none;
        width:100%;
        background-color:  #337AB7 ;
        border-radius: 20px;
        margin-left: 75%;
    }
    .alternateResultsList{
        width: 100%;
        margin-top: 10px;
        display: flex;
        flex-direction: column;
        
    }
    .alternateResultButton{
        width: 100%;
        border: 1px solid #337AB7;
        border-radius: 30px;
        margin-top: 2px;
        background-color: white;
        padding-top:3px;
        
        
    }
    
    .alternateResultButton:hover{
        background-color: #337AB7;
        color:white;
    }
    .alternateResultButton:focus{
    	outline:none;
    }
    
</style>

<script>
	
	var AUDIO_RECORDER_WORKER = '${pageContext.request.contextPath}/includes/scripts/pages/common/template/audioRecorderWorker.js';
	var AudioRecorder = function(source, cfg) {
		this.consumers = [];
		var config = cfg || {};
		var errorCallback = config.errorCallback || function() {};
		var inputBufferLength = config.inputBufferLength || 4096;
		var outputBufferLength = config.outputBufferLength || 4000;
		this.context = source.context;
		this.node = this.context.createScriptProcessor(inputBufferLength);
		var worker = new Worker(config.worker || AUDIO_RECORDER_WORKER);
		worker.postMessage({
		    command: 'init',
		    config: {
			sampleRate: this.context.sampleRate,
			outputBufferLength: outputBufferLength,
			outputSampleRate: (config.outputSampleRate || 16000)
		    }
		});
		var recording = false;
		this.node.onaudioprocess = function(e) {
		    if (!recording) return;
		    worker.postMessage({
			command: 'record',
			buffer: [
			    e.inputBuffer.getChannelData(0),
			    e.inputBuffer.getChannelData(1)
			]
		    });
		};
		this.start = function(data) {
		    this.consumers.forEach(function(consumer, y, z) {
		            consumer.postMessage({ command: 'start', data: data });
			recording = true;
			return true;
		    });
		    recording = true;
		    return (this.consumers.length > 0);
		};
		this.stop = function() {
		    if (recording) {
			this.consumers.forEach(function(consumer, y, z) {
		                consumer.postMessage({ command: 'stop' });
			});
			recording = false;
		    }
		    worker.postMessage({ command: 'clear' });
		};
		this.cancel = function() {
		    this.stop();
		};
		myClosure = this;
		worker.onmessage = function(e) {
		    if (e.data.error && (e.data.error == "silent")) errorCallback("silent");
		    if ((e.data.command == 'newBuffer') && recording) {
			myClosure.consumers.forEach(function(consumer, y, z) {
		                consumer.postMessage({ command: 'process', data: e.data.data });
			});
		    }
		};
		source.connect(this.node);
		this.node.connect(this.context.destination);
	};
	

async function chatWindowHandler(){
            var text = document.getElementById('userInput').value;
            text = text.replace("'",'')
            var scrollTargetDiv = document.getElementById("chatwindowChatSection");
            var d = new Date()
            
            var date = d.getDate()
            if(date.toString().length < 2){
            	date = '0'+date.toString()
            }
            var month = d.getMonth()
            month = month+1
            
            if(month.toString().length < 2){
            	month = '0'+month.toString()
            }
            var year = d.getFullYear()
            
            
            
            if(text.includes('today')){
            	text = text.replace('today',"FTDate:: "+date+'/'+month+'/'+year.toString()+" ::FTDate")
            }
            if(text.includes('of the day')){
            	text = text.replace('of the day',"FTDate:: "+date+'/'+month+'/'+year.toString()+" ::FTDate")
            }
            if(text.includes('yesterday')){
            	month31 = [5,7,8,10,12]
            	month30 = [2,4,6,9,11]
            	date = parseInt(date)
            	date = date - 1
            	
            	if(date == 0){
            		if(month31.includes(parseInt(month))){
            			date = 30
            			
            			month = parseInt(month) -1 
            			
            		}
            		else if (month30.includes(parseInt(month)) || parseInt(month) == 1 ){
            			date = 31
            			month = parseInt(month) -1 
            			if(month == 0){
            				month = 12
            				year =  parseInt(year) - 1
            			}
            		}
            		else{
            			if(parseInt(month) == 3){
            				year =  parseInt(year) - 1
            				
            				if ((0 == year % 4) && (0 != year % 100) || (0 == year % 400)) {
            					date = 29
            			    } else {
            			    	date = 28
            			    }
	            			
	            			month = parseInt(month) -1 
	            			
            			}
            			
            		}
            	}
            	if(date < 10){
            		
            		date = '0'+date.toString()
            	}
            	text = text.replace('yesterday',"FTDate:: "+date.toString()+'/'+month.toString()+'/'+year.toString()+" ::FTDate")
            	
            }
            if(text === '')
            {
                return
            }
            var chatSection = document.getElementById('chatwindowChatSection');
            try{
            	
				var lastchild = chatSection.lastChild;
				lastlastchild = lastchild.lastChild;
				if(lastlastchild.lastChild.classList.contains('userOptions')){
					lastlastchild.removeChild(lastlastchild.lastChild)
				}
				if(lastlastchild.lastChild.classList.contains("alternateResultsList")){
					if(!lastlastchild.lastChild.classList.contains("feedback")){
						chatSection.removeChild(chatSection.lastChild)
						
					}
					/* else{
						lastlastchild.removeChild(lastlastchild.lastChild);
					} */
					
				}
				if(lastlastchild.lastChild.classList.contains("feedback")){
					lastlastchild.removeChild(lastlastchild.lastChild);
					if(lastlastchild.lastChild.classList.contains("alternateResultsList")){
						lastlastchild.removeChild(lastlastchild.lastChild);
						
					}
					
				}
            }
            catch(e){}
            
            var userMsg = document.createElement('div');
            userMsg.className = 'userMsg';
            userMsg.id = 'userMsg';
            userMsg.innerHTML=text;
            chatSection.appendChild(userMsg);
            
            var botLogoImage = document.createElement('img')
			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
			botLogoImage.className ='botLogoImage'
			botLogoImage.id = 'botLogoImage'
			
            var botLogo3 = document.createElement('div')
            botLogo3.className = "botLogo"
            botLogo3.id = "botLogo"
            botLogo3.appendChild(botLogoImage)
            
           
            
            var botResponse = document.createElement('div')
            botResponse.className = 'botResponse pleaseWait'
            botResponse.id = 'botResponse'
            botResponse.innerHTML = 'please wait...'
            botResponse.style.color='red'
            
            var botMsg = document.createElement('div')
            botMsg.className='botMsg'
            botMsg.appendChild(botLogo3)
            botMsg.appendChild(botResponse)
            var chatSection = document.getElementById('chatwindowChatSection')
            chatSection.appendChild(botMsg)
            
            
            
            var scrollTargetDiv = document.getElementById("chatwindowChatSection");
            
            scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
            
            if(text.toLowerCase().includes('logout')||text.toLowerCase().includes('log me out')||text.toLowerCase().includes('log out') ||text.toLowerCase().includes('log off') ||text.toLowerCase().includes('log me off')){
            	var conf = confirm("Do you want to logout?");
            	  if (conf == true) {
	            	var node = document.querySelector('[class="fa fa-user fa-fw"]').parentNode;
	            	node.click();
	            	document.getElementById('logout').click();
            	    
            	  } else {
            		  var chatSection = document.getElementById('chatwindowChatSection')
                      if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
      	        		chatSection.removeChild(chatSection.lastChild)
      	        		chatSection.removeChild(chatSection.lastChild)
                      	
                      }
            		  document.getElementById('userInput').value = ''
            	  }
            }
            
            else if(text.includes('time')||text.includes('what is the time')||text.includes('time?') || text.includes('how do you do')){
            	
            	today = new Date();
                time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                console.log(time);
                time = time.split(':')
                var timeStamp = 'a m'
                var hours = parseInt(time[0])
                if( hours > 12){
                	hours = hours-12;
                	timeStamp = 'p m'
                }
               	var minutes= time[1]
             
				if(text.includes('how do you do')){
                	
	                msg = 'scooby dooby doo'
                }
                else{
                	msg = hours.toString()+' '+minutes+timeStamp;
                }
                
                
                var chatSection = document.getElementById('chatwindowChatSection')
                if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
	        		chatSection.removeChild(chatSection.lastChild)
                	
                }
        		
                var botLogoImage = document.createElement('img');
    			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
    			botLogoImage.className ='botLogoImage';
    			botLogoImage.id = 'botLogoImage';
    			
                var botLogo3 = document.createElement('div');
                botLogo3.className = "botLogo";
                botLogo3.id = "botLogo";
                botLogo3.appendChild(botLogoImage);
                
                var botResponse = document.createElement('div');
                botResponse.className = 'botResponse';
                botResponse.id = 'botResponse';
                if(text.includes('how do you do')){
                	
                	botResponse.innerHTML = 'scooby dooby doo';
                }
                else{
	                botResponse.innerHTML = hours.toString()+':'+minutes+' '+timeStamp.replace(' ','');
                }
                var botMsg = document.createElement('div');
                botMsg.className='botMsg';
                botMsg.appendChild(botLogo3);
                botMsg.appendChild(botResponse);
                chatSection.appendChild(botMsg);
                
                
                speakout(msg);
                document.getElementById('userInput').value='';
               
                scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
                return
                

            }
            /* else if(text.includes('scan for')||text.includes('scan')||text.includes('/scan')){
            	var targetName = text.replace('match','').replace('matches for','').replace('scan for','').replace('/scan','').replace('scan','')
            	
            	navigate('Real Time Scanning','realtimeScanning','common/realtimeScanning','1')
            	
            	document.getElementById('userInput').value='';
            	
            	try{
            		document.getElementById('scanName1').value= targetName;
                	document.getElementById('scanDetails').click();
            	}
            	catch(e){
            		await sleep(1000)
	            	document.getElementById('scanName1').value= targetName;
	            	document.getElementById('scanDetails').click();
            	}
            	
            	
            } */
            else if(text[0] === '/'){
            	if(text.length === 1){
            		alert('real time scanning needs a customer/person name')
	            	document.getElementById('userInput').value='';
	            	if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
		        		chatSection.removeChild(chatSection.lastChild)
	                	
	                }
            	}
            	else{
            		
	            	targetName = text.substring(1,text.length)
					navigate('Real Time Scanning','realtimeScanning','common/realtimeScanning','1')
	            	
	            	document.getElementById('userInput').value='';
	            	if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
		        		chatSection.removeChild(chatSection.lastChild)
	                	
	                }
	            	
	            	try{
	            		document.getElementById('scanName1').value= targetName;
	                	document.getElementById('scanDetails').click();
	            	}
	            	catch(e){
	            		await sleep(1000)
	            		var chatSection = document.getElementById('chatwindowChatSection')
	                    
		            	document.getElementById('scanName1').value= targetName;
		            	document.getElementById('scanDetails').click();
	            	}
	            	
            	}
            }
            
            else{
          
           /*  var queryString = document.getElementById('userInput').value;
        	input = {"query":queryString}; */
        	
        	$.ajax({
        		url: "${pageContext.request.contextPath}/query/input?queryString="+text.replace(' ','+'),
        		async:true,
        		cache: false,
        		type: "GET",
        		
        		success: function(res){
        			if(res.includes('SERVER DOWN')){
        				alert('FLASK '+res)
        			}
        			if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
    	        		chatSection.removeChild(chatSection.lastChild)
                    	
                    }
        			res = JSON.parse(res);
        			console.log(res)
        			
        			
        			
        			if(!res.data.intent){
        				
        				var botLogoImage = document.createElement('img')
            			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
            			botLogoImage.className ='botLogoImage'
            			botLogoImage.id = 'botLogoImage'
            			
                        var botLogo3 = document.createElement('div')
                        botLogo3.className = "botLogo"
                        botLogo3.id = "botLogo"
                        botLogo3.appendChild(botLogoImage)
                        
                        var botResponse = document.createElement('div')
                        botResponse.className = 'botResponse'
                        botResponse.id = 'botResponse'
                        botResponse.innerHTML = "Sorry, Nothing found"
                        var botMsg = document.createElement('div')
                        botMsg.className='botMsg'
                        botMsg.appendChild(botLogo3)
                        botMsg.appendChild(botResponse)
                        chatSection.appendChild(botMsg)
                        scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
                 
                    }
                    else{

                        if(res.data.message.includes('Sorry')){
                        	var botLogoImage = document.createElement('img')
                			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
                			botLogoImage.className ='botLogoImage'
                			botLogoImage.id = 'botLogoImage'
                			
                            var botLogo3 = document.createElement('div')
                            botLogo3.className = "botLogo"
                            botLogo3.id = "botLogo"
                            botLogo3.appendChild(botLogoImage)
                            
                           
                            
                            var botResponse = document.createElement('div')
                            botResponse.className = 'botResponse'
                            botResponse.id = 'botResponse'
                           
	                        botResponse.innerHTML = res.data.message + " please try with a different query"
                            
                            /* botResponse.appendChild(feedback) */
                            
                            var botMsg = document.createElement('div')
                            botMsg.className='botMsg'
                            botMsg.appendChild(botLogo3)
                            botMsg.appendChild(botResponse)
                            chatSection.appendChild(botMsg)
                            scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
                			
                            speakout("sorry i do not understand, i am still learning")
           
                        }
                        else{
                        	/* alert(res.data.resultCategory) */
                        	if(res.data.resultCategory === 'MODULE')
                        		{
                        			handeModuleResponse(res)
                        		}
                        	else if(res.data.resultCategory === 'COMMAND'){
                        		/* alert('its a command for '+ res.data.moduleCode); */
                        		console.log(res.data.moduleCode);
                        		if(res.data.moduleCode == 'pendingCases'){
                        			if(res.data.ftdate.length > 0){
                        				/* alert(res.data.ftdate[0]) */
                        				openPendingCasesWithDate(res.data.moduleCode,res.data.moduleName,res.data.moduleUrl,res.data.moduleMultiple,res.data.ftdate[0])
                        				
                        				
                        			}
                        			else{
                        				
		                        		$.ajax({
		                            		url: "${pageContext.request.contextPath}/query/getUserNotifications?moduleName="+res.data.moduleName.replace('|','')+"&moduleCode="+res.data.moduleCode.replace('|','')+"&moduleUrl="+res.data.moduleUrl.replace('|','')+"&moduleMultiple="+res.data.moduleMultiple.replace('|',''),
		                            		cache: false,
		                            		type: "GET",
		                            		
		                            		success: function(res){
		                            			
		                            			res = JSON.parse(res);
		                            			
		                            			var botLogoImage = document.createElement('img')
		                            			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
		                            			botLogoImage.className ='botLogoImage'
		                            			botLogoImage.id = 'botLogoImage'
		                            			
		                                        var botLogo3 = document.createElement('div')
		                                        botLogo3.className = "botLogo"
		                                        botLogo3.id = "botLogo"
		                                        botLogo3.appendChild(botLogoImage)
		                                        
		                                        var showPendingCasesButton = document.createElement('button')
					                            
					                            var functionParams = 'openPendingCases("'+res.moduleCode+'","'+res.moduleName+'","'+res.moduleUrl+'","'+res.moduleMultiple+'")';
					                     		
		                            			showPendingCasesButton.setAttribute('onclick',functionParams)
					                            showPendingCasesButton.innerHTML = 'Show in detail'
					                            showPendingCasesButton.className = 'showPendingCasesButton showCasesButton';
		                            			showPendingCasesButton.id = 'showCasesButton'
					                            
					                            var showCases = document.createElement('div')
					                            showCases.className = 'showCases'
					                            showCases.id = 'showCases'
					                            showCases.appendChild(showPendingCasesButton)
					                            
					                            var showCasesOptions = document.createElement('div')
					                            showCasesOptions.className = 'showCasesOptions'
					                            showCasesOptions.id = 'showCasesOptions'
					                            showCasesOptions.appendChild(showCases)
					                            
					                            var p = document.createElement('p')
					                            p.innerHTML = 'Want to know more?'
					                            		
					                            var openPendingCases = document.createElement('div')
					                            openPendingCases.className=('openPendingCases')
					                            openPendingCases.id=('openPendingCases')
					                            openPendingCases.appendChild(p)
					                            openPendingCases.appendChild(showCasesOptions)
					                            
		                                        var botResponse = document.createElement('div')
		                                        botResponse.className = 'botResponse'
		                                        botResponse.id = 'botResponse'
		                                        botResponse.innerHTML = 'you have '+res.pendingCasesCount+' pending cases';
		                            			botResponse.appendChild(openPendingCases)
		                            			
		                                        var botMsg = document.createElement('div')
		                                        botMsg.className='botMsg'
		                                        botMsg.appendChild(botLogo3)
		                                        botMsg.appendChild(botResponse)
		                                        chatSection.appendChild(botMsg)
		                            			scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
		                            			speakout('you have '+res.pendingCasesCount+' pending cases');
		                            			
		                                    }
		                            		
		                            		,
		                            		error: function(){
		                            			alert('Server down');
		                            		}
		                            	});
                        			}
                        		}
                        	}
                        	else if(res.data.resultCategory === 'SCAN'){
                        		if(res.data.message === 'noName'){
                        			alert('real time scanning needs a customer/person name')
                	            	document.getElementById('userInput').value='';
                	            	if(chatSection.lastChild.lastChild.classList.contains('pleaseWait')){
                		        		chatSection.removeChild(chatSection.lastChild)
                	                	
                	                }
                        			
                        		}
                        		else if(res.data.message === 'directScan'){
                    				targetName = res.data.targetName
                    				openListScreen(targetName,res.data.message)
                    			}
                    			else{
                    				
	                    			targetName = res.data.targetName;
	                    			openListScreen(targetName,res.data.message);
                    			}
                				
                    			
                    		}
                        	
                        }
                    }
                   
                	scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
                   	document.getElementById('userInput').value = '';
                 
                }
        		,
        		error: function(){
        			alert('Server down');
        		}
        	});
            
        }
}

function openModule(res,option){
	if(option === 'Y'){
		
		var chatSection = document.getElementById('chatwindowChatSection')
		var botLogoImage = document.createElement('img')
		botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
		botLogoImage.className ='botLogoImage'
		botLogoImage.id = 'botLogoImage'
		
	    var botLogo3 = document.createElement('div')
	    botLogo3.className = "botLogo"
	    botLogo3.id = "botLogo"
	    botLogo3.appendChild(botLogoImage)
	    
	    var userQuery = document.getElementById('userInput').value;
	    
	    var alternateResultsList = document.createElement('div')
	    alternateResultsList.className = 'alternateResultsList display_toggle'
	    alternateResultsList.id = 'alternateResultsList'
	    alternateResultsList.style.display="none"
	    
	    var p = document.createElement('p')
	    if(res.data.alternateResults.length > 0){
	    	
	        p.innerHTML = 'here are a few alternative results'
	        alternateResultsList.appendChild(p)
	        
	        for(var x = 0; x < res.data.alternateResults.length; x++){
	        	if(res.data.message != res.data.alternateResults[x].moduleCode){
	        		
	        	var alternateResultButton = document.createElement('button')
	        	alternateResultButton.className = 'alternateResultButton'
	        	alternateResultButton.id = 'alternateResultButton'
	        	alternateResultButton.setAttribute('onclick','alternateResultHandler("'+userQuery+'","'+res.data.alternateResults[x].moduleCode+'","'+res.data.alternateResults[x].moduleName+'","'+res.data.alternateResults[x].moduleUrl+'","'+res.data.alternateResults[x].moduleMultiple+'","'+res.data.alternateResults[x].targetCategory+'")')
	        	alternateResultButton.innerHTML = res.data.alternateResults[x].moduleName
	        	alternateResultsList.appendChild(alternateResultButton)
	        	}
	        }
	        
	        var alternateResultButton = document.createElement('button')
	    	alternateResultButton.className = 'alternateResultButton'
	    	alternateResultButton.id = 'alternateResultButton'
	    	alternateResultButton.setAttribute('onclick','alternateResultHandler("none","none","none","none","none","none")')
	    	alternateResultButton.innerHTML = "None of the above"
	    	alternateResultButton.style.width="80%"
	    	alternateResultButton.style.marginLeft="10%"
	    	alternateResultsList.appendChild(alternateResultButton)
	    	
	    }
	    else{
	    	
	    	p.innerHTML = 'No alternate results available, please try a different query.'
	    	alternateResultsList.appendChild(p)
	    }
	    
	    var yesFunctionParams = 'sendYesFeedback("'+userQuery+'","'+res.data.moduleCode+'")';
	
	    var yesFeedbackButton = document.createElement('button')
	    yesFeedbackButton.setAttribute('onclick',yesFunctionParams)
	    yesFeedbackButton.innerHTML = 'Yes'
	    yesFeedbackButton.className = 'yesFeedbackButton yesOpitonButton';
	    yesFeedbackButton.id = 'yesOptionButton'
	    
	    var noFeedbackButton = document.createElement('button')
	    var noFunctionParams = "sendNoFeedback()";
	    noFeedbackButton.setAttribute('onclick',noFunctionParams)
	    noFeedbackButton.innerHTML = 'No'
	    noFeedbackButton.className = 'noFeedbackButton noOpitonButton';
	    noFeedbackButton.id = 'noOpitonButton'
	    
	    var yesOption = document.createElement('div')
	    yesOption.className = 'yesOption'
	    yesOption.id = 'yesOption'
	    yesOption.appendChild(yesFeedbackButton)
	    
	    var noOption = document.createElement('div')
	    noOption.className = 'noOption'
	    noOption.id = 'noOption'
	    noOption.appendChild(noFeedbackButton)
	    
	    var feedbackOption = document.createElement('div')
	    feedbackOption.className = 'feedbackOption'
	    feedbackOption.id = 'feedbackOption'
	    feedbackOption.appendChild(yesOption)
	    feedbackOption.appendChild(noOption)
	    
	    var p = document.createElement('p')
	    p.innerHTML = 'Is this what you asked for?'
	    		
	    var feedback = document.createElement('div')
	    feedback.className=('feedback')
	    feedback.id=('feedback')
	    feedback.appendChild(p)
	    feedback.appendChild(feedbackOption)										
	    
	    
	    var botResponse = document.createElement('div')
	    botResponse.className = 'botResponse'
	    botResponse.id = 'botResponse'
	    botResponse.innerHTML = res.data.message
	    
	    botResponse.appendChild(alternateResultsList)
	    
		if(res.data.hasUtterance == 0){
	        botResponse.appendChild(feedback)
		}
		else{
			 var feedback = document.createElement('div')
			 
			 var showAlternateButton = document.createElement('button')
			 showAlternateButton.setAttribute('onclick',"sendNoFeedback()")
	         showAlternateButton.innerHTML = 'Show Alternative results'
	         showAlternateButton.className = 'showPendingCasesButton showCasesButton showAlternateButton';
			 showAlternateButton.id = 'showAlternateButton'
			 showAlternateButton.style.marginLeft = '0'
			 showAlternateButton.style.marginTop = '5px'
			 
	        
	         var showAlternates = document.createElement('div')
	         showAlternates.className = 'showCases showAlternates'
	         showAlternates.id = 'showAlternates'
	         showAlternates.appendChild(showAlternateButton)
	        
	         var showAlternateOptions = document.createElement('div')
	         showAlternateOptions.className = 'showCasesOptions showAlternateOptions'
	    	 showAlternateOptions.id = 'showCasesOptions'
			 showAlternateOptions.appendChild(showAlternates)
	        
	        
	         var openAlternates = document.createElement('div')
	         openAlternates.className=('openPendingCases openAlternates')
	         openAlternates.id=('openPendingCases')
	         openAlternates.appendChild(showAlternateOptions)
	         
	         feedback.className=('feedback')
	         feedback.id=('feedback')
	         feedback.style.borderTop = 'none'
	         
	         feedback.appendChild(openAlternates)
	         
	         botResponse.appendChild(feedback)
		}
	    
	    var botMsg = document.createElement('div')
	    botMsg.className='botMsg'
	    botMsg.appendChild(botLogo3)
	    botMsg.appendChild(botResponse)
	    chatSection.appendChild(botMsg)
	    
	    var scrollTargetDiv = document.getElementById("chatwindowChatSection");
	    scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
	    document.getElementById('userInput').value = '';
	    if(!res.data.uniqueId){
	    	
	    }
	}
    speakout('opening '+res.data.moduleName +'module')
    navigate(res.data.moduleName,res.data.moduleCode,res.data.moduleUrl,res.data.moduleMultiple);
}

async function askUserOption(res){
	
	var chatSection = document.getElementById('chatwindowChatSection')
	
	
	
	var botLogoImage = document.createElement('img')
	botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
	botLogoImage.className ='botLogoImage'
	botLogoImage.id = 'botLogoImage'
	
    var botLogo3 = document.createElement('div')
    botLogo3.className = "botLogo"
    botLogo3.id = "botLogo"
    botLogo3.appendChild(botLogoImage)
    
    var userQuery = document.getElementById('userInput').value;
    
    var alternateResultsList = document.createElement('div')
    alternateResultsList.className = 'alternateResultsList display_toggle'
    alternateResultsList.id = 'alternateResultsList'
    alternateResultsList.style.display="none"
    
    var p = document.createElement('p')
    if(res.data.alternateResults.length > 0){
    	
        p.innerHTML = 'here are a few alternative results'
        alternateResultsList.appendChild(p)
        
        for(var x = 0; x < res.data.alternateResults.length; x++){
        	/* if(res.data.message != res.data.alternateResults[x].moduleCode){ */
        		
        	var alternateResultButton = document.createElement('button')
        	alternateResultButton.className = 'alternateResultButton '+x.toString()
        	alternateResultButton.id = 'alternateResultButton'
        	/* alternateResultButton.setAttribute('onclick','alternateResultHandler("'+userQuery+'","'+res.data.alternateResults[x].moduleCode+'","'+res.data.alternateResults[x].moduleName+'","'+res.data.alternateResults[x].moduleUrl+'","'+res.data.alternateResults[x].moduleMultiple+'","'+res.data.alternateResults[x].targetCategory+'")')
        	 */
       	 	alternateResultButton.innerHTML = res.data.alternateResults[x].moduleName
        	alternateResultsList.appendChild(alternateResultButton)
        	/* } */
        }
        
        var alternateResultButton = document.createElement('button')
    	alternateResultButton.className = 'alternateResultButton optLast'
    	alternateResultButton.id = 'alternateResultButton'
    	alternateResultButton.setAttribute('onclick','alternateResultHandler("none","none","none","none","none","none")')
    	alternateResultButton.innerHTML = "None of the above"
    	alternateResultButton.style.width="80%"
    	alternateResultButton.style.marginLeft="10%"
    	alternateResultsList.appendChild(alternateResultButton)
    	
    }
    else{
    	
    	p.innerHTML = 'No alternate results available, please try a different query.'
    	alternateResultsList.appendChild(p)
    }
    
    
    var userOptionConfirm = document.createElement('button')
    userOptionConfirm.className = "userOption alternateResultButton"
    userOptionConfirm.id = 'userOptionConfirm'
    userOptionConfirm.innerHTML = 'Confirm'
    
    var userOptionOpenModule = document.createElement('button')
    userOptionOpenModule.className = "userOption alternateResultButton"
    userOptionOpenModule.id = 'userOptionOpenModule'
    userOptionOpenModule.innerHTML = 'open module'
    
    var changeModuleButton = document.createElement('button')
    changeModuleButton.className = "userOption alternateResultButton"
    changeModuleButton.id = 'changeModuleButton'
    changeModuleButton.innerHTML = 'change module'
    
    var userOptions = document.createElement('div')
    userOptions.className = 'userOptions'
    userOptions.id = 'userOptions'
    userOptions.appendChild(userOptionConfirm)
    userOptions.appendChild(userOptionOpenModule)
    userOptions.appendChild(changeModuleButton)
    
    var botResponse = document.createElement('div')
    botResponse.className = 'botResponse'
    botResponse.id = 'botResponse'
    
    msg = 'opening '+res.data.moduleName + ' module with '
    for(x=0; x < res.data.moduleParamList.paramIdList.length; x++){
    	if(res.data.moduleParamValues.valuesDict[res.data.moduleParamList.paramIdList[x]] && res.data.moduleParamList.paramIdList.includes(res.data.moduleParamList.paramIdList[x]) ){
    		msg = msg+' '+res.data.moduleParamList.paramIdList[x]+' = ' +res.data.moduleParamValues.valuesDict[res.data.moduleParamList.paramIdList[x]]
    	}
    	
    }
    speakout(msg)
    botResponse.innerHTML = msg
    botResponse.appendChild(alternateResultsList)
    botResponse.appendChild(userOptions)
    
    var botMsg = document.createElement('div')
    botMsg.className='botMsg'
    botMsg.appendChild(botLogo3)
    botMsg.appendChild(botResponse)
    chatSection.appendChild(botMsg)
    
    
    chatSection.scrollTop = chatSection.scrollHeight;
    document.getElementById('userInput').value = '';
    
    document.querySelectorAll('.alternateResultButton').forEach(item => {
    		/* console.log(item.classList[1])
    		console.log(item.innerHTML) */
	    	if (parseInt(item.classList[1]) >= 0){
	    		
	    	  item.addEventListener('click', event => {
	    		moduleCode = res.data.alternateResults[parseInt(item.classList[1])]["moduleCode"]
	    		moduleName = res.data.alternateResults[parseInt(item.classList[1])]["moduleName"]
	    		moduleUrl = res.data.alternateResults[parseInt(item.classList[1])]["moduleUrl"]
	    		moduleMultiple = res.data.alternateResults[parseInt(item.classList[1])]["moduleMultiple"]
	    		
	    		/* alert((moduleCode+' ' +moduleName+' ' +moduleUrl+' ' +moduleMultiple)) */
	    		
	    	  	navigate(moduleName,moduleCode,moduleUrl,moduleMultiple)
	    	  	chatSection.removeChild(chatSection.lastChild)
	    	  	moduleParameters = res.data.alternateResults[parseInt(item.classList[1])]['moduleParamList']['paramIdList']
	    		moduleParamValues = {}
	    		for(x = 0 ; x< moduleParameters.length ; x++){
	    			if(res.data.moduleParamValues.valuesDict[moduleParameters[x]]){
	    				moduleParamValues[moduleParameters[x]] =  res.data.moduleParamValues.valuesDict[moduleParameters[x]]
	    			}
	    		}
	    		
	    		/* console.log(moduleParamValues) */
	    		handleUserOptionsChangeModuleModuleOption(moduleParameters,moduleParamValues)
	    		
	    	  })
	    	}
    	})
    

    
    document.getElementById('userOptionConfirm').addEventListener('click',function(){
    	var lastchild = chatSection.lastChild;
		lastlastchild = lastchild.lastChild;
		if(lastlastchild.lastChild.classList.contains('userOptions')){
			lastlastchild.removeChild(lastlastchild.lastChild)
		}
    	
    	handleUserConfirm(res)
    })
    
    document.getElementById('userOptionOpenModule').addEventListener('click',function(){
    	var lastchild = chatSection.lastChild;
		lastlastchild = lastchild.lastChild;
		if(lastlastchild.lastChild.classList.contains('userOptions')){
			lastlastchild.removeChild(lastlastchild.lastChild)
		}
		
    	openModule(res,'N')
    })
    document.getElementById('changeModuleButton').addEventListener('click',function(){
    	sendNoFeedback()
    })
	
}
async function handleUserOptionsChangeModuleModuleOption(moduleParameters,moduleParamValues){
	await sleep(1000)
	try{
		ID = []
		$("*").each(function() { 
	        if (this.id) { 
	            ID.push(this.id); 
	        } 
	    }); 
	   
	    for(x = 0;x<ID.length;x++){
	    	/* alert(ID[x]) */
			for(id = 0;id < moduleParameters.length; id++){
				if(ID[x].startsWith(moduleParameters[id])){
					if(moduleParamValues[moduleParameters[id]]){
						
						document.getElementById(ID[x]).value = moduleParamValues[moduleParameters[id]]
					}
				}
			}
		}
		for(x = 0;x<ID.length;x++){
	    	
			if(ID[x].startsWith('search')){
				document.getElementById(ID[x]).click()
			}
		
		}
	}
	catch(e){
		alert(e)
	}
	
}
async function handleUserConfirm(res){
	openModule(res,'N')
	ID = []
	await sleep(2000)
	$("*").each(function() { 
        if (this.id) { 
            ID.push(this.id); 
        } 
    }); 
   
    for(x = 0;x<ID.length;x++){
    	
		for(id = 0;id < res.data.moduleParamValues.fieldIdList.length; id++){
			if(ID[x].startsWith(res.data.moduleParamValues.fieldIdList[id])){
				document.getElementById(ID[x]).value = res.data.moduleParamValues.valuesDict[res.data.moduleParamValues.fieldIdList[id].replace('_','')]
			}
		}
	}
	for(x = 0;x<ID.length;x++){
    	
		if(ID[x].startsWith('search')){
			document.getElementById(ID[x]).click()
		}
	
	}
   
    	
	
}
async function handeModuleResponse(res){
	/* alert(res.data.moduleParamValues.fieldIdList) */
	if(res.data.moduleParamValues.fieldIdList.length > 0)
		{
		
		askUserOption(res)
		}
	else{
		openModule(res,'Y')
	}
	/* ("please select an operation for " +res.data.moduleName+" module")
	openModule(res)
    if(res.data.uniqueId){
    
        if(res.data.moduleCode === 'customerMaster'){
        	speakout('opening customer data for I D '+res.data.uniqueId)
        	getInputFields(res.data.uniqueId,'CUSTOMERID_','searchCustomerMaster')
        }
        if(res.data.moduleCode.startsWith('trans')){
        	speakout("opening transaction data for customer with I D " + res.data.uniqueId) 
        	getInputFields(res.data.uniqueId,'CUSTOMERID_','searchTransactionDetails')
        }
    } */
	
}

async function getInputFields(uniqueId,uniqueIdInputFieldId,searchButtonId){
	fieldId = ''
	searchButton = ''
	await sleep(2000)
	 var ID = []; 
	    $("*").each(function() { 
	        if (this.id) { 
	            ID.push(this.id); 
	        } 
	    }); 
	   
	    for(x = 0;x<ID.length;x++){
	    	
	    	if(ID[x].startsWith(uniqueIdInputFieldId)){
	    		fieldId = ID[x]
	    	}
	    	else if(ID[x].startsWith('search')){
	    		searchButton = ID[x]
	    	}
	    	
	    }
    try{
    	
		document.getElementById(fieldId).value = uniqueId
    }
    catch(e){
    	alert(e)
    }
    try{
    	
	 	document.getElementById(searchButton).click()
   }
   catch(e){
	   alert(e+' '+searchButton)
   }

}

function alternateResultHandler(userQuery,moduleCode,moduleName,moduleUrl,moduleMultiple,targetCategory){
	
	if(moduleCode === "none"){
		var chatSection = document.getElementById('chatwindowChatSection')
		chatSection.removeChild(chatSection.lastChild)
		
		var botLogoImage = document.createElement('img')
		botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
		botLogoImage.className ='botLogoImage'
		botLogoImage.id = 'botLogoImage'
			
	    var botLogo3 = document.createElement('div')
	    botLogo3.className = "botLogo"
	    botLogo3.id = "botLogo"
	    botLogo3.appendChild(botLogoImage)
	    
	    var botResponse = document.createElement('div')
	    botResponse.className = 'botResponse'
	    botResponse.id = 'botResponse'
	    botResponse.innerHTML = "I am still learning. Please try giving a different query."
	    var botMsg = document.createElement('div')
	    botMsg.className='botMsg'
	    botMsg.appendChild(botLogo3)
	    botMsg.appendChild(botResponse)
	    speakout('i am sorry, i am still learning. please try a different query')
	    chatSection.appendChild(botMsg)
	    
	    var scrollTargetDiv = document.getElementById("chatwindowChatSection")
	    scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
		return
	}
	/* speakout('khushi huyyi') */
	document.getElementById('userInput').value = ''
	speakout('i am glad')
    speakout('opening '+moduleName +'module')
    navigate(moduleName,moduleCode,moduleUrl,moduleMultiple)
    document.getElementById('alternateResultsList').remove()
    var chatSection = document.getElementById('chatwindowChatSection')
	var lastchild = chatSection.lastChild;
	lastchild.childNodes[1].innerHTML = 'Iam glad :)'
	
}


async function openListScreen(targetName,message){
	if(message === 'directScan'){
		
		var chatSection = document.getElementById('chatwindowChatSection')
		var botLogoImage = document.createElement('img')
		botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
		botLogoImage.className ='botLogoImage'
		botLogoImage.id = 'botLogoImage'
		
        var botLogo3 = document.createElement('div')
        botLogo3.className = "botLogo"
        botLogo3.id = "botLogo"
        botLogo3.appendChild(botLogoImage)
        
        var performListScreenButton = document.createElement('button')
        
        var functionParams = 'openListScreen("'+targetName+'","'+'scan'+'")';
 		
		performListScreenButton.setAttribute('onclick',functionParams)
        performListScreenButton.innerHTML = 'List screen'
        performListScreenButton.className = 'performListScreenButton showCasesButton';
		performListScreenButton.id = 'performListScreenButton'
        
        var performScreening = document.createElement('div')
        performScreening.className = 'showCases'
        performScreening.id = 'performScreening'
        performScreening.appendChild(performListScreenButton)
        
        var performScreeningOptions = document.createElement('div')
        performScreeningOptions.className = 'showCasesOptions'
        performScreeningOptions.id = 'performScreeningOptions'
        performScreeningOptions.appendChild(performScreening)
        
        var p = document.createElement('p')
        p.innerHTML = 'Do you want to list Screen this person?'
        		
        var openListScreening = document.createElement('div')
        openListScreening.className=('openPendingCases')
        openListScreening.id=('openListScreening')
        openListScreening.appendChild(p)
        openListScreening.style.border = 'none'
        openListScreening.appendChild(performScreeningOptions)
        
        var botResponse = document.createElement('div')
        botResponse.className = 'botResponse'
        botResponse.id = 'botResponse'
        
		botResponse.appendChild(openListScreening)
		
		/* var p = document.createElement('p')
        p.innerHTML = 'If not please try giving a different query.' 
		p.style.fontSize = "10px"
		p.style.paddingTop = '5px'
        botResponse.appendChild(p) */
		
        var botMsg = document.createElement('div')
        botMsg.className='botMsg'
        botMsg.appendChild(botLogo3)
        botMsg.appendChild(botResponse)
        chatSection.appendChild(botMsg)
		chatSection.scrollTop = chatSection.scrollHeight;
	}
	else{
		
		navigate('Real Time Scanning','realtimeScanning','common/realtimeScanning','1')
		
		document.getElementById('userInput').value='';
		
		try{
			
			document.getElementById('scanName1').value= targetName.replace('screen','');
	    	document.getElementById('scanDetails').click();
	    	speakout('here are the matches for '+targetName)
		}
		catch(e){
			await sleep(1000)
			speakout('here are the matches for '+targetName)
	    	document.getElementById('scanName1').value= targetName;
	    	document.getElementById('scanDetails').click();
		}
	}
}

function setSpeech() {
    return new Promise(
        function (resolve, reject) {
            let synth = window.speechSynthesis;
            let id;

            id = setInterval(() => {
                if (synth.getVoices().length !== 0) {
                    resolve(synth.getVoices());
                    clearInterval(id);
                }
            }, 10);
        }
    )
}


function speakout(msg){
	let s = setSpeech();
	s.then((voices) => {
		
		
      	let speech = new SpeechSynthesisUtterance();
        speech.lang = "hi-IN";
        speech.text = msg;
        speech.volume = 1;
        speech.rate = 1;
        speech.pitch = 1;
        speech.voice = voices[9];
      
        window.speechSynthesis.speak(speech);
		});
	
}

function sleep(ms) {
	  return new Promise(resolve => setTimeout(resolve, ms));
	}


async function toggle(){
		speakout('phir milengye')
		await sleep(1000)
		document.getElementById('chatWindowToggler').classList.toggle('display_toggle');
		if(document.getElementById('chatWindowToggler').classList.contains('display_toggle')){
			
			document.getElementById('chatwindow').style.display='block';
		}
		else{
			
			document.getElementById('chatwindow').style.display='none';
		}
	} 
	
async function openPendingCases(moduleCode,moduleName,moduleUrl,moduleMultiple){
	
	var chatSection = document.getElementById('chatwindowChatSection')
	var lastchild = chatSection.lastChild;
	lastlastchild = lastchild.lastChild
	lastlastchild.removeChild(lastlastchild.lastChild)
	navigate(moduleName,moduleCode,moduleUrl,moduleMultiple);
	
}
async function openPendingCasesWithDate(moduleCode,moduleName,moduleUrl,moduleMultiple,ftdate){
	
	
	navigate(moduleName,moduleCode,moduleUrl,moduleMultiple);
	await sleep(1000)
	var ID = []; 
    $("*").each(function() { 
        if (this.id) { 
            ID.push(this.id); 
        } 
    }); 
   
    for(x = 0;x<ID.length;x++){
    	
    	if(ID[x].startsWith('FROMDATE')){
    		
			document.getElementById(ID[x]).value = ftdate
    	}
    	
    	if(ID[x].startsWith('TODATE')){
    		
			document.getElementById(ID[x]).value = ftdate
    	}
    	
    	
    }
    for(x=0;x<ID.length;x++){
    	if(ID[x].startsWith('searchAml')){
    		
    		document.getElementById(ID[x]).click()
    	}
    }
}

function sendNoFeedback(alternateResults){
	document.getElementById('alternateResultsList').style.display="block";
	var chatSection = document.getElementById('chatwindowChatSection')
	var lastchild = chatSection.lastChild;
	
	lastchildSecondchild = lastchild.childNodes[1]
	
	/* to remove module name from bot response */
	lastchildSecondchild.removeChild(lastchildSecondchild.childNodes[0])

	/* to remove feedback option */
 	lastlastchild = lastchild.lastChild
	lastlastchild.removeChild(lastlastchild.lastChild)  
	/* console.log(document.getElementById('chatwindowChatSection').childNodes) */
	if(document.getElementById('alternateResultsList').childNodes.length <= 2){
		speakout('no alternatives found, pleas try with a different query')
		lastlastchild.innerHTML = 'Sorry buddy, no other alternative found , please try using a different query'
	}

	
	
    var scrollTargetDiv = document.getElementById("chatwindowChatSection");
    scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
	
}

function sendYesFeedback(userQuery,moduleCode){
	
	$.ajax({
		url: "${pageContext.request.contextPath}/query/feedback?queryString="+userQuery.replace('|','')+"&moduleCode="+moduleCode.replace('|',''),
		cache: false,
		type: "GET",
		
		success: function(res){
			var chatSection = document.getElementById('chatwindowChatSection')
			var lastchild = chatSection.lastChild;
			lastlastchild = lastchild.lastChild
			lastlastchild.removeChild(lastlastchild.lastChild)
			lastlastchild.removeChild(lastlastchild.lastChild)
			
			
			var botLogoImage = document.createElement('img')
   			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
   			botLogoImage.className ='botLogoImage'
   			botLogoImage.id = 'botLogoImage'
   			
            var botLogo3 = document.createElement('div')
            botLogo3.className = "botLogo"
            botLogo3.id = "botLogo"
            botLogo3.appendChild(botLogoImage)
            
            var botResponse = document.createElement('div')
            botResponse.className = 'botResponse'
            botResponse.id = 'botResponse'
            botResponse.innerHTML = "Thanks for your feedback."
            var botMsg = document.createElement('div')
            botMsg.className='botMsg'
            botMsg.appendChild(botLogo3)
            botMsg.appendChild(botResponse)
            chatSection.appendChild(botMsg)
            var scrollTargetDiv = document.getElementById("chatwindowChatSection");
            scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
            
		}
	,
	error: function(){
		alert('sorry, error while saving your feedback');
		}
	});
		
}

function getWordList() {
    return JSON.parse($.ajax({
        type: 'GET',
        url: "${pageContext.request.contextPath}/query/getWordList",
        dataType: 'json',
        global: false,
        async: false,
        success: function (data) {
            return data;
        }
    }).responseText);
}

$( window ).load(function(){
		
	
		
		document.getElementById('chat_window_toggler').addEventListener('click', function() {
			  
			 
			  audioContext.resume().then(() => {
			    document.getElementById('chatWindowToggler').classList.toggle('display_toggle');
				if(document.getElementById('chatWindowToggler').classList.contains('display_toggle')){
					
					document.getElementById('chatwindow').style.display='block';
				}
				else{
					
					document.getElementById('chatwindow').style.display='none';
				}
			  });
			  
			  if($("#chatwindowChatSection > div").length === 1){
			  	speakout('namaste');
			  }
			});
		
		var chatWindowOpener = setTimeout(function(){document.getElementById('chat_window_toggler').click();},1000)
        var outputSampleRate = 16000;
        
        var acousticModel = "${pageContext.request.contextPath}/includes/scripts/pages/common/template/rm1_200";
      
        var amFolder = "${pageContext.request.contextPath}/includes/scripts/pages/common/template/pocketsphinx.js-en_US-rm1_200";
       
        var dictionary;
       
        var languageModel;
        
        var amFiles = [
        	"feat.params.js", 
        	"mdef.js", 
        	"means.js", 
        	"noisedict.js", 
        	"sendump.js", 
        	"transition_matrices.js", 
        	"variances.js"];
       	var wordList = WordList();
        
        
        var grammar1 = {numStates: 1, start: 0, end: 0, transitions: [
        	
            {from: 0, to: 0, word: "maya"},
            {from: 0, to: 0, word: "transaction"},
            {from: 0, to: 0, word: "monitoring"},
            {from: 0, to: 0, word: "data"},
            {from: 0, to: 0, word: "research"},
            {from: 0, to: 0, word: "customer"},

            {from: 0, to: 0, word: "master"},
            {from: 0, to: 0, word: "which"},
            {from: 0, to: 0, word: "company"},
            {from: 0, to: 0, word: "quantum"},
        
            {from: 0, to: 0, word: "module"},
            {from: 0, to: 0, word: "open"},
            {from: 0, to: 0, word: "for"},
            {from: 0, to: 0, word: "the"},
            {from: 0, to: 0, word: "details"},
            {from: 0, to: 0, word: "show"},
            {from: 0, to: 0, word: "case"},
            {from: 0, to: 0, word: "engine"},
            {from: 0, to: 0, word: "notifications"},
            {from: 0, to: 0, word: "pending"},
            {from: 0, to: 0, word: "cases"},
            {from: 0, to: 0, word: "my"},
            {from: 0, to: 0, word: "do"},
            {from: 0, to: 0, word: "i"},
            {from: 0, to: 0, word: "have"},
            {from: 0, to: 0, word: "one"},
            {from: 0, to: 0, word: "two"},
            {from: 0, to: 0, word: "three"},
            {from: 0, to: 0, word: "four"},
            {from: 0, to: 0, word: "five"},
            {from: 0, to: 0, word: "six"},
            {from: 0, to: 0, word: "seven"},
            {from: 0, to: 0, word: "eight"},
            {from: 0, to: 0, word: "nine"},
            
            
            

              
    
        ]};
        var grammars = [{title: "Grammar 1", g: grammar1}];
       
        var grammarIds = [];
  
        // These will be initialized later
        var recognizer, recorder, callbackManager, audioContext, outputContainer;
        // Only when both recorder and recognizer are ready do we have a ready application
        var recorderReady = recognizerReady = false;
  
        // A convenience function to post a message to the recognizer and associate
        // a callback to its response
        function postRecognizerJob(message, callback) {
          var msg = message || {};
          if (callbackManager) msg.callbackId = callbackManager.add(callback);
          if (recognizer) recognizer.postMessage(msg);
        };
        
        function spawnWorker(workerURL, onReady) {
            recognizer = new Worker(workerURL);
            recognizer.onmessage = function(event) {
              onReady(recognizer);
            };

            recognizer.postMessage('');
        };
  
        // To display the hypothesis sent by the recognizer
        function updateHyp(hyp) {
            console.log(hyp);
            console.log(document.getElementById('userInput').value)
             console.log(hyp.replace('Final: ',''))
             document.getElementById('userInput').value = hyp.replace('Final: ','')
          if (outputContainer) outputContainer.value = hyp;
          if (outputContainer) outputContainer.innerHTML = hyp;
          
        };
  
        // This updates the UI when the app becomes ready
        // Only when both recorder and recognizer are ready do we enable the buttons
        function updateUI() {
          if (recorderReady && recognizerReady) voiceIntakeButton.disabled = false;
        };
  

        // Callback function once the user authorises access to the microphone
        // in it, we instanciate the recorder
        function startUserMedia(stream) {
          // This is where magic happens, we can now get the audio samples
          // from getUserMedia

          var input = audioContext.createMediaStreamSource(stream);
          window.firefox_audio_hack = input; 
          var audioRecorderConfig = {
              outputSampleRate: outputSampleRate,
              errorCallback: function(x) {}};
          recorder = new AudioRecorder(input, audioRecorderConfig);
          // If a recognizer is ready, we pass it to the recorder
          if (recognizer) recorder.consumers = [recognizer];
          recorderReady = true;
          updateUI();

        };
  
        // This starts recording. We first need to get the id of the grammar to use
        /* var startRecording = function() {
          if (recorder && recorder.stop()) {recorder && recorder.start('0');} else{ if (recorder && recorder.start('0')) {}};
          setTimeout(function() {
          recorder && recorder.stop();
        },3000)
        }; */
        
        var startRecording = function() {
             if (recorder && recorder.start('0')) {}
            setTimeout(function() {
            recorder && recorder.stop();
            var chatSection = document.getElementById('chatwindowChatSection')
            chatSection.removeChild(chatSection.lastChild);
          },3000)
          };
  
        // Called once the recognizer is ready
        // We then add the grammars to the input select tag and update the UI
        var recognizerReady = function() {

             recognizerReady = true;
             updateUI();
        };
  
       
  
        // In case we use grammars
        // This adds a grammar from the grammars array
        // We add them one by one and call it again as
        // a callback.
        // Once we are done adding all grammars, we can call
        // recognizerReady()
        var feedGrammar = function(g, index, id) {
          if (id && (grammarIds.length > 0)) grammarIds[0].id = id.id;
          if (index < g.length) {
            grammarIds.unshift({title: g[index].title})
        postRecognizerJob({command: 'addGrammar', data: g[index].g},
                               function(id) {feedGrammar(grammars, index + 1, {id:id});});
          } else {
            recognizerReady();
          }
        };
        // In case we use grammars, and add dictionary words at runtime
        // This adds words to the recognizer. When it calls back, we add grammars
        var feedWords = function(words) {
             postRecognizerJob({command: 'addWords', data: words},
                          function() {
                            feedGrammar(grammars, 0);
                          });
        };
  
        // This initializes the recognizer. When it calls back, we add words
        var initRecognizer = function() {
            // You can pass parameters to the recognizer, such as : {command: 'initialize', data: [["-hmm", "my_model"], ["-fwdflat", "no"]]}
            var data = [["-hmm",'rm1_200']];

            if (dictionary) data.push(["-dict", dictionary]);
            if (languageModel) data.push(["-lm", languageModel]);

            
            postRecognizerJob({command: 'initialize', data:data},
                              function() {
                                          if (recorder) recorder.consumers = [recognizer];
                                          if (grammars) feedWords(wordList);
                                          else recognizerReady();
                                          });
        };
  
        var loadModels = function() {
            var data = amFiles.map(function(x) {return amFolder+'/'+ x;});
            if (dictionary) data.push(dictionaryFile);
            if (languageModel) data.push(languageModelFile);
  
            postRecognizerJob({command: 'load', data: data}, initRecognizer);
        };
        
   
        outputContainer = document.getElementById("output");
       
        callbackManager = new CallbackManager();
        spawnWorker("${pageContext.request.contextPath}/includes/scripts/pages/common/template/recognizer.js", function(worker) {
            // This is the onmessage function, once the worker is fully loaded
            worker.onmessage = function(e) {
                // This is the case when we have a callback id to be called
                if (e.data.hasOwnProperty('id')) {
                  var clb = callbackManager.get(e.data['id']);
                  var data = {};
                  if ( e.data.hasOwnProperty('data')) data = e.data.data;
                  if(clb) clb(data);
                }
                // This is a case when the recognizer has a new hypothesis
                if (e.data.hasOwnProperty('hyp')) {
                  var newHyp = e.data.hyp;
                  if (e.data.hasOwnProperty('final') &&  e.data.final) {
                      newHyp =  newHyp;
                      updateHyp(newHyp);
                      document.getElementById('querySubmitButton').click()
                      return
                      }
                  else{

                  updateHyp(newHyp);
                  }
                  
                }
                // This is the case when we have an error
                 if (e.data.hasOwnProperty('status') && (e.data.status == "error")) {
                  
                  console.log("Error in " + e.data.command + " with code " + e.data.code)
                } 
            };
            // Once the worker is fully loaded, we can call the initialize function
            loadModels();
            
        });

   
        try {
          window.AudioContext = window.AudioContext || window.webkitAudioContext;
          navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
          window.URL = window.URL || window.webkitURL;
          audioContext = new AudioContext();
        } catch (e) {
          
          console.log("Error initializing Web Audio browser")
        }
        if (navigator.getUserMedia) navigator.getUserMedia({volume:6,audio: true}, startUserMedia, function(e) {
                                      
                                        console.log("No live audio input in this browser")
                                    });
        
        else console.log("No web audio support in this browser")
        
        var recognitionStarter = document.getElementById("voiceIntakeButton");
        recognitionStarter.addEventListener("click", function(event) {
        	
        	var botLogoImage = document.createElement('img')
			botLogoImage.src = '${pageContext.request.contextPath}/includes/images/botLogo3.png';
			botLogoImage.className ='botLogoImage'
			botLogoImage.id = 'botLogoImage'
			
            var botLogo3 = document.createElement('div')
            botLogo3.className = "botLogo"
            botLogo3.id = "botLogo"
            botLogo3.appendChild(botLogoImage)
            
           
            
            var botResponse = document.createElement('div')
            botResponse.className = 'botResponse'
            botResponse.id = 'botResponse'
            botResponse.innerHTML = 'Listening...'
            botResponse.style.color='red'
            
            var botMsg = document.createElement('div')
            botMsg.className='botMsg'
            botMsg.appendChild(botLogo3)
            botMsg.appendChild(botResponse)
            var chatSection = document.getElementById('chatwindowChatSection')
            chatSection.appendChild(botMsg)
            
            var scrollTargetDiv = document.getElementById("chatwindowChatSection");
            scrollTargetDiv.scrollTop = scrollTargetDiv.scrollHeight;
            startRecording();
		});
        
       
   
}); 
  
</script>  

<body>
<script>

</script>

    <div class="chatwindow  " id="chatwindow" style='display:none;' >
        <div class="chatwindowHeader" id="chatwindowHeader">
            <div class="chatwindowHeaderName" id="chatwindowHeaderName" style='color:white;'>
                <b>Maya</b>
            </div>
            <div class="chatwindowHeaderClose" id="chatwindowHeaderClose">
                <!-- <button class="closeButton" id="closeButon" onclick = toggle();><b>X</b></button> -->
                <button type="button" class="close" onclick=toggle(); data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove" ></span>
						</button>
            </div>
        </div>
        <div class="chatwindowChatSection" id="chatwindowChatSection">
                <div class="botMsg" id="botMsg">
                    <div class="botLogo" id="botLogo">
                        <img class = 'botLogoImage' id = 'botLogoImage' src="${pageContext.request.contextPath}/includes/images/botLogo3.png"/>
                    </div>
                    
                    <div class="botResponse" id="botResponse">
                        Welcome!
                    </div>
                </div>
               
        </div>
        <div class="inputSectionContainer" id="inputSectionContainer">
            <div class="chatwindowInputSection" id="chatwindowInputSection">
                <div class="inputArea" id="inputArea">
                    <input type="text" name="userInput" id="userInput" placeholder="Enter query">
                </div>
                <div class="submitArea " id="submitArea">
                    <div class="send" id="send">
                        <img id = "querySubmitButton" class='submitButton' onclick=chatWindowHandler(); src="${pageContext.request.contextPath}/includes/images/chatWindowSendButton.png" height=25px width=25px>
                        
                    </div>
                    <div class="voiceInput" id="voiceInput">
                       <button id="voiceIntakeButton" class="submitButton" style="margin-left:2px;">
                            <i class="fa fa-microphone submitbutton" id = "voiceIntakeButton" style="color:white;" ></i>
                       </button> 
                    </div>
                    
                </div>
    
            </div>

        </div>
        <script>
            var input = document.getElementById("userInput");
            input.addEventListener("keyup", function(event) {
              if (event.keyCode === 13) {
               event.preventDefault();
               document.getElementById("querySubmitButton").click();
               input.value='';
              }
            });
        </script>
    </div>
    
    <div class="chatWindowToggler" id="chatWindowToggler" style="position:fixed;bottom:6%;right:1%;">
        <img id = "chat_window_toggler" src="${pageContext.request.contextPath}/includes/images/chatWindowOpenButton.png" height=40px width=40px>
    </div>
    <!-- <div class="togglerCaption" id="togglerCaption" style="position:fixed;bottom:6%;right:8%; font-size:30px;">
    	<label>Hey there!</label>
    </div> -->

      
</body>
<script src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/wordList.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/test_script.js"></script>
<script src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/audioRecorder.js"></script>
<script src="${pageContext.request.contextPath}/includes/scripts/pages/common/template/callbackManager.js"></script>

</html>