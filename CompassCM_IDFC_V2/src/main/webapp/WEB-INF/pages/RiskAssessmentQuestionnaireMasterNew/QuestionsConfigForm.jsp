<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script>
var acc = document.getElementsByClassName("accordion");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.maxHeight) {
      panel.style.maxHeight = null;
    } else {
      panel.style.maxHeight = panel.scrollHeight + "px";
    } 
  });
}
</script>
<style>
	.accordion {
	  background-color: #337ab7;
	  border-color: #337ab7;
	  color: #fff;
	  cursor: pointer;
	  padding-left: 18px;
	  width: 100%;
	  border: none;
	  text-align: left;
	  outline: none;
	  font-size: 15px;
	  transition: 0.4s;/* 
	  border-radius:5px 5px 0px 0px; */
	  
	}
	.panel {
	  padding: 0 18px;
	  background-color: white;
	  border-radius:0px 0px 5px 5px;
	  border:1px solid #337ab7;
	  max-height: 0;
	  overflow: hidden;
	  transition: max-height 0.2s ease-out;
	  
	}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var assessmentUnit = '${ASSESSMENTUNIT}'

		var today = new Date();
		var dd = String(today.getDate()).padStart(2, '0');
		var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = today.getFullYear();

		today = mm + '/' + dd + '/' + yyyy;
		
		$("#todayDate").html(today)
		
		compassTopFrame.init(id, 'reportBenchMarkDtlsTable1'+id, 'dd/mm/yy');

		// creating js array from jstl object for categories and sub categories
		var categories = {};
		<c:forEach var= "category" items = "${QUESTIONSFORMDETAILS.categoryList}">
			var subCategories = [];
			<c:forEach var= "subCategory" items = "${QUESTIONSFORMDETAILS.categoresAndSubCategories[category]}">
				subCategories.push('${subCategory}');
			</c:forEach>
			categories['${category}'] = subCategories
		</c:forEach>
			
		$("#categoriesSubCategories").html(JSON.stringify(categories))
		
		var crCategories = {};
		<c:forEach var= "category" items = "${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg.subCategories}">
			var crSubCategories = [];
			<c:forEach var= "subCategory" items = "${QUESTIONSFORMDETAILS.controlsReviewCategSubCateg.subAndSubSubCateg[category]}">
				
				crSubCategories.push('${subCategory}');
			</c:forEach>
			crCategories['${category}'] = crSubCategories
		</c:forEach>
			
		$("#controlsReviewsCategSubCateg").html(JSON.stringify(crCategories))
		//$("#controlsReviewsQuestionsDetails").html($("#controlsReviewsQuestionsDetails").html().replaceAll('"[','[').replaceAll(']"',']'))
		
		
		
		
		var questionsFormDetails = JSON.parse('${QUESTIONSFORMDETAILS.categoryWiseQuesitonsJson}')
		$("#riskAssessmentQuestionsForm"+id).html(riskAssessmentMaster.generateQuestionsForm(id))
		
		
	});
	
	/* function handleSlidingPanels(elm, id, target){
		var mainRow = $(elm).parents(".compassmodalrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find("."+target);
		if($(slidingDiv).hasClass("card-collapsed")){
			$(panelBody).slideDown();
			$(slidingDiv).removeClass('card-collapsed');
			$(slidingDiv).find("i.collapsable").removeClass("fa-chevron-down").addClass("fa-chevron-up");
			$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideUp();
		}else{
			$(panelBody).slideUp();
			$(slidingDiv).addClass('card-collapsed');
			$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
			$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
		}
	} */
	function handleSlidingPanels(elm, id, target){
		var mainRow = $(elm).parents(".compassmodalrow"+id);
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
	function saveFormConfiguration(){
		var ctx = window.location.href;
		ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
		var url = ctx + '/common/saveRiskAssesesmentFormConfiguration';
		var id = '${UNQID}'
		var allQuestionConfigurationList = [];
		var categories = JSON.parse($("#categoriesSubCategories").html());
		var questionsFormDetails = JSON.parse($("#quesionDetailsFormJson").html());
		var assessmentUnit = $("#assessmentUnit").html();
		Object.keys(categories).forEach(category=>{
			categories[category].forEach(subCategory=>{
				questionsFormDetails[category][subCategory].forEach(question=>{
					var newQuestion = Object.assign({},question)
					newQuestion['category'] = category;
					newQuestion['subCategory'] = subCategory;
					newQuestion['assessmentUnit'] = '${ASSESSMENTUNIT}';
					allQuestionConfigurationList.push(newQuestion);
					try{
						question['SUBQUESTIONLIST'].forEach(question=>{
							console.log(question)
							var newSubQuestion = Object.assign({},question)
							newSubQuestion['category'] = category;
							newSubQuestion['subCategory'] = subCategory;
							newSubQuestion['assessmentUnit'] = '${ASSESSMENTUNIT}';
							allQuestionConfigurationList.push(newSubQuestion);
							})
						}catch(e){console.log(e)}
					
				})
			})
		})
		var allCRQuestionConfigurationList = [];
		categories = JSON.parse($("#controlsReviewsCategSubCateg").html());
		questionsFormDetails = JSON.parse($("#controlsReviewsQuestionsDetails").html());
		Object.keys(categories).forEach(category=>{
			categories[category].forEach(subCategory=>{
				questionsFormDetails[category][subCategory].forEach(question=>{
					var newQuestion = Object.assign({},question)
					newQuestion['category'] = category;
					newQuestion['subCategory'] = subCategory;
					newQuestion['assessmentUnit'] = '${ASSESSMENTUNIT}';
					allCRQuestionConfigurationList.push(newQuestion);
					try{
						question['SUBQUESTIONLIST'].forEach(question=>{
							console.log(question)
							var newSubQuestion = Object.assign({},question)
							newSubQuestion['category'] = category;
							newSubQuestion['subCategory'] = subCategory;
							newSubQuestion['assessmentUnit'] = '${ASSESSMENTUNIT}';
							allCRQuestionConfigurationList.push(newSubQuestion);
							})
						}catch(e){console.log(e)}
					
				})
			})
		})
		//console.log(allQuestionConfigurationList)
		 var data = {
					"questionsList":allQuestionConfigurationList,
					"crQuestionsList":allCRQuestionConfigurationList
				   };
		console.log(data)
		$.ajax({
			url: url,
			cache: false,
			type: 'POST',
			data: JSON.stringify(data),
			contentType: "application/json",
			success: function (response) {
				alert("Form Successfully Configured.")
			},
			error: function (a, b, c) {
				alert("form Configuration Failed. with error: "+a+b+c+". see console for more info.")
				console.log(a+b+c);
			}
		}) 
		
	}
	
	function switchCRTabs(tabIndex){
		var rootEle = document.getElementById("crCategoryTabContent")
		var elements = rootEle.getElementsByClassName('tab-pane')
		var ids = [];
		for(var i = 0; i < elements.length; i++){
				ids.push(elements[i].id)
				/* alert(elements[i].id) */
			}
		
		ids.forEach((id,i)=>{
			if(id == tabIndex && !id.endsWith("subCategCR")){
				var element = document.getElementById(id);
				 element.classList.add("active");
			}
			else{
				if(!id.endsWith("subCategCR")){
					var element = document.getElementById(id);
					 element.classList.remove("active");
				}
			}
			
		})
		rootEle = document.getElementById("crCategoryTabContent")
		elements = rootEle.getElementsByClassName('nav-link')
		ids = [];
		
		for(var i = 0; i < elements.length; i++){
				ids.push(elements[i].id)
			}
		ids.forEach((id,i)=>{
			try{
				var element = document.getElementById(id);
				 element.classList.remove("active");
				}
			catch(e){}
			
			
		})
		
	}
	function switchCRSubTabs(tabIndex){
		var rootEle = document.getElementById("crCategoryTabContent")
		var elements = rootEle.getElementsByClassName('tab-pane')
		var ids = [];
		for(var i = 0; i < elements.length; i++){
				ids.push(elements[i].id)
				/* alert(elements[i].id) */
			}
		ids.forEach((id,i)=>{
			if(id == tabIndex){
				var element = document.getElementById(id);
				 element.classList.add("active");
			}
			else{
				if(id != tabIndex && id.endsWith("subSubCategCR")){
					var element = document.getElementById(id);
					 element.classList.remove("active");
				}
			}
			
		})
		
	}
	function switchTabs(tabIndex){
		
		var rootEle = document.getElementById("RiskAssessmentQuestionFormPanel"+"${UNQID}")
		var elements = rootEle.getElementsByClassName('tab-pane')
		var ids = [];
		for(var i = 0; i < elements.length; i++){
				ids.push(elements[i].id)
				/* alert(elements[i].id) */
			}
		
		ids.forEach((id,i)=>{
			if(id == tabIndex && !id.endsWith("subCateg")){
				var element = document.getElementById(id);
				 element.classList.add("active");
			}
			else{
				if(!id.endsWith("subCateg")){
					var element = document.getElementById(id);
					 element.classList.remove("active");
				}
			}
			
		})
		
	}
	function switchSubTabs(tabIndex){
		var rootEle = document.getElementById("categoryTabContent")
		var elementss = rootEle.getElementsByClassName('nav-link')
		var idss = [];
		for(var i = 0; i < elementss.length; i++){
				idss.push(elementss[i].id)
			}
		idss.forEach(id=>{
				try{
					var element = document.getElementById(id);
					 element.classList.remove("active");
					}
				catch(e){}
		})
		
		
		var elements = rootEle.getElementsByClassName('tab-pane')
		var ids = [];
		for(var i = 0; i < elements.length; i++){
				ids.push(elements[i].id)
			}
		ids.forEach(id=>{
			if(id == tabIndex && id.endsWith("subCateg")){
				var element = document.getElementById(id);
				 element.classList.add("active");
			}
			else{
				if(id.endsWith("subCateg")){
					var element = document.getElementById(id);
					 element.classList.remove("active");
				}
			}
		})
		
	}
</script> 

<div>
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
	<div id = "categoriesSubCategories">
			
	</div>
	<div id = "assessmentUnit">
		${ASSESSMENTUNIT}
	</div>
	<div id = "unqId">
		${UNQID}
	</div>
	<div id = "userCode">
		${USERCODE }
	</div>
	<div id = "todayDate">
		
	</div>
	<div id = "individualQsId">
		${QUESTIONID }
	</div>
</div>
</div>
<div class="card card-primary" id="RiskAssessmentQuestionFormPanel${UNQID}" style = "width:100%">
	<div class="card-header RiskAssessmentQuestionFormPanel${UNQID} clearfix">
		<h6 class="card-title pull-${dirL}">${ASSESSMENTUNIT} Risk Assessment Form</h6>
		
	</div>
	<div>
		<button type="button" id="showReport${UNQID}" onclick=saveFormConfiguration() class="btn btn-success btn-sm pull-right" style = "margin-right:10px;margin-bottom:5px;margin-top:5px">Save Configuration</button>
	</div>
	<div id="riskAssessmentQuestionsForm${UNQID}" style = "padding:1%"></div>
</div>
<%-- <div id = "riskAssessmentQuestionsForm${UNQID}">
</div> --%>







