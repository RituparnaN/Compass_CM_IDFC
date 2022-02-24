var compassDatatable = compassDatatable || (function(){
		return {
			construct : function(tableClass, fileName, isExportable,moduleCode,columnDetails,resetColumnFlag){
				if(isExportable){
					var searchResultGenericTable = $("."+tableClass)
					.on( 'draw.dt',  function () { eventFired(tableClass); } )
					.DataTable({
						"bRetrieve":true,
						dom : '<"tableTools"<"row"<"col-xs-4"l><"col-xs-4"f><"col-xs-4 '+tableClass+'Cols">><"row"<"col-xs-4"B><"col-xs-4 compassDataTableInfo"i><"col-xs-4"p>>><"compassDataTable"t><"clear">',
						responsive : true,
						order: [],
						
						/*Fixed Column Changes started*/
						scrollX: true,
						drawCallback: function(settings, json) {
							$('.dataTables_scrollBody thead tr').css({visibility:'collapse'});
							/*$('.dataTables_scrollHead').css({'margin-bottom':'-20px'});*/
			                //$('.DTFC_LeftHeadWrapper').css({'margin-bottom':'-20px'});
			            },
			            /*Fixed Column Changes ended*/
			            
						columnDefs: [ { targets: "no-sort", orderable: false }],
						buttons: [
						            {
						            	extend: 'copy',
						            	text: 'TSV'
						            },
						            {
						            	extend: 'csvHtml5',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)']
						                }
						            }, 
						            {
						                extend: 'print',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)']
						                }
						            },
						            {
						            	extend: 'excelHtml5',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)']
						                }
						            }/*,
						            {
						            	extend: 'pdfHtml5',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)']
						                }
						            }*/
						         ]
					});
				}else{
					var searchResultGenericTable = $("."+tableClass)
					.on( 'draw.dt',  function () { eventFired(tableClass); } )
					.DataTable({
						"bRetrieve":true,
						dom : '<"tableTools"<"row"<"col-xs-2 compassDataTableL"l><"col-xs-3 compassDataTableF"f><"col-xs-3 compassDataTableInfo"i><"col-xs-4"p>>><"compassDataTable"t><"clear">',
						responsive : true,
						order: [],
						columnDefs: [ { targets: "no-sort", orderable: false }]
					});
				}
				
				$("."+tableClass).children("thead").children("tr").children("th").each(function(){
					var w = $(this).css("width");
					var updatedW = parseInt(w) + 25;
					$(this).css("min-width", updatedW+"px");
				});
				
				var tableColNames = "<div class='btn-group "+tableClass+"ResetCols'><button type='button' class='btn btn-default btn-xs'>Reset Columns</button>"+
				"<button type='button' class='btn btn-default btn-xs dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>"+
				"<span class='caret'></span><span class='sr-only'>Toggle Dropdown</span></button>";
				
				if(resetColumnFlag){
					tableColNames +=  "<a href= '#' class='btn' id='saveDisabled"+tableClass+"'  onClick = resetDataTableColumns(this,'"+moduleCode+"')  style='margin-left: 10px;'" +
							           "title = 'Save Reset Column State'> <span class='glyphicon glyphicon-floppy-saved'></a>";
				}
				
				tableColNames += "<ul class='dropdown-menu compassResetCols'>";
				
				if (columnDetails !== undefined){
					var index = 0;
					for(var i=0;i<columnDetails.length;i++){
						//console.log(columnDetails[i]);
						if(columnDetails[i].isEnable == 'Y'){
							tableColNames = tableColNames+"<li class='enabledCol' id='"+columnDetails[i].columnName+"' tableClass='"+tableClass+"' onclick='resetColumns(this)'  index = '"+ index++ +"'><a href='javascript:void(0)'>"+columnDetails[i].columnName+"</a></li>";
						}else if(columnDetails[i].isEnable == 'N'){
							tableColNames = tableColNames+"<li class='disabledCol' id='"+columnDetails[i].columnName+"' tableClass='"+tableClass+"' onclick='resetColumns(this)' noindex = 'noindex'><a href='javascript:void(0)'>"+columnDetails[i].columnName+"</a></li>";
						}
					}
				}else{
					$("."+tableClass).children("thead").children("tr").children("th").each(function(){
						if(!$(this).hasClass('no-sort'))
							tableColNames = tableColNames+"<li class='enabledCol' id='"+$(this).text().replace(/ /g,'')+"' tableClass='"+tableClass+"' onclick='resetColumns(this)'><a href='javascript:void(0)'>"+$(this).html()+"</a></li>";
					});
				}
				tableColNames = tableColNames +"</ul></div>";

				$("."+tableClass+"Cols").html(tableColNames);
				
				$(".compassResetCols").click(function(event){
			    	event.stopPropagation();
			    });
				
				/*
				 * 
				 * Fixed Column Changes started
				 * 
				 * 
				 */
				
				//  very important code for modal part
				if ($('#compassGenericModal').is(':visible')){
					if ($('#compassGenericModal:visible').find('div.compassDataTable').length>0){
						
						$('#compassGenericModal:visible').find("div.dataTables_scrollHead:visible").css({'margin-bottom':'-20px'});
						
					}else{
						//console.log("no datatable");
					}
				}else{
					//console.log("no modal");
					if($(".searchResultGenericTable:visible > thead > tr:first > th").length < 6){
						//console.log("no fixed column");
						$("."+tableClass).closest(".DTFC_LeftWrapper").css({'display':'none'});
						/*$("."+tableClass).closest(".dataTables_scrollHeadInner:visible").children().css({'width':'100% !important'});*/
						//$("."+tableClass).closest(".dataTables_scrollBody").children().eq(0).css({'width':'inherit'});
						$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
						
					}
					else if($(".searchResultGenericTable:visible > thead > tr:first > th").length > 6){
						//console.log("fixed column");
						fixedColumnsStart();
					}
					if ($(".searchResultGenericTable:visible > tbody > tr:first > td").length == 1){
						//console.log("no data");
						$("."+tableClass).closest(".DTFC_LeftWrapper").css({'display':'none'});
						$('.dataTables_scrollHead:visible').css({'margin-bottom':'0px'});
					}
					
				}
				
				if($(".dataTable:visible").find("th#LISTEDID").length > 0 ){
					////console.log("list");
					$(".dataTables_scrollHead:visible").css({'margin-bottom':'0px'});
					$('.DTFC_LeftHeadWrapper:visible').css({'margin-bottom':'0px'});
				}
				
				//  function for fixed columns assignment
				function fixedColumnsStart(){
					if ($(".searchResultGenericTable:visible > thead > tr:first > th").length >= 6 ){
						var fixedColumns = new $.fn.dataTable.FixedColumns( searchResultGenericTable, {
							leftColumns:3
						} );
						
						$('.dataTables_scrollHead:visible').css({'margin-bottom':'-20px'});
						$('.DTFC_LeftHeadWrapper:visible').css({'margin-bottom':'-20px'});
						
						
					}else {
						//console.log("reports");
						$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
						$(".dataTable:visible>thead:first-child>tr:first-child>td:first-child").trigger("click");
						//$("."+tableClass).closest(".dataTables_scrollBody").children().eq(0).width("100%");
						$('.dataTables_scrollHead:visible').css({'margin-bottom':'0px'});
					}
				}
				
				
				function tableResize(){
					if ($("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(0).hasClass("sorting_disabled")){
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(1).trigger("click");
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(1).trigger("click");
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(1).trigger("click");
					}
					else{
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(0).trigger("click");
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(0).trigger("click");
						$("."+tableClass).closest(".DTFC_Cloned").children("thead").children("tr").children("th").eq(0).trigger("click");
					}
					
					if ($("."+tableClass).closest(".dataTable").children("thead").children("tr").children("th").eq(0).hasClass("sorting_disabled")){
						//console.log("no sorting");
						$(".dataTable:visible>thead:first-child>tr:first-child>th").eq(1).trigger("click");
						$(".dataTable:visible>thead:first-child>tr:first-child>th").eq(1).trigger("click");
					}
					else{
						//console.log("sorting");
						$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
						$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
					}
				}
				
				// Calling tableResize function
				tableResize();
				
				
				$(window).resize(function() {
					tableResize();
					$('.dataTables_scrollBody:visible').children(".dataTable").children("thead").children("tr").css({visibility:'collapse'});
				});
				
				$(document).on("click", ".subTab", function(){
					//console.log("subtab clicked");
					/*$('#compassGenericModal:visible').find(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
					$('#compassGenericModal:visible').find(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");*/
					/*OR*/
					/*$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
					$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");*/
					
					$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
					$(".dataTable:visible>thead:first-child>tr:first-child>th:first-child").trigger("click");
					
					$('#compassGenericModal:visible').find("div.dataTables_scrollHead:visible").css({'margin-bottom':'-20px'});
				});
				
				
				/* This part for removing duplicate columns*/
				$('.compassResetCols').find('[id]').each(function () {
				    $('.compassResetCols').find('[id="' + this.id + '"]:gt(0)').remove();
				    //console.log($('.compassResetCols').children().length);
				});
				
				

				/*
				 * 
				 * Fixed Column Changes ended
				 * 
				 * 
				 */
				
			},
			enableCheckBoxSelection : function(){
				$("input[type='checkbox']").click(function(){
			    	if($(this).is(":checked") && $(this).hasClass("checkbox-check-one")){
			    		$(this).parents("tr").siblings().each(function(){
			    			$(this).children("td:first-child").children("input[type='checkbox']").prop("checked", false);
			    		})
			    	}
			    	if($(this).hasClass("checkbox-check-all")){
			    		if($(this).is(":checked")){
			    			$(this).parents("table").children("tbody").children("tr").each(function(){
				    			$(this).children("td:first-child").children("input[type='checkbox']").prop("checked", true);
				    		});
			    		}else{
			    			$(this).parents("table").children("tbody").children("tr").each(function(){
				    			$(this).children("td:first-child").children("input[type='checkbox']").prop("checked", false);
				    		})
			    		}
			    	}
			    	
			    });
			}
		};
}());

function resetDataTableColumns(elm,moduleCode){
	if(moduleCode == 'undefined'){
		alert("Please add module code as 4 th param while constructing datatable");
	}else{
		var columnDetails ="";
		$(elm).next('ul').find('li').each(function(){
			if($(this).hasClass('disabledCol')){
				columnDetails += $(this).text()+"=N,";
			}else if($(this).hasClass('enabledCol')){
				columnDetails += $(this).text()+"=Y,";
			}
		});
		var ctx = window.location.href;
		ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
		var url = ctx+"/common/disabledColumnsMethod";
		$.ajax({
			url: url,
			data: {disabledColumnArray:columnDetails,moduleCode:moduleCode},
			type: "POST",
			success: function(res){
				if(res.STATUS == true){
					alert(res.STATUSMESSAGE);	
				}
			},
			error: function(err){
				alert("got error");
				console.log(err);
			}
		});
		
	}
};