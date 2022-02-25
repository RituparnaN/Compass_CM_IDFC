<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

<div class="card card-default">
	<div class="card-body">
		<div class="col-sm-12">
			<div class="form-group col-sm-8">
				<label for="sel1">Select Questions</label> 
				 <select class="form-control emailQuestionsSelectBox" id="emailQuestionsSelectBox${UNQID}" name="emailQuestionsSelectBox" MULTIPLE style="width:100%">
				 	<c:forEach items = "${QUESTIONS}" var = "emailQuestions">
				 		<option value = "${emailQuestions.value}" serialNo = "${emailQuestions.key}" id="${emailQuestions.key}">${emailQuestions.value}</option>
				 	</c:forEach>
				</select>
			</div>
			<div class="form-group col-sm-4">
				<label for="sel1">Select Group</label> 
				<select class="form-control"id="emailQuestionGroup${UNQID}">
					<option value="Group 1">Group 1</option>
					<option value="Group 2">Group 2</option>
					<option value="Group 3">Group 3</option>
					<option value="Group 4">Group 4</option>
				</select>
			</div>
			<button class="btn btn-primary pull-right" id="addQuestionInGroup${UNQID}">Add
				Question IN Group</button>
		</div>
		<div class="col-sm-12 table-responsive" style="margin-top: 20px; display:none; height:280px; overflow-y: auto;" id="tableDiv${UNQID}">
			<table class="table table-striped" id="groupAndQuestionsTable${UNQID}" border="1" bordercolor="#a4d4f6">
				<thead>
					<th>Group Name</th>
					<th>Questions</th>
					<th>Delete</th>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
	<div class="card-footer">
		<div class="col-sm-offset-11">
			<button type="button" class="btn btn-primary" id="addQuestionsInMaleBody">Finish</button>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	var id = "${UNQID}";
	var emailGroupAndQuestionsObj = {};
	emailQuestionsStartup();
	function emailQuestionsStartup(){
		
		$("#emailQuestionsSelectBox"+id).select2();
		 
		var previousQuestions = ${PREVIOUSQUESTIONS};
		
		var serialNoAndQuestion = {};
		$.each(previousQuestions, function(i, k){
			if(!(k.group in emailGroupAndQuestionsObj)){
				emailGroupAndQuestionsObj[k.group] = {};
			}
			var serialNoAndQuestion = {};
			serialNoAndQuestion[k.questionNo] = k.question;
			$.extend(true,emailGroupAndQuestionsObj[k.group],serialNoAndQuestion);
		});
		
		let groupAndQuestionTableString = "";
		$("#groupAndQuestionsTable"+id+" tbody").html("");
		$.each(emailGroupAndQuestionsObj,function(group,questions){
			if(nullOrUndefineObjArr(questions)){
				$.each(questions,function(k,v){
					groupAndQuestionTableString += "<tr>";
					groupAndQuestionTableString += "<td>"+group+"</td>";
					groupAndQuestionTableString += "<td>"+v+"</td>";
					groupAndQuestionTableString += "<td><button type='button' class='btn btn-default btn-sm deleteEamilQuestionRow' groupName = '"+group+"' questionNo = '"+k+"'>"+
					                               "<span class='glyphicon glyphicon-trash'></span></button></td>";
					groupAndQuestionTableString += "</tr>";
				})	
			}
		});
		$("#tableDiv"+id).show();
		$("#groupAndQuestionsTable"+id+" tbody").append(groupAndQuestionTableString);
		groupAndQuestionTableString = "";
	}
	
	
	$("#emailQuestionGroup"+id).change(function(){
		$("#emailQuestionsSelectBox"+id).val(null).trigger("change");
		let groupName = $("#emailQuestionGroup"+id).val();
		let selectedQuestionForGroup = [];
		if(nullOrUndefineObjArr(emailGroupAndQuestionsObj[groupName])){
			selectedQuestionForGroup = Object.values(emailGroupAndQuestionsObj[groupName]);
		}
		if(nullOrUndefineObjArr(selectedQuestionForGroup)){
			$("#emailQuestionsSelectBox"+id).val(selectedQuestionForGroup).change();
		}

		
	});
	$("#addQuestionInGroup"+id).click(function(){
		let emailQuestionsSerialNo = [];
		let groupName = $("#emailQuestionGroup"+id).val();
		let emailQuestions = $("#emailQuestionsSelectBox"+id).val();
		var serialNoAndQuestion = {};
		$("#emailQuestionsSelectBox"+id).find(":selected").each(function(){
			serialNoAndQuestion[$(this).attr("serialNo")] = $(this).attr("value");
		});
		if(nullOrUndefineObjArr(emailGroupAndQuestionsObj[groupName])){
			$.extend(emailGroupAndQuestionsObj[groupName],serialNoAndQuestion);
		}
		else{
			emailGroupAndQuestionsObj[groupName] = serialNoAndQuestion;
		}
		let groupAndQuestionTableString = "";
		$("#groupAndQuestionsTable"+id+" tbody").html("");
		$.each(emailGroupAndQuestionsObj,function(group,questions){
			if(nullOrUndefineObjArr(questions)){
				$.each(questions,function(k,v){
					groupAndQuestionTableString += "<tr>";
					groupAndQuestionTableString += "<td>"+group+"</td>";
					groupAndQuestionTableString += "<td>"+v+"</td>";
					groupAndQuestionTableString += "<td><button type='button' class='btn btn-default btn-sm deleteEamilQuestionRow' groupName = '"+group+"' questionNo = '"+k+"'>"+
					                               "<span class='glyphicon glyphicon-trash'></span></button></td>";
					groupAndQuestionTableString += "</tr>";
				})	
			}
		});
		$("#tableDiv"+id).show();
		$("#groupAndQuestionsTable"+id+" tbody").append(groupAndQuestionTableString);
	});
	
	// for deleting row of questions
	$(document).unbind("click").on("click",".deleteEamilQuestionRow",function(e) {
		let groupName = $(this).attr("groupName");
		let questionNumber = $(this).attr("questionNo");
		if(nullOrUndefineObjArr(emailGroupAndQuestionsObj[groupName][questionNumber])){
			delete emailGroupAndQuestionsObj[groupName][questionNumber];
		}else{
		}
		$(this).closest('tr').remove();
	});
	
	function nullOrUndefineObjArr(obj){
	 return obj && obj !== 'null' && obj !== 'undefined';
	}
	
	// for adding in questions in email body
	$("#addQuestionsInMaleBody").click(function(){
		let groupAndQuestionTableString = "<div  style='width:40%' id = 'emailComposeQuestionList'>";
		$.each(emailGroupAndQuestionsObj,function(group,questions){
			if(nullOrUndefineObjArr(questions)){
				groupAndQuestionTableString += "<h4 style='border-bottom:1px solid black;color:red;font-weight: bold' >"+group+"</h4>";
				groupAndQuestionTableString +=  "<ul>";
				$.each(questions,function(k,v){
					groupAndQuestionTableString +=	"<li questionno = '"+k+"' group = '"+group+"'>"+v+"</li>";
				});
				groupAndQuestionTableString += "</ul>";
			}
		});
		groupAndQuestionTableString += "</div>";
		
		if (CKEDITOR.instances['editor1'].document.getById('emailComposeQuestionList') == undefined){
		}else{
			var mainCkeditor = CKEDITOR.instances['editor1'];
			var newTableGenerated = $(mainCkeditor.editable().$).find('#emailComposeQuestionList').html();
			CKEDITOR.instances['editor1'].document.getById('emailComposeQuestionList').remove();
		}
		var composeHTML = CKEDITOR.instances['editor1'].getData();
		composeHTML = composeHTML+groupAndQuestionTableString;
		CKEDITOR.instances['editor1'].setData(composeHTML);
		$("#compassMediumGenericModal").modal("hide");
	});
});
</script>