/*17.08.2019*/

var compassUserNotes = compassUserNotes || (function(){
		return {
			userNotesInterval: function(wholeData, id, intervalSeconds, action){
				var interval = null;
				interval = setInterval(intervalFunction,intervalSeconds);
				
				var counter = 0;
				function intervalFunction(){
				    //console.log(" counter "+counter);
				    
				    var dateTime = new Date();
				
					var day = dateTime.getDate();
					var month = dateTime.getMonth()+1;
					var year = dateTime.getFullYear();
					
					var hours = dateTime.getHours();
					var minutes = dateTime.getMinutes();
					var seconds = dateTime.getSeconds();
					
					var date = ((''+day).length<2 ? '0' : '') + day + "/" + ((''+month).length<2 ? '0' : '') + month + "/" + year; 
					// var time = hours + "." + minutes + "." + ((''+seconds).length<2 ? '0' : '') + seconds;
					var time = ((''+hours).length<2 ? '0' : '') + hours + ":" +((''+minutes).length<2 ? '0' : '') + minutes;
					var currentDateTime = date + " " +time;
					// console.log(currentDateTime);
					
					$.each(wholeData, function(index, eachNote){
						$.each(eachNote, function(key, value){
							//console.log("-------------");
							if(key == "REMINDERTIME"){
								//console.log(value+"---"+currentDateTime);
								if(value == currentDateTime){
									//console.log("yes = "+index+ "--- "+value+"---"+currentDateTime);
									// alert("Reminder ="+wholeData[index]['NOTES']);
									$("#compassReminderModal").modal("show");
									$("#compassReminderModal-title").html("Reminder");
									$("#compassReminderModal-body").html("<p style='word-break: break-word;'>"+wholeData[index]['NOTES']+"</p>");
								}
							}
						});
					});
				    counter = counter + 1;					
				}
				
				if(action == "Stop"){
			    	clearInterval(interval); // stop the interval
			    	// console.log("Interval stopped");
			    }
			}
		};
}());