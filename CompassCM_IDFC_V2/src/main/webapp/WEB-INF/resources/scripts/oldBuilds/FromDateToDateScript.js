function getDate(date, type, amount){
		var l_dateSysDate = new Date(date);
		if(type == "Y"){
			l_dateSysDate.setDate(l_dateSysDate.getFullYear() - amount);
	    };
	    if(type == "M"){
	    	l_dateSysDate.setDate(l_dateSysDate.getMonth() +1 -amount);
	    };
	    if(type == "D"){
	    	l_dateSysDate.setDate(l_dateSysDate.getDate() - amount);
	    };
	    
	    var l_strYear = l_dateSysDate.getFullYear();
        var	l_strMonth = l_dateSysDate.getMonth()+1;

		if(l_strMonth.toString().length == 1){
			l_strMonth = "0"+l_strMonth;
		}

        var	l_strDay = l_dateSysDate.getDate();

		if(l_strDay.toString().length == 1){
			l_strDay = "0"+l_strDay;
		}
        //var fullDate = l_strMonth+"/"+l_strDay+"/"+l_strYear;
		var fullDate = l_strDay+"/"+l_strMonth+"/"+l_strYear;
		
		return fullDate;
}

function setFromDate(){
	var date = new Date();
	// return getDate(date,"D","8");
	return getDate(date,"D","180");
}

function setToDate(){
	var date = new Date();
	return  getDate(date,"D","0");
}