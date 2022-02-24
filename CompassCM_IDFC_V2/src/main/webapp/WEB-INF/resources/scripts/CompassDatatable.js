var compassDatatable = compassDatatable || (function(){
		return {
			construct : function(tableClass, fileName, isExportable,moduleCode,columnDetails,resetColumnFlag,numberOfFreezedColumn,tblData){
				//console.log(tableClass+", "+fileName+", "+isExportable+", "+moduleCode+", "+columnDetails+", "+resetColumnFlag+", "+numberOfFreezedColumn+", "+tblData);
				if(numberOfFreezedColumn == undefined || numberOfFreezedColumn == null  ){
					numberOfFreezedColumn = 0;
				}
				if(isExportable){
					fileName = fileName+"_"+moment().format('YYYYMMDD');
					if($("."+tableClass).find("tr:first").find("th:first").find('input').length){
						$("."+tableClass).find("tr:first").find("th:first").addClass("no-export");
					}
					var searchResultGenericTable = $("."+tableClass)
					.on( 'draw.dt',  function () { eventFired(tableClass); } )
					.DataTable({
						data:tblData,
						"bRetrieve":true,
						deferRender: true,
						dom : '<"tableTools"<"row"<"col-xs-4"l><"col-xs-4"f><"col-xs-4 '+tableClass+'Cols">><"row"<"col-xs-4"B><"col-xs-4 compassDataTableInfo"i><"col-xs-4"p>>><"compassDataTable"t><"clear">',
						responsive : true,
						order: [],
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
						                    columns: [':visible:not(.no-export)'],
						                    format: formatExportDataOfDataTable()
						                }
						            }, 
						            {
						                extend: 'print',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)'],
						                    format: formatExportDataOfDataTable()
						                }
						            },
						            {
						            	extend: 'excelHtml5',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)'],
						                    format: formatExportDataOfDataTable()
						                     
						                }
						            }/*,
						            {
						            	extend: 'pdfHtml5',
						                title: fileName,
						                exportOptions: {
						                    columns: [':visible:not(.no-export)'],
						                    format: formatExportDataOfDataTable()
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
				
				tableColNames += "<div class='dropdown-menu resetAndIndexingColumnDiv' style='z-index: 50; margin-left: -165px; font-size: 14px !important;'><table width='100%' style='margin-right: 15px;'><tr width='100%'><td class='resetColsDiv' width='50%'><ul class='compassResetCols' >";
				
				if (resetColumnFlag && columnDetails !== undefined){
					var index = 0;
					let totlalColumn = columnDetails.length;
					var colIndexSelectBox = "</td><td width='50%' style='margin-right: 15px;'><ul style='list-style-type: none;' class='colIndexSelectBox'>";
					for(var i=0;i<columnDetails.length;i++){
						let disabled = i < numberOfFreezedColumn?"disabled":"";
						let disabledColumnLiElement = i <  numberOfFreezedColumn?"disabledColumnLiElement":"";
						let resetColumnFUnction  =  i >= numberOfFreezedColumn?"onclick='resetColumns(this)'":"";
						
						//console.log(columnDetails[i]);
						var columnSelectIndex = 0;
						if(columnDetails[i].isEnable == 'Y'){
							tableColNames = tableColNames+"<li class='enabledCol  "+disabledColumnLiElement+"' id='"+columnDetails[i].columnName+
							"' tableClass='"+tableClass+"' "+resetColumnFUnction+" index = '"+ index++ +
							"'><a href='javascript:void(0)'>"+columnDetails[i].columnName+"</a></li>" ;
							colIndexSelectBox += "<li><select "+disabled+">"
							for(var j = 0; j<totlalColumn;j++){
								columnSelectIndex++;
								let selected = i == j?"selected":"";
								colIndexSelectBox += "<option value = '"+columnSelectIndex+"'"+selected+">"+columnSelectIndex+"</option>";
							}
							colIndexSelectBox += "</select></li>";
						}else if(columnDetails[i].isEnable == 'N'){
							tableColNames = tableColNames+"<li class='disabledCol' id='"+columnDetails[i].columnName+
							"' tableClass='"+tableClass+"' "+resetColumnFUnction+" noindex = 'noindex'><a href='javascript:void(0)'>"+
							columnDetails[i].columnName+"</a></li>";
							colIndexSelectBox += "<li><select"+disabled+">"
							for(var j = 0; j<totlalColumn;j++){
								columnSelectIndex++;
								let selected = i == j?"selected":"";
								colIndexSelectBox += "<option value = '"+columnSelectIndex+"'"+selected+">"+columnSelectIndex+"</option>";
							}
							colIndexSelectBox += "</select></li>";
						}
					}
				}else{
					$("."+tableClass).children("thead").children("tr").children("th").each(function(){
						if(!$(this).hasClass('no-sort'))
							tableColNames = tableColNames+"<li class='enabledCol' id='"+$(this).text().replace(/ /g,'')+"' tableClass='"+tableClass+"' onclick='resetColumns(this)'><a href='javascript:void(0)'>"+$(this).html()+"</a></li>";
					});
				}
				
				if (resetColumnFlag && columnDetails !== undefined){
					tableColNames = tableColNames +"</ul>"+colIndexSelectBox+"</td></tr></table></div></div>";
				}else{
					tableColNames = tableColNames +"</ul></td></tr></table></div></div>";
				}

				$("."+tableClass+"Cols").html(tableColNames);
				
				$(".compassResetCols, .colIndexSelectBox").click(function(event){
			    	event.stopPropagation();
			    });
				
			/*	
				$("."+tableClass).children("tbody").children("tr").children("td").each(function(){
					$(this).tooltip("disable");
				});
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
		alert("Please add module code as 4th parameter while constructing datatable.");
	}else{
		var columnDetails ="";
		let tableColArrangeDataArr = [];
		$(elm).next("div").find('ul.compassResetCols').find('li').each(function(){
			let tableColArrangeDataObj = {};
			if($(this).hasClass('disabledCol')){
				columnDetails += $(this).text()+"=N,";
				tableColArrangeDataObj["name"] = $(this).text();
				tableColArrangeDataObj["isEnable"] = "N";
			}else if($(this).hasClass('enabledCol')){
				columnDetails += $(this).text()+"=Y,";
				tableColArrangeDataObj["name"] = $(this).text();
				tableColArrangeDataObj["isEnable"] = "Y";
			}
			tableColArrangeDataArr.push(tableColArrangeDataObj);
		});
		console.log(tableColArrangeDataArr);
		let columnIndexArr = [];
		$(elm).next("div").find('ul.colIndexSelectBox').find('li').each(function(i){
			let tableColArrangeDataObj = {};
			let currentColumnIndex = $(this).find('select').children("option:selected").val();
			tableColArrangeDataArr[i]["index"] = currentColumnIndex;
			columnIndexArr.push(currentColumnIndex);
		});
		
		var duplicateColumnIndex = columnIndexArr.some((val, i) => columnIndexArr.indexOf(val) !== i);
		if(duplicateColumnIndex){
			alert("Please select distinct column index to reset and rearrange the columns.");
			return false;
		}
		var mainArr = [];
		columnDetails = "";
		for(var i=0;i<tableColArrangeDataArr.length;i++){
			for(var key in tableColArrangeDataArr[i] ){
				columnDetails += tableColArrangeDataArr[i][key]+":";	
			}
			if(tableColArrangeDataArr.length-1 != i){
				columnDetails += "," 
			}
		}
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

//for getting only text of selected option from select box.
function formatExportDataOfDataTable(){
	let formatBody = {};
	formatBody['body'] = function( data, row, col, node ) {
    						if(node.children.length && node.children[0].nodeName == 'SELECT' ){
    							return node.children[0].options[node.children[0].selectedIndex].text;
    						}else if(node.children.length && node.children[0].nodeName == 'INPUT'){
    							return "";
    						}else{
    							return data;
    						}
						};
	return formatBody;
}
//showing custommised tooltip in model .....
$(document).on("contextmenu",".tdCellCustomTooltipClass ", function(e) {
	e.preventDefault();	
	let colName = $(this).closest('table').find('th').eq($(this).index()).text();
    $("#tdCellCustomTooltipModel-title").text(colName); 
    $("#tdCellCustomTooltipModel-body").html("<b>"+$(this).text()+"</b>");
    $("#tdCellCustomTooltipModel").modal('show');
});