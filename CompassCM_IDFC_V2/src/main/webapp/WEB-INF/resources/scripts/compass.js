$(function() {
	var timerIntervalCounter = 0;
	
	var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(header, token);
    });
    
    setInterval(function() {
    	timerIntervalCounter = timerIntervalCounter+1;
    	
    	// if(timerIntervalCounter % 2 == 0){
    	if(timerIntervalCounter % 20 == 0){
    		getNewProcessStatus();
    		// getProcessStatus();
        	// getChatStatus();
    	}
    	
    	// if(timerIntervalCounter % 5 == 0){
    	/*
    	if(timerIntervalCounter % 10 == 0){
    		keepAlive();
    	}
    	*/
    	if(timerIntervalCounter % 150 == 0){
    		keepAlive();
    	} 
    	
    }, 10000);
    
	$(window).bind("load resize", function() {
		calculate_popups();
        topOffset = 10;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
        $("#heightWidth").html("width : "+width+", height : "+height);
    });

    var url = window.location;
    var element = $('ul.nav a').filter(function() {
        return this.href == url || url.href.indexOf(this.href) == 0;
    }).addClass('active').parent().parent().addClass('in').parent();
    if (element.is('li')) {
        element.addClass('active');
    }
});
