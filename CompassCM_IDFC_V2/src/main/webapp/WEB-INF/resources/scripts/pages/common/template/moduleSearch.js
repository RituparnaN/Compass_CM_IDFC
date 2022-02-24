$("#topBarSearchIcon").click(function(){
		$('#topBarSearchBox').fadeToggle(1000,function(){
			$("#topHeaderSearchBoxItem").focus();
		});
	});
	
	
	
	//for searching
	$("#topHeaderSearchBoxItem").on('input', function(e){
	    let inputItem = $(this).val().trim();
	    $('#compassUserModuleList').empty()
	    performModuleSearchOperations(inputItem);
	   
	});
	
	
	function performModuleSearchOperations(inputItem ){
		
		 var matchedModuleName = moduleNameArr.filter(function(moduleName) {
	    	  return  moduleName.toUpperCase().includes(inputItem.toUpperCase());
	    });
	    if(inputItem !== ""){
		    for (var moduleName in matchedModuleName) {
			    let optionElement = document.createElement("option");
			    optionElement.value = matchedModuleName[moduleName];
			    $("#compassUserModuleList").append(optionElement);
			  }
	    }
	    if($('#compassUserModuleList option').filter(function(){
	        listItem = this.value;
	    	return this.value.toUpperCase() === inputItem.toUpperCase();        
	    }).length) {
	    	let searchedModuleName = moduleNameObj[listItem]['MODULENAME'];
	   		let searchedModuleCode = moduleNameObj[listItem]['MODULECODE'];
	   		let searchedModuleURL = moduleNameObj[listItem]['MODULEURL'];
	    	let searchedModuleIsMultiple = moduleNameObj[listItem]['ISMULTIPLE'];
	    	navigate(searchedModuleName,searchedModuleCode,searchedModuleURL,searchedModuleIsMultiple);
	    	$('#compassUserModuleList').empty()
	    }
	}
	