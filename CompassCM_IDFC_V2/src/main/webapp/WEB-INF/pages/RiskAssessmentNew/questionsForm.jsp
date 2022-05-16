<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ASSESSMENTUNIT" value="${ASSESSMENTUNIT}"></c:set>
<c:if test="${empty ASSESSMENTUNIT}">
	<c:set var="ASSESSMENTUNIT" value="${GENERALTABDATA['ASSESSMENTUNIT']}"></c:set>
</c:if>
<c:set var="STATUS" value="${GENERALTABDATA['STATUS']}"/>

<%-- ${QUESTIONSFORMDETAILS} --%>
<script type="text/javascript">
	var subCategoriesWeightages = {}
	<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.categoryList}">
		<c:set var = "formattedCategory" value = "${f:replace(f:replace(f:replace(f:replace(category,')',''),'(',''),'/',''),' ','')}"/>
			count = 0
			<c:forEach var = "subCategory" items = "${QUESTIONSFORMDETAILS.categoresAndSubCategories[category]}">
			
				count++
			</c:forEach>
			subCategoriesWeightages["${formattedCategory}"] = Math.round(100/count)
	</c:forEach>
		
	$(document).ready(function() {

		var slidingPanels = document.getElementById("panelSearchFormNew").querySelectorAll(".subQuestionSlididngPanel"); 

		slidingPanels.forEach(elm =>{
			$(elm).slideUp();
			})
			
		calculateAndUpdateTotalInherentRisk()
		calculateAndUpdateTotalInternalControlRisk()
				
		var id = '${UNQID}';
		var ASSESSMENTUNIT = '${ASSESSMENTUNIT}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var ISNEWFORM = '${ISNEWFORM}';
		//alert(COMPASSREFERENCENO+" -- "+ISNEWFORM);
		var STATUS = "${GENERALTABDATA['STATUS']}";
		var CURRENTROLE = "${CURRENTROLE}";
		var userCode = "${USERCODE}"
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#riskAssessmentForm :input").prop("disabled", true);
			$("#riskAssessmentForm :button").prop("disabled", false);
		}
	
		var currentTimestamp = compassTopFrame.getDate(new Date(),"","");
		var generalAndstatusDetails = JSON.parse($("#generalAndstatusDetails").html())
														
		if(CURRENTROLE == 'ROLE_CM_OFFICER'){
			if(generalAndstatusDetails['CMOFFICERCODE'] == ""){
				generalAndstatusDetails['CMOFFICERCODE'] = userCode
				$("#STATUS_CMOFFICERCODE").val(userCode)
				}
			/* if(generalAndstatusDetails['CMOFFICERTIMESTAMP'] == ""){
				generalAndstatusDetails["CMOFFICERTIMESTAMP"] = currentTimestamp
				$("#STATUS_CMOFFICERTIMESTAMP").val(currentTimestamp)
				} */
			generalAndstatusDetails["CMOFFICERTIMESTAMP"] = currentTimestamp
			$("#STATUS_CMOFFICERTIMESTAMP").val(currentTimestamp)
			}
		if(CURRENTROLE == 'ROLE_CM_MANAGER'){
			/* if(generalAndstatusDetails['CMMANAGERCODE'] == ""){
				generalAndstatusDetails['CMMANAGERCODE'] = userCode
				$("#STATUS_CMMANAGERCODE").val(userCode)
				} */
			/* if(generalAndstatusDetails['CMMANAGERTIMESTAMP'] == ""){
				generalAndstatusDetails["CMMANAGERTIMESTAMP"] = currentTimestamp
				$("#STATUS_CMMANAGERTIMESTAMP").val(currentTimestamp)
				} */
			generalAndstatusDetails['CMMANAGERCODE'] = userCode
			$("#STATUS_CMMANAGERCODE").val(userCode)
			generalAndstatusDetails["CMMANAGERTIMESTAMP"] = currentTimestamp
			$("#STATUS_CMMANAGERTIMESTAMP").val(currentTimestamp)
			$("#STATUS_CMMANAGERCOMMENTS").attr("disabled",false)
			}
		$("#generalAndstatusDetails").html(JSON.stringify(generalAndstatusDetails))
		
	});
	
	function handleRaiseToRFIBulk(elm){
		
		if(JSON.parse(document.getElementById("selectedQIds").value).length > 0){
			document.getElementById('bulk').value = 'bulk';
			document.getElementById('crn').value = elm.name.split("||")[1]
			rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(elm)
		}
		else{
			alert("Please select atleast one question")
		}
	}

	function handleSlidingPanels(elm, id, target){
		var mainRow = $(elm).parents(".panelSearchFormNew");
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find("."+target);
		if($(slidingDiv).hasClass("card-collapsed")){
			$(panelBody).slideDown();
			$(slidingDiv).removeClass('card-collapsed');
			$(slidingDiv).find("i.collapsable"+target).removeClass("fa-chevron-down").addClass("fa-chevron-up");
			console.log($(mainRow).next().find(".compassrow"+id).find(".card-header").next())
			/* $(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideUp(); */
			$("#"+target).slideUp();
			
		}else{
			$(panelBody).slideUp();
			$(slidingDiv).addClass('card-collapsed');
			$(slidingDiv).find('i.collapsable'+target).removeClass('fa-chevron-up').addClass('fa-chevron-down');
			/* $(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown(); */
			$("#"+target).slideDown();
		}
	}
	
	function userInputChange(elm){
		
		var questionResponsesData = JSON.parse($("#questionResponses").html())
		var categSubcategInherentRiskRatings = JSON.parse($("#categSubcategInherentRiskRatings").html())
		var categoryRiskRatings = JSON.parse($("#categoryRiskRatings").html())
		
		var toEditQuestionId = ""
		try{
			toEditQuestionId = elm.id.replace("inputValue","").replace("SQ",".")
			}
		catch(e){
			toEditQuestionId = ($(elm).attr('id')).replace("inputValue","").replace("SQ",".")
			
			}
		
		
		var elmData = ""
		try{
			elmData = elm.name.split("||")
			}
		catch(e){
			elmData = ($(elm).attr('name')).split("||")
			}
		
		
		var inputType = elmData[0]
		var qId = elmData[1].split("^")[0]
		var subQuestionId = elmData[2]
		var category = elmData[3]
		var subCategory = elmData[4]
		var parentIds = []
		elmData[5].split(",").forEach(id=>{
			if(id.length > 0){
				parentIds.push(id.replace(".","SQ"))
				}
			})
		
		var value = 0
		try{
			value = parseInt(elm.value.split("||")[0])
		}catch(e){
			value = parseInt(($(elm).val()).split("||")[0])
			}
		//console.log(parentIds)
		var divisorValue = 0
		parentIds.forEach(id=>{
			divisorValue += parseInt($("#"+id+"inputValue").val())
			})
		if(divisorValue == 0){
			divisorValue = 1
			}
		var toEditId = ""
			
		if(subQuestionId != 'null') toEditId = subQuestionId
		else toEditId = qId
		
		var resultValue = 0
		if(value <= 0)
			resultValue = 0
		else
			resultValue = Math.round((value*100)/divisorValue)
		//alert(resultValue)
		//if(resultValue < 100 || elmData[5] == ""){
			var likelyhood = 0
			if(resultValue <= 0)likelyhood = 0
			else if(resultValue > 0 && resultValue <=5) likelyhood = 1
			else if (resultValue > 5 && resultValue <=15) likelyhood = 2
			else likelyhood = 3

			var impactCriteria = 0
			if(inputType == 'select'){
				try{
					impactCriteria = parseInt(elm.value.split("||")[1])
					}
				catch(e){
					impactCriteria = parseInt(($(elm).val()).split("||")[1])
					}
				$('#'+toEditId+"impactCriteria").val(impactCriteria)
				$('#'+toEditId+"result").val(resultValue)
				$('#'+toEditId+"likelyhood").val(likelyhood)
				$('#'+toEditId+"inherentRisk").val(impactCriteria * likelyhood)
		
				questionResponsesData[toEditQuestionId]['QIMPACTCRITERIA'] = impactCriteria
				questionResponsesData[toEditQuestionId]['QINPUT'] = value
				questionResponsesData[toEditQuestionId]['QRESULT'] = resultValue
				questionResponsesData[toEditQuestionId]['QLIKELYHOOD'] = likelyhood
				questionResponsesData[toEditQuestionId]['QINHERENTRISK'] = impactCriteria * likelyhood
				

			}
			
			if(inputType == 'numeric'){
				var rangesStr = elmData[1].split("^")[1]
				var ranges = []
				rangesStr.split("%%").forEach(range=>{
					if(range.split("$")[1] == 'INF'){
						
						ranges.push({"lower":parseInt(range.split("$")[0]),"upper":99.99})
						}
					else{
						ranges.push({"lower":parseInt(range.split("$")[0]),"upper":parseInt(range.split("$")[1])})
						}
					})
				var range = 0
				//we check only two ranges
				for(var i = 0;i<2;i++){
					if(value > parseInt(ranges[i]['lower']) && value <= parseInt(ranges[i]['upper'])){
						
						range = i+1
					}
				}
				// no range is matched then the risk impact is high
				if(range == 0){
					range = 3
					}
				$('#'+toEditId+"impactCriteria").val(range)
				$('#'+toEditId+"result").val(resultValue)
				$('#'+toEditId+"likelyhood").val(likelyhood)
				$('#'+toEditId+"inherentRisk").val(range * likelyhood)
				
				questionResponsesData[toEditQuestionId]['QINPUT'] = value
				questionResponsesData[toEditQuestionId]['QIMPACTCRITERIA'] = range
				questionResponsesData[toEditQuestionId]['QRESULT'] = resultValue
				questionResponsesData[toEditQuestionId]['QLIKELYHOOD'] = likelyhood
				questionResponsesData[toEditQuestionId]['QINHERENTRISK'] = range * likelyhood
				}
	
			//for refreshing all dependent values
			var qsInherentRisks = document.getElementById(category+"||"+subCategory+"||table").querySelectorAll(".qsInherentRisk"); 
			var answeredQsCount = 0
			var sectionInherentRisk = 0
			qsInherentRisks.forEach(elmm =>{
				
				if($(elmm).val() > 0){
					answeredQsCount ++
					sectionInherentRisk += parseInt($(elmm).val())
					}
				
				})
			//console.log(sectionInherentRisk)
			//console.log(answeredQsCount)
			$("#"+category+subCategory+"inherentRisk").val(isNaN((sectionInherentRisk/answeredQsCount).toFixed(2))?0:(sectionInherentRisk/answeredQsCount).toFixed(2))
			
			Object.keys(categSubcategInherentRiskRatings).forEach(categ=>{
				if(categ.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'').replaceAll("&","") == category){
					Object.keys(categSubcategInherentRiskRatings[categ]).forEach(subCateg=>{
						if(subCateg.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'').replaceAll("&","") == subCategory){
							categSubcategInherentRiskRatings[categ][subCateg] = isNaN((sectionInherentRisk/answeredQsCount).toFixed(2))?0:(sectionInherentRisk/answeredQsCount).toFixed(2)
							}
						})
					}

				})
			
			$("#categSubcategInherentRiskRatings").html(JSON.stringify(categSubcategInherentRiskRatings))
			
			var subCategoryInherentRisks = document.getElementById("panelSearchFormNew").querySelectorAll("."+category+"SectionInherentRisk"); 
			var categInherentRisk = 0
			var provRiskRating = 0
			subCategoryInherentRisks.forEach(elmm =>{
				//console.log((parseInt($(elmm).val())))
				//console.log(subCategoriesWeightages[category])
				categInherentRisk += parseFloat($(elmm).val())
				provRiskRating += parseFloat(((parseFloat($(elmm).val())*subCategoriesWeightages[category])/100).toFixed(2))
				
				})
			var prov = ""
			if(provRiskRating <= 0) prov = 'NoRisk'
			else if(provRiskRating > 0 && provRiskRating <=5) prov = 'Low'
			else if (provRiskRating > 5 && provRiskRating <=15) prov = 'Medium'
			else prov = 'High'

			//for residual risk tab fields
			$("#"+category+"SysGenResidualRisk").val(isNaN(categInherentRisk)? 0: categInherentRisk)
			$("#"+category+"ProvResidualRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2) + " -" + prov)
			$("#"+category+"FinalResidualRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2))
			
			//for in tab fields
			$("#"+category+"systemGeneratedRisk").val(isNaN(categInherentRisk.toFixed(2)) ? 0 : categInherentRisk.toFixed(2))
			$("#"+category+"provisionalRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2) + " -" + prov)
			$("#"+category+"finalRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2))
			
			$("#questionResponses").html(JSON.stringify(questionResponsesData))
			
			Object.keys(categoryRiskRatings).forEach(categ=>{
				if(categ.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'').replaceAll("&","") == category){
					categoryRiskRatings[categ]['PROVRISKRATING'] = isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2) + " -" + prov
					categoryRiskRatings[categ]['SYSGENRISKRATING'] = isNaN(categInherentRisk.toFixed(2)) ? 0 : categInherentRisk.toFixed(2)
					categoryRiskRatings[categ]['FINALRISKRATING'] = isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2)
					}

				})
			
			$("#categoryRiskRatings").html(JSON.stringify(categoryRiskRatings))
			
			calculateAndUpdateTotalInherentRisk()
			
			var x = document.getElementById("panelSearchFormNew").querySelectorAll(".RAInputValue"); 
			x.forEach(elmm =>{
				
				var elmName = $(elmm).attr("name")
				if(elmName.replaceAll(".","SQ").includes(toEditId+","))
					{
						userInputChange($(elmm))
						
					}
				})
			
			//}
		//else{
			//alert("Input Value cannot be greater than sum of parent values"+"\nparent Question Ids:"+elmData[5]+"\n allowed range:<="+divisorValue)
			//}
		}
	function handleCRInputChange(elm){

		var questionResponsesData = JSON.parse($("#questionResponses").html())
		var questionId = elm.name.split("||")[0]
		var editField = elm.name.split("||")[1]
		var category = elm.name.split("||")[2]
		questionResponsesData[questionId][editField] = elm.value
		$("#questionResponses").html(JSON.stringify(questionResponsesData))

		var Ecount = 0
		var NIcount = 0
		var NCcount = 0
		var NAcount = 0
		var totalQsCount = 0
		var x = document.getElementById("controlsReviewNew").querySelectorAll("."+category+"designRating"); 
		x.forEach(elmm =>{
			if(elmm.value == 'E') Ecount++
			else if (elmm.value == 'NI') NIcount++
			else if (elmm.value == "NC") NCcount++
			else NAcount++

			totalQsCount++
		})
		x = document.getElementById("controlsReviewNew").querySelectorAll("."+category+"operatingRating"); 
		x.forEach(elmm =>{
			if(elmm.value == 'E') Ecount++
			else if (elmm.value == 'NI') NIcount++
			else if (elmm.value == "NC") NCcount++
			else NAcount++
		})
		
		/* console.log("qscount:",totalQsCount)
		console.log("Ecount:",Ecount)
		console.log("NIcount:",NIcount)
		console.log("NCcount:",NCcount)
		console.log("NAcount:",NAcount) */
		
		var controlReviewCategoryWeights = JSON.parse($("#controlReviewCategoryWeights").html())
		Object.keys(controlReviewCategoryWeights).forEach(crCateg=>{
			if(crCateg.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'').replaceAll("&","") == category){
				var provRiskRating = 0
				var categInherentRisk = (((NIcount * 5) + (NCcount*10))/(totalQsCount*2 - NAcount)).toFixed(2)
				//console.log("inherentRisk:",categInherentRisk)
				//console.log("weight:",controlReviewCategoryWeights[crCateg])
				if(categInherentRisk < 0 || !isFinite(categInherentRisk)){
					categInherentRisk = 0
					}
				try{
					provRiskRating = (categInherentRisk*controlReviewCategoryWeights[crCateg])/100
					}
				catch(e){}
				if(provRiskRating < 0 || !isFinite(provRiskRating)){
					provRiskRating = 0
					}
				
				//console.log("crRisk:",provRiskRating)
				/* var prov = ""
				if(provRiskRating <= 0) prov = 'NoRisk'
				else if(provRiskRating > 0 && provRiskRating <=5) prov = 'Low'
				else if (provRiskRating > 5 && provRiskRating <=15) prov = 'Medium'
				else prov = 'High' */
	
				//for residual risk tab fields
				$("#"+category+"CRSysGenResidualRisk").val(isNaN(categInherentRisk)? 0: categInherentRisk)
				$("#"+category+"CRProvResidualRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2))
				$("#"+category+"CRFinalResidualRisk").val(isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2))
				
				var crCategoryRiskRatings = JSON.parse($("#crCategoryRiskRatings").html())
				crCategoryRiskRatings[crCateg]['SYSGENRISKRATING'] = isNaN(categInherentRisk)? 0: categInherentRisk
				crCategoryRiskRatings[crCateg]['PROVRISKRATING'] = isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2)
				crCategoryRiskRatings[crCateg]['FINALRISKRATING'] = isNaN(provRiskRating.toFixed(2)) ? 0 : provRiskRating.toFixed(2)
				$("#crCategoryRiskRatings").html(JSON.stringify(crCategoryRiskRatings))

				calculateAndUpdateTotalInternalControlRisk()
				
					
				}
			
		})
		
		
	}
	function calculateAndUpdateTotalInternalControlRisk(){
		var crCategoryRiskRatings = JSON.parse($("#crCategoryRiskRatings").html())
		var totalInternalControlRisk = 0.0
		Object.keys(crCategoryRiskRatings).forEach(categ=>{
			totalInternalControlRisk += parseFloat(crCategoryRiskRatings[categ]['PROVRISKRATING'])
			})
		var result = "Effective (Low)"
		if(totalInternalControlRisk > 3 && totalInternalControlRisk < 7) result = "Needs Improvement (Medium)"
		if(totalInternalControlRisk >= 7) result = "No Control (Hign)"

		$("#totalInternalControlRiskRating").val(totalInternalControlRisk)
		$("#totalInternalControlRiskRatingResult").val(result)
		}
	function calculateAndUpdateTotalInherentRisk(){
		
		var categoryWeights = JSON.parse($("#categoryWeights").html())
		var categoryRiskRatings = JSON.parse($("#categoryRiskRatings").html())

		var totalInherentRisk = 0.0
		Object.keys(categoryRiskRatings).forEach(categ=>{
			totalInherentRisk += parseFloat(((parseFloat(categoryRiskRatings[categ]['PROVRISKRATING'].split("-")[0]) * categoryWeights[categ])/100).toFixed(2))
			})

		var result = "Low"
		if(totalInherentRisk > 2 && totalInherentRisk <= 6) result = "Medium"
		if(totalInherentRisk > 6) result = "High"

		$("#totalInherentRiskRating").val(totalInherentRisk.toFixed(2))
		$("#totalInherentRiskRatingResult").val(result)
			
		}
	function handleFormGeneralDataChange(elm){
		
		var generalAndstatusDetails = JSON.parse($("#generalAndstatusDetails").html())
		generalAndstatusDetails[elm.name] = elm.value
		$("#generalAndstatusDetails").html(JSON.stringify(generalAndstatusDetails))
		}

	function handleSaveForm(elm){
		var ctx = window.location.href;
		ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
		var url = ctx + '/common/saveRiskAssesesmentForm';
		var CURRENTROLE = "${CURRENTROLE}";
		var userCode = "${USERCODE}"
		
		var generalAndstatusDetails = JSON.parse($("#generalAndstatusDetails").html())
		/* alert(elm.value) */
		generalAndstatusDetails['FORMSTATUS'] = elm.value
		generalAndstatusDetails['CMOFFICERTIMESTAMP'] = generalAndstatusDetails['CMOFFICERTIMESTAMP'].split(" ")[0]
		try{
			generalAndstatusDetails['CMMANAGERTIMESTAMP'] = generalAndstatusDetails['CMMANAGERTIMESTAMP'].split(" ")[0]
			}
		catch(e){
			generalAndstatusDetails['CMMANAGERTIMESTAMP'] = generalAndstatusDetails['CMMANAGERTIMESTAMP']
			}
		var toPost = true
		if(CURRENTROLE == 'ROLE_CM_OFFICER'){
			if(generalAndstatusDetails['CMOFFICERCOMMENTS'] == ""){
				toPost = false
				alert("Please provide CM Officer comments")
				}
			
			}
		if(CURRENTROLE == 'ROLE_CM_MANAGER'){
			if(generalAndstatusDetails['CMMANAGERCOMMENTS'] == "" || !Object.keys(generalAndstatusDetails).includes("CMMANAGERCOMMENTS")){
				toPost = false
				alert("Please provide CM Manager comments")
				}
			
			}
		$("#generalAndstatusDetails").html(JSON.stringify(generalAndstatusDetails))
		if(toPost){
				 var categSubcategInherentRisks = []
				 var categSubcategInherentRiskRatings = JSON.parse($("#categSubcategInherentRiskRatings").html())
				 Object.keys(categSubcategInherentRiskRatings).forEach(category=>{
					Object.keys(categSubcategInherentRiskRatings[category]).forEach(subcategory=>{
						categSubcategInherentRisks.push({"category":category,
														 "subCategory":subcategory,
														 "inherentRisk":categSubcategInherentRiskRatings[category][subcategory]})
						})
					 })
				 var categoryRisks = []
				 var categoryRiskRatings = JSON.parse($("#categoryRiskRatings").html())
				 Object.keys(categoryRiskRatings).forEach(category=>{
						categoryRisks.push({
											"categoryName":category,
											"sysgenRisk":categoryRiskRatings[category]['SYSGENRISKRATING'],
											"provisionalRisk":categoryRiskRatings[category]['PROVRISKRATING'],
											"finalRisk":categoryRiskRatings[category]['FINALRISKRATING'],
											"reasonsForDeviation":categoryRiskRatings[category]['REASONFORDEVIATION']
											})
					 })
				 var crCategoryRisks = []
				 var crCategoryRiskRatings = JSON.parse($("#crCategoryRiskRatings").html())
				 Object.keys(crCategoryRiskRatings).forEach(category=>{
					 crCategoryRisks.push({
											"categoryName":category,
											"sysgenRisk":crCategoryRiskRatings[category]['SYSGENRISKRATING'],
											"provisionalRisk":crCategoryRiskRatings[category]['PROVRISKRATING'],
											"finalRisk":crCategoryRiskRatings[category]['FINALRISKRATING'],
											"reasonsForDeviation":crCategoryRiskRatings[category]['REASONFORDEVIATION']
											})
					 })
				 var questionResponses = []
				 var questionResponsesJ = JSON.parse($("#questionResponses").html())
				 Object.keys(questionResponsesJ).forEach(category=>{
					 questionResponses.push(questionResponsesJ[category])
					 })
					 
				 var data = {
							"generalAndStatusDetails":JSON.parse($("#generalAndstatusDetails").html()),
							"questionResponses":questionResponses,
							"categSubcategInherentRiskRatings":categSubcategInherentRisks,
							"categoryRiskRatings":categoryRisks,
							"crCategoryRiskRatings":crCategoryRisks,
							"assessmentUnit":$("#assessmentUnit").html().replaceAll("\n","").replaceAll("\t",""),
							"cmRefNo":$("#cmRefNo").html().replaceAll("\n","").replaceAll("\t","")
							
						   };
				/* console.log(data) */
				$.ajax({
					url: url,
					cache: false,
					type: 'POST',
					data: JSON.stringify(data),
					contentType: "application/json",
					success: function (response) {
						if(CURRENTROLE == 'ROLE_CM_OFFICER'){
							if(elm.value == "CMO-P")
								alert("Form Successfully Saved As A Draft.")
							else{
								alert("Form Successfully Saved")
								reloadTabContent();
								/* $('#ASSESSMENTUNIT option[value="${ASSESSMENTUNIT}"]').attr('selected','selected'); */
								setTimeout(()=>{
									$("#ASSESSMENTUNIT").val("${ASSESSMENTUNIT}")
									$("#searchRiskAssessment").click()
									},2000)
								
								}
						}
						else{
							if(elm.value == "CMM-A"){
								alert("Form Approved Successfully")
								reloadTabContent();
								setTimeout(()=>{
									$("#ASSESSMENTUNIT").val("${ASSESSMENTUNIT}")
									$("#searchRiskAssessment").click()
									},2000)
								}
							else{
								alert("Form Successfully Saved")
								reloadTabContent();
								setTimeout(()=>{
									$("#ASSESSMENTUNIT").val("${ASSESSMENTUNIT}")
									$("#searchRiskAssessment").click()
									},2000)
								}
							}
					},
					error: function (a, b, c) {
						alert("form saving Failed. with error: "+a+b+c+". see console for more info.")
						console.log(a+b+c);
					}
				}) 
			}
		
		}
