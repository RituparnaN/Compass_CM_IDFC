var rfiCaseWorkFlowActions = rfiCaseWorkFlowActions || (function () {
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	return {

		handleViewComments: function (elm) {
			
			var qId = elm.name.split("||")[0]
			var crn = elm.name.split("||")[2]
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Comment Logs for Question : " + qId);
			var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
			$("#compassGenericModal-body").html("<br/><center><img src='" + loaderUrl + "'/></center><br/>");

			$.ajax({
				url: ctx+"/common/riskAssessmentPendingCases/getCaseWorkflowModuleDetails",
				cache: false,
				type: "GET",
				data: "moduleValue=" + qId +"&compassRefNo="+crn+ "&moduleCode=" + "riskAssessmentViewComments" + "&detailPage=" + escape("RiskAssessmentPendingCases/AddViewCommentsWithHistory")+"&actionType="+"viewComments",
				success: function (res) {
					$("#compassMediumGenericModal-body").html(res);
				},
				error: function (a, b, c) {
					alert(a + b + c);
				}
			});
		},
		handleCheckBoxChange: function (elm) {
			var selectedQIds = JSON.parse(document.getElementById("selectedQIds").value)
			if (selectedQIds.includes(elm.name)) {
				var tempSelectedQIds = []
				selectedQIds.forEach(qId => {
					console.log(qId, ":", elm.name, ":", qId === elm.name)
					if (qId !== elm.name) {
						tempSelectedQIds.push(qId)
						console.log("tempSelectedQIds:", tempSelectedQIds)
					}
				})
				document.getElementById("selectedQIds").value = JSON.stringify(tempSelectedQIds)
			}
			else {
				selectedQIds.push(elm.name)
				document.getElementById("selectedQIds").value = JSON.stringify(selectedQIds)
			}
		},
		addRows: function () {
			var rowsData = JSON.parse(document.getElementById("rowsData").value)
			
			var newRowId;
			if (rowsData.length === JSON.parse(document.getElementById("makerList").value).length) {
				alert("Maximum Rows Count Reached")
			}
			else {
				if (rowsData.length === 0) {
					newRowId = 0
				}
				else {
					newRowId = rowsData[rowsData.length - 1]["id"] + 1
				}
				rowsData.push({ "id": newRowId, "makerDueDate": "", "checkerDueDate": "", "makerName": "", "checkerNames": [], "comments": "", "editable": "" })
				document.getElementById("rowsData").value = JSON.stringify(rowsData);
				/*document.getElementById("").value = */
				$("#compassGenericModal-body").html(rfiCaseWorkFlowActions.getRows());
				$('.selectpicker').selectpicker(); $('.datepicker').datepicker({minDate: 0, dateFormat: 'dd/mm/yy' });
			}
		},
		removeRows: function (id) {
			var rowsData = JSON.parse(document.getElementById("rowsData").value)
			var selectedMakers = JSON.parse(document.getElementById("selectedMakers").value)
			var id = parseInt(id)
			var tempRowsData = []
			rowsData.forEach(element => {
				if (element["id"] != id) {
					tempRowsData.push(element)
				}
				else {
					if (selectedMakers.length > 0) {
						var tempMakers = []
						selectedMakers.forEach(maker => {
							if (maker != element["makerName"]) {
								tempMakers.push(maker)
							}
						})
						document.getElementById("selectedMakers").value = JSON.stringify(tempMakers);
					}
				}
			})
			document.getElementById("rowsData").value = JSON.stringify(tempRowsData);
			$("#compassGenericModal-body").html(rfiCaseWorkFlowActions.getRows());
			$('.selectpicker').selectpicker(); $('.datepicker').datepicker({minDate: 0, dateFormat: 'dd/mm/yy' });
		},

		handleInputChange: function (elm) {
			let rowsData = JSON.parse(document.getElementById("rowsData").value)
			let selectedMakers = JSON.parse(document.getElementById("selectedMakers").value)
			var names = []
			if (elm.name.includes("checkerNames")) {
				for (var option of document.getElementById(elm.name).options) {
					if (option.selected) {
						names.push(option.value);
					}
				}
			}
			rowsData.forEach(element => {

				if (elm.name.includes("checkerNames")) {
					if (element.id == parseInt(elm.name.split("||")[1])) {
						if (element.makerName.length > 0)
							element[elm.name.split("||")[0]] = names
						else {
							alert("select a maker first")
							elm.value = ""
						}
					}
				}
				else {

					if (element.id == parseInt(elm.name.split("||")[1])) {

						if (elm.name.includes("checkerDueDate")) {

							let mdd = new Date(element.makerDueDate)
							let cdd = new Date(elm.value)
							if (cdd <= mdd || element.makerDueDate === "") {
								if (element.makerDueDate === "") {
									alert("please set maker due date first")
									elm.value = ""
								}
								else {
									alert("checker due date must be later to maker due date")
									elm.value = ""
								}
							}
							else {
								element[elm.name.split("||")[0]] = elm.value
							}

						}
						else {

							if (elm.name.includes("makerDueDate")) {
								/*if (new Date(elm.value) < new Date()) {
									alert("Maker Due Date must be later to Current date")
									elm.value = ""
								}
								else {*/
									element[elm.name.split("||")[0]] = elm.value
									
									$('.datepicker').datepicker({ 
										dateFormat:"dd/mm/yy",
									    minDate: new Date(elm.value.split("/")[1]+"/"+elm.value.split("/")[0]+"/"+elm.value.split("/")[2])
									
									});
								/*}*/
							}
							else {
								if (elm.name.includes("checkerNames")) {
									if (element.makerName.length === 0) {
										alert("Please select a maker first")
										elm.value = ""
									}
									else {
										element[elm.name.split("||")[0]] = elm.value
									}
								}
								else {
									if (!selectedMakers.includes(elm.value) && elm.name.split("||")[0].includes("makerName")) {
										var temp = []
										selectedMakers.forEach(maker => {
											if (maker != element["makerName"]) {
												temp.push(maker)
											}
										})

										temp.push(elm.value)
										document.getElementById("selectedMakers").value = JSON.stringify(temp);
										element[elm.name.split("||")[0]] = elm.value
									}
									else {
										if (elm.name.split("||")[0].includes("makerName")) {
											alert("Maker already selected")
											elm.value = ""
										}
										else {
											element[elm.name.split("||")[0]] = elm.value
										}
									}
								}
							}
						}
					}
				}
				// }

			})
			document.getElementById("rowsData").value = JSON.stringify(rowsData);

		},
		getMakerList: function (id) {
			var makerListString = ""
			var makerList = JSON.parse(document.getElementById("makerList").value)
			var rowsData = JSON.parse(document.getElementById("rowsData").value)
			var selectedMakers = JSON.parse(document.getElementById("selectedMakers").value)
			rowsData.forEach(element => {
				if (element.id == id) {
					makerList.forEach(maker => {
						if (element.makerName === maker) {

							makerListString += "<option value = '" + maker + "' selected>" + maker + "</option>"
							selectedMakers.push(maker)
						}
						else {
							if (!selectedMakers.includes(maker)) {
								makerListString += "<option value = '" + maker + "'>" + maker + "</option>"
							}
						}
					})
				}
			})
			document.getElementById("selectedMakers").value = JSON.stringify(selectedMakers);
			return makerListString
		},
		getCheckerList: function (id) {
			var checkerListString = ""
			var checkerList = JSON.parse(document.getElementById("checkerList").value)
			var rowsData = JSON.parse(document.getElementById("rowsData").value)
			rowsData.forEach(element => {
				if (element.id == id) {
					checkerList.forEach(checker => {
						if (element.checkerNames.includes(checker)) {

							checkerListString += "<option value = '" + checker + "' selected>" + checker + "</option>"
						}
						else {
							checkerListString += "<option value = '" + checker + "' >" + checker + "</option>"
						}
					})
				}
			})
			return checkerListString
		},

		checkCheck: function (msg, a, b, c,response = null,qId = null) {
			var emailAlertDetails = JSON.parse(document.getElementById("emailAlertDetails").value)
			if(response != null){
				emailAlertDetails[qId] = response
				document.getElementById("emailAlertDetails").value = JSON.stringify(emailAlertDetails) ;
			}
			if (a.length == b && c == b) {
				setTimeout(function(){
							var qIds = JSON.parse(document.getElementById("selectedQIds").value);
							qIds.forEach(qId =>{
								
								document.getElementById(qId).style.backgroundColor = "#FF7F7F";
								document.getElementById("chk"+qId).setAttribute("disabled", "disabled");
								
							})
							alert(msg);
							var makerAssignedCases = {};
							var makersList = JSON.parse(document.getElementById("selectedMakers").value);
							var selectedQsList = JSON.parse(document.getElementById("selectedQIds").value);
							makersList.forEach(maker=>{
								var makerAssignedData = []
								var makerAssignedCaseNos = []
								var makerAssignedQsIds = []
								selectedQsList.forEach(qId=>{
									if(Object.keys(emailAlertDetails[qId]).includes(maker)){
										makerAssignedData.push({"caseNo":emailAlertDetails[qId][maker]["caseNo"],"qestionId":emailAlertDetails[qId][maker]["qId"]})
										makerAssignedCaseNos.push(emailAlertDetails[qId][maker]["caseNo"])
										makerAssignedQsIds.push(emailAlertDetails[qId][maker]["qId"])
									}
								})
								makerAssignedCases[maker] = {"makerAssignedData":makerAssignedData,
															 "makerAssignedCaseNos":makerAssignedCaseNos,
															 "makerAssignedQsIds":makerAssignedQsIds};
							})
							
							document.getElementById("selectedQIds").value = JSON.stringify([]);
							document.getElementById("emailAlertDetails").value = JSON.stringify(emailAlertDetails);
							document.getElementById("makerAssignedCases").value = JSON.stringify(makerAssignedCases);
							$("#compassGenericModal").modal("hide");
							$(":checkbox").attr("checked", false); }, 1000);
				
				

			}
			else if (a.length != b && c == b) {
				alert(msg);

			}
		},

		handleRowsSave: function () {
			var rowsData = JSON.parse(document.getElementById("rowsData").value)

			var isFieldEmpty = false
			rowsData.forEach(element => {
				element['checkerJoinNames'] = element['checkerNames'].join(",")
				if (Object.values(element).filter(x => x === "").length > 1) { isFieldEmpty = true }
			})
			document.getElementById("emailAlertDetails").value = JSON.stringify({});
			var emailAlertDetails = JSON.parse(document.getElementById("emailAlertDetails").value)
			
			if (!isFieldEmpty) {
				if (document.getElementById("bulk").value === "bulk") {
					var selectedQIds = JSON.parse(document.getElementById("selectedQIds").value)
					var crn = document.getElementById("crn").value

					var testArr = [];
					var testCounter = 0;

					selectedQIds.forEach(qId => {
						var data = { "makerCheckerData": rowsData, "qId": qId,"compassRefNo":crn }
						var ctx = window.location.href;
						ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
						var url = ctx + '/common/saveRaiseToRFI'
						var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
						$("#compassGenericModal-body").html("<br/><center><img src='" + loaderUrl + "'/></center><br/>");


						$.ajax({
							url: url,
							cache: false,
							type: 'POST',
							data: JSON.stringify(data),
							contentType: "application/json",
							success: function (response) {
								//$("#compassGenericModal").html(resonse);
								testArr.push(0);
								testCounter += 1;
								
								rfiCaseWorkFlowActions.checkCheck('Successfully Raised for RFI.', testArr, selectedQIds.length, testCounter,response,qId);
								
							},
							error: function (a, b, c) {
								testCounter += 1;
								rfiCaseWorkFlowActions.checkCheck("Something went wrong" + a + b + c, testArr, selectedQIds.length, testCounter);
							}
						})
					})
				}
				else {
					var qId = document.getElementById("qId").value;
					var crn = document.getElementById("crn").value;
					var data = { "makerCheckerData": rowsData, "qId": qId,"compassRefNo":crn };
					var ctx = window.location.href;
					ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
					var url = ctx + '/common/saveRaiseToRFI'
					var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
					$("#compassGenericModal-body").html("<br/><center><img src='" + loaderUrl + "'/></center><br/>");


					$.ajax({
						url: url,
						cache: false,
						type: 'POST',
						data: JSON.stringify(data),
						contentType: "application/json",
						success: function (response) {
							
							//$("#compassGenericModal").html(response);
							console.log("raise response",response)
							if($("#compassGenericModal").modal("hide")){
								
								setTimeout(function(){
									document.getElementById(qId).style.backgroundColor = "#FF7F7F";
									document.getElementById("chk"+qId).setAttribute("disabled", "disabled");
									alert("Successfully Raised for RFI.") }, 1000);
							}
							
							emailAlertDetails[qId] = response
							
							var makerAssignedCases = {};
							var makersList = JSON.parse(document.getElementById("selectedMakers").value);
							qId = document.getElementById("qId").value;
							makersList.forEach(maker=>{
								var makerAssignedData = []
								var makerAssignedCaseNos = []
								var makerAssignedQsIds = []
								if(Object.keys(response).includes(maker)){
									makerAssignedData.push({"caseNo":emailAlertDetails[qId][maker]["caseNo"],"qestionId":emailAlertDetails[qId][maker]["qId"]})
									makerAssignedCaseNos.push(emailAlertDetails[qId][maker]["caseNo"])
									makerAssignedQsIds.push(emailAlertDetails[qId][maker]["qId"])
								}
								
								makerAssignedCases[maker] = {"makerAssignedData":makerAssignedData,
															 "makerAssignedCaseNos":makerAssignedCaseNos,
															 "makerAssignedQsIds":makerAssignedQsIds};
							})
							
							document.getElementById("selectedQIds").value = JSON.stringify([]);
							document.getElementById("emailAlertDetails").value = JSON.stringify(emailAlertDetails);
							document.getElementById("makerAssignedCases").value = JSON.stringify(makerAssignedCases);
							
							$(":checkbox").attr("checked", false);
						},
						error: function (a, b, c) {

							alert("Something went wrong" + a + b + c);
						}
					});
				}
			}
			else {
				alert("All fields are mandatory")
			}
			// }
		},
		handleRaiseForRFIPage: function (elm) {
			$("#compassGenericModal").modal("show");
			$("#compassGenericModal-title").html("Raise To RFI");

			var ctx = window.location.href;
			ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
			var url = ctx + '/common/getMakerCheckerList'
			var data = { "qId": elm.name.split("||")[0],"compassRefNo": elm.name.split("||")[2]}
			$.ajax({
				url: url,
				cache: false,
				type: 'POST',
				data: JSON.stringify(data),
				contentType: "application/json",
				success: function (response) {
					// console.log("response:", response)
					let makerCheckerData = JSON.parse(response)
					document.getElementById("selectedMakers").value = JSON.stringify([]);
					document.getElementById("qId").value = elm.name.split("||")[0];
					document.getElementById("crn").value = elm.name.split("||")[2];
					document.getElementById("makerList").value = JSON.stringify(makerCheckerData["makerList"]);
					document.getElementById("checkerList").value = JSON.stringify(makerCheckerData["checkerList"]);
					if (makerCheckerData["rowDetails"].length > 0)
						document.getElementById("rowsData").value = JSON.stringify(makerCheckerData["rowDetails"]);
					else {
						document.getElementById("rowsData").value = JSON.stringify([{ "id": 0, "makerDueDate": "", "checkerDueDate": "", "makerName": "", "checkerNames": [], "comments": "", "editable": "" }]);
						
					}

					$("#compassGenericModal-body").html(rfiCaseWorkFlowActions.getRows());
					$(".selectpicker").selectpicker();
					$(".datepicker").datepicker({minDate: 0, dateFormat: 'dd/mm/yy' });
				},
				error: function (a, b, c) {

					alert("Something went wrong" + a + b + c);
				}
			});

		},
		getRows: function () {
			var rowsData = JSON.parse(document.getElementById("rowsData").value)
			var comments = ""
			if (rowsData.length > 0) {
				comments = rowsData[0]['comments']
			}

			var startHtmlString = '<div class="row">' +
				"	<div class='col-sm-12'>" +
				"		<div class='card card-primary'>" +
				"			<div class='panelSearchForm'>" +
				"			<form action='javascript:void(0)' >" +
				"			<div class='card-search-card' >" +
				"				<table class='table table-striped  ' style='margin-bottom: 0px;'>" +
				"<tbody>";

			var endHtmlString = "</tbody>" +
				"				</table>" +
				"			</div>" +
				"			<div class='card-footer clearfix'>" +
				"				<div class='pull'>" +
				"					<input type='button' id='save' class='btn btn-success btn-sm'style='float:right' name='save' value='Save' onClick = 'rfiCaseWorkFlowActions.handleRowsSave()'/>" +
				"					<input type='button' id='addRowButton' class='btn btn-primary btn-sm'style='float:right;margin-right:10px' name='addRow' value='Add Row' onClick='rfiCaseWorkFlowActions.addRows()'/>" +
				"				</div>" +
				"			</div>" +
				"			</form>" +
				"			</div>" +
				"		</div>" +
				"		" +
				"	</div>" +
				"</div>";

			var rowsString = "";
			rowsData.forEach((element, i) => {
				var makerListString = rfiCaseWorkFlowActions.getMakerList(element.id)
				var checkerListString = rfiCaseWorkFlowActions.getCheckerList(element.id)
				rowsString = rowsString + "									<tr>" +
					"                                       <td><table class='table' style='width:100%;border: 1px solid #ddd;'><tbody><tr>" +
					"                                        <td width='15%'>" +
					"                                            Maker Due Date" +
					"                                        </td>" +
					"										<td width='30%'>" +
					"										    <input type='text'  " + element.editable + "  class='form-control input-sm datepicker' value = '" + element.makerDueDate + "' name='makerDueDate||" + element.id + "' onChange='rfiCaseWorkFlowActions.handleInputChange(this)'/>" +
					"											" +
					"                                        </td>" +
					"                                        <td width='10%'></td>" +
					"                                        <td width='15%'>" +
					"                                            Checker Due Date" +
					"                                        </td>" +
					"										<td width='30%'>" +
					"										    <input type='text' " + element.editable + "  class='form-control input-sm datepicker'  value = '" + element.checkerDueDate + "' type='date' name='checkerDueDate||" + element.id + "' onChange='rfiCaseWorkFlowActions.handleInputChange(this)'/>" +
					"											" +
					"                                        </td></tr>" +
					"                                        <tr><td width='15%'>" +
					"                                            Maker code" +
					"                                        </td>" +
					"										<td width='30%'>" +
					"                                            <select  " + element.editable + " class='form-control selectpicker' name='makerName||" + element.id + "' value = '" + element.makerName + "' onChange='rfiCaseWorkFlowActions.handleInputChange(this)'>" +
					"                                            <option >Select Maker</option>" + makerListString +

					"                                            </select>" +
					"                                        </td>" +
					"                                        <td width='10%'></td>" +
					"                                        <td width='15%'>" +
					"                                            Checker code" +
					"                                        </td>" +
					"										<td width='30%'>" +
					"                                            <select  " + element.editable + " id = 'checkerNames||" + element.id + "' class='form-control selectpicker' multiple='multiple' data-live-search='true' name='checkerNames||" + element.id + "'  onChange='rfiCaseWorkFlowActions.handleInputChange(this)'>" +
					"                                            " + checkerListString +
					"                                            </select><br>" +
					"                                        </td></tr>" +
					"										<tr>" +
					"											<td width='15%'>" +
					"												Comments" +
					"											</td>" +
					"											<td colspan = '4'>" +
					"												<textarea  style='margin-bottom:10px'" + element.editable + "  class='form-control' placeholder = '" + element.comments + "' onKeyUp = 'rfiCaseWorkFlowActions.handleInputChange(this)' name = 'comments||" + element.id + "'></textarea>" +
					"                                            	<input type='button' " + element.editable + " id='removeRowButton"+i+"' class='btn btn-danger btn-sm' style='float:right' name='removeRow' value='Remove Row' onClick='rfiCaseWorkFlowActions.removeRows(" + element.id + ")' />" +
					"											</td>" +
					"										</tr>" +
					"											</tbody>" +
					"                                          </table></td>" +
					"									</tr>"
			});
			return startHtmlString + rowsString + endHtmlString

		}



	};
}());