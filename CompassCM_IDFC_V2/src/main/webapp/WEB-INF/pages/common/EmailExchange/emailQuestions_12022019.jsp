<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<style>
	.dropdown-menu{
		overflow: auto;
		max-height: 200px !important;
		max-width:200px !important;
		padding: 2px !important;
	}
	.emailQuestionsSelectBox{
		padding:0px;
	}
	.bootstrap-select.btn-group.show-tick .dropdown-menu li.selected a span.check-mark{
	    position: absolute;
	    display: inline-block;
	    left: 5px; 
	    margin-top: 5px ;
	}
	 .bootstrap-select.btn-group .dropdown-toggle .filter-option{
		width:600px;
	} 
	/* .dropdown-toggle{
		width:500px;
	} */
</style>


<script type="text/javascript">
$(document).ready(function() {
	var id = "${UNQID}";
	var emailGroupAndQuestionsObj = {};
	//for previous questions
	
	//for arranginf questions from compose mail page
	var previousQuestionsObject = JSON.parse($("#hideenPreviousQuestions").text());
	$.each(previousQuestionsObject,function(i,question){
		let groupName = question['groupName'];
		let groupTitle = question['groupTitle'];
		if(! (groupName in emailGroupAndQuestionsObj)){
			emailGroupAndQuestionsObj[groupName] = {};
			emailGroupAndQuestionsObj[groupName]['groupName'] = groupName;
			emailGroupAndQuestionsObj[groupName]['groupTitle'] = groupTitle;
			emailGroupAndQuestionsObj[groupName]['groupQuestions'] = [];
		}
		emailGroupAndQuestionsObj[groupName]['groupQuestions'].push(question['question']);
	});
	
	wirtingQuestionAndGroupInTable();
	function wirtingQuestionAndGroupInTable(){
		let groupAndQuestionTableString = "";
		$("#groupAndQuestionsTable"+id+" tbody").html("");
		$.each(emailGroupAndQuestionsObj,function(groupName,gropDetails){
			if(nullOrUndefineObjArr(gropDetails['groupQuestions'])){
				$.each(gropDetails['groupQuestions'],function(k,v){
					groupAndQuestionTableString += "<tr>";
					groupAndQuestionTableString += "<td>"+gropDetails['groupTitle']+"</td>";
					groupAndQuestionTableString += "<td>"+v+"</td>";
					groupAndQuestionTableString += "<td><button type='button' class='btn btn-default btn-sm deleteEamilQuestionRow' groupName = '"+gropDetails['groupName']+"' questionNo = '"+k+"'>"+
					                               "<span class='glyphicon glyphicon-trash'></span></button></td>";
					groupAndQuestionTableString += "</tr>";
				})	
			}
		});
		$("#tableDiv"+id).show();
		$("#groupAndQuestionsTable"+id+" tbody").empty().append(groupAndQuestionTableString);
	}
	
	
	//for adding question in table 
	$("#addQuestionInGroup"+id).click(function(){
		let groupTitle = $("#emailQuestionGroup"+id).find("option:selected").attr("grouptitle");
		let groupName = $("#emailQuestionGroup"+id).val();
		let selectedQuestionArray = [];
		$("#emailQuestionsSelectBox"+id).find(":selected").each(function(){
			selectedQuestionArray.push($(this).attr("value"));
		});
		var tempObj = {};
		 tempObj["groupName"] = groupName;
		 tempObj["groupTitle"] = groupTitle;
		 tempObj["groupQuestions"] = selectedQuestionArray;
		 emailGroupAndQuestionsObj[groupName] = tempObj;
		wirtingQuestionAndGroupInTable();
		/*let groupAndQuestionTableString = "";
		 $("#groupAndQuestionsTable"+id+" tbody").html("");
		$.each(emailGroupAndQuestionsObj,function(groupName,gropDetails){
			if(nullOrUndefineObjArr(gropDetails['groupQuestions'])){
				$.each(gropDetails['groupQuestions'],function(k,v){
					groupAndQuestionTableString += "<tr>";
					groupAndQuestionTableString += "<td>"+gropDetails['groupTitle']+"</td>";
					groupAndQuestionTableString += "<td>"+v+"</td>";
					groupAndQuestionTableString += "<td><button type='button' class='btn btn-default btn-sm deleteEamilQuestionRow' groupName = '"+gropDetails['groupName']+"' questionNo = '"+k+"'>"+
					                               "<span class='glyphicon glyphicon-trash'></span></button></td>";
					groupAndQuestionTableString += "</tr>";
				})	
			}
		});
		$("#tableDiv"+id).show();
		$("#groupAndQuestionsTable"+id+" tbody").empty().append(groupAndQuestionTableString); */
	});
	
	// for deleting row of questions
	$("#emailQuestionsMainDiv"+id).unbind("click").on("click",".deleteEamilQuestionRow",function(e) {
		let groupName = $(this).attr("groupName");
		let questionNumber = $(this).attr("questionNo");
		if(nullOrUndefineObjArr(emailGroupAndQuestionsObj[groupName]['groupQuestions'])){
			emailGroupAndQuestionsObj[groupName]['groupQuestions'].splice( questionNumber,1);
		}else{
		}
		$(this).closest('tr').remove();
		if($("#emailQuestionGroup"+id).val() == groupName){
			selectedQuestionsIndropdown(groupName);
		}
		
	});
	
	function nullOrUndefineObjArr(obj){
	 return obj && obj !== 'null' && obj !== 'undefined';
	}
	
	//for adding question into emale body
	$("#addQuestionsInMailBody").click(function(){
		let groupAndQuestionTableString = "<div style='width:100%' id='emailComposeQuestionList'>";
		$.each(emailGroupAndQuestionsObj,function(group,groupDetails){
			if(groupDetails['groupQuestions'].length > 0){
				groupAndQuestionTableString += "<h4 style='text-decoration:underline; font-weight:bold'>"+groupDetails['groupTitle']+":</h4>";
				groupAndQuestionTableString +=  "<ul>";
				$.each(groupDetails['groupQuestions'],function(k,v){
					groupAndQuestionTableString +=	"<li questionno = '"+k+"' groupName = '"+groupDetails['groupName']+"' groupTitle = '"+groupDetails['groupTitle']+"'>"+v+"</li>";
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
		$("#compassSearchModuleModal").modal("hide");
	});
	
	//for constructing dataformat for group and quesions.
	var questionsArr =	[];
	<c:forEach items = "${QUESTIONS}" var = "emailQuestions">
		<c:forEach items = "${emailQuestions}" var="emailQuestion">
			var questionsObj = {};
	 		<c:forEach items = "${emailQuestion.value}" var="questionNames">
	 			questionsObj['${emailQuestion.key}'] = '${questionNames}';
	 		</c:forEach>
	 		questionsArr.push(questionsObj);
		</c:forEach>
	</c:forEach>
	
	
	//for changing questions according group
	$("#emailQuestionGroup"+id).on("change", function(){
		createQuestionsDropdown($(this).val());
		selectedQuestionsIndropdown($(this).val());
	});
	
	createQuestionsDropdown($("#emailQuestionGroup"+id).val());
	function createQuestionsDropdown(selectedGroup){
		var questionsString = "";
		$.each(questionsArr,function(i,v){
			 $.each(v,function(key,value){
				if(key === selectedGroup){
					questionsString += "<option value ='"+value+"' >"+value+"</option>"
				}
			}) 
		});
		$("#emailQuestionsSelectBox"+id).empty().append(questionsString).selectpicker('refresh');
	}
	
	selectedQuestionsIndropdown($("#emailQuestionGroup"+id).val());
	function selectedQuestionsIndropdown(selectedGroupName){
		if(selectedGroupName in emailGroupAndQuestionsObj){
			$("#emailQuestionsSelectBox"+id).selectpicker('val', emailGroupAndQuestionsObj[selectedGroupName]['groupQuestions']);
		}
		
		//
	};
	
});
</script>

<div class="card card-default " id="emailQuestionsMainDiv${UNQID}">
	<div class="card-body" style="padding:10px 0 0 0;" >
		<div style="padding: 10px 10px 10px 10px">
			<table class="table table-striped" id="fields${UNQID}"  frame="box" bordercolor="#a4d4f6">
				<tr>
					<td width="15%">
						Select Group
					</td>
					<td width = "10%"></td>
					<td width = "75%">
						Select Question
					</td>
				</tr>
				<tr>
					<td width="15%">
						<select class="form-control" id="emailQuestionGroup${UNQID}">
							<c:forEach items = "${GROUPS}" var = "emailGroups">
								<option value="${emailGroups.key}" grouptitle ="${emailGroups.value}" >${emailGroups.key}</option>
							</c:forEach>
						</select>
					</td>
					<td width = "10%"></td>
					<td width = "75%">
						<select class="col-sm-12 emailQuestionsSelectBox selectpicker" id="emailQuestionsSelectBox${UNQID}"
						  name="emailQuestionsSelectBox" data-live-search="true" data-width="100%" data-selected-text-format="count" MULTIPLE  >
								</select>
					</td>
				</tr>
				<tr>
					<td width="15%"></td>
					<td width = "10%"></td>
					<td width = "75%" >
						<button class="btn btn-sm btn-primary pull-${dirR}" id="addQuestionInGroup${UNQID}" >
							Add Question in Group
						</button>
					</td>
				</tr>
				
				<%-- <tr>
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
						<div class=" col-sm-10" style="max-height: 160px;border:2px solid black;" id="questionDiv${UNQID}" >
							<label for="sel1">Select Questions</label>
							 <select class="col-sm-12 emailQuestionsSelectBox" id="emailQuestionsSelectBox${UNQID}"  name="emailQuestionsSelectBox" MULTIPLE >
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
				</tr> --%>
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
	<div class="card-footer" style="min-height: 50px;">
		<div class="pull-${dirR}">
			<button type="button" class="btn btn-sm btn-success" id="addQuestionsInMailBody" >Save</button>
		</div>
	</div>
</div>

<div id = "hideenPreviousQuestions" style="display:none;">
${PREVIOUSQUESTIONS}
</div>
