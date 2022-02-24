<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

<!-- : 18012019 -->
<c:set var="newWindow" value="${NEWWINDOW}"/>
<c:if test="${newWindow == 'Yes'}">
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Email Questions</title>
	<jsp:include page="../../tags/staticFiles.jsp"/>
</c:if>

<style>
	/*  19012019 */
	.select2{
		overflow-y: auto;
		max-height: 50px;
		padding: 2px;
	}
	.select2-container--default.select2-container--focus .select2-selection--multiple {
        border-color: #66afe9;
    }
</style>
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
	
	/*  19012019 */
	$("#addQuestionInGroup"+id).click(function(){
		let emailQuestionsSerialNo = [];
		let groupName = $("#emailQuestionGroup"+id).find("option:selected").attr("id");
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
	$("#addQuestionsInMailBody").click(function(){
		let groupAndQuestionTableString = "<div style='width:100%' id='emailComposeQuestionList'>";
		$.each(emailGroupAndQuestionsObj,function(group,questions){
			if(nullOrUndefineObjArr(questions)){
				groupAndQuestionTableString += "<h4 style='text-decoration:underline; font-weight:bold'>"+group+":</h4>";
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
			CKEDITOR.instances['editor1'].document.getById('emailComposeQuestionList').setHtml(groupAndQuestionTableString);
		}
		/* var composeHTML = CKEDITOR.instances['editor1'].getData();
		composeHTML = composeHTML+groupAndQuestionTableString;
		CKEDITOR.instances['editor1'].setData(composeHTML); */
		$("#compassSearchModuleModal").modal("hide");
	});
	
	// 18012019 - getting all the questions
	var questionsArr =	[];
	<c:forEach items = "${QUESTIONS}" var = "emailQuestions">
		<c:forEach items = "${emailQuestions}" var="emailQuestion">
	 		<c:set var="groupCode" value="${emailQuestion.key}"></c:set>
	 		<c:set var="questionNameList" value="${emailQuestion.value}"></c:set>
			var questionsObj = {};
	 		<c:forEach items = "${questionNameList}" var="questionNames">
	 			questionsObj['${groupCode}'] = '${questionNames}';
	 		</c:forEach>
	 		questionsArr.push(questionsObj);
		</c:forEach>
	</c:forEach>
	//console.log(questionsArr);
	
	// 18012019 - dynamic question selection
	$("#emailQuestionGroup"+id).on("change", function(){
		createQuestionsDropdown($(this).val());
	});
	
	createQuestionsDropdown($("#emailQuestionGroup"+id).val());
	function createQuestionsDropdown(selectedGroup){
		var questionsString = "";
		$.each(questionsArr,function(i,v){
			$.each(v,function(key,value){
				if(key.includes(selectedGroup)){
					questionsString += "<option value ='"+value+"' serialNo ='"+value+"'>"+value+"</option>"
				}
			})
		});
		//console.log(subReasonsOptionsString);
		$("#emailQuestionsSelectBox"+id).empty().append(questionsString);
	}
	
	$("#openModalInWindow").click(function(){
		var caseNo = '${CASENO}';
		var url = "${pageContext.request.contextPath}/common/getEmailQuestions?moduleType=EmailQuestions&caseNo="+caseNo+"&newWindow=Yes";
		window.open(url,'EmailQuestions','width=1000, height=600');
		
	});
	
});
</script>

<div class="card card-default ">
	<div class="card-body" style="padding:10px 0 0 0;">
		<div class="col-sm-12" >
			<table class="table table-striped" id="fields${UNQID}" border="1" bordercolor="#a4d4f6" >
				<tr>
					<td>
						<div class="form-group col-sm-2" style="padding:0px;">
							<label for="sel1">Select Group</label>
							<!--  16012019 -->
							<select class="form-control" id="emailQuestionGroup${UNQID}">
								<c:forEach items = "${GROUPS}" var = "emailGroups">
									<option value="${emailGroups.key}" id="${emailGroups.value}">${emailGroups.key}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group col-sm-10" style="max-height: 50px;">
							<label for="sel1">Select Questions</label>
							 <select class="form-control emailQuestionsSelectBox" id="emailQuestionsSelectBox${UNQID}"  name="emailQuestionsSelectBox" MULTIPLE >
								</select>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<button class="btn btn-primary pull-right" id="addQuestionInGroup${UNQID}" style="font-size: 12px; margin-right: 15px;">
							Add Question in Group
						</button>
					</td>
				</tr>
			</table>
		</div>
		<div class="col-sm-12 table-responsive" style="margin-top: 20px; display:none; max-height:210px; min-height:210px;  overflow: auto;" id="tableDiv${UNQID}">
			<table class="table table-striped" id="groupAndQuestionsTable${UNQID}" border="1" bordercolor="#a4d4f6">
				<thead>
					<th>Group Name</th>
					<th>Questions</th>
					<th>Delete</th>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
	<div class="card-footer">
		<div class="col-sm-offset-11">
			<button type="button" class="btn btn-primary" id="addQuestionsInMailBody" style="font-size: 12px;">Save</button>
		</div>
	</div>
</div>
