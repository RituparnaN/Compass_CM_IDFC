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
								console.log(question['QUESTIONID']+":"+qId)
								if(question['QUESTIONID'] == qId){
									question[elm.name] = names.join(',');
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId))
			$(".selectpicker").selectpicker();
			
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
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId))
			$(".selectpicker").selectpicker();
		},
		handleOptionsInputChange: function (elm,unqId,toEditCategory,toEditSubCategory,qId){
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
									var optionsList = question['INPUTOPTIONSLIST'].split("||")
									
									optionsList.forEach((option,i)=>{
										if(elm.name.split("||")[0] == i){
											var optionLabel = option.split("^")[0]
											var optionValue = option.split("^")[1]
											if(elm.name.split("||")[1] == '0'){
												optionLabel = elm.value
											}
											if(elm.name.split("||")[1] == '1'){
												optionValue = elm.value
											}
											newOptionList.push(optionLabel+"^"+optionValue)
										}
										else{
											newOptionList.push(option)
										}
									})
									question['INPUTOPTIONSLIST'] = newOptionList.join("||");
								}
								questionsList.push(Object.assign({},question));
							})
							
							questionsFormDetails[category][subCategory] = questionsList;
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId))
			$(".selectpicker").selectpicker();
		},
		addQuestion: function(elm,unqId,toAddCategory,toAddSubCategory,qsType){
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
							if(questionsFormDetails[category][subCategory].length > 0)
								var questionOrder = parseInt(questionsFormDetails[category][subCategory][questionsFormDetails[category][subCategory].length - 1]['QUESTIONID'].replace(categoryPrefixes[categoryIndex],'').replace(subCategoryPrefixes[subCategoryIndex],''))+1
							var newQuestionObject = {
														"QUESTIONID":categoryPrefixes[categoryIndex]+subCategoryPrefixes[subCategoryIndex]+questionOrder,
														"ISSUPERPARENT":"N",
														"QUESTION":"",
														"INPUTTYPE":"numeric",
														"INPUTOPTIONSLIST":"null^null||null^null||null^null",
														"HASRISKIMPACT":"N",
														"HASPARENT":"N",
														"PARENTQSIDS":"",
														"DISABLED":"N"}
							questionsFormDetails[category][subCategory].push(newQuestionObject);
							
						}
					})
				}
			})
			$("#quesionDetailsFormJson").html(JSON.stringify(questionsFormDetails))
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId))
			$(".selectpicker").selectpicker();
			
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
			$("#riskAssessmentQuestionsForm"+unqId).html(riskAssessmentMaster.generateQuestionsForm(unqId))
			$(".selectpicker").selectpicker();
		},
		createParentQsOptionList: function(parentsList,qId,unqId,category,subCategory){
			var qIds = [];
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			Object.keys(categories).forEach(category=>{
				categories[category].forEach(subCategory=>{
					questionsFormDetails[category][subCategory].forEach(question=>{
						
						qIds.push(question['QUESTIONID'])
					})
				})
			})
			
			var parentQsIds = parentsList.split(",");
			var selectBody = `<tr>
									<td width="15%">Parent Questions List</td>
									<td width="30%">
										<select class="form-control input-sm selectpicker" name = 'PARENTQSIDS' id="PARENTQSIDS`+qId+`" multiple="multiple" onchange = "riskAssessmentMaster.handleMultipleSelectInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')")>`
			qIds.forEach(qId=>{
				
				if(parentQsIds.includes(qId)){
					selectBody += `<option value = '`+qId+`' selected>`+qId+`</option>`
				}else{
					selectBody += `<option value = '`+qId+`'>`+qId+`</option>`
					
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
		createInputOptionList: function (optionValues,qId,unqId,category,subCategory){
			if(optionValues == undefined || optionValues.length == 0){
				var optionBody =  `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">`;
				optionBody += `<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>
									<tr>
										<td width=15%>Option label</td>
										<td width="30%">
											<input class="form-control input-sm" name = '0||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel1'/>
										</td>
										<td width="10%"></td>
										<td width="15%">option Value</td>
										<td width="30%">
											<input class="form-control input-sm" name = '0||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOption1' />
										</td>
									</tr>
									<tr>
										<td width=15%>Option label</td>
										<td width="30%">
											<input class="form-control input-sm" name='1||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel2'/>
										</td>
										<td width="10%"></td>
										<td width="15%">option Value</td>
										<td width="30%">
											<input class="form-control input-sm" name='1||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue2'/>
										</td>
									</tr>
									<tr>
										<td width=15%>Option label</td>
										<td width="30%">
											<input class="form-control input-sm" name='2||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel3'/>
										</td>
										<td width="10%"></td>
										<td width="15%">option Value</td>
										<td width="30%">
											<input class="form-control input-sm" name='2||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue3'/>
										</td>
									</tr>
								
								</table>`;
				optionBody += `</div>`;
				return optionBody;
			}
			var optionBody = `<div class = 'card card-primary' style = "margin:.5%;padding-top:1px;">
								<table class="table table-striped" id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionsTable'>`;
								
			optionValues.split("||").forEach((option,i)=>{
				var optionLabel = option.split("^")[0] != "null"?option.split("^")[0]:'';
				var optionValue = option.split("^")[1] != "null"?option.split("^")[1]:'';
				optionBody +=  `<tr>
									<td width=15%>Option label</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||0' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionLabel`+i+`' value = '`+optionLabel+`'/>
									</td>
									<td width="10%"></td>
									<td width="15%">option Value</td>
									<td width="30%">
										<input class="form-control input-sm" name = '`+i+`||1' onchange = "riskAssessmentMaster.handleOptionsInputChange(this,'`+unqId+`','`+category+`','`+subCategory+`','`+qId+`')") id = '`+category+`||`+subCategory+`||`+qId+`||`+`inputOptionValue`+i+`' value = '`+optionValue+`'/>
									</td>
								</tr>`;
			
			})
			
			optionBody += 		`</table>
							</div>`;
			return optionBody;
			
		},
		generateQuestionsForm: function (unqId) {
			var assessmentUnit = $("#assessmentUnit").html()
			var categories = JSON.parse($("#categoriesSubCategories").html())
			var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html())
			/*console.log(categories);
			console.log(questionsFormDetails);*/
			var initial = `<div class="row compassmodalrow`+unqId+`">`;
			var body = ``;
			var ending = `</div>`;
			Object.keys(categories).forEach((category,cIndex)=>{
				var formattedCategory = category.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');
				body += `<div class="col-sm-12">
							<div class="card card-primary panel_reportBenchMarkDtls">
								<div class="card-header  clearfix" onclick="handleSlidingPanels(this,'`+unqId+`','`+formattedCategory+`')">
									
									<h6 class="card-title pull-left">`+category+`</h6>
									<div class="btn-group pull-right clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
								</div>
								<div class="`+formattedCategory+`">
									<div class="panel-search-panel" style="padding-top:2%" >`;
									
				categories[category].forEach((subCategory,sIndex)=>{
					var formattedSubCategory = subCategory.replaceAll(" ",'').replaceAll("/",'').replaceAll("(",'').replaceAll(")",'');
					body += `<div class="col-sm-12">
								<div class="card card-primary panel_reportBenchMarkDtls">
									<div class="card-header  clearfix" onclick="handleSlidingPanels(this,'`+unqId+`','`+formattedSubCategory+`')" style = "background-color:#efda6d">
										<h6 class="card-title pull-left">`+subCategory+`</h6>
										<div class="btn-group pull-right clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
									</div>
									<div class="`+formattedSubCategory+`">
										<div class="panel-search-panel" >`
											
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
															<td width="75%">
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
																	<select class="form-control input-sm" name = 'HASPARENT' onchange = "riskAssessmentMaster.handleInputChange(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')")>
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
									
									body +=			`</table>
												</div>
												<button type="button" id="removeQuestion`+question['QUESTIONID']+`" class="pull-right btn btn-danger btn-sm" onclick="riskAssessmentMaster.removeQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','`+question['QUESTIONID']+`')") style = "margin-right:20px;margin-bottom:5px;">Remove</button>
										</div>
									</div>`;
						
					})
					body +=				`</div>`
									
						body += `<div class="btn-group dropdown pull-right" role="group" style="margin-right:50px;margin-bottom:10px" >
									<button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
										Add Question
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu">
										<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','individual')") >Inidividual</a></li>
										<li><a class="nav-link" href="javascript:void(0)"  onclick="riskAssessmentMaster.addQuestion(this,'`+unqId+`','`+formattedCategory+`','`+formattedSubCategory+`','interlinked')") >Interlinked</a></li>																	
									</ul>
								</div>
									</div>
								</div>
								
							</div>`;
				})
						
						body+=`</div>
						
						</div>
					</div>
					
				</div>`;
				
			})
			
		return (initial+body+ending);
		}

	};
}());