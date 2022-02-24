$(function () {	
	$(".subType").change(function(){
		var elm = $(this);
		var ckd = $(elm).is(":checked");
		var compassID1 = $(elm).attr("compassId1");
		var compassID2 = $(elm).attr("compassId2");
		var compassID3 = $(elm).attr("compassId3");
		var mainType = $(".mainWith"+compassID1+compassID2);
		var roleType = $(".roleWith"+compassID1);
		var selectedCount = 0;
		var totalCount = 0;
		$(".subOf"+compassID1+compassID2).each(function(i, obj){
			totalCount++;
			if($(obj).is(":checked"))
				selectedCount++;
		});
		
		if(selectedCount == totalCount && selectedCount > 0){
			$(mainType).prop("indeterminate",false);
			$(mainType).prop("checked",true);
			$(mainType).change();
		}
		if(totalCount > selectedCount && selectedCount > 0){
			$(mainType).prop("checked",false);
			$(mainType).prop("indeterminate", true);
			$(mainType).change();
		}
		if(selectedCount == 0){
			$(mainType).prop("checked",false);
			$(mainType).prop("indeterminate", false);
			$(mainType).change();
		}
		
		
	});
	
	
	$(".mainType").click(function(){
		e.preventDefault();
		$(this).change();
	});
	
	$(".roleType").click(function(){
		e.preventDefault();
		$(".roleType").change();
	});
	
	$(".mainType").change(function(e){			
		var elm = $(this);
		var ckd = $(elm).is(":checked");
		var idm = $(elm).is(":indeterminate");
		var compassID1 = $(elm).attr("compassId1");
		var compassID2 = $(elm).attr("compassId2");
		var roleType = $(".roleWith"+compassID1);
		var selectedCount = 0;
		var semiSelectedCount = 0;
		var totalCount = 0;
		$(".mainOf"+compassID1).each(function(i, obj){
			totalCount++;
			if($(obj).is(":checked"))
				selectedCount++;
			if($(obj).is(":indeterminate"))
				semiSelectedCount++;
		});
		
		if(ckd){
			$(".subOf"+compassID1+compassID2).each(function(i, obj){
				$(obj).prop("indeterminate",false);
				$(obj).prop("checked",true);
				
			});
		}else if(!idm){
			$(".subOf"+compassID1+compassID2).each(function(i, obj){
				$(obj).prop("indeterminate",false);
				$(obj).prop("checked",false);					
			});
		}
		
		if(selectedCount == totalCount && selectedCount > 0){
			$(roleType).prop("indeterminate",false);
			$(roleType).prop("checked",true);
			$(roleType).change();
		}
		if(totalCount != selectedCount && (semiSelectedCount > 0 || selectedCount > 0)){
			$(roleType).prop("checked",false);
			$(roleType).prop("indeterminate", true);
			$(roleType).change();
		}
		if(selectedCount == 0 && semiSelectedCount == 0){				
			$(roleType).prop("checked",false);
			$(roleType).prop("indeterminate", false);
			$(roleType).change();
		}
		
	});
	
	$(".roleType").change(function(e){
		var elm = $(this);
		var ckd = $(elm).is(":checked");
		var idm = $(elm).is(":indeterminate");
		var compassID1 = $(elm).attr("compassId1");
		
		if(ckd){
			$(".mainOf"+compassID1).each(function(i, obj){
				$(obj).prop("indeterminate",false);
				$(obj).prop("checked",true);
				$(obj).change();
			});
		}else if(!idm){
			$(".mainOf"+compassID1).each(function(i, obj){
				$(obj).prop("indeterminate",false);
				$(obj).prop("checked",false);
				$(obj).change();
			});
		}
	});
	
});