</script>
<div class="col-sm-12">
	<div style = "display: none">
		<div id = "controlsReviewsCategSubCateg">
			${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg }
		</div>
		<div id = "controlsReviewsQuestionsDetails">
			${QUESTIONSFORMDETAILS.controlsReviewQuestionsJson }
		</div>
		<div id = "quesionDetailsFormJson">
			${QUESTIONSFORMDETAILS.categoryWiseQuesitonsJson }
		</div>
		<div id = "quesionDetailsForm">
			${QUESTIONSFORMDETAILS.categoryWiseQuesitons }
		</div>
		<div id = "categoriesSubCategories">
				${QUESTIONSFORMDETAILS.categoryList }
		</div>
		<div id = "questionResponses">
			${QUESTIONSFORMDETAILS.questionResponsesData }
		</div>
		<div id = "assessmentUnit">
			${ASSESSMENTUNIT}
		</div>
		<div id = "unqId">
			${UNQID}
		</div>
		<div id = "cmRefNo">
			${COMPASSREFERENCENO}
		</div>
		
		<div id = "categSubcategInherentRiskRatings">
			${QUESTIONSFORMDETAILS.categSubcategInherentRiskRatingsJson }
		</div>
		<div id = "categoryRiskRatings">
			${QUESTIONSFORMDETAILS.categoryRiskRatingsJson }
		</div>
		<div id = "crCategoryRiskRatings">
			${QUESTIONSFORMDETAILS.crCategoryRiskRatingsJson }
		</div>
		<div id = "controlReviewCategoryWeights">
			${QUESTIONSFORMDETAILS.controlReviewCategoryWeights }
		</div>
		<div id = "categoryWeights">
			${QUESTIONSFORMDETAILS.categoryWeights }
		</div>
		<div id = "generalAndstatusDetails">
			${QUESTIONSFORMDETAILS.generalAndstatusDetailsJson }
		</div>
		
	</div>
	<div style = "display:none">
		<textarea id = "selectedQIds">[]</textarea>
		<textarea id = "rowsData" value = ""/>
		<textarea id = "qId" value = ""/>
		<textarea id = "emailAlertDetails" value = ""/>
		<textarea id = "checkerList" value = ""/>
		<textarea id = "makerList" value = ""/>
		<textarea id = "crn" value = ""/>
		<textarea id = "makerAssignedCases" value = ""/>
		<textarea id = "bulk" value = ""/>
		<textarea id = "selectedMakers" value = ""/>
	</div>
	<div class="card card-primary panel_CDDForm">
		<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
			<h6 class="card-title pull-${dirL}">Inherent Risk Questionnaire for ${ASSESSMENTUNIT}</h6>
		</div>
		<div class="panelSearchFormNew" id = "panelSearchFormNew">
				<div class="card-search-card" >
				<form action="javascript:void(0)" method="POST" id="riskAssessmentForm">
				<input type="hidden" value="${ASSESSMENTUNIT}" name="ASSESSMENTUNIT"></input>
				<input type="hidden" value="${COMPASSREFERENCENO}" name="COMPASSREFNO"></input>
					<ul class="nav nav-pills modalNav" role="tablist" style = "margin:2px 0px 2px 0px;">
						<li role="presentation" class="active" id="generalTabNew">
							<a class="subTab nav-link active" href="#generalNew" aria-controls="tab" role="tab" data-toggle="tab">General</a>
						</li>
						<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.categoryList}">
						
							<li role="presentation" id=<c:out value="${f:replace(category,' ','')}TabNew"/>>
								<a class="subTab nav-link" href=<c:out value="#${f:replace(category,' ','')}New"/> aria-controls="tab" role="tab" data-toggle="tab" style="text-transform: capitalize">${category }</a>
							</li>
						</c:forEach>
						<!-- <li role="presentation" id="geographyTab">
							<a class="subTab nav-link" href="#geography" aria-controls="tab" role="tab" data-toggle="tab">Geography</a>
						</li>
						<li role="presentation" id="productsServicesTab">
							<a class="subTab nav-link" href="#productsServices" aria-controls="tab" role="tab" data-toggle="tab">Products & Services</a>
						</li>
						<li role="presentation" id="transactionsTab">
							<a class="subTab nav-link" href="#transactions" aria-controls="tab" role="tab" data-toggle="tab">Transactions</a>
						</li>
						<li role="presentation" id="deliveryChannelsTab">
							<a class="subTab nav-link" href="#deliveryChannels" aria-controls="tab" role="tab" data-toggle="tab">Delivery Channels</a>
						</li> -->
						<li role="presentation" id="controlParametersTabNew">
							<a class="subTab nav-link" href="#controlsReviewNew" aria-controls="tab" role="tab" data-toggle="tab">Controls Review</a>
						</li>
						<li role="presentation" id="riskRatingTabNew">
							<a class="subTab nav-link" href="#riskRatingNew" aria-controls="tab" role="tab" data-toggle="tab">Residual Risk Rating</a>
						</li>
						<li role="presentation" id="statusApprovalsTabNew">
							<a class="subTab nav-link" href="#statusApprovalsNew" aria-controls="tab" role="tab" data-toggle="tab">Status & Approvals</a>
						</li>
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="generalNew">
							<table class="table table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td width="10%">
											Assessment Period
										</td>
										<td width="20%">
											<input type="text" autocomplete="off" class="form-control input-sm" name="ASSESSMENTPERIOD" onchange="handleFormGeneralDataChange(this)" id="GENERAL_ASSESSMENTPERIOD${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.ASSESSMENTPERIOD}">
										</td>
										<td width="5%">&nbsp;</td>
										<td width="10%">
											 Point of Contact Name
										</td>
										<td width="20%">
											<input type="text"  autocomplete="off" class="form-control input-sm" name="POCNAME" onchange="handleFormGeneralDataChange(this)" id="GENERAL_POCNAME${UNQID}"  value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.POCNAME}">
										</td>
										<td width="5%">&nbsp;</td>
										<td>Point of Contact Email</td>
										<td>
											<input type="text" class="form-control input-sm" name="POCEMAIL" onchange="handleFormGeneralDataChange(this)" id="GENERAL_POCEMAIL${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.POCEMAIL}">
										</td>
									</tr>
									<tr>
										<td>Assessment Unit</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_ASSESSMENTUNIT" id="GENERAL_ASSESSMENTUNIT${UNQID}" 
											       value="${ASSESSMENTUNIT}" readonly="readonly">
										</td>
										<td>&nbsp;</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">Compliance:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Business:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Other:</td>
											 	</tr>
											 </table>
										</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="COMPLIANCE1"  onchange="handleFormGeneralDataChange(this)" id="GENERAL_COMPLIANCE1${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.COMPLIANCE1}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="BUSINESS1" onchange="handleFormGeneralDataChange(this)" id="GENERAL_BUSINESS1${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.BUSINESS1}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="OTHER1" onchange="handleFormGeneralDataChange(this)" id="GENERAL_OTHER1${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.OTHER1}">
											 		</td>
											 	</tr>
											 </table>
										</td>
										<td>&nbsp;</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">Compliance:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Business:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Other:</td>
											 	</tr>
											 </table>
										</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="COMPLIANCE2" onchange="handleFormGeneralDataChange(this)" id="GENERAL_COMPLIANCE2${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.COMPLIANCE2}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="BUSINESS2" onchange="handleFormGeneralDataChange(this)" id="GENERAL_BUSINESS2${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.BUSINESS2}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="OTHER2" onchange="handleFormGeneralDataChange(this)" id="GENERAL_OTHER2${UNQID}" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.OTHER2}">
											 		</td>
											 	</tr>
											 </table>
										</td>
									</tr>
									<tr>
										<td colspan="8" style="text-align: left;">
											Who are the key business leads / stakeholders for the assessment unit responsible for providing responses to the questionnaires? Please provide name and role.
										</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											Sr. No.
										</td>
										<td>
											Name
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 Role
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											1
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="KEYBUSINESSNAME1" id="GENERAL_NAME1${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSNAME1}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="KEYBUSINESSROLE1" id="GENERAL_ROLE1${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSROLE1}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											2
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="KEYBUSINESSNAME2" id="GENERAL_NAME2${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSNAME2}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="KEYBUSINESSROLE2" id="GENERAL_ROLE2${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSROLE2}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											3
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="KEYBUSINESSNAME3" id="GENERAL_NAME3${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSNAME3}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="KEYBUSINESSROLE3" id="GENERAL_ROLE3${UNQID}" onchange="handleFormGeneralDataChange(this)" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.KEYBUSINESSROLE3}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>									
									<tr>
										<td colspan="8" style="text-align: left;">
											Table below illustrates the weightage of each risk factor:
										</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Risk Factor
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 Weight
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Customer Risk
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 30%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Geographic Risk
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 25%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Products & Services
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 25%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Transactions
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 10%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Delivery Channel
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 10%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>									
								</tbody>
							</table>
						</div>
						
						<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.categoryList}">
							<c:set var = "formattedCategory" value = "${f:replace(f:replace(f:replace(f:replace(category,')',''),'(',''),'/',''),' ','')}"/>
							<div role="tabpanel" class="tab-pane  fade in" id=<c:out value="${f:replace(category,' ','')}New"/> >
								<div class="row">
									<div class="col-sm-12">
										<div class="">
											<%-- <div id=<c:out value="${f:replace(category,' ','')}DetailsNew"/>> --%>
												<c:forEach var ="subCategory" items = "${QUESTIONSFORMDETAILS.categoresAndSubCategories[category] }">
													<c:set var = "formattedSubCategory" value = "${f:replace(f:replace(f:replace(f:replace(subCategory,')',''),'(',''),'/',''),' ','')}"/>
													<div class="card card-primary panel_RiskAssessmentForm" style="">
														<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
															<h6 class="card-title pull-${dirL}">${subCategory}</h6>
														</div>
														<div class="panelSearchForm">
															<div class="card-search-card" >
															
																<c:if test = "${f:length(QUESTIONSFORMDETAILS.categoryWiseQuesitons[category][subCategory]) > 0}">
																<table class="table " id = "${formattedCategory }||${formattedSubCategory }||table" style="style="margin-bottom: 0px;border-collapse:collapse;">
																	<tbody>
																			 <tr style="background-color:#ddd">
																				<th width = "1%"></th>
																				<th width = "10%">Question Id</th>
																				<th width = "45%">Question</th>
																				<th width = "10%">Question Input</th>
																				<th width = "5%">Result (%)</th>
																				<th width = "7%">Impact Criteria</th>
																				<th width = "7%">Likelihood</th>
																				<th colspan=2 width="10%" style="text-align:center">Action</th>
																			</tr> 
																		<%-- ${QUESTIONSFORMDETAILS.categoryWiseQuesitons[category][subCategory] } --%>
																		<c:forEach var = "question" items = "${QUESTIONSFORMDETAILS.categoryWiseQuesitons[category][subCategory]}">
																			
																			<c:set var = "checkboxState" value = "disabled"></c:set>
																			
																			<c:if test = "${question['RFISTATUS'] eq 'PE'}">
																				<c:set var = "rowColor" value = "#FF7F7F"></c:set>
																			</c:if>
																			<c:if test = "${question['RFISTATUS'] eq 'IP'}">
																				<c:set var = "rowColor" value = "lightyellow"></c:set>
																			</c:if>
																			<c:if test = "${question['RFISTATUS'] eq 'CO'}">
																				<c:set var = "rowColor" value = "lightgreen"></c:set>
																			</c:if>
																			<c:if test = "${question['RFISTATUS'] eq 'NA'}">
																				<c:set var = "rowColor" value = "transparent"></c:set>
																				<c:set var = "checkboxState" value = ""></c:set>
																			</c:if>
																			
																			<tr >
																				<c:choose>
																					<c:when test = "${f:length(question.SUBQUESTIONLIST) > 0 }">
																						<td colspan = 9  style = "padding:0">
																							<table>
																								<tr>
																									<td style="width:1%;background-color:${rowColor }" id = "${question['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${question['QUESTIONID']}" name = "${question['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																									</td >
																									<td width = "10%">
																										${question.QUESTIONID } 
																										<div class="btn-group pull-right clearfix">
																											<span class="pull-right" onclick="handleSlidingPanels(this,'${UNQID}','${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}')"><i class="collapsable${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID} fa fa-chevron-up" style = "font-size:15px;"></i></span>
																										</div>
																									</td>
																									<td width = "45%">
																										${question.QUESTION }
																									</td>
																									<td width = "10%">
																											
																										<c:if test = "${question.INPUTTYPE eq 'select' }">
																											<!--  name = "inputType||QId||subQuestionId||category||subCategory||parentIdsList" -->
																											<select id = "${question['QUESTIONID'] }inputValue" class="form-control input-sm RAInputValue" name = "select||${question['QUESTIONID'] }||null||${formattedCategory}||${formattedSubCategory}||<c:if test = "${question['ISSUPERPARENT'] ne 'Y' }">${question['PARENTQSIDS']}</c:if>" onchange = "userInputChange(this)">
																												<option value = "0||1">Nothing Selected</option>
																												<c:forEach var = "option" items = "${f:split(question.INPUTOPTIONSLIST, '||') }">
																													<c:if test = "${f:split(option,'^')[0] ne 'null' }">
																														<option value = <c:out value = "${f:split(option,'^')[1] }||${f:split(option,'^')[2] }"/> <c:if test = "${f:split(option,'^')[1] eq question.QRESPONSES.QINPUT}">selected</c:if>>${f:split(option,'^')[0] }( ${f:split(option,'^')[1] })</option>
																													</c:if>
																												</c:forEach>
																											</select>
																										</c:if>
																										<c:if test = "${question.INPUTTYPE eq 'numeric' }">
																											<input id = "${question['QUESTIONID'] }inputValue" value = "${question.QRESPONSES.QINPUT }"  class="form-control input-sm RAInputValue" type = "number" name = "numeric||${question['QUESTIONID'] }^${f:replace(f:replace(question['INPUTOPTIONSLISTFORNUMERIC'],'||','%%'),'^','$') }||null||${formattedCategory}||${formattedSubCategory}||<c:if test = "${question['ISSUPERPARENT'] ne 'Y' }">${question['PARENTQSIDS']}</c:if>" onchange = "userInputChange(this)">
																										</c:if>
																										<c:if test = "${question.INPUTTYPE eq 'text' }">
																											<textarea class="form-control input-sm">${question.QRESPONSES.QINPUT }</textarea>
																										</c:if>
																										
																									</td>
																									<c:choose>
																										<c:when test = "${question.ISSUPERPARENT ne 'Y' && question.HASRISKIMPACT eq 'Y' }">
																											<td width = "5%">
																												<input  id = "${question.QUESTIONID }result" class="form-control input-sm" value = "${question.QRESPONSES.QRESULT }" disabled>
																												<input  id = "${question.QUESTIONID }inherentRisk" class="form-control input-sm qsInherentRisk" value = "${question.QRESPONSES.QINHERENTRISK }" style = "display:none">
																											</td>
																											<td width = "7%">
																												<select class="form-control input-sm" id="${question.QUESTIONID }impactCriteria" disabled>
																													<!-- <option>Nothing Selected</option> -->
																													<option value = 1 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 1) || (question.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																													<option value = 2 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 2) || (question.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																													<option value = 3 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 3) || (question.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																													
																												</select>
																											</td>
																											<td width = "7%">
																												<select class="form-control input-sm" id="${question.QUESTIONID }likelyhood" disabled>
																													<option value = 0 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 0) || (question.QRESPONSES.QIMPACTCRITERIA eq '0')}">selected</c:if>>NoRisk</option>
																													<option value = 1 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 1) || (question.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																													<option value = 2 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 2) || (question.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																													<option value = 3 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 3) || (question.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																													
																												</select>
																											</td>
																											<%-- <td width = "5%">
																												<input id = "${question.QUESTIONID }result" class="form-control input-sm" disabled> 
																											</td> --%>
																											<td width = "5%" align="center">
																												<button class="btn btn-primary" name = "${question['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${question['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																											</td>
																											<td width = "5%" align="center">
																												<button class="btn btn-warning" name = "${question['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${question['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																											</td>
																										</c:when>
																										<c:otherwise>
																											<td width = "5%">
																											</td>
																											<td width = "7%">
																											</td>
																											<td width = "7%"> 
																											</td>
																											<td width = "5%" align="center">
																												<button class="btn btn-primary" name = "${question['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${question['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																											</td>
																											<td width = "5%" align="center">
																												<button class="btn btn-warning" name = "${question['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${question['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																											</td>
																										</c:otherwise>
																									</c:choose>
																								</tr>
																								<tr>
																									<td colspan = 9 style="padding:0">
																										<div class = "subQuestionSlididngPanel" id="${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}" class="${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}" >
																												
																												<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
																												
																													<table class="" style="style="margin-bottom: 0px;border-collapse:collapse;">
																														<tbody>
																																 <tr style = "background-color:#d9edf7">
																																	<th></th>
																																	<th>Question Id</th>
																																	<th>Question</th>
																																	<th>Question Input</th>
																																	<th>Result (%)</th>
																																	<th>Impact Criteria</th>
																																	<th>Likelihood</th>
																																	<th colspan=2 style="text-align:center">Action</th>
																																</tr> 
																															<c:forEach var = "subQuestion" items = "${question['SUBQUESTIONLIST']}">
																																
																																<c:set var = "checkboxState" value = "disabled"></c:set>
																			
																																<c:if test = "${subQuestion['RFISTATUS'] eq 'PE'}">
																																	<c:set var = "rowColor" value = "#FF7F7F"></c:set>
																																</c:if>
																																<c:if test = "${subQuestion['RFISTATUS'] eq 'IP'}">
																																	<c:set var = "rowColor" value = "lightyellow"></c:set>
																																</c:if>
																																<c:if test = "${subQuestion['RFISTATUS'] eq 'CO'}">
																																	<c:set var = "rowColor" value = "lightgreen"></c:set>
																																</c:if>
																																<c:if test = "${subQuestion['RFISTATUS'] eq 'NA'}">
																																	<c:set var = "rowColor" value = "transparent"></c:set>
																																	<c:set var = "checkboxState" value = ""></c:set>
																																</c:if>
																			
																																<tr width="100%">
																																	<td style="width:1%;background-color:${rowColor }" id = "${subQuestion['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${subQuestion['QUESTIONID']}" name = "${subQuestion['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																																	</td >
																																	<td width = "10%">
																																		${subQuestion.QUESTIONID }
																																	</td>
																																	<td width = "45%">
																																		${subQuestion.QUESTION }
																																	</td>
																																	<td width = "10%">
																																		<c:if test = "${subQuestion.INPUTTYPE eq 'select' }">
																																			<select id = "${f:replace(subQuestion['QUESTIONID'],'.','SQ') }inputValue" class="form-control input-sm RAInputValue" name = "select||${question['QUESTIONID'] }||${f:replace(subQuestion['QUESTIONID'],'.','SQ') }||${formattedCategory}||${formattedSubCategory}||${subQuestion['PARENTQSIDS']}" onchange = "userInputChange(this)">
																																				<option value = "0||1">Nothing Selected</option>
																																				<c:forEach var = "option" items = "${f:split(subQuestion.INPUTOPTIONSLIST, '||') }">
																																					<c:if test = "${f:split(option,'^')[0] ne 'null' }">
																																						<option value = <c:out value = "${f:split(option,'^')[1] }||${f:split(option,'^')[2] }"/> <c:if test = "${f:split(option,'^')[1] eq subQuestion.QRESPONSES.QINPUT}">selected</c:if>>${f:split(option,'^')[0] } (${f:split(option,'^')[1]})</option>
																																					</c:if>
																																				</c:forEach>
																																			</select>
																																		</c:if>
																																		<c:if test = "${subQuestion.INPUTTYPE eq 'numeric' }">
																																			<input id = "${f:replace(subQuestion['QUESTIONID'],'.','SQ') }inputValue" value = "${subQuestion.QRESPONSES.QINPUT }" class="form-control input-sm RAInputValue" type = "number" name = "numeric||${question['QUESTIONID'] }^${f:replace(f:replace(subQuestion['INPUTOPTIONSLISTFORNUMERIC'],'||','%%'),'^','$') }||${f:replace(subQuestion['QUESTIONID'],'.','SQ') }||${formattedCategory}||${formattedSubCategory}||${subQuestion['PARENTQSIDS']}" onchange = "userInputChange(this)">
																																		</c:if>
																																		<c:if test = "${subQuestion.INPUTTYPE eq 'text' }">
																																			<textarea class="form-control input-sm">${subQuestion.QRESPONSES.QINPUT } </textarea>
																																		</c:if>
																																		
																																	</td>
																																	<c:choose>
																																		<c:when test = "${subQuestion.HASRISKIMPACT eq 'Y' }">
																																			<td width = "5%">
																																				<input id = "${f:replace(subQuestion.QUESTIONID,'.','SQ') }result" class="form-control input-sm" value = "${subQuestion.QRESPONSES.QRESULT }" disabled>
																																				<input  id = "${f:replace(subQuestion.QUESTIONID,'.','SQ') }inherentRisk" class="form-control input-sm qsInherentRisk" value = "${subQuestion.QRESPONSES.QINHERENTRISK }" style = "display:none" >
																																			</td>
																																			<td width = "7%">
																																				<select class="form-control input-sm" id="${f:replace(subQuestion.QUESTIONID,'.','SQ') }impactCriteria" disabled>
																																					<!-- <option>Nothing Selected</option> -->
																																					<option value = 1 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 1) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																																					<option value = 2 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 2) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																																					<option value = 3 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 3) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																													
																																					
																																				</select>
																																			</td>
																																			<td width = "7%">
																																				<select class="form-control input-sm" id="${f:replace(subQuestion.QUESTIONID,'.','SQ') }likelyhood" disabled>
																																					<option value = 0 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 0) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '0')}">selected</c:if>>NoRisk</option>
																																					<option value = 1 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 1) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																																					<option value = 2 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 2) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																																					<option value = 3 <c:if test = "${(subQuestion.QRESPONSES.QIMPACTCRITERIA eq 3) || (subQuestion.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																																					
																																				</select>
																																			</td>
																																			<td width = "5%" align="center">
																																				<button class="btn btn-primary" name = "${subQuestion['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${subQuestion['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																																			</td>
																																			<td width = "5%" align="center">
																																				<button class="btn btn-warning" name = "${subQuestion['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${subQuestion['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																																			</td>
																																			</c:when>
																																		<c:otherwise>
																																			<td width = "5%">
																																			</td>
																																			<td width = "7%">
																																			</td>
																																			<td width = "7%"> 
																																			</td>
																																			<td width = "5%" align="center">
																																				<button class="btn btn-primary" name = "${subQuestion['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${subQuestion['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																																			</td>
																																			<td width = "5%" align="center">
																																				<button class="btn btn-warning" name = "${subQuestion['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${subQuestion['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																																			</td>
																																		</c:otherwise>
																																	</c:choose>				
																																</tr>
																															</c:forEach>
																														</tbody>
																													</table>
																												</div>
																											</div>
																										
																									</td>
																								</tr>
																							</table>
																						</td>
																					</c:when>
																					<c:otherwise>
																						<td style="width:1%;background-color:${rowColor }" id = "${question['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${question['QUESTIONID']}" name = "${question['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																						</td >
																						<td width = "10%">
																							${question.QUESTIONID }
																						</td>
																						<td width = "45%">
																							${question.QUESTION }
																						</td>
																						<td width = "10%">
																							<c:if test = "${question.INPUTTYPE eq 'select' }">
																								<select id = "${question['QUESTIONID'] }inputValue" class="form-control input-sm RAInputValue" name = "select||${question['QUESTIONID'] }||null||${formattedCategory}||${formattedSubCategory}||<c:if test = "${question['ISSUPERPARENT'] ne 'Y' }">${question['PARENTQSIDS']}</c:if>" onchange = "userInputChange(this)">
																									<option value = "0||1">Nothing Selected</option>
																									<c:forEach var = "option" items = "${f:split(question.INPUTOPTIONSLIST, '||') }">
																										<c:if test = "${f:split(option,'^')[0] ne 'null' }">
																											<option value = <c:out value = "${f:split(option,'^')[1] }||${f:split(option,'^')[2] }"/> <c:if test = "${f:split(option,'^')[1] eq question.QRESPONSES.QINPUT}">selected</c:if>>${f:split(option,'^')[0] } (${f:split(option,'^')[1]})</option>
																										</c:if>
																									</c:forEach>
																								</select>
																							</c:if>
																							<c:if test = "${question.INPUTTYPE eq 'numeric' }">
																								<input id = "${question['QUESTIONID'] }inputValue" value = "${question.QRESPONSES.QINPUT }" class="form-control input-sm RAInputValue" type = "number" name = "numeric||${question['QUESTIONID'] }^${f:replace(f:replace(question['INPUTOPTIONSLISTFORNUMERIC'],'||','%%'),'^','$') }||null||${formattedCategory}||${formattedSubCategory}||<c:if test = "${question['ISSUPERPARENT'] ne 'Y' }">${question['PARENTQSIDS']}</c:if>" onchange = "userInputChange(this)">
																							</c:if>
																							<c:if test = "${question.INPUTTYPE eq 'text' }">
																								<textarea class="form-control input-sm">${question.QRESPONSES.QINPUT }</textarea>
																							</c:if>
																							
																						</td>
																						<c:choose>
																							<c:when test = "${question.ISSUPERPARENT ne 'Y' && question.HASRISKIMPACT eq 'Y' }">
																								<td width = "5%">
																									<input id = "${question.QUESTIONID }result" class="form-control input-sm" value = "${question.QRESPONSES.QRESULT }" disabled>
																									<input  id = "${question.QUESTIONID }inherentRisk" class="form-control input-sm qsInherentRisk" value = "${question.QRESPONSES.QINHERENTRISK }" style = "display:none">
																								</td>
																								<td width = "7%">
																									<select class="form-control input-sm" id="${question.QUESTIONID }impactCriteria" disabled>
																										<!-- <option>Nothing Selected</option> -->
																										<option value = 1 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 1) || (question.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																										<option value = 2 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 2) || (question.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																										<option value = 3 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 3) || (question.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																													
																										
																									</select>
																								</td>
																								<td width = "7%">
																									<select class="form-control input-sm" id="${question.QUESTIONID }likelyhood" disabled>
																										<option value = 0 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 0) || (question.QRESPONSES.QIMPACTCRITERIA eq '0')}">selected</c:if>>NoRisk</option>
																										<option value = 1 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 1) || (question.QRESPONSES.QIMPACTCRITERIA eq '1')}">selected</c:if>>Low</option>
																										<option value = 2 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 2) || (question.QRESPONSES.QIMPACTCRITERIA eq '2')}">selected</c:if>>Medium</option>
																										<option value = 3 <c:if test = "${(question.QRESPONSES.QIMPACTCRITERIA eq 3) || (question.QRESPONSES.QIMPACTCRITERIA eq '3')}">selected</c:if>>High</option>
																													
																									</select>
																								</td>
																								<td width = "5%" align="center">
																									<button class="btn btn-primary" name = "${question['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${question['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																								</td>
																								<td width = "5%" align="center">
																									<button class="btn btn-warning" name = "${question['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${question['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																								</td>
																							</c:when>
																							<c:otherwise>
																								<td width = "5%">
																									
																								</td>
																								<td width = "7%">
																									
																								</td>
																								<td width = "7%">
																									
																								</td>
																								<td width = "5%" align="center">
																									<button class="btn btn-primary" name = "${question['QUESTIONID']}||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActionsNew.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI"  id="raiseToRFIIndividual${question['QUESTIONID']}"><i class="fa fa-paper-plane-o" style = "font-size:15px;"></i></button> 
																								</td>
																								<td width = "5%" align="center">
																									<button class="btn btn-warning" name = "${question['QUESTIONID'] }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${question['QUESTIONID']}" onclick="rfiCaseWorkFlowActionsNew.handleViewComments(this)"><i class="fa fa-comments-o" style = "font-size:15px;"></i></button>
																								</td>
																							</c:otherwise>
																						</c:choose>
																					
																						
																					</c:otherwise>
																				
																				</c:choose>
																				
																				
																			</tr>
																		</c:forEach>
																		<tr >
																			<td colspan = 4> </td>
																			<th colspan = 2 style = "padding-top: 1%;">${subCategory } inherent</th>
																			<td colspan = 3><input class = "form-control input-sm ${formattedCategory }SectionInherentRisk" id = "${formattedCategory }${formattedSubCategory }inherentRisk" disabled value = "${ QUESTIONSFORMDETAILS.categSubcategInherentRiskRatings[category][subCategory]}" /></td>
																		</tr>
																	</tbody>
																	
																</table>
																</c:if>
																
															</div>
														</div>
													</div>
												</c:forEach>
											<!-- </div> -->
											
										</div>
										<div class="card-search-card">
										<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
												<tbody>
														<tr>
															<td width="25%">
																System Generated Risk Rating
															</td>
															<%-- <td width="20%" style="text-align: center;">	
																<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">Calculate</button>
															</td> --%>
															<td width = "20%">
															</td>
															<td width="5%">&nbsp;</td>
															<td colspan="3">
																<input type="text" class="form-control input-sm"  readonly="readonly" 
																       name="CUSTOMER_SYSTEMRISKRATING" id="${formattedCategory }systemGeneratedRisk" 
																      value="${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['SYSGENRISKRATING']}"/>
															</td>
														</tr>
														<tr>
															<td width="25%">
																Provisional Risk Rating
															</td>
															<td width="20%">
																<input type="text" readonly="readonly" class="form-control input-sm" name="CUSTOMER_PROVISIONALRISKRATING" 
																       id="${formattedCategory }provisionalRisk" value="${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['PROVRISKRATING']}">
															</td>
															<td width="5%">&nbsp;</td>
															<td width="25%">
																Final Risk Rating
															</td>
															<td colspan = 2>
																<input type="text" readonly="readonly" class="form-control input-sm" name="CUSTOMER_PROVISIONALRISKRATING" 
																       id="${formattedCategory }finalRisk"  value = "${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['FINALRISKRATING']}">
															</td>
															<%-- <td width="10%">
																<select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING1" id="CUSTOMER_FINALRISKRATING1${UNQID}"
																	onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
																	<c:forEach var="i" begin="0" end="9">
																		<option value="${i}" <c:if test="${custFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
																	</c:forEach>
																</select>
															</td>
															<td width="10%">
																 <select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING2" id="CUSTOMER_FINALRISKRATING2${UNQID}"
																		onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
																	<c:forEach var="i" begin="00" end="99">
																		<option value=".${i}" <c:if test="${custFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
																	</c:forEach>
																</select>
															</td> --%>
														</tr>
														<tr>
															<td width="25%">
																Reason(s) for Deviations between Provisional and Final Risk Rating
															</td>
															<td colspan="5">
																<textarea rows="2" cols="2" class="form-control" name="CUSTOMER_RISKRATINGREASON" id="CUSTOMER_RISKRATINGREASON${UNQID}" disabled>${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['REASONFORDEVIATION']}</textarea>
															</td>
														</tr>
												</tbody>
											</table>
											<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS != 'CMM-A'}">
												<div class="card-footer clearfix">
													<div class="pull-${dirR}">
														<%-- <button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P">Save</button> --%>
														<button type="button" name="raiseToRFIBulk||QForm||${COMPASSREFERENCENO}" id="raiseToRFIBulk${UNQID}" class="btn btn-primary btn-sm" onclick="handleRaiseToRFIBulk(this)" value="CMO-P">Raise to RFI</button>
														<%-- <button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button>
													 --%>
													 </div>
												</div>
											</c:if>
										</div>
									</div>
								</div>
							</div>
							
						</c:forEach>
						
						<div role="tabpanel" class="tab-pane fade in" id="controlsReviewNew" >
							<div class="row">
								<div class="col-sm-12">
									<div class="">
										<div id=<c:out value="controlsReviewDetailsNew"/>>
												<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg.subCategories }">
												<c:set var = "formattedCategory" value = "${f:replace(f:replace(f:replace(f:replace(f:replace(f:replace(category,'&',''),'&amp;',''),')',''),'(',''),'/',''),' ','')}"/>
													<div class="card card-primary panel_RiskAssessmentForm" >
														<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
															<h6 class="card-title" style = "font-weight:bold">${category}</h6>
														</div>
														<div class="panelSearchForm">
															<div class="card-search-card" style="padding-bottom:10px">
																<c:forEach var = "subCategory" items = "${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg.subAndSubSubCateg[category] }">
																<c:set var = "formattedSubCategory" value = "${f:replace(f:replace(f:replace(f:replace(f:replace(f:replace(subCategory,'&',''),'&amp;',''),')',''),'(',''),'/',''),' ','')}"/>
																	<div class="card card-primary panel_RiskAssessmentForm" style="width:98%;margin:auto;margin-top: 10px;">
																		<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
																			<h6 class="card-title pull-${dirL}" >${subCategory}</h6>
																		</div>
																		<div class="panelSearchForm">
																			<div class="card-search-card"  >
																				<c:if test = "${f:length(QUESTIONSFORMDETAILS.controlsReviewQuestions[category][subCategory]) > 0}">
																					<table class="table " id = "${formattedCategory }||${formattedSubCategory }||table" style="width:100%;margin-bottom: 0px;border-collapse:collapse;">
																						<tbody>	
																								<tr style="background-color:#ddd">
																									<td width = "1%" style = ""></td>
																									<td width = "10%" style="font-weight:bold;">Question Id</td>
																									<td width = "30%" style="font-weight:bold;">Question</td>
																									<td width = "12%" style="font-weight:bold;">Question Input</td>
																									<td width = "12%" style="font-weight:bold;">Design Rating</td>
																									<td width = "12%" style="font-weight:bold;">Operating Rating</td>
																									<td width = "12%" style="font-weight:bold;">Observation</td>
																									<td  style="text-align:center;font-weight:bold;" colspan = '2'>Documents Referred / Sample Testing</td>
																								</tr>  
																								<!-- <tr>
																									<td width = "1%"> </td>
																									<td width = "10%"> </td>
																									<td width = "30%"> </td>
																									<td width = "12%%"> </td>
																									<td width = "12%%"> </td>
																									<td width = "12%%"> </td>
																									<td width = "12%%"> </td>
																									<td width = "11%%"> </td>
																								</tr> -->
																								
																								<c:forEach var = "question" items = "${QUESTIONSFORMDETAILS.controlsReviewQuestions[category][subCategory]}">
																									<c:set var = "checkboxState" value = "disabled"></c:set>
																			
																									<c:if test = "${question['RFISTATUS'] eq 'PE'}">
																										<c:set var = "rowColor" value = "#FF7F7F"></c:set>
																									</c:if>
																									<c:if test = "${question['RFISTATUS'] eq 'IP'}">
																										<c:set var = "rowColor" value = "lightyellow"></c:set>
																									</c:if>
																									<c:if test = "${question['RFISTATUS'] eq 'CO'}">
																										<c:set var = "rowColor" value = "lightgreen"></c:set>
																									</c:if>
																									<c:if test = "${question['RFISTATUS'] eq 'NA'}">
																										<c:set var = "rowColor" value = "transparent"></c:set>
																										<c:set var = "checkboxState" value = ""></c:set>
																									</c:if>
																									
																									<tr >
																										<c:choose>
																											<c:when test = "${f:length(question.SUBQUESTIONLIST) > 0 }">
																												<td colspan = 9  style = "padding:0">
																													<table>
																														<!-- <tr style="background-color:#ddd">
																															<th ></th>
																															<th >Question Id</th>
																															<th >Question</th>
																															<th >Question Input</th>
																															<th >Design rating</th>
																															<th >Operating Rating</th>
																															<th >Observation</th>
																															<th colspan=2 style="text-align:center">Documents Referred / Sample Testing</th>
																														</tr>  -->
																														<tr>
																															<td style="width:1%;background-color:${rowColor }" id = "${question['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${question['QUESTIONID']}" name = "${question['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																															</td >
																															<td width = "10%">
																																${question.QUESTIONID } 
																																<div class="btn-group pull-right clearfix">
																																	<span class="pull-right" onclick="handleSlidingPanels(this,'${UNQID}','${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}')"><i class="collapsable${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID} fa fa-chevron-up" style = "font-size:15px;"></i></span>
																																</div>
																															</td>
																															<td width = "30%">
																																${question.QUESTION }
																															</td>
																															<td width = "12%">
																																<c:if test = "${question.HASPARENT eq 'Y' }">
																																<textarea class="form-control input-sm ${formattedCategory}Qinput" id="${question.QUESTIONID }qInput" name="${question.QUESTIONID }||QINPUT||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QINPUT }</textarea>
																																</c:if>
																															</td>
																															<td width = "12%">
																																<select class="form-control input-sm ${formattedCategory}designRating" id="${question.QUESTIONID }desinRating" name="${question.QUESTIONID }||QDESIGNRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																																	<!-- <option>Nothing Selected</option> -->
																																	<option value = 'NA' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NA'}">selected</c:if>>NA</option>
																																	<option value = 'E' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'E'}">selected</c:if>>E</option>
																																	<option value = 'NI' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NI'}">selected</c:if>>NI</option>
																																	<option value = 'NC' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NC'}">selected</c:if>>NC</option>
																																	
																																</select>
																															</td>
																															<td width = "12%">
																																<select class="form-control input-sm ${formattedCategory}operatingRating" id="${question.QUESTIONID }operatingRating" name="${question.QUESTIONID }||QOPERATINGRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																																	
																																	<option value = 'NA' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NA'}">selected</c:if>>NA</option>
																																	<option value = 'E' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'E'}">selected</c:if>>E</option>
																																	<option value = 'NI' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NI'}">selected</c:if>>NI</option>
																																	<option value = 'NC' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NC'}">selected</c:if>>NC</option>
																														
																																	
																																</select>
																															</td>
																															<td width = "12%">
																																
																																<textarea class="form-control input-sm ${formattedCategory}observation" id="${question.QUESTIONID }observation" name="${question.QUESTIONID }||QOBSERVATION||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QOBSERVATION }</textarea>
																																
																															</td>
																															<td colspan = '2'>
																																
																																<textarea class="form-control input-sm ${formattedCategory}docRefSamTesting" id="${question.QUESTIONID }docRefSamTesting" name="${question.QUESTIONID }||QDOCREFSAMTESTING||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QDOCREFSAMTESTING }</textarea>
																																
																															</td>
																															
																														</tr>
																														<tr>
																															<td colspan = 9 style="padding:0">
																																<div class = "subQuestionSlididngPanel" id="${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}" class="${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}" >
																																		
																																		<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
																																		
																																			<table class="" style="margin-bottom: 0px;border-collapse:collapse;">
																																				<tbody>
																																						 <tr style="background-color:#d9edf7">
																																							<th></th>
																																							<th>Question Id</th>
																																							<th>Question</th>
																																							<th>Question Input</th>
																																							<th></th>
																																							<th></th>
																																							<th></th>
																																							<th colspan=2 style="text-align:center"></th>
																																						</tr> 
																																					<c:forEach var = "subQuestion" items = "${question['SUBQUESTIONLIST']}">
																																						<c:set var = "checkboxState" value = "disabled"></c:set>
																			
																																						<c:if test = "${subQuestion['RFISTATUS'] eq 'PE'}">
																																							<c:set var = "rowColor" value = "#FF7F7F"></c:set>
																																						</c:if>
																																						<c:if test = "${subQuestion['RFISTATUS'] eq 'IP'}">
																																							<c:set var = "rowColor" value = "lightyellow"></c:set>
																																						</c:if>
																																						<c:if test = "${subQuestion['RFISTATUS'] eq 'CO'}">
																																							<c:set var = "rowColor" value = "lightgreen"></c:set>
																																						</c:if>
																																						<c:if test = "${subQuestion['RFISTATUS'] eq 'NA'}">
																																							<c:set var = "rowColor" value = "transparent"></c:set>
																																							<c:set var = "checkboxState" value = ""></c:set>
																																						</c:if>
																																						
																																						<tr>
																																							<td style="width:1%;background-color:${rowColor }" id = "${subQuestion['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${subQuestion['QUESTIONID']}" name = "${subQuestion['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																																							</td >
																																							<td width = "10%">
																																								${subQuestion.QUESTIONID } 
																																								<%-- <div class="btn-group pull-right clearfix">
																																									<span class="pull-right" onclick="handleSlidingPanels(this,'${UNQID}','${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}')"><i class="collapsable${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID} fa fa-chevron-up" style = "font-size:15px;"></i></span>
																																								</div> --%>
																																							</td>
																																							<td width = "30%">
																																								${subQuestion.QUESTION }
																																							</td>
																																							<td width = "12%">
																																								<c:if test = "${subQuestion.HASPARENT eq 'Y' }">
																																									<textarea class="form-control input-sm ${formattedCategory}Qinput" id="${subQuestion.QUESTIONID }qInput" name="${subQuestion.QUESTIONID }||QINPUT||${formattedCategory}" onChange = "handleCRInputChange(this)">${subQuestion.QRESPONSES.QINPUT }</textarea>
																																								</c:if>
																																							</td>
																																							<td width = "12%">
																																								<%-- <select class="form-control input-sm ${formattedCategory}designRating" id="${question.QUESTIONID }desinRating" name="${question.QUESTIONID }||QDESIGNRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																																									<!-- <option>Nothing Selected</option> -->
																																									<option value = 'NA' selected>NA</option>
																																									<option value = 'E'>E</option>
																																									<option value = 'NI'>NI</option>
																																									<option value = 'NC'>NC</option>
																																									
																																								</select> --%>
																																							</td>
																																							<td width = "12%">
																																								<%-- <select class="form-control input-sm ${formattedCategory}operatingRating" id="${question.QUESTIONID }operatingRating" name="${question.QUESTIONID }||QOPERATINGRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																																									
																																									<option value = 'NA' selected>NA</option>
																																									<option value = 'E'>E</option>
																																									<option value = 'NI'>NI</option>
																																									<option value = 'NC'>NC</option>
																																									
																																								</select> --%>
																																							</td>
																																							<td width = "12%">
																																								
																																								<%-- <textarea class="form-control input-sm ${formattedCategory}observation" id="${question.QUESTIONID }observation" name="${question.QUESTIONID }||QOBSERVATION||${formattedCategory}" onChange = "handleCRInputChange(this)"/>
																																								 --%>
																																							</td>
																																							<td colspan = 2>
																																								<%-- 
																																								<textarea class="form-control input-sm ${formattedCategory}docRefSamTesting" id="${question.QUESTIONID }docRefSamTesting" name="${question.QUESTIONID }||QDOCREFSAMTESTING||${formattedCategory}" onChange = "handleCRInputChange(this)"/>
																																								 --%>
																																							</td>
																																							
																																						</tr>
																																					</c:forEach>
																																				</tbody>
																																			</table>
																																		</div>
																																	</div>
																																
																															</td>
																														</tr>
																													</table>
																												</td>
																											</c:when>
																											<c:otherwise>
																												
																												
																												<td style="width:1%;background-color:${rowColor }" id = "${question['QUESTIONID']}"><input type="checkbox" ${checkboxState } id = "chk${question['QUESTIONID']}" name = "${question['QUESTIONID']}"  onchange="rfiCaseWorkFlowActionsNew.handleCheckBoxChange(this)"/>
																												</td >
																												<td width = "10%">
																													${question.QUESTIONID } 
																													<%-- <div class="btn-group pull-right clearfix">
																														<span class="pull-right" onclick="handleSlidingPanels(this,'${UNQID}','${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID}')"><i class="collapsable${f:replace(question['QUESTIONID'],'.','SQ')}slidingQuestionDetails${UNQID} fa fa-chevron-up" style = "font-size:15px;"></i></span>
																													</div> --%>
																												</td>
																												<td width = "30%">
																													${question.QUESTION }
																												</td>
																												<td width = "12%">
																													<c:if test = "${question.HASPARENT eq 'Y' }">
																													<textarea class="form-control input-sm ${formattedCategory}Qinput" id="${question.QUESTIONID }qInput" name="${question.QUESTIONID }||QINPUT||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QINPUT }</textarea>
																													</c:if>
																												</td>
																												<td width = "12%">
																													<select class="form-control input-sm ${formattedCategory}designRating" id="${question.QUESTIONID }desinRating" name="${question.QUESTIONID }||QDESIGNRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																														<!-- <option>Nothing Selected</option> -->
																														<option value = 'NA' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NA'}">selected</c:if>>NA</option>
																														<option value = 'E' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'E'}">selected</c:if>>E</option>
																														<option value = 'NI' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NI'}">selected</c:if>>NI</option>
																														<option value = 'NC' <c:if test = "${question.QRESPONSES.QDESIGNRATING eq 'NC'}">selected</c:if>>NC</option>
																														
																													</select>
																												</td>
																												<td width = "12%">
																													<select class="form-control input-sm ${formattedCategory}operatingRating" id="${question.QUESTIONID }operatingRating" name="${question.QUESTIONID }||QOPERATINGRATING||${formattedCategory}" onChange = "handleCRInputChange(this)">
																														
																														<option value = 'NA' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NA'}">selected</c:if>>NA</option>
																														<option value = 'E' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'E'}">selected</c:if>>E</option>
																														<option value = 'NI' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NI'}">selected</c:if>>NI</option>
																														<option value = 'NC' <c:if test = "${question.QRESPONSES.QOPERATINGRATING eq 'NC'}">selected</c:if>>NC</option>
																														
																													</select>
																												</td>
																												<td width = "12%">
																													
																													<textarea class="form-control input-sm ${formattedCategory}observation" id="${question.QUESTIONID }observation" name="${question.QUESTIONID }||QOBSERVATION||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QOBSERVATION }</textarea>
																													
																												</td>
																												<td colspan = 2>
																													
																													<textarea class="form-control input-sm ${formattedCategory}docRefSamTesting" id="${question.QUESTIONID }docRefSamTesting" name="${question.QUESTIONID }||QDOCREFSAMTESTING||${formattedCategory}" onChange = "handleCRInputChange(this)">${question.QRESPONSES.QDOCREFSAMTESTING }</textarea>
																													
																												</td>
																												
																										</c:otherwise>
																										</c:choose>
																														
																										
																										
																									</tr>
																								</c:forEach>
																								
																						</tbody>
																					</table>
																				</c:if>
																			</div>
																		</div>
																	</div>
																</c:forEach>
															</div>
														</div>
													</div>
													
												</c:forEach>
												
											</div>
											
										
										<%-- <div class="card-search-card">
										<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
												<tbody>
														<tr>
															<td width="25%">
																System Generated Risk Rating
															</td>
															<td width="20%" style="text-align: center;">	
																<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">Calculate</button>
															</td>
															<td width="5%">&nbsp;</td>
															<td colspan="3">
																<input type="text" class="form-control input-sm"  readonly="readonly" 
																       name="CUSTOMER_SYSTEMRISKRATING" id="CUSTOMER_SYSTEMRISKRATING${UNQID}" 
																      value="${CUSTOMERRISKTABDATA['CUSTOMERSYSTEMGENRISK']}"/>
															</td>
														</tr>
														<tr>
															<td width="25%">
																Provisional Risk Rating
															</td>
															<td width="20%">
																<input type="text" readonly="readonly" class="form-control input-sm" name="CUSTOMER_PROVISIONALRISKRATING" 
																       id="CUSTOMER_PROVISIONALRISKRATING${UNQID}" value="${CUSTOMERRISKTABDATA['CUSTOMERPROVISRISK']}">
															</td>
															<td width="5%">&nbsp;</td>
															<td width="25%">
																Final Risk Rating
															</td>
															<td width="10%">
																<select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING1" id="CUSTOMER_FINALRISKRATING1${UNQID}"
																	onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
																	<c:forEach var="i" begin="0" end="9">
																		<option value="${i}" <c:if test="${custFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
																	</c:forEach>
																</select>
															</td>
															<td width="10%">
																 <select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING2" id="CUSTOMER_FINALRISKRATING2${UNQID}"
																		onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
																	<c:forEach var="i" begin="00" end="99">
																		<option value=".${i}" <c:if test="${custFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
																	</c:forEach>
																</select>
															</td>
														</tr>
														<tr>
															<td width="25%">
																Reason(s) for Deviations between Provisional and Final Risk Rating
															</td>
															<td colspan="5">
																<textarea rows="2" cols="2" class="form-control" name="CUSTOMER_RISKRATINGREASON" id="CUSTOMER_RISKRATINGREASON${UNQID}">${CUSTOMERRISKTABDATA['CUSTOMERREMARKS']}</textarea>
															</td>
														</tr>
												</tbody>
											</table>
										</div> --%>
										<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS != 'CMM-A'}">
											<div class="card-footer clearfix">
												<div class="pull-${dirR}">
													<%-- <button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P">Save</button> --%>
													<button type="button" name="raiseToRFIBulk||QForm||${COMPASSREFERENCENO}" id="raiseToRFIBulk${UNQID}" class="btn btn-primary btn-sm" onclick="handleRaiseToRFIBulk(this)" value="CMO-P">Raise to RFI</button>
													<%-- <button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button>
												 --%>
												 </div>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="riskRatingNew" >
							<div class="row">
								<div class="col-sm-12">
									<div class="">
										<div id="riskRatingDetailsNew">
											<div class="card card-primary panel_RiskCalculationForm" style=" margin-bottom: 0;">	
												<div class="card-search-card" >
													<table class="table table-striped formSearchTable riskMatrixForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
														<%-- <c:set var="residualFinalRiskVal" value="${f:split(RISKTABDATA['RESIDUALFINALRISK'], ' - ')}"></c:set> --%>
														<c:set var="residualFinalRiskRating" value="${f:split(RISKTABDATA['RESIDUALFINALRISK'], '.')}"></c:set>
														<tbody>
																<tr class="info">
																	<td colspan="5" style="text-align: left; font-weight: bolder;">
																		Inherent Risk Ratings
																	</td>
																</tr>
																<tr style="text-align: left; font-weight: bolder;">
																	<td width="30%">
																		Unit
																	</td>
																	<td width="10%">&nbsp;</td>
																	<td width="20%">
																		 System Generated Risk Rating
																	</td>
																	<td width="20%">
																		 Provisional Risk Rating
																	</td>
																	<td width="20%">
																		 Final Risk 
																	</td>
																</tr>
																<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.categoryList}">
																	<c:set var = "formattedCategory" value = "${f:replace(f:replace(f:replace(f:replace(f:replace(f:replace(category,'&amp;',''),'&',''),')',''),'(',''),'/',''),' ','')}"/>
																		
																	<tr>
																		<td width="30%">
																			${category }
																		</td>
																		<td width="10%">&nbsp;</td>
																		<td width="20%">
																			 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "${formattedCategory }SysGenResidualRisk" value="${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['SYSGENRISKRATING']}">
																		</td>
																		<td width="20%">
																			 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "${formattedCategory }ProvResidualRisk" value="${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['PROVRISKRATING']}">
																		</td>
																		<td width="20%">
																			<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "${formattedCategory }FinalResidualRisk" value = "${QUESTIONSFORMDETAILS.categoryRiskRatings[category]['FINALRISKRATING']}">
																		</td>
																	</tr>
																</c:forEach>
																
																<%-- <tr>
																	<td width="30%">
																		Total Inherent Units Risk Rating
																	</td>
																	<td width="10%">&nbsp;</td>
																	<td>
																	 	<input type="text" readonly="readonly" class="form-control input-sm" 
																	 		name ="TOTAL_INHERENTSYSTEMRISKRATING" id = "totalInherentUnitsSysRiskRating"
																		 value="${RISKTABDATA['TOTINHSYSGENRISK']}">
																	</td>
																	<td>
																		 <input type="text" readonly="readonly" class="form-control input-sm" 
																		 	name ="TOTAL_INHERENTPROVRISKRATING" id = "totalInherentUnitsProvRiskRating"
																		 value="${RISKTABDATA['TOTINHPROVISRISK']}">
																	</td>
																	<td>
																		 <input type="text" readonly="readonly" class="form-control input-sm" 
																		 name ="TOTAL_INHERENTFINALRISKRATING" id = "totalInherentUnitsFinalRiskRating"
																		 value="${RISKTABDATA['TOTINHFINALRISK']}">
																	</td>
																</tr> --%>
																<tr class="info">
																	<td colspan="5" style="text-align: left; font-weight: bolder;">
																		Internal Control Risk Ratings
																	</td>
																</tr>
																<tr style="text-align: left; font-weight: bolder;">
																	<td width="30%">
																		Unit
																	</td>
																	<td width="10%">&nbsp;</td>
																	<td width="20%">
																		 System Generated Risk Rating
																	</td>
																	<td width="20%">
																		 Provisional Risk Rating
																	</td>
																	<td width="20%">
																		 Final Risk 
																	</td>
																</tr>
																<c:forEach var = "category" items = "${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg.subCategories}">
																	<c:set var = "formattedCategory" value = "${f:replace(f:replace(f:replace(f:replace(f:replace(f:replace(category,'&',''),'&amp;',''),')',''),'(',''),'/',''),' ','')}"/>
																		
																	<tr>
																		<td width="30%">
																			${category }
																		</td>
																		<td width="10%">&nbsp;</td>
																		<td width="20%">
																			 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "${formattedCategory }CRSysGenResidualRisk" value = "${QUESTIONSFORMDETAILS.crCategoryRiskRatings[category]['SYSGENRISKRATING']}" >
																		</td>
																		<td width="20%">
																			 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "${formattedCategory }CRProvResidualRisk" value = "${QUESTIONSFORMDETAILS.crCategoryRiskRatings[category]['PROVRISKRATING']}">
																		</td>
																		<td width="20%">
																			<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "${formattedCategory }CRFinalResidualRisk" value = "${QUESTIONSFORMDETAILS.crCategoryRiskRatings[category]['FINALRISKRATING']}">
																		</td>
																	</tr>
																</c:forEach>
																
																
															</tbody>
														</table>
													</div>
													<div class="card-search-card" >
														<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
															<tbody>
																<tr>
																	<td>
																		<div class="card card-primary">
																			<div class="card card-primary riskCalculationResult_Panel" style="margin-top:0; margin-bottom: 0;">
																				<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
																					<h6 class="card-title pull-${dirL}" >Overview</h6>
																				</div>
																				<div class="card-search-card" >
																					<table class="table table-striped formSearchTable riskCalculationResult${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
																						<tr>
																							<td width="25%">
																								Total Inherent Risk Rating
																							</td>
																							<td width="20%">
																								<input type="text" readonly="readonly" class="form-control input-sm" name="totalInherentRiskRating" 
																								       id="totalInherentRiskRating" value="">
																							</td>
																							<td width="5%">&nbsp;</td>
																							<td width="25%">
																								Result
																							</td>
																							<td width="10%">
																								<input type="text" readonly="readonly" class="form-control input-sm" name="totalInherentRiskRatingResult" 
																								       id="totalInherentRiskRatingResult" value="">
																							</td>
																							
																						</tr>
																						<tr>
																							<td width="25%">
																								Total Internal Control Risk Rating
																							</td>
																							<td width="20%">
																								<input type="text" readonly="readonly" class="form-control input-sm" name="totalInternalControlRiskRating" 
																								       id="totalInternalControlRiskRating" value="">
																							</td>
																							<td width="5%">&nbsp;</td>
																							<td width="25%">
																								Result
																							</td>
																							<td width="10%">
																								<input type="text" readonly="readonly" class="form-control input-sm" name="totalInternalControlRiskRatingResult" 
																								       id="totalInternalControlRiskRatingResult" value="">
																							</td>
																						</tr>
																					</table>
																				</div>
																			</div>
																		</div>
																	</td>
																<tr>
															</tbody>
														</table>
													</div>
												</div>
									</div>
								</div>
							</div>
						</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="statusApprovalsNew" >
							<div class="row">
								<div class="col-sm-12">
									<div class="">
										<table class="table table-striped" id="statusTable${UNQID}" style="margin-bottom: 0px;">
											<tr>
												<td>Form Status</td>
												<td>
													<c:set var = "STATUS" value = "${QUESTIONSFORMDETAILS.generalAndstatusDetails.FORMSTATUS}"/>
													<c:choose>
														<c:when test="${STATUS eq 'CMO-P'}">
															Pending with CM Officer
														</c:when>
														<c:when test="${STATUS eq 'CMM-P'}">
															Pending with CM Manager
														</c:when>
														<c:when test="${STATUS eq 'CMM-R'}">
															Rejected by CM Manager
														</c:when>
														<c:when test="${STATUS eq 'CMM-A'}">
															Approved by CM Manager. Risk Assessment Complete.
														</c:when>
														<c:otherwise>
															In Progress
														</c:otherwise>
													</c:choose>
												</td>
												<td colspan="3">&nbsp;</td>
												
											</tr>
											<tr>
												<td width="15%">
													CM Officer Code
												</td>
												<td width="33%">
													<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMOFFICERCODE" id="STATUS_CMOFFICERCODE" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMOFFICERCODE}" />
												</td>
												<td width="4%">&nbsp;</td>
												<td width="15%">
													CM Officer Timestamp
												</td>
												<td width="33%">
													<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMOFFICERTIMESTAMP" id="STATUS_CMOFFICERTIMESTAMP" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMOFFICERTIMESTAMP}"/>
												</td>
											</tr>
											<tr>
												<td width="15%">
													CM Officer Comments
												</td>
												<td colspan="4">
													<textarea rows="2" cols="2" class="form-control" name="CMOFFICERCOMMENTS" id="STATUS_CMOFFICERCOMMENTS" onchange="handleFormGeneralDataChange(this)">${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMOFFICERCOMMENTS}</textarea>
												</td>
											</tr>
											<tr>
												<td width="15%">
													CM Manager Code
												</td>
												<td width="33%">
													<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMMANAGERCODE" id="STATUS_CMMANAGERCODE" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMMANAGERCODE}"/>
												</td>
												<td width="4%">&nbsp;</td>
												<td width="15%">
													CM Manager Timestamp
												</td>
												<td width="33%">
													<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMMANAGERTIMESTAMP" id="STATUS_CMMANAGERTIMESTAMP" value="${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMMANAGERTIMESTAMP}"/>
												</td>
											</tr>
											<tr>
												<td width="20%">
													CM Manager Comments
												</td>
												<td colspan="4">
													<textarea rows="2" cols="2" class="form-control" <c:if test="${CURRENTROLE ne 'ROLE_CM_MANAGER' }">readonly</c:if> name="CMMANAGERCOMMENTS" id="STATUS_CMMANAGERCOMMENTS" onchange="handleFormGeneralDataChange(this)">${QUESTIONSFORMDETAILS.generalAndstatusDetails.CMMANAGERCOMMENTS}</textarea>
												</td>
											</tr>
										</table>
										<br/>
										<div id="searchResultGenericDiv">
											<table class="table table-bordered table-striped searchResultGenericTable CMStatus${UNQID}" style="margin-bottom: 0px;">
												<thead>
													<tr>
														<th width="15%">User Name</th>
														<th width="10%">User Role</th>
														<!-- <th width="10%">Status</th> -->
														<th width="15%">Timestamp</th>
														<th width="40%">Comments</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="AUDITLOGLIST" items="${QUESTIONSFORMDETAILS.formCommentLogs}">
														<tr>
															<td>${AUDITLOGLIST['USERNAME']}</td>
															<td>${AUDITLOGLIST['USERROLE']}</td>
															<%-- <td>${AUDITLOGLIST['STATUS']}</td> --%>
															<td>${AUDITLOGLIST['TIMESTAMP']}</td>
															<td>${AUDITLOGLIST['COMMENTS']}</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
										<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS ne 'CMM-A'}">
											<div class="card-footer clearfix">
												<div class="pull-${dirR}">
													<button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P" onclick = "handleSaveForm(this)">Save</button>
													<%-- <button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button> --%>
												</div>
											</div>
										</c:if>
										<c:if test="${CURRENTROLE eq 'ROLE_CM_MANAGER' && STATUS eq 'CMM-P'}">
											<div class="card-footer clearfix">
												<div class="pull-${dirR}">
													<button type="button" name="saveRiskAssessment" class="btn btn-success btn-sm" id="approveRiskAssessment${UNQID}" onclick = "handleSaveForm(this)" value="CMM-A">Approve</button>
													<button type="button" name="saveRiskAssessment" class="btn btn-danger btn-sm" id="rejectRiskAssessment${UNQID}" onclick = "handleSaveForm(this)" value="CMM-R">Reject</button>
												</div>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</div>
					
				</form>
				<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS != 'CMM-A'}">
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<%-- <button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P">Save</button> --%>
							<%-- <button type="button" name="raiseToRFIBulk||QForm||${COMPASSREFERENCENO}" id="raiseToRFIBulk${UNQID}" class="btn btn-primary btn-sm" onclick="handleRaiseToRFIBulk(this)" value="CMO-P">Raise to RFI</button>
							 --%>
							 <button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" onclick = "handleSaveForm(this)" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button>
						</div>
					</div>
				</c:if>
				
				
			</div>
		</div>
	</div>
</div>
