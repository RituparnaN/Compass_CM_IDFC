var riskAssessmentMaster = riskAssessmentMaster || (function () {
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	return {
		handleMultipleSelectInputChange:function(elm,unqId,toEditCategory,toEditSubCategory,qId){
			var names = []
			for (var option of document.getElementById(elm.name+qId).options) {
				if (option.selected) {
					names.push(option.value);
					
				}
			}
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toEditSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								//console.log(question['QUESTIONID']+":"+qId)
								if(question['QUESTIONID'] == qId){
									if(names.join(',').endsWith(","))
										question[elm.name] = names.join(',');
									else
										question[elm.name] = names.join(',')+",";
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditCategory+toEditSubCategory+"subCategLink"))
			/*document.getElementById(toEditCategory+"Link").click()
			document.getElementById(toEditCategory+toEditSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
			
		},
		handleInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId){
			
			
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toEditSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] == qId){
									question[elm.name] = elm.value;
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			

			
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditCategory+toEditSubCategory+"subCategLink"))
			
			$(".selectpicker").selectpicker();
			
			elm.scrollLeft = 10;
			elm.scrollTop = 0;
			
		},
		
		handleSubInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId){
			
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
						
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toEditSubCategory){
							questionsFormDetails[category][subCategory].forEach(question=>{
								/*if(question['QUESTIONID'] == qId){*/
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(q['QUESTIONID'] == qId){
											q[elm.name] = elm.value
										}
									})
								/*}*/
							})
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditCategory+toEditSubCategory+"subCategLink"))
			/*document.getElementById(toEditCategory+"Link").click()
			document.getElementById(toEditCategory+toEditSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		handleOptionsInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId,type = null){
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toEditSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] == qId){
									var newOptionList = [];
									var field = 'INPUTOPTIONSLIST'
									if(type != null){
										field = "INPUTOPTIONSLISTFORNUMERIC"
									}
									var optionsList = question[field].split("||")
									
									optionsList.forEach((option,i)=>{
										if(elm.name.split("||")[0] == i){
											var optionLabel = option.split("^")[0]
											var optionValue = option.split("^")[1]
											var impactCriteria = option.split("^")[2]
											if(elm.name.split("||")[1] == '0'){
												optionLabel = elm.value
											}
											if(elm.name.split("||")[1] == '1'){
												optionValue = elm.value
											}
											if(elm.name.split("||")[1] == '2'){
												impactCriteria = elm.value
											}
											newOptionList.push(optionLabel+"^"+optionValue+"^"+impactCriteria)
										}
										else{
											newOptionList.push(option)
										}
									})
									question[field] = newOptionList.join("||");
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditCategory+toEditSubCategory+"subCategLink"))
			/*document.getElementById(toEditCategory+"Link").click()
			document.getElementById(toEditCategory+toEditSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		handleOptionsSubInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId,type = null){
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toEditSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								/*if(question['QUESTIONID'] == qId){*/
									question["SUBQUESTIONLIST"].forEach(q=>{
										if(q['QUESTIONID'] == qId){
											
										var newOptionList = [];
										var field = 'INPUTOPTIONSLIST'
										if(type != null){
											field = "INPUTOPTIONSLISTFORNUMERIC"
										}
										var optionsList = q[field].split("||")
										
										optionsList.forEach((option,i)=>{
											if(elm.name.split("||")[0] == i){
												var optionLabel = option.split("^")[0]
												var optionValue = option.split("^")[1]
												var impactCriteria = option.split("^")[2]
												if(elm.name.split("||")[1] == '0'){
													optionLabel = elm.value
												}
												if(elm.name.split("||")[1] == '1'){
													optionValue = elm.value
												}
												if(elm.name.split("||")[1] == '2'){
													impactCriteria = elm.value
												}
												newOptionList.push(optionLabel+"^"+optionValue+"^"+impactCriteria)
											}
											else{
												newOptionList.push(option)
											}
										})
									q[field] = newOptionList.join("||");
									}
									})
								/*}*/
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditCategory+toEditSubCategory+"subCategLink"))
			/*document.getElementById(toEditCategory+"Link").click()
			document.getElementById(toEditCategory+toEditSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		
		addQuestion: function(elm,unqId,toAddCategory,toAddSubCategory,qsType,buttonPosition){
			var categoryPrefixes=['A','B','C','D','E','F','G']
			var subCategoryPrefixes=['a','b','c','d','e','f','g']
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach((category,categoryIndex)=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toAddCategory){
					categories[category].forEach((subCategory,subCategoryIndex)=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toAddSubCategory){
							var questionOrder = 1;
							if(questionsFormDetails[category][subCategory].length > 0){
									questionsFormDetails[category][subCategory].forEach(q=>{
										if(parseInt(q['QUESTIONID'].replace(categoryPrefixes[categoryIndex],"").replace(subCategoryPrefixes[subCategoryIndex],""))+1 > questionOrder){
											questionOrder = parseInt(q['QUESTIONID'].replace(categoryPrefixes[categoryIndex],"").replace(subCategoryPrefixes[subCategoryIndex],""))+1
										}
										
									})
								
								if(buttonPosition == "B"){
									
									//questionOrder = questionsFormDetails[category][subCategory].length+1
									var newQuestionObject = {
																"QUESTIONID":categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
																"ISSUPERPARENT":"N",
																"QUESTION":"",
																"INPUTTYPE":"numeric",
																"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																"HASRISKIMPACT":"Y",
																"HASPARENT":"N",
																"PARENTQSIDS":"",
																"SUBQUESTIONLIST": [],
																"DISABLED":"N",
																"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																"COMMENTS":"",
																"CREATEDBY":$("#userCode").html().trim(),
																"CREATEDON":$("#todayDate").html()}
									questionsFormDetails[category][subCategory].push(newQuestionObject);
								}
								else{
									//questionOrder = questionsFormDetails[category][subCategory].length+1
									var newQuestionObject = [{
																"QUESTIONID":categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
																"ISSUPERPARENT":"N",
																"QUESTION":"",
																"INPUTTYPE":"numeric",
																"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																"HASRISKIMPACT":"Y",
																"HASPARENT":"N",
																"PARENTQSIDS":"",
																"SUBQUESTIONLIST": [],
																"DISABLED":"N",
																"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																"COMMENTS":"",
																"CREATEDBY":$("#userCode").html().trim(),
																"CREATEDON":$("#todayDate").html()}]
									questionsFormDetails[category][subCategory].forEach(question=>{
										newQuestionObject.push(Object.assign({},question));
									})
									questionsFormDetails[category][subCategory] = newQuestionObject;
								}
									
							}
							else{
								var newQuestionObject = {
															"QUESTIONID":categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
															"ISSUPERPARENT":"N",
															"QUESTION":"",
															"INPUTTYPE":"numeric",
															"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
															"HASRISKIMPACT":"Y",
															"HASPARENT":"N",
															"PARENTQSIDS":"",
															"SUBQUESTIONLIST": [],
															"DISABLED":"N",
															"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
															"COMMENTS":"",
															"CREATEDBY":$("#userCode").html().trim(),
															"CREATEDON":$("#todayDate").html()}
								questionsFormDetails[category][subCategory].push(newQuestionObject);
							}
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toAddCategory+"Link",toAddCategory+toAddSubCategory+"subCategLink"))
			/*document.getElementById(toAddCategory+"Link").click()
			document.getElementById(toAddCategory+toAddSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			/*if(buttonPosition == "T")
				document.getElementById("addQuestionDiv1"+toAddCategory+toAddSubCategory).scrollIntoView();
			else
				document.getElementById("addQuestionDiv2"+toAddCategory+toAddSubCategory).scrollIntoView();*/
			
		},
		addSubQuestion: function(elm,unqId,toAddCategory,toAddSubCategory,qId){
			var categoryPrefixes=['A','B','C','D','E','F','G']
			var subCategoryPrefixes=['a','b','c','d','e','f','g']
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			Object.keys(categories).forEach((category,categoryIndex)=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toAddCategory){
					categories[category].forEach((subCategory,subCategoryIndex)=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toAddSubCategory){
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] == qId){
									var questionOrder = 1
									
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(parseInt(q['QUESTIONID'].split(".")[1])+1 > questionOrder){
											questionOrder = parseInt(q['QUESTIONID'].split(".")[1])+1
										}
										
									})
									
									question['SUBQUESTIONLIST'].push({
																	"QUESTIONID":qId+"."+questionOrder,
																	"ISSUPERPARENT":"N",
																	"QUESTION":"",
																	"INPUTTYPE":"select",
																	"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																	"HASRISKIMPACT":"Y",
																	"HASPARENT":"Y",
																	"PARENTQSIDS":elm.name+",",
																	"DISABLED":"N",
																	"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																	"COMMENTS":"",
																	"CREATEDBY":$("#userCode").html().trim(),
																	"CREATEDON":$("#todayDate").html()
																	 })
								}
							})
							
											
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toAddCategory+"Link",toAddCategory+toAddSubCategory+"subCategLink"))
			/*document.getElementById(toAddCategory+"Link").click()
			document.getElementById(toAddCategory+toAddSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
			
		},
		
		removeQuestion: function (elm,unqId,toRemoveCategory,toRemoveSubCategory,qId){
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toRemoveCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toRemoveSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] != qId){
									questionsList.push(Object.assign({},question));
								}
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toRemoveCategory+"Link",toRemoveCategory+toRemoveSubCategory+"subCategLink"))
			/*document.getElementById(toRemoveCategory+"Link").click()
			document.getElementById(toRemoveCategory+toRemoveSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		
		
		removeSubQuestion: function (elm,unqId,toRemoveCategory,toRemoveSubCategory,qId){
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var categories = JSON.parse($("#categoriesSubCategories").html())
			
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
				if(fcateg == toRemoveCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'')
						if(fSubCateg == toRemoveSubCategory){
							//console.log(questionsFormDetails[category][subCategory])
							questionsFormDetails[category][subCategory].forEach(question=>{
								//console.log(question)
								if(question['QUESTIONID'] == qId.split(".")[0]){
									var subQuestionsList = [];
									//console.log(question['SUBQUESTIONLIST'])
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(q['QUESTIONID'] != qId){
											
											subQuestionsList.push(Object.assign({},q));
										}
									})
								question['SUBQUESTIONLIST'] = subQuestionsList;
								}
							})
							
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toRemoveCategory+"Link",toRemoveCategory+toRemoveSubCategory+"subCategLink"))
			/*document.getElementById(toRemoveCategory+"Link").click()
			document.getElementById(toRemoveCategory+toRemoveSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		
		createParentQsOptionList: function(parentsList,qId,unqId,category,subCategory){
			var qIds = [];
			var qDesc = {};
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			Object.keys(categories).forEach(category=>{
				categories[category].forEach(subCategory=>{
					questionsFormDetails[category][subCategory].forEach(question=>{
						
						qIds.push(question['QUESTIONID'])
						qDesc[question['QUESTIONID']] = question['QUESTION']
						try{
							question['SUBQUESTIONLIST'].forEach(q=>{
								qIds.push(q['QUESTIONID'])
								qDesc[q['QUESTIONID']] = q['QUESTION']
							})
						}catch(e){}
					})
				})
			})
			
			var parentQsIds = []
			try{
				parentQsIds = parentsList.split(",");
			}
			catch(e){}
			var selectBody = `<tr>
									<td width="15%">Parent Questions List</td>
									<td width="30%">
										<select class="form-control input-sm selectpicker" name = 'PARENTQSIDS' id="PARENTQSIDS`+qId+`" multiple="multiple" onchange = "riskAssessmentMaster.handleMultipleSelectInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')")>`
			
			qIds.forEach(qId=>{
				
				if(parentQsIds.includes(qId)){
					selectBody += `<option value = '`+qId+`' selected>`+qId +'-'+qDesc[qId]+`</option>`
				}else{
					selectBody += `<option value = '`+qId+`'>`+qId +'-'+qDesc[qId]+`</option>`
					
				}
			})
											
								
			selectBody +=					`	</select>
									</td>
									<td width="10%"></td>
									<td width="15%"></td>
									<td width="30%">
									</td>
								</tr>`
			return selectBody;
			
		},
		createSubQuestionList: function(subQuesitonsList,qId,unqId,category,subCategory){
			var subQIds = [];
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			Object.keys(categories).forEach(category=>{
				categories[category].forEach(subCategory=>{
					questionsFormDetails[category][subCategory].forEach(question=>{
						
						subQIds.push(question['QUESTIONID'])
					})
				})
			})
			
			var parentQsIds = []
			try{
				parentQsIds = parentsList.split(",");
			}
			catch(e){}
			var subQuestionsBody = `<tr>
										<td colspan = 5 >`
			subQuesitonsList.forEach((question,i)=>{
				
			
					subQuestionsBody +=		`<div class="card card-primary questionDiv`+unqId+`" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header panelSlidingRiskAssessQs`+unqId+` clearfix" 
													id="`+question['QUESTIONID']+`slidingQuestionPanel`+unqId+`" data-toggle="collapse"
													onclick="handleSlidingPanels(this,'`+unqId+`','`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`')" style = "background-color:#f7b3ba">
													<h6 class="card-title pull-left">Sub Question Id:`+question['QUESTIONID']+`</h6>
													<div class="btn-group pull-right clearfix">
														<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
													</div>
												</div>
												<div id="`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`" class="`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`" >
													
														<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
														
															<table class="table table-striped">
																<tr style = "width:100%">
																	<td width="15%">Question</td>
																	<td colspan = 4>
																		<textarea type='text' name="QUESTION" onchange = "riskAssessmentMaster.handleSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||question`+`" class='form-control input-sm'>`+question['QUESTION']+`</textarea>
																	</td>
																</tr>
																<tr>
																	<td width="15%">Input Type</td>
																	<td colspan = 4>
																		<select class="form-control input-sm" name = 'INPUTTYPE' onchange = "riskAssessmentMaster.handleSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||inputType`+`">
																			<option value = '' selected>Please Select</option>`
																			if(question['INPUTTYPE'] == 'select'){
																				subQuestionsBody += `<option value = 'select' selected>Select</option>`
																			}else{
																				subQuestionsBody += `<option value = 'select' >Select</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'numeric'){
																				subQuestionsBody += `<option value = 'numeric' selected>Numeric</option>`
																			}else{
																				subQuestionsBody += `<option value = 'numeric' >Numeric</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'text'){
																				subQuestionsBody += `<option value = 'text' selected>Free Text</option>`
																			}else{
																				subQuestionsBody += `<option value = 'text' >Free Text</option>`
																				
																			}
											subQuestionsBody +=  		`</select>
																	</td>
																	
																</tr>`
											if(question['INPUTTYPE'] == 'select'){
												subQuestionsBody += `<tr width=100%><td colspan = 5 >`
												subQuestionsBody += this.createSubInputOptionList(question['INPUTOPTIONSLIST'],question['QUESTIONID'],unqId,category,subCategory)
												subQuestionsBody += `</td></tr>`
											}
											if(question['INPUTTYPE'] == 'numeric'){
												subQuestionsBody += `<tr width=100%><td colspan = 5 >`
												subQuestionsBody += this.createSubInputOptionListForNumeric(question['INPUTOPTIONSLISTFORNUMERIC'],question['QUESTIONID'],unqId,category,subCategory)
												subQuestionsBody += `</td></tr>`
											}
																
											subQuestionsBody +=	`<tr style = "width:100%">
																	<td width="15%">Has Risk Impact</td>
																	<td colspan = 4>
																		<select class="form-control input-sm" name='HASRISKIMPACT' onchange = "riskAssessmentMaster.handleSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||HASRISKIMPACT`+`" >
																			<option value = '' selected>Please Select</option>`
																			
																			if(question['HASRISKIMPACT'] == 'Y'){
																				subQuestionsBody += `<option value = 'Y' selected>Yes</option>`
																			}else{
																				subQuestionsBody += `<option value = 'Y' >Yes</option>`
																				
																			}
																			if(question['HASRISKIMPACT'] == 'N'){
																				subQuestionsBody += `<option value = 'N' selected>No</option>`
																			}else{
																				subQuestionsBody += `<option value = 'N' >No</option>`
																				
																			}
											subQuestionsBody +=	`	  </select>
																	</td>
																</tr>
																<tr>
																	<td width = "15%">Created By</td>
																	<td width = "30%"><input type="text" class="form-control input-sm" name = "CREATEDBY" value = "`+question['CREATEDBY']+`" readonly/></td>
																	<td width = "10%"></td>
																	<td width = "15%">Created On</td>
																	<td width = "30%"><input type = "text" class="form-control input-sm" name = "CREATEDON" value = "`+question['CREATEDON']+`" readonly></td>
																</tr>
																<tr>
																	<td width = "15%">Comments</td>
																	<td colspan = 4 >
																		<textarea class="form-control input-sm" name = "COMMENTS" style = "margin-bottom:5px"S" onchange = "riskAssessmentMaster.handleSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')")>`+question['COMMENTS']+` </textarea>
																		`+
																		/*`<button class = "pull-right btn btn-warning" onclick = "textifySummary.getSummary(this)">Summarize</button>`*/
																		`
																	</td>
																
																</tr>
															</table>

														</div>
															<button type="button" name = "`+question['QUESTIONID']+`" id="removeSubQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-danger btn-sm" onclick="riskAssessmentMaster.removeSubQuestion(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Remove Sub Question</button>
													</div>
												</div>`
			})
			subQuestionsBody += 		`</td>
									</tr>`
			return subQuestionsBody;
			
		},
		createInputOptionList: function (optionValues,qId,unqId,category,subCategory){
			
			var optionBody = `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
								<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>
									<tr>
										<th>Option Label</th>
										<th>Option Value</th>
										<th>Impact Criteria</th>
									</tr>`;
								
			optionValues.split("||").forEach((option,i)=>{
				var optionLabel = option.split("^")[0] != "null"?option.split("^")[0]:'';
				var optionValue = option.split("^")[1] != "null"?option.split("^")[1]:'';
				var impactCriteria = option.split("^")[2] != "null"?option.split("^")[2]:'';
				optionBody +=  `<tr>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+optionLabel+`'/>
									</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue`+i+`' value = '`+optionValue+`'/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name = '`+i+`||2' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`impactCriteria`+i+`' disabled>
											<option value = '' selected>Please Select</option>`
											if(impactCriteria == '1'){
												optionBody += `<option value = '1' selected>Low</option>`
											}else{
												optionBody += `<option value = '1' >Low</option>`
											}
											if(impactCriteria == '2'){
												optionBody += `<option value = '2' selected>Medium</option>`
											}else{
												optionBody += `<option value = '2' >Medium</option>`
											}
											if(impactCriteria == '3'){
												optionBody += `<option value = '3' selected>High</option>`
											}else{
												optionBody += `<option value = '3' >High</option>`
											}
											
				optionBody +=		`	</select>
									</td>
								</tr>`;
			
			})
			
			optionBody += 		`</table>
							</div>`;
			return optionBody;
			
		},
		createInputOptionListForNumeric: function (optionValues,qId,unqId,category,subCategory){
			
			var optionBody = `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
								<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>
									<tr>
										<th>Lower Range</th>
										<th>Upper Range</th>
										<th>Impact Criteria</th>
									</tr>`;
								
			optionValues.split("||").forEach((option,i)=>{
				var optionLabel = option.split("^")[0] != "null"?option.split("^")[0]:'';
				var optionValue = option.split("^")[1] != "null"?option.split("^")[1]:'';
				var impactCriteria = option.split("^")[2] != "null"?option.split("^")[2]:'';
				var disableLower = "";
				var disableUpper = "";
				var upperFormat = "number";
				if(i == 0){
					disableLower = "disabled"
				}
				if(i == optionValues.split("||").length-1){
					disableUpper = "disabled"
					upperFormat = 'text/number'
				}
				optionBody +=  `<tr>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+optionLabel+`' type = 'number'/>
									</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue`+i+`' value = '`+optionValue+`' type = '`+upperFormat+`'/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name = '`+i+`||2' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`impactCriteria`+i+`' disabled>
											<option value = '' selected>Please Select</option>`
											if(impactCriteria == '1'){
												optionBody += `<option value = '1' selected>Low</option>`
											}else{
												optionBody += `<option value = '1' >Low</option>`
											}
											if(impactCriteria == '2'){
												optionBody += `<option value = '2' selected>Medium</option>`
											}else{
												optionBody += `<option value = '2' >Medium</option>`
											}
											if(impactCriteria == '3'){
												optionBody += `<option value = '3' selected>High</option>`
											}else{
												optionBody += `<option value = '3' >High</option>`
											}
											
				optionBody +=		`	</select>
									</td>
								</tr>`;
			
			})
			
			optionBody += 		`</table>
							</div>`;
			return optionBody;
			
		},
		createSubInputOptionList: function (optionValues,qId,unqId,category,subCategory,type=null){
			
			var optionBody = `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
								<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>
								<tr>
										<th>Option Label</th>
										<th>Option Value</th>
										<th>Impact Criteria</th>
									</tr>`;
								
			optionValues.split("||").forEach((option,i)=>{
				var optionLabel = option.split("^")[0] != "null"?option.split("^")[0]:'';
				var optionValue = option.split("^")[1] != "null"?option.split("^")[1]:'';
				var impactCriteria = option.split("^")[2] != "null"?option.split("^")[2]:'';
				optionBody +=  `<tr>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||0' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+optionLabel+`'/>
									</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||1' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+optionValue+`'/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name = '`+i+`||2' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue`+i+`' disabled>
											<option value = '' selected>Please Select</option>`
											if(impactCriteria == '1'){
												optionBody += `<option value = '1' selected>Low</option>`
											}else{
												optionBody += `<option value = '1' >Low</option>`
											}
											if(impactCriteria == '2'){
												optionBody += `<option value = '2' selected>Medium</option>`
											}else{
												optionBody += `<option value = '2' >Medium</option>`
											}
											if(impactCriteria == '3'){
												optionBody += `<option value = '3' selected>High</option>`
											}else{
												optionBody += `<option value = '3' >High</option>`
											}
											
				optionBody +=		`	</select>
									</td>
								</tr>`;
			
			})
			
			optionBody += 		`</table>
							</div>`;
			return optionBody;
			
		},
		createSubInputOptionListForNumeric: function (optionValues,qId,unqId,category,subCategory){
			
			var optionBody = `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
								<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>
								<tr>
										<th>Lower Range</th>
										<th>Upper Range</th>
										<th>Impact Criteria</th>
									</tr>`;
								
			optionValues.split("||").forEach((option,i)=>{
				var lowerRange = option.split("^")[0] != "null"?option.split("^")[0]:'';
				var upperRange = option.split("^")[1] != "null"?option.split("^")[1]:'';
				var impactCriteria = option.split("^")[2] != "null"?option.split("^")[2]:'';
				var disableLower = "";
				var disableUpper = "";
				if(i == 0){
					disableLower = "disabled"
				}
				if(i == optionValues.split("||").length-1){
					disableUpper = "disabled"
				}
				
				optionBody +=  `<tr>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||0' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+lowerRange+`' type = 'number' />
									</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||1' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+upperRange+`' type = 'number'/>
									</td>
									<td width="30%">
										<select class="form-control input-sm" name = '`+i+`||2' onchange = "riskAssessmentMaster.handleOptionsSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`','numeric')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue`+i+`' readonly>
											<option value = '' selected>Please Select</option>`
											if(impactCriteria == '1'){
												optionBody += `<option value = '1' selected>Low</option>`
											}else{
												optionBody += `<option value = '1' >Low</option>`
											}
											if(impactCriteria == '2'){
												optionBody += `<option value = '2' selected>Medium</option>`
											}else{
												optionBody += `<option value = '2' >Medium</option>`
											}
											if(impactCriteria == '3'){
												optionBody += `<option value = '3' selected>High</option>`
											}else{
												optionBody += `<option value = '3' >High</option>`
											}
											
				optionBody +=		`	</select>
									</td>
								</tr>`;
			
			})
			
			optionBody += 		`</table>
							</div>`;
			return optionBody;
			
		},
		addCRQuestion: function(elm,unqId,toAddCategory,toAddSubCategory,qsType,buttonPosition){
			var categoryPrefixes=['A','B','C','D','E','F','G','H','I','J','K']
			var subCategoryPrefixes=['a','b','c','d','e','f','g','h','i','j','k']
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
			Object.keys(categories).forEach((category,categoryIndex)=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
				if(fcateg == toAddCategory){
					categories[category].forEach((subCategory,subCategoryIndex)=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
						if(fSubCateg == toAddSubCategory){
							var questionOrder = 1;
							if(questionsFormDetails[category][subCategory].length > 0){
									questionsFormDetails[category][subCategory].forEach(q=>{
										if(parseInt(q['QUESTIONID'].replace("CR",'').replace(categoryPrefixes[categoryIndex],"").replace(subCategoryPrefixes[subCategoryIndex],""))+1 > questionOrder){
											questionOrder = parseInt(q['QUESTIONID'].replace("CR",'').replace(categoryPrefixes[categoryIndex],"").replace(subCategoryPrefixes[subCategoryIndex],""))+1
										}
										
									})
							}
							if(buttonPosition == "B"){
									
									//questionOrder = questionsFormDetails[category][subCategory].length+1
									var newQuestionObject = {
																"QUESTIONID":"CR"+categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
																"ISSUPERPARENT":"N",
																"QUESTION":"",
																"INPUTTYPE":"",
																"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																"HASRISKIMPACT":"Y",
																"HASPARENT":"Y",
																"PARENTQSIDS":"",
																"SUBQUESTIONLIST": [],
																"DISABLED":"N",
																"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																"COMMENTS":"",
																"CREATEDBY":$("#userCode").html().trim(),
																"CREATEDON":$("#todayDate").html()}
									questionsFormDetails[category][subCategory].push(newQuestionObject);
								}
								else{
									//questionOrder = questionsFormDetails[category][subCategory].length+1
									var newQuestionObject = [{
																"QUESTIONID":"CR"+categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
																"ISSUPERPARENT":"N",
																"QUESTION":"",
																"INPUTTYPE":"",
																"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																"HASRISKIMPACT":"Y",
																"HASPARENT":"N",
																"PARENTQSIDS":"",
																"SUBQUESTIONLIST": [],
																"DISABLED":"N",
																"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																"COMMENTS":"",
																"CREATEDBY":$("#userCode").html().trim(),
																"CREATEDON":$("#todayDate").html()
																	}]
									questionsFormDetails[category][subCategory].forEach(question=>{
										newQuestionObject.push(Object.assign({},question));
									})
									questionsFormDetails[category][subCategory] = newQuestionObject;
								}
						
							
						}
					})
				}
			})
			// console.log(toAddSubCategory+"subCategLinkCR")
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toAddCategory+"Link",toAddSubCategory+"subCategLinkCR",true))
			
			$(".selectpicker").selectpicker();
			
		},
		removeCRQuestion: function (elm,unqId,toRemoveCategory,toRemoveSubCategory,qId){
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
				if(fcateg == toRemoveCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
						if(fSubCateg == toRemoveSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] != qId){
									questionsList.push(Object.assign({},question));
								}
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toRemoveCategory+"Link",toRemoveSubCategory+"subCategLinkCR",true))
			
			$(".selectpicker").selectpicker();
		},
		addCRSubQuestion: function(elm,unqId,toAddCategory,toAddSubCategory,qId){
			
			var categoryPrefixes=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
			var subCategoryPrefixes=['a','b','c','d','e','f','g','h','i','j','k','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
			Object.keys(categories).forEach((category,categoryIndex)=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
				//console.log(fcateg+"--"+toAddCategory)
				if(fcateg == toAddCategory){
					categories[category].forEach((subCategory,subCategoryIndex)=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
						//console.log(fSubCateg+"++"+toAddSubCategory)
						if(fSubCateg == toAddSubCategory){
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] == qId){
									var questionOrder = 1
									
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(parseInt(q['QUESTIONID'].split(".")[1])+1 > questionOrder){
											questionOrder = parseInt(q['QUESTIONID'].split(".")[1])+1
										}
										
									})
									
									question['SUBQUESTIONLIST'].push({
																	"QUESTIONID":qId+"."+questionOrder,
																	"ISSUPERPARENT":"N",
																	"QUESTION":"",
																	"INPUTTYPE":"",
																	"INPUTOPTIONSLIST":"null^null^1||null^null^2||null^null^3",
																	"HASRISKIMPACT":"Y",
																	"HASPARENT":"Y",
																	"PARENTQSIDS":elm.name+",",
																	"DISABLED":"N",
																	"INPUTOPTIONSLISTFORNUMERIC":"0^null^1||null^null^2||null^INF^3",
																	"COMMENTS":"",
																	"CREATEDBY":$("#userCode").html().trim(),
																	"CREATEDON":$("#todayDate").html()
																	 })
								}
							})
							
											
						}
					})
				}
			})
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toAddCategory+"Link",toAddSubCategory+"subCategLinkCR",true))
			
			$(".selectpicker").selectpicker();
			
		},
		removeCRSubQuestion: function (elm,unqId,toRemoveCategory,toRemoveSubCategory,qId){
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
			
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
				if(fcateg == toRemoveCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&')
						if(fSubCateg == toRemoveSubCategory){
							//console.log(questionsFormDetails[category][subCategory])
							questionsFormDetails[category][subCategory].forEach(question=>{
								//console.log(question)
								if(question['QUESTIONID'] == qId.split(".")[0]){
									var subQuestionsList = [];
									//console.log(question['SUBQUESTIONLIST'])
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(q['QUESTIONID'] != qId){
											
											subQuestionsList.push(Object.assign({},q));
										}
									})
								question['SUBQUESTIONLIST'] = subQuestionsList;
								}
							})
							
							
						}
					})
				}
			})
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toRemoveCategory+"Link",toRemoveSubCategory+"subCategLinkCR",true))
			
			$(".selectpicker").selectpicker();
		},
		createCRSubQuestionList: function(subQuesitonsList,qId,unqId,category,subCategory){
			var subQIds = [];
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			Object.keys(categories).forEach(category=>{
				categories[category].forEach(subCategory=>{
					questionsFormDetails[category][subCategory].forEach(question=>{
						
						subQIds.push(question['QUESTIONID'])
					})
				})
			})
			
			var parentQsIds = []
			try{
				parentQsIds = parentsList.split(",");
			}
			catch(e){}
			var subQuestionsBody = `<tr>
										<td colspan = 5 >`
			subQuesitonsList.forEach((question,i)=>{
				
			
					subQuestionsBody +=		`<div class="card card-primary questionDiv`+unqId+`" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header panelSlidingRiskAssessQs`+unqId+` clearfix" 
													id="`+question['QUESTIONID']+`slidingQuestionPanel`+unqId+`" data-toggle="collapse"
													onclick="handleSlidingPanels(this,'`+unqId+`','`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`')" style = "background-color:#f7b3ba">
													<h6 class="card-title pull-left">Sub Question Id:`+question['QUESTIONID']+`</h6>
													<div class="btn-group pull-right clearfix">
														<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
													</div>
												</div>
												<div id="`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`" class="`+question['QUESTIONID'].replaceAll(".","")+`slidingQuestionDetails`+unqId+`" >
													
														<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
														
															<table class="table table-striped">
																<tr style = "width:100%">
																	<td width="15%">Question</td>
																	<td colspan = 4>
																		<textarea type='text' name="QUESTION" onchange = "riskAssessmentMaster.handleCRSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||question`+`" class='form-control input-sm'>`+question['QUESTION']+`</textarea>
																	</td>
																</tr>
																<tr>
																<td width="15%">Input Type</td>
																	<td width="30%">
																		<select class="form-control input-sm" name = 'INPUTTYPE' id = "`+question["QUESTIONID"]+`||hasParent" onchange = "riskAssessmentMaster.handleCRSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')")>
																			<option value = '' selected>Please Select</option>`
																			if(question['INPUTTYPE'] == 'T'){
																				subQuestionsBody += `<option value = 'T' selected>Text</option>`
																			}else{
																				subQuestionsBody += `<option value = 'T' >Text</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'L'){
																				subQuestionsBody += `<option value = 'L' selected>Option List</option>`
																			}else{
																				subQuestionsBody += `<option value = 'L' >Option List</option>`
																				
																			}
																			
																
											subQuestionsBody +=					`	</select>
																	</td>
																	<td width="10%"></td>
																	<td width="15%"></td>
																	<td width="30%">
																	</td>
																</tr>
																<tr>
																	<td width = "15%">Created By</td>
																	<td width = "30%"><input type="text" class="form-control input-sm" name = "CREATEDBY" value = "`+question['CREATEDBY']+`" readonly/></td>
																	<td width = "10%"></td>
																	<td width = "15%">Created On</td>
																	<td width = "30%"><input type = "text" class="form-control input-sm" name = "CREATEDON" value = "`+question['CREATEDON']+`" readonly></td>
																</tr>
																<tr>
																	<td width = "15%">Comments</td>
																	<td colspan = 4 >
																		<textarea class="form-control input-sm" name = "COMMENTS" style = "margin-bottom:5px"S" onchange = "riskAssessmentMaster.handleCRSubInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')")>`+question['COMMENTS']+` </textarea>
																		`
																		/*`<button class = "pull-right btn btn-warning" onclick = "textifySummary.getSummary(this)">Summarize</button>	
																	`*/
																	+`</td>
																	
																</tr>
															</table>

														</div>
															<button type="button" name = "`+question['QUESTIONID']+`" id="removeCRSubQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-danger btn-sm" onclick="riskAssessmentMaster.removeCRSubQuestion(this,'`+unqId+`','`+category+`','`+subCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Remove Sub Question</button>
													</div>
												</div>`
			})
			subQuestionsBody += 		`</td>
									</tr>`
			return subQuestionsBody;
			
		},
		
		handleCRInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId){
			
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;","&")
				//console.log(fcateg,":",toEditCategory)
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;","&")
						//console.log(fSubCateg,":",toEditSubCategory)
						if(fSubCateg == toEditSubCategory){
							var questionsList = [];
							questionsFormDetails[category][subCategory].forEach(question=>{
								if(question['QUESTIONID'] == qId){
									question[elm.name] = elm.value;
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditSubCategory+"subCategLinkCR",true))
			
			$(".selectpicker").selectpicker();
			
			
		},
		
		handleCRSubInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId){
			
			var questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var categories = JSON.parse($("#controlsReviewsCategSubCateg").html())
						
			Object.keys(categories).forEach(category=>{
				var fcateg = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;","&")
				if(fcateg == toEditCategory){
					categories[category].forEach(subCategory=>{
						var fSubCateg = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;","&")
						if(fSubCateg == toEditSubCategory){
							questionsFormDetails[category][subCategory].forEach(question=>{
								/*if(question['QUESTIONID'] == qId){*/
									question['SUBQUESTIONLIST'].forEach(q=>{
										if(q['QUESTIONID'] == qId){
											q[elm.name] = elm.value
										}
									})
								/*}*/
							})
							
						}
					})
				}
			})
			$("#controlsReviewsQuestionsDetails").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId,toEditCategory+"Link",toEditSubCategory+"subCategLinkCR",true))
			/*document.getElementById(toEditCategory+"Link").click()
			document.getElementById(toEditCategory+toEditSubCategory+"subCategLink").click()*/
			$(".selectpicker").selectpicker();
			//document.getElementById(elm.id).scrollIntoView();
		},
		getSummany:function (ele){
			$(ele).siblings().each(function() {
				 msg = $(this).val()
				 $("#compassCaseWorkFlowGenericModal").modal("show");
				 $("#compassCaseWorkFlowGenericModal-title").html("Comment Summary");
				 $("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				 $.ajax({
				 	url : 'http://127.0.0.1:5555/predict',
			 		cache : true,
			 		type : 'POST',
			 		data : "message="+msg,
				 	success: function(res) {
						var summaryHtml = `<div class="card card-primary" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header clearfix" 
													id="slidingSummaryPanel"" data-toggle="collapse"
													 style = "background-color:#95f1a7">
													<h6 class="card-title pull-left">Generated Summary</h6>
													
												</div>
												<div id="summarySection" class="summarySection" >
													
															<table class="table table-striped">
																<tr style = "width:100%">
																	<td width="100%">
																		<textarea class = "form-control input-sm" readonly>`+res+`</textarea>
																	</td>
																</tr>
															</table>
													</div>
												</div>`
						
				 		$("#compassCaseWorkFlowGenericModal-body").html(summaryHtml);
				 	},
				 	error: function(a,b,c) {
						alert(a+b+c);
				 	}
				 });
				 
				});
		},
		
		generateQuestionsForm: function (unqId,prevCategoryLink = null, prevSubCategoryLink = null, isControlsReview = false) {
			var assessmentUnit = $("#assessmentUnit").html()
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			var crCategoriesSubCategores = JSON.parse($("#controlsReviewsCategSubCateg").html())
			var crQuestionDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html())
			var initial = `<div class="compassmodalrow`+unqId+`">`;
			var ending = `</div>`;
			var body = `<div class="card card-primary">
							<ul class="nav nav-pills modalNav" role="tablist">`
							Object.keys(categories).forEach((category,cIndex)=>{
									var formattedCategory = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');
									if(prevCategoryLink != null){
										if(formattedCategory+"Link" == prevCategoryLink){
											body += `<li role="presentation">
														<a class="subTab nav-link active" id = "`+formattedCategory+`Link" 
															href="#" onclick="switchTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										else{
											body += `<li role="presentation">
														<a class="subTab nav-link" id = "`+formattedCategory+`Link" 
															href="#" onclick="switchTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										
									}else{
										
										if(cIndex == 0){
											body += `<li role="presentation">
														<a class="subTab nav-link " id = "`+formattedCategory+`Link" 
															href="#" onclick="switchTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										else{
											body += `<li role="presentation">
														<a class="subTab nav-link" id = "`+formattedCategory+`Link"
															href="#" onclick="switchTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
									}
									
							})
					if(isControlsReview){
						
						body += `<li role="presentation">
									<a class="subTab nav-link active" id = "controlReviewsLink"
										href="#" onclick="switchTabs('controlReviews')" 
										aria-controls="tab" role="tab" data-toggle="tab">
											`+'Control Reviews'+`
									</a>
								</li>`
					}
					else{
						body += `<li role="presentation">
									<a class="subTab nav-link" id = "controlReviewsLink"
										href="#" onclick="switchTabs('controlReviews')" 
										aria-controls="tab" role="tab" data-toggle="tab">
											`+'Control Reviews'+`
									</a>
								</li>`
						
					}
					body+= `</ul>`;
					body+= `<div class="tab-content" id = "categoryTabContent">`
					Object.keys(categories).forEach((category,cIndex)=>{
						var formattedCategory = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');
						if(prevCategoryLink != null){
							if(formattedCategory == prevCategoryLink.replace("Link","")){
								body += `<div role="tabpanel" class="tab-pane active"  id="`+formattedCategory+cIndex+`">`
							}
							else{
								body += `<div role="tabpanel" class="tab-pane"  id="`+formattedCategory+cIndex+`">`
							}
							
						}
						else{
							
							if(cIndex == 0){
								body += `<div role="tabpanel" class="tab-pane "  id="`+formattedCategory+cIndex+`">`	
							}
							else{
								body += `<div role="tabpanel" class="tab-pane"  id="`+formattedCategory+cIndex+`">`
							}
						}
						body += `<div class="card card-primary" style = "width:95%;margin:auto;margin-top:5px;">
									<ul class="nav nav-pills modalNav" role="tablist">`
						categories[category].forEach((subCategory,sIndex)=>{
							var formattedSubCategory = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');							
							if(prevSubCategoryLink != null){
								if(prevSubCategoryLink == formattedCategory+formattedSubCategory+"subCategLink"){
									body +=    `<li role="presentation">
												<a class="subTab nav-link active" id = "`+formattedCategory+formattedSubCategory+`subCategLink"
													href="#" onclick="switchSubTabs('`+formattedSubCategory+sIndex+`subCateg')" 
													aria-controls="tab" role="tab" data-toggle="tab">
														`+subCategory+`
												</a>
											</li>`
								}
								else{
									body +=    `<li role="presentation">
												<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subCategLink"
													href="#" onclick="switchSubTabs('`+formattedSubCategory+sIndex+`subCateg')" 
													aria-controls="tab" role="tab" data-toggle="tab">
														`+subCategory+`
												</a>
											</li>`
								}
							}
							else{
								
								if(sIndex == 0){
									body +=    `<li role="presentation">
													<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subCategLink"
														href="#" onclick="switchSubTabs('`+formattedSubCategory+sIndex+`subCateg')" 
														aria-controls="tab" role="tab" data-toggle="tab">
															`+subCategory+`
													</a>
												</li>`
								}
								else{
									body +=    `<li role="presentation">
													<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subCategLink"
														href="#" onclick="switchSubTabs('`+formattedSubCategory+sIndex+`subCateg')" 
														aria-controls="tab" role="tab" data-toggle="tab">
															`+subCategory+`
													</a>
												</li>`
								}
							}
						})
						body += `	</ul>`
						body += `	<div class="tab-content" id = "subCategoryTabContent">`
						categories[category].forEach((subCategory,sIndex)=>{
							var formattedSubCategory = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');							
							if(prevSubCategoryLink != null){
								if(formattedSubCategory == prevSubCategoryLink.replace("subCateg","").replace(formattedCategory,"").replace("Link","")){
									body += `<div role="tabpanel" class="tab-pane active"  id="`+formattedSubCategory+sIndex+`subCateg">`
								}
								else{
									body += `<div role="tabpanel" class="tab-pane "  id="`+formattedSubCategory+sIndex+`subCateg">`
								}
								
							}
							else{
								
								if(sIndex == 0){
									body += `<div role="tabpanel" class="tab-pane "  id="`+formattedSubCategory+sIndex+`subCateg">`
								}
								else{
									body += `<div role="tabpanel" class="tab-pane"  id="`+formattedSubCategory+sIndex+`subCateg">`
								}
							}
							
							body += `<div>
										<div class = "pull-left" style = "margin-left:50px;margin-bottom:10px;margin-top:10px">
											Question count : `+questionsFormDetails[category][subCategory].length+`
										</div>`
							if(questionsFormDetails[category][subCategory].length > 1){
								
								body += `<div class="btn-group dropdown pull-right" id = "addQuestionDiv1"`+formattedCategory+formattedSubCategory+` role="group" style="margin-right:50px;margin-bottom:10px" >
											<button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
												Add Question
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu">
												<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','individual','T')") >Inidividual</a></li>
												<!--<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','interlinked','T')") >Interlinked</a></li>!-->							
											</ul>
										</div>`
							}
							body += `</div>`
							questionsFormDetails[category][subCategory].forEach((question,qId)=>{
						
								body += `<div class="card card-primary questionDiv`+unqId+`" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header panelSlidingRiskAssessQs`+unqId+` clearfix" 
													id="`+qId+`slidingQuestionPanel`+unqId+`" data-toggle="collapse"
													onclick="handleSlidingPanels(this,'`+unqId+`','`+qId+`slidingQuestionDetails`+unqId+`')" style = "background-color:#95f1a7">
													<h6 class="card-title pull-left">Question Id:`+question['QUESTIONID']+`</h6>
													<div class="btn-group pull-right clearfix">
														<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
													</div>
												</div>
												<div id="`+qId+`slidingQuestionDetails`+unqId+`" class="`+qId+`slidingQuestionDetails`+unqId+`" >
													
														<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
														
															<table class="table table-striped">
																<tr style = "width:100%">
																	<td width="15%">Is Super Parent</td>
																	<td width="30%">
																		<select class="form-control input-sm" name='ISSUPERPARENT' onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||issuperparent`+`" >
																			<option value = '' selected>Please Select</option>`
																			
																			if(question['ISSUPERPARENT'] == 'Y'){
																				body += `<option value = 'Y' selected>Yes</option>`
																			}else{
																				body += `<option value = 'Y' >Yes</option>`
																				
																			}
																			if(question['ISSUPERPARENT'] == 'N'){
																				body += `<option value = 'N' selected>No</option>`
																			}else{
																				body += `<option value = 'N' >No</option>`
																				
																			}
																			
																
											body +=					`	</select>
																	</td>
																	<td width="10%"></td>
																	<td width="15%"></td>
																	<td width="30%">
																	</td>
																	
																</tr>
																
																<tr>
																	<td width="15%">Question</td>
																	<td colspan = 4>
																		<textarea type='text' name="QUESTION" onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||question`+`" class='form-control input-sm'>`+question['QUESTION']+`</textarea>
																	</td>
																	
																</tr>
																
																<tr>
																	<td width="15%">Input Type</td>
																	<td width="30%">
																		<select class="form-control input-sm" name = 'INPUTTYPE' onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||inputType`+`">
																			<option value = '' selected>Please Select</option>`
																			if(question['INPUTTYPE'] == 'select'){
																				body += `<option value = 'select' selected>Select</option>`
																			}else{
																				body += `<option value = 'select' >Select</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'numeric'){
																				body += `<option value = 'numeric' selected>Numeric</option>`
																			}else{
																				body += `<option value = 'numeric' >Numeric</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'text'){
																				body += `<option value = 'text' selected>Free Text</option>`
																			}else{
																				body += `<option value = 'text' >Free Text</option>`
																				
																			}
																
											body +=					`	</select>
																	</td>
																	<td width="10%"></td>
																	<td width="15%"></td>
																	<td width="30%">
																	</td>
																</tr>`
																if(question['INPUTTYPE'] == 'select'){
																	body += `<tr><td colspan = 5 >`
																	body += this.createInputOptionList(question['INPUTOPTIONSLIST'],question['QUESTIONID'],unqId,formattedCategory,formattedSubCategory)
																	body += `</td></tr>`
																}
																if(question['INPUTTYPE'] == 'numeric'){
																	body += `<tr><td colspan = 5 >`
																	body += this.createInputOptionListForNumeric(question['INPUTOPTIONSLISTFORNUMERIC'],question['QUESTIONID'],unqId,formattedCategory,formattedSubCategory)
																	body += `</td></tr>`
																}
																
																
											/*body +=				`<tr>
																	<td width="15%">Has Risk Impact</td>
																	<td width="30%">
																		<select class="form-control input-sm" name = 'HASRISKIMPACT' onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>
																			<option value = '' selected>Please Select</option>`
																			if(question['HASRISKIMPACT'] == 'Y'){
																				body += `<option value = 'Y' selected>Yes</option>`
																			}else{
																				body += `<option value = 'Y' >Yes</option>`
																				
																			}
																			if(question['HASRISKIMPACT'] == 'N'){
																				body += `<option value = 'N' selected>No</option>`
																			}else{
																				body += `<option value = 'N' >No</option>`
																				
																			}
																			
																
											body +=					`	</select>
																	</td>
																	<td width="10%"></td>
																	<td width="15%"></td>
																	<td width="30%">
																	</td>
																</tr>`*/
											if(question['ISSUPERPARENT'] == 'N'){
												
												body +=				`<tr>
																		<td width="15%">Has Parent</td>
																		<td width="30%">
																			<select class="form-control input-sm" name = 'HASPARENT' id = "`+question["QUESTIONID"]+`||hasParent" onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>
																				<option value = '' selected>Please Select</option>`
																				if(question['HASPARENT'] == 'Y'){
																					body += `<option value = 'Y' selected>Yes</option>`
																				}else{
																					body += `<option value = 'Y' >Yes</option>`
																					
																				}
																				if(question['HASPARENT'] == 'N'){
																					body += `<option value = 'N' selected>No</option>`
																				}else{
																					body += `<option value = 'N' >No</option>`
																					
																				}
																				
																	
												body +=					`	</select>
																		</td>
																		<td width="10%"></td>
																		<td width="15%"></td>
																		<td width="30%">
																		</td>
																	</tr>`
																	if(question['HASPARENT'] == 'Y'){
																		body += this.createParentQsOptionList(question['PARENTQSIDS'],question['QUESTIONID'],unqId,formattedCategory,formattedSubCategory)
																		
																	}														
											}
											if(question['SUBQUESTIONLIST'] != undefined && question['SUBQUESTIONLIST'].length > 0){
												body += this.createSubQuestionList(question['SUBQUESTIONLIST'], question['QUESTIONID'], unqId, formattedCategory, formattedSubCategory)
											}
											
											body +=			`
															<tr>
																<td width = "15%">Created By</td>
																<td width = "30%"><input type="text" class="form-control input-sm" name = "CREATEDBY" value = "`+question['CREATEDBY']+`" readonly/></td>
																<td width = "10%"></td>
																<td width = "15%">Created On</td>
																<td width = "30%"><input type = "text" class="form-control input-sm" name = "CREATEDON" value = "`+question['CREATEDON']+`" readonly></td>
															</tr>
															<tr>
																<td width = "15%">Comments</td>
																<td colspan = 4 >
																	<textarea class="form-control input-sm" name = "COMMENTS" style = "margin-bottom:5px"S" style = "margin-bottom:5px" onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>`+question['COMMENTS']+` </textarea>
																	`+
																	/*`<button class = "pull-right btn btn-warning" onclick = "textifySummary.getSummary(this)">Summarize</button>
																`*/
																`</td>
																
															</tr>
															</table>
														</div>
														<button type="button" id="removeQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-danger btn-sm" onclick="riskAssessmentMaster.removeQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Remove</button>
														<button type="button" name = "`+question['QUESTIONID']+`" id="addSubQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-warning btn-sm" onclick="riskAssessmentMaster.addSubQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Add Sub Question</button>
												</div>
											</div>`;
								
							})
							body += `<div class="btn-group dropdown pull-right" role="group" id = "addQuestionDiv2`+formattedCategory+formattedSubCategory+`" style="margin-right:50px;margin-bottom:10px" >
										<button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											Add Question
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','individual','B')") >Inidividual</a></li>
											<!-- <li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','interlinked','B')") >Interlinked</a></li> !-->																
										</ul>
									</div>`
							
							body += `</div>`
						})
						
						body += `	</div>`
						body += ` </div>`
						body += `</div>`
					})
					
					if(isControlsReview){
					body += `<div role="tabpanel" class="tab-pane active"  id="controlReviews">`
					}
					else{
					body += `<div role="tabpanel" class="tab-pane "  id="controlReviews">`
					}
					body += `<div class="card card-primary" style = "width:95%;margin:auto">
							<ul class="nav nav-pills modalNav" role="tablist">`
							Object.keys(crCategoriesSubCategores).forEach((category,cIndex)=>{
									var formattedCategory = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&');
									if(prevCategoryLink != null){
										//console.log(prevCategoryLink,"--", formattedCategory+"Link")
										if(formattedCategory+"Link" == prevCategoryLink){
											body += `<li role="presentation">
														<a class="subTab nav-link active" id = "`+formattedCategory+`Link" 
															href="#" onclick="switchCRTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										else{
											body += `<li role="presentation">
														<a class="subTab nav-link" id = "`+formattedCategory+`Link" 
															href="#" onclick="switchCRTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										
									}else{
										
										if(cIndex == 0){
											body += `<li role="presentation">
														<a class="subTab nav-link " id = "`+formattedCategory+`Link" 
															href="#" onclick="switchCRTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
										else{
											body += `<li role="presentation">
														<a class="subTab nav-link" id = "`+formattedCategory+`Link"
															href="#" onclick="switchCRTabs('`+formattedCategory+cIndex+`')" 
															aria-controls="tab" role="tab" data-toggle="tab">
																`+category+`
														</a>
													</li>`
										}
									}
									
							})
					
					body+= `</ul>`;
					body+= `<div class="tab-content" id = "crCategoryTabContent">`
					Object.keys(crCategoriesSubCategores).forEach((category,cIndex)=>{
						var formattedCategory = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&');
						if(prevCategoryLink != null){
							
							if(formattedCategory == prevCategoryLink.replace("Link","")){
								body += `<div role="tabpanel" class="tab-pane active"  id="`+formattedCategory+cIndex+`">`
							}
							else{
								body += `<div role="tabpanel" class="tab-pane"  id="`+formattedCategory+cIndex+`">`
							}
							
						}
						else{
							
							if(cIndex == 0){
								body += `<div role="tabpanel" class="tab-pane "  id="`+formattedCategory+cIndex+`">`	
							}
							else{
								body += `<div role="tabpanel" class="tab-pane"  id="`+formattedCategory+cIndex+`">`
							}
						}
						body += `<div class="card card-primary" style = "width:95%;margin:auto;margin-top:5px;">
									<ul class="nav nav-pills modalNav" role="tablist">`
						crCategoriesSubCategores[category].forEach((subCategory,sIndex)=>{
							var formattedSubCategory = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&');							
							if(prevSubCategoryLink != null){
								//console.log(prevSubCategoryLink,"++",formattedSubCategory+"subCategLinkCR")
								if(prevSubCategoryLink == formattedSubCategory+"subCategLinkCR"){
									body +=    `<li role="presentation">
												<a class="subTab nav-link active" id = "`+formattedCategory+formattedSubCategory+`subSubCategLinkCR"
													href="#" onclick="switchCRSubTabs('`+formattedSubCategory+sIndex+`subSubCategCR')" 
													aria-controls="tab" role="tab" data-toggle="tab">
														`+subCategory+`
												</a>
											</li>`
								}
								else{
									body +=    `<li role="presentation">
												<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subSubCategLinkCR"
													href="#" onclick="switchCRSubTabs('`+formattedSubCategory+sIndex+`subSubCategCR')" 
													aria-controls="tab" role="tab" data-toggle="tab">
														`+subCategory+`
												</a>
											</li>`
								}
							}
							else{
								
								if(sIndex == 0){
									body +=    `<li role="presentation">
													<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subSubCategLinkCR"
														href="#" onclick="switchCRSubTabs('`+formattedSubCategory+sIndex+`subSubCategCR')" 
														aria-controls="tab" role="tab" data-toggle="tab">
															`+subCategory+`
													</a>
												</li>`
								}
								else{
									body +=    `<li role="presentation">
													<a class="subTab nav-link" id = "`+formattedCategory+formattedSubCategory+`subSubCategLinkCR"
														href="#" onclick="switchCRSubTabs('`+formattedSubCategory+sIndex+`subSubCategCR')" 
														aria-controls="tab" role="tab" data-toggle="tab">
															`+subCategory+`
													</a>
												</li>`
								}
							}
						})
						body += `	</ul>`
						body += `	<div class="tab-content" id = "crSubCategoryTabContent">`
						crCategoriesSubCategores[category].forEach((subCategory,sIndex)=>{
							var formattedSubCategory = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'').replaceAll("&amp;",'&');							
							if(prevSubCategoryLink != null){
								//console.log(formattedSubCategory,"====",prevSubCategoryLink)
								//console.log(prevSubCategoryLink,"+++++",formattedSubCategory+"subCategLinkCR")
								//if(formattedSubCategory == prevSubCategoryLink.replace("subCateg","").replace(formattedCategory,"").replace("LinkCR","").replaceAll("&amp;",'&')){
								if(prevSubCategoryLink == formattedSubCategory+"subCategLinkCR"){
									body += `<div role="tabpanel" class="tab-pane active"  id="`+formattedSubCategory+sIndex+`subSubCategCR">`
								}
								else{
									body += `<div role="tabpanel" class="tab-pane "  id="`+formattedSubCategory+sIndex+`subSubCategCR">`
								}
								
							}
							else{
								
								if(sIndex == 0){
									body += `<div role="tabpanel" class="tab-pane "  id="`+formattedSubCategory+sIndex+`subSubCategCR">`
								}
								else{
									body += `<div role="tabpanel" class="tab-pane"  id="`+formattedSubCategory+sIndex+`subSubCategCR">`
								}
							}
							
							body += `<div>
										<div class = "pull-left" style = "margin-left:50px;margin-bottom:10px;margin-top:10px">
											Question count : `+crQuestionDetails[category][subCategory].length+`
										</div>
										
										`
										
							if(crQuestionDetails[category][subCategory].length > 1){
								
								body += `<div class="btn-group dropdown pull-right" id = "addQuestionDiv1"`+formattedCategory+formattedSubCategory+` role="group" style="margin-right:50px;margin-bottom:10px" >
											<button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
												Add Question
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu">
												<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addCRQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','individual','T')") >Inidividual</a></li>
												<!--<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addCRQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','interlinked','T')") >Interlinked</a></li>!-->							
											</ul>
										</div>`
							}
							body += `</div>`
							crQuestionDetails[category][subCategory].forEach((question,qId)=>{
						
								body += `<div class="card card-primary questionDiv`+unqId+`" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header panelSlidingRiskAssessQs`+unqId+` clearfix" 
													id="`+qId+`slidingQuestionPanel`+unqId+`" data-toggle="collapse"
													onclick="handleSlidingPanels(this,'`+unqId+`','`+qId+`slidingQuestionDetails`+unqId+`')" style = "background-color:#95f1a7">
													<h6 class="card-title pull-left">Question Id:`+question['QUESTIONID']+`</h6>
													<div class="btn-group pull-right clearfix">
														<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
													</div>
												</div>
												<div id="`+qId+`slidingQuestionDetails`+unqId+`" class="`+qId+`slidingQuestionDetails`+unqId+`" >
													
														<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
														
															<table class="table table-striped">`
																
																
											body+=				`<tr>
																	<td width="15%">Question</td>
																	<td colspan = 4>
																		<textarea type='text' name="QUESTION" onchange = "riskAssessmentMaster.handleCRInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") id = "`+question['QUESTIONID']+`||question`+`" class='form-control input-sm'>`+question['QUESTION']+`</textarea>
																	</td>
																	
																</tr>`
											body +=				`<tr>
																	<td width="15%">Input Type</td>
																	<td width="30%">
																		<select class="form-control input-sm" name = 'INPUTTYPE' id = "`+question["QUESTIONID"]+`||hasParent" onchange = "riskAssessmentMaster.handleCRInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>
																			<option value = '' selected>Please Select</option>`
																			if(question['INPUTTYPE'] == 'T'){
																				body += `<option value = 'T' selected>Text</option>`
																			}else{
																				body += `<option value = 'T' >Text</option>`
																				
																			}
																			if(question['INPUTTYPE'] == 'L'){
																				body += `<option value = 'L' selected>Option List</option>`
																			}else{
																				body += `<option value = 'L' >Option List</option>`
																				
																			}
																			
																
											body +=					`	</select>
																	</td>
																	<td width="10%"></td>
																	<td width="15%"></td>
																	<td width="30%">
																	</td>
																</tr>`
															
																
											if(question['SUBQUESTIONLIST'] != undefined && question['SUBQUESTIONLIST'].length > 0){
												body += this.createCRSubQuestionList(question['SUBQUESTIONLIST'], question['QUESTIONID'], unqId, formattedCategory, formattedSubCategory)
											}
											
											body +=			`
															<tr>
																<td width = "15%">Created By</td>
																<td width = "30%"><input type="text" class="form-control input-sm" name = "CREATEDBY" value = "`+question['CREATEDBY']+`" readonly/></td>
																<td width = "10%"></td>
																<td width = "15%">Created On</td>
																<td width = "30%"><input type = "text" class="form-control input-sm" name = "CREATEDON" value = "`+question['CREATEDON']+`" readonly></td>
															</tr>
															<tr>
																<td width = "15%">Comments</td>
																<td colspan = 4 >
																	<textarea class="form-control input-sm" name = "COMMENTS" style = "margin-bottom:5px"S" onchange = "riskAssessmentMaster.handleCRInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>`+question['COMMENTS']+` </textarea>
																	`+
																	/*`<button class = "pull-right btn btn-warning" onclick = "textifySummary.getSummary(this)">Summarize</button>
																`*/
																`</td>
																
															</tr>
															
															</table>
														</div>
														<button type="button" id="removeQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-danger btn-sm" onclick="riskAssessmentMaster.removeCRQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Remove</button>
														<button type="button" name = "`+question['QUESTIONID']+`" id="addSubQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-warning btn-sm" onclick="riskAssessmentMaster.addCRSubQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Add Sub Question</button>
												</div>
											</div>`;
								
							})
							body += `<div class="btn-group dropdown pull-right" role="group" id = "addQuestionDiv2`+formattedCategory+formattedSubCategory+`" style="margin-right:50px;margin-bottom:10px" >
										<button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
											Add Question
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addCRQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','individual','B')") >Inidividual</a></li>
											<!-- <li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addCRQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','interlinked','B')") >Interlinked</a></li> !-->																
										</ul>
									</div>`
							
							body += `</div>`
						})
						
						body += `	</div>`
						body += ` </div>`
						body += `</div>`
					})
					body += `</div>`
									
			body+= `</div>`
			
		return (initial+body+ending);
		}

	};
}());